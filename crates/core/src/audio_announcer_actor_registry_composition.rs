//! Full62A140 using actual primary/secondary/owner registry implementations.
//! All actor metadata and table bytes share caller-owned storage; no helper-result adapters.
use crate::audio_announcer_actor_admission as admission;
use crate::audio_announcer_object_lookup as lookup;
use crate::audio_announcer_registry_init::{self as init,Storage};
use crate::audio_announcer_registry_remove::Backend as RemovalBackend;
use crate::audio_announcer_secondary_registries::{self as secondary,Kind,Boundaries};
#[derive(Debug,PartialEq,Eq)]
pub enum Error {Admission(admission::Error),Context(lookup::Error),Secondary(secondary::Error),Provider(&'static str),Initialization(init::Error),Removal(crate::audio_announcer_registry_remove::Error),Unregister(crate::audio_announcer_secondary_unregister::Error),AddressOverflow}
impl From<lookup::Error> for Error {fn from(e:lookup::Error)->Self {Self::Context(e)}}
impl From<secondary::Error> for Error {fn from(e:secondary::Error)->Self {Self::Secondary(e)}}
pub trait ActorProvider:admission::IdProvider {fn owner_failure_diagnostic(&mut self)->Result<(),&'static str>;}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct Tables {pub secondary:u32,pub owner:u32}
fn add(a:u32,b:u32)->Result<u32,Error> {a.checked_add(b).ok_or(Error::AddressOverflow)}
pub fn register<B:Storage+RemovalBackend+Boundaries+ActorProvider>(memory:&mut B,state:&mut init::State,constructor_byte:u8,tables:Tables,actor:u32,invalid_id:u32,invalid_owner:u32)->Result<admission::Entry,Error> {
 let entry=admission::admit_actor_shared(memory,state,constructor_byte,actor,invalid_id).map_err(Error::Admission)?;
 let key=memory.word(add(actor,8)?)?;
 if secondary::query(memory,tables.secondary,Kind::Secondary,key)?==0 {
  let fresh_key=memory.word(add(actor,8)?)?;secondary::register(memory,tables.secondary,Kind::Secondary,actor,fresh_key)?;
 }
 let metadata=memory.word(add(actor,0x17c)?)?;let owner_storage=memory.word(add(metadata,0x30)?)?;let owner=memory.word(owner_storage)?;
 if owner!=invalid_owner {
  let result=secondary::register(memory,tables.owner,Kind::Owner,add(actor,0x178)?,owner)?;
  if result==0 {memory.owner_failure_diagnostic().map_err(Error::Provider)?;}
 }Ok(entry)
}
/// Native actor destructor629921..62997C registry-removal segment only.
/// Owner component and actor storage are destroyed later by separate native contracts.
pub fn unregister_registries<B:Storage+RemovalBackend+Boundaries>(memory:&mut B,state:&mut init::State,constructor_byte:u8,tables:Tables,actor:u32)->Result<(),Error> {
 let key=memory.word(add(actor,8)?)?;
 crate::audio_announcer_secondary_unregister::unregister(memory,tables.secondary,Kind::Secondary,actor,key).map_err(Error::Unregister)?;
 // Native actor+FC is read after secondary unregister and its free/lock callbacks.
 let id=memory.word(add(actor,0xfc)?)?;
 init::initialize(state,constructor_byte,memory).map_err(Error::Initialization)?;
 let node=lookup::lookup_node_initialized(memory,state.manager,id)?;
 init::initialize(state,constructor_byte,memory).map_err(Error::Initialization)?;
 if let Some(node)=node {
  let head=memory.word(add(state.manager,4)?)?;
  if node!=head {crate::audio_announcer_registry_remove::remove_node(memory,state.manager,node).map_err(Error::Removal)?;}
 }
 Ok(())
}
#[cfg(test)] mod tests {
 use super::*;use lookup::{Memory,Hash};use init::OwnedMemory;use crate::audio_announcer_registry_remove as remove;use crate::audio_announcer_registry_insert as insert;
 struct Owned {memory:OwnedMemory,ids:Vec<u32>,calls:Vec<u32>,diagnostics:Vec<serde_json::Value>,locks:Vec<serde_json::Value>,owner_arrays:Vec<u32>,mutation:Option<(bool,u32,u32)>}
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
  fn free(&mut self,n:u32,_:remove::Deallocator)->Result<(),remove::Error> {self.memory.release(n).map_err(remove::Error::Owned)?;if let Some((true,address,value))=self.mutation {self.mutation=None;Storage::write_word(&mut self.memory,address,value).map_err(remove::Error::Owned)?;}Ok(())}
 }
 impl admission::IdProvider for Owned {
  fn actor_id(&mut self,_:u32)->Result<u32,&'static str> {let value=*self.ids.get(self.calls.len()).ok_or("ID provider exhausted")?;self.calls.push(value);Ok(value)}
  fn invalid_id_diagnostic(&mut self)->Result<(),&'static str> {self.diagnostics.push(serde_json::json!([17396368,17324845,0,17324845,17324845]));Ok(())}
 }
 impl ActorProvider for Owned {fn owner_failure_diagnostic(&mut self)->Result<(),&'static str> {self.diagnostics.push(serde_json::json!([17442848,17324845,0,17324845,17324845]));Ok(())}}
 impl Boundaries for Owned {
  fn diagnostic(&mut self,_:Kind,_:secondary::Diagnostic)->Result<(),&'static str> {Err("unexpected registration diagnostic")}
  fn enter(&mut self,k:Kind)->Result<(),&'static str> {self.locks.push(serde_json::json!({"op":"enter","object":if k==Kind::Secondary {0x2110a40u32} else {0x2d5f4a0u32}}));Ok(())}
  fn leave(&mut self,k:Kind)->Result<(),&'static str> {if k==Kind::Secondary {if let Some((false,address,value))=self.mutation {self.mutation=None;Storage::write_word(&mut self.memory,address,value).map_err(|_|"mutation storage unavailable")?;}}self.locks.push(serde_json::json!({"op":"leave","object":if k==Kind::Secondary {0x2110a40u32} else {0x2d5f4a0u32}}));Ok(())}
  fn allocate_owner_array(&mut self,n:u32)->Result<u32,init::Error> {let p=self.memory.allocate(n*4)?;self.owner_arrays.push(p);Ok(p)}
 }
 fn owned(poison:u8)->Owned {Owned {memory:OwnedMemory::new(0x34000000,poison),ids:vec![],calls:vec![],diagnostics:vec![],locks:vec![],owner_arrays:vec![],mutation:None}}
 fn initialize_tables(b:&mut Owned,poison:u8)->Tables {
  let tables=Tables {secondary:0x2110a10,owner:0x2d5f470};
  for table in [tables.secondary,tables.owner] {b.memory.reserve_at(table,48).unwrap();init::construct_at(b,table,poison).unwrap();for offset in [36,40,44] {Storage::write_word(b,table+offset,0).unwrap();}}
  tables
 }
 fn compare_words(b:&mut Owned,words:&serde_json::Value) {for w in words.as_array().unwrap() {assert_eq!(b.word(w[0].as_u64().unwrap() as u32).unwrap(),w[1].as_u64().unwrap() as u32,"{w}");}}
 #[test] fn audio_owned_actor_registration_matches576_native_composed_calls288_lifetimes() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_actor_registry_composition_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),288);let mut calls=0;
  for c in cases {
   let poison=c["poison"].as_u64().unwrap() as u8;let mut b=owned(poison);let tables=Tables {secondary:0x2110a10,owner:0x2d5f470};let actor=c["actor"].as_u64().unwrap() as u32;let id=c["second_id"].as_u64().unwrap() as u32;
   for (table,prior,key) in [(tables.secondary,&c["secondary_prior"],77),(tables.owner,&c["owner_prior"],42)] {b.memory.reserve_at(table,48).unwrap();init::construct_at(&mut b,table,poison).unwrap();for offset in [36,40,44] {Storage::write_word(&mut b,table+offset,0).unwrap();}if let Some(value)=prior.as_u64() {insert::insert_with_hash(&mut b,table,key,value as u32,Hash::Identity).unwrap();}}
   b.memory.reserve_at(actor,0x180).unwrap();b.memory.reserve_at(0x30005500,0x34).unwrap();b.memory.reserve_at(0x30005600,4).unwrap();
   for (a,v) in [(actor+8,77),(actor+0x17c,0x30005500),(0x30005530,0x30005600),(0x30005600,c["owner_id"].as_u64().unwrap() as u32)] {Storage::write_word(&mut b,a,v).unwrap();}
   let mut state=init::State {shutdown_flag:1,..init::State::default()};if c["existed"].as_bool().unwrap() {init::initialize(&mut state,poison,&mut b).unwrap();insert::insert(&mut b,state.manager,id,0x11223344).unwrap();}
   for step in c["steps"].as_array().unwrap() {
    b.memory.allocations.clear();b.memory.released_labels.clear();b.ids=vec![c["first_id"].as_u64().unwrap() as u32,id];b.calls.clear();b.diagnostics.clear();b.locks.clear();b.owner_arrays.clear();
    let entry=register(&mut b,&mut state,poison,tables,actor,u32::MAX,u32::MAX).unwrap();assert_eq!(entry.id,id);assert_eq!(state.manager,step["primary_manager"].as_u64().unwrap() as u32);assert_eq!(b.word(entry.node+12).unwrap(),actor);
    assert_eq!(serde_json::json!(b.calls),step["getter_calls"]);assert_eq!(serde_json::json!(b.diagnostics),step["diagnostics"]);assert_eq!(serde_json::json!(b.locks),step["locks"]);
    let allocations:Vec<_>=b.memory.allocations.iter().map(|&(bytes,pointer)| {let mut a=serde_json::json!({"bytes":bytes,"pointer":pointer});if b.owner_arrays.contains(&pointer) {a["allocator"]=serde_json::json!("owner_pointer_array");}a}).collect();assert_eq!(serde_json::json!(allocations),step["allocations"]);assert_eq!(serde_json::json!(b.memory.released_labels),step["freed"]);
    for field in ["primary_words","secondary_words","owner_words"] {compare_words(&mut b,&step[field]);}calls+=1;
   }
   crate::audio_announcer_registry_shutdown::shutdown(&mut b,&mut state).unwrap();assert_eq!(b.word(actor+8).unwrap(),77);assert_eq!(b.word(0x30005600).unwrap(),c["owner_id"].as_u64().unwrap() as u32);
  }assert_eq!(calls,576);
 }
 #[test] fn audio_owned_registration_missing_metadata_preserves_primary_and_secondary_publication() {
  let mut b=owned(0);let tables=initialize_tables(&mut b,0);let actor=0x30004000;b.memory.reserve_at(actor,0x180).unwrap();Storage::write_word(&mut b,actor+8,77).unwrap();b.ids=vec![42,42];let mut state=init::State::default();
  assert_eq!(register(&mut b,&mut state,0,tables,actor,u32::MAX,u32::MAX),Err(Error::Context(lookup::Error::MissingWord(0x30))));
  assert_eq!(lookup::lookup_initialized(&mut b,state.manager,42).unwrap(),actor);assert_eq!(secondary::query(&mut b,tables.secondary,Kind::Secondary,77).unwrap(),actor);assert_eq!(secondary::query(&mut b,tables.owner,Kind::Owner,42).unwrap(),0);
 }
 #[test] fn audio_owned_actor_storage_rejects_overlap_and_allocator_collision_without_erasing_bytes() {
  let mut memory=OwnedMemory::new(0x34000000,0);memory.reserve_at(0x30004000,16).unwrap();Storage::write_word(&mut memory,0x30004000,123).unwrap();
  for (label,size) in [(0x30004000,4),(0x30004008,16),(0x30003ff8,16)] {assert_eq!(memory.reserve_at(label,size),Err(init::Error::Backend("overlapping owned storage range")));assert_eq!(memory.word(0x30004000).unwrap(),123);}
  memory.reserve_at(0x34000000,16).unwrap();assert_eq!(memory.allocate(16),Err(init::Error::Backend("overlapping owned storage range")));assert!(memory.allocations.is_empty());memory.release(0x34000000).unwrap();assert_eq!(memory.allocate(16).unwrap(),0x34000000);
 }

 #[test] fn audio_actor_unregister_segment_matches96_native_calls48_owned_lifetimes() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_actor_unregister_segment_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),48);let mut calls=0;
  for c in cases {
   let poison=c["poison"].as_u64().unwrap() as u8;let mut b=owned(poison);let tables=Tables {secondary:0x2110a10,owner:0x2d5f470};let actor=c["actor"].as_u64().unwrap() as u32;let id=c["second_id"].as_u64().unwrap() as u32;
   for (table,prior,key) in [(tables.secondary,&c["secondary_prior"],77),(tables.owner,&serde_json::Value::Null,42)] {
    b.memory.reserve_at(table,48).unwrap();init::construct_at(&mut b,table,poison).unwrap();for offset in [36,40,44] {Storage::write_word(&mut b,table+offset,0).unwrap();}
    if let Some(value)=prior.as_u64() {insert::insert_with_hash(&mut b,table,key,value as u32,Hash::Identity).unwrap();}
   }
   b.memory.reserve_at(actor,0x180).unwrap();b.memory.reserve_at(0x30005500,0x34).unwrap();b.memory.reserve_at(0x30005600,4).unwrap();
   for (a,v) in [(actor+8,77),(actor+0xfc,id),(actor+0x17c,0x30005500),(0x30005530,0x30005600),(0x30005600,c["owner_id"].as_u64().unwrap() as u32)] {Storage::write_word(&mut b,a,v).unwrap();}
   let mut state=init::State {shutdown_flag:1,..init::State::default()};b.ids=vec![c["first_id"].as_u64().unwrap() as u32,id];register(&mut b,&mut state,poison,tables,actor,u32::MAX,u32::MAX).unwrap();assert_eq!(state.manager,c["primary_manager"].as_u64().unwrap() as u32);
   for field in ["primary_words","secondary_words","owner_words"] {compare_words(&mut b,&c["initial"][field]);}
   for step in c["steps"].as_array().unwrap() {
    b.memory.allocations.clear();b.memory.released_labels.clear();b.locks.clear();b.diagnostics.clear();unregister_registries(&mut b,&mut state,poison,tables,actor).unwrap();
    assert!(b.memory.allocations.is_empty());assert_eq!(serde_json::json!(b.memory.released_labels),step["freed"]);assert_eq!(serde_json::json!(b.locks),step["locks"]);assert_eq!(serde_json::json!(b.diagnostics),step["diagnostics"]);
    for field in ["primary_words","secondary_words","owner_words"] {compare_words(&mut b,&step[field]);}assert_eq!(b.word(actor+8).unwrap(),77);calls+=1;
   }
  }assert_eq!(calls,96);
 }

 #[test] fn audio_actor_unregister_reads_fresh_id_matching8_native_free_and_leave_mutations() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_actor_unregister_mutations_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),8);
  for c in cases {
   let poison=c["poison"].as_u64().unwrap() as u8;let mut b=owned(poison);let tables=initialize_tables(&mut b,poison);let actor=c["actor"].as_u64().unwrap() as u32;let new_id=c["new_id"].as_u64().unwrap() as u32;
   b.memory.reserve_at(actor,0x180).unwrap();b.memory.reserve_at(0x30005500,0x34).unwrap();b.memory.reserve_at(0x30005600,4).unwrap();
   for (a,v) in [(actor+8,77),(actor+0xfc,42),(actor+0x17c,0x30005500),(0x30005530,0x30005600),(0x30005600,u32::MAX)] {Storage::write_word(&mut b,a,v).unwrap();}
   let mut state=init::State {shutdown_flag:1,..init::State::default()};b.ids=vec![42,42];register(&mut b,&mut state,poison,tables,actor,u32::MAX,u32::MAX).unwrap();if c["alternate_present"].as_bool().unwrap() {insert::insert(&mut b,state.manager,new_id,0x3000bbbb).unwrap();}
   for field in ["primary_words","secondary_words","owner_words"] {compare_words(&mut b,&c["initial"][field]);}
   b.memory.allocations.clear();b.memory.released_labels.clear();b.locks.clear();b.diagnostics.clear();b.mutation=Some((c["mode"]=="free",actor+0xfc,new_id));
   unregister_registries(&mut b,&mut state,poison,tables,actor).unwrap();assert_eq!(b.word(actor+0xfc).unwrap(),new_id);assert!(b.mutation.is_none());assert_eq!(lookup::lookup_initialized(&mut b,state.manager,42).unwrap(),actor);assert_eq!(lookup::lookup_initialized(&mut b,state.manager,new_id).unwrap(),0);
   assert!(b.memory.allocations.is_empty());assert_eq!(serde_json::json!(b.memory.released_labels),c["freed"]);assert_eq!(serde_json::json!(b.locks),c["locks"]);assert_eq!(serde_json::json!(b.diagnostics),c["diagnostics"]);for field in ["primary_words","secondary_words","owner_words"] {compare_words(&mut b,&c[field]);}
  }
 }
}
