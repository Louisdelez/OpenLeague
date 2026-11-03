//! Local, bounded, at-most-once consumption of server-scoped accepted Q impacts.
//! Its queue and current authorization are independent of all audio consumers.
//! A paused current flash may retain authorization; take discards paused births.
//! This channel never infers a hit from health, damage, expiry or disappearance.
use openleague_core::{ezreal_q_accepted_impacts, session_transport::Context, Point, Snapshot, TICK_RATE};
use std::collections::{BTreeMap, BTreeSet, VecDeque};

pub const MAX_PENDING: usize = 32;
pub const MAX_OWNERS: usize = 6;
// Local presentation policy, not a recovered native VFX delivery deadline.
pub const MAX_AGE_TICKS: u64 = 3;
pub const MAX_DELAY: f64 = MAX_AGE_TICKS as f64 / TICK_RATE as f64;

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct Identity { pub session:u64, pub epoch:u64, pub owner:u32, pub order:u64 }

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Request { pub identity:Identity, pub position:Point, pub received_at:f64, fingerprint:Fingerprint, incarnation:u64 }
impl Request { pub(crate) fn incarnation(&self)->u64 { self.incarnation } }

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Fingerprint { target:u32, tick:u64, projectile:[u32;2], target_center:[u32;2] }
impl Fingerprint {
    fn of(event:&ezreal_q_accepted_impacts::Event)->Self {
        Self { target:event.target, tick:event.tick,
            projectile:[event.projectile_center.x.to_bits(),event.projectile_center.z.to_bits()],
            target_center:[event.target_center.x.to_bits(),event.target_center.z.to_bits()] }
    }
}
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
struct Authorization { fingerprint:Fingerprint, incarnation:u64 }
impl Authorization {
    fn matches(&self,request:&Request)->bool {
        self.fingerprint==request.fingerprint && self.incarnation==request.incarnation
    }
}

#[derive(Clone, Debug, Default, PartialEq)]
pub struct State {
    session:Option<u64>, viewer:u32, epoch:u64, tick:Option<u64>, clock:Option<f64>, ready:bool,
    seen:BTreeMap<u32,(u64,Option<Fingerprint>)>, visible:BTreeSet<u32>, pending:VecDeque<Request>,
    authorized:BTreeMap<(u32,u64),Authorization>, next_incarnation:u64, last_frame:Option<u64>,
}
impl State {
    pub fn reset(&mut self,session:u64,viewer:u32) {
        if self.session!=Some(session) || self.viewer!=viewer { *self=Self { session:Some(session),viewer,..Self::default() }; }
        else { self.suspend();self.epoch=0;self.last_frame=None;self.tick=None;self.clock=None;self.visible.clear(); }
    }
    /// Called only by the existing authenticated Welcome/epoch receive path.
    pub fn begin_epoch(&mut self,session:u64,epoch:u64,viewer:u32) {
        if epoch==0 || (self.session==Some(session) && self.viewer==viewer && epoch<=self.epoch) {return;}
        if self.session!=Some(session) || self.viewer!=viewer {self.reset(session,viewer);}
        self.suspend();self.epoch=epoch;self.last_frame=None;self.tick=None;self.clock=None;self.visible.clear();
    }
    pub fn context(&self)->Option<(u64,u64,u32)> {self.session.map(|session|(session,self.epoch,self.viewer))}
    pub fn presentation_ready(&self,now:f64)->bool {
        self.epoch!=0 && self.ready && now.is_finite() && self.clock.is_none_or(|previous|now>=previous)
    }
    pub fn suspend(&mut self) {self.pending.clear();self.authorized.clear();self.ready=false;}
    pub fn authorizes(&self,request:&Request)->bool {
        self.session==Some(request.identity.session) && self.epoch==request.identity.epoch
            && self.authorized.get(&(request.identity.owner,request.identity.order)).is_some_and(|authorization|authorization.matches(request))
            && [request.position.x.to_bits(),request.position.z.to_bits()]==request.fingerprint.target_center
    }
    /// Observe every accepted packet before coalescing. Malformed optional data
    /// cannot reject gameplay or partially advance this channel's watermarks.
    pub fn observe_accepted_frame(&mut self,snapshot:&Snapshot,now:f64,clock_ready:bool,paused:bool,
        delivery:Option<(Context,u64)>)->Result<bool,String> {
        let Some((context,frame))=delivery else {
            // OLST is deliberately silent, including a forged optional Q value.
            self.suspend();return Ok(false);
        };
        if !context.valid() || self.context()!=Some((context.session,context.epoch,context.player))
            || context.session!=snapshot.session || frame==0 {
            self.suspend();return Err("Q flash VFX OLSR context invalid".into());
        }
        if self.last_frame.is_some_and(|old|frame<=old) || self.tick.is_some_and(|old|snapshot.tick<old) {
            self.suspend();return Ok(false);
        }
        // Consume this exact accepted delivery even if its optional body fails.
        // A malformed frame cannot later be repaired/replayed at the same ID.
        self.last_frame=Some(frame);
        self.observe_accepted_inner(snapshot,now,clock_ready,paused)
    }
    fn observe_accepted_inner(&mut self,snapshot:&Snapshot,now:f64,clock_ready:bool,paused:bool)->Result<bool,String> {
        if self.viewer==0 || self.session!=Some(snapshot.session) || self.tick.is_some_and(|old|snapshot.tick<old) {return Ok(false);}
        if !now.is_finite() || self.clock.is_some_and(|old|now<old) {
            self.suspend();return Err("Q flash VFX clock invalid".into());
        }
        let mut next=self.clone();
        match next.observe_validated(snapshot,now,clock_ready,paused) {
            Ok(())=>{*self=next;Ok(true)},
            Err(error)=>{
                // An invalid optional projection cannot authorize old contact
                // points. Keep consumed orders, revoke only this VFX channel.
                self.suspend();self.tick=Some(snapshot.tick);self.clock=Some(now);Err(error)
            }
        }
    }
    fn observe_validated(&mut self,snapshot:&Snapshot,now:f64,clock_ready:bool,paused:bool)->Result<(),String> {
        let events=ezreal_q_accepted_impacts::decode_view(snapshot.ezreal_q_accepted_impacts.as_ref(),snapshot.tick)
            .map_err(|error|format!("Q accepted impact extension: {error:?}"))?;
        let missing_projection=events.is_none();let events=events.unwrap_or_default();
        if snapshot.roster.len()>64 || snapshot.players.len()>64 {return Err("Q flash VFX actor budget exceeded".into());}
        let mut roster=BTreeMap::new();
        for row in &snapshot.roster {
            if row.id==0 || row.team>1 || roster.insert(row.id,(row.champion.as_str(),row.team)).is_some() {
                return Err("Q flash VFX roster invalid".into());
            }
        }
        let owners:BTreeSet<_>=roster.iter().filter(|(_, (name,_))|*name=="ezreal").map(|(&id,_)|id).collect();
        if owners.len()>MAX_OWNERS {return Err("Q flash VFX owner budget exceeded".into());}
        let mut visible=BTreeSet::new();let mut actor_ids=BTreeSet::new();
        for actor in &snapshot.players {
            if actor.id==0 || !actor_ids.insert(actor.id) {return Err("Q flash VFX scene identity duplicated".into());}
            if actor.champion!="ezreal" {continue;}
            if !roster.get(&actor.id).is_some_and(|(name,team)|*name=="ezreal" && *team==actor.team)
                || !visible.insert(actor.id) {return Err("Q flash VFX visible owner invalid".into());}
        }
        for event in &events {
            if !visible.contains(&event.owner) {return Err("Q flash VFX event owner is not canonically visible".into());}
            if self.authorized.get(&(event.owner,event.order)).is_some_and(|old|old.fingerprint!=Fingerprint::of(event)) {
                return Err("Q flash VFX authorized contact identity changed".into());
            }
            if let Some((order,Some(previous)))=self.seen.get(&event.owner) {
                if event.order==*order && Fingerprint::of(event)!=*previous {
                    return Err("Q flash VFX accepted event identity changed".into());
                }
            }
        }
        let mut next=self.clone();
        let baseline=next.tick.is_none() || !next.ready;
        let finished=snapshot.winner.is_some() || snapshot.result.is_some();
        next.seen.retain(|owner,_|owners.contains(owner));
        // A revoked episode cannot authorize an existing Flash after a later
        // reveal in the SAME receive batch. Tokens are local, never on wire.
        let mut current=BTreeMap::new();
        for event in &events {
            let key=(event.owner,event.order);let fingerprint=Fingerprint::of(event);
            let authorization=if let Some(previous)=self.authorized.get(&key) {
                *previous
            }else{
                next.next_incarnation=next.next_incarnation.checked_add(1).ok_or("Q flash VFX authorization incarnation exhausted")?;
                Authorization {fingerprint,incarnation:next.next_incarnation}
            };
            current.insert(key,authorization);
        }
        next.authorized=current;
        let authorized=&next.authorized;
        next.pending.retain(|request|authorized.get(&(request.identity.owner,request.identity.order)).is_some_and(|authorization|authorization.matches(request))
            && visible.contains(&request.identity.owner)
            && now>=request.received_at && now-request.received_at<=MAX_DELAY);
        for &owner in &owners {next.seen.entry(owner).or_insert((0,None));}
        for event in events {
            let entry=next.seen.get_mut(&event.owner).expect("visible canonical owner has roster slot");
            if event.order<=entry.0 {continue;}
            *entry=(event.order,Some(Fingerprint::of(&event)));
            if baseline || !self.visible.contains(&event.owner) || !clock_ready || paused || finished
                || snapshot.tick.saturating_sub(event.tick)>MAX_AGE_TICKS
                || self.tick.is_some_and(|old|event.tick<old) || next.pending.len()==MAX_PENDING {continue;}
            // Frozen target center is an explicit local anchor choice. No lookup
            // of a killed target or replacement entity and no native bone claim.
            let incarnation=next.authorized[&(event.owner,event.order)].incarnation;
            next.pending.push_back(Request { identity:Identity { session:snapshot.session,epoch:next.epoch,
                owner:event.owner,order:event.order }, position:event.target_center,received_at:now,fingerprint:Fingerprint::of(&event),incarnation });
        }
        if !clock_ready || paused || finished {next.pending.clear();}
        next.visible=visible;next.tick=Some(snapshot.tick);next.clock=Some(now);next.ready=clock_ready && !finished && !missing_projection;
        if !clock_ready || finished {next.suspend();}
        *self=next;Ok(())
    }
    /// A missing backend/asset never creates a retry queue. Taken requests are
    /// consumed whether the optional physical quad can be created or not.
    pub fn take(&mut self,now:f64,clock_ready:bool,paused:bool)->Vec<Request> {
        if !clock_ready || !now.is_finite() || self.clock.is_some_and(|old|now<old) {
            self.suspend();return Vec::new();
        }
        self.clock=Some(now);
        let pending=std::mem::take(&mut self.pending);
        if paused || self.epoch==0 || !self.ready {return Vec::new();}
        pending.into_iter().filter(|request|self.authorizes(request) && now>=request.received_at && now-request.received_at<=MAX_DELAY).collect()
    }
}

#[cfg(test)]
impl State {
    pub(crate) fn observe_test_frame(&mut self,snapshot:&Snapshot,now:f64,ready:bool,paused:bool)->Result<bool,String> {
        let (session,epoch,player)=self.context().expect("fixture has an admitted OLSR epoch");
        let frame=self.last_frame.unwrap_or(0).checked_add(1).expect("fixture frame does not overflow");
        self.observe_accepted_frame(snapshot,now,ready,paused,Some((Context{session,epoch,player},frame)))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use openleague_core::{Navigation,Simulation};
    fn fixture()->(Snapshot,u32,State) {
        let mut cells=Vec::new();for _ in 0..400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
        let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap();
        let mut game=Simulation::new(nav).unwrap();game.session=7;game.tick=100;let owner=game.join("ezreal").unwrap();
        let mut snapshot=game.snapshot();snapshot.ezreal_q_accepted_impacts=Some(serde_json::json!({"version":1,"events":[]}));
        let mut state=State::default();state.reset(7,owner);state.begin_epoch(7,1,owner);
        state.observe_test_frame(&snapshot,1.,true,false).unwrap();(snapshot,owner,state)
    }
    fn event(snapshot:&mut Snapshot,owner:u32,order:u64,tick:u64) {
        snapshot.tick=tick;snapshot.ezreal_q_accepted_impacts=Some(serde_json::json!({"version":1,"events":[{
            "owner":owner,"target":900,"order":order,"tick":tick,
            "projectile_center":{"x":200.,"z":300.},"target_center":{"x":220.,"z":300.}}]}));
    }
    #[test]
    fn accepted_packets_coalesce_without_losing_hits_and_duplicates_never_replay() {
        let (mut snapshot,owner,mut state)=fixture();event(&mut snapshot,owner,1,101);
        state.observe_test_frame(&snapshot,1.01,true,false).unwrap();state.observe_test_frame(&snapshot,1.01,true,false).unwrap();
        let first=snapshot.ezreal_q_accepted_impacts.as_ref().unwrap()["events"][0].clone();
        event(&mut snapshot,owner,2,102);snapshot.ezreal_q_accepted_impacts.as_mut().unwrap()["events"].as_array_mut().unwrap().insert(0,first);
        state.observe_test_frame(&snapshot,1.02,true,false).unwrap();
        let requests=state.take(1.02,true,false);assert_eq!(requests.len(),2);
        assert_eq!(requests.iter().map(|r|r.identity.order).collect::<Vec<_>>(),[1,2]);
        assert_eq!(requests[0].position,Point{x:220.,z:300.});
        state.observe_test_frame(&snapshot,1.03,true,false).unwrap();assert!(state.take(1.03,true,false).is_empty());
        snapshot.tick=100;state.observe_test_frame(&snapshot,1.04,true,false).unwrap();assert_eq!(state.tick,Some(102));
        // A later accepted projection can revoke only a contact point while
        // retaining the same visible owner. It must cancel before any frame.
        event(&mut snapshot,owner,3,103);state.observe_test_frame(&snapshot,1.04,true,false).unwrap();
        let old=snapshot.ezreal_q_accepted_impacts.clone();snapshot.tick=104;
        snapshot.ezreal_q_accepted_impacts=Some(serde_json::json!({"version":1,"events":[]}));
        state.observe_test_frame(&snapshot,1.05,true,false).unwrap();assert!(state.take(1.05,true,false).is_empty());
        snapshot.tick=105;snapshot.ezreal_q_accepted_impacts=old;
        state.observe_test_frame(&snapshot,1.06,true,false).unwrap();assert!(state.take(1.06,true,false).is_empty());
        event(&mut snapshot,owner,4,106);state.observe_test_frame(&snapshot,1.07,true,false).unwrap();
        let old=snapshot.ezreal_q_accepted_impacts.clone();
        snapshot.tick=107;snapshot.ezreal_q_accepted_impacts=None;
        state.observe_test_frame(&snapshot,1.08,true,false).unwrap();assert!(state.take(1.08,true,false).is_empty());assert!(!state.ready);
        snapshot.tick=108;snapshot.ezreal_q_accepted_impacts=old;state.observe_test_frame(&snapshot,1.09,true,false).unwrap();
        assert!(state.take(1.09,true,false).is_empty());
    }
    #[test]
    fn join_epoch_fow_pause_and_clock_failure_consume_without_deferred_flash() {
        let (mut snapshot,owner,mut state)=fixture();event(&mut snapshot,owner,1,101);
        state.begin_epoch(7,2,owner);state.observe_test_frame(&snapshot,1.01,true,false).unwrap();assert!(state.take(1.01,true,false).is_empty());
        snapshot.tick=102;snapshot.players.clear();snapshot.ezreal_q_accepted_impacts=None;
        state.observe_test_frame(&snapshot,1.02,true,false).unwrap();
        let (base,_,_)=fixture();snapshot.players=base.players;event(&mut snapshot,owner,2,103);
        state.observe_test_frame(&snapshot,1.03,true,false).unwrap();assert!(state.take(1.03,true,false).is_empty());
        event(&mut snapshot,owner,3,104);state.observe_test_frame(&snapshot,1.03,true,true).unwrap();
        assert!(state.take(1.03,true,false).is_empty());
        event(&mut snapshot,owner,4,105);state.observe_test_frame(&snapshot,1.04,true,false).unwrap();
        assert!(state.take(1.04,false,false).is_empty());
        state.observe_test_frame(&snapshot,1.05,true,false).unwrap();assert!(state.take(1.05,true,false).is_empty());
        event(&mut snapshot,owner,5,106);state.observe_test_frame(&snapshot,1.06,true,false).unwrap();
        assert_eq!(state.take(1.06,true,false)[0].identity.epoch,2);
        state.reset(8,owner);assert!(state.take(1.07,true,false).is_empty());assert_eq!(state.context(),Some((8,0,owner)));
        state.reset(8,99);assert!(state.seen.is_empty());assert_eq!(state.context(),Some((8,0,99)));
    }
    #[test]
    fn malformed_or_conflicting_extensions_are_atomic_and_missing_extension_is_silent() {
        let (mut snapshot,owner,mut state)=fixture();event(&mut snapshot,owner,1,101);
        state.observe_test_frame(&snapshot,1.01,true,false).unwrap();state.take(1.01,true,false);let before=state.clone();
        snapshot.ezreal_q_accepted_impacts.as_mut().unwrap()["events"][0]["target_center"]["x"]=serde_json::json!(221.);
        assert!(state.observe_test_frame(&snapshot,1.02,true,false).is_err());
        assert_eq!(state.seen,before.seen);assert_eq!(state.tick,before.tick);assert!(!state.ready && state.authorized.is_empty() && state.pending.is_empty());
        snapshot.ezreal_q_accepted_impacts=Some(serde_json::json!({"version":999,"events":[]}));
        assert!(state.observe_test_frame(&snapshot,1.02,true,false).is_err());assert_eq!(state.seen,before.seen);assert!(!state.ready);
        snapshot.tick=102;snapshot.ezreal_q_accepted_impacts=None;state.observe_test_frame(&snapshot,1.02,true,false).unwrap();
        assert!(state.take(1.02,true,false).is_empty());
    }
    #[test]
    fn queue_freshness_and_owner_budgets_bound_optional_presentation() {
        let (mut snapshot,owner,mut state)=fixture();
        // Real projected rings keep the latest 32 facts; older evicted facts
        // revoke pending flashes, rather than accumulating across packet batches.
        for order in 1..=40 {
            let mut ring=snapshot.ezreal_q_accepted_impacts.as_ref().map(|v|v["events"].as_array().unwrap().clone()).unwrap_or_default();
            event(&mut snapshot,owner,order,101);ring.push(snapshot.ezreal_q_accepted_impacts.as_ref().unwrap()["events"][0].clone());
            if ring.len()>MAX_PENDING {ring.remove(0);}
            snapshot.ezreal_q_accepted_impacts.as_mut().unwrap()["events"]=serde_json::Value::Array(ring);
            state.observe_test_frame(&snapshot,1.01,true,false).unwrap();
        }
        assert_eq!(state.pending.len(),MAX_PENDING);assert_eq!(state.authorized.len(),MAX_PENDING);assert_eq!(state.seen.len(),1);
        assert!(state.take(2.,true,false).is_empty());
        event(&mut snapshot,owner,41,102);state.observe_test_frame(&snapshot,2.01,true,false).unwrap();
        snapshot.tick=106;state.take(2.01,true,false);event(&mut snapshot,owner,42,102);snapshot.tick=106;
        state.observe_test_frame(&snapshot,2.02,true,false).unwrap();assert!(state.take(2.02,true,false).is_empty());
        let before=state.clone();let row=snapshot.roster[0].clone();
        for index in 0..6 {let mut added=row.clone();added.id=100+index;snapshot.roster.push(added);}
        assert!(state.observe_test_frame(&snapshot,2.03,true,false).is_err());assert_eq!(state.seen,before.seen);assert!(state.authorized.is_empty());
        snapshot.roster.clear();snapshot.players.clear();snapshot.ezreal_q_accepted_impacts=None;
        state.observe_test_frame(&snapshot,2.03,true,false).unwrap();assert!(state.seen.is_empty());
        let (mut snapshot,owner,mut exhausted)=fixture();exhausted.next_incarnation=u64::MAX;
        let seen=exhausted.seen.clone();event(&mut snapshot,owner,1,101);
        assert!(exhausted.observe_test_frame(&snapshot,1.01,true,false).is_err());
        assert_eq!(exhausted.seen,seen);assert!(!exhausted.ready && exhausted.pending.is_empty() && exhausted.authorized.is_empty());
    }
    #[test]
    fn real_q_acceptance_shield_lethal_and_miss_drive_only_their_frozen_facts() {
        use openleague_core::Action;
        for case in 0..4 {
        let mut cells=Vec::new();for _ in 0..6400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
        let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&cells).unwrap();
        let mut game=Simulation::new(nav).unwrap();game.session=420;
        let owner=game.join("ezreal").unwrap();let target=game.join("garen").unwrap();
        for (id,x,team) in [(owner,200.,0),(target,600.,1)] {
            let actor=game.players.get_mut(&id).unwrap();actor.team=team;actor.position=Point{x,z:300.};
            actor.health=10000.;actor.max_health=10000.;actor.mana=2000.;actor.level=6;
        }
        game.players.get_mut(&owner).unwrap().ranks=[1,0,0,0];
        // These are public fixture inputs; no private journal or synthetic hit injection.
        match case {
            1=>game.grant_shield(target,"Q flash fixture",10000.,100).unwrap(),
            2=>game.players.get_mut(&target).unwrap().health=1.,
            3=>game.players.get_mut(&target).unwrap().position.x=1800.,
            _=>{},
        }
        let context=Context{session:420,epoch:9,player:owner};let mut channel=State::default();
        channel.begin_epoch(420,9,owner);
        let first=game.snapshot_for_atomic(owner).unwrap();
        assert!(first.ezreal_q_accepted_impacts.is_some());
        channel.observe_accepted_frame(&first,1.,true,false,Some((context,1))).unwrap();
        game.command(owner,Action::CastAt{slot:0,point:Point{x:600.,z:300.}}).unwrap();
        let mut flashes=Vec::new();let mut accepted=Vec::new();
        for frame in 2..=41 {
            game.advance();let snapshot=game.snapshot_for_atomic(owner).unwrap();
            let before=serde_json::to_value(&snapshot).unwrap();let now=1.+game.tick as f64/TICK_RATE as f64;
            let events=ezreal_q_accepted_impacts::decode_view(snapshot.ezreal_q_accepted_impacts.as_ref(),snapshot.tick).unwrap().unwrap();
            for event in events {if !accepted.contains(&event) {accepted.push(event);}}
            channel.observe_accepted_frame(&snapshot,now,true,false,Some((context,frame))).unwrap();
            flashes.extend(channel.take(now,true,false));
            assert_eq!(serde_json::to_value(&snapshot).unwrap(),before);
        }
        if case==3 {assert!(accepted.is_empty());assert!(flashes.is_empty());continue;}
        if case==1 {assert_eq!(game.players[&target].health,10000.);assert!(game.players[&target].shields[0].remaining<10000.);}
        else if case==2 {assert_eq!(game.players[&target].health,0.);}
        else {assert!(game.players[&target].health<10000.);}
        assert_eq!(accepted.len(),1);assert_eq!(flashes.len(),1);
        assert_eq!((accepted[0].owner,accepted[0].target),(owner,target));
        assert_eq!(flashes[0].position,accepted[0].target_center);
        assert_eq!(flashes[0].identity,Identity{session:420,epoch:9,owner,order:accepted[0].order});
        assert!(game.snapshot().ezreal_q_accepted_impacts.is_none());
        // Q facts intentionally remain in the historical team-scoped projection.
        // OLSR-only admission belongs to this VFX consumer, not to snapshot_for.
        let legacy=game.snapshot_for(owner).unwrap();
        let atomic=game.snapshot_for_atomic(owner).unwrap();
        assert_eq!(legacy.ezreal_q_accepted_impacts,atomic.ezreal_q_accepted_impacts);
        assert_eq!(ezreal_q_accepted_impacts::decode_view(legacy.ezreal_q_accepted_impacts.as_ref(),legacy.tick)
            .unwrap().unwrap(),accepted);
        assert!(channel.authorizes(&flashes[0]));
        let now=1.+game.tick as f64/TICK_RATE as f64;
        assert!(!channel.observe_accepted_frame(&legacy,now,true,false,None).unwrap());
        assert!(!channel.authorizes(&flashes[0]));
        assert!(!channel.presentation_ready(now));
        assert!(channel.take(now,true,false).is_empty());
        }
    }
    #[test]
    fn only_exact_olsr_delivery_authorizes_and_legacy_gaps_revoke_before_coalescing() {
        for case in 0..7 {
            let (mut snapshot,owner,mut state)=fixture();event(&mut snapshot,owner,1,101);
            state.observe_test_frame(&snapshot,1.01,true,false).unwrap();
            let request=state.take(1.01,true,false).pop().unwrap();assert!(state.authorizes(&request));
            let good=Context{session:7,epoch:1,player:owner};let current=state.last_frame.unwrap();
            let delivery=match case {
                0=>None,1=>Some((good,0)),2=>Some((Context{epoch:2,..good},current+1)),
                3=>Some((Context{session:8,..good},current+1)),4=>Some((Context{player:owner+1,..good},current+1)),
                5=>Some((good,current)),_=>Some((good,current-1)),
            };
            let result=state.observe_accepted_frame(&snapshot,1.01,true,false,delivery);
            assert_eq!(result.is_err(),(1..=4).contains(&case));
            assert!(!state.authorizes(&request));assert!(!state.presentation_ready(1.01));
            // A later valid reveal in the same frame batch establishes a new
            // episode, but cannot replay a consumed or legacy-only contact.
            state.observe_accepted_frame(&snapshot,1.01,true,false,Some((good,current+2))).unwrap();
            assert!(!state.authorizes(&request));assert!(state.take(1.01,true,false).is_empty());
            event(&mut snapshot,owner,2,102);
            state.observe_accepted_frame(&snapshot,1.02,true,false,Some((good,current+3))).unwrap();
            assert_eq!(state.take(1.02,true,false).len(),1);
        }
    }
    #[test]
    fn full_u64_context_orders_and_frames_survive_and_reconnection_baselines_old_hits() {
        let (mut snapshot,owner,_)=fixture();snapshot.session=u64::MAX-5;
        let context=Context{session:snapshot.session,epoch:u64::MAX-3,player:owner};
        let mut state=State::default();state.begin_epoch(context.session,context.epoch,owner);
        state.observe_accepted_frame(&snapshot,1.,true,false,Some((context,u64::MAX-4))).unwrap();
        event(&mut snapshot,owner,u64::MAX-2,101);
        let wire=serde_json::to_vec(&snapshot).unwrap();let snapshot:Snapshot=serde_json::from_slice(&wire).unwrap();
        state.observe_accepted_frame(&snapshot,1.01,true,false,Some((context,u64::MAX-3))).unwrap();
        let played=state.take(1.01,true,false);assert_eq!(played.len(),1);
        assert_eq!(played[0].identity,Identity{session:context.session,epoch:context.epoch,owner,order:u64::MAX-2});
        let next=Context{epoch:context.epoch+1,..context};state.begin_epoch(next.session,next.epoch,owner);
        assert!(!state.authorizes(&played[0]));
        state.observe_accepted_frame(&snapshot,1.02,true,false,Some((next,1))).unwrap();
        assert!(state.take(1.02,true,false).is_empty());
        let mut fresh=snapshot.clone();event(&mut fresh,owner,u64::MAX-1,102);
        state.observe_accepted_frame(&fresh,1.03,true,false,Some((next,2))).unwrap();
        assert_eq!(state.take(1.03,true,false)[0].identity.epoch,next.epoch);
    }
    #[test]
    fn invalid_optional_body_consumes_frame_and_cannot_be_repaired_at_same_ordinal() {
        let (mut snapshot,owner,mut state)=fixture();let context=Context{session:7,epoch:1,player:owner};
        event(&mut snapshot,owner,1,101);let good=snapshot.clone();
        snapshot.ezreal_q_accepted_impacts.as_mut().unwrap()["version"]=serde_json::json!(99);
        assert!(state.observe_accepted_frame(&snapshot,1.01,true,false,Some((context,2))).is_err());
        assert_eq!(state.last_frame,Some(2));assert!(state.authorized.is_empty());
        assert_eq!(state.observe_accepted_frame(&good,1.01,true,false,Some((context,2))),Ok(false));
        assert!(state.take(1.01,true,false).is_empty());
        state.observe_accepted_frame(&good,1.02,true,false,Some((context,3))).unwrap();
        assert!(state.take(1.02,true,false).is_empty());
        let mut fresh=good;event(&mut fresh,owner,2,102);
        state.observe_accepted_frame(&fresh,1.03,true,false,Some((context,4))).unwrap();
        assert_eq!(state.take(1.03,true,false).len(),1);
    }

}

#[cfg(test)]
pub(crate) fn test_fixture(position:[f32;2])->(Snapshot,u32,State) {
    // Explicit codec fixture, not a native/authoritative contact claim.
    let mut cells=Vec::new();for _ in 0..400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
    let nav=openleague_core::Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap();
    let mut game=openleague_core::Simulation::new(nav).unwrap();game.session=7;game.tick=100;let owner=game.join("ezreal").unwrap();
    let mut snapshot=game.snapshot();snapshot.ezreal_q_accepted_impacts=Some(serde_json::json!({"version":1,"events":[]}));
    let mut state=State::default();state.begin_epoch(7,1,owner);state.observe_test_frame(&snapshot,1.,true,false).unwrap();
    snapshot.tick=101;snapshot.ezreal_q_accepted_impacts=Some(serde_json::json!({"version":1,"events":[{
        "owner":owner,"target":900,"order":1,"tick":101,
        "projectile_center":{"x":position[0]-1.,"z":position[1]},"target_center":{"x":position[0],"z":position[1]}}]}));
    state.observe_test_frame(&snapshot,1.01,true,false).unwrap();(snapshot,owner,state)
}
