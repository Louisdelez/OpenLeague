//! Complete6B2B20 owner-component normal-return destruction.
//! Atomic decrement and virtual disposal/control-release are explicit runtime primitives.
use crate::audio_announcer_object_lookup as lookup;
use crate::audio_announcer_registry_init::{self as init,Storage};
use crate::audio_announcer_registry_remove::Backend as RemovalBackend;
use crate::audio_announcer_secondary_registries::{self as secondary,Kind,Boundaries};
use crate::audio_announcer_secondary_unregister as unregister;
#[derive(Debug,PartialEq,Eq)]
pub enum Error {Context(lookup::Error),Query(secondary::Error),Unregister(unregister::Error),Boundary(&'static str),AddressOverflow}
impl From<lookup::Error> for Error {fn from(e:lookup::Error)->Self {Self::Context(e)}}
pub trait ControlBoundary {
 /// Must atomically subtract1 with wrapping32-bit arithmetic and return the old value.
 fn decrement_reference(&mut self,address:u32)->Result<u32,&'static str>;
 fn dispose(&mut self,control:u32,callback:u32)->Result<(),&'static str>;
 fn release_control(&mut self,control:u32,callback:u32)->Result<(),&'static str>;
}
fn add(a:u32,b:u32)->Result<u32,Error> {a.checked_add(b).ok_or(Error::AddressOverflow)}
pub fn destroy<B:Storage+RemovalBackend+Boundaries+ControlBoundary>(memory:&mut B,owner_table:u32,component:u32,invalid_owner:u32)->Result<(),Error> {
 let metadata=memory.word(add(component,4)?)?;let owner_storage=memory.word(add(metadata,0x30)?)?;let owner=memory.word(owner_storage)?;
 if owner!=invalid_owner {
  let owner_storage=memory.word(add(metadata,0x30)?)?;let fresh_owner=memory.word(owner_storage)?;
  if secondary::query(memory,owner_table,Kind::Owner,fresh_owner).map_err(Error::Query)?!=0 {
   let metadata=memory.word(add(component,4)?)?;let owner_storage=memory.word(add(metadata,0x30)?)?;let fresh_owner=memory.word(owner_storage)?;
   unregister::unregister(memory,owner_table,Kind::Owner,component,fresh_owner).map_err(Error::Unregister)?;
  }
 }
 // Reload only after unregister callbacks; retain this selected control across virtual dispose.
 let control=memory.word(add(component,8)?)?;
 if control!=0 && memory.decrement_reference(add(control,4)?).map_err(Error::Boundary)?==1 {
  let vtable=memory.word(control)?;let callback=memory.word(vtable)?;memory.dispose(control,callback).map_err(Error::Boundary)?;
  if memory.decrement_reference(add(control,8)?).map_err(Error::Boundary)?==1 {
   let vtable=memory.word(control)?;let callback=memory.word(add(vtable,4)?)?;memory.release_control(control,callback).map_err(Error::Boundary)?;
  }
 }
 Ok(())
}
#[cfg(test)] mod tests {
 use super::*;use lookup::{Memory,Hash};use init::OwnedMemory;use crate::audio_announcer_registry_insert as insert;use crate::audio_announcer_registry_remove as remove;
 struct Owned {memory:OwnedMemory,locks:Vec<serde_json::Value>,calls:Vec<serde_json::Value>,fail_dispose:bool,mutation:Option<(String,u32)>}
 impl Memory for Owned {fn word(&mut self,a:u32)->Result<u32,lookup::Error> {self.memory.word(a)}}
 impl Storage for Owned {
  fn allocate(&mut self,n:u32)->Result<u32,init::Error> {self.memory.allocate(n)}
  fn write_word(&mut self,a:u32,v:u32)->Result<(),init::Error> {Storage::write_word(&mut self.memory,a,v)}
  fn write_byte(&mut self,a:u32,v:u8)->Result<(),init::Error> {self.memory.write_byte(a,v)}
  fn register_shutdown(&mut self,c:u32)->Result<(),init::Error> {self.memory.register_shutdown(c)}
 }
 impl RemovalBackend for Owned {
  fn write_word(&mut self,a:u32,v:u32)->Result<(),remove::Error> {Storage::write_word(&mut self.memory,a,v).map_err(remove::Error::Owned)}
  fn deallocator(&mut self)->Result<remove::Deallocator,remove::Error> {Ok(remove::Deallocator::Standard)}
  fn free(&mut self,n:u32,_:remove::Deallocator)->Result<(),remove::Error> {self.memory.release(n).map_err(remove::Error::Owned)?;if self.mutation.as_ref().is_some_and(|(mode,_)|mode=="free_control") {Storage::write_word(&mut self.memory,0x30004180,0x30006800).map_err(remove::Error::Owned)?;}Ok(())}
 }
 impl Boundaries for Owned {
  fn diagnostic(&mut self,_:Kind,_:secondary::Diagnostic)->Result<(),&'static str> {Err("unexpected owner diagnostic")}
  fn enter(&mut self,_:Kind)->Result<(),&'static str> {self.locks.push(serde_json::json!({"op":"enter","object":0x2d5f4a0u32}));Ok(())}
  fn leave(&mut self,_:Kind)->Result<(),&'static str> {if self.mutation.as_ref().is_some_and(|(mode,_)|mode=="leave_control") {Storage::write_word(&mut self.memory,0x30004180,0x30006800).map_err(|_|"mutation storage unavailable")?;}self.locks.push(serde_json::json!({"op":"leave","object":0x2d5f4a0u32}));Ok(())}
  fn allocate_owner_array(&mut self,n:u32)->Result<u32,init::Error> {self.memory.allocate(n*4)}
 }
 impl ControlBoundary for Owned {
  // Sequential primitive adapter only; this fixture backend does not prove live atomic synchronization.
  fn decrement_reference(&mut self,a:u32)->Result<u32,&'static str> {let old=self.memory.word(a).map_err(|_|"missing reference count")?;Storage::write_word(&mut self.memory,a,old.wrapping_sub(1)).map_err(|_|"missing count storage")?;Ok(old)}
  fn dispose(&mut self,c:u32,callback:u32)->Result<(),&'static str> {assert_eq!(callback,0x32000b00);let strong=self.word(c+4).unwrap();let weak=self.word(c+8).unwrap();self.calls.push(if self.mutation.is_some() {serde_json::json!({"op":"dispose","control":c,"callback":callback,"strong":strong,"weak":weak})} else {serde_json::json!({"op":"dispose","strong":strong,"weak":weak})});if let Some((mode,value))=self.mutation.clone() {let change=match mode.as_str() {"dispose_weak"=>Some((c+8,value)),"dispose_vtable"=>Some((c,0x30006900)),"dispose_component_control"=>Some((0x30004180,0x30006800)),_=>None};if let Some((address,value))=change {Storage::write_word(&mut self.memory,address,value).map_err(|_|"mutation storage unavailable")?;}}if self.fail_dispose {Err("dispose failed")} else {Ok(())}}
  fn release_control(&mut self,c:u32,callback:u32)->Result<(),&'static str> {assert!(callback==0x32000c00 || (self.mutation.is_some() && callback==0x32000d00));let strong=self.word(c+4).unwrap();let weak=self.word(c+8).unwrap();self.calls.push(if self.mutation.is_some() {serde_json::json!({"op":"release_control","control":c,"callback":callback,"strong":strong,"weak":weak})} else {serde_json::json!({"op":"release_control","strong":strong,"weak":weak})});Ok(())}
 }
 fn setup(poison:u8)->Owned {
  let mut b=Owned {memory:OwnedMemory::new(0x34000000,poison),locks:vec![],calls:vec![],fail_dispose:false,mutation:None};
  for (label,bytes) in [(0x2d5f470,48),(0x30004178,12),(0x30005500,0x34),(0x30005600,4),(0x30006500,12),(0x30006600,8)] {b.memory.reserve_at(label,bytes).unwrap();}
  init::construct_at(&mut b,0x2d5f470,poison).unwrap();for offset in [36,40,44] {Storage::write_word(&mut b,0x2d5f470+offset,0).unwrap();}
  for (a,v) in [(0x3000417c,0x30005500),(0x30005530,0x30005600),(0x30006500,0x30006600),(0x30006600,0x32000b00),(0x30006604,0x32000c00)] {Storage::write_word(&mut b,a,v).unwrap();}b
 }
 fn compare(b:&mut Owned,words:&serde_json::Value) {for w in words.as_array().unwrap() {assert_eq!(b.word(w[0].as_u64().unwrap() as u32).unwrap(),w[1].as_u64().unwrap() as u32,"{w}");}}
 #[test] fn audio_owner_component_destructor_matches208_complete_native_cases() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_owner_component_destructor_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),208);
  for c in cases {
   let mut b=setup(c["poison"].as_u64().unwrap() as u8);let component=c["component"].as_u64().unwrap() as u32;
   if let Some(prior)=c["prior"].as_u64() {if prior==0 {insert::insert_with_hash(&mut b,0x2d5f470,42,0,Hash::Identity).unwrap();} else {secondary::register(&mut b,0x2d5f470,Kind::Owner,prior as u32,42).unwrap();}}
   Storage::write_word(&mut b,0x30005600,c["owner_id"].as_u64().unwrap() as u32).unwrap();let control=c["control"].as_u64().unwrap_or(0) as u32;Storage::write_word(&mut b,component+8,control).unwrap();
   if control!=0 {Storage::write_word(&mut b,control+4,c["initial_strong"].as_u64().unwrap() as u32).unwrap();Storage::write_word(&mut b,control+8,c["initial_weak"].as_u64().unwrap() as u32).unwrap();}
   compare(&mut b,&c["initial_words"]);b.memory.allocations.clear();b.memory.released_labels.clear();b.locks.clear();destroy(&mut b,0x2d5f470,component,u32::MAX).unwrap();
   assert!(b.memory.allocations.is_empty());assert_eq!(serde_json::json!(b.memory.released_labels),c["freed"]);assert_eq!(serde_json::json!(b.locks),c["locks"]);assert_eq!(serde_json::json!(b.calls),c["virtual_calls"]);compare(&mut b,&c["words"]);assert_eq!(b.word(component+8).unwrap(),c["retained_component_control"].as_u64().unwrap() as u32);
   if control!=0 {assert_eq!(b.word(control+4).unwrap(),c["final_strong"].as_u64().unwrap() as u32);assert_eq!(b.word(control+8).unwrap(),c["final_weak"].as_u64().unwrap() as u32);}
  }
 }
 #[test] fn audio_owner_disposal_error_keeps_strong_decrement_and_skips_weak_release() {
  let mut b=setup(0);let component=0x30004178;for (a,v) in [(0x30005600,42),(component+8,0x30006500),(0x30006504,1),(0x30006508,1)] {Storage::write_word(&mut b,a,v).unwrap();}secondary::register(&mut b,0x2d5f470,Kind::Owner,component,42).unwrap();b.fail_dispose=true;
  assert_eq!(destroy(&mut b,0x2d5f470,component,u32::MAX),Err(Error::Boundary("dispose failed")));assert_eq!(secondary::query(&mut b,0x2d5f470,Kind::Owner,42).unwrap(),0);assert_eq!(b.word(0x30006504).unwrap(),0);assert_eq!(b.word(0x30006508).unwrap(),1);assert_eq!(b.calls.len(),1);
 }

 #[test] fn audio_owner_component_callback_mutations_match40_native_control_weak_vtable_cases() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_owner_component_mutations_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),40);
  for c in cases {
   let mut b=setup(c["poison"].as_u64().unwrap() as u8);let component=0x30004178;let mode=c["mode"].as_str().unwrap();let value=c["weak_value"].as_u64().unwrap() as u32;b.memory.reserve_at(0x30006800,12).unwrap();b.memory.reserve_at(0x30006900,8).unwrap();
   for (a,v) in [(0x30005600,42),(component+8,0x30006500),(0x30006504,1),(0x30006508,1),(0x30006800,0x30006600),(0x30006804,1),(0x30006808,1),(0x30006900,0x32000b00),(0x30006904,0x32000d00)] {Storage::write_word(&mut b,a,v).unwrap();}
   if mode=="free_control" || mode=="leave_control" {Storage::write_word(&mut b,0x30006808,value).unwrap();} else if mode!="dispose_weak" {Storage::write_word(&mut b,0x30006508,value).unwrap();}
   secondary::register(&mut b,0x2d5f470,Kind::Owner,component,42).unwrap();compare(&mut b,&c["initial_words"]);b.memory.allocations.clear();b.memory.released_labels.clear();b.locks.clear();b.mutation=Some((mode.to_owned(),value));
   destroy(&mut b,0x2d5f470,component,u32::MAX).unwrap();assert!(b.memory.allocations.is_empty());assert_eq!(serde_json::json!(b.memory.released_labels),c["freed"]);assert_eq!(serde_json::json!(b.locks),c["locks"]);assert_eq!(serde_json::json!(b.calls),c["virtual_calls"]);compare(&mut b,&c["words"]);assert_eq!(b.word(component+8).unwrap(),c["component_control"].as_u64().unwrap() as u32);
   for control in c["controls"].as_array().unwrap() {let address=control[0].as_u64().unwrap() as u32;for offset in 0..3 {assert_eq!(b.word(address+offset*4).unwrap(),control[(offset+1) as usize].as_u64().unwrap() as u32);}}
  }
 }
}
