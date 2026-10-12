from pathlib import Path
r=Path('E:/OpenLeague')
s=r'''//! Original CA92CB startup and CA9341/CB027B cleanup, with explicit OS/heap services.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_global_float_default_power::Windows};
use crate::audio_path_source_virtual_cleanup::{get,put,live};
pub trait Services:Windows+crate::audio_crt_global_dispatch_initialization::Services+crate::audio_crt_static_lock_startup::Services+crate::audio_crt_tls_slot_wrappers::Services+crate::audio_crt_tls_value_wrappers::Services{
 fn delete_critical_section(&mut self,reference:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<(),Error>;
}
/// Dynamic locks are deleted/freed/cleared first; static locks are deleted but retained.
pub fn cleanup(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,s:&mut impl Services)->Result<(),Error>{
 let index=get(m,d,0x12230cc,4)?;if index!=u32::MAX{crate::audio_crt_tls_slot_wrappers::free(m,d,index,s)?;put(m,d,0x12230cc,4,u32::MAX)?;}
 for j in 0..36{let a=0x1223580+j*8;let reference=get(m,d,a,4)?;if reference!=0&&get(m,d,a+4,4)?!=1{s.delete_critical_section(reference,m,d)?;s.free_thread(reference,m,d)?;d.insert(reference);put(m,d,a,4,0)?;}}
 for j in 0..36{let a=0x1223580+j*8;if get(m,d,a,4)?!=0&&get(m,d,a+4,4)?==1{let reference=get(m,d,a,4)?;s.delete_critical_section(reference,m,d)?;}}
 Ok(())
}
pub fn initialize(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,s:&mut impl Services)->Result<u32,Error>{
 crate::audio_crt_global_dispatch_initialization::initialize(m,d,s)?;
 if crate::audio_crt_static_lock_startup::initialize(m,d,s)?==0{cleanup(m,d,s)?;return Ok(0);}
 let index=crate::audio_crt_tls_slot_wrappers::allocate(m,d,0xca9026,s)?;put(m,d,0x12230cc,4,index)?;
 if index==u32::MAX{cleanup(m,d,s)?;return Ok(0);}
 let record=s.calloc_thread(1,0x3bc,m,d)?.unwrap_or(0);
 if record==0{cleanup(m,d,s)?;return Ok(0);}
 live(m,d,record,0x3bc)?;let index=get(m,d,0x12230cc,4)?;
 // CA92CB retains the allocated record on publication failure, unlike CA91A9.
 if crate::audio_crt_tls_value_wrappers::set_value(m,d,index,record,s)?==0{cleanup(m,d,s)?;return Ok(0);}
 crate::audio_crt_thread_context::initialize(m,d,record,s)?;
 let id=s.current_thread_id(m,d)?;put(m,d,record+4,4,u32::MAX)?;put(m,d,record,4,id)?;Ok(1)
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 struct Api{regions:Vec<(String,u32,usize)>,calls:Vec<Value>,layout:String,failure:String,export:u32,tls:u32,last:u32,allocations:Vec<Value>,freed:Vec<u32>}
 impl Api{
 fn snapshot(&self,m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r,z)in &self.regions{out[n]=json!((0..*z).map(|j|format!("{:02x}",crate::audio_path_memory::read(m,r+j as u32,1).unwrap()[0])).collect::<String>());}out}
 fn emit(&mut self,name:&str,args:Value,result:u32,m:&BTreeMap<u32,Memory>,storage:Option<u8>){let mut v=json!({"kind":name,"arguments":args,"result":result,"at_call":self.snapshot(m)});if let Some(b)=storage{v["supplied_storage_bytes"]=json!(format!("{b:02x}").repeat(24));}self.calls.push(v);}
 fn fill(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,reference:u32,size:u32,value:u8)->Result<(),Error>{for j in 0..size{put(m,d,reference+j,1,value as u32)?;}Ok(())}
 }
 impl crate::audio_crt_windows_dispatch_resolver::Services for Api{
 fn module_handle(&mut self,name:&str,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.emit("GetModuleHandleW",json!([name]),0x12340000,m,None);Ok(0x12340000)}
 fn procedure_address(&mut self,module:u32,name:&str,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let value=if self.layout=="all"{0x40004000+self.export*16}else{0};self.export+=1;self.emit("GetProcAddress",json!([module,name]),value,m,None);Ok(value)}
 }
 impl crate::audio_crt_global_dispatch_initialization::Services for Api{
 fn encode_pointer(&mut self,value:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let result=value^0x13572468;self.emit("EncodePointer",json!([value]),result,m,None);Ok(result)}
 }
 impl crate::audio_crt_static_lock_startup::Services for Api{
 fn initialize(&mut self,function:u32,reference:u32,spin:u32,flags:Option<u32>,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{assert_eq!(function,if self.layout=="all"{0x40004040}else{0});let mut args=vec![reference,spin];if let Some(f)=flags{args.push(f);}self.emit(if function==0{"InitializeCriticalSectionAndSpinCount"}else{"InitializeCriticalSectionEx"},json!(args),1,m,Some(0x5a));Self::fill(m,d,reference,24,0x5a)?;Ok(1)}
 }
 impl crate::audio_crt_tls_slot_wrappers::Services for Api{
 fn allocate_slot(&mut self,function:u32,callback:Option<u32>,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{assert_eq!(function,if self.layout=="all"{0x40004000}else{0});let result=if self.failure=="slot"{u32::MAX}else{5};self.emit(if function==0{"TlsAlloc"}else{"FlsAlloc"},json!(callback.into_iter().collect::<Vec<_>>()),result,m,None);Ok(result)}
 fn free_slot(&mut self,function:u32,index:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{assert_eq!(function,if self.layout=="all"{0x40004010}else{0});assert_eq!(self.tls,0,"live FLS callback requires actual destructor execution");self.emit(if function==0{"TlsFree"}else{"FlsFree"},json!([index]),1,m,None);Ok(1)}
 }
 impl crate::audio_crt_tls_value_wrappers::Services for Api{
 fn get_value(&mut self,function:u32,index:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{assert_eq!(function,if self.layout=="all"{0x40004020}else{0});self.emit(if function==0{"TlsGetValue"}else{"FlsGetValue"},json!([index]),self.tls,m,None);self.last=0;Ok(self.tls)}
 fn set_value(&mut self,function:u32,index:u32,value:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{assert_eq!(function,if self.layout=="all"{0x40004030}else{0});let result=u32::from(self.failure!="set");self.emit(if function==0{"TlsSetValue"}else{"FlsSetValue"},json!([index,value]),result,m,None);if result!=0{self.tls=value;}Ok(result)}
 }
 impl Windows for Api{
 fn get_last_error(&mut self,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.emit("GetLastError",json!([]),self.last,m,None);Ok(self.last)}
 fn set_last_error(&mut self,value:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.emit("SetLastError",json!([value]),0,m,None);self.last=value;Ok(())}
 fn tls_get_value(&mut self,index:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{crate::audio_crt_tls_value_wrappers::get_value(m,d,index,self)}
 fn tls_set_value(&mut self,index:u32,value:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<bool,Error>{Ok(crate::audio_crt_tls_value_wrappers::set_value(m,d,index,value,self)?!=0)}
 fn calloc_thread(&mut self,count:u32,size:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{let result=if self.failure=="calloc"{0}else{0x40012000};self.emit("calloc",json!([count,size]),result,m,None);if result!=0{self.allocations.push(json!({"reference":result,"size":size}));Self::fill(m,d,result,size,0)?;}Ok((result!=0).then_some(result))}
 fn free_thread(&mut self,reference:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.emit("free",json!([reference]),0,m,None);self.freed.push(reference);Ok(())}
 fn current_thread_id(&mut self,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.emit("GetCurrentThreadId",json!([]),123,m,None);Ok(123)}
 fn thread_lock(&mut self,reference:u32,enter:bool,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.emit(if enter{"EnterCriticalSection"}else{"LeaveCriticalSection"},json!([reference]),0,m,None);Ok(())}
 }
 impl Services for Api{
 fn delete_critical_section(&mut self,reference:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.emit("DeleteCriticalSection",json!([reference]),0,m,Some(0xdd));Self::fill(m,d,reference,24,0xdd)}
 }
 #[test]fn audio_crt_thread_system_startup_matches48_original_global_handlers_exports_static_locks_tls_fls_allocation_real_constructor_failure_cleanup_and_all_native_banks(){let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_thread_system_startup_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],48);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m=regions.iter().map(|(n,r,_)|(*r,Memory{reference:*r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut d=BTreeSet::new();let mut api=Api{regions,calls:vec![],layout:row["layout"].as_str().unwrap().into(),failure:row["failure"].as_str().unwrap().into(),export:0,tls:0,last:97,allocations:vec![],freed:vec![]};let result=initialize(&mut m,&mut d,&mut api).unwrap();assert_eq!(result as u64,row["result"].as_u64().unwrap(),"original bootstrap success/failure {i}");assert_eq!(json!(api.calls),row["calls"],"every original ordered service entry and complete bank {i}");assert_eq!(api.snapshot(&m),row["after"],"all32 canonical read/write regions {i}");assert_eq!(json!(api.allocations),row["allocations"],"real allocation lifetime {i}");assert_eq!(json!(api.freed),row["freed"],"publication failure does not free the allocated record {i}");assert_eq!(api.tls as u64,row["tls_value"].as_u64().unwrap());assert_eq!(api.last as u64,row["last_error"].as_u64().unwrap());assert_eq!(api.export,33);assert!(d.is_empty(),"all captured cleanup locks static and retained {i}");}}
}
'''
(r/'crates/core/src/audio_crt_thread_system_startup.rs').write_text(s,encoding='utf-8')
p=r/'crates/core/src/audio_crt_thread_context.rs';s=p.read_text(encoding='utf-8');assert 'fn initialize(m:'in s;p.write_text(s.replace('fn initialize(m:','pub(crate) fn initialize(m:',1),encoding='utf-8')
p=r/'crates/core/src/lib.rs';s=p.read_text(encoding='utf-8');assert 'pub mod audio_crt_thread_system_startup;'not in s;p.write_text(s+'\npub mod audio_crt_thread_system_startup;\n',encoding='utf-8')
(r/'tools/implement_audio_crt_thread_system_startup.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('Implemented complete original root startup plus actual failure cleanup and48 native comparisons')
