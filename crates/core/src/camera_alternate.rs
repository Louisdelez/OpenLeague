//! Original7CFE90/7CFFA0 camera assembly; supplied controller/entity state and shake clock.
use crate::{camera_parameters::Parameters,camera_shake::{self,State},native_random::Rng55};
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Builder {Normal,Mode1,Mode2,Angles}
/// Original58C8B0 routing. Mode3 receiver is controller+78; unknown raw modes use normal.
pub fn select(mode_raw:u32)->Builder {match mode_raw {1=>Builder::Mode1,2=>Builder::Mode2,3=>Builder::Angles,_=>Builder::Normal}}
#[derive(Debug,Clone,Copy)]
pub struct EntityInputs {pub position:[f32;3],pub bounds_min:[f32;3],pub bounds_max:[f32;3],pub direction:[f32;3]}
fn direction(vector:[f32;3])->Result<[f32;3],&'static str> {
 let squared=(vector[0]*vector[0]+vector[1]*vector[1])+vector[2]*vector[2];
 if squared>f32::from_bits(814313567) {let scale=crate::audio_emitter_planes::reciprocal_sqrt(squared)?;Ok(vector.map(|v|(f64::from(v)*f64::from(scale)) as f32))} else {Ok(vector)}
}
/// Preserves near/far/up/dimensions/auxiliary. Original subtracts the rounded target from position.
pub fn mode1(initial:&Parameters,position:[f32;3],input_direction:[f32;3],fov:f32,shake:&mut State,now:f32,rng:&mut Rng55)->Result<(Parameters,u8),&'static str> {
 let v=std::array::from_fn(|i|(position[i]+input_direction[i]*10.)-position[i]);
 let mut camera=*initial;camera.position=position;camera.direction=direction(v)?;camera.fov_degrees=fov;camera.projection_raw=0;
 let draws=camera_shake::update(shake,&mut camera,now,rng)?;Ok((camera,draws))
}
/// Original unaligned entity bounds95..A9 determine eye distance and twice the bounds height.
pub fn mode2(initial:&Parameters,entity:&EntityInputs,fov:f32,shake:&mut State,now:f32,rng:&mut Rng55)->Result<(Parameters,u8),&'static str> {
 let x=entity.position[0];let z=entity.position[2];let height=entity.bounds_max[1]-entity.bounds_min[1];
 let target_y=height+entity.position[1];
 let scale=((entity.bounds_max[2]-entity.bounds_min[2])+(entity.bounds_max[0]-entity.bounds_min[0]))*2.;
 let eye=[x-entity.direction[0]*scale,(height+target_y)-entity.direction[1]*scale,z-entity.direction[2]*scale];
 let mut camera=*initial;camera.position=eye;camera.direction=direction([x-eye[0],target_y-eye[1],z-eye[2]])?;camera.fov_degrees=fov;camera.projection_raw=0;
 let draws=camera_shake::update(shake,&mut camera,now,rng)?;Ok((camera,draws))
}
#[cfg(test)]
mod tests {
 use super::*;
 fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/camera_alternate_contract.json")).unwrap()}
 #[test]
 fn matches_96_full_native_alternate_builders_with_active_and_inactive_shake() {
  let p=proof();let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),96);
  for (n,c) in cases.iter().enumerate() {
   let bit=|key:&str,i:usize|c[key][i].as_u64().unwrap() as u32;let f=|key:&str,i:usize|f32::from_bits(bit(key,i));let cam=|i|f("initial_camera_bits",i);
   let initial=Parameters{position:[cam(0),cam(1),cam(2)],near:cam(3),far:cam(4),direction:[cam(5),cam(6),cam(7)],up:[cam(8),cam(9),cam(10)],fov_degrees:cam(11),projection_raw:bit("initial_camera_bits",12),width:cam(13),height:cam(14),auxiliary_raw:bit("initial_camera_bits",15)};
   let mut shake=State{offsets:std::array::from_fn(|i|f("initial_shake_bits",i)),duration:f("initial_shake_bits",3),started:f("initial_shake_bits",4),amplitude:f("initial_shake_bits",5),next_change:f("initial_shake_bits",6),frequency:f("initial_shake_bits",7),active_raw:c["initial_active_raw"].as_u64().unwrap() as u8};
   let position=std::array::from_fn(|i|f("position_bits",i));let input_direction=std::array::from_fn(|i|f("direction_bits",i));let fov=f32::from_bits(c["fov_bits"].as_u64().unwrap() as u32);let now=f32::from_bits(c["now_bits"].as_u64().unwrap() as u32);let mut rng=Rng55::seeded(c["seed"].as_u64().unwrap() as u32);
   let (camera,draws)=if c["mode"]==1 {mode1(&initial,position,input_direction,fov,&mut shake,now,&mut rng).unwrap()} else {mode2(&initial,&EntityInputs{position,bounds_min:std::array::from_fn(|i|f("bounds_bits",i)),bounds_max:std::array::from_fn(|i|f("bounds_bits",i+3)),direction:input_direction},fov,&mut shake,now,&mut rng).unwrap()};
   let words=[camera.position[0].to_bits(),camera.position[1].to_bits(),camera.position[2].to_bits(),camera.near.to_bits(),camera.far.to_bits(),camera.direction[0].to_bits(),camera.direction[1].to_bits(),camera.direction[2].to_bits(),camera.up[0].to_bits(),camera.up[1].to_bits(),camera.up[2].to_bits(),camera.fov_degrees.to_bits(),camera.projection_raw,camera.width.to_bits(),camera.height.to_bits(),camera.auxiliary_raw];
   for i in 0..16 {if matches!(i,0|1|2|5|6|7) {let a=f32::from_bits(words[i]);let b=f("output_camera_bits",i);assert!((a-b).abs()<=1e-5_f32.max(b.abs()*2e-7),"case{n}field{i}: {a}/{b}");}else {assert_eq!(words[i],bit("output_camera_bits",i),"case{n}field{i}");}}
   let values=[shake.offsets[0],shake.offsets[1],shake.offsets[2],shake.duration,shake.started,shake.amplitude,shake.next_change,shake.frequency];for i in 0..8 {assert_eq!(values[i].to_bits(),bit("output_shake_bits",i),"case{n}shake{i}");}
   assert_eq!(shake.active_raw,c["active_raw"].as_u64().unwrap() as u8);assert_eq!(draws,c["random_calls"].as_u64().unwrap() as u8);
   assert_eq!(rng.first,c["rng"]["first"].as_u64().unwrap() as u32);assert_eq!(rng.second,c["rng"]["second"].as_u64().unwrap() as u32);for i in 0..55 {assert_eq!(rng.words[i],c["rng"]["words"][i].as_u64().unwrap() as u32);}
  }
 }
 #[test]
 fn matches_native_dispatch_including_unrecognized_raw_modes() {
  let p=proof();let cases=p["dispatch_cases"].as_array().unwrap();assert_eq!(cases.len(),9);
  for c in cases {let chosen=select(c["mode_raw"].as_u64().unwrap() as u32);assert_eq!(chosen,match c["target"].as_str().unwrap(){"normal"=>Builder::Normal,"mode1"=>Builder::Mode1,"mode2"=>Builder::Mode2,"mode3"=>Builder::Angles,_=>panic!("native route")});assert_eq!(c["receiver_offset"].as_u64().unwrap(),if chosen==Builder::Angles {0x78}else{0});}
 }
}
