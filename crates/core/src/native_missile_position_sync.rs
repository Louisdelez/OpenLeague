//! Native7631C0/7648C0 copy of moving544 to owner60.
//! Valid-target nonzero-gravity interpolation remains unqualified.
pub fn synchronize(moving:[f32;3], gravity:f32, target_span_present:bool)->Result<[f32;3], &'static str>{
 if !moving.into_iter().all(f32::is_finite) || !gravity.is_finite(){return Err("unqualified position sync inputs");}
 if gravity!=0. && target_span_present{return Err("native gravity target interpolation not qualified");}
 Ok(moving)
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn matches36_original_position_sync_executions(){
 let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/missile_position_sync_contract.json")).unwrap();
 let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),36);
 for(n,c) in cases.iter().enumerate(){
  let moving=std::array::from_fn(|i|f32::from_bits(c["moving_words"][i].as_u64().unwrap() as u32));
  let a=synchronize(moving,c["gravity"].as_f64().unwrap() as f32,false).unwrap();
  for i in 0..3{assert_eq!(a[i].to_bits(),c["owner_position_words"][i].as_u64().unwrap() as u32,"case{n} axis{i}");}
 }
 assert!(synchronize([1.,2.,3.],1.,true).is_err());
 }
}
