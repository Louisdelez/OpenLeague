use super::*;
use crate::audio_announcer_registry_init::OwnedMemory;
use crate::audio_announcer_owner_control::Counts;
use std::collections::BTreeMap;
use serde_json::{Value,json};
fn n(v:&Value)->u32{v.as_u64().unwrap() as u32}
const SOURCE:u32=0x3000a010;
const DEST:u32=0x3000a000;
struct Backend{memory:OwnedMemory,counts:BTreeMap<u32,Counts>,events:Vec<Value>,mutate:bool,observing_move:Option<u8>,fail_allocation:bool}
impl Memory for Backend{fn word(&mut self,a:u32)->Result<u32,lookup::Error>{self.memory.word(a)}}
impl Storage for Backend{
 fn allocate(&mut self,n:u32)->Result<u32,init::Error>{if self.fail_allocation{assert_eq!(n,16);self.memory.allocations.push((n,0));Ok(0)}else{self.memory.allocate(n)}}
 fn write_word(&mut self,a:u32,v:u32)->Result<(),init::Error>{self.memory.write_word(a,v)}
 fn write_byte(&mut self,a:u32,v:u8)->Result<(),init::Error>{self.memory.write_byte(a,v)}
 fn register_shutdown(&mut self,c:u32)->Result<(),init::Error>{self.memory.register_shutdown(c)}
}
impl Backend{
 fn counter(&mut self,a:u32,increase:bool)->Result<u32,&'static str>{
  let (base,offset)=self.counts.keys().find_map(|&p|if a==p+4{Some((p,4))}else if a==p+8{Some((p,8))}else{None}).ok_or("unknown reference")?;
  let count=&self.counts[&base];let old=if increase{count.increment(offset)?}else{count.decrement(offset)?};
  self.memory.write_word(a,count.read(offset)?).map_err(|_|"missing count storage")?;Ok(old)
 }
 fn event(&mut self,p:u32,op:&str){let strong=self.word(p+4).unwrap();let weak=self.word(p+8).unwrap();let mut event=json!({"op":op,"control":p,"strong":strong,"weak":weak});
  if self.observing_move.is_some(){event["destination"]=json!([self.word(DEST).unwrap(),self.word(DEST+4).unwrap()]);event["source"]=json!([self.word(SOURCE).unwrap(),self.word(SOURCE+4).unwrap()]);}
  self.events.push(event);}
}
impl ControlBoundary for Backend{
 fn decrement_reference(&mut self,a:u32)->Result<u32,&'static str>{self.counter(a,false)}
 fn dispose(&mut self,p:u32,callback:u32)->Result<(),&'static str>{assert_eq!(callback,0x32008000);self.event(p,"dispose");if let Some(profile)=self.observing_move{
   if profile&1!=0{self.write_word(SOURCE,0xfefefefe).unwrap();self.write_word(SOURCE+4,0).unwrap();}
   if profile&2!=0{self.write_word(DEST,0xedededed).unwrap();self.write_word(DEST+4,0).unwrap();}
  }if self.mutate{self.write_word(SOURCE,0xfefefefe).unwrap();self.write_word(SOURCE+4,0).unwrap();}Ok(())}
 fn release_control(&mut self,p:u32,callback:u32)->Result<(),&'static str>{assert_eq!(callback,0x32008100);self.event(p,"release");Ok(())}
}
impl Boundary for Backend{fn increment_reference(&mut self,a:u32)->Result<u32,&'static str>{self.counter(a,true)}}
fn backend(strong:u32,weak:u32,mutate:bool)->Backend{
 let mut b=Backend{memory:OwnedMemory::new(0x34000000,165),counts:BTreeMap::new(),events:vec![],mutate,observing_move:None,fail_allocation:false};b.memory.reserve_at(DEST,0x2000).unwrap();
 for p in [0x3000a100,0x3000a200]{b.counts.insert(p,Counts::new(strong,weak));b.write_word(p,0x3000a300).unwrap();b.write_word(p+4,strong).unwrap();b.write_word(p+8,weak).unwrap();}
 b.write_word(0x3000a300,0x32008000).unwrap();b.write_word(0x3000a304,0x32008100).unwrap();b
}
fn compare(b:&mut Backend,words:&Value){for w in words.as_array().unwrap(){assert_eq!(b.word(n(&w[0])).unwrap(),n(&w[1]),"{w}");}}
fn proof()->Value{serde_json::from_str(&crate::audio_test_fixture("data/4.20/replay_shared_pair_contract.json")).unwrap()}
#[test]fn audio_replay_shared_pair_matches288_native_copy_and_release_lifetimes(){
 let p=proof();let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),288);
 for c in cases{
  let mut b=backend(n(&c["strong"]),n(&c["weak"]),c["mutate"].as_bool().unwrap());
  for w in c["before"].as_array().unwrap(){b.write_word(n(&w[0]),n(&w[1])).unwrap();}
  copy(&mut b,DEST,n(&c["source"])).unwrap();compare(&mut b,&c["copied"]);assert_eq!(json!(b.events),c["copy_events"]);
  b.events.clear();destroy(&mut b,DEST).unwrap();compare(&mut b,&c["destroyed"]);assert_eq!(json!(b.events),c["destroy_events"]);
 }
}
#[test]fn audio_replay_manager_acquisition_matches72_native_accessor_cases(){
 let p=proof();let cases=p["accessors"].as_array().unwrap();assert_eq!(cases.len(),72);
 for c in cases{
  let mut b=backend(n(&c["strong"]),n(&c["weak"]),false);let manager=n(&p["manager"]);let nested=n(&p["nested"]);
  b.write_word(manager+0x30,if c["present"].as_bool().unwrap(){nested}else{0}).unwrap();b.write_word(nested+0x6c,n(&c["object"])).unwrap();b.write_word(nested+0x70,n(&c["control"])).unwrap();
  b.write_word(DEST,0xaaaaaaaa).unwrap();b.write_word(DEST+4,0xbbbbbbbb).unwrap();
  assert_eq!(from_manager(&mut b,manager,DEST).unwrap(),n(&c["result"]));assert_eq!(json!([b.word(DEST).unwrap(),b.word(DEST+4).unwrap()]),c["pair"]);
  assert_eq!(json!([b.word(0x3000a104).unwrap(),b.word(0x3000a108).unwrap()]),c["counts"]);assert_eq!(json!(b.events),c["events"]);
 }
}
#[test]fn audio_replay_shared_counters_keep_balanced_parallel_acquisitions(){
 use std::sync::Arc;
 let counts=Arc::new(Counts::new(1,1));
 std::thread::scope(|scope|{for _ in 0..8{let c=counts.clone();scope.spawn(move||{for _ in 0..10000{assert!(c.increment(4).unwrap()>=1);assert!(c.decrement(4).unwrap()>=2);}});}});
 assert_eq!(counts.read(4),Ok(1));assert_eq!(counts.decrement(4),Ok(1));assert_eq!(counts.decrement(8),Ok(1));
 let c=Counts::new(u32::MAX,u32::MAX);assert_eq!(c.increment(4),Ok(u32::MAX));assert_eq!(c.read(4),Ok(0));assert_eq!(c.increment(8),Ok(u32::MAX));assert_eq!(c.read(8),Ok(0));assert!(c.increment(12).is_err());
}

#[path="audio_replay_pair_move_tests.rs"]
mod move_tests;
