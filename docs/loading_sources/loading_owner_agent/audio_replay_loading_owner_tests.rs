use super::*;
use serde_json::{json,Value};
use std::collections::{BTreeMap,BTreeSet,VecDeque};
const H:u32=0x30000000;const PAIR:u32=H+0x400;const TMP:u32=H+0x420;const SRC:u32=H+0x100;const RAW:u32=H+0x200;const RVT:u32=H+0x600;
const CLOSE:u32=0x32000300;const DELETE:u32=0x32000400;const CUSTOM:u32=0x32000500;
fn n(v:&Value)->u32{v.as_u64().unwrap()as u32}
fn bytes(v:&Value)->Vec<u8>{let s=v.as_str().unwrap();(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
fn hex(v:impl Iterator<Item=u8>)->String{v.map(|b|format!("{b:02x}")).collect()}
struct Owned{memory:init::OwnedMemory,live:BTreeMap<u32,u32>,locks:BTreeSet<u32>,queue:VecDeque<(u32,u32)>,ops:Vec<Value>,fill:u8}
impl Memory for Owned{fn word(&mut self,p:u32)->Result<u32,lookup::Error>{self.memory.word(p)}}
impl Storage for Owned{
 fn allocate(&mut self,size:u32)->Result<u32,init::Error>{let(s,p)=self.queue.pop_front().expect("unexpected allocation");assert_eq!(size,s);if p!=0{self.memory.reserve_at(p,size)?;self.live.insert(p,size);}self.ops.push(json!({"op":"allocate","bytes":size,"pointer":p}));Ok(p)}
 fn write_word(&mut self,p:u32,v:u32)->Result<(),init::Error>{Storage::write_word(&mut self.memory,p,v)}
 fn write_byte(&mut self,p:u32,v:u8)->Result<(),init::Error>{self.memory.write_byte(p,v)}
 fn register_shutdown(&mut self,_:u32)->Result<(),init::Error>{Err(init::Error::Backend("no loading atexit boundary"))}
}
impl RemovalBackend for Owned{
 fn write_word(&mut self,p:u32,v:u32)->Result<(),remove::Error>{Storage::write_word(&mut self.memory,p,v).map_err(remove::Error::Owned)}
 fn deallocator(&mut self)->Result<Deallocator,remove::Error>{let target=self.word(0x14bef40)?;Ok(if target==0{Deallocator::Standard}else{Deallocator::Custom{callback:target,context:self.word(0x14bef44)?}})}
 fn free(&mut self,p:u32,route:Deallocator)->Result<(),remove::Error>{let size=*self.live.get(&p).expect("free of unowned block");let data=hex((0..size).map(|i|self.memory.read_byte(p+i).unwrap()));let global=[self.word(GLOBAL_PAIR)?,self.word(GLOBAL_PAIR+4)?];let pair=[self.word(PAIR)?,self.word(PAIR+4)?];self.ops.push(json!({"op":"free","pointer":p,"route":match route{Deallocator::Standard=>0,Deallocator::Custom{callback,..}=>callback},"hex":data,"global":global,"pair":pair}));self.live.remove(&p);self.memory.release(p).map_err(remove::Error::Owned)}
}
impl ControlBoundary for Owned{
 fn decrement_reference(&mut self,p:u32)->Result<u32,&'static str>{let v=self.word(p).map_err(|_|"missing count")?;Storage::write_word(self,p,v.wrapping_sub(1)).map_err(|_|"count write")?;Ok(v)}
 fn dispose(&mut self,p:u32,target:u32)->Result<(),&'static str>{match target{WRAPPER_DISPOSE=>dispose_wrapper(self,p),RECIPIENT_DISPOSE=>dispose_recipient(self,p),_=>panic!("unqualified control dispose {target:x}")}.map_err(|_|"loading dispose error")}
 fn release_control(&mut self,p:u32,target:u32)->Result<(),&'static str>{assert_eq!(target,control::RELEASE);control::release(self,p).map_err(|_|"control release error")}
}
impl Boundary for Owned{
 fn read_byte(&mut self,p:u32)->Result<u8,lookup::Error>{self.memory.read_byte(p)}
 fn initialize_lock(&mut self,p:u32)->Result<(),&'static str>{assert!(self.locks.insert(p));for i in 0..24{self.memory.write_byte(p+i,0).unwrap();}self.ops.push(json!({"op":"initialize_lock","pointer":p}));Ok(())}
 fn destroy_lock(&mut self,p:u32)->Result<(),&'static str>{assert!(self.locks.remove(&p));self.ops.push(json!({"op":"destroy_lock","pointer":p}));Ok(())}
 fn recipient_virtual(&mut self,p:u32,target:u32,slot:u32,flags:Option<u32>)->Result<(),&'static str>{assert_eq!((target,slot,flags),if target==CLOSE{(CLOSE,12,None)}else{(DELETE,16,Some(1))});let global=[self.word(GLOBAL_PAIR).unwrap(),self.word(GLOBAL_PAIR+4).unwrap()];let pair=[self.word(PAIR).unwrap(),self.word(PAIR+4).unwrap()];let active=self.word(ACTIVE_GLOBAL).unwrap();self.ops.push(json!({"op":"recipient","pointer":p,"target":target,"slot":slot,"flags":flags,"global":global,"pair":pair,"active_global":active}));if target==DELETE{let route=self.deallocator().unwrap();self.free(p,route).unwrap();}Ok(())}
}
impl Owned{
 fn write_bytes(&mut self,p:u32,v:&[u8]){for(i,b)in v.iter().enumerate(){self.memory.write_byte(p+i as u32,*b).unwrap();}}
 fn load_state(&mut self,v:&Value){let blocks=v["blocks"].as_array().unwrap();let new:BTreeMap<_,_>=blocks.iter().map(|a|(n(&a["pointer"]),n(&a["size"]))).collect();for p in self.live.keys().filter(|p|!new.contains_key(p)).copied().collect::<Vec<_>>(){self.memory.release(p).unwrap();}for a in blocks{let p=n(&a["pointer"]);let size=n(&a["size"]);if !self.live.contains_key(&p){self.memory.reserve_at(p,size).unwrap();}self.write_bytes(p,&bytes(&a["hex"]));}self.live=new;self.locks=v["locks"].as_array().unwrap().iter().map(n).collect();for(p,key)in[(GLOBAL_PAIR,"global"),(PAIR,"pair")]{for i in 0..2{Storage::write_word(self,p+i*4,n(&v[key][i as usize])).unwrap();}}Storage::write_word(self,ACTIVE_GLOBAL,n(&v["active_global"])).unwrap();}
 fn queue(&mut self,step:&Value){assert!(self.queue.is_empty());self.queue=step["operations"].as_array().unwrap().iter().filter(|v|v["op"]=="allocate").map(|v|(n(&v["bytes"]),n(&v["pointer"]))).collect();self.ops.clear();}
 fn state(&mut self)->Value{let blocks=self.live.iter().map(|(&p,&size)|json!({"pointer":p,"size":size,"hex":hex((0..size).map(|i|self.memory.read_byte(p+i).unwrap()))})).collect::<Vec<_>>();json!({"blocks":blocks,"global":[self.word(GLOBAL_PAIR).unwrap(),self.word(GLOBAL_PAIR+4).unwrap()],"pair":[self.word(PAIR).unwrap(),self.word(PAIR+4).unwrap()],"active_global":self.word(ACTIVE_GLOBAL).unwrap(),"locks":self.locks})}
 fn compare(&mut self,step:&Value,label:&str){assert!(self.queue.is_empty(),"allocations remaining {label}");assert_eq!(json!(self.ops),step["operations"],"operations {label}");assert_eq!(self.state(),step["state"],"state {label}");self.ops.clear();}
}
fn setup(proof:&Value,fill:u8,custom:bool,language:&[u8])->Owned{
 let mut b=Owned{memory:init::OwnedMemory::new(0x35000000,fill),live:BTreeMap::new(),locks:BTreeSet::new(),queue:VecDeque::new(),ops:vec![],fill};
 for(p,size)in[(GLOBAL_PAIR,8),(LANGUAGE_GLOBAL,4),(ACTIVE_GLOBAL,4),(C_LOCALE_FLAG,4),(0x14bef40,8),(H,0x1000)]{b.memory.reserve_at(p,size).unwrap();}
 for region in proof["source_regions"].as_array().unwrap(){if ["control_vtables","language_literal"].contains(&region["label"].as_str().unwrap()){let p=n(&region["address"]);b.memory.reserve_at(p,n(&region["size"])).unwrap();b.write_bytes(p,&bytes(&region["hex"]));}}
 for(p,v)in[(GLOBAL_PAIR,0),(GLOBAL_PAIR+4,0),(PAIR,0),(PAIR+4,0),(ACTIVE_GLOBAL,0xabcdef01),(LANGUAGE_GLOBAL,SRC),(C_LOCALE_FLAG,0),(0x14bef40,if custom{CUSTOM}else{0}),(0x14bef44,0x11223344),(RVT+12,CLOSE),(RVT+16,DELETE),(SRC+16,language.len()as u32),(SRC+20,if language.len()<16{15}else{language.len()as u32|15})]{Storage::write_word(&mut b,p,v).unwrap();}
 let chars=if language.len()<16{SRC}else{Storage::write_word(&mut b,SRC,RAW).unwrap();RAW};b.write_bytes(chars,language);b.memory.write_byte(chars+language.len()as u32,0).unwrap();b
}
#[test]
fn audio_replay_loading_owner_matches48_native_constructors_populated_teardowns_and_strings(){
 let proof:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/loading_owner_probe.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),48);
 for (i,c)in cases.iter().enumerate(){let mut b=setup(&proof,n(&c["fill"])as u8,c["custom"].as_bool().unwrap(),&bytes(&c["language_hex"]));b.queue(&c["constructed"]);let p=b.allocate(128).unwrap();assert_eq!(p,n(&c["wrapper"]));assert_eq!(construct(&mut b,p,TMP).unwrap(),p);b.compare(&c["constructed"],&format!("construct {i}"));b.load_state(&c["prepared"]["state"]);b.queue(&c["destroyed"]);destroy(&mut b,p).unwrap();b.compare(&c["destroyed"],&format!("destroy {i}"));b.queue(&c["shutdown"]);b.free(p,Deallocator::Standard).unwrap();b.compare(&c["shutdown"],&format!("shutdown {i}"));assert!(b.live.is_empty()&&b.locks.is_empty());}
}
#[test]
fn audio_replay_loading_owner_matches96_native_global_nested_publication_and_null_control_cases(){
 let proof:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/loading_owner_probe.json")).unwrap();let cases=proof["publications"].as_array().unwrap();assert_eq!(cases.len(),96);
 for(i,c)in cases.iter().enumerate(){let mut b=setup(&proof,n(&c["fill"])as u8,c["custom"].as_bool().unwrap(),b"en_US");b.load_state(&c["seed"]["state"]);b.queue(&c["changed"]);let recipient=c["kind"]=="recipient";let destination=n(&c["destination"]);let old=n(&c["old"]);let new=n(&c["new"]);let oldcontrol=n(&c["oldcontrol"]);publish(&mut b,destination,new,recipient,TMP).unwrap();b.compare(&c["changed"],&format!("publish {i}"));let newcontrol=b.word(destination+4).unwrap();b.queue(&c["shutdown"]);
  if b.live.contains_key(&old){if recipient{dispose_recipient(&mut b,oldcontrol).unwrap();}else{dispose_wrapper(&mut b,oldcontrol).unwrap();}}
  if b.live.contains_key(&oldcontrol){control::release(&mut b,oldcontrol).unwrap();}
  if newcontrol!=0{if recipient{dispose_recipient(&mut b,newcontrol).unwrap();}else{dispose_wrapper(&mut b,newcontrol).unwrap();}control::release(&mut b,newcontrol).unwrap();}
  else if recipient{b.recipient_virtual(new,DELETE,16,Some(1)).unwrap();}else{destroy(&mut b,new).unwrap();b.free(new,Deallocator::Standard).unwrap();}
  b.compare(&c["shutdown"],&format!("shutdown {i}"));assert!(b.live.is_empty()&&b.locks.is_empty());
 }
}
