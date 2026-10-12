//! AFF450 inherited property5/6 pair, with actual RTPC8 replacement.
use std::collections::BTreeMap;
use crate::audio_rtpc_manager::Manager;
#[derive(Debug,Clone,Default)] pub struct Node {pub reference:u32,pub flags2e:u8,pub props:BTreeMap<u8,f32>,pub rtpc:bool}
#[derive(Debug,PartialEq)] pub enum Error {EmptyHierarchy,InvalidValue,Rtpc(crate::audio_rtpc_manager::Error)}
#[derive(Debug,Clone,PartialEq,serde::Serialize)] #[serde(tag="kind",rename_all="lowercase")]
pub enum Call {Pair {node:usize},Rtpc {node:usize,parameter:u32,owner:u32}}
pub fn evaluate(nodes:&[Node],owner:u32,manager:&Manager)->Result<([f32;2],Vec<Call>),Error>{
 if nodes.is_empty(){return Err(Error::EmptyHierarchy);}let mut calls=Vec::new();for (i,n) in nodes.iter().enumerate(){calls.push(Call::Pair {node:i});if n.flags2e&0x40==0 && i+1<nodes.len(){continue;}
 let first=if n.rtpc {calls.push(Call::Rtpc {node:i,parameter:8,owner});manager.evaluate(n.reference,8,owner).map_err(Error::Rtpc)?.value}else{n.props.get(&5).copied().unwrap_or(50.)};
 let second=if n.flags2e&0x20!=0 {n.props.get(&6).copied().unwrap_or(-10.)}else{0.};if !first.is_finite() || !second.is_finite(){return Err(Error::InvalidValue);}return Ok(([first,second],calls));}unreachable!("root always qualifies")
}
pub struct PairBackend<'a,B>{pub dependencies:&'a mut B,pub nodes:&'a [Node],pub manager:&'a Manager,pub calls:Vec<Call>}
impl<B:crate::audio_control_refresh::Backend> crate::audio_control_refresh::Backend for PairBackend<'_,B>{
 fn spatial(&mut self,s:&mut crate::audio_control_refresh::State)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.spatial(s)}
 fn optional(&mut self)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.optional()}
 fn flag(&mut self,o:u32)->Result<u8,crate::audio_control_refresh::Error>{self.dependencies.flag(o)}
 fn source(&mut self)->Result<f32,crate::audio_control_refresh::Error>{self.dependencies.source()}
 fn routing(&mut self,s:&mut crate::audio_control_refresh::State)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.routing(s)}
 fn parameters(&mut self,s:&mut crate::audio_control_refresh::State,r:crate::audio_control_refresh::Request)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.parameters(s,r)}
 fn pair(&mut self,o:u32)->Result<[f32;2],crate::audio_control_refresh::Error>{let (value,calls)=evaluate(self.nodes,o,self.manager).map_err(|_|crate::audio_control_refresh::Error::Backend("pair controls failed"))?;self.calls=calls;Ok(value)}
 fn transition(&mut self,v:f32)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.transition(v)}
}
#[cfg(test)] pub(crate) mod tests {
 use super::*;
 pub(crate) fn fixture(row:&serde_json::Value,whole:bool)->(Vec<Node>,Manager){let nodes:Vec<_>=row["nodes"].as_array().unwrap().iter().map(|v|Node {reference:v["reference"].as_u64().unwrap() as u32,flags2e:v["flags2e"].as_u64().unwrap() as u8,props:v["props"].as_object().unwrap().iter().map(|(k,v)|(k.parse().unwrap(),v.as_f64().unwrap() as f32)).collect(),rtpc:v["rtpc"].as_bool().unwrap()}).collect();let mut manager=Manager::default();manager.records.insert(100,crate::audio_rtpc_manager::Record {default:20.,overrides:BTreeMap::from([(0,25.),(77,75.)])});for (i,n) in nodes.iter().enumerate(){let curve=&row["nodes"][i][if whole {"pair_curve"}else{"curve"}];manager.bindings.insert((n.reference,8),vec![crate::audio_rtpc_manager::RouteCurve {rtpc:100,curve:crate::audio_curves::Curve {scaling:0,points:vec![crate::audio_curves::Point {from:0.,to:curve[0].as_f64().unwrap() as f32,interp:4},crate::audio_curves::Point {from:100.,to:curve[1].as_f64().unwrap() as f32,interp:4}]}}]);}(nodes,manager)}
 #[test] fn native_inherited_pair_matches1536_cases(){let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_pair_controls_contract.json")).unwrap();assert_eq!(proof["case_count"],1536);assert_eq!(proof["default_property5_bits"],50f32.to_bits());assert_eq!(proof["default_property6_bits"],(-10f32).to_bits());for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){let (n,m)=fixture(row,false);let (v,calls)=evaluate(&n,row["owner"].as_u64().unwrap() as u32,&m).unwrap();assert_eq!(serde_json::json!(v.map(f32::to_bits)),row["output_bits"],"pair {case}");assert_eq!(serde_json::json!(calls),row["calls"],"calls {case}");}}
 #[test] fn invalid_pair_controls_fail_instead_of_using_guessed_defaults(){let m=Manager::default();assert_eq!(evaluate(&[],0,&m),Err(Error::EmptyHierarchy));let n=Node {props:BTreeMap::from([(5,f32::NAN)]),..Default::default()};assert_eq!(evaluate(&[n],0,&m),Err(Error::InvalidValue));}
}
