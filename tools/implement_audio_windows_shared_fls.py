from pathlib import Path
r=Path('E:/OpenLeague')
p=r/'crates/core/src/audio_crt_windows_fls_slot.rs'
s=p.read_text();s=s.replace('WrongThread,StateBusy','WrongThread,Closed,SlotClosing,Occupied,StateBusy').replace(' fn new()->Self',' pub(crate) fn new()->Self').replace(' fn fail(&self,f:Failure)',' pub(crate) fn fail(&self,f:Failure)');p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/lib.rs';s=p.read_text();s+='\n#[cfg(windows)]\npub mod audio_crt_windows_shared_fls;\n';p.write_text(s,encoding='utf-8')
source=r'''//! One Windows FLS index shared across threads, with serialized canonical CRT globals.
//! Thread values own distinct records. Arbitrary fiber migration is not supported.
use std::{collections::BTreeSet,ffi::c_void,marker::PhantomData,sync::{Arc,Mutex,RwLock,atomic::{AtomicU32,Ordering}}};
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
struct Data<S>{context:Arc<SharedContext<S>>,record:u32,report:Arc<Report>}
unsafe extern "system" fn callback<S:Services+Send+'static>(pointer:*mut c_void){
 if pointer.is_null(){return;}
 let data=unsafe{Box::from_raw(pointer.cast::<Data<S>>())};let report=Arc::clone(&data.report);
 // Windows has already removed this thread/fiber's value before calling us.
 let outcome=std::panic::catch_unwind(std::panic::AssertUnwindSafe(||{
  let result=data.context.access(|state|{
   let Context{memory,dead,services}=&mut state.context;
   let result=crate::audio_crt_fls_callback::dispatch(Some(crate::audio_crt_fls_callback::THREAD_DESTRUCTOR),data.record,memory,dead,services);
   state.bound.remove(&data.record);result.map_err(|e|Failure::Destructor(format!("{e:?}")))
  });
  match result{Ok(Ok(()))=>report.success(),Ok(Err(e))|Err(e)=>report.fail(e)}
 }));
 report.attempt();if outcome.is_err(){report.fail(Failure::Panicked);}
}
struct Inner<S>{index:RwLock<Option<u32>>,report:Arc<Report>,_services:PhantomData<fn()->S>}
impl<S> Drop for Inner<S>{fn drop(&mut self){let index=self.index.get_mut().unwrap_or_else(|p|p.into_inner());if let Some(i)=*index{if unsafe{FlsFree(i)}==0{self.report.fail(Failure::Windows{operation:"FlsFree",code:unsafe{GetLastError()}});}else{*index=None;}}}}
pub struct SharedSlot<S:Services+Send+'static>{inner:Arc<Inner<S>>}
impl<S:Services+Send+'static> Clone for SharedSlot<S>{fn clone(&self)->Self{Self{inner:Arc::clone(&self.inner)}}}
impl<S:Services+Send+'static> SharedSlot<S>{
 pub fn new()->Result<Self,Failure>{let index=unsafe{FlsAlloc(Some(callback::<S>))};if index==u32::MAX{return Err(Failure::Windows{operation:"FlsAlloc",code:unsafe{GetLastError()}});}Ok(Self{inner:Arc::new(Inner{index:RwLock::new(Some(index)),report:Arc::new(Report::new()),_services:PhantomData})})}
 pub fn report(&self)->Arc<Report>{Arc::clone(&self.inner.report)}
 pub fn bind_current(&self,context:Arc<SharedContext<S>>,record:u32)->Result<(),Failure>{
  let guard=self.inner.index.try_read().map_err(|e|match e{std::sync::TryLockError::WouldBlock=>Failure::SlotClosing,_=>Failure::StatePoisoned})?;
  let index=guard.ok_or(Failure::Closed)?;
  // Inspection is an ownership check, not the original setter; preserve LastError.
  let saved=unsafe{GetLastError()};let existing=unsafe{FlsGetValue(index)};let error=unsafe{GetLastError()};unsafe{SetLastError(saved)};
  if !existing.is_null(){return Err(Failure::Occupied);}if error!=0{return Err(Failure::Windows{operation:"FlsGetValue",code:error});}
  context.access(|state|{
   if record==0{return Err(Failure::InvalidContext("NULL record".into()));}
   crate::audio_path_source_virtual_cleanup::live(&state.context.memory,&state.context.dead,record,0x3bc).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?;
   if !state.bound.insert(record){return Err(Failure::Occupied);}
   let data=Box::into_raw(Box::new(Data{context:Arc::clone(&context),record,report:Arc::clone(&self.inner.report)}));
   if unsafe{FlsSetValue(index,data.cast())}==0{let code=unsafe{GetLastError()};unsafe{drop(Box::from_raw(data))};state.bound.remove(&record);return Err(Failure::Windows{operation:"FlsSetValue",code});}Ok(())
  })?
 }
 pub fn value(&self)->Result<u32,Failure>{let guard=self.inner.index.try_read().map_err(|e|match e{std::sync::TryLockError::WouldBlock=>Failure::SlotClosing,_=>Failure::StatePoisoned})?;let index=guard.ok_or(Failure::Closed)?;let data=unsafe{FlsGetValue(index)};if data.is_null(){let code=unsafe{GetLastError()};if code!=0{return Err(Failure::Windows{operation:"FlsGetValue",code});}return Ok(0);}Ok(unsafe{(*data.cast::<Data<S>>()).record})}
 /// Releases all live worker values synchronously on the caller, as Windows specifies.
 pub fn close(&self)->Result<(),Failure>{let mut guard=self.inner.index.try_write().map_err(|e|match e{std::sync::TryLockError::WouldBlock=>Failure::SlotClosing,_=>Failure::StatePoisoned})?;if let Some(index)=*guard{if unsafe{FlsFree(index)}==0{return Err(Failure::Windows{operation:"FlsFree",code:unsafe{GetLastError()}});}*guard=None;}match self.inner.report.failure(){Some(e)=>Err(e),None=>Ok(())}}
}
'''
# Shared component uses private counter methods instead of exposing atomics.
p=r/'crates/core/src/audio_crt_windows_fls_slot.rs';s=p.read_text();s=s.replace(' pub fn attempts(&self)', ' pub(crate) fn attempt(&self){self.attempts.fetch_add(1,Ordering::AcqRel);}\n pub(crate) fn success(&self){self.completed.fetch_add(1,Ordering::AcqRel);}\n pub fn attempts(&self)');p.write_text(s,encoding='utf-8')
(r/'crates/core/src/audio_crt_windows_shared_fls.rs').write_text(source,encoding='utf-8')
(r/'tools/implement_audio_windows_shared_fls.py').write_text(Path(__file__).read_text(),encoding='utf-8')
print('shared component implemented')
