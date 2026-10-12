
//! Original CB65B4 security-cookie producer. The local reference is a source32-bit
//! frame value used only as integer entropy; it is never a truncated/dereferenced
//! host pointer. Initial counter words describe the original caller's stack state.
use std::collections::{BTreeMap,BTreeSet};use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};use crate::audio_path_source_virtual_cleanup::{get,put,live};
pub const COOKIE:u32=0x1222ed0;pub const COMPLEMENT:u32=0x1222ed4;pub const DEFAULT:u32=0xbb40e64e;
#[derive(Clone,Copy,Debug,PartialEq,Eq)]pub struct Counter{pub value:[u32;2],pub result:u32}
pub trait Services{fn file_time(&mut self)->Result<[u32;2],Error>;fn thread_id(&mut self)->Result<u32,Error>;fn process_id(&mut self)->Result<u32,Error>;fn performance_counter(&mut self,initial:[u32;2])->Result<Counter,Error>;}
pub fn initialize(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,local_reference:u32,initial_counter:[u32;2],s:&mut impl Services)->Result<(),Error>{
 // Validate required canonical output storage before entropy calls or mutation.
 live(m,d,COOKIE,4)?;live(m,d,COMPLEMENT,4)?;let old=get(m,d,COOKIE,4)?;
 if old!=DEFAULT&&old&0xffff0000!=0{return put(m,d,COMPLEMENT,4,!old);}
 let time=s.file_time()?;let mut seed=time[0]^time[1];seed^=s.thread_id()?;seed^=s.process_id()?;let counter=s.performance_counter(initial_counter)?;
 // Original code ignores QPC's BOOL and consumes the resulting output words.
 let mut value=counter.value[0]^counter.value[1]^seed^local_reference;
 if value==DEFAULT{value=DEFAULT.wrapping_add(1);}else if value&0xffff0000==0{value|=(value|0x4711).wrapping_shl(16);}
 put(m,d,COOKIE,4,value)?;put(m,d,COMPLEMENT,4,!value)
}
#[cfg(windows)]pub struct WindowsEntropy;
#[cfg(windows)]impl Services for WindowsEntropy{
 fn file_time(&mut self)->Result<[u32;2],Error>{#[repr(C)]struct FileTime{low:u32,high:u32}#[link(name="kernel32")]unsafe extern "system"{fn GetSystemTimeAsFileTime(time:*mut FileTime);}let mut time=FileTime{low:0,high:0};unsafe{GetSystemTimeAsFileTime(&mut time)};Ok([time.low,time.high])}
 fn thread_id(&mut self)->Result<u32,Error>{#[link(name="kernel32")]unsafe extern "system"{fn GetCurrentThreadId()->u32;}Ok(unsafe{GetCurrentThreadId()})}
 fn process_id(&mut self)->Result<u32,Error>{#[link(name="kernel32")]unsafe extern "system"{fn GetCurrentProcessId()->u32;}Ok(unsafe{GetCurrentProcessId()})}
 fn performance_counter(&mut self,initial:[u32;2])->Result<Counter,Error>{#[link(name="kernel32")]unsafe extern "system"{fn QueryPerformanceCounter(counter:*mut i64)->i32;}let mut raw=[0;8];raw[..4].copy_from_slice(&initial[0].to_le_bytes());raw[4..].copy_from_slice(&initial[1].to_le_bytes());let mut counter=i64::from_le_bytes(raw);let result=unsafe{QueryPerformanceCounter(&mut counter)}as u32;let raw=counter.to_le_bytes();Ok(Counter{value:[u32::from_le_bytes(raw[..4].try_into().unwrap()),u32::from_le_bytes(raw[4..].try_into().unwrap())],result})}
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 struct Api<'a>{row:&'a Value,calls:Vec<Value>}
 impl Services for Api<'_>{
  fn file_time(&mut self)->Result<[u32;2],Error>{let value=[self.row["time_value"][0].as_u64().unwrap()as u32,self.row["time_value"][1].as_u64().unwrap()as u32];self.calls.push(json!({"kind":"GetSystemTimeAsFileTime","initial":[0,0],"value":value}));Ok(value)}
  fn thread_id(&mut self)->Result<u32,Error>{let result=self.row["thread_id"].as_u64().unwrap()as u32;self.calls.push(json!({"kind":"GetCurrentThreadId","result":result}));Ok(result)}
  fn process_id(&mut self)->Result<u32,Error>{let result=self.row["process_id"].as_u64().unwrap()as u32;self.calls.push(json!({"kind":"GetCurrentProcessId","result":result}));Ok(result)}
  fn performance_counter(&mut self,initial:[u32;2])->Result<Counter,Error>{let a=&self.row["counter"];let value=if a["writes"]==true{[a["value"][0].as_u64().unwrap()as u32,a["value"][1].as_u64().unwrap()as u32]}else{initial};let result=a["result"].as_u64().unwrap()as u32;self.calls.push(json!({"kind":"QueryPerformanceCounter","initial":initial,"value":value,"result":result}));Ok(Counter{value,result})}
 }
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 #[test]fn audio_security_cookie_matches896_original_complete_entropy_order_raw_qpc_bool_stack_inputs_default_collision_promotion_and_retention_cases(){let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_security_cookie_preparation.json")).unwrap();assert_eq!(p["case_count"],896);for row in p["cases"].as_array().unwrap(){let mut m=BTreeMap::from([(COOKIE,Memory{reference:COOKIE,raw:bytes(row["before"].as_str().unwrap())})]);let d=BTreeSet::new();let mut api=Api{row,calls:Vec::new()};let initial=[row["initial_counter"][0].as_u64().unwrap()as u32,row["initial_counter"][1].as_u64().unwrap()as u32];initialize(&mut m,&d,row["local_reference"].as_u64().unwrap()as u32,initial,&mut api).unwrap();assert_eq!(m[&COOKIE].raw,bytes(row["after"].as_str().unwrap()));assert_eq!(json!(api.calls),row["calls"]);}}
}
