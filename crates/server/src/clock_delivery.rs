//! Reliable ordered delivery for the local ClockControl transport adapter.
//! Native A1/0A payload semantics live in core; this is not native wire framing.
use std::collections::{HashMap,VecDeque};
#[derive(Clone,Debug,PartialEq,Eq)]
pub struct Pending {pub ordinal:u64,pub opcode:u16,pub payload:Vec<u8>}
#[derive(Default)]
struct Peer {issued:u64,acked:u64,pending:VecDeque<Pending>}
#[derive(Default)]
pub struct Delivery {peers:HashMap<u32,Peer>}
pub struct PreparedRecipient {player:u32,peer:Peer,bootstrap:openleague_core::session_transport::ClockBootstrap}
impl PreparedRecipient {
 pub fn bootstrap(&self)->openleague_core::session_transport::ClockBootstrap{self.bootstrap}
}
impl Delivery {
 /// Reserve destination capacity and build the real pause bootstrap in isolation.
 /// On error, the current recipient and every queued directive remain untouched.
 pub fn prepare_recipient(&mut self,player:u32,pause:&crate::pause::Pause,now:std::time::Duration)->Result<PreparedRecipient,&'static str>{
  if player==0{return Err("invalid clock recipient");}
  if !self.peers.contains_key(&player){self.peers.try_reserve(1).map_err(|_|"clock recipient allocation failed")?;}
  let mut temporary=Delivery::default();temporary.register(player);pause.bootstrap(player,now,&mut temporary)?;
  let peer=temporary.peers.remove(&player).ok_or("clock bootstrap recipient missing")?;
  let bootstrap=if pause.is_paused(){
   if peer.issued!=1 || peer.pending.len()!=1 || peer.pending[0].opcode!=0xa1{return Err("invalid paused clock bootstrap");}
   openleague_core::session_transport::ClockBootstrap::Paused{through_ordinal:peer.issued}
  }else{
   if peer.issued!=0 || !peer.pending.is_empty(){return Err("unexpected running clock bootstrap");}
   openleague_core::session_transport::ClockBootstrap::Running
  };
  Ok(PreparedRecipient{player,peer,bootstrap})
 }
 /// Call synchronously after registry commit; preparation reserved the only
 /// needed HashMap slot. No delivery mutation may intervene between the two.
 pub fn install_recipient(&mut self,prepared:PreparedRecipient){self.peers.insert(prepared.player,prepared.peer);}
 pub fn issued(&self,player:u32)->Option<u64>{self.peers.get(&player).map(|peer|peer.issued)}
 pub fn register(&mut self,player:u32){self.peers.entry(player).or_default();}
 pub fn ensure_capacity(&self,additional:usize)->Result<(),&'static str>{
  if self.peers.values().any(|p|p.pending.len().saturating_add(additional)>64 || p.issued.checked_add(additional as u64).is_none()){return Err("clock delivery window full");}Ok(())
 }
 pub fn enqueue(&mut self,player:u32,opcode:u16,payload:&[u8])->Result<(),&'static str>{
  let peer=self.peers.get_mut(&player).ok_or("unknown clock recipient")?;
  if peer.pending.len()>=64 || peer.issued==u64::MAX{return Err("clock delivery window full");}
  peer.issued+=1;peer.pending.push_back(Pending{ordinal:peer.issued,opcode,payload:payload.to_vec()});Ok(())
 }
 pub fn remove(&mut self,player:u32){self.peers.remove(&player);}
 /// Preflight every recipient: never publish a partially accepted transition.
 pub fn broadcast(&mut self,opcode:u16,payload:&[u8])->Result<(),&'static str>{
  if self.peers.values().any(|p|p.pending.len()>=64 || p.issued==u64::MAX){return Err("clock delivery window full");}
  for peer in self.peers.values_mut(){peer.issued+=1;peer.pending.push_back(Pending{ordinal:peer.issued,opcode,payload:payload.to_vec()});}Ok(())
 }
 pub fn acknowledge(&mut self,player:u32,ordinal:u64)->Result<(),&'static str>{
  let peer=self.peers.get_mut(&player).ok_or("unknown clock recipient")?;
  if ordinal>peer.issued{return Err("clock acknowledgment exceeds issued sequence");}
  if ordinal<=peer.acked{return Ok(());}
  peer.acked=ordinal;while peer.pending.front().is_some_and(|p|p.ordinal<=ordinal){peer.pending.pop_front();}Ok(())
 }
 /// Repeated calls return identical unacknowledged payloads, in original order.
 pub fn pending(&self,player:u32)->impl Iterator<Item=&Pending>{self.peers.get(&player).into_iter().flat_map(|p|p.pending.iter())}
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test] fn prepared_running_recipient_does_not_replace_queue_before_commit(){
  let mut d=Delivery::default();d.register(7);d.enqueue(7,0x0a,&[9]).unwrap();
  let before=d.pending(7).cloned().collect::<Vec<_>>();
  let prepared=d.prepare_recipient(7,&crate::pause::Pause::default(),std::time::Duration::ZERO).unwrap();
  assert_eq!(prepared.bootstrap(),openleague_core::session_transport::ClockBootstrap::Running);
  assert_eq!(d.pending(7).cloned().collect::<Vec<_>>(),before);assert_eq!(d.issued(7),Some(1));
  drop(prepared);assert_eq!(d.pending(7).cloned().collect::<Vec<_>>(),before);
  let prepared=d.prepare_recipient(7,&crate::pause::Pause::default(),std::time::Duration::ZERO).unwrap();
  d.install_recipient(prepared);assert_eq!(d.issued(7),Some(0));assert_eq!(d.pending(7).count(),0);
 }
 #[test] fn prepared_paused_recipient_uses_actual_pause_bootstrap_and_receives_final_resume(){
  use std::time::Duration;
  let mut d=Delivery::default();d.register(1);let mut pause=crate::pause::Pause::default();
  pause.request(1,true,Duration::ZERO,&mut d).unwrap();
  pause.request(1,false,Duration::from_secs(2),&mut d).unwrap();
  let old=d.pending(1).cloned().collect::<Vec<_>>();
  let prepared=d.prepare_recipient(7,&pause,Duration::from_secs(5)).unwrap();
  assert_eq!(prepared.bootstrap(),openleague_core::session_transport::ClockBootstrap::Paused{through_ordinal:1});
  assert_eq!(d.issued(7),None);assert_eq!(d.pending(1).cloned().collect::<Vec<_>>(),old);
  let mut reference=Delivery::default();reference.register(7);pause.bootstrap(7,Duration::from_secs(5),&mut reference).unwrap();
  d.install_recipient(prepared);assert_eq!(d.pending(7).cloned().collect::<Vec<_>>(),reference.pending(7).cloned().collect::<Vec<_>>());
  assert!(!pause.poll(Duration::from_secs(6),&mut d).unwrap());
  assert!(pause.poll(Duration::from_secs(7),&mut d).unwrap());
  let events=d.pending(7).collect::<Vec<_>>();assert_eq!(events.len(),2);
  assert_eq!(events[0].ordinal,1);assert_eq!(events[0].opcode,0xa1);
  assert_eq!(events[1].ordinal,2);assert_eq!(events[1].opcode,0x0a);assert_eq!(events[1].payload[9],0);
 }
 #[test] fn invalid_preparation_leaves_every_existing_recipient_unchanged(){
  let mut d=Delivery::default();d.register(1);d.register(2);d.broadcast(0xa1,&[4]).unwrap();
  let before1=d.pending(1).cloned().collect::<Vec<_>>();let before2=d.pending(2).cloned().collect::<Vec<_>>();
  assert!(d.prepare_recipient(0,&crate::pause::Pause::default(),std::time::Duration::ZERO).is_err());
  assert_eq!(d.pending(1).cloned().collect::<Vec<_>>(),before1);assert_eq!(d.pending(2).cloned().collect::<Vec<_>>(),before2);
 }
 #[test] fn lost_packets_and_acknowledgments_keep_original_order(){
  let mut d=Delivery::default();d.register(1);d.broadcast(0xa1,&[1,2]).unwrap();d.broadcast(0x0a,&[3]).unwrap();
  let first=d.pending(1).cloned().collect::<Vec<_>>();assert_eq!(first,d.pending(1).cloned().collect::<Vec<_>>());
  assert!(d.acknowledge(1,3).is_err());assert_eq!(d.pending(1).count(),2);
  d.acknowledge(1,1).unwrap();d.acknowledge(1,1).unwrap();assert_eq!(d.pending(1).next().unwrap(),&first[1]);
  d.acknowledge(1,2).unwrap();assert_eq!(d.pending(1).count(),0);
 }
 #[test] fn full_recipient_window_rejects_broadcast_atomically(){
  let mut d=Delivery::default();d.register(1);d.register(2);for _ in 0..64{d.broadcast(0xa1,&[0]).unwrap();}
  d.acknowledge(1,64).unwrap();assert!(d.broadcast(0x0a,&[1]).is_err());assert_eq!(d.pending(1).count(),0);assert_eq!(d.pending(2).count(),64);
  d.acknowledge(2,64).unwrap();d.broadcast(0x0a,&[1]).unwrap();assert_eq!(d.pending(1).next().unwrap().ordinal,65);
 }
 #[test] fn heartbeat_registration_preserves_queue_new_identity_starts_at_one(){
  let mut d=Delivery::default();d.register(1);d.broadcast(0xa1,&[0]).unwrap();d.register(1);assert_eq!(d.pending(1).count(),1);
  d.remove(1);assert!(d.acknowledge(1,1).is_err());d.register(2);d.broadcast(0x0a,&[1]).unwrap();assert_eq!(d.pending(2).next().unwrap().ordinal,1);
 }
}
