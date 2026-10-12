//! One Windows FLS index shared across threads, with serialized canonical CRT globals.
//! Thread values own distinct records. Arbitrary fiber migration is not supported.
use std::{collections::BTreeSet,ffi::c_void,marker::PhantomData,sync::{Arc,Weak,Mutex,RwLock,atomic::{AtomicU32,AtomicBool,Ordering}}};
use crate::{audio_crt_thread_destructor::Services,audio_crt_windows_fls_slot::{Context,Failure,Report}};
#[link(name="kernel32")]unsafe extern "system"{
 fn FlsAlloc(callback:Option<unsafe extern "system" fn(*mut c_void)>)->u32;
 fn FlsSetValue(index:u32,value:*mut c_void)->i32;
 fn FlsGetValue(index:u32)->*mut c_void;
 fn FlsFree(index:u32)->i32;
 fn GetLastError()->u32;fn SetLastError(value:u32);fn GetCurrentThreadId()->u32;
}
struct State<S>{context:Context<S>,bound:BTreeSet<u32>}
pub struct SharedContext<S>{state:Mutex<State<S>>,owner:AtomicU32}
struct Owner<'a>(&'a AtomicU32);
impl Drop for Owner<'_>{fn drop(&mut self){self.0.store(0,Ordering::Release);}}
impl<S> SharedContext<S>{
 pub fn new(context:Context<S>)->Self{Self{state:Mutex::new(State{context,bound:BTreeSet::new()}),owner:AtomicU32::new(0)}}
 fn access<R>(&self,f:impl FnOnce(&mut State<S>)->R)->Result<R,Failure>{
  let thread=unsafe{GetCurrentThreadId()};if self.owner.load(Ordering::Acquire)==thread{return Err(Failure::StateBusy);}
  let mut state=self.state.lock().map_err(|_|Failure::StatePoisoned)?;
  self.owner.store(thread,Ordering::Release);let _owner=Owner(&self.owner);Ok(f(&mut state))
 }
 /// Serialized access. Same-thread reentry fails instead of deadlocking.
 pub fn with<R>(&self,f:impl FnOnce(&mut Context<S>)->R)->Result<R,Failure>{self.access(|s|f(&mut s.context))}
}
/// Optional production cleanup, run only after successful source destruction.
/// Diagnostic mode retains snapshots by leaving this policy unset.
pub type Retirement<S>=fn(&mut Context<S>)->Result<(),crate::audio_bus_bank::Error>;
struct Data<S>{retirement:Option<Retirement<S>>,context:Arc<SharedContext<S>>,record:u32,report:Arc<Report>}
unsafe extern "system" fn callback<S:Services+Send+'static>(pointer:*mut c_void){
 if pointer.is_null(){return;}
 let data=unsafe{Box::from_raw(pointer.cast::<Data<S>>())};let report=Arc::clone(&data.report);report.attempt();
 // Windows has already removed this thread/fiber's value before calling us.
 let outcome=std::panic::catch_unwind(std::panic::AssertUnwindSafe(||{
  let result=data.context.access(|state|{
   let Context{memory,dead,services}=&mut state.context;
   let result=crate::audio_crt_fls_callback::dispatch(Some(crate::audio_crt_fls_callback::THREAD_DESTRUCTOR),data.record,memory,dead,services);
   state.bound.remove(&data.record);
   let result=result.and_then(|()|match data.retirement{Some(retire)=>retire(&mut state.context),None=>Ok(())});result.map_err(|e|Failure::Destructor(format!("{e:?}")))
  });
  match result{Ok(Ok(()))=>report.success(),Ok(Err(e))|Err(e)=>report.fail(e)}
 }));
 if outcome.is_err(){report.fail(Failure::Panicked);}
}
struct Inner<S>{api:crate::audio_crt_windows_dispatch_resolver::FlsFunctions,retirement:Option<Retirement<S>>,context:Mutex<Option<Weak<SharedContext<S>>>>,allocated_index:u32,cleanup_done:AtomicBool,index:RwLock<Option<u32>>,report:Arc<Report>,_services:PhantomData<fn()->S>}
impl<S> Drop for Inner<S>{fn drop(&mut self){let index=self.index.get_mut().unwrap_or_else(|p|p.into_inner());if let Some(i)=*index{if unsafe{(self.api.free)(i)}==0{self.report.fail(Failure::Windows{operation:"FlsFree",code:unsafe{GetLastError()}});}else{*index=None;}}}}
pub struct SharedSlot<S:Services+Send+'static>{inner:Arc<Inner<S>>}
impl<S:Services+Send+'static> Clone for SharedSlot<S>{fn clone(&self)->Self{Self{inner:Arc::clone(&self.inner)}}}
impl<S:Services+Send+'static> SharedSlot<S>{
 pub fn new()->Result<Self,Failure>{Self::new_policy(None,Self::linked_api())}
 /// Production policy runs under serialized state access after the destructor
 /// succeeds, on both thread exit and slot close. Cleanup errors are sticky
 /// callback failures; diagnostic clients can continue to use new().
 pub fn new_with_retirement(retire:Retirement<S>)->Result<Self,Failure>{Self::new_policy(Some(retire),Self::linked_api())}
 fn linked_api()->crate::audio_crt_windows_dispatch_resolver::FlsFunctions{unsafe{crate::audio_crt_windows_dispatch_resolver::FlsFunctions::new(FlsAlloc,FlsFree,FlsGetValue,FlsSetValue)}}
 /// Production root uses the exact typed exports from its native resolver.
 pub fn new_resolved(retirement:Option<Retirement<S>>,api:crate::audio_crt_windows_dispatch_resolver::FlsFunctions)->Result<Self,Failure>{Self::new_policy(retirement,api)}
 fn new_policy(retirement:Option<Retirement<S>>,api:crate::audio_crt_windows_dispatch_resolver::FlsFunctions)->Result<Self,Failure>{let index=unsafe{(api.alloc)(Some(callback::<S>))};if index==u32::MAX{return Err(Failure::Windows{operation:"FlsAlloc",code:unsafe{GetLastError()}});}Ok(Self{inner:Arc::new(Inner{api,retirement,context:Mutex::new(None),allocated_index:index,cleanup_done:AtomicBool::new(false),index:RwLock::new(Some(index)),report:Arc::new(Report::new()),_services:PhantomData})})}
 pub fn report(&self)->Arc<Report>{Arc::clone(&self.inner.report)}
 pub fn bind_current(&self,context:Arc<SharedContext<S>>,record:u32)->Result<(),Failure>{
  self.claim_context(&context)?;
  let guard=self.inner.index.try_read().map_err(|e|match e{std::sync::TryLockError::WouldBlock=>Failure::SlotClosing,_=>Failure::StatePoisoned})?;
  let index=guard.ok_or(Failure::Closed)?;
  // Inspection is an ownership check, not the original setter; preserve LastError.
  let saved=unsafe{GetLastError()};let existing=unsafe{(self.inner.api.get)(index)};let error=unsafe{GetLastError()};unsafe{SetLastError(saved)};
  if !existing.is_null(){return Err(Failure::Occupied);}if error!=0{return Err(Failure::Windows{operation:"FlsGetValue",code:error});}
  context.access(|state|{
   if record==0{return Err(Failure::InvalidContext("NULL record".into()));}
   crate::audio_path_source_virtual_cleanup::live(&state.context.memory,&state.context.dead,record,0x3bc).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?;
   if !state.bound.insert(record){return Err(Failure::Occupied);}
   let data=Box::into_raw(Box::new(Data{retirement:self.inner.retirement,context:Arc::clone(&context),record,report:Arc::clone(&self.inner.report)}));
   if unsafe{(self.inner.api.set)(index,data.cast())}==0{let code=unsafe{GetLastError()};unsafe{drop(Box::from_raw(data))};state.bound.remove(&record);return Err(Failure::Windows{operation:"FlsSetValue",code});}Ok(())
  })?
 }
 pub fn value(&self)->Result<u32,Failure>{let guard=self.inner.index.try_read().map_err(|e|match e{std::sync::TryLockError::WouldBlock=>Failure::SlotClosing,_=>Failure::StatePoisoned})?;let index=guard.ok_or(Failure::Closed)?;let data=unsafe{(self.inner.api.get)(index)};if data.is_null(){let code=unsafe{GetLastError()};if code!=0{return Err(Failure::Windows{operation:"FlsGetValue",code});}return Ok(0);}Ok(unsafe{(*data.cast::<Data<S>>()).record})}
 /// Releases all live worker values synchronously on the caller, as measured on Windows.
 pub fn close(&self)->Result<(),Failure>{let mut guard=self.inner.index.try_write().map_err(|e|match e{std::sync::TryLockError::WouldBlock=>Failure::SlotClosing,_=>Failure::StatePoisoned})?;if let Some(index)=*guard{if unsafe{(self.inner.api.free)(index)}==0{return Err(Failure::Windows{operation:"FlsFree",code:unsafe{GetLastError()}});}*guard=None;}match self.inner.report.failure(){Some(e)=>Err(e),None=>Ok(())}}
}

/// Canonical decoded FLS function references supplied by the verified resolver.
/// They identify dispatch in the 32-bit source image; they are not host pointers.
#[derive(Clone,Copy)]pub struct ValueDispatch{pub get:u32,pub set:u32}
struct CurrentProvider<'a,S>{api:crate::audio_crt_windows_dispatch_resolver::FlsFunctions,retirement:Option<Retirement<S>>,services:&'a mut S,context:Arc<SharedContext<S>>,bound:&'a mut BTreeSet<u32>,report:Arc<Report>,index:u32,dispatch:ValueDispatch}
impl<S:Services+Send+'static> crate::audio_crt_tls_value_wrappers::Services for CurrentProvider<'_,S>{
 fn get_value(&mut self,function:u32,index:u32,_:&mut std::collections::BTreeMap<u32,crate::audio_plugin_factory::Memory>,_:&mut BTreeSet<u32>)->Result<u32,crate::audio_bus_bank::Error>{
  if function==0||function!=self.dispatch.get||index!=self.index{return Err(crate::audio_bus_bank::Error::Backend("shared FLS getter dispatch/index mismatch"));}
  let data=unsafe{(self.api.get)(index)};Ok(if data.is_null(){0}else{unsafe{(*data.cast::<Data<S>>()).record}})
 }
 fn set_value(&mut self,function:u32,index:u32,record:u32,m:&mut std::collections::BTreeMap<u32,crate::audio_plugin_factory::Memory>,d:&mut BTreeSet<u32>)->Result<u32,crate::audio_bus_bank::Error>{
  use crate::audio_bus_bank::Error;
  if function==0||function!=self.dispatch.set||index!=self.index{return Err(Error::Backend("shared FLS setter dispatch/index mismatch"));}
  let saved=unsafe{GetLastError()};let old=unsafe{(self.api.get)(index)};unsafe{SetLastError(saved)};
  let old_record=if old.is_null(){0}else{unsafe{(*old.cast::<Data<S>>()).record}};
  if record!=0{crate::audio_path_source_virtual_cleanup::live(m,d,record,0x3bc)?;if record!=old_record&&self.bound.contains(&record){return Err(Error::Backend("CRT record already bound to another thread"));}}
  let next=if record==0{std::ptr::null_mut()}else{Box::into_raw(Box::new(Data{retirement:self.retirement,context:self.context.clone(),record,report:self.report.clone()})).cast::<c_void>()};
  let result=unsafe{(self.api.set)(index,next)}as u32;
  if result==0{if !next.is_null(){unsafe{drop(Box::from_raw(next.cast::<Data<S>>()))};}return Ok(result);}
  // Original FlsSetValue replacement/clear does not invoke the destructor.
  // Reclaim only the adapter payload; canonical record ownership stays with caller.
  if !old.is_null(){unsafe{drop(Box::from_raw(old.cast::<Data<S>>()))};self.bound.remove(&old_record);}
  if record!=0{self.bound.insert(record);}Ok(result)
 }
}
impl<S:Services+Send+'static> crate::audio_global_float_default_power::Windows for CurrentProvider<'_,S>{
 fn get_last_error(&mut self,m:&mut std::collections::BTreeMap<u32,crate::audio_plugin_factory::Memory>,d:&mut BTreeSet<u32>)->Result<u32,crate::audio_bus_bank::Error>{self.services.get_last_error(m,d)}
 fn set_last_error(&mut self,v:u32,m:&mut std::collections::BTreeMap<u32,crate::audio_plugin_factory::Memory>,d:&mut BTreeSet<u32>)->Result<(),crate::audio_bus_bank::Error>{self.services.set_last_error(v,m,d)}
 fn tls_get_value(&mut self,i:u32,m:&mut std::collections::BTreeMap<u32,crate::audio_plugin_factory::Memory>,d:&mut BTreeSet<u32>)->Result<u32,crate::audio_bus_bank::Error>{crate::audio_crt_tls_value_wrappers::get_value(m,d,i,self)}
 fn tls_set_value(&mut self,i:u32,v:u32,m:&mut std::collections::BTreeMap<u32,crate::audio_plugin_factory::Memory>,d:&mut BTreeSet<u32>)->Result<bool,crate::audio_bus_bank::Error>{Ok(crate::audio_crt_tls_value_wrappers::set_value(m,d,i,v,self)?!=0)}
 fn calloc_thread(&mut self,n:u32,z:u32,m:&mut std::collections::BTreeMap<u32,crate::audio_plugin_factory::Memory>,d:&mut BTreeSet<u32>)->Result<Option<u32>,crate::audio_bus_bank::Error>{self.services.calloc_thread(n,z,m,d)}
 fn free_thread(&mut self,r:u32,m:&mut std::collections::BTreeMap<u32,crate::audio_plugin_factory::Memory>,d:&mut BTreeSet<u32>)->Result<(),crate::audio_bus_bank::Error>{self.services.free_thread(r,m,d)}
 fn current_thread_id(&mut self,m:&mut std::collections::BTreeMap<u32,crate::audio_plugin_factory::Memory>,d:&mut BTreeSet<u32>)->Result<u32,crate::audio_bus_bank::Error>{self.services.current_thread_id(m,d)}
 fn thread_lock(&mut self,r:u32,e:bool,m:&mut std::collections::BTreeMap<u32,crate::audio_plugin_factory::Memory>,d:&mut BTreeSet<u32>)->Result<(),crate::audio_bus_bank::Error>{self.services.thread_lock(r,e,m,d)}
}
impl<S:Services+Send+'static> SharedSlot<S>{
 /// Publish the actually allocated index into the original CRT global after allocation.
 /// This adapter step does not perform global/static-lock initialization.
 pub fn publish_index(&self,context:&Arc<SharedContext<S>>)->Result<(),Failure>{
  self.claim_context(context)?;
  let guard=self.inner.index.try_read().map_err(|_|Failure::SlotClosing)?;let index=guard.ok_or(Failure::Closed)?;
  context.with(|c|crate::audio_path_source_virtual_cleanup::put(&mut c.memory,&c.dead,0x12230cc,4,index).map_err(|e|Failure::InvalidContext(format!("{e:?}"))))?
 }
 /// Execute the original CA91A9 getter/CA9218 constructor with real encoded FLS values.
 /// One state lock covers construction and binding without recursively acquiring it.
 pub fn get_or_create_current(&self,context:Arc<SharedContext<S>>,dispatch:ValueDispatch)->Result<u32,Failure>{
  self.claim_context(&context)?;
  let guard=self.inner.index.try_read().map_err(|_|Failure::SlotClosing)?;let index=guard.ok_or(Failure::Closed)?;
  context.access(|state|{
   let Context{memory,dead,services}=&mut state.context;
   if crate::audio_path_source_virtual_cleanup::get(memory,dead,0x12230cc,4).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?!=index{return Err(Failure::InvalidContext("original CRT global slot index not published".into()));}
   let mut provider=CurrentProvider{api:self.inner.api,retirement:self.inner.retirement,services,context:context.clone(),bound:&mut state.bound,report:self.inner.report.clone(),index,dispatch};
   crate::audio_crt_thread_context::get_context(memory,dead,&mut provider).map_err(|e|Failure::InvalidContext(format!("{e:?}")))
  })?
 }
}

#[cfg(test)]
#[path="audio_crt_windows_shared_fls_tests.rs"] mod tests;

/// Only the original lock-retirement dependency is needed after OS slot closure.
pub trait LockCleanup{fn delete_critical_section(&mut self,reference:u32,m:&mut std::collections::BTreeMap<u32,crate::audio_plugin_factory::Memory>,dead:&mut BTreeSet<u32>)->Result<(),crate::audio_bus_bank::Error>;}
impl<S:Services+LockCleanup+Send+'static> SharedSlot<S>{
 /// Finish original CA9341 cleanup in callback-safe phases. The canonical state
 /// lock is released during FlsFree, then original CB027B deletion resumes.
 pub fn shutdown_crt(&self,context:&Arc<SharedContext<S>>)->Result<(),Failure>{
  self.claim_context(context)?;
  let mut guard=self.inner.index.try_write().map_err(|_|Failure::SlotClosing)?;
  if self.inner.cleanup_done.load(Ordering::Acquire){return match self.inner.report.failure(){Some(e)=>Err(e),None=>Ok(())};}
  context.with(|c|{let index=crate::audio_path_source_virtual_cleanup::get(&c.memory,&c.dead,0x12230cc,4).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?;if index!=self.inner.allocated_index&&!(index==u32::MAX&&self.inner.report.failure().is_some()){return Err(Failure::InvalidContext("CRT cleanup global slot ownership mismatch".into()));}Ok(())})??;
  if let Some(index)=*guard{if unsafe{(self.inner.api.free)(index)}==0{return Err(Failure::Windows{operation:"FlsFree",code:unsafe{GetLastError()}});}*guard=None;}
  let result=context.with(|c|{
   crate::audio_path_source_virtual_cleanup::put(&mut c.memory,&c.dead,0x12230cc,4,u32::MAX).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?;
   // Failed destructor may still own locks; retain them instead of unsafe deletion.
   if let Some(e)=self.inner.report.failure(){return Err(e);}
   crate::audio_crt_thread_system_startup::cleanup_lock_table(&mut c.memory,&mut c.dead,&mut c.services,|s,r,m,d|s.delete_critical_section(r,m,d)).map_err(|e|Failure::Destructor(format!("{e:?}")))
  }).and_then(|v|v);
  if let Err(e)=result{self.inner.report.fail(e.clone());return Err(e);}
  self.inner.cleanup_done.store(true,Ordering::Release);Ok(())
 }
}

impl<S:Services+Send+'static> SharedSlot<S>{
 fn claim_context(&self,context:&Arc<SharedContext<S>>)->Result<(),Failure>{
  let mut assigned=self.inner.context.lock().map_err(|_|Failure::StatePoisoned)?;
  if let Some(old)=&*assigned{match old.upgrade(){Some(old)if Arc::ptr_eq(&old,context)=>Ok(()),_=>Err(Failure::InvalidContext("one global CRT FLS slot must use one canonical context".into()))}}else{*assigned=Some(Arc::downgrade(context));Ok(())}
 }
}

use std::collections::BTreeMap;use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};

impl<S:Services+Send+'static> crate::audio_crt_thread_destructor::Services for CurrentProvider<'_,S>{}

impl<S:Services+crate::audio_crt_worker_exit::ComServices+Send+'static> crate::audio_crt_worker_exit::ComServices for CurrentProvider<'_,S>{
 fn load_library(&mut self,n:&str,f:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.services.load_library(n,f,m,d)}
 fn procedure(&mut self,r:u32,n:&str,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.services.procedure(r,n,m,d)}
 fn encode(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.services.encode(r,m,d)}
 fn decode(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.services.decode(r,m,d)}
 fn invoke_ro_uninitialize(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.services.invoke_ro_uninitialize(r,m,d)}
}

impl<S:Services+crate::audio_crt_worker_exit::ComServices+Send+'static> SharedSlot<S>{
 /// Explicit source detachment and mirror retirement on the current worker.
 /// FLS data is cleared before destruction, so OS thread exit cannot destroy it twice.
 pub fn prepare_worker_exit(&self,context:Arc<SharedContext<S>>,dispatch:ValueDispatch,code:u32)->Result<crate::audio_crt_worker_exit::PreparedExit,Failure>{
  self.claim_context(&context)?;let guard=self.inner.index.try_read().map_err(|_|Failure::SlotClosing)?;let index=guard.ok_or(Failure::Closed)?;
  context.access(|state|{
   let Context{memory,dead,services}=&mut state.context;
   if crate::audio_path_source_virtual_cleanup::get(memory,dead,0x12230cc,4).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?!=index{return Err(Failure::InvalidContext("worker exit slot ownership mismatch".into()));}
   let mut provider=CurrentProvider{api:self.inner.api,retirement:self.inner.retirement,services,context:context.clone(),bound:&mut state.bound,report:self.inner.report.clone(),index,dispatch};
   let result=crate::audio_crt_worker_exit::prepare_exit(memory,dead,code,&mut provider).map_err(|e|Failure::Destructor(format!("{e:?}")))?;
   if let Some(retire)=self.inner.retirement{retire(&mut state.context).map_err(|e|Failure::Destructor(format!("{e:?}")))?;}Ok(result)
  })?
 }
}

impl<S:Services+crate::audio_crt_worker_com_startup::Services+Send+'static> crate::audio_crt_worker_com_startup::Services for CurrentProvider<'_,S>{
 fn current_package_id(&mut self,r:u32,l:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<crate::audio_crt_worker_com_startup::PackageQuery,Error>{self.services.current_package_id(r,l,m,d)}
 fn invoke_ro_initialize(&mut self,r:u32,k:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.services.invoke_ro_initialize(r,k,m,d)}
}

impl<S:Services+crate::audio_crt_worker_com_startup::Services+Send+'static> SharedSlot<S>{
 pub fn initialize_worker_com(&self,context:Arc<SharedContext<S>>,dispatch:ValueDispatch)->Result<u32,Failure>{
  self.claim_context(&context)?;let guard=self.inner.index.try_read().map_err(|_|Failure::SlotClosing)?;let index=guard.ok_or(Failure::Closed)?;
  context.access(|state|{let Context{memory,dead,services}=&mut state.context;
   if crate::audio_path_source_virtual_cleanup::get(memory,dead,0x12230cc,4).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?!=index{return Err(Failure::InvalidContext("worker COM slot ownership mismatch".into()));}
   let mut provider=CurrentProvider{api:self.inner.api,retirement:self.inner.retirement,services,context:context.clone(),bound:&mut state.bound,report:self.inner.report.clone(),index,dispatch};let record=crate::audio_crt_thread_context::get_context(memory,dead,&mut provider).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?;if record==0{return Err(Failure::InvalidContext("worker context allocation returned NULL".into()));}
   crate::audio_crt_worker_com_startup::prepare_worker(memory,dead,record,&mut provider).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?;Ok(record)
  })?
 }
}


impl<S:Services+crate::audio_crt_worker_body::CallbackServices+Send+'static> crate::audio_crt_worker_body::CallbackServices for CurrentProvider<'_,S>{
 fn worker_callback(&mut self,r:u32,a:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.services.worker_callback(r,a,m,d)}
}
impl<S:Services+crate::audio_crt_worker_exit::ComServices+crate::audio_crt_worker_body::CallbackServices+Send+'static> SharedSlot<S>{
 /// Qualified normal callback/exit path. Native exception dispatch is not supplied.
 pub fn prepare_worker_body_exit(&self,context:Arc<SharedContext<S>>,dispatch:ValueDispatch)->Result<crate::audio_crt_worker_exit::PreparedExit,Failure>{
  self.claim_context(&context)?;let guard=self.inner.index.try_read().map_err(|_|Failure::SlotClosing)?;let index=guard.ok_or(Failure::Closed)?;
  context.access(|state|{let Context{memory,dead,services}=&mut state.context;
   if crate::audio_path_source_virtual_cleanup::get(memory,dead,0x12230cc,4).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?!=index{return Err(Failure::InvalidContext("worker body slot ownership mismatch".into()));}
   let mut provider=CurrentProvider{api:self.inner.api,retirement:self.inner.retirement,services,context:context.clone(),bound:&mut state.bound,report:self.inner.report.clone(),index,dispatch};
   let exit=crate::audio_crt_worker_body::prepare_normal_exit(memory,dead,&mut provider).map_err(|e|Failure::Destructor(format!("{e:?}")))?;
   if let Some(retire)=self.inner.retirement{retire(&mut state.context).map_err(|e|Failure::Destructor(format!("{e:?}")))?;}Ok(exit)
  })?
 }
}


impl<S:Services+Send+'static> SharedSlot<S>{
 /// Source packet production while the owning slot/index/context remain guarded.
 /// The syscall closure must not wait for the worker or reenter this state guard.
 pub fn create_worker_packet<F:FnMut(crate::audio_crt_worker_packet::ThreadRequest,&mut S,&mut BTreeMap<u32,Memory>,&mut BTreeSet<u32>)->Result<u32,Error>>(&self,context:Arc<SharedContext<S>>,dispatch:ValueDispatch,request:crate::audio_crt_worker_packet::Request,mut spawn:F)->Result<u32,Failure>{
  self.claim_context(&context)?;let guard=self.inner.index.try_read().map_err(|_|Failure::SlotClosing)?;let index=guard.ok_or(Failure::Closed)?;
  context.access(|state|{let Context{memory,dead,services}=&mut state.context;
   if crate::audio_path_source_virtual_cleanup::get(memory,dead,0x12230cc,4).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?!=index{return Err(Failure::InvalidContext("worker producer slot ownership mismatch".into()));}
   let mut provider=CurrentProvider{api:self.inner.api,retirement:self.inner.retirement,services,context:context.clone(),bound:&mut state.bound,report:self.inner.report.clone(),index,dispatch};
   let mut creator=crate::audio_crt_worker_packet::Creator{windows:&mut provider,spawn:|r,p:&mut CurrentProvider<'_,S>,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>|spawn(r,p.services,m,d)};
   let result=crate::audio_crt_worker_packet::create(memory,dead,request,&mut creator).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?;
   if let Some(retire)=self.inner.retirement{retire(&mut state.context).map_err(|e|Failure::Destructor(format!("{e:?}")))?;}Ok(result)
  })?
 }
}
impl<S:Services+crate::audio_crt_worker_com_startup::Services+Send+'static> SharedSlot<S>{
 pub fn initialize_worker_packet(&self,context:Arc<SharedContext<S>>,dispatch:ValueDispatch,incoming:u32)->Result<crate::audio_crt_worker_entry::Entry,Failure>{
  self.claim_context(&context)?;let guard=self.inner.index.try_read().map_err(|_|Failure::SlotClosing)?;let index=guard.ok_or(Failure::Closed)?;
  context.access(|state|{if state.bound.contains(&incoming){return Err(Failure::InvalidContext("incoming packet already bound to an FLS owner".into()));}let Context{memory,dead,services}=&mut state.context;
   if crate::audio_path_source_virtual_cleanup::get(memory,dead,0x12230cc,4).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?!=index{return Err(Failure::InvalidContext("worker entry slot ownership mismatch".into()));}
   crate::audio_path_source_virtual_cleanup::live(memory,dead,incoming,956).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?;
   let mut provider=CurrentProvider{api:self.inner.api,retirement:self.inner.retirement,services,context:context.clone(),bound:&mut state.bound,report:self.inner.report.clone(),index,dispatch};
   let result=crate::audio_crt_worker_entry::prepare_entry(memory,dead,incoming,&mut provider).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?;
   if let crate::audio_crt_worker_entry::Entry::Ready{record}=result{crate::audio_crt_worker_com_startup::prepare_worker(memory,dead,record,&mut provider).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?;}
   if let Some(retire)=self.inner.retirement{retire(&mut state.context).map_err(|e|Failure::Destructor(format!("{e:?}")))?;}Ok(result)
  })?
 }
}
