//! Selected B12320/B12200/B10780/B11850 mixed Meter/Bus notification.
//! Forward source-vector traversal, adjacent deduplication, OLD globals for
//! every callback and one final store. Native registration/voices are inputs.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,
 audio_rtpc_subscriber_release::{Manager,Record,Binding},audio_meter_lifecycle::Runtime as Meters,
 audio_bus_effects_changed::Graph,audio_bus_control_application::Store};
use crate::audio_bus_rtpc_delta as bus;
use std::collections::BTreeMap;

#[derive(Clone,Copy,Debug)]pub struct Request{pub key:u32,pub new_bits:u32,pub owner:u32,pub transition:[u32;2],pub mode:u32}
#[derive(Clone,Debug)]pub enum Callback{
 Meter{receiver:u32,parameter:u32,new_curve_bits:u32,status:u32},
 Bus(bus::Delivery),
}
#[derive(Clone,Debug)]pub struct Notification{pub binding:u32,pub manager_old_value_bits:u32,pub callback:Callback}
#[derive(Clone,Copy,Debug)]pub struct FinalStore{pub address:u32,pub size:u32,pub value:u32,pub notifications_already_observed:usize}
#[derive(Clone,Debug)]pub struct Outcome{pub status:u32,pub notifications:Vec<Notification>,pub final_store:Option<FinalStore>}
fn word(raw:&[u8],offset:usize)->u32{u32::from_le_bytes(raw[offset..offset+4].try_into().unwrap())}
fn put(raw:&mut[u8],offset:usize,value:u32){raw[offset..offset+4].copy_from_slice(&value.to_le_bytes());}

fn copy_manager(manager:&Manager)->Manager{
 Manager{raw:manager.raw,records:manager.records.iter().map(|(&key,r)|(key,Record{memory:r.memory.clone(),subscribers:r.subscribers.clone()})).collect(),
  bindings:manager.bindings.iter().map(|(&key,b)|(key,Binding{memory:b.memory.clone(),curves:b.curves.clone(),points:b.points.clone()})).collect()}
}
fn copy_meters(meters:&Meters)->Meters{Meters{objects:meters.objects.clone(),manager:meters.manager,manager_allocator:meters.manager_allocator}}

/// B11850 class0 uses its first selected curve directly, not a fabricated sum
/// or a manager hash binding. Concrete Meter::set_parameter writes the object.
fn notify_meter(manager:&Manager,meters:&mut Meters,binding_reference:u32,key:u32,new_bits:u32)->Result<Callback,Error>{
 let binding=manager.bindings.get(&binding_reference).ok_or(Error::UnresolvedReference)?;let raw=&binding.memory.raw;
 if binding.memory.reference!=binding_reference||raw.len()!=32||word(raw,16)!=0||word(raw,12)!=0||word(raw,4)!=4||word(raw,24)!=1||word(raw,28)<1||binding.curves.reference!=word(raw,20)||binding.curves.raw.len()<20{return Err(Error::Backend("selected class0/global/parameter4 single-curve binding required"));}
 let first=&binding.curves.raw[..20];if word(first,4)!=key{return Err(Error::Backend("selected Meter curve RTPC must match changed key"));}
 let count=word(first,12)as usize;
 let reference=word(first,8);let points=binding.points.get(&reference).ok_or(Error::UnresolvedReference)?;
 if points.reference!=reference||count==0||points.raw.len()<count*12{return Err(Error::InvalidAllocation);}
 let curve=crate::audio_curves::Curve{scaling:word(first,16),points:points.raw[..count*12].chunks_exact(12).map(|point|crate::audio_curves::Point{from:f32::from_bits(word(point,0)),to:f32::from_bits(word(point,4)),interp:word(point,8)}).collect()};
 // The selected native layout's +16 is scaling (not a point capacity). The
 // producer supplies exactly count point records, retained without mutation.
 let new_curve_bits=curve.evaluate(f32::from_bits(new_bits)).map_err(|_|Error::Backend("unqualified Meter setter curve evaluation"))?.to_bits();
 let receiver=word(raw,0);let parameter=word(raw,4)&0xffff;
 let object=meters.objects.get_mut(&receiver).ok_or(Error::UnresolvedReference)?;if object.reference!=receiver{return Err(Error::UnresolvedReference);}
 let status=crate::audio_meter_lifecycle::set_parameter(object,parameter,&new_curve_bits.to_le_bytes(),4)?;
 Ok(Callback::Meter{receiver,parameter,new_curve_bits,status})
}

/// Existing owner0, immediate [duration0,curve4], mode1 and one curve only.
/// Owned proposals isolate any late Meter/Bus/reference failure. Neither callback
/// stores a global value; the final four-byte store happens only after fanout.
pub fn set_global(manager:&mut Manager,values:&mut BTreeMap<u32,Memory>,meters:&mut Meters,graph:&mut Graph,targets:&mut Store,request:Request,context:bus::Context)->Result<Outcome,Error>{
 if request.transition!=[0,4]||request.mode!=1{return Err(Error::Backend("mixed RTPC transition/mode outside selected native route"));}
 if context.manager_reference==0{return Err(Error::UnresolvedReference);}
 let global=bus::global(manager,values,request.key,request.new_bits,request.owner)?;
 if !global.changed{return Ok(Outcome{status:1,notifications:vec![],final_store:None});}
 let proposed_manager=copy_manager(manager);let mut proposed_values=values.clone();let mut proposed_meters=copy_meters(meters);
 let _validated_owned_memory=bus::memory(&proposed_manager,&proposed_values,context)?;
 let mut proposed_graph=bus::copy_graph(graph);let mut proposed_targets=bus::copy_targets(targets);let mut notifications=vec![];let mut previous=0;
 for binding in bus::subscriber_vector(&proposed_manager,global.record)?{
  if binding==previous{continue;}previous=binding;
  let entry=proposed_manager.bindings.get(&binding).ok_or(Error::UnresolvedReference)?;
  if entry.memory.raw.len()!=32{return Err(Error::InvalidAllocation);}
  let old_bits=word(&proposed_values.get(&global.allocation).ok_or(Error::UnresolvedReference)?.raw,4);
  let callback=match word(&entry.memory.raw,16){
   0=>notify_meter(&proposed_manager,&mut proposed_meters,binding,request.key,request.new_bits)?,
   1=>Callback::Bus(bus::notify_binding(&proposed_manager,&proposed_values,&mut proposed_graph,&mut proposed_targets,binding,request.key,request.new_bits,context)?),
   _=>return Err(Error::Backend("other mixed RTPC subscriber classes require their native callback bodies")),
  };
  notifications.push(Notification{binding,manager_old_value_bits:old_bits,callback});
 }
 let allocation=proposed_values.get_mut(&global.allocation).ok_or(Error::UnresolvedReference)?;
 put(&mut allocation.raw,4,request.new_bits);
 let final_store=FinalStore{address:global.allocation.wrapping_add(4),size:4,value:word(&allocation.raw,4),notifications_already_observed:notifications.len()};
 *manager=proposed_manager;*values=proposed_values;*meters=proposed_meters;*graph=proposed_graph;*targets=proposed_targets;
 Ok(Outcome{status:1,notifications,final_store:Some(final_store)})
}

#[cfg(test)]
#[path="audio_mixed_rtpc_notification_tests.rs"]
mod tests;
