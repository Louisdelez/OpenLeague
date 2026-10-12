use super::*;
use crate::audio_announcer_object_lookup as read;
use crate::audio_announcer_registry_init::{self as init,OwnedMemory};
use crate::audio_announcer_registry_remove::{self as remove,Deallocator};
use crate::audio_announcer_owner_metadata::{self as owner,Boundaries};
use serde_json::{json,Value};
use std::collections::{BTreeMap,VecDeque};
fn n(v:&Value)->u32{v.as_u64().unwrap() as u32}
fn decode(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
struct Host {
 memory:OwnedMemory,queue:VecDeque<Value>,allocated:Vec<Value>,live:BTreeMap<u32,u32>,
 actor_events:Vec<Value>,metadata:u32,fallbacks:Vec<(u16,u32,u32)>,
}
impl Host {
 fn allocate_kind(&mut self,size:u32,kind:Option<&str>)->Result<u32,init::Error>{
  let row=self.queue.pop_front().expect("unexpected allocation versus actual native consumer");assert_eq!(n(&row["bytes"]),size);assert_eq!(row["allocator"].as_str(),kind);let p=n(&row["pointer"]);self.memory.reserve_at(p,size)?;self.live.insert(p,size);self.allocated.push(row);Ok(p)
 }
}
impl Memory for Host{fn word(&mut self,p:u32)->Result<u32,read::Error>{self.memory.word(p)}}
impl Storage for Host{
 fn allocate(&mut self,size:u32)->Result<u32,init::Error>{self.allocate_kind(size,None)}
 fn write_word(&mut self,p:u32,v:u32)->Result<(),init::Error>{Storage::write_word(&mut self.memory,p,v)}
 fn write_byte(&mut self,p:u32,v:u8)->Result<(),init::Error>{self.memory.write_byte(p,v)}
 fn register_shutdown(&mut self,p:u32)->Result<(),init::Error>{self.memory.register_shutdown(p)}
}
impl RemovalBackend for Host{
 fn write_word(&mut self,p:u32,v:u32)->Result<(),remove::Error>{Storage::write_word(&mut self.memory,p,v).map_err(remove::Error::Owned)}
 fn deallocator(&mut self)->Result<Deallocator,remove::Error>{Ok(Deallocator::Standard)}
 fn free(&mut self,p:u32,route:Deallocator)->Result<(),remove::Error>{assert_eq!(route,Deallocator::Standard);self.live.remove(&p).expect("owned live allocation");self.memory.release(p).map_err(remove::Error::Owned)}
}
impl Boundaries for Host{
 fn allocate_callback_clone(&mut self,size:u32)->Result<u32,&'static str>{self.allocate_kind(size,Some("engine_operator_new")).map_err(|_|"callback allocation failed")}
 fn register_listener(&mut self,service:u32,callback:u32,field:u32,temporary:&mut u32)->Result<(),&'static str>{crate::audio_announcer_pending_service::register_virtual(self,service,callback,field,*temporary).map_err(|_|"actual pending registration failed")}
 fn unregister_listener(&mut self,service:u32,callback:u32,field:u32)->Result<(),&'static str>{crate::audio_announcer_pending_service::unregister_virtual(self,service,callback,field).map_err(|_|"actual listener removal failed")}
}
impl PendingBoundary for Host{
 fn allocate_engine(&mut self,size:u32)->Result<u32,&'static str>{self.allocate_kind(size,Some("engine_operator_new")).map_err(|_|"engine allocation failed")}
 fn allocate_pointer_array(&mut self,count:u32)->Result<u32,&'static str>{let size=count.checked_mul(4).ok_or("array overflow")?;self.allocate_kind(size,Some("owner_pointer_array")).map_err(|_|"pointer array allocation failed")}
 fn remove_active_listener(&mut self,registry:u32,field:u32)->Result<(),&'static str>{crate::audio_announcer_active_service::remove_active(self,registry,field).map_err(|_|"actual active removal failed")}
}
impl ConsumerBoundary for Host{
 fn byte(&mut self,p:u32)->Result<u8,read::Error>{self.memory.read_byte(p)}
 fn service_gate(&mut self,service:u32,callback:u32)->Result<u32,&'static str>{assert_eq!(callback,0x718ad0);self.memory.read_byte(service+0x122).map(u32::from).map_err(|_|"missing source service flag")}
 fn actor_call(&mut self,actor:u32,callback:u32)->Result<(),&'static str>{assert_eq!(actor,0x30004000);let slot=match callback{0x32001300=>0x24,0x32001400=>0x2c,_=>return Err("unqualified actor callback")};let flags=self.word(self.metadata+36).unwrap();self.actor_events.push(json!({"slot":slot,"flags_word":flags}));Ok(())}
 fn diagnostic(&mut self,_:[u32;5])->Result<(),&'static str>{Err("diagnostic consumer is outside this fixture")}
}
impl Boundary for Host{
 fn packet_fallback(&mut self,event:u16,packet:u32,context:u32)->Result<u8,Error>{
  self.fallbacks.push((event,packet,context));let target=packet_target(self,event)?;
  if target==PACKET_DEFAULT{Ok(0)}else{Err(Error::UnknownCallback(target))}
 }
}
fn seed(b:&mut Host,p:u32,bytes:&[u8]){for (i,&v) in bytes.iter().enumerate(){b.write_byte(p+i as u32,v).unwrap();}}
fn bytes(b:&Host,p:u32,len:u32)->Vec<u8>{(0..len).map(|i|b.memory.read_byte(p+i).unwrap()).collect()}
fn queue(b:&mut Host,s:&Value){assert!(b.queue.is_empty());assert!(b.allocated.is_empty());assert!(b.memory.released_labels.is_empty());b.queue=s["allocations"].as_array().unwrap().iter().cloned().collect();}
fn compare(b:&mut Host,s:&Value){
 assert!(b.queue.is_empty());assert_eq!(json!(b.allocated),s["allocations"]);assert_eq!(json!(b.memory.released_labels),s["freed"]);b.allocated.clear();b.memory.released_labels.clear();
 let rows=s["blocks"].as_array().unwrap();assert_eq!(b.live.len(),rows.len());for r in rows{let p=n(&r["pointer"]);let len=n(&r["bytes"]);assert_eq!(b.live.get(&p),Some(&len));assert_eq!(bytes(b,p,len),decode(r["hex"].as_str().unwrap()),"owned block {p:08x}");}
 assert_eq!(bytes(b,0x30006000,392),decode(s["service_hex"].as_str().unwrap()));
}
fn fixture(name:&str)->Value{serde_json::from_str(&crate::audio_test_fixture(&format!("data/4.20/{name}"))).unwrap()}
fn host(fill:u8)->Host{
 let mut b=Host{memory:OwnedMemory::new(0x34000000,fill),queue:VecDeque::new(),allocated:vec![],live:BTreeMap::new(),actor_events:vec![],metadata:0,fallbacks:vec![]};
 let source=fixture("replay_service_packet_sources.json");assert_eq!(source["native_sha256"],"402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862");
 for r in source["regions"].as_array().unwrap(){if matches!(r["role"].as_str().unwrap(),"service_vtable"|"packet_jump_table"|"packet_case_indices"|"owner_metadata_callback_vtables"|"owner_callback_vtable"){let p=n(&r["address"]);b.memory.reserve_at(p,n(&r["length"])).unwrap();seed(&mut b,p,&decode(r["hex"].as_str().unwrap()));}}
 for (p,size) in [(owner::SERVICE_GLOBAL,4),(0x123b12c,4),(0x2d5f448,4),(LOCAL_OWNER,4),(0x30005600,4),(0x30006000,392),(0x30004000,4),(0x30004100,0x30),(0x30007900,32),(0x3000a000,SCRATCH_BYTES)]{b.memory.reserve_at(p,size).unwrap();}
 for (p,v) in [(owner::SERVICE_GLOBAL,0),(0x123b12c,0),(0x30006000,0x10afe8c),(0x3000600c,0),(0x30006010,0),(0x30006014,0),(0x30004000,0x30004100),(0x30004124,0x32001300),(0x3000412c,0x32001400)]{Storage::write_word(&mut b,p,v).unwrap();}b
}
#[test]
fn audio_replay_service_receive_matches_native_registry_effects_and_rejects_unported_packet95(){
 let proof=fixture("replay_service_packet_probe.json");assert_eq!(proof["passed"],true);assert_eq!(proof["native_sha256"],"402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862");assert_eq!(proof["cases"].as_array().unwrap().len(),8);let mut matched=0;let mut unsupported=0;
 for c in proof["cases"].as_array().unwrap(){
  let fill=n(&c["fill"]) as u8;let service=n(&c["service"]);let packet=n(&c["packet"]);let mut b=host(fill);queue(&mut b,&c["initial"]);crate::audio_announcer_active_service::construct(&mut b,service,fill).unwrap();compare(&mut b,&c["initial"]);
  for (p,v) in [(owner::SERVICE_GLOBAL,service),(0x123b12c,0x3f800000),(0x2d5f448,u32::MAX),(LOCAL_OWNER,0x11223344),(0x30005600,n(&c["owner_id"]))]{Storage::write_word(&mut b,p,v).unwrap();}b.write_byte(service+0x122,n(&c["gate"]) as u8).unwrap();queue(&mut b,&c["created"]);let metadata=b.allocate(56).unwrap();assert_eq!(metadata,n(&c["metadata"]));b.metadata=metadata;owner::construct(&mut b,metadata,0x30004000,0x30005600).unwrap();compare(&mut b,&c["created"]);
  for step in c["steps"].as_array().unwrap(){
   b.write_byte(service+0x184,n(&step["enabled"]) as u8).unwrap();seed(&mut b,packet,&decode(step["packet_hex"].as_str().unwrap()));
   // Source stack padding is caller-owned input. Native activation descriptor
   // captures provide those two bytes; the port performs the other writes.
   if let Some(row)=step["activation_inputs"].as_array().unwrap().first(){let captured=decode(row.as_str().unwrap());seed(&mut b,0x3000a016,&captured[10..12]);}
   if let Some(row)=step["dispatch_inputs"].as_array().unwrap().first(){let captured=decode(row["descriptor_hex"].as_str().unwrap());seed(&mut b,0x3000a00a,&captured[10..12]);}
   b.actor_events.clear();b.fallbacks.clear();queue(&mut b,&step["snapshot"]);let result=invoke_virtual(&mut b,service,n(&step["context"]),packet,0x3000a000);
   if n(&step["code"])==0x95{assert_eq!(result,Err(Error::UnknownCallback(0x58a6f2)));unsupported+=1;}else{assert_eq!(result.unwrap(),n(&step["return_al"]) as u8);matched+=1;}
   let fallback=step["native_calls"].as_array().unwrap().iter().any(|v|n(v)==0x588290);assert_eq!(b.fallbacks,if fallback{vec![(n(&step["code"]) as u16,packet,n(&step["context"]))]}else{vec![]});assert_eq!(json!(b.actor_events),step["actor_events"]);compare(&mut b,&step["snapshot"]);
  }
  queue(&mut b,&c["metadata_destroyed"]);owner::scalar_delete(&mut b,metadata,1).unwrap();compare(&mut b,&c["metadata_destroyed"]);Storage::write_word(&mut b,owner::SERVICE_GLOBAL,0).unwrap();queue(&mut b,&c["destroyed"]);crate::audio_announcer_service_teardown::destroy_members(&mut b,service).unwrap();compare(&mut b,&c["destroyed"]);assert!(b.live.is_empty());
 }
 assert_eq!((matched,unsupported),(128,16));
}
#[test]
fn audio_replay_service_receive_filtered_headers_need_no_packet_owner_or_fallback(){
 let mut b=host(0);b.memory.reserve_at(0x3000b000,1).unwrap();b.write_byte(0x3000b000,0xdd).unwrap();assert_eq!(receive(&mut b,0,7,0x3000b000,0).unwrap(),1);b.write_byte(0x3000b000,0x51).unwrap();assert_eq!(invoke_virtual(&mut b,0x30006000,7,0x3000b000,0).unwrap(),1);assert!(b.fallbacks.is_empty());assert!(b.allocated.is_empty());
 Storage::write_word(&mut b,0x10afe8c+0x34,0x1234).unwrap();assert_eq!(invoke_virtual(&mut b,0x30006000,7,0x3000b000,0),Err(Error::UnknownCallback(0x1234)));
}
