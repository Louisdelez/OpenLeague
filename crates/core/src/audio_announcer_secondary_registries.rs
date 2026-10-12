//! Normal-return secondary64C270 and owner6B59F0 registration, on initialized tables.
//! Primitive lock, diagnostic and owner-array allocator boundaries remain explicit.
use crate::audio_announcer_object_lookup::{self as lookup,Memory,Hash};
use crate::audio_announcer_registry_init::{self as init,Storage};
use crate::audio_announcer_registry_insert as insert;
use crate::audio_announcer_registry_remove::{self as remove,Backend as RemovalBackend};
#[derive(Debug,PartialEq,Eq)]
pub enum Error {Lookup(lookup::Error),Storage(init::Error),Insert(insert::Error),Release(remove::Error),Boundary(&'static str),InvalidVector,AddressOverflow,NullAllocation}
impl From<lookup::Error> for Error {fn from(e:lookup::Error)->Self {Self::Lookup(e)}}
impl From<init::Error> for Error {fn from(e:init::Error)->Self {Self::Storage(e)}}
impl From<insert::Error> for Error {fn from(e:insert::Error)->Self {Self::Insert(e)}}
impl From<remove::Error> for Error {fn from(e:remove::Error)->Self {Self::Release(e)}}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Kind {Secondary,Owner}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Diagnostic {NullActor,CountThreshold}
pub trait Boundaries {
 fn diagnostic(&mut self,kind:Kind,event:Diagnostic)->Result<(),&'static str>;
 fn enter(&mut self,kind:Kind)->Result<(),&'static str>;
 fn leave(&mut self,kind:Kind)->Result<(),&'static str>;
 /// Original5CC6B0 engine allocation, measured in pointer words.
 fn allocate_owner_array(&mut self,words:u32)->Result<u32,init::Error>;
}
fn add(a:u32,b:u32)->Result<u32,Error> {a.checked_add(b).ok_or(Error::AddressOverflow)}
fn write<B:Storage>(b:&mut B,a:u32,v:u32)->Result<(),Error> {Storage::write_word(b,a,v)?;Ok(())}
pub fn query<B:Storage+Boundaries>(b:&mut B,manager:u32,kind:Kind,key:u32)->Result<u32,Error> {
 if b.word(add(manager,8)?)?>=10000 {b.diagnostic(kind,Diagnostic::CountThreshold).map_err(Error::Boundary)?;}
 match lookup::lookup_node_with_hash(b,manager,key,Hash::Identity)? {Some(n)=>Ok(b.word(add(n,12)?)?),None=>Ok(0)}
}
fn append<B:Storage+RemovalBackend+Boundaries>(b:&mut B,vector:u32,kind:Kind,actor:u32)->Result<(),Error> {
 let begin=b.word(vector)?;let end=b.word(add(vector,4)?)?;let cap=b.word(add(vector,8)?)?;
 if end<begin || cap<end || (end-begin)%4!=0 || (cap-begin)%4!=0 {return Err(Error::InvalidVector);}
 let mut destination=end;
 if end==cap {
  let size=(end-begin)/4;let capacity=(cap-begin)/4;let needed=size.checked_add(1).ok_or(Error::AddressOverflow)?;
  if needed>0x3fffffff {return Err(Error::InvalidVector);}
  let half=capacity>>1;let growth=if capacity>0x3fffffff-half {0} else {capacity+half};let words=growth.max(needed);let bytes=words.checked_mul(4).ok_or(Error::AddressOverflow)?;
  let new=match kind {Kind::Secondary=>b.allocate(bytes)?,Kind::Owner=>b.allocate_owner_array(words)?};
  if new==0 {return Err(Error::NullAllocation);}
  for i in 0..size {let value=b.word(add(begin,i*4)?)?;write(b,add(new,i*4)?,value)?;}
  if begin!=0 {let route=b.deallocator()?;b.free(begin,route)?;}
  write(b,vector,new)?;write(b,add(vector,8)?,add(new,bytes)?)?;destination=add(new,size*4)?;write(b,add(vector,4)?,destination)?;
 }
 write(b,destination,actor)?;write(b,add(vector,4)?,add(destination,4)?)?;Ok(())
}
/// Returns the native low byte only; upper EAX bits have no established contract.
/// Error paths retain preceding mutations and do not claim native exception unwinding.
pub fn register<B:Storage+RemovalBackend+Boundaries>(b:&mut B,manager:u32,kind:Kind,actor:u32,key:u32)->Result<u8,Error> {
 if actor==0 {b.diagnostic(kind,Diagnostic::NullActor).map_err(Error::Boundary)?;}
 if query(b,manager,kind,key)?!=0 {return Ok(0);}
 b.enter(kind).map_err(Error::Boundary)?;
 let node=match lookup::lookup_node_with_hash(b,manager,key,Hash::Identity)? {Some(n)=>n,None=>insert::insert_with_hash(b,manager,key,0,Hash::Identity)?.node};
 write(b,add(node,12)?,actor)?;append(b,add(manager,36)?,kind,actor)?;
 b.leave(kind).map_err(Error::Boundary)?;Ok(1)
}
#[cfg(test)] mod tests {
 use super::*;use std::collections::BTreeMap;use init::OwnedMemory;
 struct Backend {global:BTreeMap<u32,u32>,heap:OwnedMemory,locks:Vec<serde_json::Value>,diagnostics:Vec<Diagnostic>,owner_arrays:Vec<u32>}
 impl Memory for Backend {fn word(&mut self,a:u32)->Result<u32,lookup::Error> {if let Some(v)=self.global.get(&a) {Ok(*v)} else {self.heap.word(a)}}}
 impl Storage for Backend {
  fn allocate(&mut self,n:u32)->Result<u32,init::Error> {self.heap.allocate(n)}
  fn write_word(&mut self,a:u32,v:u32)->Result<(),init::Error> {if let Some(w)=self.global.get_mut(&a) {*w=v;Ok(())} else {Storage::write_word(&mut self.heap,a,v)}}
  fn write_byte(&mut self,a:u32,v:u8)->Result<(),init::Error> {if let Some(w)=self.global.get_mut(&a) {*w=(*w&0xffffff00)|u32::from(v);Ok(())} else {self.heap.write_byte(a,v)}}
  fn register_shutdown(&mut self,c:u32)->Result<(),init::Error> {self.heap.register_shutdown(c)}
 }
 impl RemovalBackend for Backend {
  fn write_word(&mut self,a:u32,v:u32)->Result<(),remove::Error> {Storage::write_word(self,a,v).map_err(remove::Error::Owned)}
  fn deallocator(&mut self)->Result<remove::Deallocator,remove::Error> {Ok(remove::Deallocator::Standard)}
  fn free(&mut self,n:u32,_:remove::Deallocator)->Result<(),remove::Error> {self.heap.release(n).map_err(remove::Error::Owned)}
 }
 impl Boundaries for Backend {
  fn diagnostic(&mut self,_:Kind,e:Diagnostic)->Result<(),&'static str> {self.diagnostics.push(e);Ok(())}
  fn enter(&mut self,k:Kind)->Result<(),&'static str> {self.locks.push(serde_json::json!({"op":"enter","object":if k==Kind::Secondary {0x2110a40u32} else {0x2d5f4a0u32}}));Ok(())}
  fn leave(&mut self,k:Kind)->Result<(),&'static str> {self.locks.push(serde_json::json!({"op":"leave","object":if k==Kind::Secondary {0x2110a40u32} else {0x2d5f4a0u32}}));Ok(())}
  fn allocate_owner_array(&mut self,n:u32)->Result<u32,init::Error> {let p=self.heap.allocate(n*4)?;self.owner_arrays.push(p);Ok(p)}
 }
 #[test] fn audio_secondary_owner_registrations_match288_native_calls144_sequences() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_secondary_owner_registries_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),144);let mut calls=0;
  for c in cases {
   let manager=c["manager"].as_u64().unwrap() as u32;let poison=c["poison"].as_u64().unwrap() as u8;let key=c["key"].as_u64().unwrap() as u32;let actor=c["actor"].as_u64().unwrap() as u32;let kind=if c["kind"]=="secondary" {Kind::Secondary} else {Kind::Owner};
   let mut b=Backend {global:(0..48).step_by(4).map(|i|(manager+i,0)).collect(),heap:OwnedMemory::new(0x34000000,poison),locks:vec![],diagnostics:vec![],owner_arrays:vec![]};
   init::construct_at(&mut b,manager,poison).unwrap();
   if let Some(prior)=c["prior"].as_u64() {insert::insert_with_hash(&mut b,manager,key,prior as u32,Hash::Identity).unwrap();}
   for step in c["steps"].as_array().unwrap() {
    b.heap.allocations.clear();b.heap.released_labels.clear();b.locks.clear();b.diagnostics.clear();b.owner_arrays.clear();
    assert_eq!(query(&mut b,manager,kind,key).unwrap(),step["before"].as_u64().unwrap() as u32);
    assert_eq!(register(&mut b,manager,kind,actor,key).unwrap(),step["return_low_byte"].as_u64().unwrap() as u8);
    assert_eq!(query(&mut b,manager,kind,key).unwrap(),step["after"].as_u64().unwrap() as u32);
    assert_eq!(serde_json::json!(b.locks),step["locks"]);assert_eq!(b.diagnostics,if actor==0 {vec![Diagnostic::NullActor]} else {vec![]});
    let allocations:Vec<_>=b.heap.allocations.iter().map(|&(bytes,pointer)| {let mut a=serde_json::json!({"bytes":bytes,"pointer":pointer});if b.owner_arrays.contains(&pointer) {a["allocator"]=serde_json::json!("owner_pointer_array");}a}).collect();
    assert_eq!(serde_json::json!(allocations),step["allocations"],"{c}");assert_eq!(serde_json::json!(b.heap.released_labels),step["freed"]);
    for w in step["words"].as_array().unwrap() {assert_eq!(b.word(w[0].as_u64().unwrap() as u32).unwrap(),w[1].as_u64().unwrap() as u32,"{c}");}calls+=1;
   }
  }assert_eq!(calls,288);
 }

 #[test] fn audio_secondary_owner_growth_matches384_registrations_and48_threshold_queries() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_secondary_growth_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),8);let mut calls=0;let mut queries=0;
  for (index,c) in cases.iter().enumerate() {
   let manager=c["manager"].as_u64().unwrap() as u32;let poison=c["poison"].as_u64().unwrap() as u8;let kind=if c["kind"]=="secondary" {Kind::Secondary} else {Kind::Owner};
   let mut b=Backend {global:(0..48).step_by(4).map(|i|(manager+i,0)).collect(),heap:OwnedMemory::new(0x34000000,poison),locks:vec![],diagnostics:vec![],owner_arrays:vec![]};init::construct_at(&mut b,manager,poison).unwrap();
   for step in c["steps"].as_array().unwrap() {
    let key=step["key"].as_u64().unwrap() as u32;let actor=step["actor"].as_u64().unwrap() as u32;
    b.heap.allocations.clear();b.heap.released_labels.clear();b.locks.clear();b.diagnostics.clear();b.owner_arrays.clear();
    assert_eq!(query(&mut b,manager,kind,key).unwrap(),step["before"].as_u64().unwrap() as u32);
    assert_eq!(register(&mut b,manager,kind,actor,key).unwrap(),step["return_low_byte"].as_u64().unwrap() as u8);
    assert_eq!(query(&mut b,manager,kind,key).unwrap(),step["after"].as_u64().unwrap() as u32);
    assert_eq!(serde_json::json!(b.locks),step["locks"]);assert!(b.diagnostics.is_empty());assert!(step["diagnostics"].as_array().unwrap().is_empty());
    let allocations:Vec<_>=b.heap.allocations.iter().map(|&(bytes,pointer)| {let mut a=serde_json::json!({"bytes":bytes,"pointer":pointer});if b.owner_arrays.contains(&pointer) {a["allocator"]=serde_json::json!("owner_pointer_array");}a}).collect();
    assert_eq!(serde_json::json!(allocations),step["allocations"],"case {index} key {key}");assert_eq!(serde_json::json!(b.heap.released_labels),step["freed"]);
    for w in step["words"].as_array().unwrap() {assert_eq!(b.word(w[0].as_u64().unwrap() as u32).unwrap(),w[1].as_u64().unwrap() as u32,"case {index} key {key}, word {w}");}calls+=1;
   }
   for t in proof["thresholds"].as_array().unwrap().iter().filter(|t|t["case"].as_u64().unwrap() as usize==index) {
    let count=t["count"].as_u64().unwrap() as u32;Storage::write_word(&mut b,manager+8,count).unwrap();b.diagnostics.clear();
    assert_eq!(query(&mut b,manager,kind,t["key"].as_u64().unwrap() as u32).unwrap(),t["value"].as_u64().unwrap() as u32);
    assert_eq!(b.diagnostics,if count>=10000 {vec![Diagnostic::CountThreshold]} else {vec![]});assert_eq!(b.diagnostics.len(),t["diagnostics"].as_array().unwrap().len());queries+=1;
   }
  }assert_eq!((calls,queries),(384,48));
 }
}
