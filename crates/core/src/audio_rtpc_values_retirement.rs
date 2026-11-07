//! Selected B12A80 body retirement after actual fresh Init/first-global values.
//! Consumes the operational owner. Manager/Bus/registry/11CS remain distinct
//! physical owners; dangling native pool words survive only as diagnostic raw.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,
 audio_init_rtpc_owner::FreshInitializationOwner,audio_rtpc_first_global_value::Values,
 audio_bus_registry::Bus};
use std::collections::{BTreeMap,BTreeSet};

#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Role{Manager954,Registry2260,Bus200,Record40,Values64,Subscribers,Binding32,Curves20,Points24,PoolC0}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]pub enum Custody{Live,Freed,Indeterminate}
#[derive(Debug,Clone)]pub struct BlockSnapshot{pub role:Role,pub memory:Memory,pub custody:Custody}
#[derive(Debug,Clone)]pub struct Snapshot{pub manager:u32,pub blocks:BTreeMap<u32,BlockSnapshot>,pub critical_sections:Vec<u32>,pub cursor:usize,pub actions:usize,pub poisoned:bool}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]pub enum Operation{Entry{va:u32,receiver:u32,argument:Option<u32>},Write{pc:u32,reference:u32,offset:usize,value:u32},Free{caller:u32,reference:u32,role:Role}}
/// Err cannot implicitly promise that a physical block still exists. A provider
/// explicitly returns Retained only when no deallocation occurred. Otherwise
/// Indeterminate permanently stops this ledger: retry could double-free.
pub enum FreeResult{Freed,Retained(Error),Indeterminate(Error)}
pub trait Services{
 fn free_owned(&mut self,pool:u32,role:Role,memory:&Memory)->FreeResult;
 /// Passive trace only, after the real operation. It substitutes no callback,
 /// allocation, free or value; snapshots mark freed bytes as historical.
 fn observe(&mut self,_operation:Operation,_snapshot:&Snapshot){}
}
#[must_use="Rejected input owners remain owned and must be retained or explicitly retired"]
pub struct BeginFailure{pub error:Error,pub owner:FreshInitializationOwner,pub values:Values,pub bus:Bus}
struct Block{role:Role,memory:Memory,custody:Custody}
#[must_use="Retirement progress and remaining physical custody must not be discarded"]
pub struct Retiring{pool:u32,manager:u32,registry:u32,bus:u32,critical_sections:Vec<u32>,blocks:BTreeMap<u32,Block>,actions:Vec<Operation>,cursor:usize,poisoned:bool}
/// No operational FreshInitializationOwner/Values is returned. Its raw manager
/// and freed buffers are diagnostics, not reusable table/pool ownership.
#[must_use="The remaining Manager, Bus, registry and critical sections still require their own qualified callers"]
pub struct Retired{remaining:RemainingOwners,history:Snapshot}
/// These three allocations and11CS survive B12A80. This type offers no implicit
/// Drop/free, native caller/global0, Bus teardown or registry CS destruction.
#[must_use="B12A80 did not release these allocations or critical sections"]
pub struct RemainingOwners{pool:u32,manager:Memory,registry:Memory,bus:Memory,critical_sections:Vec<u32>}
impl RemainingOwners{
 pub fn pool(&self)->u32{self.pool}
 pub fn manager(&self)->&Memory{&self.manager}
 pub fn registry(&self)->&Memory{&self.registry}
 pub fn bus(&self)->&Memory{&self.bus}
 pub fn critical_sections(&self)->&[u32]{&self.critical_sections}
}
impl Retired{
 pub fn history(&self)->&Snapshot{&self.history}
 pub fn remaining(&self)->&RemainingOwners{&self.remaining}
 pub fn into_remaining(self)->RemainingOwners{self.remaining}
}
impl Retiring{
 pub fn snapshot(&self)->Snapshot{Snapshot{manager:self.manager,blocks:self.blocks.iter().map(|(&p,b)|(p,BlockSnapshot{role:b.role,memory:b.memory.clone(),custody:b.custody})).collect(),critical_sections:self.critical_sections.clone(),cursor:self.cursor,actions:self.actions.len(),poisoned:self.poisoned}}
 /// Native stores already performed before an unavailable physical free remain
 /// visible. This is resumable local provider custody, not native fault rollback.
 pub fn advance(&mut self,services:&mut impl Services)->Result<bool,Error>{
  if self.poisoned{return Err(Error::Backend("physical release custody indeterminate; retry forbidden"));}
  while self.cursor<self.actions.len(){let operation=self.actions[self.cursor];match operation{
   Operation::Entry{..}=>{},
   Operation::Write{reference,offset,value,..}=>{let b=self.blocks.get_mut(&reference).ok_or(Error::UnresolvedReference)?;if b.custody!=Custody::Live{return Err(Error::InvalidAllocation);}put(&mut b.memory.raw,offset,value);},
   Operation::Free{reference,role,..}=>{let b=self.blocks.get_mut(&reference).ok_or(Error::UnresolvedReference)?;if b.custody!=Custody::Live||b.role!=role{return Err(Error::InvalidAllocation);}match services.free_owned(self.pool,role,&b.memory){
    FreeResult::Freed=>b.custody=Custody::Freed,
    FreeResult::Retained(error)=>return Err(error),
    FreeResult::Indeterminate(error)=>{b.custody=Custody::Indeterminate;self.poisoned=true;return Err(error);}
   }},
  }self.cursor+=1;services.observe(operation,&self.snapshot());}Ok(true)
 }
 /// Err returns the unchanged retirement state, never a usable FreshOwner.
 pub fn finish(mut self)->Result<Retired,Self>{
  if self.poisoned||self.cursor!=self.actions.len(){return Err(self);}
  let history=self.snapshot();let take=|blocks:&mut BTreeMap<u32,Block>,p|blocks.remove(&p).unwrap().memory;
  let remaining=RemainingOwners{pool:self.pool,manager:take(&mut self.blocks,self.manager),registry:take(&mut self.blocks,self.registry),bus:take(&mut self.blocks,self.bus),critical_sections:self.critical_sections};
  Ok(Retired{remaining,history})
 }
}
fn word(raw:&[u8],offset:usize)->u32{u32::from_le_bytes(raw[offset..offset+4].try_into().unwrap())}
fn put(raw:&mut[u8],offset:usize,value:u32){raw[offset..offset+4].copy_from_slice(&value.to_le_bytes());}
fn hex(s:&str)->Result<Vec<u8>,Error>{if s.len()%2!=0{return Err(Error::Truncated);}s.as_bytes().chunks_exact(2).map(|p|std::str::from_utf8(p).ok().and_then(|s|u8::from_str_radix(s,16).ok()).ok_or(Error::Truncated)).collect()}
fn source()->Result<(BTreeMap<u32,u32>,Vec<u8>),Error>{
 let d:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_init_rtpc_owner_source.json")).map_err(|_|Error::Truncated)?;
 if d["schema"]!="original_init_rtpc_selected_configuration_v1"||d["original_inputs_not_runtime_oracle"]!=true{return Err(Error::Truncated);}
 let entries=d["STMG"]["defaults"].as_array().ok_or(Error::Truncated)?;let mut out=BTreeMap::new();
 for e in entries{let id=u32::try_from(e["id"].as_u64().ok_or(Error::Truncated)?).map_err(|_|Error::Truncated)?;let bits=u32::try_from(e["default_bits"].as_u64().ok_or(Error::Truncated)?).map_err(|_|Error::Truncated)?;if out.insert(id,bits).is_some(){return Err(Error::InvalidAllocation);}}
 let block=hex(d["sfx_rtpc_block_hex"].as_str().ok_or(Error::Truncated)?)?;
 if out.len()!=21||block.len()!=41{return Err(Error::Truncated);}Ok((out,block))
}
struct Plan{blocks:BTreeMap<u32,Block>,actions:Vec<Operation>,ranges:Vec<(u32,u32)>}
impl Plan{
 fn add(&mut self,role:Role,memory:Memory)->Result<(),Error>{
  let p=memory.reference;let size=u32::try_from(memory.raw.len()).map_err(|_|Error::InvalidAllocation)?;let end=p.checked_add(size).ok_or(Error::InvalidAllocation)?;
  if p==0||size==0||self.ranges.iter().any(|&(a,b)|p<b&&a<end){return Err(Error::InvalidAllocation);}self.ranges.push((p,end));self.blocks.insert(p,Block{role,memory,custody:Custody::Live});Ok(())
 }
 fn raw(&self,p:u32)->Result<&[u8],Error>{Ok(&self.blocks.get(&p).ok_or(Error::UnresolvedReference)?.memory.raw)}
 fn size(&self,p:u32,n:usize)->Result<(),Error>{if self.raw(p)?.len()!=n{return Err(Error::InvalidAllocation);}Ok(())}
 fn entry(&mut self,va:u32,receiver:u32,argument:Option<u32>){self.actions.push(Operation::Entry{va,receiver,argument});}
 fn write(&mut self,pc:u32,p:u32,o:usize,v:u32)->Result<(),Error>{let b=self.blocks.get(&p).ok_or(Error::UnresolvedReference)?;if o.checked_add(4).is_none_or(|end|end>b.memory.raw.len()){return Err(Error::InvalidAllocation);}self.actions.push(Operation::Write{pc,reference:p,offset:o,value:v});Ok(())}
 fn free(&mut self,caller:u32,p:u32,role:Role)->Result<(),Error>{let b=self.blocks.get(&p).ok_or(Error::UnresolvedReference)?;if b.role!=role||self.actions.iter().any(|op|matches!(op,Operation::Free{reference,..}if *reference==p)){return Err(Error::InvalidAllocation);}self.actions.push(Operation::Free{caller,reference:p,role});Ok(())}
}
fn plan(owner:&FreshInitializationOwner,values:&Values,bus:&Bus)->Result<Plan,Error>{
 if owner.pool_id!=u32::MAX||owner.reference==0||bus.word(0)!=0xff1380||bus.word(8)!=393239870||bus.word(0x24)!=0||bus.word(0x18)!=0||bus.word(0x1c)!=0{return Err(Error::Backend("selected fresh isolated Init SFX ownership required"));}
 let mut p=Plan{blocks:BTreeMap::new(),actions:vec![],ranges:vec![]};let manager=owner.reference;let raw=owner.full_raw();
 if word(&raw,0x304)!=21||word(&raw,0x610)!=0||word(&raw,0x918)!=1||owner.manager.records.len()!=21||owner.manager.bindings.len()!=1{return Err(Error::InvalidAllocation);}
 for offset in [0x91c,0x920,0x930,0x938,0x93c,0x940,0x944,0x94c,0x950]{if word(&raw,offset)!=0{return Err(Error::Backend("nonempty delayed/curve source not qualified"));}}
 if word(&raw,0x308)!=u32::MAX||word(&raw,0x928)!=16||word(&raw,0x92c)!=u32::MAX||word(&raw,0x948)!=u32::MAX||word(&raw,0x934)!=owner.pool_nodes.reference{return Err(Error::InvalidAllocation);}
 let expected_sections=(0..11).map(|i|owner.node_registry.reference.checked_add(i*0x320).ok_or(Error::InvalidAllocation)).collect::<Result<Vec<_>,_>>()?;
 if owner.node_registry.raw.len()!=0x2260||owner.pool_nodes.raw.len()!=0xc0||owner.initialized_critical_sections!=expected_sections{return Err(Error::InvalidAllocation);}
 p.add(Role::Manager954,Memory{reference:manager,raw:raw.to_vec()})?;p.add(Role::Registry2260,owner.node_registry.clone())?;p.add(Role::Bus200,Memory{reference:bus.reference,raw:bus.raw.to_vec()})?;p.add(Role::PoolC0,owner.pool_nodes.clone())?;
 let(defaults,block)=source()?;let key=word(&block,2);let parameter=word(&block,6);let curve_id=word(&block,10);let scaling=u32::from(block[14]);let point_count=u32::from(u16::from_le_bytes(block[15..17].try_into().unwrap()));
 let mut connected_values=BTreeSet::new();
 for(&reference,r)in &owner.manager.records{
  if r.memory.reference!=reference||r.memory.raw.len()!=40{return Err(Error::InvalidAllocation);}let a=&r.memory.raw;
  if defaults.get(&word(a,0))!=Some(&word(a,8))||word(a,24)!=0{return Err(Error::Backend("authored defaults and null transition owner required"));}
  let table=word(a,12);if table==0{if word(a,16)!=0||word(a,20)!=0{return Err(Error::InvalidAllocation);}}
  else{if word(a,0)!=key||word(a,16)!=1||word(a,20)!=8||!connected_values.insert(table){return Err(Error::InvalidAllocation);}let v=values.blocks.get(&table).ok_or(Error::UnresolvedReference)?;if v.reference!=table||v.raw.len()!=64||word(&v.raw,0)!=0{return Err(Error::InvalidAllocation);}p.add(Role::Values64,v.clone())?;}
  let subscribers=word(a,28);let count=word(a,32);let capacity=word(a,36);
  if subscribers!=r.subscribers.reference||count>capacity||usize::try_from(capacity).ok().and_then(|n|n.checked_mul(4))!=Some(r.subscribers.raw.len()){return Err(Error::InvalidAllocation);}
  if subscribers==0{if count!=0||capacity!=0{return Err(Error::InvalidAllocation);}}
  else{if word(a,0)!=key||count!=1||capacity!=2{return Err(Error::InvalidAllocation);}p.add(Role::Subscribers,r.subscribers.clone())?;}
  p.add(Role::Record40,r.memory.clone())?;
 }
 if connected_values.len()!=values.blocks.len(){return Err(Error::InvalidAllocation);}
 let(&binding,b)=owner.manager.bindings.iter().next().ok_or(Error::UnresolvedReference)?;
 if b.memory.reference!=binding||b.memory.raw.len()!=32||word(&b.memory.raw,0)!=bus.reference||word(&b.memory.raw,4)!=parameter||word(&b.memory.raw,12)!=0||word(&b.memory.raw,16)!=1||word(&b.memory.raw,20)!=b.curves.reference||word(&b.memory.raw,24)!=1||word(&b.memory.raw,28)!=1||b.curves.raw.len()!=20{return Err(Error::InvalidAllocation);}
 let c=&b.curves.raw;let points=word(c,8);
 if word(c,0)!=curve_id||word(c,4)!=key||word(c,12)!=point_count||word(c,16)!=scaling||b.points.len()!=1{return Err(Error::InvalidAllocation);}
 let point_memory=b.points.get(&points).ok_or(Error::UnresolvedReference)?;
 if point_memory.reference!=points||point_count.checked_mul(12)!=Some(point_memory.raw.len()as u32)||point_memory.raw!=block[17..]{return Err(Error::InvalidAllocation);}
 p.add(Role::Binding32,b.memory.clone())?;p.add(Role::Curves20,b.curves.clone())?;p.add(Role::Points24,point_memory.clone())?;
 p.entry(0xb12a80,manager,None);let mut records=BTreeSet::new();let mut count=21u32;
 for bucket in 0..193{
  if word(&raw,0x30c+bucket*4)!=0{return Err(Error::Backend("secondary table must be empty"));}
  let reference=word(&raw,bucket*4);if reference==0{continue;}let a=p.raw(reference)?.to_vec();
  // Authored21 heads are collision-free. A new collision/list corpus is not
  // admitted merely because a generalized implementation could walk it.
  if a.len()!=40||word(&a,4)!=0||word(&a,0)%193!=bucket as u32||!records.insert(reference){return Err(Error::InvalidAllocation);}
  count-=1;p.write(0xb12aff,manager,bucket*4,0)?;p.write(0xb12b11,manager,0x304,count)?;p.write(0xb12b2d,reference,16,0)?;
  let table=word(&a,12);if table!=0{p.write(0xb12b38,reference,16,0)?;p.free(0xb12b41,table,Role::Values64)?;p.write(0xb12b49,reference,12,0)?;p.write(0xb12b4c,reference,20,0)?;}
  let subscribers=word(&a,28);if subscribers!=0{if word(p.raw(subscribers)?,0)!=binding{return Err(Error::InvalidAllocation);}p.write(0xb12b57,reference,32,0)?;p.free(0xb12b64,subscribers,Role::Subscribers)?;p.write(0xb12b6c,reference,28,0)?;p.write(0xb12b73,reference,36,0)?;}
  p.free(0xb12b7e,reference,Role::Record40)?;
 }
 if records.len()!=21||count!=0{return Err(Error::InvalidAllocation);}
 let binding_bucket=(bus.reference.wrapping_add(parameter)%193)as usize;let heads=(0..193).filter(|&i|word(&raw,0x614+i*4)!=0).collect::<Vec<_>>();
 if heads!=vec![binding_bucket]||word(&raw,0x614+binding_bucket*4)!=binding||word(&b.memory.raw,8)!=0{return Err(Error::InvalidAllocation);}
 p.write(0xb12c0c,manager,0x614+binding_bucket*4,0)?;p.write(0xb12c1e,manager,0x918,0)?;p.entry(0xb11d70,manager,Some(binding));
 p.free(0xb11ddc,points,Role::Points24)?;p.write(0xb11de4,b.curves.reference,8,0)?;p.write(0xb11dee,b.curves.reference,12,0)?;p.write(0xb11df5,b.curves.reference,16,0)?;p.write(0xb11e61,binding,24,0)?;
 p.write(0xb12c42,binding,24,0)?;p.free(0xb12c4f,b.curves.reference,Role::Curves20)?;p.write(0xb12c5a,binding,20,0)?;p.write(0xb12c61,binding,28,0)?;p.free(0xb12c6c,binding,Role::Binding32)?;
 let backing=owner.pool_nodes.reference;let mut interior=word(&raw,0x924);let mut seen=BTreeSet::new();
 while interior!=0{let offset=interior.checked_sub(backing).ok_or(Error::InvalidAllocation)?as usize;if offset>=0xc0||offset%12!=0||!seen.insert(interior){return Err(Error::InvalidAllocation);}interior=word(&owner.pool_nodes.raw,offset);}
 if seen.len()!=16{return Err(Error::InvalidAllocation);}p.entry(0xb129d0,manager+0x91c,None);p.free(0xb12a4a,backing,Role::PoolC0)?;
 for(pc,offset)in [(0xb12a52,0x928),(0xb12a59,0x92c),(0xb12a60,0x91c),(0xb12a66,0x920)]{p.write(pc,manager,offset,0)?;}
 p.entry(0xb12920,manager+0x938,None);for(pc,offset)in [(0xb1299f,0x944),(0xb129a6,0x948),(0xb129ad,0x938),(0xb129b3,0x93c)]{p.write(pc,manager,offset,0)?;}Ok(p)
}
/// Input validation precedes all physical operations. The operational FreshOwner
/// and Values are moved, not borrowed; begin failure returns them unchanged.
pub fn begin(owner:FreshInitializationOwner,values:Values,bus:Bus)->Result<Retiring,BeginFailure>{
 match plan(&owner,&values,&bus){
  Err(error)=>Err(BeginFailure{error,owner,values,bus}),
  Ok(plan)=>Ok(Retiring{pool:owner.pool_id,manager:owner.reference,registry:owner.node_registry.reference,bus:bus.reference,critical_sections:owner.initialized_critical_sections,blocks:plan.blocks,actions:plan.actions,cursor:0,poisoned:false}),
 }
}

#[cfg(test)]
#[path="audio_rtpc_values_retirement_tests.rs"]
mod tests;
