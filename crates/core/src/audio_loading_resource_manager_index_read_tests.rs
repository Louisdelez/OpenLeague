use super::*;
use super::super::{Allocation,Phase,retire_empty};
use crate::audio_announcer_object_lookup::{self as read,Memory};
use crate::audio_announcer_registry_init::{self as init,OwnedMemory};
use crate::audio_announcer_registry_remove::{self as removal,Backend as Free,Deallocator};
use crate::audio_replay_metadata as metadata;
use serde_json::{json,Value};
use std::collections::{BTreeMap,VecDeque};

fn n(v:&Value)->u32{v.as_u64().unwrap() as u32}
fn bytes(v:&Value)->Vec<u8>{v.as_str().unwrap().as_bytes().chunks_exact(2).map(|b|u8::from_str_radix(std::str::from_utf8(b).unwrap(),16).unwrap()).collect()}
fn proof()->Value{serde_json::from_str(&crate::audio_test_fixture("data/4.20/loading_resource_index_read_contract.json")).unwrap()}
struct Host {
    memory:OwnedMemory,live:BTreeMap<u32,u32>,queue:VecDeque<Value>,access:Vec<Value>,
    read_count:usize,fail_read:Option<usize>,fail_free_once:bool,freed:Vec<u32>,
}
impl Host {
    fn read(&mut self,p:u32,width:u32)->Result<(),read::Error>{
        self.access.push(json!(["read",p,width]));let index=self.read_count;self.read_count+=1;
        if self.fail_read==Some(index){self.fail_read=None;return Err(read::Error::MissingWord(p));}Ok(())
    }
    fn set(&mut self,p:u32,s:&[u8]){for(i,&v)in s.iter().enumerate(){Storage::write_byte(&mut self.memory,p+i as u32,v).unwrap();}}
    fn raw(&self,p:u32,len:u32)->Vec<u8>{(0..len).map(|i|self.memory.read_byte(p+i).unwrap()).collect()}
    fn reserve(&mut self,p:u32,s:&[u8]){self.memory.reserve_at(p,s.len() as u32).unwrap();self.set(p,s);}
    fn write_events(&mut self,p:u32,s:&[u8]){for(i,&v)in s.iter().enumerate(){self.access.push(json!(["write",p+i as u32,v]));}}
}
impl Memory for Host {
    fn word(&mut self,p:u32)->Result<u32,read::Error>{self.read(p,4)?;self.memory.word(p)}
}
impl Storage for Host {
    fn allocate(&mut self,len:u32)->Result<u32,init::Error>{
        let next=self.queue.pop_front().expect("unexpected index allocation");let p=n(&next["pointer"]);assert_eq!(n(&next["bytes"]),len);
        self.memory.reserve_at(p,len)?;assert!(self.live.insert(p,len).is_none());self.access.push(json!(["allocate",p,len]));Ok(p)
    }
    fn write_word(&mut self,p:u32,v:u32)->Result<(),init::Error>{Storage::write_word(&mut self.memory,p,v)?;self.write_events(p,&v.to_le_bytes());Ok(())}
    fn write_byte(&mut self,p:u32,v:u8)->Result<(),init::Error>{Storage::write_byte(&mut self.memory,p,v)?;self.write_events(p,&[v]);Ok(())}
    fn register_shutdown(&mut self,_:u32)->Result<(),init::Error>{Err(init::Error::Backend("index has no registration"))}
}
impl Free for Host {
    fn write_word(&mut self,p:u32,v:u32)->Result<(),removal::Error>{Storage::write_word(self,p,v).map_err(removal::Error::Owned)}
    fn deallocator(&mut self)->Result<Deallocator,removal::Error>{
        self.read(0x14bef40,4).map_err(removal::Error::Storage)?;Ok(Deallocator::Standard)
    }
    fn free(&mut self,p:u32,route:Deallocator)->Result<(),removal::Error>{
        assert_eq!(route,Deallocator::Standard);
        if self.fail_free_once{self.fail_free_once=false;return Err(removal::Error::Backend("injected atomic index free failure"));}
        assert!(self.live.contains_key(&p),"double free or unowned index allocation");
        self.memory.release(p).map_err(removal::Error::Owned)?;self.live.remove(&p);self.freed.push(p);self.access.push(json!(["free",p]));Ok(())
    }
}
impl metadata::Boundary for Host {
    fn read_byte(&mut self,p:u32)->Result<u8,read::Error>{self.read(p,1)?;self.memory.read_byte(p)}
    fn initialize_lock(&mut self,_:u32)->Result<(),&'static str>{Err("no index mutex")}
    fn destroy_lock(&mut self,_:u32)->Result<(),&'static str>{Err("no index mutex")}
    fn enter_lock(&mut self,_:u32)->Result<(),&'static str>{Err("no index mutex")}
    fn leave_lock(&mut self,_:u32)->Result<(),&'static str>{Err("no index mutex")}
}
impl Boundary for Host {
    fn release_owned(&mut self,p:u32,route:Deallocator)->Result<(),removal::Error>{Free::free(self,p,route)}
}
fn host(case:&Value,call:&Value)->(Host,Record){
    let mut b=Host{memory:OwnedMemory::new(0x38000000,n(&case["fill"]) as u8),live:BTreeMap::new(),
        queue:call["allocations"].as_array().unwrap().iter().cloned().collect(),access:vec![],read_count:0,fail_read:None,fail_free_once:false,freed:vec![]};
    let mut owner=Record::default();owner.pointer=n(&case["manager"]);owner.phase=Phase::Building;
    for block in call["before"]["blocks"].as_array().unwrap(){
        let p=n(&block["pointer"]);let len=n(&block["size"]);b.reserve(p,&bytes(&block["hex"]));assert!(b.live.insert(p,len).is_none());
        owner.allocations[owner.allocation_count]=Allocation{pointer:p,bytes:len,live:true};owner.allocation_count+=1;
    }
    b.reserve(n(&call["key_ref"]),&n(&call["key"]).to_le_bytes());
    b.reserve(super::super::GLOBAL,&n(&call["before"]["global"]).to_le_bytes());
    (b,owner)
}
fn snapshot(b:&Host,value:&Value){
    assert_eq!(b.live.len(),value["blocks"].as_array().unwrap().len());
    for block in value["blocks"].as_array().unwrap(){let p=n(&block["pointer"]);assert_eq!(b.live[&p],n(&block["size"]));assert_eq!(b.raw(p,n(&block["size"])),bytes(&block["hex"]));}
}

#[test]
fn audio_loading_resource_index_matches8_native_insertions_including_exact_read_order(){
    let p=proof();assert_eq!(p["passed"],true);assert_eq!(p["source_sha256"],"402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862");
    let mut insertions=0;let mut reads=0;
    for case in p["cases"].as_array().unwrap(){assert_eq!(case["index_calls"].as_array().unwrap().len(),4);
        for call in case["index_calls"].as_array().unwrap(){
            let (mut b,mut owner)=host(case,call);
            let slot=value_slot(&mut b,&mut owner,n(&call["tree"]),n(&call["key_ref"])).unwrap();
            assert_eq!(slot,n(&call["slot"]));assert_eq!(json!(b.access),call["access"],"fill {} key {}",case["fill"],call["key"]);
            snapshot(&b,&call["after"]);assert_eq!(owner.snapshot().owned_allocations,b.live.len());assert!(b.queue.is_empty());
            reads+=b.read_count;insertions+=1;
            // This isolated call snapshot is a partial constructor, not a
            // published manager. Cleanup uses its explicit raw inventory.
            retire_empty(&mut b,&mut owner).unwrap();assert!(b.live.is_empty()&&owner.is_retired());
        }
    }
    assert_eq!(insertions,8);assert_eq!(reads,232);
}

#[test]
fn audio_loading_resource_index_each_native_read_failure_preserves_partial_constructor_ownership(){
    let p=proof();let mut failures=0;
    for case in p["cases"].as_array().unwrap(){for call in case["index_calls"].as_array().unwrap(){
        let expected=call["access"].as_array().unwrap();let reads=expected.iter().filter(|e|e[0]=="read").count();
        for fail_at in 0..reads {
            let (mut b,mut owner)=host(case,call);b.fail_read=Some(fail_at);
            let primary=value_slot(&mut b,&mut owner,n(&call["tree"]),n(&call["key_ref"])).unwrap_err();
            assert!(matches!(primary,Error::Read(_)));assert!(b.fail_read.is_none());assert_eq!(owner.snapshot().owned_allocations,b.live.len());
            let end=expected.iter().enumerate().filter(|(_,e)|e[0]=="read").nth(fail_at).unwrap().0+1;
            assert_eq!(b.access,expected[..end],"first failing read is native read {fail_at}");
            b.fail_free_once=true;assert!(matches!(retire_empty(&mut b,&mut owner),Err(Error::Free(_))));
            assert!(!owner.is_retired());assert_eq!(owner.snapshot().owned_allocations,b.live.len());
            let live=b.live.len();retire_empty(&mut b,&mut owner).unwrap();assert!(b.live.is_empty()&&owner.is_retired());assert_eq!(b.freed.len(),live);
            assert_eq!(b.freed.iter().copied().collect::<std::collections::BTreeSet<_>>().len(),b.freed.len());
            assert!(matches!(primary,Error::Read(_)));failures+=1;
        }
    }}
    assert_eq!(failures,232);
}
