//! Source-routed control evaluation. These controls are not a finished voice mixer.
//! Scalar contributions remain per node until native aggregation/DSP is qualified.
use crate::audio_curves::{Curve,Error as CurveError};
use serde::Deserialize;
use std::collections::{BTreeMap,BTreeSet};
#[derive(Clone,Debug,Deserialize)]
pub struct Control {pub node:String,pub properties:BTreeMap<String,f32>,pub ranges:BTreeMap<String,Range>}
#[derive(Clone,Debug,Deserialize)]
pub struct Range {pub min:f32,pub max:f32}
#[derive(Clone,Debug,Deserialize)]
pub struct BusControl {pub node:String,pub parameter:u32,pub default:f32,pub curve:Curve}
#[derive(Clone,Debug,Deserialize)]
pub struct Route {
 pub event:u32,pub sound:u32,pub actor_chain:Vec<String>,pub bus_chain:Vec<String>,
 pub controls:Vec<Control>,pub attenuation:Curve,pub bus_controls:Vec<BusControl>,
}
#[derive(Debug,Deserialize)]
pub struct Contract {pub routes:Vec<Route>}
#[derive(Debug,PartialEq)]
pub enum Error {InvalidContract,UnknownSound(u32,u32),InvalidDistance,InvalidParameter(u32),Curve(CurveError)}
#[derive(Debug)]
pub struct Evaluated {
 pub distance:f32,
 pub attenuation_db:f32,
 /// Individual original bus RTPC amplitude controls in leaf-to-master order.
 pub bus_gains:Vec<(String,u32,f32)>,
 pub node_controls:Vec<Control>,
}
impl Contract {
 pub fn native()->Result<Self,Error> {
  let c:Self=serde_json::from_str(include_str!("../../../data/4.20/ambient_mix_routes.json")).map_err(|_|Error::InvalidContract)?;
  c.validate()?;Ok(c)
 }
 pub fn validate(&self)->Result<(),Error> {
  if self.routes.is_empty() {return Err(Error::InvalidContract);}
  let mut seen=BTreeSet::new();
  for r in &self.routes {
   if !seen.insert((r.event,r.sound)) || r.actor_chain.is_empty() || r.bus_chain.is_empty()
    || r.controls.iter().map(|c|&c.node).ne(r.actor_chain.iter()) {return Err(Error::InvalidContract);}
   let mut chain=BTreeSet::new();
   if r.actor_chain.iter().chain(&r.bus_chain).any(|n|!chain.insert(n)) {return Err(Error::InvalidContract);}
   r.attenuation.validate().map_err(Error::Curve)?;
   for c in &r.controls {
    if c.properties.values().any(|v|!v.is_finite()) || c.ranges.values().any(|v|!v.min.is_finite()||!v.max.is_finite()||v.min>v.max) {return Err(Error::InvalidContract);}
   }
   for b in &r.bus_controls {
    if !r.bus_chain.contains(&b.node) || !b.default.is_finite() || b.curve.scaling!=2 {return Err(Error::InvalidContract);}
    b.curve.validate().map_err(Error::Curve)?;
   }
  }
  Ok(())
 }
 /// Feed source-qualified spatial descriptor distance into native attenuation.
 /// Caller must supply backend position components and the correct listener mask.
 /// This does not qualify current camera/world descriptor mapping or final gains.
 pub fn evaluate_spatial(&self,event:u32,sound:u32,sources:crate::audio_distance::Sources<'_>,listeners:&[crate::audio_distance::Listener;8],listener_mask:u8,parameters:&BTreeMap<u32,f32>)->Result<Evaluated,Error> {
  let distance=crate::audio_distance::nearest(sources,listeners,listener_mask).map_err(|_|Error::InvalidDistance)?;
  self.evaluate(event,sound,distance,parameters)
 }
 /// The caller supplies measured native distance. This does not choose a spatial
 /// metric, combine gain contributions, convert pitch, or run the LPF.
 pub fn evaluate(&self,event:u32,sound:u32,distance:f32,parameters:&BTreeMap<u32,f32>)->Result<Evaluated,Error> {
  if !distance.is_finite() || distance<0. {return Err(Error::InvalidDistance);}
  let r=self.routes.iter().find(|r|r.event==event&&r.sound==sound).ok_or(Error::UnknownSound(event,sound))?;
  let attenuation_db=r.attenuation.evaluate(distance).map_err(Error::Curve)?;
  let mut bus_gains=Vec::new();
  for b in &r.bus_controls {
   let input=parameters.get(&b.parameter).copied().unwrap_or(b.default);
   if !input.is_finite() {return Err(Error::InvalidParameter(b.parameter));}
   bus_gains.push((b.node.clone(),b.parameter,b.curve.bus_gain(input).map_err(Error::Curve)?));
  }
  Ok(Evaluated {distance,attenuation_db,bus_gains,node_controls:r.controls.clone()})
 }
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn all_source_sounds_have_evaluable_native_routes() {
  let c=Contract::native().unwrap();assert_eq!(c.routes.len(),42);
  for r in &c.routes {
   let v=c.evaluate(r.event,r.sound,1350.,&BTreeMap::new()).unwrap();
   assert_eq!(v.attenuation_db,0.);assert_eq!(v.bus_gains.len(),2);
   assert!(v.bus_gains.iter().all(|(_,_,g)|*g==1.));
   let far=c.evaluate(r.event,r.sound,10000.,&BTreeMap::new()).unwrap();assert_eq!(far.attenuation_db,-4096.);
  }
 }
 #[test] fn environment_and_shop_routes_use_distinct_volume_parameters() {
  let c=Contract::native().unwrap();let overrides=BTreeMap::from([(2442501159,25.),(3273357900,50.),(3391499625,75.)]);
  let env=c.evaluate(1392698701,258704465,0.,&overrides).unwrap();
  assert_eq!(env.bus_gains.iter().map(|(_,p,g)|(*p,*g)).collect::<Vec<_>>(),vec![(2442501159,0.25),(3391499625,0.75)]);
  let shop=c.evaluate(910296305,799533143,0.,&overrides).unwrap();
  assert_eq!(shop.bus_gains.iter().map(|(_,p,g)|(*p,*g)).collect::<Vec<_>>(),vec![(3273357900,0.5),(3391499625,0.75)]);
  assert_eq!(shop.node_controls[1].properties["0"],-31.);
  assert_eq!(env.node_controls[1].ranges["2"].max,200.);
 }
 #[test] fn source_qualified_spatial_distance_drives_all_native_attenuation_routes() {
  use crate::audio_distance::{Listener,Sources,DISTANCE_SENTINEL};
  #[derive(serde::Deserialize)]struct Case {listener_mask:u8,mode_raw:u8,positions:Vec<[f32;3]>,listeners:[Listener;8],native_distance:f32}
  #[derive(serde::Deserialize)]struct Distances {cases:Vec<Case>}
  let distances:Distances=serde_json::from_str(include_str!("../../../data/4.20/audio_distance_contract.json")).unwrap();let c=Contract::native().unwrap();let params=BTreeMap::new();let mut checked=0;
  for sample in distances.cases {
   for route in &c.routes {
    let actual=c.evaluate_spatial(route.event,route.sound,Sources {positions:&sample.positions,mode_raw:sample.mode_raw},&sample.listeners,sample.listener_mask,&params).unwrap();
    assert_eq!(actual.distance.to_bits(),sample.native_distance.to_bits());assert_eq!(actual.attenuation_db,route.attenuation.evaluate(sample.native_distance).unwrap());
    if sample.listener_mask==0 {assert_eq!(actual.distance,DISTANCE_SENTINEL);assert_eq!(actual.attenuation_db,-4096.);}
    assert!(actual.bus_gains.iter().all(|(_,_,gain)|*gain==1.));checked+=1;
   }
  }
  assert_eq!(checked,15162);
 }
 #[test] fn invalid_distance_and_used_parameter_never_produce_mix_controls() {
  let c=Contract::native().unwrap();
  for d in [f32::NAN,f32::INFINITY,-1.] {assert!(matches!(c.evaluate(910296305,799533143,d,&BTreeMap::new()),Err(Error::InvalidDistance)));}
  assert!(matches!(c.evaluate(910296305,799533143,0.,&BTreeMap::from([(3273357900,f32::NAN)])),Err(Error::InvalidParameter(3273357900))));
  assert!(matches!(c.evaluate(910296305,1,0.,&BTreeMap::new()),Err(Error::UnknownSound(910296305,1))));
 }
 #[test] fn duplicate_or_cyclic_routes_are_rejected() {
  let mut c=Contract::native().unwrap();c.routes.push(c.routes[0].clone());assert_eq!(c.validate(),Err(Error::InvalidContract));
  c.routes.pop();let cycle=c.routes[0].actor_chain[0].clone();c.routes[0].bus_chain.push(cycle);assert_eq!(c.validate(),Err(Error::InvalidContract));
 }
}
