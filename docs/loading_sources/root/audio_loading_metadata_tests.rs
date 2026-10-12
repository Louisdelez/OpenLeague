use super::*;
use crate::audio_announcer_object_lookup::{self as read, Memory};
use crate::audio_announcer_registry_init::{self as init, OwnedMemory};
use crate::audio_announcer_registry_remove::{self as removal, Backend as Free, Deallocator};
use crate::audio_announcer_owner_component_destructor::ControlBoundary;
use serde_json::{json,Value};
use std::collections::{BTreeMap,VecDeque};
const H:u32=0x30000000;
const P:u32=H+0x100;
const OUT:u32=H+0x3000;
const PARENT_OBJECT:u32=H+0x3100;
const SCRATCH:u32=H+0x7000;
fn n(v:&Value)->u32{v.as_u64().unwrap() as u32}
fn decode(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
struct Host{memory:OwnedMemory,queue:VecDeque<Value>,live:BTreeMap<u32,u32>,events:Vec<Value>,held:bool,resolved:u64,fail_resolve:bool,fail_leave:bool,fail_word:Option<u32>,fail_after_allocation:Option<u32>,fail_after_retain:bool}
impl Memory for Host{fn word(&mut self,p:u32)->Result<u32,read::Error>{if self.fail_word==Some(p){self.fail_word=None;return Err(read::Error::InvalidLayout);}self.memory.word(p)}}
impl Storage for Host{
 fn allocate(&mut self,size:u32)->Result<u32,init::Error>{let a=self.queue.pop_front().expect("unexpected allocation");assert_eq!(n(&a["bytes"]),size);let p=n(&a["pointer"]);self.memory.reserve_at(p,size)?;self.live.insert(p,size);self.events.push(json!({"op":"allocate","p":p,"bytes":size}));if let Some(p)=self.fail_after_allocation.take(){self.fail_word=Some(p);}Ok(p)}
 fn write_word(&mut self,p:u32,v:u32)->Result<(),init::Error>{Storage::write_word(&mut self.memory,p,v)}
 fn write_byte(&mut self,p:u32,v:u8)->Result<(),init::Error>{self.memory.write_byte(p,v)}
 fn register_shutdown(&mut self,p:u32)->Result<(),init::Error>{self.memory.register_shutdown(p)}
}
impl Free for Host{
 fn write_word(&mut self,p:u32,v:u32)->Result<(),removal::Error>{Free::write_word(&mut self.memory,p,v)}
 fn deallocator(&mut self)->Result<Deallocator,removal::Error>{Ok(Deallocator::Standard)}
 fn free(&mut self,p:u32,_route:Deallocator)->Result<(),removal::Error>{self.live.remove(&p).expect("live buffer");self.events.push(json!({"op":"free","p":p}));if p>=0x38000000{self.memory.free(p,Deallocator::Standard)?;}Ok(())}
}
impl metadata::Boundary for Host{
 fn read_byte(&mut self,p:u32)->Result<u8,read::Error>{self.memory.read_byte(p)}
 fn initialize_lock(&mut self,_p:u32)->Result<(),&'static str>{Err("not expected")}
 fn destroy_lock(&mut self,_p:u32)->Result<(),&'static str>{Err("not expected")}
 fn enter_lock(&mut self,p:u32)->Result<(),&'static str>{assert!(!self.held);self.held=true;self.events.push(json!({"op":"enter","p":p}));Ok(())}
 fn leave_lock(&mut self,p:u32)->Result<(),&'static str>{assert!(self.held);self.held=false;self.events.push(json!({"op":"leave","p":p}));if self.fail_leave{Err("injected leave failure")}else{Ok(())}}
}
impl ControlBoundary for Host{
 fn decrement_reference(&mut self,p:u32)->Result<u32,&'static str>{let old=self.word(p).unwrap();Storage::write_word(self,p,old.wrapping_sub(1)).unwrap();Ok(old)}
 fn dispose(&mut self,_p:u32,_target:u32)->Result<(),&'static str>{Err("unexpected last strong reference")}
 fn release_control(&mut self,_p:u32,_target:u32)->Result<(),&'static str>{Err("unexpected last weak reference")}
}
impl pair::Boundary for Host{
 fn increment_reference(&mut self,p:u32)->Result<u32,&'static str>{let old=self.word(p).unwrap();Storage::write_word(self,p,old.wrapping_add(1)).unwrap();if self.fail_after_retain{self.fail_word=Some(SCRATCH+4);self.fail_after_retain=false;}Ok(old)}
}
impl Boundary for Host{
 fn initialize_game_manager(&mut self)->Result<(),&'static str>{self.events.push(json!({"op":"initialize_parent"}));Storage::write_word(self,PARENT,PARENT_OBJECT).unwrap();Ok(())}
 fn resolve_key(&mut self,p:u32,target:u32,key:u32)->Result<u64,&'static str>{self.events.push(json!({"op":"resolve","p":p,"target":target,"key":key}));if self.fail_resolve{Err("injected resolver failure")}else{Ok(self.resolved)}}
}
fn arena(v:&Value,fill:u8)->Vec<u8>{let mut data=vec![fill;0x6000];for r in v["arena_runs"].as_array().unwrap(){let p=n(&r[0]) as usize;let bytes=decode(r[1].as_str().unwrap());data[p..p+bytes.len()].copy_from_slice(&bytes);}data}
fn bytes(b:&Host,p:u32,size:u32)->Vec<u8>{(0..size).map(|i|b.memory.read_byte(p+i).unwrap()).collect()}
fn host(c:&Value)->Host{
 let mut b=Host{memory:OwnedMemory::new(0x38000000,n(&c["fill"]) as u8),queue:VecDeque::new(),live:BTreeMap::new(),events:vec![],held:false,resolved:0,fail_resolve:false,fail_leave:false,fail_word:None,fail_after_allocation:None,fail_after_retain:false};
 b.memory.reserve_at(H,0x8000).unwrap();for(i,v)in arena(&c["initial"],n(&c["fill"]) as u8).into_iter().enumerate(){b.write_byte(H+i as u32,v).unwrap();}
 for x in c["initial"]["live"].as_array().unwrap(){b.live.insert(n(&x["pointer"]),n(&x["bytes"]));}
 b.memory.reserve_at(PARENT,4).unwrap();Storage::write_word(&mut b,PARENT,PARENT_OBJECT).unwrap();b.memory.reserve_at(0x10b00c4,0x28).unwrap();
 for(o,v)in [(0x18,RESOLVE),(0x20,NAME),(0x24,EXTRA)]{Storage::write_word(&mut b,0x10b00c4+o,v).unwrap();}b
}
fn check(b:&Host,expected:&Value,fill:u8){assert_eq!(bytes(b,H,0x6000),arena(expected,fill));let live=expected["live"].as_array().unwrap();assert_eq!(b.live.len(),live.len());for x in live{let p=n(&x["pointer"]);let size=n(&x["bytes"]);assert_eq!(b.live.get(&p),Some(&size));assert_eq!(bytes(b,p,size),decode(x["hex"].as_str().unwrap()));}assert!(!b.held);}
fn destroy(b:&mut Host,p:u32){if b.word(p+20).unwrap()>=16{let raw=b.word(p).unwrap();b.free(raw,Deallocator::Standard).unwrap();}empty(b,p).unwrap();}
#[test]
fn audio_loading_metadata_native_getters_and_capacity_retention(){
 let v:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/loading_metadata_probe.json")).unwrap();let mut calls=0;
 for c in v["cases"].as_array().unwrap(){let fill=n(&c["fill"]) as u8;let service=c["service"].as_bool().unwrap();let mut b=host(c);
  for step in c["steps"].as_array().unwrap(){check(&b,&step["before"],fill);b.resolved=step["resolved"].as_u64().unwrap();b.queue=step["name_allocations"].as_array().unwrap().iter().cloned().collect();b.events.clear();if step["reset_parent"].as_bool().unwrap(){Storage::write_word(&mut b,PARENT,0).unwrap();}
   let key=n(&step["input_key"]);assert_eq!(if service{service_name(&mut b,OUT,key,SCRATCH)}else{name(&mut b,P,OUT,key)}.unwrap(),OUT);assert!(b.queue.is_empty());assert_eq!(b.events,step["name_events"].as_array().unwrap().clone());check(&b,&step["name_after"],fill);
   b.events.clear();assert_eq!(if service{service_extra(&mut b,key,SCRATCH)}else{extra(&mut b,P,key)}.unwrap(),n(&step["extra"]));assert_eq!(b.events,step["extra_events"].as_array().unwrap().clone());check(&b,&step["extra_after"],fill);
   b.events.clear();destroy(&mut b,OUT);assert_eq!(b.events,step["destroy_events"].as_array().unwrap().clone());check(&b,&step["after"],fill);calls+=2;
  }
 }assert_eq!(calls,704);
}
#[test]
fn audio_loading_metadata_releases_pair_and_lock_on_resolver_failure(){
 let v:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/loading_metadata_probe.json")).unwrap();let mut b=host(&v["cases"][0]);b.fail_resolve=true;
 assert!(service_name(&mut b,OUT,4,SCRATCH).is_err());assert!(!b.held);assert_eq!(b.word(H+0x3204).unwrap(),3);assert!(b.queue.is_empty());
 assert!(service_extra(&mut b,4,SCRATCH).is_err());assert!(!b.held);assert_eq!(b.word(H+0x3204).unwrap(),3);
}
#[test]
fn audio_loading_metadata_rolls_back_new_buffers_and_partial_acquisition(){
 let v:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/loading_metadata_probe.json")).unwrap();
 let c=&v["cases"][0];
 let step=&c["steps"][1]; // key0/index0, string16: fresh cache and output both grow.
 let mut b=host(c);let initial=b.live.len();b.resolved=step["resolved"].as_u64().unwrap();b.queue=step["name_allocations"].as_array().unwrap().iter().cloned().collect();b.fail_after_allocation=Some(P+0x1b0+20);
 assert!(service_name(&mut b,OUT,4,SCRATCH).is_err());assert_eq!(b.live.len(),initial);assert!(!b.held);assert_eq!(b.word(H+0x3204).unwrap(),3);
 let mut b=host(c);b.resolved=step["resolved"].as_u64().unwrap();b.queue=step["name_allocations"].as_array().unwrap().iter().cloned().collect();b.fail_leave=true;
 assert!(service_name(&mut b,OUT,4,SCRATCH).is_err());assert_eq!(b.live.len(),initial+1);assert_eq!(b.word(OUT+20).unwrap(),15);assert_eq!(b.word(OUT+16).unwrap(),0);assert_eq!(b.word(H+0x3204).unwrap(),3);assert!(!b.held);
 let mut b=host(c);b.fail_after_retain=true;assert!(service_name(&mut b,OUT,4,SCRATCH).is_err());assert_eq!(b.word(H+0x3204).unwrap(),3);assert_eq!(b.live.len(),initial);assert!(!b.held);
}
