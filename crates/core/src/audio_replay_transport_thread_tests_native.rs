use super::*;
use crate::audio_announcer_object_lookup::Memory;
use crate::audio_announcer_owner_control as owner;
use serde_json::{json, Value};
use std::collections::{BTreeMap, BTreeSet, VecDeque};
pub(crate) struct Harness {
    pub(crate) memory: init::OwnedMemory, pub(crate) events: Vec<Value>, pub(crate) watched: BTreeSet<u32>,
    waits: VecDeque<(u32,u32)>, close: (u32,u32), last: u32, held: Vec<u32>,
    counts: BTreeMap<u32,owner::Counts>, deleted_locks: Vec<u32>,
    allocation: VecDeque<u32>, spawn: Option<(u32,u32,u32)>, launches: Vec<Launch>, run_worker: bool,
    pub(crate) fail_wait: bool,
}
pub(crate) fn n(v: &Value) -> u32 { v.as_u64().unwrap().try_into().unwrap() }
impl Harness {
    pub(crate) fn new() -> Self {
        let mut b=Self {memory:init::OwnedMemory::new(0x38000000,0),events:vec![],watched:BTreeSet::new(),waits:VecDeque::new(),close:(1,0),last:0,held:vec![],counts:BTreeMap::new(),deleted_locks:vec![],allocation:VecDeque::new(),spawn:None,launches:vec![],run_worker:false,fail_wait:false};
        for (p,size) in [(PAIR,8),(CONTROL_VTABLE,12),(crate::audio_replay_transport_startup::STATUS,4),(crate::audio_replay_transport_startup::REFERENCES,4),(0x1225878,8)] {b.memory.reserve_at(p,size).unwrap();}
        for p in crate::audio_replay_transport_startup::COUNTERS {b.memory.reserve_at(p,4).unwrap();}
        for (p,v) in [(CONTROL_VTABLE,DISPOSE),(CONTROL_VTABLE+4,owner::RELEASE),(CONTROL_VTABLE+8,owner::SCALAR_DELETE)] {Storage::write_word(&mut b.memory,p,v).unwrap();}
        b
    }
    pub(crate) fn words(&mut self, p:u32, count:u32)->Vec<u32>{(0..count).map(|i|self.word(p+i*4).unwrap()).collect()}
    fn seed(&mut self,p:u32,words:&Value){let values=words.as_array().unwrap();self.memory.reserve_at(p,values.len() as u32*4).unwrap();for(i,v)in values.iter().enumerate(){Storage::write_word(&mut self.memory,p+i as u32*4,n(v)).unwrap();}}
    fn launch_step(&mut self,c:&Value){
        self.events.clear();self.launches.clear();self.waits.clear();self.close=(1,0);self.spawn=None;
        if !c["launches"].as_array().unwrap().is_empty(){let e=c["events"].as_array().unwrap().iter().find(|e|e["op"]=="drain_entry").unwrap();self.allocation.push_back(n(&e["control"]));self.spawn=Some((n(&e["raw"]),e["handle"].as_u64().unwrap_or(0) as u32,e["id"].as_u64().unwrap_or(0) as u32));}
        for event in c["thread_events"].as_array().unwrap(){if event["op"]=="wait"{self.waits.push_back((n(&event["result"]),0));}}
    }
    fn compare_launch(&mut self,c:&Value){
        assert_eq!(self.word(crate::audio_replay_transport_startup::STATUS).unwrap(),n(&c["after"]["status"]));assert_eq!(self.word(crate::audio_replay_transport_startup::REFERENCES).unwrap(),n(&c["after"]["references"]));
        assert_eq!(self.words(PAIR,2),vec![n(&c["after"]["raw"]),n(&c["after"]["control"])]);
        let control=n(&c["after"]["control"]);if control!=0{assert_eq!(json!(self.words(control,4)),c["after"]["control_words"]);}
        assert_eq!(self.launches.len(),c["launches"].as_array().unwrap().len());
        for (a,e) in self.launches.iter().zip(c["launches"].as_array().unwrap()){assert_eq!(a.callback,n(&e["callback"]));assert_eq!(a.argument,n(&e["argument"]));assert_eq!(json!(a.tag.chunks_exact(4).map(|w|u32::from_le_bytes(w.try_into().unwrap())).collect::<Vec<_>>()),e["options"]);assert_eq!(a.name.iter().map(|b|format!("{b:02x}")).collect::<String>(),e["name"].as_str().unwrap());}
        let actual=self.events.iter().filter(|e|e["op"]=="wait"||e["op"]=="close").cloned().collect::<Vec<_>>();
        let expected=c["thread_events"].as_array().unwrap().iter().filter(|e|e["op"]=="wait"||e["op"]=="close").map(|e|{let mut e=e.clone();if e["op"]=="close"{e["result"]=json!(1);}e}).collect::<Vec<_>>();assert_eq!(actual,expected);assert!(self.held.is_empty());
    }
}
impl Memory for Harness {fn word(&mut self,a:u32)->Result<u32,read::Error>{self.memory.word(a)}}
impl Storage for Harness {
 fn allocate(&mut self,n:u32)->Result<u32,init::Error>{if let Some(p)=self.allocation.pop_front(){assert_eq!(n,16);self.memory.reserve_at(p,n)?;Ok(p)}else{self.memory.allocate(n)}}
 fn write_word(&mut self,a:u32,v:u32)->Result<(),init::Error>{Storage::write_word(&mut self.memory,a,v)?;if self.watched.contains(&a){self.events.push(json!({"op":"write","address":a,"value":v}));}Ok(())}
 fn write_byte(&mut self,a:u32,v:u8)->Result<(),init::Error>{self.memory.write_byte(a,v)}
 fn register_shutdown(&mut self,c:u32)->Result<(),init::Error>{self.memory.register_shutdown(c)}
}
impl Removal for Harness {
 fn write_word(&mut self,a:u32,v:u32)->Result<(),removal::Error>{Storage::write_word(self,a,v).map_err(removal::Error::Owned)}
 fn deallocator(&mut self)->Result<removal::Deallocator,removal::Error>{Ok(removal::Deallocator::Standard)}
 fn free(&mut self,p:u32,_:removal::Deallocator)->Result<(),removal::Error>{self.memory.release(p).map_err(removal::Error::Owned)?;self.counts.remove(&p);Ok(())}
}
impl ControlBoundary for Harness {
 fn decrement_reference(&mut self,a:u32)->Result<u32,&'static str>{let(p,off)=if self.counts.contains_key(&(a-4)){(a-4,4)}else if self.counts.contains_key(&(a-8)){(a-8,8)}else{let p=a-4;let s=self.word(p+4).unwrap();let w=self.word(p+8).unwrap();self.counts.insert(p,owner::Counts::new(s,w));(p,4)};let c=&self.counts[&p];let previous=c.decrement(off)?;let value=c.read(off)?;Storage::write_word(self,a,value).map_err(|_|"count write")?;Ok(previous)}
 fn dispose(&mut self,p:u32,method:u32)->Result<(),&'static str>{assert_eq!(method,DISPOSE);dispose(self,p).map_err(|_|"thread disposal failed")}
 fn release_control(&mut self,p:u32,method:u32)->Result<(),&'static str>{assert_eq!(method,owner::RELEASE);owner::release(self,p).map_err(|_|"control deletion failed")}
}
impl Boundary for Harness {
 fn current_thread_id(&mut self)->Result<u32,&'static str>{self.events.push(json!({"op":"current_thread","value":1}));Ok(1)}
 fn wait_handle(&mut self,h:u32,t:u32)->Result<u32,&'static str>{if self.fail_wait{return Err("wait unavailable");}if self.run_worker{self.run_worker=false;crate::audio_replay_transport_startup::worker(self).unwrap();}let(v,e)=self.waits.pop_front().expect("unexpected wait");self.last=e;self.events.push(json!({"op":"wait","handle":h,"timeout":t,"result":v}));Ok(v)}
 fn close_handle(&mut self,h:u32)->Result<u32,&'static str>{self.last=self.close.1;self.events.push(json!({"op":"close","handle":h,"result":self.close.0}));Ok(self.close.0)}
 fn last_error(&mut self)->Result<u32,&'static str>{self.events.push(json!({"op":"last_error","value":self.last}));Ok(self.last)}
 fn mutex(&mut self,a:u32,enter:bool)->Result<(),&'static str>{if enter{self.held.push(a);}else{assert_eq!(self.held.pop(),Some(a));}self.events.push(json!({"op":if enter{"lock"}else{"unlock"},"address":a}));Ok(())}
 fn delete_critical_section(&mut self,a:u32)->Result<(),&'static str>{self.deleted_locks.push(a);Ok(())}
 fn create_worker(&mut self,launch:&Launch)->Result<u32,&'static str>{let(p,h,id)=self.spawn.take().ok_or("thread launch unavailable")?;self.launches.push(launch.clone());if p!=0{self.memory.reserve_at(p,80).unwrap();for(o,v)in[(0,h),(4,1),(0x24,id),(0x4c,15)]{Storage::write_word(&mut self.memory,p+o,v).unwrap();}self.run_worker=true;}Ok(p)}
 fn exchange_status(&mut self,v:u32)->Result<u32,&'static str>{let a=crate::audio_replay_transport_startup::STATUS;let old=self.word(a).unwrap();Storage::write_word(self,a,v).unwrap();Ok(old)}
}
impl crate::audio_replay_transport_startup::Network for Harness {
 fn winsock_startup(&mut self,_:u16)->Result<crate::audio_replay_transport_startup::Negotiation,crate::audio_replay_transport_startup::Error>{Ok(crate::audio_replay_transport_startup::Negotiation{code:0,version:0x202})}
 fn winsock_cleanup(&mut self)->Result<u32,crate::audio_replay_transport_startup::Error>{Ok(0)}
 fn timer_begin(&mut self,_:u32)->Result<u32,crate::audio_replay_transport_startup::Error>{Ok(0)}
 fn timer_end(&mut self,_:u32)->Result<u32,crate::audio_replay_transport_startup::Error>{Ok(0)}
}
impl crate::audio_replay_transport_startup::Backend for Harness {
 fn read(&self,a:u32)->Result<u32,crate::audio_replay_transport_startup::Error>{let mut bytes=[0;4];for(i,b)in bytes.iter_mut().enumerate(){*b=self.memory.read_byte(a+i as u32).unwrap();}Ok(u32::from_le_bytes(bytes))}
 fn write(&mut self,a:u32,v:u32)->Result<(),crate::audio_replay_transport_startup::Error>{Storage::write_word(&mut self.memory,a,v).unwrap();Ok(())}
 fn exchange(&mut self,a:u32,v:u32)->Result<u32,crate::audio_replay_transport_startup::Error>{let old=self.word(a).unwrap();Storage::write_word(&mut self.memory,a,v).unwrap();Ok(old)}
 fn mutex(&mut self,_:u32,_:bool)->Result<(),crate::audio_replay_transport_startup::Error>{Ok(())}
 fn logger(&mut self)->Result<u32,crate::audio_replay_transport_startup::Error>{Err(crate::audio_replay_transport_startup::Error::Boundary("logger unavailable"))}
 fn log(&mut self,_:u32,_:&str)->Result<(),crate::audio_replay_transport_startup::Error>{unreachable!()}
}
#[test]fn audio_replay_thread_wait_join_close_drain_match420_native_error_self_wait_handle_and_control_lifetimes(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/replay_thread_waits_contract.json")).unwrap();let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),420);
 for c in cases{let mut b=Harness::new();let thread=n(&c["thread"]);let control=n(&c["control"]);b.seed(thread,&c["before"]);if control!=0{b.seed(control,&c["before_control"]);Storage::write_word(&mut b.memory,PAIR,thread).unwrap();Storage::write_word(&mut b.memory,PAIR+4,control).unwrap();}
  b.watched.extend([thread,thread+0x24,PAIR,PAIR+4]);if control!=0{b.watched.extend([control,control+4,control+8]);}b.waits=c["wait_profile"].as_array().unwrap().iter().map(|v|(n(&v[0]),n(&v[1]))).collect();b.close=(n(&c["close_profile"][0]),n(&c["close_profile"][1]));
  let result=match c["operation"].as_str().unwrap(){"wait"=>Some(wait(&mut b,thread,9000).unwrap()),"join"=>Some(join(&mut b,thread,9000).unwrap()),"apply_wait"=>Some(apply_close(&mut b,thread,true).unwrap()),"apply_close"=>Some(apply_close(&mut b,thread,false).unwrap()),"drain"=>{drain(&mut b).unwrap();None},_=>unreachable!()};assert_eq!(json!(result),c["result"]);assert_eq!(json!(b.events),c["events"],"{c}");assert_eq!(json!(b.memory.released_labels),c["freed"]);assert_eq!(json!(b.words(PAIR,2)),c["pair_after"]);if !c["after"].is_null(){assert_eq!(json!(b.words(thread,20)),c["after"]);}if !c["after_control"].is_null(){assert_eq!(json!(b.words(control,4)),c["after_control"]);}assert!(b.held.is_empty());
 }
}
#[test]fn audio_replay_transport_launch_matches16_native_status_and_create_failure_cases_and3_retry_sequences(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/replay_transport_launch_contract.json")).unwrap();assert_eq!(p["cases"].as_array().unwrap().len(),16);
 for c in p["cases"].as_array().unwrap(){let mut b=Harness::new();Storage::write_word(&mut b.memory,crate::audio_replay_transport_startup::STATUS,n(&c["before_status"])).unwrap();Storage::write_word(&mut b.memory,crate::audio_replay_transport_startup::REFERENCES,n(&c["before_references"])).unwrap();b.launch_step(c);assert_eq!(initialize(&mut b).unwrap() as u32,n(&c["return_byte"]));b.compare_launch(c);}
 assert_eq!(p["sequences"].as_array().unwrap().len(),3);for sequence in p["sequences"].as_array().unwrap(){let mut b=Harness::new();for c in sequence["steps"].as_array().unwrap(){b.launch_step(c);assert_eq!(initialize(&mut b).unwrap(),1);b.compare_launch(c);}}
}
#[test]fn audio_replay_thread_unavailable_wait_preserves_handle_and_releases_recursive_mutex_scopes(){let mut b=Harness::new();let p=0x39000000;b.memory.reserve_at(p,80).unwrap();Storage::write_word(&mut b.memory,p,7).unwrap();Storage::write_word(&mut b.memory,p+0x24,8).unwrap();b.fail_wait=true;assert_eq!(apply_close(&mut b,p,true),Err(Error::Boundary("wait unavailable")));assert!(b.held.is_empty());assert_eq!(b.word(p).unwrap(),7);assert_eq!(b.word(p+0x24).unwrap(),8);}
