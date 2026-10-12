from pathlib import Path
r=Path('E:/OpenLeague');base=r/'crates/core/src'
p=base/'audio_crt_thread_context.rs';s=p.read_text(encoding='utf-8');needle='pub(crate) fn initialize(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,r:u32,s:&mut impl Windows)->Result<(),Error>{';assert needle in s
s=s.replace(needle,'''pub(crate) fn initialize(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,r:u32,s:&mut impl Windows)->Result<(),Error>{initialize_from_locale(m,d,r,0,s)}
/// Original constructor caller-supplied locale, falling back to current global only for NULL.
pub fn initialize_from_locale(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,r:u32,parent_locale:u32,s:&mut impl Windows)->Result<(),Error>{''')
needle='lock(m,d,12,true,s)?;put(m,d,r+0x6c,4,0)?;let locale=get(m,d,0x122323c,4)?;put(m,d,r+0x6c,4,locale)?;'
assert needle in s;s=s.replace(needle,'lock(m,d,12,true,s)?;put(m,d,r+0x6c,4,parent_locale)?;if parent_locale==0{let locale=get(m,d,0x122323c,4)?;put(m,d,r+0x6c,4,locale)?;}');p.write_text(s,encoding='utf-8')
source='''//! Original C9C27C beginthreadex producer for a nonNULL callback.
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
'''
old=(base/'audio_crt_worker_body.rs').read_text(encoding='utf-8');a=old.index(' fn bytes(s:');b=old.index(' impl CallbackServices',a);methods=old[a:b]
methods=methods.replace('let value=if self.row["state"]=="null_failure"{0}else{0x40012000};','let value=if self.row["allocation_ok"]==true{0x40014000}else{0};')
test='''
 impl Services for Api{fn create_worker_thread(&mut self,r:ThreadRequest,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{assert_eq!((r.entry,r.packet),(0xc9c3dc,0x40014000));let result=self.row["handle"].as_u64().unwrap()as u32;self.last=self.row["thread_error"].as_u64().unwrap()as u32;put(m,d,r.thread_id_output,4,456)?;self.emit("CreateThread",json!([r.security,r.stack_size,r.entry,r.packet,r.flags,r.thread_id_output]),result,m);let call=self.calls.last_mut().unwrap();call["supplied_thread_id"]=json!(456);call["supplied_last_error"]=json!(self.last);Ok(result)}}
 #[test]fn audio_crt_worker_packet_matches384_original_beginthreadex_parent_locale_constructor_wrap_implicit_explicit_id_slot_create_failure_doserrno_errno_and_complete_banks(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_worker_packet_locale_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],384);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().into(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m=regions.iter().map(|(n,a,_)|(*a,Memory{reference:*a,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut d=BTreeSet::new();let mut api=Api{row:row.clone(),regions,calls:vec![],tls:0x40012000,last:97,freed:vec![],allocations:vec![]};let result=create(&mut m,&mut d,Request{security:0,stack_size:0,callback:0x40029500,argument:row["argument"].as_u64().unwrap()as u32,flags:row["flags"].as_u64().unwrap()as u32,thread_id_output:if row["explicit_id_output"]==true{0x40029600}else{0},callback_slot:0x4002000c},&mut api).unwrap();assert_eq!(result as u64,row["result"].as_u64().unwrap(),"native handle {i}");assert_eq!(json!(api.calls),row["calls"],"all service banks {i}");assert_eq!(api.snapshot(&m),row["after"],"all final banks {i}");assert_eq!(json!(api.freed),row["freed"]);assert_eq!(json!(api.allocations),row["allocations"]);assert_eq!(api.last as u64,row["last_error"].as_u64().unwrap());assert_eq!(d,if row["allocation_ok"]==true&&result==0{BTreeSet::from([0x40014000])}else{BTreeSet::new()});}
 }
}
'''
(base/'audio_crt_worker_packet.rs').write_text(source+'#[cfg(test)]mod tests{\n use super::*;use serde_json::{Value,json};use crate::audio_crt_tls_value_wrappers;use crate::audio_crt_worker_exit::ComServices;\n'+methods+test,encoding='utf-8')
p=base/'lib.rs';s=p.read_text(encoding='utf-8');assert 'pub mod audio_crt_worker_packet;'not in s;p.write_text(s+'\npub mod audio_crt_worker_packet;\n',encoding='utf-8');(r/'tools/implement_audio_crt_worker_packet.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Installed packet producer, supplied parent locale constructor and384 regression')
