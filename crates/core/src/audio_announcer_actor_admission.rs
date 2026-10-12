//! Native62A140 admission through actor-value publication at62A1F5.
//! Remaining registration callbacks and actor ownership are separate contracts.
use crate::audio_announcer_object_lookup as lookup;
use crate::audio_announcer_registry_init::{self as init,Storage};
use crate::audio_announcer_registry_insert as insert;
use crate::audio_announcer_registry_remove::Backend as RemovalBackend;
#[derive(Debug,PartialEq,Eq)]
pub enum Error {Provider(&'static str),Initialization(init::Error),Lookup(lookup::Error),Insertion(insert::Error),Storage(init::Error)}
pub trait IdProvider {
 fn actor_id(&mut self,actor:u32)->Result<u32,&'static str>;
 fn invalid_id_diagnostic(&mut self)->Result<(),&'static str>;
}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct Entry {pub id:u32,pub node:u32}
/// Each ID getter is fresh. A returning invalid-ID diagnostic does not skip admission.
pub fn admit_actor<B:Storage+RemovalBackend>(memory:&mut B,state:&mut init::State,constructor_byte:u8,actor:u32,invalid_id:u32,provider:&mut impl IdProvider)->Result<Entry,Error> {
 let id=resolve_id(actor,invalid_id,provider)?;
 publish_actor(memory,state,constructor_byte,actor,id)
}
fn resolve_id(actor:u32,invalid_id:u32,provider:&mut impl IdProvider)->Result<u32,Error> {
 let first=provider.actor_id(actor).map_err(Error::Provider)?;
 if first==invalid_id {provider.invalid_id_diagnostic().map_err(Error::Provider)?;}
 let id=provider.actor_id(actor).map_err(Error::Provider)?;
 Ok(id)
}
/// Shared backend admits from its own actor/provider and registry storage.
pub fn admit_actor_shared<B:Storage+RemovalBackend+IdProvider>(memory:&mut B,state:&mut init::State,constructor_byte:u8,actor:u32,invalid_id:u32)->Result<Entry,Error> {
 let id=resolve_id(actor,invalid_id,memory)?;publish_actor(memory,state,constructor_byte,actor,id)
}
fn publish_actor<B:Storage+RemovalBackend>(memory:&mut B,state:&mut init::State,constructor_byte:u8,actor:u32,id:u32)->Result<Entry,Error> {
 init::initialize(state,constructor_byte,memory).map_err(Error::Initialization)?;
 let node=match lookup::lookup_node_initialized(memory,state.manager,id).map_err(Error::Lookup)? {
  Some(node)=>node,
  None=>insert::insert(memory,state.manager,id,0).map_err(Error::Insertion)?.node,
 };
 let address=node.checked_add(12).ok_or(Error::Storage(init::Error::AddressOverflow))?;
 Storage::write_word(memory,address,actor).map_err(Error::Storage)?;
 Ok(Entry {id,node})
}
#[cfg(test)] mod tests {
 use super::*;use init::{OwnedMemory,State};
 struct Provider {ids:Vec<u32>,calls:Vec<u32>,actors:Vec<u32>,diagnostics:usize,fail_at:Option<usize>}
 impl IdProvider for Provider {
  fn actor_id(&mut self,actor:u32)->Result<u32,&'static str> {if self.fail_at==Some(self.calls.len()) {return Err("ID getter unavailable");}let value=self.ids[self.calls.len()];self.calls.push(value);self.actors.push(actor);Ok(value)}
  fn invalid_id_diagnostic(&mut self)->Result<(),&'static str> {self.diagnostics+=1;Ok(())}
 }
 #[test] fn audio_actor_admission_matches64_original_fresh_id_diagnostic_existing_and_absent_cases() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_actor_registration_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),64);
  for case in cases {
   let poison=case["poison"].as_u64().unwrap() as u8;let second=case["second_id"].as_u64().unwrap() as u32;let actor=case["actor"].as_u64().unwrap() as u32;
   let mut memory=OwnedMemory::new(0x34000000,poison);let mut state=State {shutdown_flag:1,..State::default()};
   if case["existed"].as_bool().unwrap() {init::initialize(&mut state,poison,&mut memory).unwrap();insert::insert(&mut memory,state.manager,second,0x11223344).unwrap();}
   memory.allocations.clear();memory.released_labels.clear();let mut provider=Provider {ids:vec![case["first_id"].as_u64().unwrap() as u32,second],calls:vec![],actors:vec![],diagnostics:0,fail_at:None};
   let entry=admit_actor(&mut memory,&mut state,poison,actor,u32::MAX,&mut provider).unwrap();
   assert_eq!(entry,Entry {id:second,node:case["node"].as_u64().unwrap() as u32});assert_eq!(state.manager,case["manager"].as_u64().unwrap() as u32);assert_eq!(serde_json::json!(provider.calls),case["getter_calls"]);assert_eq!(provider.actors,vec![actor,actor]);assert_eq!(provider.diagnostics,case["diagnostics"].as_array().unwrap().len());
   let allocations:Vec<_>=memory.allocations.iter().map(|&(bytes,pointer)|serde_json::json!({"bytes":bytes,"pointer":pointer})).collect();assert_eq!(serde_json::json!(allocations),case["allocations"]);assert_eq!(serde_json::json!(memory.released_labels),case["freed"]);
   assert_eq!(lookup::Memory::word(&mut memory,state.manager+8).unwrap(),case["count"].as_u64().unwrap() as u32);
   assert_eq!(lookup::lookup_initialized(&mut memory,state.manager,second).unwrap(),case["stored_value"].as_u64().unwrap() as u32);
  }
 }
 #[test] fn audio_failed_second_id_getter_prevents_registry_initialization_and_publication() {
  let mut state=State {initialization_flag:255,..State::default()};let mut memory=OwnedMemory::new(0x34000000,0);let mut provider=Provider {ids:vec![u32::MAX],calls:vec![],actors:vec![],diagnostics:0,fail_at:Some(1)};
  assert_eq!(admit_actor(&mut memory,&mut state,0,0x30004000,u32::MAX,&mut provider),Err(Error::Provider("ID getter unavailable")));assert_eq!(provider.diagnostics,1);assert_eq!(state.manager,0);assert_eq!(state.initialization_flag,255);assert!(memory.allocations.is_empty());
 }
}
