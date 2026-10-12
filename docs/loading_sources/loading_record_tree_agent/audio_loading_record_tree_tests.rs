use super::*;
use crate::audio_announcer_object_lookup::{self as read,Memory};
use crate::audio_announcer_registry_init::{self as init,OwnedMemory};
use crate::audio_announcer_registry_remove::{self as removal,Backend as Free};
use serde_json::{Value,json};
use std::collections::BTreeMap;
const TREE:u32=0x30000100;const KEY:u32=0x30000200;const ARENA:u32=0x38000000;
const CUSTOM_A:u32=0x32001000;const CUSTOM_B:u32=0x32002000;
fn n(v:&Value)->u32{v.as_u64().unwrap() as u32}
fn decode(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
struct Host {m:OwnedMemory,cursor:u32,live:BTreeMap<u32,u32>,events:Vec<Value>,writes:Vec<Value>,mutation:Option<u32>,null_next:bool,route:Deallocator,switch_free:bool}
impl Host {
 fn hex(&self,p:u32,len:u32)->String{(0..len).map(|i|format!("{:02x}",self.m.read_byte(p+i).unwrap())).collect()}
 fn raw(&mut self,p:u32,data:&[u8]){for (i,&v) in data.iter().enumerate(){self.m.write_byte(p+i as u32,v).unwrap();}}
 fn trace_write(&mut self,p:u32,bytes:&[u8]){for (i,&v) in bytes.iter().enumerate(){self.writes.push(json!([p+i as u32,v]));}}
 fn alloc(&mut self,bytes:u32)->Result<u32,init::Error>{let p=self.cursor;self.cursor+=(bytes+15)&!15;self.m.reserve_at(p,bytes)?;self.live.insert(p,bytes);Ok(p)}
}
impl Memory for Host {fn word(&mut self,p:u32)->Result<u32,read::Error>{self.m.word(p)}}
impl Storage for Host {
 fn allocate(&mut self,bytes:u32)->Result<u32,init::Error>{
  if self.null_next{self.null_next=false;self.events.push(json!({"op":"allocate_null","bytes":bytes}));return Ok(0);}
  let p=self.alloc(bytes)?;self.events.push(json!({"op":"allocate","pointer":p,"bytes":bytes}));
  if let Some(value)=self.mutation.take(){Storage::write_word(&mut self.m,KEY,value)?;self.events.push(json!({"op":"mutate_key","value":value}));}Ok(p)
 }
 fn write_word(&mut self,p:u32,v:u32)->Result<(),init::Error>{Storage::write_word(&mut self.m,p,v)?;self.trace_write(p,&v.to_le_bytes());Ok(())}
 fn write_byte(&mut self,p:u32,v:u8)->Result<(),init::Error>{self.m.write_byte(p,v)?;self.trace_write(p,&[v]);Ok(())}
 fn register_shutdown(&mut self,_:u32)->Result<(),init::Error>{Err(init::Error::Backend("unexpected shutdown callback"))}
}
impl Free for Host {
 fn write_word(&mut self,p:u32,v:u32)->Result<(),removal::Error>{Storage::write_word(self,p,v).map_err(removal::Error::Owned)}
 fn deallocator(&mut self)->Result<Deallocator,removal::Error>{Ok(self.route)}
 fn free(&mut self,p:u32,route:Deallocator)->Result<(),removal::Error>{
  let len=*self.live.get(&p).expect("free of live allocation");let (callback,context)=match route{Deallocator::Standard=>(0,0),Deallocator::Custom{callback,context}=>(callback,context)};
  self.events.push(json!({"op":"free","pointer":p,"callback":callback,"context":context,"hex":self.hex(p,len)}));
  self.live.remove(&p);self.m.release(p).map_err(removal::Error::Owned)?;
  if self.switch_free{if callback==CUSTOM_A{self.route=Deallocator::Custom{callback:CUSTOM_B,context:0x2222};}else if callback==CUSTOM_B{self.route=Deallocator::Standard;}}
  Ok(())
 }
}
impl Boundary for Host {
 fn read_byte(&mut self,p:u32)->Result<u8,read::Error>{self.m.read_byte(p)}
 fn initialize_lock(&mut self,_:u32)->Result<(),&'static str>{Err("unexpected lock")}
 fn destroy_lock(&mut self,_:u32)->Result<(),&'static str>{Err("unexpected lock")}
 fn enter_lock(&mut self,_:u32)->Result<(),&'static str>{Err("unexpected lock")}
 fn leave_lock(&mut self,_:u32)->Result<(),&'static str>{Err("unexpected lock")}
}
fn host(fill:u8)->Host {
 let mut b=Host{m:OwnedMemory::new(ARENA,fill),cursor:ARENA,live:BTreeMap::new(),events:vec![],writes:vec![],mutation:None,null_next:false,route:Deallocator::Standard,switch_free:false};
 b.m.reserve_at(TREE,8).unwrap();b.m.reserve_at(KEY,4).unwrap();b.m.reserve_at(TUTORIAL_CONSTRUCTION_BYTE,1).unwrap();
 let source:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/loading_record_tree_sources.json")).unwrap();assert_eq!(source["native_sha256"],"402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862");let row=source["regions"].as_array().unwrap().iter().find(|x|x["role"]=="tutorial_construction_byte").unwrap();b.raw(TUTORIAL_CONSTRUCTION_BYTE,&decode(row["hex"].as_str().unwrap()));b
}
fn compare(b:&mut Host,s:&Value,context:&str){
 assert_eq!(b.hex(TREE,8),s["tree_hex"].as_str().unwrap(),"tree {context}");
 let blocks:Vec<Value>=b.live.iter().map(|(&p,&len)|json!({"pointer":p,"bytes":len,"hex":b.hex(p,len)})).collect();assert_eq!(json!(blocks),s["blocks"],"blocks {context}");
 assert_eq!(json!(b.events),s["events"],"allocation/free order {context}");
 assert_eq!(json!(b.writes),s["writes"],"native byte write order {context}");assert_eq!(b.word(KEY).unwrap(),n(&s["key"]),"key {context}");b.events.clear();b.writes.clear();
}
fn exercise(kind:Kind){
 let proof:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/replay_loading_record_tree_probe.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["native_sha256"],"402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862");
 let name=if kind==Kind::Standard{"standard"}else{"tutorial"};let mut calls=0;let mut lives=0;
 for case in proof["cases"].as_array().unwrap().iter().filter(|c|c["kind"]==name){
  let profile=case["profile"].as_str().unwrap();let mut b=host(n(&case["fill"]) as u8);construct(&mut b,kind,TREE).unwrap();compare(&mut b,&case["initial"],profile);
  for (i,step) in case["steps"].as_array().unwrap().iter().enumerate(){
   Storage::write_word(&mut b.m,KEY,n(&step["key"])).unwrap();b.mutation=step["mutate_key"].as_u64().map(|x|x as u32);b.null_next=step["null_allocate"].as_bool().unwrap();if let Some(c)=step["seed_count"].as_u64(){Storage::write_word(&mut b.m,TREE+4,c as u32).unwrap();}
   if step["custom_free"]==true{b.route=Deallocator::Custom{callback:CUSTOM_A,context:0x1111};}
   let result=record_slot(&mut b,kind,TREE,KEY);match step["error"].as_str(){Some("bad_alloc")=>assert_eq!(result,Err(Error::AllocationFailed(kind.node_bytes()))),Some("length_error")=>assert_eq!(result,Err(Error::Boundary("native loading record tree capacity exceeded"))),None=>assert_eq!(result,Ok(n(&step["result"]))),e=>panic!("unknown native error {e:?}")}
   compare(&mut b,&step["snapshot"],&format!("{name} {profile} #{i}"));b.route=Deallocator::Standard;calls+=1;
  }
  for s in case["seeded_strings"].as_array().unwrap(){let data=decode(s["hex"].as_str().unwrap());let p=b.alloc(data.len() as u32).unwrap();assert_eq!(p,n(&s["pointer"]));b.raw(p,&data);let string=n(&s["node"])+n(&s["offset"]);for (o,v) in [(0,p),(16,data.len() as u32-1),(20,data.len() as u32-1)]{Storage::write_word(&mut b.m,string+o,v).unwrap();}}
  if profile=="custom_strings"{b.switch_free=true;b.route=Deallocator::Custom{callback:CUSTOM_A,context:0x1111};}
  compare(&mut b,&case["before_destroy"],profile);destroy(&mut b,kind,TREE).unwrap();compare(&mut b,&case["destroyed"],profile);assert!(b.live.is_empty());lives+=1;
 }
 assert_eq!((lives,calls),(24,240));
}
#[test]fn audio_loading_record_tree_standard_matches_native240_calls24_lifetimes_full_bytes_writes_and_frees(){exercise(Kind::Standard)}
#[test]fn audio_loading_record_tree_tutorial_matches_native240_calls24_lifetimes_full_bytes_writes_and_frees(){exercise(Kind::Tutorial)}
#[test]fn audio_loading_record_tree_rejects_missing_tree_and_null_sentinel_without_fake_record(){
 let mut b=host(165);assert!(record_slot(&mut b,Kind::Standard,TREE,KEY).is_err());assert!(b.live.is_empty());
 b.null_next=true;assert_eq!(construct(&mut b,Kind::Tutorial,TREE),Err(Error::AllocationFailed(96)));assert!(b.live.is_empty());assert_eq!(b.word(TREE).unwrap(),0);assert_eq!(b.word(TREE+4).unwrap(),0);
}
