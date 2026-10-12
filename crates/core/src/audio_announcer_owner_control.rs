//! Native5D1FA0 shared-owner replacement and1085F4C control virtual functions.
use crate::audio_announcer_object_lookup::{self as lookup,Memory};
use crate::audio_announcer_registry_init::{self as init,Storage};
use crate::audio_announcer_registry_remove::{self as remove,Backend as RemovalBackend};
use crate::audio_announcer_owner_component_destructor::ControlBoundary;
use std::sync::atomic::{AtomicU32,Ordering};
#[derive(Debug,PartialEq,Eq)]
pub enum Error {Context(lookup::Error),Storage(init::Error),Release(remove::Error),Boundary(&'static str),UnknownScalarCallback(u32),AddressOverflow}
impl From<lookup::Error> for Error {fn from(e:lookup::Error)->Self {Self::Context(e)}}
impl From<init::Error> for Error {fn from(e:init::Error)->Self {Self::Storage(e)}}
impl From<remove::Error> for Error {fn from(e:remove::Error)->Self {Self::Release(e)}}
fn add(a:u32,b:u32)->Result<u32,Error> {a.checked_add(b).ok_or(Error::AddressOverflow)}
pub const VTABLE:u32=0x1085f4c;
pub const DISPOSE:u32=0x5a3220;
pub const RELEASE:u32=0x5d5b40;
pub const SCALAR_DELETE:u32=0x5d6840;
/// Persistent shared native counters; SeqCst preserves locked-XADD ordering.
/// This does not own the object or grant permission to read already-released bytes.
pub struct Counts {strong:AtomicU32,weak:AtomicU32}
impl Counts {
 pub fn new(strong:u32,weak:u32)->Self {Self {strong:AtomicU32::new(strong),weak:AtomicU32::new(weak)}}
 pub fn increment(&self,offset:u32)->Result<u32,&'static str> {match offset {4=>Ok(self.strong.fetch_add(1,Ordering::SeqCst)),8=>Ok(self.weak.fetch_add(1,Ordering::SeqCst)),_=>Err("unknown reference count offset")}}
 pub fn decrement(&self,offset:u32)->Result<u32,&'static str> {match offset {4=>Ok(self.strong.fetch_sub(1,Ordering::SeqCst)),8=>Ok(self.weak.fetch_sub(1,Ordering::SeqCst)),_=>Err("unknown reference count offset")}}
 pub fn read(&self,offset:u32)->Result<u32,&'static str> {match offset {4=>Ok(self.strong.load(Ordering::SeqCst)),8=>Ok(self.weak.load(Ordering::SeqCst)),_=>Err("unknown reference count offset")}}
}
/// Allocate before reading the old control; publish new control before raw object.
/// Native null allocation still releases old control and publishes (object,0).
pub fn replace_pair<B:Storage+ControlBoundary>(memory:&mut B,pair:u32,object:u32)->Result<(),Error> {
 replace_pair_with_vtable(memory,pair,object,VTABLE)
}
/// Identical normal-return factory body used by native5D1FA0 and9019A0.
pub(crate) fn replace_pair_with_vtable<B:Storage+ControlBoundary>(memory:&mut B,pair:u32,object:u32,vtable:u32)->Result<(),Error> {
 let new=memory.allocate(16)?;
 if new!=0 {for (offset,value) in [(4,1),(8,1),(0,vtable),(12,object)] {Storage::write_word(memory,add(new,offset)?,value)?;}}
 let old=memory.word(add(pair,4)?)?;
 if old!=0 && memory.decrement_reference(add(old,4)?).map_err(Error::Boundary)?==1 {
  let vtable=memory.word(old)?;let callback=memory.word(vtable)?;memory.dispose(old,callback).map_err(Error::Boundary)?;
  if memory.decrement_reference(add(old,8)?).map_err(Error::Boundary)?==1 {let vtable=memory.word(old)?;let callback=memory.word(add(vtable,4)?)?;memory.release_control(old,callback).map_err(Error::Boundary)?;}
 }
 Storage::write_word(memory,add(pair,4)?,new)?;Storage::write_word(memory,pair,object)?;Ok(())
}
pub trait ObjectBoundary {fn scalar_delete_object(&mut self,object:u32,callback:u32,flags:u32)->Result<(),&'static str>;}
/// Actual5A3220: null raw object skips dispatch, nonnull uses its current vtable slot0.
pub fn dispose<B:Memory+ObjectBoundary>(memory:&mut B,control:u32)->Result<(),Error> {
 let object=memory.word(add(control,12)?)?;if object!=0 {let vtable=memory.word(object)?;let callback=memory.word(vtable)?;memory.scalar_delete_object(object,callback,1).map_err(Error::Boundary)?;}Ok(())
}
/// Actual5D6840 scalar delete. Header mutation precedes free-route selection.
pub fn scalar_delete<B:Storage+RemovalBackend>(memory:&mut B,control:u32,flags:u32)->Result<u32,Error> {
 Storage::write_word(memory,control,0x107c834)?;
 if flags&1!=0 {let route=memory.deallocator()?;memory.free(control,route)?;}Ok(control)
}
/// Actual5D5B40 dispatches current control slot8 with scalar-delete flag1.
/// Unknown control types are explicit errors; no unrelated virtual method is substituted.
pub fn release<B:Storage+RemovalBackend>(memory:&mut B,control:u32)->Result<(),Error> {
 if control!=0 {let vtable=memory.word(control)?;let callback=memory.word(add(vtable,8)?)?;if callback!=SCALAR_DELETE {return Err(Error::UnknownScalarCallback(callback));}scalar_delete(memory,control,1)?;}Ok(())
}
#[cfg(test)] mod tests {
 use super::*;use std::collections::BTreeMap;use std::sync::Arc;use crate::audio_announcer_owner_component_destructor as component;use crate::audio_announcer_secondary_registries::{self as secondary,Kind,Boundaries};
 struct Owned {memory:init::OwnedMemory,counts:BTreeMap<u32,Arc<Counts>>,virtual_calls:Vec<serde_json::Value>,object_calls:Vec<serde_json::Value>,locks:Vec<serde_json::Value>,fail:bool,custom:bool,routes:Vec<serde_json::Value>}
 impl Memory for Owned {fn word(&mut self,a:u32)->Result<u32,lookup::Error> {self.memory.word(a)}}
 impl Storage for Owned {
  fn allocate(&mut self,n:u32)->Result<u32,init::Error> {if self.fail && n==16 {self.memory.allocations.push((16,0));Ok(0)} else {self.memory.allocate(n)}}
  fn write_word(&mut self,a:u32,v:u32)->Result<(),init::Error> {Storage::write_word(&mut self.memory,a,v)}
  fn write_byte(&mut self,a:u32,v:u8)->Result<(),init::Error> {self.memory.write_byte(a,v)}
  fn register_shutdown(&mut self,c:u32)->Result<(),init::Error> {self.memory.register_shutdown(c)}
 }
 impl RemovalBackend for Owned {
  fn write_word(&mut self,a:u32,v:u32)->Result<(),remove::Error> {Storage::write_word(&mut self.memory,a,v).map_err(remove::Error::Owned)}
  fn deallocator(&mut self)->Result<remove::Deallocator,remove::Error> {Ok(if self.custom {remove::Deallocator::Custom {callback:0x32000f00,context:0x3000d000}} else {remove::Deallocator::Standard})}
  fn free(&mut self,a:u32,route:remove::Deallocator)->Result<(),remove::Error> {if let remove::Deallocator::Custom {context,..}=route {self.routes.push(serde_json::json!({"pointer":a,"context":context}));}self.memory.release(a).map_err(remove::Error::Owned)?;self.counts.remove(&a);Ok(())}
 }
 impl ControlBoundary for Owned {
  fn decrement_reference(&mut self,a:u32)->Result<u32,&'static str> {
   let (base,offset)=if self.counts.contains_key(&(a-4)) {(a-4,4)} else if self.counts.contains_key(&(a-8)) {(a-8,8)} else {
    // A strong decrement is always first for these native control lifetimes.
    let base=a.checked_sub(4).ok_or("invalid count address")?;let strong=self.memory.word(base+4).map_err(|_|"missing strong")?;let weak=self.memory.word(base+8).map_err(|_|"missing weak")?;self.counts.insert(base,Arc::new(Counts::new(strong,weak)));(base,4)
   };
   let counts=self.counts.get(&base).unwrap();let old=counts.decrement(offset)?;let value=counts.read(offset)?;Storage::write_word(&mut self.memory,a,value).map_err(|_|"missing count storage")?;Ok(old)
  }
  fn dispose(&mut self,c:u32,callback:u32)->Result<(),&'static str> {if callback==DISPOSE {dispose(self,c).map_err(|_|"raw object disposal failed")} else if callback==0x32000b00 {let strong=self.word(c+4).unwrap();let weak=self.word(c+8).unwrap();self.virtual_calls.push(serde_json::json!({"op":"dispose","strong":strong,"weak":weak}));Ok(())} else {Err("unknown disposal callback")}}
  fn release_control(&mut self,c:u32,callback:u32)->Result<(),&'static str> {if callback==RELEASE {release(self,c).map_err(|_|"control release failed")} else if callback==0x32000c00 {let strong=self.word(c+4).unwrap();let weak=self.word(c+8).unwrap();self.virtual_calls.push(serde_json::json!({"op":"release_control","strong":strong,"weak":weak}));Ok(())} else {Err("unknown control release callback")}}
 }
 impl ObjectBoundary for Owned {fn scalar_delete_object(&mut self,o:u32,callback:u32,flags:u32)->Result<(),&'static str> {assert_eq!(callback,0x32000e00);self.object_calls.push(serde_json::json!({"object":o,"flags":flags}));Ok(())}}
 impl Boundaries for Owned {
  fn diagnostic(&mut self,_:Kind,_:secondary::Diagnostic)->Result<(),&'static str> {Err("unexpected owner diagnostic")}
  fn enter(&mut self,_:Kind)->Result<(),&'static str> {self.locks.push(serde_json::json!({"op":"enter","object":0x2d5f4a0u32}));Ok(())}
  fn leave(&mut self,_:Kind)->Result<(),&'static str> {self.locks.push(serde_json::json!({"op":"leave","object":0x2d5f4a0u32}));Ok(())}
  fn allocate_owner_array(&mut self,n:u32)->Result<u32,init::Error> {self.memory.allocate(n*4)}
 }
 fn owned(poison:u8)->Owned {
  let mut b=Owned {memory:init::OwnedMemory::new(0x34000000,poison),counts:BTreeMap::new(),virtual_calls:vec![],object_calls:vec![],locks:vec![],fail:false,custom:false,routes:vec![]};
  for (label,size) in [(VTABLE,12),(0x30006500,16),(0x30006600,8),(0x30007000,0x34),(0x30007200,8),(0x30007300,4),(0x30004178,12),(0x30005600,4)] {b.memory.reserve_at(label,size).unwrap();}
  for (a,v) in [(VTABLE,DISPOSE),(VTABLE+4,RELEASE),(VTABLE+8,SCALAR_DELETE),(0x30006500,0x30006600),(0x30006600,0x32000b00),(0x30006604,0x32000c00),(0x30007000,0x30007300),(0x30007300,0x32000e00),(0x30007030,0x30005600)] {Storage::write_word(&mut b,a,v).unwrap();}b
 }
 fn compare(b:&mut Owned,words:&serde_json::Value) {for w in words.as_array().unwrap() {assert_eq!(b.word(w[0].as_u64().unwrap() as u32).unwrap(),w[1].as_u64().unwrap() as u32,"{w}");}}
 #[test] fn audio_owner_control_factory_matches104_native_replacements_and_null_allocations() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_owner_control_factory_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),104);
  for c in cases {
   let mut b=owned(c["poison"].as_u64().unwrap() as u8);let old=c["initial_control"].as_u64().unwrap_or(0) as u32;Storage::write_word(&mut b,0x30007200,0x30007777).unwrap();Storage::write_word(&mut b,0x30007204,old).unwrap();if old!=0 {Storage::write_word(&mut b,old+4,c["initial_strong"].as_u64().unwrap() as u32).unwrap();Storage::write_word(&mut b,old+8,c["initial_weak"].as_u64().unwrap() as u32).unwrap();}b.fail=c["fail_allocation"].as_bool().unwrap();
   replace_pair(&mut b,0x30007200,c["object"].as_u64().unwrap() as u32).unwrap();assert_eq!(b.word(0x30007200).unwrap(),c["pair_object"].as_u64().unwrap() as u32);assert_eq!(b.word(0x30007204).unwrap(),c["pair_control"].as_u64().unwrap() as u32);let allocations:Vec<_>=b.memory.allocations.iter().map(|&(bytes,pointer)|serde_json::json!({"bytes":bytes,"pointer":pointer})).collect();assert_eq!(serde_json::json!(allocations),c["allocations"]);assert_eq!(serde_json::json!(b.virtual_calls),c["virtual_calls"]);compare(&mut b,&c["new_control_words"]);compare(&mut b,&c["old_control_words"]);
  }
 }
 #[test] fn audio_owner_real_control_lifecycle_matches64_native_lifetimes_with_actual_control_free() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_owner_real_control_lifecycle_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),64);
  for c in cases {
   let poison=c["poison"].as_u64().unwrap() as u8;let mut b=owned(poison);let manager=0x2d5f470;let owner=c["owner_id"].as_u64().unwrap() as u32;let component=0x30004178;b.memory.reserve_at(manager,48).unwrap();init::construct_at(&mut b,manager,poison).unwrap();for offset in [36,40,44] {Storage::write_word(&mut b,manager+offset,0).unwrap();}Storage::write_word(&mut b,component+4,0).unwrap();Storage::write_word(&mut b,component+8,0).unwrap();Storage::write_word(&mut b,0x30005600,owner).unwrap();replace_pair(&mut b,component+4,0x30007000).unwrap();let control=b.word(component+8).unwrap();assert_eq!(control,c["control"].as_u64().unwrap() as u32);
   Storage::write_word(&mut b,control+4,c["strong"].as_u64().unwrap() as u32).unwrap();Storage::write_word(&mut b,control+8,c["weak"].as_u64().unwrap() as u32).unwrap();if owner!=u32::MAX {secondary::register(&mut b,manager,Kind::Owner,component,owner).unwrap();}compare(&mut b,&c["initial_words"]);b.memory.allocations.clear();b.memory.released_labels.clear();b.locks.clear();component::destroy(&mut b,manager,component,u32::MAX).unwrap();
   assert!(b.memory.allocations.is_empty());assert_eq!(serde_json::json!(b.object_calls),c["object_delete_calls"]);assert_eq!(serde_json::json!(b.memory.released_labels),c["freed"]);assert_eq!(serde_json::json!(b.locks),c["locks"]);assert_eq!(b.word(component+8).unwrap(),c["retained_component_control"].as_u64().unwrap() as u32);compare(&mut b,&c["words"]);compare(&mut b,&c["live_control_words"]);if c["control_freed"].as_bool().unwrap() {assert!(matches!(b.word(control),Err(lookup::Error::MissingWord(_))));}
  }
 }
 #[test] fn audio_owner_control_scalar_delete_matches36_native_flag_and_free_route_cases() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_owner_control_scalar_delete_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),36);
  for c in cases {
   let mut b=owned(c["poison"].as_u64().unwrap() as u8);Storage::write_word(&mut b,0x30007200,0).unwrap();Storage::write_word(&mut b,0x30007204,0).unwrap();replace_pair(&mut b,0x30007200,0x30007000).unwrap();let control=b.word(0x30007204).unwrap();b.memory.released_labels.clear();b.custom=c["custom_free"].as_bool().unwrap();assert_eq!(scalar_delete(&mut b,control,c["flags"].as_u64().unwrap() as u32).unwrap(),c["result"].as_u64().unwrap() as u32);assert_eq!(serde_json::json!(b.memory.released_labels),c["freed"]);assert_eq!(serde_json::json!(b.routes),c["custom_routes"]);compare(&mut b,&c["live_words"]);
  }
 }
 #[test] fn audio_native_shared_reference_counts_have_one_last_release_across8_threads_and_wrap_zero() {
  let counts=Arc::new(Counts::new(8,1));let disposals=Arc::new(AtomicU32::new(0));let releases=Arc::new(AtomicU32::new(0));std::thread::scope(|scope| {for _ in 0..8 {let counts=counts.clone();let disposals=disposals.clone();let releases=releases.clone();scope.spawn(move || {if counts.decrement(4).unwrap()==1 {disposals.fetch_add(1,Ordering::SeqCst);if counts.decrement(8).unwrap()==1 {releases.fetch_add(1,Ordering::SeqCst);}}});}});assert_eq!(counts.read(4),Ok(0));assert_eq!(counts.read(8),Ok(0));assert_eq!(disposals.load(Ordering::SeqCst),1);assert_eq!(releases.load(Ordering::SeqCst),1);let zero=Counts::new(0,0);assert_eq!(zero.decrement(4),Ok(0));assert_eq!(zero.read(4),Ok(u32::MAX));assert_eq!(zero.decrement(8),Ok(0));assert_eq!(zero.read(8),Ok(u32::MAX));assert_eq!(zero.decrement(12),Err("unknown reference count offset"));
 }
}
