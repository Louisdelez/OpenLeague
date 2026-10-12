from pathlib import Path
r=Path('E:/OpenLeague')
s=r'''//! Encoded TLS/FLS provider for the actual CRT getter, constructor and default power.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_global_float_default_power::Windows};
pub struct Provider<'a,S>{pub services:&'a mut S}
impl<S:Windows+crate::audio_crt_tls_value_wrappers::Services> Windows for Provider<'_,S>{
 fn get_last_error(&mut self,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.services.get_last_error(m,d)}
 fn set_last_error(&mut self,value:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.services.set_last_error(value,m,d)}
 fn tls_get_value(&mut self,index:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{crate::audio_crt_tls_value_wrappers::get_value(m,d,index,self.services)}
 fn tls_set_value(&mut self,index:u32,value:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<bool,Error>{Ok(crate::audio_crt_tls_value_wrappers::set_value(m,d,index,value,self.services)?!=0)}
 fn calloc_thread(&mut self,count:u32,size:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{self.services.calloc_thread(count,size,m,d)}
 fn free_thread(&mut self,reference:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.services.free_thread(reference,m,d)}
 fn current_thread_id(&mut self,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.services.current_thread_id(m,d)}
 fn thread_lock(&mut self,reference:u32,enter:bool,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.services.thread_lock(reference,enter,m,d)}
}
pub fn get_context(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,services:&mut(impl Windows+crate::audio_crt_tls_value_wrappers::Services))->Result<u32,Error>{crate::audio_crt_thread_context::get_context(m,d,&mut Provider{services})}
'''
(r/'crates/core/src/audio_crt_encoded_thread_provider.rs').write_text(s,encoding='utf-8')
p=r/'crates/core/src/lib.rs';s=p.read_text(encoding='utf-8');assert 'pub mod audio_crt_encoded_thread_provider;'not in s;p.write_text(s+'\npub mod audio_crt_encoded_thread_provider;\n',encoding='utf-8')
p=r/'crates/core/src/audio_crt_thread_system_startup.rs';s=p.read_text(encoding='utf-8')
old='assert_eq!(function,if self.layout=="all"{0x40004010}else{0});'
assert old in s;s=s.replace(old,'assert_eq!(function,if self.layout=="all"{0x40004010}else if self.layout=="extended"{0x40028020}else{0});')
s=s.rstrip();assert s.endswith('}');s=s[:-1]+r'''
 #[test]fn audio_crt_startup_getter_matches36_original_full_startup_then_encoded_tls_fls_lookup_error_preservation_and_all55_canonical_banks(){let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_startup_getter_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],36);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m=regions.iter().map(|(n,r,_)|(*r,Memory{reference:*r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut d=BTreeSet::new();let mut api=Api{regions,calls:vec![],layout:row["layout"].as_str().unwrap().into(),failure:"none".into(),export:0,tls:0,last:97,allocations:vec![],freed:vec![]};let result=initialize(&mut m,&mut d,&mut api).unwrap();assert_eq!(result as u64,row["startup_result"].as_u64().unwrap(),"bootstrap status {i}");assert_eq!(api.snapshot(&m),row["after_startup"],"all intermediate startup banks {i}");assert_eq!(api.calls.len()as u64,row["startup_call_count"].as_u64().unwrap());api.last=row["saved_error"].as_u64().unwrap()as u32;let record=crate::audio_crt_encoded_thread_provider::get_context(&mut m,&mut d,&mut api).unwrap();assert_eq!(record as u64,row["getter_result"].as_u64().unwrap(),"bootstrapped original context identity {i}");assert_eq!(json!(api.calls),row["calls"],"every startup and encoded getter service entry and bank {i}");assert_eq!(api.snapshot(&m),row["after"],"all55 canonical read/write regions {i}");assert_eq!(json!(api.allocations),row["allocations"],"no additional allocation {i}");assert_eq!(json!(api.freed),row["freed"]);assert_eq!(api.tls as u64,row["tls_value"].as_u64().unwrap());assert_eq!(api.last as u64,row["last_error"].as_u64().unwrap());assert!(d.is_empty());}}
 #[test]fn audio_crt_thread_system_cleanup_matches72_original_tls_fls_release_two_pass_dynamic_non_one_flags_static_retention_and_complete_ownership_cases(){let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_thread_system_cleanup_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],72);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m:BTreeMap<u32,Memory>=regions.iter().map(|(n,r,_)|(*r,Memory{reference:*r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();
 // Canonical capture joins adjacent bytes; ownership is36 separate24-byte locks.
 let storage=m.remove(&0x40008000).unwrap();assert_eq!(storage.raw.len(),36*24);for j in 0..36{let reference=storage.reference+j as u32*24;m.insert(reference,Memory{reference,raw:storage.raw[j*24..j*24+24].to_vec()});}
 let mut d=BTreeSet::new();let mut api=Api{regions,calls:vec![],layout:if row["extended"].as_bool().unwrap(){"extended".into()}else{"none".into()},failure:"none".into(),export:0,tls:0,last:97,allocations:vec![],freed:vec![]};cleanup(&mut m,&mut d,&mut api).unwrap();assert_eq!(json!(api.calls),row["calls"],"native slot then dynamic-delete/free/clear then static-delete order and entry banks {i}");assert_eq!(api.snapshot(&m),row["after"],"all canonical regions including retained static table pointers {i}");assert_eq!(json!(api.freed),row["freed"],"exact original dynamic allocation identities {i}");assert_eq!(d,api.freed.iter().copied().collect(),"only individual dynamic lock allocations retired {i}");assert!(api.allocations.is_empty());}}
}
'''
p.write_text(s,encoding='utf-8')
(r/'tools/integrate_audio_crt_encoded_context_cleanup.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('Integrated encoded thread provider;36 full startup/getter and72 static/dynamic cleanup comparisons')
