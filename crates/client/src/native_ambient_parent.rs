//! Actual ambient Simple child and native parent audio policy.
//! Host frame inputs remain explicit; logical registration is not physical playback.
use crate::{native_projected_parent::{Parent,Input,ParentAudio,AudioFrame},simple_projected_config::SimpleProjectedConfig,simple_owner_pose::SimpleOwnerPose};
use openleague_core::{audio_logical_registration::Manager,audio_requests::Request,native_random::Rng55,native_troy_resume as audio,native_troy_oneshot as oneshot,native_troy_frame_gate::Decision};
pub struct AmbientParent {pub parent:Parent,pub config_flags:u32,pub radius:f32,pub build_up:f32,config:SimpleProjectedConfig,persistent:String,creation:String}
/// Host scheduling/instance state stays explicit; resource policy and camera planes
/// are resolved here so callers cannot accidentally substitute animation-event flags.
pub struct SceneFrame<'a> {
 pub time:f32,pub owner:&'a SimpleOwnerPose,pub direction:bevy::prelude::Vec3,
 pub instance_flags:u8,pub source_flags:u32,pub quality_setting:u32,
 pub root_clock:u32,pub status:u8,pub emit:bool,
 pub camera:&'a crate::camera_native::NativeCamera,pub aspect:f32,
}
// Presence-only host descriptor. No native pointer or heap string is fabricated:
// callbacks resolve the owned string retained alongside this policy descriptor.
fn descriptor(name:&str)->[u8;24] {let mut d=[0;24];d[16..20].copy_from_slice(&(name.len() as u32).to_le_bytes());d}
impl AmbientParent {
 pub fn new(document:&serde_json::Value,start:f32,owner:&SimpleOwnerPose,rng:Rng55)->Result<Self,String>{
  let config=SimpleProjectedConfig::from_ambient_troy(document)?;
  let system=&document["sections"]["System"];
  let event=|key:&str|->Result<String,String>{match system.get(key){None=>Ok(String::new()),Some(v)=>{
   let s=v.as_str().ok_or("audio event must be a string")?;
   if !s.is_ascii()||s.as_bytes().contains(&0)||s.len()>4096{return Err("unsupported audio event".into());}Ok(s.into())
  }}};
  let persistent=event("SoundPersistent")?;let creation=event("SoundOnCreate")?;
  if system.as_object().ok_or("missing System")?.keys().any(|k|k.starts_with("Sound")&&k!="SoundPersistent"&&k!="SoundOnCreate"&&k!="SoundEndsOnEmitterEnd"&&k!="SoundsPlayWhileOffScreen") {return Err("unsupported secondary ambient sound".into());}
  let mut parent=Parent::new_with_rng(start,owner,&config,rng).map_err(str::to_owned)?;
  parent.state.audio.descriptors[0]=descriptor(&persistent);
  let config_flags=openleague_core::native_troy_simulation_flags::system_flags(system).map_err(str::to_owned)?;
  let build_up=openleague_core::native_troy_simulation_flags::build_up_time(system).map_err(str::to_owned)?;
  let radius=match system.get("group-vis"){None=>250.,Some(v)=>v.as_f64().ok_or("invalid group-vis")? as f32};
  if !radius.is_finite(){return Err("nonfinite group-vis".into());}
  Ok(Self{parent,config_flags,radius,build_up,config,persistent,creation})
 }
 pub fn update_scene_shared(&mut self,i:SceneFrame,logical:&mut Manager,transient:&mut Vec<Request>,rng:&mut Rng55)->Result<Decision,String>{
  self.parent.child.exchange_rng(rng);
  let result=self.update_scene(i,logical,transient);
  self.parent.child.exchange_rng(rng);
  result
 }
 pub fn update_scene(&mut self,i:SceneFrame,logical:&mut Manager,transient:&mut Vec<Request>)->Result<Decision,String>{
  // Fail before any parent/audio mutation if the camera has not produced a pose.
  let volume=i.camera.culling_volume(i.aspect).map_err(str::to_owned)?;
  let mut scratch=openleague_core::native_troy_scratch::Scratch::default();
  scratch.set_visibility_inputs(std::array::from_fn(|n|volume.planes[n].coefficients.map(f32::to_bits)),std::array::from_fn(|n|volume.planes[n].indices.map(|j|j as u32)));
  let rate=f32::from_bits(openleague_core::native_troy_simulation_flags::engine_timing_words(i.quality_setting)[0]);
  self.update(Input{time:i.time,owner:i.owner,direction:i.direction,flags:i.instance_flags,source_flags:i.source_flags,config_flags:self.config_flags,build_up:self.build_up,rate,radius:self.radius,scratch:&scratch},i.emit,i.root_clock,i.status,logical,transient)
 }
 pub fn update(&mut self,input:Input,emit:bool,root_clock:u32,status:u8,logical:&mut Manager,transient:&mut Vec<Request>)->Result<Decision,String>{
  let mut backend=Backend{persistent:&self.persistent,creation:&self.creation,logical,transient,error:None};
  let result=self.parent.update_with_audio(input,&self.config,AudioFrame{emit,one_shot_descriptors:[descriptor(&self.creation),[0;24]],root_clock,status},&mut backend).map_err(str::to_owned)?;
  if let Some(error)=backend.error{return Err(error.into());}Ok(result)
 }
}
struct Backend<'a>{persistent:&'a str,creation:&'a str,logical:&'a mut Manager,transient:&'a mut Vec<Request>,error:Option<&'static str>}
impl Backend<'_>{
 fn request(name:&str,slot:u32,p:[u32;3],t:u32)->Request{Request{slot,event:name.into(),position:p.map(f32::from_bits),age:f32::from_bits(t)}}
 fn pause(&mut self,key:u32,value:u32){self.logical.update_boolean(key,value as u8);}
}
impl audio::Backend for Backend<'_>{
 fn owner_eligible(&mut self)->u8{0}fn owner_id(&mut self)->u32{0}
 fn create_primary(&mut self,d:&[u8;24],p:[u32;3],t:u32)->u32{
  if *d!=descriptor(self.persistent){self.error=Some("unexpected persistent descriptor");return u32::MAX;}
  match self.logical.register(&Self::request(self.persistent,0x10,p,t)){Ok(h)=>h as u32,Err(e)=>{self.error=Some(e);u32::MAX}}
 }
 fn create_secondary(&mut self,_:&[u8;24],_:u32,_:[u32;3],_:u32)->u32{self.error=Some("secondary ambient audio unsupported");u32::MAX}
 fn audio_pause(&mut self,k:u32,p:u32){self.pause(k,p)}
}
impl oneshot::Backend for Backend<'_>{
 fn owner_eligible(&mut self)->u8{0}fn owner_id(&mut self)->u32{0}
 fn play_primary(&mut self,d:&[u8;24],p:[u32;3],t:u32){
  if *d!=descriptor(self.creation){self.error=Some("unexpected creation descriptor");return;}
  let request=Self::request(self.creation,0x18,p,t);
  if !request.age.is_finite()||request.position.iter().any(|v|!v.is_finite()){self.error=Some("invalid transient context");return;}
  self.transient.push(request);
 }
 fn play_secondary(&mut self,_:&[u8;24],_:u32,_:[u32;3],_:u32){self.error=Some("secondary ambient audio unsupported");}
}
impl ParentAudio for Backend<'_>{
 fn release(&mut self,key:u32){self.logical.queue_release(key as i32)}
 fn position(&mut self,key:u32,p:[u32;3]){if let Err(e)=self.logical.update_position(key,p.map(f32::from_bits)){self.error=Some(e);}}
}
#[cfg(test)]mod tests{
 use super::*;use bevy::prelude::*;use openleague_core::native_troy_scratch::Scratch;
 fn owner(x:f32)->SimpleOwnerPose{SimpleOwnerPose::new(Vec3::new(x,200.,300.),Mat4::IDENTITY,0.).unwrap()}
 fn step(p:&mut AmbientParent,m:&mut Manager,q:&mut Vec<Request>,time:f32,x:f32,flags:u8,config:u32)->Decision{
  p.update(Input{time,owner:&owner(x),direction:Vec3::ZERO,flags,source_flags:0,config_flags:config,build_up:0.,rate:30.,radius:0.,scratch:&Scratch::default()},true,99,0,m,q).unwrap()
 }
 #[test]fn ambient_parent_keeps_real_child_and_routes_position_pause_release_and_resume(){
  let doc=serde_json::from_str(include_str!("../../../data/4.20/particles/Audio-Emitter_TT_Shopkeeper_idle.json")).unwrap();
  let mut p=AmbientParent::new(&doc,10.,&owner(100.),Rng55::seeded(17)).unwrap();assert_eq!(p.config_flags,0x84);let mut m=Manager::default();let mut q=vec![];
  step(&mut p,&mut m,&mut q,10.125,100.,1,0);assert_eq!(p.parent.state.audio.handles[0],1);
  assert_eq!(m.entry(1).unwrap().event,"Play_sfx_TT_Shopkeeper_idle1");assert_eq!(m.entry(1).unwrap().backend_reference,-1);
  step(&mut p,&mut m,&mut q,10.25,150.,1,0);assert_eq!(m.entry(1).unwrap().position,[150.,200.,300.]);assert_eq!(m.pending_key_calls(),&[1]);assert!(!p.parent.child.finished);
  assert_eq!(step(&mut p,&mut m,&mut q,10.375,200.,9,0).path,openleague_core::native_troy_frame_gate::Path::Skip);
  assert_eq!(m.entry(1).unwrap().position,[150.,200.,300.]);assert_eq!(m.entry(1).unwrap().flag30_raw,1);assert_eq!(m.release_keys(),&[1]);
  step(&mut p,&mut m,&mut q,10.5,250.,1,0);assert_eq!(p.parent.state.audio.handles[0],2);assert_eq!(m.entry(2).unwrap().position,[250.,200.,300.]);assert!(q.is_empty());
 }
 #[test]fn ambient_parent_persistent_config_keeps_handle_while_hidden_and_creation_posts_once(){
  for (raw,persistent) in [(include_str!("../../../data/4.20/particles/Audio-Emitter_TT_Shopkeeper_idle2.json"),true),(include_str!("../../../data/4.20/particles/Audio-Emitter_TT_BrazierChains.json"),false)]{
   let doc=serde_json::from_str(raw).unwrap();let mut p=AmbientParent::new(&doc,10.,&owner(100.),Rng55::seeded(17)).unwrap();assert_eq!(p.config_flags,0x84);let mut m=Manager::default();let mut q=vec![];
   step(&mut p,&mut m,&mut q,10.125,100.,1,0x20);step(&mut p,&mut m,&mut q,10.25,150.,9,0x20);step(&mut p,&mut m,&mut q,10.375,200.,1,0x20);
   if persistent {assert_eq!(m.pending_key_calls(),&[1]);assert!(m.release_keys().is_empty());assert_eq!(m.entry(1).unwrap().flag30_raw,0);assert_eq!(m.entry(1).unwrap().position,[200.,200.,300.]);assert!(q.is_empty());}
   else {assert_eq!(q.len(),1);assert_eq!(q[0].event,"Play_sfx_Env_Map10_Emitter_brazierchain");assert_eq!(q[0].age,0.);assert_eq!(q[0].slot,0x18);}
  }
 }
}

#[cfg(test)]mod scene_tests{
 use super::*;use bevy::prelude::*;
 #[test]fn real_camera_pan_releases_and_reacquires_actual_ambient_resource(){
  let doc=serde_json::from_str(include_str!("../../../data/4.20/particles/Audio-Emitter_TT_Shopkeeper_idle.json")).unwrap();
  for aspect in [0.75,16./9.] {
   let owner=SimpleOwnerPose::new(Vec3::new(7400.,0.,7700.),Mat4::IDENTITY,0.).unwrap();
   let mut p=AmbientParent::new(&doc,10.,&owner,Rng55::seeded(17)).unwrap();
   assert_eq!((p.config_flags,p.radius,p.build_up),(0x84,250.,0.));
   let mut camera=crate::camera_native::NativeCamera::default();let mut logical=Manager::default();let mut transient=vec![];
   let step=|p:&mut AmbientParent,camera:&crate::camera_native::NativeCamera,logical:&mut Manager,transient:&mut Vec<Request>,time|p.update_scene(SceneFrame{time,owner:&owner,direction:Vec3::ZERO,instance_flags:0,source_flags:0x10,quality_setting:3,root_clock:77,status:0,emit:true,camera,aspect},logical,transient);
   assert!(step(&mut p,&camera,&mut logical,&mut transient,10.125).is_err());
   assert!(logical.pending_key_calls().is_empty());assert_eq!(p.parent.state.audio.handles,[u32::MAX;2]);
   camera.pose(owner.position/20.,0.016,10.125).unwrap();
   assert!(step(&mut p,&camera,&mut logical,&mut transient,10.125).unwrap().visible);
   assert_eq!(logical.pending_key_calls(),&[1]);assert_eq!(logical.entry(1).unwrap().position,owner.position.to_array());
   camera.pose(Vec3::new(150.,0.,220.),0.016,10.25).unwrap();
   let hidden=step(&mut p,&camera,&mut logical,&mut transient,10.25).unwrap();assert!(!hidden.visible);
   assert_eq!(hidden.path,openleague_core::native_troy_frame_gate::Path::Skip);assert_eq!(logical.release_keys(),&[1]);
   camera.pose(owner.position/20.,0.016,10.375).unwrap();
   assert!(step(&mut p,&camera,&mut logical,&mut transient,10.375).unwrap().visible);
   assert_eq!(logical.pending_key_calls(),&[1,2]);assert_eq!(p.parent.state.clock,77);assert!(transient.is_empty());
  }
 }
 #[test]fn qualified_sound_policy_fields_are_not_rejected_as_secondary_descriptors(){
  let mut doc:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/particles/Audio-Emitter_TT_Shopkeeper_idle.json")).unwrap();
  doc["sections"]["System"]["SoundsPlayWhileOffScreen"]=true.into();doc["sections"]["System"]["SoundEndsOnEmitterEnd"]=true.into();
  let owner=SimpleOwnerPose::new(Vec3::ZERO,Mat4::IDENTITY,0.).unwrap();
  assert_eq!(AmbientParent::new(&doc,0.,&owner,Rng55::seeded(17)).unwrap().config_flags,0xb4);
  doc["sections"]["System"]["SoundUnknown"]="event".into();assert!(AmbientParent::new(&doc,0.,&owner,Rng55::seeded(17)).is_err());
 }
}
