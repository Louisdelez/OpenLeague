//! Play0403 scheduling arithmetic and stable native deadline ordering.
//! Delay input is native property14, not milliseconds or transition15.
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct PlaySchedule { pub tick:u32, pub remainder:u32, pub immediate:bool }
pub fn play_schedule(tick:u32,delay:u32)->PlaySchedule {
 let blocks=delay>>10;
 PlaySchedule {tick:tick.wrapping_add(blocks),remainder:delay&1023,immediate:blocks==0}
}
/// Scheduling storage only; does not admit voices or own native reference lifetimes.
pub struct Ordered<T> { entries:Vec<(u32,T)> }
impl<T> Default for Ordered<T> {fn default()->Self {Self {entries:Vec::new()}}}
impl<T> Ordered<T> {
 pub fn insert(&mut self,tick:u32,value:T) {
  let index=self.entries.partition_point(|(key,_)|*key<=tick);
  self.entries.insert(index,(tick,value));
 }
 /// Native B07E50 compares unsigned ticks without modular wrap compensation.
 pub fn pop_due(&mut self,now:u32)->Option<T> {
  if self.entries.first().is_some_and(|(tick,_)|*tick<=now) {Some(self.entries.remove(0).1)} else {None}
 }
 pub fn len(&self)->usize {self.entries.len()}
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn matches_native_play_delay_cases() {
 assert_eq!(play_schedule(0,0),PlaySchedule {tick:0,remainder:0,immediate:true});
 assert_eq!(play_schedule(100,0),PlaySchedule {tick:100,remainder:0,immediate:true});
 assert_eq!(play_schedule(4294967295,0),PlaySchedule {tick:4294967295,remainder:0,immediate:true});
 assert_eq!(play_schedule(0,0),PlaySchedule {tick:0,remainder:0,immediate:true});
 assert_eq!(play_schedule(100,0),PlaySchedule {tick:100,remainder:0,immediate:true});
 assert_eq!(play_schedule(4294967295,0),PlaySchedule {tick:4294967295,remainder:0,immediate:true});
 assert_eq!(play_schedule(0,0),PlaySchedule {tick:0,remainder:0,immediate:true});
 assert_eq!(play_schedule(100,0),PlaySchedule {tick:100,remainder:0,immediate:true});
 assert_eq!(play_schedule(4294967295,0),PlaySchedule {tick:4294967295,remainder:0,immediate:true});
 assert_eq!(play_schedule(0,1),PlaySchedule {tick:0,remainder:1,immediate:true});
 assert_eq!(play_schedule(100,1),PlaySchedule {tick:100,remainder:1,immediate:true});
 assert_eq!(play_schedule(4294967295,1),PlaySchedule {tick:4294967295,remainder:1,immediate:true});
 assert_eq!(play_schedule(0,1),PlaySchedule {tick:0,remainder:1,immediate:true});
 assert_eq!(play_schedule(100,1),PlaySchedule {tick:100,remainder:1,immediate:true});
 assert_eq!(play_schedule(4294967295,1),PlaySchedule {tick:4294967295,remainder:1,immediate:true});
 assert_eq!(play_schedule(0,1),PlaySchedule {tick:0,remainder:1,immediate:true});
 assert_eq!(play_schedule(100,1),PlaySchedule {tick:100,remainder:1,immediate:true});
 assert_eq!(play_schedule(4294967295,1),PlaySchedule {tick:4294967295,remainder:1,immediate:true});
 assert_eq!(play_schedule(0,1023),PlaySchedule {tick:0,remainder:1023,immediate:true});
 assert_eq!(play_schedule(100,1023),PlaySchedule {tick:100,remainder:1023,immediate:true});
 assert_eq!(play_schedule(4294967295,1023),PlaySchedule {tick:4294967295,remainder:1023,immediate:true});
 assert_eq!(play_schedule(0,1023),PlaySchedule {tick:0,remainder:1023,immediate:true});
 assert_eq!(play_schedule(100,1023),PlaySchedule {tick:100,remainder:1023,immediate:true});
 assert_eq!(play_schedule(4294967295,1023),PlaySchedule {tick:4294967295,remainder:1023,immediate:true});
 assert_eq!(play_schedule(0,1023),PlaySchedule {tick:0,remainder:1023,immediate:true});
 assert_eq!(play_schedule(100,1023),PlaySchedule {tick:100,remainder:1023,immediate:true});
 assert_eq!(play_schedule(4294967295,1023),PlaySchedule {tick:4294967295,remainder:1023,immediate:true});
 assert_eq!(play_schedule(0,1024),PlaySchedule {tick:1,remainder:0,immediate:false});
 assert_eq!(play_schedule(100,1024),PlaySchedule {tick:101,remainder:0,immediate:false});
 assert_eq!(play_schedule(4294967295,1024),PlaySchedule {tick:0,remainder:0,immediate:false});
 assert_eq!(play_schedule(0,1024),PlaySchedule {tick:1,remainder:0,immediate:false});
 assert_eq!(play_schedule(100,1024),PlaySchedule {tick:101,remainder:0,immediate:false});
 assert_eq!(play_schedule(4294967295,1024),PlaySchedule {tick:0,remainder:0,immediate:false});
 assert_eq!(play_schedule(0,1024),PlaySchedule {tick:1,remainder:0,immediate:false});
 assert_eq!(play_schedule(100,1024),PlaySchedule {tick:101,remainder:0,immediate:false});
 assert_eq!(play_schedule(4294967295,1024),PlaySchedule {tick:0,remainder:0,immediate:false});
 assert_eq!(play_schedule(0,1025),PlaySchedule {tick:1,remainder:1,immediate:false});
 assert_eq!(play_schedule(100,1025),PlaySchedule {tick:101,remainder:1,immediate:false});
 assert_eq!(play_schedule(4294967295,1025),PlaySchedule {tick:0,remainder:1,immediate:false});
 assert_eq!(play_schedule(0,1025),PlaySchedule {tick:1,remainder:1,immediate:false});
 assert_eq!(play_schedule(100,1025),PlaySchedule {tick:101,remainder:1,immediate:false});
 assert_eq!(play_schedule(4294967295,1025),PlaySchedule {tick:0,remainder:1,immediate:false});
 assert_eq!(play_schedule(0,1025),PlaySchedule {tick:1,remainder:1,immediate:false});
 assert_eq!(play_schedule(100,1025),PlaySchedule {tick:101,remainder:1,immediate:false});
 assert_eq!(play_schedule(4294967295,1025),PlaySchedule {tick:0,remainder:1,immediate:false});
 assert_eq!(play_schedule(0,2048),PlaySchedule {tick:2,remainder:0,immediate:false});
 assert_eq!(play_schedule(100,2048),PlaySchedule {tick:102,remainder:0,immediate:false});
 assert_eq!(play_schedule(4294967295,2048),PlaySchedule {tick:1,remainder:0,immediate:false});
 assert_eq!(play_schedule(0,2048),PlaySchedule {tick:2,remainder:0,immediate:false});
 assert_eq!(play_schedule(100,2048),PlaySchedule {tick:102,remainder:0,immediate:false});
 assert_eq!(play_schedule(4294967295,2048),PlaySchedule {tick:1,remainder:0,immediate:false});
 assert_eq!(play_schedule(0,2048),PlaySchedule {tick:2,remainder:0,immediate:false});
 assert_eq!(play_schedule(100,2048),PlaySchedule {tick:102,remainder:0,immediate:false});
 assert_eq!(play_schedule(4294967295,2048),PlaySchedule {tick:1,remainder:0,immediate:false});
 assert_eq!(play_schedule(0,48000),PlaySchedule {tick:46,remainder:896,immediate:false});
 assert_eq!(play_schedule(100,48000),PlaySchedule {tick:146,remainder:896,immediate:false});
 assert_eq!(play_schedule(4294967295,48000),PlaySchedule {tick:45,remainder:896,immediate:false});
 assert_eq!(play_schedule(0,48000),PlaySchedule {tick:46,remainder:896,immediate:false});
 assert_eq!(play_schedule(100,48000),PlaySchedule {tick:146,remainder:896,immediate:false});
 assert_eq!(play_schedule(4294967295,48000),PlaySchedule {tick:45,remainder:896,immediate:false});
 assert_eq!(play_schedule(0,48000),PlaySchedule {tick:46,remainder:896,immediate:false});
 assert_eq!(play_schedule(100,48000),PlaySchedule {tick:146,remainder:896,immediate:false});
 assert_eq!(play_schedule(4294967295,48000),PlaySchedule {tick:45,remainder:896,immediate:false});
 }
 #[test] fn native_stable_unsigned_order_and_deadline() {
 let mut queue=Ordered::default();
 queue.insert(5,0);
 queue.insert(1,1);
 queue.insert(5,2);
 queue.insert(3,3);
 queue.insert(1,4);
 assert_eq!(queue.len(),5);
 assert_eq!(queue.pop_due(0),None);
 assert_eq!(queue.pop_due(1),Some(1));
 assert_eq!(queue.pop_due(0),None);
 assert_eq!(queue.pop_due(1),Some(4));
 assert_eq!(queue.pop_due(2),None);
 assert_eq!(queue.pop_due(3),Some(3));
 assert_eq!(queue.pop_due(4),None);
 assert_eq!(queue.pop_due(5),Some(0));
 assert_eq!(queue.pop_due(4),None);
 assert_eq!(queue.pop_due(5),Some(2));
 assert_eq!(queue.len(),0);assert_eq!(queue.pop_due(u32::MAX),None);
 let mut queue=Ordered::default();
 queue.insert(4294967295,0);
 queue.insert(0,1);
 queue.insert(1,2);
 queue.insert(4294967294,3);
 assert_eq!(queue.len(),4);
 assert_eq!(queue.pop_due(0),Some(1));
 assert_eq!(queue.pop_due(0),None);
 assert_eq!(queue.pop_due(1),Some(2));
 assert_eq!(queue.pop_due(4294967293),None);
 assert_eq!(queue.pop_due(4294967294),Some(3));
 assert_eq!(queue.pop_due(4294967294),None);
 assert_eq!(queue.pop_due(4294967295),Some(0));
 assert_eq!(queue.len(),0);assert_eq!(queue.pop_due(u32::MAX),None);
 let mut queue=Ordered::default();
 queue.insert(7,0);
 queue.insert(7,1);
 queue.insert(7,2);
 queue.insert(7,3);
 assert_eq!(queue.len(),4);
 assert_eq!(queue.pop_due(6),None);
 assert_eq!(queue.pop_due(7),Some(0));
 assert_eq!(queue.pop_due(6),None);
 assert_eq!(queue.pop_due(7),Some(1));
 assert_eq!(queue.pop_due(6),None);
 assert_eq!(queue.pop_due(7),Some(2));
 assert_eq!(queue.pop_due(6),None);
 assert_eq!(queue.pop_due(7),Some(3));
 assert_eq!(queue.len(),0);assert_eq!(queue.pop_due(u32::MAX),None);
 let mut queue=Ordered::default();
 queue.insert(9,0);
 queue.insert(8,1);
 queue.insert(7,2);
 queue.insert(6,3);
 queue.insert(5,4);
 assert_eq!(queue.len(),5);
 assert_eq!(queue.pop_due(4),None);
 assert_eq!(queue.pop_due(5),Some(4));
 assert_eq!(queue.pop_due(5),None);
 assert_eq!(queue.pop_due(6),Some(3));
 assert_eq!(queue.pop_due(6),None);
 assert_eq!(queue.pop_due(7),Some(2));
 assert_eq!(queue.pop_due(7),None);
 assert_eq!(queue.pop_due(8),Some(1));
 assert_eq!(queue.pop_due(8),None);
 assert_eq!(queue.pop_due(9),Some(0));
 assert_eq!(queue.len(),0);assert_eq!(queue.pop_due(u32::MAX),None);
 let mut queue=Ordered::default();
 queue.insert(0,0);
 queue.insert(1,1);
 queue.insert(2,2);
 queue.insert(3,3);
 assert_eq!(queue.len(),4);
 assert_eq!(queue.pop_due(0),Some(0));
 assert_eq!(queue.pop_due(0),None);
 assert_eq!(queue.pop_due(1),Some(1));
 assert_eq!(queue.pop_due(1),None);
 assert_eq!(queue.pop_due(2),Some(2));
 assert_eq!(queue.pop_due(2),None);
 assert_eq!(queue.pop_due(3),Some(3));
 assert_eq!(queue.len(),0);assert_eq!(queue.pop_due(u32::MAX),None);
 }
}
