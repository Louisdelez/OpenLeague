//! Pickup Simple composition. Native definition/owner inputs stay mandatory.
//! Logical storage tokens are local; this does not claim original heap ownership.
use openleague_core::{native_scalar_parameter::ScalarParameter,native_vector_parameter::VectorParameter,
 native_simple_concrete_frame as frame,native_simple_frame as owner_frame,native_simple_control as control,
 native_simple_pose as pose,native_simple_particle_update as particles,native_simple_emission_sources as sources,
 native_simple_birth_parameters as birth,native_simple_birth_factors as factors,native_simple_rotation_list as rotations,
 native_simple_emission_lifecycle as emission,native_simple_emission_count as count,native_random::Rng55,
 native_simple_animation_policy as animation,native_particle_force_graph as graph};

#[derive(Clone)]pub struct Parameters {pub rate:ScalarParameter,pub life:ScalarParameter,pub quad_rotation:Option<ScalarParameter>,
 pub size:ScalarParameter,pub angular_velocity:ScalarParameter,pub size_over_life:ScalarParameter,
 pub offset:VectorParameter,pub velocity:VectorParameter}
impl Parameters {
 /// Lookup is native-normalized raw text plus native typed probability pairs.
 pub fn read(mut get:impl FnMut(&str)->Option<Vec<f32>>)->Result<Self,String>{
  let mut scalar=|key:&str,default|ScalarParameter::read_numeric(key,default,&mut get).map_err(|e|format!("{key}: {e:?}"));
  let rate=scalar("e-rate",0.)?.ok_or("pickup e-rate missing")?;
  let life=scalar("p-life",3.)?.ok_or("pickup p-life missing")?;
  let quad_rotation=scalar("p-quadrot",0.)?;
  let size=scalar("p-scale",1.)?.ok_or("pickup p-scale missing")?;
  let angular_velocity=scalar("p-rotvel",0.)?.ok_or("pickup p-rotvel missing")?;
  let size_over_life=scalar("p-xscale",1.)?.ok_or("pickup p-xscale missing")?;
  let offset=VectorParameter::read_nonrotation("p-offset",[0.;3],0,&mut get).map_err(|e|format!("p-offset: {e:?}"))?.ok_or("pickup p-offset missing")?;
  let velocity=VectorParameter::read_nonrotation("p-vel",[0.;3],0,&mut get).map_err(|e|format!("p-vel: {e:?}"))?.ok_or("pickup p-vel missing")?;
  Ok(Self{rate,life,quad_rotation,size,angular_velocity,size_over_life,offset,velocity})
 }
}
fn table(s:&ScalarParameter)->particles::Table<'_>{particles::Table{values:&s.table,probability:Some(&s.probability)}}
/// Every value is supplied by the definition owner, not inferred from another effect.
pub struct Definition<'a>{pub flags:u8,pub life:f32,pub lower:f32,pub upper:f32,pub delay:f32,pub emitter_linger:f32,pub particle_linger:f32,
 pub period:f32,pub window:f32,pub single:u32,pub emitter_local:u8,pub sticky:u8,pub local:u8,pub circular:u8,pub direction:u32,
 pub scalar_enabled:u8,pub bind:[u32;2],pub attributes:[particles::Attribute;2],pub rotations:&'a [rotations::Source<'a>],
 pub factors:factors::Sources<'a>,pub force_resource:u32,pub forces:Option<&'a graph::Input<'a>>,pub terrain:u8,
 pub quad_rotation_fallback:u32,pub reset_value:u32,pub manager_flag:Option<u8>,pub definition_kind:u32,
 pub rate_factor:f32,pub position:[u32;3],pub position_probabilities:[Option<&'a openleague_core::native_probability_curve::ProbabilityCurve>;3]}
pub struct Owner{pub system_matrix:[u32;16],pub position:[u32;3],pub inverse_fallback:[u32;16]}
pub struct Host{pub state:frame::State,pub ordinal:u64,pub time:f32}
fn clone_state(s:&frame::State)->frame::State{frame::State{frame:owner_frame::State{particles:s.frame.particles,helper:s.frame.helper,
 animation:s.frame.animation.clone(),tail:s.frame.tail.clone()},pose:s.pose.clone(),particles:s.particles.clone(),birth:s.birth.clone(),emission:s.emission.clone()}}
impl Clone for Host{fn clone(&self)->Self{Self{state:clone_state(&self.state),ordinal:self.ordinal,time:self.time}}}
fn empty(position:[u32;3])->particles::State{particles::State{last_time:f32::MIN.to_bits(),life:vec![],ages:vec![],active:0,
 positions:vec![],velocities:vec![],scales:vec![],factors:vec![],scalar:vec![],rates:vec![],auxiliary:vec![],attribute_a:vec![],attribute_b:vec![],previous_heights:vec![],
 bounds:openleague_core::native_simple_bounds_policy::State{bounds:openleague_core::native_simple_particle_bounds::Bounds{minimum:position,maximum:position},center:position,last:0},counter:0}}
impl Host{
 /// Caller owns the actual initial pose, time and storage allocation policy.
 pub fn new(owner:&Owner,start:f32)->Result<Self,&'static str>{
  if !start.is_finite()||!owner.system_matrix.iter().chain(&owner.position).chain(&owner.inverse_fallback).all(|v|f32::from_bits(*v).is_finite()){return Err("pickup initial owner nonfinite");}
  let mut current=owner.system_matrix;current[12..15].copy_from_slice(&owner.position);
  let inverse=openleague_core::matrix_inverse::inverse(&current.map(f32::from_bits),&owner.inverse_fallback.map(f32::from_bits)).matrix.map(f32::to_bits);
  Ok(Self{state:frame::State{frame:owner_frame::State{particles:1,helper:None,animation:animation::State{clock:0,resource:0,pose_flag:0},
   tail:openleague_core::native_simple_finish::State{previous:current,previous_inverse:inverse,last_time:f32::MIN.to_bits(),finished:0}},
   pose:pose::State{current,previous:current,initial_inverse:inverse},particles:Some(empty(owner.position)),birth:vec![],
   emission:emission::State{previous:start.to_bits(),emitted:0,counter:0,bounds_factor:1f32.to_bits()}},ordinal:0,time:start})
 }
 pub fn finished(&self)->bool{self.state.frame.tail.finished!=0}
 pub fn planned(&self,ordinal:u64,time:f32,start:f32,parameters:&Parameters,definition:&Definition,owner:&Owner,rng:&Rng55,
  height:&mut impl FnMut([u32;3])->Result<u32,&'static str>)->Result<Option<(Self,Rng55)>,&'static str>{
  if ordinal==0||!time.is_finite()||!start.is_finite()||time<self.time||time<start{return Err("pickup ordinal/clock invalid");}
  if ordinal<=self.ordinal{return Ok(None);}
  if ![definition.life,definition.lower,definition.upper,definition.delay,definition.emitter_linger,definition.particle_linger,definition.period,definition.window].iter().all(|v|v.is_finite())
   || !definition.rate_factor.is_finite() || !definition.position.iter().chain(owner.system_matrix.iter()).chain(&owner.position).chain(&owner.inverse_fallback).all(|v|f32::from_bits(*v).is_finite()) {return Err("pickup definition/owner nonfinite");}
  let mut next=self.clone();let mut random=rng.clone();
  let p=parameters;
  let input=frame::Input{frame:owner_frame::Input{control:control::Input{flags:definition.flags,time:time.to_bits(),start:start.to_bits(),life:definition.life.to_bits(),
   lower:definition.lower.to_bits(),upper:definition.upper.to_bits(),delay:definition.delay.to_bits(),emitter_linger:definition.emitter_linger.to_bits(),particle_linger:definition.particle_linger.to_bits(),last_step:0},
   position:owner.position,previous_position:next.state.pose.previous[12..15].try_into().unwrap(),reset_value:definition.reset_value,manager_flag:definition.manager_flag,
   definition_kind:definition.definition_kind,clip_index:u32::MAX,mapping:0,inverse_fallback:owner.inverse_fallback},
   pose:pose::Input{emitter_local:definition.emitter_local,warm:next.state.emission.emitted,system_matrix:owner.system_matrix,position:owner.position,inverse_fallback:owner.inverse_fallback,modifier:0},
   particles:particles::Input{time:time.to_bits(),cap:f32::MAX.to_bits(),birth:&[],bounds_flag:0,previous_position:[0;3],current_position:[0;3],initial_inverse:owner.inverse_fallback,current_matrix:owner.system_matrix,
    bind_begin:definition.bind[0],bind_end:definition.bind[1],sticky:definition.sticky,local:definition.local,circular:definition.circular,direction:definition.direction,
    force_resource:definition.force_resource,force_graph:definition.forces,scalar_enabled:definition.scalar_enabled,
    scalar_table:if let Some(rotation)=&p.quad_rotation{table(rotation)}else{particles::Table{values:&[0.],probability:None}},
    scale_table:table(&p.size_over_life),attributes:definition.attributes,bounds_factor:next.state.emission.bounds_factor,terrain_enabled:definition.terrain}};
  let shared=std::cell::RefCell::new(height);
  let mut producer=Producer{parameters:p,definition,start,height:&shared};
  frame::update(&mut next.state,&input,&mut random,&mut producer,&mut |point|shared.borrow_mut()(point),&mut |_|{})?;
  next.ordinal=ordinal;next.time=time;Ok(Some((next,random)))
 }
}
struct Producer<'a,'b,H>{parameters:&'a Parameters,definition:&'a Definition<'b>,start:f32,height:&'a std::cell::RefCell<&'a mut H>}
impl<H> animation::Backend for Producer<'_,'_,H>{
 fn lookup(&mut self,_:u32)->Option<openleague_core::native_simple_animation_clock::Clip>{None}
 fn special_kind11(&mut self,_:&mut animation::State){}
 fn special_kind11_checked(&mut self,_:&mut animation::State)->Result<(),&'static str>{Err("pickup animation producer unavailable")}
 fn evaluate_uncompressed(&mut self,_:openleague_core::native_simple_animation_clock::Clip,_:u32,_:u32,_:&mut animation::State){}
 fn evaluate_compressed(&mut self,_:openleague_core::native_simple_animation_clock::Clip,_:u32,_:u32,_:&mut animation::State){}
}
impl<H:FnMut([u32;3])->Result<u32,&'static str>> frame::Sources for Producer<'_,'_,H>{
 fn emission(&mut self,time:u32,progress:u32,resource:&mut u32,storage:&mut Option<particles::State>,births:&mut Vec<u32>,pose:&pose::State,owner:&mut emission::State,rng:&mut Rng55)->Result<(),&'static str>{
  let p=self.parameters;let d=self.definition;let progress=f32::from_bits(progress);
  let scalar=if let Some(q)=&p.quad_rotation{birth::sample(&q.table,progress)?}else{d.quad_rotation_fallback};
  let base=birth::BaseBirth{values:birth::Values{life:birth::sample(&p.life.table,progress)?,scalar,factor:birth::sample(&p.size.table,progress)?,rotation:birth::sample(&p.angular_velocity.table,progress)?},
   position:d.position,velocity:birth::sample_vector(&p.velocity.table,progress)?,offset:birth::sample_vector(&p.offset.table,progress)?};
  let curves=birth::BirthCurves{life:Some(&p.life.probability),factor:Some(&p.size.probability),scalar:p.quad_rotation.as_ref().map(|p|&p.probability),rotation:Some(&p.angular_velocity.probability),
   position:d.position_probabilities,velocity:std::array::from_fn(|i|Some(&p.velocity.probabilities[i])),offset:std::array::from_fn(|i|Some(&p.offset.probabilities[i]))};
  let source=sources::Sources{base:&base,curves:&curves,attributes:sources::Attributes{life:None,position:None,velocity:None,rotation:None,offset:None},factors:&d.factors,rotations:d.rotations,
   rate_table:&p.rate.table,rate_probability:Some(&p.rate.probability),rate_factor:d.rate_factor,rate_attribute:None};
  sources::emit_from_frame(time,progress.to_bits(),*resource,storage,births,pose,owner,rng,
   count::Input{time:f32::from_bits(time),start:self.start,previous:f32::from_bits(owner.previous),life:d.life,delay:d.delay,period:d.period,window:d.window,rate:0.,single:d.single,emitted:owner.emitted},
   &source,particles::Table{values:&p.size_over_life.table,probability:Some(&p.size_over_life.probability)},d.terrain,&mut |point|self.height.borrow_mut()(point))?;Ok(())
 }
 fn modifier(&mut self,_:u32,_:u32,_:u32,_:&mut [u32;16])->Result<(),&'static str>{Err("pickup pose modifier unavailable")}
 fn initialize_manager(&mut self,_:&mut openleague_core::native_simple_auxiliary::Helper)->Result<u8,&'static str>{Err("pickup auxiliary manager unavailable")}
 fn evaluated_pose(&mut self,_:[u32;16])->Result<[u32;16],&'static str>{Err("pickup animation pose unavailable")}
}

#[cfg(test)]
#[path="relic_pickup_simulation_tests.rs"] mod tests;
