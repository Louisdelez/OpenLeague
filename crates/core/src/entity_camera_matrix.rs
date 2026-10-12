//! Native6AB520 entity direction matrix. Entity virtual20 getter600ED0 exposes entity18C0.
pub fn from_direction(direction:[f32;3])->Result<[f32;16],&'static str> {
 let [x,y,z]=direction;
 let norm=|mut v:[f32;3],squared:f32|->Result<[f32;3],&'static str> {if squared>f32::from_bits(814313567) {let f=crate::audio_emitter_planes::reciprocal_sqrt(squared)?;for value in &mut v {*value=(f64::from(*value)*f64::from(f)) as f32;}}Ok(v)};
 let forward=norm(direction,(y*y+x*x)+z*z)?;
 // Source computes the horizontal side from the supplied vector before normalizing it.
 let side=[z-y*0.,x*0.-z*0.,y*0.-x];let side=norm(side,(side[1]*side[1]+side[0]*side[0])+side[2]*side[2])?;
 Ok([side[0],side[1],side[2],0.,0.,1.,0.,0.,forward[0],forward[1],forward[2],0.,0.,0.,0.,1.])
}
/// Actual direction-matrix producer followed by qualified native565910 camera math.
/// Movement updates/input/mode activation remain caller responsibilities.
pub fn angle_camera(initial:&crate::camera_parameters::Parameters,controls:&crate::camera_angles::Controls,entity_position:[f32;3],entity_direction:[f32;3])->Result<crate::camera_parameters::Parameters,&'static str> {
 crate::camera_angles::assemble(initial,controls,entity_position,&from_direction(entity_direction)?)
}
#[cfg(test)]
mod tests {
 use super::*;
 fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/entity_camera_matrix_contract.json")).unwrap()}
 #[test]
 fn matches_51_native_direction_matrices_and_getter_offsets() {
  let p=proof();let cases=p["matrix_cases"].as_array().unwrap();assert_eq!(cases.len(),51);
  for (n,c) in cases.iter().enumerate() {let m=from_direction(std::array::from_fn(|i|f32::from_bits(c["direction_bits"][i].as_u64().unwrap() as u32))).unwrap();for i in 0..16 {let expected=f32::from_bits(c["matrix_bits"][i].as_u64().unwrap() as u32);if matches!(i,0|1|2|8|9|10) {assert!((m[i]-expected).abs()<=1e-7_f32.max(expected.abs()*2e-7),"case{n}field{i}: {}/{expected}",m[i]);} else {assert_eq!(m[i].to_bits(),expected.to_bits());}}}
  let getters=p["getter_cases"].as_array().unwrap();assert_eq!(getters.len(),2);for c in getters {assert_eq!(c["receiver_entity_offset"],0x3e0);assert_eq!(c["returned_entity_offset"],0x18c0);assert_eq!(c["virtual20"],"0x600ed0");}
 }
 #[test]
 fn matches_204_native_entity_direction_to_angle_camera_chains() {
  use crate::camera_parameters::Parameters;use crate::camera_angles::Controls;
  let p=proof();let cases=p["camera_chain_cases"].as_array().unwrap();assert_eq!(cases.len(),204);
  for (n,c) in cases.iter().enumerate() {
   let bits=|key:&str,i:usize|c[key][i].as_u64().unwrap() as u32;let f=|key:&str,i:usize|f32::from_bits(bits(key,i));let cam=|i|f("initial_camera_bits",i);
   let initial=Parameters{position:[cam(0),cam(1),cam(2)],near:cam(3),far:cam(4),direction:[cam(5),cam(6),cam(7)],up:[cam(8),cam(9),cam(10)],fov_degrees:cam(11),projection_raw:bits("initial_camera_bits",12),width:cam(13),height:cam(14),auxiliary_raw:bits("initial_camera_bits",15)};
   let controls=Controls{yaw_degrees:f("state_bits",0),pitch_degrees:f("state_bits",1),side_offset:f("state_bits",2),up_offset:f("state_bits",3),distance:f("state_bits",4)};
   let out=angle_camera(&initial,&controls,std::array::from_fn(|i|f("entity_position_bits",i)),std::array::from_fn(|i|f("direction_bits",i))).unwrap();
   let words=[out.position[0].to_bits(),out.position[1].to_bits(),out.position[2].to_bits(),out.near.to_bits(),out.far.to_bits(),out.direction[0].to_bits(),out.direction[1].to_bits(),out.direction[2].to_bits(),out.up[0].to_bits(),out.up[1].to_bits(),out.up[2].to_bits(),out.fov_degrees.to_bits(),out.projection_raw,out.width.to_bits(),out.height.to_bits(),out.auxiliary_raw];
   for i in 0..16 {if matches!(i,0|1|2|5|6|7) {let a=f32::from_bits(words[i]);let b=f("output_camera_bits",i);assert!((a-b).abs()<=1e-5_f32.max(b.abs()*2e-7),"case{n}field{i}: {a}/{b}");}else {assert_eq!(words[i],bits("output_camera_bits",i));}}
  }
 }
}
