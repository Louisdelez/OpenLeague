from pathlib import Path
r=Path('E:/OpenLeague')
source='''//! Original C9C3DC worker packet adoption/transfer, before C9C439 COM stage.
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
'''
old=(r/'crates/core/src/audio_crt_worker_exit.rs').read_text()
a=old.index(' impl audio_crt_tls_value_wrappers::Services for Api');b=old.index(' impl ComServices for Api',a)
methods=old[a:b].replace('self.emit(if f==0{"TlsSetValue"}else{"FlsSetValue"},json!([index,v]),1,m);self.tls=v;Ok(1)', 'let ok=u32::from(self.row["state"]!="publication_failure");self.emit(if f==0{"TlsSetValue"}else{"FlsSetValue"},json!([index,v]),ok,m);if ok!=0{self.tls=v;}Ok(ok)')
prefix=old[old.index(' fn bytes(s:'):a]
test='''
 #[test]fn audio_crt_worker_entry_matches162_original_tls_fls_packet_adoption_three_field_transfer_destructor_publication_failure_and_terminal_banks(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_worker_entry_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],162);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().into(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m=regions.iter().map(|(n,a,_)|(*a,Memory{reference:*a,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut d=BTreeSet::new();let mut api=Api{row:row.clone(),regions,calls:vec![],tls:if row["state"]=="existing"{0x40012000}else{0},last:97,freed:vec![],allocations:vec![]};let result=prepare_entry(&mut m,&mut d,0x40014000,&mut api).unwrap();let expected=if row["terminal"]=="exit"{let code=row["calls"].as_array().unwrap().last().unwrap()["arguments"][0].as_u64().unwrap()as u32;api.emit("ExitThread",json!([code]),0,&m);Entry::Exit{code}}else{Entry::Ready{record:row["tls_value"].as_u64().unwrap()as u32}};assert_eq!(result,expected,"native outcome {i}");assert_eq!(json!(api.calls),row["calls"],"native service banks {i}");assert_eq!(api.snapshot(&m),row["after"],"final banks {i}");assert_eq!(json!(api.freed),row["freed"]);assert_eq!(json!(api.allocations),row["allocations"]);assert_eq!(api.tls as u64,row["tls_value"].as_u64().unwrap());assert_eq!(api.last as u64,row["last_error"].as_u64().unwrap());assert_eq!(d,if row["state"]=="existing"{BTreeSet::from([0x40014000])}else{BTreeSet::new()});}
 }
}
'''
(r/'crates/core/src/audio_crt_worker_entry.rs').write_text(source+'#[cfg(test)]mod tests{\n use super::*;use serde_json::{Value,json};use crate::audio_crt_tls_value_wrappers;\n'+prefix+methods+test)
lib=r/'crates/core/src/lib.rs';text=lib.read_text();assert 'pub mod audio_crt_worker_entry;'not in text;lib.write_text(text+'\npub mod audio_crt_worker_entry;\n')
(r/'tools/implement_audio_crt_worker_entry.py').write_text(Path(__file__).read_text())
print('Installed original worker entry port and162-case full-bank regression')
