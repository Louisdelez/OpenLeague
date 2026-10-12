//! B12E20/B10EB0/B11D70/B10160 owned subscriber release and reverse-vector cleanup.
//! Native registration/manager construction and global record lifetime remain separate.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_effect_resource_bank::Services};
use std::collections::{BTreeMap,BTreeSet};
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
fn set(raw:&mut[u8],o:usize,v:u32){raw[o..o+4].copy_from_slice(&v.to_le_bytes());}
pub struct Binding{pub memory:Memory,pub curves:Memory,pub points:BTreeMap<u32,Memory>}
pub struct Record{pub memory:Memory,pub subscribers:Memory}
pub struct Manager{pub raw:[u8;0x920],pub bindings:BTreeMap<u32,Binding>,pub records:BTreeMap<u32,Record>}
impl Manager{
 pub(crate) fn remove_reverse(&mut self,reference:u32,target:u32)->Result<(),Error>{
  let record=self.records.get_mut(&reference).ok_or(Error::UnresolvedReference)?;
  if record.memory.raw.len()<40{return Err(Error::InvalidAllocation);}
  let count=word(&record.memory.raw,32)as usize;let capacity=word(&record.memory.raw,36)as usize;
  if count>capacity||count>i32::MAX as usize||count.checked_mul(4).filter(|n|*n<=record.subscribers.raw.len()).is_none()||word(&record.memory.raw,28)!=record.subscribers.reference{return Err(Error::InvalidAllocation);}
  // Exact native midpoint search, including its selected duplicate and retained tail bytes.
  let mut low=0i64;let mut high=count as i64-1;
  while low<=high{
   let mid=low+(high-low)/2;let value=word(&record.subscribers.raw,mid as usize*4);
   if target<value{high=mid-1;}else if target>value{low=mid+1;}else{
    let index=mid as usize;if index+1<count{record.subscribers.raw.copy_within((index+1)*4..count*4,index*4);}set(&mut record.memory.raw,32,(count-1)as u32);return Ok(());
   }
  }Ok(())
 }
 pub(crate) fn find_record(&self,key:u32)->Result<Option<u32>,Error>{
  let mut reference=word(&self.raw,(key%193)as usize*4);let mut visited=BTreeSet::new();
  while reference!=0{if !visited.insert(reference){return Err(Error::Backend("cyclic RTPC record chain"));}let record=self.records.get(&reference).ok_or(Error::UnresolvedReference)?;if record.memory.raw.len()<40{return Err(Error::InvalidAllocation);}if word(&record.memory.raw,0)==key{return Ok(Some(reference));}reference=word(&record.memory.raw,4);}Ok(None)
 }
 fn clean_curves(&mut self,reference:u32,pool:u32,services:&mut impl Services)->Result<(),Error>{
  let binding=self.bindings.get(&reference).ok_or(Error::UnresolvedReference)?;let count=word(&binding.memory.raw,24)as usize;
  if count>word(&binding.memory.raw,28)as usize||count.checked_mul(20).filter(|n|*n<=binding.curves.raw.len()).is_none()||word(&binding.memory.raw,20)!=binding.curves.reference{return Err(Error::InvalidAllocation);}
  let mut found_record=false;
  for index in 0..count{
   let o=index*20;let rtpc=word(&self.bindings[&reference].curves.raw,o+4);
   if let Some(record)=self.find_record(rtpc)?{self.remove_reverse(record,reference)?;found_record=true;}
   let binding=self.bindings.get_mut(&reference).unwrap();let points=word(&binding.curves.raw,o+8);
   if points!=0{let memory=binding.points.get(&points).ok_or(Error::UnresolvedReference)?;services.free_pool(pool,memory)?;binding.points.remove(&points);set(&mut binding.curves.raw,o+8,0);}
   set(&mut binding.curves.raw,o+12,0);set(&mut binding.curves.raw,o+16,0);
  }
  set(&mut self.bindings.get_mut(&reference).unwrap().memory.raw,24,0);
  if !found_record{
   for bucket in 0..193{
    let mut record=word(&self.raw,bucket*4);let mut visited=BTreeSet::new();
    while record!=0{if !visited.insert(record){return Err(Error::Backend("cyclic fallback RTPC record chain"));}let next=word(&self.records.get(&record).ok_or(Error::UnresolvedReference)?.memory.raw,4);self.remove_reverse(record,reference)?;record=next;}
   }
  }Ok(())
 }
 pub(crate) fn retire_binding(&mut self,reference:u32,pool:u32,services:&mut impl Services)->Result<(),Error>{
  let binding=self.bindings.get(&reference).ok_or(Error::UnresolvedReference)?;let bucket=word(&binding.memory.raw,0).wrapping_add(word(&binding.memory.raw,4))%193;let offset=0x614+bucket as usize*4;let next=word(&binding.memory.raw,8);let mut current=word(&self.raw,offset);let mut previous=0;let mut seen=BTreeSet::new();
  while current!=reference{if current==0{return Err(Error::UnresolvedReference);}if !seen.insert(current){return Err(Error::CyclicList);}previous=current;current=word(&self.bindings.get(&current).ok_or(Error::UnresolvedReference)?.memory.raw,8);}
  if previous==0{set(&mut self.raw,offset,next);}else{set(&mut self.bindings.get_mut(&previous).unwrap().memory.raw,8,next);}let count=word(&self.raw,0x918).wrapping_sub(1);set(&mut self.raw,0x918,count);self.clean_curves(reference,pool,services)?;
  let binding=self.bindings.get_mut(&reference).unwrap();if binding.curves.reference!=0{set(&mut binding.memory.raw,24,0);services.free_pool(pool,&binding.curves)?;binding.curves=Memory{reference:0,raw:vec![]};set(&mut binding.memory.raw,20,0);set(&mut binding.memory.raw,28,0);}services.free_pool(pool,&binding.memory)?;self.bindings.remove(&reference);Ok(())
 }
 pub fn unsubscribe(&mut self,key:u32,pool:u32,services:&mut impl Services)->Result<(),Error>{
  for bucket in 0..193{
   let offset=0x614+bucket*4;let mut reference=word(&self.raw,offset);let mut previous=0;let mut visited=BTreeSet::new();
   while reference!=0{
    if !visited.insert(reference){return Err(Error::Backend("cyclic RTPC subscriber chain"));}
    let binding=self.bindings.get(&reference).ok_or(Error::UnresolvedReference)?;if binding.memory.raw.len()!=32{return Err(Error::InvalidAllocation);}let next=word(&binding.memory.raw,8);
    if word(&binding.memory.raw,0)!=key{previous=reference;reference=next;continue;}
    if previous==0{set(&mut self.raw,offset,next);}else{set(&mut self.bindings.get_mut(&previous).unwrap().memory.raw,8,next);}
    let count=word(&self.raw,0x918).wrapping_sub(1);set(&mut self.raw,0x918,count);
    self.clean_curves(reference,pool,services)?;
    let binding=self.bindings.get_mut(&reference).unwrap();if word(&binding.memory.raw,20)!=0{
     set(&mut binding.memory.raw,24,0);services.free_pool(pool,&binding.curves)?;binding.curves=Memory{reference:0,raw:vec![]};set(&mut binding.memory.raw,20,0);set(&mut binding.memory.raw,28,0);
    }
    services.free_pool(pool,&binding.memory)?;self.bindings.remove(&reference);reference=next;
   }
  }Ok(())
 }
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};use crate::audio_plugin_factory::Allocator;use crate::audio_meter_lifecycle::Lifetime;
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Physical{calls:Vec<Value>,freed:BTreeMap<u32,Memory>}
 impl Allocator for Physical{fn allocate(&mut self,_:u32,_:u32)->Result<Option<Memory>,Error>{Err(Error::Backend("no RTPC release allocation"))}}
 impl Lifetime for Physical{fn free(&mut self,_:u32,_:&Memory)->Result<(),Error>{Err(Error::Backend("no virtual free in RTPC release"))}fn register_callback(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("no RTPC release callback"))}}
 impl Services for Physical{fn free_pool(&mut self,pool:u32,m:&Memory)->Result<(),Error>{assert!(self.freed.insert(m.reference,m.clone()).is_none());self.calls.push(json!({"kind":"free","method":"pool","allocator":pool,"reference":m.reference}));Ok(())}}
 #[test]fn audio_rtpc_subscriber_release_matches360_native_unlink_curve_and_reverse_binary_search_cases(){
 for (text,count)in [(include_str!("../../../data/4.20/audio_rtpc_subscriber_release_preparation.json"),72),(include_str!("../../../data/4.20/audio_rtpc_subscriber_release_present_preparation.json"),144),(include_str!("../../../data/4.20/audio_rtpc_subscriber_release_sorted_preparation.json"),144)]{
  let proof:Value=serde_json::from_str(text).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],count);
  for (i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
   let b=&row["before"];let mut storage:BTreeMap<u32,Memory>=b["allocations"].as_array().unwrap().iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(a["raw"].as_str().unwrap())})}).collect();let mut manager=Manager{raw:bytes(b["rtpc"].as_str().unwrap()).try_into().unwrap(),bindings:BTreeMap::new(),records:BTreeMap::new()};
   for reference in [0x30009400,0x30009600]{let memory=storage.remove(&reference).unwrap();let curves_ref=word(&memory.raw,20);let curves=if curves_ref==0{Memory{reference:0,raw:vec![]}}else{storage.remove(&curves_ref).unwrap()};let mut points=BTreeMap::new();for entry in curves.raw.chunks_exact(20){let p=word(entry,8);if p!=0{points.insert(p,storage.remove(&p).unwrap());}}manager.bindings.insert(reference,Binding{memory,curves,points});}
   if let Some(memory)=storage.remove(&0x30009c00){let subscribers=storage.remove(&word(&memory.raw,28)).unwrap();manager.records.insert(memory.reference,Record{memory,subscribers});}assert!(storage.is_empty());
   let mut physical=Physical{calls:vec![],freed:BTreeMap::new()};manager.unsubscribe(row["key"].as_u64().unwrap()as u32,u32::MAX,&mut physical).unwrap();assert_eq!(hex(&manager.raw),row["after"]["rtpc"].as_str().unwrap(),"whole RTPC manager {count}/{i}");assert_eq!(json!(physical.calls),row["calls"],"free order {count}/{i}");
   let allocations:Vec<Value>=b["allocations"].as_array().unwrap().iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;let m=physical.freed.get(&reference).or_else(||manager.bindings.get(&reference).map(|n|&n.memory)).or_else(||manager.bindings.values().find(|n|n.curves.reference==reference).map(|n|&n.curves)).or_else(||manager.bindings.values().find_map(|n|n.points.get(&reference))).or_else(||manager.records.get(&reference).map(|n|&n.memory)).or_else(||manager.records.values().find(|n|n.subscribers.reference==reference).map(|n|&n.subscribers)).unwrap();json!({"reference":reference,"size":m.raw.len(),"freed":physical.freed.contains_key(&reference),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),row["after"]["allocations"],"all owned storage {count}/{i}");
  }
 }
 }

 #[test]fn audio_rtpc_registered_meter_release_matches12_native_actual_subscription_states(){
 let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_rtpc_meter_subscription_release_preparation.json")).unwrap();assert_eq!(proof["case_count"],12);assert_eq!(proof["passed"],true);
 for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){
  let b=&row["registered"];let mut storage:BTreeMap<u32,Memory>=b["allocations"].as_array().unwrap().iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(a["raw"].as_str().unwrap())})}).collect();let mut manager=Manager{raw:bytes(b["rtpc"].as_str().unwrap()).try_into().unwrap(),bindings:BTreeMap::new(),records:BTreeMap::new()};
  for bucket in 0..193{let mut reference=word(&manager.raw,0x614+bucket*4);while reference!=0{let memory=storage.remove(&reference).unwrap();let next=word(&memory.raw,8);let curves=storage.remove(&word(&memory.raw,20)).unwrap();let mut points=BTreeMap::new();for entry in curves.raw[..word(&memory.raw,24)as usize*20].chunks_exact(20){let p=word(entry,8);if p!=0{points.insert(p,storage.remove(&p).unwrap());}}manager.bindings.insert(reference,Binding{memory,curves,points});reference=next;}}
  let memory=Memory{reference:0x30009c00,raw:bytes(b["record"].as_str().unwrap())};let subscribers=storage.remove(&word(&memory.raw,28)).unwrap();manager.records.insert(memory.reference,Record{memory,subscribers});
  let mut physical=Physical{calls:vec![],freed:BTreeMap::new()};manager.unsubscribe(0x30008000,u32::MAX,&mut physical).unwrap();let after=&row["after"];assert_eq!(hex(&manager.raw),after["rtpc"].as_str().unwrap(),"registered manager {i}");assert_eq!(hex(&manager.records[&0x30009c00].memory.raw),after["record"].as_str().unwrap(),"registered record {i}");assert_eq!(json!(physical.calls),row["calls"]);assert!(manager.bindings.is_empty());
  let allocations:Vec<Value>=b["allocations"].as_array().unwrap().iter().map(|a|{let reference=a["reference"].as_u64().unwrap()as u32;let m=physical.freed.get(&reference).or_else(||storage.get(&reference)).or_else(||manager.records.values().find(|n|n.subscribers.reference==reference).map(|n|&n.subscribers)).unwrap();json!({"reference":reference,"size":m.raw.len(),"freed":physical.freed.contains_key(&reference),"raw":hex(&m.raw)})}).collect();assert_eq!(json!(allocations),after["allocations"],"all created subscription allocation bytes {i}");assert_eq!(hex(&storage[&0x30008000].raw),after["parameter"].as_str().unwrap());
 }
 }
}
