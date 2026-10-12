//! Concrete fallback bodies integrated into owned factory/quota/output switching.
//! Modern/legacy device bodies, clock/allocator/recording transport stay mandatory.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_device_factory::{self as factory,Virtual},audio_fallback_device::{self as fallback,Services as Physical},audio_frame_quota::Scheduler};
fn is_fallback(memory:&Memory)->Result<bool,Error>{if memory.raw.len()<4{return Err(Error::Truncated);}Ok(u32::from_le_bytes(memory.raw[..4].try_into().unwrap())==0xff25b0)}
struct Adapter<'a,S>{fallback:&'a mut fallback::Runtime,rate:u32,device_pool:u32,recorder_pool:u32,backend:&'a mut S}
impl<S:Virtual+Physical> factory::Services for Adapter<'_,S>{
 fn allocate_pool(&mut self,pool:u32,size:u32)->Result<Option<Memory>,Error>{factory::Services::allocate_pool(self.backend,pool,size)}
 fn free_pool(&mut self,pool:u32,memory:&Memory)->Result<(),Error>{factory::Services::free_pool(self.backend,pool,memory)}
 fn configure_modern(&mut self,m:&mut Memory,c:u32,mask:u32,kind:u32)->Result<u32,Error>{self.backend.configure_modern(m,c,mask,kind)}
 fn configure_legacy(&mut self,m:&mut Memory,c:u32,mask:u32)->Result<u32,Error>{self.backend.configure_legacy(m,c,mask)}
 fn configure_fallback(&mut self,m:&mut Memory,mask:u32)->Result<u32,Error>{self.fallback.configure(m,mask,self.rate,self.device_pool,self.backend)}
 fn term(&mut self,m:&mut Memory)->Result<(),Error>{if is_fallback(m)?{self.fallback.term(m,self.device_pool,self.recorder_pool,self.backend)}else{factory::Services::term(self.backend,m)}}
}
impl<S:Virtual+Physical> Virtual for Adapter<'_,S>{
 fn init_device(&mut self,m:&mut Memory)->Result<u32,Error>{if is_fallback(m)?{fallback::init(m)}else{self.backend.init_device(m)}}
 fn device_quota(&mut self,m:&mut Memory,output:&mut u32)->Result<u32,Error>{if is_fallback(m)?{fallback::quota(m,output,self.backend)}else{self.backend.device_quota(m,output)}}
}
/// Real owned fallback configure/Init/quota/Term are used by the shared factory.
/// Output switching retires its buffer before the44-byte descriptor is freed.
pub fn quota(factory:&mut factory::Runtime,fallback:&mut fallback::Runtime,scheduler:&mut Scheduler,outputs:&mut factory::Outputs,rate:u32,recorder_pool:u32,backend:&mut(impl Virtual+Physical))->Result<u32,Error>{
 let mut adapter=Adapter{fallback,rate,device_pool:scheduler.pool,recorder_pool,backend};factory.quota_with_outputs(scheduler,outputs,&mut adapter)
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};use std::collections::BTreeMap;
 fn word(r:&[u8],o:usize)->u32{u32::from_le_bytes(r[o..o+4].try_into().unwrap())}
 fn set(r:&mut[u8],o:usize,v:u32){r[o..o+4].copy_from_slice(&v.to_le_bytes());}
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{clock:u32,pattern:u8,profile:String,status:u32,written:u32,next_pool:u32,next_aligned:u32,calls:Vec<Value>,freed:BTreeMap<u32,Memory>,allocated:Vec<u32>}
 impl Backend{
  fn configure(&mut self,m:&mut Memory,entry:&str,args:Vec<u32>,mask:u32)->Result<u32,Error>{let status=if self.profile=="both_fail"{52}else{1};set(&mut m.raw,8,mask);self.calls.push(json!({"kind":"configure_device","entry":entry,"reference":m.reference,"args":args,"status":status}));Ok(status)}
  fn free(&mut self,pool:u32,m:&Memory)->Result<(),Error>{self.calls.push(json!({"kind":"free","method":"pool","allocator":pool,"reference":m.reference}));assert!(self.freed.insert(m.reference,m.clone()).is_none());Ok(())}
 }
 impl factory::Services for Backend{
  fn allocate_pool(&mut self,pool:u32,size:u32)->Result<Option<Memory>,Error>{let reference=self.next_pool;self.next_pool+=512;self.allocated.push(reference);self.calls.push(json!({"kind":"allocate","method":"pool","allocator":pool,"size":size,"reference":reference}));Ok(Some(Memory{reference,raw:vec![self.pattern;size as usize]}))}
  fn free_pool(&mut self,pool:u32,m:&Memory)->Result<(),Error>{self.free(pool,m)}
  fn configure_modern(&mut self,m:&mut Memory,c:u32,mask:u32,kind:u32)->Result<u32,Error>{self.configure(m,"modern",vec![c,mask,kind],mask)}
  fn configure_legacy(&mut self,m:&mut Memory,c:u32,mask:u32)->Result<u32,Error>{self.configure(m,"legacy",vec![c,mask],mask)}
  fn configure_fallback(&mut self,_:&mut Memory,_:u32)->Result<u32,Error>{Err(Error::Backend("fallback configure must execute owned body"))}
  fn term(&mut self,m:&mut Memory)->Result<(),Error>{if is_fallback(m)?{return Err(Error::Backend("fallback Term must execute owned body"));}self.calls.push(json!({"kind":"term_device","reference":m.reference}));Ok(())}
 }
 impl Virtual for Backend{
  fn init_device(&mut self,m:&mut Memory)->Result<u32,Error>{if is_fallback(m)?{return Err(Error::Backend("fallback Init must execute owned body"));}self.calls.push(json!({"kind":"init_device","reference":m.reference,"status":1}));Ok(1)}
  fn device_quota(&mut self,m:&mut Memory,output:&mut u32)->Result<u32,Error>{if is_fallback(m)?{return Err(Error::Backend("fallback quota must execute owned body"));}*output=self.written;self.calls.push(json!({"kind":"device_quota","reference":m.reference,"status":self.status,"quota_written":self.written}));Ok(self.status)}
 }
 impl Physical for Backend{
  fn tick(&mut self)->Result<u32,Error>{self.calls.push(json!({"kind":"tick","value":self.clock}));Ok(self.clock)}
  fn allocate_aligned(&mut self,pool:u32,size:u32,alignment:u32)->Result<Option<Memory>,Error>{let reference=self.next_aligned;self.next_aligned+=0x40000;self.allocated.push(reference);self.calls.push(json!({"kind":"allocate","method":"aligned","allocator":pool,"size":size,"alignment":alignment,"reference":reference}));Ok(Some(Memory{reference,raw:vec![self.pattern;size as usize]}))}
  fn free_pool(&mut self,pool:u32,m:&Memory)->Result<(),Error>{self.free(pool,m)}
  fn write_recording(&mut self,_:u32,_:&mut Memory)->Result<u32,Error>{Err(Error::Backend("recording transport not bound in this fixture"))}
  fn close_recording(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("recording transport not bound in this fixture"))}
  fn observe_zero_buffer(&mut self,m:&Memory){assert!(m.raw.iter().all(|v|*v==0));self.calls.push(json!({"kind":"zero_buffer","reference":m.reference,"size":m.raw.len()}));}
 }
 #[test]fn audio_factory_actual_fallback_matches48_native_full_quota_switch_buffer_lifetime_compositions(){
  let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_factory_actual_fallback_preparation.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],48);
  for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let initial=b["allocations"].as_array().unwrap();let mut factory=factory::Runtime{legacy_handle:b["legacy_handle"].as_u64().unwrap()as u32,..factory::Runtime::default()};let mut fallback=fallback::Runtime::default();for a in initial{let reference=a["reference"].as_u64().unwrap()as u32;let memory=Memory{reference,raw:bytes(a["raw"].as_str().unwrap())};if reference>=0x33000000{fallback.buffers.insert(reference,memory);}else{factory.objects.insert(reference,memory);}}
   let mut scheduler=Scheduler{retry:b["retry"].as_u64().unwrap()as u32,device:b["device"].as_u64().unwrap()as u32,changed:b["changed"].as_u64().unwrap()as u8,device_kind:row["kind"].as_u64().unwrap()as u32,settings:Memory{reference:0x14a79f8,raw:bytes(b["settings"].as_str().unwrap())},pool:row["pool"].as_u64().unwrap()as u32};let mut outputs=factory::Outputs{memory:Memory{reference:b["table_reference"].as_u64().unwrap()as u32,raw:bytes(b["table"].as_str().unwrap())},count:b["table_count"].as_u64().unwrap()as u32};let mut backend=Backend{clock:row["clock"].as_u64().unwrap()as u32,pattern:row["pattern"].as_u64().unwrap()as u8,profile:row["profile"].as_str().unwrap().into(),status:row["quota_status"].as_u64().unwrap()as u32,written:row["quota_written"].as_u64().unwrap()as u32,next_pool:row["next_pool"].as_u64().unwrap()as u32,next_aligned:row["next_aligned"].as_u64().unwrap()as u32,calls:vec![],freed:BTreeMap::new(),allocated:vec![]};assert_eq!(quota(&mut factory,&mut fallback,&mut scheduler,&mut outputs,row["rate"].as_u64().unwrap()as u32,u32::MAX,&mut backend).unwrap()as u64,row["result"].as_u64().unwrap(),"quota {i}");assert_eq!(json!(backend.calls),row["calls"],"all physical/hardware call order {i}");let refs:Vec<u32>=initial.iter().map(|a|a["reference"].as_u64().unwrap()as u32).chain(backend.allocated.iter().copied()).collect();let allocations:Vec<Value>=refs.iter().map(|r|{let m=backend.freed.get(r).or_else(||factory.objects.get(r)).or_else(||fallback.buffers.get(r)).unwrap();json!({"reference":r,"size":m.raw.len(),"freed":backend.freed.contains_key(r),"raw":hex(&m.raw)})}).collect();assert_eq!(factory.objects.len()+fallback.buffers.len()+backend.freed.len(),refs.len());assert!(fallback.recorders.is_empty());assert_eq!(json!({"table":hex(&outputs.memory.raw),"table_reference":outputs.memory.reference,"table_count":outputs.count,"retry":scheduler.retry,"device":scheduler.device,"changed":scheduler.changed,"settings":hex(&scheduler.settings.raw),"legacy_handle":factory.legacy_handle,"allocations":allocations}),row["after"],"all shared descriptor/buffer/settings bytes {i}");assert_eq!(word(&outputs.memory.raw,4),scheduler.device);
  }
 }
}
