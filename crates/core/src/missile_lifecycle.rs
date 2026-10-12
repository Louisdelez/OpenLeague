//! Preserve observed missile transitions independently of the latest display snapshot.
//! Disappearance is an observation, not proof of impact, death or expiry.
use crate::annie::Missile;
use std::collections::BTreeMap;
pub type Identity=(u32,u32,u64);
pub fn identity(m:&Missile)->Identity {(m.source,m.target,m.cooldown_ready)}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Kind { Appeared, Observed, Disappeared }
#[derive(Debug,Clone)]
pub struct Event {pub session:u64,pub tick:u64,pub kind:Kind,pub missile:Missile}
#[derive(Default,Clone)]
pub struct Journal {session:Option<u64>,last_tick:Option<u64>,epoch:Option<u64>,last_frame:Option<u64>,active:BTreeMap<Identity,Missile>,pending:Vec<Event>}
impl Journal {
 /// Caller must establish the session from its welcome handshake.
 pub fn reset(&mut self,session:u64) {self.session=Some(session);self.last_tick=None;self.epoch=None;self.last_frame=None;self.active.clear();self.pending.clear();}
 /// Accepted Welcome only. Preserve missile identity/observations on recovery.
 pub fn begin_epoch(&mut self,session:u64,epoch:u64)->Result<bool,&'static str> {
  if self.session!=Some(session) {return Err("missile snapshot session mismatch");}
  if epoch==0 {return Err("invalid missile frame epoch");}
  if self.epoch.is_some_and(|old|epoch<=old) {return Ok(false);}
  self.epoch=Some(epoch);self.last_frame=None;Ok(true)
 }
 pub fn accept(&mut self,session:u64,tick:u64,missiles:&[Missile])->Result<bool,&'static str> {
  self.accept_ordered(session,None,tick,missiles)
 }
 /// Transport already authenticated the current context and fresh frame.
 pub fn accept_frame(&mut self,session:u64,frame:u64,tick:u64,missiles:&[Missile])->Result<bool,&'static str> {
  self.accept_ordered(session,Some(frame),tick,missiles)
 }
 fn accept_ordered(&mut self,session:u64,frame:Option<u64>,tick:u64,missiles:&[Missile])->Result<bool,&'static str> {
  if self.session!=Some(session) {return Err("missile snapshot session mismatch");}
  if let Some(frame)=frame {
   if frame==0 {return Err("invalid missile frame ordinal");}
   if self.epoch.is_none() {return Err("missile frame epoch missing");}
   if self.last_frame.is_some_and(|old|frame<=old) {return Ok(false);}
  }
  if self.last_tick.is_some_and(|previous|tick<previous || (frame.is_none() && tick==previous)) {return Ok(false);}
  let mut next=BTreeMap::new();
  for missile in missiles {
   if next.insert(identity(missile),missile.clone()).is_some(){return Err("duplicate missile identity");}
  }
  for (key,missile) in &next {
   self.pending.push(Event{session,tick,kind:if self.active.contains_key(key){Kind::Observed}else{Kind::Appeared},missile:missile.clone()});
  }
  for (key,missile) in &self.active {
   if !next.contains_key(key){self.pending.push(Event{session,tick,kind:Kind::Disappeared,missile:missile.clone()});}
  }
  self.active=next;self.last_tick=Some(tick);if let Some(frame)=frame {self.last_frame=Some(frame);}Ok(true)
 }
 /// Drain once per consumer update. All observed ticks survive coalesced delivery.
 pub fn drain(&mut self)->Vec<Event> {std::mem::take(&mut self.pending)}
}
#[cfg(test)]
mod tests {
 use super::*;
 fn missile()->Missile {Missile{source:1,target:2,position:crate::Point{x:10.,z:20.},raw:80.,cost:60.,refund_ticks:60,cooldown_ready:100}}
 #[test]
 fn complete_lifecycle_survives_one_receive_batch_and_drains_once() {
  let mut j=Journal::default();j.reset(7);let mut m=missile();
  j.accept(7,10,&[m.clone()]).unwrap();m.position.x=30.;j.accept(7,13,&[m]).unwrap();j.accept(7,16,&[]).unwrap();
  let events=j.drain();assert_eq!(events.iter().map(|e|(e.tick,e.kind)).collect::<Vec<_>>(),vec![(10,Kind::Appeared),(13,Kind::Observed),(16,Kind::Disappeared)]);
  assert_eq!(events[2].missile.position.x,30.);assert!(j.drain().is_empty());
 }
 #[test]
 fn stale_packets_duplicates_and_session_changes_do_not_replay_old_effects() {
  let mut j=Journal::default();j.reset(7);j.accept(7,10,&[missile()]).unwrap();j.drain();
  assert!(!j.accept(7,9,&[]).unwrap());assert!(!j.accept(7,10,&[]).unwrap());
  assert!(j.accept(8,11,&[]).is_err());assert!(j.accept(7,11,&[missile(),missile()]).is_err());assert!(j.drain().is_empty());
  j.accept(7,11,&[]).unwrap();assert_eq!(j.drain()[0].kind,Kind::Disappeared);
  j.reset(8);j.accept(8,1,&[]).unwrap();assert!(j.drain().is_empty());
 }
 #[test]
 fn real_batched_v53_wire_retains_the_lost_projectile() {
  let fixture:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/missile_lifecycle_v53_replay.json")).unwrap();
  let mut j=Journal::default();j.reset(1);
  for s in fixture["states"].as_array().unwrap() {
   let missiles:Vec<Missile>=serde_json::from_value(s["spell_projectiles"].clone()).unwrap();j.accept(1,s["tick"].as_u64().unwrap(),&missiles).unwrap();
  }
  let events=j.drain();assert_eq!(events.iter().filter(|e|e.kind==Kind::Appeared).count(),1);assert_eq!(events.iter().filter(|e|e.kind==Kind::Disappeared).count(),1);
  assert_eq!(events.iter().filter(|e|e.kind!=Kind::Disappeared).map(|e|e.tick).collect::<Vec<_>>(),vec![826,830,833]);
 }

 #[test]
 fn fresh_same_tick_frames_observe_then_remove_missile_without_second_appearance() {
  let mut journal=Journal::default();journal.reset(7);journal.begin_epoch(7,1).unwrap();
  journal.accept_frame(7,1,10,&[missile()]).unwrap();
  journal.accept_frame(7,2,10,&[missile()]).unwrap();
  journal.accept_frame(7,3,10,&[]).unwrap();
  let events=journal.drain();
  assert_eq!(events.iter().map(|e|(e.tick,e.kind)).collect::<Vec<_>>(),
   vec![(10,Kind::Appeared),(10,Kind::Observed),(10,Kind::Disappeared)]);
  assert!(!journal.accept_frame(7,3,11,&[missile()]).unwrap());
  assert!(!journal.accept_frame(7,4,9,&[missile()]).unwrap());
  journal.accept_frame(7,4,10,&[]).unwrap();assert!(journal.drain().is_empty());
 }
 #[test]
 fn new_epoch_retains_active_missile_and_does_not_reopen_duplicate_epoch() {
  let mut journal=Journal::default();journal.reset(7);journal.begin_epoch(7,1).unwrap();
  journal.accept_frame(7,42,10,&[missile()]).unwrap();journal.drain();
  assert!(journal.begin_epoch(7,2).unwrap());
  journal.accept_frame(7,1,10,&[missile()]).unwrap();
  assert_eq!(journal.drain()[0].kind,Kind::Observed);
  assert!(!journal.begin_epoch(7,2).unwrap());assert!(!journal.begin_epoch(7,1).unwrap());
  assert!(!journal.accept_frame(7,1,10,&[]).unwrap());assert_eq!(journal.active.len(),1);
  assert!(journal.begin_epoch(8,3).is_err());journal.reset(8);journal.begin_epoch(8,1).unwrap();
  journal.accept_frame(8,1,1,&[]).unwrap();assert!(journal.drain().is_empty());
 }
 #[test]
 fn invalid_frame_missiles_do_not_consume_order_or_emit_partial_observations() {
  let mut journal=Journal::default();journal.reset(7);
  assert!(journal.accept_frame(7,1,10,&[missile()]).is_err());assert!(journal.begin_epoch(7,0).is_err());
  journal.begin_epoch(7,1).unwrap();
  assert!(journal.accept_frame(7,0,10,&[missile()]).is_err());
  assert!(journal.accept_frame(7,1,10,&[missile(),missile()]).is_err());
  assert!(journal.active.is_empty());assert!(journal.pending.is_empty());assert_eq!(journal.last_frame,None);
  assert!(journal.accept_frame(7,1,10,&[missile()]).unwrap());assert_eq!(journal.drain().len(),1);
 }
}
