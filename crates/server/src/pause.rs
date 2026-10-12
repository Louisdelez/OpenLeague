//! Local server reconstruction: native A1/0A fields and constructor defaults,
//! with community reference freeze + delayed/immediate resume sequencing.
//! Official server permission policy is not established by these references.
use std::time::Duration;
use crate::clock_delivery::Delivery;
#[derive(Clone,Copy)]
struct Active {started:Duration,resume_at:Option<Duration>,actor:u32}
pub struct Pause {budget:Duration,active:Option<Active>}
impl Default for Pause {fn default()->Self{Self{budget:Duration::from_secs(1800),active:None}}}
fn packet(actor:u32,remaining:Option<i32>,flag:bool)->(u16,Vec<u8>){
 // Zero prefix is local adapter storage, not reconstructed native framing.
 let mut p=vec![0;if remaining.is_some(){14}else{10}];p[5..9].copy_from_slice(&actor.to_le_bytes());
 if let Some(seconds)=remaining{p[9..13].copy_from_slice(&seconds.to_le_bytes());p[13]=u8::from(flag);(0xa1,p)}else{p[9]=u8::from(flag);(0x0a,p)}
}
impl Pause {
 pub fn is_paused(&self)->bool{self.active.is_some()}
 fn remaining(&self,now:Duration)->Duration{self.active.map_or(self.budget,|a|self.budget.saturating_sub(now.saturating_sub(a.started)))}
 fn seconds(&self,now:Duration)->i32{let d=self.remaining(now);(d.as_secs()+u64::from(d.subsec_nanos()!=0)).min(i32::MAX as u64) as i32}
 pub fn request(&mut self,actor:u32,paused:bool,now:Duration,delivery:&mut Delivery)->Result<(),&'static str>{
  if paused {
   if self.is_paused(){return Err("match is already paused");}if self.budget.is_zero(){return Err("pause budget exhausted");}
   // Reserve space for pause, delayed resume and final resume before freezing.
   delivery.ensure_capacity(3)?;let (op,p)=packet(actor,Some(self.seconds(now)),true);delivery.broadcast(op,&p)?;
   self.active=Some(Active{started:now,resume_at:None,actor});
  }else{
   let active=self.active.as_mut().ok_or("match is not paused")?;
   if active.resume_at.is_some(){return Err("resume already scheduled");}
   delivery.ensure_capacity(2)?;let (op,p)=packet(actor,None,true);delivery.broadcast(op,&p)?;
   active.actor=actor;active.resume_at=Some(now+Duration::from_secs(5));
  }Ok(())
 }
 /// Returns true only when an immediate resume has been queued for everyone.
 pub fn poll(&mut self,now:Duration,delivery:&mut Delivery)->Result<bool,&'static str>{
  let Some(active)=self.active else{return Ok(false);};
  if !self.remaining(now).is_zero() && !active.resume_at.is_some_and(|t|now>=t){return Ok(false);}
  let (op,p)=packet(active.actor,None,false);delivery.broadcast(op,&p)?;
  self.budget=self.remaining(now);self.active=None;Ok(true)
 }
 pub fn bootstrap(&self,player:u32,now:Duration,delivery:&mut Delivery)->Result<(),&'static str>{
  if let Some(active)=self.active {let(op,p)=packet(active.actor,Some(self.seconds(now).max(1)),true);delivery.enqueue(player,op,&p)?;}
  // Joining during countdown stays paused until the authoritative final resume.
  Ok(())
 }
}
#[cfg(test)] mod tests{
 use super::*;
 #[test] fn countdown_freezes_until_final_resume_and_debits_wall_budget(){
  let mut p=Pause::default();let mut d=Delivery::default();d.register(1);p.request(1,true,Duration::ZERO,&mut d).unwrap();
  p.request(1,false,Duration::from_secs(2),&mut d).unwrap();assert!(p.request(1,false,Duration::from_secs(3),&mut d).is_err());
  assert!(!p.poll(Duration::from_secs(6),&mut d).unwrap());assert!(p.is_paused());assert!(p.poll(Duration::from_secs(7),&mut d).unwrap());assert!(!p.is_paused());assert_eq!(p.budget,Duration::from_secs(1793));
  let messages=d.pending(1).collect::<Vec<_>>();assert_eq!(messages.iter().map(|m|m.opcode).collect::<Vec<_>>(),vec![0xa1,0x0a,0x0a]);assert_eq!(messages[1].payload[9],1);assert_eq!(messages[2].payload[9],0);
 }
 #[test] fn joining_during_countdown_waits_for_authoritative_immediate_resume(){
  let mut p=Pause::default();let mut d=Delivery::default();d.register(1);p.request(1,true,Duration::ZERO,&mut d).unwrap();p.request(1,false,Duration::from_secs(1),&mut d).unwrap();
  d.register(2);p.bootstrap(2,Duration::from_secs(5),&mut d).unwrap();assert_eq!(d.pending(2).count(),1);p.poll(Duration::from_secs(6),&mut d).unwrap();
  let m=d.pending(2).collect::<Vec<_>>();assert_eq!(m[0].ordinal,1);assert_eq!(m[1].ordinal,2);assert_eq!(m[1].payload[9],0);
 }
 #[test] fn exhausted_budget_resumes_and_delivery_backpressure_never_half_pauses(){
  let mut p=Pause{budget:Duration::from_secs(1),active:None};let mut d=Delivery::default();d.register(1);p.request(1,true,Duration::ZERO,&mut d).unwrap();assert!(p.poll(Duration::from_secs(1),&mut d).unwrap());assert!(p.request(1,true,Duration::from_secs(2),&mut d).is_err());
  let mut p=Pause::default();for _ in 0..60{d.broadcast(0xa1,&[0]).unwrap();}assert!(p.request(1,true,Duration::ZERO,&mut d).is_err());assert!(!p.is_paused());
 }
}
