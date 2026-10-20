//! Explicit reconstructed presentation of a received Trundle W zone.
//! No gameplay, input, attack journal, native callback, VFX or audio producer.
use openleague_core::{Snapshot, TICK_RATE};
use std::collections::{BTreeMap, BTreeSet};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Identity {
    pub session: u64,
    pub owner: u32,
    pub starts: u64,
    pub until: u64,
}
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct Stamp { identity: Identity, rank: u8, center: [u32; 2] }
#[derive(Debug, Clone, Copy, PartialEq)]
struct Anchor {
    stamp: Stamp,
    age: f64,
    received_at: f64,
    // The first actual AnimationPlayer entity/generation owns this one-shot.
    claimed_by: Option<u64>,
    last_attack_sequence: u64,
    retired: bool,
}
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Selection { pub identity: Identity, pub age_seconds: f32, pub first: bool }

#[derive(Debug, Default, Clone, PartialEq)]
pub struct State {
    session: Option<u64>,
    epoch: Option<u64>,
    tick: Option<u64>,
    clock: Option<f64>,
    seen: BTreeMap<u32, Stamp>,
    active: BTreeMap<u32, Anchor>,
    finished: bool,
    error: Option<String>,
}
impl State {
    pub fn reset(&mut self, session: u64) {
        if self.session==Some(session) {
            self.active.clear();self.tick=None;self.clock=None;self.epoch=None;
        } else { *self=Self { session:Some(session), ..Self::default() }; }
    }
    pub fn retire(&mut self, owner:u32) {
        if let Some(anchor)=self.active.get_mut(&owner) {anchor.retired=true;}
    }
    /// Called only after the existing authenticated presentation epoch succeeds.
    /// Retire pending/playing poses but retain same-session zone barriers.
    pub fn begin_epoch(&mut self, session: u64, epoch: u64) {
        if self.session!=Some(session) { self.reset(session); }
        if self.epoch!=Some(epoch) {
            self.epoch=Some(epoch);self.tick=None;self.clock=None;self.active.clear();
        }
    }
    pub fn error(&self)->Option<&str> { self.error.as_deref() }

    /// Only for snapshots already accepted by the existing common journals.
    /// Local W errors disable only W presentation; the caller must not reject
    /// a game snapshot or alter an attack based on this optional presentation.
    pub fn observe_accepted(&mut self, snapshot:&Snapshot, now:f64)->Result<bool,String> {
        if self.session!=Some(snapshot.session) || self.tick.is_some_and(|tick| snapshot.tick<tick) {
            return Ok(false);
        }
        if self.error.is_some() { return Ok(false); }
        let mut next=self.clone();
        match next.observe_inner(snapshot,now) {
            Ok(())=>{*self=next;Ok(true)},
            Err(error)=>{self.active.clear();self.error=Some(error.clone());Err(error)},
        }
    }
    fn observe_inner(&mut self,snapshot:&Snapshot,now:f64)->Result<(),String> {
        if !now.is_finite() || self.clock.is_some_and(|old| now<old) {
            return Err("Trundle W presentation clock is nonfinite or went backwards".into());
        }
        let mut roster=BTreeSet::new();
        for entry in snapshot.roster.iter().filter(|entry|entry.champion=="trundle") {
            if !roster.insert(entry.id) { return Err("duplicate Trundle W roster owner".into()); }
        }
        if roster.len()>openleague_core::attack_presentation::Limits::default().active_sources() {
            return Err("Trundle W presentation roster exceeds existing capacity".into());
        }
        self.seen.retain(|id,_|roster.contains(id));
        self.active.retain(|id,_|roster.contains(id));
        self.tick=Some(snapshot.tick);self.clock=Some(now);
        self.finished|=snapshot.winner.is_some() || snapshot.result.is_some();
        if self.finished { self.active.clear();return Ok(()); }
        let mut visible=BTreeSet::new();
        for champion in &snapshot.players {
            if champion.champion!="trundle" {
                if champion.effects.trundle_w.is_some() { return Err("Trundle W zone on another champion".into()); }
                continue;
            }
            if !roster.contains(&champion.id) || !visible.insert(champion.id) {
                return Err("Trundle W visible owner absent or duplicated in roster".into());
            }
            let Some(zone)=champion.effects.trundle_w.as_ref() else {self.active.remove(&champion.id);continue;};
            if zone.owner!=champion.id || !zone.center.finite() || !(1..=5).contains(&zone.rank)
                || zone.rank>champion.ranks[1] || zone.starts.checked_add(8*TICK_RATE)!=Some(zone.until)
                || snapshot.tick<zone.starts {
                return Err("invalid authoritative Trundle W zone identity".into());
            }
            let stamp=Stamp {identity:Identity {session:snapshot.session,owner:zone.owner,starts:zone.starts,until:zone.until},
                rank:zone.rank,center:[zone.center.x.to_bits(),zone.center.z.to_bits()]};
            let new=match self.seen.get(&champion.id) {
                Some(previous) if stamp.identity.starts<previous.identity.starts=>{
                    return Err("Trundle W zone identity went backwards".into());
                },
                Some(previous) if stamp.identity.starts==previous.identity.starts=>{
                    if stamp!=*previous {return Err("Trundle W zone identity changed".into());}false
                },
                _=>true,
            };
            if new {self.seen.insert(champion.id,stamp);self.active.remove(&champion.id);}
            if !champion.health.is_finite() || champion.health<=0. || !champion.position.finite()
                || snapshot.tick>=zone.until {
                self.active.remove(&champion.id);continue;
            }
            let network_age=(snapshot.tick-zone.starts) as f64/TICK_RATE as f64;
            let events=snapshot.attack_events.iter().filter(|event|event.attack.source==champion.id);
            let highest=events.clone().map(|event|event.sequence).max().unwrap_or(0);
            if new {
                self.active.insert(champion.id,Anchor {stamp,age:network_age,received_at:now,claimed_by:None,
                    last_attack_sequence:highest,retired:false});
            } else if let Some(anchor)=self.active.get_mut(&champion.id) {
                let new_started=events.filter(|event|event.sequence>anchor.last_attack_sequence)
                    .any(|event|matches!(event.phase,openleague_core::attack_presentation::Phase::Started{..}));
                if anchor.claimed_by.is_some() && (champion.windup.is_some() || champion.destination.is_some()
                    || openleague_core::stuns::active(champion,snapshot.tick)
                    || openleague_core::trundle_e::champion_forced(champion,snapshot.tick) || new_started) {
                    anchor.retired=true;
                }
                anchor.last_attack_sequence=anchor.last_attack_sequence.max(highest);
                let age=(anchor.age+(now-anchor.received_at)).max(network_age);
                if !age.is_finite() {return Err("Trundle W presentation age overflow".into());}
                anchor.age=age;anchor.received_at=now;
            }
        }
        // Losing visibility, death or an absent zone retires the old pose. The
        // barrier remains for current roster members, so later reappearance is
        // never interpreted as a second cast or a respawn-triggered playback.
        self.active.retain(|id,_|visible.contains(id));
        Ok(())
    }
    /// Idle-only local policy. A pending request can wait within the loaded
    /// clip's age window; after its first claim, any priority loss retires it.
    pub fn select(&mut self,owner:u32,entity:u64,now:f64,duration:Option<f32>,idle_available:bool,clock_ready:bool)->Option<Selection> {
        if self.finished || self.error.is_some() {return None;}
        let anchor=self.active.get_mut(&owner)?;
        if anchor.retired {return None;}
        if !clock_ready || !now.is_finite() || now<anchor.received_at {
            if anchor.claimed_by.is_some() {anchor.retired=true;}
            return None;
        }
        let age=anchor.age+(now-anchor.received_at);
        let zone_seconds=(anchor.stamp.identity.until-anchor.stamp.identity.starts) as f64/TICK_RATE as f64;
        if !age.is_finite() || age<0. || age>=zone_seconds {anchor.retired=true;return None;}
        let Some(duration)=duration.filter(|value|value.is_finite() && *value>0.) else {
            if anchor.claimed_by.is_some() {anchor.retired=true;}
            return None;
        };
        if age>=f64::from(duration).min(zone_seconds) {anchor.retired=true;return None;}
        if let Some(claim)=anchor.claimed_by {
            if claim!=entity {return None;}
            if !idle_available {anchor.retired=true;return None;}
            return Some(Selection {identity:anchor.stamp.identity,age_seconds:age as f32,first:false});
        }
        if !idle_available {return None;}
        anchor.claimed_by=Some(entity);
        Some(Selection {identity:anchor.stamp.identity,age_seconds:age as f32,first:true})
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn fixture()->(openleague_core::Simulation,u32,State) {
        let mut cells=Vec::new();for _ in 0..400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
        let nav=openleague_core::Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap();
        let mut game=openleague_core::Simulation::new(nav).unwrap();game.session=7;let id=game.join("trundle").unwrap();game.tick=101;
        let p=game.players.get_mut(&id).unwrap();p.ranks[1]=1;p.effects.trundle_w=Some(openleague_core::trundle_w::Zone {owner:id,center:p.position,rank:1,starts:100,until:340});
        let mut state=State::default();state.reset(7);(game,id,state)
    }
    #[test]
    fn received_zone_is_once_at_network_age_and_effect_clock_pause_holds_it() {
        let (game,id,mut state)=fixture();let snapshot=game.snapshot();let original=serde_json::to_value(&snapshot).unwrap();
        state.observe_accepted(&snapshot,10.).unwrap();let first=state.select(id,42,10.,Some(0.73333335),true,true).unwrap();
        assert!(first.first);assert!((first.age_seconds-1./30.).abs()<0.00001);
        state.observe_accepted(&snapshot,10.).unwrap();let again=state.select(id,42,10.,Some(0.73333335),true,true).unwrap();
        assert!(!again.first);assert_eq!(first.age_seconds,again.age_seconds);
        assert_eq!(serde_json::to_value(&snapshot).unwrap(),original);
        assert!(state.select(id,42,10.8,Some(0.73333335),true,true).is_none());
    }
    #[test]
    fn delayed_clip_and_player_load_seek_current_age_and_late_recreation_never_reclaims() {
        let (game,id,mut state)=fixture();state.observe_accepted(&game.snapshot(),1.).unwrap();
        assert!(state.select(id,1,1.,None,true,true).is_none());
        let selected=state.select(id,1,1.2,Some(0.73333335),true,true).unwrap();assert!(selected.first && selected.age_seconds>0.2);
        assert!(state.select(id,2,1.21,Some(0.73333335),true,true).is_none());
        let (game,id,mut late)=fixture();late.observe_accepted(&game.snapshot(),1.).unwrap();
        assert!(late.select(id,2,2.,Some(0.73333335),true,true).is_none());
    }
    #[test]
    fn pending_waits_for_idle_but_started_pose_never_resumes_after_attack_or_priority_loss() {
        let (game,id,mut state)=fixture();state.observe_accepted(&game.snapshot(),0.).unwrap();
        assert!(state.select(id,1,0.,Some(0.73333335),false,true).is_none());
        assert!(state.select(id,1,0.1,Some(0.73333335),true,true).unwrap().first);
        assert!(state.select(id,1,0.2,Some(0.73333335),false,true).is_none());
        assert!(state.select(id,1,0.3,Some(0.73333335),true,true).is_none());
        // A started+resolved attack can arrive entirely between render calls.
        use openleague_core::attack_presentation::{State as Events,Kind,Audience};
        for claimed in [false,true] {
            let (mut game,id,mut state)=fixture();state.observe_accepted(&game.snapshot(),0.).unwrap();
            if claimed {assert!(state.select(id,1,0.,Some(0.73333335),true,true).is_some());}
            let mut facts=Events::default();let audience=Audience::from_visibility(true,true);
            let attack=facts.begin(id,102,103,Kind::Basic,audience).unwrap();facts.resolve(attack,103,Kind::Basic,true,audience).unwrap();
            game.tick=103;let mut snapshot=game.snapshot();snapshot.attack_events=facts.events();
            state.observe_accepted(&snapshot,0.05).unwrap();
            if claimed {assert!(state.select(id,1,0.05,Some(0.73333335),true,true).is_none());}
            else {
                assert!(state.select(id,1,0.05,Some(0.73333335),true,true).unwrap().first);
                snapshot.tick=104;state.observe_accepted(&snapshot,0.06).unwrap();
                assert!(!state.select(id,1,0.06,Some(0.73333335),true,true).unwrap().first,
                    "the same historical Started event must not retire a later idle claim");
            }
        }
    }
    #[test]
    fn stale_foreign_snapshots_and_epoch_death_fog_respawn_do_not_replay_zone() {
        let (mut game,id,mut state)=fixture();state.observe_accepted(&game.snapshot(),0.).unwrap();
        let before=state.clone();game.tick=99;assert!(!state.observe_accepted(&game.snapshot(),0.).unwrap());assert_eq!(state,before);
        game.tick=101;game.session=8;assert!(!state.observe_accepted(&game.snapshot(),0.).unwrap());assert_eq!(state,before);game.session=7;
        state.reset(7);state.observe_accepted(&game.snapshot(),0.).unwrap();assert!(state.select(id,1,0.,Some(0.73333335),true,true).is_none());
        state.begin_epoch(7,2);state.observe_accepted(&game.snapshot(),0.).unwrap();assert!(state.select(id,1,0.,Some(0.73333335),true,true).is_none());
        for mode in [0,1] {
            let (mut game,id,mut state)=fixture();state.observe_accepted(&game.snapshot(),0.).unwrap();
            let mut missing=game.snapshot();missing.tick=102;
            if mode==0 {missing.players.iter_mut().find(|p|p.id==id).unwrap().health=0.;}else{missing.players.clear();}
            state.observe_accepted(&missing,0.01).unwrap();game.tick=103;state.observe_accepted(&game.snapshot(),0.02).unwrap();
            assert!(state.select(id,1,0.02,Some(0.73333335),true,true).is_none());
        }
        state.reset(8);game.session=8;state.observe_accepted(&game.snapshot(),0.).unwrap();assert!(state.select(id,1,0.,Some(0.73333335),true,true).unwrap().first);
    }
    #[test]
    fn invalid_zone_nonfinite_clock_failed_clock_and_terminal_remain_fail_closed() {
        let (mut game,id,mut state)=fixture();state.observe_accepted(&game.snapshot(),0.).unwrap();
        let snapshot=game.snapshot();assert!(state.observe_accepted(&snapshot,f64::NAN).is_err());assert!(state.error().is_some());
        assert!(state.select(id,1,0.,Some(1.),true,true).is_none());
        let (_,_,mut state)=fixture();game.players.get_mut(&id).unwrap().effects.trundle_w.as_mut().unwrap().owner=id+1;
        assert!(state.observe_accepted(&game.snapshot(),0.).is_err());
        let (mut game,id,mut state)=fixture();state.observe_accepted(&game.snapshot(),0.).unwrap();
        assert!(state.select(id,1,0.,Some(1.),true,false).is_none());assert!(state.select(id,1,0.,Some(1.),true,true).unwrap().first);
        assert!(state.select(id,1,0.,Some(1.),true,false).is_none());assert!(state.select(id,1,0.,Some(1.),true,true).is_none());
        game.tick=340;state.observe_accepted(&game.snapshot(),1.).unwrap();assert!(state.select(id,1,1.,Some(1.),true,true).is_none());
        let (mut game,id,mut state)=fixture();game.winner=Some(0);state.observe_accepted(&game.snapshot(),0.).unwrap();assert!(state.select(id,1,0.,Some(1.),true,true).is_none());
    }
}


#[cfg(test)]
mod trundle_e_interrupt_tests {
    use super::*;
    #[test]
    fn forced_intermediate_snapshot_retires_claimed_w_before_render_without_replay() {
        let mut cells=Vec::new();for _ in 0..400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
        let nav=openleague_core::Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap();
        let mut game=openleague_core::Simulation::new(nav).unwrap();game.session=7;game.tick=101;let id=game.join("trundle").unwrap();
        let p=game.players.get_mut(&id).unwrap();p.position=openleague_core::Point{x:100.,z:100.};p.ranks[1]=1;
        p.effects.trundle_w=Some(openleague_core::trundle_w::Zone{owner:id,center:p.position,rank:1,starts:100,until:340});
        let mut state=State::default();state.reset(7);state.observe_accepted(&game.snapshot(),0.).unwrap();
        assert!(state.select(id,42,0.,Some(0.73333335),true,true).unwrap().first);
        game.tick=102;let p=game.players.get_mut(&id).unwrap();
        p.effects.trundle_e_push=Some(openleague_core::trundle_e::ForcedMovement{started:102,until:107});
        assert!(p.destination.is_none() && p.windup.is_none() && p.stuns.is_empty());
        state.observe_accepted(&game.snapshot(),0.02).unwrap();
        game.tick=107;game.players.get_mut(&id).unwrap().effects.trundle_e_push=None;
        state.observe_accepted(&game.snapshot(),0.03).unwrap();
        assert!(state.select(id,42,0.03,Some(0.73333335),true,true).is_none(),"both snapshots arrived before animate; old claimed W stays retired");
        game.tick=108;let p=game.players.get_mut(&id).unwrap();let z=p.effects.trundle_w.as_mut().unwrap();z.starts=108;z.until=348;
        state.observe_accepted(&game.snapshot(),0.04).unwrap();
        assert!(state.select(id,42,0.04,Some(0.73333335),true,true).unwrap().first,"a genuinely newer W identity is distinct");
    }
}
