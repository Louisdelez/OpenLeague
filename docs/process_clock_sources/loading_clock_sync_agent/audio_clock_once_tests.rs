use super::*;
use serde_json::{json, Value};
use std::collections::BTreeMap;
const ALLOC:u32=0x35000000;const CALLBACK:u32=0x32000800;const NESTED:u32=0x32000900;const SECOND:u32=0x30000900;
struct Api {
    memory:BTreeMap<u32,u8>, regions:Vec<(String,u32,u32)>, calls:Vec<Value>, writes:Vec<Value>,
    tid:u32, atexit:u32, fail_alloc:bool, live:bool, held:bool, outer:u32, waits:u32, race:bool,
    failures:Vec<(&'static str,u32,usize)>,
}
impl Api {
    fn new(proof:&Value,before:&Value)->Self {
        let regions=proof["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().into(),v["address"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as u32)).collect::<Vec<_>>();
        let mut memory=BTreeMap::new();
        for(n,p,z)in &regions{let h=before[n].as_str().unwrap();assert_eq!(h.len(),*z as usize*2);for i in 0..*z{memory.insert(p+i,u8::from_str_radix(&h[i as usize*2..i as usize*2+2],16).unwrap());}}
        let mut s=Self{memory,regions,calls:vec![],writes:vec![],tid:17,atexit:0,fail_alloc:false,live:false,held:false,outer:0,waits:0,race:false,failures:vec![]};
        s.raw_word(COOKIE,0x12345678);s.raw_word(CS_DISPATCH,0x12345678);s
    }
    fn raw_word(&mut self,p:u32,v:u32){for(i,b)in v.to_le_bytes().iter().enumerate(){self.memory.insert(p+i as u32,*b);}}
    fn raw_read(&self,p:u32)->u32{u32::from_le_bytes(std::array::from_fn(|i|*self.memory.get(&(p+i as u32)).expect("fixture address")))}
    fn snapshot(&self)->Value{let mut v=json!({});for(n,p,z)in &self.regions{v[n]=json!((0..*z).map(|i|format!("{:02x}",self.memory[&(p+i)])).collect::<String>());}v}
    fn emit(&mut self,k:&str,args:Value){self.calls.push(json!({"kind":k,"args":args,"at_call":self.snapshot()}));}
    fn fail(&mut self,op:&str,p:u32)->Result<(),&'static str>{
        if let Some(i)=self.failures.iter().position(|(o,a,_)|*o==op&&*a==p){if self.failures[i].2==0{self.failures.remove(i);return Err("injected boundary failure");}self.failures[i].2-=1;}Ok(())
    }
    fn compare(&mut self,row:&Value,label:&str){assert_eq!(self.snapshot(),row["after"],"full native banks {label}");assert_eq!(json!(self.calls),row["calls"],"ordered native calls and bytes {label}");assert_eq!(json!(self.writes),row["writes"],"ordered native writes {label}");self.calls.clear();self.writes.clear();}
}
impl Boundary for Api {
    fn word(&mut self,p:u32)->Result<u32,&'static str>{self.fail("read",p)?;Ok(self.raw_read(p))}
    fn byte(&mut self,p:u32)->Result<u8,&'static str>{self.fail("read_byte",p)?;Ok(self.memory[&p])}
    fn put_word(&mut self,p:u32,v:u32)->Result<(),&'static str>{self.fail("write",p)?;self.raw_word(p,v);self.writes.push(json!([p,4,v]));Ok(())}
    fn put_byte(&mut self,p:u32,v:u8)->Result<(),&'static str>{self.fail("write_byte",p)?;self.memory.insert(p,v);self.writes.push(json!([p,1,v]));Ok(())}
    fn exchange(&mut self,p:u32,v:u32)->Result<u32,&'static str>{if self.race{self.raw_word(OUTER_STATE,2);self.race=false;self.emit("schedule_initializer_publish",json!([2]));}let old=self.word(p)?;self.put_word(p,v)?;Ok(old)}
    fn sleep(&mut self,ms:u32)->Result<(),&'static str>{self.emit("Sleep",json!([ms]));assert!(self.waits>0);self.waits-=1;if self.waits==0{self.raw_word(OUTER_STATE,2);}Ok(())}
    fn initialize_outer(&mut self,function:u32,p:u32,spin:u32,flags:Option<u32>)->Result<u32,&'static str>{assert_eq!(function,if flags.is_some(){0x32000700}else{0});self.emit(if flags.is_some(){"InitializeCriticalSectionEx"}else{"InitializeCriticalSectionAndSpinCount"},if let Some(v)=flags{json!([p,spin,v])}else{json!([p,spin])});for i in 0..24{self.memory.insert(p+i,0x5a);}Ok(1)}
    fn enter_outer(&mut self,p:u32)->Result<(),&'static str>{self.emit("EnterCriticalSection",json!([p]));self.outer+=1;Ok(())}
    fn leave_outer(&mut self,p:u32)->Result<(),&'static str>{self.emit("LeaveCriticalSection",json!([p]));self.outer-=1;self.fail("leave_outer",p)}
    fn delete_outer(&mut self,p:u32)->Result<(),&'static str>{assert_eq!(self.outer,0);self.emit("DeleteCriticalSection",json!([p]));Ok(())}
    fn calloc(&mut self,c:u32,z:u32)->Result<u32,&'static str>{self.emit("calloc",json!([c,z]));if self.fail_alloc{return Ok(0);}assert!(!self.live);self.live=true;for i in 0..z{self.memory.insert(ALLOC+i,0);}Ok(ALLOC)}
    fn free(&mut self,p:u32)->Result<(),&'static str>{self.emit("free",json!([p]));self.fail("free",p)?;assert!(self.live);assert!(!self.held);self.live=false;Ok(())}
    fn register_atexit(&mut self,p:u32)->Result<u32,&'static str>{self.emit("atexit",json!([p]));Ok(self.atexit)}
    fn current_thread_id(&mut self)->Result<u32,&'static str>{self.emit("GetCurrentThreadId",json!([]));self.fail("thread",0)?;Ok(self.tid)}
    fn inner_lock(&mut self,p:u32)->Result<(),&'static str>{self.emit("inner_lock",json!([p]));self.fail("inner_lock",p)?;assert!(!self.held);self.held=true;Ok(())}
    fn inner_unlock(&mut self,p:u32)->Result<(),&'static str>{self.emit("inner_unlock",json!([p]));assert!(self.held);self.held=false;self.fail("inner_unlock",p)}
    fn retire_inner(&mut self,_:u32)->Result<(),&'static str>{assert!(!self.held);Ok(())}
}
fn fixture()->Value{serde_json::from_str(&crate::audio_test_fixture("data/4.20/clock_sync_probe.json")).unwrap()}
fn step(b:&mut Api,flag:u32,callback:u32,arg:u32,nested:bool)->Result<(),Error>{
    prepare_and_enter_clock_mutex(b)?;
    let action=(||{if b.word(flag)?==0{b.emit("callback",json!([callback,arg]));if nested{step(b,SECOND,NESTED,0x76543210,false)?;}b.put_word(flag,1)?;}Ok(())})();
    let cleanup=leave_clock_mutex(b);finish(action,cleanup)
}
#[test]
fn audio_clock_once_native64_boundary_lifetimes_all_bytes_calls_writes_and_nested_flags(){
    let proof=fixture();assert_eq!(proof["boundary_cases"].as_array().unwrap().len(),64);
    for(i,c)in proof["boundary_cases"].as_array().unwrap().iter().enumerate(){
        let mut b=Api::new(&proof,&c["steps"][0]["before"]);b.atexit=c["atexit_result"].as_u64().unwrap()as u32;if c["dispatch_ex"]==true{b.raw_word(CS_DISPATCH,0x12345678^0x32000700);}
        for(j,row)in c["steps"].as_array().unwrap().iter().enumerate(){if j==2{b.tid=99;}step(&mut b,CLOCK_FLAG,CALLBACK,0x11223344,c["nested"]==true).unwrap();b.compare(row,&format!("case{i}/step{j}"));assert!(!b.held);assert_eq!(b.outer,0);}
        dispatch_cleanup(&mut b,MUTEX_CLEANUP).unwrap();dispatch_cleanup(&mut b,OUTER_CLEANUP).unwrap();b.compare(&c["shutdown"],&format!("case{i}/shutdown"));assert!(!b.live);
    }
}
#[test]
fn audio_clock_once_native34_outer_races_and8_allocations(){
    let proof=fixture();assert_eq!(proof["outer_cases"].as_array().unwrap().len(),34);
    for(i,c)in proof["outer_cases"].as_array().unwrap().iter().enumerate(){let mut b=Api::new(&proof,&c["execution"]["before"]);if c["dispatch_ex"]==true{b.raw_word(CS_DISPATCH,0x12345678^0x32000700);}b.race=c["race"]==true;b.waits=if c["initial_state"]==1||c["initial_state"]==3{2}else{0};outer_once(&mut b,MUTEX_READY,|b|{b.emit("callback",json!([NESTED]));Ok(())}).unwrap();b.compare(&c["execution"],&format!("outer{i}"));}
    for(i,c)in proof["allocation_cases"].as_array().unwrap().iter().enumerate(){let mut b=Api::new(&proof,&c["allocation"]["before"]);b.fail_alloc=c["failed"]==true;let result=allocate_mutex(&mut b,MUTEX_POINTER,c["type"].as_u64().unwrap()as u32).unwrap();assert_eq!(json!(result),c["allocation"]["result"]);b.compare(&c["allocation"],&format!("allocate{i}"));if !c["cleanup"].is_null(){destroy_mutex(&mut b,MUTEX_POINTER).unwrap();b.compare(&c["cleanup"],&format!("cleanup{i}"));}assert!(!b.live);}
}
fn fresh()->Api{let proof=fixture();Api::new(&proof,&proof["boundary_cases"][0]["steps"][0]["before"])}
#[test]
fn audio_clock_once_host_failed_calloc_adoption_releases_allocation_and_retains_cleanup_error(){
    // Every constructor write after calloc, including final ownership publication.
    for address in [ALLOC+0x1c,ALLOC+0x20,ALLOC+4,ALLOC+8,ALLOC+0x10,ALLOC+0x0c,ALLOC+0x14,ALLOC+0x18,ALLOC+0x24,ALLOC,MUTEX_POINTER]{
        let mut b=fresh();b.failures.push(("write",address,usize::from(address==MUTEX_POINTER)));assert!(allocate_mutex(&mut b,MUTEX_POINTER,1).is_err());assert!(!b.live);assert_eq!(b.raw_read(MUTEX_POINTER),0);
    }
    let mut b=fresh();b.failures=vec![("write",ALLOC+0x1c,0),("free",ALLOC,0)];assert!(matches!(allocate_mutex(&mut b,MUTEX_POINTER,1),Err(Error::Cleanup{..})));assert!(b.live);assert_eq!(b.raw_read(MUTEX_POINTER),0); // Remaining ownership is reported by cleanup error.
}
#[test]
fn audio_clock_once_host_acquire_errors_restore_owner_and_release_only_new_inner_acquisition(){
    for(op,address,skip)in [("thread",0,1),("read",MUTEX_POINTER,1),("read",MUTEX_POINTER,2),("read",ALLOC+0x24,1),("write",ALLOC+0x24,0),("read",ALLOC+0x28,0),("write",ALLOC+0x28,0)]{
        let mut b=fresh();allocate_mutex(&mut b,MUTEX_POINTER,1).unwrap();b.failures.push((op,address,skip));assert!(enter_mutex(&mut b,MUTEX_POINTER).is_err(),"{op} {address:x}");assert!(!b.held);assert_eq!(b.raw_read(ALLOC+0x24),u32::MAX);assert_eq!(b.raw_read(ALLOC+0x28),0);
    }
    let mut b=fresh();allocate_mutex(&mut b,MUTEX_POINTER,1).unwrap();b.failures=vec![("read",ALLOC+0x28,0),("inner_unlock",ALLOC+4,0)];assert!(matches!(enter_mutex(&mut b,MUTEX_POINTER),Err(Error::Cleanup{..})));assert!(!b.held);
    let mut b=fresh();allocate_mutex(&mut b,MUTEX_POINTER,1).unwrap();enter_mutex(&mut b,MUTEX_POINTER).unwrap();b.failures=vec![("write",ALLOC+0x28,0)];assert!(enter_mutex(&mut b,MUTEX_POINTER).is_err());assert!(b.held);assert_eq!(b.raw_read(ALLOC+0x28),1);leave_mutex(&mut b,MUTEX_POINTER).unwrap();assert!(!b.held);
}
#[test]
fn audio_clock_once_host_outer_callback_errors_release_and_keep_double_error(){
    let mut b=fresh();b.failures.push(("leave_outer",OUTER_SECTION,0));assert!(matches!(outer_once(&mut b,MUTEX_READY,|_|Err(Error::Boundary("callback failed"))),Err(Error::Cleanup{..})));assert_eq!(b.outer,0);assert_eq!(b.memory[&MUTEX_READY],0);
}
