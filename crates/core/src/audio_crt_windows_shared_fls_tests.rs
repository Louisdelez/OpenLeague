//! Integration tests using actual crate types and original paired native byte banks.
use super::*;
use std::collections::BTreeMap;
use crate::{audio_plugin_factory::Memory,audio_bus_bank::Error};
use serde_json::{Value,json};
type Bank=BTreeMap<u32,Vec<u8>>;
fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
fn bank(p:&Value,row:&Value)->Bank{p["regions"].as_array().unwrap().iter().map(|v|(v["reference"].as_u64().unwrap()as u32,bytes(row[v["name"].as_str().unwrap()].as_str().unwrap()))).collect()}
fn input(p:&Value,row:&Value)->BTreeMap<u32,Memory>{bank(p,row).into_iter().map(|(reference,raw)|(reference,Memory{reference,raw})).collect()}
fn fixture()->Value{serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_paired_thread_lifetime_preparation.json")).unwrap()}
fn check(m:&BTreeMap<u32,Memory>,expected:&Bank,normalize:bool){
 let second_id=if normalize{crate::audio_path_memory::read(m,0x40013000,4).map(|v|u32::from_le_bytes(v.try_into().unwrap())).unwrap_or(0)}else{0};
 for(a,raw)in expected{for(j,v)in raw.iter().enumerate(){let at=*a+j as u32;let observed=if normalize&&(0x12230cc..0x12230d0).contains(&at){5u32.to_le_bytes()[(at-0x12230cc)as usize]}else if normalize&&second_id!=0&&(0x40013000..0x40013004).contains(&at){456u32.to_le_bytes()[(at-0x40013000)as usize]}else{crate::audio_path_memory::read(m,at,1).unwrap()[0]};assert_eq!(observed,*v,"native byte at {at:x}");}}
}
struct Step{kind:String,reference:u32,bank:Bank}
struct Api{steps:Vec<Step>,index:usize,events:Vec<(u32,u32)>,regions:Vec<(String,u32,usize)>,calls:Vec<Value>,allocation_failure:bool,normalize:bool,thread_id:Option<u32>,destructor_error:bool,destructor_panic:bool}
impl Api{
 fn new(p:&Value,row:&Value,normalize:bool)->Self{let mut steps=vec![];if !normalize{for cb in row["callbacks"].as_array().unwrap(){for c in cb["calls"].as_array().unwrap(){steps.push(Step{kind:c["kind"].as_str().unwrap().into(),reference:c["arguments"][0].as_u64().unwrap()as u32,bank:bank(p,&c["at_call"])});}}}Self{steps,index:0,events:vec![],regions:p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().into(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect(),calls:vec![],allocation_failure:false,normalize,thread_id:None,destructor_error:false,destructor_panic:false}}
 fn snapshot(&self,m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r,z)in &self.regions{let mut raw=crate::audio_path_memory::read(m,*r,*z).unwrap().to_vec();if self.normalize{for(at,value)in[(0x12230cc,5u32),(0x40013000,456u32)]{if at>=*r&&at+4<=*r+*z as u32{let off=(at-*r)as usize;if at!=0x40013000||self.thread_id==Some(u32::from_le_bytes(raw[off..off+4].try_into().unwrap())){raw[off..off+4].copy_from_slice(&value.to_le_bytes());}}}}out[n]=json!(raw.iter().map(|v|format!("{v:02x}")).collect::<String>());}out}
 fn emit(&mut self,kind:&str,arguments:Value,result:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":kind,"arguments":arguments,"result":result,"at_call":self.snapshot(m)}));}
 fn event(&mut self,kind:&str,reference:u32,m:&BTreeMap<u32,Memory>){if !self.steps.is_empty(){let expected=&self.steps[self.index];assert_eq!(kind,expected.kind);assert_eq!(reference,expected.reference);check(m,&expected.bank,false);self.index+=1;}self.emit(kind,json!([reference]),0,m);if kind=="free"{self.events.push((reference,unsafe{GetCurrentThreadId()}));}}
}
impl crate::audio_global_float_default_power::Windows for Api{
 fn get_last_error(&mut self,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let result=unsafe{GetLastError()};self.emit("GetLastError",json!([]),result,m);Ok(result)}
 fn set_last_error(&mut self,e:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.emit("SetLastError",json!([e]),0,m);unsafe{SetLastError(e)};Ok(())}
 fn tls_get_value(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("expected actual encoded FLS adapter"))}
 fn calloc_thread(&mut self,n:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{assert_eq!((n,z),(1,0x3bc));let record=if self.allocation_failure{0}else{0x40013000};self.emit("calloc",json!([n,z]),record,m);if record!=0{m.get_mut(&record).unwrap().raw.fill(0);}Ok((record!=0).then_some(record))}
 fn current_thread_id(&mut self,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{let result=unsafe{GetCurrentThreadId()};self.emit("GetCurrentThreadId",json!([]),if self.normalize{456}else{result},m);self.thread_id=Some(result);Ok(result)}
 fn thread_lock(&mut self,r:u32,enter:bool,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.event(if enter{"EnterCriticalSection"}else{"LeaveCriticalSection"},r,m);Ok(())}
 fn free_thread(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{if self.destructor_panic{panic!("qualified CRT free panic");}if self.destructor_error{return Err(Error::Backend("qualified CRT free failure"));}self.event("free",r,m);Ok(())}
}
impl Services for Api{}
#[test]fn audio_windows_shared_fls_full_core_matches48_paired_original_service_entry_banks_two_retirement_orders_and_actual_worker_callback_affinity(){
 let p=fixture();assert_eq!(p["case_count"],24);for row in p["cases"].as_array().unwrap(){for natural in [false,true]{
  let context=Arc::new(SharedContext::new(Context{memory:input(&p,&row["after_second_constructor"]),dead:BTreeSet::new(),services:Api::new(&p,row,false)}));let slot=SharedSlot::<Api>::new().unwrap();let report=slot.report();let records=row["callbacks"].as_array().unwrap().iter().map(|v|v["record"].as_u64().unwrap()as u32).collect::<Vec<_>>();let mut workers=vec![];let mut identities=vec![];
  for &record in &records{let(tx,rx)=std::sync::mpsc::channel();let(ready,wait)=std::sync::mpsc::channel();let s=slot.clone();let c=context.clone();let worker=std::thread::spawn(move||{s.bind_current(c,record).unwrap();assert_eq!(s.value().unwrap(),record);ready.send(unsafe{GetCurrentThreadId()}).unwrap();rx.recv().unwrap();});identities.push(wait.recv().unwrap());workers.push((tx,worker));}
  if !natural{slot.close().unwrap();}for(tx,worker)in workers{tx.send(()).unwrap();worker.join().unwrap();}slot.close().unwrap();slot.close().unwrap();assert_eq!((report.attempts(),report.completed(),report.failure()),(2,2,None));
  context.with(|c|{check(&c.memory,&bank(&p,&row["before_cleanup"]),false);assert_eq!(c.dead,BTreeSet::from([0x40012000,0x40013000]));assert_eq!(c.services.index,c.services.steps.len());assert_eq!(c.services.events.len(),2);for(j,(record,thread))in c.services.events.iter().enumerate(){assert_eq!(*record,records[j]);assert_eq!(*thread,if natural{identities[j]}else{unsafe{GetCurrentThreadId()}});}}).unwrap();
 }}
}
#[test]fn audio_windows_shared_fls_original_getter_creates6_native_worker_contexts_preserves_last_error_and_reuses_existing_record(){
 let p=fixture();let mut count=0;for row in p["cases"].as_array().unwrap().iter().filter(|r|r["layout"]=="all"&&r["reverse"]==false){
  let context=Arc::new(SharedContext::new(Context{memory:input(&p,&row["after_startup"]),dead:BTreeSet::new(),services:Api::new(&p,row,true)}));let slot=SharedSlot::<Api>::new().unwrap();slot.publish_index(&context).unwrap();slot.bind_current(context.clone(),0x40012000).unwrap();let dispatch=ValueDispatch{get:0x40004020,set:0x40004030};unsafe{SetLastError(97)};assert_eq!(slot.get_or_create_current(context.clone(),dispatch).unwrap(),0x40012000);assert_eq!(unsafe{GetLastError()},97);context.with(|c|{assert_eq!(c.services.calls.len(),2);c.services.calls.clear();}).unwrap();
  let(tx,rx)=std::sync::mpsc::channel();let(ready,wait)=std::sync::mpsc::channel();let s=slot.clone();let c=context.clone();let worker=std::thread::spawn(move||{unsafe{SetLastError(97)};assert_eq!(s.get_or_create_current(c.clone(),dispatch).unwrap(),0x40013000);assert_eq!(unsafe{GetLastError()},97);assert_eq!(s.get_or_create_current(c,dispatch).unwrap(),0x40013000);assert_eq!(unsafe{GetLastError()},97);ready.send(()).unwrap();rx.recv().unwrap();});wait.recv().unwrap();
  context.with(|c|{check(&c.memory,&bank(&p,&row["after_second_constructor"]),true);let start=row["startup_call_count"].as_u64().unwrap()as usize;let end=row["constructor_call_count"].as_u64().unwrap()as usize;let expected=row["calls"].as_array().unwrap()[start..end].iter().filter(|c|c["kind"]!="FlsGetValue"&&c["kind"]!="FlsSetValue").cloned().collect::<Vec<_>>();assert_eq!(&c.services.calls[..expected.len()],expected.as_slice());assert_eq!(c.services.calls.len(),expected.len()+2);}).unwrap();
  slot.close().unwrap();tx.send(()).unwrap();worker.join().unwrap();assert_eq!(slot.report().completed(),2);context.with(|c|check(&c.memory,&bank(&p,&row["before_cleanup"]),true)).unwrap();count+=1;
 }assert_eq!(count,6);
}
#[test]fn audio_windows_shared_fls_original_getter_rejects_unpublished_dispatch_and_preserves_null_allocation_branch(){
 let p=fixture();let row=p["cases"].as_array().unwrap().iter().find(|r|r["layout"]=="all"&&r["reverse"]==false).unwrap();let mut api=Api::new(&p,row,true);api.allocation_failure=true;let context=Arc::new(SharedContext::new(Context{memory:input(&p,&row["after_startup"]),dead:BTreeSet::new(),services:api}));let slot=SharedSlot::<Api>::new().unwrap();let dispatch=ValueDispatch{get:0x40004020,set:0x40004030};context.with(|c|crate::audio_path_source_virtual_cleanup::put(&mut c.memory,&c.dead,0x12230cc,4,u32::MAX).unwrap()).unwrap();assert!(matches!(slot.get_or_create_current(context.clone(),dispatch),Err(Failure::InvalidContext(_))));slot.publish_index(&context).unwrap();assert!(slot.get_or_create_current(context.clone(),ValueDispatch{get:123,set:456}).is_err());unsafe{SetLastError(97)};assert_eq!(slot.get_or_create_current(context.clone(),dispatch).unwrap(),0);assert_eq!(unsafe{GetLastError()},97);assert_eq!(slot.value().unwrap(),0);slot.close().unwrap();assert_eq!(slot.report().completed(),0);context.with(|c|assert!(c.dead.is_empty())).unwrap();
}
#[test]fn audio_windows_shared_fls_callback_same_thread_busy_reports_failure_without_deadlock_or_false_retirement(){
 let p=fixture();let row=&p["cases"][0];let context=Arc::new(SharedContext::new(Context{memory:input(&p,&row["after_second_constructor"]),dead:BTreeSet::new(),services:Api::new(&p,row,false)}));let slot=SharedSlot::<Api>::new().unwrap();slot.bind_current(context.clone(),0x40012000).unwrap();context.with(|_|assert_eq!(slot.close(),Err(Failure::StateBusy))).unwrap();assert_eq!((slot.report().attempts(),slot.report().completed()),(1,0));context.with(|c|assert!(c.dead.is_empty())).unwrap();assert_eq!(slot.close(),Err(Failure::StateBusy));
}

#[test]fn audio_windows_shared_fls_production_real_locks_callback_safe_shutdown_matches12_original_global_record_and_lock_table_final_banks(){
 use crate::audio_crt_windows_critical_sections::{Provider,Bank};let p=fixture();let mut count=0;
 for row in p["cases"].as_array().unwrap().iter().filter(|r|r["layout"]=="all"&&r["reverse"]==false){for natural in[false,true]{
  let memory=input(&p,&row["after_second_constructor"]);let mut locks=Bank::default();for j in 0..36{let reference=crate::audio_path_source_virtual_cleanup::get(&memory,&BTreeSet::new(),0x1223580+j*8,4).unwrap();if reference!=0&&locks.section(reference).is_err(){locks.initialize(reference,4000,Some(0)).unwrap();}}assert!(!locks.is_empty());let report=locks.report();
  let context=Arc::new(SharedContext::new(Context{memory,dead:BTreeSet::new(),services:Provider{inner:Api::new(&p,row,true),locks}}));let slot=SharedSlot::new().unwrap();slot.publish_index(&context).unwrap();let mut workers=vec![];
  for record in[0x40012000,0x40013000]{let(tx,rx)=std::sync::mpsc::channel();let(ready,wait)=std::sync::mpsc::channel();let s=slot.clone();let c=context.clone();let worker=std::thread::spawn(move||{s.bind_current(c,record).unwrap();ready.send(()).unwrap();rx.recv().unwrap();});wait.recv().unwrap();workers.push((tx,worker));}
  if natural{for(tx,worker)in workers.drain(..){tx.send(()).unwrap();worker.join().unwrap();}}
  slot.shutdown_crt(&context).unwrap();slot.shutdown_crt(&context).unwrap();for(tx,worker)in workers{tx.send(()).unwrap();worker.join().unwrap();}
  assert_eq!((slot.report().attempts(),slot.report().completed(),slot.report().failure()),(2,2,None));assert!(report.failures().is_empty());context.with(|c|{
   assert!(c.services.locks.is_empty());assert_eq!(c.services.inner.events.iter().map(|(r,_)|*r).collect::<Vec<_>>(),vec![0x40012000,0x40013000]);
   // Captured 32-bit opaque CS storage is represented by separately pinned host
   // OS objects. Compare all other native bytes; never invent/copy DD host data.
   let mut expected=bank(&p,&row["after"]);for(a,raw)in &mut expected{for(j,v)in raw.iter_mut().enumerate(){let at=*a+j as u32;if(0x14ae988..0x14ae988+36*24).contains(&at){*v=crate::audio_path_memory::read(&c.memory,at,1).unwrap()[0];}}}check(&c.memory,&expected,false);
   assert_eq!(crate::audio_path_source_virtual_cleanup::get(&c.memory,&c.dead,0x12230cc,4).unwrap(),u32::MAX);
  }).unwrap();count+=1;
 }}assert_eq!(count,12);
}

#[test]fn audio_windows_shared_fls_global_slot_rejects_independent_canonical_contexts(){let p=fixture();let row=&p["cases"][0];let make=||Arc::new(SharedContext::new(Context{memory:input(&p,&row["after_second_constructor"]),dead:BTreeSet::new(),services:Api::new(&p,row,true)}));let context=make();let other=make();let slot=SharedSlot::<Api>::new().unwrap();slot.publish_index(&context).unwrap();assert!(matches!(slot.publish_index(&other),Err(Failure::InvalidContext(_))));assert!(matches!(slot.bind_current(other,0x40012000),Err(Failure::InvalidContext(_))));slot.bind_current(context,0x40012000).unwrap();slot.close().unwrap();assert_eq!(slot.report().completed(),1);}
#[test]fn audio_windows_shared_fls_real_lock_shutdown_retains_locks_and_reports_destructor_failure_or_panic_without_native_unwind(){
 use crate::audio_crt_windows_critical_sections::{Provider,Bank};let p=fixture();let row=p["cases"].as_array().unwrap().iter().find(|v|v["layout"]=="all"&&v["reverse"]==false).unwrap();for panic in[false,true]{
  let memory=input(&p,&row["after_second_constructor"]);let mut locks=Bank::default();for j in 0..36{let r=crate::audio_path_source_virtual_cleanup::get(&memory,&BTreeSet::new(),0x1223580+j*8,4).unwrap();if r!=0&&locks.section(r).is_err(){locks.initialize(r,4000,Some(0)).unwrap();}}let lock_count=locks.len();let lock_report=locks.report();let mut inner=Api::new(&p,row,true);inner.destructor_error=!panic;inner.destructor_panic=panic;
  let context=Arc::new(SharedContext::new(Context{memory,dead:BTreeSet::new(),services:Provider{inner,locks}}));let slot=SharedSlot::new().unwrap();slot.publish_index(&context).unwrap();slot.bind_current(context.clone(),0x40012000).unwrap();assert!(slot.shutdown_crt(&context).is_err());assert_eq!((slot.report().attempts(),slot.report().completed()),(1,0));
  if panic{assert_eq!(slot.report().failure(),Some(Failure::Panicked));assert_eq!(context.with(|_|()),Err(Failure::StatePoisoned));}else{assert!(matches!(slot.report().failure(),Some(Failure::Destructor(_))));context.with(|c|{assert_eq!(c.services.locks.len(),lock_count);assert!(!c.dead.contains(&0x40012000));assert_eq!(crate::audio_path_source_virtual_cleanup::get(&c.memory,&c.dead,0x12230cc,4).unwrap(),u32::MAX);}).unwrap();}
  assert!(slot.shutdown_crt(&context).is_err());drop(slot);drop(context);assert!(lock_report.failures().is_empty());
 }
}
