//! Original6653B0/5DE550/5DEAD0 normal-return shutdown with owned storage.
//! Actor values are borrowed labels; table destruction frees nodes, never actors.
use crate::audio_announcer_object_lookup::{self as lookup,Memory};
use crate::audio_announcer_registry_init::{self as init,State};
use crate::audio_announcer_registry_remove::{self as remove,Backend,Deallocator};
use std::collections::BTreeSet;
#[derive(Debug,PartialEq,Eq)]
pub enum Error {Lookup(lookup::Error),Backend(remove::Error),InvalidChain,AddressOverflow}
impl From<lookup::Error> for Error {fn from(e:lookup::Error)->Self {Self::Lookup(e)}}
impl From<remove::Error> for Error {fn from(e:remove::Error)->Self {Self::Backend(e)}}
fn add(a:u32,b:u32)->Result<u32,Error> {a.checked_add(b).ok_or(Error::AddressOverflow)}
fn free(b:&mut impl Backend,label:u32)->Result<(),Error> {let route=b.deallocator()?;b.free(label,route)?;Ok(())}
/// Unlink the whole list and reset count before invoking any node free callback.
/// Native standard route stays cached; custom route is refreshed after each callback.
pub fn clear_nodes(b:&mut impl Backend,manager:u32)->Result<(),Error> {
 let head=b.word(add(manager,4)?)?;if head==0 {return Err(Error::InvalidChain);}
 let mut node=b.word(head)?;b.write_word(head,head)?;
 let head=b.word(add(manager,4)?)?;b.write_word(add(head,4)?,head)?;b.write_word(add(manager,8)?,0)?;
 if node==head {return Ok(());}
 let mut route=b.deallocator()?;let mut seen=BTreeSet::new();
 loop {
  if node==0 || !seen.insert(node) {return Err(Error::InvalidChain);}
  let next=b.word(node)?;b.free(node,route)?;
  if matches!(route,Deallocator::Custom {..}) {route=b.deallocator()?;}
  node=next;let head=b.word(add(manager,4)?)?;if node==head {break;}
 }Ok(())
}
/// Release bucket storage first, then nodes and sentinel, matching5DE550.
/// Manager storage remains owned by the caller until shutdown frees it.
pub fn destroy_table(b:&mut impl Backend,manager:u32)->Result<(),Error> {
 let buckets=b.word(add(manager,12)?)?;
 if buckets!=0 {free(b,buckets)?;for offset in [12,16,20] {b.write_word(add(manager,offset)?,0)?;}}
 clear_nodes(b,manager)?;let head=b.word(add(manager,4)?)?;free(b,head)
}
/// Repeated shutdown still writes the native null manager and initialization flag1.
/// Failed boundaries preserve preceding mutations; native exception unwind is unqualified.
pub fn shutdown(b:&mut impl Backend,state:&mut State)->Result<(),Error> {
 if state.manager!=0 {let manager=state.manager;destroy_table(b,manager)?;free(b,manager)?;}
 state.manager=0;state.initialization_flag=1;Ok(())
}
#[cfg(test)] mod tests {
 use super::*;use init::{OwnedMemory,Storage};use crate::audio_announcer_registry_insert as insert;
 struct Owned {memory:OwnedMemory,route:Deallocator,routes:Vec<serde_json::Value>,manager:u32,last_manager_words:Vec<serde_json::Value>,fail:Option<u32>,events:Vec<serde_json::Value>,transition:Option<String>,nodes:Vec<u32>}
 impl Memory for Owned {fn word(&mut self,a:u32)->Result<u32,lookup::Error> {self.memory.word(a)}}
 impl Backend for Owned {
  fn write_word(&mut self,a:u32,v:u32)->Result<(),remove::Error> {Storage::write_word(&mut self.memory,a,v).map_err(remove::Error::Owned)}
  fn deallocator(&mut self)->Result<Deallocator,remove::Error> {Ok(self.route)}
  fn free(&mut self,p:u32,route:Deallocator)->Result<(),remove::Error> {
   let (custom,context)=match route {Deallocator::Standard=>(false,None),Deallocator::Custom {context,..}=>(true,Some(context))};
   self.events.push(serde_json::json!({"pointer":p,"custom":custom,"context":context}));
   if self.nodes.contains(&p) {match self.transition.as_deref() {
    Some("standard_to_custom")=>self.route=Deallocator::Custom {callback:0x32001000,context:0x3000d000},
    Some("custom_to_standard")=>self.route=Deallocator::Standard,
    Some("changing_context")=>if let Deallocator::Custom {callback,context}=self.route {self.route=Deallocator::Custom {callback,context:context+4};},
    _=>{}
   }}
   if self.fail==Some(p) {return Err(remove::Error::Backend("free boundary failed"));}
   if let Deallocator::Custom {context,..}=route {self.routes.push(serde_json::json!({"pointer":p,"context":context}));}
   if p==self.manager {self.last_manager_words=(4..36).step_by(4).map(|i|serde_json::json!([p+i,self.memory.word(p+i).unwrap()])).collect();}
   self.memory.release(p).map_err(remove::Error::Owned)
  }
 }
 #[test] fn audio_registry_shutdown_matches64_native_calls32_owned_lifetimes() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_registry_shutdown_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),32);let mut calls=0;
  for c in cases {
   let poison=c["poison"].as_u64().unwrap() as u8;let mut state=State {shutdown_flag:1,..State::default()};let mut memory=OwnedMemory::new(0x34000000,poison);
   if let Some(count)=c["initial_count"].as_u64() {init::initialize(&mut state,poison,&mut memory).unwrap();for key in 0..count as u32 {insert::insert(&mut memory,state.manager,key,0x30006000+key*32).unwrap();}}
   assert_eq!(state.manager,c["original_manager"].as_u64().unwrap() as u32);state.initialization_flag=c["initial_flag"].as_u64().unwrap() as u8;
   let mut b=Owned {memory,route:if c["custom_free"].as_bool().unwrap() {Deallocator::Custom {callback:0x32001000,context:0x3000d000}} else {Deallocator::Standard},routes:vec![],manager:state.manager,last_manager_words:vec![],fail:None,events:vec![],transition:None,nodes:vec![]};
   for step in c["steps"].as_array().unwrap() {
    b.memory.released_labels.clear();b.routes.clear();shutdown(&mut b,&mut state).unwrap();
    assert_eq!(state.manager,step["manager"].as_u64().unwrap() as u32);assert_eq!(state.initialization_flag,step["initialization_flag"].as_u64().unwrap() as u8);assert_eq!(state.shutdown_flag,1);
    assert_eq!(serde_json::json!(b.memory.released_labels),step["freed"],"{c}");assert_eq!(serde_json::json!(b.routes),step["custom_routes"]);assert_eq!(serde_json::json!(b.last_manager_words),step["words"]);
    if b.manager!=0 {assert!(matches!(b.memory.word(b.manager),Err(lookup::Error::MissingWord(_))));}calls+=1;
   }
  }assert_eq!(calls,64);
 }
 #[test] fn audio_registry_shutdown_failed_node_free_retains_reset_list_and_published_manager() {
  let mut state=State {shutdown_flag:1,..State::default()};let mut memory=OwnedMemory::new(0x34000000,0);init::initialize(&mut state,0,&mut memory).unwrap();let node=insert::insert(&mut memory,state.manager,42,0x30004000).unwrap().node;let manager=state.manager;
  let mut b=Owned {memory,route:Deallocator::Standard,routes:vec![],manager,last_manager_words:vec![],fail:Some(node),events:vec![],transition:None,nodes:vec![]};
  assert_eq!(shutdown(&mut b,&mut state),Err(Error::Backend(remove::Error::Backend("free boundary failed"))));assert_eq!(state.manager,manager);assert_eq!(state.initialization_flag,0);
  assert_eq!(b.word(manager+12).unwrap(),0);assert_eq!(b.word(manager+16).unwrap(),0);assert_eq!(b.word(manager+20).unwrap(),0);assert_eq!(b.word(manager+8).unwrap(),0);
  let head=b.word(manager+4).unwrap();assert_eq!(b.word(head).unwrap(),head);assert_eq!(b.word(head+4).unwrap(),head);assert_eq!(b.word(node+12).unwrap(),0x30004000);
 }

 #[test] fn audio_registry_shutdown_matches252_native_dynamic_free_route_events12_lifetimes() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_shutdown_routes_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),12);let mut events=0;
  for c in cases {
   let poison=c["poison"].as_u64().unwrap() as u8;let mut state=State {shutdown_flag:1,..State::default()};let mut memory=OwnedMemory::new(0x34000000,poison);init::initialize(&mut state,poison,&mut memory).unwrap();let mut nodes=vec![];
   for key in 0..c["count"].as_u64().unwrap() as u32 {nodes.push(insert::insert(&mut memory,state.manager,key,0x30006000+key*32).unwrap().node);}
   assert_eq!(serde_json::json!(nodes),c["nodes"]);let mode=c["mode"].as_str().unwrap();
   let mut b=Owned {memory,route:if mode=="standard_to_custom" {Deallocator::Standard} else {Deallocator::Custom {callback:0x32001000,context:0x3000d000}},routes:vec![],manager:state.manager,last_manager_words:vec![],fail:None,events:vec![],transition:Some(mode.to_owned()),nodes};
   shutdown(&mut b,&mut state).unwrap();assert_eq!(serde_json::json!(b.events),c["free_events"],"{c}");assert_eq!(state.manager,0);assert_eq!(state.initialization_flag,1);events+=b.events.len();
  }assert_eq!(events,252);
 }
}
