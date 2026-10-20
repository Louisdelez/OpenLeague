//! Bounded, optional presentation of received Ezreal Q CastLock on base spell1.
//! releases-8 is a LOCAL reconstruction, not a recovered native animation clock.
//! No gameplay, snapshot, direction, attack journal, effect or audio is changed.
use openleague_core::{Snapshot, TICK_RATE};
use std::collections::{BTreeMap, BTreeSet};

const MAX_OWNERS: usize = 64;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Identity { pub session:u64, pub epoch:u64, pub owner:u32, pub releases:u64 }

#[derive(Debug, Clone, Copy, PartialEq)]
struct Record {
    releases:u64, direction:[u32;2], age:f64, received_at:f64,
    claimed_by:Option<u64>, retired:bool,
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Selection { pub identity:Identity, pub age_seconds:f32, pub first:bool }

#[derive(Debug, Default, Clone, PartialEq)]
pub struct State {
    session:Option<u64>, epoch:u64, tick:Option<u64>, clock:Option<f64>,
    visible:BTreeSet<u32>, records:BTreeMap<u32,Record>, ready:bool, finished:bool,
}

impl State {
    pub fn reset(&mut self,session:u64) {
        if self.session!=Some(session) { *self=Self{session:Some(session),..Self::default()}; }
        else { self.suspend();self.epoch=0;self.tick=None;self.clock=None;self.visible.clear(); }
    }
    /// The existing common receive path has already authenticated this epoch.
    /// Keep consumed-release barriers for the same session, never rearm a pose.
    pub fn begin_epoch(&mut self,session:u64,epoch:u64) {
        if epoch==0 || (self.session==Some(session) && epoch<=self.epoch) {return;}
        if self.session!=Some(session) {self.reset(session);}
        self.suspend();self.epoch=epoch;self.tick=None;self.clock=None;self.visible.clear();
    }
    pub fn retire(&mut self,owner:u32) {
        if let Some(record)=self.records.get_mut(&owner) {record.retired=true;}
    }
    pub fn suspend(&mut self) {
        for record in self.records.values_mut() {record.retired=true;}
        self.ready=false;
    }
    /// Observe EVERY already accepted packet before the receive loop coalesces.
    /// Optional malformed/conflicting locks leave the previous State unchanged.
    /// A clock failure instead suspends this Q channel, never freezing its pose.
    pub fn observe_accepted(&mut self,snapshot:&Snapshot,now:f64,clock_ready:bool,clock_paused:bool)->Result<bool,String> {
        if self.session!=Some(snapshot.session) || self.tick.is_some_and(|tick|snapshot.tick<tick) {return Ok(false);}
        if !now.is_finite() || self.clock.is_some_and(|old|now<old) {
            self.suspend();return Err("Ezreal Q presentation clock invalid".into());
        }
        let mut next=self.clone();
        next.observe_inner(snapshot,now,clock_ready,clock_paused)?;
        *self=next;Ok(true)
    }
    fn observe_inner(&mut self,snapshot:&Snapshot,now:f64,clock_ready:bool,clock_paused:bool)->Result<(),String> {
        if snapshot.roster.len()>MAX_OWNERS || snapshot.players.len()>MAX_OWNERS {
            return Err("Ezreal Q presentation owner budget exceeded".into());
        }
        let mut roster=BTreeMap::new();
        for entry in &snapshot.roster {
            if entry.id==0 || entry.team>1 || roster.insert(entry.id,(entry.team,entry.champion.as_str())).is_some() {
                return Err("Ezreal Q presentation roster invalid".into());
            }
        }
        let mut visible=BTreeMap::new();
        for actor in snapshot.players.iter().filter(|actor|actor.champion=="ezreal") {
            if !roster.get(&actor.id).is_some_and(|(team,name)|*name=="ezreal" && *team==actor.team)
                || visible.insert(actor.id,actor).is_some() {
                return Err("Ezreal Q presentation visible owner invalid".into());
            }
        }
        // Validate the complete packet before committing any record or watermark.
        for (&owner,actor) in &visible {
            if let Some(lock)=actor.effects.ezreal_q.as_ref() {
                let starts=lock.releases.checked_sub(openleague_core::ezreal_q::WINDUP_TICKS)
                    .ok_or("Ezreal Q release precedes local windup")?;
                let length=f64::from(lock.direction.x).hypot(f64::from(lock.direction.z));
                if starts>snapshot.tick || !lock.direction.finite() || !(0.999..=1.001).contains(&length) {
                    return Err("Ezreal Q received lock geometry/time invalid".into());
                }
                let direction=[lock.direction.x.to_bits(),lock.direction.z.to_bits()];
                if let Some(old)=self.records.get(&owner) {
                    if lock.releases<old.releases || (lock.releases==old.releases && direction!=old.direction) {
                        return Err("Ezreal Q received lock identity changed".into());
                    }
                }
            }
        }
        let baseline=self.tick.is_none() || !self.ready;
        let previous_tick=self.tick;
        let previous_visible=self.visible.clone();
        self.finished|=snapshot.winner.is_some() || snapshot.result.is_some();
        // Roster departure frees bounded storage. FoW absence keeps its consumed
        // release while that owner is still rostered, so a return cannot replay.
        self.records.retain(|owner,_|roster.get(owner).is_some_and(|(_,name)|*name=="ezreal"));
        for (&owner,actor) in &visible {
            if let Some(lock)=actor.effects.ezreal_q.as_ref() {
                let starts=lock.releases-openleague_core::ezreal_q::WINDUP_TICKS;
                let new=self.records.get(&owner).map_or(true,|old|lock.releases>old.releases);
                if new {
                    self.records.insert(owner,Record{releases:lock.releases,
                        direction:[lock.direction.x.to_bits(),lock.direction.z.to_bits()],
                        age:snapshot.tick.saturating_sub(starts) as f64/TICK_RATE as f64,
                        received_at:now,claimed_by:None,
                        retired:baseline || !previous_visible.contains(&owner) || !clock_ready || clock_paused || self.finished
                            || previous_tick.is_some_and(|tick|starts<tick)});
                }
            }
        }
        for (&owner,record) in &mut self.records {
            let Some(actor)=visible.get(&owner) else {record.retired=true;continue;};
            let Some(lock)=actor.effects.ezreal_q.as_ref().filter(|lock|lock.releases==record.releases) else {record.retired=true;continue;};
            let starts=record.releases-openleague_core::ezreal_q::WINDUP_TICKS;
            // A paused EffectClock freezes the current sampled pose even if
            // accepted snapshot ticks advance. Authoritative interruptions and
            // release/absence below still retire it. Reconcile tick age on resume.
            let elapsed=record.age+(now-record.received_at);
            let age=if clock_paused {record.age} else {
                elapsed.max(snapshot.tick.saturating_sub(starts) as f64/TICK_RATE as f64)
            };
            if !age.is_finite() || age<0. {return Err("Ezreal Q presentation age invalid".into());}
            record.age=age;record.received_at=now;
            if self.finished || !clock_ready || snapshot.tick>=lock.releases
                || age>=openleague_core::ezreal_q::WINDUP_TICKS as f64/TICK_RATE as f64
                || !actor.health.is_finite() || actor.health<=0. || !actor.position.finite()
                || openleague_core::trundle_e::champion_forced(actor,snapshot.tick)
                || openleague_core::stuns::active(actor,snapshot.tick) || actor.windup.is_some() {
                record.retired=true;
            }
        }
        self.visible=visible.keys().copied().collect();self.tick=Some(snapshot.tick);self.clock=Some(now);self.ready=clock_ready;
        Ok(())
    }
    /// Missing/unusable clips, ineligible poses, a replacement entity or expired
    /// observations consume this lock. There is no deferred animation backlog.
    pub fn select(&mut self,owner:u32,entity:u64,now:f64,duration:Option<f32>,eligible:bool,clock_ready:bool)->Option<Selection> {
        if !clock_ready || !self.ready || !now.is_finite() || self.clock.is_some_and(|old|now<old) {
            self.suspend();return None;
        }
        self.clock=Some(now);
        let record=self.records.get_mut(&owner)?;
        if record.retired {return None;}
        let age=record.age+(now-record.received_at);
        let duration=duration.filter(|duration|duration.is_finite() && *duration>0.);
        if !eligible || duration.is_none() || !age.is_finite() || age<0.
            || age>=openleague_core::ezreal_q::WINDUP_TICKS as f64/TICK_RATE as f64
            || duration.is_some_and(|duration|age>=f64::from(duration))
            || record.claimed_by.is_some_and(|old|old!=entity) {
            record.retired=true;return None;
        }
        let first=record.claimed_by.is_none();record.claimed_by=Some(entity);
        record.age=age;record.received_at=now;
        Some(Selection{identity:Identity{session:self.session?,epoch:self.epoch,owner,releases:record.releases},age_seconds:age as f32,first})
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use openleague_core::{Action,Navigation,Point,Simulation};
    fn fixture()->(Simulation,u32,State) {
        let mut cells=Vec::new();for _ in 0..400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
        let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap();
        let mut game=Simulation::new(nav).unwrap();game.session=7;game.tick=99;
        let owner=game.join("ezreal").unwrap();game.players.get_mut(&owner).unwrap().position=Point{x:100.,z:100.};
        game.command(owner,Action::Learn{slot:0}).unwrap();
        let mut state=State::default();state.reset(7);state.observe_accepted(&game.snapshot(),1.,true,false).unwrap();
        (game,owner,state)
    }
    fn cast(game:&mut Simulation,owner:u32)->Snapshot {
        game.tick=100;game.command(owner,Action::CastAt{slot:0,point:Point{x:700.,z:100.}}).unwrap();game.snapshot()
    }
    fn select(state:&mut State,owner:u32,entity:u64,now:f64)->Option<Selection>{state.select(owner,entity,now,Some(0.8),true,true)}
    #[test]
    fn accepted_core_cast_age_duplicate_pause_and_expiry_never_mutate_or_extend_lock() {
        let(mut game,owner,mut state)=fixture();let snapshot=cast(&mut game,owner);
        let original=serde_json::to_value(&snapshot).unwrap();state.observe_accepted(&snapshot,1.1,true,false).unwrap();
        let first=select(&mut state,owner,10,1.1).unwrap();assert!(first.first);assert_eq!(first.age_seconds,0.);
        let paused=select(&mut state,owner,10,1.1).unwrap();assert!(!paused.first);assert_eq!(paused,Selection{first:false,..first});
        state.observe_accepted(&snapshot,1.3,true,false).unwrap();let current=select(&mut state,owner,10,1.3).unwrap();
        assert!((current.age_seconds-0.2).abs()<0.00001);
        let mut paused_packet=snapshot.clone();paused_packet.tick=107;
        state.observe_accepted(&paused_packet,1.3,true,true).unwrap();
        assert_eq!(select(&mut state,owner,10,1.3).unwrap().age_seconds,current.age_seconds,
            "network correction must not advance the paused EffectClock pose");
        assert!(select(&mut state,owner,10,1.4).is_none());
        state.observe_accepted(&snapshot,1.41,true,false).unwrap();assert!(select(&mut state,owner,10,1.41).is_none());
        let mut old=snapshot.clone();old.tick=99;let before=state.clone();assert_eq!(state.observe_accepted(&old,1.5,true,false),Ok(false));assert_eq!(state,before);
        assert_eq!(serde_json::to_value(&snapshot).unwrap(),original);
    }
    #[test]
    fn changed_direction_malformed_future_and_budget_reject_transactionally() {
        let(mut game,owner,mut state)=fixture();let snapshot=cast(&mut game,owner);state.observe_accepted(&snapshot,1.1,true,false).unwrap();
        for mode in 0..5 {
            let mut bad=snapshot.clone();let lock=bad.players.iter_mut().find(|p|p.id==owner).unwrap().effects.ezreal_q.as_mut().unwrap();
            match mode {0=>lock.direction=Point{x:0.,z:1.},1=>lock.direction.x=f32::NAN,2=>lock.releases=3,3=>lock.releases=200,_=>{let entry=bad.roster[0].clone();bad.roster=vec![entry;65];}}
            let before=state.clone();assert!(state.observe_accepted(&bad,1.11,true,false).is_err());assert_eq!(state,before);
        }
        assert!(select(&mut state,owner,10,1.11).is_some(),"invalid optional packet does not replace an accepted lock");
    }
    #[test]
    fn missing_clip_recreated_scene_clock_failure_and_regression_consume_without_resume() {
        for mode in 0..5 {
            let(mut game,owner,mut state)=fixture();let snapshot=cast(&mut game,owner);state.observe_accepted(&snapshot,1.1,true,false).unwrap();
            if mode==0 {assert!(state.select(owner,10,1.1,None,true,true).is_none());}
            else {
                assert!(select(&mut state,owner,10,1.1).is_some());
                match mode {1=>assert!(select(&mut state,owner,11,1.11).is_none()),
                    2=>assert!(state.select(owner,10,1.11,Some(0.8),true,false).is_none()),
                    3=>assert!(state.observe_accepted(&snapshot,f64::NAN,true,false).is_err()),
                    _=>assert!(select(&mut state,owner,10,1.).is_none())}
            }
            state.observe_accepted(&snapshot,1.12,true,false).unwrap();assert!(select(&mut state,owner,10,1.12).is_none());
        }
    }
    #[test]
    fn baseline_epoch_session_fog_departure_and_late_windows_never_replay() {
        for mode in 0..6 {
            let(mut game,owner,mut state)=fixture();let snapshot=cast(&mut game,owner);
            if mode==0 {state.begin_epoch(7,2);state.observe_accepted(&snapshot,1.1,true,false).unwrap();}
            else if mode==1 {state.reset(8);let mut changed=snapshot.clone();changed.session=8;state.observe_accepted(&changed,1.1,true,false).unwrap();}
            else if mode==2 {let mut fog=snapshot.clone();fog.players.clear();state.observe_accepted(&fog,1.1,true,false).unwrap();state.observe_accepted(&snapshot,1.12,true,false).unwrap();}
            else if mode==3 {let mut late=snapshot.clone();late.tick=108;state.observe_accepted(&late,1.1,true,false).unwrap();}
            else if mode==4 {let mut middle=snapshot.clone();middle.tick=104;middle.players.iter_mut().find(|p|p.id==owner).unwrap().effects.ezreal_q=None;state.observe_accepted(&middle,1.1,true,false).unwrap();let mut late=snapshot.clone();late.tick=105;state.observe_accepted(&late,1.12,true,false).unwrap();}
            else {state.observe_accepted(&snapshot,1.1,true,false).unwrap();let mut gone=snapshot.clone();gone.tick=101;gone.players.clear();gone.roster.clear();state.observe_accepted(&gone,1.11,true,false).unwrap();assert!(state.records.is_empty());}
            assert!(select(&mut state,owner,10,1.13).is_none());
        }
        let(mut game,owner,mut state)=fixture();let mut delayed=cast(&mut game,owner);delayed.tick=103;
        state.observe_accepted(&delayed,1.1,true,false).unwrap();let pose=select(&mut state,owner,10,1.1).unwrap();assert!((pose.age_seconds-0.1).abs()<0.00001,"still-live first observation seeks current age, not time zero");
    }
    #[test]
    fn accepted_batch_interruptions_and_match_end_win_before_first_render() {
        for mode in 0..4 {
            let(mut game,owner,mut state)=fixture();let snapshot=cast(&mut game,owner);state.observe_accepted(&snapshot,1.1,true,false).unwrap();
            let mut blocked=snapshot.clone();blocked.tick=101;
            let p=blocked.players.iter_mut().find(|p|p.id==owner).unwrap();
            match mode {0=>p.health=0.,1=>p.effects.trundle_e_push=Some(openleague_core::trundle_e::ForcedMovement{started:101,until:107}),2=>p.stuns.push(openleague_core::stuns::Stun{tag:"fixture".into(),source:None,expires_at:107}),_=>blocked.winner=Some(0)}
            state.observe_accepted(&blocked,1.11,true,false).unwrap();let mut restored=snapshot.clone();restored.tick=102;
            state.observe_accepted(&restored,1.12,true,false).unwrap();assert!(select(&mut state,owner,10,1.12).is_none());
        }
    }
}
