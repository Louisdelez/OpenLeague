use super::*;
use serde_json::Value;
use std::collections::{BTreeMap,BTreeSet,VecDeque};
fn bytes(s:&str)->Vec<u8>{s.as_bytes().chunks_exact(2).map(|p|u8::from_str_radix(std::str::from_utf8(p).unwrap(),16).unwrap()).collect()}
fn proof()->Value{serde_json::from_str(include_str!("../../../data/4.20/audio_init_rtpc_owner_contract.json")).unwrap()}
fn source()->Value{serde_json::from_str(include_str!("../../../data/4.20/audio_init_rtpc_owner_source.json")).unwrap()}
struct Backend {
 allocations:VecDeque<(u32,u32,u32,u8)>,live:BTreeMap<u32,usize>,initialized:BTreeSet<u32>,held:BTreeSet<u32>,
 events:Vec<(String,u32)>,fail:Option<Role>,alias:Option<(Role,u32,usize)>,unlock_error:bool,delete_error:bool,
}
impl Backend {
 fn new(row:&Value)->Self{Self{allocations:row["calls"].as_array().unwrap().iter().filter(|c|c["kind"]=="HeapAlloc").map(|c|(c["pool"].as_u64().unwrap()as u32,c["size"].as_u64().unwrap()as u32,c["reference"].as_u64().unwrap()as u32,c["pattern"].as_u64().unwrap()as u8)).collect(),live:BTreeMap::new(),initialized:BTreeSet::new(),held:BTreeSet::new(),events:vec![],fail:None,alias:None,unlock_error:false,delete_error:false}}
}
impl Services for Backend {
 fn allocate(&mut self,role:Role,pool:u32,size:u32)->Result<Option<Memory>,Error>{
  if self.fail==Some(role){return Ok(None);}if let Some((r,reference,len))=self.alias{if role==r{return Ok(Some(Memory{reference,raw:vec![0x11;len]}));}}
  let(p,z,r,pattern)=self.allocations.pop_front().expect("native allocation input absent");assert_eq!((pool,size),(p,z));assert!(self.live.insert(r,size as usize).is_none());self.events.push((format!("allocate:{role:?}"),r));Ok(Some(Memory{reference:r,raw:vec![pattern;size as usize]}))
 }
 fn free(&mut self,pool:u32,m:&Memory)->Result<(),Error>{assert_eq!(pool,u32::MAX);assert_eq!(self.live.remove(&m.reference),Some(m.raw.len()));self.events.push(("free".into(),m.reference));Ok(())}
 fn initialize_critical_section(&mut self,r:u32)->Result<(),Error>{assert!(self.initialized.insert(r));self.events.push(("initialize_cs".into(),r));Ok(())}
 fn delete_critical_section(&mut self,r:u32)->Result<(),Error>{if self.delete_error{return Err(Error::Backend("physical delete service temporarily unavailable"));}assert!(!self.held.contains(&r));assert!(self.initialized.remove(&r));self.events.push(("delete_cs".into(),r));Ok(())}
 fn lock(&mut self,r:u32)->Result<(),Error>{assert!(self.initialized.contains(&r));assert!(self.held.insert(r));self.events.push(("lock".into(),r));Ok(())}
 fn unlock(&mut self,r:u32)->Result<(),Error>{if self.unlock_error{return Err(Error::Backend("physical unlock service temporarily unavailable"));}assert!(self.held.remove(&r));self.events.push(("unlock".into(),r));Ok(())}
}
fn compare(owner:&FreshInitializationOwner,bus:Option<&Bus>,expected:&Value){
 let mut actual=owner.owned_memory().unwrap();if let Some(b)=bus{assert!(actual.insert(b.reference,Memory{reference:b.reference,raw:b.raw.to_vec()}).is_none());}
 let target:BTreeMap<u32,Vec<u8>>=expected["blocks"].as_array().unwrap().iter().filter(|b|b["freed"]==false).map(|b|(b["reference"].as_u64().unwrap()as u32,bytes(b["raw"].as_str().unwrap()))).collect();
 assert_eq!(actual.len(),target.len());for (r,raw) in target {assert_eq!(actual.get(&r).unwrap().raw,raw,"entire owned buffer {r:x}");}
 assert_eq!(owner.full_raw().to_vec(),bytes(expected["manager_raw"].as_str().unwrap()));assert_eq!(owner.reference,expected["manager"].as_u64().unwrap()as u32);
}
fn populate(owner:&mut FreshInitializationOwner,b:&mut Backend){let d=source()["defaults"].as_array().unwrap().iter().map(|d|(d["id"].as_u64().unwrap()as u32,d["default_bits"].as_u64().unwrap()as u32)).collect::<Vec<_>>();owner.set_defaults(&d,b).unwrap();}
fn prepared(row:&Value)->(FreshInitializationOwner,Bus,Backend){let mut backend=Backend::new(row);let mut owner=FreshInitializationOwner::create(u32::MAX,&mut backend).unwrap();populate(&mut owner,&mut backend);let bus=owner.create_sfx_bus(&mut backend).unwrap();(owner,bus,backend)}
fn register(owner:&mut FreshInitializationOwner,bus:&mut Bus,backend:&mut Backend,graph:&mut native::audio_bus_effects_changed::Graph)->Result<ReadResult,Failure>{let cfg=source();let block=bytes(cfg["sfx_rtpc_block_hex"].as_str().unwrap());register_fresh_sfx(owner,bus,&block,graph,&mut native::audio_bus_control_application::Store::default(),&native::audio_bus_gain_aggregation::Inputs::default(),&mut native::audio_bus_gain_aggregation::CachedStates::default(),0x14a7970,backend)}
#[test]
fn original_fresh_init_full_owners_defaults_and_class1_registration_match_all_eight_native_snapshots(){
 let proof=proof();assert_eq!(proof["passed"],true);assert_eq!(proof["rows"].as_array().unwrap().len(),2);
 for row in proof["rows"].as_array().unwrap(){let mut backend=Backend::new(row);let mut owner=FreshInitializationOwner::create(u32::MAX,&mut backend).unwrap();compare(&owner,None,&row["after_factories"]);
  populate(&mut owner,&mut backend);compare(&owner,None,&row["after_actual_defaults"]);
  let mut bus=owner.create_sfx_bus(&mut backend).unwrap();assert_eq!(bus.raw.to_vec(),bytes(row["bus_after_initializer"].as_str().unwrap()));compare(&owner,Some(&bus),&row["before_registration"]);
  let mut graph=native::audio_bus_effects_changed::Graph::default();graph.buses.insert(bus.reference,bus.clone());let result=register(&mut owner,&mut bus,&mut backend,&mut graph).unwrap();assert_eq!((result.consumed,result.remaining),(41,17));compare(&owner,Some(&bus),&row["after_registration"]);
  assert_eq!(graph.buses[&bus.reference].raw,bus.raw);assert!(backend.allocations.is_empty());assert!(backend.held.is_empty());assert_eq!(backend.initialized.len(),11);
  let record=record_reference(&owner.manager,3273357900).unwrap().unwrap();let r=&owner.manager.records[&record];assert_eq!(word(&r.memory.raw,8),0x42c80000);assert_eq!(word(&r.memory.raw,16),0);assert_eq!(r.subscribers.raw[4..8],vec![row["pattern"].as_u64().unwrap()as u8;4]);
 }
}
#[test]
fn malformed_size_alias_and_late_registration_failure_reclaim_only_unpublished_owners(){
 let row=&proof()["rows"][0];
 for wrong_size in [24usize,3]{let(mut owner,mut bus,mut backend)=prepared(row);let before=owner.owned_memory().unwrap();let bus_before=bus.raw;let live_before=backend.live.clone();backend.alias=Some((Role::Points,owner.reference,wrong_size));let mut graph=native::audio_bus_effects_changed::Graph::default();let mut error=register(&mut owner,&mut bus,&mut backend,&mut graph).unwrap_err();assert!(matches!(error.error,Error::InvalidAllocation));assert_eq!(error.unpublished_allocations.len(),2);assert!(!error.unpublished_allocations.iter().any(|m|m.reference==owner.reference));assert_eq!(owner.owned_memory().unwrap().iter().map(|(k,m)|(*k,m.raw.clone())).collect::<BTreeMap<_,_>>(),before.iter().map(|(k,m)|(*k,m.raw.clone())).collect());assert_eq!(bus.raw,bus_before);assert!(graph.buses.is_empty());error.reclaim(u32::MAX,&mut backend).unwrap();assert_eq!(backend.live,live_before);assert_eq!(backend.initialized.len(),11);}
 let(mut owner,mut bus,mut backend)=prepared(row);let before=owner.full_raw();let mut graph=native::audio_bus_effects_changed::Graph::default();let mut foreign=bus.clone();foreign.raw[8]^=1;graph.buses.insert(bus.reference,foreign.clone());let error=register(&mut owner,&mut bus,&mut backend,&mut graph).unwrap_err();assert!(matches!(error.error,Error::Backend(_)));assert!(error.unpublished_allocations.is_empty());assert_eq!(owner.full_raw(),before);assert_eq!(graph.buses[&bus.reference].raw,foreign.raw);
 let mut alias_bus=bus.clone();alias_bus.reference=owner.reference;assert!(matches!(register(&mut owner,&mut alias_bus,&mut backend,&mut native::audio_bus_effects_changed::Graph::default()).unwrap_err().error,Error::InvalidAllocation));
}
#[test]
fn constructor_and_unlock_failures_retain_critical_section_ownership_until_explicit_reclaim(){
 let row=&proof()["rows"][0];let mut backend=Backend::new(row);backend.fail=Some(Role::ManagerPool);let mut error=match FreshInitializationOwner::create(u32::MAX,&mut backend){Ok(_)=>panic!("late constructor must reject"),Err(e)=>e};assert_eq!(error.unpublished_allocations.len(),2);assert_eq!(error.initialized_critical_sections.len(),11);assert_eq!(backend.initialized.len(),11);
 backend.delete_error=true;assert!(error.reclaim(u32::MAX,&mut backend).is_err());assert_eq!(error.unpublished_allocations.len(),2);assert_eq!(error.initialized_critical_sections.len(),11);assert_eq!(backend.live.len(),2);
 backend.delete_error=false;error.reclaim(u32::MAX,&mut backend).unwrap();assert!(backend.live.is_empty()&&backend.initialized.is_empty()&&backend.held.is_empty());
 let mut backend=Backend::new(row);let mut owner=FreshInitializationOwner::create(u32::MAX,&mut backend).unwrap();populate(&mut owner,&mut backend);let before=owner.node_registry.raw.clone();let live_before=backend.live.clone();backend.unlock_error=true;let mut error=owner.create_sfx_bus(&mut backend).unwrap_err();assert_eq!(error.held_critical_sections.len(),1);assert_eq!(backend.held.len(),1);assert_eq!(owner.node_registry.raw,before);assert_eq!(error.unpublished_allocations.len(),1);
 assert!(error.reclaim(u32::MAX,&mut backend).is_err());assert_eq!(error.unpublished_allocations.len(),1);assert_eq!(error.held_critical_sections.len(),1);backend.unlock_error=false;error.reclaim(u32::MAX,&mut backend).unwrap();assert_eq!(backend.live,live_before);assert!(backend.held.is_empty());assert_eq!(backend.initialized.len(),11);
}
