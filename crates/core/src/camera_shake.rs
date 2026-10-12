//! Full original7D2BE0 active shake, source clock and shared RNG supplied explicitly.
use crate::{camera_parameters::Parameters,native_random::Rng55};
#[derive(Debug,Clone,Copy)]
pub struct State {pub offsets:[f32;3],pub duration:f32,pub started:f32,pub amplitude:f32,pub next_change:f32,pub frequency:f32,pub active_raw:u8}
fn sample(low:f32,high:f32,random:f64,offset:Option<f32>)->Result<f32,&'static str> {
 #[cfg(any(target_arch="x86",target_arch="x86_64"))]
 {
  let mut result=0_f32;
  if let Some(offset)=offset {
   unsafe {std::arch::asm!("fld dword ptr [{high}]","fsub dword ptr [{low}]","fmul qword ptr [{random}]","fadd dword ptr [{low}]","fadd dword ptr [{offset}]","fstp dword ptr [{result}]",high=in(reg)&high,low=in(reg)&low,random=in(reg)&random,offset=in(reg)&offset,result=in(reg)&mut result,out("st(0)") _,options(nostack));}
  } else {
   unsafe {std::arch::asm!("fld dword ptr [{high}]","fsub dword ptr [{low}]","fmul qword ptr [{random}]","fadd dword ptr [{low}]","fstp dword ptr [{result}]",high=in(reg)&high,low=in(reg)&low,random=in(reg)&random,result=in(reg)&mut result,out("st(0)") _,options(nostack));}
  }
  Ok(result)
 }
 #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
 {let _=(low,high,random,offset);Err("native extended shake interpolation unavailable")}
}
/// Returns number of shared RNG draws. Existing offsets apply while no renewal is due.
pub fn update(state:&mut State,camera:&mut Parameters,now:f32,rng:&mut Rng55)->Result<u8,&'static str> {
 if state.active_raw==0 {return Ok(0);}
 if now>state.duration+state.started {state.active_raw=0;return Ok(0);}
 let mut draws=0;
 if now>state.next_change {
  let decay=1.-((now-state.started)/state.duration);let amplitude=state.amplitude*decay;
  state.offsets[0]=sample(-amplitude,amplitude,rng.fraction_extended(),None)?;
  state.offsets[2]=sample(-amplitude,amplitude,rng.fraction_extended(),None)?;
  let low=state.duration/(state.frequency*f32::from_bits(1067869798));
  let high=state.duration/(state.frequency*f32::from_bits(1060320051));
  state.next_change=sample(low,high,rng.fraction_extended(),Some(now))?;draws=3;
 }
 let [x,y,z]=camera.direction;
 // Keep explicit native zero products for IEEE behavior and signed zeros.
 let side=[y*0.-z,z*0.-x*0.,x-y*0.];
 let mut up=[z*side[1]-y*side[2],x*side[2]-z*side[0],y*side[0]-side[1]*x];
 let squared=(up[0]*up[0]+up[1]*up[1])+up[2]*up[2];
 if squared>f32::from_bits(814313567) {
  let inverse=crate::audio_emitter_planes::reciprocal_sqrt(squared)?;
  for v in &mut up {*v=(f64::from(*v)*f64::from(inverse)) as f32;}
 }
 for i in 0..3 {camera.position[i]=((side[i]*state.offsets[0])+camera.position[i])+(up[i]*state.offsets[2]);}
 Ok(draws)
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn matches_480_native_shake_sequences_and_2880_state_updates_with_shared_rng() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/camera_random_shake_contract.json")).unwrap();let cases=proof["shake_cases"].as_array().unwrap();assert_eq!(cases.len(),480);let mut updates=0;
  for (n,c) in cases.iter().enumerate() {
   let input=|i|f32::from_bits(c["initial_shake_bits"][i].as_u64().unwrap() as u32);
   let mut state=State{offsets:[input(0),input(1),input(2)],duration:input(3),started:input(4),amplitude:input(5),next_change:input(6),frequency:input(7),active_raw:c["initial_active_raw"].as_u64().unwrap() as u8};let cam=|i|f32::from_bits(c["initial_camera_bits"][i].as_u64().unwrap() as u32);
   let mut camera=Parameters{position:[cam(0),cam(1),cam(2)],near:cam(3),far:cam(4),direction:[cam(5),cam(6),cam(7)],up:[cam(8),cam(9),cam(10)],fov_degrees:cam(11),projection_raw:c["initial_camera_bits"][12].as_u64().unwrap() as u32,width:cam(13),height:cam(14),auxiliary_raw:c["initial_camera_bits"][15].as_u64().unwrap() as u32};let mut rng=Rng55::seeded(c["seed"].as_u64().unwrap() as u32);
   for (s,step) in c["steps"].as_array().unwrap().iter().enumerate() {
    updates+=1;let draws=update(&mut state,&mut camera,f32::from_bits(step["now_bits"].as_u64().unwrap() as u32),&mut rng).unwrap();assert_eq!(draws,step["random_calls"].as_u64().unwrap() as u8,"case{n}step{s}draws");assert_eq!(state.active_raw,step["active_raw"].as_u64().unwrap() as u8);
    let values=[state.offsets[0],state.offsets[1],state.offsets[2],state.duration,state.started,state.amplitude,state.next_change,state.frequency];
    for i in 0..8 {let expected=f32::from_bits(step["shake_bits"][i].as_u64().unwrap() as u32);if expected.is_nan() {assert!(values[i].is_nan());} else {assert_eq!(values[i].to_bits(),expected.to_bits(),"case{n}step{s}field{i}: {}/{expected}",values[i]);}}
    let words=[camera.position[0].to_bits(),camera.position[1].to_bits(),camera.position[2].to_bits(),camera.near.to_bits(),camera.far.to_bits(),camera.direction[0].to_bits(),camera.direction[1].to_bits(),camera.direction[2].to_bits(),camera.up[0].to_bits(),camera.up[1].to_bits(),camera.up[2].to_bits(),camera.fov_degrees.to_bits(),camera.projection_raw,camera.width.to_bits(),camera.height.to_bits(),camera.auxiliary_raw];
    for i in 0..16 {let expected=step["camera_bits"][i].as_u64().unwrap() as u32;if i<3 {let original=f32::from_bits(expected);let actual=f32::from_bits(words[i]);if original.is_nan() {assert!(actual.is_nan());} else if original.is_infinite() {assert_eq!(actual,original);} else {assert!((actual-original).abs()<=1e-5_f32.max(original.abs()*2e-7),"case{n}step{s}camera{i}: {actual}/{original}");}} else {assert_eq!(words[i],expected);}}
    assert_eq!(rng.first,step["rng"]["first"].as_u64().unwrap() as u32);assert_eq!(rng.second,step["rng"]["second"].as_u64().unwrap() as u32);for i in 0..55 {assert_eq!(rng.words[i],step["rng"]["words"][i].as_u64().unwrap() as u32);}
   }
  }
  assert_eq!(updates,2880);
 }
}
