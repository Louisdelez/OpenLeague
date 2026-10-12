//! Native9198C4 System/SimulateEveryFrame contribution to configuration1BC.
/// Preserve existing bits; the native field caller ORs bit40 only when enabled.
/// Typed resource decoding and the full config constructor remain separate.
pub fn apply_simulate_every_frame(existing:u32,system:&serde_json::Value)->Result<u32,&'static str>{
 if !system.is_object(){return Err("invalid decoded Troy System");}
 let enabled=match system.get("SimulateEveryFrame"){
  None=>false,
  Some(serde_json::Value::Bool(value))=>*value,
  Some(value) if value.as_i64()==Some(0)=>false,
  Some(value) if value.as_i64()==Some(1)=>true,
  Some(_)=>return Err("unqualified SimulateEveryFrame representation"),
 };
 Ok(existing | if enabled {0x40}else{0})
}
#[cfg(test)]
mod tests{
 use super::*;
 #[test]
 fn native_troy_simulation_flags_match81_resource_reads(){
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/troy_simulate_every_frame_contract.json")).unwrap();
  let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),81);
  for c in cases{
   let system=serde_json::json!({"SimulateEveryFrame":c["authored"]});
   assert_eq!(apply_simulate_every_frame(c["initial_flags"].as_u64().unwrap() as u32,&system).unwrap(),c["flags"].as_u64().unwrap() as u32,"{c}");
  }
  let annie:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/particles/annie/Annie_Q_mis.json")).unwrap();
  assert_eq!(apply_simulate_every_frame(0,&annie["sections"]["System"]).unwrap(),0x40);
  assert_eq!(apply_simulate_every_frame(0x40,&serde_json::json!({})).unwrap(),0x40);
  assert!(apply_simulate_every_frame(0,&serde_json::json!({"SimulateEveryFrame":"true"})).is_err());
 }
}

/// Native919768: independent offscreen policy bit; absence preserves existing flags.
pub fn apply_simulate_offscreen(existing:u32,system:&serde_json::Value)->Result<u32,&'static str>{
 if !system.is_object(){return Err("invalid decoded Troy System");}
 let enabled=match system.get("SimulateWhileOffScreen"){
  None=>false,Some(serde_json::Value::Bool(v))=>*v,
  Some(v) if v.as_i64()==Some(0)=>false,
  Some(v) if v.as_i64()==Some(1)=>true,
  Some(_)=>return Err("unqualified SimulateWhileOffScreen representation"),
 };
 Ok(existing | u32::from(enabled))
}
#[cfg(test)]
mod offscreen_tests{
 use super::*;
 #[test]
 fn offscreen_flags_match81_native_resource_reads(){
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/troy_simulate_offscreen_contract.json")).unwrap();
  let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),81);
  for c in cases{
   let system=serde_json::json!({"SimulateWhileOffScreen":c["authored"]});
   assert_eq!(apply_simulate_offscreen(c["initial_flags"].as_u64().unwrap() as u32,&system).unwrap(),c["flags"].as_u64().unwrap() as u32);
  }
  let annie:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/particles/annie/Annie_Q_mis.json")).unwrap();
  let system=&annie["sections"]["System"];
  assert_eq!(apply_simulate_offscreen(apply_simulate_every_frame(0,system).unwrap(),system).unwrap(),0x40);
  assert!(apply_simulate_offscreen(0,&serde_json::json!({"SimulateWhileOffScreen":2})).is_err());
 }
}
/// Native919C9D: authored build-up-time, default zero, stored at configuration1C0.
/// Frame timing applies its own minimum cap; preserve the resource value here.
pub fn build_up_time(system:&serde_json::Value)->Result<f32,&'static str>{
 if !system.is_object(){return Err("invalid decoded Troy System");}
 let value=match system.get("build-up-time"){
  None=>0.,Some(v)=>v.as_f64().ok_or("unqualified build-up-time representation")? as f32,
 };
 if !value.is_finite(){return Err("nonfinite build-up-time");}
 Ok(value)
}
#[cfg(test)]
mod build_up_tests{
 use super::*;
 #[test]
 fn build_up_time_matches81_native_resource_reads(){
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/troy_build_up_time_contract.json")).unwrap();
  let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),81);
  for c in cases{
   assert_eq!(build_up_time(&serde_json::json!({"build-up-time":c["authored"]})).unwrap().to_bits(),c["value_bits"].as_u64().unwrap() as u32);
  }
  let annie:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/particles/annie/Annie_Q_mis.json")).unwrap();
  assert_eq!(build_up_time(&annie["sections"]["System"]).unwrap(),0.);
  assert!(build_up_time(&serde_json::json!({"build-up-time":"bad"})).is_err());
  assert!(build_up_time(&serde_json::json!({"build-up-time":1e100})).is_err());
 }
}
/// Native92DA90 engine fields E8..FC, selected by global1225888.
/// UI setting provenance remains caller-owned; do not infer it from frame rate.
pub fn engine_timing_words(setting:u32)->[u32;6]{
 match setting{
  0=>[0x41700000,0x3dcccccd,0x3e4ccccd,0x3f800000,0x3f800000,setting],
  1=>[0x41700000,0x3e4ccccd,0x3ecccccd,0x3f800000,0x3f800000,setting],
  2=>[0x41a00000,0x3ecccccd,0x3f19999a,0x3f800000,0x3f800000,setting],
  _=>[0x41f00000,0x3f800000,0x3f800000,0x3f800000,0x3f800000,setting],
 }
}
#[cfg(test)]
mod engine_rate_tests{
 use super::*;
 #[test]
 fn engine_setting_matches24_original_caller_executions(){
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/troy_engine_rate_contract.json")).unwrap();
  let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),24);
  for c in cases{
   let expected:[u32;6]=std::array::from_fn(|i|c["words"][i].as_u64().unwrap() as u32);
   assert_eq!(engine_timing_words(c["setting"].as_u64().unwrap() as u32),expected);
  }
 }
}

/// Contiguous native919720..919C9D resets configuration1BC, then reads eight booleans.
/// These are resource flags, not animation-event flags or parent-instance flags.
pub fn system_flags(system:&serde_json::Value)->Result<u32,&'static str>{
 if !system.is_object(){return Err("invalid decoded Troy System");}
 let mut flags=0;
 for (name,bit,default) in [
  ("SimulateWhileOffScreen",1,false),("SimulateOncePerFrame",8,false),
  ("SimulateEveryFrame",0x40,false),("SoundEndsOnEmitterEnd",0x10,false),
  ("SoundsPlayWhileOffScreen",0x20,false),("PersistThruDeath",2,false),
  ("PersistThruRevive",4,true),("KeepOrientationAfterSpellCast",0x80,true)] {
  let enabled=match system.get(name){None=>default,Some(serde_json::Value::Bool(v))=>*v,
   Some(v) if v.as_i64()==Some(0)=>false,Some(v) if v.as_i64()==Some(1)=>true,
   Some(_)=>return Err("unqualified system boolean representation")};
  if enabled{flags|=bit;}
 }
 Ok(flags)
}
#[cfg(test)]mod full_flags_tests{
 use super::*;
 #[test]fn flags_match_contiguous_native_constructor_on_actual_resources(){
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/troy_system_flags_contract.json")).unwrap();
  let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),96);
  for c in cases{assert_eq!(system_flags(&c["system"]).unwrap(),c["flags"].as_u64().unwrap() as u32,"{c}");}
  assert_eq!(system_flags(&serde_json::json!({})).unwrap(),0x84);
  assert!(system_flags(&serde_json::json!({"SoundsPlayWhileOffScreen":"yes"})).is_err());
 }
}
