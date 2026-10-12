use super::*;
use crate::audio_announcer_object_lookup::{self as read,Memory};
use crate::audio_announcer_registry_init::{self as init,OwnedMemory};
use crate::audio_announcer_registry_remove::{self as removal,Deallocator};
use serde_json::Value;

#[derive(Clone,Copy,PartialEq,Eq)]
enum Failure {None,Consumer,Reload,Copy,Handler}
#[derive(Clone,Copy,PartialEq,Eq)]
enum CleanupFailure {None,Route,Free}
struct Host {
 memory:OwnedMemory,metadata:u32,source_node:u32,snapshot:Option<u32>,
 failure:Failure,cleanup:CleanupFailure,events:Vec<&'static str>,
 route:Deallocator,freed_route:Option<Deallocator>,
}
impl Memory for Host {
 fn word(&mut self,p:u32)->Result<u32,read::Error>{
  if self.snapshot.is_some()&&((self.failure==Failure::Reload&&p==self.source_node+20)||(self.failure==Failure::Handler&&p==self.metadata+4)){
   self.events.push("read_failed");return Err(read::Error::MissingWord(p));
  }self.memory.word(p)
 }
}
impl Storage for Host {
 fn allocate(&mut self,size:u32)->Result<u32,init::Error>{self.memory.allocate(size)}
 fn write_word(&mut self,p:u32,v:u32)->Result<(),init::Error>{
  if self.failure==Failure::Copy&&self.snapshot==Some(p){self.events.push("copy_failed");return Err(init::Error::Backend("snapshot copy failed"));}
  Storage::write_word(&mut self.memory,p,v)
 }
 fn write_byte(&mut self,p:u32,v:u8)->Result<(),init::Error>{self.memory.write_byte(p,v)}
 fn register_shutdown(&mut self,p:u32)->Result<(),init::Error>{self.memory.register_shutdown(p)}
}
impl RemovalBackend for Host {
 fn write_word(&mut self,p:u32,v:u32)->Result<(),removal::Error>{Storage::write_word(&mut self.memory,p,v).map_err(removal::Error::Owned)}
 fn deallocator(&mut self)->Result<Deallocator,removal::Error>{self.events.push("deallocator");if self.cleanup==CleanupFailure::Route{return Err(removal::Error::Backend("cleanup route failed"));}Ok(self.route)}
 fn free(&mut self,p:u32,route:Deallocator)->Result<(),removal::Error>{assert_eq!(Some(p),self.snapshot);self.events.push("free");self.freed_route=Some(route);if self.cleanup==CleanupFailure::Free{return Err(removal::Error::Backend("snapshot free failed"));}self.memory.release(p).map_err(removal::Error::Owned)}
}
impl PendingBoundary for Host {
 fn allocate_engine(&mut self,_:u32)->Result<u32,&'static str>{Err("unexpected engine allocation")}
 fn allocate_pointer_array(&mut self,words:u32)->Result<u32,&'static str>{assert_eq!(words,1);self.events.push("allocate");let p=self.memory.allocate(words*4).map_err(|_|"allocation failed")?;self.snapshot=Some(p);Ok(p)}
 fn remove_active_listener(&mut self,_:u32,_:u32)->Result<(),&'static str>{Err("unexpected removal")}
}
impl ConsumerBoundary for Host {
 fn byte(&mut self,p:u32)->Result<u8,read::Error>{self.memory.read_byte(p)}
 fn service_gate(&mut self,service:u32,callback:u32)->Result<u32,&'static str>{assert_eq!((service,callback),(0x30006000,0x718ad0));self.events.push("gate");Ok(0)}
 fn actor_call(&mut self,actor:u32,callback:u32)->Result<(),&'static str>{
  assert_eq!((actor,callback),(0x30004000,0x32001300));assert_eq!(self.memory.read_byte(self.metadata+36).unwrap(),0);
  if self.failure==Failure::Consumer{self.events.push("consumer_failed");self.route=Deallocator::Custom{callback:0x1234,context:7};Err("actor consumer failed")}else{self.events.push("consumer");Ok(())}
 }
 fn diagnostic(&mut self,_:[u32;5])->Result<(),&'static str>{Err("unexpected diagnostic")}
}
fn number(v:&Value)->u32{v.as_u64().unwrap() as u32}
fn decode(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
fn seed(b:&mut Host,p:u32,bytes:&[u8]){for (i,&v) in bytes.iter().enumerate(){b.memory.write_byte(p+i as u32,v).unwrap();}}
fn prepared(failure:Failure,cleanup:CleanupFailure)->Host {
 let proof:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/replay_service_packet_probe.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["native_sha256"],"402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862");let c=&proof["cases"][0];assert_eq!((number(&c["owner_id"]),number(&c["gate"])),(42,0));let state=&c["steps"][5]["snapshot"];
 let mut b=Host{memory:OwnedMemory::new(0x38000000,0xa5),metadata:number(&c["metadata"]),source_node:0,snapshot:None,failure,cleanup,events:vec![],route:Deallocator::Standard,freed_route:None};
 // The input graph was constructed/activated by the original native code.
 // No lookup or consumer result is supplied by a mock for this error test.
 for row in state["blocks"].as_array().unwrap(){let p=number(&row["pointer"]);b.memory.reserve_at(p,number(&row["bytes"])).unwrap();seed(&mut b,p,&decode(row["hex"].as_str().unwrap()));}
 let source:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/replay_service_packet_sources.json")).unwrap();assert_eq!(source["native_sha256"],proof["native_sha256"]);
 for row in source["regions"].as_array().unwrap(){if matches!(row["role"].as_str().unwrap(),"service_vtable"|"owner_metadata_callback_vtables"|"owner_callback_vtable"){let p=number(&row["address"]);b.memory.reserve_at(p,number(&row["length"])).unwrap();seed(&mut b,p,&decode(row["hex"].as_str().unwrap()));}}
 for (p,size) in [(0x30006000,392),(0x2d787b8,4),(0x30004000,4),(0x30004100,48),(0x30007800,12),(0x30007900,32)]{b.memory.reserve_at(p,size).unwrap();}
 seed(&mut b,0x30006000,&decode(state["service_hex"].as_str().unwrap()));
 for (p,v) in [(0x2d787b8,0x30006000),(0x30004000,0x30004100),(0x30004124,0x32001300),(0x30007800,42),(0x30007804,0),(0x30007808,0x51)]{Storage::write_word(&mut b.memory,p,v).unwrap();}
 b.source_node=active::descriptor_lookup(&mut b,0x30006018,42,0x51).unwrap().unwrap();b.memory.write_byte(b.metadata+36,1).unwrap();b
}
fn run(b:&mut Host)->Result<u8,Error>{dispatch(b,0x30006000,0x30007800,0x30007900)}
#[test]
fn audio_service_dispatch_cleanup_consumer_failure_releases_snapshot_after_real_metadata_effect(){
 let mut b=prepared(Failure::Consumer,CleanupFailure::None);let begin=b.word(b.source_node+20).unwrap();let source_entry=b.word(begin).unwrap();assert_eq!(run(&mut b),Err(Error::Boundary("actor consumer failed")));
 assert_eq!(b.events,vec!["allocate","gate","consumer_failed","deallocator","free"]);assert_eq!(b.freed_route,Some(Deallocator::Custom{callback:0x1234,context:7}));let snapshot=b.snapshot.unwrap();assert_eq!(b.memory.released_labels,vec![snapshot]);assert!(b.memory.word(snapshot).is_err());assert_eq!(b.memory.word(begin).unwrap(),source_entry);assert_eq!(b.memory.read_byte(b.metadata+36).unwrap(),0);
}
#[test]
fn audio_service_dispatch_cleanup_releases_snapshot_on_reload_copy_and_handler_read_errors(){
 for failure in [Failure::Reload,Failure::Copy,Failure::Handler]{let mut b=prepared(failure,CleanupFailure::None);let expected=match failure{Failure::Reload=>Error::Context(read::Error::MissingWord(b.source_node+20)),Failure::Copy=>Error::Storage(init::Error::Backend("snapshot copy failed")),Failure::Handler=>Error::Context(read::Error::MissingWord(b.metadata+4)),_=>unreachable!()};assert_eq!(run(&mut b),Err(expected));let snapshot=b.snapshot.unwrap();assert_eq!(b.memory.released_labels,vec![snapshot]);assert!(b.memory.word(snapshot).is_err());assert_eq!(&b.events[b.events.len()-2..],&["deallocator","free"]);assert!(!b.events.contains(&"gate"));}
}
#[test]
fn audio_service_dispatch_cleanup_preserves_primary_and_route_or_free_failures(){
 for failure in [CleanupFailure::Route,CleanupFailure::Free]{let mut b=prepared(Failure::Consumer,failure);let cleanup=if failure==CleanupFailure::Route{"cleanup route failed"}else{"snapshot free failed"};assert_eq!(run(&mut b),Err(Error::Cleanup{primary:Box::new(Error::Boundary("actor consumer failed")),cleanup:Box::new(Error::Release(removal::Error::Backend(cleanup)))}));assert_eq!(b.events.last(),Some(&if failure==CleanupFailure::Route{"deallocator"}else{"free"}));assert!(b.memory.released_labels.is_empty());assert!(b.memory.word(b.snapshot.unwrap()).is_ok());}
}
#[test]
fn audio_service_dispatch_cleanup_free_failure_after_success_is_not_a_success_result(){
 let mut b=prepared(Failure::None,CleanupFailure::Free);assert_eq!(run(&mut b),Err(Error::Release(removal::Error::Backend("snapshot free failed"))));assert_eq!(b.events,vec!["allocate","gate","consumer","deallocator","free"]);assert!(b.memory.released_labels.is_empty());assert!(b.memory.word(b.snapshot.unwrap()).is_ok());
}
