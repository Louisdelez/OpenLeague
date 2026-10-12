//! Native default phase deadlines. Camera/audio/skin consumers remain separate work.
use bevy::prelude::*;
use crate::Match;
#[derive(Debug)] pub struct Schedule {pub pan:f64,pub skin:f64,pub main_sfx_delay:f64,pub main_sfx_fade:f64,pub minion_fade:f64,pub scoreboard_delay:f64}
impl Schedule {pub fn scoreboard(&self)->f64{self.skin+self.scoreboard_delay}}
pub fn schedule()->&'static Schedule {
 static VALUE:std::sync::OnceLock<Schedule>=std::sync::OnceLock::new();
 VALUE.get_or_init(||{
  let timing:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_endgame_default_timing.json")).expect("native getter qualification");
  let lua:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/endgame_lua_source_audit.json")).expect("native Lua audit");
  let getter=|name:&str|timing["cases"].as_array().unwrap().iter().find(|r|r["name"]==name).unwrap()["value"].as_f64().unwrap();
  let literal=|name:&str|lua["initialization"]["globals"][name].as_f64().expect("native phase literal");
  let s=Schedule{pan:getter("pan"),skin:getter("nexus_skin"),main_sfx_delay:literal("EOG_MAIN_SFX_FADE_DELAY_TIME"),main_sfx_fade:literal("EOG_MAIN_SFX_FADE_DURATION"),minion_fade:literal("EOG_MINION_FADE_TIME"),scoreboard_delay:literal("EOG_SCOREBOARD_PHASE_DELAY_TIME")};
  assert!([s.pan,s.skin,s.main_sfx_delay,s.main_sfx_fade,s.minion_fade,s.scoreboard_delay].iter().all(|v|v.is_finite()&&*v>=0.));s
 })
}
#[derive(Resource,Default,Debug)] pub struct Clock {key:Option<(u64,u64)>,started:Option<f64>}
impl Clock {
 fn observe(&mut self,key:Option<(u64,u64)>,now:f64){if self.key!=key {self.key=key;self.started=key.map(|_|now);}}
 pub fn age(&self,now:f64)->Option<f64>{self.started.map(|start|(now-start).max(0.))}
 pub fn skin_due_for(&self,result:&openleague_core::match_results::MatchResult,now:f64)->bool {self.key==Some((result.session,result.ended_tick)) && self.age(now).is_some_and(|age|age>=schedule().skin)}
 pub fn scoreboard_due(&self,now:f64)->bool{self.age(now).is_some_and(|age|age>=schedule().scoreboard())}
}
pub fn update(state:Res<Match>,time:Res<Time>,mut clock:ResMut<Clock>){let key=state.snapshot.as_ref().and_then(|s|s.result.as_ref()).map(|r|(r.session,r.ended_tick));clock.observe(key,time.elapsed_secs_f64());}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn phase_boundary_uses_native_skin_time_plus_original_scoreboard_timer(){
  let mut c=Clock::default();assert!(!c.scoreboard_due(100.));c.observe(Some((42,123)),100.);assert!(!c.scoreboard_due(105.499999));assert!(c.scoreboard_due(105.5));c.observe(Some((42,123)),106.);assert_eq!(c.age(106.),Some(6.));
 }
 #[test] fn different_match_and_absent_result_reset_the_local_phase_clock(){let mut c=Clock::default();c.observe(Some((1,3)),10.);assert!(c.scoreboard_due(20.));c.observe(None,20.);assert_eq!(c.age(20.),None);c.observe(Some((2,3)),30.);assert!(!c.scoreboard_due(30.));assert!(c.scoreboard_due(35.5));}
}

#[cfg(test)] mod lua51_consistency_tests {
 use super::*;
 #[test] fn native_schedule_matches_executed_original_lua51_calls_and_team_scope() {
  let document:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_endgame_lua51_contract.json")).unwrap();
  assert_eq!(document["runtime"],"Lua 5.1");assert_eq!(document["source_roundtrip_exact"],true);assert_eq!(document["instruction_arrays_preserved"],true);
  let mut checked=0;
  for case in document["cases"].as_array().unwrap().iter().filter(|c|c["use_death_animation"]==false) {
   let calls=case["calls"].as_array().unwrap();
   let call=|name:&str|calls.iter().find(|c|c["name"]==name).unwrap();
   assert_eq!(call("SetHQCurrentSkin")["time"].as_f64().unwrap(),schedule().skin);
   assert_eq!(call("FadeOutMainSFX")["time"].as_f64().unwrap(),schedule().main_sfx_delay);
   assert_eq!(call("FadeOutMainSFX")["args"][0].as_f64().unwrap(),schedule().main_sfx_fade);
   assert_eq!(call("FadeMinions")["time"].as_f64().unwrap(),schedule().skin);
   assert_eq!(call("FadeMinions")["args"][0],case["loser"]);assert_eq!(call("FadeMinions")["args"][1].as_f64().unwrap(),0.);
   assert_eq!(call("FadeMinions")["args"][2].as_f64().unwrap(),schedule().minion_fade);
   assert_eq!(call("SetMinionsNoRender")["time"].as_f64().unwrap(),schedule().skin+schedule().minion_fade);
   assert_eq!(call("SetMinionsNoRender")["args"][0],case["loser"]);assert_eq!(call("SetMinionsNoRender")["args"][1],true);
   assert_eq!(call("EndGame")["time"].as_f64().unwrap(),schedule().scoreboard());assert_eq!(call("EndGame")["args"][0],case["winner"]);
   for camera in calls.iter().filter(|c|c["name"]=="MoveCameraFromCurrentPositionToPoint") {assert_eq!(camera["args"][2].as_f64().unwrap(),schedule().pan);assert_eq!(camera["args"][3],true);}
   for grey in calls.iter().filter(|c|c["name"]=="SetGreyscaleEnabledWhenDead") {assert_eq!(grey["args"][1],false);}
   checked+=1;
  }
  assert_eq!(checked,8);
 }
}
