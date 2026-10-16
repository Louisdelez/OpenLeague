//! Selected actual fresh Init/global owner0/parameter4 first value creation.
//! Native callbacks occur before allocation. Values belong to a separate owner;
//! no override100, voice, parent graph, queue worker or ordinary mixer is created.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,
 audio_init_rtpc_owner::FreshInitializationOwner,audio_bus_effects_changed::Graph,
 audio_bus_control_application::Store,audio_bus_rtpc_delta as bus};
use std::collections::{BTreeMap,BTreeSet};

/// Empty blocks mean the original initialized manager owns no override table.
/// This is owned storage, not a semantic default or a pre-created owner value.
#[derive(Default)]pub struct Values{pub blocks:BTreeMap<u32,Memory>}
#[derive(Clone,Copy,Debug)]pub struct Request{pub key:u32,pub new_bits:u32,pub owner:u32,pub transition:[u32;2],pub mode:u32}
#[derive(Clone,Debug)]pub struct Notification{pub manager_old_bits:u32,pub owner_value_existed_before:bool,pub delivery:bus::Delivery}
#[derive(Clone,Copy,Debug)]pub struct FinalStore{pub address:u32,pub bytes:u32,pub value:u32,pub notifications_already_observed:usize}
#[derive(Debug)]pub struct Outcome{pub status:u32,pub notifications:Vec<Notification>,pub final_store:Option<FinalStore>,pub created_values:Option<u32>}
/// A local typed rejection returns only newly granted, non-aliased storage.
/// Callbacks already delivered are explicit; no general native rollback is claimed.
#[derive(Debug)]pub struct Failure{pub error:Error,pub notifications:Vec<Notification>,pub unpublished_values:Vec<Memory>}
impl Failure{
 pub fn reclaim(&mut self,pool:u32,services:&mut impl Services)->Result<(),Error>{
  while let Some(m)=self.unpublished_values.last(){services.free_values(pool,m)?;self.unpublished_values.pop();}Ok(())
 }
}
pub trait Services{
 /// Some proposes one fresh grant; custody is accepted only after a valid new
 /// reference/range is verified. An aliased or unrepresentable reply remains
 /// provider-owned. None is NULL; Err retains any unreturned physical resource.
 fn allocate_values(&mut self,pool:u32,bytes:u32)->Result<Option<Memory>,Error>;
 fn free_values(&mut self,pool:u32,memory:&Memory)->Result<(),Error>;
 /// Passive observation after the concrete native-port Bus callback. Never
 /// replaces a receiver or commits a value; OLD remains in the actual owner.
 fn observe_notification(&mut self,_owner:&FreshInitializationOwner,_values:&Values,_notification:&Notification){}
}
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
fn put(raw:&mut[u8],o:usize,v:u32){raw[o..o+4].copy_from_slice(&v.to_le_bytes());}
fn fail(error:Error,notifications:Vec<Notification>)->Failure{Failure{error,notifications,unpublished_values:vec![]}}
fn record(owner:&FreshInitializationOwner,key:u32)->Result<u32,Error>{
 let mut p=word(&owner.manager.raw,(key%193)as usize*4);let mut seen=BTreeSet::new();
 while p!=0{if !seen.insert(p){return Err(Error::CyclicList);}let r=owner.manager.records.get(&p).ok_or(Error::UnresolvedReference)?;
  if r.memory.reference!=p||r.memory.raw.len()!=40{return Err(Error::InvalidAllocation);}if word(&r.memory.raw,0)==key{return Ok(p);}p=word(&r.memory.raw,4);
 }Err(Error::UnresolvedReference)
}
fn range(ranges:&mut Vec<(u32,u32)>,reference:u32,len:usize)->Result<(),Error>{
 let n=u32::try_from(len).map_err(|_|Error::InvalidAllocation)?;let end=reference.checked_add(n).ok_or(Error::InvalidAllocation)?;
 if reference==0||n==0||ranges.iter().any(|&(a,b)|reference<b&&a<end){return Err(Error::InvalidAllocation);}ranges.push((reference,end));Ok(())
}
fn owned_ranges(owner:&FreshInitializationOwner,values:&Values,graph:&Graph)->Result<Vec<(u32,u32)>,Error>{
 let mut ranges=vec![];range(&mut ranges,owner.reference,0x954)?;
 if owner.node_registry.raw.len()!=0x2260||owner.pool_nodes.raw.len()!=0xc0{return Err(Error::InvalidAllocation);}
 for m in [&owner.node_registry,&owner.pool_nodes]{range(&mut ranges,m.reference,m.raw.len())?;}
 let mut used_values=BTreeSet::new();
 for (&p,r)in &owner.manager.records{
  if r.memory.reference!=p||r.memory.raw.len()!=40{return Err(Error::InvalidAllocation);}range(&mut ranges,p,40)?;
  let raw=&r.memory.raw;let table=word(raw,12);let count=word(raw,16)as usize;let capacity=word(raw,20)as usize;
  if word(raw,24)!=0||count>capacity{return Err(Error::InvalidAllocation);}
  if table==0{if count!=0||capacity!=0{return Err(Error::InvalidAllocation);}}
  else{let m=values.blocks.get(&table).ok_or(Error::UnresolvedReference)?;if m.reference!=table||capacity.checked_mul(8)!=Some(m.raw.len())||!used_values.insert(table){return Err(Error::InvalidAllocation);}range(&mut ranges,table,m.raw.len())?;}
  let p=word(raw,28);let count=word(raw,32)as usize;let capacity=word(raw,36)as usize;
  if count>capacity||r.subscribers.reference!=p||capacity.checked_mul(4)!=Some(r.subscribers.raw.len()){return Err(Error::InvalidAllocation);}
  if p!=0{range(&mut ranges,p,r.subscribers.raw.len())?;}else if count!=0||capacity!=0{return Err(Error::InvalidAllocation);}
 }
 if used_values.len()!=values.blocks.len(){return Err(Error::InvalidAllocation);}
 for (&p,b)in &owner.manager.bindings{
  if b.memory.reference!=p||b.memory.raw.len()!=32||word(&b.memory.raw,20)!=b.curves.reference{return Err(Error::InvalidAllocation);}range(&mut ranges,p,32)?;range(&mut ranges,b.curves.reference,b.curves.raw.len())?;
  for (&p,m)in &b.points{if m.reference!=p{return Err(Error::InvalidAllocation);}range(&mut ranges,p,m.raw.len())?;}
 }
 for (&p,b)in &graph.buses{if b.reference!=p{return Err(Error::InvalidAllocation);}range(&mut ranges,p,b.raw.len())?;}
 Ok(ranges)
}
fn selected(owner:&FreshInitializationOwner,values:&Values,graph:&Graph,targets:&Store,request:Request,context:bus::Context)->Result<(u32,u32,Option<u32>,Vec<(u32,u32)>),Error>{
 if request.key!=3273357900||request.owner!=0||request.transition!=[0,4]||request.mode!=1||!f32::from_bits(request.new_bits).is_finite()||context.manager_reference!=owner.reference{return Err(Error::Backend("selected first-global owner0/VOL_sfx/immediate request required"));}
 if !targets.voices.is_empty()||!targets.registered.is_empty()||!targets.roots.is_empty()||!targets.bus_ids.is_empty()||!graph.caches.is_empty()||!graph.groups.is_empty()||graph.buses.len()!=1{
  return Err(Error::Backend("qualified isolated SFX graph has no parent/effects/voice owner"));
 }
 let(&node_reference,node)=graph.buses.iter().next().ok_or(Error::UnresolvedReference)?;
 // Bus.raw is [u8;200] in the unchanged native owner ABI. Reject a foreign
 // map-key/owner identity before reading even those fixed-sized fields.
 if node.reference!=node_reference{return Err(Error::InvalidAllocation);}
 if node.word(0)!=0xff1380||node.word(8)!=393239870||node.word(0x24)!=0||node.word(0x18)!=0||node.word(0x1c)!=0{return Err(Error::Backend("original selected isolated Init SFX Bus required"));}
 let reference=record(owner,request.key)?;let r=&owner.manager.records[&reference];let raw=&r.memory.raw;
 if word(raw,8)!=100f32.to_bits()||word(raw,24)!=0||word(raw,32)!=1||r.subscribers.raw.len()<4{return Err(Error::Backend("actual Init default100/single class1 source required"));}
 let binding=word(&r.subscribers.raw,0);let b=owner.manager.bindings.get(&binding).ok_or(Error::UnresolvedReference)?;
 if b.memory.raw.len()!=32||word(&b.memory.raw,0)!=node.reference||word(&b.memory.raw,4)!=4||word(&b.memory.raw,12)!=0||word(&b.memory.raw,16)!=1{return Err(Error::Backend("actual selected class1 source binding required"));}
 let table=word(raw,12);let old=if table==0{None}else{
  let v=values.blocks.get(&table).ok_or(Error::UnresolvedReference)?;
  if word(raw,16)!=1||word(raw,20)!=8||v.raw.len()!=64||word(&v.raw,0)!=0{return Err(Error::Backend("qualified created owner0 table required"));}Some(word(&v.raw,4))
 };
 let ranges=owned_ranges(owner,values,graph)?;Ok((reference,binding,old,ranges))
}
/// First callback-before-allocation success/failure and subsequent existing-value
/// updates. This API does not turn a semantic default into a stored override.
/// Null allocation returns native status2 with delivered notifications visible.
pub fn set_global(owner:&mut FreshInitializationOwner,values:&mut Values,graph:&mut Graph,targets:&mut Store,request:Request,context:bus::Context,services:&mut impl Services)->Result<Outcome,Failure>{
 let(reference,binding,old,mut ranges)=selected(owner,values,graph,targets,request,context).map_err(|e|fail(e,vec![]))?;
 if let Some(old_bits)=old{
  let pointer=word(&owner.manager.records[&reference].memory.raw,12);
  let deliveries=bus::set_global(&mut owner.manager,&mut values.blocks,graph,targets,request.key,request.new_bits,0,context).map_err(|e|fail(e,vec![]))?;
  let notifications:Vec<_>=deliveries.into_iter().map(|delivery|Notification{manager_old_bits:old_bits,owner_value_existed_before:true,delivery}).collect();
  // Existing Bus helper has already committed its qualified local plan. The
  // first-value native passive callback observation is the branch below.
  let final_store=if notifications.is_empty(){None}else{Some(FinalStore{address:pointer.wrapping_add(4),bytes:4,value:request.new_bits,notifications_already_observed:notifications.len()})};
  return Ok(Outcome{status:1,notifications,final_store,created_values:None});
 }
 let delivery=bus::notify_first_binding(&owner.manager,&values.blocks,graph,targets,binding,request.key,request.new_bits,context).map_err(|e|fail(e,vec![]))?;
 let notification=Notification{manager_old_bits:word(&owner.manager.records[&reference].memory.raw,8),owner_value_existed_before:false,delivery};
 services.observe_notification(owner,values,&notification);let notifications=vec![notification];
 let allocation=services.allocate_values(owner.pool_id,64).map_err(|e|fail(e,notifications.clone()))?;
 let Some(mut memory)=allocation else{return Ok(Outcome{status:2,notifications,final_store:None,created_values:None});};
 // Custody is accepted only after its range is proven new. An aliased reply is
 // still provider-owned; this API must not reclaim any existing owner for it.
 if let Err(e)=range(&mut ranges,memory.reference,memory.raw.len()){return Err(fail(e,notifications));}
 if memory.raw.len()!=64{return Err(Failure{error:Error::InvalidAllocation,notifications,unpublished_values:vec![memory]});}
 let pointer=memory.reference;let r=&mut owner.manager.records.get_mut(&reference).unwrap().memory.raw;
 put(r,12,pointer);put(r,20,8);put(r,16,1);put(&mut memory.raw,0,0);
 // Original B107E9 final store follows the callback, allocation and owner key.
 put(&mut memory.raw,4,request.new_bits);values.blocks.insert(pointer,memory);
 Ok(Outcome{status:1,final_store:Some(FinalStore{address:pointer.wrapping_add(4),bytes:4,value:request.new_bits,notifications_already_observed:notifications.len()}),notifications,created_values:Some(pointer)})
}

#[cfg(test)]
#[path="audio_rtpc_first_global_value_tests.rs"]
mod tests;
