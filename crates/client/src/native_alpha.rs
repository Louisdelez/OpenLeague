//! Native9AC500 x87 alpha-reference conversion; ordinary world compare mode4 -> D3D GREATER5.
pub fn reference_byte(value:f32)->Result<u8,&'static str> {
 if !value.is_finite() || !(0. ..=1.).contains(&value) {return Err("native alpha reference outside qualified range");}
 // f32*255 fits exactly in f64; preserve x87 product before truncation, not rounded f32 multiply.
 Ok((value as f64*255.).trunc() as u8)
}
pub fn shader_reference(value:f32)->Result<f32,&'static str> {Ok(reference_byte(value)? as f32/255.)}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn production_reference_matches_original_x87_conversion_for_every_cutoff_mode_and_cache_case() {
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/alpha_render_state_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["world_setup_calls"],serde_json::json!([[15,1],[25,5],[24,1]]));
  for c in p["cases"].as_array().unwrap() {let f=f32::from_bits(c["reference_bits"].as_u64().unwrap() as u32);assert_eq!(reference_byte(f).unwrap() as u64,c["quantized_reference"].as_u64().unwrap());}
  for v in [f32::NAN,f32::INFINITY,-0.1,1.1] {assert!(reference_byte(v).is_err());}
 }
}
