//! Native B11040/B110A0 routing and B11320 owner/global/default resolution.
//! Bindings must come from verified bank/runtime data; creation and smoothing are separate.
use std::collections::BTreeMap;
use crate::audio_curves::Curve;
use serde::Deserialize;
#[derive(Debug, Clone, Deserialize)]
pub struct RouteCurve {pub rtpc:u32, #[serde(flatten)] pub curve:Curve}
#[derive(Debug, Clone, Default)]
pub struct Record {pub default:f32, pub overrides:BTreeMap<u32,f32>}
#[derive(Debug, Clone, Default)]
pub struct Manager {
 pub bindings:BTreeMap<(u32,u32),Vec<RouteCurve>>,
 pub records:BTreeMap<u32,Record>,
}
#[derive(Debug, PartialEq)]
pub enum Error {InvalidValue, Curve(crate::audio_curves::Error), Overflow}
#[derive(Debug, Clone, PartialEq)]
pub struct CurveCall {pub curve:usize,pub input_bits:u32}
#[derive(Debug, PartialEq)]
pub struct Evaluation {pub value:f32,pub calls:Vec<CurveCall>}
impl Manager {
 /// Exact owner overrides take precedence over owner zero, then the record default.
 /// Native absence of the whole RTPC record resolves to zero.
 pub fn value(&self,rtpc:u32,owner:u32)->Result<f32,Error> {
  let value=self.records.get(&rtpc).map_or(0.,|r|r.overrides.get(&owner).or_else(||r.overrides.get(&0)).copied().unwrap_or(r.default));
  if value.is_finite(){Ok(value)}else{Err(Error::InvalidValue)}
 }
 pub fn evaluate(&self,subscriber:u32,parameter:u32,owner:u32)->Result<Evaluation,Error> {
  match self.bindings.get(&(subscriber,parameter)) {
   Some(curves)=>self.evaluate_binding(curves,owner,None),
   None=>Ok(Evaluation {value:0.,calls:Vec::new()}),
  }
 }
 /// None matches selector zero (all curves). Duplicate curves are evaluated in order.
 pub fn evaluate_binding(&self,curves:&[RouteCurve],owner:u32,selector:Option<u32>)->Result<Evaluation,Error> {
  let selector=selector.filter(|v|*v!=0);
  let mut value=0f32;let mut calls=Vec::new();
  for (index,route) in curves.iter().enumerate() {
   if selector.is_some_and(|id|id!=route.rtpc){continue;}
   let input=self.value(route.rtpc,owner)?;
   let output=route.curve.evaluate(input).map_err(Error::Curve)?;
   calls.push(CurveCall {curve:index,input_bits:input.to_bits()});
   value+=output;if !value.is_finite(){return Err(Error::Overflow);}
  }
  Ok(Evaluation {value,calls})
 }
 /// Connects the actual manager lookup to property8/9 getters without a fixed RTPC adapter.
 pub fn getter(&self,subscriber:u32,owner:u32,kind:crate::audio_parameter_getters::Kind,input:crate::audio_parameter_getters::Input,rng:&mut crate::audio_random::NativeRandom)->Result<f32,crate::audio_parameter_getters::Error> {
  crate::audio_parameter_getters::evaluate_with_rng(kind,input,|parameter|self.evaluate(subscriber,parameter,owner).map(|r|r.value).map_err(|_|crate::audio_parameter_getters::Error::Backend("RTPC evaluation failed")),rng)
 }
}
#[cfg(test)] mod tests {
 use super::*;
 #[derive(Deserialize)] struct Override {owner:u32,value:f32}
 #[derive(Deserialize)] struct SourceRecord {rtpc:u32,default:f32,overrides:Vec<Override>}
 #[derive(Deserialize)] struct NativeCall {curve:usize,input_bits:u32}
 #[derive(Deserialize)] struct Case {found:bool,subscriber:u32,parameter:u32,owner:u32,selector:Option<u32>,curves:Vec<RouteCurve>,records:Vec<SourceRecord>,result_bits:u32,calls:Vec<NativeCall>}
 #[derive(Deserialize)] struct Proof {passed:bool,case_count:usize,cases:Vec<Case>}
 #[test] fn original_manager_owner_defaults_collisions_and_order_match3456_cases() {
  let proof:Proof=serde_json::from_str(include_str!("../../../data/4.20/audio_rtpc_manager_contract.json")).unwrap();assert!(proof.passed);assert_eq!(proof.case_count,3456);assert_eq!(proof.cases.len(),3456);
  for (index,row) in proof.cases.into_iter().enumerate() {
   let mut manager=Manager::default();
   for record in row.records {manager.records.insert(record.rtpc,Record {default:record.default,overrides:record.overrides.into_iter().map(|v|(v.owner,v.value)).collect()});}
   // Include a key which collides in the original wrapping 193-bucket table.
   manager.bindings.insert((row.subscriber.wrapping_add(193),row.parameter),row.curves.clone());
   if row.found {manager.bindings.insert((row.subscriber,row.parameter),row.curves.clone());}
   let actual=match row.selector {None=>manager.evaluate(row.subscriber,row.parameter,row.owner),Some(selector)=>manager.evaluate_binding(&row.curves,row.owner,Some(selector))}.unwrap();
   assert_eq!(actual.value.to_bits(),row.result_bits,"case {index}");
   assert_eq!(actual.calls,row.calls.into_iter().map(|v|CurveCall {curve:v.curve,input_bits:v.input_bits}).collect::<Vec<_>>(),"case {index}");
  }
 }
 fn route(rtpc:u32)->RouteCurve {RouteCurve {rtpc,curve:Curve {scaling:0,points:vec![crate::audio_curves::Point {from:0.,to:0.,interp:4},crate::audio_curves::Point {from:100.,to:10.,interp:4}]}}}
 #[test] fn actual_manager_composes_getters_with_shared_rng_and_owner_precedence() {
  use crate::audio_parameter_getters::{Kind,Input,Range};
  let mut manager=Manager::default();manager.bindings.insert((12,29),vec![route(100)]);manager.bindings.insert((12,30),vec![route(100),route(100)]);
  manager.records.insert(100,Record {default:20.,overrides:BTreeMap::from([(0,25.),(77,75.)])});
  let mut rng=crate::audio_random::NativeRandom::seeded(17);let state=rng.state();
  assert_eq!(manager.getter(12,77,Kind::Property8,Input {static_value:Some(-31.),rtpc_enabled:true,range:None},&mut rng),Ok(7.5));assert_eq!(rng.state(),state);
  assert_eq!(manager.getter(12,88,Kind::Property9,Input {static_value:Some(40.),rtpc_enabled:true,range:None},&mut rng),Ok(45.));
  let mut expected_rng=rng.clone();let input=Input {static_value:Some(40.),rtpc_enabled:true,range:Some(Range {min:-8.,max:0.})};
  let expected=crate::audio_parameter_getters::evaluate_with_rng(Kind::Property9,input,|_|Ok(15.),&mut expected_rng);
  assert_eq!(manager.getter(12,77,Kind::Property9,input,&mut rng),expected);assert_eq!(rng.state(),expected_rng.state());
 }
 #[test] fn unsupported_curves_and_invalid_values_fail_before_consuming_getter_rng() {
  let mut manager=Manager::default();manager.bindings.insert((12,29),vec![route(100)]);manager.records.insert(100,Record {default:f32::NAN,..Default::default()});
  let mut rng=crate::audio_random::NativeRandom::seeded(17);let state=rng.state();
  let result=manager.getter(12,77,crate::audio_parameter_getters::Kind::Property8,crate::audio_parameter_getters::Input {rtpc_enabled:true,range:Some(crate::audio_parameter_getters::Range {min:0.,max:1.}),..Default::default()},&mut rng);
  assert!(result.is_err());assert_eq!(rng.state(),state);
  manager.records.clear();manager.bindings.get_mut(&(12,29)).unwrap()[0].curve.scaling=99;
  assert_eq!(manager.evaluate(12,29,77),Err(Error::Curve(crate::audio_curves::Error::UnsupportedScaling(99))));
  assert_eq!(manager.evaluate(12,30,77).unwrap().value,0.);
 }
}
