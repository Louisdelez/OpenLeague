//! Effects reader callbacks sharing one live Bus graph, source store and target registry.
//! Allocation and effect-instance replacement remain mandatory external operations.
use crate::{audio_bus_bank::Error,audio_bus_registry::Bus,audio_bus_effects_bank as effects,audio_bus_effects_changed as changed,audio_bus_gain_aggregation as gain,audio_bus_gain_application as application,audio_bus_effect_slot_dispatch as slot};
pub trait Refresh{fn dispatch(&mut self,b:&Bus,g:&changed::Graph,inputs:&gain::Inputs,targets:&mut crate::audio_bus_control_application::Store,index:u32)->Result<Vec<slot::Call>,Error>;}
pub struct Backend<'a,A,C,R,O>{
 pub allocation:&'a mut A,pub graph:&'a mut changed::Graph,pub inputs:&'a mut gain::Inputs,
 pub contribution:&'a mut C,pub manager:&'a crate::audio_rtpc_manager::Manager,
 pub targets:&'a mut crate::audio_bus_control_application::Store,pub refresh:&'a mut R,pub observer:&'a mut O,
 pub gain_calls:Vec<application::Call>,pub slots:Vec<slot::Call>,pub applied:Vec<crate::audio_bus_control_application::Call>,
}
impl<A:effects::Backend,C:gain::Contribution,R:Refresh,O:application::Observer>effects::Backend for Backend<'_,A,C,R,O>{
 fn allocate(&mut self,n:u32)->Result<Option<effects::Allocation>,Error>{self.observer.effect(&effects::Call::Allocate{size:n});self.allocation.allocate(n)}
 fn changed(&mut self,b:&mut Bus,c:&effects::Cache)->Result<(),Error>{
  self.observer.effect(&effects::Call::Changed);if !self.graph.buses.contains_key(&b.reference){return Err(Error::Backend("missing live gain consumer Bus"));}self.graph.buses.insert(b.reference,b.clone());self.graph.caches.insert(b.word(0x18),c.clone());
  let mut application=application::Backend{targets:self.targets,tables:&self.inputs.tables,manager:self.manager,observer:self.observer,calls:vec![]};
  let mut backend=gain::Backend{inputs:self.inputs,contribution:self.contribution,application:&mut application};let result=self.graph.changed(b.reference,&mut backend);drop(backend);self.gain_calls.extend(application.calls);*b=self.graph.buses[&b.reference].clone();result
 }
 fn slot(&mut self,b:&mut Bus,i:u32)->Result<(),Error>{self.observer.effect(&effects::Call::Slot{index:i});self.slots.extend(self.refresh.dispatch(b,self.graph,self.inputs,self.targets,i)?);Ok(())}
 fn mask(&mut self,b:&mut Bus,v:u32,m:u32)->Result<(),Error>{self.observer.effect(&effects::Call::Mask{args:[v,m]});self.inputs.sources.mask(b,v,m)}
 fn apply(&mut self,b:&Bus,v:u32,m:u32)->Result<(),Error>{let calls=if b.word(0x24)==0 && b.raw[0xc4]&0x80!=0{self.targets.root(v,m)}else{self.targets.bus(b.word(8),v,m)}.map_err(Error::Application)?;self.applied.extend(calls);Ok(())}
}

impl<A:effects::Backend,C:gain::Contribution,R:Refresh,O:application::Observer>Backend<'_,A,C,R,O>{
 /// Synchronize source, selected Bus and effect cache before and after the
 /// actual reader, including partial failure; callbacks share this same graph.
 pub fn read(&mut self,store:&mut effects::Store,b:&mut Bus,c:&mut crate::audio_bus_bank::Cursor<'_>)->Result<effects::Read,Error>{
  if !self.graph.buses.contains_key(&b.reference){return Err(Error::Backend("missing registered effects consumer Bus"));}
  self.graph.buses.insert(b.reference,b.clone());if let Some(cache)=store.caches.get(&b.word(0x18)){self.graph.caches.insert(b.word(0x18),cache.clone());}
  let result=store.read(b,c,self);self.graph.buses.insert(b.reference,b.clone());if let Some(cache)=store.caches.get(&b.word(0x18)){self.graph.caches.insert(b.word(0x18),cache.clone());}result
 }
}
#[cfg(test)]mod tests{
 use super::*;use crate::{audio_bus_bank::Cursor,audio_bus_control_application::{Store as Targets,Voice,Root},audio_rtpc_manager::{Manager,Record,RouteCurve},audio_curves::{Curve,Point}};
 use std::{rc::Rc,cell::RefCell};type Calls=Rc<RefCell<Vec<serde_json::Value>>>;
 struct Observer{calls:Calls}
 impl application::Observer for Observer{fn call(&mut self,c:&application::Call){self.calls.borrow_mut().push(serde_json::json!(c));}fn effect(&mut self,c:&effects::Call){self.calls.borrow_mut().push(serde_json::json!(c));}}
 struct State{store:gain::CachedStates,calls:Calls}
 impl gain::State for State{fn contribution(&mut self,n:u32,m:u32,g:&changed::Graph)->Result<f32,Error>{self.calls.borrow_mut().push(serde_json::json!({"kind":"state","node":n,"mask":m}));gain::State::contribution(&mut self.store,n,m,g)}}
 struct Contribution<'a>{managed:gain::Managed<'a,State>,calls:Calls}
 impl gain::Contribution for Contribution<'_>{fn state(&mut self,n:u32,m:u32,g:&changed::Graph)->Result<f32,Error>{self.managed.state(n,m,g)}fn rtpc(&mut self,n:u32,p:u32,o:u32)->Result<Vec<f32>,Error>{self.calls.borrow_mut().push(serde_json::json!({"kind":"rtpc","node":n,"parameter":p,"owner":o}));self.managed.rtpc(n,p,o)}}
 struct Refresh{calls:Calls}
 impl slot::Refresh for Refresh{fn refresh(&mut self,r:u32,_:&mut Voice,b:slot::Binding,i:u32)->Result<(),Error>{self.calls.borrow_mut().push(serde_json::json!({"kind":"refresh_slot","voice":r,"binding":match b{slot::Binding::Primary=>0x14a7aac,slot::Binding::VoiceBus(v)=>v+0x4d0},"index":i}));Ok(())}}
 impl super::Refresh for Refresh{fn dispatch(&mut self,b:&Bus,_:&changed::Graph,_:&gain::Inputs,t:&mut Targets,index:u32)->Result<Vec<slot::Call>,Error>{slot::dispatch(b,t,index,self)}}
 fn bytes(v:&serde_json::Value)->Vec<u8>{crate::audio_bus_properties_bank::tests::bytes(v.as_str().unwrap())}
 #[test]fn audio_whole_effect_reader_actual_gain_and_target_consumers_match648_native_cases(){
  let p:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_bus_effect_gain_consumers_contract.json")).unwrap();assert_eq!(p["case_count"],648);
  for(case,row)in p["cases"].as_array().unwrap().iter().enumerate(){
   let mut graph=changed::Graph::default();let mut bus=Bus{reference:0x30001000,raw:crate::audio_spatial_controls::tests::hex(row["before"][0].as_str().unwrap())};graph.buses.insert(bus.reference,bus.clone());graph.buses.insert(0x3000e000,Bus{reference:0x3000e000,raw:crate::audio_spatial_controls::tests::hex(row["before"][1].as_str().unwrap())});let mut inputs=gain::Inputs::default();for t in row["tables"].as_array().unwrap(){inputs.tables.values.insert(t["reference"].as_u64().unwrap()as u32,bytes(&t["raw"]));}inputs.sources.sources.insert(0x30009000,crate::audio_spatial_controls::tests::hex(row["before_source"].as_str().unwrap()));inputs.ranges.insert(0x3000c200,bytes(&row["range_raw"]));let mut states=gain::CachedStates::default();for s in row["states"].as_array().unwrap(){let ptr=s["table"].as_u64().unwrap()as u32;states.entries.insert(s["reference"].as_u64().unwrap()as u32,gain::StateEntry{next:s["next"].as_u64().unwrap()as u32,table:ptr});states.tables.insert(ptr,bytes(&s["raw"]));}
   let mut manager=Manager::default();manager.records.insert(100,Record::default());for r in row["routes"].as_array().unwrap(){manager.bindings.insert((r["node"].as_u64().unwrap()as u32,r["parameter"].as_u64().unwrap()as u32),vec![RouteCurve{rtpc:100,curve:Curve{scaling:0,points:vec![Point{from:0.,to:r["value"].as_f64().unwrap()as f32,interp:4}]}}]);}
   let mut store=effects::Store::default();if let Some(raw)=row["before_cache"].as_str(){store.caches.insert(0x30002000,effects::Cache{raw:crate::audio_spatial_controls::tests::hex(raw)});}
   let mut targets=Targets::default();targets.bus_ids.insert(bus.reference,bus.word(8));targets.bus_ids.insert(0x3000e000,777);for(i,r)in [0x30006000,0x30007000].into_iter().enumerate(){targets.voices.insert(r,Voice{raw:crate::audio_spatial_controls::tests::hex(row["before_targets"][i].as_str().unwrap())});targets.registered.push(r);targets.roots.push(Root{voice:r,key:[i as u32,0]});}
   let calls:Calls=Rc::default();let mut observer=Observer{calls:calls.clone()};let mut state=State{store:states,calls:calls.clone()};let mut contribution=Contribution{managed:gain::Managed{state:&mut state,manager:&manager},calls:calls.clone()};let mut refresh=Refresh{calls:calls.clone()};let mut allocation=effects::tests::Snapshot{reference:0x30003000,failure:row["allocation_failure"].as_bool().unwrap()};let mut backend=Backend{allocation:&mut allocation,graph:&mut graph,inputs:&mut inputs,contribution:&mut contribution,manager:&manager,targets:&mut targets,refresh:&mut refresh,observer:&mut observer,gain_calls:vec![],slots:vec![],applied:vec![]};let raw=bytes(&row["payload"]);let mut cursor=Cursor{bytes:&raw,offset:0,remaining:raw.len()as u32};let out=backend.read(&mut store,&mut bus,&mut cursor).unwrap();drop(backend);
   assert_eq!(serde_json::json!(*calls.borrow()),row["calls"],"complete callback order {case}");assert_eq!(u64::from(out.result),row["result"].as_u64().unwrap(),"status {case}");assert_eq!(bus.raw,crate::audio_spatial_controls::tests::hex::<200>(row["after"][0].as_str().unwrap()),"live Bus {case}");assert_eq!(graph.buses[&bus.reference].raw,bus.raw,"synchronized Bus {case}");assert_eq!(graph.buses[&0x3000e000].raw,crate::audio_spatial_controls::tests::hex::<200>(row["after"][1].as_str().unwrap()),"parent {case}");assert_eq!(inputs.sources.sources[&0x30009000],crate::audio_spatial_controls::tests::hex::<20>(row["after_source"].as_str().unwrap()),"source {case}");let expected=row["after_cache"].as_str().map(str::to_owned);assert_eq!(store.caches.get(&bus.word(0x18)).map(|c|c.raw.iter().map(|b|format!("{b:02x}")).collect::<String>()),expected,"cache {case}");if bus.word(0x18)!=0{assert_eq!(graph.caches[&bus.word(0x18)].raw,store.caches[&bus.word(0x18)].raw,"synchronized cache {case}");}for(i,r)in [0x30006000,0x30007000].into_iter().enumerate(){assert_eq!(targets.voices[&r].raw,crate::audio_spatial_controls::tests::hex::<0x500>(row["after_targets"][i].as_str().unwrap()),"full voice {case}/{i}");}assert_eq!(cursor.offset as u64,row["consumed"].as_u64().unwrap());assert_eq!(u64::from(cursor.remaining),row["remaining"].as_u64().unwrap());
  }
 }
}
