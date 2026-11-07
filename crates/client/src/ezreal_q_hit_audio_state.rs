//! Local, bounded, at-most-once consumption of server-scoped accepted Q impacts.
//! This channel never infers a hit from health, damage, expiry or disappearance.
use openleague_core::{ezreal_q_accepted_impacts, Point, Snapshot, TICK_RATE};
use std::collections::{BTreeMap, BTreeSet, VecDeque};

pub const MAX_PENDING: usize = 32;
pub const MAX_OWNERS: usize = 6;
// Local presentation policy, not a recovered native audio delivery deadline.
pub const MAX_AGE_TICKS: u64 = 3;
pub const MAX_DELAY: f64 = MAX_AGE_TICKS as f64 / TICK_RATE as f64;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Identity { pub session:u64, pub epoch:u64, pub owner:u32, pub order:u64 }

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Request { pub identity:Identity, pub position:Point, pub received_at:f64, fingerprint:Fingerprint, incarnation:u64 }

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
    authorized:BTreeMap<(u32,u64),Authorization>, next_incarnation:u64,
}
impl State {
    pub fn reset(&mut self,session:u64,viewer:u32) {
        if self.session!=Some(session) || self.viewer!=viewer { *self=Self { session:Some(session),viewer,..Self::default() }; }
        else { self.suspend();self.epoch=0;self.tick=None;self.clock=None;self.visible.clear(); }
    }
    /// Called only by the existing authenticated Welcome/epoch receive path.
    pub fn begin_epoch(&mut self,session:u64,epoch:u64,viewer:u32) {
        if epoch==0 || (self.session==Some(session) && self.viewer==viewer && epoch<=self.epoch) {return;}
        if self.session!=Some(session) || self.viewer!=viewer {self.reset(session,viewer);}
        self.suspend();self.epoch=epoch;self.tick=None;self.clock=None;self.visible.clear();
    }
    pub fn context(&self)->Option<(u64,u64,u32)> {self.session.map(|session|(session,self.epoch,self.viewer))}
    pub fn presentation_ready(&self,now:f64)->bool {
        self.ready && now.is_finite() && self.clock.is_none_or(|previous|now>=previous)
    }
    pub fn suspend(&mut self) {self.pending.clear();self.authorized.clear();self.ready=false;}
    pub fn authorizes(&self,request:&Request)->bool {
        self.session==Some(request.identity.session) && self.epoch==request.identity.epoch
            && self.authorized.get(&(request.identity.owner,request.identity.order)).is_some_and(|authorization|authorization.matches(request))
            && [request.position.x.to_bits(),request.position.z.to_bits()]==request.fingerprint.target_center
    }
    /// Observe every accepted packet before coalescing. Malformed optional data
    /// cannot reject gameplay or partially advance this channel's watermarks.
    pub fn observe_accepted(&mut self,snapshot:&Snapshot,now:f64,clock_ready:bool,paused:bool)->Result<bool,String> {
        if self.viewer==0 || self.session!=Some(snapshot.session) || self.tick.is_some_and(|old|snapshot.tick<old) {return Ok(false);}
        if !now.is_finite() || self.clock.is_some_and(|old|now<old) {
            self.suspend();return Err("Q hit audio clock invalid".into());
        }
        let mut next=self.clone();
        match next.observe_validated(snapshot,now,clock_ready,paused) {
            Ok(())=>{*self=next;Ok(true)},
            Err(error)=>{
                // An invalid optional projection cannot authorize old contact
                // points. Keep consumed orders, revoke only this audio channel.
                self.suspend();self.tick=Some(snapshot.tick);self.clock=Some(now);Err(error)
            }
        }
    }
    fn observe_validated(&mut self,snapshot:&Snapshot,now:f64,clock_ready:bool,paused:bool)->Result<(),String> {
        let events=ezreal_q_accepted_impacts::decode_view(snapshot.ezreal_q_accepted_impacts.as_ref(),snapshot.tick)
            .map_err(|error|format!("Q accepted impact extension: {error:?}"))?;
        let missing_projection=events.is_none();let events=events.unwrap_or_default();
        if snapshot.roster.len()>64 || snapshot.players.len()>64 {return Err("Q audio actor budget exceeded".into());}
        let mut roster=BTreeMap::new();
        for row in &snapshot.roster {
            if row.id==0 || row.team>1 || roster.insert(row.id,(row.champion.as_str(),row.team)).is_some() {
                return Err("Q audio roster invalid".into());
            }
        }
        let owners:BTreeSet<_>=roster.iter().filter(|(_, (name,_))|*name=="ezreal").map(|(&id,_)|id).collect();
        if owners.len()>MAX_OWNERS {return Err("Q audio owner budget exceeded".into());}
        let mut visible=BTreeSet::new();let mut actor_ids=BTreeSet::new();
        for actor in &snapshot.players {
            if actor.id==0 || !actor_ids.insert(actor.id) {return Err("Q audio scene identity duplicated".into());}
            if actor.champion!="ezreal" {continue;}
            if !roster.get(&actor.id).is_some_and(|(name,team)|*name=="ezreal" && *team==actor.team)
                || !visible.insert(actor.id) {return Err("Q audio visible owner invalid".into());}
        }
        for event in &events {
            if !visible.contains(&event.owner) {return Err("Q audio event owner is not canonically visible".into());}
            if self.authorized.get(&(event.owner,event.order)).is_some_and(|old|old.fingerprint!=Fingerprint::of(event)) {
                return Err("Q audio authorized contact identity changed".into());
            }
            if let Some((order,Some(previous)))=self.seen.get(&event.owner) {
                if event.order==*order && Fingerprint::of(event)!=*previous {
                    return Err("Q audio accepted event identity changed".into());
                }
            }
        }
        let mut next=self.clone();
        let baseline=next.tick.is_none() || !next.ready;
        let finished=snapshot.winner.is_some() || snapshot.result.is_some();
        next.seen.retain(|owner,_|owners.contains(owner));
        // A revoked episode cannot authorize an existing Voice after a later
        // reveal in the SAME receive batch. Tokens are local, never on wire.
        let mut current=BTreeMap::new();
        for event in &events {
            let key=(event.owner,event.order);let fingerprint=Fingerprint::of(event);
            let authorization=if let Some(previous)=self.authorized.get(&key) {
                *previous
            }else{
                next.next_incarnation=next.next_incarnation.checked_add(1).ok_or("Q audio authorization incarnation exhausted")?;
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
    /// consumed whether the optional physical voice can be created or not.
    pub fn take(&mut self,now:f64,clock_ready:bool,paused:bool)->Vec<Request> {
        if !clock_ready || !now.is_finite() || self.clock.is_some_and(|old|now<old) {
            self.suspend();return Vec::new();
        }
        self.clock=Some(now);
        let pending=std::mem::take(&mut self.pending);
        if paused || !self.ready {return Vec::new();}
        pending.into_iter().filter(|request|self.authorizes(request) && now>=request.received_at && now-request.received_at<=MAX_DELAY).collect()
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
        let mut state=State::default();state.reset(7,owner);
        state.observe_accepted(&snapshot,1.,true,false).unwrap();(snapshot,owner,state)
    }
    fn event(snapshot:&mut Snapshot,owner:u32,order:u64,tick:u64) {
        snapshot.tick=tick;snapshot.ezreal_q_accepted_impacts=Some(serde_json::json!({"version":1,"events":[{
            "owner":owner,"target":900,"order":order,"tick":tick,
            "projectile_center":{"x":200.,"z":300.},"target_center":{"x":220.,"z":300.}}]}));
    }
    #[test]
    fn accepted_packets_coalesce_without_losing_hits_and_duplicates_never_replay() {
        let (mut snapshot,owner,mut state)=fixture();event(&mut snapshot,owner,1,101);
        state.observe_accepted(&snapshot,1.01,true,false).unwrap();state.observe_accepted(&snapshot,1.01,true,false).unwrap();
        let first=snapshot.ezreal_q_accepted_impacts.as_ref().unwrap()["events"][0].clone();
        event(&mut snapshot,owner,2,102);snapshot.ezreal_q_accepted_impacts.as_mut().unwrap()["events"].as_array_mut().unwrap().insert(0,first);
        state.observe_accepted(&snapshot,1.02,true,false).unwrap();
        let requests=state.take(1.02,true,false);assert_eq!(requests.len(),2);
        assert_eq!(requests.iter().map(|r|r.identity.order).collect::<Vec<_>>(),[1,2]);
        assert_eq!(requests[0].position,Point{x:220.,z:300.});
        state.observe_accepted(&snapshot,1.03,true,false).unwrap();assert!(state.take(1.03,true,false).is_empty());
        snapshot.tick=100;state.observe_accepted(&snapshot,1.04,true,false).unwrap();assert_eq!(state.tick,Some(102));
        // A later accepted projection can revoke only a contact point while
        // retaining the same visible owner. It must cancel before any frame.
        event(&mut snapshot,owner,3,103);state.observe_accepted(&snapshot,1.04,true,false).unwrap();
        let old=snapshot.ezreal_q_accepted_impacts.clone();snapshot.tick=104;
        snapshot.ezreal_q_accepted_impacts=Some(serde_json::json!({"version":1,"events":[]}));
        state.observe_accepted(&snapshot,1.05,true,false).unwrap();assert!(state.take(1.05,true,false).is_empty());
        snapshot.tick=105;snapshot.ezreal_q_accepted_impacts=old;
        state.observe_accepted(&snapshot,1.06,true,false).unwrap();assert!(state.take(1.06,true,false).is_empty());
        event(&mut snapshot,owner,4,106);state.observe_accepted(&snapshot,1.07,true,false).unwrap();
        let old=snapshot.ezreal_q_accepted_impacts.clone();
        snapshot.tick=107;snapshot.ezreal_q_accepted_impacts=None;
        state.observe_accepted(&snapshot,1.08,true,false).unwrap();assert!(state.take(1.08,true,false).is_empty());assert!(!state.ready);
        snapshot.tick=108;snapshot.ezreal_q_accepted_impacts=old;state.observe_accepted(&snapshot,1.09,true,false).unwrap();
        assert!(state.take(1.09,true,false).is_empty());
    }
    #[test]
    fn join_epoch_fow_pause_and_clock_failure_consume_without_deferred_audio() {
        let (mut snapshot,owner,mut state)=fixture();event(&mut snapshot,owner,1,101);
        state.begin_epoch(7,2,owner);state.observe_accepted(&snapshot,1.01,true,false).unwrap();assert!(state.take(1.01,true,false).is_empty());
        snapshot.tick=102;snapshot.players.clear();snapshot.ezreal_q_accepted_impacts=None;
        state.observe_accepted(&snapshot,1.02,true,false).unwrap();
        let (base,_,_)=fixture();snapshot.players=base.players;event(&mut snapshot,owner,2,103);
        state.observe_accepted(&snapshot,1.03,true,false).unwrap();assert!(state.take(1.03,true,false).is_empty());
        event(&mut snapshot,owner,3,104);state.observe_accepted(&snapshot,1.03,true,true).unwrap();
        assert!(state.take(1.03,true,false).is_empty());
        event(&mut snapshot,owner,4,105);state.observe_accepted(&snapshot,1.04,true,false).unwrap();
        assert!(state.take(1.04,false,false).is_empty());
        state.observe_accepted(&snapshot,1.05,true,false).unwrap();assert!(state.take(1.05,true,false).is_empty());
        event(&mut snapshot,owner,5,106);state.observe_accepted(&snapshot,1.06,true,false).unwrap();
        assert_eq!(state.take(1.06,true,false)[0].identity.epoch,2);
        state.reset(8,owner);assert!(state.take(1.07,true,false).is_empty());assert_eq!(state.context(),Some((8,0,owner)));
        state.reset(8,99);assert!(state.seen.is_empty());assert_eq!(state.context(),Some((8,0,99)));
    }
    #[test]
    fn malformed_or_conflicting_extensions_are_atomic_and_missing_extension_is_silent() {
        let (mut snapshot,owner,mut state)=fixture();event(&mut snapshot,owner,1,101);
        state.observe_accepted(&snapshot,1.01,true,false).unwrap();state.take(1.01,true,false);let before=state.clone();
        snapshot.ezreal_q_accepted_impacts.as_mut().unwrap()["events"][0]["target_center"]["x"]=serde_json::json!(221.);
        assert!(state.observe_accepted(&snapshot,1.02,true,false).is_err());
        assert_eq!(state.seen,before.seen);assert_eq!(state.tick,before.tick);assert!(!state.ready && state.authorized.is_empty() && state.pending.is_empty());
        snapshot.ezreal_q_accepted_impacts=Some(serde_json::json!({"version":999,"events":[]}));
        assert!(state.observe_accepted(&snapshot,1.02,true,false).is_err());assert_eq!(state.seen,before.seen);assert!(!state.ready);
        snapshot.tick=102;snapshot.ezreal_q_accepted_impacts=None;state.observe_accepted(&snapshot,1.02,true,false).unwrap();
        assert!(state.take(1.02,true,false).is_empty());
    }
    #[test]
    fn queue_freshness_and_owner_budgets_bound_optional_presentation() {
        let (mut snapshot,owner,mut state)=fixture();
        // Real projected rings keep the latest 32 facts; older evicted facts
        // revoke pending sound, rather than accumulating across packet batches.
        for order in 1..=40 {
            let mut ring=snapshot.ezreal_q_accepted_impacts.as_ref().map(|v|v["events"].as_array().unwrap().clone()).unwrap_or_default();
            event(&mut snapshot,owner,order,101);ring.push(snapshot.ezreal_q_accepted_impacts.as_ref().unwrap()["events"][0].clone());
            if ring.len()>MAX_PENDING {ring.remove(0);}
            snapshot.ezreal_q_accepted_impacts.as_mut().unwrap()["events"]=serde_json::Value::Array(ring);
            state.observe_accepted(&snapshot,1.01,true,false).unwrap();
        }
        assert_eq!(state.pending.len(),MAX_PENDING);assert_eq!(state.authorized.len(),MAX_PENDING);assert_eq!(state.seen.len(),1);
        assert!(state.take(2.,true,false).is_empty());
        event(&mut snapshot,owner,41,102);state.observe_accepted(&snapshot,2.01,true,false).unwrap();
        snapshot.tick=106;state.take(2.01,true,false);event(&mut snapshot,owner,42,102);snapshot.tick=106;
        state.observe_accepted(&snapshot,2.02,true,false).unwrap();assert!(state.take(2.02,true,false).is_empty());
        let before=state.clone();let row=snapshot.roster[0].clone();
        for index in 0..6 {let mut added=row.clone();added.id=100+index;snapshot.roster.push(added);}
        assert!(state.observe_accepted(&snapshot,2.03,true,false).is_err());assert_eq!(state.seen,before.seen);assert!(state.authorized.is_empty());
        snapshot.roster.clear();snapshot.players.clear();snapshot.ezreal_q_accepted_impacts=None;
        state.observe_accepted(&snapshot,2.03,true,false).unwrap();assert!(state.seen.is_empty());
        let (mut snapshot,owner,mut exhausted)=fixture();exhausted.next_incarnation=u64::MAX;
        let seen=exhausted.seen.clone();event(&mut snapshot,owner,1,101);
        assert!(exhausted.observe_accepted(&snapshot,1.01,true,false).is_err());
        assert_eq!(exhausted.seen,seen);assert!(!exhausted.ready && exhausted.pending.is_empty() && exhausted.authorized.is_empty());
    }
}
