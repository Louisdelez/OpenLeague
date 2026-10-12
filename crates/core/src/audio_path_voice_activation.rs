//! Original AEF410 refresh and AEF540 once-only voice activation callers.
//! Shares canonical resource-state storage with configuration and node ownership.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_path_voice_configuration::Runtime,audio_timed_node_selection::Observer};
fn word(b:&[u8],o:usize)->u32{u32::from_le_bytes(b[o..o+4].try_into().unwrap())}
fn voice_valid(voice:&Memory)->Result<(),Error>{if voice.reference==0||voice.raw.len()<408{Err(Error::InvalidAllocation)}else{Ok(())}}
fn start(context:&mut Runtime,source:u32,node:u32,frame:u32,observer:&mut impl Observer)->Result<(),Error>{
 let state_reference=crate::audio_path_source_state::nearest(&context.sources,source)?;
 let mut state:[u8;8]=crate::audio_path_memory::read(&context.resources,state_reference,8)?.try_into().unwrap();
 crate::audio_path_activation::start(&mut context.nodes,&mut context.paths,&mut context.bindings,&mut context.selection,node,&mut state,frame,observer)?;
 let resource=context.resources.get_mut(&state_reference.wrapping_sub(64)).ok_or(Error::UnresolvedReference)?;
 if resource.raw.len()<72{return Err(Error::InvalidAllocation);}resource.raw[64..72].copy_from_slice(&state);Ok(())
}
/// AEF410: update loop byte before checking flags/class and activating.
/// The original mode1 ratio body remains an explicit unqualified boundary.
pub fn refresh(context:&mut Runtime,voice:&mut Memory,frame:u32,observer:&mut impl Observer)->Result<(),Error>{
 voice_valid(voice)?;let flags=voice.raw[299];if flags&3==0{voice.raw[368..372].copy_from_slice(&0x42ca0000u32.to_le_bytes());return Ok(());}
 if flags&12==4{let resource=context.resources.get(&word(&voice.raw,48)).ok_or(Error::UnresolvedReference)?;let flags=*resource.raw.get(56).ok_or(Error::InvalidAllocation)?;if flags&8==0&&voice.raw[300]&0x40!=0{return Ok(());}return Err(Error::Backend("native voice mode1 AF3700/AEC3A0 ratio requires qualification"));}
 let node=word(&voice.raw,400);if node==0{return Ok(());}let resource=context.resources.get(&word(&voice.raw,48)).ok_or(Error::UnresolvedReference)?;let loop_byte=(*resource.raw.get(56).ok_or(Error::InvalidAllocation)?>>5)&1;
 let owned=context.nodes.nodes.get_mut(&node).ok_or(Error::UnresolvedReference)?;if owned.reference!=node||owned.raw.len()<30{return Err(Error::InvalidAllocation);}owned.raw[29]=loop_byte;if loop_byte==0{return Ok(());}if word(&owned.raw,24)&2==0||word(&owned.raw,0)!=0{return Ok(());}start(context,word(&voice.raw,96),node,frame,observer)
}
/// AEF540: overwrite half296 before the byte301 sign-bit guard, then start once.
pub fn once(context:&mut Runtime,voice:&mut Memory,frame:u32,observer:&mut impl Observer)->Result<(),Error>{
 voice_valid(voice)?;let source=word(&voice.raw,96);let input=context.sources.get(&source).ok_or(Error::UnresolvedReference)?;if input.reference!=source{return Err(Error::InvalidAllocation);}let value=crate::audio_path_source_value::value(input,&context.source_properties,&mut context.paths.random,observer)?;voice.raw[296..298].copy_from_slice(&value.to_le_bytes());if voice.raw[301]&0x80!=0{return Ok(());}voice.raw[301]|=0x80;let node=word(&voice.raw,400);if node==0{return Ok(());}start(context,source,node,frame,observer)
}
#[cfg(test)]mod tests{
 use super::*;use std::collections::BTreeMap;use serde_json::{Value,json};use crate::{audio_random::NativeRandom,audio_frame_node_update,audio_timed_node_update,audio_timed_node_segment,audio_timed_node_selection,audio_path_lifecycle};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 fn memory(reference:u32,v:&Value)->Memory{Memory{reference,raw:bytes(v.as_str().unwrap())}}
 fn map(v:&Value)->BTreeMap<u32,Memory>{v.as_array().unwrap().iter().map(|m|{let reference=m["reference"].as_u64().unwrap()as u32;(reference,memory(reference,&m["raw"]))}).collect()}
 fn snapshot(m:&BTreeMap<u32,Memory>)->Value{json!(m.values().map(|m|json!({"reference":m.reference,"raw":hex(&m.raw)})).collect::<Vec<_>>())}
 struct Backend{calls:Vec<Value>}
 impl Observer for Backend{fn observe_random(&mut self,value:u16){self.calls.push(json!({"kind":"rand","value":value}));}}
 #[test]fn audio_path_voice_activation_matches2736_native_refresh_and_once_source_chain_guard_pose_rng_and_full_memory_cases(){
 let refresh_proof:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_path_outer_activation_preparation.json")).unwrap();let once_proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_voice_once_activation_preparation.json")).unwrap();assert_eq!(refresh_proof["passed"],true);assert_eq!(once_proof["passed"],true);assert_eq!(refresh_proof["case_count"],2016);assert_eq!(once_proof["case_count"],720);
 for (proof,is_once)in[(&refresh_proof,false),(&once_proof,true)]{for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut voice=memory(0x40004000,&b["voice"]);let mut context=Runtime{source_properties:BTreeMap::new(),sources:map(&b["source_chain"]),resources:BTreeMap::from([(0x40005000,memory(0x40005000,&b["resource"]))]),inputs:BTreeMap::new(),nodes:audio_frame_node_update::Runtime{reference:0,header:[0;12],table:Memory{reference:0,raw:vec![]},nodes:BTreeMap::from([(0x40006000,memory(0x40006000,&b["node"]))])},bindings:audio_timed_node_update::Runtime{tables:BTreeMap::from([(0x40008000,memory(0x40008000,&b["table"]))]),links:map(&b["links"]),targets:map(&b["targets"])},paths:audio_timed_node_segment::Runtime{descriptors:BTreeMap::from([(0x40007000,memory(0x40007000,&b["descriptor"]))]),points:BTreeMap::from([(0x40007800,memory(0x40007800,&b["points"]))]),random:NativeRandom::seeded(b["rng_state"].as_u64().unwrap()as u32),interval:1024},selection:audio_timed_node_selection::Runtime::default(),lifetime:audio_path_lifecycle::Runtime::default()};let mut backend=Backend{calls:vec![]};let frame=row["frame"].as_u64().unwrap()as u32;
 if is_once{once(&mut context,&mut voice,frame,&mut backend).unwrap();}else{refresh(&mut context,&mut voice,frame,&mut backend).unwrap();}
 assert_eq!(json!(backend.calls),row["calls"],"calls family{is_once} case{i}");assert_eq!(json!({"voice":hex(&voice.raw),"source_chain":snapshot(&context.sources),"resource":hex(&context.resources[&0x40005000].raw),"node":hex(&context.nodes.nodes[&0x40006000].raw),"descriptor":hex(&context.paths.descriptors[&0x40007000].raw),"points":hex(&context.paths.points[&0x40007800].raw),"table":hex(&context.bindings.tables[&0x40008000].raw),"links":snapshot(&context.bindings.links),"targets":snapshot(&context.bindings.targets),"rng_state":context.paths.random.state()}),row["after"],"all bytes family{is_once} case{i}");}}
 }
}
