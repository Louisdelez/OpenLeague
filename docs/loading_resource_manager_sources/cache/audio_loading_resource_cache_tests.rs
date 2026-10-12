use super::*;
use crate::audio_announcer_object_lookup::{self as read,Memory};
use crate::audio_announcer_registry_init::{self as init,OwnedMemory};
use crate::audio_announcer_registry_remove::{self as removal,Backend as Free,Deallocator};
use crate::audio_replay_metadata as metadata;
use serde_json::{json,Value};
use std::collections::{BTreeMap,BTreeSet,VecDeque};

fn n(v:&Value)->u32 {v.as_u64().unwrap() as u32}
fn hex(s:&str)->Vec<u8> {s.as_bytes().chunks_exact(2).map(|b|u8::from_str_radix(std::str::from_utf8(b).unwrap(),16).unwrap()).collect()}
fn proof()->Value {serde_json::from_str(&crate::audio_test_fixture("data/4.20/loading_resource_cache_contract.json")).unwrap()}
fn copy_record(q:&Value)->&Value {if q["copy"].is_null(){&q["stop"]["copy"]}else{&q["copy"]}}
struct Host {
    memory:OwnedMemory,live:BTreeMap<u32,u32>,allocations:Vec<(u32,u32)>,queue:VecDeque<Value>,
    events:Vec<Value>,released:Vec<u32>,attempted:Vec<u32>,fail_free:BTreeSet<u32>,
    fail_write:Option<(u32,u32)>,fail_read:Option<u32>,c_locale:bool,locale_reads:u32,
}
impl Host {
    fn bytes(&self,p:u32,size:u32)->Vec<u8> {(0..size).map(|i|self.memory.read_byte(p+i).unwrap()).collect()}
    fn set(&mut self,p:u32,bytes:&[u8]) {for(i,&v)in bytes.iter().enumerate(){Storage::write_byte(&mut self.memory,p+i as u32,v).unwrap();}}
    fn reserve(&mut self,p:u32,bytes:&[u8],owned:bool) {
        self.memory.reserve_at(p,bytes.len() as u32).unwrap();self.set(p,bytes);
        if owned {assert!(self.live.insert(p,bytes.len() as u32).is_none());}
    }
    fn before_write(&mut self,p:u32,width:u32)->Result<(),init::Error> {
        if self.fail_write==Some((p,width)) {self.fail_write=None;return Err(init::Error::Backend("injected cache write failure"));}Ok(())
    }
}
impl Memory for Host {
    fn word(&mut self,p:u32)->Result<u32,read::Error> {
        self.events.push(json!(["read",p,4]));
        if self.fail_read==Some(p) {self.fail_read=None;return Err(read::Error::MissingWord(p));}
        self.memory.word(p)
    }
}
impl Storage for Host {
    fn allocate(&mut self,bytes:u32)->Result<u32,init::Error> {
        let a=self.queue.pop_front().expect("unexpected allocation outside native fixture");assert_eq!(n(&a["bytes"]),bytes);
        let p=n(&a["pointer"]);self.memory.reserve_at(p,bytes)?;assert!(self.live.insert(p,bytes).is_none());
        self.allocations.push((p,bytes));Ok(p)
    }
    fn write_word(&mut self,p:u32,value:u32)->Result<(),init::Error> {
        self.before_write(p,4)?;self.events.push(json!(["write",p,4,value]));Storage::write_word(&mut self.memory,p,value)
    }
    fn write_byte(&mut self,p:u32,value:u8)->Result<(),init::Error> {
        self.before_write(p,1)?;self.events.push(json!(["write",p,1,value]));Storage::write_byte(&mut self.memory,p,value)
    }
    fn register_shutdown(&mut self,_:u32)->Result<(),init::Error> {Err(init::Error::Backend("no shutdown registration in lookup"))}
}
impl Free for Host {
    fn write_word(&mut self,p:u32,value:u32)->Result<(),removal::Error> {Storage::write_word(self,p,value).map_err(removal::Error::Owned)}
    fn deallocator(&mut self)->Result<Deallocator,removal::Error> {self.events.push(json!(["read",0x14bef40u32,4]));Ok(Deallocator::Standard)}
    fn free(&mut self,p:u32,route:Deallocator)->Result<(),removal::Error> {
        assert_eq!(route,Deallocator::Standard);self.attempted.push(p);
        if self.fail_free.remove(&p) {return Err(removal::Error::Backend("injected atomic cache free failure"));}
        assert!(self.live.contains_key(&p),"double free or borrowed-provider retirement {p:08x}");
        self.memory.release(p).map_err(removal::Error::Owned)?;self.live.remove(&p);
        self.events.push(json!(["free",p]));self.released.push(p);Ok(())
    }
}
impl metadata::Boundary for Host {
    fn read_byte(&mut self,p:u32)->Result<u8,read::Error> {self.events.push(json!(["read",p,1]));self.memory.read_byte(p)}
    fn initialize_lock(&mut self,_:u32)->Result<(),&'static str> {Err("lookup has no mutex")}
    fn destroy_lock(&mut self,_:u32)->Result<(),&'static str> {Err("lookup has no mutex")}
    fn enter_lock(&mut self,_:u32)->Result<(),&'static str> {Err("lookup has no mutex")}
    fn leave_lock(&mut self,_:u32)->Result<(),&'static str> {Err("lookup has no mutex")}
}
impl owned::Boundary for Host {
    fn release_owned(&mut self,p:u32,route:Deallocator)->Result<(),removal::Error> {Free::free(self,p,route)}
}
impl Boundary for Host {
    fn locale_is_default(&mut self)->Result<bool,Error> {self.locale_reads+=1;Ok(self.c_locale)}
}
fn host(case:&Value,q:&Value)->Host {
    let mut b=Host{memory:OwnedMemory::new(0x38000000,n(&case["fill"]) as u8),live:BTreeMap::new(),allocations:vec![],queue:VecDeque::new(),
        events:vec![],released:vec![],attempted:vec![],fail_free:BTreeSet::new(),fail_write:None,fail_read:None,c_locale:true,locale_reads:0};
    for block in case["prepared"]["blocks"].as_array().unwrap() {
        b.reserve(n(&block["pointer"]),&hex(block["hex"].as_str().unwrap()),true);
    }
    let source=&q["detail"]["source"];
    b.reserve(n(&source["pointer"]),&hex(source["object_hex"].as_str().unwrap()),false);
    if n(&source["capacity"])>=16 {b.reserve(n(&source["data"]),&hex(q["detail"]["source_storage_hex"].as_str().unwrap()),true);}
    b.reserve(n(&copy_record(q)["pointer"]),&hex(q["detail"]["initial_key_hex"].as_str().unwrap()),false);
    b.queue=q["temporary_allocations"].as_array().unwrap().iter().cloned().collect();b
}
fn begin(b:&mut Host,q:&Value)->Temporary {
    let p=n(&copy_record(q)["pointer"]);initialize_key(b,p).unwrap();Temporary::new_reset(p)
}
fn run(b:&mut Host,case:&Value,q:&Value,key:&mut Temporary)->Result<Outcome,Error> {
    resolve(b,n(&case["manager"]),n(&q["detail"]["source"]["pointer"]),n(&q["skin"]),key)
}
fn assert_native(case:&Value,q:&Value,is_hit:bool) {
    let mut b=host(case,q);let baseline=b.live.clone();let mut key=begin(&mut b,q);let address=key.address();
    assert_eq!(b.events,vec![json!(["write",address+20,4,15]),json!(["write",address+16,4,0]),json!(["write",address,1,0])]);
    let result=run(&mut b,case,q,&mut key).unwrap();
    let expected=if is_hit {Outcome::HitBorrowed{provider:n(&q["result"])}}else{Outcome::MissFactory{manager:n(&case["manager"]),original_name:n(&q["stop"]["arguments"][0]),skin:n(&q["stop"]["arguments"][1])}};
    assert_eq!(result,expected);
    let native_copy=copy_record(q);
    assert_eq!(b.bytes(address,24),hex(native_copy["object_hex"].as_str().unwrap()));
    assert_eq!(b.bytes(n(&native_copy["data"]),n(&native_copy["length"])),hex(native_copy["bytes_hex"].as_str().unwrap()));
    assert_eq!(b.locale_reads,n(&native_copy["length"]),"C98719 reads locale once per byte including NUL/high bytes");
    assert_eq!(b.bytes(address+24,4),n(&q["skin"]).to_le_bytes());
    let first=b.events.iter().position(|e|*e==json!(["read",n(&case["manager"])+12,4])).unwrap();
    assert_eq!(json!(&b.events[first..]),q["detail"]["lookup_events"],"all native lookup reads, fill {} name {} skin {}",case["fill"],q["name_hex"],q["skin"]);
    assert_eq!(b.allocations,q["temporary_allocations"].as_array().unwrap().iter().map(|a|(n(&a["pointer"]),n(&a["bytes"]))).collect::<Vec<_>>());
    assert!(b.queue.is_empty());
    for block in case["prepared"]["blocks"].as_array().unwrap() {assert_eq!(b.bytes(n(&block["pointer"]),n(&block["size"])),hex(block["hex"].as_str().unwrap()));}
    let source=&q["detail"]["source"];
    assert_eq!(b.bytes(n(&source["pointer"]),24),hex(source["object_hex"].as_str().unwrap()));
    assert_eq!(b.bytes(n(&source["data"]),n(&source["capacity"])+1),hex(q["detail"]["source_storage_hex"].as_str().unwrap()));
    b.events.clear();key.retire(&mut b).unwrap();assert!(key.is_retired());
    assert_eq!(json!(b.events),q["detail"]["retirement_events"],"564900 reads, route, free and reset writes");
    assert_eq!(b.bytes(address,24),hex(q["detail"]["after_retirement_hex"].as_str().unwrap()));
    assert_eq!(b.released,q["temporary_frees"].as_array().unwrap().iter().map(|a|n(&a["pointer"])).collect::<Vec<_>>());
    assert_eq!(b.live,baseline,"only copied key may be retired, provider is borrowed");
    b.events.clear();key.retire(&mut b).unwrap();assert!(b.events.is_empty(),"retirement retry is idempotent");
}

#[test]
fn audio_loading_resource_cache_matches66_native_hits_and_full_lookup_retirement_traces() {
    let p=proof();assert_eq!(p["source_sha256"],"402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862");assert_eq!(p["passed"],true);
    let mut count=0;for c in p["cases"].as_array().unwrap(){for q in c["hits"].as_array().unwrap(){assert_native(c,q,true);count+=1;}}assert_eq!(count,66);
}
#[test]
fn audio_loading_resource_cache_matches8_native_misses_without_calling_factory() {
    let p=proof();let mut count=0;for c in p["cases"].as_array().unwrap(){for q in c["misses"].as_array().unwrap(){assert_eq!(n(&q["stop"]["address"]),FACTORY);assert_native(c,q,false);count+=1;}}assert_eq!(count,8);
}
#[test]
fn audio_loading_resource_cache_non_c_locale_is_explicit_and_empty_names_skip_tolower() {
    let p=proof();for c in p["cases"].as_array().unwrap() {
        let q=&c["hits"][5];let mut b=host(c,q);let mut key=begin(&mut b,q);b.c_locale=false;
        assert_eq!(run(&mut b,c,q,&mut key),Err(Error::Boundary("non-C locale C985D6 is unavailable")));
        assert_eq!(b.locale_reads,1);assert!(!key.is_retired());key.retire(&mut b).unwrap();assert_eq!(b.released.len(),1);
        let q=&c["misses"][3];assert_eq!(q["name_hex"],"");let mut b=host(c,q);let mut key=begin(&mut b,q);b.c_locale=false;
        assert!(matches!(run(&mut b,c,q,&mut key),Ok(Outcome::MissFactory{..})));assert_eq!(b.locale_reads,0);key.retire(&mut b).unwrap();
    }
}
#[test]
fn audio_loading_resource_cache_failed_copy_publication_keeps_detached_allocation() {
    let p=proof();for c in p["cases"].as_array().unwrap() {let q=&c["hits"][5];
        for (offset,width) in [(0,1),(0,4),(20,4),(16,4)] {
            let mut b=host(c,q);let mut key=begin(&mut b,q);let address=key.address();b.fail_write=Some((address+offset,width));
            let primary=run(&mut b,c,q,&mut key);assert!(matches!(primary,Err(Error::Write(_))));assert!(b.fail_write.is_none());
            let raw=n(&q["temporary_allocations"][0]["pointer"]);assert_eq!(key.authority(),owned::Authority::Detached(raw));
            b.fail_free.insert(raw);let failure=owned::finish(&mut b,key,primary).unwrap_err();assert!(failure.primary.is_some());assert!(failure.cleanup.is_some());
            let mut key=failure.remaining.unwrap();assert!(b.live.contains_key(&raw));key.retire(&mut b).unwrap();assert!(key.is_retired());assert_eq!(b.released,vec![raw]);
        }
    }
}
#[test]
fn audio_loading_resource_cache_reset_write_failures_retry_without_read_or_double_free() {
    let p=proof();for c in p["cases"].as_array().unwrap() {for index in [0,5] {
        let q=&c["hits"][index];for (offset,width) in [(20,4),(16,4),(0,1)] {
            let mut b=host(c,q);let mut key=begin(&mut b,q);run(&mut b,c,q,&mut key).unwrap();let address=key.address();
            b.fail_write=Some((address+offset,width));assert!(matches!(key.retire(&mut b),Err(Error::Write(_))));
            assert_eq!(key.authority(),owned::Authority::None);assert!(!key.is_retired());let frees=b.released.clone();b.events.clear();
            key.retire(&mut b).unwrap();assert!(key.is_retired());assert_eq!(b.released,frees);assert!(b.events.iter().all(|v|v[0]=="write"));
            assert_eq!(b.bytes(address,24),hex(q["detail"]["after_retirement_hex"].as_str().unwrap()));
        }
    }}
}
#[test]
fn audio_loading_resource_cache_group_preserves_two_owners_and_primary_lookup_failure() {
    let p=proof();for c in p["cases"].as_array().unwrap() {let q=&c["hits"][5];let mut b=host(c,q);let key=begin(&mut b,q);
        let source=n(&q["detail"]["source"]["pointer"]);let source_raw=n(&q["detail"]["source"]["data"]);let key_raw=n(&q["temporary_allocations"][0]["pointer"]);
        let mut owners=owned::Group::new([Some(Temporary::new(source)),Some(key)]);
        let failing_address=n(&c["manager"])+12;b.fail_read=Some(failing_address);
        let primary=run(&mut b,c,q,owners.get_mut(1).unwrap());assert_eq!(primary,Err(Error::Read(read::Error::MissingWord(failing_address))));
        b.fail_free.extend([source_raw,key_raw]);let mut failure=owned::finish_group(&mut b,owners,primary).unwrap_err();
        assert_eq!(failure.primary,Some(Error::Read(read::Error::MissingWord(failing_address))));assert!(failure.cleanup.iter().all(Option::is_some));assert_eq!(failure.remaining.remaining_count(),2);
        assert_eq!(b.attempted,vec![key_raw,source_raw]);assert!(b.released.is_empty());
        let retried=failure.remaining.retire(&mut b);assert!(retried.iter().all(Option::is_none));assert_eq!(failure.remaining.remaining_count(),0);
        assert_eq!(b.released,vec![key_raw,source_raw]);assert!(failure.primary.is_some());assert!(failure.cleanup.iter().all(Option::is_some));
    }
}
#[test]
fn audio_loading_resource_cache_corrupt_tree_cycle_is_explicit_and_key_still_retirable() {
    let p=proof();let c=&p["cases"][0];let q=&c["misses"][0];let mut b=host(c,q);let mut key=begin(&mut b,q);
    let head=b.memory.word(n(&c["manager"])+12).unwrap();let root=b.memory.word(head+4).unwrap();
    Storage::write_word(&mut b.memory,root,root).unwrap();Storage::write_word(&mut b.memory,root+8,root).unwrap();
    assert_eq!(run(&mut b,c,q,&mut key),Err(Error::InvalidTree));key.retire(&mut b).unwrap();assert!(key.is_retired());
}
