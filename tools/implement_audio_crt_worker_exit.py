from pathlib import Path
r=Path('E:/OpenLeague')
s='''//! Original C9C356 worker exit preparation and C9C459 optional WinRT release.
//! ExitThread remains an explicit terminal OS boundary owned by the worker caller.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put};
pub trait Services:crate::audio_crt_thread_destructor::Services+crate::audio_crt_tls_value_wrappers::Services{
 fn load_library(&mut self,name:&str,flags:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>;
 fn procedure(&mut self,module:u32,name:&str,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>;
 fn encode(&mut self,reference:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>;
 fn decode(&mut self,reference:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>;
 fn invoke_ro_uninitialize(&mut self,reference:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>;
}
pub fn release_com(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,s:&mut impl Services)->Result<(),Error>{
 if get(m,d,0x14ae604,4)?==0{let module=s.load_library("combase.dll",0x800,m,d)?;let procedure=s.procedure(module,"RoUninitialize",m,d)?;if procedure==0{return Ok(());}let encoded=s.encode(procedure,m,d)?;put(m,d,0x14ae600,4,encoded)?;put(m,d,0x14ae604,4,1)?;}
 let encoded=get(m,d,0x14ae600,4)?;let procedure=s.decode(encoded,m,d)?;s.invoke_ro_uninitialize(procedure,m,d)
}
/// Must be consumed by a qualified worker exit boundary. This result does not
/// terminate an OS thread, and must not be reported as physical ExitThread proof.
#[derive(Debug,PartialEq,Eq)]pub struct PreparedExit{pub code:u32}
pub fn prepare_exit(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,code:u32,s:&mut impl Services)->Result<PreparedExit,Error>{
 let record=crate::audio_crt_thread_context::get_context(m,d,s)?;
 if record!=0{if get(m,d,record+0x3b4,4)?!=0{release_com(m,d,s)?;}crate::audio_crt_thread_destructor::detach(m,d,record,s)?;}
 Ok(PreparedExit{code})
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};use crate::audio_crt_tls_value_wrappers;
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 struct Api{row:Value,regions:Vec<(String,u32,usize)>,calls:Vec<Value>,tls:u32,last:u32,freed:Vec<u32>,allocations:Vec<Value>}
 impl Api{fn snapshot(&self,m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,a,z)in &self.regions{out[n]=json!(crate::audio_path_memory::read(m,*a,*z).unwrap().iter().map(|v|format!("{v:02x}")).collect::<String>());}out}fn emit(&mut self,name:&str,args:Value,result:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":name,"arguments":args,"result":result,"at_call":self.snapshot(m)}));}}
 impl audio_crt_tls_value_wrappers::Services for Api{
  fn get_value(&mut self,f:u32,index:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{assert_eq!(f,if self.row["layout"]=="all"{0x40004020}else{0});self.emit(if f==0{"TlsGetValue"}else{"FlsGetValue"},json!([index]),self.tls,m);self.last=0;Ok(self.tls)}
  fn set_value(&mut self,f:u32,index:u32,v:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{assert_eq!(f,if self.row["layout"]=="all"{0x40004030}else{0});self.emit(if f==0{"TlsSetValue"}else{"FlsSetValue"},json!([index,v]),1,m);self.tls=v;Ok(1)}
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
 impl Services for Api{
  fn load_library(&mut self,n:&str,f:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let result=self.row["module"].as_u64().unwrap()as u32;self.emit("LoadLibraryExW",json!([n,0,f]),result,m);Ok(result)}
  fn procedure(&mut self,module:u32,n:&str,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let result=if module!=0&&self.row["available"]==true{0x40029100}else{0};self.emit("GetProcAddress",json!([module,n]),result,m);Ok(result)}
  fn encode(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let result=v^0x13572468;self.emit("EncodePointer",json!([v]),result,m);Ok(result)}
  fn decode(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let result=v^0x13572468;self.emit("DecodePointer",json!([v]),result,m);Ok(result)}
  fn invoke_ro_uninitialize(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{assert_eq!(v,0x40029100);self.emit("RoUninitialize",json!([]),0,m);Ok(())}
 }
 #[test]fn audio_crt_worker_exit_preparation_matches124_original_full_com_lookup_cache_missing_export_tls_fls_fresh_null_context_detach_and_exit_code_cases(){
  let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_worker_exit_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],124);
  for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().into(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m=regions.iter().map(|(n,a,_)|(*a,Memory{reference:*a,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut d=BTreeSet::new();let mut api=Api{row:row.clone(),regions,calls:vec![],tls:if row["state"]=="existing"{0x40012000}else{0},last:97,freed:vec![],allocations:vec![]};let code=row["exit_code"].as_u64().unwrap()as u32;assert_eq!(prepare_exit(&mut m,&mut d,code,&mut api).unwrap(),PreparedExit{code});
   // Explicit terminal boundary observation; no physical OS termination claimed.
   api.emit("ExitThread",json!([code]),0,&m);assert_eq!(json!(api.calls),row["calls"],"all native service entry banks {i}");assert_eq!(api.snapshot(&m),row["after"],"all native final banks {i}");assert_eq!(json!(api.freed),row["freed"]);assert_eq!(json!(api.allocations),row["allocations"]);assert_eq!(api.tls as u64,row["tls_value"].as_u64().unwrap());assert_eq!(api.last as u64,row["last_error"].as_u64().unwrap());assert_eq!(d.contains(&0x40012000),row["state"]!="null_failure");
  }
 }
}
'''
(r/'crates/core/src/audio_crt_worker_exit.rs').write_text(s,encoding='utf-8');p=r/'crates/core/src/lib.rs';s=p.read_text();assert 'pub mod audio_crt_worker_exit;' not in s;p.write_text(s+'\npub mod audio_crt_worker_exit;\n',encoding='utf-8');(r/'tools/implement_audio_crt_worker_exit.py').write_text(Path(__file__).read_text(),encoding='utf-8');print('Original worker exit preparation and COM cache/release ported;124-case native full-bank test added')
