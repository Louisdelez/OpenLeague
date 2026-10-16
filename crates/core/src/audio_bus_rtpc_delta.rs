//! Selected native global class1/parameter4 RTPC delivery and Bus gain delta.
//! Existing owned manager/voice/Bus contexts are required; no voice is fabricated.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,
 audio_rtpc_subscriber_release::Manager,
 audio_bus_effects_changed::Graph,audio_bus_control_application::{Store,Voice},
 audio_dynamic_input_owner_selector as native_rtpc};
use std::collections::{BTreeMap,BTreeSet};

#[derive(Clone,Copy)]pub struct Context{pub manager_reference:u32,pub conversion_cache:u32}
#[derive(Debug,Clone)]pub struct Delivery{pub binding:u32,pub bus:u32,pub new_curve_bits:u32,pub delta_bits:u32,pub voices:Vec<u32>}
struct Observe;
impl native_rtpc::Services for Observe{}
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
fn put(raw:&mut[u8],o:usize,v:u32){raw[o..o+4].copy_from_slice(&v.to_le_bytes());}
fn finite(bits:u32)->Result<f32,Error>{let value=f32::from_bits(bits);if value.is_finite(){Ok(value)}else{Err(Error::Backend("nonfinite Bus delta outside qualified scope"))}}
pub(crate) fn locate(manager:&Manager,key:u32)->Result<u32,Error>{
 let mut at=word(&manager.raw,(key%193)as usize*4);let mut visited=BTreeSet::new();
 while at!=0{if !visited.insert(at){return Err(Error::CyclicList);}let record=manager.records.get(&at).ok_or(Error::UnresolvedReference)?;if record.memory.raw.len()!=40{return Err(Error::InvalidAllocation);}if word(&record.memory.raw,0)==key{return Ok(at);}at=word(&record.memory.raw,4);}
 Err(Error::Backend("existing native RTPC record required for Bus delta"))
}
pub(crate) fn memory(manager:&Manager,values:&BTreeMap<u32,Memory>,context:Context)->Result<BTreeMap<u32,Memory>,Error>{
 if context.manager_reference==0{return Err(Error::UnresolvedReference);}
 let mut result=BTreeMap::new();let mut readonly_points=BTreeSet::new();
 fn add(out:&mut BTreeMap<u32,Memory>,points:&mut BTreeSet<u32>,m:Memory,readonly_point:bool)->Result<(),Error>{
  if m.reference==0{return Err(Error::InvalidAllocation);}
  if let Some(old)=out.get(&m.reference){
   // A native read-only POINTS allocation can be shared by several bindings.
   // Byte-identical aliases retain the single allocation; mutable aliases or
   // conflicting backing bytes cannot be chosen by map insertion order.
   return if readonly_point&&points.contains(&m.reference)&&old.raw==m.raw{Ok(())}else{Err(Error::InvalidAllocation)};
  }
  if readonly_point{points.insert(m.reference);}out.insert(m.reference,m);Ok(())
 }
 add(&mut result,&mut readonly_points,Memory{reference:context.manager_reference,raw:manager.raw.to_vec()},false)?;
 for r in manager.records.values(){add(&mut result,&mut readonly_points,r.memory.clone(),false)?;if r.subscribers.reference!=0{add(&mut result,&mut readonly_points,r.subscribers.clone(),false)?;}}
 for b in manager.bindings.values(){add(&mut result,&mut readonly_points,b.memory.clone(),false)?;if b.curves.reference!=0{add(&mut result,&mut readonly_points,b.curves.clone(),false)?;}for points in b.points.values(){add(&mut result,&mut readonly_points,points.clone(),true)?;}}
 for v in values.values(){add(&mut result,&mut readonly_points,v.clone(),false)?;}Ok(result)
}
#[cfg(target_arch="x86_64")]
fn rounded(retained:&[u8;10])->u32{
 let mut result=0u32;let mut cw=[0x037f0000u32,0];
 unsafe{std::arch::asm!("fnstcw word ptr [{cw}]","fldcw word ptr [{cw} + 2]","fld tbyte ptr [{retained}]","fstp dword ptr [{result}]","fldcw word ptr [{cw}]",cw=in(reg)cw.as_mut_ptr(),retained=in(reg)retained.as_ptr(),result=in(reg)&mut result,out("st(0)")_,options(nostack));}result
}
#[cfg(target_arch="x86_64")]
fn difference(new_bits:u32,old:&[u8;10])->u32{
 let mut result=0u32;let mut cw=[0x037f0000u32,0];
 unsafe{std::arch::asm!("fnstcw word ptr [{cw}]","fldcw word ptr [{cw} + 2]","fld tbyte ptr [{old}]","fsubr dword ptr [{new}]","fstp dword ptr [{result}]","fldcw word ptr [{cw}]",cw=in(reg)cw.as_mut_ptr(),old=in(reg)old.as_ptr(),new=in(reg)&new_bits,result=in(reg)&mut result,out("st(0)")_,options(nostack));}result
}
#[cfg(not(target_arch="x86_64"))]fn rounded(_:&[u8;10])->u32{unreachable!()}
#[cfg(not(target_arch="x86_64"))]fn difference(_:u32,_:&[u8;10])->u32{unreachable!()}
fn processing(graph:&Graph,node:u32)->Result<bool,Error>{
 let b=graph.buses.get(&node).ok_or(Error::UnresolvedReference)?;if b.reference!=node||b.word(0)!=0xff1380{return Err(Error::WrongClass);}
 let effects=if b.word(0x18)==0{false}else{graph.caches.get(&b.word(0x18)).ok_or(Error::MissingEffectsCache(b.word(0x18)))?.notification().effect_ids.iter().any(|v|*v!=0)};
 Ok(effects||b.word(0x60)!=0||b.raw[0x2f]&4!=0||b.word(0x24)==0||b.raw[0x2f]&8!=0)
}
fn write_delta(voice:&mut Voice,bits:u32)->Result<(),Error>{
 let value=finite(word(&voice.raw,0x43c))?+finite(bits)?;if !value.is_finite(){return Err(Error::Backend("Bus delta gain overflow"));}
 // B0F290/B0F470 change only43C and434. Mode2 remains included; no spatial
 // defaults are reset. AF5670 uses the same native conversion arithmetic.
 put(&mut voice.raw,0x43c,value.to_bits());put(&mut voice.raw,0x434,crate::audio_gain::native_extended_bits(value.to_bits()));Ok(())
}
fn deliver(graph:&mut Graph,targets:&mut Store,node:u32,bits:u32,visited:&mut BTreeSet<u32>,out:&mut Vec<u32>)->Result<(),Error>{
 if !visited.insert(node){return Err(Error::CyclicList);}let processing=processing(graph,node)?;
 let bus=graph.buses.get(&node).ok_or(Error::UnresolvedReference)?;
 if processing{
  let selected=if bus.word(0x24)==0&&bus.raw[0xc4]&0x80!=0{targets.roots.iter().find(|r|r.key==[0,0]).map(|r|vec![r.voice]).unwrap_or_default()}
  else{let id=bus.word(8);let mut list=vec![];for &r in &targets.registered{let v=targets.voices.get(&r).ok_or(Error::UnresolvedReference)?;let pointer=word(&v.raw,0x4d0);let actual=if pointer==0{0}else{*targets.bus_ids.get(&pointer).ok_or(Error::UnresolvedReference)?};if actual==id{list.push(r);}}list};
  for r in selected{let voice=targets.voices.get_mut(&r).ok_or(Error::UnresolvedReference)?;write_delta(voice,bits)?;out.push(r);}
 }else if bus.word(0x1c)!=0{
  let group=graph.groups.get(&bus.word(0x1c)).ok_or(Error::UnresolvedReference)?;
  if group.active!=[0,0]{let children=group.children.clone();let bc=finite(bus.word(0xbc))?+finite(bits)?;graph.buses.get_mut(&node).unwrap().set_word(0xbc,bc.to_bits());for child in children{let child_bus=graph.buses.get(&child).ok_or(Error::UnresolvedReference)?;let ptr=child_bus.word(0x1c);if ptr!=0&&graph.groups.get(&ptr).ok_or(Error::UnresolvedReference)?.active!=[0,0]{deliver(graph,targets,child,bits,visited,out)?;}}}
 }
 visited.remove(&node);Ok(())
}
pub(crate) fn copy_graph(g:&Graph)->Graph{Graph{buses:g.buses.clone(),caches:g.caches.clone(),groups:g.groups.iter().map(|(key,value)|(*key,crate::audio_bus_effects_changed::Group{children:value.children.clone(),active:value.active})).collect()}}
pub(crate) fn copy_targets(t:&Store)->Store{Store{voices:t.voices.clone(),bus_ids:t.bus_ids.clone(),registered:t.registered.clone(),roots:t.roots.clone()}}

#[derive(Clone,Copy,Debug)]pub(crate) struct Global{pub record:u32,pub allocation:u32,pub old_bits:u32,pub changed:bool}
pub(crate) fn global(manager:&Manager,values:&BTreeMap<u32,Memory>,key:u32,new_bits:u32,owner:u32)->Result<Global,Error>{
 if !cfg!(target_arch="x86_64"){return Err(Error::Backend("native Bus delta x87 unavailable"));}
 if owner!=0{return Err(Error::Backend("Bus delta currently requires native global owner0"));}finite(new_bits)?;
 let reference=locate(manager,key)?;let raw=&manager.records[&reference].memory.raw;
 if word(raw,24)!=0{return Err(Error::Backend("Bus delta transition removal requires its native body"));}
 let vp=word(raw,12);let n=word(raw,16)as usize;let cap=word(raw,20)as usize;let table=values.get(&vp).ok_or(Error::UnresolvedReference)?;
 if table.reference!=vp||n==0||n>cap||table.raw.len()<cap*8||word(&table.raw,0)!=0{return Err(Error::Backend("existing native global owner value required"));}
 let old_bits=word(&table.raw,4);let old=finite(old_bits)?;
 Ok(Global{record:reference,allocation:vp,old_bits,changed:old!=f32::from_bits(new_bits)})
}
pub(crate) fn subscriber_vector(manager:&Manager,reference:u32)->Result<Vec<u32>,Error>{
 let record=manager.records.get(&reference).ok_or(Error::UnresolvedReference)?;if record.memory.raw.len()!=40{return Err(Error::InvalidAllocation);}
 let count=word(&record.memory.raw,32)as usize;let capacity=word(&record.memory.raw,36)as usize;
 if count>capacity||record.subscribers.raw.len()<capacity*4||record.subscribers.reference!=word(&record.memory.raw,28){return Err(Error::InvalidAllocation);}
 Ok(record.subscribers.raw[..count*4].chunks_exact(4).map(|r|word(r,0)).collect())
}

/// One already-selected native class1 callback. Manager/global values stay OLD.
/// Caller must supply an owned proposed Graph/Store, and commit after the whole
/// mixed fanout succeeds. This callback never publishes the global value.
pub fn notify_binding(manager:&Manager,values:&BTreeMap<u32,Memory>,graph:&mut Graph,targets:&mut Store,binding_reference:u32,key:u32,new_bits:u32,context:Context)->Result<Delivery,Error>{
 let global=global(manager,values,key,new_bits,0)?;
 let binding=manager.bindings.get(&binding_reference).ok_or(Error::UnresolvedReference)?;let b=&binding.memory.raw;
 if binding.memory.reference!=binding_reference||b.len()!=32||word(b,16)!=1||word(b,4)!=4||word(b,12)!=0||word(b,24)!=1||word(b,28)<1||binding.curves.raw.len()<20||binding.curves.reference!=word(b,20){return Err(Error::Backend("selected class1/global/parameter4 single-curve binding required"));}
 if word(&binding.curves.raw,4)!=key{return Err(Error::Backend("selected Bus curve RTPC must match changed key"));}
 let node=word(b,0);let mut native_memory=memory(manager,values,context)?;let deleted=BTreeSet::new();let mut observe=Observe;
 let nc=native_rtpc::Context{manager:context.manager_reference,conversion_cache:context.conversion_cache};
 let old=native_rtpc::evaluate(&mut native_memory,&deleted,node,4,0,nc,&mut observe)?;
 let mut new_memory=native_memory.clone();put(&mut new_memory.get_mut(&global.allocation).ok_or(Error::UnresolvedReference)?.raw,4,new_bits);
 let new=native_rtpc::evaluate(&mut new_memory,&deleted,node,4,0,nc,&mut observe)?;let new_curve_bits=rounded(&new);let delta_bits=difference(new_curve_bits,&old);finite(delta_bits)?;
 let mut voices=vec![];deliver(graph,targets,node,delta_bits,&mut BTreeSet::new(),&mut voices)?;
 Ok(Delivery{binding:binding_reference,bus:node,new_curve_bits,delta_bits,voices})
}

/// Selected successful existing-global update. Incompatible input is rejected
/// before publication. Notification reads the OLD manager, then native storage
/// changes last; planning copies isolate late graph/voice failures from all state.
/// Normal bank/live-reference registration and owner lifetime remain mandatory.
pub fn set_global(manager:&mut Manager,values:&mut BTreeMap<u32,Memory>,graph:&mut Graph,targets:&mut Store,key:u32,new_bits:u32,owner:u32,context:Context)->Result<Vec<Delivery>,Error>{
 let global=global(manager,values,key,new_bits,owner)?;if !global.changed{return Ok(vec![]);}
 let mut proposed_graph=copy_graph(graph);let mut proposed_targets=copy_targets(targets);let mut result=vec![];let mut previous=0;
 for binding_reference in subscriber_vector(manager,global.record)?{
  if binding_reference==previous{continue;}previous=binding_reference;
  result.push(notify_binding(manager,values,&mut proposed_graph,&mut proposed_targets,binding_reference,key,new_bits,context)?);
 }
 *graph=proposed_graph;*targets=proposed_targets;put(&mut values.get_mut(&global.allocation).unwrap().raw,4,new_bits);Ok(result)
}

#[cfg(test)]
#[path="audio_bus_rtpc_delta_tests.rs"]
pub(crate) mod tests;

/// First selected native class1 callback with genuinely absent owner values.
/// This evaluates NEW through the original curve directly, while OLD follows
/// the actual native manager default lookup. It neither creates nor stores values.
pub(crate) fn notify_first_binding(manager:&Manager,values:&BTreeMap<u32,Memory>,graph:&mut Graph,targets:&mut Store,binding_reference:u32,key:u32,new_bits:u32,context:Context)->Result<Delivery,Error>{
 if !cfg!(target_arch="x86_64"){return Err(Error::Backend("native first-global x87 unavailable"));}finite(new_bits)?;
 let reference=locate(manager,key)?;let record=manager.records.get(&reference).ok_or(Error::UnresolvedReference)?;
 if record.memory.raw.len()!=40||word(&record.memory.raw,12)!=0||word(&record.memory.raw,16)!=0||word(&record.memory.raw,20)!=0||word(&record.memory.raw,24)!=0||word(&record.memory.raw,8)!=100f32.to_bits()||!values.is_empty(){
  return Err(Error::Backend("selected fresh first-global source default100/absent table required"));
 }
 let binding=manager.bindings.get(&binding_reference).ok_or(Error::UnresolvedReference)?;let b=&binding.memory.raw;
 if binding.memory.reference!=binding_reference||b.len()!=32||word(b,16)!=1||word(b,4)!=4||word(b,12)!=0||word(b,24)!=1||word(b,28)<1||binding.curves.raw.len()!=20||binding.curves.reference!=word(b,20){
  return Err(Error::Backend("selected first-global class1/owner0/parameter4 single curve required"));
 }
 let c=&binding.curves.raw;
 if key!=3273357900||word(c,0)!=5685792||word(c,4)!=key||word(c,12)!=2||word(c,16)!=2{return Err(Error::Backend("original selected Init VOL_sfx curve required"));}
 let p=binding.points.get(&word(c,8)).ok_or(Error::UnresolvedReference)?;
 // Authored Init.bnk bytes933..957, not an expected runtime output table.
 const POINTS:[u8;24]=[0,0,0,0,0,0,128,191,4,0,0,0,0,0,200,66,0,0,0,0,4,0,0,0];
 if p.reference!=word(c,8)||p.raw.as_slice()!=POINTS{return Err(Error::Backend("original selected VOL_sfx point bytes required"));}
 let node=word(b,0);let mut native_memory=memory(manager,values,context)?;let deleted=BTreeSet::new();let mut observe=Observe;
 let nc=native_rtpc::Context{manager:context.manager_reference,conversion_cache:context.conversion_cache};
 let (_,new_curve_bits)=native_rtpc::evaluate_first_global_curve(&mut native_memory,&deleted,binding.curves.reference.wrapping_add(8),new_bits,4,context.conversion_cache)?;
 let old=native_rtpc::evaluate(&mut native_memory,&deleted,node,4,0,nc,&mut observe)?;
 let delta_bits=difference(new_curve_bits,&old);finite(delta_bits)?;
 let mut voices=vec![];deliver(graph,targets,node,delta_bits,&mut BTreeSet::new(),&mut voices)?;
 Ok(Delivery{binding:binding_reference,bus:node,new_curve_bits,delta_bits,voices})
}
