//! Owned Projected child driven by the qualified native parent frame.
//! Clock, quality, camera packet and source policy are explicit caller inputs.
use bevy::prelude::*;
use crate::{native_projected_cycle::NativeProjectedCycle,simple_projected_config::SimpleProjectedConfig,simple_owner_pose::SimpleOwnerPose,simple_cycle::OwnerEnd};
use openleague_core::{native_troy_frame as frame,native_troy_frame_gate as gate,native_troy_resume as audio,native_troy_reset as reset,native_troy_substeps as steps,native_troy_oneshot as oneshot,native_troy_scratch::Scratch};
pub struct Parent {pub state:frame::State,pub child:NativeProjectedCycle,start:f32,done:u8}
pub struct Input<'a>{pub time:f32,pub owner:&'a SimpleOwnerPose,pub direction:Vec3,pub flags:u8,pub source_flags:u32,pub config_flags:u32,pub build_up:f32,pub rate:f32,pub radius:f32,pub scratch:&'a Scratch}
pub trait ParentAudio:audio::Backend+oneshot::Backend {
 fn release(&mut self,key:u32);
 fn position(&mut self,key:u32,position:[u32;3]);
}
pub struct AudioFrame {pub emit:bool,pub one_shot_descriptors:[[u8;24];2],pub root_clock:u32,pub status:u8}
struct NoAudio;
impl audio::Backend for NoAudio {
 fn owner_eligible(&mut self)->u8{unreachable!()}fn owner_id(&mut self)->u32{unreachable!()}
 fn create_primary(&mut self,_:&[u8;24],_:[u32;3],_:u32)->u32{unreachable!()}
 fn create_secondary(&mut self,_:&[u8;24],_:u32,_:[u32;3],_:u32)->u32{unreachable!()}
 fn audio_pause(&mut self,_:u32,_:u32){unreachable!()}
}
impl oneshot::Backend for NoAudio {
 fn owner_eligible(&mut self)->u8{unreachable!()}fn owner_id(&mut self)->u32{unreachable!()}
 fn play_primary(&mut self,_:&[u8;24],_:[u32;3],_:u32){unreachable!()}
 fn play_secondary(&mut self,_:&[u8;24],_:u32,_:[u32;3],_:u32){unreachable!()}
}
impl ParentAudio for NoAudio {fn release(&mut self,_:u32){unreachable!()}fn position(&mut self,_:u32,_:[u32;3]){unreachable!()}}
impl Parent {
 pub fn new(start:f32,owner:&SimpleOwnerPose,c:&SimpleProjectedConfig)->Result<Self,&'static str>{
  Self::new_with_rng(start,owner,c,openleague_core::native_random::Rng55::seeded(17))
 }
 pub fn new_with_rng(start:f32,owner:&SimpleOwnerPose,c:&SimpleProjectedConfig,rng:openleague_core::native_random::Rng55)->Result<Self,&'static str>{
  let initialized=openleague_core::native_troy_resource_initial::start(start,0.,0.)?;
  Ok(Self{start,done:0,child:NativeProjectedCycle::new(start,owner,c,rng)?,state:frame::State{
   audio:audio::State{handles:[u32::MAX;2],descriptors:[[0;24];2],times:[initialized.clock_words[0],initialized.clock_words[2]],position:[0;3],flags_1dc:0,flags_1dd:0,field_ec:initialized.offset_words,global_last_primary:0},
   motion:steps::State{previous:initialized.previous_words,position:initialized.position_words,direction:[0;3],minimum:initialized.minimum_words,maximum:initialized.maximum_words,last:initialized.clock_words[1],flags:0,metrics:[0;2]},clock:0,counter:0}})
 }
 pub fn update(&mut self,i:Input,c:&SimpleProjectedConfig)->Result<gate::Decision,&'static str>{
  self.update_with_audio(i,c,AudioFrame{emit:false,one_shot_descriptors:[[0;24];2],root_clock:0,status:0},&mut NoAudio)
 }
 pub fn update_with_audio(&mut self,i:Input,c:&SimpleProjectedConfig,a:AudioFrame,audio:&mut dyn ParentAudio)->Result<gate::Decision,&'static str>{
  if ![i.time,i.build_up,i.rate,i.radius].iter().all(|v|v.is_finite())||i.rate<=0.||i.time<self.start{return Err("invalid projected parent input");}
  // Caller owns suppression, persistence and stop bits; parent owns all other bits.
  self.state.audio.flags_1dc=(self.state.audio.flags_1dc & !0x59)|(i.flags&0x59);
  self.state.motion.position=i.owner.position.to_array().map(f32::to_bits);self.state.motion.direction=i.direction.to_array().map(f32::to_bits);
  let bounds=openleague_core::native_troy_position_bounds::apply(self.state.motion.position,i.radius.to_bits());self.state.motion.minimum=bounds.minimum;self.state.motion.maximum=bounds.maximum;
  let mut child=self.child.gate_child();let mut pending=Vec::new();let mut done=[self.done];
  let mut backend=Adapter{child:&mut self.child,config:c,owner:i.owner,start:self.start,error:None,audio,root_clock:a.root_clock,status:a.status};
  let decision=frame::update(&mut self.state,&frame::Input{gate:gate::Input{time:i.time.to_bits(),start:self.start.to_bits(),lifetime:c.emitter_life.to_bits(),delay:i.build_up.to_bits(),source_flags:i.source_flags,config_flags:i.config_flags,owner_present:true,bounds:[bounds.minimum[0],bounds.minimum[1],bounds.minimum[2],bounds.maximum[0],bounds.maximum[1],bounds.maximum[2]]},rate:i.rate.to_bits(),emit:a.emit,one_shot_descriptors:a.one_shot_descriptors,bounds_coefficient:i.radius.to_bits()},i.scratch,&mut [],&[],std::slice::from_mut(&mut child),&[reset::PauseFilter{source_flags:i.source_flags,config_flags:i.config_flags}],&mut pending,&mut [],&mut done,&mut backend)?;
  if let Some(error)=backend.error{return Err(error);}
  self.done=done[0];Ok(decision)
 }
}
struct Adapter<'a>{child:&'a mut NativeProjectedCycle,config:&'a SimpleProjectedConfig,owner:&'a SimpleOwnerPose,start:f32,error:Option<&'static str>,audio:&'a mut dyn ParentAudio,root_clock:u32,status:u8}
impl audio::Backend for Adapter<'_>{
 fn owner_eligible(&mut self)->u8{audio::Backend::owner_eligible(self.audio)}fn owner_id(&mut self)->u32{audio::Backend::owner_id(self.audio)}
 fn create_primary(&mut self,d:&[u8;24],p:[u32;3],t:u32)->u32{self.audio.create_primary(d,p,t)}
 fn create_secondary(&mut self,d:&[u8;24],o:u32,p:[u32;3],t:u32)->u32{self.audio.create_secondary(d,o,p,t)}
 fn audio_pause(&mut self,k:u32,p:u32){self.audio.audio_pause(k,p)}
}
impl openleague_core::native_complex_particle_storage::TrailBackend for Adapter<'_>{
 fn release_particle_trail(&mut self,_:[u32;2]){unreachable!()} fn set_particle_index(&mut self,_:[u32;2],_:usize){unreachable!()} fn drop_slot(&mut self,_:[u32;2]){unreachable!()}
}
impl reset::Backend for Adapter<'_>{fn audio_release(&mut self,k:u32){self.audio.release(k)}}
impl reset::PauseBackend for Adapter<'_>{fn audio_pause(&mut self,k:u32,p:u32){self.audio.audio_pause(k,p)}}
impl gate::Backend for Adapter<'_>{fn root_clock(&mut self)->u32{self.root_clock}}
impl oneshot::Backend for Adapter<'_>{
 fn owner_eligible(&mut self)->u8{oneshot::Backend::owner_eligible(self.audio)}fn owner_id(&mut self)->u32{oneshot::Backend::owner_id(self.audio)}
 fn play_primary(&mut self,d:&[u8;24],p:[u32;3],t:u32){self.audio.play_primary(d,p,t)}
 fn play_secondary(&mut self,d:&[u8;24],o:u32,p:[u32;3],t:u32){self.audio.play_secondary(d,o,p,t)}
}
impl steps::Backend for Adapter<'_>{
 fn status(&mut self)->u8{self.status}
 fn complex_update(&mut self,_:usize,_:u32,_:&steps::State)->u8{unreachable!()}
 fn simple_update(&mut self,index:usize,time:u32,last:bool,state:&steps::State)->u8{
  assert_eq!(index,0);if self.error.is_some(){return 0;}
  let result=(||{
   let owner=SimpleOwnerPose::new(Vec3::from_array(state.position.map(f32::from_bits)),self.owner.orientation,self.config.scale)?;
   let end=(state.flags&0x10!=0).then_some(OwnerEnd{system_start:self.start,emitter_linger:self.config.emitter_linger,particle_linger:self.config.particle_linger});
   self.child.step_with_bounds(f32::from_bits(time),&owner,end.as_ref(),self.config,last)
  })();self.error=result.err();u8::from(self.child.finished)
 }
}
impl frame::Backend for Adapter<'_>{
 fn audio_position(&mut self,k:u32,p:[u32;3]){self.audio.position(k,p)}
 fn commit_simple_gate(&mut self,children:&[reset::SimpleChild],pending:&[u32])->Result<(),&'static str>{
  if children.len()!=1{return Err("projected parent requires one child");}self.child.commit_gate_child(&children[0],pending)
 }
}
#[cfg(test)]mod tests{
 use super::*;
 #[test]fn parent_suspends_actual_storage_and_restarts_then_expires(){
  let doc=serde_json::from_str(include_str!("../../../data/4.20/particles/annie/Annie_Q_mis.json")).unwrap();let c=SimpleProjectedConfig::from_troy(&doc,"Projected").unwrap();
  let owner=SimpleOwnerPose::new(Vec3::new(100.,200.,300.),Mat4::IDENTITY,c.scale).unwrap();let scratch=Scratch::default();let mut p=Parent::new(10.,&owner,&c).unwrap();
  let update=|p:&mut Parent,time,flags|p.update(Input{time,owner:&owner,direction:Vec3::ZERO,flags,source_flags:0,config_flags:0x40,build_up:0.,rate:30.,radius:250.,scratch:&scratch},&c).unwrap();
  update(&mut p,10.125,1);update(&mut p,10.25,1);assert_eq!(p.child.active_count,1);
  assert_eq!(update(&mut p,10.375,9).path,gate::Path::Skip);assert_eq!(p.child.active_count,0);assert_eq!(p.child.gate_child().resource,0);
  let last=p.state.motion.last;update(&mut p,10.5,9);assert_eq!(p.state.motion.last,last);
  assert_eq!(update(&mut p,10.625,1).path,gate::Path::Continue);assert_ne!(p.child.gate_child().resource,0);
  update(&mut p,10.75,1);assert_eq!(p.child.active_count,1);
  assert_eq!(update(&mut p,10.875,0x58).path,gate::Path::Stop);
 }
}
