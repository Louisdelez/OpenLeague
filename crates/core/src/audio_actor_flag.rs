//! FF1CD8 E8 = AF14D0 Boolean control, including AF06F0 first-match lookup.
use std::collections::BTreeMap;
use crate::audio_rtpc_manager::Manager;
#[derive(Debug,Clone,Default)] pub struct Node {pub reference:u32,pub flags2f:u8,pub initial:Option<u8>,pub global:Option<u8>,pub objects:Option<Vec<(u32,u8)>>,pub rtpc:bool}
#[derive(Debug,PartialEq)] pub enum Error {EmptyHierarchy,Rtpc(crate::audio_rtpc_manager::Error)}
#[derive(Debug,Clone,PartialEq,serde::Serialize)] #[serde(tag="kind",rename_all="lowercase")]
pub enum Call {Node {node:usize},Rtpc {node:usize,parameter:u32,owner:u32},Object {node:usize,owner:u32}}
#[derive(Debug,PartialEq)] pub struct Evaluation {pub value:u8,pub calls:Vec<Call>}
pub fn evaluate(nodes:&[Node],owner:u32,manager:&Manager)->Result<Evaluation,Error>{
 if nodes.is_empty(){return Err(Error::EmptyHierarchy);}let mut calls=Vec::new();
 for (i,n) in nodes.iter().enumerate(){
  calls.push(Call::Node {node:i});if n.flags2f&0x40==0 && i+1<nodes.len(){continue;}
  let Some(initial)=n.initial else{return Ok(Evaluation {value:0,calls})};
  if n.rtpc {calls.push(Call::Rtpc {node:i,parameter:28,owner});let value=manager.evaluate(n.reference,28,owner).map_err(Error::Rtpc)?.value;return Ok(Evaluation {value:u8::from(value!=0.),calls});}
  let mut flag=initial;
  if let Some(objects)=&n.objects {calls.push(Call::Object {node:i,owner});if let Some((_,value))=objects.iter().find(|(id,_)|*id==owner){return Ok(Evaluation {value:(value>>4)&1,calls});}}
  if let Some(global)=n.global {flag=global;}
  return Ok(Evaluation {value:(flag>>4)&1,calls});
 }
 unreachable!("root always qualifies")
}
/// Replaces the flag dependency; keeps all other qualified dependencies mandatory.
pub struct FlagBackend<'a,B>{pub dependencies:&'a mut B,pub nodes:&'a [Node],pub manager:&'a Manager,pub calls:Vec<Call>}
impl<B:crate::audio_control_refresh::Backend> crate::audio_control_refresh::Backend for FlagBackend<'_,B>{
 fn spatial(&mut self,s:&mut crate::audio_control_refresh::State)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.spatial(s)}
 fn optional(&mut self)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.optional()}
 fn flag(&mut self,o:u32)->Result<u8,crate::audio_control_refresh::Error>{let value=evaluate(self.nodes,o,self.manager).map_err(|_|crate::audio_control_refresh::Error::Backend("actor flag failed"))?;self.calls=value.calls;Ok(value.value)}
 fn source(&mut self)->Result<f32,crate::audio_control_refresh::Error>{self.dependencies.source()}
 fn routing(&mut self,s:&mut crate::audio_control_refresh::State)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.routing(s)}
 fn parameters(&mut self,s:&mut crate::audio_control_refresh::State,r:crate::audio_control_refresh::Request)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.parameters(s,r)}
 fn pair(&mut self,o:u32)->Result<[f32;2],crate::audio_control_refresh::Error>{self.dependencies.pair(o)}
 fn transition(&mut self,v:f32)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.transition(v)}
}
#[cfg(test)] pub(crate) mod tests {
 use super::*;
 pub(crate) fn fixture(row:&serde_json::Value,whole:bool)->(Vec<Node>,Manager){
  let byte=|v:&serde_json::Value|v.as_u64().map(|v|v as u8);let key=|name:&str|if whole {format!("flag_{name}")}else{name.to_string()};
  let nodes:Vec<_>=row["nodes"].as_array().unwrap().iter().map(|v|Node {reference:v["reference"].as_u64().unwrap() as u32,flags2f:v["flags2f"].as_u64().unwrap() as u8,initial:byte(&v[&key("initial")]),global:byte(&v[&key("global")]),objects:v[&key("objects")].as_array().map(|a|a.iter().map(|v|(v[0].as_u64().unwrap() as u32,v[1].as_u64().unwrap() as u8)).collect()),rtpc:v["rtpc"].as_bool().unwrap()}).collect();
  let mut manager=Manager::default();manager.records.insert(100,crate::audio_rtpc_manager::Record {default:20.,overrides:BTreeMap::from([(0,25.),(77,75.)])});
  for (i,n) in nodes.iter().enumerate(){let curve=&row["nodes"][i][if whole {"flag_curve"}else{"curve"}];manager.bindings.insert((n.reference,28),vec![crate::audio_rtpc_manager::RouteCurve {rtpc:100,curve:crate::audio_curves::Curve {scaling:0,points:vec![crate::audio_curves::Point {from:0.,to:curve[0].as_f64().unwrap() as f32,interp:4},crate::audio_curves::Point {from:100.,to:curve[1].as_f64().unwrap() as f32,interp:4}]}}]);}
  (nodes,manager)
 }
 #[test] fn native_inherited_flags_and_priority_match9216_cases(){let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_actor_flag_contract.json")).unwrap();assert_eq!(proof["case_count"],9216);for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){let (n,m)=fixture(row,false);let v=evaluate(&n,row["owner"].as_u64().unwrap() as u32,&m).unwrap();assert_eq!(serde_json::json!(v.value),row["value"],"value {case}");assert_eq!(serde_json::json!(v.calls),row["calls"],"calls {case}");}}
 #[test] fn invalid_rtpc_is_not_silently_converted_to_a_boolean(){assert_eq!(evaluate(&[],0,&Manager::default()),Err(Error::EmptyHierarchy));let mut m=Manager::default();m.records.insert(100,crate::audio_rtpc_manager::Record {default:f32::NAN,..Default::default()});m.bindings.insert((1,28),vec![crate::audio_rtpc_manager::RouteCurve {rtpc:100,curve:crate::audio_curves::Curve {scaling:0,points:vec![crate::audio_curves::Point {from:0.,to:0.,interp:4}]}}]);let n=Node {reference:1,initial:Some(0x10),rtpc:true,..Default::default()};assert!(matches!(evaluate(&[n],0,&m),Err(Error::Rtpc(_))));let n=Node {reference:1,initial:None,rtpc:true,..Default::default()};assert_eq!(evaluate(&[n],0,&m).unwrap().value,0);}
}
