use super::*;
use crate::audio_announcer_registry_init::OwnedMemory;
use crate::audio_announcer_owner_control::{self as control,Counts,ObjectBoundary};
use crate::audio_announcer_owner_component_destructor::ControlBoundary;
use crate::audio_replay_object_commands as commands;
use crate::audio_replay_events as events;
use serde_json::{Value,json};
use std::collections::{BTreeMap,BTreeSet};
const GAME:u32=0x3000a000;const NESTED:u32=0x3000a100;const PACKET:u32=0x3000a300;const HELD:u32=0x3000a800;const INCOMING:u32=0x3000a900;const SCRATCH:u32=0x3000aa00;
fn n(v:&Value)->u32{v.as_u64().unwrap() as u32}
struct Backend{memory:OwnedMemory,counts:BTreeMap<u32,Counts>,events:Vec<Value>,locks:BTreeSet<u32>,held:BTreeSet<u32>,fail_allocation:Option<u32>,custom:bool,clone_labels:BTreeSet<u32>,actions:Vec<crate::audio_replay_stream::Action>,event_calls:Vec<Value>,state_mutation:Option<u32>}
impl Memory for Backend{fn word(&mut self,a:u32)->Result<u32,read::Error>{self.memory.word(a)}}
impl Storage for Backend{
 fn allocate(&mut self,bytes:u32)->Result<u32,init::Error>{if self.fail_allocation==Some(bytes){return Ok(0);}self.memory.allocate(bytes)}
 fn write_word(&mut self,a:u32,v:u32)->Result<(),init::Error>{Storage::write_word(&mut self.memory,a,v)}
 fn write_byte(&mut self,a:u32,v:u8)->Result<(),init::Error>{self.memory.write_byte(a,v)}
 fn register_shutdown(&mut self,c:u32)->Result<(),init::Error>{self.memory.register_shutdown(c)}
}
impl Free for Backend{
 fn write_word(&mut self,a:u32,v:u32)->Result<(),removal::Error>{Storage::write_word(&mut self.memory,a,v).map_err(removal::Error::Owned)}
 fn deallocator(&mut self)->Result<removal::Deallocator,removal::Error>{Ok(if self.custom{removal::Deallocator::Custom{callback:0x32008300,context:0x13572468}}else{removal::Deallocator::Standard})}
 fn free(&mut self,p:u32,route:removal::Deallocator)->Result<(),removal::Error>{
  if let removal::Deallocator::Custom{callback,context}=route{assert_eq!(callback,0x32008300);self.events.push(json!({"op":"custom_free","pointer":p,"context":context}));}self.memory.release(p).map_err(removal::Error::Owned)?;self.counts.remove(&p);Ok(())}
}
impl Backend{
 fn set(&mut self,p:u32,value:u32){Storage::write_word(self,p,value).unwrap();}
 fn count(&mut self,address:u32,increase:bool)->Result<u32,&'static str>{
  let existing=self.counts.keys().find_map(|&p|if address==p+4{Some((p,4))}else if address==p+8{Some((p,8))}else{None});
  let (base,offset)=if let Some(pair)=existing{pair}else{let base=address.checked_sub(4).ok_or("invalid counter")?;let strong=self.word(base+4).map_err(|_|"missing strong")?;let weak=self.word(base+8).map_err(|_|"missing weak")?;self.counts.insert(base,Counts::new(strong,weak));(base,4)};
  let c=&self.counts[&base];let old=if increase{c.increment(offset)?}else{c.decrement(offset)?};Storage::write_word(&mut self.memory,address,c.read(offset)?).map_err(|_|"counter write failed")?;Ok(old)
 }
 fn new_packet(&mut self,id:u32,low:u32,high:u32)->u32{
  let p=self.allocate(16).unwrap();for (off,v) in [(0,commands::PACKET_VTABLE),(4,id),(8,low),(12,high)]{self.set(p+off,v);}p
 }
 fn incoming(&mut self,id:u32,low:u32,high:u32){let p=self.new_packet(id,low,high);self.set(INCOMING,0);self.set(INCOMING+4,0);control::replace_pair(self,INCOMING,p).unwrap();}
}
impl ControlBoundary for Backend{
 fn decrement_reference(&mut self,a:u32)->Result<u32,&'static str>{self.count(a,false)}
 fn dispose(&mut self,p:u32,callback:u32)->Result<(),&'static str>{if callback==crate::audio_replay_manager_control::DISPOSE{crate::audio_replay_manager_control::dispose(self,p).map_err(|_|"manager dispose failed")}
  else if callback==control::DISPOSE{control::dispose(self,p).map_err(|_|"dispose failed")}
  else{Err("unknown dispose")}}
 fn release_control(&mut self,p:u32,callback:u32)->Result<(),&'static str>{if callback!=control::RELEASE{return Err("unknown release");}control::release(self,p).map_err(|_|"release failed")}
}
impl pair::Boundary for Backend{fn increment_reference(&mut self,a:u32)->Result<u32,&'static str>{self.count(a,true)}}
impl ObjectBoundary for Backend{
 fn scalar_delete_object(&mut self,p:u32,callback:u32,flags:u32)->Result<(),&'static str>{if callback!=commands::PACKET_DELETE{return Err("unknown packet scalar delete");}commands::delete_packet(self,p,flags).map(|_|()).map_err(|_|"packet delete failed")}
}
impl Boundary for Backend{
 fn read_byte(&mut self,a:u32)->Result<u8,read::Error>{self.memory.read_byte(a)}
 fn initialize_lock(&mut self,p:u32)->Result<(),&'static str>{assert!(self.locks.insert(p));for i in 8..32{self.write_byte(p+i,0).unwrap();}Ok(())}
 fn enter_lock(&mut self,p:u32)->Result<(),&'static str>{if !self.locks.contains(&p)||!self.held.insert(p){return Err("invalid or reentrant mutex");}self.events.push(json!({"op":"enter","manager":p}));Ok(())}
 fn leave_lock(&mut self,p:u32)->Result<(),&'static str>{assert!(self.held.remove(&p));self.events.push(json!({"op":"leave","manager":p}));Ok(())}
 fn destroy_lock(&mut self,p:u32)->Result<(),&'static str>{assert!(self.locks.remove(&p));assert!(!self.held.contains(&p));Ok(())}
 fn object_id(&mut self,p:u32,callback:u32)->Result<u32,&'static str>{if callback!=commands::PACKET_ID{return Err("unknown packet id method");}self.events.push(json!({"op":"id","object":p}));commands::packet_id(self,p).map_err(|_|"id read failed")}
 fn object_value(&mut self,p:u32,callback:u32)->Result<u64,&'static str>{if callback!=commands::PACKET_VALUE{return Err("unknown packet value method");}self.events.push(json!({"op":"value","object":p}));commands::packet_value(self,p).map_err(|_|"value read failed")}
}
impl events::Boundary for Backend{
 fn byte(&mut self,a:u32)->Result<u8,read::Error>{self.memory.read_byte(a)}
 fn virtual_call(&mut self,_:u32,_:u32,_:u32,_:&[events::Argument])->Result<u32,&'static str>{Err("live event consumer unavailable")}
 fn member_call(&mut self,_:u32,target:u32,args:[u32;5])->Result<u32,&'static str>{if target!=0x72c780{return Err("unknown member callback");}commands::dispatch(self,args,SCRATCH).map(|x|x as u32).map_err(|_|"command dispatch failed")}
}
impl commands::Boundary for Backend{fn initialize_game_manager(&mut self)->Result<(),&'static str>{Err("stream manager initialization is not connected")}}
fn make(fill:u8)->Backend{
 let mut b=Backend{memory:OwnedMemory::new(0x34000000,fill),counts:BTreeMap::new(),events:vec![],locks:BTreeSet::new(),held:BTreeSet::new(),fail_allocation:None,custom:false,clone_labels:BTreeSet::new(),actions:vec![],event_calls:vec![],state_mutation:None};
 for (p,size) in [(GAME,0x1000),(0x2d78520,4),(control::VTABLE,12),(crate::audio_replay_manager_control::VTABLE,12),(commands::PACKET_VTABLE,12)]{b.memory.reserve_at(p,size).unwrap();}
 for (p,value) in [(control::VTABLE,control::DISPOSE),(control::VTABLE+4,control::RELEASE),(control::VTABLE+8,control::SCALAR_DELETE),(commands::PACKET_VTABLE,commands::PACKET_DELETE),(commands::PACKET_VTABLE+4,commands::PACKET_ID),(commands::PACKET_VTABLE+8,commands::PACKET_VALUE)]{b.set(p,value);}
 for (off,value) in [(0,crate::audio_replay_manager_control::DISPOSE),(4,control::RELEASE),(8,control::SCALAR_DELETE)]{b.set(crate::audio_replay_manager_control::VTABLE+off,value);}
 b
}
fn state(b:&mut Backend,v:&Value,label:&str){
 let allocated:Vec<_>=b.memory.allocations.iter().map(|&(bytes,pointer)|json!({"bytes":bytes,"pointer":pointer})).collect();
 assert_eq!(json!(allocated),v["allocations"],"allocations {label}");assert_eq!(json!(b.memory.released_labels),v["freed"],"frees {label}");assert_eq!(json!(b.events),v["events"],"events {label}");
 for pair in v["words"].as_array().unwrap(){assert_eq!(b.word(n(&pair[0])).unwrap(),n(&pair[1]),"memory {label} address{:08x}",n(&pair[0]));}
 b.memory.allocations.clear();b.memory.released_labels.clear();b.events.clear();
}
#[test]fn audio_replay_dual_trees_and_commands_match608_native_operations_and8_destructions(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/replay_object_manager_contract.json")).unwrap();let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),8);let mut steps=0;
 for case in cases{
  let mut b=make(n(&case["fill"]) as u8);let manager=b.allocate(48).unwrap();assert_eq!(manager,n(&case["objects"]));construct(&mut b,manager).unwrap();
  b.set(0x2d78520,GAME);b.set(GAME+0x30,NESTED);b.set(NESTED+0x6c,manager);b.set(NESTED+0x70,HELD);
  for (off,v) in [(0,0x10afd08),(4,0x3000a500),(8,0x72c780),(12,0),(0x20,0x12345678)]{b.set(0x3000ab00+off,v);}
  for (off,v) in [(0,control::VTABLE),(4,1),(8,1),(12,manager)]{b.set(HELD+off,v);}
  state(&mut b,&case["initial"],"constructor");
  for (i,step) in case["steps"].as_array().unwrap().iter().enumerate(){
   let c=&step["command"];let result=match c[0].as_str().unwrap(){
    "insert"=>{b.incoming(n(&c[1]),n(&c[2]),n(&c[3]));insert(&mut b,manager,INCOMING,SCRATCH).unwrap() as u64},
    "lookup"=>lookup(&mut b,manager,n(&c[1]),SCRATCH).unwrap(),
    "remove"=>remove(&mut b,manager,n(&c[1]),SCRATCH).unwrap() as u64,
    "packet"=>{b.write_byte(PACKET,n(&c[1]) as u8).unwrap();b.set(PACKET+4,n(&c[2]));b.set(PACKET+8,n(&c[3]));b.set(PACKET+12,n(&c[4]));events::invoke(&mut b,0x3000ab00,[0x3000ab20,0,0x100,0,PACKET]).unwrap() as u64},
    _=>panic!("unknown fixture operation")
   };
   let label=format!("{} fill{} step{i} {c}",case["order"],case["fill"]);assert_eq!(result,step["result"].as_u64().unwrap(),"result {label}");state(&mut b,&step["state"],&label);assert_eq!(json!([b.word(HELD+4).unwrap(),b.word(HELD+8).unwrap()]),step["held_counts"]);steps+=1;
  }
  destroy(&mut b,manager).unwrap();state(&mut b,&case["destroyed"],"destructor");assert!(b.held.is_empty());assert!(b.locks.is_empty());assert_eq!(b.counts.len(),1);assert_eq!(b.counts[&HELD].read(4),Ok(1));
 }
 assert_eq!(steps,608);
}
#[test]fn audio_replay_insert_allocation_failure_releases_temporary_pair_and_unlocks(){
 let mut b=make(0);let manager=b.allocate(48).unwrap();construct(&mut b,manager).unwrap();b.incoming(42,1,2);let object=b.word(INCOMING).unwrap();let ctrl=b.word(INCOMING+4).unwrap();b.fail_allocation=Some(28);
 assert_eq!(insert(&mut b,manager,INCOMING,SCRATCH),Err(Error::AllocationFailed));assert!(b.held.is_empty());assert!(b.word(object).is_err());assert!(b.word(ctrl).is_err());assert_eq!(b.word(manager+0x2c),Ok(0));destroy(&mut b,manager).unwrap();
}
#[test]fn audio_replay_unknown_consumers_and_missing_startup_are_explicit(){
 let mut b=make(0);b.set(0x2d78520,0);assert_eq!(commands::dispatch(&mut b,[0,0,0,0,0],SCRATCH),Err(commands::Error::Boundary("stream manager initialization is not connected")));
 b.set(0x2d78520,GAME);b.set(GAME+0x20,INCOMING);b.set(INCOMING,HELD);b.set(HELD+8,123);
 assert_eq!(commands::dispatch(&mut b,[0,3,2,0,PACKET],SCRATCH),Err(commands::Error::Events(events::Error::Boundary("live event consumer unavailable"))));
}

#[path="audio_replay_manager_control_tests.rs"]
mod ownership_tests;

#[path="audio_replay_stream_tests.rs"]
mod stream_tests;
