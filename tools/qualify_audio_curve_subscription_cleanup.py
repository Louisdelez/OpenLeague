from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_resource_curve_admission.rs'
s=p.read_text(encoding='utf-8');assert 'mod subscription_cleanup_tests'not in s
s+='''
#[cfg(test)]mod subscription_cleanup_tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 struct Backend{regions:Vec<(String,u32,usize)>,calls:Vec<Value>}
 impl Backend{fn snapshot(&self,m:&BTreeMap<u32,Memory>)->Value{let mut v=json!({});for(n,r,z)in &self.regions{let b=crate::audio_path_memory::read(m,*r,*z).unwrap();v[n]=json!(b.iter().map(|v|format!("{v:02x}")).collect::<String>());}v}}
 impl crate::audio_path_voice_empty_source_release::Services for Backend{fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"pool":p,"reference":r,"at_call":self.snapshot(m)}));Ok(())}}
 impl crate::audio_action_registry_key_publication::Services for Backend{fn allocate(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{panic!("native subscription cleanup does not allocate")}}
 impl Services for Backend{}
 #[test]fn audio_curve_subscription_cleanup_matches576_original_heap_embedded_free_order_unsigned_count_wrap_and_stale_header_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_curve_subscription_cleanup_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],576);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().into(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<(String,u32,usize)>>();let mut m=regions.iter().map(|(n,r,_)|(*r,Memory{reference:*r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut d=BTreeSet::new();let mut s=Backend{regions,calls:vec![]};clear_list(&mut m,&mut d,0x40001000,19,&mut s).unwrap();assert_eq!(row["result"],1,"native success {i}");assert_eq!(json!(s.calls),row["calls"],"native free order and every call bank {i}");assert_eq!(s.snapshot(&m),row["after"],"complete physical banks {i}");let freed:BTreeSet<u32>=row["freed"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect();assert_eq!(d,freed,"retired identity {i}");}
 }
}
'''
p.write_text(s,encoding='utf-8');(r/'tools/qualify_audio_curve_subscription_cleanup.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Added native576 cleanup replay without changing production behavior')
