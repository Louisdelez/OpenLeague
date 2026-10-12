//! Full original565910 angle camera with explicit entity matrix and controller offsets.
use crate::camera_parameters::Parameters;
fn constant(key:&str)->f32 {
 static PROOF:std::sync::OnceLock<serde_json::Value>=std::sync::OnceLock::new();
 let p=PROOF.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/camera_angles_contract.json")).expect("native angle camera proof"));
 f32::from_bits(p["constants_bits"][key].as_u64().expect("native angle constant") as u32)
}
fn polynomial(x:f32,cosine:bool)->f32 {
 let sq=x*x;
 let (c0,c1,c2,c3,c4)=if cosine {("0x11392b0","0x11389c0","0x1138a1c","0x1138a94","0x1138ba4")} else {("0x11392ac","0x11389a8","0x11389e0","0x1138a4c","0x1138b10")};
 let mut p=sq*constant(c0)+constant(c1);p=p*sq-constant(c2);p=p*sq+constant(c3);p=p*sq-constant(c4);p=p*sq+constant("0x1138c74");
 if cosine {p} else {p*x}
}
/// Native8E1F40 polynomial; no periodic reduction beyond its original pi reflection.
pub fn sine(x:f32)->f32 {let abs=x.abs();let v=if abs<=constant("0x1138d2c") {abs}else{constant("0x1138eac")-abs};let y=polynomial(v,false);if x<0. {f32::from_bits(y.to_bits()^0x80000000)}else{y}}
/// Native8E2030 polynomial; inputs outside the expected angle range are not wrapped.
pub fn cosine(x:f32)->f32 {let abs=x.abs();if abs<=constant("0x1138d2c") {polynomial(x,true)}else {let y=polynomial(constant("0x1138eac")-abs,true);f32::from_bits(y.to_bits()^0x80000000)}}
#[derive(Debug,Clone,Copy)]
pub struct Controls {pub yaw_degrees:f32,pub pitch_degrees:f32,pub side_offset:f32,pub up_offset:f32,pub distance:f32}
fn normalized(mut v:[f32;3],squared:f32)->Result<[f32;3],&'static str> {
 if squared>constant("0x1138990") {let factor=crate::audio_emitter_planes::reciprocal_sqrt(squared)?;for x in &mut v {*x=(f64::from(*x)*f64::from(factor)) as f32;}}Ok(v)
}
/// Mode3 preserves projection/near/up/dimensions/auxiliary, sets FOV50 and far25000.
/// Matrix is the native entity virtual20 result; translation is retained as the original does.
pub fn assemble(initial:&Parameters,controls:&Controls,entity_position:[f32;3],matrix:&[f32;16])->Result<Parameters,&'static str> {
 let pitch=(f64::from(controls.pitch_degrees)*f64::from(constant("0x1138a68"))) as f32;
 let yaw=(f64::from(controls.yaw_degrees)*f64::from(constant("0x1138a68"))) as f32;
 let cp=cosine(pitch);let sy=sine(yaw);let sp=sine(pitch);let cy=cosine(yaw);
 let vector=[(f64::from(cp)*f64::from(sy)) as f32,sp,(f64::from(cp)*f64::from(cy)) as f32];
 let vector=normalized(vector,(vector[1]*vector[1]+vector[0]*vector[0])+vector[2]*vector[2])?;
 let v=std::array::from_fn::<_,3,_>(|i|((matrix[4+i]*vector[1]+matrix[i]*vector[0])+matrix[8+i]*vector[2])+matrix[12+i]);
 let side=[v[1]*0.-v[2],v[2]*0.-v[0]*0.,v[0]-v[1]*0.];
 let side=normalized(side,(side[1]*side[1]+side[0]*side[0])+side[2]*side[2])?;
 let up=[side[1]*v[2]-side[2]*v[1],side[2]*v[0]-side[0]*v[2],v[1]*side[0]-side[1]*v[0]];
 let target=std::array::from_fn::<_,3,_>(|i|up[i]*controls.up_offset+(side[i]*controls.side_offset+entity_position[i]));
 let eye=std::array::from_fn::<_,3,_>(|i|target[i]-v[i]*controls.distance);
 let direction=std::array::from_fn::<_,3,_>(|i|target[i]-eye[i]);let squared=(direction[0]*direction[0]+direction[1]*direction[1])+direction[2]*direction[2];
 let mut camera=*initial;camera.position=eye;camera.direction=normalized(direction,squared)?;camera.far=25000.;camera.fov_degrees=50.;Ok(camera)
}
#[cfg(test)]
mod tests {
 use super::*;
 fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/camera_angles_contract.json")).unwrap()}
 #[test]
 fn matches_269_native_polynomial_sine_cosine_pairs_without_angle_wrapping() {
  let p=proof();let cases=p["trig_cases"].as_array().unwrap();assert_eq!(cases.len(),269);
  for c in cases {let x=f32::from_bits(c["input_bits"].as_u64().unwrap() as u32);assert_eq!(sine(x).to_bits(),c["sin_bits"].as_u64().unwrap() as u32,"sin{x}");assert_eq!(cosine(x).to_bits(),c["cos_bits"].as_u64().unwrap() as u32,"cos{x}");}
 }
 #[test]
 fn matches_120_full_native_angle_camera_builders() {
  let p=proof();let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),120);
  for (n,c) in cases.iter().enumerate() {
   let bits=|key:&str,i:usize|c[key][i].as_u64().unwrap() as u32;let f=|key:&str,i:usize|f32::from_bits(bits(key,i));let cam=|i|f("initial_camera_bits",i);
   let initial=Parameters{position:[cam(0),cam(1),cam(2)],near:cam(3),far:cam(4),direction:[cam(5),cam(6),cam(7)],up:[cam(8),cam(9),cam(10)],fov_degrees:cam(11),projection_raw:bits("initial_camera_bits",12),width:cam(13),height:cam(14),auxiliary_raw:bits("initial_camera_bits",15)};
   let controls=Controls{yaw_degrees:f("state_bits",0),pitch_degrees:f("state_bits",1),side_offset:f("state_bits",2),up_offset:f("state_bits",3),distance:f("state_bits",4)};
   let out=assemble(&initial,&controls,std::array::from_fn(|i|f("entity_position_bits",i)),&std::array::from_fn(|i|f("matrix_bits",i))).unwrap();
   let words=[out.position[0].to_bits(),out.position[1].to_bits(),out.position[2].to_bits(),out.near.to_bits(),out.far.to_bits(),out.direction[0].to_bits(),out.direction[1].to_bits(),out.direction[2].to_bits(),out.up[0].to_bits(),out.up[1].to_bits(),out.up[2].to_bits(),out.fov_degrees.to_bits(),out.projection_raw,out.width.to_bits(),out.height.to_bits(),out.auxiliary_raw];
   for i in 0..16 {if matches!(i,0|1|2|5|6|7) {let a=f32::from_bits(words[i]);let b=f("output_camera_bits",i);assert!((a-b).abs()<=1e-5_f32.max(b.abs()*2e-7),"case{n}field{i}: {a}/{b}");}else {assert_eq!(words[i],bits("output_camera_bits",i),"case{n}field{i}");}}
  }
 }
}
