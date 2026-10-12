//! Native AE9F60/AEAF90 callback vector, including AFF610 pool growth.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_rtpc_output_setter::Services};
fn word(r:&[u8],o:usize)->u32{u32::from_le_bytes(r[o..o+4].try_into().unwrap())}
fn set(r:&mut[u8],o:usize,v:u32){r[o..o+4].copy_from_slice(&v.to_le_bytes());}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Reason{Frame,Shutdown}
impl Reason{pub fn word(self)->u32{match self{Self::Frame=>0,Self::Shutdown=>1}}}
#[derive(Debug)]
pub struct Registry{pub raw:[u8;12],pub callbacks:Memory}
impl Default for Registry{fn default()->Self{Self{raw:[0;12],callbacks:Memory{reference:0,raw:vec![]}}}}
impl Registry{
 /// B06987 / AEB7C4. Capture the initial count, then reload current storage for
 /// each descending slot. Mutations can repeat callbacks or relocate the table.
 /// Removal preserves backing bytes; do not clamp the index to the new count.
 pub fn dispatch(&mut self,reason:Reason,mut callback:impl FnMut(&mut Self,u32,Reason)->Result<(),Error>)->Result<(),Error>{
  let(count,_)=self.validate()?;let mut remaining=count;
  while remaining!=0{remaining-=1;let(_,capacity)=self.validate()?;if remaining>=capacity{return Err(Error::InvalidAllocation);}let key=word(&self.callbacks.raw,remaining*4);callback(self,key,reason)?;}
  Ok(())
 }

 fn validate(&self)->Result<(usize,usize),Error>{let count=word(&self.raw,4)as usize;let cap=word(&self.raw,8)as usize;if word(&self.raw,0)!=self.callbacks.reference||count>cap||self.callbacks.raw.len()<cap.checked_mul(4).ok_or(Error::InvalidAllocation)?||(cap!=0&&self.callbacks.reference==0){return Err(Error::InvalidAllocation);}Ok((count,cap))}
 pub fn register(&mut self,key:u32,pool:u32,services:&mut impl Services)->Result<u32,Error>{
  let(count,cap)=self.validate()?;
  if count==cap{let capacity=cap.checked_add(1).ok_or(Error::InvalidAllocation)?;let size=u32::try_from(capacity.checked_mul(4).ok_or(Error::InvalidAllocation)?).map_err(|_|Error::InvalidAllocation)?;
   let Some(mut next)=services.allocate_pool(pool,size)?else{return Ok(52);};if next.reference==0||next.raw.len()!=size as usize{return Err(Error::InvalidAllocation);}
   next.raw[..count*4].copy_from_slice(&self.callbacks.raw[..count*4]);if self.callbacks.reference!=0{services.free_pool(pool,&self.callbacks)?;}
   set(&mut self.raw,0,next.reference);set(&mut self.raw,8,capacity as u32);self.callbacks=next;
  }
  set(&mut self.callbacks.raw,count*4,key);set(&mut self.raw,4,(count+1)as u32);Ok(1)
 }
 pub fn unregister(&mut self,key:u32)->Result<u32,Error>{let(count,_)=self.validate()?;let Some(index)=(0..count).find(|i|word(&self.callbacks.raw,i*4)==key)else{return Ok(2);};self.callbacks.raw.copy_within((index+1)*4..count*4,index*4);set(&mut self.raw,4,(count-1)as u32);Ok(1)}
}
/// Connects Meter lifecycle operations to the owned native callback vector.
/// Native Meter callers ignore registration/removal status codes; structural and
/// transport errors remain explicit. Physical allocation and RTPC delivery delegate.
pub struct MeterBackend<'a,S>{pub registry:&'a mut Registry,pub pool:u32,pub backend:&'a mut S}
impl<S:Services> crate::audio_plugin_factory::Allocator for MeterBackend<'_,S>{
 fn allocate(&mut self,pool:u32,size:u32)->Result<Option<Memory>,Error>{self.backend.allocate(pool,size)}
}
impl<S:Services> crate::audio_meter_lifecycle::Lifetime for MeterBackend<'_,S>{
 fn free(&mut self,pool:u32,memory:&Memory)->Result<(),Error>{self.backend.free(pool,memory)}
 fn register_callback(&mut self,key:u32)->Result<(),Error>{self.registry.register(key,self.pool,self.backend)?;Ok(())}
}
impl<S:Services> crate::audio_effect_resource_bank::Services for MeterBackend<'_,S>{
 fn free_pool(&mut self,pool:u32,memory:&Memory)->Result<(),Error>{self.backend.free_pool(pool,memory)}
}
impl<S:Services> Services for MeterBackend<'_,S>{
 fn allocate_pool(&mut self,pool:u32,size:u32)->Result<Option<Memory>,Error>{self.backend.allocate_pool(pool,size)}
 fn observe_meter_parameter(&mut self,reference:u32,id:u32,bits:u32){self.backend.observe_meter_parameter(reference,id,bits)}
}
impl<S:Services+crate::audio_meter_lifecycle::Update> crate::audio_meter_lifecycle::Update for MeterBackend<'_,S>{
 fn set_rtpc(&mut self,manager:u32,id:u32,bits:u32,owner:u32,transition:[u32;2],mode:u32)->Result<(),Error>{self.backend.set_rtpc(manager,id,bits,owner,transition,mode)}
 fn set_rtpc_owned(&mut self,runtime:&mut crate::audio_meter_lifecycle::Runtime,manager:u32,id:u32,bits:u32,owner:u32,transition:[u32;2],mode:u32)->Result<(),Error>{self.backend.set_rtpc_owned(runtime,manager,id,bits,owner,transition,mode)}
 fn unregister_callback(&mut self,key:u32)->Result<(),Error>{self.registry.unregister(key)?;Ok(())}
 fn free_manager(&mut self,pool:u32,memory:&Memory)->Result<(),Error>{self.backend.free_manager(pool,memory)}
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};use std::collections::BTreeMap;
 use crate::{audio_plugin_factory::Allocator,audio_meter_lifecycle::Lifetime,audio_effect_resource_bank::Services as PoolServices};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Physical{pattern:u8,failure:u32,nth:u32,next:u32,calls:Vec<Value>,freed:BTreeMap<u32,Memory>,allocated:Vec<u32>}
 impl Allocator for Physical{fn allocate(&mut self,_:u32,_:u32)->Result<Option<Memory>,Error>{Err(Error::Backend("explicit pool allocator required"))}}
 impl Lifetime for Physical{fn free(&mut self,_:u32,_:&Memory)->Result<(),Error>{Err(Error::Backend("no virtual registry free"))}fn register_callback(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("registry body required"))}}
 impl PoolServices for Physical{fn free_pool(&mut self,pool:u32,m:&Memory)->Result<(),Error>{self.calls.push(json!({"kind":"free","method":"pool","allocator":pool,"reference":m.reference}));assert!(self.freed.insert(m.reference,m.clone()).is_none());Ok(())}}
 impl Services for Physical{fn allocate_pool(&mut self,pool:u32,size:u32)->Result<Option<Memory>,Error>{self.nth+=1;let reference=if self.nth==self.failure{0}else{self.next};self.calls.push(json!({"kind":"allocate","method":"pool","allocator":pool,"size":size,"reference":reference}));if reference==0{return Ok(None);}self.next+=512;self.allocated.push(reference);Ok(Some(Memory{reference,raw:vec![self.pattern;size as usize]}))}}
 #[test]fn audio_callback_dispatch_matches400_native_reverse_mutation_and_failure_sequences(){
  let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_callback_dispatch_preparation.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],400);
  for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let initial=b["allocations"].as_array().unwrap();let mut registry=Registry{raw:bytes(b["header"].as_str().unwrap()).try_into().unwrap(),callbacks:initial.first().map(|a|Memory{reference:a["reference"].as_u64().unwrap()as u32,raw:bytes(a["raw"].as_str().unwrap())}).unwrap_or(Memory{reference:0,raw:vec![]})};let mut physical=Physical{pattern:row["pattern"].as_u64().unwrap()as u8,failure:row["failure_nth"].as_u64().unwrap()as u32,nth:0,next:0x3000a000,calls:vec![],freed:BTreeMap::new(),allocated:vec![]};let reason=if row["reason"]==0{Reason::Frame}else{Reason::Shutdown};let action=row["action"].as_str().unwrap();
   registry.dispatch(reason,|registry,key,reason|{physical.calls.push(json!({"kind":"callback","reference":key,"reason":reason.word()}));if action!="none"{let status=match action{"self"=>registry.unregister(key)?,"first"=>registry.unregister(row["first"].as_u64().unwrap()as u32)?,_=>registry.register(row["append"].as_u64().unwrap()as u32,u32::MAX,&mut physical)?};physical.calls.push(json!({"kind":"mutation_result","status":status}));}Ok(())}).unwrap();
   assert_eq!(hex(&registry.raw),row["after"]["header"].as_str().unwrap(),"header {i}");assert_eq!(json!(physical.calls),row["calls"],"dispatch and physical calls {i}");let refs:Vec<u32>=initial.iter().map(|a|a["reference"].as_u64().unwrap()as u32).chain(physical.allocated.iter().copied()).collect();let actual:Vec<Value>=refs.iter().map(|r|{let m=physical.freed.get(r).unwrap_or_else(||{assert_eq!(*r,registry.callbacks.reference);&registry.callbacks});json!({"reference":r,"size":m.raw.len(),"freed":physical.freed.contains_key(r),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(actual),row["after"]["allocations"],"all dispatch-owned bytes {i}");
  }
 }
 #[test]fn audio_callback_registry_matches720_native_append_growth_failure_first_removal_cases(){
  let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_callback_registry_preparation.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],720);
  for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){let before=&row["before"];let initial=before["allocations"].as_array().unwrap();let mut registry=Registry{raw:bytes(before["header"].as_str().unwrap()).try_into().unwrap(),callbacks:initial.first().map(|a|Memory{reference:a["reference"].as_u64().unwrap()as u32,raw:bytes(a["raw"].as_str().unwrap())}).unwrap_or(Memory{reference:0,raw:vec![]})};
   let mut physical=Physical{pattern:row["pattern"].as_u64().unwrap()as u8,failure:row["failure_nth"].as_u64().unwrap()as u32,nth:0,next:0x3000a000,calls:vec![],freed:BTreeMap::new(),allocated:vec![]};let key=row["key"].as_u64().unwrap()as u32;let result=if row["operation"]=="register"{registry.register(key,u32::MAX,&mut physical)}else{registry.unregister(key)}.unwrap();assert_eq!(result,row["result"].as_u64().unwrap()as u32,"status {i}");assert_eq!(hex(&registry.raw),row["after"]["header"].as_str().unwrap(),"header {i}");assert_eq!(json!(physical.calls),row["calls"],"physical calls {i}");
   let refs:Vec<u32>=initial.iter().map(|a|a["reference"].as_u64().unwrap()as u32).chain(physical.allocated.iter().copied()).collect();let actual:Vec<Value>=refs.iter().map(|r|{let m=physical.freed.get(r).unwrap_or_else(||{assert_eq!(*r,registry.callbacks.reference);&registry.callbacks});json!({"reference":r,"size":m.raw.len(),"freed":physical.freed.contains_key(r),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(actual),row["after"]["allocations"],"all owned bytes {i}");
  }
 }
}
