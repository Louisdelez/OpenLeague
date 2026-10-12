use crate::audio_announcer_object_lookup::{self as read, Memory};
use crate::audio_replay_callbacks::{self as cb, Error, InvocationBoundary, SixArguments, SixValues};
use serde_json::{json, Value};
use std::collections::BTreeMap;
const REF:u32=0x31000000;
struct Backend {
    words:BTreeMap<u32,u32>, reads:Vec<[u32;2]>, calls:Vec<Value>, result:u32,
}
impl Memory for Backend {
    fn word(&mut self,p:u32)->Result<u32,read::Error>{
        self.reads.push([p,4]);self.words.get(&p).copied().ok_or(read::Error::MissingWord(p))
    }
}
impl InvocationBoundary for Backend {
    fn member_two(&mut self,owner:u32,member:u32,first:u32,second:u32)->Result<u32,&'static str>{
        self.calls.push(json!({"owner":owner,"member":member,"args":[first,second]}));Ok(self.result)
    }
    fn member_six(&mut self,owner:u32,member:u32,args:SixValues)->Result<u32,&'static str>{
        self.calls.push(json!({"owner":owner,"member":member,"args":[args.first,args.second,args.third,args.fourth,args.fifth,args.sixth]}));Ok(self.result)
    }
    fn member_zero(&mut self,owner:u32,member:u32)->Result<u32,&'static str>{
        self.calls.push(json!({"owner":owner,"member":member,"args":[]}));Ok(self.result)
    }
}
// The default contract must reject unconnected consumers without successful stubs.
struct Disconnected(Backend);
impl Memory for Disconnected {fn word(&mut self,p:u32)->Result<u32,read::Error>{self.0.word(p)}}
impl InvocationBoundary for Disconnected {}
fn n(v:&Value)->u32{v.as_u64().unwrap().try_into().unwrap()}
fn proof()->Value{serde_json::from_str(include_str!("signatures_native_probe.json")).unwrap()}
fn backend(c:&Value)->Backend{
    let p=n(&c["callback"]);let mut words=BTreeMap::new();
    let before=c["before"].as_str().unwrap();
    for i in (0..before.len()).step_by(8){
        let bytes:Vec<u8>=(i..i+8).step_by(2).map(|j|u8::from_str_radix(&before[j..j+2],16).unwrap()).collect();
        words.insert(p+(i/2)as u32,u32::from_le_bytes(bytes.try_into().unwrap()));
    }
    words.insert(REF,0xa5c37129);words.insert(REF+4,0x8f4e5a67);
    Backend{words,reads:vec![],calls:vec![],result:c["supplied_return"].as_u64().unwrap_or(0)as u32}
}
fn invoke(b:&mut impl InvocationBoundary,c:&Value)->Result<u32,Error>{
    let p=n(&c["callback"]);let a:Vec<u32>=c["args"].as_array().unwrap().iter().map(n).collect();
    match n(&c["wrapper"]){
        0x65e9e0=>cb::invoke65e9e0(b,p,a[0],a[1]),
        0x7341d0=>cb::invoke7341d0(b,p,a[0],a[1]),
        0x734080=>cb::invoke734080(b,p,SixArguments{first_ref:a[0],second_ref:a[1],third:a[2],fourth:a[3],fifth:a[4],sixth:a[5]}),
        0x733f70=>cb::invoke733f70(b,p), _=>panic!("unknown fixture wrapper"),
    }
}
fn qualify(wrapper:u32,count:usize){
    let proof=proof();assert_eq!(proof["passed"],true);
    assert_eq!(proof["native_sha256"],"402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862");
    let cases:Vec<_>=proof["cases"].as_array().unwrap().iter().filter(|c|n(&c["wrapper"])==wrapper).collect();assert_eq!(cases.len(),count);
    for (i,c) in cases.iter().enumerate(){
        let mut b=backend(c);let before=b.words.clone();
        assert_eq!(invoke(&mut b,c),Ok(n(&c["return"])),"result {wrapper:X}/{i}");
        assert_eq!(json!(b.reads),c["reads"],"read order {wrapper:X}/{i}");
        assert_eq!(json!(b.calls),c["trace"],"terminal args {wrapper:X}/{i}");
        assert_eq!(before,b.words);assert_eq!(c["terminal_body_executed"],false);
        assert!(c["tail_reads"].as_array().unwrap().is_empty());
        assert!(!b.words.contains_key(&(n(&c["callback"])+n(&c["size"]))));
    }
}
#[test]fn two_value_signature_matches72_native_cases_and_wrapping_adjustments(){qualify(0x65e9e0,72);}
#[test]fn second_reference_signature_matches180_native_cases_and_alias_read_order(){qualify(0x7341d0,180);}
#[test]fn six_value_signature_matches72_native_cases_second_reference_read_first(){qualify(0x734080,72);}
#[test]fn zero_argument_signature_matches12_native_cases_and_full_returns(){qualify(0x733f70,12);}
#[test]fn real_false_leaves_preserve_high_eax_bits_and_their_wrappers_execute_no_external_consumer(){
    let proof=proof();let leaves=proof["direct_leaves"].as_array().unwrap();assert_eq!(leaves.len(),12);
    for c in leaves{
        let result=match n(&c["leaf"]){0x586230=>cb::leaf_false586230(n(&c["incoming_eax"])),0x71ec30=>cb::leaf_false71ec30(n(&c["incoming_eax"])),_=>panic!()};
        assert_eq!(result,n(&c["return"]));assert_eq!(result as u8,0);
        assert_eq!(n(&c["final_stack_delta"]),if n(&c["leaf"])==0x586230{4}else{28});
    }
    let cases=proof["real_leaf_wrappers"].as_array().unwrap();assert_eq!(cases.len(),12);
    for c in cases{
        let mut b=Disconnected(backend(c));let before=b.0.words.clone();
        assert_eq!(invoke(&mut b,c),Ok(n(&c["return"])));assert_eq!(json!(b.0.reads),c["reads"]);
        assert_eq!(before,b.0.words);assert!(b.0.calls.is_empty());assert_eq!(c["terminal_body_executed"],true);
        assert_eq!(n(&c["return"]),if n(&c["wrapper"])==0x733f70{0x586200}else{0x71ec00});
    }
}
#[test]fn unknown_consumers_are_explicit_errors_for_each_signature(){
    let proof=proof();
    for (wrapper,message)in[(0x65e9e0,"two-argument replay member is not connected"),(0x7341d0,"two-argument replay member is not connected"),(0x734080,"six-argument replay member is not connected"),(0x733f70,"zero-argument replay member is not connected")]{
        let c=proof["cases"].as_array().unwrap().iter().find(|c|n(&c["wrapper"])==wrapper).unwrap();
        let mut b=Disconnected(backend(c));assert_eq!(invoke(&mut b,c),Err(Error::Boundary(message)));
        assert_eq!(json!(b.0.reads),c["reads"]);assert!(b.0.calls.is_empty());
        let mut null=c.clone();null["callback"]=json!(0);b.0.reads.clear();
        assert_eq!(invoke(&mut b,&null),Err(Error::NullCallback));assert!(b.0.reads.is_empty());
    }
}
#[test]fn missing_references_fail_before_later_reads_even_for_true_false_leaves(){
    let proof=proof();let c=&proof["real_leaf_wrappers"][0];let p=n(&c["callback"]);let mut b=backend(c);
    let mut args=SixArguments{first_ref:REF,second_ref:0xdead0000,third:3,fourth:4,fifth:5,sixth:6};
    assert_eq!(cb::invoke734080(&mut b,p,args),Err(Error::Read(read::Error::MissingWord(0xdead0000))));
    assert_eq!(b.reads,vec![[0xdead0000,4]]);assert!(b.calls.is_empty());
    args.first_ref=0xdead0000;args.second_ref=REF;b.reads.clear();
    assert_eq!(cb::invoke734080(&mut b,p,args),Err(Error::Read(read::Error::MissingWord(0xdead0000))));
    assert_eq!(b.reads,vec![[REF,4],[0xdead0000,4]]);assert!(b.calls.is_empty());
    b.reads.clear();assert_eq!(cb::invoke7341d0(&mut b,p,0xdead1234,0xdead0000),Err(Error::Read(read::Error::MissingWord(0xdead0000))));
    assert_eq!(b.reads,vec![[0xdead0000,4]]);assert!(b.calls.is_empty());
}
#[test]fn twelve_byte_objects_reject_sixteen_byte_wrappers_at_the_protected_tail(){
    let proof=proof();assert_eq!(proof["negative_controls"].as_array().unwrap().len(),2);
    let c=&proof["real_leaf_wrappers"][0];let p=n(&c["callback"]);
    for wrapper in [0x65e9e0,0x7341d0]{
        let mut b=backend(c);let result=if wrapper==0x65e9e0{cb::invoke65e9e0(&mut b,p,1,REF)}else{cb::invoke7341d0(&mut b,p,1,REF)};
        assert_eq!(result,Err(Error::Read(read::Error::MissingWord(p+12))));assert!(b.calls.is_empty());
        assert_eq!(b.reads,if wrapper==0x65e9e0{vec![[p+12,4]]}else{vec![[REF,4],[p+12,4]]});
        let native=proof["negative_controls"].as_array().unwrap().iter().find(|c|n(&c["wrapper"])==wrapper).unwrap();
        assert_eq!(native["faults"],json!([[p+12,4]]));assert_eq!(native["terminal_calls"],0);
    }
}
