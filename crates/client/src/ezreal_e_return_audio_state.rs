//! Local, bounded, at-most-once consumption of server-scoped E Arrival facts.
//! Its watermarks and queue are independent of VFX. Only Arrival can sound.
//! Pause or authority loss retires a one-shot permanently; there is no resume.
//! This channel never infers a blink from actor motion or a missile birth.
use openleague_core::{ezreal_e_accepted_releases, session_transport::Context, Point, Snapshot, TICK_RATE};
use std::collections::{BTreeMap, BTreeSet, VecDeque};

pub const MAX_PENDING: usize = 32;
pub const POLICY: &str = "local_e_arrival_return_audio_v1";
pub const MAX_OWNERS: usize = 6;
// Local presentation policy, not a recovered native audio delivery deadline.
pub const MAX_AGE_TICKS: u64 = 3;
pub const MAX_DELAY: f64 = MAX_AGE_TICKS as f64 / TICK_RATE as f64;

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct Identity { pub session:u64, pub epoch:u64, pub viewer:u32, pub owner:u32, pub order:u64 }

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Request { pub identity:Identity, pub position:Point, pub received_at:f64, pub(crate) variant:usize, fingerprint:Fingerprint, incarnation:u64 }

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Fingerprint { phase:ezreal_e_accepted_releases::Phase, tick:u64, position:[u32;2] }
impl Fingerprint {
    fn of(event:&ezreal_e_accepted_releases::Event)->Self {
        Self {phase:event.phase,tick:event.tick,position:[event.position.x.to_bits(),event.position.z.to_bits()]}
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
    authorized:BTreeMap<(u32,u64),Authorization>, next_incarnation:u64, last_frame:Option<u64>, next_variant:u8,
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
        self.session==Some(request.identity.session) && self.epoch==request.identity.epoch && self.viewer==request.identity.viewer
            && request.fingerprint.phase==ezreal_e_accepted_releases::Phase::Arrival
            && self.authorized.get(&(request.identity.owner,request.identity.order)).is_some_and(|authorization|authorization.matches(request))
            && [request.position.x.to_bits(),request.position.z.to_bits()]==request.fingerprint.position
    }
    /// Observe every accepted packet before coalescing. Malformed optional data
    /// cannot reject gameplay or partially advance this channel's watermarks.
    pub fn observe_accepted_frame(&mut self,snapshot:&Snapshot,now:f64,clock_ready:bool,paused:bool,
        delivery:Option<(Context,u64)>)->Result<bool,String> {
        let Some((context,frame))=delivery else {
            // OLST is deliberately silent, including a forged optional E value.
            self.suspend();return Ok(false);
        };
        if !context.valid() || self.context()!=Some((context.session,context.epoch,context.player))
            || context.session!=snapshot.session || frame==0 {
            self.suspend();return Err("E Arrival audio OLSR context invalid".into());
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
            self.suspend();return Err("E Arrival audio clock invalid".into());
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
        let events=ezreal_e_accepted_releases::decode_view(snapshot.ezreal_e_accepted_releases.as_ref(),snapshot.tick)
            .map_err(|error|format!("E committed release extension: {error:?}"))?;
        let missing_projection=events.is_none();let events=events.unwrap_or_default();
        if snapshot.roster.len()>64 || snapshot.players.len()>64 {return Err("E Arrival audio actor budget exceeded".into());}
        let mut roster=BTreeMap::new();
        for row in &snapshot.roster {
            if row.id==0 || row.team>1 || roster.insert(row.id,(row.champion.as_str(),row.team)).is_some() {
                return Err("E Arrival audio roster invalid".into());
            }
        }
        let owners:BTreeSet<_>=roster.iter().filter(|(_, (name,_))|*name=="ezreal").map(|(&id,_)|id).collect();
        if owners.len()>MAX_OWNERS {return Err("E Arrival audio owner budget exceeded".into());}
        let mut visible=BTreeSet::new();let mut actor_ids=BTreeSet::new();
        for actor in &snapshot.players {
            if actor.id==0 || !actor_ids.insert(actor.id) {return Err("E Arrival audio scene identity duplicated".into());}
            if actor.champion!="ezreal" {continue;}
            if !roster.get(&actor.id).is_some_and(|(name,team)|*name=="ezreal" && *team==actor.team)
                || !visible.insert(actor.id) {return Err("E Arrival audio visible owner invalid".into());}
        }
        for event in &events {
            if !visible.contains(&event.owner) {return Err("E Arrival audio event owner is not canonically visible".into());}
            if self.authorized.get(&(event.owner,event.order)).is_some_and(|old|old.fingerprint!=Fingerprint::of(event)) {
                return Err("E Arrival audio authorized contact identity changed".into());
            }
            if let Some((order,Some(previous)))=self.seen.get(&event.owner) {
                if event.order==*order && Fingerprint::of(event)!=*previous {
                    return Err("E Arrival audio accepted event identity changed".into());
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
            if event.phase!=ezreal_e_accepted_releases::Phase::Arrival {continue;}
            let key=(event.owner,event.order);let fingerprint=Fingerprint::of(event);
            let authorization=if let Some(previous)=self.authorized.get(&key) {
                *previous
            }else{
                next.next_incarnation=next.next_incarnation.checked_add(1).ok_or("E Arrival audio authorization incarnation exhausted")?;
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
            if event.phase!=ezreal_e_accepted_releases::Phase::Arrival || baseline || !self.visible.contains(&event.owner) || !clock_ready || paused || finished
                || snapshot.tick.saturating_sub(event.tick)>MAX_AGE_TICKS
                || self.tick.is_some_and(|old|event.tick<old) || next.pending.len()==MAX_PENDING {continue;}
            // One phase supplies exactly one committed public point. Never infer
            // the other endpoint, query an actor position or reconstruct a bone.
            let incarnation=next.authorized[&(event.owner,event.order)].incarnation;
            next.pending.push_back(Request { identity:Identity { session:snapshot.session,epoch:next.epoch,
                viewer:next.viewer,owner:event.owner,order:event.order }, position:event.position,variant:usize::from(next.next_variant),received_at:now,fingerprint:Fingerprint::of(&event),incarnation });
            // Cycle on admitted requests, including later physical failures; no retry.
            next.next_variant=(next.next_variant+1)%3;
        }
        if !clock_ready || paused || finished {next.pending.clear();}
        next.visible=visible;next.tick=Some(snapshot.tick);next.clock=Some(now);next.ready=clock_ready && !finished && !missing_projection;
        if !clock_ready || paused || finished {next.suspend();}
        *self=next;Ok(())
    }
    /// A missing backend/asset never creates a retry queue. Taken requests are
    /// consumed whether the optional physical voice can be created or not.
    pub fn take(&mut self,now:f64,clock_ready:bool,paused:bool)->Vec<Request> {
        if !clock_ready || !now.is_finite() || self.clock.is_some_and(|old|now<old) {
            self.suspend();return Vec::new();
        }
        self.clock=Some(now);
        if paused {self.suspend();return Vec::new();}
        let pending=std::mem::take(&mut self.pending);
        if paused || self.epoch==0 || !self.ready {return Vec::new();}
        pending.into_iter().filter(|request|self.authorizes(request) && now>=request.received_at && now-request.received_at<=MAX_DELAY).collect()
    }
}



#[cfg(test)]
#[path="ezreal_e_return_audio_state_tests.rs"]
mod tests;
