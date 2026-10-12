from pathlib import Path
r=Path('E:/OpenLeague')
s=r'''//! Owned real Windows FLS slot feeding the reconstructed CRT context destructor.
//! Call close without holding the context mutex. Callback failures remain observable.
use std::{collections::{BTreeMap,BTreeSet},ffi::c_void,marker::PhantomData,rc::Rc,sync::{Arc,Mutex,atomic::{AtomicU32,Ordering}}};
use crate::{audio_plugin_factory::Memory,audio_crt_thread_destructor::Services};
pub struct Context<S>{pub memory:BTreeMap<u32,Memory>,pub dead:BTreeSet<u32>,pub services:S}
#[derive(Debug,Clone,PartialEq,Eq)]pub enum Failure{Windows{operation:&'static str,code:u32},WrongThread,StateBusy,StatePoisoned,InvalidContext(String),Destructor(String),Panicked}
pub struct Report{attempts:AtomicU32,completed:AtomicU32,failure:Mutex<Option<Failure>>}
impl Report{
 fn new()->Self{Self{attempts:AtomicU32::new(0),completed:AtomicU32::new(0),failure:Mutex::new(None)}}
 fn fail(&self,f:Failure){let mut v=self.failure.lock().unwrap_or_else(|p|p.into_inner());if v.is_none(){*v=Some(f);}}
 pub fn attempts(&self)->u32{self.attempts.load(Ordering::Acquire)}
 pub fn completed(&self)->u32{self.completed.load(Ordering::Acquire)}
 pub fn failure(&self)->Option<Failure>{self.failure.lock().unwrap_or_else(|p|p.into_inner()).clone()}
}
struct Data<S>{context:Arc<Mutex<Context<S>>>,record:u32,report:Arc<Report>}
#[link(name="kernel32")]unsafe extern "system"{
 fn FlsAlloc(callback:Option<unsafe extern "system" fn(*mut c_void)>)->u32;
 fn FlsSetValue(index:u32,value:*mut c_void)->i32;
 fn FlsGetValue(index:u32)->*mut c_void;
 fn FlsFree(index:u32)->i32;
 fn GetLastError()->u32;fn GetCurrentThreadId()->u32;
}
unsafe extern "system" fn callback<S:Services+Send+'static>(pointer:*mut c_void){
 if pointer.is_null(){return;}
 // This Box was exclusively transferred by new(). Windows releases its value first.
 let data=unsafe{Box::from_raw(pointer.cast::<Data<S>>())};let report=Arc::clone(&data.report);report.attempts.fetch_add(1,Ordering::AcqRel);
 let result=std::panic::catch_unwind(std::panic::AssertUnwindSafe(||{
  match data.context.try_lock(){
   Ok(mut context)=>{let Context{memory,dead,services}=&mut*context;match crate::audio_crt_fls_callback::dispatch(Some(crate::audio_crt_fls_callback::THREAD_DESTRUCTOR),data.record,memory,dead,services){Ok(())=>{report.completed.fetch_add(1,Ordering::AcqRel);},Err(e)=>report.fail(Failure::Destructor(format!("{e:?}")))}},
   Err(std::sync::TryLockError::WouldBlock)=>report.fail(Failure::StateBusy),
   Err(std::sync::TryLockError::Poisoned(_))=>report.fail(Failure::StatePoisoned),
  }
  drop(data);
 }));
 if result.is_err(){report.fail(Failure::Panicked);}
}
/// Thread-affine ownership; arbitrary fiber rebinding is not part of this interface.
/// The OS owns any transferred Data until callback execution. No payload is freed twice.
pub struct OwnedSlot<S:Services+Send+'static>{index:Option<u32>,owner:u32,report:Arc<Report>,_services:PhantomData<S>,_thread:PhantomData<Rc<()>>}
impl<S:Services+Send+'static> OwnedSlot<S>{
 pub fn new(context:Option<(Arc<Mutex<Context<S>>>,u32)>)->Result<Self,Failure>{
  if let Some((ctx,record))=&context{if *record==0{return Err(Failure::InvalidContext("NULL record requires an empty slot".into()));}let c=ctx.try_lock().map_err(|e|match e{std::sync::TryLockError::WouldBlock=>Failure::StateBusy,_=>Failure::StatePoisoned})?;crate::audio_path_source_virtual_cleanup::live(&c.memory,&c.dead,*record,0x3bc).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?;}
  let index=unsafe{FlsAlloc(Some(callback::<S>))};if index==u32::MAX{return Err(Failure::Windows{operation:"FlsAlloc",code:unsafe{GetLastError()}});}
  let mut slot=Self{index:Some(index),owner:unsafe{GetCurrentThreadId()},report:Arc::new(Report::new()),_services:PhantomData,_thread:PhantomData};
  if let Some((context,record))=context{let data=Box::into_raw(Box::new(Data{context,record,report:Arc::clone(&slot.report)}));if unsafe{FlsSetValue(index,data.cast())}==0{let code=unsafe{GetLastError()};unsafe{drop(Box::from_raw(data))};let _=slot.close();return Err(Failure::Windows{operation:"FlsSetValue",code});}}
  Ok(slot)
 }
 pub fn report(&self)->Arc<Report>{Arc::clone(&self.report)}
 pub fn is_closed(&self)->bool{self.index.is_none()}
 pub fn value(&self)->Result<u32,Failure>{
  if unsafe{GetCurrentThreadId()}!=self.owner{return Err(Failure::WrongThread);}let Some(index)=self.index else{return Ok(0);};let data=unsafe{FlsGetValue(index)};if data.is_null(){let code=unsafe{GetLastError()};if code!=0{return Err(Failure::Windows{operation:"FlsGetValue",code});}return Ok(0);}
  // No foreign native code is given this slot; its only nonNULL value is our Data.
  Ok(unsafe{(*data.cast::<Data<S>>()).record})
 }
 pub fn close(&mut self)->Result<(),Failure>{
  if unsafe{GetCurrentThreadId()}!=self.owner{return Err(Failure::WrongThread);}if let Some(index)=self.index{if unsafe{FlsFree(index)}==0{return Err(Failure::Windows{operation:"FlsFree",code:unsafe{GetLastError()}});}self.index=None;}
  match self.report.failure(){Some(e)=>Err(e),None=>Ok(())}
 }
}
impl<S:Services+Send+'static> Drop for OwnedSlot<S>{fn drop(&mut self){if let Err(e)=self.close(){self.report.fail(e);}}}
''';(r/'crates/core/src/audio_crt_windows_fls_slot.rs').write_text(s,encoding='utf-8')
p=r/'crates/core/src/lib.rs';s=p.read_text(encoding='utf-8');assert 'pub mod audio_crt_windows_fls_slot;'not in s;p.write_text(s+'\n#[cfg(windows)]\npub mod audio_crt_windows_fls_slot;\n',encoding='utf-8')
p=r/'crates/core/src/audio_crt_thread_system_startup.rs';s=p.read_text(encoding='utf-8')
needle='fn free_thread(&mut self,reference:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.emit(';assert needle in s;s=s.replace(needle,'fn free_thread(&mut self,reference:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{if self.failure=="callback_error"{return Err(Error::Backend("qualified callback heap failure"));}if self.failure=="callback_panic"{panic!("qualified callback panic");}self.emit(',1)
s=s.rstrip();assert s.endswith('}');s=s[:-1]+r'''
 #[cfg(windows)]fn os_context(row:&Value,p:&Value)->std::sync::Arc<std::sync::Mutex<crate::audio_crt_windows_fls_slot::Context<Api>>>{let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let memory=regions.iter().map(|(n,r,_)|(*r,Memory{reference:*r,raw:bytes(row["before_cleanup"][n].as_str().unwrap())})).collect();std::sync::Arc::new(std::sync::Mutex::new(crate::audio_crt_windows_fls_slot::Context{memory,dead:BTreeSet::new(),services:Api{regions,calls:vec![],layout:"all".into(),failure:"none".into(),export:0,tls:0,last:97,allocations:vec![],freed:vec![],slot_callback:None,callbacks:vec![]}}))}
 #[cfg(windows)]#[test]fn audio_windows_owned_fls_matches12_actual_os_callbacks_production_context_native_service_entry_banks_order_free_identities_and_empty_slots(){use crate::audio_crt_windows_fls_slot::OwnedSlot;let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_fls_slot_lifetime_preparation.json")).unwrap();let mut count=0;
 for row in p["cases"].as_array().unwrap().iter().filter(|v|v["layout"]=="all"&&(v["state"]=="live"||v["state"]=="cleared")){let context=os_context(row,&p);let live=row["state"]=="live";let mut slot=OwnedSlot::<Api>::new(if live{Some((context.clone(),0x40012000))}else{None}).unwrap();let report=slot.report();assert_eq!(slot.value().unwrap(),if live{0x40012000}else{0});slot.close().unwrap();assert!(slot.is_closed());slot.close().unwrap();assert_eq!(report.attempts(),u32::from(live));assert_eq!(report.completed(),u32::from(live));assert_eq!(report.failure(),None);
 let c=context.lock().unwrap();let mut expected=vec![];if live{let calls=row["calls"].as_array().unwrap();let start=calls.iter().position(|v|v["kind"]=="FlsFree").unwrap()+1;for v in &calls[start..]{if v["kind"]=="DeleteCriticalSection"{break;}expected.push(v.clone());}}assert_eq!(json!(c.services.calls),json!(expected),"actualOS callback every original destructor service entry/full bank");assert_eq!(c.services.snapshot(&c.memory),if live{row["callbacks"][0]["after"].clone()}else{row["before_cleanup"].clone()});assert_eq!(c.services.freed,if live{vec![0x40012000]}else{vec![]});assert_eq!(c.dead,if live{BTreeSet::from([0x40012000])}else{BTreeSet::new()});count+=1;}assert_eq!(count,12);}
 #[cfg(windows)]#[test]fn audio_windows_owned_fls_drop_releases_context_once_and_busy_state_reports_failure_without_deadlock(){use crate::audio_crt_windows_fls_slot::{OwnedSlot,Failure};let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_fls_slot_lifetime_preparation.json")).unwrap();let row=p["cases"].as_array().unwrap().iter().find(|v|v["layout"]=="all"&&v["state"]=="live").unwrap();let context=os_context(row,&p);let report;{let slot=OwnedSlot::<Api>::new(Some((context.clone(),0x40012000))).unwrap();report=slot.report();}assert_eq!(report.completed(),1);assert_eq!(context.lock().unwrap().services.freed,vec![0x40012000]);
 let context=os_context(row,&p);let mut slot=OwnedSlot::<Api>::new(Some((context.clone(),0x40012000))).unwrap();let guard=context.lock().unwrap();assert_eq!(slot.close(),Err(Failure::StateBusy));assert!(slot.is_closed());assert!(guard.dead.is_empty());assert_eq!(slot.report().attempts(),1);assert_eq!(slot.report().completed(),0);drop(guard);}
 #[cfg(windows)]#[test]fn audio_windows_owned_fls_backend_errors_and_panics_remain_reported_without_unwinding_native_callback(){use crate::audio_crt_windows_fls_slot::{OwnedSlot,Failure};let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_fls_slot_lifetime_preparation.json")).unwrap();let row=p["cases"].as_array().unwrap().iter().find(|v|v["layout"]=="all"&&v["state"]=="live").unwrap();for failure in["callback_error","callback_panic"]{let context=os_context(row,&p);context.lock().unwrap().services.failure=failure.into();let mut slot=OwnedSlot::<Api>::new(Some((context.clone(),0x40012000))).unwrap();let result=slot.close();if failure=="callback_error"{assert!(matches!(result,Err(Failure::Destructor(_))));}else{assert_eq!(result,Err(Failure::Panicked));}assert!(slot.is_closed());assert_eq!(slot.report().attempts(),1);assert_eq!(slot.report().completed(),0);assert!(!context.lock().unwrap_or_else(|p|p.into_inner()).dead.contains(&0x40012000));}}
}
''';p.write_text(s,encoding='utf-8');(r/'tools/implement_audio_windows_owned_fls.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Promoted actual owned FLS slot into core; OS callback/native contexts, Drop ownership and failure/ABI containment checks')
