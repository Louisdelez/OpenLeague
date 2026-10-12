//! Native65E6F0/6680F0/663710 normal-return insertion and default4.0 load-factor growth.
use crate::audio_announcer_object_lookup::{self as lookup,Memory};
use crate::audio_announcer_registry_init::{self as init,Storage};
use crate::audio_announcer_registry_remove::{self as remove,Backend as RemovalBackend};
#[derive(Debug,PartialEq,Eq)]
pub enum Error {Storage(lookup::Error),Allocation(init::Error),Release(remove::Error),InvalidLayout,CountLimit,UnsupportedLoadFactor(u32),NullAllocation(u32),AddressOverflow}
impl From<lookup::Error> for Error {fn from(e:lookup::Error)->Self {Self::Storage(e)}}
impl From<init::Error> for Error {fn from(e:init::Error)->Self {Self::Allocation(e)}}
impl From<remove::Error> for Error {fn from(e:remove::Error)->Self {Self::Release(e)}}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct Inserted {pub node:u32,pub inserted:bool}
fn add(a:u32,b:u32)->Result<u32,Error> {a.checked_add(b).ok_or(Error::AddressOverflow)}
fn write<B:Storage>(b:&mut B,a:u32,v:u32)->Result<(),Error> {Storage::write_word(b,a,v)?;Ok(())}
fn free<B:RemovalBackend>(b:&mut B,a:u32)->Result<(),Error> {let route=b.deallocator()?;b.free(a,route)?;Ok(())}
fn sort_node<B:Storage+RemovalBackend>(b:&mut B,manager:u32,node:u32,depth:u32,hash:lookup::Hash)->Result<Inserted,Error> {
 if depth>32 {return Err(Error::InvalidLayout);}
 let key=b.word(add(node,8)?)?;let mask=b.word(add(manager,24)?)?;let maximum=b.word(add(manager,28)?)?;
 let index=lookup::bucket_index_with_hash(key,mask,maximum,hash)?;let buckets=b.word(add(manager,12)?)?;let bucket=add(buckets,index.checked_mul(8).ok_or(Error::AddressOverflow)?)?;
 let head=b.word(add(manager,4)?)?;let first=b.word(bucket)?;let mut position=head;
 if first!=head {
  let last=b.word(add(bucket,4)?)?;position=b.word(last)?;
  if position!=first {
   loop {
    position=b.word(add(position,4)?)?;let current_key=b.word(add(position,8)?)?;
    if current_key<=key {
     if current_key==key {
      let previous=b.word(add(node,4)?)?;let next=b.word(node)?;write(b,previous,next)?;write(b,add(next,4)?,previous)?;
      let count=b.word(add(manager,8)?)?;write(b,add(manager,8)?,count.wrapping_sub(1))?;free(b,node)?;
      return Ok(Inserted {node:position,inserted:false});
     }
     position=b.word(position)?;break;
    }
    if position==first {break;}
   }
  }
 }
 let last=b.word(node)?;
 if position!=last {
  let previous=b.word(add(node,4)?)?;write(b,previous,last)?;
  let previous_last=b.word(add(last,4)?)?;write(b,previous_last,position)?;
  let previous_position=b.word(add(position,4)?)?;write(b,previous_position,node)?;
  let previous_last=b.word(add(last,4)?)?;let previous_position=b.word(add(position,4)?)?;write(b,add(position,4)?,previous_last)?;
  let previous=b.word(add(node,4)?)?;write(b,add(last,4)?,previous)?;write(b,add(node,4)?,previous_position)?;
 }
 let first=b.word(bucket)?;
 if first==head {write(b,bucket,node)?;write(b,add(bucket,4)?,node)?;}
 else if first==position {write(b,bucket,node)?;}
 else {let previous_last=b.word(add(bucket,4)?)?;let mut next=b.word(previous_last)?;write(b,add(bucket,4)?,next)?;if next!=node {next=b.word(add(next,4)?)?;write(b,add(bucket,4)?,next)?;}}
 grow(b,manager,depth,hash)?;Ok(Inserted {node,inserted:true})
}
fn grow<B:Storage+RemovalBackend>(b:&mut B,manager:u32,depth:u32,hash:lookup::Hash)->Result<(),Error> {
 let count=b.word(add(manager,8)?)?;let maximum=b.word(add(manager,28)?)?;let load=b.word(add(manager,32)?)?;
 if load!=0x40800000 {return Err(Error::UnsupportedLoadFactor(load));}
 if u64::from(count)<=u64::from(maximum)*4 {return Ok(());}
 let target=if maximum<512 {maximum.checked_mul(8).ok_or(Error::AddressOverflow)?} else if maximum<0x1fffffff {maximum.checked_mul(2).ok_or(Error::AddressOverflow)?} else {maximum};
 if target==0 {return Err(Error::InvalidLayout);}
 let old=b.word(add(manager,12)?)?;let capacity_end=b.word(add(manager,20)?)?;let capacity=capacity_end.checked_sub(old).ok_or(Error::InvalidLayout)?/4;
 let requested=target.checked_mul(2).ok_or(Error::AddressOverflow)?;write(b,add(manager,16)?,old)?;let head=b.word(add(manager,4)?)?;
 if requested>capacity {
  let half=capacity>>1;let increased=if capacity>0x3fffffff-half {0} else {capacity+half};let allocation_words=increased.max(requested);let bytes=allocation_words.checked_mul(4).ok_or(Error::AddressOverflow)?;
  let new=b.allocate(bytes)?;if new==0 {return Err(Error::NullAllocation(bytes));}
  for i in 0..requested {write(b,add(new,i.checked_mul(4).ok_or(Error::AddressOverflow)?)?,head)?;}
  if old!=0 {free(b,old)?;}
  write(b,add(manager,12)?,new)?;write(b,add(manager,20)?,add(new,bytes)?)?;write(b,add(manager,16)?,add(new,requested*4)?)?;
 } else {for i in 0..requested {write(b,add(old,i*4)?,head)?;}write(b,add(manager,16)?,add(old,requested*4)?)?;}
 write(b,add(manager,24)?,target-1)?;write(b,add(manager,28)?,target)?;
 if b.word(head)?!=head {
  let last=b.word(add(head,4)?)?;
  loop {let node=b.word(head)?;sort_node(b,manager,node,depth+1,hash)?;if node==last {break;}}
 }
 Ok(())
}
/// Pair copy precedes count validation, as in the original allocation/list helper.
pub fn insert<B:Storage+RemovalBackend>(b:&mut B,manager:u32,key:u32,value:u32)->Result<Inserted,Error> {insert_with_hash(b,manager,key,value,lookup::Hash::Legacy)}
pub fn insert_with_hash<B:Storage+RemovalBackend>(b:&mut B,manager:u32,key:u32,value:u32,hash:lookup::Hash)->Result<Inserted,Error> {
 if manager==0 {return Err(Error::InvalidLayout);}
 let head=b.word(add(manager,4)?)?;let first=b.word(head)?;let previous=b.word(add(first,4)?)?;
 let node=b.allocate(16)?;if node==0 {return Err(Error::NullAllocation(16));}
 for (offset,v) in [(0,first),(4,previous),(8,key),(12,value)] {write(b,add(node,offset)?,v)?;}
 let count=b.word(add(manager,8)?)?;if count>=0xffffffe {return Err(Error::CountLimit);}
 write(b,add(manager,8)?,count+1)?;write(b,add(first,4)?,node)?;let previous=b.word(add(node,4)?)?;write(b,previous,node)?;
 let current=b.word(head)?;sort_node(b,manager,current,0,hash)
}
pub fn insert_live<B:Storage+RemovalBackend>(b:&mut B,state:&mut init::State,constructor_byte:u8,key:u32,value:u32)->Result<Inserted,Error> {
 init::initialize(state,constructor_byte,b)?;insert(b,state.manager,key,value)
}
#[cfg(test)] mod tests {
 use super::*;use init::{OwnedMemory,State};
 fn compare_words(memory:&mut OwnedMemory,words:&serde_json::Value) {for w in words.as_array().unwrap() {assert_eq!(memory.word(w[0].as_u64().unwrap() as u32).unwrap(),w[1].as_u64().unwrap() as u32,"{w}");}}
 #[test] fn audio_registry_insertion_matches384_native_growth_insertions36_duplicates384_removals() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_registry_insertion_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),6);let mut inserted_count=0;let mut duplicate_count=0;let mut removal_count=0;
  for case in cases {
   let poison=case["poison"].as_u64().unwrap() as u8;let mut memory=OwnedMemory::new(0x34000000,poison);let mut state=State {shutdown_flag:1,..State::default()};init::initialize(&mut state,poison,&mut memory).unwrap();assert_eq!(state.manager,case["manager"].as_u64().unwrap() as u32);
   for step in case["steps"].as_array().unwrap() {
    memory.allocations.clear();memory.released_labels.clear();let actual=insert_live(&mut memory,&mut state,poison,step["key"].as_u64().unwrap() as u32,step["value"].as_u64().unwrap() as u32).unwrap();assert_eq!(actual,Inserted {node:step["node"].as_u64().unwrap() as u32,inserted:true},"{step}");
    let allocations:Vec<_>=memory.allocations.iter().map(|&(bytes,pointer)|serde_json::json!({"bytes":bytes,"pointer":pointer})).collect();assert_eq!(serde_json::json!(allocations),step["allocations"]);assert_eq!(serde_json::json!(memory.released_labels),step["freed"]);compare_words(&mut memory,&step["words"]);
    for q in step["lookups"].as_array().unwrap() {assert_eq!(lookup::lookup_initialized(&mut memory,state.manager,q["key"].as_u64().unwrap() as u32).unwrap(),q["value"].as_u64().unwrap() as u32);}
    inserted_count+=1;
   }
   for step in case["duplicate_steps"].as_array().unwrap() {
    memory.allocations.clear();memory.released_labels.clear();let actual=insert(&mut memory,state.manager,step["key"].as_u64().unwrap() as u32,step["supplied_value"].as_u64().unwrap() as u32).unwrap();assert_eq!(actual,Inserted {node:step["returned_node"].as_u64().unwrap() as u32,inserted:false});assert_eq!(memory.word(actual.node+12).unwrap(),step["retained_value"].as_u64().unwrap() as u32);assert_eq!(serde_json::json!(memory.released_labels),step["freed"]);assert_eq!(memory.word(state.manager+8).unwrap(),step["count"].as_u64().unwrap() as u32);duplicate_count+=1;
   }
   for step in case["removal_steps"].as_array().unwrap() {memory.released_labels.clear();let next=remove::remove_node(&mut memory,state.manager,step["node"].as_u64().unwrap() as u32).unwrap();assert_eq!(next,step["returned_next"].as_u64().unwrap() as u32);assert_eq!(serde_json::json!(memory.released_labels),step["freed"]);compare_words(&mut memory,&step["words"]);for q in step["lookups"].as_array().unwrap() {assert_eq!(lookup::lookup_initialized(&mut memory,state.manager,q["key"].as_u64().unwrap() as u32).unwrap(),q["value"].as_u64().unwrap() as u32);}removal_count+=1;}
  }assert_eq!((inserted_count,duplicate_count,removal_count),(384,36,384));
 }
}
pub(crate) fn sort_existing_node<B:Storage+RemovalBackend>(b:&mut B,manager:u32,node:u32)->Result<Inserted,Error> {sort_node(b,manager,node,0,lookup::Hash::Legacy)}
