//! Original7D2330 FPS camera base initialization; configfile lookup is caller-provided.
pub const SECTION:&str="Hacks";
pub const VIEW_VELOCITY_KEY:&str="FPS_ViewAngleVelocity_Magnitude";
pub const ACCELERATION_KEY:&str="FPS_Acceleration_Magnitude";
/// Initializes bytes0..75 while preserving later controller fields and upperword74 bits.
/// Supplied raw global vector repeats eighttimes, including raw signalingNaN payloads.
pub fn initialize(words:&mut[u32],global_vector:[u32;3],view_velocity:Option<f32>,acceleration:Option<f32>)->Result<(),&'static str> {
 if words.len()<30 {return Err("native FPS controller needs at least120bytes of word storage");}
 let velocity=view_velocity.unwrap_or(15.);let acceleration=acceleration.unwrap_or(500.);
 if !velocity.is_finite() || !acceleration.is_finite() {return Err("nonfinite native FPS config scalar unqualified");}
 words[0]=velocity.to_bits();words[1]=acceleration.to_bits();
 for i in 0..8 {words[2+i*3..5+i*3].copy_from_slice(&global_vector);}
 words[26..29].fill(0);words[29]&=0xffff0000;Ok(())
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn matches_64_native_config_initializers_and_preserves_mode3_controls() {
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/camera_fps_settings_contract.json")).unwrap();let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),64);
  for (n,c) in cases.iter().enumerate() {let mut words=c["initial_words"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>();let seed=std::array::from_fn(|i|c["vector_seed_bits"][i].as_u64().unwrap() as u32);let velocity=c["velocity_override_bits"].as_u64().map(|v|f32::from_bits(v as u32));let acceleration=c["acceleration_override_bits"].as_u64().map(|v|f32::from_bits(v as u32));initialize(&mut words,seed,velocity,acceleration).unwrap();
   for i in 0..35 {assert_eq!(words[i],c["output_words"][i].as_u64().unwrap() as u32,"case{n}word{i}");}
   let calls=c["getter_calls"].as_array().unwrap();assert_eq!(calls.len(),2);assert_eq!(calls[0]["section"],SECTION);assert_eq!(calls[1]["section"],SECTION);assert_eq!(calls[0]["key"],VIEW_VELOCITY_KEY);assert_eq!(calls[1]["key"],ACCELERATION_KEY);assert_eq!(calls[0]["default_bits"],15_f32.to_bits());assert_eq!(calls[1]["default_bits"],500_f32.to_bits());
  }
 }
}
