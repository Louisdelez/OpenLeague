//! Native B124E0 successful subscription mutations and B13540 notifications.
//! Allocator failures, absent RTPC record construction and class3 remain explicit gaps.
use std::collections::BTreeMap;
use crate::{audio_rtpc_manager::{Manager,Record,RouteCurve},audio_rtpc_bank::Subscription};
#[derive(Debug,Clone)] pub struct Binding {pub owner:u32,pub class:u32,pub curve_ids:Vec<u32>,sequence:u64}
#[derive(Debug,PartialEq)] pub enum Error {UnsupportedClass(u32),UnsupportedParameter(u32),MissingRecord(u32),Curve(crate::audio_curves::Error),Evaluation(crate::audio_rtpc_manager::Error),Overflow}
#[derive(Debug,PartialEq)] pub enum Notification {Control {parameter:u16,value:f32},Invalidate,BusControl {parameter:u16,value:f32}}
#[derive(Debug,PartialEq)] pub struct Outcome {pub status:u32,pub notifications:Vec<Notification>}
#[derive(Debug,Clone,Default)] pub struct Subscriptions {manager:Manager,bindings:BTreeMap<(u32,u32),Binding>,sequence:u64}
#[derive(Debug,Clone,Copy,Default,PartialEq)] pub struct BusState {pub slot13:f32,pub slot14:f32}
impl BusState {
 /// Original AEED80 changes only signed-short parameter13/14 when bus state exists.
 pub fn apply(&mut self,notification:&Notification){if let Notification::BusControl {parameter,value}=notification {match *parameter as i16 {13=>self.slot13=*value,14=>self.slot14=*value,_=>{}}}}
}
impl Subscriptions {
 pub fn manager(&self)->&Manager {&self.manager}
 pub fn bindings(&self)->&BTreeMap<(u32,u32),Binding>{&self.bindings}
 pub fn set_record(&mut self,id:u32,record:Record){self.manager.records.insert(id,record);}
 /// Native replacement removes the old curve and appends the new one at the end.
 /// Existing binding owner/class are retained; an empty replacement returns31,
 /// leaves other curves intact, and does not notify. An emptied binding is retired.
 pub fn subscribe(&mut self,subscriber:u32,owner:u32,class:u32,entry:Subscription)->Result<Outcome,Error>{
  if subscriber==0{return Ok(Outcome {status:31,notifications:Vec::new()});}
  if entry.parameter>=64{return Err(Error::UnsupportedParameter(entry.parameter));}
  let key=(subscriber,entry.parameter);
  if !self.bindings.contains_key(&key)&&!matches!(class,0|1|2|4){return Err(Error::UnsupportedClass(class));}
  let empty=entry.curve.points.is_empty();
  if !empty {entry.curve.validate().map_err(Error::Curve)?;if !self.manager.records.contains_key(&entry.rtpc){return Err(Error::MissingRecord(entry.rtpc));}}
  if !self.bindings.contains_key(&key) {
   self.sequence=self.sequence.checked_add(1).ok_or(Error::Overflow)?;
   self.bindings.insert(key,Binding {owner,class,curve_ids:Vec::new(),sequence:self.sequence});self.manager.bindings.insert(key,Vec::new());
  }
  let binding=self.bindings.get_mut(&key).unwrap();let curves=self.manager.bindings.get_mut(&key).unwrap();
  if let Some(index)=binding.curve_ids.iter().position(|id|*id==entry.curve_id){binding.curve_ids.remove(index);curves.remove(index);}
  if !empty {binding.curve_ids.push(entry.curve_id);curves.push(RouteCurve {rtpc:entry.rtpc,curve:entry.curve});}
  if curves.is_empty(){self.manager.bindings.remove(&key);self.bindings.remove(&key);}
  if empty{return Ok(Outcome {status:31,notifications:Vec::new()});}
  Ok(Outcome {status:1,notifications:self.notify(subscriber)?})
 }
 /// Compose the generic bank reader's incremental flag marking and dispatch.
 /// Manager absence still marks flags but skips class, subscribe and node notify.
 /// Each successful subscribe delivers notify-all before the bank node notification.
 pub fn load_bank(&mut self,subscriber:u32,parsed:&crate::audio_rtpc_bank::Parsed,flags:&mut [u32;2],manager_available:bool,
  mut class:impl FnMut([u32;2])->u32,mut deliver:impl FnMut(&Notification,[u32;2]),mut node_notify:impl FnMut(u32,[u32;2]))->Result<Vec<u32>,Error>{
  let mut statuses=Vec::new();
  for entry in &parsed.entries {
   if entry.parameter<64 {flags[(entry.parameter/32) as usize]|=1u32<<(entry.parameter%32);}
   if manager_available {
    let kind=class(*flags);let result=self.subscribe(subscriber,0,kind,entry.clone())?;
    for notification in &result.notifications {deliver(notification,*flags);}
    // Native B008B0 ignores B124E0's status and calls virtual70 regardless.
    statuses.push(result.status);node_notify(entry.parameter,*flags);
   }
  }
  Ok(statuses)
 }
 fn ordered_keys(&self,subscriber:u32)->Vec<(u32,u32)>{
  let mut keys:Vec<_>=self.bindings.keys().filter(|(id,_)|*id==subscriber).copied().collect();
  keys.sort_by_key(|key|(key.0.wrapping_add(key.1)%193,std::cmp::Reverse(self.bindings[key].sequence)));keys
 }
 /// Original notify-all hash-table order, including repeated invalidate calls.
 pub fn notify(&self,subscriber:u32)->Result<Vec<Notification>,Error>{
  let mut out=Vec::new();
  for key in self.ordered_keys(subscriber){let binding=&self.bindings[&key];
   match binding.class {
    1|2=>out.push(Notification::Invalidate),
    0|4=>{let value=self.manager.evaluate(key.0,key.1,binding.owner).map_err(Error::Evaluation)?.value;out.push(if binding.class==0 {Notification::Control {parameter:key.1 as u16,value}}else{Notification::BusControl {parameter:key.1 as u16,value}});},
    kind=>return Err(Error::UnsupportedClass(kind)),
   }
  }
  Ok(out)
 }
}
#[cfg(test)] mod tests {
 use super::*;
 fn input(row:&serde_json::Value)->Subscription {Subscription {rtpc:row["rtpc"].as_u64().unwrap() as u32,parameter:row["parameter"].as_u64().unwrap() as u32,curve_id:row["curve_id"].as_u64().unwrap() as u32,curve:crate::audio_curves::Curve {scaling:row["scaling"].as_u64().unwrap() as u32,points:serde_json::from_value(row["points"].clone()).unwrap()}}}
 #[test] fn original_creation_replacement_retirement_and_notifications_match512_mutations(){
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_rtpc_subscriptions_contract.json")).unwrap();assert_eq!(proof["case_count"],128);assert_eq!(proof["step_count"],512);let subscriber=proof["subscriber"].as_u64().unwrap() as u32;
  let mut checked=0;
  for case in proof["cases"].as_array().unwrap(){
   let mut state=Subscriptions::default();let mut bus=BusState::default();
   for (id,default,global,owner) in [(100,20.,25.,75.),(293,60.,35.,85.)]{state.set_record(id,Record {default,overrides:BTreeMap::from([(0,global),(77,owner)])});}
   for step in case["steps"].as_array().unwrap(){
    let result=state.subscribe(subscriber,step["owner"].as_u64().unwrap() as u32,step["class"].as_u64().unwrap() as u32,input(step)).unwrap();assert_eq!(u64::from(result.status),step["result"].as_u64().unwrap());
    let mut calls=Vec::new();for notification in &result.notifications {bus.apply(notification);match notification {Notification::Control {parameter,value}=>calls.push(serde_json::json!({"kind":"control","parameter":parameter,"value_bits":value.to_bits()})),Notification::Invalidate=>calls.push(serde_json::json!({"kind":"invalidate"})),Notification::BusControl {..}=>{}}}
    assert_eq!(serde_json::json!(calls),step["calls"]);assert_eq!(u64::from(bus.slot13.to_bits()),step["bus_slot13_bits"].as_u64().unwrap());assert_eq!(u64::from(bus.slot14.to_bits()),step["bus_slot14_bits"].as_u64().unwrap());
    let snapshot:Vec<_>=state.ordered_keys(subscriber).into_iter().map(|key|{let binding=&state.bindings[&key];let curves:Vec<_>=state.manager.bindings[&key].iter().zip(&binding.curve_ids).map(|(route,id)|serde_json::json!({"curve_id":id,"rtpc":route.rtpc,"scaling":route.curve.scaling,"points":route.curve.points.iter().map(|p|serde_json::json!({"from":p.from,"to":p.to,"interp":p.interp})).collect::<Vec<_>>()})).collect();serde_json::json!({"parameter":key.1,"owner":binding.owner,"class":binding.class,"curves":curves})}).collect();assert_eq!(serde_json::json!(snapshot),step["bindings"]);checked+=1;
   }
  }
  assert_eq!(checked,512);
 }
 #[test] fn unsupported_runtime_records_classes_and_curves_are_explicit(){
  let mut state=Subscriptions::default();let entry=Subscription {rtpc:100,parameter:29,curve_id:500,curve:crate::audio_curves::Curve {scaling:0,points:vec![crate::audio_curves::Point {from:0.,to:1.,interp:4}]}};
  assert_eq!(state.subscribe(0,0,3,entry.clone()).unwrap().status,31);assert!(state.bindings.is_empty());
  assert!(matches!(state.subscribe(12,0,3,entry.clone()),Err(Error::UnsupportedClass(3))));assert!(matches!(state.subscribe(12,0,1,entry.clone()),Err(Error::MissingRecord(100))));assert!(state.bindings.is_empty());
  state.set_record(100,Record::default());let mut invalid=entry.clone();invalid.curve.scaling=99;assert!(matches!(state.subscribe(12,0,0,invalid),Err(Error::Curve(_))));assert!(state.bindings.is_empty());
  assert_eq!(state.subscribe(12,0,0,entry).unwrap().notifications,[Notification::Control {parameter:29,value:1.}]);
 }
}

#[cfg(test)] mod bank_composition_tests {
 use super::*;
 fn decode(hex:&str)->Vec<u8>{(0..hex.len()).step_by(2).map(|i|u8::from_str_radix(&hex[i..i+2],16).unwrap()).collect()}
 #[test] fn original_bank_reader_subscription_composition_matches_all_loads(){
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_rtpc_bank_composition_contract.json")).unwrap();
  let blocks:BTreeMap<_,_>=proof["blocks"].as_array().unwrap().iter().map(|block|(block["id"].as_str().unwrap(),decode(block["bytes"].as_str().unwrap()))).collect();let subscriber=proof["subscriber"].as_u64().unwrap() as u32;let mut checked=0;
  for row in proof["cases"].as_array().unwrap(){
   let mut state=Subscriptions::default();for (id,value) in proof["defaults"].as_object().unwrap(){state.set_record(id.parse().unwrap(),Record {default:value.as_f64().unwrap() as f32,..Default::default()});}
   let mut flags=[row["initial_flags"][0].as_u64().unwrap() as u32,row["initial_flags"][1].as_u64().unwrap() as u32];let raw=&blocks[row["block"].as_str().unwrap()];
   for step in row["steps"].as_array().unwrap(){
    let parsed=crate::audio_rtpc_bank::read(raw,flags,raw.len() as u32).unwrap();let calls=std::cell::RefCell::new(Vec::new());
    let statuses=state.load_bank(subscriber,&parsed,&mut flags,row["manager"].as_bool().unwrap(),|flags|{calls.borrow_mut().push(serde_json::json!({"kind":"class","flags":flags}));step["class"].as_u64().unwrap() as u32},|notification,_|{match notification {Notification::Control {parameter,value}=>calls.borrow_mut().push(serde_json::json!({"kind":"control","parameter":parameter,"value_bits":value.to_bits()})),Notification::Invalidate=>calls.borrow_mut().push(serde_json::json!({"kind":"invalidate"})),Notification::BusControl {..}=>panic!("generic class0/1/2 fixture")}},|parameter,flags|calls.borrow_mut().push(serde_json::json!({"kind":"bank_notify","parameter":parameter,"flags":flags}))).unwrap();
    assert_eq!(serde_json::json!(calls.into_inner()),step["calls"]);assert_eq!(serde_json::json!(flags),step["flags"]);assert_eq!(parsed.consumed as u64,step["consumed"].as_u64().unwrap());assert_eq!(u64::from(parsed.remaining),step["remaining"].as_u64().unwrap());assert_eq!(step["result"],1);assert!(statuses.iter().all(|status|*status==1));
    let snapshot:Vec<_>=state.ordered_keys(subscriber).into_iter().map(|key|{let binding=&state.bindings[&key];let curves:Vec<_>=state.manager.bindings[&key].iter().zip(&binding.curve_ids).map(|(route,id)|serde_json::json!({"curve_id":id,"rtpc":route.rtpc,"scaling":route.curve.scaling,"points":route.curve.points.iter().map(|p|serde_json::json!({"from":p.from,"to":p.to,"interp":p.interp})).collect::<Vec<_>>()})).collect();serde_json::json!({"parameter":key.1,"owner":binding.owner,"class":binding.class,"curves":curves})}).collect();assert_eq!(serde_json::json!(snapshot),step["bindings"]);checked+=1;
   }
  }
  assert_eq!(checked,proof["step_count"].as_u64().unwrap());assert_eq!(checked,1992);
 }
 #[test] fn bank_node_notification_follows_empty_subscription_failure(){
  let mut state=Subscriptions::default();let parsed=crate::audio_rtpc_bank::Parsed {entries:vec![crate::audio_rtpc_bank::Subscription {rtpc:100,parameter:29,curve_id:500,curve:crate::audio_curves::Curve {scaling:0,points:vec![]}}],flags:[0,0],consumed:17,remaining:17};let mut flags=[0,0];let mut notifications=Vec::new();
  let statuses=state.load_bank(12,&parsed,&mut flags,true,|_|0,|_,_|panic!("empty subscription does not notify-all"),|parameter,flags|notifications.push((parameter,flags))).unwrap();assert_eq!(statuses,[31]);assert_eq!(notifications,[(29,[1<<29,0])]);assert!(state.bindings().is_empty());
 }
}
