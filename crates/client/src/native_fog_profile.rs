//! Original environment setting suffix8376CC and Fog setter987600.
//! Full option retrieval and dependent rebuild bodies remain separate work.
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub struct Profile {pub environment:i32,pub fog:u32,pub clouds:bool}
impl Profile {
 pub fn from_setting(input:i32)->Self {Self {environment:input.clamp(0,4),fog:if input<=1 {1} else {2},clouds:input>=2}}
}
#[derive(Clone,Copy,Debug)]
pub struct State {pub environment:i32,pub fog:u32,pub revision:u32}
impl State {
 pub fn apply(&mut self,input:i32,enabled:bool,subscribers:usize,mut notify:impl FnMut(usize,bool))->Profile {
  let profile=Profile::from_setting(input);
  if self.environment!=profile.environment {self.environment=profile.environment;self.revision=self.revision.wrapping_add(1);}
  if self.fog!=profile.fog {self.fog=profile.fog;for index in 0..subscribers {notify(index,enabled);}}
  profile
 }
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn profile_and_notifications_match_original_dispatcher_cases() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_environment_fog_profile_contract.json")).unwrap();assert_eq!(proof["passed"],true);
  assert_eq!(proof["case_count"],1408);
  for c in proof["cases"].as_array().unwrap() {
   let mut state=State {environment:c["previous_environment"].as_i64().unwrap() as i32,fog:c["previous_fog"].as_u64().unwrap() as u32,revision:c["initial_revision"].as_u64().unwrap() as u32};
   let mut notifications=Vec::new();let profile=state.apply(c["input"].as_i64().unwrap() as i32,c["enabled"].as_bool().unwrap(),c["subscribers"].as_u64().unwrap() as usize,|i,enabled|notifications.push((i,enabled)));
   assert_eq!(profile.environment,c["environment_quality"].as_i64().unwrap() as i32);assert_eq!(profile.fog,c["fog_quality"].as_u64().unwrap() as u32);assert_eq!(profile.clouds,c["clouds_enabled"].as_bool().unwrap());assert_eq!(state.revision,c["revision"].as_u64().unwrap() as u32);
   let expected=c["notifications"].as_array().unwrap();assert_eq!(notifications.len(),expected.len());for (i,(_,enabled)) in notifications.iter().enumerate() {assert_eq!(*enabled,expected[i]["enabled"].as_u64().unwrap()!=0);}
  }
 }
}
