use super::*;
use crate::audio_announcer_object_lookup::Memory;
use crate::audio_announcer_registry_init::OwnedMemory;
use crate::audio_announcer_owner_component_destructor::ControlBoundary;
use serde_json::{json, Value};

const H:u32=0x30000000;
const SCR:u32=H+0x100;
const DST:u32=H+0x120;
const A:u32=H+0x200;
const VT2:u32=H+0x310;
const RECIP:u32=H+0x420;
const PACKET:u32=H+0x600;
fn n(v:&Value)->u32{v.as_u64().unwrap() as u32}
struct Host {
    memory:OwnedMemory, trace:Vec<Value>, mode:String, dest:u32,
    fail_receive:bool, fail_decrement:bool,
}
impl Host {
    fn raw(&mut self,a:u32)->u32{self.memory.word(a).unwrap()}
    fn put(&mut self,a:u32,v:u32){self.memory.write_word(a,v).unwrap();}
    fn event(&mut self,op:&str,p:u32,method:u32,payload:Option<u32>){
        let mut e=json!({"op":op,"object":p,"method":method,
            "global":[self.raw(GLOBAL_PAIR),self.raw(GLOBAL_PAIR+4)],
            "destination":[self.raw(self.dest),self.raw(self.dest+4)]});
        if let Some(payload)=payload{e["payload"]=json!(payload);e["counts"]=json!([self.raw(A+4),self.raw(A+8)]);}
        else{e["counts"]=json!([self.raw(p+4),self.raw(p+8)]);}
        self.trace.push(e);
        if op=="receive" {
            if matches!(self.mode.as_str(),"clear_global"|"drop_global"){self.put(GLOBAL_PAIR,0);self.put(GLOBAL_PAIR+4,0);}
            if self.mode=="drop_global" && p==RECIP{let old=self.raw(A+4);self.put(A+4,old.wrapping_sub(1));}
            if self.mode=="retarget_vtable"{self.put(A,VT2);}
        }else if op=="dispose" {
            if self.mode=="dispose_mutates_global"{self.put(GLOBAL_PAIR,0xfeed1234);self.put(GLOBAL_PAIR+4,0);}
            if self.mode=="dispose_retargets"{self.put(p,VT2);}
            if self.mode=="dispose_weak2"{self.put(p+8,2);}
        }
    }
}
impl Memory for Host {
    fn word(&mut self,a:u32)->Result<u32,lookup::Error>{
        let v=self.memory.word(a)?;self.trace.push(json!({"op":"read","address":a,"value":v}));Ok(v)
    }
}
impl Storage for Host {
    fn write_word(&mut self,a:u32,v:u32)->Result<(),init::Error>{
        self.memory.write_word(a,v)?;self.trace.push(json!({"op":"write","address":a,"value":v}));Ok(())
    }
    fn allocate(&mut self,_:u32)->Result<u32,init::Error>{panic!("native packet95 does not allocate")}
    fn write_byte(&mut self,_:u32,_:u8)->Result<(),init::Error>{panic!("unexpected byte write")}
    fn register_shutdown(&mut self,_:u32)->Result<(),init::Error>{panic!("unexpected registration")}
}
impl pair::Boundary for Host {
    fn increment_reference(&mut self,a:u32)->Result<u32,&'static str>{
        let old=self.raw(a);self.trace.push(json!({"op":"increment","address":a,"old":old}));self.put(a,old.wrapping_add(1));Ok(old)
    }
}
impl ControlBoundary for Host {
    fn decrement_reference(&mut self,a:u32)->Result<u32,&'static str>{
        if self.fail_decrement{return Err("injected decrement failure");}
        let old=self.raw(a);self.trace.push(json!({"op":"decrement","address":a,"old":old}));self.put(a,old.wrapping_sub(1));Ok(old)
    }
    fn dispose(&mut self,p:u32,method:u32)->Result<(),&'static str>{self.event("dispose",p,method,None);Ok(())}
    fn release_control(&mut self,p:u32,method:u32)->Result<(),&'static str>{self.event("release",p,method,None);Ok(())}
}
impl Boundary for Host {
    fn receive_payload(&mut self,p:u32,method:u32,payload:u32)->Result<(),&'static str>{
        self.event("receive",p,method,Some(payload));
        if self.fail_receive{Err("recipient not connected")}else{Ok(())}
    }
}
fn proof()->Value{serde_json::from_str(&crate::audio_test_fixture("data/4.20/replay_packet95_probe.json")).unwrap()}
fn host(c:&Value,consumer:bool)->Host{
    let mut b=Host{memory:OwnedMemory::new(0x34000000,n(&c["fill"]) as u8),trace:vec![],mode:c["mode"].as_str().unwrap().into(),dest:if consumer{SCR}else{n(&c["destination"])},fail_receive:false,fail_decrement:false};
    b.memory.reserve_at(H,0x1000).unwrap();b.memory.reserve_at(GLOBAL_PAIR,8).unwrap();
    for word in c["before"].as_array().unwrap(){b.put(n(&word[0]),n(&word[1]));}
    b
}
fn compare(b:&mut Host,c:&Value){
    assert_eq!(json!(b.trace),c["trace"],"profile {} mode {} relation {}",c["profile"],c["mode"],c["relation"]);
    for word in c["after"].as_array().unwrap(){assert_eq!(b.raw(n(&word[0])),n(&word[1]),"word {word}");}
    assert!(b.memory.allocations.is_empty());assert!(b.memory.released_labels.is_empty());
}
#[test]
fn audio_replay_packet95_matches148_native_consumers_and_ordered_release(){
    let p=proof();let cases=p["consumers"].as_array().unwrap();assert_eq!(cases.len(),148);
    for c in cases{let mut b=host(c,true);assert_eq!(consume_packet(&mut b,PACKET,SCR).unwrap(),n(&c["result_al"]) as u8);compare(&mut b,c);}
}
#[test]
fn audio_replay_packet95_matches192_native_global_assignments(){
    let p=proof();let cases=p["assignments"].as_array().unwrap();assert_eq!(cases.len(),192);
    for c in cases{let mut b=host(c,false);acquire_global(&mut b,n(&c["destination"])).unwrap();compare(&mut b,c);}
}
#[test]
fn audio_replay_packet95_boundary_failures_release_acquired_reference_and_report_cleanup(){
    let p=proof();let c=p["consumers"].as_array().unwrap().iter().find(|c|c["profile"]=="owned"&&c["mode"]=="observe").unwrap();
    let mut b=host(c,true);b.fail_receive=true;
    assert_eq!(consume_packet(&mut b,PACKET,SCR),Err(Error::Boundary("recipient not connected")));
    assert_eq!(b.raw(A+4),1);assert_eq!(b.raw(SCR+4),A);
    let last=b.trace.last().unwrap();assert_eq!(last,&json!({"op":"decrement","address":A+4,"old":2}));
    let mut b=host(c,true);b.fail_receive=true;b.fail_decrement=true;
    assert_eq!(consume_packet(&mut b,PACKET,SCR),Err(Error::Cleanup{cause:Box::new(Error::Boundary("recipient not connected")),cleanup:pair::Error::Boundary("injected decrement failure")}));
    assert_eq!(b.raw(A+4),2);
    let mut b=host(c,true);b.put(H+0x400,0xdead0000);
    assert!(matches!(consume_packet(&mut b,PACKET,SCR),Err(Error::Read(_))));assert_eq!(b.raw(A+4),1);
    let mut b=host(c,true);assert_eq!(consume_packet(&mut b,u32::MAX,SCR),Err(Error::AddressOverflow));assert!(b.trace.is_empty());
}
