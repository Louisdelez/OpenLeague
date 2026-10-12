//! Normal-return 64DD60 removal of a valid live node from the native registry layout.
use crate::audio_announcer_object_lookup::{self as lookup,Memory};
#[derive(Debug,Clone,PartialEq,Eq)]
pub enum Error { Owned(crate::audio_announcer_registry_init::Error), Storage(lookup::Error), Backend(&'static str), InvalidNode, AddressOverflow }
impl From<lookup::Error> for Error {fn from(value:lookup::Error)->Self {Self::Storage(value)}}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Deallocator {Standard,Custom {callback:u32,context:u32}}
pub trait Backend:Memory {
    fn write_word(&mut self,address:u32,value:u32)->Result<(),Error>;
    /// Native deallocator globals are selected after unlink and count decrement.
    fn deallocator(&mut self)->Result<Deallocator,Error>;
    fn free(&mut self,node:u32,route:Deallocator)->Result<(),Error>;
}
fn add(base:u32,offset:u32)->Result<u32,Error> {base.checked_add(offset).ok_or(Error::AddressOverflow)}
/// Only valid, owned live nodes are qualified. Sentinel/null handles are rejected explicitly.
/// Free errors retain the already-unlinked topology, matching the native call order.
pub fn remove_node(memory:&mut impl Backend,manager:u32,node:u32)->Result<u32,Error> {remove_node_with_hash(memory,manager,node,lookup::Hash::Legacy)}
pub fn remove_node_with_hash(memory:&mut impl Backend,manager:u32,node:u32,hash:lookup::Hash)->Result<u32,Error> {
    if manager==0 || node==0 {return Err(Error::InvalidNode);}
    let head=memory.word(add(manager,4)?)?;
    if node==head {return Err(Error::InvalidNode);}
    let key=memory.word(add(node,8)?)?;
    let mask=memory.word(add(manager,24)?)?;let maximum=memory.word(add(manager,28)?)?;
    let index=lookup::bucket_index_with_hash(key,mask,maximum,hash)?;
    let buckets=memory.word(add(manager,12)?)?;let bucket=add(buckets,index.checked_mul(8).ok_or(Error::AddressOverflow)?)?;
    if memory.word(add(bucket,4)?)?==node {
        if memory.word(bucket)?==node {memory.write_word(bucket,head)?;memory.write_word(add(bucket,4)?,head)?;}
        else {let previous=memory.word(add(node,4)?)?;memory.write_word(add(bucket,4)?,previous)?;}
    } else if memory.word(bucket)?==node {let next=memory.word(node)?;memory.write_word(bucket,next)?;}
    let previous=memory.word(add(node,4)?)?;let next=memory.word(node)?;
    memory.write_word(previous,next)?;
    let current_next=memory.word(node)?;let current_previous=memory.word(add(node,4)?)?;
    memory.write_word(add(current_next,4)?,current_previous)?;
    let count=memory.word(add(manager,8)?)?;memory.write_word(add(manager,8)?,count.wrapping_sub(1))?;
    let route=memory.deallocator()?;memory.free(node,route)?;Ok(next)
}
impl Backend for crate::audio_announcer_registry_init::OwnedMemory {
 fn write_word(&mut self,a:u32,v:u32)->Result<(),Error> {crate::audio_announcer_registry_init::Storage::write_word(self,a,v).map_err(Error::Owned)}
 fn deallocator(&mut self)->Result<Deallocator,Error> {Ok(Deallocator::Standard)}
 fn free(&mut self,node:u32,route:Deallocator)->Result<(),Error> {match route {Deallocator::Standard=>self.release(node).map_err(Error::Owned),Deallocator::Custom {..}=>Err(Error::Backend("custom native deallocator unavailable in owned backend"))}}
}
#[cfg(test)] mod tests {
    use super::*;use std::collections::BTreeMap;
    struct Words {words:BTreeMap<u32,u32>,manager:u32,route:Deallocator,free_calls:Vec<serde_json::Value>,fail_free:bool}
    impl Memory for Words {fn word(&mut self,a:u32)->Result<u32,lookup::Error> {self.words.get(&a).copied().ok_or(lookup::Error::MissingWord(a))}}
    impl Backend for Words {
        fn write_word(&mut self,a:u32,v:u32)->Result<(),Error> {self.words.get_mut(&a).ok_or(Error::Backend("unavailable write storage"))?.clone_from(&v);Ok(())}
        fn deallocator(&mut self)->Result<Deallocator,Error> {Ok(self.route)}
        fn free(&mut self,node:u32,route:Deallocator)->Result<(),Error> {
            let previous=self.word(node+4)?;let next=self.word(node)?;let count=self.word(self.manager+8)?;let previous_next=self.word(previous)?;let next_previous=self.word(next+4)?;
            let (custom,context)=match route {Deallocator::Standard=>(false,None),Deallocator::Custom {context,..}=>(true,Some(context))};
            self.free_calls.push(serde_json::json!({"pointer":node,"custom":custom,"context":context,"count_at_free":count,"previous_next_at_free":previous_next,"next_previous_at_free":next_previous}));
            if self.fail_free {return Err(Error::Backend("free boundary failed"));}
            for offset in [0,4,8,12] {self.words.remove(&(node+offset));}Ok(())
        }
    }
    #[test] fn audio_registry_remove_matches108_native_sequences918_unlinks_and12852_lookups() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_registry_removal_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),108);let mut removed=0;let mut queried=0;
        for case in cases {
            let manager=case["manager"].as_u64().unwrap() as u32;let custom=case["custom_free"].as_bool().unwrap();
            let mut memory=Words {words:case["initial_words"].as_array().unwrap().iter().map(|w|(w[0].as_u64().unwrap() as u32,w[1].as_u64().unwrap() as u32)).collect(),manager,route:if custom {Deallocator::Custom {callback:0x32000600,context:0x13572468}} else {Deallocator::Standard},free_calls:vec![],fail_free:false};
            for step in case["steps"].as_array().unwrap() {
                memory.free_calls.clear();let next=remove_node(&mut memory,manager,step["node"].as_u64().unwrap() as u32).unwrap();assert_eq!(next,step["returned_next"].as_u64().unwrap() as u32);assert_eq!(serde_json::json!(memory.free_calls),step["free_calls"],"{step}");
                for word in step["words"].as_array().unwrap() {assert_eq!(memory.word(word[0].as_u64().unwrap() as u32).unwrap(),word[1].as_u64().unwrap() as u32,"{step}");}
                for query in step["lookups"].as_array().unwrap() {assert_eq!(lookup::lookup_initialized(&mut memory,manager,query["key"].as_u64().unwrap() as u32).unwrap(),query["result"].as_u64().unwrap() as u32);queried+=1;}
                removed+=1;
            }
        }assert_eq!(removed,918);assert_eq!(queried,12852);
    }
    #[test] fn audio_registry_free_failure_preserves_unlink_and_rejects_sentinel() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_registry_removal_contract.json")).unwrap();let case=&proof["cases"][0];let manager=case["manager"].as_u64().unwrap() as u32;
        let mut memory=Words {words:case["initial_words"].as_array().unwrap().iter().map(|w|(w[0].as_u64().unwrap() as u32,w[1].as_u64().unwrap() as u32)).collect(),manager,route:Deallocator::Standard,free_calls:vec![],fail_free:true};
        let head=memory.word(manager+4).unwrap();assert_eq!(remove_node(&mut memory,manager,head),Err(Error::InvalidNode));assert!(memory.free_calls.is_empty());
        let node=case["steps"][0]["node"].as_u64().unwrap() as u32;let before=memory.word(manager+8).unwrap();assert_eq!(remove_node(&mut memory,manager,node),Err(Error::Backend("free boundary failed")));assert_eq!(memory.word(manager+8).unwrap(),before-1);
        assert_eq!(lookup::lookup_initialized(&mut memory,manager,case["steps"][0]["key"].as_u64().unwrap() as u32).unwrap(),0);
    }
}

#[cfg(test)] mod owned_tests {
 use super::*;use crate::audio_announcer_registry_init::{OwnedMemory,State,Storage,initialize};
 #[test] fn audio_registry_owned_node_release_keeps_sentinel_and_missing_lookup_valid() {
  let mut memory=OwnedMemory::new(0x36000000,0);let mut state=State::default();initialize(&mut state,0,&mut memory).unwrap();let manager=state.manager;let head=memory.word(manager+4).unwrap();let buckets=memory.word(manager+12).unwrap();let node=memory.allocate(16).unwrap();
  for (address,value) in [(node,head),(node+4,head),(node+8,42),(node+12,0x30007000),(head,node),(head+4,node),(manager+8,1)] {Storage::write_word(&mut memory,address,value).unwrap();}
  let bucket=buckets+lookup::bucket_index(42,7,8).unwrap()*8;Storage::write_word(&mut memory,bucket,node).unwrap();Storage::write_word(&mut memory,bucket+4,node).unwrap();
  assert_eq!(lookup::lookup_initialized(&mut memory,manager,42).unwrap(),0x30007000);assert_eq!(remove_node(&mut memory,manager,node).unwrap(),head);assert_eq!(lookup::lookup_initialized(&mut memory,manager,42).unwrap(),0);
  assert_eq!(memory.word(node),Err(lookup::Error::MissingWord(node)));assert_eq!(memory.released_labels,vec![node]);assert_eq!(memory.word(head).unwrap(),head);assert_eq!(memory.word(manager+8).unwrap(),0);
 }
}
