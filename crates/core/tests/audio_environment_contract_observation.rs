//! Current selection compared with four isolated native4.20 event traces.
//! See docs/FIDELITY_REA_ENVIRONMENT_EVENTS_V789.md; this test does not play audio.
use openleague_core::{audio_action_dispatch::Dispatcher,audio_selection::{ambient_contract,NativeSelector,Selection},audio_random::NativeRandom};
fn expected(a:&serde_json::Value)->Option<Selection>{
 let s=&a["selection"];if s.is_null(){return None;}
 Some(Selection{action:a["action"].as_u64().unwrap()as u32,container:a["target"].as_u64().unwrap()as u32,sound:s["sound"].as_u64().unwrap()as u32,source:s["media"].as_u64().unwrap()as u32,transition_ms:100.})
}
#[test]
fn current_environment_selection_matches_four_native_traces(){
 let cases:serde_json::Value=serde_json::from_str(r#"[{"profile":"revision789_event_bigchains_extended","event_id":3282059833,"actions":[{"action":1039678573,"target":6932,"probability_percent":100.0,"gate_seed":1700000000,"selection":{"sound":567219536,"media":400899600},"native_action_object":1612821040},{"action":650629985,"target":535542627,"probability_percent":100.0,"gate_seed":4012821443,"selection":{"sound":566280987,"media":800678156},"native_action_object":1612821104}]},{"profile":"revision789_event_bigchainsbase_extended","event_id":2293336866,"actions":[{"action":576555959,"target":6935,"probability_percent":100.0,"gate_seed":1700000000,"selection":{"sound":91624717,"media":400899600},"native_action_object":1612820016},{"action":242485587,"target":493483218,"probability_percent":100.0,"gate_seed":4012821443,"selection":{"sound":609493361,"media":51118002},"native_action_object":1612820080}]},{"profile":"revision789_event_brazierchain_extended","event_id":1392698701,"actions":[{"action":1049381235,"target":6927,"probability_percent":50.0,"gate_seed":1700000000,"selection":null,"native_action_object":1612819200},{"action":415219389,"target":191470420,"probability_percent":25.0,"gate_seed":67307386,"selection":null,"native_action_object":1612819264}]},{"profile":"revision789_event_brazierchain_epoch0","event_id":1392698701,"actions":[{"action":1049381235,"target":6927,"probability_percent":50.0,"gate_seed":0,"selection":{"sound":407149979,"media":931355143},"native_action_object":1612819200},{"action":415219389,"target":191470420,"probability_percent":25.0,"gate_seed":3539360597,"selection":{"sound":900501484,"media":556739449},"native_action_object":1612819264}]}]"#).unwrap();
 for c in cases.as_array().unwrap(){
  let event=c["event_id"].as_u64().unwrap()as u32;let actions=c["actions"].as_array().unwrap();
  let seed=actions[0]["gate_seed"].as_u64().unwrap()as u32;let mut rng=NativeRandom::seeded(seed);let mut selector=NativeSelector::new(ambient_contract().unwrap()).unwrap();
  for a in actions{
   assert_eq!(rng.state(),a["gate_seed"].as_u64().unwrap()as u32);
   let selected=selector.action(event,a["action"].as_u64().unwrap()as u32,2000001,&mut rng).unwrap();assert_eq!(selected,expected(a));
  }
  let mut dispatcher=Dispatcher::new(ambient_contract().unwrap()).unwrap();let mut rng2=NativeRandom::seeded(seed);
  let dispatched=dispatcher.post_immediate_event(event,2000001,0,&mut rng2).unwrap();assert_eq!(dispatched.len(),2);
  for (actual,want)in dispatched.iter().zip(actions){assert_eq!(actual.action,want["action"].as_u64().unwrap()as u32);assert_eq!(actual.selection,expected(want));}
  assert_eq!(rng2.state(),rng.state());assert_eq!(dispatcher.pending(),0);
  println!("OBSERVATION {}",serde_json::json!({"profile":c["profile"],"event":event,"actions":2,"selected":dispatched.iter().filter(|e|e.selection.is_some()).count(),"seed":seed,"final_selection_seed":rng.state()}));
 }
}
#[test]
fn unknown_event_and_action_preserve_rng_and_queue(){
 let mut d=Dispatcher::new(ambient_contract().unwrap()).unwrap();let mut rng=NativeRandom::seeded(17);
 assert!(d.post_immediate_event(0,2000001,0,&mut rng).is_err());assert_eq!(rng.state(),17);assert_eq!(d.pending(),0);
 assert!(d.post(0,0,2000001,0,1024,&mut rng).is_err());assert_eq!(rng.state(),17);assert_eq!(d.pending(),0);
 println!("LOCAL_REFUSALS 2 PASS");
}
