//! Verified HIRC8/FF1380 bus actor B02A70, not the sound actor AF0880.
use std::collections::BTreeMap;
use crate::{audio_control_refresh::{State,Request},audio_rtpc_manager::Manager};
#[derive(Debug,Clone,Default)] pub struct Node {pub reference:u32,pub props:BTreeMap<u8,f32>,pub global:BTreeMap<u8,f32>,pub cached:Vec<BTreeMap<u8,f32>>,pub rtpc_mask:u64,/// Captured native global state10 caller flags; reserved bits remain explicit.
 pub gain_flags:Option<u32>}
#[derive(Debug,PartialEq)] pub enum Error {EmptyHierarchy,InvalidValue,Unsupported(&'static str),Gain(crate::audio_gain_entries::Error),Rtpc(crate::audio_rtpc_manager::Error)}
#[derive(Debug,Clone,PartialEq,serde::Serialize)] #[serde(tag="kind",rename_all="lowercase")]
pub enum Call {Bus {node:usize,mask:u32,owner:u32,first:u32,last:u32},Rtpc {node:usize,parameter:u32,owner:u32},Gain {node:usize,flags:u32,gain_bits:u32}}
fn add(s:&mut State,o:usize,v:f32){s.set_value(o,s.value(o)+v);}
/// Nodes are the ordered bus24 chain. Actor-parent20/object-child40 do not
/// participate. Cached states precede static/RTPC and global contributions.
pub(crate) fn validate(nodes:&[Node])->Result<(),Error>{
 if nodes.is_empty(){return Err(Error::EmptyHierarchy);}for n in nodes {if n.global.get(&10).is_some_and(|v|*v!=1.){let Some(flags)=n.gain_flags else{return Err(Error::Unsupported("bus state10 native caller flags missing"));};if flags&3!=1{return Err(Error::InvalidValue);}}if n.props.values().chain(n.global.values()).chain(n.cached.iter().flat_map(|p|p.values())).any(|v|!v.is_finite()){return Err(Error::InvalidValue);}}
 Ok(())
}
pub fn apply(nodes:&[Node],state:&mut State,request:Request,manager:&Manager)->Result<Vec<Call>,Error>{
 validate(nodes)?;if state.entries.iter().any(|e|!e.gain.is_finite()){return Err(Error::InvalidValue);}
 if [state.value(8),state.value(12)].iter().any(|v|!v.is_finite()){return Err(Error::InvalidValue);}let mut calls=Vec::new();let mut mask=request.mask;
 for (i,n) in nodes.iter().enumerate(){calls.push(Call::Bus {node:i,mask,owner:request.owner,first:request.first,last:if i==0{request.last}else{1}});mask&=0xfffffff6;
  for cached in &n.cached {for (key,bit,offset) in [(2,2,8),(3,4,12)]{if mask&bit!=0{if let Some(v)=cached.get(&key){add(state,offset,*v);}}}}
  for (key,bit,offset,parameter) in [(2,2,8,2),(3,4,12,3)] {if mask&bit!=0 {add(state,offset,n.props.get(&key).copied().unwrap_or(0.));if n.rtpc_mask&(1u64<<parameter)!=0 {calls.push(Call::Rtpc {node:i,parameter,owner:0});let v=manager.evaluate(n.reference,parameter,0).map_err(Error::Rtpc)?.value;add(state,offset,v);}}}
  for (key,offset) in [(2,8),(3,12)]{if let Some(v)=n.global.get(&key){add(state,offset,*v);}}
  if let Some(&gain)=n.global.get(&10){if gain!=1. {let flags=n.gain_flags.expect("validated native gain flags");calls.push(Call::Gain{node:i,flags,gain_bits:gain.to_bits()});crate::audio_gain_entries::upsert(&mut state.entries,n.reference,flags,gain).map_err(Error::Gain)?;}}
 }
 if [state.value(8),state.value(12)].iter().any(|v|!v.is_finite()){return Err(Error::InvalidValue);}Ok(calls)
}
#[cfg(test)] pub(crate) mod tests {
 use super::*;
 pub(crate) fn fixture(row:&serde_json::Value)->(Vec<Node>,Manager){fn props(v:&serde_json::Value)->BTreeMap<u8,f32>{v.as_object().unwrap().iter().map(|(k,v)|(k.parse().unwrap(),v.as_f64().unwrap() as f32)).collect()}
 let nodes:Vec<_>=row["nodes"].as_array().unwrap().iter().map(|v|Node {reference:v["reference"].as_u64().unwrap() as u32,props:props(&v["props"]),global:props(&v["global"]),cached:v["cached"].as_array().unwrap().iter().map(props).collect(),rtpc_mask:if v["rtpc"].as_bool().unwrap(){(1<<2)|(1<<3)}else{0},gain_flags:None}).collect();let mut manager=Manager::default();manager.records.insert(100,crate::audio_rtpc_manager::Record {default:20.,overrides:BTreeMap::from([(0,25.),(77,75.)])});for (i,n) in nodes.iter().enumerate(){for p in [2,3]{let begin=p as f32*0.125+i as f32*2.;manager.bindings.insert((n.reference,p),vec![crate::audio_rtpc_manager::RouteCurve {rtpc:100,curve:crate::audio_curves::Curve {scaling:0,points:vec![crate::audio_curves::Point {from:0.,to:begin,interp:4},crate::audio_curves::Point {from:100.,to:begin+10.,interp:4}]}}]);}}(nodes,manager)}
 fn state()->State{let mut s=State{block:[0;84],flags:[0;5],entries:vec![],extras:[23.,29.,31.],d4:0.,d8:1.,dc:1.,cc:0.,d0:0.,pair:[0.;2],spatial:crate::audio_spatial_controls::Spatial::default(),pose:None,range_limit:0.,context:None,optional:false,owner:0};for (o,v) in [(0,13.),(4,1.),(8,17.),(12,19.),(20,5.)]{s.set_value(o,v);}s}
 #[test] fn audio_original_bus_actor_matches3072_native_cases(){let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_bus_controls_contract.json")).unwrap();assert_eq!(proof["case_count"],3072);for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){let (nodes,manager)=fixture(row);let mut s=state();let calls=apply(&nodes,&mut s,Request {mask:row["mask"].as_u64().unwrap() as u32,first:row["first"].as_u64().unwrap() as u32,owner:row["owner"].as_u64().unwrap() as u32,last:row["last"].as_u64().unwrap() as u32},&manager).unwrap();assert_eq!(s.block,crate::audio_spatial_controls::tests::hex::<84>(row["output_block"].as_str().unwrap()),"block {case}");assert_eq!(serde_json::json!(s.extras.map(f32::to_bits)),row["output_extras_bits"],"extras {case}");assert_eq!(serde_json::json!(calls),row["calls"],"calls {case}");}}
 #[test] fn audio_unqualified_bus_gain_entries_fail_before_mutation(){let mut s=state();let before=s.block;let m=Manager::default();let r=Request{mask:u32::MAX,first:1,owner:77,last:1};assert_eq!(apply(&[],&mut s,r,&m),Err(Error::EmptyHierarchy));assert!(matches!(apply(&[Node {global:BTreeMap::from([(10,0.5)]),..Default::default()}],&mut s,r,&m),Err(Error::Unsupported(_))));assert_eq!(s.block,before);assert_eq!(apply(&[Node {global:BTreeMap::from([(10,0.5)]),gain_flags:Some(2),..Default::default()}],&mut s,r,&m),Err(Error::InvalidValue));assert_eq!(s.block,before);assert_eq!(apply(&[Node {props:BTreeMap::from([(2,f32::NAN)]),..Default::default()}],&mut s,r,&m),Err(Error::InvalidValue));assert_eq!(s.block,before);}
}
