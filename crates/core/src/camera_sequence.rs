//! Ordered normal camera focus/geometry sequence, with automatic target resolution and shake inactive.
use crate::{camera_focus::{self,State as Focus,Context,Restriction},camera_normal::{self,Controls,Assembly},camera_parameters::Parameters,camera_zoom::Zoom};
#[derive(Debug,Clone,Copy)]
pub struct State {pub focus:Focus,pub zoom:Zoom}
#[derive(Debug,Clone,Copy)]
pub struct Angles {pub pitch:f32,pub yaw:f32,pub previous_yaw:f32,pub fov:f32}
/// Source7CFB70 clears Y before focus holds/restrictions; preserved saved focus can restore it.
/// Caller must resolve the automatic target phase separately or keep it inactive.
pub fn step_without_auto_follow(initial:&Parameters,state:&State,context:&Context,restriction:&Restriction,angles:&Angles,delta:f32)->Result<(State,Assembly),&'static str> {
 let mut focus=state.focus;focus.current[1]=0.;focus=camera_focus::update(&focus,context,restriction)?;
 let controls=Controls{focus_after_update:focus.current,pitch_degrees:angles.pitch,yaw_degrees:angles.yaw,previous_yaw_degrees:angles.previous_yaw,fov_degrees:angles.fov,zoom:state.zoom};
 let assembly=camera_normal::assemble_after_focus(initial,&controls,delta)?;
 Ok((State{focus,zoom:assembly.zoom},assembly))
}
/// Native5755C4 depth transfer preserves raw source words, including exceptional values.
pub fn apply_renderer_depth(camera:&mut Parameters,renderer_near_raw:u32,map_far_raw:u32) {
 camera.near=f32::from_bits(renderer_near_raw);camera.far=f32::from_bits(map_far_raw);
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn native_depth_setup_preserves_16_original_raw_plane_transfers() {
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/camera_sequence_contract.json")).unwrap();let cases=p["depth_setup_cases"].as_array().unwrap();assert_eq!(cases.len(),16);
  for c in cases {let mut camera=Parameters::original_initial([1.,2.,3.]);apply_renderer_depth(&mut camera,c["near_bits"].as_u64().unwrap() as u32,c["far_bits"].as_u64().unwrap() as u32);assert_eq!(camera.near.to_bits(),c["camera_near_bits"].as_u64().unwrap() as u32);assert_eq!(camera.far.to_bits(),c["camera_far_bits"].as_u64().unwrap() as u32);assert_eq!(camera.position,[1.,2.,3.]);assert_eq!(camera.fov_degrees,103.);}
 }

 #[test]
 fn matches_512_full_original_normal_camera_sequences_in_controlled_service_contexts() {
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/camera_sequence_contract.json")).unwrap();let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),512);
  for (n,c) in cases.iter().enumerate() {
   let vector=|key:&str|std::array::from_fn(|i|c[key][i].as_f64().unwrap() as f32);let word=|key:&str,i:usize|c[key][i].as_u64().unwrap() as u32;let z=|i|f32::from_bits(word("initial_zoom_bits",i));
   let state=State{focus:Focus{current:vector("focus"),saved:vector("saved"),held_raw:c["held_raw"].as_u64().unwrap() as u8},zoom:Zoom{smooth_time:z(0),epsilon:z(1),scale_raw:word("initial_zoom_bits",2),velocity:z(3),current:z(4),target:z(5)}};
   let context=Context{active_raw:c["active_raw"].as_u64().unwrap() as u8,service_flag_raw:c["service_flag_raw"].as_u64().unwrap() as u8,special_flag_raw:c["special_flag_raw"].as_u64().unwrap() as u8};
   let rectangle=&c["rectangle"];let restriction=Restriction{min_x:rectangle[0].as_f64().unwrap() as f32,max_x:rectangle[1].as_f64().unwrap() as f32,min_z:rectangle[2].as_f64().unwrap() as f32,max_z:rectangle[3].as_f64().unwrap() as f32,center:vector("center"),radius:c["radius"].as_f64().unwrap() as f32};
   let mut initial=Parameters::original_initial([0.;3]);initial.projection_raw=2;
   let (result,assembly)=step_without_auto_follow(&initial,&state,&context,&restriction,&Angles{pitch:56.,yaw:180.,previous_yaw:180.,fov:50.},f32::from_bits(c["delta_bits"].as_u64().unwrap() as u32)).unwrap();
   assert_eq!(result.focus.held_raw,c["output_held_raw"].as_u64().unwrap() as u8);
   let close=|actual:f32,key:&str,i| {let expected=f32::from_bits(word(key,i));assert!((actual-expected).abs()<=1e-5_f32.max(expected.abs()*2e-6),"case{n}/{key}/{i}: {actual}/{expected}");};
   for i in 0..3 {close(result.focus.current[i],"output_focus_bits",i);assert_eq!(result.focus.saved[i].to_bits(),word("output_focus_bits",i+3));}
   let z=result.zoom;let zoom_words=[z.smooth_time.to_bits(),z.epsilon.to_bits(),z.scale_raw,z.velocity.to_bits(),z.current.to_bits(),z.target.to_bits()];for i in 0..6 {assert_eq!(zoom_words[i],word("output_zoom_bits",i));}
   let cam=assembly.camera;for i in 0..3 {close(cam.position[i],"output_camera_bits",i);close(cam.direction[i],"output_camera_bits",i+5);}
   let preserved=[(cam.near.to_bits(),3),(cam.far.to_bits(),4),(cam.up[0].to_bits(),8),(cam.up[1].to_bits(),9),(cam.up[2].to_bits(),10),(cam.fov_degrees.to_bits(),11),(cam.projection_raw,12),(cam.width.to_bits(),13),(cam.height.to_bits(),14),(cam.auxiliary_raw,15)];for (actual,i) in preserved {assert_eq!(actual,word("output_camera_bits",i));}
   assert_eq!(assembly.distance.to_bits(),c["distance_bits"].as_u64().unwrap() as u32);
  }
 }
}
