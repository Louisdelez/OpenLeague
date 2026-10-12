use super::*;
use crate::audio_announcer_object_lookup::{self as read,Memory};
use crate::audio_announcer_registry_init::{self as init,OwnedMemory};
use crate::audio_announcer_registry_remove::{self as removal,Backend as Free,Deallocator};
use crate::audio_replay_metadata as metadata;
use serde_json::Value;
use std::collections::{BTreeMap,VecDeque};
const SCRATCH:u32=0x30005000;
fn n(v:&Value)->u32{v.as_u64().unwrap() as u32}
fn bytes(s:&str)->Vec<u8>{s.as_bytes().chunks_exact(2).map(|p|u8::from_str_radix(std::str::from_utf8(p).unwrap(),16).unwrap()).collect()}
fn fixture()->Value{serde_json::from_str(&crate::audio_test_fixture("data/4.20/loading_resource_manager_oracle.json")).unwrap()}
#[derive(Debug,Clone,PartialEq,Eq)]
enum Event{Allocate(u32,u32),Write(u32,u8),Free(u32)}
struct Host{
    memory:OwnedMemory,live:BTreeMap<u32,u32>,queue:VecDeque<Value>,trace:Vec<Event>,
    op:usize,fail:Option<usize>,partial:bool,null_alloc:bool,attempted:Vec<u32>,
}
impl Host{
    fn raw(&self,p:u32,n:u32)->Vec<u8>{(p..p+n).map(|a|self.memory.read_byte(a).unwrap()).collect()}
    fn set(&mut self,p:u32,s:&[u8]){for(i,&v)in s.iter().enumerate(){self.memory.write_byte(p+i as u32,v).unwrap();}}
    fn checkpoint(&mut self)->bool{let op=self.op;self.op+=1;if self.fail==Some(op){self.fail=None;true}else{false}}
    fn record_write(&mut self,p:u32,s:&[u8]){if p!=SCRATCH{for(i,&v)in s.iter().enumerate(){self.trace.push(Event::Write(p+i as u32,v));}}}
    fn write(&mut self,p:u32,s:&[u8])->Result<(),init::Error>{
        if self.checkpoint(){if self.partial{self.set(p,&s[..1]);}return Err(init::Error::Backend("injected resource write"));}
        self.set(p,s);self.record_write(p,s);Ok(())
    }
}
impl Memory for Host{fn word(&mut self,p:u32)->Result<u32,read::Error>{self.memory.word(p)}}
impl Storage for Host{
    fn allocate(&mut self,size:u32)->Result<u32,init::Error>{
        if self.checkpoint(){return Err(init::Error::Backend("injected resource allocation"));}
        if self.null_alloc{assert_eq!(size,BYTES);self.null_alloc=false;self.trace.push(Event::Allocate(0,size));return Ok(0);}
        let a=self.queue.pop_front().expect("unexpected allocation");let p=n(&a["pointer"]);assert_eq!(size,n(&a["bytes"]));
        self.memory.reserve_at(p,size)?;assert!(self.live.insert(p,size).is_none());self.trace.push(Event::Allocate(p,size));Ok(p)
    }
    fn write_word(&mut self,p:u32,v:u32)->Result<(),init::Error>{self.write(p,&v.to_le_bytes())}
    fn write_byte(&mut self,p:u32,v:u8)->Result<(),init::Error>{self.write(p,&[v])}
    fn register_shutdown(&mut self,_:u32)->Result<(),init::Error>{Err(init::Error::Backend("unexpected resource registration"))}
}
impl Free for Host{
    fn write_word(&mut self,p:u32,v:u32)->Result<(),removal::Error>{Storage::write_word(self,p,v).map_err(removal::Error::Owned)}
    fn deallocator(&mut self)->Result<Deallocator,removal::Error>{Ok(Deallocator::Standard)}
    fn free(&mut self,p:u32,_:Deallocator)->Result<(),removal::Error>{
        self.attempted.push(p);
        if self.checkpoint(){return Err(removal::Error::Backend("injected atomic resource free"));}
        assert!(self.live.contains_key(&p),"unowned/double free {p:08x}");
        self.memory.release(p).map_err(removal::Error::Owned)?;self.live.remove(&p);self.trace.push(Event::Free(p));Ok(())
    }
}
impl metadata::Boundary for Host{
    fn read_byte(&mut self,p:u32)->Result<u8,read::Error>{self.memory.read_byte(p)}
    fn initialize_lock(&mut self,_:u32)->Result<(),&'static str>{Err("resource manager takes no lock")}
    fn destroy_lock(&mut self,_:u32)->Result<(),&'static str>{Err("resource manager takes no lock")}
    fn enter_lock(&mut self,_:u32)->Result<(),&'static str>{Err("resource manager takes no lock")}
    fn leave_lock(&mut self,_:u32)->Result<(),&'static str>{Err("resource manager takes no lock")}
}
impl Boundary for Host{fn release_owned(&mut self,p:u32,r:Deallocator)->Result<(),removal::Error>{Free::free(self,p,r)}}
fn host(proof:&Value,c:&Value)->Host{
    let mut b=Host{memory:OwnedMemory::new(0x38000000,n(&c["fill"]) as u8),live:BTreeMap::new(),
        queue:c["allocations"].as_array().unwrap().iter().cloned().collect(),trace:vec![],op:0,fail:None,partial:false,null_alloc:false,attempted:vec![]};
    for d in proof["source_data"].as_array().unwrap(){let p=n(&d["address"]);let s=bytes(d["hex"].as_str().unwrap());b.memory.reserve_at(p,s.len() as u32).unwrap();b.set(p,&s);}
    b.memory.reserve_at(GLOBAL,4).unwrap();b.set(GLOBAL,&[0;4]);b.memory.reserve_at(SCRATCH,4).unwrap();b
}
fn expected(c:&Value,phases:&[&str])->Vec<Event>{
    let mut out=vec![];
    for e in c["trace"].as_array().unwrap(){
        if !phases.contains(&e["phase"].as_str().unwrap()){continue;}
        match e["kind"].as_str().unwrap(){
            "allocate"=>out.push(Event::Allocate(n(&e["pointer"]),n(&e["bytes"]))),
            "free"=>out.push(Event::Free(n(&e["pointer"]))),
            "write"=>for(i,v)in bytes(e["hex"].as_str().unwrap()).into_iter().enumerate(){out.push(Event::Write(n(&e["address"])+i as u32,v));},
            k=>panic!("unknown native event {k}"),
        }
    }out
}
fn assert_snapshot(b:&mut Host,s:&Value){
    assert_eq!(b.word(GLOBAL).unwrap(),n(&s["global"]));assert_eq!(b.live.len(),s["blocks"].as_array().unwrap().len());
    for a in s["blocks"].as_array().unwrap(){let p=n(&a["pointer"]);assert_eq!(b.live[&p],n(&a["size"]));
        assert_eq!(b.raw(p,n(&a["size"])),bytes(a["hex"].as_str().unwrap()),"native bytes at {p:08x}");}
}
#[test]
fn audio_loading_resource_manager_matches_two_native_lifetimes_and_exact_heap_writes(){
    let proof=fixture();assert_eq!(proof["passed"],true);assert_eq!(proof["cases"].as_array().unwrap().len(),2);
    for c in proof["cases"].as_array().unwrap(){
        let mut b=host(&proof,c);let mut r=Record::default();initialize_hashes(&mut b).unwrap();
        assert_eq!(produce(&mut b,&mut r,SCRATCH).unwrap(),n(&c["manager"]));assert_snapshot(&mut b,&c["initial"]);
        assert_eq!(b.trace,expected(c,&["hashes","produce"]));assert_eq!(r.snapshot().owned_allocations,14);
        assert!(matches!(r.phase,Phase::Published));assert!(!r.backpointers);
        wire_backpointers(&mut b,&mut r).unwrap();assert_snapshot(&mut b,&c["wired"]);
        assert_eq!(b.trace,expected(c,&["hashes","produce","wire"]));
        retire_empty(&mut b,&mut r).unwrap();let mut all=expected(c,&["hashes","produce","wire","destroy"]);
        for i in 0..4{all.push(Event::Write(GLOBAL+i,0));}assert_eq!(b.trace,all);
        assert!(b.live.is_empty()&&r.is_retired());assert_eq!(b.word(GLOBAL).unwrap(),0);assert!(b.queue.is_empty());
    }
}
#[test]
fn audio_loading_resource_manager_null_producer_and_external_global_are_distinct(){
    let proof=fixture();let c=&proof["cases"][0];
    let native:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/loading_resource_manager_null_probe.json")).unwrap();
    assert_eq!(native["passed"],true);
    let mut b=host(&proof,c);let mut r=Record::default();b.null_alloc=true;
    assert_eq!(produce(&mut b,&mut r,SCRATCH),Ok(0));assert!(r.is_retired()&&b.live.is_empty());
    assert_eq!(b.trace,vec![Event::Allocate(0,172),Event::Write(GLOBAL,0),Event::Write(GLOBAL+1,0),Event::Write(GLOBAL+2,0),Event::Write(GLOBAL+3,0)]);
    b.set(GLOBAL,&0x30004000u32.to_le_bytes());let before=b.op;
    assert!(produce(&mut b,&mut r,SCRATCH).is_err());assert_eq!(b.op,before);assert_eq!(b.word(GLOBAL).unwrap(),0x30004000);
    retire_empty(&mut b,&mut r).unwrap();assert_eq!(b.word(GLOBAL).unwrap(),0x30004000,"external global is never cleared by empty Record");
}
#[test]
fn audio_loading_resource_manager_every_constructor_host_failure_keeps_raw_ownership(){
    let proof=fixture();let c=&proof["cases"][1];
    let mut baseline=host(&proof,c);initialize_hashes(&mut baseline).unwrap();let begin=baseline.op;
    produce(&mut baseline,&mut Record::default(),SCRATCH).unwrap();let end=baseline.op;
    for partial in [false,true]{for point in begin..end{
        let mut b=host(&proof,c);let mut r=Record::default();initialize_hashes(&mut b).unwrap();b.fail=Some(point);b.partial=partial;
        let primary=produce(&mut b,&mut r,SCRATCH).unwrap_err();assert!(b.fail.is_none(),"fault {point}");
        let before=b.trace.len();assert!(produce(&mut b,&mut r,SCRATCH).is_err());assert_eq!(b.trace.len(),before);
        assert_eq!(r.snapshot().owned_allocations,b.live.len());
        if !r.is_retired(){
            b.fail=Some(b.op);let cleanup=retire_empty(&mut b,&mut r).unwrap_err();
            assert!(matches!(cleanup,Error::Write(_)|Error::Free(_)));
            assert!(!r.is_retired());assert_eq!(r.snapshot().owned_allocations,b.live.len());
        }
        retire_empty(&mut b,&mut r).unwrap();assert!(r.is_retired()&&b.live.is_empty());assert_eq!(b.word(GLOBAL).unwrap(),0);
        assert!(matches!(primary,Error::Write(_)),"primary failure preserved by caller");
    }}
}
#[test]
fn audio_loading_resource_manager_each_retirement_write_and_free_failure_is_retryable(){
    let proof=fixture();let c=&proof["cases"][1];
    let mut baseline=host(&proof,c);let mut r=Record::default();initialize_hashes(&mut baseline).unwrap();produce(&mut baseline,&mut r,SCRATCH).unwrap();
    let begin=baseline.op;retire_empty(&mut baseline,&mut r).unwrap();let end=baseline.op;
    for partial in [false,true]{for point in begin..end{
        let mut b=host(&proof,c);let mut r=Record::default();initialize_hashes(&mut b).unwrap();produce(&mut b,&mut r,SCRATCH).unwrap();
        b.fail=Some(point);b.partial=partial;let primary=retire_empty(&mut b,&mut r).unwrap_err();assert!(b.fail.is_none());
        assert!(!r.is_retired());assert_eq!(r.snapshot().owned_allocations,b.live.len());
        if point!=end-1{assert_eq!(b.word(GLOBAL).unwrap(),n(&c["manager"]),"global stays through failed frees");}
        retire_empty(&mut b,&mut r).unwrap();assert!(r.is_retired()&&b.live.is_empty());assert_eq!(b.word(GLOBAL).unwrap(),0);
        let frees=b.trace.iter().filter_map(|e|match e{Event::Free(p)=>Some(*p),_=>None}).collect::<Vec<_>>();
        assert_eq!(frees,c["frees"].as_array().unwrap().iter().map(|v|n(&v["pointer"])).collect::<Vec<_>>());
        assert!(matches!(primary,Error::Write(_)|Error::Free(_)));
    }}
}
#[test]
fn audio_loading_resource_manager_refuses_populated_cache_without_free_or_mutation(){
    let proof=fixture();let c=&proof["cases"][0];let mut b=host(&proof,c);let mut r=Record::default();
    initialize_hashes(&mut b).unwrap();produce(&mut b,&mut r,SCRATCH).unwrap();let p=r.pointer();
    for off in [8,16,24,0x30,0x44,0x58,0x74,0x8c,0x9c]{
        let previous=b.word(p+off).unwrap();b.set(p+off,&1u32.to_le_bytes());let before=b.trace.clone();
        assert!(retire_empty(&mut b,&mut r).is_err());assert_eq!(before,b.trace);assert_eq!(b.live.len(),14);b.set(p+off,&previous.to_le_bytes());
    }
    let before=b.trace.len();assert!(produce(&mut b,&mut r,SCRATCH).is_err());assert_eq!(before,b.trace.len());
    retire_empty(&mut b,&mut r).unwrap();assert!(b.live.is_empty());
}

#[test]
fn audio_loading_resource_manager_hash_matches264_native_inputs_including_signed_bytes(){
    let proof=fixture();let cases=proof["hash_cases"].as_array().unwrap();assert_eq!(cases.len(),264);
    let mut b=host(&proof,&proof["cases"][0]);let address=0x30006000;
    b.memory.reserve_at(address,128).unwrap();
    for c in cases{
        let p=if c["null"].as_bool().unwrap(){0}else{let mut s=bytes(c["bytes_hex"].as_str().unwrap());s.push(0);b.set(address,&s);address};
        assert_eq!(hash65599(&mut b,p).unwrap(),n(&c["value"]),"{c}");
    }
}
