
//! Actual AF69B0/AF6F50 transition admission and AF95A0 capacity+5 growth.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put,live};
pub trait Services:crate::audio_path_voice_empty_source_release::Services{
 fn allocate_transition(&mut self,pool:u32,size:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<Option<u32>,Error>;
}
fn grow(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,header:u32,pool:u32,s:&mut impl Services)->Result<bool,Error>{
 let capacity=get(m,d,header.wrapping_add(8),4)?.wrapping_add(5);let size=capacity.wrapping_mul(12);let new=s.allocate_transition(pool,size,m,d)?.unwrap_or(0);if new==0{return Ok(false);}live(m,d,new,size as usize)?;
 let old=get(m,d,header,4)?;let count=get(m,d,header.wrapping_add(4),4)?;
 if old!=0{for i in 0..count{let current=get(m,d,header,4)?;for off in[0,4,8]{let bits=get(m,d,current.wrapping_add(i.wrapping_mul(12)).wrapping_add(off),4)?;put(m,d,new.wrapping_add(i.wrapping_mul(12)).wrapping_add(off),4,bits)?;}}
 let old=get(m,d,header,4)?;live(m,d,old,1)?;s.free(pool,old,m)?;d.insert(old);}
 put(m,d,header,4,new)?;put(m,d,header.wrapping_add(8),4,capacity)?;Ok(true)
}
fn insert(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,header:u32,from:u32,to:u32,duration:u32,pool:u32,s:&mut impl Services)->Result<Option<u32>,Error>{
 let saved=get(m,d,header.wrapping_add(4),4)?;let mut at=get(m,d,header,4)?;let end=at.wrapping_add(saved.wrapping_mul(12));let mut seen=BTreeSet::new();
 while at!=end{if !seen.insert(at){return Err(Error::CyclicList);}if get(m,d,at,4)?==from&&get(m,d,at.wrapping_add(4),4)?==to{let value=at.wrapping_add(8);if value!=0{put(m,d,value,4,duration)?;return Ok(Some(value));}break;}at=at.wrapping_add(12);}
 if saved>=get(m,d,header.wrapping_add(8),4)?{if !grow(m,d,header,pool,s)?||saved>=get(m,d,header.wrapping_add(8),4)?{return Ok(None);}}
 let count=get(m,d,header.wrapping_add(4),4)?;let table=get(m,d,header,4)?;let at=table.wrapping_add(count.wrapping_mul(12));put(m,d,header.wrapping_add(4),4,count.wrapping_add(1))?;if at==0{return Ok(None);}
 put(m,d,at,4,from)?;put(m,d,at.wrapping_add(4),4,to)?;let value=at.wrapping_add(8);put(m,d,value,4,duration)?;Ok(Some(value))
}
/// Status20 missing key,2 insertion failure,1 complete; reverse uses its low byte.
pub fn register(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,registry:u32,key:u32,from:u32,to:u32,duration:u32,reverse:u32,pool:u32,s:&mut impl Services)->Result<u32,Error>{
 let mut at=get(m,d,registry,4)?;let end=at.wrapping_add(get(m,d,registry.wrapping_add(4),4)?.wrapping_mul(8));let mut seen=BTreeSet::new();let mut owner=None;
 while at!=end{if !seen.insert(at){return Err(Error::CyclicList);}if get(m,d,at,4)?==key{let slot=at.wrapping_add(4);if slot!=0{owner=Some(get(m,d,slot,4)?);}break;}at=at.wrapping_add(8);}
 let Some(owner)=owner else{return Ok(20);};let header=owner.wrapping_add(12);
 if insert(m,d,header,from,to,duration,pool,s)?.is_none(){return Ok(2);}
 if reverse as u8!=0&&insert(m,d,header,to,from,duration,pool,s)?.is_none(){return Ok(2);}Ok(1)
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{calls:Vec<Value>,regions:Vec<(String,u32,usize)>,failure:bool,next:u32,allocations:Vec<Value>}
 impl Backend{fn snapshot(&self,m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r,z)in &self.regions{out[n]=json!(hex(&(0..*z).map(|i|crate::audio_path_memory::read(m,r+i as u32,1).unwrap()[0]).collect::<Vec<_>>()));}out}}
 impl crate::audio_path_voice_empty_source_release::Services for Backend{fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"kind":"free","pool":p,"reference":r,"at_call":self.snapshot(m)}));Ok(())}}
 impl Services for Backend{fn allocate_transition(&mut self,p:u32,size:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{
 let result=if self.failure{0}else{let r=self.next;self.next+=128;r};self.calls.push(json!({"kind":"allocate","pool":p,"size":size,"result":result,"at_call":self.snapshot(m)}));if result!=0{self.allocations.push(json!({"reference":result,"size":size}));let full=m.remove(&result).unwrap();assert_eq!(full.raw.len(),128);m.insert(result,Memory{reference:result,raw:full.raw[..size as usize].to_vec()});if size<128{m.insert(result+size,Memory{reference:result+size,raw:full.raw[size as usize..].to_vec()});}}Ok((result!=0).then_some(result))
 }}
 #[test]fn audio_action_registry_transition_admission_matches512_original_first_key_duplicate_pair_update_empty_spare_full_capacity_plus5_copy_free_before_publish_symmetric_equal_endpoints_low_byte_oom_and_complete_physical_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_action_registry_transition_admission_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],512);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m=BTreeMap::new();for(n,r,z)in &regions{let raw=bytes(row["before"][n].as_str().unwrap());if n=="old_table"{let size=(row["old_capacity"].as_u64().unwrap()as usize*12).max(1);m.insert(*r,Memory{reference:*r,raw:raw[..size].to_vec()});m.insert(r+size as u32,Memory{reference:r+size as u32,raw:raw[size..].to_vec()});}else{let size=if n=="owners"{24}else if n=="new_tables"{128}else{*z};for(j,b)in raw.chunks(size).enumerate(){let reference=r+j as u32*size as u32;m.insert(reference,Memory{reference,raw:b.to_vec()});}}}
 let mut d=BTreeSet::new();let mut s=Backend{calls:vec![],regions,failure:row["allocation_failure"].as_bool().unwrap(),next:0x40005000,allocations:vec![]};
 let result=register(&mut m,&mut d,0x40001000,7,row["from"].as_u64().unwrap()as u32,row["to"].as_u64().unwrap()as u32,row["duration"].as_u64().unwrap()as u32,row["reverse"].as_u64().unwrap()as u32,19,&mut s).unwrap();
 assert_eq!(result as u64,row["result"].as_u64().unwrap(),"native admission status {i}");assert_eq!(json!(s.calls),row["calls"],"all allocator/free and publication snapshots {i}");assert_eq!(s.snapshot(&m),row["after"],"all registry/key/owner/old/new physical bytes {i}");assert_eq!(json!(s.allocations),row["allocations"],"actual allocation sizes/identities {i}");let freed:BTreeSet<u32>=row["freed"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect();assert_eq!(d,freed,"retired buffers {i}");for r in &d{assert_eq!(get(&m,&d,*r,1),Err(Error::UnresolvedReference));}
 }}
}
