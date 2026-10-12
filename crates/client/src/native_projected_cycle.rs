//! Client bridge to the qualified core Simple frame; owner identity/RNG remain explicit.
use bevy::prelude::*;
use crate::{simple_projected_config::SimpleProjectedConfig,simple_owner_pose::SimpleOwnerPose,simple_cycle::OwnerEnd};
use openleague_core::{native_simple_concrete_frame as frame,native_simple_frame as dispatch,native_simple_pose as pose,native_simple_emission_lifecycle as emission,native_simple_emission_sources as sources,native_simple_birth_parameters as birth,native_simple_birth_factors as factors,native_simple_particle_update as particles,native_simple_animation_policy as animation,native_simple_animation_clock::Clip,native_random::Rng55};
pub struct NativeProjectedCycle {pending:Vec<openleague_core::native_simple_storage::Storage>,state:frame::State,rng:Rng55,start:f32,pub position:Vec3,pub active_count:u32,pub finished:bool,pub normalized_age:f32,pub scale:f32,pub angle:f32,pub color_uv:Vec2}
struct ProjectedSources<'a> {config:&'a SimpleProjectedConfig,start:f32,pending:&'a mut Vec<openleague_core::native_simple_storage::Storage>}
impl animation::Backend for ProjectedSources<'_> {
 fn lookup(&mut self,_:u32)->Option<Clip>{None}
 fn special_kind11(&mut self,_:&mut animation::State){unreachable!("projected profile has no animation")}
 fn evaluate_uncompressed(&mut self,_:Clip,_:u32,_:u32,_:&mut animation::State){unreachable!("projected profile has no animation")}
 fn evaluate_compressed(&mut self,_:Clip,_:u32,_:u32,_:&mut animation::State){unreachable!("projected profile has no animation")}
}
impl frame::Sources for ProjectedSources<'_> {
 fn emission(&mut self,time:u32,progress:u32,resource:&mut u32,storage:&mut Option<particles::State>,born:&mut Vec<u32>,pose:&pose::State,owner:&mut emission::State,rng:&mut Rng55)->Result<(),&'static str>{
  let c=self.config;
  if *resource==0 {
   let timing=openleague_core::native_simple_emission_count::Input{time:f32::from_bits(time),start:self.start,previous:f32::from_bits(owner.previous),life:c.emitter_life,delay:0.,period:f32::MAX,window:f32::MAX,rate:c.emission_rate,single:c.single_particle,emitted:owner.emitted};
   if !openleague_core::native_simple_emission_count::eligible(timing)? {return Ok(());}
   // Storage acquisition remains separate from the signed emission count;
   // constant rate1 single and invisible continuous profiles are qualified.
   let acquired=openleague_core::native_simple_storage::acquire(self.pending,1,0,0);
   *storage=Some(acquired.particles);*born=acquired.birth;*resource=1;
  }
  //91C0C0 defaults: scalarC4/rotation108/vectors zero, no probabilities or
  // attributes; rate/life/D8 scale are explicit authored projection overrides.
  let base=birth::BaseBirth {values:birth::Values {life:c.particle_life.to_bits(),scalar:0,factor:c.scale.to_bits(),rotation:0},position:[0;3],velocity:[0;3],offset:[0;3]};
  let curves=birth::BirthCurves {life:None,scalar:None,factor:None,rotation:None,position:[None;3],velocity:[None;3],offset:[None;3]};
  let factor_sources=factors::Sources {context:[0;3],offset_coefficients:[0;3],bounds_coefficients:[0;3],life_multiplier:None,offset_attribute:None,size_attribute:None};
  let rate=[c.emission_rate];
  let source=sources::Sources {base:&base,curves:&curves,attributes:sources::Attributes {life:None,position:None,velocity:None,rotation:None,offset:None},factors:&factor_sources,rotations:&[],rate_table:&rate,rate_probability:None,rate_factor:1.,rate_attribute:None};
  sources::emit_from_frame(time,progress,*resource,storage,born,pose,owner,rng,openleague_core::native_simple_emission_count::Input {time:f32::from_bits(time),start:self.start,previous:f32::from_bits(owner.previous),life:c.emitter_life,delay:0.,period:f32::MAX,window:f32::MAX,rate:0.,single:c.single_particle,emitted:owner.emitted},&source,particles::Table {values:&[1.],probability:None},0,&mut |_|Err("projected profile has no terrain-follow"))?;Ok(())
 }
 fn modifier(&mut self,_:u32,_:u32,_:u32,_:&mut [u32;16])->Result<(),&'static str>{Err("projected modifier unqualified")}
 fn initialize_manager(&mut self,_:&mut openleague_core::native_simple_auxiliary::Helper)->Result<u8,&'static str>{Err("projected manager unqualified")}
 fn evaluated_pose(&mut self,_:[u32;16])->Result<[u32;16],&'static str>{Err("projected animation pose unqualified")}
}
impl NativeProjectedCycle {
 /// Exchange with the engine-owned stream; callers restore it even on errors.
 pub fn exchange_rng(&mut self,rng:&mut Rng55){std::mem::swap(&mut self.rng,rng);}

 pub fn new(start:f32,owner:&SimpleOwnerPose,c:&SimpleProjectedConfig,rng:Rng55)->Result<Self,&'static str>{
  let supported_single=c.single_particle==1;
  let supported_ambient=c.single_particle==0 && c.particle_life==0. && c.scale==0.;
  if !start.is_finite()||!(supported_single||supported_ambient)||c.emission_rate!=1.||c.simple_orientation!=0{return Err("unqualified constant Simple cycle profile");}
  let identity=Mat4::IDENTITY.to_cols_array().map(f32::to_bits);let matrix=owner.emitter_matrix(c.emitter_local_orientation)?.to_cols_array().map(f32::to_bits);
  let inverse=openleague_core::matrix_inverse::inverse(&matrix.map(f32::from_bits),&identity.map(f32::from_bits)).matrix.map(f32::to_bits);
  let storage=openleague_core::native_simple_storage::Storage::fresh(1,0,0);
  Ok(Self {pending:Vec::new(),state:frame::State {frame:dispatch::State {particles:1,helper:None,animation:animation::State {clock:0,resource:0,pose_flag:0},tail:openleague_core::native_simple_finish::State {previous:matrix,previous_inverse:inverse,last_time:0xff7fffff,finished:0}},pose:pose::State {current:matrix,previous:matrix,initial_inverse:inverse},particles:Some(storage.particles),birth:storage.birth,emission:emission::State {previous:start.to_bits(),emitted:0,counter:0,bounds_factor:1f32.to_bits()}},rng,start,position:owner.position,active_count:0,finished:false,normalized_age:0.,scale:c.scale,angle:0.,color_uv:Vec2::ZERO})
 }
 pub fn gate_child(&self)->openleague_core::native_troy_reset::SimpleChild {
  openleague_core::native_troy_reset::SimpleChild{flag:self.state.emission.emitted,times:[self.state.emission.previous,self.state.frame.tail.last_time],resource:self.state.frame.particles}
 }
 pub fn commit_gate_child(&mut self,child:&openleague_core::native_troy_reset::SimpleChild,pending:&[u32])->Result<(),&'static str>{
  if self.state.frame.particles!=0 && child.resource==0 {
   if pending!=[self.state.frame.particles]{return Err("unexpected projected deferred handles");}
   let particles=self.state.particles.take().ok_or("missing projected gate storage")?;
   self.pending.push(openleague_core::native_simple_storage::Storage{owner:1,context:0,particles,birth:std::mem::take(&mut self.state.birth)});self.active_count=0;
  }else if !pending.is_empty(){return Err("unexpected projected deferred storage");}
  self.state.emission.emitted=child.flag;self.state.emission.previous=child.times[0];self.state.frame.tail.last_time=child.times[1];self.state.frame.particles=child.resource;Ok(())
 }
 /// Native93EF80 child fields; parent gate and frame scheduling are caller-owned.
 pub fn pause_for_visibility(&mut self,source_flags:u32,config_flags:u32)->Result<(),&'static str>{
  use openleague_core::native_troy_reset as reset;
  let mut child=reset::SimpleChild{flag:self.state.emission.emitted,times:[self.state.emission.previous,self.state.frame.tail.last_time],resource:self.state.frame.particles};
  let mut parent=reset::ResetState{handles:[u32::MAX;2],times:[0;3],reset_b8:0,position:[0;3],previous_position:[0;3],flags_1dd:0,field_ec:0};
  let mut deferred=Vec::new();let mut flags=0;
  reset::pause(&mut parent,&mut flags,config_flags,&mut [],&[],std::slice::from_mut(&mut child),&[reset::PauseFilter{source_flags,config_flags}],&mut deferred,&mut SilentPause)?;
  if !deferred.is_empty(){
   let particles=self.state.particles.take().ok_or("missing deferred projected storage")?;
   self.pending.push(openleague_core::native_simple_storage::Storage{owner:1,context:0,particles,birth:std::mem::take(&mut self.state.birth)});self.active_count=0;
  }
  self.state.emission.emitted=child.flag;self.state.emission.previous=child.times[0];self.state.frame.tail.last_time=child.times[1];self.state.frame.particles=child.resource;Ok(())
 }
 pub fn step(&mut self,now:f32,owner:&SimpleOwnerPose,end:Option<&OwnerEnd>,c:&SimpleProjectedConfig)->Result<(),&'static str>{
  self.step_with_bounds(now,owner,end,c,false)
 }
 pub fn step_with_bounds(&mut self,now:f32,owner:&SimpleOwnerPose,end:Option<&OwnerEnd>,c:&SimpleProjectedConfig,last_step:bool)->Result<(),&'static str>{
  if !now.is_finite()||now<self.start||f32::from_bits(self.state.frame.tail.last_time)>now{return Err("invalid projected cycle time");}
  let identity=Mat4::IDENTITY.to_cols_array().map(f32::to_bits);let position=owner.position.to_array().map(f32::to_bits);let previous=self.state.frame.tail.previous[12..15].try_into().unwrap();let time=now.to_bits();
  let (flags,start,emitter_linger,particle_linger)=match end {None=>(0,self.start,0.,0.),Some(e)=>(0x10,e.system_start,e.emitter_linger,e.particle_linger)};
  let input=frame::Input {frame:dispatch::Input {control:openleague_core::native_simple_control::Input {flags,time,start:start.to_bits(),life:c.emitter_life.to_bits(),lower:f32::MAX.to_bits(),upper:f32::MAX.to_bits(),delay:0,emitter_linger:emitter_linger.to_bits(),particle_linger:particle_linger.to_bits(),last_step:u32::from(last_step)},position,previous_position:previous,reset_value:0,manager_flag:None,definition_kind:0,clip_index:0,mapping:0,inverse_fallback:identity},pose:pose::Input {emitter_local:u8::from(c.emitter_local_orientation),warm:self.state.emission.emitted,system_matrix:owner.orientation.to_cols_array().map(f32::to_bits),position,inverse_fallback:identity,modifier:0},particles:particles::Input {time,cap:f32::MAX.to_bits(),birth:&[],bounds_flag:0,previous_position:previous,current_position:position,initial_inverse:self.state.pose.initial_inverse,current_matrix:self.state.pose.current,bind_begin:c.bind_weight.x.to_bits(),bind_end:c.bind_weight.y.to_bits(),sticky:u8::from(c.locked_to_emitter),local:u8::from(c.local_orientation),circular:0,direction:0,force_resource:0,force_graph:None,scalar_enabled:0,scalar_table:particles::Table {values:&[],probability:None},scale_table:particles::Table {values:&[1.],probability:None},attributes:std::array::from_fn(|i|particles::Attribute {mode:c.color_modes[i],multiplier:c.color_scale[i].to_bits(),offset:c.color_offset[i].to_bits()}),bounds_factor:self.state.emission.bounds_factor,terrain_enabled:0}};
  frame::update(&mut self.state,&input,&mut self.rng,&mut ProjectedSources {config:c,start:self.start,pending:&mut self.pending},&mut |_|Err("projected profile has no terrain-follow"),&mut |_|{})?;
  if let Some(p)=self.state.particles.as_ref() {
   if let Some(position)=p.positions.first(){self.position=Vec3::from_array(position.map(f32::from_bits));self.normalized_age=f32::from_bits(p.ages[0]);self.scale=f32::from_bits(p.scales[0]);self.angle=f32::from_bits(p.scalar[0]);self.color_uv=Vec2::new(f32::from_bits(p.attribute_a[0]),f32::from_bits(p.attribute_b[0]));}
   self.active_count=p.active;
  }else{self.active_count=0;}
  self.finished=self.state.frame.tail.finished!=0;Ok(())
 }
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn invisible_continuous_child_matches_native_lifecycle_without_false_parent_completion(){
  let doc=serde_json::from_str(include_str!("../../../data/4.20/particles/annie/Annie_Q_mis.json")).unwrap();
  let mut c=SimpleProjectedConfig::from_troy(&doc,"Projected").unwrap();
  // Explicit constant profile from the native fixture; not an ambient file loader.
  c.single_particle=0;c.particle_life=0.;c.scale=0.;c.emitter_life=f32::MAX;c.local_orientation=false;c.particle_linger=10.;
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/ambient_simple_cycle_contract.json")).unwrap();
  let owner=SimpleOwnerPose::new(Vec3::new(100.,200.,300.),Mat4::IDENTITY,0.).unwrap();
  let mut cycle=NativeProjectedCycle::new(10.,&owner,&c,Rng55 {words:std::array::from_fn(|i|12345+13579*i as u32),first:0,second:0}).unwrap();
  for f in proof["frames"].as_array().unwrap(){
   let age=f["age"].as_f64().unwrap() as f32;
   let owner=SimpleOwnerPose::new(Vec3::new(100.+age*10.,200.,300.),Mat4::IDENTITY,0.).unwrap();
   let end=f["ended"].as_bool().unwrap().then_some(OwnerEnd {system_start:10.,emitter_linger:0.,particle_linger:10.});
   cycle.step(10.+age,&owner,end.as_ref(),&c).unwrap();
   assert_eq!(cycle.finished,f["finished"]==1,"age {age}");
   assert_eq!(cycle.active_count as u64,f["active"].as_u64().unwrap(),"age {age}");
   let particles=cycle.state.particles.as_ref().unwrap();
   assert_eq!(particles.life.len() as u64,f["slots"].as_u64().unwrap(),"age {age}");
   for (values,key) in [(&particles.life,"life_bits"),(&particles.ages,"age_bits")] {
    assert_eq!(*values,f[key].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>(),"{key} age {age}");
   }
  }
 }
 #[test]
 fn core_cycle_matches_fifty_native_owner_end_frames(){
  let doc=serde_json::from_str(include_str!("../../../data/4.20/particles/annie/Annie_Q_mis.json")).unwrap();
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_owner_end_contract.json")).unwrap();let mut checked=0;
  for case in proof["cases"].as_array().unwrap(){
   let mut c=SimpleProjectedConfig::from_troy(&doc,"Projected").unwrap();c.emitter_linger=case["emitter_linger"].as_f64().unwrap() as f32;c.particle_linger=case["particle_linger"].as_f64().unwrap() as f32;
   let owner=|f:&serde_json::Value|{let raw=f["previous_matrix"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();let matrix=Mat4::from_cols_array(&raw.try_into().unwrap());SimpleOwnerPose::new(matrix.w_axis.truncate(),matrix,500.).unwrap()};
   let frames=case["frames"].as_array().unwrap();let mut cycle=NativeProjectedCycle::new(10.,&owner(&frames[0]),&c,Rng55::seeded(17)).unwrap();
   for f in frames{let end=(f["owner_end_flag"]==true).then_some(OwnerEnd {system_start:10.,emitter_linger:c.emitter_linger,particle_linger:c.particle_linger});cycle.step(10.+f["age"].as_f64().unwrap() as f32,&owner(f),end.as_ref(),&c).unwrap();
    if cycle.active_count>0 {assert_eq!(cycle.color_uv,Vec2::new(cycle.normalized_age,1.));}
    assert_eq!(cycle.normalized_age.to_bits(),f["normalized_age_bits"][0].as_u64().unwrap() as u32);assert_eq!(cycle.position.to_array().map(f32::to_bits),std::array::from_fn(|j|(f["position"][j].as_f64().unwrap() as f32).to_bits()));assert_eq!(cycle.active_count,f["active_count"].as_u64().unwrap() as u32);assert_eq!(cycle.finished,f["emitter_finished"]==1);checked+=1;
   }
  }assert_eq!(checked,50);
 }
 #[test]
 fn core_cycle_matches_native_owner_pose_frames(){
  let doc=serde_json::from_str(include_str!("../../../data/4.20/particles/annie/Annie_Q_mis.json")).unwrap();let c=SimpleProjectedConfig::from_troy(&doc,"Projected").unwrap();
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_owner_pose_contract.json")).unwrap();let frames=p["frames"].as_array().unwrap();
  let owner=|f:&serde_json::Value|{let vec=|key:&str|f[key].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();SimpleOwnerPose::new(Vec3::from_slice(&vec("system_position")),Mat4::from_cols_array(&vec("system_orientation").try_into().unwrap()),500.).unwrap()};
  let mut cycle=NativeProjectedCycle::new(10.,&owner(&frames[0]),&c,Rng55::seeded(17)).unwrap();
  for f in frames{cycle.step(10.+f["age"].as_f64().unwrap() as f32,&owner(f),None,&c).unwrap();let expected=std::array::from_fn(|j|(f["position"][j].as_f64().unwrap() as f32).to_bits());assert_eq!(cycle.position.to_array().map(f32::to_bits),expected);assert_eq!(cycle.normalized_age,f["normalized_age"][0].as_f64().unwrap() as f32);assert_eq!(cycle.active_count,f["active_count"].as_u64().unwrap() as u32);assert_eq!(cycle.finished,f["emitter_finished"]==1);assert_eq!(cycle.scale,500.);assert_eq!(cycle.angle,0.);}
 }
}

// The projected child has no audio handles or complex trail resources.
struct SilentPause;
impl openleague_core::native_complex_particle_storage::TrailBackend for SilentPause {
 fn release_particle_trail(&mut self,_:[u32;2]){unreachable!()}
 fn set_particle_index(&mut self,_:[u32;2],_:usize){unreachable!()}
 fn drop_slot(&mut self,_:[u32;2]){unreachable!()}
}
impl openleague_core::native_troy_reset::Backend for SilentPause {fn audio_release(&mut self,_:u32){unreachable!()}}
impl openleague_core::native_troy_reset::PauseBackend for SilentPause {fn audio_pause(&mut self,_:u32,_:u32){unreachable!()}}
#[cfg(test)]
mod visibility_storage_tests {
 use super::*;
 #[test]
 fn projected_visibility_storage_is_deferred_reused_and_expired_without_allocation(){
  let document=serde_json::from_str(include_str!("../../../data/4.20/particles/annie/Annie_Q_mis.json")).unwrap();
  let config=SimpleProjectedConfig::from_troy(&document,"Projected").unwrap();
  let owner=SimpleOwnerPose::new(Vec3::new(100.,200.,300.),Mat4::IDENTITY,config.scale).unwrap();
  let mut cycle=NativeProjectedCycle::new(10.,&owner,&config,Rng55::seeded(17)).unwrap();
  cycle.step(10.125,&owner,None,&config).unwrap();assert_eq!(cycle.active_count,0);assert_eq!(cycle.state.birth.len(),1);
  cycle.step(10.1875,&owner,None,&config).unwrap();assert_eq!(cycle.active_count,1);
  cycle.pause_for_visibility(0,1).unwrap();assert_eq!(cycle.active_count,1);assert!(cycle.pending.is_empty());
  cycle.pause_for_visibility(0,0).unwrap();assert_eq!(cycle.active_count,0);assert!(cycle.state.particles.is_none());assert_eq!(cycle.pending.len(),1);
  cycle.pause_for_visibility(0,0).unwrap();assert_eq!(cycle.pending.len(),1);
  cycle.step(10.25,&owner,None,&config).unwrap();assert_eq!(cycle.active_count,0);assert_eq!(cycle.state.birth,vec![10.25f32.to_bits()]);assert!(cycle.pending.is_empty());
  cycle.step(10.3125,&owner,None,&config).unwrap();assert_eq!(cycle.active_count,1);
  cycle.pause_for_visibility(0,0).unwrap();cycle.step(20.,&owner,None,&config).unwrap();assert!(cycle.state.particles.is_none());assert_eq!(cycle.pending.len(),1);assert!(cycle.finished);
 }
}
