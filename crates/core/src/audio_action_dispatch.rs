//! Executes qualified audio selection when a Play action becomes due.
//! The caller owns native tick production, posting order, RNG and actual voice admission.
use crate::{audio_random::NativeRandom,audio_schedule::{Ordered,play_schedule},audio_selection::{Contract,NativeSelector,Selection,Error}};
use std::collections::{BTreeSet,BTreeMap};
#[derive(Debug)]
pub struct Execution {pub event:u32,pub action:u32,pub owner:u64,pub remainder:u32,pub selection:Option<Selection>}
struct Pending {event:u32,action:u32,owner:u64,remainder:u32}
pub struct Dispatcher {selector:NativeSelector,known:BTreeSet<(u32,u32)>,immediate_events:BTreeMap<u32,Vec<u32>>,queue:Ordered<Pending>,seek_targets:BTreeMap<u32,Vec<u32>>}
impl Dispatcher {
 pub fn new(contract:Contract)->Result<Self,Error> {
  let known=contract.events.iter().flat_map(|e|e.actions.iter().map(move |a|(e.id,a.id))).collect();
  let immediate_events=contract.events.iter().filter(|e|e.actions.iter().all(|a|!a.properties.contains_key("14")))
      .map(|e|(e.id,e.actions.iter().map(|a|a.id).collect())).collect();
  let seek_targets=contract.events.iter().map(|e|(e.id,e.actions.iter().map(|a|a.target).collect())).collect();
  Ok(Self {selector:NativeSelector::new(contract)?,known,immediate_events,queue:Ordered::default(),seek_targets})
 }
 /// Native event traversal skips owner-bound Play0403 actions on lookup failure.
 /// Caller maps the registered object ID to its stable lifetime identity.
 pub fn post_registered_event(&mut self,registry:&crate::audio_object_registration::Registry,
     object_id:u32,event:u32,owner_token:u64,tick:u32,rng:&mut NativeRandom)->Result<Vec<Execution>,Error> {
  if registry.get(object_id).is_none() {return Ok(Vec::new());}
  self.post_immediate_event(event,owner_token,tick,rng)
 }
 /// Native bank loader B1A960 preserves serialized action order.
 /// This path supports events whose actions all have absent property14 (native zero).
 /// Owner must already be registered by the caller; a token alone is not admission.
 pub fn post_immediate_event(&mut self,event:u32,owner:u64,tick:u32,rng:&mut NativeRandom)->Result<Vec<Execution>,Error> {
  let actions=self.immediate_events.get(&event).ok_or(Error::InvalidContract)?.clone();
  actions.into_iter().map(|action|self.post(event,action,owner,tick,0,rng).map(|x|x.expect("zero delay executes immediately"))).collect()
 }
 /// Delay is the evaluated native property14, never the transition/fade field.
 /// Return an execution only for the native immediate branch, even when silent.
 pub fn post(&mut self,event:u32,action:u32,owner:u64,tick:u32,delay:u32,rng:&mut NativeRandom)->Result<Option<Execution>,Error> {
  if !self.known.contains(&(event,action)) {return Err(Error::InvalidContract);}
  let timing=play_schedule(tick,delay);
  let pending=Pending {event,action,owner,remainder:timing.remainder};
  if timing.immediate {self.execute(pending,rng).map(Some)} else {self.queue.insert(timing.tick,pending);Ok(None)}
 }
 fn execute(&mut self,p:Pending,rng:&mut NativeRandom)->Result<Execution,Error> {
  let selection=self.selector.action(p.event,p.action,p.owner,rng)?;
  Ok(Execution {event:p.event,action:p.action,owner:p.owner,remainder:p.remainder,selection})
 }
 pub fn next_due(&mut self,tick:u32,rng:&mut NativeRandom)->Option<Result<Execution,Error>> {
  self.queue.pop_due(tick).map(|p|self.execute(p,rng))
 }
 /// Ambient contract contains qualified Play0403 actions in serialized order.
 /// Seeking routes to their target nodes; it never chooses another random sound.
 pub fn seek_event(&self,event:u32,packet:crate::audio_seek_dispatch::Packet,backend:&mut impl crate::audio_seek_dispatch::Backend)->Result<(),Error>{
  let targets=self.seek_targets.get(&event).ok_or(Error::UnknownEvent(event))?;
  crate::audio_seek_dispatch::dispatch(packet,targets.iter().map(|&target|crate::audio_seek_dispatch::Action{kind:0x403,target}),backend);Ok(())
 }
 pub fn pending(&self)->usize {self.queue.len()}
}
#[cfg(test)] mod tests {
 use super::*;
 use crate::audio_selection::ambient_contract;
 #[test] fn deferred_choices_follow_deadline_and_equal_deadline_posting_order() {
  let c=ambient_contract().unwrap();let e=c.events[1].id;let a=c.events[1].actions[0].id;let b=c.events[1].actions[1].id;
  let mut direct=NativeSelector::new(c.clone()).unwrap();let mut expected=NativeRandom::seeded(17);
  let mut d=Dispatcher::new(c).unwrap();let mut rng=NativeRandom::seeded(17);
  assert!(d.post(e,a,1,100,2048,&mut rng).unwrap().is_none());
  assert!(d.post(e,b,2,100,1025,&mut rng).unwrap().is_none());
  assert!(d.post(e,a,3,100,1024,&mut rng).unwrap().is_none());
  assert_eq!(rng.state(),17);assert_eq!(d.pending(),3);assert!(d.next_due(100,&mut rng).is_none());
  for (tick,action,owner,remainder) in [(101,b,2,1),(101,a,3,0),(102,a,1,0)] {
   let x=d.next_due(tick,&mut rng).unwrap().unwrap();assert_eq!((x.event,x.action,x.owner,x.remainder),(e,action,owner,remainder));
   assert_eq!(x.selection,direct.action(e,action,owner,&mut expected).unwrap());assert_eq!(rng.state(),expected.state());
  }
  assert_eq!(d.pending(),0);assert!(d.next_due(u32::MAX,&mut rng).is_none());
 }
 #[test] fn actual_ambient_actions_are_immediate_and_unknown_action_never_queues() {
  let c=ambient_contract().unwrap();let mut d=Dispatcher::new(c.clone()).unwrap();let mut rng=NativeRandom::seeded(17);
  for e in c.events {for a in e.actions {assert!(!a.properties.contains_key("14"));let x=d.post(e.id,a.id,7,19,0,&mut rng).unwrap().unwrap();assert_eq!(x.remainder,0);}}
  assert_eq!(d.pending(),0);let state=rng.state();assert!(d.post(0,0,7,19,2048,&mut rng).is_err());assert_eq!(rng.state(),state);assert_eq!(d.pending(),0);
 }
}

#[cfg(test)] mod event_tests {
 use super::*;
 #[test] fn all_actual_events_keep_bank_action_order_and_unknown_event_consumes_nothing() {
  let c=crate::audio_selection::ambient_contract().unwrap();let mut d=Dispatcher::new(c.clone()).unwrap();let mut rng=NativeRandom::seeded(17);
  for e in c.events {let expected:Vec<_>=e.actions.iter().map(|a|a.id).collect();let executions=d.post_immediate_event(e.id,73,100,&mut rng).unwrap();
   assert_eq!(executions.iter().map(|x|x.action).collect::<Vec<_>>(),expected);
   assert!(executions.iter().all(|x|x.event==e.id&&x.owner==73&&x.remainder==0));}
  let state=rng.state();assert!(d.post_immediate_event(0,73,100,&mut rng).is_err());assert_eq!(rng.state(),state);assert_eq!(d.pending(),0);
 }
 #[test] fn event_with_unevaluated_delay_is_not_silently_immediate() {
  let mut c=crate::audio_selection::ambient_contract().unwrap();let id=c.events[0].id;c.events[0].actions[1].properties.insert("14".into(),1024.);
  let mut d=Dispatcher::new(c).unwrap();let mut rng=NativeRandom::seeded(17);
  assert!(d.post_immediate_event(id,1,0,&mut rng).is_err());assert_eq!(rng.state(),17);assert_eq!(d.pending(),0);
 }
}

#[cfg(test)] mod registration_tests {
 use super::*;
 use crate::audio_object_registration::{Registry,RegisterCommand};
 #[test] fn actual_registry_admission_gates_event_selection_without_premature_random_draws() {
  let c=crate::audio_selection::ambient_contract().unwrap();let event=c.events[1].id;
  let mut dispatcher=Dispatcher::new(c.clone()).unwrap();let mut registry=Registry::default();let mut rng=NativeRandom::seeded(17);
  assert!(dispatcher.post_registered_event(&registry,123,event,77,0,&mut rng).unwrap().is_empty());assert_eq!(rng.state(),17);
  assert!(!registry.register(RegisterCommand {object_id:123,listener_mask:1,extra_raw:0},|_|None));
  assert!(dispatcher.post_registered_event(&registry,123,event,77,0,&mut rng).unwrap().is_empty());assert_eq!(rng.state(),17);
  assert!(registry.register(RegisterCommand {object_id:123,listener_mask:1,extra_raw:0},|_|Some(0)));
  let mut reference=Dispatcher::new(c).unwrap();let mut reference_rng=NativeRandom::seeded(17);
  let actual=dispatcher.post_registered_event(&registry,123,event,77,0,&mut rng).unwrap();
  let expected=reference.post_immediate_event(event,77,0,&mut reference_rng).unwrap();
  assert_eq!(actual.len(),2);assert_eq!(rng.state(),reference_rng.state());
  for (a,e) in actual.iter().zip(expected) {assert_eq!(a.selection,e.selection);assert_eq!(a.owner,77);}
  let state=rng.state();assert!(dispatcher.post_registered_event(&registry,124,event,78,0,&mut rng).unwrap().is_empty());assert_eq!(rng.state(),state);
 }
}

#[cfg(test)] mod seek_tests {
 use super::*;use crate::audio_seek_dispatch::{Backend,NodeSeek,Packet};
 #[derive(Default)] struct Probe{targets:Vec<u32>,seeks:Vec<i32>,objects:usize,events:usize}
 impl Backend for Probe{
  type Object=u32;type Node=u32;
  fn acquire_object(&mut self,id:u32)->Option<u32>{Some(id)}
  fn acquire_node(&mut self,target:u32)->Option<u32>{self.targets.push(target);Some(target)}
  fn seek_node(&mut self,_:&u32,_:Option<&u32>,r:NodeSeek){self.seeks.push(r.milliseconds);}
  fn release_node(&mut self,_:u32){}
  fn release_object(&mut self,_:u32){self.objects+=1;}
  fn release_event(&mut self){self.events+=1;}
 }
 #[test] fn every_ambient_seek_keeps_target_order_without_reselecting_or_consuming_rng(){
  let contract=crate::audio_selection::ambient_contract().unwrap();let mut dispatcher=Dispatcher::new(contract.clone()).unwrap();let mut reference=Dispatcher::new(contract.clone()).unwrap();let mut rng=NativeRandom::seeded(71);let mut other=rng.clone();
  for event in contract.events{
   let mut probe=Probe::default();dispatcher.seek_event(event.id,Packet{object_id:2,milliseconds:250,marker_raw:0},&mut probe).unwrap();
   assert_eq!(probe.targets,event.actions.iter().map(|a|a.target).collect::<Vec<_>>());assert_eq!(probe.seeks,vec![250;event.actions.len()]);assert_eq!((probe.objects,probe.events),(1,1));
   let actual=dispatcher.post_immediate_event(event.id,7,0,&mut rng).unwrap();let expected=reference.post_immediate_event(event.id,7,0,&mut other).unwrap();
   assert_eq!(actual.iter().map(|a|&a.selection).collect::<Vec<_>>(),expected.iter().map(|a|&a.selection).collect::<Vec<_>>());assert_eq!(rng.state(),other.state());
  }
  let mut probe=Probe::default();assert!(matches!(dispatcher.seek_event(0,Packet{object_id:2,milliseconds:0,marker_raw:0},&mut probe),Err(Error::UnknownEvent(0))));assert!(probe.targets.is_empty());assert_eq!(probe.events,0);
 }
}
