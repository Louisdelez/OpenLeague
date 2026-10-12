//! Original Bus B04A00 parameter gate and B03740 root/identified dispatch.
//! B02F20/B02EC0 source/cache flags and live RTPC evaluation stay distinct.
use crate::{audio_bus_registry::Bus,audio_rtpc_manager};
use std::collections::BTreeMap;
#[derive(Debug,Clone)] pub struct Cache{pub effect_ids:[u32;4],pub flags:u8}
#[derive(Debug,Default)] pub struct Store{pub caches:BTreeMap<u32,Cache>,pub source_flags:BTreeMap<u32,u8>}
#[derive(Debug,PartialEq,Eq)] pub enum Error{WrongClass,UnresolvedReference,MissingCache(u32),MissingSource(u32),Application(crate::audio_bus_control_application::Error),Backend(&'static str)}
#[derive(Debug,Clone,serde::Serialize)] #[serde(tag="kind",rename_all="lowercase")]
pub enum Call{Rtpc{subscriber:u32,parameter:u32,owner:u32},Root{args:[u32;2]},Bus{args:[u32;3]}}
pub trait Backend{
 fn rtpc(&mut self,subscriber:u32,parameter:u32,owner:u32)->Result<f32,Error>;
 fn root(&mut self,value:u32,mask:u32)->Result<(),Error>;
 fn bus(&mut self,id:u32,value:u32,mask:u32)->Result<(),Error>;
}
impl Store{
 pub fn notify(&self,bus:&Bus,parameter:u32,backend:&mut impl Backend)->Result<Vec<Call>,Error>{
  if bus.reference==0{return Err(Error::UnresolvedReference);}if bus.word(0)!=0xff1380{return Err(Error::WrongClass);}if parameter.wrapping_sub(24)>4{return Ok(vec![]);}
  let index=(parameter-24) as usize;let mask=1u32<<index;let cache=if bus.word(0x18)==0{None}else{Some(self.caches.get(&bus.word(0x18)).ok_or(Error::MissingCache(bus.word(0x18)))?)};
  let enabled=bus.word(0x30)&(1u32<<parameter)!=0;let mut calls=Vec::new();
  let evaluate=if index==4{enabled}else{cache.is_some_and(|c|c.effect_ids[index]!=0)&&enabled};
  let value=if evaluate{calls.push(Call::Rtpc{subscriber:bus.reference,parameter,owner:0});backend.rtpc(bus.reference,parameter,0)?!=0.}
   else if index!=4 && cache.is_none(){false}
   else if bus.word(0x14)!=0{let flags=self.source_flags.get(&bus.word(0x14)).ok_or(Error::MissingSource(bus.word(0x14)))?;(*flags&(mask as u8))!=0}
   else{cache.is_some_and(|c|c.flags&(mask as u8)!=0)};
  let value=if value{mask}else{0};if bus.word(0x24)==0 && bus.raw[0xc4]&0x80!=0{calls.push(Call::Root{args:[value,mask]});backend.root(value,mask)?;}else{let id=bus.word(8);calls.push(Call::Bus{args:[id,value,mask]});backend.bus(id,value,mask)?;}Ok(calls)
 }
}
/// Evaluate through the previously qualified native RTPC manager. Physical
/// root/identified-bus application remains a mandatory implementation.
pub struct ManagerBackend<'a,B>{pub manager:&'a audio_rtpc_manager::Manager,pub dependencies:&'a mut B,pub curves:Vec<audio_rtpc_manager::CurveCall>}
impl<B:Backend> Backend for ManagerBackend<'_,B>{
 fn rtpc(&mut self,s:u32,p:u32,o:u32)->Result<f32,Error>{let out=self.manager.evaluate(s,p,o).map_err(|_|Error::Backend("RTPC manager evaluation failed"))?;self.curves.extend(out.calls);Ok(out.value)}
 fn root(&mut self,v:u32,m:u32)->Result<(),Error>{self.dependencies.root(v,m)}
 fn bus(&mut self,id:u32,v:u32,m:u32)->Result<(),Error>{self.dependencies.bus(id,v,m)}
}
#[cfg(test)] mod tests{
 use super::*;
 struct Trace{calls:Vec<serde_json::Value>}
 impl Backend for Trace{fn rtpc(&mut self,_:u32,_:u32,_:u32)->Result<f32,Error>{Err(Error::Backend("RTPC dependency absent"))}fn root(&mut self,v:u32,m:u32)->Result<(),Error>{self.calls.push(serde_json::json!({"kind":"root","args":[v,m]}));Ok(())}fn bus(&mut self,id:u32,v:u32,m:u32)->Result<(),Error>{self.calls.push(serde_json::json!({"kind":"bus","args":[id,v,m]}));Ok(())}}
 fn fixture(row:&serde_json::Value)->(Bus,Store){let bus=Bus{reference:0x30001000,raw:crate::audio_spatial_controls::tests::hex(row["before"].as_str().unwrap())};let mut store=Store::default();if row["cache_present"]==true{store.caches.insert(0x30002000,Cache{effect_ids:[if row["nonempty"]==true{1}else{0};4],flags:row["cached_flags"].as_u64().unwrap() as u8});}if row["source_present"]==true{store.source_flags.insert(0x30003000,row["source_flags"].as_u64().unwrap() as u8);}(bus,store)}
 #[test] fn audio_bus_parameter_notifications_match10368_native_cases(){let p:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_bus_parameter_notification_contract.json")).unwrap();assert_eq!(p["case_count"],10368);for(case,row)in p["cases"].as_array().unwrap().iter().enumerate(){let (bus,store)=fixture(row);let mut b=Trace{calls:vec![]};let calls=store.notify(&bus,row["parameter"].as_u64().unwrap() as u32,&mut b).unwrap();assert_eq!(serde_json::json!(calls),row["calls"],"order {case}");assert_eq!(serde_json::json!(b.calls),row["calls"],"actual application dispatch {case}");assert_eq!(bus.raw,crate::audio_spatial_controls::tests::hex::<200>(row["after"].as_str().unwrap()),"bus {case}");}}
 #[test] fn audio_bus_notifications_with_actual_rtpc_manager_match5760_native_cases(){let p:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_bus_parameter_notification_rtpc_contract.json")).unwrap();assert_eq!(p["case_count"],5760);for(case,row)in p["cases"].as_array().unwrap().iter().enumerate(){let (bus,store)=fixture(row);let mut manager=audio_rtpc_manager::Manager::default();if row["found"]==true{manager.bindings.insert((bus.reference,row["parameter"].as_u64().unwrap() as u32),serde_json::from_value(row["curves"].clone()).unwrap());}for record in row["records"].as_array().unwrap(){manager.records.insert(record["rtpc"].as_u64().unwrap() as u32,audio_rtpc_manager::Record{default:record["default"].as_f64().unwrap() as f32,overrides:record["overrides"].as_array().unwrap().iter().map(|v|(v["owner"].as_u64().unwrap() as u32,v["value"].as_f64().unwrap() as f32)).collect()});}let mut dependencies=Trace{calls:vec![]};let mut backend=ManagerBackend{manager:&manager,dependencies:&mut dependencies,curves:vec![]};let calls=store.notify(&bus,row["parameter"].as_u64().unwrap() as u32,&mut backend).unwrap();let mut trace=Vec::new();for c in &calls{trace.push(serde_json::json!(c));if matches!(c,Call::Rtpc{..}){trace.extend(backend.curves.iter().map(|c|serde_json::json!({"kind":"curve","index":c.curve,"input_bits":c.input_bits})));}}drop(backend);assert_eq!(serde_json::json!(trace),row["calls"],"whole native order {case}");let expected:Vec<_>=row["calls"].as_array().unwrap().iter().filter(|v|v["kind"]=="root" || v["kind"]=="bus").cloned().collect();assert_eq!(dependencies.calls,expected,"application {case}");assert_eq!(bus.raw,crate::audio_spatial_controls::tests::hex::<200>(row["after"].as_str().unwrap()),"bus {case}");}}
 #[test] fn audio_bus_notification_missing_dependencies_do_not_apply_controls(){let mut bus=Bus{reference:1,raw:[0;200]};bus.set_word(0,0xff1380);bus.set_word(0x18,2);bus.set_word(0x30,1<<24);let mut s=Store::default();let mut b=Trace{calls:vec![]};assert!(matches!(s.notify(&bus,24,&mut b),Err(Error::MissingCache(2))));s.caches.insert(2,Cache{effect_ids:[1;4],flags:0});assert!(matches!(s.notify(&bus,24,&mut b),Err(Error::Backend("RTPC dependency absent"))));assert!(b.calls.is_empty());assert!(s.notify(&bus,23,&mut b).unwrap().is_empty());}
}
