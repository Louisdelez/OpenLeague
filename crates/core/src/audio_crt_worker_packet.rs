//! Original C9C27C beginthreadex producer for a nonNULL callback.
//! Physical CreateThread ownership and invalid-parameter/SEH paths remain separate.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put};
#[derive(Debug,Clone,Copy)]pub struct Request{pub security:u32,pub stack_size:u32,pub callback:u32,pub argument:u32,pub flags:u32,pub thread_id_output:u32,pub callback_slot:u32}
#[derive(Debug,Clone,Copy)]pub struct ThreadRequest{pub security:u32,pub stack_size:u32,pub entry:u32,pub packet:u32,pub flags:u32,pub thread_id_output:u32}
pub trait Services:crate::audio_global_float_default_power::Windows{
 fn create_worker_thread(&mut self,request:ThreadRequest,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>;
}
fn map_error(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,code:u32,s:&mut impl Services)->Result<(),Error>{let record=crate::audio_crt_thread_context::get_context(m,d,s)?;put(m,d,if record==0{0x122299c}else{record+12},4,code)?;let errno=crate::audio_crt_heap::windows_errno(m,d,code)?;let record=crate::audio_crt_thread_context::get_context(m,d,s)?;put(m,d,if record==0{0x1222998}else{record+8},4,errno)}
/// Preserve source free-only failure semantics (no locale destructor).
pub fn create(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,request:Request,s:&mut impl Services)->Result<u32,Error>{
 if request.callback==0{return Err(Error::Backend("original NULL beginthreadex callback invalid-parameter path required"));}
 let packet=s.calloc_thread(1,956,m,d)?.unwrap_or(0);let mut error=0;
 if packet!=0{
  let parent=crate::audio_crt_thread_context::get_context(m,d,s)?;if parent==0{return Err(Error::Backend("original worker parent fatal context16 path required"));}
  let locale=get(m,d,parent+0x6c,4)?;crate::audio_crt_thread_context::initialize_from_locale(m,d,packet,locale,s)?;
  put(m,d,packet+4,4,u32::MAX)?;put(m,d,packet+0x58,4,request.argument)?;put(m,d,packet+0x54,4,request.callback)?;
  let thread_id_output=if request.thread_id_output!=0{request.thread_id_output}else{request.callback_slot};
  let result=s.create_worker_thread(ThreadRequest{security:request.security,stack_size:request.stack_size,entry:0xc9c3dc,packet,flags:request.flags,thread_id_output},m,d)?;
  if result!=0{return Ok(result);}error=s.get_last_error(m,d)?;
 }
 s.free_thread(packet,m,d)?;if packet!=0{d.insert(packet);}if error!=0{map_error(m,d,error,s)?;}Ok(0)
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};use crate::audio_crt_tls_value_wrappers;use crate::audio_crt_worker_exit::ComServices;
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
  fn calloc_thread(&mut self,n:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{assert_eq!((n,z),(1,956));let value=if self.row["allocation_ok"]==true{0x40014000}else{0};self.emit("calloc",json!([n,z]),value,m);if value!=0{m.get_mut(&value).unwrap().raw[..956].fill(0);self.allocations.push(json!({"reference":value,"size":z}));}Ok(Some(value))}
  fn free_thread(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.emit("free",json!([v]),0,m);self.freed.push(v);Ok(())}
  fn current_thread_id(&mut self,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.emit("GetCurrentThreadId",json!([]),123,m);Ok(123)}
  fn thread_lock(&mut self,v:u32,enter:bool,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.emit(if enter{"EnterCriticalSection"}else{"LeaveCriticalSection"},json!([v]),0,m);Ok(())}
 }
 impl crate::audio_crt_thread_destructor::Services for Api{}
 impl ComServices for Api{
  fn load_library(&mut self,n:&str,f:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let result=self.row["module"].as_u64().unwrap()as u32;self.emit("LoadLibraryExW",json!([n,0,f]),result,m);Ok(result)}
  fn procedure(&mut self,module:u32,n:&str,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let result=if module!=0&&self.row["available"]==true{0x40029100}else{0};self.emit("GetProcAddress",json!([module,n]),result,m);Ok(result)}
  fn encode(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let result=v^0x13572468;self.emit("EncodePointer",json!([v]),result,m);Ok(result)}
  fn decode(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let result=v^0x13572468;self.emit("DecodePointer",json!([v]),result,m);Ok(result)}
  fn invoke_ro_uninitialize(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{assert_eq!(v,0x40029100);self.emit("RoUninitialize",json!([]),0,m);Ok(())}
 }


 impl Services for Api{fn create_worker_thread(&mut self,r:ThreadRequest,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{assert_eq!((r.entry,r.packet),(0xc9c3dc,0x40014000));let result=self.row["handle"].as_u64().unwrap()as u32;self.last=self.row["thread_error"].as_u64().unwrap()as u32;put(m,d,r.thread_id_output,4,456)?;self.emit("CreateThread",json!([r.security,r.stack_size,r.entry,r.packet,r.flags,r.thread_id_output]),result,m);let call=self.calls.last_mut().unwrap();call["supplied_thread_id"]=json!(456);call["supplied_last_error"]=json!(self.last);Ok(result)}}
 #[test]fn audio_crt_worker_packet_matches384_original_beginthreadex_parent_locale_constructor_wrap_implicit_explicit_id_slot_create_failure_doserrno_errno_and_complete_banks(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_worker_packet_locale_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],384);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().into(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m=regions.iter().map(|(n,a,_)|(*a,Memory{reference:*a,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut d=BTreeSet::new();let mut api=Api{row:row.clone(),regions,calls:vec![],tls:0x40012000,last:97,freed:vec![],allocations:vec![]};let result=create(&mut m,&mut d,Request{security:0,stack_size:0,callback:0x40029500,argument:row["argument"].as_u64().unwrap()as u32,flags:row["flags"].as_u64().unwrap()as u32,thread_id_output:if row["explicit_id_output"]==true{0x40029600}else{0},callback_slot:0x4002000c},&mut api).unwrap();assert_eq!(result as u64,row["result"].as_u64().unwrap(),"native handle {i}");assert_eq!(json!(api.calls),row["calls"],"all service banks {i}");assert_eq!(api.snapshot(&m),row["after"],"all final banks {i}");assert_eq!(json!(api.freed),row["freed"]);assert_eq!(json!(api.allocations),row["allocations"]);assert_eq!(api.last as u64,row["last_error"].as_u64().unwrap());assert_eq!(d,if row["allocation_ok"]==true&&result==0{BTreeSet::from([0x40014000])}else{BTreeSet::new()});}
 }
}


/// Injectable syscall boundary; the source producer still performs all packet writes.
pub struct Creator<'a,W,F>{pub windows:&'a mut W,pub spawn:F}
impl<W:crate::audio_global_float_default_power::Windows,F> crate::audio_global_float_default_power::Windows for Creator<'_,W,F>{
 fn get_last_error(&mut self,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.windows.get_last_error(m,d)}
 fn set_last_error(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.windows.set_last_error(v,m,d)}
 fn tls_get_value(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.windows.tls_get_value(v,m,d)}
 fn tls_set_value(&mut self,i:u32,v:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<bool,Error>{self.windows.tls_set_value(i,v,m,d)}
 fn calloc_thread(&mut self,n:u32,z:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{self.windows.calloc_thread(n,z,m,d)}
 fn free_thread(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.windows.free_thread(r,m,d)}
 fn current_thread_id(&mut self,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.windows.current_thread_id(m,d)}
 fn thread_lock(&mut self,r:u32,e:bool,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.windows.thread_lock(r,e,m,d)}
}
impl<W:crate::audio_global_float_default_power::Windows,F:FnMut(ThreadRequest,&mut W,&mut BTreeMap<u32,Memory>,&mut BTreeSet<u32>)->Result<u32,Error>> Services for Creator<'_,W,F>{
 fn create_worker_thread(&mut self,r:ThreadRequest,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{(self.spawn)(r,self.windows,m,d)}
}
