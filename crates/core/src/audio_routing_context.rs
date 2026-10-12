//! AEF360 routing gate, B1AD70/B1AA50 context allocation and AF1900 bridge.
use crate::audio_parameter_inheritance as inherited;
use std::collections::BTreeMap;
#[derive(Debug,Clone)] pub struct Context {pub reference:u32,pub raw:Vec<u8>}
impl Context {
 fn word(&self,o:usize)->u32{u32::from_le_bytes(self.raw[o..o+4].try_into().unwrap())}
 pub fn contribution(&self)->Result<f32,Error>{if self.raw.len()<48{return Err(Error::MalformedContext);}let v=f32::from_bits(self.word(16));if !v.is_finite(){return Err(Error::InvalidControl);}Ok(v)}
 fn initialize(&mut self,multiplier:u32,mask:u32)->Result<(),Error>{if self.reference==0 || self.raw.len()<48{return Err(Error::MalformedContext);}self.raw[..24].fill(0);for o in (24..40).step_by(4){self.raw[o..o+4].copy_from_slice(&1f32.to_le_bytes());}self.raw[40..44].fill(0);self.raw[44..46].copy_from_slice(&((mask&0xfff7) as u16).to_le_bytes());let old=u16::from_le_bytes(self.raw[46..48].try_into().unwrap());let header=((old&!0x70)|(((multiplier<<4)&0x70) as u16))&0xfff0 | ((mask&0xfff7).count_ones() as u16&15)|0x80;self.raw[46..48].copy_from_slice(&header.to_le_bytes());Ok(())}
}
#[derive(Debug)] pub struct Voice {pub context:Option<Context>,pub eligibility:Option<u32>,pub mask:u32,pub optional_mask:Option<u32>,pub packed:u8,pub source:u32}
#[derive(Debug,PartialEq)] pub enum Error {MalformedContext,InvalidManager,InvalidControl,Allocation,Inheritance(inherited::Error)}
#[derive(Debug,Clone,PartialEq,serde::Serialize)] #[serde(tag="kind",rename_all="snake_case")]
pub enum Call {Routing,Allocate {size:u32,alignment:u32},Inherit {node:u32,first_raw:u8},Getter {node:u32,slot:u32},Rtpc {node:u32,parameter:u32,owner:u32},Draw {value:u16},ContextConsumer {context:u32,source:u32,owner:u32,last:u32}}
pub trait Allocator {fn allocate(&mut self,size:u32,alignment:u32)->Result<Option<Context>,Error>;}
pub trait Consumer {fn consume(&mut self,context:&mut Context,source:u32,owner:u32)->Result<Vec<Call>,Error>;}
pub struct InheritedConsumer<'a,G> {pub nodes:&'a BTreeMap<u32,inherited::Node>,pub root:u32,pub getter:G}
impl<G:FnMut(u32,u32,u32)->Result<f32,inherited::Error>> Consumer for InheritedConsumer<'_,G> {
 fn consume(&mut self,c:&mut Context,_source:u32,owner:u32)->Result<Vec<Call>,Error>{
  if c.reference==0 || c.raw.len()<48{return Err(Error::MalformedContext);}let p=inherited::Parameters {reference:c.word(0),slots:std::array::from_fn(|i|f32::from_bits(c.word(4+i*4))),marker:u16::from_le_bytes(c.raw[42..44].try_into().unwrap())};
  let out=inherited::evaluate_with(self.nodes,self.root,owner,1,p,&mut self.getter).map_err(Error::Inheritance)?;
  c.raw[..4].copy_from_slice(&out.parameters.reference.to_le_bytes());for i in 0..3{c.raw[4+i*4..8+i*4].copy_from_slice(&out.parameters.slots[i].to_le_bytes());}c.raw[42..44].copy_from_slice(&out.parameters.marker.to_le_bytes());
  Ok(out.calls.into_iter().map(|v|match v {inherited::Call::Inherit{node,first_raw}=>Call::Inherit{node,first_raw},inherited::Call::Getter{node,slot}=>Call::Getter{node,slot}}).collect())
 }
}
/// Native local getters resolve the live manager at each inheritance visit.
/// Missing local snapshots fail; repeated visits consume the shared RNG again.
pub struct QualifiedInheritedConsumer<'a>{pub nodes:&'a BTreeMap<u32,inherited::Node>,pub root:u32,pub inputs:&'a BTreeMap<(u32,u32),crate::audio_parameter_getters::Input>,pub manager:&'a crate::audio_rtpc_manager::Manager,pub rng:&'a mut crate::audio_random::NativeRandom}
impl Consumer for QualifiedInheritedConsumer<'_>{
 fn consume(&mut self,c:&mut Context,source:u32,owner:u32)->Result<Vec<Call>,Error>{
  use crate::audio_parameter_getters as local;
  let nodes=self.nodes;let inputs=self.inputs;let manager=self.manager;let rng=&mut *self.rng;let mut traces=Vec::new();
  let calls={let mut consumer=InheritedConsumer {nodes,root:self.root,getter:|node,slot,owner|{
   let input=*inputs.get(&(node,slot)).ok_or(inherited::Error::Getter(local::Error::Backend("unresolved local getter")))?;let kind=match slot{0x110=>local::Kind::Property8,0x114=>local::Kind::Property9,_=>return Err(inherited::Error::InvalidControl)};let trace=std::cell::RefCell::new(Vec::new());
   let value=local::evaluate_for_class(kind,nodes[&node].class,input,|parameter|{trace.borrow_mut().push(Call::Rtpc {node,parameter,owner});manager.evaluate(nodes[&node].reference,parameter,owner).map(|v|v.value).map_err(|_|local::Error::Backend("RTPC getter failed"))},||{let value=rng.draw();trace.borrow_mut().push(Call::Draw {value});value}).map_err(inherited::Error::Getter)?;traces.push(trace.into_inner());Ok(value)
  }};consumer.consume(c,source,owner)?};
  let mut traces=traces.into_iter();let mut out=Vec::new();for call in calls{let is_getter=matches!(call,Call::Getter{..});out.push(call);if is_getter{out.extend(traces.next().expect("one qualified trace per getter"));}}debug_assert!(traces.next().is_none());Ok(out)
 }
}
pub fn route(voice:&mut Voice,flags:&mut u8,owner:u32,outputs:Option<&[u32]>,allocator:&mut impl Allocator,consumer:&mut impl Consumer)->Result<Vec<Call>,Error>{
 let mut calls=vec![Call::Routing];let Some(outputs)=outputs else{return Ok(calls);};if outputs.len()>255{return Err(Error::InvalidManager);}if !outputs.iter().any(|v|*v!=0){return Ok(calls);}
 if voice.context.is_none() && (voice.eligibility.unwrap_or(0)!=0 || *flags&0x80!=0){let mask=voice.optional_mask.unwrap_or(voice.mask&0x3ffff);let channels=mask&0xfffffff7;if channels!=0{let multiplier=if voice.packed&3==1 && (voice.packed>>2)&3==1 {outputs.len() as u32}else{1};let size=(multiplier*channels.count_ones()-1)*64+112;calls.push(Call::Allocate{size,alignment:16});if let Some(mut c)=allocator.allocate(size,16)?{if c.raw.len()<size as usize{return Err(Error::MalformedContext);}c.initialize(multiplier,mask)?;voice.context=Some(c);}}}
 if let Some(c)=voice.context.as_mut(){calls.extend(consumer.consume(c,voice.source,owner)?);}*flags|=0x40;Ok(calls)
}
pub struct RoutingBackend<'a,B,A,C> {pub dependencies:&'a mut B,pub voice:&'a mut Voice,pub outputs:Option<&'a [u32]>,pub allocator:&'a mut A,pub consumer:&'a mut C,pub calls:Vec<Call>}
impl<B:crate::audio_control_refresh::Backend,A:Allocator,C:Consumer> crate::audio_control_refresh::Backend for RoutingBackend<'_,B,A,C>{
 fn spatial(&mut self,s:&mut crate::audio_control_refresh::State)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.spatial(s)}
 fn optional(&mut self)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.optional()}
 fn flag(&mut self,o:u32)->Result<u8,crate::audio_control_refresh::Error>{self.dependencies.flag(o)}
 fn source(&mut self)->Result<f32,crate::audio_control_refresh::Error>{self.dependencies.source()}
 fn routing(&mut self,s:&mut crate::audio_control_refresh::State)->Result<(),crate::audio_control_refresh::Error>{self.calls=route(self.voice,&mut s.flags[2],s.owner,self.outputs,self.allocator,self.consumer).map_err(|_|crate::audio_control_refresh::Error::Backend("routing context failed"))?;s.context=self.voice.context.as_ref().map(Context::contribution).transpose().map_err(|_|crate::audio_control_refresh::Error::Backend("invalid routing contribution"))?;Ok(())}
 fn parameters(&mut self,s:&mut crate::audio_control_refresh::State,r:crate::audio_control_refresh::Request)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.parameters(s,r)}
 fn pair(&mut self,o:u32)->Result<[f32;2],crate::audio_control_refresh::Error>{self.dependencies.pair(o)}
 fn transition(&mut self,v:f32)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.transition(v)}
}
/// Routing getters and actor parameters borrow the same stream sequentially.
/// No cloned seed or separately advancing generator is introduced.
pub struct ActorRoutingBackend<'a,B,A>{
 pub dependencies:&'a mut B,pub nodes:&'a [crate::audio_actor_controls::Node],pub bus_bindings:Option<&'a crate::audio_actor_controls::BusBindings>,pub hierarchy:&'a BTreeMap<u32,inherited::Node>,pub root:u32,pub inputs:&'a BTreeMap<(u32,u32),crate::audio_parameter_getters::Input>,
 pub manager:&'a crate::audio_rtpc_manager::Manager,pub rng:&'a mut crate::audio_random::NativeRandom,pub voice:&'a mut Voice,pub outputs:Option<&'a [u32]>,pub allocator:&'a mut A,
 pub actor_calls:Vec<crate::audio_actor_controls::GraphCall>,pub routing_calls:Vec<Call>,
}
impl<B:crate::audio_control_refresh::Backend,A:Allocator> crate::audio_control_refresh::Backend for ActorRoutingBackend<'_,B,A>{
 fn spatial(&mut self,s:&mut crate::audio_control_refresh::State)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.spatial(s)}
 fn optional(&mut self)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.optional()}
 fn flag(&mut self,o:u32)->Result<u8,crate::audio_control_refresh::Error>{self.dependencies.flag(o)}
 fn source(&mut self)->Result<f32,crate::audio_control_refresh::Error>{self.dependencies.source()}
 fn routing(&mut self,s:&mut crate::audio_control_refresh::State)->Result<(),crate::audio_control_refresh::Error>{
  let mut consumer=QualifiedInheritedConsumer{nodes:self.hierarchy,root:self.root,inputs:self.inputs,manager:self.manager,rng:self.rng};
  self.routing_calls=route(self.voice,&mut s.flags[2],s.owner,self.outputs,self.allocator,&mut consumer).map_err(|_|crate::audio_control_refresh::Error::Backend("routing context failed"))?;
  s.context=self.voice.context.as_ref().map(Context::contribution).transpose().map_err(|_|crate::audio_control_refresh::Error::Backend("invalid routing contribution"))?;Ok(())
 }
 fn parameters(&mut self,s:&mut crate::audio_control_refresh::State,r:crate::audio_control_refresh::Request)->Result<(),crate::audio_control_refresh::Error>{self.actor_calls=if let Some(bindings)=self.bus_bindings{crate::audio_actor_controls::apply_with_bus(self.nodes,bindings,s,r,self.manager,self.rng)}else{crate::audio_actor_controls::apply(self.nodes,s,r,self.manager,self.rng).map(|v|v.into_iter().map(crate::audio_actor_controls::GraphCall::Actor).collect())}.map_err(|_|crate::audio_control_refresh::Error::Backend("actor controls failed"))?;Ok(())}
 fn pair(&mut self,o:u32)->Result<[f32;2],crate::audio_control_refresh::Error>{self.dependencies.pair(o)}
 fn transition(&mut self,v:f32)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.transition(v)}
}
#[cfg(test)] pub(crate) mod tests {
 use super::*;
 pub(crate) struct SnapshotAllocator {pub reference:u32,pub fail:bool}
 impl Allocator for SnapshotAllocator {fn allocate(&mut self,size:u32,alignment:u32)->Result<Option<Context>,Error>{assert_eq!(alignment,16);Ok(if self.fail {None}else{Some(Context{reference:self.reference,raw:vec![0xa5;size as usize]})})}}
 struct InterfaceConsumer;
 impl Consumer for InterfaceConsumer {fn consume(&mut self,c:&mut Context,source:u32,owner:u32)->Result<Vec<Call>,Error>{Ok(vec![Call::ContextConsumer{context:c.reference,source,owner,last:1}])}}
 #[test] fn audio_native_routing_constructor_matches3456_cases(){let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_routing_context_contract.json")).unwrap();assert_eq!(proof["case_count"],3456);for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){let reference=row["context_reference"].as_u64().unwrap() as u32;let mut voice=Voice{context:row["existing"].as_bool().unwrap().then(||Context{reference,raw:vec![0xa5;4096]}),eligibility:row["eligibility"].as_u64().map(|v|v as u32),mask:row["mask"].as_u64().unwrap() as u32,optional_mask:row["optional"].as_bool().unwrap().then(||row["mask"].as_u64().unwrap() as u32),packed:row["packed"].as_u64().unwrap() as u8,source:0xabcdef};let mut flags=row["flags"].as_u64().unwrap() as u8;let outputs:Vec<u32>=row["outputs"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();let mut allocator=SnapshotAllocator{reference,fail:row["allocation_fail"].as_bool().unwrap()};let calls=route(&mut voice,&mut flags,77,row["manager_present"].as_bool().unwrap().then_some(outputs.as_slice()),&mut allocator,&mut InterfaceConsumer).unwrap();assert_eq!(flags as u64,row["result_flags"].as_u64().unwrap(),"flags {case}");assert_eq!(voice.context.as_ref().map_or(0,|c|c.reference) as u64,row["result_reference"].as_u64().unwrap(),"reference {case}");assert_eq!(voice.context.as_ref().map(|c|c.raw[..48].iter().map(|b|format!("{b:02x}")).collect::<String>()),row["context_prefix"].as_str().map(str::to_owned),"prefix {case}");assert_eq!(serde_json::json!(calls.into_iter().skip(1).collect::<Vec<_>>()),row["calls"],"calls {case}");}}
 #[test] fn audio_context_bridge_preserves_unowned_bytes_and_reports_bad_graph(){let mut c=Context{reference:1,raw:vec![0;112]};c.raw[16..20].copy_from_slice(&6.5f32.to_le_bytes());let nodes=BTreeMap::from([(0,inherited::Node{static_property8:Some(-3.25),..Default::default()})]);let mut consumer=InheritedConsumer{nodes:&nodes,root:0,getter:|_,_,_|Err(inherited::Error::InvalidControl)};let before=c.raw.clone();consumer.consume(&mut c,0xabcdef,77).unwrap();assert_eq!(c.word(4),(-3.25f32).to_bits());for i in 0..112{if !(4..8).contains(&i){assert_eq!(c.raw[i],before[i]);}}assert_eq!(c.contribution(),Ok(6.5));consumer.root=99;assert!(matches!(consumer.consume(&mut c,0,77),Err(Error::Inheritance(inherited::Error::MissingNode(99)))));c.raw.truncate(47);assert_eq!(c.contribution(),Err(Error::MalformedContext));}
 fn hierarchy_fixture(row:&serde_json::Value)->(BTreeMap<u32,inherited::Node>,BTreeMap<(u32,u32),crate::audio_parameter_getters::Input>,crate::audio_rtpc_manager::Manager){
  use crate::audio_parameter_getters::{Input,Range};
  let mut nodes:BTreeMap<u32,inherited::Node>=(0..4).map(|i|(i,inherited::Node{reference:0x30001000+i*0x1000,..Default::default()})).collect();if row["mixed_classes"]==true{for id in [2,3]{nodes.get_mut(&id).unwrap().class=crate::audio_parameter_getters::Class::Bus;}if row["root_class"]=="bus"{nodes.get_mut(&0).unwrap().class=crate::audio_parameter_getters::Class::Bus;}}if row["parent_present"].as_bool().unwrap(){nodes.get_mut(&0).unwrap().parent=Some(1);}if row["bus_present"].as_bool().unwrap(){let n=nodes.get_mut(&0).unwrap();n.bus_override=Some(inherited::BusOverride{node:2,local_slot4:0.,local_slot_c:0.});n.bus_link=Some(2);nodes.get_mut(&2).unwrap().bus_link=Some(3);if row["volume_path"]!="absent"{nodes.get_mut(&2).unwrap().property0=Some(-23.);nodes.get_mut(&3).unwrap().property0=Some(-12.);}if row["volume_path"]=="blocked"{nodes.get_mut(&2).unwrap().block_static_bus_walk=true;}}
  let scope=row["scope"].as_u64().unwrap();for (&i,n) in &mut nodes{if scope&1!=0{n.static_property8=Some((i+1) as f32);}if scope&2!=0{n.object_property8.insert(1,(i+1) as f32*0.25);}}
  let enabled=row["rtpc_enabled"].as_bool().unwrap_or(false);let inputs=[(8,0x110,-31.),(9,0x114,40.)].into_iter().map(|(property,slot,value)|{let range=&row["ranges"][property.to_string()];((0,slot),Input{static_value:Some(value),rtpc_enabled:enabled,range:range.as_array().map(|v|Range{min:v[0].as_f64().unwrap() as f32,max:v[1].as_f64().unwrap() as f32})})}).collect();
  let mut manager=crate::audio_rtpc_manager::Manager::default();manager.records.insert(100,crate::audio_rtpc_manager::Record{default:20.,overrides:BTreeMap::from([(1,25.),(2,75.)])});for (parameter,begin) in [(29,-2.5),(30,5.)]{manager.bindings.insert((nodes[&0].reference,parameter),vec![crate::audio_rtpc_manager::RouteCurve{rtpc:100,curve:crate::audio_curves::Curve{scaling:0,points:vec![crate::audio_curves::Point{from:0.,to:begin,interp:4},crate::audio_curves::Point{from:100.,to:begin+10.,interp:4}]}}]);}(nodes,inputs,manager)
 }
 fn compare_hierarchy(proof:&str,count:usize){let proof:serde_json::Value=serde_json::from_str(proof).unwrap();assert_eq!(proof["case_count"],count);for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){
  let (nodes,inputs,manager)=hierarchy_fixture(row);let reference=row["context_reference"].as_u64().unwrap() as u32;let mut rng=crate::audio_random::NativeRandom::seeded(17);let mut consumer=QualifiedInheritedConsumer{nodes:&nodes,root:0,inputs:&inputs,manager:&manager,rng:&mut rng};let mut allocator=SnapshotAllocator{reference,fail:false};let initial=crate::audio_spatial_controls::tests::hex::<48>(row["initial_prefix"].as_str().unwrap());let mut voice=Voice{context:if row["created"].as_bool().unwrap(){None}else{Some(Context{reference,raw:initial.to_vec()})},eligibility:if row["bus_present"].as_bool().unwrap(){Some(nodes[&2].reference)}else{None},mask:0,optional_mask:Some(3),packed:5,source:0xabcdef};let mut flags=0x80;let calls=route(&mut voice,&mut flags,row["owner"].as_u64().unwrap() as u32,Some(&[1,0]),&mut allocator,&mut consumer).unwrap();let c=voice.context.as_ref().unwrap();assert_eq!(c.reference,reference,"ref {case}");assert_eq!(flags,0xc0,"flags {case}");assert_eq!(c.raw[..48],crate::audio_spatial_controls::tests::hex::<48>(row["output_prefix"].as_str().unwrap()),"prefix {case}");assert_eq!(serde_json::json!(calls),row["calls"],"trace {case}");drop(consumer);assert_eq!(rng.state() as u64,row["rng"].as_u64().unwrap_or(17),"RNG {case}");
 }}
 #[test] fn audio_routing_actual_local_getters_match384_native_cases(){compare_hierarchy(include_str!("../../../data/4.20/audio_routing_inheritance_contract.json"),384);}
 #[test] fn audio_routing_actual_manager_ranges_and_shared_rng_match2304_native_cases(){compare_hierarchy(include_str!("../../../data/4.20/audio_routing_inheritance_rtpc_contract.json"),2304);}
 #[test] fn audio_actual_bus_and_sound_routing_match4608_native_cases(){compare_hierarchy(include_str!("../../../data/4.20/audio_bus_routing_inheritance_rtpc_contract.json"),4608);}
 #[test] fn audio_unresolved_local_getter_does_not_invent_context_values(){let nodes=BTreeMap::from([(0,inherited::Node{bus_override:Some(inherited::BusOverride{node:1,local_slot4:0.,local_slot_c:0.}),..Default::default()}),(1,inherited::Node::default())]);let inputs=BTreeMap::new();let manager=crate::audio_rtpc_manager::Manager::default();let mut rng=crate::audio_random::NativeRandom::seeded(17);let mut consumer=QualifiedInheritedConsumer{nodes:&nodes,root:0,inputs:&inputs,manager:&manager,rng:&mut rng};let mut c=Context{reference:1,raw:vec![0;112]};let before=c.raw.clone();assert!(matches!(consumer.consume(&mut c,0,1),Err(Error::Inheritance(inherited::Error::Getter(crate::audio_parameter_getters::Error::Backend("unresolved local getter"))))));assert_eq!(c.raw,before);drop(consumer);assert_eq!(rng.state(),17);}

}
