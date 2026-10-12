//! Original CABCC2/CABCE1 encoded TLS/FLS value dispatch wrappers.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::get;
pub trait Services{
 fn get_value(&mut self,function:u32,index:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<u32,Error>;
 fn set_value(&mut self,function:u32,index:u32,value:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<u32,Error>;
}
pub fn get_value(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,index:u32,s:&mut impl Services)->Result<u32,Error>{let function=get(m,d,0x2da5308,4)?^get(m,d,0x1222ed0,4)?;s.get_value(function,index,m,d)}
pub fn set_value(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,index:u32,value:u32,s:&mut impl Services)->Result<u32,Error>{let function=get(m,d,0x2da530c,4)?^get(m,d,0x1222ed0,4)?;s.set_value(function,index,value,m,d)}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 struct Api{regions:Vec<(String,u32,usize)>,calls:Vec<Value>,result:u32}
 impl Api{fn snapshot(&self,m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r,z)in &self.regions{out[n]=json!((0..*z).map(|j|format!("{:02x}",crate::audio_path_memory::read(m,r+j as u32,1).unwrap()[0])).collect::<String>());}out}}
 impl Services for Api{
 fn get_value(&mut self,function:u32,index:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{assert!(function==0||function==0x40028020);self.calls.push(json!({"kind":if function==0{"TlsGetValue"}else{"FlsGetValue"},"arguments":[index],"result":self.result,"at_call":self.snapshot(m)}));Ok(self.result)}
 fn set_value(&mut self,function:u32,index:u32,value:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{assert!(function==0||function==0x40028030);self.calls.push(json!({"kind":if function==0{"TlsSetValue"}else{"FlsSetValue"},"arguments":[index,value],"result":self.result,"at_call":self.snapshot(m)}));Ok(self.result)}
 }
 #[test]fn audio_crt_tls_value_wrappers_matches144_original_encoded_tls_fls_get_set_unsigned_index_raw_pointer_bool_return_and_all_canonical_banks(){let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_tls_value_wrappers_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],144);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m=regions.iter().map(|(n,r,_)|(*r,Memory{reference:*r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut d=BTreeSet::new();let mut api=Api{regions,calls:vec![],result:row["api_result"].as_u64().unwrap()as u32};let index=row["index"].as_u64().unwrap()as u32;let value=row["value"].as_u64().unwrap()as u32;let result=if row["action"]=="get"{get_value(&mut m,&mut d,index,&mut api)}else{set_value(&mut m,&mut d,index,value,&mut api)}.unwrap();assert_eq!(result as u64,row["result"].as_u64().unwrap(),"native raw pointer/BOOL {i}");assert_eq!(json!(api.calls),row["calls"],"original arguments and complete service entry banks {i}");assert_eq!(api.snapshot(&m),row["after"],"canonical globals {i}");assert_eq!(row["stack_delta"],4,"native caller retains cdecl arguments {i}");assert!(d.is_empty());}}
}
