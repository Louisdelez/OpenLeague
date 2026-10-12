//! Actual AF6890 registry key publication with B15890 insertion/B153B0 growth and AF7350 cleanup.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put,live};
pub trait Services:crate::audio_path_voice_empty_source_release::Services{
 fn allocate(&mut self,pool:u32,size:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<Option<u32>,Error>;
}
fn find(m:&BTreeMap<u32,Memory>,d:&BTreeSet<u32>,registry:u32,key:u32)->Result<Option<u32>,Error>{
 let table=get(m,d,registry,4)?;let count=get(m,d,registry.wrapping_add(4),4)?;if count!=0{live(m,d,table,(count as usize).checked_mul(8).ok_or(Error::InvalidAllocation)?)?;}
 for i in 0..count{let entry=table.wrapping_add(i.wrapping_mul(8));if get(m,d,entry,4)?==key{return Ok(Some(entry.wrapping_add(4)));}}Ok(None)
}
fn allocate(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,pool:u32,size:u32,s:&mut impl Services)->Result<u32,Error>{let r=s.allocate(pool,size,m,d)?.unwrap_or(0);if r!=0{live(m,d,r,size as usize)?;}Ok(r)}
fn free(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,pool:u32,r:u32,s:&mut impl Services)->Result<(),Error>{live(m,d,r,1)?;s.free(pool,r,m)?;d.insert(r);Ok(())}
/// Capacity grows by8. Existing entries copy before old storage is freed;
/// the registry pointer/capacity publish only after that free returns.
fn grow(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,registry:u32,pool:u32,s:&mut impl Services)->Result<bool,Error>{
 let capacity=get(m,d,registry.wrapping_add(8),4)?.wrapping_add(8);let size=capacity.wrapping_mul(8);let new=allocate(m,d,pool,size,s)?;if new==0{return Ok(false);}
 let old=get(m,d,registry,4)?;let count=get(m,d,registry.wrapping_add(4),4)?;if old!=0{
 for i in 0..count{let old=get(m,d,registry,4)?;let key=get(m,d,old.wrapping_add(i.wrapping_mul(8)),4)?;put(m,d,new.wrapping_add(i.wrapping_mul(8)),4,key)?;let value=get(m,d,old.wrapping_add(i.wrapping_mul(8)+4),4)?;put(m,d,new.wrapping_add(i.wrapping_mul(8)+4),4,value)?;}
 let old=get(m,d,registry,4)?;free(m,d,pool,old,s)?;}
 put(m,d,registry,4,new)?;put(m,d,registry.wrapping_add(8),4,capacity)?;Ok(true)
}
fn insert(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,registry:u32,key:u32,value:u32,pool:u32,s:&mut impl Services)->Result<Option<u32>,Error>{
 if let Some(slot)=find(m,d,registry,key)?{put(m,d,slot,4,value)?;return Ok(Some(slot));}
 let saved_count=get(m,d,registry.wrapping_add(4),4)?;if saved_count>=get(m,d,registry.wrapping_add(8),4)?{if !grow(m,d,registry,pool,s)?||saved_count>=get(m,d,registry.wrapping_add(8),4)?{return Ok(None);}}
 let count=get(m,d,registry.wrapping_add(4),4)?;let table=get(m,d,registry,4)?;let entry=table.wrapping_add(count.wrapping_mul(8));put(m,d,registry.wrapping_add(4),4,count.wrapping_add(1))?;if entry==0{return Ok(None);}put(m,d,entry,4,key)?;put(m,d,entry.wrapping_add(4),4,value)?;Ok(Some(entry.wrapping_add(4)))
}
/// Original status1 for existing/new key and2 for allocation/insertion failure.
pub fn publish(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,registry:u32,key:u32,pool:u32,s:&mut impl Services)->Result<u32,Error>{
 if find(m,d,registry,key)?.is_some(){return Ok(1);}let owner=allocate(m,d,pool,24,s)?;if owner==0{return Ok(2);}for o in[0,4,8,12,16,20]{put(m,d,owner.wrapping_add(o),4,0)?;}
 if insert(m,d,registry,key,owner,pool,s)?.is_some(){return Ok(1);}
 let buffer=get(m,d,owner.wrapping_add(12),4)?;if buffer!=0{put(m,d,owner.wrapping_add(16),4,0)?;free(m,d,pool,buffer,s)?;put(m,d,owner.wrapping_add(12),4,0)?;put(m,d,owner.wrapping_add(20),4,0)?;}put(m,d,owner.wrapping_add(8),4,0)?;free(m,d,pool,owner,s)?;Ok(2)
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 const REGIONS:[(&str,u32);7]=[("registry",0x40001000),("old_table",0x40002000),("new_table",0x40003000),("new_owner",0x40004000),("owners",0x40005000),("first_pool",0x40006000),("second_pool",0x40007000)];
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 fn snapshot(m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r)in REGIONS{out[n]=json!(hex(&m[&r].raw));}out}
 struct Backend{calls:Vec<Value>,failure:String}
 impl crate::audio_path_voice_empty_source_release::Services for Backend{
 fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"kind":"free","pool":p,"reference":r,"at_call":snapshot(m)}));Ok(())}
 }
 impl Services for Backend{
 fn allocate(&mut self,p:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{let fail=self.failure=="owner"&&z==24||self.failure=="table"&&z!=24;let result=if fail{0}else if z==24{0x40004000}else{0x40003000};self.calls.push(json!({"kind":"allocate","pool":p,"size":z,"result":result,"at_call":snapshot(m)}));Ok((result!=0).then_some(result))}
 }
 #[test]fn audio_action_registry_key_publication_matches135_native_duplicate_first_key_owner24_capacity_plus8_growth_copy_free_before_publish_cleanup_and_all_physical_memory_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_action_registry_key_publication_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],135);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m:BTreeMap<u32,Memory>=REGIONS.into_iter().map(|(n,reference)|(reference,Memory{reference,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut dead=BTreeSet::new();let mut b=Backend{calls:vec![],failure:row["failure"].as_str().unwrap().to_owned()};assert_eq!(publish(&mut m,&mut dead,0x40001000,row["key"].as_u64().unwrap()as u32,19,&mut b).unwrap(),row["result"].as_u64().unwrap()as u32,"actual status {i}");assert_eq!(json!(b.calls),row["calls"],"every allocation/free/publication snapshot {i}");assert_eq!(snapshot(&m),row["after"],"all owner/table/registry/pool bytes {i}");assert_eq!(json!(dead.iter().copied().collect::<Vec<_>>()),row["freed"],"exact retired allocations {i}");for r in &dead{assert_eq!(get(&m,&dead,*r,1),Err(Error::UnresolvedReference));}}
 }
}
