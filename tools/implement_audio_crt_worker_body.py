from pathlib import Path
r=Path('E:/OpenLeague')
source='''//! Original C9C315 normal callback/return path through C9C356 exit preparation.
//! Native exception filter/SEH and missing-context fatal path remain unqualified.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::get;
pub trait CallbackServices{
 fn worker_callback(&mut self,function:u32,argument:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>;
}
pub trait Services:crate::audio_crt_worker_exit::Services+CallbackServices{}
impl<S:crate::audio_crt_worker_exit::Services+CallbackServices> Services for S{}
/// Normal return path only. A service error does not emulate native SEH dispatch.
/// Callback executes under the shared context guard; it must not reenter that guard.
pub fn prepare_normal_exit(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,s:&mut impl Services)->Result<crate::audio_crt_worker_exit::PreparedExit,Error>{
 let record=crate::audio_crt_thread_context::get_context(m,d,s)?;
 if record==0{return Err(Error::Backend("original worker fatal context16 path required"));}
 let argument=get(m,d,record+0x58,4)?;let function=get(m,d,record+0x54,4)?;
 let code=s.worker_callback(function,argument,m,d)?;
 crate::audio_crt_worker_exit::prepare_exit(m,d,code,s)
}
'''
old=(r/'crates/core/src/audio_crt_worker_exit.rs').read_text(encoding='utf-8');a=old.index(' fn bytes(s:');b=old.index(' #[test]fn',a);methods=old[a:b]
test='''
 impl CallbackServices for Api{fn worker_callback(&mut self,f:u32,a:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{assert_eq!(f,0x40029200);let code=self.row["code"].as_u64().unwrap()as u32;assert_eq!(a as u64,self.row["argument"].as_u64().unwrap());self.emit("worker_callback",json!([a]),code,m);Ok(code)}}
 #[test]fn audio_crt_worker_body_matches54_original_required_context_stdcall_callback_argument_raw_return_exit_service_order_and_complete_banks(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_worker_body_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],54);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().into(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m=regions.iter().map(|(n,a,_)|(*a,Memory{reference:*a,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut d=BTreeSet::new();let mut api=Api{row:row.clone(),regions,calls:vec![],tls:0x40012000,last:97,freed:vec![],allocations:vec![]};let code=row["code"].as_u64().unwrap()as u32;assert_eq!(prepare_normal_exit(&mut m,&mut d,&mut api).unwrap(),crate::audio_crt_worker_exit::PreparedExit{code});api.emit("ExitThread",json!([code]),0,&m);assert_eq!(json!(api.calls),row["calls"],"service entry banks {i}");assert_eq!(api.snapshot(&m),row["after"],"final native banks {i}");assert_eq!(api.freed,vec![0x40012000]);assert_eq!(api.tls,0);assert_eq!(api.last as u64,row["last_error"].as_u64().unwrap());assert_eq!(d,BTreeSet::from([0x40012000]));}
 }
}
'''
(r/'crates/core/src/audio_crt_worker_body.rs').write_text(source+'#[cfg(test)]mod tests{\n use super::*;use serde_json::{Value,json};use crate::audio_crt_tls_value_wrappers;use crate::audio_crt_worker_exit::ComServices;\n'+methods+test,encoding='utf-8')
lib=r/'crates/core/src/lib.rs';text=lib.read_text(encoding='utf-8');assert 'pub mod audio_crt_worker_body;'not in text;lib.write_text(text+'\npub mod audio_crt_worker_body;\n',encoding='utf-8')
(r/'tools/implement_audio_crt_worker_body.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('Installed normal worker body and54 native regression cases')
