//! Original sound AF1900 + AFF1E0 inheritance, with explicit evaluated getters.
//! Raw slots4/8/C are not silently equated to final audible gain/pitch/LPF.
use std::collections::{BTreeMap,BTreeSet};
#[derive(Debug,Clone,Copy)]
pub struct BusOverride {pub node:u32,pub local_slot4:f32,pub local_slot_c:f32}
#[derive(Debug,Clone,Default)]
pub struct Node {
 pub class:crate::audio_parameter_getters::Class,
 pub reference:u32,pub parent:Option<u32>,pub bus_link:Option<u32>,pub bus_override:Option<BusOverride>,
 pub property0:Option<f32>,pub block_static_bus_walk:bool,
 pub static_property8:Option<f32>,pub object_property8:BTreeMap<u32,f32>,
}
#[derive(Debug,Clone,Copy,PartialEq)]
pub struct Parameters {pub reference:u32,pub slots:[f32;3],pub marker:u16}
#[derive(Debug,Clone,PartialEq,Eq)]
pub enum Call {Inherit {node:u32,first_raw:u8},Getter {node:u32,slot:u32}}
#[derive(Debug,PartialEq,Eq)]
pub enum Error {MissingNode(u32),CyclicGraph(u32),InvalidControl,Overflow,Getter(crate::audio_parameter_getters::Error)}
#[derive(Debug)]
pub struct Evaluation {pub parameters:Parameters,pub calls:Vec<Call>}
fn validate(nodes:&BTreeMap<u32,Node>)->Result<(),Error> {
 fn visit(id:u32,nodes:&BTreeMap<u32,Node>,active:&mut BTreeSet<u32>,done:&mut BTreeSet<u32>)->Result<(),Error> {
  if done.contains(&id){return Ok(());}if !active.insert(id){return Err(Error::CyclicGraph(id));}
  let n=nodes.get(&id).ok_or(Error::MissingNode(id))?;
  for next in [n.parent,n.bus_link,n.bus_override.map(|b|b.node)].into_iter().flatten(){visit(next,nodes,active,done)?;}
  active.remove(&id);done.insert(id);Ok(())
 }
 let mut active=BTreeSet::new();let mut done=BTreeSet::new();
 for (&id,n) in nodes {
  if n.property0.into_iter().chain(n.static_property8).chain(n.object_property8.values().copied()).chain(n.bus_override.into_iter().flat_map(|b|[b.local_slot4,b.local_slot_c])).any(|v|!v.is_finite()){return Err(Error::InvalidControl);}
  visit(id,nodes,&mut active,&mut done)?;
 }
 Ok(())
}
/// Getter results must come from the native-qualified local evaluators. First
/// raw byte is tested for zero; recursive calls always pass zero. Repeated nodes
/// through different graph paths remain repeated calls, preserving add order.
pub fn evaluate(nodes:&BTreeMap<u32,Node>,root:u32,owner:u32,first_raw:u8,parameters:Parameters)->Result<Evaluation,Error> {
 evaluate_with(nodes,root,owner,first_raw,parameters,|id,slot,_| {
  let bus=nodes[&id].bus_override.expect("getter only called for override");
  Ok(if slot==0x110 {bus.local_slot4}else{bus.local_slot_c})
 })
}
/// Resolve local values at the actual native call site, preserving repeated
/// evaluations and shared random draw order when a node is visited more than once.
pub fn evaluate_with(nodes:&BTreeMap<u32,Node>,root:u32,owner:u32,first_raw:u8,parameters:Parameters,
 mut getter:impl FnMut(u32,u32,u32)->Result<f32,Error>)->Result<Evaluation,Error> {
 validate(nodes)?;if parameters.slots.iter().any(|v|!v.is_finite()){return Err(Error::InvalidControl);}
 let mut out=Evaluation {parameters,calls:Vec::new()};inherit(nodes,root,owner,first_raw,&mut out,&mut getter)?;
 if out.parameters.slots.iter().any(|v|!v.is_finite()){return Err(Error::Overflow);}Ok(out)
}
fn inherit(nodes:&BTreeMap<u32,Node>,id:u32,owner:u32,first_raw:u8,out:&mut Evaluation,getter:&mut impl FnMut(u32,u32,u32)->Result<f32,Error>)->Result<(),Error> {
 let node=nodes.get(&id).ok_or(Error::MissingNode(id))?;
 out.calls.push(Call::Inherit {node:id,first_raw});
 let marker_zero=out.parameters.marker==0;
 if let Some(bus)=node.bus_override {
  out.calls.push(Call::Getter {node:id,slot:0x110});let local4=getter(id,0x110,owner)?;
  out.calls.push(Call::Getter {node:id,slot:0x114});let local_c=getter(id,0x114,owner)?;
  if !local4.is_finite() || !local_c.is_finite(){return Err(Error::InvalidControl);}
  if first_raw!=0 {
   out.parameters.slots[0]=local4;out.parameters.slots[2]=local_c;
   if marker_zero {out.parameters.reference=nodes[&bus.node].reference;out.parameters.marker=u16::MAX;}
   inherit(nodes,bus.node,owner,0,out,getter)?;
   let mut search=Some(id);let mut bus_start=None;
   while let Some(current)=search {let n=&nodes[&current];if n.bus_link.is_some(){bus_start=n.bus_link;break;}search=n.parent;}
   let mut current=bus_start;
   while let Some(id)=current {let n=&nodes[&id];if n.block_static_bus_walk{break;}
    out.parameters.slots[1]+=n.property0.unwrap_or(0.);current=n.bus_link;
   }
  } else {out.parameters.slots[0]+=local4;out.parameters.slots[2]+=local_c;}
 }
 if let Some(parent)=node.parent {inherit(nodes,parent,owner,0,out,getter)?;}
 if node.class==crate::audio_parameter_getters::Class::Sound {
  if let Some(value)=node.static_property8 {out.parameters.slots[0]+=value;}
  if let Some(value)=node.object_property8.get(&owner) {out.parameters.slots[0]+=*value;}
 }
 Ok(())
}
#[cfg(test)] mod tests {
 use super::*;
 fn compare_native_classes(proof:&str,mixed:bool) {
  let proof:serde_json::Value=serde_json::from_str(proof).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),384);
  for row in cases {
   let mut nodes:BTreeMap<u32,Node>=(0..4).map(|id|(id,Node {reference:0x30001000+id*0x1000,..Default::default()})).collect();
   if mixed{for id in [2,3]{nodes.get_mut(&id).unwrap().class=crate::audio_parameter_getters::Class::Bus;}}
   if row["parent_present"].as_bool().unwrap(){nodes.get_mut(&0).unwrap().parent=Some(1);}
   if row["bus_present"].as_bool().unwrap(){let n=nodes.get_mut(&0).unwrap();n.bus_override=Some(BusOverride {node:2,local_slot4:-31.,local_slot_c:40.});n.bus_link=Some(2);nodes.get_mut(&2).unwrap().bus_link=Some(3);
    if row["volume_path"]!="absent"{nodes.get_mut(&2).unwrap().property0=Some(-23.);nodes.get_mut(&3).unwrap().property0=Some(-12.);}
    if row["volume_path"]=="blocked"{nodes.get_mut(&2).unwrap().block_static_bus_walk=true;}
   }
   let scope=row["scope"].as_u64().unwrap();for (&id,n) in &mut nodes {if scope&1!=0{n.static_property8=Some((id+1) as f32);}if scope&2!=0{n.object_property8.insert(1,(id+1) as f32*0.25);}}
   let out=evaluate(&nodes,0,row["owner"].as_u64().unwrap() as u32,row["first_raw"].as_u64().unwrap() as u8,Parameters {reference:0x12345678,slots:[13.,17.,19.],marker:row["initial_marker"].as_u64().unwrap() as u16}).unwrap();
   assert_eq!(serde_json::json!(out.parameters.slots.map(f32::to_bits)),row["output_words"]);assert_eq!(u64::from(out.parameters.marker),row["output_marker"].as_u64().unwrap());assert_eq!(u64::from(out.parameters.reference),row["output_reference"].as_u64().unwrap());
   let calls:Vec<_>=out.calls.iter().map(|c|match c {Call::Inherit {node,first_raw}=>serde_json::json!({"kind":"inherit","node":node,"first_raw":first_raw}),Call::Getter {node,slot}=>serde_json::json!({"kind":"getter","node":node,"slot":slot})}).collect();assert_eq!(serde_json::json!(calls),row["calls"]);
  }
 }
 #[test] fn full_native_inheritance_trace_and_slots_match384_cases(){compare_native_classes(include_str!("../../../data/4.20/audio_parameter_inheritance_contract.json"),false);}
 #[test] fn audio_mixed_sound_bus_inheritance_matches384_native_cases(){compare_native_classes(include_str!("../../../data/4.20/audio_bus_parameter_inheritance_contract.json"),true);}
 #[test] fn malformed_graphs_and_nonfinite_controls_are_rejected() {
  let p=Parameters {reference:0,slots:[0.;3],marker:0};let mut nodes=BTreeMap::from([(0,Node::default())]);
  nodes.get_mut(&0).unwrap().parent=Some(0);assert!(matches!(evaluate(&nodes,0,1,1,p),Err(Error::CyclicGraph(0))));
  nodes.get_mut(&0).unwrap().parent=Some(99);assert!(matches!(evaluate(&nodes,0,1,1,p),Err(Error::MissingNode(99))));
  nodes.get_mut(&0).unwrap().parent=None;nodes.get_mut(&0).unwrap().static_property8=Some(f32::NAN);assert!(matches!(evaluate(&nodes,0,1,1,p),Err(Error::InvalidControl)));
 }
}

#[cfg(test)] mod live_getter_tests {
 use super::*;
 use crate::{audio_parameter_getters::{self as local,Input,Kind,Range},audio_random::NativeRandom};
 #[test] fn evaluated_getters_preserve_native_visit_and_shared_draw_order() {
  for first in [0,1,255] {
   let mut graph:BTreeMap<u32,Node>=(0..4).map(|id|(id,Node {reference:id+100,..Default::default()})).collect();
   graph.get_mut(&0).unwrap().parent=Some(1);graph.get_mut(&0).unwrap().bus_override=Some(BusOverride {node:2,local_slot4:0.,local_slot_c:0.});graph.get_mut(&1).unwrap().bus_override=Some(BusOverride {node:3,local_slot4:0.,local_slot_c:0.});
   let inputs=BTreeMap::from([((0,0x110),Input {static_value:Some(-31.),rtpc_enabled:true,range:Some(Range {min:-8.,max:0.})}),((0,0x114),Input {static_value:Some(3.25),rtpc_enabled:true,range:Some(Range {min:-5.,max:0.})}),((1,0x110),Input {static_value:Some(-23.),range:Some(Range {min:0.,max:0.}),..Default::default()}),((1,0x114),Input {range:Some(Range {min:0.,max:40.}),..Default::default()})]);
   let p=Parameters {reference:0,slots:[13.,17.,19.],marker:0};let mut rng=NativeRandom::seeded(17);let mut actual_calls=Vec::new();
   let out=evaluate_with(&graph,0,77,first,p,|id,slot,owner|{actual_calls.push((id,slot,owner));local::evaluate_with_rng(if slot==0x110 {Kind::Property8}else{Kind::Property9},inputs[&(id,slot)],|parameter|Ok(parameter as f32*0.25),&mut rng).map_err(Error::Getter)}).unwrap();
   let mut reference_rng=NativeRandom::seeded(17);
   for (id,slot) in [(0,0x110),(0,0x114),(1,0x110),(1,0x114)] {let value=local::evaluate_with_rng(if slot==0x110 {Kind::Property8}else{Kind::Property9},inputs[&(id,slot)],|parameter|Ok(parameter as f32*0.25),&mut reference_rng).unwrap();let b=graph.get_mut(&id).unwrap().bus_override.as_mut().unwrap();if slot==0x110{b.local_slot4=value;}else{b.local_slot_c=value;}}
   let expected=evaluate(&graph,0,77,first,p).unwrap();assert_eq!(out.parameters,expected.parameters);assert_eq!(out.calls,expected.calls);assert_eq!(rng.state(),reference_rng.state());assert_eq!(actual_calls,[(0,0x110,77),(0,0x114,77),(1,0x110,77),(1,0x114,77)]);
  }
 }
}
