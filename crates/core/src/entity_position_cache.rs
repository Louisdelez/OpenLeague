//! Original5657E0: position cache at receiver40..48 after the unchanged64byte matrix.
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct Update {pub wrote_position:bool,pub warn_x_outside_native_bounds:bool}
fn x87_copy(bits:u32)->u32 {if bits&0x7f800000==0x7f800000 && bits&0x007fffff!=0 {bits|0x00400000}else{bits}}
/// Input and frame are raw words to preserve native MOVSS vs x87 signaling-NaN behavior.
/// Reports the original diagnostic condition; actual logging is caller-owned.
pub fn update(frame:&mut[u32;19],position:[u32;3])->Update {
 let x=f32::from_bits(position[0]);let z=f32::from_bits(position[2]);let epsilon=f32::from_bits(897988541);
 let warning=!(x> -1_000_000_000. && x<1_000_000_000.);
 let write=!(x<=epsilon && x>= -epsilon && z<=epsilon && z>= -epsilon);
 if write {frame[16]=position[0];frame[17]=x87_copy(position[1]);frame[18]=x87_copy(position[2]);}
 Update{wrote_position:write,warn_x_outside_native_bounds:warning}
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn matches_768_native_cache_updates_including_boundaries_and_signaling_nan_copies() {
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/entity_position_cache_contract.json")).unwrap();let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),768);
  let hardware:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/x87_position_copy_hardware.json")).unwrap();let hardware=hardware.as_array().unwrap();assert_eq!(hardware.len(),8);
  assert_eq!(p["constants_bits"]["0x11389a0"],897988541_u32);
  for (n,c) in cases.iter().enumerate() {
   let mut frame=std::array::from_fn(|i|c["initial_frame_bits"][i].as_u64().unwrap() as u32);let initial=frame;
   let input=std::array::from_fn(|i|c["input_position_bits"][i].as_u64().unwrap() as u32);let report=update(&mut frame,input);
   assert_eq!(report.warn_x_outside_native_bounds,c["warning"].as_bool().unwrap(),"case{n}warning");
   for i in 0..19 {
    let mut expected=c["output_frame_bits"][i].as_u64().unwrap() as u32;
    // Unicorn preserves signaling-NaN payloads on FLD/FSTP; actual host x87 quiets them.
    if matches!(i,17|18) && c["wrote_position"].as_bool().unwrap() && input[i-16]&0x7fc00000==0x7f800000 && input[i-16]&0x003fffff!=0 {
     let observed=hardware.iter().find(|h|h["input_bits"].as_u64().unwrap() as u32==input[i-16]).expect("hardware signaling NaN case");expected=observed["output_bits"].as_u64().unwrap() as u32;
    }
    assert_eq!(frame[i],expected,"case{n}field{i}");
   }
   assert_eq!(frame[..16],initial[..16]);
   assert_eq!(report.wrote_position,c["wrote_position"].as_bool().unwrap());
  }
 }
}
