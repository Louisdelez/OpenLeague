//! Native6B26F0 metadata and6B2900/6B28C0 normal-return destruction.
//! Service virtual calls and allocator startup remain explicit runtime boundaries.
use crate::audio_announcer_object_lookup::{self as lookup,Memory};
use crate::audio_announcer_registry_init::{self as init,Storage};
use crate::audio_announcer_registry_remove::{self as remove,Backend as RemovalBackend};
#[derive(Debug,PartialEq,Eq)]
pub enum Error {Context(lookup::Error),Storage(init::Error),Release(remove::Error),Boundary(&'static str),UnknownCallback(u32),AddressOverflow,Cleanup {primary:Box<Error>,cleanup:Box<Error>}}
impl From<lookup::Error> for Error {fn from(e:lookup::Error)->Self {Self::Context(e)}}
impl From<init::Error> for Error {fn from(e:init::Error)->Self {Self::Storage(e)}}
impl From<remove::Error> for Error {fn from(e:remove::Error)->Self {Self::Release(e)}}
fn add(a:u32,b:u32)->Result<u32,Error> {a.checked_add(b).ok_or(Error::AddressOverflow)}
pub const VTABLE:u32=0x10a0384;
pub const SCALAR_DELETE:u32=0x6b28c0;
pub const HANDLER_VTABLE:u32=0x1086078;
pub const HANDLER_DELETE:u32=0x578010;
pub const HANDLER_CLONE:u32=0x5ccdc0;
pub const SERVICE_GLOBAL:u32=0x2d787b8;
pub trait Boundaries {
 /// Execute allocator startup/route selection; returned allocation is real storage.
 fn allocate_callback_clone(&mut self,bytes:u32)->Result<u32,&'static str>;
 /// Original service slot0x84 receives handler storage and a mutable temporary callback.
 fn register_listener(&mut self,service:u32,callback:u32,handler_storage:u32,temporary:&mut u32)->Result<(),&'static str>;
 /// Original service slot0x88 receives handler storage.
 fn unregister_listener(&mut self,service:u32,callback:u32,handler_storage:u32)->Result<(),&'static str>;
}
fn callback_new<B:Storage>(b:&mut B,owner:u32,method:u32)->Result<u32,Error> {
 let p=b.allocate(12)?;if p!=0 {for (o,v) in [(0,HANDLER_VTABLE),(4,owner),(8,method)] {Storage::write_word(b,add(p,o)?,v)?;}}Ok(p)
}
pub fn clone_callback<B:Storage+Boundaries>(b:&mut B,source:u32)->Result<u32,Error> {
 let p=b.allocate_callback_clone(12).map_err(Error::Boundary)?;
 if p!=0 {Storage::write_word(b,p,HANDLER_VTABLE)?;let owner=b.word(add(source,4)?)?;Storage::write_word(b,add(p,4)?,owner)?;let method=b.word(add(source,8)?)?;Storage::write_word(b,add(p,8)?,method)?;}Ok(p)
}
pub fn scalar_delete_callback<B:Storage+RemovalBackend>(b:&mut B,p:u32,flags:u32)->Result<u32,Error> {
 Storage::write_word(b,p,0x1084ed4)?;if flags&1!=0 {let route=b.deallocator()?;b.free(p,route)?;}Ok(p)
}
fn dispatch_delete<B:Storage+RemovalBackend>(b:&mut B,p:u32)->Result<(),Error> {
 if p!=0 {let vt=b.word(p)?;let callback=b.word(vt)?;if callback!=HANDLER_DELETE {return Err(Error::UnknownCallback(callback));}scalar_delete_callback(b,p,1)?;}Ok(())
}
fn listener_construct<B:Storage+RemovalBackend+Boundaries>(b:&mut B,base:u32,method:u32)->Result<(),Error> {
 Storage::write_word(b,base,0x109b308)?;let field=add(base,4)?;Storage::write_word(b,field,0)?;
 let temp=callback_new(b,base,0x65ee40)?;
 let cloned=if temp==0 {0} else {let vt=b.word(temp)?;let callback=b.word(add(vt,4)?)?;if callback!=HANDLER_CLONE {return Err(Error::UnknownCallback(callback));}clone_callback(b,temp)?};
 let old=b.word(field)?;Storage::write_word(b,field,0)?;Storage::write_word(b,field,cloned)?;dispatch_delete(b,old)?;dispatch_delete(b,temp)?;
 let service=b.word(SERVICE_GLOBAL)?;
 if service!=0 {let mut temp=callback_new(b,base,method)?;let vt=b.word(service)?;let callback=b.word(add(vt,0x84)?)?;b.register_listener(service,callback,field,&mut temp).map_err(Error::Boundary)?;dispatch_delete(b,temp)?;}Ok(())
}
pub fn construct<B:Storage+RemovalBackend+Boundaries>(b:&mut B,metadata:u32,actor:u32,owner_storage:u32)->Result<u32,Error> {
 for (offset,method) in [(0,0x6b9680),(8,0x6b96c0),(16,0x6b9700),(24,0x6b9740)] {listener_construct(b,add(metadata,offset)?,method)?;}
 for (offset,value) in [(8,0x10a036c),(16,0x10a0378),(24,0x10a0360),(32,actor),(48,owner_storage),(0,VTABLE)] {Storage::write_word(b,add(metadata,offset)?,value)?;}
 b.write_byte(add(metadata,36)?,0)?;b.write_byte(add(metadata,37)?,0)?;Storage::write_word(b,add(metadata,40)?,0)?;b.write_byte(add(metadata,44)?,0)?;
 let default=b.word(0x123b12c)?;Storage::write_word(b,add(metadata,52)?,default)?;Ok(metadata)
}
pub fn destroy<B:Storage+RemovalBackend+Boundaries>(b:&mut B,metadata:u32)->Result<(),Error> {
 let mut service=0;
 for offset in [24,16,8,0] {
  let base=add(metadata,offset)?;Storage::write_word(b,base,0x109b308)?;let field=add(base,4)?;
  if offset==24 {service=b.word(SERVICE_GLOBAL)?;}
  if service!=0 {let vt=b.word(service)?;let callback=b.word(add(vt,0x88)?)?;b.unregister_listener(service,callback,field).map_err(Error::Boundary)?;if offset!=0 {service=b.word(SERVICE_GLOBAL)?;}}
  let handler=b.word(field)?;dispatch_delete(b,handler)?;if handler!=0 && offset!=0 {service=b.word(SERVICE_GLOBAL)?;}
 }Ok(())
}
pub fn scalar_delete<B:Storage+RemovalBackend+Boundaries>(b:&mut B,metadata:u32,flags:u32)->Result<u32,Error> {
 destroy(b,metadata)?;if flags&1!=0 {let route=b.deallocator()?;b.free(metadata,route)?;}Ok(metadata)
}
#[cfg(test)] mod tests {
 use super::*;
 struct Owned {memory:init::OwnedMemory,allocations:Vec<serde_json::Value>,mode:u32,events:Vec<serde_json::Value>,gate:u32,metadata:u32,diagnostics:Vec<serde_json::Value>}
 impl Memory for Owned {fn word(&mut self,a:u32)->Result<u32,lookup::Error> {self.memory.word(a)}}
 impl Storage for Owned {
  fn allocate(&mut self,n:u32)->Result<u32,init::Error> {let p=self.memory.allocate(n)?;self.allocations.push(serde_json::json!({"bytes":n,"pointer":p}));Ok(p)}
  fn write_word(&mut self,a:u32,v:u32)->Result<(),init::Error> {Storage::write_word(&mut self.memory,a,v)}
  fn write_byte(&mut self,a:u32,v:u8)->Result<(),init::Error> {self.memory.write_byte(a,v)}
  fn register_shutdown(&mut self,c:u32)->Result<(),init::Error> {self.memory.register_shutdown(c)}
 }
 impl RemovalBackend for Owned {
  fn write_word(&mut self,a:u32,v:u32)->Result<(),remove::Error> {Storage::write_word(&mut self.memory,a,v).map_err(remove::Error::Owned)}
  fn deallocator(&mut self)->Result<remove::Deallocator,remove::Error> {Ok(remove::Deallocator::Standard)}
  fn free(&mut self,a:u32,_:remove::Deallocator)->Result<(),remove::Error> {self.memory.release(a).map_err(remove::Error::Owned)}
 }
 impl Boundaries for Owned {
  fn allocate_callback_clone(&mut self,n:u32)->Result<u32,&'static str> {let p=self.memory.allocate(n).map_err(|_|"allocation failed")?;self.allocations.push(serde_json::json!({"bytes":n,"pointer":p,"allocator":if self.mode>=4 {"engine_operator_new"} else {"callback_clone_new"}}));Ok(p)}
  fn register_listener(&mut self,s:u32,c:u32,field:u32,temp:&mut u32)->Result<(),&'static str> {if self.mode>=4 {assert_eq!(c,0x72c610);return crate::audio_announcer_pending_service::register_virtual(self,s,c,field,*temp).map_err(|_|"pending registration failed");}assert_eq!(s,0x30006000);assert_eq!(c,0x32001000);let handler=self.word(field).unwrap();let owner=self.word(*temp+4).unwrap();let method=self.word(*temp+8).unwrap();self.events.push(serde_json::json!({"op":"register","field":field,"handler":handler,"temporary":*temp,"owner":owner,"method":method}));if self.mode==1 {Storage::write_word(self,SERVICE_GLOBAL,0).unwrap();}Ok(())}
  fn unregister_listener(&mut self,s:u32,c:u32,field:u32)->Result<(),&'static str> {if self.mode>=4 {assert_eq!(c,0x72c620);return crate::audio_announcer_pending_service::unregister_virtual(self,s,c,field).map_err(|_|"pending removal failed");}assert_eq!(s,0x30006000);assert_eq!(c,0x32001100);let handler=self.word(field).unwrap();self.events.push(serde_json::json!({"op":"unregister","field":field,"handler":handler}));if self.mode==2 {Storage::write_word(self,SERVICE_GLOBAL,0).unwrap();}Ok(())}
 }
 fn compare(b:&mut Owned,words:&serde_json::Value) {for w in words.as_array().unwrap() {assert_eq!(b.word(w[0].as_u64().unwrap() as u32).unwrap(),w[1].as_u64().unwrap() as u32,"{w}");}}
 #[test] fn audio_owner_metadata_matches96_native_construction_and_real_scalar_destruction_lifetimes() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_owner_metadata_lifecycle_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),96);
  for c in cases {
   let mut b=Owned {memory:init::OwnedMemory::new(0x34000000,c["poison"].as_u64().unwrap() as u8),allocations:vec![],mode:0,events:vec![],gate:0,metadata:0,diagnostics:vec![]};
   for (a,n) in [(HANDLER_VTABLE,12),(SERVICE_GLOBAL,4),(0x123b12c,4)] {b.memory.reserve_at(a,n).unwrap();}
   for (a,v) in [(HANDLER_VTABLE,HANDLER_DELETE),(HANDLER_VTABLE+4,HANDLER_CLONE),(SERVICE_GLOBAL,0),(0x123b12c,c["global_value"].as_u64().unwrap() as u32)] {Storage::write_word(&mut b,a,v).unwrap();}
   let p=b.allocate(56).unwrap();assert_eq!(p,c["metadata"].as_u64().unwrap() as u32);assert_eq!(construct(&mut b,p,c["actor_argument"].as_u64().unwrap() as u32,c["owner_argument"].as_u64().unwrap() as u32).unwrap(),p);
   assert_eq!(serde_json::json!(b.allocations),c["constructor_allocations"]);assert_eq!(serde_json::json!(b.memory.released_labels),c["constructor_freed"]);compare(&mut b,&c["constructed_words"]);compare(&mut b,&c["handler_words"]);
   b.allocations.clear();b.memory.released_labels.clear();assert_eq!(scalar_delete(&mut b,p,c["flags"].as_u64().unwrap() as u32).unwrap(),c["result"].as_u64().unwrap() as u32);assert_eq!(serde_json::json!(b.memory.released_labels),c["destructor_freed"]);assert_eq!(serde_json::json!(b.allocations),c["destructor_allocations"]);compare(&mut b,&c["live_words"]);
   for field in [4,12,20,28] {let pointer=c["constructed_words"][(field/4) as usize][1].as_u64().unwrap() as u32;assert!(matches!(b.word(pointer),Err(lookup::Error::MissingWord(_))));}if c["flags"].as_u64().unwrap()&1!=0 {assert!(matches!(b.word(p),Err(lookup::Error::MissingWord(_))));}
  }
 }
 #[test] fn audio_owner_metadata_matches24_native_service_boundary_lifetimes_and_global_mutations() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_owner_metadata_service_boundary_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),24);
  for c in cases {
   let mut b=Owned {memory:init::OwnedMemory::new(0x34000000,c["poison"].as_u64().unwrap() as u8),allocations:vec![],mode:c["mode"].as_u64().unwrap() as u32,events:vec![],gate:0,metadata:0,diagnostics:vec![]};
   for (a,n) in [(HANDLER_VTABLE,12),(SERVICE_GLOBAL,4),(0x123b12c,4),(0x30006000,4),(0x30006100,0x8c)] {b.memory.reserve_at(a,n).unwrap();}
   for (a,v) in [(HANDLER_VTABLE,HANDLER_DELETE),(HANDLER_VTABLE+4,HANDLER_CLONE),(SERVICE_GLOBAL,0x30006000),(0x30006000,0x30006100),(0x30006184,0x32001000),(0x30006188,0x32001100),(0x123b12c,0x3f800000)] {Storage::write_word(&mut b,a,v).unwrap();}
   let p=b.allocate(56).unwrap();construct(&mut b,p,0x30004000,0x30005600).unwrap();compare(&mut b,&c["constructed_words"]);assert_eq!(serde_json::json!(b.allocations),c["constructor_allocations"]);assert_eq!(serde_json::json!(b.memory.released_labels),c["constructor_freed"]);assert_eq!(serde_json::json!(b.events),c["constructor_events"]);
   b.allocations.clear();b.memory.released_labels.clear();b.events.clear();scalar_delete(&mut b,p,c["flags"].as_u64().unwrap() as u32).unwrap();assert_eq!(serde_json::json!(b.events),c["destructor_events"]);assert_eq!(serde_json::json!(b.memory.released_labels),c["destructor_freed"]);assert!(b.allocations.is_empty());assert_eq!(b.word(SERVICE_GLOBAL).unwrap(),c["final_service"].as_u64().unwrap() as u32);compare(&mut b,&c["live_words"]);
  }
 }
 impl crate::audio_announcer_metadata_callbacks::ConsumerBoundary for Owned {
  fn byte(&mut self,a:u32)->Result<u8,lookup::Error> {self.memory.read_byte(a)}
  fn service_gate(&mut self,service:u32,callback:u32)->Result<u32,&'static str> {assert_eq!(service,0x30006000);if callback==0x718ad0 {return self.memory.read_byte(service+0x122).map(u32::from).map_err(|_|"missing native service flag");}assert_eq!(callback,0x32001200);self.events.push(serde_json::json!({"op":"gate","value":self.gate}));Ok(self.gate)}
  fn actor_call(&mut self,actor:u32,callback:u32)->Result<(),&'static str> {assert_eq!(actor,0x30004000);let slot=match callback {0x32001300=>0x24,0x32001400=>0x2c,_=>panic!("unknown actor callback")};let flags=self.word(self.metadata+36).unwrap();if self.mode==5 {self.events.push(serde_json::json!({"slot":slot,"flags_word":flags}));} else {self.events.push(serde_json::json!({"op":"actor","slot":slot,"flags_word":flags}));}Ok(())}
  fn diagnostic(&mut self,args:[u32;5])->Result<(),&'static str> {self.diagnostics.push(serde_json::json!(args));Ok(())}
 }
 fn callback_owned(poison:u8)->Owned {
  let mut b=Owned {memory:init::OwnedMemory::new(0x34000000,poison),allocations:vec![],mode:0,events:vec![],gate:0,metadata:0,diagnostics:vec![]};
  for (a,n) in [(HANDLER_VTABLE,12),(SERVICE_GLOBAL,4),(0x123b12c,4),(0x2d5f448,4),(0x30005600,0x100),(0x30007800,20),(0x10a0360,48),(0x30006000,0x188),(0x30006300,0xb4),(0x30004000,4),(0x30004100,0x30)] {b.memory.reserve_at(a,n).unwrap();}
  for (a,v) in [(HANDLER_VTABLE,HANDLER_DELETE),(HANDLER_VTABLE+4,HANDLER_CLONE),(SERVICE_GLOBAL,0),(0x123b12c,0),(0x10a0388,0x6b28a0),(0x10a0370,0x6bd80d),(0x10a037c,0x6bd7ed),(0x10a0364,0x6bd7fd),(0x10a038c,0x6b27a0),(0x10a0374,0x6b27d0),(0x10a0380,0x6b2800),(0x10a0368,0x6b2850),(0x30006000,0x30006300),(0x300063b0,0x32001200),(0x30004000,0x30004100),(0x30004124,0x32001300),(0x3000412c,0x32001400)] {Storage::write_word(&mut b,a,v).unwrap();}b
 }
 #[test] fn audio_owner_metadata_callbacks_match48_native_descriptors_with_actual_owner_getters_and_thunks() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_owner_metadata_descriptor_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),48);
  for c in cases {
   let mut b=callback_owned(c["poison"].as_u64().unwrap() as u8);Storage::write_word(&mut b,0x30005600,c["owner_id"].as_u64().unwrap() as u32).unwrap();Storage::write_word(&mut b,0x2d5f448,c["sentinel"].as_u64().unwrap() as u32).unwrap();let p=b.allocate(56).unwrap();construct(&mut b,p,0x30004000,0x30005600).unwrap();let handler=callback_new(&mut b,p+c["offset"].as_u64().unwrap() as u32,c["method"].as_u64().unwrap() as u32).unwrap();assert_eq!(handler,c["callback"].as_u64().unwrap() as u32);
   b.allocations.clear();b.memory.released_labels.clear();assert_eq!(crate::audio_announcer_metadata_callbacks::invoke(&mut b,handler,0x30007800).unwrap(),c["return_al"].as_u64().unwrap() as u8);let packet:String=(0..20).map(|i|format!("{:02x}",b.memory.read_byte(0x30007800+i).unwrap())).collect();assert_eq!(packet,c["packet_after"].as_str().unwrap());assert!(b.allocations.is_empty());assert!(b.memory.released_labels.is_empty());
  }
 }
 #[test] fn audio_owner_metadata_callbacks_match432_native_full_consumer_dispatches() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_owner_metadata_consumer_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),432);
  for c in cases {
   let mut b=callback_owned(c["poison"].as_u64().unwrap() as u8);let p=b.allocate(56).unwrap();construct(&mut b,p,0x30004000,0x30005600).unwrap();b.metadata=p;b.gate=c["gate"].as_u64().unwrap() as u32;Storage::write_word(&mut b,p+36,0xa5a5ffff).unwrap();Storage::write_word(&mut b,p+40,c["mask"].as_u64().unwrap() as u32).unwrap();Storage::write_word(&mut b,SERVICE_GLOBAL,0x30006000).unwrap();b.write_byte(0x30007805,c["index"].as_u64().unwrap() as u8).unwrap();let handler=b.word(p+c["offset"].as_u64().unwrap() as u32+4).unwrap();assert_eq!(handler,c["handler"].as_u64().unwrap() as u32);
   b.allocations.clear();b.memory.released_labels.clear();assert_eq!(crate::audio_announcer_metadata_callbacks::invoke(&mut b,handler,0x30007800).unwrap(),1);assert_eq!(serde_json::json!(b.events),c["events"]);assert_eq!(serde_json::json!(b.diagnostics),c["diagnostics"]);assert_eq!(b.word(p+36).unwrap(),c["flags_word"].as_u64().unwrap() as u32);assert_eq!(b.word(p+40).unwrap(),c["result_mask"].as_u64().unwrap() as u32);assert!(b.allocations.is_empty());assert!(b.memory.released_labels.is_empty());
  }
 }

 impl crate::audio_announcer_pending_service::PendingBoundary for Owned {
  fn allocate_engine(&mut self,n:u32)->Result<u32,&'static str> {let p=self.memory.allocate(n).map_err(|_|"engine allocation failed")?;self.allocations.push(serde_json::json!({"bytes":n,"pointer":p,"allocator":"engine_operator_new"}));Ok(p)}
  fn allocate_pointer_array(&mut self,n:u32)->Result<u32,&'static str> {let bytes=n.checked_mul(4).ok_or("array size overflow")?;let p=self.memory.allocate(bytes).map_err(|_|"pointer array allocation failed")?;self.allocations.push(serde_json::json!({"bytes":bytes,"pointer":p,"allocator":"owner_pointer_array"}));Ok(p)}
  fn remove_active_listener(&mut self,registry:u32,field:u32)->Result<(),&'static str> {crate::audio_announcer_active_service::remove_active(self,registry,field).map_err(|_|"active registry removal failed")}
 }
 #[test] fn audio_owner_metadata_matches16_real_native_pending_service_lifetimes_with_owned_storage() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_owner_metadata_real_pending_service_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),16);
  for c in cases {
   let mut b=Owned {memory:init::OwnedMemory::new(0x34000000,c["poison"].as_u64().unwrap() as u8),allocations:vec![],mode:4,events:vec![],gate:0,metadata:0,diagnostics:vec![]};
   for (a,n) in [(HANDLER_VTABLE,12),(SERVICE_GLOBAL,4),(0x123b12c,4),(0x30005600,4),(0x30006000,0x188),(0x10afe8c,0x8c)] {b.memory.reserve_at(a,n).unwrap();}
   for (a,v) in [(HANDLER_VTABLE,HANDLER_DELETE),(HANDLER_VTABLE+4,HANDLER_CLONE),(SERVICE_GLOBAL,0x30006000),(0x30006000,0x10afe8c),(0x10aff10,0x72c610),(0x10aff14,0x72c620),(0x3000600c,0),(0x30006010,0),(0x30006014,0),(0x123b12c,0x3f800000),(0x30005600,c["owner_id"].as_u64().unwrap() as u32)] {Storage::write_word(&mut b,a,v).unwrap();}
   let p=b.allocate(56).unwrap();assert_eq!(p,c["metadata"].as_u64().unwrap() as u32);construct(&mut b,p,0x30004000,0x30005600).unwrap();assert_eq!(serde_json::json!(b.allocations),c["constructor_allocations"]);assert_eq!(serde_json::json!(b.memory.released_labels),c["constructor_freed"]);compare(&mut b,&c["constructed_words"]);compare(&mut b,&c["pending_words"]);
   b.allocations.clear();b.memory.released_labels.clear();scalar_delete(&mut b,p,c["flags"].as_u64().unwrap() as u32).unwrap();assert_eq!(serde_json::json!(b.memory.released_labels),c["destructor_freed"]);assert_eq!(serde_json::json!(b.allocations),c["destructor_allocations"]);compare(&mut b,&c["empty_pending_words"]);compare(&mut b,&c["live_words"]);
   for label in b.memory.released_labels.clone() {assert!(matches!(b.word(label),Err(lookup::Error::MissingWord(_))));}
  }
 }

 #[test] fn audio_pending_service_matches52_native_registrations_and52_removals_with_duplicates_and_null_descriptors() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_pending_service_sequences_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),10);
  for c in cases {
   let mut b=Owned {memory:init::OwnedMemory::new(0x34000000,c["poison"].as_u64().unwrap() as u8),allocations:vec![],mode:4,events:vec![],gate:0,metadata:0,diagnostics:vec![]};
   for (a,n) in [(HANDLER_VTABLE,12),(SERVICE_GLOBAL,4),(0x123b12c,4),(0x30006000,0x188)] {b.memory.reserve_at(a,n).unwrap();}
   for (a,v) in [(HANDLER_VTABLE,HANDLER_DELETE),(HANDLER_VTABLE+4,HANDLER_CLONE),(SERVICE_GLOBAL,0),(0x123b12c,0),(0x30006000,0x10afe8c),(0x3000600c,0),(0x30006010,0),(0x30006014,0)] {Storage::write_word(&mut b,a,v).unwrap();}
   let p=b.allocate(56).unwrap();construct(&mut b,p,0x30004000,0x30005600).unwrap();assert_eq!(p,c["metadata"].as_u64().unwrap() as u32);
   for step in c["steps"].as_array().unwrap() {
    b.allocations.clear();b.memory.released_labels.clear();let field=step["field"].as_u64().unwrap() as u32;
    if step["op"]=="register" {let index=step["index"].as_u64().unwrap() as usize;let temporary=if index%3==0 {0} else {callback_new(&mut b,p+((index%4)*8) as u32,[0x6b9680,0x6b96c0,0x6b9700,0x6b9740][index%4]).unwrap()};assert_eq!(temporary,step["temporary"].as_u64().unwrap() as u32);crate::audio_announcer_pending_service::register_virtual(&mut b,0x30006000,0x72c610,field,temporary).unwrap();dispatch_delete(&mut b,temporary).unwrap();}
    else {crate::audio_announcer_pending_service::unregister_virtual(&mut b,0x30006000,0x72c620,field).unwrap();}
    assert_eq!(serde_json::json!(b.allocations),step["allocations"]);assert_eq!(serde_json::json!(b.memory.released_labels),step["freed"]);compare(&mut b,&step["pending_words"]);
   }
  }
 }

 #[test] fn audio_active_service_registry_construction_matches4_native_layouts_and16_missing_removals() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_active_service_initialization_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),4);
  for c in cases {
   let mut b=Owned {memory:init::OwnedMemory::new(0x34000000,c["poison"].as_u64().unwrap() as u8),allocations:vec![],mode:4,events:vec![],gate:0,metadata:0,diagnostics:vec![]};let service=c["service"].as_u64().unwrap() as u32;b.memory.reserve_at(service,0x188).unwrap();Storage::write_word(&mut b,service,0x10afe8c).unwrap();for i in [12,16,20] {Storage::write_word(&mut b,service+i,0).unwrap();}
   crate::audio_announcer_active_service::construct(&mut b,service,c["opaque_byte"].as_u64().unwrap() as u8).unwrap();assert_eq!(serde_json::json!(b.allocations),c["allocations"]);assert_eq!(serde_json::json!(b.memory.released_labels),c["freed"]);compare(&mut b,&c["words"]);
   for q in c["missing_queries"].as_array().unwrap() {b.allocations.clear();b.memory.released_labels.clear();crate::audio_announcer_pending_service::unregister_virtual(&mut b,service,0x72c620,q["field"].as_u64().unwrap() as u32).unwrap();assert_eq!(serde_json::json!(b.allocations),q["allocations"]);assert_eq!(serde_json::json!(b.memory.released_labels),q["freed"]);compare(&mut b,&c["words"]);}
  }
 }
 #[test] fn audio_active_service_removal_matches32_native_pending_matching_active_and_repeated_missing_calls() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_active_service_removals_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),4);
  for c in cases {
   let mut b=Owned {memory:init::OwnedMemory::new(0x35000000,c["poison"].as_u64().unwrap() as u8),allocations:vec![],mode:4,events:vec![],gate:0,metadata:0,diagnostics:vec![]};let service=c["service"].as_u64().unwrap() as u32;b.memory.reserve_at(service,0x188).unwrap();b.memory.reserve_at(HANDLER_VTABLE,12).unwrap();Storage::write_word(&mut b,HANDLER_VTABLE,HANDLER_DELETE).unwrap();
   for block in c["owned_blocks"].as_array().unwrap() {b.memory.reserve_at(block[0].as_u64().unwrap() as u32,block[1].as_u64().unwrap() as u32).unwrap();}for word in c["initial"]["words"].as_array().unwrap() {Storage::write_word(&mut b,word[0].as_u64().unwrap() as u32,word[1].as_u64().unwrap() as u32).unwrap();}
   for step in c["steps"].as_array().unwrap() {b.allocations.clear();b.memory.released_labels.clear();crate::audio_announcer_pending_service::unregister_virtual(&mut b,service,0x72c620,step["field"].as_u64().unwrap() as u32).unwrap();assert_eq!(serde_json::json!(b.allocations),step["state"]["allocations"]);assert_eq!(serde_json::json!(b.memory.released_labels),step["state"]["freed"]);compare(&mut b,&step["state"]["words"]);for label in b.memory.released_labels.clone() {assert!(matches!(b.word(label),Err(lookup::Error::MissingWord(_))));}}
  }
 }
 #[test] fn audio_active_service_removal_matches64_native_shared_and_distinct_owner_calls() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_shared_active_service_removals_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),4);
  for c in cases {
   let mut b=Owned {memory:init::OwnedMemory::new(0x35000000,c["poison"].as_u64().unwrap() as u8),allocations:vec![],mode:4,events:vec![],gate:0,metadata:0,diagnostics:vec![]};let service=c["service"].as_u64().unwrap() as u32;b.memory.reserve_at(service,0x188).unwrap();b.memory.reserve_at(HANDLER_VTABLE,12).unwrap();Storage::write_word(&mut b,HANDLER_VTABLE,HANDLER_DELETE).unwrap();
   for block in c["owned_blocks"].as_array().unwrap() {b.memory.reserve_at(block[0].as_u64().unwrap() as u32,block[1].as_u64().unwrap() as u32).unwrap();}for word in c["initial"]["words"].as_array().unwrap() {Storage::write_word(&mut b,word[0].as_u64().unwrap() as u32,word[1].as_u64().unwrap() as u32).unwrap();}
   for step in c["steps"].as_array().unwrap() {b.allocations.clear();b.memory.released_labels.clear();crate::audio_announcer_pending_service::unregister_virtual(&mut b,service,0x72c620,step["field"].as_u64().unwrap() as u32).unwrap();assert_eq!(serde_json::json!(b.allocations),step["state"]["allocations"]);assert_eq!(serde_json::json!(b.memory.released_labels),step["state"]["freed"]);compare(&mut b,&step["state"]["words"]);for label in b.memory.released_labels.clone() {assert!(matches!(b.word(label),Err(lookup::Error::MissingWord(_))));}}
  }
 }

 fn compare_state(b:&mut Owned,state:&serde_json::Value) {assert_eq!(serde_json::json!(b.allocations),state["allocations"]);assert_eq!(serde_json::json!(b.memory.released_labels),state["freed"]);compare(b,&state["words"]);b.allocations.clear();b.memory.released_labels.clear();}
 #[test] fn audio_service_activation_dispatch_and_metadata_teardown_match8_native_lifetimes32_events() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_active_service_lifetimes_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),8);
  for c in cases {
   let mut b=callback_owned(c["poison"].as_u64().unwrap() as u8);b.mode=5;b.memory.reserve_at(0x10afe8c,0xb4).unwrap();b.memory.reserve_at(0x30007900,20).unwrap();b.memory.reserve_at(0x3000a000,12).unwrap();
   for (a,v) in [(HANDLER_VTABLE+8,0x5cce30),(0x30006000,0x10afe8c),(0x10aff10,0x72c610),(0x10aff14,0x72c620),(0x10aff3c,0x718ad0),(0x3000600c,0),(0x30006010,0),(0x30006014,0)] {Storage::write_word(&mut b,a,v).unwrap();}
   crate::audio_announcer_active_service::construct(&mut b,0x30006000,c["poison"].as_u64().unwrap() as u8).unwrap();compare_state(&mut b,&c["initial"]);
   Storage::write_word(&mut b,SERVICE_GLOBAL,0x30006000).unwrap();Storage::write_word(&mut b,0x123b12c,0x3f800000).unwrap();Storage::write_word(&mut b,0x2d5f448,u32::MAX).unwrap();Storage::write_word(&mut b,0x30005600,c["owner_id"].as_u64().unwrap() as u32).unwrap();b.write_byte(0x30006122,c["gate"].as_u64().unwrap() as u8).unwrap();let p=b.allocate(56).unwrap();b.metadata=p;construct(&mut b,p,0x30004000,0x30005600).unwrap();compare_state(&mut b,&c["created"]);
   let hex=c["activation_packets"][0].as_str().unwrap();let mut bytes=[0u8;4];for i in 0..4 {bytes[i]=u8::from_str_radix(&hex[16+i*2..18+i*2],16).unwrap();}Storage::write_word(&mut b,0x3000a008,u32::from_le_bytes(bytes)).unwrap();
   crate::audio_announcer_service_activation::activate(&mut b,0x30006000,0x3000a000).unwrap();compare_state(&mut b,&c["activated"]);
   for d in c["dispatches"].as_array().unwrap() {Storage::write_word(&mut b,0x30007800,c["owner_id"].as_u64().unwrap() as u32).unwrap();let code=d["event_code"].as_u64().unwrap() as u16;b.write_byte(0x30007808,code as u8).unwrap();b.write_byte(0x30007809,(code>>8) as u8).unwrap();b.write_byte(0x30007905,3).unwrap();b.events.clear();assert_eq!(crate::audio_announcer_service_activation::dispatch(&mut b,0x30006000,0x30007800,0x30007900).unwrap(),d["return_al"].as_u64().unwrap() as u8);assert_eq!(serde_json::json!(b.events),d["actor_events"]);compare_state(&mut b,&d["state"]);}
   scalar_delete(&mut b,p,1).unwrap();compare_state(&mut b,&c["destroyed"]);assert!(matches!(b.word(p),Err(lookup::Error::MissingWord(_))));
  }
 }

 #[test] fn audio_service_activation_growth_matches8_native_sequences44_metadata_components() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_service_activation_growth_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),8);
  for c in cases {
   let mut b=callback_owned(c["poison"].as_u64().unwrap() as u8);b.mode=5;b.memory.reserve_at(0x10afe8c,0xb4).unwrap();b.memory.reserve_at(0x30007900,20).unwrap();b.memory.reserve_at(0x3000a000,12).unwrap();
   for (a,v) in [(HANDLER_VTABLE+8,0x5cce30),(0x30006000,0x10afe8c),(0x10aff10,0x72c610),(0x10aff14,0x72c620),(0x10aff3c,0x718ad0),(0x3000600c,0),(0x30006010,0),(0x30006014,0)] {Storage::write_word(&mut b,a,v).unwrap();}
   crate::audio_announcer_active_service::construct(&mut b,0x30006000,c["poison"].as_u64().unwrap() as u8).unwrap();compare_state(&mut b,&c["initial"]);

   Storage::write_word(&mut b,SERVICE_GLOBAL,0x30006000).unwrap();Storage::write_word(&mut b,0x123b12c,0x3f800000).unwrap();Storage::write_word(&mut b,0x2d5f448,u32::MAX).unwrap();
   let count=c["count"].as_u64().unwrap() as u32;let mut labels=vec![];
   for i in 0..count {let storage=0x30005600+i*4;Storage::write_word(&mut b,storage,if c["shared_owner"].as_bool().unwrap(){42}else{42+i}).unwrap();let p=b.allocate(56).unwrap();construct(&mut b,p,0x30004000,storage).unwrap();labels.push(p);}
   assert_eq!(serde_json::json!(labels),c["metadata_labels"]);compare_state(&mut b,&c["created"]);
   let hex=c["activation_packets"][0].as_str().unwrap();let mut bytes=[0u8;4];for i in 0..4 {bytes[i]=u8::from_str_radix(&hex[16+i*2..18+i*2],16).unwrap();}Storage::write_word(&mut b,0x3000a008,u32::from_le_bytes(bytes)).unwrap();
   crate::audio_announcer_service_activation::activate(&mut b,0x30006000,0x3000a000).unwrap();compare_state(&mut b,&c["activated"]);
   for (p,state) in labels.into_iter().zip(c["destroyed_steps"].as_array().unwrap()) {scalar_delete(&mut b,p,1).unwrap();compare_state(&mut b,state);}
  }
 }
 #[test] fn audio_service_member_teardown_matches8_native_sequences36_metadata_components() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_service_member_teardown_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),8);
  for c in cases {
   let mut b=callback_owned(c["poison"].as_u64().unwrap() as u8);b.mode=5;b.memory.reserve_at(0x10afe8c,0xb4).unwrap();b.memory.reserve_at(0x30007900,20).unwrap();b.memory.reserve_at(0x3000a000,12).unwrap();
   for (a,v) in [(HANDLER_VTABLE+8,0x5cce30),(0x30006000,0x10afe8c),(0x10aff10,0x72c610),(0x10aff14,0x72c620),(0x10aff3c,0x718ad0),(0x3000600c,0),(0x30006010,0),(0x30006014,0)] {Storage::write_word(&mut b,a,v).unwrap();}
   crate::audio_announcer_active_service::construct(&mut b,0x30006000,c["poison"].as_u64().unwrap() as u8).unwrap();compare_state(&mut b,&c["initial"]);

   Storage::write_word(&mut b,SERVICE_GLOBAL,0x30006000).unwrap();Storage::write_word(&mut b,0x123b12c,0x3f800000).unwrap();Storage::write_word(&mut b,0x2d5f448,u32::MAX).unwrap();
   let count=c["count"].as_u64().unwrap() as u32;let mut labels=vec![];
   for i in 0..count {let storage=0x30005600+i*4;Storage::write_word(&mut b,storage,if c["shared_owner"].as_bool().unwrap(){42}else{42+i}).unwrap();let p=b.allocate(56).unwrap();construct(&mut b,p,0x30004000,storage).unwrap();labels.push(p);}
   assert_eq!(serde_json::json!(labels),c["metadata_labels"]);compare_state(&mut b,&c["created"]);
   if let Some(hex)=c["activation_packets"][0].as_str() {let mut bytes=[0u8;4];for i in 0..4 {bytes[i]=u8::from_str_radix(&hex[16+i*2..18+i*2],16).unwrap();}Storage::write_word(&mut b,0x3000a008,u32::from_le_bytes(bytes)).unwrap();}
   crate::audio_announcer_service_activation::activate(&mut b,0x30006000,0x3000a000).unwrap();compare_state(&mut b,&c["activated"]);
   for (p,state) in labels.into_iter().zip(c["destroyed_steps"].as_array().unwrap()) {scalar_delete(&mut b,p,1).unwrap();compare_state(&mut b,state);}
   compare_state(&mut b,&c["before_service_teardown"]);Storage::write_word(&mut b,SERVICE_GLOBAL,0).unwrap();crate::audio_announcer_service_teardown::destroy_members(&mut b,0x30006000).unwrap();compare_state(&mut b,&c["service_destroyed"]);
  }
 }
 #[test] fn audio_service_member_nonempty_teardown_matches4_native_sequences36_metadata_components() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_service_member_nonempty_teardown_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),4);
  for c in cases {
   let mut b=callback_owned(c["poison"].as_u64().unwrap() as u8);b.mode=5;b.memory.reserve_at(0x10afe8c,0xb4).unwrap();b.memory.reserve_at(0x30007900,20).unwrap();b.memory.reserve_at(0x3000a000,12).unwrap();
   for (a,v) in [(HANDLER_VTABLE+8,0x5cce30),(0x30006000,0x10afe8c),(0x10aff10,0x72c610),(0x10aff14,0x72c620),(0x10aff3c,0x718ad0),(0x3000600c,0),(0x30006010,0),(0x30006014,0)] {Storage::write_word(&mut b,a,v).unwrap();}
   crate::audio_announcer_active_service::construct(&mut b,0x30006000,c["poison"].as_u64().unwrap() as u8).unwrap();compare_state(&mut b,&c["initial"]);

   Storage::write_word(&mut b,SERVICE_GLOBAL,0x30006000).unwrap();Storage::write_word(&mut b,0x123b12c,0x3f800000).unwrap();Storage::write_word(&mut b,0x2d5f448,u32::MAX).unwrap();
   let count=c["count"].as_u64().unwrap() as u32;let mut labels=vec![];
   for i in 0..count {let storage=0x30005600+i*4;Storage::write_word(&mut b,storage,if c["shared_owner"].as_bool().unwrap(){42}else{42+i}).unwrap();let p=b.allocate(56).unwrap();construct(&mut b,p,0x30004000,storage).unwrap();labels.push(p);}
   assert_eq!(serde_json::json!(labels),c["metadata_labels"]);compare_state(&mut b,&c["created"]);
   if let Some(hex)=c["activation_packets"][0].as_str() {let mut bytes=[0u8;4];for i in 0..4 {bytes[i]=u8::from_str_radix(&hex[16+i*2..18+i*2],16).unwrap();}Storage::write_word(&mut b,0x3000a008,u32::from_le_bytes(bytes)).unwrap();}
   crate::audio_announcer_service_activation::activate(&mut b,0x30006000,0x3000a000).unwrap();compare_state(&mut b,&c["activated"]);
   compare_state(&mut b,&c["before_service_teardown"]);Storage::write_word(&mut b,SERVICE_GLOBAL,0).unwrap();crate::audio_announcer_service_teardown::destroy_members(&mut b,0x30006000).unwrap();compare_state(&mut b,&c["service_destroyed"]);
   for (p,state) in labels.into_iter().zip(c["destroyed_steps"].as_array().unwrap()) {scalar_delete(&mut b,p,1).unwrap();compare_state(&mut b,state);}
  }
 }

}
