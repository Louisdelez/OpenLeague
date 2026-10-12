use super::*;
use crate::audio_announcer_object_lookup::{self as read,Memory};
use crate::audio_announcer_registry_init::{self as init,OwnedMemory};
use crate::audio_announcer_registry_remove::Backend as Free;
use serde_json::{json,Value};
use std::collections::{BTreeMap,VecDeque};
fn n(v:&Value)->u32 {v.as_u64().unwrap() as u32}
fn decode(s:&str)->Vec<u8> {s.as_bytes().chunks_exact(2).map(|b|u8::from_str_radix(std::str::from_utf8(b).unwrap(),16).unwrap()).collect()}
fn fixture()->Value {serde_json::from_str(&crate::audio_test_fixture("data/4.20/loading_owned_string_probe.json")).unwrap()}
#[derive(Clone,Copy)]
struct Fault {address:u32,width:u32,occurrence:u32,after_old_free:bool}
struct Host {
    memory:OwnedMemory,live:BTreeMap<u32,u32>,queue:VecDeque<Value>,old:u32,
    released:Vec<u32>,attempted:Vec<u32>,events:Vec<Value>,fault:Option<Fault>,
    seen:u32,fail_release:Option<u32>,release_failed:bool,
}
impl Host {
    fn bytes(&self,p:u32,size:u32)->Vec<u8> {(p..p+size).map(|p|self.memory.read_byte(p).unwrap()).collect()}
    fn set(&mut self,p:u32,data:&[u8]) {for(i,&v)in data.iter().enumerate(){self.memory.write_byte(p+i as u32,v).unwrap();}}
    fn before_write(&mut self,p:u32,width:u32)->Result<(),init::Error> {
        if let Some(f)=self.fault {
            if p==f.address && width==f.width && (!f.after_old_free || self.released.contains(&self.old)) {
                self.seen+=1;
                if self.seen==f.occurrence {self.fault=None;return Err(init::Error::Backend("injected atomic write failure"));}
            }
        }Ok(())
    }
}
impl Memory for Host {
    fn word(&mut self,p:u32)->Result<u32,read::Error> {self.events.push(json!(["read",p,4]));self.memory.word(p)}
}
impl Storage for Host {
    fn allocate(&mut self,size:u32)->Result<u32,init::Error> {
        let a=self.queue.pop_front().expect("unexpected allocation");assert_eq!(n(&a["bytes"]),size);
        let p=n(&a["pointer"]);self.memory.reserve_at(p,size)?;assert!(self.live.insert(p,size).is_none());Ok(p)
    }
    fn write_word(&mut self,p:u32,value:u32)->Result<(),init::Error> {
        self.before_write(p,4)?;self.events.push(json!(["write",p,4]));Storage::write_word(&mut self.memory,p,value)
    }
    fn write_byte(&mut self,p:u32,value:u8)->Result<(),init::Error> {
        self.before_write(p,1)?;self.events.push(json!(["write",p,1]));self.memory.write_byte(p,value)
    }
    fn register_shutdown(&mut self,_:u32)->Result<(),init::Error> {Err(init::Error::Backend("unexpected registration"))}
}
impl Free for Host {
    fn write_word(&mut self,p:u32,value:u32)->Result<(),removal::Error> {Storage::write_word(self,p,value).map_err(removal::Error::Owned)}
    fn deallocator(&mut self)->Result<Deallocator,removal::Error> {self.events.push(json!(["route"]));Ok(Deallocator::Standard)}
    fn free(&mut self,p:u32,_:Deallocator)->Result<(),removal::Error> {
        self.attempted.push(p);
        if self.fail_release==Some(p) && !self.release_failed {self.release_failed=true;return Err(removal::Error::Backend("injected atomic release failure"));}
        assert!(self.live.contains_key(&p),"double free or unowned release {p:08x}");
        self.memory.release(p).map_err(removal::Error::Owned)?;self.live.remove(&p);self.released.push(p);Ok(())
    }
}
impl metadata::Boundary for Host {
    fn read_byte(&mut self,p:u32)->Result<u8,read::Error> {self.memory.read_byte(p)}
    fn initialize_lock(&mut self,_:u32)->Result<(),&'static str> {Err("no locks in string assignment")}
    fn destroy_lock(&mut self,_:u32)->Result<(),&'static str> {Err("no locks in string assignment")}
    fn enter_lock(&mut self,_:u32)->Result<(),&'static str> {Err("no locks in string assignment")}
    fn leave_lock(&mut self,_:u32)->Result<(),&'static str> {Err("no locks in string assignment")}
}
impl Boundary for Host {
    fn release_owned(&mut self,p:u32,route:Deallocator)->Result<(),removal::Error> {Free::free(self,p,route)}
}
fn host(c:&Value)->Host {
    let mut b=Host {memory:OwnedMemory::new(0x38000000,n(&c["fill"]) as u8),live:BTreeMap::new(),queue:VecDeque::new(),
        old:c["destination_heap"]["pointer"].as_u64().unwrap_or(0) as u32,released:vec![],attempted:vec![],events:vec![],fault:None,seen:0,
        fail_release:None,release_failed:false};
    for (p,hex) in [(n(&c["source"]),c["source_descriptor_hex"].as_str().unwrap()),
                    (n(&c["destination"]),c["destination_descriptor_hex"].as_str().unwrap())] {
        b.memory.reserve_at(p,24).unwrap();b.set(p,&decode(hex));
    }
    for block in [&c["source_heap"],&c["destination_heap"]] {
        if !block.is_null(){let p=n(&block["pointer"]);let size=n(&block["bytes"]);b.memory.reserve_at(p,size).unwrap();
            b.set(p,&decode(block["hex"].as_str().unwrap()));b.live.insert(p,size);}
    }
    if !c["new_allocation"].is_null(){b.queue.push_back(c["new_allocation"].clone());}
    b
}
fn primary_write_error()->Error {Error::Write(init::Error::Backend("injected atomic write failure"))}
#[test]
fn audio_loading_owned_string_matches128_native_success_cases_and_final_read_order() {
    let proof=fixture();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),128);
    for c in cases {
        let mut b=host(c);let p=n(&c["destination"]);let mut owner=Temporary::new(p);
        if c["assignment_called"].as_bool().unwrap() {assign_owned_non_alias(&mut b,&mut owner,n(&c["source"])).unwrap();}
        assert!(b.queue.is_empty());assert_eq!(b.bytes(p,24),decode(c["expected_descriptor_hex"].as_str().unwrap()));
        assert_eq!(b.released,c["expected_assignment_frees"].as_array().unwrap().iter().map(n).collect::<Vec<_>>());
        if !c["expected_heap"].is_null(){let h=&c["expected_heap"];assert_eq!(b.bytes(n(&h["pointer"]),n(&h["bytes"])),decode(h["hex"].as_str().unwrap()));}
        if c["assignment_called"].as_bool().unwrap() {
            let last=b.events.iter().rposition(|v|*v==json!(["write",p+16,4])).unwrap();
            assert_eq!(b.events[last-1],json!(["read",p+20,4]),"native564BCB precedes564BCF");
        }
        let descriptor=b.bytes(p,24);let before=b.released.len();
        finish(&mut b,owner,Ok(())).unwrap();
        assert_eq!(b.released[before..],c["expected_cleanup_frees"].as_array().unwrap().iter().map(n).collect::<Vec<_>>());
        assert_eq!(b.bytes(p,24),descriptor,"standard cleanup must not reset descriptor");
        assert_eq!(b.live.len(),usize::from(!c["source_heap"].is_null()),"only borrowed source may remain");
    }
}
#[test]
fn audio_loading_owned_string_partial_publication_never_releases_old_buffer_twice() {
    let proof=fixture();
    for fill in [0,165] {
    let c=proof["cases"].as_array().unwrap().iter().find(|c|c["profile"]=="heap_growth" && c["fill"]==fill).unwrap();
    let p=n(&c["destination"]);let raw=n(&c["new_allocation"]["pointer"]);
    let original=decode(c["destination_descriptor_hex"].as_str().unwrap());let old_len=u32::from_le_bytes(original[16..20].try_into().unwrap());
    let source=decode(c["source_descriptor_hex"].as_str().unwrap());let length=u32::from_le_bytes(source[16..20].try_into().unwrap());
    let faults=[(p,1,1),(p,4,1),(p+20,4,1),(p+16,4,1),(raw+old_len,1,1),(raw,1,1),(p+16,4,2),(raw+length,1,1)];
    for (index,(address,width,occurrence)) in faults.into_iter().enumerate() {
        let mut b=host(c);let old=b.old;let mut owner=Temporary::new(p);
        b.fault=Some(Fault{address,width,occurrence,after_old_free:true});
        let primary=assign_owned_non_alias(&mut b,&mut owner,n(&c["source"]));
        assert_eq!(primary,Err(primary_write_error()));assert!(b.fault.is_none());
        assert_eq!(owner.authority(),Authority::Detached(raw));assert_eq!(owner.pending(),None);
        // Independently reconstruct only the native writes which precede this
        // failure. A failed descriptor write must leave this exact partial state.
        let mut expected=original.clone();
        if index>=1 {expected[0]=0;}
        if index>=2 {expected[..4].copy_from_slice(&raw.to_le_bytes());}
        if index>=3 {expected[20..24].copy_from_slice(&(n(&c["new_allocation"]["bytes"])-1).to_le_bytes());}
        if index>=7 {expected[16..20].copy_from_slice(&length.to_le_bytes());}
        assert_eq!(b.bytes(p,24),expected,"descriptor at failure index {index}, fill {fill}");
        let mut expected_heap=vec![fill as u8;n(&c["new_allocation"]["bytes"]) as usize];
        let old_heap=decode(c["destination_heap"]["hex"].as_str().unwrap());
        expected_heap[..old_len as usize].copy_from_slice(&old_heap[..old_len as usize]);
        if index>=5 {expected_heap[old_len as usize]=0;}
        if index>=6 {
            let source_heap=decode(c["source_heap"]["hex"].as_str().unwrap());
            expected_heap[..length as usize].copy_from_slice(&source_heap[..length as usize]);
        }
        assert_eq!(b.bytes(raw,n(&c["new_allocation"]["bytes"])),expected_heap);
        let descriptor=b.bytes(p,24);let before=b.events.len();
        let failure=finish(&mut b,owner,primary).unwrap_err();
        assert_eq!(failure.primary,Some(primary_write_error()));assert_eq!(failure.cleanup,None);assert_eq!(failure.remaining,None);
        assert_eq!(b.attempted.iter().filter(|&&v|v==old).count(),1);
        assert_eq!(b.released,vec![old,raw]);assert_eq!(b.bytes(p,24),descriptor);
        assert!(b.events[before..].iter().all(|e|e[0]!="read"),"detached cleanup must not read partial descriptor");
        assert_eq!(b.live.len(),1);assert!(b.live.contains_key(&n(&c["source_heap"]["pointer"])));
    }
    }
}
#[test]
fn audio_loading_owned_string_retains_primary_cleanup_and_recoverable_ownership() {
    let proof=fixture();let c=proof["cases"].as_array().unwrap().iter().find(|c|c["profile"]=="heap_growth").unwrap();
    let p=n(&c["destination"]);let raw=n(&c["new_allocation"]["pointer"]);
    let mut b=host(c);let old=b.old;let mut owner=Temporary::new(p);
    // Pointer publication succeeds; capacity publication fails. The descriptor
    // contains the new pointer but its old capacity and is never used to free.
    b.fault=Some(Fault{address:p+20,width:4,occurrence:1,after_old_free:true});
    let primary=assign_owned_non_alias(&mut b,&mut owner,n(&c["source"]));
    b.fail_release=Some(raw);let descriptor=b.bytes(p,24);
    let mut failure=finish(&mut b,owner,primary).unwrap_err();
    assert_eq!(failure.primary,Some(primary_write_error()));
    assert_eq!(failure.cleanup,Some(Error::Free(removal::Error::Backend("injected atomic release failure"))));
    let mut remaining=failure.remaining.take().expect("new live allocation must transfer to caller");
    assert_eq!(remaining.authority(),Authority::Detached(raw));assert!(b.live.contains_key(&raw));
    assert!(!b.live.contains_key(&old));assert_eq!(b.bytes(p,24),descriptor);
    // Explicit retry only after a failure known to have no release side effect.
    remaining.retire(&mut b).unwrap();assert!(remaining.is_retired());
    assert_eq!(b.released,vec![old,raw]);assert_eq!(b.attempted,vec![old,raw,raw]);
    assert_eq!(b.bytes(p,24),descriptor);assert_eq!(b.live.len(),1);
}
#[test]
fn audio_loading_owned_string_failures_before_transfer_preserve_both_owners() {
    let proof=fixture();let c=proof["cases"].as_array().unwrap().iter().find(|c|c["profile"]=="heap_growth").unwrap();
    let p=n(&c["destination"]);let raw=n(&c["new_allocation"]["pointer"]);
    for fail_old_release in [false,true] {
        let mut b=host(c);let old=b.old;let descriptor=b.bytes(p,24);let mut owner=Temporary::new(p);
        if fail_old_release {b.fail_release=Some(old);}else{b.fault=Some(Fault{address:raw,width:1,occurrence:1,after_old_free:false});}
        let primary=assign_owned_non_alias(&mut b,&mut owner,n(&c["source"]));assert!(primary.is_err());
        assert_eq!(owner.authority(),Authority::Descriptor);assert_eq!(owner.pending(),Some(raw));
        assert_eq!(b.bytes(p,24),descriptor);assert!(b.live.contains_key(&old)&&b.live.contains_key(&raw));
        let failure=finish(&mut b,owner,primary).unwrap_err();assert!(failure.primary.is_some());
        assert_eq!(failure.cleanup,None);assert_eq!(failure.remaining,None);
        assert_eq!(b.released,vec![raw,old]);assert_eq!(b.bytes(p,24),descriptor);assert_eq!(b.live.len(),1);
    }
}
