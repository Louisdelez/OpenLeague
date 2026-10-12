//! Isolated local resume registry. No socket, Simulation mutation, wall clock,
//! entropy implementation or native clock is hidden inside this module.
use openleague_core::session_transport::{self as wire, ClockBootstrap, Context, Input,
    JoinRequest, RequestNonce, ResumeRequest, Secret32, SessionInput, Welcome};
use std::{net::SocketAddr, time::Duration};

pub const SILENCE: Duration = Duration::from_secs(30);

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Limits { live:usize, identities:usize, endpoints:usize }
impl Limits {
    pub fn new(live:usize, identities:usize, endpoints:usize) -> Result<Self, Error> {
        if live==0 || identities<live || endpoints<live || identities>4096 || endpoints>16384 {
            return Err(Error::InvalidLimits);
        }
        Ok(Self {live,identities,endpoints})
    }
}
impl Default for Limits { fn default()->Self {Self {live:6,identities:1024,endpoints:4096}} }

/// A production host must fill this from an OS CSPRNG. There is intentionally no
/// fallback/default implementation. Test deterministic keys are not OS evidence.
pub trait Entropy { fn access_key(&mut self)->Result<Secret32, EntropyUnavailable>; }
#[derive(Clone, Copy, Debug, PartialEq, Eq)] pub struct EntropyUnavailable;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Error {
    InvalidLimits, InvalidSession, InvalidRequest, UnsupportedVersion, Capacity,
    Closing, UnknownLease, Retired, Busy, PeerOccupied, EndpointRetired,
    JoinNeedsResume, JoinMismatch, StaleEpoch {current:Context}, ReplayExpired,
    Unauthorized, StaleSequence, ClockWentBack, EntropyUnavailable, KeyCollision,
    CounterExhausted, InvalidPlayer, InvalidBootstrap, AckProofRequired, InvalidAck, StaleAck,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Endpoint { pub peer:SocketAddr, pub context:Context }
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Retirement { Leave, Abandon, OwnerDrain }
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Transition {
    /// Retain the Simulation player. Remove only the old clock recipient/peer.
    Detached(Endpoint),
    /// Caller must use the existing authoritative remove_player path once.
    Retired {player:u32, endpoint:Option<Endpoint>, reason:Retirement},
}
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct LeaseView {
    pub context:Context, pub endpoint:Option<SocketAddr>, pub last_sequence:u64,
    pub resumable:bool, pub retired:bool,
}
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct View {
    pub session:u64, pub draining:bool, pub leases:Vec<LeaseView>,
    pub marked_endpoints:usize, pub observed_time:Duration,
}
#[derive(Clone)]
struct Connection { peer:SocketAddr, last_seen:Duration, last_clock_ack:u64 }
#[derive(Clone)]
struct ResumeReplay { expected:Context, nonce:RequestNonce, peer:SocketAddr }
struct Lease {
    recovery:Secret32, join:JoinRequest, player:u32, epoch:u64, last_sequence:u64,
    connection:Option<Connection>, welcome:Welcome, last_resume:Option<ResumeReplay>,
    resumable:bool, retired:bool,
}
impl Lease {
    fn context(&self,session:u64)->Context {Context{session,player:self.player,epoch:self.epoch}}
}
pub struct Registry {
    session:u64, limits:Limits, leases:Vec<Lease>, marked:Vec<SocketAddr>,
    draining:bool, observed_time:Duration,
}
impl Registry {
    pub fn new(session:u64,limits:Limits)->Result<Self,Error> {
        if session==0 {return Err(Error::InvalidSession);}
        Ok(Self {session,limits,leases:Vec::with_capacity(limits.identities),
            marked:Vec::with_capacity(limits.endpoints),draining:false,observed_time:Duration::ZERO})
    }
    pub fn view(&self)->View {
        View {session:self.session,draining:self.draining,marked_endpoints:self.marked.len(),
            observed_time:self.observed_time,leases:self.leases.iter().map(|l|LeaseView{
                context:l.context(self.session),endpoint:l.connection.as_ref().map(|c|c.peer),
                last_sequence:l.last_sequence,resumable:l.resumable,retired:l.retired}).collect()}
    }
    /// Use before *every* legacy input/Join dispatch, including retired peers.
    pub fn forbids_legacy(&self,peer:SocketAddr)->bool {self.marked.contains(&peer)}
    /// Includes offline reservations, unlike the connected socket map.
    pub fn live_players(&self)->usize {self.leases.iter().filter(|l|!l.retired).count()}
    /// Authenticate before disclosing even the public epoch. This query does not
    /// refresh activity, admit an endpoint, consume a sequence, or revoke a lease.
    pub fn query_context(&self,r:&wire::ContextRequest,now:Duration)->Result<wire::ContextResponse,Error> {
        self.time(now)?;
        if r.version!=wire::VERSION {return Err(Error::UnsupportedVersion);}
        if !r.request_nonce.valid() || r.expected_session==Some(0) {return Err(Error::InvalidRequest);}
        let l=self.leases.iter().find(|l|l.recovery==r.recovery_key).ok_or(Error::UnknownLease)?;
        if r.expected_session.is_some_and(|session|session!=self.session) {return Err(Error::Unauthorized);}
        let availability=if l.retired {wire::Availability::Retired}
            else if self.draining || !l.resumable {wire::Availability::Closing}
            else if l.connection.as_ref().is_some_and(|c|now.saturating_sub(c.last_seen)<=SILENCE) {wire::Availability::Busy}
            else {wire::Availability::Detached};
        Ok(wire::ContextResponse{request_nonce:r.request_nonce,context:l.context(self.session),availability})
    }
    fn time(&self,now:Duration)->Result<(),Error> {
        if now<self.observed_time {Err(Error::ClockWentBack)}else{Ok(())}
    }
    fn peer_busy(&self,peer:SocketAddr,except:Option<usize>)->bool {
        self.leases.iter().enumerate().any(|(i,l)|Some(i)!=except
            && l.connection.as_ref().is_some_and(|c|c.peer==peer))
    }
    fn reserve_endpoint(&self,peer:SocketAddr)->Result<(),Error> {
        if !self.marked.contains(&peer) && self.marked.len()>=self.limits.endpoints {Err(Error::Capacity)}else{Ok(())}
    }
    fn mark(&mut self,peer:SocketAddr) {if !self.marked.contains(&peer){self.marked.push(peer);}}
    fn key(&self,recovery:&Secret32,e:&mut impl Entropy)->Result<Secret32,Error> {
        let key=e.access_key().map_err(|_|Error::EntropyUnavailable)?;
        if key==*recovery || self.leases.iter().any(|l|key==l.recovery || key==l.welcome.access_key) {
            return Err(Error::KeyCollision);
        }
        Ok(key)
    }
    /// No state is changed until a New guard commits. Dropping it cancels the
    /// attempt. The exclusive borrow prevents another registry transaction.
    /// Host must also reject peers already occupied by a legacy participant.
    pub fn prepare_join<'a>(&'a mut self,peer:SocketAddr,r:&JoinRequest,now:Duration,
        entropy:&mut impl Entropy)->Result<JoinPreparation<'a>,Error> {
        self.time(now)?;
        if r.version!=wire::VERSION {return Err(Error::UnsupportedVersion);}
        if !r.request_nonce.valid() || r.champion.is_empty() || r.champion.len()>64 {return Err(Error::InvalidRequest);}
        if self.draining {return Err(Error::Closing);}
        if let Some(l)=self.leases.iter().find(|l|l.recovery==r.recovery_key) {
            if l.retired || !l.resumable {return Err(Error::Retired);}
            if l.join.champion!=r.champion || l.join.summoners!=r.summoners || l.join.request_nonce!=r.request_nonce {
                return Err(Error::JoinMismatch);
            }
            if l.epoch!=1 {return Err(Error::JoinNeedsResume);}
            let c=l.connection.as_ref().ok_or(Error::JoinNeedsResume)?;
            if c.peer!=peer || now.saturating_sub(c.last_seen)>SILENCE {return Err(Error::JoinNeedsResume);}
            // Retransmitting a Welcome does not extend liveness.
            return Ok(JoinPreparation::Replay(l.welcome.clone()));
        }
        if self.marked.contains(&peer) {return Err(Error::EndpointRetired);}
        if self.peer_busy(peer,None) {return Err(Error::PeerOccupied);}
        if self.leases.iter().any(|l|l.welcome.access_key==r.recovery_key) {return Err(Error::KeyCollision);}
        if self.live_players()>=self.limits.live || self.leases.len()>=self.limits.identities {return Err(Error::Capacity);}
        self.reserve_endpoint(peer)?;
        let access=self.key(&r.recovery_key,entropy)?;
        Ok(JoinPreparation::New(PendingJoin{registry:self,peer,request:r.clone(),access,now}))
    }
    pub fn prepare_resume<'a>(&'a mut self,peer:SocketAddr,r:&ResumeRequest,now:Duration,
        entropy:&mut impl Entropy)->Result<ResumePreparation<'a>,Error> {
        self.time(now)?;
        if r.version!=wire::VERSION {return Err(Error::UnsupportedVersion);}
        if !r.request_nonce.valid() || !r.expected.valid() {return Err(Error::InvalidRequest);}
        if self.draining {return Err(Error::Closing);}
        let index=self.leases.iter().position(|l|l.recovery==r.recovery_key).ok_or(Error::UnknownLease)?;
        let l=&self.leases[index];let current=l.context(self.session);
        if l.retired || !l.resumable {return Err(Error::Retired);}
        if r.expected.session!=self.session || r.expected.player!=l.player {return Err(Error::Unauthorized);}
        if l.last_resume.as_ref().is_some_and(|x|x.expected==r.expected && x.nonce==r.request_nonce && x.peer==peer) {
            let c=l.connection.as_ref().ok_or(Error::ReplayExpired)?;
            if c.peer!=peer || now.saturating_sub(c.last_seen)>SILENCE {return Err(Error::ReplayExpired);}
            return Ok(ResumePreparation::Replay(l.welcome.clone()));
        }
        if r.expected!=current {return Err(Error::StaleEpoch{current});}
        if l.connection.as_ref().is_some_and(|c|now.saturating_sub(c.last_seen)<=SILENCE) {return Err(Error::Busy);}
        if self.peer_busy(peer,Some(index)) {return Err(Error::PeerOccupied);}
        self.reserve_endpoint(peer)?;
        let epoch=l.epoch.checked_add(1).ok_or(Error::CounterExhausted)?;
        let next_sequence=l.last_sequence.checked_add(1).ok_or(Error::CounterExhausted)?;
        let access=self.key(&r.recovery_key,entropy)?;
        Ok(ResumePreparation::New(PendingResume{registry:self,index,peer,request:r.clone(),access,epoch,next_sequence,now}))
    }
    /// Authenticate and check freshness before any activity/sequence change.
    /// A ClockAck additionally needs PreparedAck from actual delivery preflight.
    pub fn prepare_input<'a>(&'a mut self,peer:SocketAddr,r:&SessionInput,now:Duration)->Result<PendingInput<'a>,Error> {
        self.time(now)?;
        if r.version!=wire::VERSION {return Err(Error::UnsupportedVersion);}
        if !r.context.valid() || r.context.session!=self.session {return Err(Error::Unauthorized);}
        let index=self.leases.iter().position(|l|l.player==r.context.player).ok_or(Error::Unauthorized)?;
        let l=&self.leases[index];
        if l.retired || l.context(self.session)!=r.context || l.welcome.access_key!=r.access_key {return Err(Error::Unauthorized);}
        let c=l.connection.as_ref().ok_or(Error::Unauthorized)?;
        if c.peer!=peer || now.saturating_sub(c.last_seen)>SILENCE {return Err(Error::Unauthorized);}
        if r.sequence<=l.last_sequence {return Err(Error::StaleSequence);}
        if matches!(&r.input,Input::ClockAck{ordinal:0}) {return Err(Error::InvalidAck);}
        if matches!(&r.input,Input::ClockAck{ordinal} if *ordinal<=c.last_clock_ack) {return Err(Error::StaleAck);}
        Ok(PendingInput{registry:self,index,request:r.clone(),now})
    }
    /// Detach silent endpoints, keeping their players indefinitely while open.
    /// While draining, the same timeout retires them instead.
    pub fn poll(&mut self,now:Duration)->Result<Vec<Transition>,Error> {
        self.time(now)?;let mut events=Vec::new();
        for l in &mut self.leases {
            if l.retired {continue;}
            if l.connection.as_ref().is_some_and(|c|now.saturating_sub(c.last_seen)>SILENCE) {
                let c=l.connection.take().unwrap();let endpoint=Endpoint{peer:c.peer,context:l.context(self.session)};
                if self.draining {
                    l.retired=true;l.resumable=false;
                    events.push(Transition::Retired{player:l.player,endpoint:Some(endpoint),reason:Retirement::OwnerDrain});
                }else{events.push(Transition::Detached(endpoint));}
            }
        }
        self.observed_time=now;Ok(events)
    }
    /// EOF/abandon closes admission and recovery for everyone. Offline players
    /// retire now; connected participants remain until Leave or silence timeout.
    pub fn begin_drain(&mut self,now:Duration)->Result<Vec<Transition>,Error> {
        self.time(now)?;self.draining=true;let mut events=self.poll(now)?;
        for l in &mut self.leases {
            l.resumable=false;
            if !l.retired && l.connection.is_none() {
                l.retired=true;events.push(Transition::Retired{player:l.player,endpoint:None,reason:Retirement::OwnerDrain});
            }
        }
        self.observed_time=now;Ok(events)
    }
    /// Trusted host abandonment only, not a network operation without auth.
    pub fn abandon(&mut self,player:u32,now:Duration)->Result<Option<Transition>,Error> {
        self.time(now)?;
        let l=self.leases.iter_mut().find(|l|l.player==player).ok_or(Error::UnknownLease)?;
        if l.retired {return Ok(None);}
        let endpoint=l.connection.take().map(|c|Endpoint{peer:c.peer,context:l.context(self.session)});
        l.retired=true;l.resumable=false;self.observed_time=now;
        Ok(Some(Transition::Retired{player,endpoint,reason:Retirement::Abandon}))
    }
}

pub enum JoinPreparation<'a> { Replay(Welcome), New(PendingJoin<'a>) }
pub struct PendingJoin<'a> { registry:&'a mut Registry,peer:SocketAddr,request:JoinRequest,access:Secret32,now:Duration }
impl PendingJoin<'_> {
    /// Call only with a newly-created Simulation player and a prepared clock
    /// recipient. If this returns Err, host must roll back that newly-created
    /// player/recipient. A duplicate ID is a caller contract error, never removal
    /// permission for an already-existing player. No registry mutation on Err.
    pub fn commit(self,player:u32,bootstrap:ClockBootstrap)->Result<Welcome,Error> {
        bootstrap.required_ordinal().map_err(|_|Error::InvalidBootstrap)?;
        if player==0 || self.registry.leases.iter().any(|l|l.player==player) {return Err(Error::InvalidPlayer);}
        let welcome=Welcome{version:wire::VERSION,context:Context{session:self.registry.session,player,epoch:1},
            request_nonce:self.request.request_nonce,access_key:self.access,next_sequence:1,bootstrap};
        self.registry.mark(self.peer);
        self.registry.leases.push(Lease{recovery:self.request.recovery_key.clone(),join:self.request,
            player,epoch:1,last_sequence:0,connection:Some(Connection{peer:self.peer,last_seen:self.now,last_clock_ack:0}),
            welcome:welcome.clone(),last_resume:None,resumable:true,retired:false});
        self.registry.observed_time=self.now;Ok(welcome)
    }
}
pub enum ResumePreparation<'a> { Replay(Welcome), New(PendingResume<'a>) }
pub struct PendingResume<'a> {
    registry:&'a mut Registry,index:usize,peer:SocketAddr,request:ResumeRequest,
    access:Secret32,epoch:u64,next_sequence:u64,now:Duration,
}
#[derive(Clone, Debug)] pub struct Attached {pub welcome:Welcome,pub previous:Option<Endpoint>}
impl PendingResume<'_> {
    /// Host stages a replacement clock recipient before this commit. Preparing
    /// must not erase the old live recipient on failure. No OS/native work here.
    pub fn commit(self,bootstrap:ClockBootstrap)->Result<Attached,Error> {
        bootstrap.required_ordinal().map_err(|_|Error::InvalidBootstrap)?;
        let l=&mut self.registry.leases[self.index];
        let previous=l.connection.take().map(|c|Endpoint{peer:c.peer,context:l.context(self.registry.session)});
        l.epoch=self.epoch;
        let welcome=Welcome{version:wire::VERSION,context:l.context(self.registry.session),
            request_nonce:self.request.request_nonce,access_key:self.access,next_sequence:self.next_sequence,bootstrap};
        l.last_resume=Some(ResumeReplay{expected:self.request.expected,nonce:self.request.request_nonce,peer:self.peer});
        l.connection=Some(Connection{peer:self.peer,last_seen:self.now,last_clock_ack:0});l.welcome=welcome.clone();
        self.registry.mark(self.peer);self.registry.observed_time=self.now;Ok(Attached{welcome,previous})
    }
}

/// Token of numeric validation against the actual delivery recipient's issued
/// ordinal. Host must pass its real issued value and preserve the recipient
/// between this check and commit (single-threaded server currently does so).
pub struct PreparedAck {context:Context,ordinal:u64}
impl PreparedAck {
    pub fn check(context:Context,ordinal:u64,issued:u64)->Result<Self,Error> {
        if !context.valid() || ordinal==0 || ordinal>issued {return Err(Error::InvalidAck);}
        Ok(Self{context,ordinal})
    }
}
pub struct PendingInput<'a> {registry:&'a mut Registry,index:usize,request:SessionInput,now:Duration}
#[derive(Clone, Debug)] pub struct Accepted {pub context:Context,pub sequence:u64,pub input:Input,pub transition:Option<Transition>}
impl PendingInput<'_> {
    pub fn input(&self)->&Input {&self.request.input}
    /// Semantic Action rejection still consumes its authenticated fresh sequence
    /// as the existing server does. Invalid ClockAck must not commit activity.
    pub fn commit(self,ack:Option<PreparedAck>)->Result<Accepted,Error> {
        match (&self.request.input,ack) {
            (Input::ClockAck{ordinal},Some(proof)) if proof.context==self.request.context && proof.ordinal==*ordinal=>{},
            (Input::ClockAck{..},_)=>return Err(Error::AckProofRequired),
            (_,Some(_))=>return Err(Error::InvalidAck),
            (_,None)=>{},
        }
        let l=&mut self.registry.leases[self.index];
        l.last_sequence=self.request.sequence;
        let transition=if matches!(self.request.input,Input::Leave) {
            let c=l.connection.take().expect("prepared active endpoint");l.retired=true;l.resumable=false;
            Some(Transition::Retired{player:l.player,endpoint:Some(Endpoint{peer:c.peer,context:self.request.context}),reason:Retirement::Leave})
        }else{
            let c=l.connection.as_mut().expect("prepared active endpoint");c.last_seen=self.now;
            if let Input::ClockAck{ordinal}=&self.request.input {c.last_clock_ack=*ordinal;}
            None
        };
        self.registry.observed_time=self.now;
        Ok(Accepted{context:self.request.context,sequence:self.request.sequence,input:self.request.input,transition})
    }
}

#[cfg(test)]
#[path = "reconnect_tests.rs"]
mod tests;

#[cfg(test)]
#[path = "reconnect_recovery_tests.rs"]
mod recovery_tests;
