//! Bounded943760/943750/9433F0 and snapshot/clear semantics of93F1A0.
//! Matching skeletons only. No pose allocation, lazy model update or rendering.
use std::sync::{Arc, Mutex};
use crate::native_troy_owner_pose::DeferredCall;

pub const HANDLER: u32 = 0x943750;
pub type Joint = [u8; 40];
pub const IDENTITY: [u32; 10] = [0,0,0,0x3f800000,0x3f800000,0x3f800000,0,0,0,0x3f800000];

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Error {
    InvalidIdentity,
    TooManyJoints,
    MissingDestination,
    SkeletonChanged { destination: u64, source: u64 },
    JointCountChanged { destination: usize, source: usize },
    Unsupported(&'static str),
    Allocation,
    Capacity,
    BusyOrPoisoned,
    ResourceMismatch,
    Interrupted,
}
impl Error {
    pub fn message(&self) -> &'static str {
        match self {
            Self::InvalidIdentity => "invalid type11 instance or skeleton identity",
            Self::TooManyJoints => "type11 joint count exceeds native WORD",
            Self::MissingDestination => "type11 source exists but destination pose is absent",
            Self::SkeletonChanged {..} => "type11 skeleton replacement is not qualified",
            Self::JointCountChanged {..} => "type11 matching skeleton has inconsistent joint buffers",
            Self::Unsupported(s) => s,
            Self::Allocation => "type11 queue allocation failed",
            Self::Capacity => "type11 queue capacity exceeded",
            Self::BusyOrPoisoned => "type11 owner is busy or poisoned",
            Self::ResourceMismatch => "type11 animation resource disagrees with owned destination",
            Self::Interrupted => "type11 batch interrupted; failed work cannot be replayed",
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Phase { BeforeCopy, AfterCopy }
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Failure { pub phase: Phase, pub error: Error }
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Outcome { SourceAbsent, Applied { joints: usize } }

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Pose { skeleton: u64, joints: Vec<Joint> }
impl Pose {
    pub fn new(skeleton: u64, joints: Vec<Joint>) -> Result<Self, Error> {
        if skeleton == 0 { return Err(Error::InvalidIdentity); }
        if joints.len() > u16::MAX as usize { return Err(Error::TooManyJoints); }
        Ok(Self { skeleton, joints })
    }
    pub fn skeleton(&self) -> u64 { self.skeleton }
    pub fn joints(&self) -> &[Joint] { &self.joints }
}

/// Producer boundary, not a generated pose or a completed actor binding.
/// `pose` performs the first owner/eligibility/pose read. `transform` performs
/// the second owner/eligibility read AFTER the joint copy; None selects the
/// native identity literal. A lazy/unqualified producer must return Err.
/// Returned Arc keeps the entire source alive through copying. Destination
/// Vec storage is disjoint and owned by Instance. Implementations must not
/// invoke rendering or pretend a generic NULL-pose owner has a pose.
pub trait Provider: Send {
    fn pose(&mut self) -> Result<Option<Arc<Pose>>, Error>;
    fn transform(&mut self) -> Result<Option<[u32; 10]>, Error>;
}
pub type ProviderHandle = Arc<Mutex<Box<dyn Provider>>>;

#[derive(Debug,Clone)]
pub struct Model {
    pub pose:Option<Arc<Pose>>,
    pub transform:[u32;10],
    pub lazy_update:bool,
}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum ProviderKind { GeometryOrPose, GenericNullPose }
///719BC0/719BF0 value consumer, using the existing qualified weak-owner value
///representation. Missing model/pose is native absence. Obtaining this model
///from an actor or constructing its pose remains the caller's real obligation.
#[derive(Debug,Clone)]
pub struct ModelProvider {
    pub owner:Option<crate::native_actor_effect_owner::Owner>,
    pub kind:ProviderKind,
    pub model:Option<Model>,
}
impl Provider for ModelProvider {
    fn pose(&mut self)->Result<Option<Arc<Pose>>,Error>{
        if !self.owner.as_ref().is_some_and(|o|o.eligible()) {return Ok(None)}
        if self.kind==ProviderKind::GenericNullPose {return Ok(None)}
        let Some(model)=&self.model else{return Ok(None)};
        if model.lazy_update{return Err(Error::Unsupported("type11 model lazy update8882E0 is not qualified"))}
        Ok(model.pose.clone())
    }
    fn transform(&mut self)->Result<Option<[u32;10]>,Error>{
        if !self.owner.as_ref().is_some_and(|o|o.eligible()) {return Ok(None)}
        Ok(self.model.as_ref().map(|m|m.transform))
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Instance {
    pub resource: u32,
    pub destination: Option<Pose>,
    /// Instance+118..+13F: translation, reciprocal unit scale, conjugate quaternion.
    pub inverse: [u32; 10],
}

fn finite(v: f32) -> Result<f32, Error> {
    if v.is_finite() { Ok(v) } else { Err(Error::Unsupported("nonfinite type11 transform arithmetic is not qualified")) }
}
// Each call is one scalar f32 operation. Do not replace with FMA, matrix inverse,
// quaternion library normalization, f64 arithmetic or fast-math reassociation.
#[inline(never)] fn mul(a:f32,b:f32)->Result<f32,Error>{finite(a*b)}
#[inline(never)] fn add(a:f32,b:f32)->Result<f32,Error>{finite(a+b)}
#[inline(never)] fn sub(a:f32,b:f32)->Result<f32,Error>{finite(a-b)}
fn neg(a:f32)->f32{f32::from_bits(a.to_bits()^0x80000000)}

/// Original scalar operation order9434F5..94372F, default masked IEEE mode.
/// Source scale words3..5 are copied by native code but not used in this block.
/// Finite inputs/intermediates only; no NaN payload/flags/physical-CPU claim.
pub fn inverse_transform(words:[u32;10])->Result<[u32;10],Error>{
    let t=words.map(f32::from_bits);
    for i in [0,1,2,6,7,8,9] { finite(t[i])?; }
    let (qx,qy,qz,qw)=(neg(t[6]),neg(t[7]),neg(t[8]),t[9]);
    // Divisors are the original unit literals123EF74/78/7C, not source scale.
    let scale=[1.0f32/1.0,1.0f32/1.0,1.0f32/1.0];
    let x=mul(scale[0],t[0])?;
    let y=mul(scale[1],t[1])?;
    let z=mul(scale[2],t[2])?;
    let a=mul(qy,y)?;
    let mut w=neg(mul(qx,x)?);
    w=sub(w,a)?;
    w=sub(w,mul(qz,z)?)?;
    let mut u=mul(qw,x)?;
    let a=mul(qy,z)?;
    let mut v=mul(qw,y)?;
    u=add(u,a)?;
    u=sub(u,mul(qz,y)?)?;
    let a=mul(qz,x)?;
    let mut r=mul(qw,z)?;
    v=add(v,a)?;
    v=sub(v,mul(qx,z)?)?;
    let a=mul(qx,y)?;
    let mut ox=mul(qw,u)?;
    r=add(r,a)?;
    r=sub(r,mul(qy,x)?)?;
    ox=sub(ox,mul(qx,w)?)?;
    ox=sub(ox,mul(qz,v)?)?;
    let a=mul(qy,r)?;
    let mut oy=mul(qw,v)?;
    ox=add(ox,a)?;
    oy=sub(oy,mul(qy,w)?)?;
    oy=sub(oy,mul(qx,r)?)?;
    let a=mul(qz,u)?;
    let zw=mul(qz,w)?;
    oy=add(oy,a)?;
    let mut oz=mul(qw,r)?;
    oz=sub(oz,zw)?;
    oz=sub(oz,mul(qy,u)?)?;
    oz=add(oz,mul(qx,v)?)?;
    Ok([neg(ox),neg(oy),neg(oz),scale[0],scale[1],scale[2],qx,qy,qz,qw].map(f32::to_bits))
}

/// Native success mutation order is joint copy, provider recheck, transform.
/// Errors after copy report AfterCopy and leave the new joint bytes in place;
/// no invented rollback or automatic retry is allowed. Transform commits only
/// when its supported finite arithmetic completes (host error adaptation).
pub fn consume(instance:&mut Instance,provider:&mut dyn Provider)->Result<Outcome,Failure>{
    let before=|error|Failure {phase:Phase::BeforeCopy,error};
    let source=provider.pose().map_err(before)?;
    let Some(source)=source else{return Ok(Outcome::SourceAbsent)};
    let destination=instance.destination.as_mut().ok_or_else(||before(Error::MissingDestination))?;
    if destination.skeleton!=source.skeleton {
        return Err(before(Error::SkeletonChanged {destination:destination.skeleton,source:source.skeleton}));
    }
    if destination.joints.len()!=source.joints.len() {
        return Err(before(Error::JointCountChanged {destination:destination.joints.len(),source:source.joints.len()}));
    }
    destination.joints.copy_from_slice(&source.joints);
    let after=|error|Failure {phase:Phase::AfterCopy,error};
    let transform=provider.transform().map_err(after)?.unwrap_or(IDENTITY);
    instance.inverse=inverse_transform(transform).map_err(after)?;
    Ok(Outcome::Applied {joints:source.joints.len()})
}

#[derive(Clone)]
pub struct InstanceHandle { id:u32, owner:Arc<Mutex<Instance>> }
impl InstanceHandle {
    pub fn new(id:u32,instance:Instance)->Result<Self,Error>{
        if id==0 {return Err(Error::InvalidIdentity)}
        Ok(Self {id,owner:Arc::new(Mutex::new(instance))})
    }
    pub fn id(&self)->u32{self.id}
    pub fn owner(&self)->&Arc<Mutex<Instance>>{&self.owner}
}
#[derive(Clone)]
struct Job { call:DeferredCall, instance:InstanceHandle, provider:ProviderHandle }
impl Job {
    fn execute(&self)->Result<Outcome,Failure>{
        let failure=||Failure {phase:Phase::BeforeCopy,error:Error::BusyOrPoisoned};
        // try_lock makes self-reentry/cyclic ownership an explicit failure.
        let mut provider=self.provider.try_lock().map_err(|_|failure())?;
        let mut instance=self.instance.owner.try_lock().map_err(|_|failure())?;
        consume(&mut instance,provider.as_mut())
    }
}

/// Owned adaptation of raw native callback arguments. Capacity is a caller
/// policy, not an inferred native emitter/participant limit. Queueing does not
/// freeze provider data: its actual read happens at dispatch.
pub struct Queue { pending:Vec<Job>, capacity:usize }
impl Queue {
    pub fn new(capacity:usize)->Self{Self {pending:Vec::new(),capacity}}
    pub fn len(&self)->usize{self.pending.len()}
    pub fn is_empty(&self)->bool{self.pending.is_empty()}
    pub fn calls(&self)->impl Iterator<Item=DeferredCall>+'_ {self.pending.iter().map(|j|j.call)}
    pub fn enqueue(&mut self,instance:InstanceHandle,provider:ProviderHandle)->Result<(),Error>{
        if self.pending.len()==self.capacity{return Err(Error::Capacity)}
        self.pending.try_reserve(1).map_err(|_|Error::Allocation)?;
        self.pending.push(Job {call:DeferredCall {handler:HANDLER,argument:instance.id},instance,provider});
        Ok(())
    }
    /// Same snapshot then clear order as93F1A0. Reservation fails before any
    /// mutation. Newly enqueued jobs stay in this Queue for a later batch.
    fn snapshot(&self)->Result<Batch,Error>{
        let mut entries=Vec::new();entries.try_reserve_exact(self.pending.len()).map_err(|_|Error::Allocation)?;
        entries.extend(self.pending.iter().cloned().map(Some));
        Ok(Batch {entries,cursor:0,failure:None})
    }
    pub fn begin_drain(&mut self)->Result<Batch,Error>{
        let batch=self.snapshot()?;self.pending.clear();Ok(batch)
    }
    /// Invoke the existing owner/property phase and consume this queue only
    /// when its deferred branch is actually reached. Ineligible/unlinked owners
    /// retain the original jobs. Property/status mutations precede pose copying.
    /// This queue contains only HANDLER jobs; other.deferred is never called.
    /// On a host failure, the error owns the interrupted job and all unstarted
    /// siblings after the queue has been cleared. It must be retained/reported,
    /// or explicitly dropped to abandon work; it must never be retried as new.
    pub fn transfer_owner(
        &mut self,source:&mut crate::native_troy_properties::Source,
        emitter:&mut crate::native_troy_properties::Emitter,
        config:crate::native_troy_owner_pose::Config,linked:bool,
        other:&mut impl crate::native_troy_owner_pose::Backend,
    )->Result<usize,DrainFailure>{
        let prepare_error=|error|DrainFailure {failure:Failure {phase:Phase::BeforeCopy,error},retained:None};
        let mut batch=self.snapshot().map_err(prepare_error)?;
        let mut calls=Vec::new();calls.try_reserve_exact(self.len()).map_err(|_|prepare_error(Error::Allocation))?;
        calls.extend(self.calls());
        let started={
            let mut proxy=OwnerPhase {queue:self,batch:&mut batch,other,started:false};
            crate::native_troy_owner_pose::transfer(source,emitter,config,linked,&mut calls,&mut proxy);
            proxy.started
        };
        if let Some(failure)=batch.failure.clone(){return Err(DrainFailure {failure,retained:Some(batch)})}
        Ok(if started {batch.cursor} else {0})
    }
}

/// A failure is deliberately an owning value rather than a string. Converting
/// it to a log line and discarding it explicitly abandons the retained batch.
pub struct DrainFailure {pub failure:Failure,pub retained:Option<Batch>}
impl std::fmt::Debug for DrainFailure {
    fn fmt(&self,f:&mut std::fmt::Formatter<'_>)->std::fmt::Result{
        f.debug_struct("DrainFailure").field("failure",&self.failure)
            .field("retained_jobs",&self.retained.as_ref().map(Batch::remaining)).finish()
    }
}
struct OwnerPhase<'a,B> {queue:&'a mut Queue,batch:&'a mut Batch,other:&'a mut B,started:bool}
impl<B:crate::native_troy_owner_pose::Backend> crate::native_troy_owner_pose::Backend for OwnerPhase<'_,B>{
    fn eligible(&mut self)->u8{self.other.eligible()}
    fn position(&mut self)->Option<[u32;3]>{self.other.position()}
    fn direction(&mut self)->Option<[u32;3]>{self.other.direction()}
    fn orientation(&mut self)->Option<[u32;16]>{self.other.orientation()}
    fn secondary_status(&mut self)->u8{self.other.secondary_status()}
    fn primary_status(&mut self)->u8{self.other.primary_status()}
    fn deferred(&mut self,call:DeferredCall,pending:&mut Vec<DeferredCall>){
        if !self.started {self.queue.pending.clear();self.started=true;}
        if self.batch.failure.is_some(){return}
        if !pending.is_empty() || self.batch.entries.get(self.batch.cursor).and_then(Option::as_ref).map(|j|j.call)!=Some(call){
            self.batch.failure=Some(Failure {phase:Phase::BeforeCopy,error:Error::Unsupported("type11 owner queue order changed")});return
        }
        // next stores its exact failure before returning; do not erase it when
        // the legacy infallible owner loop proceeds to its remaining callbacks.
        let _=self.batch.next();
    }
}
#[derive(Debug,Clone,PartialEq,Eq)]
pub struct Completion {pub call:DeferredCall,pub outcome:Outcome}
/// On failure the attempted job and unstarted siblings stay owned here. The
/// batch refuses replay; dropping it explicitly abandons them via Rust RAII.
/// This host failure policy is not native exception-unwind parity.
pub struct Batch {entries:Vec<Option<Job>>,cursor:usize,failure:Option<Failure>}
impl Batch {
    pub fn remaining(&self)->usize{self.entries.iter().filter(|e|e.is_some()).count()}
    pub fn failure(&self)->Option<&Failure>{self.failure.as_ref()}
    pub fn next(&mut self)->Result<Option<Completion>,Failure>{
        if self.failure.is_some(){return Err(Failure {phase:Phase::BeforeCopy,error:Error::Interrupted})}
        if self.cursor==self.entries.len(){return Ok(None)}
        let job=self.entries[self.cursor].as_ref().expect("unconsumed batch entry");
        let call=job.call;
        match job.execute(){
            Ok(outcome)=>{self.entries[self.cursor]=None;self.cursor+=1;Ok(Some(Completion {call,outcome}))}
            Err(f)=>{self.failure=Some(f.clone());Err(f)}
        }
    }
}

/// Concrete animationpolicy hook. Other animation/producer obligations are
/// forwarded unchanged. The prepared policy calls the fallible method, so a
/// queue failure cannot silently claim success. No immediate pose evaluation.
pub struct Animation<'a,B> {
    pub other:&'a mut B,pub queue:&'a mut Queue,pub instance:InstanceHandle,pub provider:ProviderHandle,
    error:Option<Error>,
}
impl<'a,B> Animation<'a,B>{
    pub fn new(other:&'a mut B,queue:&'a mut Queue,instance:InstanceHandle,provider:ProviderHandle)->Self{
        Self {other,queue,instance,provider,error:None}
    }
    pub fn error(&self)->Option<&Error>{self.error.as_ref()}
    fn enqueue(&mut self,state:&crate::native_simple_animation_policy::State)->Result<(),&'static str>{
        if let Some(e)=&self.error{return Err(e.message())}
        let resource=self.instance.owner.try_lock().map(|v|v.resource).map_err(|_|Error::BusyOrPoisoned);
        let result=resource.and_then(|r|if r==state.resource {self.queue.enqueue(self.instance.clone(),self.provider.clone())}else{Err(Error::ResourceMismatch)});
        if let Err(e)=result {let message=e.message();self.error=Some(e);return Err(message)}
        Ok(())
    }
}
impl<B:crate::native_simple_animation_policy::Backend> crate::native_simple_animation_policy::Backend for Animation<'_,B>{
    fn lookup(&mut self,index:u32)->Option<crate::native_simple_animation_clock::Clip>{self.other.lookup(index)}
    fn special_kind11(&mut self,state:&mut crate::native_simple_animation_policy::State){let _=self.enqueue(state);}
    fn special_kind11_checked(&mut self,state:&mut crate::native_simple_animation_policy::State)->Result<(),&'static str>{self.enqueue(state)}
    fn evaluate_uncompressed(&mut self,clip:crate::native_simple_animation_clock::Clip,time:u32,mapping:u32,state:&mut crate::native_simple_animation_policy::State){self.other.evaluate_uncompressed(clip,time,mapping,state)}
    fn evaluate_compressed(&mut self,clip:crate::native_simple_animation_clock::Clip,time:u32,mapping:u32,state:&mut crate::native_simple_animation_policy::State){self.other.evaluate_compressed(clip,time,mapping,state)}
}

// These forwarding implementations are the concrete entry at existing
//9437E0/native_simple_frame and native_simple_concrete_frame::Sources. They
// preserve all non-type11 behavior and do not invent an actor/mesh provider.
impl<B:crate::native_simple_control::Backend> crate::native_simple_control::Backend for Animation<'_,B>{
    fn attachment(&mut self,t:u32,p:u32){self.other.attachment(t,p)}
    fn emission(&mut self,t:u32,p:u32,r:&mut u32){self.other.emission(t,p,r)}
    fn particles(&mut self,r:u32,t:u32,c:u32,last:u32){self.other.particles(r,t,c,last)}
}
impl<B:crate::native_simple_frame::Backend> crate::native_simple_frame::Backend for Animation<'_,B>{
    fn initialize_manager(&mut self,h:&mut crate::native_simple_auxiliary::Helper)->u8{self.other.initialize_manager(h)}
    fn current_pose(&mut self)->[u32;16]{self.other.current_pose()}
    fn active_particles(&mut self,r:u32)->u32{self.other.active_particles(r)}
}
impl<B:crate::native_simple_concrete_frame::Sources> crate::native_simple_concrete_frame::Sources for Animation<'_,B>{
    fn emission(&mut self,t:u32,p:u32,r:&mut u32,s:&mut Option<crate::native_simple_particle_update::State>,b:&mut Vec<u32>,pose:&crate::native_simple_pose::State,o:&mut crate::native_simple_emission_lifecycle::State,rng:&mut crate::native_random::Rng55)->Result<(),&'static str>{
        self.other.emission(t,p,r,s,b,pose,o,rng)
    }
    fn modifier(&mut self,r:u32,t:u32,p:u32,m:&mut [u32;16])->Result<(),&'static str>{self.other.modifier(r,t,p,m)}
    fn initialize_manager(&mut self,h:&mut crate::native_simple_auxiliary::Helper)->Result<u8,&'static str>{self.other.initialize_manager(h)}
    fn evaluated_pose(&mut self,base:[u32;16])->Result<[u32;16],&'static str>{self.other.evaluated_pose(base)}
}

#[cfg(test)]
#[path="native_simple_type11_pose_tests.rs"]
mod tests;
