//! Original secondary64C330 and owner6B5AB0 normal-return unregister.
//! Native checks key-node presence and actor-vector presence independently.
use crate::audio_announcer_object_lookup::{self as lookup,Hash};
use crate::audio_announcer_registry_init::{self as init,Storage};
use crate::audio_announcer_registry_remove::{self as remove,Backend as RemovalBackend};
use crate::audio_announcer_secondary_registries::{Kind,Diagnostic,Boundaries};
#[derive(Debug,PartialEq,Eq)]
pub enum Error {Lookup(lookup::Error),Storage(init::Error),Removal(remove::Error),Boundary(&'static str),Shutdown(crate::audio_announcer_registry_shutdown::Error),InvalidVector,AddressOverflow}
impl From<lookup::Error> for Error {fn from(e:lookup::Error)->Self {Self::Lookup(e)}}
impl From<init::Error> for Error {fn from(e:init::Error)->Self {Self::Storage(e)}}
impl From<remove::Error> for Error {fn from(e:remove::Error)->Self {Self::Removal(e)}}
pub const NOT_FOUND:u32=u32::MAX;
fn add(a:u32,b:u32)->Result<u32,Error> {a.checked_add(b).ok_or(Error::AddressOverflow)}
/// Returns the erased vector index or nativeFFFFFFFF when either lookup fails.
/// Actor values are borrowed; only the table node is freed. No actor-value/key consistency guard is invented.
pub fn unregister<B:Storage+RemovalBackend+Boundaries>(b:&mut B,manager:u32,kind:Kind,actor:u32,key:u32)->Result<u32,Error> {
 if actor==0 {b.diagnostic(kind,Diagnostic::NullActor).map_err(Error::Boundary)?;}
 let node=lookup::lookup_node_with_hash(b,manager,key,Hash::Identity)?;
 let vector=add(manager,36)?;let begin=b.word(vector)?;let end=b.word(add(vector,4)?)?;
 if end<begin || (end-begin)%4!=0 {return Err(Error::InvalidVector);}
 let mut position=begin;
 while position!=end {if b.word(position)?==actor {break;}position=add(position,4)?;}
 let Some(node)=node else {return Ok(NOT_FOUND);};if position==end {return Ok(NOT_FOUND);}
 b.enter(kind).map_err(Error::Boundary)?;
 remove::remove_node_with_hash(b,manager,node,Hash::Identity)?;
 let end=b.word(add(vector,4)?)?;let next=add(position,4)?;let fresh_begin=b.word(vector)?;
 if end<next || position<fresh_begin || (end-next)%4!=0 || (position-fresh_begin)%4!=0 {return Err(Error::InvalidVector);}
 for offset in (0..end-next).step_by(4) {let value=b.word(add(next,offset)?)?;Storage::write_word(b,add(position,offset)?,value)?;}
 let fresh_end=b.word(add(vector,4)?)?;Storage::write_word(b,add(vector,4)?,fresh_end.checked_sub(4).ok_or(Error::InvalidVector)?)?;
 b.leave(kind).map_err(Error::Boundary)?;Ok((position-fresh_begin)/4)
}
pub trait TeardownBoundary {
 fn delete_critical_section(&mut self,kind:Kind,address:u32)->Result<(),&'static str>;
}
/// One-shot64C400/6B5B80 teardown of initialized global tables.
/// Native sentinel label remains after release; callers must not reuse this table.
/// Fixed manager storage is retained, and borrowed actor labels are never freed.
pub fn teardown<B:Storage+RemovalBackend+TeardownBoundary>(b:&mut B,manager:u32,kind:Kind)->Result<(),Error> {
 b.delete_critical_section(kind,add(manager,56)?).map_err(Error::Boundary)?;
 let vector=add(manager,36)?;let begin=b.word(vector)?;
 if begin!=0 {let route=b.deallocator()?;b.free(begin,route)?;for offset in [0,4,8] {Storage::write_word(b,add(vector,offset)?,0)?;}}
 crate::audio_announcer_registry_shutdown::destroy_table(b,manager).map_err(Error::Shutdown)
}
#[cfg(test)] mod tests {
 use super::*;use lookup::Memory;use init::OwnedMemory;use crate::audio_announcer_secondary_registries as secondary;
 struct Owned {memory:OwnedMemory,locks:Vec<serde_json::Value>,diagnostics:Vec<serde_json::Value>,fail_free:bool,deleted:Vec<u32>,custom:bool,routes:Vec<serde_json::Value>}
 impl Memory for Owned {fn word(&mut self,a:u32)->Result<u32,lookup::Error> {self.memory.word(a)}}
 impl Storage for Owned {
  fn allocate(&mut self,n:u32)->Result<u32,init::Error> {self.memory.allocate(n)}
  fn write_word(&mut self,a:u32,v:u32)->Result<(),init::Error> {Storage::write_word(&mut self.memory,a,v)}
  fn write_byte(&mut self,a:u32,v:u8)->Result<(),init::Error> {self.memory.write_byte(a,v)}
  fn register_shutdown(&mut self,c:u32)->Result<(),init::Error> {self.memory.register_shutdown(c)}
 }
 impl RemovalBackend for Owned {
  fn write_word(&mut self,a:u32,v:u32)->Result<(),remove::Error> {Storage::write_word(&mut self.memory,a,v).map_err(remove::Error::Owned)}
  fn deallocator(&mut self)->Result<remove::Deallocator,remove::Error> {Ok(if self.custom {remove::Deallocator::Custom {callback:0x32000a00,context:0x3000d000}} else {remove::Deallocator::Standard})}
  fn free(&mut self,n:u32,route:remove::Deallocator)->Result<(),remove::Error> {if self.fail_free {return Err(remove::Error::Backend("free boundary failed"));}if let remove::Deallocator::Custom {context,..}=route {self.routes.push(serde_json::json!({"pointer":n,"context":context}));}self.memory.release(n).map_err(remove::Error::Owned)}
 }
 impl Boundaries for Owned {
  fn diagnostic(&mut self,_:Kind,d:Diagnostic)->Result<(),&'static str> {if d!=Diagnostic::NullActor {return Err("unexpected threshold diagnostic");}self.diagnostics.push(serde_json::json!([17409852,17324845,0,17324845,17324845]));Ok(())}
  fn enter(&mut self,k:Kind)->Result<(),&'static str> {self.locks.push(serde_json::json!({"op":"enter","object":if k==Kind::Secondary {0x2110a40u32} else {0x2d5f4a0u32}}));Ok(())}
  fn leave(&mut self,k:Kind)->Result<(),&'static str> {self.locks.push(serde_json::json!({"op":"leave","object":if k==Kind::Secondary {0x2110a40u32} else {0x2d5f4a0u32}}));Ok(())}
  fn allocate_owner_array(&mut self,n:u32)->Result<u32,init::Error> {self.memory.allocate(n*4)}
 }
 impl TeardownBoundary for Owned {fn delete_critical_section(&mut self,_:Kind,address:u32)->Result<(),&'static str> {self.deleted.push(address);Ok(())}}
 fn owned(poison:u8,manager:u32)->Owned {let mut b=Owned {memory:OwnedMemory::new(0x34000000,poison),locks:vec![],diagnostics:vec![],fail_free:false,deleted:vec![],custom:false,routes:vec![]};b.memory.reserve_at(manager,48).unwrap();init::construct_at(&mut b,manager,poison).unwrap();for offset in [36,40,44] {Storage::write_word(&mut b,manager+offset,0).unwrap();}b}
 fn compare(b:&mut Owned,words:&serde_json::Value) {for w in words.as_array().unwrap() {assert_eq!(b.word(w[0].as_u64().unwrap() as u32).unwrap(),w[1].as_u64().unwrap() as u32,"{w}");}}
 #[test] fn audio_secondary_owner_unregister_matches332_native_calls16_lifetimes() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_secondary_unregister_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),16);let mut calls=0;
  for c in cases {
   let manager=c["manager"].as_u64().unwrap() as u32;let kind=if c["kind"]=="secondary" {Kind::Secondary} else {Kind::Owner};let mut b=owned(c["poison"].as_u64().unwrap() as u8,manager);
   for seed in c["seed"].as_array().unwrap() {secondary::register(&mut b,manager,kind,seed[1].as_u64().unwrap() as u32,seed[0].as_u64().unwrap() as u32).unwrap();}compare(&mut b,&c["initial_words"]);
   for step in c["steps"].as_array().unwrap() {
    b.locks.clear();b.diagnostics.clear();b.memory.released_labels.clear();b.memory.allocations.clear();
    assert_eq!(unregister(&mut b,manager,kind,step["actor"].as_u64().unwrap() as u32,step["key"].as_u64().unwrap() as u32).unwrap(),step["result"].as_u64().unwrap() as u32,"{step}");
    assert_eq!(serde_json::json!(b.locks),step["locks"]);assert_eq!(serde_json::json!(b.diagnostics),step["diagnostics"]);assert_eq!(serde_json::json!(b.memory.released_labels),step["freed"]);assert!(b.memory.allocations.is_empty());compare(&mut b,&step["words"]);calls+=1;
   }
  }assert_eq!(calls,332);
 }
 #[test] fn audio_unregister_failed_free_preserves_unlink_before_pending_vector_erase() {
  let manager=0x2110a10;let actor=0x30004000;let mut b=owned(0,manager);secondary::register(&mut b,manager,Kind::Secondary,actor,77).unwrap();let vector=b.word(manager+36).unwrap();let end=b.word(manager+40).unwrap();b.fail_free=true;b.locks.clear();
  assert_eq!(unregister(&mut b,manager,Kind::Secondary,actor,77),Err(Error::Removal(remove::Error::Backend("free boundary failed"))));assert_eq!(b.word(manager+8).unwrap(),0);assert_eq!(lookup::lookup_node_with_hash(&mut b,manager,77,Hash::Identity).unwrap(),None);assert_eq!(b.word(manager+40).unwrap(),end);assert_eq!(b.word(vector).unwrap(),actor);assert_eq!(b.locks.len(),1);
 }

 #[test] fn audio_secondary_owner_teardown_matches32_native_lifetimes744_frees() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_secondary_teardown_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),32);let mut freed=0;
  for c in cases {
   let manager=c["manager"].as_u64().unwrap() as u32;let kind=if c["kind"]=="secondary" {Kind::Secondary} else {Kind::Owner};let mut b=owned(c["poison"].as_u64().unwrap() as u8,manager);
   for key in 0..c["count"].as_u64().unwrap() as u32 {secondary::register(&mut b,manager,kind,0x30004000+key*0x200,key*8).unwrap();}
   b.memory.allocations.clear();b.memory.released_labels.clear();b.custom=c["custom_free"].as_bool().unwrap();teardown(&mut b,manager,kind).unwrap();
   assert!(b.memory.allocations.is_empty());assert_eq!(serde_json::json!(b.deleted),c["deleted_critical_sections"]);assert_eq!(serde_json::json!(b.memory.released_labels),c["freed"]);assert_eq!(serde_json::json!(b.routes),c["custom_routes"]);compare(&mut b,&c["words"]);
   let head=b.word(manager+4).unwrap();assert!(matches!(b.word(head),Err(lookup::Error::MissingWord(_))));assert_eq!(secondary::query(&mut b,manager,kind,0),Err(secondary::Error::Lookup(lookup::Error::InvalidLayout)));freed+=b.memory.released_labels.len();
  }assert_eq!(freed,744);
 }
}
