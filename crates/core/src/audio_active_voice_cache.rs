//! Sound AF3420 active list invalidation -> AEE780 raw flag changes.
//! AEDC60 gate requests virtual3C only while primary control cache bit20 is clear.
//! Full recomputation owns its values and final flags; no automatic valid mark here.
use std::collections::{BTreeMap,BTreeSet};
#[derive(Debug,Clone,Copy,PartialEq,Eq)] pub struct Flags {pub raw:[u8;4]}
impl Flags {
 pub fn invalidate(&mut self){self.raw[0]&=0xdf;self.raw[2]&=0xbf;}
 pub fn needs_refresh(&self)->bool {self.raw[0]&0x20==0}
}
#[derive(Debug,Clone)] pub struct Voice {pub next:Option<u32>,pub flags:Flags}
#[derive(Debug,Default)] pub struct Store {pub voices:BTreeMap<u32,Voice>}
#[derive(Debug,PartialEq,Eq)] pub enum Error {MissingVoice(u32),Cycle(u32),Backend(&'static str)}
impl Store {
 /// Build the linked-list traversal first, rejecting malformed graphs before writes.
 /// Original ordering remains intact and repeated notifications remain repeated walks.
 pub fn invalidate(&mut self,head:Option<u32>)->Result<Vec<u32>,Error>{
  let mut visited=BTreeSet::new();let mut order=Vec::new();let mut cursor=head;
  while let Some(id)=cursor {if !visited.insert(id){return Err(Error::Cycle(id));}let voice=self.voices.get(&id).ok_or(Error::MissingVoice(id))?;order.push(id);cursor=voice.next;}
  for id in &order {self.voices.get_mut(id).unwrap().flags.invalidate();}Ok(order)
 }
 /// Dispatch the native cache gate. The actual recompute callback must establish
 /// its qualified final flags; returning success alone does not validate the cache.
 pub fn refresh_if_needed(&mut self,id:u32,mut recompute:impl FnMut(&mut Voice)->Result<(),Error>)->Result<bool,Error>{
  let voice=self.voices.get_mut(&id).ok_or(Error::MissingVoice(id))?;
  if !voice.flags.needs_refresh(){return Ok(false);}
  recompute(voice)?;Ok(true)
 }
}
#[cfg(test)] mod tests {
 use super::*;
 use crate::{audio_rtpc_bank,audio_rtpc_manager::Record,audio_rtpc_subscriptions::{Subscriptions,Notification}};
 fn decode(hex:&str)->Vec<u8>{(0..hex.len()).step_by(2).map(|i|u8::from_str_radix(&hex[i..i+2],16).unwrap()).collect()}
 #[test] fn actual_sound_bank_notifications_and_refresh_gates_match320_steps(){
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_active_voice_cache_contract.json")).unwrap();assert_eq!(proof["case_count"],160);assert_eq!(proof["step_count"],320);
  let blocks:BTreeMap<_,_>=proof["blocks"].as_array().unwrap().iter().map(|block|(block["id"].as_str().unwrap(),decode(block["bytes"].as_str().unwrap()))).collect();let subscriber=proof["subscriber"].as_u64().unwrap() as u32;let mut checked=0;
  for row in proof["cases"].as_array().unwrap(){
   let mut subscriptions=Subscriptions::default();for (id,value) in proof["defaults"].as_object().unwrap(){subscriptions.set_record(id.parse().unwrap(),Record {default:value.as_f64().unwrap() as f32,..Default::default()});}
   let layout:Vec<u32>=row["layout"].as_array().map_or(Vec::new(),|ids|ids.iter().map(|id|id.as_u64().unwrap() as u32).collect());let head=layout.first().copied();let mut store=Store::default();
   for (index,flags) in row["initial_voice_flags"].as_array().unwrap().iter().enumerate(){let next=layout.iter().position(|id|*id==index as u32).and_then(|i|layout.get(i+1).copied());let raw:[u8;4]=serde_json::from_value(flags.clone()).unwrap();store.voices.insert(index as u32,Voice {next,flags:Flags {raw}});}
   let mut flags=[0,0];let raw=&blocks[row["block"].as_str().unwrap()];
   for step in row["steps"].as_array().unwrap(){
    let parsed=audio_rtpc_bank::read(raw,flags,raw.len() as u32).unwrap();let calls=std::cell::RefCell::new(Vec::new());
    subscriptions.load_bank(subscriber,&parsed,&mut flags,row["manager"].as_bool().unwrap(),|flags|{calls.borrow_mut().push(serde_json::json!({"kind":"class","flags":flags}));2},|notification,_|{assert_eq!(notification,&Notification::Invalidate);calls.borrow_mut().push(serde_json::json!({"kind":"invalidate"}));for id in store.invalidate(head).unwrap(){calls.borrow_mut().push(serde_json::json!({"kind":"voice_invalidate","voice":id}));}},|parameter,flags|calls.borrow_mut().push(serde_json::json!({"kind":"bank_notify","parameter":parameter,"flags":flags}))).unwrap();
    assert_eq!(serde_json::json!(calls.into_inner()),step["calls"]);let voices:Vec<_>=(0..3).map(|id|store.voices[&id].flags.raw).collect();assert_eq!(serde_json::json!(voices),step["voices"]);
    let mut refresh_calls=Vec::new();for id in 0..3 {store.refresh_if_needed(id,|_|{refresh_calls.push(id);Ok(())}).unwrap();}assert_eq!(serde_json::json!(refresh_calls),step["refresh_calls"]);checked+=1;
   }
  }
  assert_eq!(checked,320);
 }
 #[test] fn malformed_lists_do_not_partially_invalidate_other_voices(){
  let mut store=Store {voices:BTreeMap::from([(1,Voice {next:Some(2),flags:Flags {raw:[255;4]}})])};
  assert_eq!(store.invalidate(Some(1)),Err(Error::MissingVoice(2)));assert_eq!(store.voices[&1].flags.raw,[255;4]);store.voices.get_mut(&1).unwrap().next=Some(1);assert_eq!(store.invalidate(Some(1)),Err(Error::Cycle(1)));assert_eq!(store.voices[&1].flags.raw,[255;4]);assert_eq!(store.invalidate(None),Ok(Vec::new()));
 }
 #[test] fn only_actual_refresh_flags_can_make_a_cache_valid(){
  let mut store=Store {voices:BTreeMap::from([(1,Voice {next:None,flags:Flags {raw:[0,0x5a,0,0xa5]}})])};
  assert_eq!(store.refresh_if_needed(1,|_|Err(Error::Backend("unqualified recompute"))),Err(Error::Backend("unqualified recompute")));assert!(store.voices[&1].flags.needs_refresh());
  assert_eq!(store.refresh_if_needed(1,|_|Ok(())),Ok(true));assert!(store.voices[&1].flags.needs_refresh());
  store.voices.get_mut(&1).unwrap().flags.raw[0]|=0x20;
  assert_eq!(store.refresh_if_needed(1,|_|panic!("valid cache")),Ok(false));assert_eq!(store.voices[&1].flags.raw,[0x20,0x5a,0,0xa5]);
 }
}
