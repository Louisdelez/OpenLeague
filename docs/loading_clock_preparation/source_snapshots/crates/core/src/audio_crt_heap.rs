
//! Original CA8673/CBE04E calloc, C98528 free and C9DC58 new-handler dispatch.
//! Heap/context/OS services remain explicit; no allocator ownership is synthesized.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put};
pub trait Services{
 fn heap_allocate(&mut self,heap:u32,flags:u32,size:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<u32,Error>;
 fn heap_free(&mut self,heap:u32,flags:u32,reference:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<u32,Error>;
 fn thread_context(&mut self,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<u32,Error>;
 fn last_error(&mut self,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<u32,Error>;
 fn sleep(&mut self,milliseconds:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<(),Error>;
 fn decode_pointer(&mut self,encoded:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<u32,Error>;
 fn invoke_handler(&mut self,function:u32,size:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<u32,Error>;
}
fn errno_address(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,s:&mut impl Services)->Result<u32,Error>{let r=s.thread_context(m,d)?;Ok(if r==0{0x1222998}else{r.wrapping_add(8)})}
pub fn windows_errno(m:&BTreeMap<u32,Memory>,d:&BTreeSet<u32>,error:u32)->Result<u32,Error>{for j in 0..45{if get(m,d,0x1222830+j*8,4)?==error{return get(m,d,0x1222834+j*8,4);}}Ok(if error.wrapping_sub(19)<=17{13}else if error.wrapping_sub(188)<=14{8}else{22})}
fn new_handler(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,size:u32,s:&mut impl Services)->Result<bool,Error>{let encoded=get(m,d,0x14ae620,4)?;let function=s.decode_pointer(encoded,m,d)?;Ok(function!=0&&s.invoke_handler(function,size,m,d)?!=0)}
pub fn calloc_base(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,count:u32,size:u32,error_argument:u32,s:&mut impl Services)->Result<u32,Error>{
 if count!=0&&size>0xffffffe0/count{let errno=errno_address(m,d,s)?;put(m,d,errno,4,12)?;return Ok(0);}
 let size=count.wrapping_mul(size).max(1);
 loop{
  let result=if size<=0xffffffe0{let heap=get(m,d,0x14ae87c,4)?;s.heap_allocate(heap,8,size,m,d)?}else{0};
  if result!=0{return Ok(result);}
  if get(m,d,0x14af110,4)?!=0&&new_handler(m,d,size,s)?{continue;}
  if error_argument!=0{put(m,d,error_argument,4,12)?;}return Ok(0);
 }
}
pub fn calloc(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,count:u32,size:u32,s:&mut impl Services)->Result<u32,Error>{
 let mut delay=0u32;
 loop{let result=calloc_base(m,d,count,size,0,s)?;if result!=0||get(m,d,0x14ae868,4)?==0{return Ok(result);}
  s.sleep(delay,m,d)?;delay=delay.wrapping_add(1000);if delay>get(m,d,0x14ae868,4)?{delay=u32::MAX;}if delay==u32::MAX{return Ok(result);}
 }
}
pub fn free(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,reference:u32,s:&mut impl Services)->Result<(),Error>{
 if reference==0{return Ok(());}let heap=get(m,d,0x14ae87c,4)?;if s.heap_free(heap,0,reference,m,d)?==0{let errno=errno_address(m,d,s)?;let error=s.last_error(m,d)?;let value=windows_errno(m,d,error)?;put(m,d,errno,4,value)?;}Ok(())
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 struct Api{config:Value,regions:Vec<(String,u32,usize)>,calls:Vec<Value>,allocations:usize,handlers:usize}
 impl Api{fn snapshot(&self,m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,a,z)in &self.regions{out[n]=json!(crate::audio_path_memory::read(m,*a,*z).unwrap().iter().map(|v|format!("{v:02x}")).collect::<String>());}out}fn emit(&mut self,kind:&str,args:Value,result:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":kind,"arguments":args,"result":result,"at_call":self.snapshot(m)}));}}
 impl Services for Api{
  fn heap_allocate(&mut self,h:u32,f:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let seq=self.config["allocation_results"].as_array().unwrap();let result=if seq[self.allocations.min(seq.len()-1)].as_u64().unwrap()!=0{0x40015000}else{0};self.allocations+=1;assert!(self.allocations<30);self.emit("HeapAlloc",json!([h,f,z]),result,m);Ok(result)}
  fn heap_free(&mut self,h:u32,f:u32,r:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let result=self.config["free_result"].as_u64().unwrap()as u32;self.emit("HeapFree",json!([h,f,r]),result,m);Ok(result)}
  fn thread_context(&mut self,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let result=self.config["context"].as_u64().unwrap()as u32;self.emit("GetContext",json!([]),result,m);Ok(result)}
  fn last_error(&mut self,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let result=self.config["windows_error"].as_u64().unwrap()as u32;self.emit("GetLastError",json!([]),result,m);Ok(result)}
  fn sleep(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.emit("Sleep",json!([v]),0,m);Ok(())}
  fn decode_pointer(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let result=self.config["decoded_handler"].as_u64().unwrap()as u32;self.emit("DecodePointer",json!([v]),result,m);Ok(result)}
  fn invoke_handler(&mut self,f:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let seq=self.config["handler_results"].as_array().unwrap();let result=seq[self.handlers.min(seq.len()-1)].as_u64().unwrap()as u32;self.handlers+=1;self.emit("Handler",json!([f,z]),result,m);Ok(result)}
 }
 fn qualify(free_cases:bool){let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_heap_preparation.json")).unwrap();assert_eq!(p["case_count"],975);let mut tested=0;
  for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let entry=row["entry"].as_u64().unwrap()as u32;if(entry==0xc98528)!=free_cases{continue;}let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().into(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut memory=regions.iter().map(|(n,a,_)|(*a,Memory{reference:*a,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut dead=BTreeSet::new();let mut api=Api{config:row["config"].clone(),regions,calls:vec![],allocations:0,handlers:0};let args=row["arguments"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect::<Vec<_>>();
   if entry==0xc98528{free(&mut memory,&mut dead,args[0],&mut api).unwrap();}else{let result=if entry==0xca8673{calloc(&mut memory,&mut dead,args[0],args[1],&mut api).unwrap()}else{calloc_base(&mut memory,&mut dead,args[0],args[1],args[2],&mut api).unwrap()};assert_eq!(result as u64,row["result"].as_u64().unwrap(),"native allocation result {i}");}
   assert_eq!(json!(api.calls),row["calls"],"all original heap/context/error/handler/sleep calls and entry bytes {i}");assert_eq!(api.snapshot(&memory),row["after"],"native complete errno/argument/global/table banks {i}");assert!(dead.is_empty(),"OS ownership remains provider boundary");tested+=1;
  }assert_eq!(tested,if free_cases{624}else{351});
 }
 #[test]fn audio_crt_heap_calloc_matches351_original_overflow_minimum_size_new_handler_decoding_retry_sleep_and_errno_argument_cases(){qualify(false);}
 #[test]fn audio_crt_heap_free_matches624_original_null_raw_bool_52_windows_error_table_range_and_thread_fallback_errno_cases(){qualify(true);}
}

/// Whole original CABB83 process-heap bootstrap.
pub trait Bootstrap{fn process_heap(&mut self)->Result<u32,Error>;}
pub fn initialize(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,s:&mut impl Bootstrap)->Result<u32,Error>{let handle=s.process_heap()?;put(m,d,0x14ae87c,4,handle)?;Ok(u32::from(handle!=0))}
#[cfg(test)]mod bootstrap_tests{
 use super::*;
 struct Api(u32);impl Bootstrap for Api{fn process_heap(&mut self)->Result<u32,Error>{Ok(self.0)}}
 #[test]fn audio_crt_process_heap_initialize_matches12_original_published_null_nonnull_handles_and_boolean_results(){let p:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_process_heap_preparation.json")).unwrap();assert_eq!(p["case_count"],12);for row in p["cases"].as_array().unwrap(){let mut m=BTreeMap::from([(0x14ae87c,Memory{reference:0x14ae87c,raw:(row["before"].as_u64().unwrap()as u32).to_le_bytes().to_vec()})]);let d=BTreeSet::new();let result=initialize(&mut m,&d,&mut Api(row["handle"].as_u64().unwrap()as u32)).unwrap();assert_eq!(result as u64,row["result"].as_u64().unwrap());assert_eq!(get(&m,&d,0x14ae87c,4).unwrap()as u64,row["after"].as_u64().unwrap());}}
}
