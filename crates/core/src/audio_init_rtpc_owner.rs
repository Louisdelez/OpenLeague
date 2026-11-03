//! Selected fresh Init owner/default/class1 registration; no ordinary activation.
//! The existing 0x920 Manager ABI stays intact. Allocator bytes and the full
//! 0x954 owner are preserved; native startup/other bank stages are not inferred.
use crate as native;
use native::{audio_bus_bank::Error, audio_plugin_factory::Memory,
 audio_rtpc_subscriber_release::{Manager,Record,Binding},audio_bus_registry::Bus};
use std::collections::{BTreeMap,BTreeSet};

#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Role {NodeRegistry,Manager,ManagerPool,DefaultRecord,SfxBus,Binding,Curves,Points,RecordReferences}
/// Services own real allocation/critical-section lifetime. They supply every
/// byte, including opaque CS storage and unused vector capacity. A failed local
/// plan returns newly allocated blocks instead of claiming native fault rollback.
/// lock/unlock Err must preserve the prior acquisition state. A provider which
/// cannot guarantee that contract must expose its lower-level lease before use.
pub trait Services {
 fn allocate(&mut self,role:Role,pool:u32,size:u32)->Result<Option<Memory>,Error>;
 fn free(&mut self,pool:u32,memory:&Memory)->Result<(),Error>;
 fn initialize_critical_section(&mut self,reference:u32)->Result<(),Error>;
 fn delete_critical_section(&mut self,reference:u32)->Result<(),Error>;
 fn lock(&mut self,reference:u32)->Result<(),Error>;
 fn unlock(&mut self,reference:u32)->Result<(),Error>;
}
#[derive(Debug)]pub struct Failure {pub error:Error,pub unpublished_allocations:Vec<Memory>,pub initialized_critical_sections:Vec<u32>,pub held_critical_sections:Vec<u32>}
impl Failure {
 /// Explicit local rejection cleanup, not the unqualified native destructor.
 /// On a failed service call, retain the unreclaimed suffix for caller retry.
 pub fn reclaim(&mut self,pool:u32,s:&mut impl Services)->Result<(),Error>{
  while let Some(&r)=self.held_critical_sections.last(){s.unlock(r)?;self.held_critical_sections.pop();}
  while let Some(&r)=self.initialized_critical_sections.last(){s.delete_critical_section(r)?;self.initialized_critical_sections.pop();}
  while let Some(memory)=self.unpublished_allocations.last(){s.free(pool,memory)?;self.unpublished_allocations.pop();}Ok(())
 }
}
fn word(raw:&[u8],o:usize)->u32 {u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
fn put(raw:&mut[u8],o:usize,v:u32){raw[o..o+4].copy_from_slice(&v.to_le_bytes());}
fn empty()->Memory {Memory{reference:0,raw:vec![]}}
fn clone_manager(m:&Manager)->Manager {Manager{raw:m.raw,records:m.records.iter().map(|(&k,r)|(k,Record{memory:r.memory.clone(),subscribers:r.subscribers.clone()})).collect(),bindings:m.bindings.iter().map(|(&k,b)|(k,Binding{memory:b.memory.clone(),curves:b.curves.clone(),points:b.points.clone()})).collect()}}
fn record_reference(m:&Manager,key:u32)->Result<Option<u32>,Error>{let mut at=word(&m.raw,(key%193)as usize*4);let mut seen=BTreeSet::new();while at!=0{if !seen.insert(at){return Err(Error::CyclicList);}let r=m.records.get(&at).ok_or(Error::UnresolvedReference)?;if r.memory.reference!=at||r.memory.raw.len()!=40{return Err(Error::InvalidAllocation);}if word(&r.memory.raw,0)==key{return Ok(Some(at));}at=word(&r.memory.raw,4);}Ok(None)}
struct Allocations {blocks:Vec<Memory>,ranges:Vec<(u32,u32)>}
impl Allocations {
 fn with_existing(existing:&BTreeMap<u32,Memory>)->Result<Self,Error>{let mut out=Self{blocks:vec![],ranges:vec![]};for m in existing.values(){out.range(m)?;}Ok(out)}
 fn range(&mut self,m:&Memory)->Result<(),Error>{let end=m.reference.checked_add(u32::try_from(m.raw.len()).map_err(|_|Error::InvalidAllocation)?).ok_or(Error::InvalidAllocation)?;
  if m.reference==0||m.raw.is_empty()||self.ranges.iter().any(|&(a,b)|m.reference<b&&a<end){return Err(Error::InvalidAllocation);}self.ranges.push((m.reference,end));Ok(())}
 fn allocate(&mut self,s:&mut impl Services,role:Role,pool:u32,size:u32)->Result<Memory,Error>{let m=s.allocate(role,pool,size)?.ok_or(Error::Backend("required fresh Init allocation unavailable"))?;
  // Conflicting references stay owned by the services; do not reclaim or
  // publish an alias as a new allocation belonging to this plan.
  self.range(&m)?;if m.raw.len()!=size as usize {self.blocks.push(m);return Err(Error::InvalidAllocation);}self.blocks.push(m.clone());Ok(m)}
}

pub struct FreshInitializationOwner {
 pub reference:u32,pub pool_id:u32,pub manager:Manager,
 /// Mandatory tail returned from native-sized allocation, never defaulted.
 pub opaque_tail:[u8;0x34],pub node_registry:Memory,pub pool_nodes:Memory,
 pub initialized_critical_sections:Vec<u32>,
}
impl FreshInitializationOwner {
 fn clone_for_plan(&self)->Self {Self{reference:self.reference,pool_id:self.pool_id,manager:clone_manager(&self.manager),opaque_tail:self.opaque_tail,node_registry:self.node_registry.clone(),pool_nodes:self.pool_nodes.clone(),initialized_critical_sections:self.initialized_critical_sections.clone()}}
 pub fn full_raw(&self)->[u8;0x954]{let mut raw=[0u8;0x954];raw[..0x920].copy_from_slice(&self.manager.raw);raw[0x920..].copy_from_slice(&self.opaque_tail);raw}
 fn publish_full_raw(&mut self,raw:&[u8;0x954]){self.manager.raw.copy_from_slice(&raw[..0x920]);self.opaque_tail.copy_from_slice(&raw[0x920..]);}
 pub fn owned_memory(&self)->Result<BTreeMap<u32,Memory>,Error>{
  let mut out=BTreeMap::new();let mut refs=Allocations{blocks:vec![],ranges:vec![]};
  let mut add=|m:Memory|->Result<(),Error>{refs.range(&m)?;out.insert(m.reference,m);Ok(())};
  add(Memory{reference:self.reference,raw:self.full_raw().to_vec()})?;add(self.node_registry.clone())?;add(self.pool_nodes.clone())?;
  for (&key,r) in &self.manager.records {if key!=r.memory.reference||r.memory.raw.len()!=40{return Err(Error::InvalidAllocation);}if word(&r.memory.raw,12)!=0||word(&r.memory.raw,16)!=0||word(&r.memory.raw,20)!=0||word(&r.memory.raw,24)!=0{return Err(Error::Backend("override/transition memory owner must be connected separately"));}add(r.memory.clone())?;if r.subscribers.reference!=0{add(r.subscribers.clone())?;}}
  for (&key,b) in &self.manager.bindings {if key!=b.memory.reference||b.memory.raw.len()!=32{return Err(Error::InvalidAllocation);}add(b.memory.clone())?;if b.curves.reference!=0{add(b.curves.clone())?;}for (&key,p) in &b.points {if key!=p.reference{return Err(Error::InvalidAllocation);}add(p.clone())?;}}
  Ok(out)
 }
 /// AE9D50/AF64A0 and B10320/B115C0 selected successful fresh initialization.
 /// Caller supplies the engine pool ID; this is not its startup producer.
 pub fn create(pool:u32,s:&mut impl Services)->Result<Self,Failure>{
  let mut allocated=Allocations{blocks:vec![],ranges:vec![]};let mut locks=vec![];
  let result=(||{
   let mut node=allocated.allocate(s,Role::NodeRegistry,pool,0x2260)?;
   // Eleven original registry constructor callbacks and count stores.
   for i in 0..11 {let offset=i*0x320;let r=node.reference.checked_add(offset as u32).ok_or(Error::InvalidAllocation)?;s.initialize_critical_section(r)?;locks.push(r);put(&mut node.raw,offset+0x31c,0);}
   // AF64A0 initializes each 193-bucket table, retaining opaque headers.
   for i in 0..11 {let offset=i*0x320;node.raw[offset+0x18..offset+0x18+193*4].fill(0);put(&mut node.raw,offset+0x31c,0);}
   let memory=allocated.allocate(s,Role::Manager,pool,0x954)?;let reference=memory.reference;let mut raw:[u8;0x954]=memory.raw.try_into().map_err(|_|Error::InvalidAllocation)?;
   // B10320: only explicit constructor stores; retain all other bytes.
   for offset in [0x304,0x610,0x918,0x928,0x92c,0x930,0x944,0x948,0x94c]{put(&mut raw,offset,0);}put(&mut raw,0x308,u32::MAX);
   // B115C0 before the auxiliary allocation.
   put(&mut raw,0x308,pool);for offset in [0,0x30c,0x614]{raw[offset..offset+193*4].fill(0);}
   for offset in [0x304,0x610,0x918,0x930,0x924]{put(&mut raw,offset,0);}put(&mut raw,0x92c,u32::MAX);
   let mut nodes=allocated.allocate(s,Role::ManagerPool,pool,0xc0)?;put(&mut raw,0x934,nodes.reference);put(&mut raw,0x928,16);put(&mut raw,0x924,nodes.reference);
   for i in 0..16 {let next=if i==15{0}else{nodes.reference.checked_add((i+1)*12).ok_or(Error::InvalidAllocation)?};put(&mut nodes.raw,i as usize*12,next);}
   for offset in [0x91c,0x920,0x94c,0x940,0x950,0x938,0x93c]{put(&mut raw,offset,0);}put(&mut raw,0x948,u32::MAX);
   Ok(Self{reference,pool_id:pool,manager:Manager{raw:raw[..0x920].try_into().unwrap(),records:BTreeMap::new(),bindings:BTreeMap::new()},opaque_tail:raw[0x920..].try_into().unwrap(),node_registry:node,pool_nodes:nodes,initialized_critical_sections:locks.clone()})
  })();result.map_err(|error|Failure{error,unpublished_allocations:allocated.blocks,initialized_critical_sections:locks,held_critical_sections:vec![]})
 }
 /// Original B121E0 body reused through the qualified core memory port.
 /// Existing raw owner is published only after this selected local plan succeeds.
 pub fn set_defaults(&mut self,defaults:&[(u32,u32)],s:&mut impl Services)->Result<(),Failure>{
  let existing=self.owned_memory().map_err(|error|Failure{error,unpublished_allocations:vec![],initialized_critical_sections:vec![],held_critical_sections:vec![]})?;
  let mut allocated=Allocations::with_existing(&existing).map_err(|error|Failure{error,unpublished_allocations:vec![],initialized_critical_sections:vec![],held_critical_sections:vec![]})?;
  let result=(||{
   if defaults.iter().any(|(_,b)|!f32::from_bits(*b).is_finite()){return Err(Error::Backend("nonfinite source default outside selected Init scope"));}
   let mut m=existing;let mut dead=BTreeSet::new();
   {let mut service=Defaults{s,allocated:&mut allocated};for &(key,bits) in defaults {native::audio_registry_resource_admission::default_record(&mut m,&mut dead,self.reference,key,bits,self.pool_id,&mut service)?;}}
   let raw:[u8;0x954]=m.get(&self.reference).ok_or(Error::UnresolvedReference)?.raw.clone().try_into().map_err(|_|Error::InvalidAllocation)?;
   let mut records=BTreeMap::new();
   for bucket in 0..193 {let mut at=word(&raw,bucket*4);let mut seen=BTreeSet::new();while at!=0 {if !seen.insert(at){return Err(Error::CyclicList);}let memory=m.get(&at).ok_or(Error::UnresolvedReference)?.clone();if memory.raw.len()!=40{return Err(Error::InvalidAllocation);}let next=word(&memory.raw,4);let old=self.manager.records.get(&at);let subscribers=if let Some(old)=old{old.subscribers.clone()}else{empty()};records.insert(at,Record{memory,subscribers});at=next;}}
   self.publish_full_raw(&raw);self.manager.records=records;Ok(())
  })();result.map_err(|error|Failure{error,unpublished_allocations:allocated.blocks,initialized_critical_sections:vec![],held_critical_sections:vec![]})
 }
 /// Native constructors AFD490/AFDD70/B02080, then B03530 initializer.
 /// Selected source ownership stays local; caller must load parent/effects later.
 pub fn create_sfx_bus(&mut self,s:&mut impl Services)->Result<Bus,Failure>{
  let existing=self.owned_memory().map_err(|error|Failure{error,unpublished_allocations:vec![],initialized_critical_sections:vec![],held_critical_sections:vec![]})?;let mut allocated=Allocations::with_existing(&existing).map_err(|error|Failure{error,unpublished_allocations:vec![],initialized_critical_sections:vec![],held_critical_sections:vec![]})?;let mut held=vec![];
  let result=(||{
   let memory=allocated.allocate(s,Role::SfxBus,self.pool_id,200)?;let mut b=Bus{reference:memory.reference,raw:memory.raw.try_into().unwrap()};
   b.set_word(8,393239870);b.set_word(0xc,1);for off in [0x10,0x14,0x18,0x1c,0x20,0x24,0x28,0x30,0x34,0x38]{b.set_word(off,0);}b.set_word(0x2c,0x900000);b.set_word(0,0xff1380);
   for off in [0x40,0x44,0x48,0x50,0x54,0x58,0x5c,0x74,0x78,0x7c,0x90,0x94,0x98,0xac,0xb0,0xb4,0xbc,0xc0]{b.set_word(off,0);}b.set_word(0x60,0x63f);b.set_word(0x64,0xc2c0999a);b.raw[0xc4]=0x60;
   let mut registry=self.node_registry.clone();b.raw[0x2f]|=2;let selector=(b.raw[0x2f]>>1)&1;let offset=usize::from(selector)*0x320;let lock=registry.reference.checked_add(offset as u32).ok_or(Error::InvalidAllocation)?;
   s.lock(lock)?;held.push(lock);let bucket=(b.word(8)%193)as usize;let head=word(&registry.raw,offset+0x18+bucket*4);b.set_word(4,head);put(&mut registry.raw,offset+0x18+bucket*4,b.reference);let count=word(&registry.raw,offset+0x31c);put(&mut registry.raw,offset+0x31c,count.wrapping_add(1));s.unlock(lock)?;held.pop();
   for off in [0x7c,0x70,0x80,0x68,0x6c,0x98,0x8c,0x9c,0x84,0x88,0xb4,0xa8,0xb8,0xa0,0xa4]{b.set_word(off,0);}for off in [0x78,0x94,0xb0]{b.set_word(off,100);}
   self.node_registry=registry;Ok(b)
  })();result.map_err(|error|Failure{error,unpublished_allocations:allocated.blocks,initialized_critical_sections:vec![],held_critical_sections:held})
 }
}
struct Defaults<'a,S>{s:&'a mut S,allocated:&'a mut Allocations}
impl<S:Services> native::audio_path_voice_empty_source_release::Services for Defaults<'_,S>{fn free(&mut self,pool:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.s.free(pool,m.get(&r).ok_or(Error::UnresolvedReference)? )}}
impl<S:Services> native::audio_action_registry_key_publication::Services for Defaults<'_,S>{fn allocate(&mut self,pool:u32,size:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{let memory=self.allocated.allocate(self.s,Role::DefaultRecord,pool,size)?;let r=memory.reference;m.insert(r,memory);Ok(Some(r))}}
impl<S:Services> native::audio_resource_curve_admission::Services for Defaults<'_,S>{}
impl<S:Services> native::audio_global_float_configuration::Services for Defaults<'_,S>{}
impl<S:Services> native::audio_registry_resource_admission::Services for Defaults<'_,S>{fn observe(&mut self,_:native::audio_registry_resource_admission::Event,_:&BTreeMap<u32,Memory>){}fn configuration(&mut self,_:bool,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<u32,Error>{Err(Error::Backend("STMG output settings producer is outside defaults-only scope"))}}

#[derive(Debug,Clone,Copy)]pub struct ReadResult {pub consumed:usize,pub remaining:u32}
struct Rtpc<'a>{memory:BTreeMap<u32,Memory>,manager:u32,conversion_cache:u32,state:&'a mut native::audio_bus_gain_aggregation::CachedStates}
struct Observe;impl native::audio_dynamic_input_owner_selector::Services for Observe{}
#[cfg(target_arch="x86_64")]
fn rounded(retained:&[u8;10])->u32{let mut result=0u32;let mut cw=[0x037f0000u32,0];unsafe{std::arch::asm!("fnstcw word ptr [{cw}]","fldcw word ptr [{cw}+2]","fld tbyte ptr [{retained}]","fstp dword ptr [{result}]","fldcw word ptr [{cw}]",cw=in(reg)cw.as_mut_ptr(),retained=in(reg)retained.as_ptr(),result=in(reg)&mut result,out("st(0)")_,options(nostack));}result}
#[cfg(not(target_arch="x86_64"))]fn rounded(_:&[u8;10])->u32{unreachable!()}
impl native::audio_bus_gain_aggregation::Contribution for Rtpc<'_>{
 fn state(&mut self,n:u32,mask:u32,g:&native::audio_bus_effects_changed::Graph)->Result<f32,Error>{native::audio_bus_gain_aggregation::State::contribution(self.state,n,mask,g)}
 fn rtpc(&mut self,n:u32,p:u32,o:u32)->Result<Vec<f32>,Error>{let mut observe=Observe;let result=native::audio_dynamic_input_owner_selector::evaluate(&mut self.memory,&BTreeSet::new(),n,p,o,native::audio_dynamic_input_owner_selector::Context{manager:self.manager,conversion_cache:self.conversion_cache},&mut observe)?;Ok(vec![f32::from_bits(rounded(&result))])}
}
/// Selected fresh Init SFX registration only: one class1/owner0/parameter4,
/// default100, no overrides/previous bindings, constructor/initializer-owned Bus.
/// Real graph/target/state/input owners are mandatory even when the source
/// branch is empty. This API never creates a default playing voice or mixer.
pub fn register_fresh_sfx(owner:&mut FreshInitializationOwner,bus:&mut Bus,source:&[u8],graph:&mut native::audio_bus_effects_changed::Graph,targets:&mut native::audio_bus_control_application::Store,inputs:&native::audio_bus_gain_aggregation::Inputs,states:&mut native::audio_bus_gain_aggregation::CachedStates,conversion_cache:u32,s:&mut impl Services)->Result<ReadResult,Failure>{
 let fail=|error|Failure{error,unpublished_allocations:vec![],initialized_critical_sections:vec![],held_critical_sections:vec![]};
 let mut existing=owner.owned_memory().map_err(fail)?;if existing.contains_key(&bus.reference){return Err(fail(Error::InvalidAllocation));}
 existing.insert(bus.reference,Memory{reference:bus.reference,raw:bus.raw.to_vec()});let mut allocated=Allocations::with_existing(&existing).map_err(fail)?;
 let result=(||{
  if !cfg!(target_arch="x86_64"){return Err(Error::Backend("native x87 unavailable"));}
  if bus.word(0)!=0xff1380||bus.word(8)!=393239870||bus.word(0x24)!=0||bus.word(0x18)!=0||bus.word(0x1c)!=0||!owner.manager.bindings.is_empty(){return Err(Error::Backend("qualified fresh isolated Init SFX Bus required"));}
  // These are mandatory source/caller owners. The finite corpus uses the actual
  // initial empty native voice arrays; no arbitrary nonempty mixer is admitted.
  if !targets.voices.is_empty()||!targets.registered.is_empty()||!targets.roots.is_empty()||graph.buses.keys().any(|r|*r!=bus.reference){return Err(Error::Backend("normal voice/parent ownership has not been qualified for fresh registration"));}
  if graph.buses.get(&bus.reference).is_some_and(|old|old.reference!=bus.reference||old.raw!=bus.raw){return Err(Error::Backend("Graph Bus identity differs from the supplied owned Bus"));}
  let parsed=native::audio_rtpc_bank::read(source,[bus.word(0x30),bus.word(0x34)],source.len()as u32).map_err(|_|Error::Truncated)?;
  if parsed.entries.len()!=1{return Err(Error::Backend("actual single Init SFX subscription required"));}let e=&parsed.entries[0];
  if e.rtpc!=3273357900||e.parameter!=4||e.curve_id!=5685792||e.curve.scaling!=2||e.curve.points.len()!=2||e.curve.points.iter().map(|p|(p.from.to_bits(),p.to.to_bits(),p.interp)).collect::<Vec<_>>()!=vec![(0,0xbf800000,4),(0x42c80000,0,4)]{return Err(Error::Backend("source block differs from qualified Init SFX resource"));}
  let record=record_reference(&owner.manager,e.rtpc)?.ok_or(Error::UnresolvedReference)?;let old=owner.manager.records.get(&record).ok_or(Error::UnresolvedReference)?;if old.memory.raw.len()!=40||word(&old.memory.raw,8)!=0x42c80000||old.memory.raw[12..40]!=[0u8;28]{return Err(Error::Backend("fresh authored default100/no-override record required"));}
  let mut proposed=owner.clone_for_plan();let mut b=bus.clone();b.set_word(0x30,parsed.flags[0]);b.set_word(0x34,parsed.flags[1]);
  let mut binding=allocated.allocate(s,Role::Binding,owner.pool_id,32)?;binding.raw.fill(0);for(o,v)in[(0,b.reference),(4,4),(12,0),(16,1)]{put(&mut binding.raw,o,v);}
  let mut curves=allocated.allocate(s,Role::Curves,owner.pool_id,20)?;curves.raw.fill(0);put(&mut curves.raw,0,e.curve_id);put(&mut curves.raw,4,e.rtpc);
  let mut points=allocated.allocate(s,Role::Points,owner.pool_id,24)?;let mut point_bytes=Vec::with_capacity(24);for p in &e.curve.points{point_bytes.extend_from_slice(&p.from.to_bits().to_le_bytes());point_bytes.extend_from_slice(&p.to.to_bits().to_le_bytes());point_bytes.extend_from_slice(&p.interp.to_le_bytes());}points.raw.copy_from_slice(&point_bytes);
  for(o,v)in[(8,points.reference),(12,2),(16,2)]{put(&mut curves.raw,o,v);}for(o,v)in[(20,curves.reference),(24,1),(28,1)]{put(&mut binding.raw,o,v);}
  let binding_ref=binding.reference;let bucket=0x614+((b.reference+4)%193)as usize*4;put(&mut binding.raw,8,word(&proposed.manager.raw,bucket));put(&mut proposed.manager.raw,bucket,binding_ref);let count=word(&proposed.manager.raw,0x918);put(&mut proposed.manager.raw,0x918,count.wrapping_add(1));
  proposed.manager.bindings.insert(binding_ref,Binding{memory:binding,curves,points:BTreeMap::from([(points.reference,points)])});
  let mut refs=allocated.allocate(s,Role::RecordReferences,owner.pool_id,8)?;put(&mut refs.raw,0,binding_ref);let r=proposed.manager.records.get_mut(&record).unwrap();for(o,v)in[(28,refs.reference),(32,1),(36,2)]{put(&mut r.memory.raw,o,v);}r.subscribers=refs;
  let mut g=native::audio_bus_effects_changed::Graph{buses:graph.buses.clone(),caches:graph.caches.clone(),groups:graph.groups.iter().map(|(&r,q)|(r,native::audio_bus_effects_changed::Group{children:q.children.clone(),active:q.active})).collect()};g.buses.insert(b.reference,b.clone());
  let mut t=native::audio_bus_control_application::Store{voices:targets.voices.clone(),bus_ids:targets.bus_ids.clone(),registered:targets.registered.clone(),roots:targets.roots.clone()};
  let mut memory=proposed.owned_memory()?;memory.insert(b.reference,Memory{reference:b.reference,raw:b.raw.to_vec()});let mut state_copy=native::audio_bus_gain_aggregation::CachedStates{entries:states.entries.clone(),tables:states.tables.clone()};
  // B13540 ascending buckets and linked next+8. One source binding is admitted,
  // nevertheless preserve the native traversal/filter rather than B11850.
  let mut selected=Vec::new();for bucket in 0..193 {let mut at=word(&proposed.manager.raw,0x614+bucket*4);let mut seen=BTreeSet::new();while at!=0{if !seen.insert(at){return Err(Error::CyclicList);}let binding=proposed.manager.bindings.get(&at).ok_or(Error::UnresolvedReference)?;let q=&binding.memory.raw;if q.len()!=32{return Err(Error::InvalidAllocation);}if word(q,0)==b.reference{if word(q,16)!=1{return Err(Error::Backend("fresh class1 notify-all required"));}selected.push(word(q,0));}at=word(q,8);}}
  let logical=native::audio_rtpc_manager::Manager{records:proposed.manager.records.values().map(|r|(word(&r.memory.raw,0),native::audio_rtpc_manager::Record{default:f32::from_bits(word(&r.memory.raw,8)),overrides:BTreeMap::new()})).collect(),bindings:BTreeMap::from([((b.reference,4),vec![native::audio_rtpc_manager::RouteCurve{rtpc:e.rtpc,curve:e.curve.clone()}])])};
  {let mut contribution=Rtpc{memory,manager:proposed.reference,conversion_cache,state:&mut state_copy};let mut observe=();let mut application=native::audio_bus_gain_application::Backend{targets:&mut t,tables:&inputs.tables,manager:&logical,observer:&mut observe,calls:vec![]};let mut gain=native::audio_bus_gain_aggregation::Backend{inputs,contribution:&mut contribution,application:&mut application};for selected in selected{g.changed(selected,&mut gain)?;}}
  b=g.buses[&b.reference].clone();
  // B04A00 returns directly for authored parameter4 (only24..28 invoke body).
  *owner=proposed;*bus=b;*graph=g;*targets=t;*states=state_copy;Ok(ReadResult{consumed:parsed.consumed,remaining:parsed.remaining})
 })();result.map_err(|error|Failure{error,unpublished_allocations:allocated.blocks,initialized_critical_sections:vec![],held_critical_sections:vec![]})
}

#[cfg(test)]#[path="audio_init_rtpc_owner_tests.rs"]mod tests;
