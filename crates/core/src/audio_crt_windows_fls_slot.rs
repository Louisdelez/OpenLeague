//! Owned real Windows FLS slot feeding the reconstructed CRT context destructor.
//! Call close without holding the context mutex. Callback failures remain observable.
use std::{collections::{BTreeMap,BTreeSet},ffi::c_void,marker::PhantomData,rc::Rc,sync::{Arc,Mutex,atomic::{AtomicU32,Ordering}}};
use crate::{audio_plugin_factory::Memory,audio_crt_thread_destructor::Services};
pub struct Context<S>{pub memory:BTreeMap<u32,Memory>,pub dead:BTreeSet<u32>,pub services:S}
#[derive(Debug,Clone,PartialEq,Eq)]pub enum Failure{Windows{operation:&'static str,code:u32},WrongThread,Closed,SlotClosing,Occupied,StateBusy,StatePoisoned,InvalidContext(String),Destructor(String),Panicked}
pub struct Report{attempts:AtomicU32,completed:AtomicU32,failure:Mutex<Option<Failure>>}
impl Report{
 pub(crate) fn new()->Self{Self{attempts:AtomicU32::new(0),completed:AtomicU32::new(0),failure:Mutex::new(None)}}
 pub(crate) fn fail(&self,f:Failure){let mut v=self.failure.lock().unwrap_or_else(|p|p.into_inner());if v.is_none(){*v=Some(f);}}
 pub(crate) fn attempt(&self){self.attempts.fetch_add(1,Ordering::AcqRel);}
 pub(crate) fn success(&self){self.completed.fetch_add(1,Ordering::AcqRel);}
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
