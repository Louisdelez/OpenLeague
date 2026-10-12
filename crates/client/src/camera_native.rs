//! Map10 native normal-camera math, bridged to the client's native-units/20 coordinates.
use bevy::prelude::*;
use openleague_core::{camera_defaults::Defaults,camera_focus::{State as Focus,Context,Restriction},camera_sequence::{self,State,Angles},camera_parameters::Parameters,camera_zoom::Zoom};
#[derive(Resource)]
pub struct NativeCamera {last_parameters:Option<Parameters>,defaults:Defaults,state:State,restriction:Restriction,map_far:f32,wheel:openleague_core::camera_wheel::Settings,shake_probe:Option<ShakeProbe>}
impl Default for NativeCamera {
 fn default()->Self {
  let defaults=Defaults::original_initial([0;3],10);
  let mut zoom=Zoom::original_initial(None,None);zoom.scale_raw=defaults.zoom_scale.to_bits();
  let settings:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/camera_map10_settings.json")).expect("native Map10 camera settings");
  let values=&settings["native_values"];let value=|key:&str|values[key].as_f64().expect("camera bound") as f32;
  let restriction=Restriction{min_x:value("cam_MinX"),max_x:value("cam_MaxX"),min_z:value("cam_MinY"),max_z:value("cam_MaxY"),center:[0.;3],radius:0.};
  Self {last_parameters:None,defaults,state:State{focus:Focus{current:defaults.current,saved:[0.;3],held_raw:0},zoom},restriction,map_far:value("cam_FarZ"),wheel:Default::default(),shake_probe:probe_from_environment().expect("valid camera shake diagnostic")}
 }
}
impl NativeCamera {
 pub fn native_focus(&self)->[f32;3]{self.state.focus.current}
 /// Last successfully rendered native pose, including shake and native depth settings.
 pub fn native_parameters(&self)->Option<&Parameters>{self.last_parameters.as_ref()}
 pub fn culling_volume(&self,aspect:f32)->Result<openleague_core::audio_emitter_camera_volume::Volume,&'static str>{
  let camera=self.native_parameters().ok_or("native camera has no successful pose")?;
  if !aspect.is_finite() || aspect<=0. {return Err("invalid camera culling aspect");}
  Ok(openleague_core::camera_culling::from_parameters(camera,aspect,&Mat4::IDENTITY.to_cols_array())?.volume)
 }

 /// Windows winit line units are raw WM_MOUSEWHEEL signed high-word / WHEEL_DELTA120.
 /// UI capture and original event producer remain reconstructed, not qualified.
 pub fn scroll(&mut self,unit:bevy::input::mouse::MouseScrollUnit,lines:f32)->Result<(),&'static str> {
  let delta=windows_wheel_delta(unit,lines)?;
  self.wheel.apply(&mut self.state.zoom.target,delta,0);
  Ok(())
 }
 pub fn pose(&mut self,render_focus:Vec3,delta:f32,now:f32)->Result<(Transform,Projection,Vec3),&'static str> {
  // Game entities, terrain raycasts and the Map10 GLB share native XYZ /20.
  // Camera math already consumes that direct basis; no world reflection belongs here.
  let focus=(render_focus*20.).to_array();
  self.state.focus.current=focus;
  let d=self.defaults;let angles=Angles{pitch:d.pitch_degrees,yaw:d.yaw_degrees,previous_yaw:d.previous_yaw_degrees,fov:d.fov_degrees};
  // Inactive native service flags: input/follow is still supplied by the client.
  let context=Context{active_raw:0,service_flag_raw:0,special_flag_raw:0};
  let mut initial=Parameters::original_initial(focus);
  let near_raw=initial.near.to_bits();
  camera_sequence::apply_renderer_depth(&mut initial,near_raw,self.map_far.to_bits());
  let (state,result)=camera_sequence::step_without_auto_follow(&initial,&self.state,&context,&self.restriction,&angles,delta)?;
  self.state=state;
  let mut camera=result.camera;
  if let Some(probe)=&mut self.shake_probe {probe.apply(&mut camera,now)?;}
  let eye=Vec3::from_array(camera.position)/20.;let direction=Vec3::from_array(camera.direction);
  let transform=Transform::from_translation(eye).looking_to(direction,Vec3::from_array(camera.up));
  // Preserve Bevy reverse depth and compensate only the LH/RH screen-X mismatch.
  // Native depth matrices are not copied into the GPU convention.
  let projection=crate::camera_projection_bridge::projection(camera.fov_degrees.to_radians(),camera.near/20.,camera.far/20.);
  self.last_parameters=Some(camera);
  Ok((transform,projection,Vec3::from_array(self.state.focus.current)/20.))
 }
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn map10_pose_uses_native_geometry_and_points_at_the_supplied_focus() {
  let mut controller=NativeCamera::default();
  assert!(controller.culling_volume(16./9.).is_err());
  for focus in [Vec3::new(370.,5.,385.),Vec3::new(150.,0.,450.),Vec3::new(700.,-5.,220.),Vec3::new(-100.,999.,800.),Vec3::new(1000.,-999.,-100.)] {
   let (transform,projection,focus)=controller.pose(focus,0.016,0.016).unwrap();
   assert_eq!(focus.y,0.);assert!((40.0..=735.0).contains(&focus.x));assert!((210.0..=500.0).contains(&focus.z));
   let expected=(focus-transform.translation).normalize();
   assert!(transform.forward().dot(expected)>0.999999);
   assert!(transform.translation.y>focus.y);
   assert!(transform.translation.z<focus.z);
   let p=crate::camera_projection_bridge::perspective(&projection).expect("native perspective expected");
   assert_eq!(p.fov,50_f32.to_radians());assert_eq!(p.near,2.5);assert_eq!(p.far,250.);
   assert!((transform.translation.distance(focus)-90.).abs()<0.001);
   let native=controller.native_parameters().unwrap();
   assert!((Vec3::from_array(native.position)/20.-transform.translation).length()<0.0001);
   for aspect in [0.5,1.,16./9.] {
    let volume=controller.culling_volume(aspect).unwrap();
    let mut packet=openleague_core::native_troy_scratch::Scratch::default();
    packet.set_visibility_inputs(std::array::from_fn(|i|volume.planes[i].coefficients.map(f32::to_bits)),std::array::from_fn(|i|volume.planes[i].indices.map(|j|j as u32)));
    let native_focus=(focus*20.).to_array();
    let bounds=[native_focus[0]-1.,native_focus[1]-1.,native_focus[2]-1.,native_focus[0]+1.,native_focus[1]+1.,native_focus[2]+1.];
    assert!(packet.contains_bounds(bounds.map(f32::to_bits)).unwrap());
    let behind=Vec3::from_array(native.position)-Vec3::from_array(native.direction).normalize()*1000.;
    assert!(!packet.contains_bounds([behind.x,behind.y,behind.z,behind.x,behind.y,behind.z].map(f32::to_bits)).unwrap());
   }
   assert!(controller.culling_volume(0.).is_err());
  }
 }
}

/// Network snapshot supplies the local-player target; historical UI/provider flags are reconstructed.
pub fn initialize_snapshot_focus(network_id:u32,native_position:[f32;3])->Vec3 {
 use openleague_core::camera_target::{self,Context};
 let registry=std::collections::BTreeMap::from([(network_id,native_position)]);
 let context=Context{follow_block_raw:0,service_active_raw:1,ui_present:true,target_provider_present:true};
 let out=camera_target::initialize_missing_focus([-1000.;3],&context,&[network_id],false,0,&registry);
 Vec3::from_array(out.focus)/20.
}

#[cfg(test)]
mod initialization_tests {
 use super::*;
 #[test]
 fn snapshot_target_keeps_native_position_and_zero_id_cannot_resolve() {
  for id in [1,0x80000000,u32::MAX] {
   let position=[14700.,44.,8100.];
   assert_eq!(initialize_snapshot_focus(id,position),Vec3::from_array(position)/20.);
  }
  assert_eq!(initialize_snapshot_focus(0,[14700.,44.,8100.]),Vec3::splat(-50.));
 }
}

/// Explicit diagnostic event, not a substitute for unqualified native spell/effect triggers.
struct ShakeProbe {state:openleague_core::camera_shake::State,rng:openleague_core::native_random::Rng55,rows:Vec<serde_json::Value>,initial:serde_json::Value,path:Option<std::path::PathBuf>,written:bool}
fn shake_words(s:&openleague_core::camera_shake::State)->[u32;8] {[s.offsets[0].to_bits(),s.offsets[1].to_bits(),s.offsets[2].to_bits(),s.duration.to_bits(),s.started.to_bits(),s.amplitude.to_bits(),s.next_change.to_bits(),s.frequency.to_bits()]}
fn camera_words(c:&Parameters)->[u32;16] {[c.position[0].to_bits(),c.position[1].to_bits(),c.position[2].to_bits(),c.near.to_bits(),c.far.to_bits(),c.direction[0].to_bits(),c.direction[1].to_bits(),c.direction[2].to_bits(),c.up[0].to_bits(),c.up[1].to_bits(),c.up[2].to_bits(),c.fov_degrees.to_bits(),c.projection_raw,c.width.to_bits(),c.height.to_bits(),c.auxiliary_raw]}
impl ShakeProbe {
 fn configured(raw:&str,path:Option<std::path::PathBuf>)->Result<Self,&'static str> {
  let v:serde_json::Value=serde_json::from_str(raw).map_err(|_|"invalid shake probe JSON")?;
  let seed=v["seed"].as_u64().filter(|n|*n<=u32::MAX as u64).ok_or("explicit u32 RNG seed required")? as u32;
  let value=|key:&str|v[key].as_f64().map(|f|f as f32).filter(|f|f.is_finite()).ok_or("finite shake probe parameter required");
  let duration=value("duration")?;let amplitude=value("amplitude")?;let frequency=value("frequency")?;
  if duration<=0.||amplitude<0.||frequency<=0. {return Err("positive duration/frequency and nonnegative amplitude required");}
  let state=openleague_core::camera_shake::State{offsets:[0.;3],duration,started:0.,amplitude,next_change:0.,frequency,active_raw:1};let rng=openleague_core::native_random::Rng55::seeded(seed);
  let initial=serde_json::json!({"seed":seed,"shake_bits":shake_words(&state),"active_raw":state.active_raw,"rng":{"words":rng.words.to_vec(),"first":rng.first,"second":rng.second}});
  Ok(Self{state,rng,rows:Vec::new(),initial,path,written:false})
 }
 fn apply(&mut self,camera:&mut Parameters,now:f32)->Result<(),&'static str> {
  let before=camera_words(camera);let draws=openleague_core::camera_shake::update(&mut self.state,camera,now,&mut self.rng)?;
  if self.path.is_some()&&!self.written {
   if self.rows.len()>=8000 {return Err("shake trace capacity exceeded before capture");}
   self.rows.push(serde_json::json!({"now_bits":now.to_bits(),"initial_camera_bits":before,"output_camera_bits":camera_words(camera),"shake_bits":shake_words(&self.state),"active_raw":self.state.active_raw,"draws":draws,"rng":{"words":self.rng.words.to_vec(),"first":self.rng.first,"second":self.rng.second}}));
   if now>=26. {
    let document=serde_json::json!({"diagnostic":true,"initial":self.initial,"frames":self.rows,"native_triggers_complete":false});
    std::fs::write(self.path.as_ref().unwrap(),serde_json::to_vec_pretty(&document).map_err(|_|"shake trace encoding failed")?).map_err(|_|"shake trace write failed")?;
    self.written=true;println!("Native camera shake trace captured: {}frames",self.rows.len());self.rows.clear();
   }
  }
  Ok(())
 }
}
fn probe_from_environment()->Result<Option<ShakeProbe>,&'static str> {
 let Ok(raw)=std::env::var("OPENLEAGUE_CAMERA_SHAKE_PROBE") else {return Ok(None)};
 if std::env::var_os("OPENLEAGUE_SCREENSHOT").is_none() {return Err("shake diagnostic requires screenshot mode");}
 let path=std::env::var_os("OPENLEAGUE_CAMERA_SHAKE_TRACE").map(std::path::PathBuf::from);
 ShakeProbe::configured(&raw,path).map(Some)
}
#[cfg(test)]
mod shake_probe_tests {
 use super::*;
 #[test]
 fn probe_requires_explicit_valid_seed_and_finite_parameters() {
  for raw in ["{}",r#"{"seed":4294967296,"duration":1,"amplitude":10,"frequency":1}"#,r#"{"seed":1,"duration":0,"amplitude":10,"frequency":1}"#] {assert!(ShakeProbe::configured(raw,None).is_err());}
 }
 #[test]
 fn configured_probe_moves_camera_without_reaiming_then_expires() {
  let mut probe=ShakeProbe::configured(r#"{"seed":42,"duration":2,"amplitude":10,"frequency":10}"#,None).unwrap();
  let mut camera=Parameters::original_initial([7000.,1500.,6600.]);camera.direction=[0.,-0.8,0.6];let direction=camera.direction;let position=camera.position;
  probe.apply(&mut camera,0.1).unwrap();assert_ne!(camera.position,position);assert_eq!(camera.direction,direction);
  let position=camera.position;probe.apply(&mut camera,3.).unwrap();assert_eq!(probe.state.active_raw,0);assert_eq!(camera.position,position);
 }
}

fn windows_wheel_delta(unit:bevy::input::mouse::MouseScrollUnit,lines:f32)->Result<i32,&'static str> {
 if unit!=bevy::input::mouse::MouseScrollUnit::Line {return Err("pixel wheel units unsupported pending native conversion qualification");}
 if !lines.is_finite() {return Err("nonfinite wheel input");}
 let raw=(f64::from(lines)*120.).round();
 if raw < f64::from(i16::MIN) || raw > f64::from(i16::MAX) {return Err("wheel input exceeds Windows signed high-word range");}
 Ok(raw as i32)
}
#[cfg(test)]
mod wheel_tests {
 use super::*;
 use bevy::input::mouse::MouseScrollUnit;
 #[test]
 fn recovers_all_65536_windows_wheel_values_and_rejects_unqualified_units() {
  for delta in i16::MIN..=i16::MAX {assert_eq!(windows_wheel_delta(MouseScrollUnit::Line,f32::from(delta)/120.).unwrap(),i32::from(delta));}
  assert!(windows_wheel_delta(MouseScrollUnit::Pixel,1.).is_err());
  for lines in [f32::NAN,f32::INFINITY,1000.,-1000.] {assert!(windows_wheel_delta(MouseScrollUnit::Line,lines).is_err());}
 }
 #[test]
 fn wheel_changes_native_target_then_smooths_view_to_both_original_limits() {
  let mut c=NativeCamera::default();let focus=Vec3::new(370.,0.,385.);
  c.scroll(MouseScrollUnit::Line,1.).unwrap();assert_eq!(c.state.zoom.target,2130.);
  let before=c.pose(focus,0.,0.).unwrap().0.translation;
  let after=c.pose(focus,0.016,0.016).unwrap().0.translation;
  assert!(after.distance(focus)<before.distance(focus));
  c.scroll(MouseScrollUnit::Line,20.).unwrap();assert_eq!(c.state.zoom.target,1000.);
  for i in 0..120 {c.pose(focus,0.016,i as f32*0.016).unwrap();}
  assert_eq!(c.state.zoom.current,1000.);
  assert!((c.pose(focus,0.016,2.).unwrap().0.translation.distance(focus)-40.).abs()<0.001);
  c.scroll(MouseScrollUnit::Line,-20.).unwrap();assert_eq!(c.state.zoom.target,2250.);
  for i in 0..120 {c.pose(focus,0.016,2.+i as f32*0.016).unwrap();}
  assert_eq!(c.state.zoom.current,2250.);
  assert!((c.pose(focus,0.016,4.).unwrap().0.translation.distance(focus)-90.).abs()<0.001);
 }
}

/// The server result supplies the destroyed nexus independently of fog-filtered actors.
#[derive(Resource,Default)] pub struct EndPan {key:Option<(u64,u64)>,pub initial:Option<[f32;3]>,pub started:Option<f32>,pub pan:Option<openleague_core::camera_pan::Pan>}
impl EndPan {
 pub fn apply(&mut self,result:Option<&openleague_core::match_results::MatchResult>,focus:[f32;3],now:f32)->Option<[f32;3]> {
  let key=result.map(|r|(r.session,r.ended_tick));
  if self.key!=key {self.key=key;self.initial=key.map(|_|focus);self.started=key.map(|_|now);self.pan=result.and_then(|r|r.destroyed_nexus.as_ref()).map(|n|openleague_core::camera_pan::Pan::new(focus,n.position,now,crate::endgame_timeline::schedule().pan as f32));}
  self.pan.as_mut().map(|pan|pan.update(now))
 }
}

#[cfg(test)]
#[path="nexus_glow_camera_tests.rs"]
mod glow_tests;
