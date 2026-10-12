//! Playback rate maps verified GLTF frame keys to the original BLND frame clock.
use std::{collections::BTreeMap,sync::OnceLock};
#[derive(serde::Deserialize)] struct Clock {speed:f32,repeat:bool,gltf_endpoint:f32}
#[derive(serde::Deserialize)] struct Catalog {models:BTreeMap<String,BTreeMap<String,Clock>>}
fn catalog()->&'static Catalog {
 static C:OnceLock<Catalog>=OnceLock::new();
 C.get_or_init(||serde_json::from_str(include_str!("../../../data/4.20/structure_clip_playback.json")).expect("verified structure animation clock"))
}
pub fn repeats(model:&str,role:&str)->Option<bool> {
 catalog().models.get(model).and_then(|m|m.get(role)).map(|c|c.repeat)
}
pub fn configure(model:&str,role:&str,active:&mut bevy::animation::ActiveAnimation)->bool {
 let Some(repeat)=repeats(model,role) else {return false;};
 active.set_speed(speed(model,role)).set_repeat(if repeat {bevy::animation::RepeatAnimation::Forever} else {bevy::animation::RepeatAnimation::Never});true
}
pub fn speed(model:&str,role:&str)->f32 {
 let catalog=catalog();
 let value=catalog.models.get(model).and_then(|m|m.get(role)).map(|c|c.speed).unwrap_or(1.);
 assert!(value.is_finite()&&value>0.,"invalid qualified structure animation speed");value
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn exported_key_phases_follow_native_period_and_frame_clock_oracles(){
  let binding:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/structure_clip_playback.json")).unwrap();
  let native:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/structure_clip_period_contract.json")).unwrap();assert_eq!(native["passed"],true);
  let mut checked=0;
  for (model,roles) in binding["models"].as_object().unwrap(){for (role,c) in roles.as_object().unwrap(){
   let source=native["models"].as_array().unwrap().iter().find(|m|m["model"]==c["native_model"]).unwrap();
   let state=source["states"].as_array().unwrap().iter().find(|s|s["name"]==c["native_state"]).unwrap();
   let step=c["gltf_time_step"].as_f64().unwrap() as f32;let endpoint=c["gltf_endpoint"].as_f64().unwrap() as f32;
   let period=f32::from_bits(state["native_period_bits"].as_u64().unwrap() as u32);let rate=speed(model,role);
   assert!((endpoint/rate-period).abs()<1e-6);
   for sample in state["clock_cases"].as_array().unwrap(){
    let elapsed=f32::from_bits(sample["elapsed_bits"].as_u64().unwrap() as u32);let frame=f32::from_bits(sample["native_frame_bits"].as_u64().unwrap() as u32);
    assert!((elapsed*rate/step-frame).abs()<1e-4,"{model}/{role} native frame mismatch");checked+=1;
   }
  }}assert_eq!(checked,240);
 }
}

#[cfg(test)] mod lifecycle_tests {
 use super::*;
 #[test] fn repeat_policy_matches_executed_native_nodes(){
  let native:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/structure_native_lifecycle_contract.json")).unwrap();assert_eq!(native["passed"],true);
  let binding:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/structure_clip_playback.json")).unwrap();let mut checked=0;
  for (model,roles) in binding["models"].as_object().unwrap(){for (role,c) in roles.as_object().unwrap(){
   let source=native["states"].as_array().unwrap().iter().find(|s|s["model"]==c["native_model"]&&s["state"]==c["native_state"]).unwrap();
   let repeat=repeats(model,role).unwrap();assert_eq!(repeat,source["loop"].as_bool().unwrap());
   for case in source["cases"].as_array().unwrap(){if case["stop_requested"]==false{assert_eq!(repeat,case["loop"].as_bool().unwrap());checked+=1;}}
  }}assert_eq!(checked,480);assert_eq!(repeats("Garen","idle"),None);
 }
 #[test] fn death_on_shared_clip_clears_inherited_loop_and_restarts(){
  use bevy::animation::{AnimationPlayer,RepeatAnimation,transition::AnimationTransitions,graph::AnimationNodeIndex};
  let mut player=AnimationPlayer::default();let mut transitions=AnimationTransitions::new();let clip=AnimationNodeIndex::new(0);
  let idle=transitions.play(&mut player,clip,std::time::Duration::ZERO);
  assert!(configure("TT_OrderInhibitor_destroyed","idle",idle));assert_eq!(idle.repeat_mode(),RepeatAnimation::Forever);idle.seek_to(2.);
  let death=transitions.play(&mut player,clip,std::time::Duration::ZERO);
  assert!(configure("TT_OrderInhibitor_destroyed","death",death));assert_eq!(death.repeat_mode(),RepeatAnimation::Never);assert_eq!(death.seek_time(),0.);assert_eq!(death.completions(),0);
 }
}

/// Native one-shot nodes retain the final frame after their update returns false.
pub fn clamp_finished(model:&str,role:&str,active:&mut bevy::animation::ActiveAnimation) {
 if !active.is_finished(){return;}
 if let Some(clock)=catalog().models.get(model).and_then(|m|m.get(role)) {
  if !clock.repeat {active.seek_to(clock.gltf_endpoint);}
 }
}
