//! Original C9C3DC worker packet adoption/transfer, before C9C439 COM stage.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put};
#[derive(Debug,PartialEq,Eq)]pub enum Entry{Ready{record:u32},Exit{code:u32}}
pub trait Services:crate::audio_crt_thread_destructor::Services+crate::audio_crt_tls_value_wrappers::Services{}
impl<S:crate::audio_crt_thread_destructor::Services+crate::audio_crt_tls_value_wrappers::Services> Services for S{}
/// Publication failure leaves the incoming packet unfreed, as in the source.
/// Exit is a prepared terminal outcome; the caller owns actual OS termination.
pub fn prepare_entry(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,incoming:u32,s:&mut impl Services)->Result<Entry,Error>{
 let index=get(m,d,0x12230cc,4)?;
 let mut record=crate::audio_crt_tls_value_wrappers::get_value(m,d,index,s)?;
 if record==0{
  record=incoming;let index=get(m,d,0x12230cc,4)?;
  if crate::audio_crt_tls_value_wrappers::set_value(m,d,index,record,s)?==0{return Ok(Entry::Exit{code:s.get_last_error(m,d)?});}
  let id=s.current_thread_id(m,d)?;put(m,d,record,4,id)?;
 }else{
  for off in [0x54,0x58,4]{let value=get(m,d,incoming+off,4)?;put(m,d,record+off,4,value)?;}
  crate::audio_crt_thread_destructor::destroy(m,d,incoming,s)?;
 }
 Ok(Entry::Ready{record})
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};use crate::audio_crt_tls_value_wrappers;
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 struct Api{row:Value,regions:Vec<(String,u32,usize)>,calls:Vec<Value>,tls:u32,last:u32,freed:Vec<u32>,allocations:Vec<Value>}
 impl Api{fn snapshot(&self,m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,a,z)in &self.regions{out[n]=json!(crate::audio_path_memory::read(m,*a,*z).unwrap().iter().map(|v|format!("{v:02x}")).collect::<String>());}out}fn emit(&mut self,name:&str,args:Value,result:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":name,"arguments":args,"result":result,"at_call":self.snapshot(m)}));}}
 impl audio_crt_tls_value_wrappers::Services for Api{
  fn get_value(&mut self,f:u32,index:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{assert_eq!(f,if self.row["layout"]=="all"{0x40004020}else{0});self.emit(if f==0{"TlsGetValue"}else{"FlsGetValue"},json!([index]),self.tls,m);self.last=0;Ok(self.tls)}
  fn set_value(&mut self,f:u32,index:u32,v:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{assert_eq!(f,if self.row["layout"]=="all"{0x40004030}else{0});let ok=u32::from(self.row["state"]!="publication_failure");self.emit(if f==0{"TlsSetValue"}else{"FlsSetValue"},json!([index,v]),ok,m);if ok!=0{self.tls=v;}Ok(ok)}
 }
 impl crate::audio_global_float_default_power::Windows for Api{
  fn get_last_error(&mut self,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.emit("GetLastError",json!([]),self.last,m);Ok(self.last)}
  fn set_last_error(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.emit("SetLastError",json!([v]),0,m);self.last=v;Ok(())}
  fn tls_get_value(&mut self,i:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{audio_crt_tls_value_wrappers::get_value(m,d,i,self)}
  fn tls_set_value(&mut self,i:u32,v:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<bool,Error>{Ok(audio_crt_tls_value_wrappers::set_value(m,d,i,v,self)?!=0)}
  fn calloc_thread(&mut self,n:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{assert_eq!((n,z),(1,956));let value=if self.row["state"]=="null_failure"{0}else{0x40012000};self.emit("calloc",json!([n,z]),value,m);if value!=0{m.get_mut(&value).unwrap().raw[..956].fill(0);self.allocations.push(json!({"reference":value,"size":z}));}Ok(Some(value))}
  fn free_thread(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.emit("free",json!([v]),0,m);self.freed.push(v);Ok(())}
  fn current_thread_id(&mut self,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.emit("GetCurrentThreadId",json!([]),123,m);Ok(123)}
  fn thread_lock(&mut self,v:u32,enter:bool,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.emit(if enter{"EnterCriticalSection"}else{"LeaveCriticalSection"},json!([v]),0,m);Ok(())}
 }
 impl crate::audio_crt_thread_destructor::Services for Api{}

 #[test]fn audio_crt_worker_entry_matches162_original_tls_fls_packet_adoption_three_field_transfer_destructor_publication_failure_and_terminal_banks(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_worker_entry_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],162);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().into(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m=regions.iter().map(|(n,a,_)|(*a,Memory{reference:*a,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut d=BTreeSet::new();let mut api=Api{row:row.clone(),regions,calls:vec![],tls:if row["state"]=="existing"{0x40012000}else{0},last:97,freed:vec![],allocations:vec![]};let result=prepare_entry(&mut m,&mut d,0x40014000,&mut api).unwrap();let expected=if row["terminal"]=="exit"{let code=row["calls"].as_array().unwrap().last().unwrap()["arguments"][0].as_u64().unwrap()as u32;api.emit("ExitThread",json!([code]),0,&m);Entry::Exit{code}}else{Entry::Ready{record:row["tls_value"].as_u64().unwrap()as u32}};assert_eq!(result,expected,"native outcome {i}");assert_eq!(json!(api.calls),row["calls"],"native service banks {i}");assert_eq!(api.snapshot(&m),row["after"],"final banks {i}");assert_eq!(json!(api.freed),row["freed"]);assert_eq!(json!(api.allocations),row["allocations"]);assert_eq!(api.tls as u64,row["tls_value"].as_u64().unwrap());assert_eq!(api.last as u64,row["last_error"].as_u64().unwrap());assert_eq!(d,if row["state"]=="existing"{BTreeSet::from([0x40014000])}else{BTreeSet::new()});}
 }
}
