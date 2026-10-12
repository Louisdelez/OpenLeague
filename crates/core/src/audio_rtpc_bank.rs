//! Native B008B0 RTPC block reader; header IDs are passed unchanged.
//! Initial snapshots only: runtime replacement, smoothing and notifications are separate.
use crate::{audio_curves::{Curve,Point},audio_rtpc_manager::{Manager,Record,RouteCurve}};
use std::collections::{BTreeMap,BTreeSet};
#[derive(Debug,Clone)] pub struct Subscription {pub rtpc:u32,pub parameter:u32,pub curve_id:u32,pub curve:Curve}
#[derive(Debug,Clone)] pub struct Parsed {pub entries:Vec<Subscription>,pub flags:[u32;2],pub consumed:usize,pub remaining:u32}
#[derive(Debug,PartialEq)] pub enum Error {Truncated,UnsupportedParameter(u32),DuplicateCurve(u32,u32,u32),InvalidDefault(u32),Curve(crate::audio_curves::Error)}
struct Reader<'a>{bytes:&'a [u8],offset:usize}
impl Reader<'_>{
 fn bytes<const N:usize>(&mut self)->Result<[u8;N],Error>{let end=self.offset.checked_add(N).ok_or(Error::Truncated)?;let bytes=self.bytes.get(self.offset..end).ok_or(Error::Truncated)?.try_into().unwrap();self.offset=end;Ok(bytes)}
 fn u16(&mut self)->Result<u16,Error>{Ok(u16::from_le_bytes(self.bytes()?))}
 fn u32(&mut self)->Result<u32,Error>{Ok(u32::from_le_bytes(self.bytes()?))}
}
/// Original remaining counter subtracts point payload bytes only, with u32 wrap.
/// Safe parsing additionally rejects truncated input, before any external effects.
pub fn read(bytes:&[u8],mut flags:[u32;2],mut remaining:u32)->Result<Parsed,Error>{
 let mut reader=Reader {bytes,offset:0};let count=reader.u16()?;let mut entries=Vec::new();
 for _ in 0..count {
  let rtpc=reader.u32()?;let parameter=reader.u32()?;let curve_id=reader.u32()?;let scaling=u32::from(reader.bytes::<1>()?[0]);let size=reader.u16()?;
  if parameter<64 {flags[(parameter/32) as usize]|=1u32<<(parameter%32);}
  let mut points=Vec::with_capacity(size as usize);
  for _ in 0..size {points.push(Point {from:f32::from_bits(reader.u32()?),to:f32::from_bits(reader.u32()?),interp:reader.u32()?});}
  remaining=remaining.wrapping_sub(u32::from(size)*12);
  entries.push(Subscription {rtpc,parameter,curve_id,curve:Curve {scaling,points}});
 }
 Ok(Parsed {entries,flags,consumed:reader.offset,remaining})
}
/// Native ignores the subscription return status and still notifies the node.
/// The caller supplies both backend operations; absence skips both.
pub fn dispatch(parsed:&Parsed,mut subscribe:impl FnMut(&Subscription,u32)->u32,mut class:impl FnMut()->u32,mut notify:impl FnMut(u32)) {
 for entry in &parsed.entries {let cls=class();let _=subscribe(entry,cls);notify(entry.parameter);}
}
/// Build a fresh static manager from verified blocks with explicit runtime subscriber
/// identities. Does not substitute bank object IDs for live node references.
/// Duplicate curve IDs need native replacement semantics and are rejected here.
pub fn initial_snapshot(blocks:&[(u32,Parsed)],defaults:&BTreeMap<u32,f32>)->Result<Manager,Error>{
 let mut manager=Manager::default();let mut seen=BTreeSet::new();
 for (&id,&value) in defaults {if !value.is_finite(){return Err(Error::InvalidDefault(id));}manager.records.insert(id,Record {default:value,..Default::default()});}
 for (subscriber,block) in blocks {
  for entry in &block.entries {
   if entry.parameter>=64 {return Err(Error::UnsupportedParameter(entry.parameter));}
   if !seen.insert((*subscriber,entry.parameter,entry.curve_id)){return Err(Error::DuplicateCurve(*subscriber,entry.parameter,entry.curve_id));}
   entry.curve.validate().map_err(Error::Curve)?;
   manager.bindings.entry((*subscriber,entry.parameter)).or_default().push(RouteCurve {rtpc:entry.rtpc,curve:entry.curve.clone()});
  }
 }
 Ok(manager)
}
#[cfg(test)] mod tests {
 use super::*;
 fn decode(hex:&str)->Vec<u8>{(0..hex.len()).step_by(2).map(|i|u8::from_str_radix(&hex[i..i+2],16).unwrap()).collect()}
 #[test] fn original_bank_reader_flags_raw_ids_payload_and_callback_order_match2280_cases(){
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_rtpc_bank_reader_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),2280);
  let blocks: BTreeMap<_,_>=proof["blocks"].as_array().unwrap().iter().map(|b|(b["id"].as_str().unwrap(),decode(b["bytes"].as_str().unwrap()))).collect();
  for row in cases {
   let bytes=&blocks[row["block"].as_str().unwrap()];let flags=[row["initial_flags"][0].as_u64().unwrap() as u32,row["initial_flags"][1].as_u64().unwrap() as u32];let parsed=read(bytes,flags,bytes.len() as u32).unwrap();
   assert_eq!(serde_json::json!(parsed.flags),row["flags"]);assert_eq!(parsed.consumed as u64,row["consumed"].as_u64().unwrap());assert_eq!(u64::from(parsed.remaining),row["remaining"].as_u64().unwrap());assert_eq!(row["result"],1);
   let calls=std::cell::RefCell::new(Vec::new());
   if row["manager"]==true {dispatch(&parsed,|entry,cls|{calls.borrow_mut().push(serde_json::json!({"kind":"subscribe","rtpc":entry.rtpc,"parameter":entry.parameter,"curve_id":entry.curve_id,"scaling":entry.curve.scaling,"points":entry.curve.points.iter().map(|p|serde_json::json!({"from":p.from,"to":p.to,"interp":p.interp})).collect::<Vec<_>>(),"owner":0,"class":cls}));row["subscribe_status"].as_u64().unwrap() as u32},||{calls.borrow_mut().push(serde_json::json!({"kind":"class"}));row["class"].as_u64().unwrap() as u32},|id|calls.borrow_mut().push(serde_json::json!({"kind":"notify","parameter":id})));}
   assert_eq!(serde_json::json!(calls.into_inner()),row["calls"]);
  }
 }
 #[test] fn truncation_and_unsupported_snapshot_updates_are_explicit(){
  let mut bytes=2u16.to_le_bytes().to_vec();assert!(matches!(read(&bytes,[0,0],0),Err(Error::Truncated)));bytes=0u16.to_le_bytes().to_vec();assert!(read(&bytes,[1,2],0).unwrap().entries.is_empty());
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_rtpc_bank_reader_contract.json")).unwrap();let raw=decode(proof["blocks"].as_array().unwrap().iter().find(|b|b["id"]=="boundary:4:1").unwrap()["bytes"].as_str().unwrap());
  for length in 0..raw.len(){assert!(matches!(read(&raw[..length],[0,0],0),Err(Error::Truncated)));}
  let block=read(&raw,[0,0],0).unwrap();assert_eq!(block.remaining,0u32.wrapping_sub(24));
  assert!(matches!(initial_snapshot(&[(12,block.clone()),(12,block.clone())],&BTreeMap::new()),Err(Error::DuplicateCurve(12,4,500))));
  let mut invalid=block.clone();invalid.entries[0].parameter=64;assert!(matches!(initial_snapshot(&[(12,invalid)],&BTreeMap::new()),Err(Error::UnsupportedParameter(64))));
  assert!(matches!(initial_snapshot(&[(12,block)],&BTreeMap::from([(100,f32::NAN)])),Err(Error::InvalidDefault(100))));
 }
 #[test] fn actual_bank_initial_snapshot_matches63_original_manager_evaluations(){
  let banks:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_rtpc_bank_reader_contract.json")).unwrap();
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_rtpc_bank_snapshot_contract.json")).unwrap();
  let defaults:BTreeMap<u32,f32>=proof["defaults"].as_object().unwrap().iter().map(|(id,value)|(id.parse().unwrap(),value.as_f64().unwrap() as f32)).collect();
  let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),63);
  for row in cases {
   let block=banks["blocks"].as_array().unwrap().iter().find(|block|block["id"]==row["block"]).unwrap();let bytes=decode(block["bytes"].as_str().unwrap());let parsed=read(&bytes,[0,0],bytes.len() as u32).unwrap();
   let parameter=row["parameter"].as_u64().unwrap() as u32;assert_eq!(parameter,4);assert_eq!(parsed.flags,[16,0]);
   let mut manager=initial_snapshot(&[(42,parsed)],&defaults).unwrap();let rtpc=row["rtpc"].as_u64().unwrap() as u32;
   for value in row["overrides"].as_array().unwrap(){manager.records.get_mut(&rtpc).unwrap().overrides.insert(value["owner"].as_u64().unwrap() as u32,value["value"].as_f64().unwrap() as f32);}
   let actual=manager.evaluate(42,parameter,row["owner"].as_u64().unwrap() as u32).unwrap();assert_eq!(u64::from(actual.value.to_bits()),row["result_bits"].as_u64().unwrap());
   let calls:Vec<_>=actual.calls.iter().map(|c|serde_json::json!({"curve":c.curve,"input_bits":c.input_bits})).collect();assert_eq!(serde_json::json!(calls),row["calls"]);
  }
 }

}
