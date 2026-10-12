//! Native B0FB40 device quota, periodic retry and fallback control flow.
//! Device factory, switching and virtual device bodies are mandatory services;
//! their implementations and physical audio output are separate acceptance gates.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
pub trait Devices{
 fn create(&mut self,settings:&mut Memory,kind:u32,flags:u32,current:u32)->Result<u32,Error>;
 fn init(&mut self,reference:u32)->Result<u32,Error>;
 fn switch(&mut self,first:u32,second:u32,reference:u32)->Result<(),Error>;
 fn term(&mut self,reference:u32)->Result<(),Error>;
 fn destroy(&mut self,reference:u32,flags:u32)->Result<(),Error>;
 fn free_pool(&mut self,pool:u32,reference:u32)->Result<(),Error>;
 fn quota(&mut self,reference:u32,output:&mut u32)->Result<u32,Error>;
}
/// Owned equivalents of globals14A7E48,14A7D50,14A7E35,14A79F4/8,1210228.
#[derive(Debug)]pub struct Scheduler{pub retry:u32,pub device:u32,pub changed:u8,pub device_kind:u32,pub settings:Memory,pub pool:u32}
impl Scheduler{
 pub fn quota(&mut self,devices:&mut impl Devices)->Result<u32,Error>{
  let mut output=0;
  if self.retry!=0{
   self.retry=self.retry.wrapping_sub(1);
   // Native signed magic-number division computes the remainder modulo20.
   if (self.retry as i32)%20==0{
    let candidate=devices.create(&mut self.settings,self.device_kind,0,self.device)?;
    if candidate!=0{
     if devices.init(candidate)?==1{devices.switch(0,0,candidate)?;self.device=candidate;self.retry=0;}
     else{devices.term(candidate)?;let pool=self.pool;devices.destroy(candidate,0)?;devices.free_pool(pool,candidate)?;}
    }
   }
  }
  if self.device==0{return Err(Error::UnresolvedReference);}
  let status=devices.quota(self.device,&mut output)?;
  if status!=1||self.changed!=0{
   self.changed=0;let fallback=devices.create(&mut self.settings,3,0,self.device)?;devices.switch(0,0,fallback)?;self.device=fallback;
   if fallback==0{return Err(Error::UnresolvedReference);}
   devices.init(fallback)?;self.retry=200;
  }
  Ok(output)
 }
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};use std::collections::{BTreeMap,BTreeSet};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{profile:String,status:u32,written:Option<u32>,objects:BTreeMap<u32,Memory>,freed:BTreeSet<u32>,calls:Vec<Value>}
 impl Devices for Backend{
  fn create(&mut self,settings:&mut Memory,kind:u32,flags:u32,_current:u32)->Result<u32,Error>{let reference=if kind==3{0x30009a00}else if self.profile=="missing"{0}else{0x30009600};self.calls.push(json!({"kind":"create_device","settings":settings.reference,"device_kind":kind,"flags":flags,"reference":reference}));Ok(reference)}
  fn init(&mut self,reference:u32)->Result<u32,Error>{assert!(self.objects.contains_key(&reference));let status=if reference==0x30009600&&self.profile=="failed"{52}else{1};self.calls.push(json!({"kind":"init_device","reference":reference,"status":status}));Ok(status)}
  fn switch(&mut self,first:u32,second:u32,reference:u32)->Result<(),Error>{self.calls.push(json!({"kind":"switch_device","first":first,"second":second,"reference":reference}));Ok(())}
  fn term(&mut self,reference:u32)->Result<(),Error>{assert!(self.objects.contains_key(&reference));self.calls.push(json!({"kind":"term_device","reference":reference}));Ok(())}
  fn destroy(&mut self,reference:u32,flags:u32)->Result<(),Error>{assert!(self.objects.contains_key(&reference));self.calls.push(json!({"kind":"destroy_device","reference":reference,"flags":flags}));Ok(())}
  fn free_pool(&mut self,pool:u32,reference:u32)->Result<(),Error>{assert!(self.freed.insert(reference));self.calls.push(json!({"kind":"free","method":"pool","allocator":pool,"reference":reference}));Ok(())}
  fn quota(&mut self,reference:u32,output:&mut u32)->Result<u32,Error>{assert!(self.objects.contains_key(&reference));if let Some(value)=self.written{*output=value;}self.calls.push(json!({"kind":"device_quota","reference":reference,"status":self.status,"quota_written":self.written}));Ok(self.status)}
 }
 #[test]fn audio_frame_quota_matches1440_native_retry_candidate_cleanup_and_fallback_cases(){
  let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_frame_quota_preparation.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],1440);
  for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut scheduler=Scheduler{retry:b["retry"].as_u64().unwrap()as u32,device:b["device"].as_u64().unwrap()as u32,changed:b["changed"].as_u64().unwrap()as u8,device_kind:row["device_kind"].as_u64().unwrap()as u32,settings:Memory{reference:0x14a79f8,raw:bytes(b["config"].as_str().unwrap())},pool:row["pool"].as_u64().unwrap()as u32};let mut backend=Backend{profile:row["profile"].as_str().unwrap().into(),status:row["quota_status"].as_u64().unwrap()as u32,written:row["quota_written"].as_u64().map(|v|v as u32),objects:b["allocations"].as_array().unwrap().iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(a["raw"].as_str().unwrap())})}).collect(),freed:BTreeSet::new(),calls:vec![]};assert_eq!(scheduler.quota(&mut backend).unwrap()as u64,row["result"].as_u64().unwrap(),"quota {i}");assert_eq!(json!(backend.calls),row["calls"],"device call order {i}");let allocations:Vec<Value>=b["allocations"].as_array().unwrap().iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;let m=&backend.objects[&reference];json!({"reference":reference,"size":m.raw.len(),"freed":backend.freed.contains(&reference),"raw":hex(&m.raw)})}).collect();let actual=json!({"retry":scheduler.retry,"device":scheduler.device,"changed":scheduler.changed,"config":hex(&scheduler.settings.raw),"allocations":allocations});assert_eq!(actual,row["after"],"all globals and controlled device memory {i}");
  }
 }
}
