//! Complete normal-return62A140 orchestration with explicit secondary/owner helpers.
use crate::audio_announcer_actor_admission as admission;
use crate::audio_announcer_object_lookup as lookup;
use crate::audio_announcer_registry_init::{self as init,Storage};
use crate::audio_announcer_registry_remove::Backend as RemovalBackend;
#[derive(Debug,PartialEq,Eq)]
pub enum Error {Admission(admission::Error),Context(lookup::Error),Provider(&'static str),AddressOverflow}
impl From<lookup::Error> for Error {fn from(e:lookup::Error)->Self {Self::Context(e)}}
pub trait Backend:admission::IdProvider {
 fn secondary_lookup(&mut self,key:u32)->Result<u32,&'static str>;
 fn secondary_register(&mut self,actor:u32,key:u32)->Result<(),&'static str>;
 fn owner_register(&mut self,component:u32,owner:u32)->Result<u32,&'static str>;
 fn owner_failure_diagnostic(&mut self)->Result<(),&'static str>;
}
fn add(a:u32,b:u32)->Result<u32,Error> {a.checked_add(b).ok_or(Error::AddressOverflow)}
/// Metadata is read after preceding callbacks, preserving fresh access and partial effects.
pub fn register_actor<B:Storage+RemovalBackend>(memory:&mut B,state:&mut init::State,constructor_byte:u8,actor:u32,invalid_id:u32,invalid_owner:u32,provider:&mut impl Backend)->Result<admission::Entry,Error> {
 let entry=admission::admit_actor(memory,state,constructor_byte,actor,invalid_id,provider).map_err(Error::Admission)?;
 let key=memory.word(add(actor,8)?)?;
 if provider.secondary_lookup(key).map_err(Error::Provider)?==0 {
  let fresh_key=memory.word(add(actor,8)?)?;
  provider.secondary_register(actor,fresh_key).map_err(Error::Provider)?;
 }
 let metadata=memory.word(add(actor,0x17c)?)?;let owner_storage=memory.word(add(metadata,0x30)?)?;let owner=memory.word(owner_storage)?;
 if owner!=invalid_owner {
  let result=provider.owner_register(add(actor,0x178)?,owner).map_err(Error::Provider)?;
  if result&255==0 {provider.owner_failure_diagnostic().map_err(Error::Provider)?;}
 }
 Ok(entry)
}
#[cfg(test)] mod tests {
 use super::*;use std::collections::BTreeMap;use crate::audio_announcer_registry_insert as insert;use crate::audio_announcer_registry_remove as removal;
 struct World {owned:init::OwnedMemory,words:BTreeMap<u32,u32>}
 impl lookup::Memory for World {fn word(&mut self,a:u32)->Result<u32,lookup::Error> {if let Some(v)=self.words.get(&a) {Ok(*v)} else {self.owned.word(a)}}}
 impl Storage for World {
  fn allocate(&mut self,n:u32)->Result<u32,init::Error> {self.owned.allocate(n)}
  fn write_word(&mut self,a:u32,v:u32)->Result<(),init::Error> {Storage::write_word(&mut self.owned,a,v)}
  fn write_byte(&mut self,a:u32,v:u8)->Result<(),init::Error> {self.owned.write_byte(a,v)}
  fn register_shutdown(&mut self,c:u32)->Result<(),init::Error> {self.owned.register_shutdown(c)}
 }
 impl removal::Backend for World {
  fn write_word(&mut self,a:u32,v:u32)->Result<(),removal::Error> {removal::Backend::write_word(&mut self.owned,a,v)}
  fn deallocator(&mut self)->Result<removal::Deallocator,removal::Error> {self.owned.deallocator()}
  fn free(&mut self,a:u32,r:removal::Deallocator)->Result<(),removal::Error> {self.owned.free(a,r)}
 }
 struct Provider {ids:Vec<u32>,calls:Vec<u32>,diagnostics:usize,present:bool,owner_result:u32,tail:Vec<serde_json::Value>}
 impl admission::IdProvider for Provider {
  fn actor_id(&mut self,_:u32)->Result<u32,&'static str> {let id=self.ids[self.calls.len()];self.calls.push(id);Ok(id)}
  fn invalid_id_diagnostic(&mut self)->Result<(),&'static str> {self.diagnostics+=1;Ok(())}
 }
 impl Backend for Provider {
  fn secondary_lookup(&mut self,key:u32)->Result<u32,&'static str> {self.tail.push(serde_json::json!({"op":"secondary_lookup","key":key}));Ok(u32::from(self.present))}
  fn secondary_register(&mut self,actor:u32,key:u32)->Result<(),&'static str> {self.tail.push(serde_json::json!({"op":"secondary_register","actor":actor,"key":key}));Ok(())}
  fn owner_register(&mut self,component:u32,owner:u32)->Result<u32,&'static str> {self.tail.push(serde_json::json!({"op":"owner_register","component":component,"owner":owner,"result":self.owner_result}));Ok(self.owner_result)}
  fn owner_failure_diagnostic(&mut self)->Result<(),&'static str> {self.diagnostics+=1;Ok(())}
 }
 #[test] fn audio_complete_actor_registration_matches1024_original_tail_order_and_low_byte_owner_cases() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_actor_registration_full_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),1024);
  for case in cases {
   let poison=case["poison"].as_u64().unwrap() as u8;let actor=case["actor"].as_u64().unwrap() as u32;let second=case["second_id"].as_u64().unwrap() as u32;let mut state=init::State {shutdown_flag:1,..init::State::default()};
   let mut memory=World {owned:init::OwnedMemory::new(0x34000000,poison),words:BTreeMap::from([(actor+8,case["resource_key"].as_u64().unwrap() as u32),(actor+0x17c,0x30005500),(0x30005530,0x30005600),(0x30005600,case["owner_id"].as_u64().unwrap() as u32)])};
   if case["existed"].as_bool().unwrap() {init::initialize(&mut state,poison,&mut memory).unwrap();insert::insert(&mut memory,state.manager,second,0x11223344).unwrap();}
   memory.owned.allocations.clear();memory.owned.released_labels.clear();let mut provider=Provider {ids:vec![case["first_id"].as_u64().unwrap() as u32,second],calls:vec![],diagnostics:0,present:case["secondary_present"].as_bool().unwrap(),owner_result:case["owner_result"].as_u64().unwrap() as u32,tail:vec![]};
   let entry=register_actor(&mut memory,&mut state,poison,actor,u32::MAX,case["invalid_owner"].as_u64().unwrap() as u32,&mut provider).unwrap();assert_eq!(entry.id,second);assert_eq!(serde_json::json!(provider.calls),case["getter_calls"]);assert_eq!(serde_json::json!(provider.tail),case["tail_calls"]);assert_eq!(provider.diagnostics,case["diagnostics"].as_array().unwrap().len());
   assert_eq!(lookup::lookup_initialized(&mut memory,state.manager,second).unwrap(),actor);assert_eq!(lookup::Memory::word(&mut memory,state.manager+8).unwrap(),case["count"].as_u64().unwrap() as u32);
   let allocations:Vec<_>=memory.owned.allocations.iter().map(|&(bytes,pointer)|serde_json::json!({"bytes":bytes,"pointer":pointer})).collect();assert_eq!(serde_json::json!(allocations),case["allocations"]);assert_eq!(serde_json::json!(memory.owned.released_labels),case["freed"]);
  }
 }
 #[test] fn audio_missing_tail_metadata_keeps_prior_actor_publication_and_returns_context_error() {
  let actor=0x30004000;let mut memory=World {owned:init::OwnedMemory::new(0x34000000,0),words:BTreeMap::new()};let mut state=init::State::default();let mut provider=Provider {ids:vec![42,42],calls:vec![],diagnostics:0,present:false,owner_result:1,tail:vec![]};
  assert_eq!(register_actor(&mut memory,&mut state,0,actor,u32::MAX,u32::MAX,&mut provider),Err(Error::Context(lookup::Error::MissingWord(actor+8))));assert!(provider.tail.is_empty());assert_eq!(lookup::lookup_initialized(&mut memory,state.manager,42).unwrap(),actor);
 }
}
