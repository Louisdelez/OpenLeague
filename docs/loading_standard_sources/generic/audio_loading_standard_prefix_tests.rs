use super::*;
use crate::audio_announcer_object_lookup::{self as read, Memory};
use crate::audio_announcer_owner_component_destructor::ControlBoundary;
use crate::audio_announcer_registry_init::{self as init, OwnedMemory, Storage};
use crate::audio_announcer_registry_remove::{self as removal, Backend as Free, Deallocator};
use crate::audio_loading_record_tree::Kind;
use crate::audio_loading_screen_packet as loading;
use crate::audio_replay_metadata as metadata;
use crate::audio_replay_object_commands as commands;
use crate::audio_replay_object_manager as objects;
use crate::audio_replay_shared_pair as pair;
use serde_json::{json, Value};
use std::collections::{BTreeMap, BTreeSet, VecDeque};

const DIAGNOSTIC: u32 = 0x36000000;
const RECIPIENT: u32 = DIAGNOSTIC + 0x100;
const SERVICE: u32 = DIAGNOSTIC + 0x1000;
const PAYLOAD: u32 = DIAGNOSTIC + 0x2000;
const PAIR_SCRATCH: u32 = DIAGNOSTIC + 0x8000;
const RESOLVER_SCRATCH: u32 = DIAGNOSTIC + 0x8100;
fn n(v: &Value) -> u32 { v.as_u64().unwrap() as u32 }
fn decode(s: &str) -> Vec<u8> {
    s.as_bytes().chunks_exact(2)
        .map(|s| u8::from_str_radix(std::str::from_utf8(s).unwrap(), 16).unwrap()).collect()
}
fn fixture() -> Value {
    serde_json::from_str(&crate::audio_test_fixture("data/4.20/loading_standard_prefix_probe.json")).unwrap()
}
#[derive(Clone,Copy)]
struct WriteFault { address:u32,width:u32,occurrence:u32,old:u32 }
struct Host {
    memory: OwnedMemory,
    queue: VecDeque<Value>,
    live: BTreeMap<u32, u32>,
    allocated: Vec<Value>,
    freed: Vec<u32>,
    held: BTreeSet<u32>,
    reads: Vec<u32>,
    stop: Option<Stop>,
    errors: Vec<String>,
    expected_boundary: Value,
    expected_output: Value,
    mutate_service_global: bool,
    provider_calls: u32,
    resolver_calls: u32,
    object_value_calls: u32,
    prefix_reads: Vec<u32>,
    write_fault: Option<WriteFault>,
    fault_seen: u32,
    fail_release: Option<u32>,
    release_failed: bool,
}
impl Host {
    fn before_write(&mut self,p:u32,width:u32)->Result<(),init::Error> {
        if let Some(f)=self.write_fault {
            if p==f.address && width==f.width && self.freed.contains(&f.old) {
                self.fault_seen+=1;
                if self.fault_seen==f.occurrence {
                    self.write_fault=None;
                    return Err(init::Error::Backend("injected prefix publication failure"));
                }
            }
        }
        Ok(())
    }
    fn raw_word(&mut self, p: u32) -> u32 { self.memory.word(p).unwrap() }
    fn put(&mut self, p: u32, value: u32) { Storage::write_word(&mut self.memory, p, value).unwrap(); }
    fn set(&mut self, p: u32, data: &[u8]) {
        for (i, &value) in data.iter().enumerate() { self.memory.write_byte(p+i as u32, value).unwrap(); }
    }
    fn bytes(&self, p: u32, size: u32) -> Vec<u8> {
        (p..p+size).map(|p| self.memory.read_byte(p).unwrap()).collect()
    }
    fn check_blocks(&self, expected: &Value) {
        let blocks=expected["blocks"].as_array().unwrap();
        assert_eq!(self.live.len(), blocks.len());
        for block in blocks {
            let p=n(&block["pointer"]); let size=n(&block["bytes"]);
            assert_eq!(self.live.get(&p), Some(&size));
            assert_eq!(self.bytes(p,size), decode(block["hex"].as_str().unwrap()), "block {p:08x}");
        }
        assert!(self.held.is_empty());
    }
    fn acquire_lock(&mut self, p: u32) -> Result<(), &'static str> {
        if !self.held.insert(p) { return Err("reentrant source lock"); } Ok(())
    }
    fn release_lock(&mut self, p: u32) -> Result<(), &'static str> {
        if !self.held.remove(&p) { return Err("unheld source lock"); } Ok(())
    }
    fn failure(&mut self, e: impl std::fmt::Debug, message: &'static str) -> &'static str {
        self.errors.push(format!("{message}: {e:?}")); message
    }
}
impl Memory for Host {
    fn word(&mut self, p: u32) -> Result<u32, read::Error> {
        self.reads.push(p); self.memory.word(p)
    }
}
impl Storage for Host {
    fn allocate(&mut self, size: u32) -> Result<u32, init::Error> {
        let expected=self.queue.pop_front().expect("allocation not present in native prefix oracle");
        assert_eq!(n(&expected["bytes"]),size);
        let p=n(&expected["pointer"]);
        self.memory.reserve_at(p,size)?;
        assert!(self.live.insert(p,size).is_none());
        self.allocated.push(json!({"pointer":p,"bytes":size})); Ok(p)
    }
    fn write_word(&mut self,p:u32,value:u32)->Result<(),init::Error> {
        self.before_write(p,4)?;Storage::write_word(&mut self.memory,p,value)
    }
    fn write_byte(&mut self,p:u32,value:u8)->Result<(),init::Error> {
        self.before_write(p,1)?;self.memory.write_byte(p,value)
    }
    fn register_shutdown(&mut self,_:u32)->Result<(),init::Error> { Err(init::Error::Backend("unexpected registration")) }
}
impl Free for Host {
    fn write_word(&mut self,p:u32,value:u32)->Result<(),removal::Error> {
        Storage::write_word(&mut self.memory,p,value).map_err(removal::Error::Owned)
    }
    fn deallocator(&mut self)->Result<Deallocator,removal::Error> { Ok(Deallocator::Standard) }
    fn free(&mut self,p:u32,_:Deallocator)->Result<(),removal::Error> {
        if self.fail_release==Some(p) && !self.release_failed {
            self.release_failed=true;
            return Err(removal::Error::Backend("injected prefix cleanup failure"));
        }
        assert!(self.live.contains_key(&p),"release requires live native allocation");
        self.memory.release(p).map_err(removal::Error::Owned)?;
        self.live.remove(&p);self.freed.push(p);Ok(())
    }
}
impl owned::Boundary for Host {
    fn release_owned(&mut self,p:u32,route:Deallocator)->Result<(),removal::Error> {
        Free::free(self,p,route)
    }
}
impl metadata::Boundary for Host {
    fn read_byte(&mut self,p:u32)->Result<u8,read::Error> { self.memory.read_byte(p) }
    fn initialize_lock(&mut self,_:u32)->Result<(),&'static str> { Err("unexpected metadata construction") }
    fn destroy_lock(&mut self,_:u32)->Result<(),&'static str> { Err("unexpected metadata destruction") }
    fn enter_lock(&mut self,p:u32)->Result<(),&'static str> { self.acquire_lock(p) }
    fn leave_lock(&mut self,p:u32)->Result<(),&'static str> { self.release_lock(p) }
}
impl ControlBoundary for Host {
    fn decrement_reference(&mut self,p:u32)->Result<u32,&'static str> {
        let old=self.raw_word(p); self.put(p,old.wrapping_sub(1)); Ok(old)
    }
    fn dispose(&mut self,_:u32,_:u32)->Result<(),&'static str> { Err("unexpected last strong reference") }
    fn release_control(&mut self,_:u32,_:u32)->Result<(),&'static str> { Err("unexpected last weak reference") }
}
impl pair::Boundary for Host {
    fn increment_reference(&mut self,p:u32)->Result<u32,&'static str> {
        let old=self.raw_word(p); self.put(p,old.wrapping_add(1)); Ok(old)
    }
}
impl objects::Boundary for Host {
    fn read_byte(&mut self,p:u32)->Result<u8,read::Error> { self.memory.read_byte(p) }
    fn initialize_lock(&mut self,_:u32)->Result<(),&'static str> { Err("unexpected object construction") }
    fn destroy_lock(&mut self,_:u32)->Result<(),&'static str> { Err("unexpected object destruction") }
    fn enter_lock(&mut self,p:u32)->Result<(),&'static str> { self.acquire_lock(p) }
    fn leave_lock(&mut self,p:u32)->Result<(),&'static str> { self.release_lock(p) }
    fn object_id(&mut self,p:u32,target:u32)->Result<u32,&'static str> {
        if target!=commands::PACKET_ID { return Err("unknown actual packet ID method"); }
        commands::packet_id(self,p).map_err(|e|self.failure(e,"packet ID failed"))
    }
    fn object_value(&mut self,p:u32,target:u32)->Result<u64,&'static str> {
        if target!=commands::PACKET_VALUE { return Err("unknown actual packet value method"); }
        self.object_value_calls+=1;
        commands::packet_value(self,p).map_err(|e|self.failure(e,"packet value failed"))
    }
}
impl names::Boundary for Host {
    fn initialize_game_manager(&mut self)->Result<(),&'static str> { Err("native parent must exist in this fixture") }
    fn resolve_key(&mut self,_metadata:u32,target:u32,key:u32)->Result<u64,&'static str> {
        if target!=names::RESOLVE { return Err("unknown metadata resolver"); }
        self.resolver_calls+=1;
        let parent=self.word(names::PARENT).map_err(|e|self.failure(e,"parent read failed"))?;
        let nested=self.word(parent+0x30).map_err(|e|self.failure(e,"stream read failed"))?;
        pair::from_nested(self,nested,RESOLVER_SCRATCH).map_err(|e|self.failure(e,"index acquire failed"))?;
        let action=(|| {
            let index=self.word(RESOLVER_SCRATCH).map_err(|e|self.failure(e,"index read failed"))?;
            objects::lookup(self,index,key,RESOLVER_SCRATCH+8).map_err(|e|self.failure(e,"actual index lookup failed"))
        })();
        let cleanup=pair::destroy(self,RESOLVER_SCRATCH).map_err(|e|self.failure(e,"index release failed"));
        match (action,cleanup) { (Ok(value),Ok(()))=>Ok(value),(Err(e),_)|(_,Err(e))=>Err(e) }
    }
}
impl loading::Boundary for Host {
    fn service_name(&mut self,service:u32,target:u32,out:u32,key:u32)->Result<(),&'static str> {
        assert_eq!((service,target),(SERVICE,names::SERVICE_NAME));
        self.provider_calls+=1;
        names::service_name(self,out,key,PAIR_SCRATCH)
            .map_err(|e|self.failure(e,"actual name provider failed"))?;
        if self.mutate_service_global { self.put(loading::SERVICE_GLOBAL,0xdeadbeef); }
        Ok(())
    }
    fn clock_f32_bits(&mut self)->Result<u32,&'static str> { Err("prefix must never request a clock") }
    fn initialize_standard_record(&mut self,recipient:u32,_record:u32,payload:u32,retained_service:u32,name:&mut owned::Temporary)->Result<(),Error> {
        assert_eq!(retained_service,SERVICE);
        let start=self.reads.len();
        let stop=prepare(self,recipient,retained_service,payload,name,PAIR_SCRATCH)?;
        self.prefix_reads=self.reads[start..].to_vec();
        self.check_blocks(&self.expected_boundary);
        assert_eq!(self.bytes(name.address(),24),decode(self.expected_output["hex"].as_str().unwrap()));
        self.stop=Some(stop);
        Err(Error::Boundary(stop.unavailable()))
    }
}
fn initial(proof:&Value,c:&Value,mutate_service_global:bool)->Host {
    let mut b=Host {
        memory:OwnedMemory::new(0x38000000,n(&c["fill"]) as u8),
        queue:c["state_at_boundary"]["allocations"].as_array().unwrap().iter().cloned().collect(),
        live:BTreeMap::new(),allocated:vec![],freed:vec![],held:BTreeSet::new(),reads:vec![],stop:None,errors:vec![],
        expected_boundary:c["state_at_boundary"].clone(),expected_output:c["prefix_stop"]["string"].clone(),
        mutate_service_global,provider_calls:0,resolver_calls:0,object_value_calls:0,prefix_reads:vec![],
        write_fault:None,fault_seen:0,fail_release:None,release_failed:false,
    };
    for block in c["prepared"]["blocks"].as_array().unwrap() {
        let p=n(&block["pointer"]);let size=n(&block["bytes"]);
        b.memory.reserve_at(p,size).unwrap();b.set(p,&decode(block["hex"].as_str().unwrap()));b.live.insert(p,size);
    }
    b.memory.reserve_at(DIAGNOSTIC,0x10000).unwrap();
    for region in proof["seed_regions"].as_array().unwrap() {
        let p=n(&region["address"]);b.memory.reserve_at(p,n(&region["size"])).unwrap();
        b.set(p,&decode(region["hex"].as_str().unwrap()));
    }
    for (p,value) in [(names::PARENT,n(&c["parent"])),(loading::SERVICE_GLOBAL,SERVICE),(PACKAGE_GLOBAL,0)] {
        b.memory.reserve_at(p,4).unwrap();b.put(p,value);
    }
    b.put(SERVICE,0x10afe8c);
    let heads:Vec<_>=c["prepared"]["blocks"].as_array().unwrap().iter().filter(|r|n(&r["bytes"])==140).collect();
    assert_eq!(heads.len(),1);
    b.put(RECIPIENT,0x1084ea4);b.put(RECIPIENT+0x1c,n(&heads[0]["pointer"]));b.put(RECIPIENT+0x20,0);
    b.put(RECIPIENT+0x1a0,n(&c["skin_override"]));
    let override_name=decode(c["override_hex"].as_str().unwrap());let source=RECIPIENT+0x1a8;
    b.memory.write_byte(source,0).unwrap();
    b.put(source+16,override_name.len() as u32);
    if override_name.len()<16 { b.put(source+20,15);b.set(source,&override_name);b.memory.write_byte(source+override_name.len() as u32,0).unwrap(); }
    else {
        // These are actual native reads from its564C20-created override. The
        // referenced live allocation bytes were copied from prepared.blocks.
        let read_at=|address| c["events"].as_array().unwrap().iter()
            .find(|e|e["op"]=="read"&&n(&e["pointer"])==address).map(|e|n(&e["value"])).unwrap();
        b.put(source,read_at(source));b.put(source+20,read_at(source+20));
    }
    b.set(PAYLOAD,&decode(c["payload_hex"].as_str().unwrap()));
    let entry=c["events"].as_array().unwrap().iter().find(|e|e["op"]=="prefix_entry").unwrap();
    let name=n(&entry["string"]["address"]);
    b.memory.reserve_at(name,24).unwrap();
    // Native stack padding persists between invocations. Seed its raw bytes;
    // service_name still constructs a fresh output and all owned allocations.
    b.set(name,&decode(entry["string"]["hex"].as_str().unwrap()));
    b
}
fn run(proof:&Value,c:&Value,mutate_service_global:bool) {
    let mut b=initial(proof,c,mutate_service_global);
    let name=n(&c["prefix_stop"]["string"]["address"]);
    let result=loading::receive(&mut b,Kind::Standard,RECIPIENT,PAYLOAD,name);
    assert!(b.errors.is_empty(),"unexpected boundary failures: {:?}",b.errors);
    let stop=b.stop.expect("must reach measured native stop");
    assert_eq!(result,Err(loading::ReceiveFailure::Owned(owned::Failure {
        primary:Some(Error::Boundary(stop.unavailable())),cleanup:None,remaining:None,
    })));
    let skin=n(&c["skin"]);
    let expected=if (skin as i32)<0 {
        assert_eq!(n(&c["prefix_stop"]["before_call"]),NEGATIVE_DIAGNOSTIC);
        assert!(!b.prefix_reads.contains(&PACKAGE_GLOBAL));
        assert!(!b.prefix_reads.contains(&(RECIPIENT+0x1a0)));
        Stop::Diagnostic991E60 { skin,arguments:std::array::from_fn(|i|n(&c["prefix_stop"]["arguments"][i])) }
    } else {
        assert_eq!(n(&c["prefix_stop"]["before_call"]),RESOURCE_PROVIDER);
        assert!(b.prefix_reads.iter().position(|&p|p==PACKAGE_GLOBAL).unwrap()
            <b.prefix_reads.iter().position(|&p|p==RECIPIENT+0x1a0).unwrap());
        Stop::Resource90AD00 { manager:n(&c["prefix_stop"]["registers"]["ecx"]),name24:name,skin:n(&c["prefix_stop"]["arguments"][1]) }
    };
    assert_eq!(stop,expected);
    assert_eq!(b.reads.iter().filter(|&&p|p==loading::SERVICE_GLOBAL).count(),1);
    assert!(!b.prefix_reads.contains(&loading::SERVICE_GLOBAL));
    assert_eq!(b.provider_calls,1);assert_eq!(b.resolver_calls,2);
    assert_eq!(b.object_value_calls,if c["object_exists"].as_bool().unwrap(){2}else{0});
    assert!(b.queue.is_empty());
    let expected_allocs:Vec<_>=c["state_at_boundary"]["allocations"].as_array().unwrap().iter()
        .map(|a|json!({"pointer":n(&a["pointer"]),"bytes":n(&a["bytes"])})).collect();
    assert_eq!(b.allocated,expected_allocs);
    let expected_frees:Vec<_>=c["state_at_boundary"]["freed"].as_array().unwrap().iter()
        .chain(c["cleanup"]["freed"].as_array().unwrap()).map(n).collect();
    assert_eq!(b.freed,expected_frees);
    b.check_blocks(&c["cleanup"]);
    assert_eq!(b.bytes(name,24),decode(c["prefix_stop"]["string"]["hex"].as_str().unwrap()));
    assert_eq!(b.bytes(PAYLOAD,25),decode(c["payload_hex"].as_str().unwrap()));
    // Persistent parent/index/metadata live blocks are the original prepared
    // source state, not owned by this single consumer invocation. Full native
    // parent teardown is separately captured in every oracle lifetime.
}
#[test]
fn audio_loading_standard_prefix_matches128_native_stops_and_distinct_cleanup() {
    let proof=fixture();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),128);
    for c in cases {run(&proof,c,false);}
}
#[test]
fn audio_loading_standard_prefix_keeps_service_captured_before_name_provider() {
    let proof=fixture();let cases=proof["cases"].as_array().unwrap();
    for index in [0,1,2,4,56,127] {run(&proof,&cases[index],true);}
}

#[test]
fn audio_loading_standard_prefix_consumer_retires16_partial_publications_without_second_old_free() {
    let proof=fixture();
    for fill in [0,165] {
        let c=proof["cases"].as_array().unwrap().iter().find(|c|c["profile"]=="heap_growth" && c["fill"]==fill).unwrap();
        let entry=&c["events"].as_array().unwrap().iter().find(|e|e["op"]=="prefix_entry").unwrap()["string"];
        let name=n(&entry["address"]);let old=n(&entry["data"]);let old_len=n(&entry["length"]);
        let raw=n(&c["prefix_stop"]["string"]["data"]);
        let length=decode(c["override_hex"].as_str().unwrap()).len() as u32;
        for (address,width,occurrence) in [(name,1,1),(name,4,1),(name+20,4,1),(name+16,4,1),
                (raw+old_len,1,1),(raw,1,1),(name+16,4,2),(raw+length,1,1)] {
            let mut b=initial(&proof,c,false);
            b.write_fault=Some(WriteFault{address,width,occurrence,old});
            let result=loading::receive(&mut b,Kind::Standard,RECIPIENT,PAYLOAD,name);
            assert_eq!(result,Err(loading::ReceiveFailure::Owned(owned::Failure {
                primary:Some(Error::Write(init::Error::Backend("injected prefix publication failure"))),
                cleanup:None,remaining:None,
            })));
            assert!(b.write_fault.is_none());assert!(b.errors.is_empty());assert_eq!(b.stop,None);
            assert_eq!(b.provider_calls,1);assert_eq!(b.resolver_calls,1);
            assert_eq!(b.freed,vec![old,raw]);assert!(b.queue.is_empty());
            b.check_blocks(&c["cleanup"]);
        }
    }
}

#[test]
fn audio_loading_standard_prefix_consumer_returns_owned_failure_until_explicit_retry() {
    let proof=fixture();
    let c=proof["cases"].as_array().unwrap().iter().find(|c|c["profile"]=="heap_growth" && c["fill"]==165).unwrap();
    let entry=&c["events"].as_array().unwrap().iter().find(|e|e["op"]=="prefix_entry").unwrap()["string"];
    let name=n(&entry["address"]);let old=n(&entry["data"]);
    let raw=n(&c["prefix_stop"]["string"]["data"]);
    let mut b=initial(&proof,c,false);
    b.write_fault=Some(WriteFault{address:name+20,width:4,occurrence:1,old});
    b.fail_release=Some(raw);
    let result=loading::receive(&mut b,Kind::Standard,RECIPIENT,PAYLOAD,name);
    let Err(loading::ReceiveFailure::Owned(mut failure))=result else {panic!("expected owned cleanup failure")};
    assert_eq!(failure.primary,Some(Error::Write(init::Error::Backend("injected prefix publication failure"))));
    assert_eq!(failure.cleanup,Some(Error::Free(removal::Error::Backend("injected prefix cleanup failure"))));
    let mut remaining=failure.remaining.take().expect("new allocation remains owned");
    assert_eq!(remaining.authority(),owned::Authority::Detached(raw));
    assert_eq!(remaining.address(),name);assert_eq!(b.freed,vec![old]);
    assert!(b.live.contains_key(&raw));assert!(!b.live.contains_key(&old));
    let partial=b.bytes(name,24);
    remaining.retire(&mut b).unwrap();assert!(remaining.is_retired());
    assert_eq!(b.bytes(name,24),partial);assert_eq!(b.freed,vec![old,raw]);
    b.check_blocks(&c["cleanup"]);
}
