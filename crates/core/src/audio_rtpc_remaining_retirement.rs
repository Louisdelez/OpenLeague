//! Selected LOCAL Bus→Manager-tail→Registry-tail after qualified B12A80 body.
//! Consumes opaque RemainingOwners, explicit globals and owned11CS context.
//! No whole engine shutdown, normal audio activation or implicit Drop/free.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,
 audio_rtpc_values_retirement::{RemainingOwners,Role,Custody,FreeResult}};
use std::collections::{BTreeMap,BTreeSet};

#[derive(Debug,Clone,Copy,PartialEq,Eq)]pub enum Phase{Bus,ManagerTail,RegistryTail}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]pub enum CriticalOperation{Enter,Leave,Delete}
/// Copyable diagnostic words, not an unforgeable physical global owner.
#[derive(Debug,Clone,Copy,PartialEq,Eq)]pub struct GlobalWords{pub manager:u32,pub registry:u32,pub pool:u32,pub master_bus:u32,pub alternate_bus:u32}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]pub struct CriticalState{pub reference:u32,pub recursion:u32,pub custody:Custody}
/// Mandatory caller-supplied ownership context; no defaults/Clone. The native
/// stack top is explicit for the observed AF6650 by-reference ABI argument.
#[must_use="Global words and critical sections remain separately owned"]
pub struct Context{globals:GlobalWords,sections:Vec<CriticalState>,native_stack_top:u32}
impl Context{
 pub fn supplied(globals:GlobalWords,sections:Vec<CriticalState>,native_stack_top:u32)->Self{Self{globals,sections,native_stack_top}}
 pub fn globals(&self)->GlobalWords{self.globals}
 pub fn sections(&self)->&[CriticalState]{&self.sections}
 pub fn native_stack_top(&self)->u32{self.native_stack_top}
}
#[derive(Debug,Clone)]pub struct BlockSnapshot{pub role:Role,pub memory:Memory,pub custody:Custody}
/// After an indeterminate service result, raw/globals are last-confirmed
/// diagnostic metadata only; poisoned=true forbids resuming or finishing.
#[derive(Debug,Clone)]pub struct Snapshot{pub blocks:BTreeMap<u32,BlockSnapshot>,pub globals:GlobalWords,pub sections:Vec<CriticalState>,pub cursor:usize,pub actions:usize,pub poisoned:bool}
#[derive(Debug,Clone,PartialEq,Eq)]pub enum Operation{
 Entry{phase:Phase,va:u32,receiver:u32,args:Vec<u32>},
 Write{phase:Phase,pc:u32,reference:u32,offset:usize,bytes:Vec<u8>},
 Critical{phase:Phase,pc:u32,operation:CriticalOperation,reference:u32},
 Free{phase:Phase,caller:u32,reference:u32,role:Role},
 GlobalWrite{phase:Phase,pc:u32,address:u32,value:u32},
 Boundary{phase:Phase,address:u32},
}
/// Applied confirms that this exact effect occurred. Retained confirms no
/// effect occurred and permits suffix retry. Indeterminate permanently poisons
/// custody; these are local service contracts, not native fault rollback.
pub enum EffectResult{Applied,Retained(Error),Indeterminate(Error)}
pub trait Services{
 fn store_owned(&mut self,role:Role,memory:&Memory,offset:usize,bytes:&[u8])->EffectResult;
 fn critical(&mut self,operation:CriticalOperation,section:CriticalState)->EffectResult;
 fn free_owned(&mut self,pool:u32,role:Role,memory:&Memory)->FreeResult;
 fn store_global(&mut self,address:u32,old:u32,value:u32)->EffectResult;
 /// Passive metadata only, after the completed real operation; no fabricated
 /// logical callback, physical allocator or synchronization result.
 fn observe(&mut self,_operation:&Operation,_snapshot:&Snapshot){}
}
#[must_use="Rejected RemainingOwners and Context are returned intact"]
pub struct BeginFailure{pub error:Error,pub remaining:RemainingOwners,pub context:Context}
struct Block{role:Role,memory:Memory,custody:Custody}
#[must_use="Partial retirement and pending physical custody must be retained"]
pub struct Retiring{_consumed:RemainingOwners,context:Context,blocks:BTreeMap<u32,Block>,actions:Vec<Operation>,cursor:usize,poisoned:bool}
/// Diagnostic state only: no operational Remaining/FreshOwner/Values returns.
#[must_use="Historical state records completed selected retirement, not fullbank shutdown"]
pub struct Retired{history:Snapshot}
impl Retired{pub fn history(&self)->&Snapshot{&self.history}}
impl Retiring{
 pub fn snapshot(&self)->Snapshot{Snapshot{blocks:self.blocks.iter().map(|(&r,b)|(r,BlockSnapshot{role:b.role,memory:b.memory.clone(),custody:b.custody})).collect(),globals:self.context.globals,sections:self.context.sections.clone(),cursor:self.cursor,actions:self.actions.len(),poisoned:self.poisoned}}
 fn effect(&mut self,result:EffectResult)->Result<(),Error>{match result{EffectResult::Applied=>Ok(()),EffectResult::Retained(e)=>Err(e),EffectResult::Indeterminate(e)=>{self.poisoned=true;Err(e)}}}
 pub fn advance(&mut self,services:&mut impl Services)->Result<bool,Error>{
  if self.poisoned{return Err(Error::Backend("remaining physical custody indeterminate; retry forbidden"));}
  while self.cursor<self.actions.len(){let operation=self.actions[self.cursor].clone();match &operation{
   Operation::Entry{..}|Operation::Boundary{..}=>{},
   Operation::Write{reference,offset,bytes,..}=>{
    let b=self.blocks.get(reference).ok_or(Error::UnresolvedReference)?;
    if b.custody!=Custody::Live||offset.checked_add(bytes.len()).is_none_or(|end|end>b.memory.raw.len()){return Err(Error::InvalidAllocation);}
    let result=services.store_owned(b.role,&b.memory,*offset,bytes);self.effect(result)?;
    self.blocks.get_mut(reference).unwrap().memory.raw[*offset..*offset+bytes.len()].copy_from_slice(bytes);
   },
   Operation::Critical{operation:kind,reference,..}=>{
    let i=self.context.sections.iter().position(|s|s.reference==*reference).ok_or(Error::UnresolvedReference)?;let s=self.context.sections[i];
    if s.custody!=Custody::Live{return Err(Error::InvalidAllocation);}
    let next=match kind{CriticalOperation::Enter=>s.recursion.checked_add(1).ok_or(Error::InvalidAllocation)?,CriticalOperation::Leave=>s.recursion.checked_sub(1).ok_or(Error::InvalidAllocation)?,CriticalOperation::Delete=>{if s.recursion!=0{return Err(Error::Backend("cannot delete held critical section"));}0}};
    let result=services.critical(*kind,s);
    if matches!(&result,EffectResult::Indeterminate(_)){self.context.sections[i].custody=Custody::Indeterminate;}
    self.effect(result)?;self.context.sections[i].recursion=next;
    if *kind==CriticalOperation::Delete{self.context.sections[i].custody=Custody::Freed;}
   },
   Operation::Free{reference,role,..}=>{
    let b=self.blocks.get(reference).ok_or(Error::UnresolvedReference)?;
    if b.custody!=Custody::Live||b.role!=*role{return Err(Error::InvalidAllocation);}
    if *role==Role::Registry2260&&self.context.sections.iter().any(|s|s.custody!=Custody::Freed||s.recursion!=0){return Err(Error::Backend("registry free requires all11CS deleted"));}
    let result=services.free_owned(self.context.globals.pool,*role,&b.memory);
    match result{FreeResult::Freed=>self.blocks.get_mut(reference).unwrap().custody=Custody::Freed,FreeResult::Retained(e)=>return Err(e),FreeResult::Indeterminate(e)=>{self.blocks.get_mut(reference).unwrap().custody=Custody::Indeterminate;self.poisoned=true;return Err(e)}}
   },
   Operation::GlobalWrite{address,value,..}=>{
    let old=match *address{0x14a7a3c=>self.context.globals.manager,0x14a7a08=>self.context.globals.registry,_=>return Err(Error::InvalidAllocation)};
    let result=services.store_global(*address,old,*value);self.effect(result)?;
    match *address{0x14a7a3c=>self.context.globals.manager=*value,0x14a7a08=>self.context.globals.registry=*value,_=>unreachable!()}
   },
  }self.cursor+=1;services.observe(&operation,&self.snapshot());}Ok(true)
 }
 pub fn finish(self)->Result<Retired,Self>{
  if self.poisoned||self.cursor!=self.actions.len()||self.blocks.values().any(|b|b.custody!=Custody::Freed)||self.context.sections.iter().any(|s|s.custody!=Custody::Freed||s.recursion!=0)||self.context.globals.manager!=0||self.context.globals.registry!=0{return Err(self);}
  Ok(Retired{history:self.snapshot()})
 }
}
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
struct Plan{blocks:BTreeMap<u32,Block>,actions:Vec<Operation>,ranges:Vec<(u32,u32)>}
impl Plan{
 fn add(&mut self,role:Role,memory:Memory)->Result<(),Error>{let size=u32::try_from(memory.raw.len()).map_err(|_|Error::InvalidAllocation)?;let end=memory.reference.checked_add(size).ok_or(Error::InvalidAllocation)?;
  if memory.reference==0||size==0||self.ranges.iter().any(|&(a,b)|memory.reference<b&&a<end){return Err(Error::InvalidAllocation);}self.ranges.push((memory.reference,end));self.blocks.insert(memory.reference,Block{role,memory,custody:Custody::Live});Ok(())}
 fn entry(&mut self,phase:Phase,va:u32,receiver:u32,args:&[u32]){self.actions.push(Operation::Entry{phase,va,receiver,args:args.to_vec()});}
 fn write(&mut self,phase:Phase,pc:u32,r:u32,o:usize,value:u32){self.actions.push(Operation::Write{phase,pc,reference:r,offset:o,bytes:value.to_le_bytes().to_vec()});}
 fn critical(&mut self,phase:Phase,pc:u32,operation:CriticalOperation,r:u32){self.actions.push(Operation::Critical{phase,pc,operation,reference:r});}
 fn free(&mut self,phase:Phase,caller:u32,r:u32,role:Role){self.actions.push(Operation::Free{phase,caller,reference:r,role});}
}
fn plan(remaining:&RemainingOwners,context:&Context)->Result<Plan,Error>{
 let manager=remaining.manager();let registry=remaining.registry();let bus=remaining.bus();
 if manager.raw.len()!=0x954||registry.raw.len()!=0x2260||bus.raw.len()!=200{return Err(Error::InvalidAllocation);}
 let globals=context.globals;
 if globals.manager!=manager.reference||globals.registry!=registry.reference||globals.pool!=remaining.pool()||globals.pool!=u32::MAX||globals.master_bus!=0||globals.alternate_bus!=0{return Err(Error::Backend("selected actual global owner context required"));}
 let mut p=Plan{blocks:BTreeMap::new(),actions:vec![],ranges:vec![]};p.add(Role::Manager954,manager.clone())?;p.add(Role::Registry2260,registry.clone())?;p.add(Role::Bus200,bus.clone())?;
 let mut expected=vec![];for i in 0..11u32{expected.push(registry.reference.checked_add(i*0x320).ok_or(Error::InvalidAllocation)?);}
 if remaining.critical_sections()!=expected.as_slice()||context.sections.len()!=11||context.sections.iter().map(|s|s.reference).collect::<Vec<_>>()!=expected||context.sections.iter().any(|s|s.recursion!=0||s.custody!=Custody::Live){return Err(Error::InvalidAllocation);}
 let stack_key=context.native_stack_top.checked_sub(12).ok_or(Error::InvalidAllocation)?;
 if stack_key==0||context.native_stack_top%4!=0||p.ranges.iter().any(|&(a,b)|stack_key<b&&a<context.native_stack_top){return Err(Error::InvalidAllocation);}
 let m=&manager.raw;let r=&registry.raw;let b=&bus.raw;
 if word(b,0)!=0xff1380||word(b,4)!=0||word(b,8)!=393239870||word(b,12)!=1||b[0x2f]!=2||word(b,0x30)!=0x10||word(b,0x34)!=0{return Err(Error::Backend("selected single registered InitSFX Bus source required"));}
 if [0x10,0x14,0x18,0x1c,0x20,0x24,0x28,0x38,0x40,0x44,0x48,0x50,0x54,0x58].iter().any(|&o|word(b,o)!=0){return Err(Error::Backend("parent/voice/transition/extra Bus owner outside selected source"));}
 for base in [0x68,0x84,0xa0]{if [0,4,8,12,20,24].iter().any(|&o|word(b,base+o)!=0)||word(b,base+16)!=100{return Err(Error::InvalidAllocation);}}
 if word(m,0x304)!=0||word(m,0x610)!=0||word(m,0x918)!=0||word(m,0x308)!=u32::MAX{return Err(Error::Backend("body-retired Manager required"));}
 for bucket in 0..193{if word(m,bucket*4)!=0||word(m,0x30c+bucket*4)!=0||word(m,0x614+bucket*4)!=0{return Err(Error::InvalidAllocation);}}
 if [0x91c,0x920,0x928,0x92c,0x930,0x938,0x93c,0x940,0x944,0x948,0x94c,0x950].iter().any(|&o|word(m,o)!=0){return Err(Error::Backend("nonempty retired pool metadata outside selected source"));}
 // +924/+934 are historical addresses only. Never dereference them or treat
 // them as allocations to free; they survived the already-completed body.
 let bucket=(word(b,8)%193)as usize;
 for selector in 0..11usize{
  let base=selector*0x320;let count=word(r,base+0x31c);
  if count!=u32::from(selector==1){return Err(Error::InvalidAllocation);}
  for index in 0..193{let expected=if selector==1&&index==bucket{bus.reference}else{0};if word(r,base+0x18+index*4)!=expected{return Err(Error::InvalidAllocation);}}
 }
 let phase=Phase::Bus;let B=bus.reference;let M=manager.reference;let R=registry.reference;let cs=expected[1];
 p.entry(phase,0xb00180,B,&[]);p.entry(phase,0xaf6430,R,&[1]);p.critical(phase,0xb001a8,CriticalOperation::Enter,cs);p.write(phase,0xb001ae,B,12,0);
 p.entry(phase,0xaf6430,R,&[1]);p.critical(phase,0xb001e0,CriticalOperation::Enter,cs);p.entry(phase,0xaf6650,R+0x338,&[stack_key]);
 p.write(phase,0xaf66ac,R,0x338+bucket*4,0);p.write(phase,0xaf66ae,R,0x63c,0);p.critical(phase,0xb001f3,CriticalOperation::Leave,cs);
 p.entry(phase,0xae13f0,B,&[]);p.entry(phase,0xafec20,B,&[]);p.entry(phase,0xb022f0,B,&[0]);p.entry(phase,0xb02150,B,&[]);p.write(phase,0xb0215b,B,0,0xff1380);
 for base in [0x84,0xa0]{p.entry(phase,0xb04840,B+base as u32,&[]);for(pc,o)in[(0xb04898,12),(0xb0489f,16),(0xb048a6,0),(0xb048ac,4)]{p.write(phase,pc,B,base+o,0);}}
 p.entry(phase,0xb047b0,B+0x68,&[]);for(pc,o)in[(0xb04810,12),(0xb04817,16),(0xb0481e,0),(0xb04824,4)]{p.write(phase,pc,B,0x68+o,0);}
 p.write(phase,0xb02246,B,0,0xff123c);p.entry(phase,0xafdf20,B,&[]);p.actions.push(Operation::Write{phase,pc:0xafdf27,reference:B,offset:0x2f,bytes:vec![b[0x2f]|1]});p.write(phase,0xafdf2e,B,0,0xff10f0);
 p.entry(phase,0xb12f40,M,&[B,4]);p.write(phase,0xafdf8d,B,0x30,0);p.write(phase,0xafdf92,B,0x34,0);p.write(phase,0xafdfcf,B,0x10,0);p.write(phase,0xafe0c6,B,0x28,0);
 p.entry(phase,0xafd4f0,B,&[]);p.write(phase,0xafd4f0,B,0,0xff0ff4);p.entry(phase,0xafd4b0,B,&[]);p.write(phase,0xafd4b0,B,0,0xff0fe4);
 p.free(phase,0xb0022a,B,Role::Bus200);p.critical(phase,0xb00234,CriticalOperation::Leave,cs);
 let phase=Phase::ManagerTail;p.entry(phase,0x5642d0,M,&[]);p.free(phase,0xaeba7a,M,Role::Manager954);p.actions.push(Operation::GlobalWrite{phase,pc:0xaeba82,address:0x14a7a3c,value:0});p.actions.push(Operation::Boundary{phase,address:0xaeba8c});
 let phase=Phase::RegistryTail;p.entry(phase,0x5642d0,R,&[]);p.entry(phase,0xae9ef0,R,&[]);
 for(pc,o)in[(0xae9f01,0x1f40),(0xae9f0a,0x1c20),(0xae9f13,0x1900),(0xae9f1c,0x15e0),(0xae9f25,0x12c0),(0xae9f2e,0xfa0),(0xae9f37,0xc80),(0xae9f40,0x960),(0xae9f49,0x640),(0xae9f52,0x320),(0xae9f55,0)]{p.critical(phase,pc,CriticalOperation::Delete,R+o);}
 p.free(phase,0xaebab4,R,Role::Registry2260);p.actions.push(Operation::GlobalWrite{phase,pc:0xaebabc,address:0x14a7a08,value:0});p.actions.push(Operation::Boundary{phase,address:0xaebac6});
 let unique=p.actions.iter().filter_map(|a|if let Operation::Free{reference,..}=a{Some(*reference)}else{None}).collect::<BTreeSet<_>>();if unique.len()!=3{return Err(Error::InvalidAllocation);}Ok(p)
}
/// Input refusal consumes no physical service and returns the original opaque
/// owners/context. Success keeps them private until completed retirement.
pub fn begin(remaining:RemainingOwners,context:Context)->Result<Retiring,BeginFailure>{
 match plan(&remaining,&context){Err(error)=>Err(BeginFailure{error,remaining,context}),Ok(p)=>Ok(Retiring{_consumed:remaining,context,blocks:p.blocks,actions:p.actions,cursor:0,poisoned:false})}
}

#[cfg(test)]
#[path="audio_rtpc_remaining_retirement_tests.rs"]
mod tests;
