from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_resource_curve_admission.rs';s=p.read_text(encoding='utf-8')
old=' if get(m,d,at+24,4)?!=0{return Err(Error::Backend("curve removal subscriber requeue producer requires native qualification"));}clear_list(m,d,at+24,pool,s)?;'
new=''' let mut recipient=get(m,d,at+24,4)?;let mut states=BTreeSet::new();while recipient!=0{
 let state=(recipient,m.iter().map(|(r,v)|(*r,v.raw.clone())).collect::<Vec<_>>(),d.iter().copied().collect::<Vec<_>>());if !states.insert(state){return Err(Error::CyclicList);}
 let target=get(m,d,recipient+4,4)?;if target!=0{s.observe_curve_unlink(target,m);crate::audio_curve_subscriber_unlink::unlink(m,d,manager,target)?;if let Some(slot)=subscription_slot(m,d,manager+0x91c,12,pool,s)?{put(m,d,slot+4,4,target)?;put(m,d,slot+8,4,key)?;}}
 // B1203E follows the node link after unlink has mutated it, including its free chain.
 recipient=get(m,d,recipient,4)?;
 }clear_list(m,d,at+24,pool,s)?;'''
assert old in s;s=s.replace(old,new)
s+='''
#[cfg(test)]mod removal_subscription_tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 struct Backend{regions:Vec<(String,u32,usize)>,calls:Vec<Value>,allocations:Vec<Value>,failure:bool,index:u32}
 impl Backend{fn snapshot(&self,m:&BTreeMap<u32,Memory>)->Value{let mut v=json!({});for(n,r,z)in &self.regions{let b=(0..*z).map(|j|crate::audio_path_memory::read(m,r+j as u32,1).unwrap()[0]).collect::<Vec<_>>();v[n]=json!(b.iter().map(|v|format!("{v:02x}")).collect::<String>());}v}}
 impl crate::audio_path_voice_empty_source_release::Services for Backend{fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"kind":"free","pool":p,"reference":r,"at_call":self.snapshot(m)}));Ok(())}}
 impl crate::audio_action_registry_key_publication::Services for Backend{fn allocate(&mut self,p:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{assert_eq!(p,19);assert_eq!(z,12);let r=if self.failure{0}else{0x4000c000+self.index*16};self.calls.push(json!({"kind":"allocate","pool":p,"size":z,"result":r,"at_call":self.snapshot(m)}));if r!=0{self.index+=1;self.allocations.push(json!({"reference":r,"size":z}));let v=m.remove(&r).unwrap();assert!(v.raw.len()>=z as usize);if v.raw.len()>z as usize{m.insert(r+z,Memory{reference:r+z,raw:v.raw[z as usize..].to_vec()});}m.insert(r,Memory{reference:r,raw:v.raw[..z as usize].to_vec()});}Ok((r!=0).then_some(r))}}
 impl Services for Backend{fn observe_curve_unlink(&mut self,target:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"unlink_subscriber","target":target,"at_call":self.snapshot(m)}));}}
 #[test]fn audio_curve_removal_subscription_matches576_original_mutated_bound_traversal_delayed_requeue_capacity_oom_duplicates_and_full_cleanup_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_curve_removal_subscription_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],576);assert_eq!(p["terminal_case_count"],576);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().into(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<(String,u32,usize)>>();let mut m=BTreeMap::new();for(n,r,z)in &regions{let raw=bytes(row["before"][n].as_str().unwrap());let chunk=if n=="allocated"{16}else if n=="bound"{8}else{*z};for(j,b)in raw.chunks(chunk).enumerate(){let reference=r+j as u32*chunk as u32;m.insert(reference,Memory{reference,raw:b.to_vec()});}}let mut d=BTreeSet::new();let mut s=Backend{regions,calls:vec![],allocations:vec![],failure:row["failure"].as_bool().unwrap(),index:0};remove(&mut m,&mut d,0x40001000,7,19,&mut s).unwrap();assert_eq!(json!(s.calls),row["calls"],"native calls/full entry bank {i}");assert_eq!(s.snapshot(&m),row["after"],"complete physical banks {i}");assert_eq!(json!(s.allocations),row["allocations"],"exact allocation identities/sizes {i}");let freed:BTreeSet<u32>=row["freed"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect();assert_eq!(d,freed,"retired identity {i}");}
 }
}
'''
p.write_text(s,encoding='utf-8');(r/'tools/implement_audio_curve_removal_subscription.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Implemented native removal subscription requeue and576 full state replay')
