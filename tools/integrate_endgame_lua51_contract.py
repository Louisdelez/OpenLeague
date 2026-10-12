from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
shutil.copy2(stage/'native_endgame_lua51_contract.json',r/'data/4.20/native_endgame_lua51_contract.json')
p=r/'crates/client/src/endgame_timeline.rs';s=p.read_text(encoding='utf-8');assert 'mod lua51_consistency_tests' not in s
s+=r'''
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
'''
p.write_text(s,encoding='utf-8');print('Source-executed Lua5.1 contract linked to native schedule verification')
