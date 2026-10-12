//! Native6AB380 finite XZ yaw with original FPATAN/degree constant and6BD9F0 quantization.
pub fn angle(direction:[f32;3])->Result<Option<f32>,&'static str> {
 if !direction[0].is_finite() || !direction[2].is_finite() {return Err("nonfinite native entity yaw unqualified");}
 if direction[0]==0. && direction[2]==0. {return Ok(None);}
 #[cfg(any(target_arch="x86",target_arch="x86_64"))]
 {
  let x=direction[0];let z=direction[2];let factor=f32::from_bits(1113927392);let mut rounded=0_f32;let mut extended=0_f64;
  unsafe{std::arch::asm!("fld dword ptr [{x}]","fld dword ptr [{z}]","fpatan","fmul dword ptr [{factor}]","fst dword ptr [{rounded}]","fstp qword ptr [{extended}]",x=in(reg)&x,z=in(reg)&z,factor=in(reg)&factor,rounded=in(reg)&mut rounded,extended=in(reg)&mut extended,out("st(0)") _,out("st(1)") _,options(nostack));}
  Ok(Some(if extended<0. {-(rounded+360.)}else{-rounded}))
 }
 #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
 {Err("native x87 entity yaw unavailable")}
}
pub fn update(frame:&mut[u32;19],direction:[f32;3])->Result<Option<f32>,&'static str> {
 let Some(angle)=angle(direction)? else{return Ok(None)};
 apply_angle(frame,angle)?;Ok(Some(angle))
}
/// Original quantized matrix suffix, also used for a serialized physical heading.
/// Validate before mutation; this does not establish the native direction producer.
pub fn apply_angle(frame:&mut[u32;19],angle:f32)->Result<(),&'static str> {
 if !angle.is_finite() || !(-360. ..=0.).contains(&angle) {return Err("invalid native yaw heading");}
 let inverse=360.-angle;let sin=crate::camera_rotation::lookup_scaled(inverse*10.);let cos=crate::camera_rotation::lookup_scaled((90.-inverse)*10.);
 // Specialized original6BD9F0 with axis[0,1,0], two basis vectors. Keep zero terms/signs.
 let rotate=|x:f32,z:f32|[(cos*x+0.)-(0.-sin)*z,0.,-((sin*x+0.)-cos*z)];
 let right=rotate(1.,0.);let forward=rotate(0.,1.);
 let matrix=[right[0],right[1],right[2],0.,0.,1.,0.,0.,forward[0],forward[1],forward[2],0.,0.,0.,0.,1.];
 for i in 0..16 {frame[i]=matrix[i].to_bits();}Ok(())
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn matches_111_native_yaw_matrices_and_zero_direction_preservation() {
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/entity_yaw_contract.json")).unwrap();let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),111);
  for (n,c) in cases.iter().enumerate() {let direction=std::array::from_fn(|i|f32::from_bits(c["direction_bits"][i].as_u64().unwrap() as u32));let mut frame=std::array::from_fn(|i|c["initial_frame_bits"][i].as_u64().unwrap() as u32);let angle=update(&mut frame,direction).unwrap();
   if let Some(bits)=c["angle_bits"].as_u64() {let expected=f32::from_bits(bits as u32);assert!((angle.unwrap()-expected).abs()<=0.00004,"case{n}angle");}else{assert!(angle.is_none());}
   for i in 0..19 {assert_eq!(frame[i],c["output_frame_bits"][i].as_u64().unwrap() as u32,"case{n}matrix{i}");}
  }
 }
}
