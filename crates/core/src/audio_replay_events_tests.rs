use super::*;
use crate::audio_announcer_registry_init::OwnedMemory;
use serde_json::{json, Value};
const MANAGER:u32=0x3000a000;
const PACKET:u32=0x3000d000;
const CALLBACK:u32=0x3000e000;
const FIRST:u32=CALLBACK+0x20;
const META:u32=0x3000b500;
const VT:u32=0x3000f000;
fn number(v:&Value)->u32 {v.as_u64().unwrap() as u32}
fn unhex(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
fn hex(b:&[u8])->String{b.iter().map(|x|format!("{x:02x}")).collect()}
struct Backend { memory:OwnedMemory, events:Vec<Value>, equal:bool, setter:u32, mutate:bool, passthrough:bool, failure:bool }
impl Memory for Backend {fn word(&mut self,a:u32)->Result<u32,lookup::Error>{self.memory.word(a)}}
impl Storage for Backend {
 fn allocate(&mut self,n:u32)->Result<u32,init::Error>{self.memory.allocate(n)}
 fn write_word(&mut self,a:u32,v:u32)->Result<(),init::Error>{self.memory.write_word(a,v)}
 fn write_byte(&mut self,a:u32,v:u8)->Result<(),init::Error>{self.memory.write_byte(a,v)}
 fn register_shutdown(&mut self,c:u32)->Result<(),init::Error>{self.memory.register_shutdown(c)}
}
impl Boundary for Backend {
 fn byte(&mut self,a:u32)->Result<u8,lookup::Error>{self.memory.read_byte(a)}
 fn virtual_call(&mut self,object:u32,callback:u32,slot:u32,args:&[Argument])->Result<u32,&'static str>{
  if self.failure{return Err("consumer unavailable");}
  let index=(object-0x3000a100)/0x400;
  let expected=if index==5 {0x32009000+slot}else{0x32008000+index*0x100};
  assert_eq!(callback,expected);assert_eq!(object,0x3000a100+index*0x400);
  let values:Vec<_>=args.iter().map(|a|match a {Argument::Word(x)=>json!(x),Argument::WordRef(x)=>json!({"word_ref":x}),Argument::String(s)=>json!({"string_hex":hex(s)})}).collect();
  let mut result=0xabcdef00;
  if object==META && slot==12 {
   let key=(number(&values[0]),number(&values[1]));let offset=match key{(100,1)=>1,(200,1)=>5,(100,0)=>0x189,(200,0)=>0x18d,_=>panic!("unexpected getter")};
   result=self.word(PACKET+offset).unwrap();if !self.equal{result^=0x80000000;}
  }
  if object==META && slot==8{result=if number(&values[0])==100{self.setter}else{self.setter^1};}
  self.events.push(json!({"object":object,"slot":slot,"args":values,"result":result}));
  if self.mutate && object==META && slot==8{self.write_word(META+0x1a0,2).unwrap();self.write_word(META+0x1a4,1).unwrap();}
  Ok(result)
 }
 fn member_call(&mut self,object:u32,callback:u32,args:[u32;5])->Result<u32,&'static str>{
  if self.passthrough{
   // This boundary covers only the qualified pass-through of72C780. Object
   // commands are intentionally unavailable until their actual manager is ported.
   assert_eq!(callback,0x72c780);assert_eq!(object,MANAGER);assert!(args[4]==0 || args[2] as u8!=0);
   dispatch(self,MANAGER,args).map(|x|x as u32).map_err(|_|"dispatch failed")
  }else{
   assert_eq!(callback,0x3200a000);self.events.push(json!({"this":object,"args":args}));Ok(0xf1234501)
  }
 }
}
fn write_hex(b:&mut Backend,address:u32,text:&str){for (i,value) in unhex(text).into_iter().enumerate(){b.write_byte(address+i as u32,value).unwrap();}}
fn read_hex(b:&mut Backend,address:u32,len:u32)->String{hex(&(0..len).map(|i|b.byte(address+i).unwrap()).collect::<Vec<_>>())}
fn make(c:&Value)->Backend{
 let p=&c["profile"];
 let mut b=Backend{memory:OwnedMemory::new(0x34080000,number(&c["fill"]) as u8),events:vec![],equal:p["get_equal"].as_bool().unwrap(),setter:number(&p["setter_result"]),mutate:p["mutate"].as_bool().unwrap(),passthrough:true,failure:false};
 b.memory.reserve_at(MANAGER,0x5600).unwrap();
 write_hex(&mut b,MANAGER,c["before"]["manager_hex"].as_str().unwrap());
 write_hex(&mut b,META,c["before"]["metadata_hex"].as_str().unwrap());
 for i in 0..6{b.write_word(0x3000a100+i*0x400,VT+i*0x80).unwrap();}
 for i in 0..5{b.write_word(VT+i*0x80+8,0x32008000+i*0x100).unwrap();}
 for slot in [8,12,0x28,0x3c]{b.write_word(VT+5*0x80+slot,0x32009000+slot).unwrap();}
 for (off,value) in [(4,0x3000a900),(8,0x3000ad00)]{b.write_word(0x3000ef00+off,value).unwrap();}
 for i in 0..0x400{b.write_byte(PACKET+i,(i*37+11) as u8).unwrap();}
 b.write_byte(PACKET,number(&p["opcode"]) as u8).unwrap();
 let mut text=unhex(p["text_hex"].as_str().unwrap());text.push(0);
 for (i,v) in text.into_iter().enumerate(){b.write_byte(PACKET+0x11+i as u32,v).unwrap();}
 b.write_word(PACKET+10,number(&p["flag"])).unwrap();
 for (off,value) in [(0,0x10afd08),(4,MANAGER),(8,0x72c780),(12,0)]{b.write_word(CALLBACK+off,value).unwrap();}
 b.write_word(FIRST,0x87654321).unwrap();b
}
fn proof()->Value{serde_json::from_str(&crate::audio_test_fixture("data/4.20/replay_dispatch_contract.json")).unwrap()}
#[test]fn audio_replay_dispatch_matches445_native_selector_packet_and_metadata_cases(){
 let p=proof();let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),445);
 for (index,c) in cases.iter().enumerate(){
  let mut b=make(c);let args:[u32;5]=c["args"].as_array().unwrap().iter().map(number).collect::<Vec<_>>().try_into().unwrap();
  let result=if c["through_callback"].as_bool().unwrap(){invoke(&mut b,CALLBACK,[FIRST,args[1],args[2],args[3],args[4]]).unwrap()}else{dispatch(&mut b,MANAGER,args).unwrap() as u32};
  assert_eq!(result,number(&c["result_al"]),"case{index}");assert_eq!(json!(b.events),c["after"]["events"],"case{index}");
  assert_eq!(read_hex(&mut b,MANAGER,0x44),c["after"]["manager_hex"].as_str().unwrap(),"manager{index}");
  assert_eq!(read_hex(&mut b,META,0x220),c["after"]["metadata_hex"].as_str().unwrap(),"metadata{index}");
  if let Some(native)=c["metadata_returns"].as_array().unwrap().first(){
   let mut b=make(c);assert_eq!(update_metadata(&mut b,META,PACKET).unwrap() as u32,number(native));
   assert_eq!(read_hex(&mut b,META,0x220),c["after"]["metadata_hex"].as_str().unwrap());
  }
 }
}
#[test]fn audio_replay_member_callback_matches36_native_wrapping_and_return_cases(){
 let p=proof();let cases=p["invocations"].as_array().unwrap();assert_eq!(cases.len(),36);
 for c in cases{let mut b=make(&p["cases"][0]);b.passthrough=false;
  b.write_word(CALLBACK+4,number(&c["owner"])).unwrap();b.write_word(CALLBACK+8,0x3200a000).unwrap();b.write_word(CALLBACK+12,number(&c["adjustment"])).unwrap();b.write_word(FIRST,number(&c["value"])).unwrap();
  assert_eq!(invoke(&mut b,CALLBACK,[FIRST,0xabc,0x12345678,0xdef,PACKET]).unwrap(),number(&c["result"]));assert_eq!(json!(b.events),c["observed"]);
 }
}
#[test]fn audio_replay_missing_consumers_and_truncated_packets_are_errors(){
 let p=proof();let mut b=make(&p["cases"][0]);
 b.write_word(MANAGER+0x24,0).unwrap();assert_eq!(dispatch(&mut b,MANAGER,[0,2,0,0,0]),Err(Error::NullObject));
 assert_eq!(dispatch(&mut b,MANAGER,[0,4,0,123,0]),Ok(1));assert_eq!(b.word(MANAGER+4),Ok(123));
 b.write_word(MANAGER+0x28,0).unwrap();assert!(matches!(dispatch(&mut b,MANAGER,[0,3,5,0,0]),Err(Error::Read(_))));
 b.failure=true;assert_eq!(dispatch(&mut b,MANAGER,[0,3,2,0,PACKET]),Err(Error::Boundary("consumer unavailable")));
 b.failure=false;b.write_byte(PACKET,101).unwrap();
 // An unterminated string reaches a checked storage boundary instead of inventing text.
 for i in 0x11..0x2600{b.write_byte(PACKET+i,255).unwrap();}
 assert!(matches!(dispatch(&mut b,MANAGER,[0,3,7,0,PACKET]),Err(Error::Read(_))));
}
