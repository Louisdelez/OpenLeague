//! Local W/R pose consumer of accepted, audience-scoped Core cast facts.
//! Optional errors never reject a shared Snapshot or change gameplay/attacks.
use openleague_core::{accepted_cast_presentation::{self as facts, Event, Kind}, Snapshot, TICK_RATE};
use std::collections::{BTreeMap, BTreeSet};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Identity { pub session:u64, pub view_team:u8, pub owner:u32, pub order:u64 }
#[derive(Debug, Clone, Copy, PartialEq)]
struct Record {
    event:Event, age:f64, received_at:f64, claimed_by:Option<u64>,
    last_attack_sequence:u64, retired:bool,
}

#[cfg(test)]
mod tests {
    use super::*;
    use openleague_core::{Navigation,Simulation};
    fn fixture()->(Simulation,u32,u32,State) {
        let mut cells=Vec::new();for _ in 0..400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
        let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap();
        let mut game=Simulation::new(nav).unwrap();game.session=7;game.tick=99;
        let owner=game.join("trundle").unwrap();let viewer=game.join("garen").unwrap();
        game.players.get_mut(&owner).unwrap().ranks=[1,1,0,1];
        let mut state=State::default();state.reset(7,viewer);
        let first=packet(&game,99,&[]);state.observe_accepted(&first,viewer,0.,true).unwrap();
        (game,owner,viewer,state)
    }
    fn event(owner:u32,order:u64,tick:u64,kind:Kind)->Event{Event{owner,order,tick,kind}}
    fn packet(game:&Simulation,tick:u64,events:&[Event])->Snapshot {
        let mut snapshot=game.snapshot();snapshot.tick=tick;
        snapshot.accepted_casts=Some(serde_json::json!({"version":1,"events":events}));snapshot
    }
    fn select(state:&mut State,owner:u32,entity:u64,now:f64,eligible:[bool;2])->Option<Selection>{
        state.select(owner,entity,now,[Some(0.73333335),Some(1.)],eligible,true)
    }
    #[test]
    fn lethal_without_drain_marker_selects_r_at_received_age_without_mutating_snapshot() {
        let (game,owner,viewer,mut state)=fixture();
        let snapshot=packet(&game,103,&[event(owner,1,100,Kind::R)]);
        assert!(snapshot.players.iter().find(|p|p.id==owner).unwrap().effects.trundle_r.is_none());
        let before=serde_json::to_value(&snapshot).unwrap();
        state.observe_accepted(&snapshot,viewer,0.1,true).unwrap();
        let pose=select(&mut state,owner,42,0.1,[true,true]).unwrap();
        assert_eq!(pose.kind,Kind::R);assert_eq!(pose.role,"spell4");assert!((pose.age_seconds-0.1).abs()<0.00001);
        assert_eq!(serde_json::to_value(&snapshot).unwrap(),before);
    }
    #[test]
    fn same_tick_order_compares_only_eligible_w_r_and_old_zone_cannot_block_r() {
        for reverse in [false,true] {
            let (game,owner,viewer,mut state)=fixture();
            let kinds=if reverse{[Kind::R,Kind::W]}else{[Kind::W,Kind::R]};
            let snapshot=packet(&game,101,&[event(owner,1,100,kinds[0]),event(owner,2,100,kinds[1])]);
            state.observe_accepted(&snapshot,viewer,0.1,true).unwrap();
            assert_eq!(select(&mut state,owner,1,0.1,[true,true]).unwrap().kind,kinds[1]);
            assert!(state.seen[&(owner,1)].retired,"superseded unclaimed poses cannot become a backlog");
            if reverse {assert!(select(&mut state,owner,1,0.9,[true,true]).is_none(),
                "older unclaimed R cannot appear after the newer shorter W expires");}
        }
        let (mut game,owner,viewer,mut state)=fixture();
        let center=game.players[&owner].position;
        game.players.get_mut(&owner).unwrap().effects.trundle_w=Some(openleague_core::trundle_w::Zone{
            owner,rank:1,starts:50,until:290,center});
        let snapshot=packet(&game,102,&[event(owner,1,100,Kind::R),event(owner,2,101,Kind::W)]);
        state.observe_accepted(&snapshot,viewer,0.1,true).unwrap();
        assert_eq!(select(&mut state,owner,1,0.1,[false,true]).unwrap().kind,Kind::R,
            "newer W ineligible during BA cannot erase eligible R; Zone lifetime has no priority");
    }
    #[test]
    fn new_r_supersedes_claimed_w_once_and_no_old_pose_resumes() {
        let (game,owner,viewer,mut state)=fixture();
        state.observe_accepted(&packet(&game,100,&[event(owner,1,100,Kind::W)]),viewer,0.1,true).unwrap();
        assert_eq!(select(&mut state,owner,1,0.1,[true,true]).unwrap().kind,Kind::W);
        let newer=packet(&game,103,&[event(owner,1,100,Kind::W),event(owner,2,103,Kind::R)]);
        state.observe_accepted(&newer,viewer,0.2,true).unwrap();
        assert_eq!(select(&mut state,owner,1,0.2,[true,true]).unwrap().kind,Kind::R);
        assert!(state.seen[&(owner,1)].retired);
        assert!(select(&mut state,owner,1,1.3,[true,true]).is_none());
    }
    #[test]
    fn intermediate_forced_stun_death_and_fog_retire_even_before_first_draw() {
        for mode in 0..4 {
            let (game,owner,viewer,mut state)=fixture();
            state.observe_accepted(&packet(&game,100,&[event(owner,1,100,Kind::R)]),viewer,0.1,true).unwrap();
            let mut interrupted=packet(&game,101,&[event(owner,1,100,Kind::R)]);
            if mode==3 {interrupted.players.retain(|p|p.id!=owner);interrupted.accepted_casts=Some(serde_json::json!({"version":1,"events":[]}));}
            else {
                let p=interrupted.players.iter_mut().find(|p|p.id==owner).unwrap();
                if mode==0 {p.effects.trundle_e_push=Some(openleague_core::trundle_e::ForcedMovement{started:101,until:107});}
                else if mode==1 {p.stuns.push(openleague_core::stuns::Stun{tag:"fixture".into(),source:None,expires_at:107});}
                else {p.health=0.;}
            }
            state.observe_accepted(&interrupted,viewer,0.12,true).unwrap();
            state.observe_accepted(&packet(&game,107,&[event(owner,1,100,Kind::R)]),viewer,0.2,true).unwrap();
            assert!(select(&mut state,owner,1,0.2,[true,true]).is_none());
        }
    }
    #[test]
    fn late_real_player_seeks_current_window_recreation_never_reclaims() {
        let (game,owner,viewer,mut state)=fixture();
        state.observe_accepted(&packet(&game,103,&[event(owner,1,100,Kind::R)]),viewer,0.1,true).unwrap();
        assert!(state.select(owner,5,0.1,[None,None],[true,true],true).is_none());
        let first=select(&mut state,owner,5,0.3,[true,true]).unwrap();assert!(first.first && first.age_seconds>0.29);
        assert!(select(&mut state,owner,6,0.31,[true,true]).is_none());
        assert!(select(&mut state,owner,5,0.32,[true,true]).is_none());
        let (_,_,_,mut late)=fixture();late.observe_accepted(&packet(&game,103,&[event(owner,1,100,Kind::R)]),viewer,0.1,true).unwrap();
        assert!(select(&mut late,owner,5,1.2,[true,true]).is_none());
    }
    #[test]
    fn moving_claimed_r_keeps_its_identity_current_age_and_received_destination_while_w_retires() {
        let (mut game,owner,viewer,mut state)=fixture();
        let destination=openleague_core::Point{x:300.,z:350.};
        game.players.get_mut(&owner).unwrap().destination=Some(destination);
        let mut received=packet(&game,100,&[event(owner,1,100,Kind::R)]);
        let original=serde_json::to_value(&received).unwrap();
        state.observe_accepted(&received,viewer,0.1,true).unwrap();
        let first=select(&mut state,owner,42,0.1,[false,true]).unwrap();
        assert!(first.first);assert_eq!(first.role,"spell4");assert_eq!(first.age_seconds,0.);
        assert_eq!(serde_json::to_value(&received).unwrap(),original);
        for (tick,now,age) in [(103,0.2,0.1f32),(109,0.4,0.3f32),(115,0.6,0.5f32)] {
            received.tick=tick;let before=serde_json::to_value(&received).unwrap();
            state.observe_accepted(&received,viewer,now,true).unwrap();
            let pose=select(&mut state,owner,42,now,[false,true]).unwrap();
            assert_eq!(pose.identity,first.identity);assert!(!pose.first);
            assert!((pose.age_seconds-age).abs()<0.00001);
            assert!(!state.seen[&(owner,1)].retired);
            assert_eq!(received.players.iter().find(|p|p.id==owner).unwrap().destination,Some(destination));
            assert_eq!(serde_json::to_value(&received).unwrap(),before,"rendering never clears a movement order");
        }
        assert!(select(&mut state,owner,42,1.2,[false,true]).is_none(),"R still expires at its loaded clip window");
        let (mut game,owner,viewer,mut w)=fixture();
        w.observe_accepted(&packet(&game,100,&[event(owner,1,100,Kind::W)]),viewer,0.1,true).unwrap();
        assert_eq!(select(&mut w,owner,42,0.1,[true,true]).unwrap().kind,Kind::W);
        game.players.get_mut(&owner).unwrap().destination=Some(destination);
        w.observe_accepted(&packet(&game,101,&[event(owner,1,100,Kind::W)]),viewer,0.2,true).unwrap();
        assert!(w.seen[&(owner,1)].retired && select(&mut w,owner,42,0.2,[true,true]).is_none(),
            "the movement interruption remains W-only");
    }
    #[test]
    fn missing_and_malformed_optional_journal_never_invent_r_or_mutate_world() {
        let (game,owner,viewer,mut state)=fixture();let mut missing=packet(&game,100,&[]);missing.accepted_casts=None;
        let world=serde_json::to_value(&missing).unwrap();state.observe_accepted(&missing,viewer,0.1,true).unwrap();
        assert!(!state.supported());assert!(select(&mut state,owner,1,0.1,[true,true]).is_none());
        assert_eq!(serde_json::to_value(&missing).unwrap(),world);
        let mut malformed=packet(&game,101,&[]);malformed.accepted_casts=Some(serde_json::json!({"version":1,"events":[{"owner":owner,"order":1,"tick":100,"kind":"trundle_r","target":viewer}]}));
        let world=serde_json::to_value(&malformed).unwrap();assert!(state.observe_accepted(&malformed,viewer,0.2,true).is_err());
        assert_eq!(serde_json::to_value(&malformed).unwrap(),world);assert!(state.error().is_some());
        let (game,owner,viewer,mut monotone)=fixture();
        monotone.observe_accepted(&packet(&game,100,&[event(owner,1,100,Kind::R)]),viewer,0.1,true).unwrap();
        assert!(monotone.observe_accepted(&packet(&game,101,&[event(owner,2,99,Kind::W)]),viewer,0.2,true).is_err());
        assert_eq!(monotone.watermarks[&owner],1);assert_eq!(monotone.last_ticks[&owner],100);
        assert!(select(&mut monotone,owner,1,0.2,[true,true]).is_none());
    }
    #[test]
    fn receive_batch_supported_then_missing_or_invalid_never_replays_legacy_zone() {
        for invalid in [false,true] {
            let (mut game,owner,viewer,mut state)=fixture();
            let center=game.players[&owner].position;
            game.players.get_mut(&owner).unwrap().effects.trundle_w=Some(openleague_core::trundle_w::Zone{
                owner,rank:1,starts:100,until:340,center});
            let mut legacy=crate::trundle_w_animation::State::default();legacy.reset(7);
            let supported=packet(&game,101,&[event(owner,1,100,Kind::W)]);
            legacy.observe_accepted(&supported,0.1).unwrap();
            state.observe_with_legacy(&supported,viewer,0.1,true,&mut legacy).unwrap();
            let mut later=packet(&game,102,&[]);
            later.accepted_casts=if invalid{Some(serde_json::json!({"version":2,"events":[]}))}else{None};
            legacy.observe_accepted(&later,0.11).unwrap();
            let result=state.observe_with_legacy(&later,viewer,0.11,true,&mut legacy);
            assert_eq!(result.is_err(),invalid);
            assert!(!state.supported());
            assert!(legacy.select(owner,1,0.11,Some(0.73333335),true,true).is_none(),
                "no animate occurred between the two accepted packets");
        }
    }
    #[test]
    fn team_context_epoch_initial_baseline_and_cache_eviction_do_not_replay() {
        let (game,owner,viewer,mut state)=fixture();
        for i in 1..=130 {
            state.observe_accepted(&packet(&game,99+i,&[event(owner,i,99+i,Kind::R)]),viewer,i as f64/30.,true).unwrap();
        }
        assert_eq!(state.seen.len(),128);assert_eq!(state.watermarks[&owner],130);
        state.observe_accepted(&packet(&game,230,&[event(owner,1,100,Kind::R)]),viewer,4.4,true).unwrap();
        assert!(!state.seen.contains_key(&(owner,1)));assert_eq!(state.watermarks[&owner],130);
        state.begin_epoch(7,2,viewer);
        state.observe_accepted(&packet(&game,231,&[event(owner,130,229,Kind::R)]),viewer,4.5,true).unwrap();
        assert!(select(&mut state,owner,1,4.5,[true,true]).is_none());
        let mut changed=packet(&game,232,&[event(owner,1,232,Kind::R)]);
        changed.roster.iter_mut().find(|p|p.id==viewer).unwrap().team=0;
        assert!(state.observe_accepted(&changed,viewer,4.6,true).is_err(),"team cannot alias without new accepted context");
        let (game,owner,viewer,mut rebound)=fixture();rebound.begin_epoch(7,2,viewer);
        let mut changed=packet(&game,100,&[event(owner,1,100,Kind::R)]);changed.roster.iter_mut().find(|p|p.id==viewer).unwrap().team=0;
        rebound.observe_accepted(&changed,viewer,0.1,true).unwrap();assert!(select(&mut rebound,owner,1,0.1,[true,true]).is_none());
        changed.tick=101;changed.accepted_casts=Some(serde_json::json!({"version":1,"events":[event(owner,2,101,Kind::R)]}));
        rebound.observe_accepted(&changed,viewer,0.2,true).unwrap();let selected=select(&mut rebound,owner,1,0.2,[true,true]).unwrap();
        assert_eq!(selected.identity.view_team,0);assert_eq!(selected.identity.order,2);
    }
    #[test]
    fn r_masks_render_only_while_critical_and_q_journals_advance_at_their_own_age() {
        use openleague_core::{attack_presentation::{State as Attacks,Kind as AttackKind,Audience},attacks::Windup};
        let (game,owner,viewer,mut state)=fixture();let mut attacks=Attacks::default();let audience=Audience::from_visibility(true,true);
        let mut ba=crate::attack_animation::State::default();ba.reset(7);ba.observe(&packet(&game,99,&[]),0.).unwrap();
        let attack=attacks.begin(owner,101,104,AttackKind::Critical,audience).unwrap();
        let mut p=packet(&game,103,&[event(owner,1,100,Kind::R)]);p.attack_events=attacks.events();
        p.players.iter_mut().find(|p|p.id==owner).unwrap().windup=Some(Windup{target:viewer,started:attack.started,release:attack.release,cancelable:true,critical:true,presentation:Some(attack)});
        ba.observe(&p,0.1).unwrap();state.observe_accepted(&p,viewer,0.1,true).unwrap();
        let current=ba.selection(owner,0.1,Some(2.)).unwrap();assert_eq!(current.kind,AttackKind::Critical);assert_eq!(current.attack,attack.id);
        assert_eq!(select(&mut state,owner,1,0.1,[false,true]).unwrap().kind,Kind::R);
        attacks.resolve(attack,104,AttackKind::Critical,true,audience).unwrap();
        let q=attacks.begin(owner,104,130,AttackKind::TrundleQ,audience).unwrap();
        let mut newer=packet(&game,105,&[event(owner,1,100,Kind::R)]);newer.attack_events=attacks.events();
        newer.players.iter_mut().find(|p|p.id==owner).unwrap().windup=Some(Windup{target:viewer,started:q.started,release:q.release,cancelable:true,critical:false,presentation:Some(q)});
        ba.observe(&newer,0.2).unwrap();state.observe_accepted(&newer,viewer,0.2,true).unwrap();
        let current=ba.selection(owner,0.2,Some(2.)).unwrap();assert_eq!(current.kind,AttackKind::TrundleQ);assert_eq!(current.attack,q.id);
        assert!(current.age_seconds>0.03 && current.age_seconds<0.04);
        assert_eq!(select(&mut state,owner,1,0.2,[false,true]).unwrap().kind,Kind::R);
        assert!(select(&mut state,owner,1,1.2,[false,true]).is_none());
        assert_eq!(ba.selection(owner,1.2,Some(2.)).unwrap().attack,q.id,"only still-current Q is revealed, never critical backlog");
    }
}
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Selection {
    pub identity:Identity, pub kind:Kind, pub role:&'static str,
    pub age_seconds:f32, pub first:bool,
}
#[derive(Debug, Default, Clone, PartialEq)]
pub struct State {
    session:Option<u64>, viewer:Option<u32>, view_team:Option<u8>, epoch:Option<u64>,
    allow_team_change:bool, tick:Option<u64>, clock:Option<f64>,
    visible:BTreeSet<u32>, watermarks:BTreeMap<u32,u64>, last_ticks:BTreeMap<u32,u64>,
    // Bounded equality/history cache, not a queue of animations to replay.
    seen:BTreeMap<(u32,u64),Record>, playing:BTreeMap<u32,Identity>,
    supported:bool, ready:bool, finished:bool, error:Option<String>,
}
impl State {
    /// Only the accepted Welcome path supplies this viewer identity.
    pub fn reset(&mut self,session:u64,viewer:u32) {
        if self.session!=Some(session) {
            *self=Self{session:Some(session),viewer:Some(viewer),allow_team_change:true,..Self::default()};
        } else {
            self.retire_all();self.viewer=Some(viewer);self.tick=None;self.clock=None;
            self.epoch=None;self.visible.clear();self.allow_team_change=true;self.ready=false;
        }
    }
    /// Called after the existing common epoch validator accepted a new context.
    pub fn begin_epoch(&mut self,session:u64,epoch:u64,viewer:u32) {
        if epoch==0 || (self.session==Some(session) && self.epoch.is_some_and(|old|epoch<=old)) {return;}
        if self.session!=Some(session) || self.viewer!=Some(viewer) {self.reset(session,viewer);}
        self.retire_all();self.epoch=Some(epoch);self.tick=None;self.clock=None;
        self.visible.clear();self.allow_team_change=true;self.ready=false;
    }
    pub fn error(&self)->Option<&str>{self.error.as_deref()}
    pub fn supported(&self)->bool{self.supported && self.error.is_none() && !self.finished}
    pub fn retire(&mut self,owner:u32) {
        for record in self.seen.values_mut().filter(|record|record.event.owner==owner) {record.retired=true;}
        self.playing.remove(&owner);
    }
    fn retire_all(&mut self) {
        for record in self.seen.values_mut(){record.retired=true;}
        self.playing.clear();
    }
    pub fn observe_accepted(&mut self,snapshot:&Snapshot,viewer:u32,now:f64,clock_ready:bool)->Result<bool,String> {
        if self.session!=Some(snapshot.session) || self.viewer!=Some(viewer)
            || self.tick.is_some_and(|old|snapshot.tick<old) || self.error.is_some() {return Ok(false);}
        let mut next=self.clone();
        match next.observe_inner(snapshot,viewer,now,clock_ready) {
            Ok(())=>{*self=next;Ok(true)},
            Err(error)=>{self.retire_all();self.supported=false;self.error=Some(error.clone());Err(error)},
        }
    }
    /// The accepted receive path calls this after legacy W has observed the
    /// same packet, BEFORE coalescing. A later missing/invalid optional packet
    /// in this batch cannot resurrect that Zone-derived legacy W identity.
    pub fn observe_with_legacy(&mut self,snapshot:&Snapshot,viewer:u32,now:f64,clock_ready:bool,
        legacy:&mut crate::trundle_w_animation::State)->Result<bool,String> {
        let accepted=self.observe_accepted(snapshot,viewer,now,clock_ready);
        if self.supported && self.error.is_none() {
            for actor in snapshot.players.iter().filter(|actor|actor.champion=="trundle") {legacy.retire(actor.id);}
        }
        accepted
    }
    fn observe_inner(&mut self,snapshot:&Snapshot,viewer:u32,now:f64,clock_ready:bool)->Result<(),String> {
        if !now.is_finite() || self.clock.is_some_and(|old|now<old) {return Err("cast presentation clock invalid".into());}
        let mut roster=BTreeMap::new();
        for entry in &snapshot.roster {
            if entry.id==0 || entry.team>1 || roster.insert(entry.id,(entry.team,entry.champion.as_str())).is_some() {
                return Err("cast presentation roster invalid".into());
            }
        }
        if roster.len()>facts::MAX_OWNERS {return Err("cast presentation roster exceeds bound".into());}
        let team=roster.get(&viewer).ok_or("accepted viewer missing from roster")?.0;
        if self.view_team.is_some_and(|old|old!=team) {
            if !self.allow_team_change {return Err("view team changed without a new accepted context".into());}
            self.seen.clear();self.watermarks.clear();self.last_ticks.clear();self.playing.clear();self.visible.clear();self.tick=None;
        }
        self.view_team=Some(team);self.allow_team_change=false;
        self.watermarks.retain(|owner,_|roster.get(owner).is_some_and(|(_,name)|*name=="trundle"));
        self.last_ticks.retain(|owner,_|self.watermarks.contains_key(owner));
        self.seen.retain(|(owner,_),_|roster.get(owner).is_some_and(|(_,name)|*name=="trundle"));
        self.playing.retain(|owner,_|roster.contains_key(owner));
        let mut visible=BTreeMap::new();
        for actor in snapshot.players.iter().filter(|actor|actor.champion=="trundle") {
            if !roster.get(&actor.id).is_some_and(|(_,name)|*name=="trundle") || visible.insert(actor.id,actor).is_some() {
                return Err("cast presentation visible owner invalid".into());
            }
        }
        let baseline=self.tick.is_none() || !self.ready || !self.supported;
        let previous_visible=self.visible.clone();
        self.tick=Some(snapshot.tick);self.clock=Some(now);
        self.finished|=snapshot.winner.is_some() || snapshot.result.is_some();
        let decoded=facts::decode_view(snapshot.accepted_casts.as_ref()).map_err(|error|format!("optional cast journal invalid: {error:?}"))?;
        let Some(events)=decoded else {
            self.retire_all();self.supported=false;self.ready=clock_ready;
            self.visible=visible.keys().copied().collect();return Ok(());
        };
        self.supported=true;
        // Validate the whole optional list before updating its watermarks/cache.
        for event in &events {
            if event.tick>snapshot.tick || !visible.contains_key(&event.owner) {
                return Err("cast fact is future or from an invisible owner".into());
            }
            if event.order>self.watermarks.get(&event.owner).copied().unwrap_or(0)
                && self.last_ticks.get(&event.owner).is_some_and(|tick|event.tick<*tick) {
                return Err("cast commit tick went backwards across accepted packets".into());
            }
            if self.seen.get(&(event.owner,event.order)).is_some_and(|record|record.event!=*event) {
                return Err("conflicting retained cast identity".into());
            }
        }
        for event in events {
            let highest=snapshot.attack_events.iter().filter(|event2|event2.attack.source==event.owner)
                .map(|event2|event2.sequence).max().unwrap_or(0);
            let newer=event.order>self.watermarks.get(&event.owner).copied().unwrap_or(0);
            if newer {
                self.watermarks.insert(event.owner,event.order);self.last_ticks.insert(event.owner,event.tick);
                let network_age=(snapshot.tick-event.tick) as f64/TICK_RATE as f64;
                self.seen.insert((event.owner,event.order),Record{event,age:network_age,received_at:now,
                    claimed_by:None,last_attack_sequence:highest,
                    retired:baseline || !previous_visible.contains(&event.owner) || !clock_ready || self.finished});
            }
        }
        while self.seen.len()>128 {
            let key=*self.seen.iter().min_by_key(|(_,record)|(record.event.tick,record.event.owner,record.event.order)).unwrap().0;
            self.seen.remove(&key);
        }
        for record in self.seen.values_mut() {
            let Some(actor)=visible.get(&record.event.owner) else {record.retired=true;continue;};
            let network_age=(snapshot.tick.saturating_sub(record.event.tick)) as f64/TICK_RATE as f64;
            let age=(record.age+(now-record.received_at)).max(network_age);
            if !age.is_finite() {return Err("cast presentation age overflow".into());}
            record.age=age;record.received_at=now;
            let events=snapshot.attack_events.iter().filter(|event|event.attack.source==actor.id);
            let highest=events.clone().map(|event|event.sequence).max().unwrap_or(0);
            let newly_started=events.filter(|event|event.sequence>record.last_attack_sequence)
                .any(|event|matches!(event.phase,openleague_core::attack_presentation::Phase::Started{..}));
            if self.finished || !clock_ready || !actor.health.is_finite() || actor.health<=0. || !actor.position.finite()
                || openleague_core::stuns::active(actor,snapshot.tick)
                || openleague_core::trundle_e::champion_forced(actor,snapshot.tick)
                || (record.event.kind==Kind::W && record.claimed_by.is_some() && actor.destination.is_some())
                || (record.event.kind==Kind::W && record.claimed_by.is_some()
                    && (actor.windup.is_some() || newly_started)) {
                record.retired=true;
            }
            // R deliberately does not retire on BA/Q Started: their journals and
            // ages continue while the short R pose masks only their rendering.
            record.last_attack_sequence=record.last_attack_sequence.max(highest);
        }
        let seen=&self.seen;
        self.playing.retain(|owner,id|seen.get(&(*owner,id.order)).is_some_and(|record|!record.retired));
        self.visible=visible.keys().copied().collect();self.ready=clock_ready;
        Ok(())
    }
    /// There is no animation backlog. Select one genuinely eligible fact for
    /// this owner from bounded history; a newer but ineligible W does not hide R.
    pub fn select(&mut self,owner:u32,entity:u64,now:f64,durations:[Option<f32>;2],eligible:[bool;2],clock_ready:bool)->Option<Selection> {
        if !self.supported() || !self.ready || !clock_ready || !now.is_finite() {
            self.retire(owner);return None;
        }
        let mut selected:Option<((u32,u64),f32)>=None;
        for (key,record) in self.seen.iter_mut().filter(|(_,record)|record.event.owner==owner) {
            if record.retired {continue;}
            let slot=if record.event.kind==Kind::W {0}else{1};
            if now<record.received_at {record.retired=true;continue;}
            let age=record.age+(now-record.received_at);
            let duration=durations[slot].filter(|value|value.is_finite() && *value>0.);
            if !age.is_finite() || age<0. || duration.is_some_and(|duration|age>=f64::from(duration)) {
                record.retired=true;continue;
            }
            if duration.is_none() || !eligible[slot] {
                if record.claimed_by.is_some(){record.retired=true;}
                continue;
            }
            if selected.map_or(true,|(old,_)|key.1>old.1) {selected=Some((*key,age as f32));}
        }
        let Some((key,age_seconds))=selected else {
            if let Some(old)=self.playing.remove(&owner) {if let Some(record)=self.seen.get_mut(&(owner,old.order)){record.retired=true;}}
            return None;
        };
        let identity=Identity{session:self.session?,view_team:self.view_team?,owner,order:key.1};
        if let Some(old)=self.playing.get(&owner).copied().filter(|old|*old!=identity) {
            if let Some(record)=self.seen.get_mut(&(owner,old.order)){record.retired=true;}
        }
        // Once this eligible identity is chosen, lower accepted orders are
        // superseded even if they never acquired an AnimationPlayer. They must
        // not appear later when this newer, shorter clip ends.
        for record in self.seen.values_mut().filter(|record|record.event.owner==owner && record.event.order<key.1) {
            record.retired=true;
        }
        let record=self.seen.get_mut(&key)?;
        if record.claimed_by.is_some_and(|old|old!=entity) {record.retired=true;self.playing.remove(&owner);return None;}
        let first=record.claimed_by.is_none();record.claimed_by=Some(entity);
        self.playing.insert(owner,identity);
        Some(Selection{identity,kind:record.event.kind,role:if record.event.kind==Kind::W{"spell2"}else{"spell4"},age_seconds,first})
    }
}
