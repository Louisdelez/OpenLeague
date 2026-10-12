
//! Real Windows critical sections mapped from canonical 32-bit CRT references.
//! Native opaque storage is pinned on the host; it is never copied into 24-byte PE banks.
use std::{cell::UnsafeCell,collections::{BTreeMap,BTreeSet},ffi::c_void,marker::PhantomData,rc::Rc,sync::{Arc,Mutex}};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_global_float_default_power::Windows};
#[repr(C)]struct Native{debug:*mut c_void,lock:i32,recursion:i32,owner:*mut c_void,semaphore:*mut c_void,spin:usize}
#[link(name="kernel32")]unsafe extern "system"{
 fn InitializeCriticalSectionEx(p:*mut Native,spin:u32,flags:u32)->i32;
 fn InitializeCriticalSectionAndSpinCount(p:*mut Native,spin:u32)->i32;
 fn TryEnterCriticalSection(p:*mut Native)->i32;fn EnterCriticalSection(p:*mut Native);fn LeaveCriticalSection(p:*mut Native);fn DeleteCriticalSection(p:*mut Native);
 fn GetCurrentThreadId()->u32;fn GetLastError()->u32;
}
#[derive(Debug,Clone,PartialEq,Eq)]pub enum Failure{Windows{code:u32},Duplicate(u32),Missing(u32),Busy(u32),WrongThread,OwnedAtDrop{reference:u32,owner:u32,depth:u32}}
#[derive(Default)]pub struct Report{failures:Mutex<Vec<Failure>>}
impl Report{fn record(&self,e:Failure){self.failures.lock().unwrap_or_else(|p|p.into_inner()).push(e);}pub fn failures(&self)->Vec<Failure>{self.failures.lock().unwrap_or_else(|p|p.into_inner()).clone()}}
#[derive(Default)]struct State{owner:u32,depth:u32}
pub struct Section{reference:u32,storage:Option<Box<UnsafeCell<Native>>>,state:Mutex<State>,report:Arc<Report>}
// Windows critical-section operations provide synchronization. The boxed opaque
// storage stays at one address from initialization until unowned deletion.
unsafe impl Send for Section{}unsafe impl Sync for Section{}
impl Section{
 fn pointer(&self)->*mut Native{self.storage.as_ref().unwrap().get()}
 fn new(reference:u32,spin:u32,flags:Option<u32>,report:Arc<Report>)->Result<Self,Failure>{
  let storage=Box::new(UnsafeCell::new(Native{debug:std::ptr::null_mut(),lock:0,recursion:0,owner:std::ptr::null_mut(),semaphore:std::ptr::null_mut(),spin:0}));
  let result=unsafe{match flags{Some(flags)=>InitializeCriticalSectionEx(storage.get(),spin,flags),None=>InitializeCriticalSectionAndSpinCount(storage.get(),spin)}};
  if result==0{return Err(Failure::Windows{code:unsafe{GetLastError()}});}Ok(Self{reference,storage:Some(storage),state:Mutex::new(State::default()),report})
 }
 fn enter_raw(&self){unsafe{EnterCriticalSection(self.pointer())};let mut state=self.state.lock().unwrap_or_else(|p|p.into_inner());state.owner=unsafe{GetCurrentThreadId()};state.depth+=1;}
 fn leave_raw(&self)->Result<(),Failure>{let mut state=self.state.lock().unwrap_or_else(|p|p.into_inner());if state.depth==0||state.owner!=unsafe{GetCurrentThreadId()}{return Err(Failure::WrongThread);}state.depth-=1;if state.depth==0{state.owner=0;}unsafe{LeaveCriticalSection(self.pointer())};Ok(())}
 fn held(&self)->bool{self.state.lock().unwrap_or_else(|p|p.into_inner()).depth!=0}
 /// A guard cannot migrate to another thread, including during unwinding.
 pub fn try_enter(self:&Arc<Self>)->Option<Guard>{if unsafe{TryEnterCriticalSection(self.pointer())}==0{return None;}let mut state=self.state.lock().unwrap_or_else(|p|p.into_inner());state.owner=unsafe{GetCurrentThreadId()};state.depth+=1;drop(state);Some(Guard{section:self.clone(),_thread:PhantomData})}
 pub fn enter(self:&Arc<Self>)->Guard{self.enter_raw();Guard{section:self.clone(),_thread:PhantomData}}
}
impl Drop for Section{fn drop(&mut self){let state=self.state.get_mut().unwrap_or_else(|p|p.into_inner());if state.depth!=0{self.report.record(Failure::OwnedAtDrop{reference:self.reference,owner:state.owner,depth:state.depth});if let Some(storage)=self.storage.take(){let _=Box::leak(storage);}return;}unsafe{DeleteCriticalSection(self.pointer())};}}
pub struct Guard{section:Arc<Section>,_thread:PhantomData<Rc<()>>}
impl Drop for Guard{fn drop(&mut self){if let Err(e)=self.section.leave_raw(){self.section.report.record(e);}}}
#[derive(Default)]pub struct Bank{sections:BTreeMap<u32,Arc<Section>>,report:Arc<Report>}
impl Bank{
 pub fn report(&self)->Arc<Report>{self.report.clone()}
 pub fn initialize(&mut self,reference:u32,spin:u32,flags:Option<u32>)->Result<u32,Failure>{if self.sections.contains_key(&reference){return Err(Failure::Duplicate(reference));}let section=Section::new(reference,spin,flags,self.report.clone())?;self.sections.insert(reference,Arc::new(section));Ok(1)}
 pub fn section(&self,reference:u32)->Result<Arc<Section>,Failure>{self.sections.get(&reference).cloned().ok_or(Failure::Missing(reference))}
 pub fn enter(&mut self,reference:u32)->Result<(),Failure>{self.sections.get(&reference).ok_or(Failure::Missing(reference))?.enter_raw();Ok(())}
 pub fn leave(&mut self,reference:u32)->Result<(),Failure>{self.sections.get(&reference).ok_or(Failure::Missing(reference))?.leave_raw()}
 pub fn delete(&mut self,reference:u32)->Result<(),Failure>{let section=self.sections.get(&reference).ok_or(Failure::Missing(reference))?;if Arc::strong_count(section)!=1||section.held(){return Err(Failure::Busy(reference));}self.sections.remove(&reference);Ok(())}
 pub fn len(&self)->usize{self.sections.len()}
 pub fn is_empty(&self)->bool{self.sections.is_empty()}
}
/// Production Windows service layer. Heap/error/thread services remain explicit
/// inner dependencies; CRT lock operations use initialized real Windows objects.
pub struct Provider<S>{pub inner:S,pub locks:Bank}
impl<S:Windows> Windows for Provider<S>{
 fn get_last_error(&mut self,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.get_last_error(m,d)}
 fn set_last_error(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.inner.set_last_error(v,m,d)}
 fn tls_get_value(&mut self,i:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.tls_get_value(i,m,d)}
 fn tls_set_value(&mut self,i:u32,v:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<bool,Error>{self.inner.tls_set_value(i,v,m,d)}
 fn calloc_thread(&mut self,n:u32,z:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{self.inner.calloc_thread(n,z,m,d)}
 fn free_thread(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.inner.free_thread(r,m,d)}
 fn current_thread_id(&mut self,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.current_thread_id(m,d)}
 fn thread_lock(&mut self,r:u32,enter:bool,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{(if enter{self.locks.enter(r)}else{self.locks.leave(r)}).map_err(|e|{self.locks.report.record(e);Error::Backend("actual Windows CRT critical-section operation failed")})}
}
impl<S:Windows> crate::audio_crt_thread_destructor::Services for Provider<S>{}
impl<S:Windows> crate::audio_crt_static_lock_startup::Services for Provider<S>{
 fn initialize(&mut self,function:u32,reference:u32,spin:u32,flags:Option<u32>,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{
  if (function==0)!=flags.is_none(){return Err(Error::Backend("CRT critical-section dispatch mismatch"));}crate::audio_path_source_virtual_cleanup::live(m,d,reference,24)?;
  match self.locks.initialize(reference,spin,flags){Ok(v)=>Ok(v),Err(e@Failure::Windows{..})=>{self.locks.report.record(e);Ok(0)},Err(e)=>{self.locks.report.record(e);Err(Error::Backend("CRT critical-section initialization ownership failure"))}}
 }
}
impl<S:Windows> crate::audio_crt_windows_shared_fls::LockCleanup for Provider<S>{
 fn delete_critical_section(&mut self,r:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.locks.delete(r).map_err(|e|{self.locks.report.record(e);Error::Backend("actual Windows CRT critical-section deletion failed")})}
}

#[cfg(test)]mod tests{
 use super::*;
 #[test]fn audio_windows_critical_sections_real_initialize_recursion_guard_lifetime_duplicate_and_delete_ownership(){for flags in[None,Some(0)]{for spin in[0,4000]{let mut bank=Bank::default();assert_eq!(bank.initialize(123,spin,flags),Ok(1));assert_eq!(bank.initialize(123,spin,flags),Err(Failure::Duplicate(123)));let section=bank.section(123).unwrap();let first=section.enter();let second=section.try_enter().unwrap();assert_eq!(bank.delete(123),Err(Failure::Busy(123)));drop(second);drop(first);assert_eq!(bank.delete(123),Err(Failure::Busy(123)));drop(section);bank.delete(123).unwrap();assert!(bank.is_empty());assert_eq!(bank.enter(123),Err(Failure::Missing(123)));assert!(bank.report().failures().is_empty());}}}
 #[test]fn audio_windows_critical_sections_actual_cross_thread_try_blocking_entry_and_contended_non_atomic_increment(){
  let mut bank=Bank::default();bank.initialize(456,4000,Some(0)).unwrap();let section=bank.section(456).unwrap();let guard=section.enter();let s=section.clone();let(ready,wait)=std::sync::mpsc::channel();let(entered,entry)=std::sync::mpsc::channel();let worker=std::thread::spawn(move||{assert!(s.try_enter().is_none());ready.send(()).unwrap();let _guard=s.enter();entered.send(()).unwrap();});wait.recv().unwrap();assert!(entry.try_recv().is_err());drop(guard);entry.recv_timeout(std::time::Duration::from_secs(5)).unwrap();worker.join().unwrap();
  let count=Arc::new(std::sync::atomic::AtomicU32::new(0));let mut workers=vec![];for _ in 0..4{let s=section.clone();let c=count.clone();workers.push(std::thread::spawn(move||{for _ in 0..1000{let _guard=s.enter();let value=c.load(std::sync::atomic::Ordering::Relaxed);std::thread::yield_now();c.store(value+1,std::sync::atomic::Ordering::Relaxed);}}));}for worker in workers{worker.join().unwrap();}assert_eq!(count.load(std::sync::atomic::Ordering::Relaxed),4000);drop(section);bank.delete(456).unwrap();assert!(bank.report().failures().is_empty());
 }
 #[test]fn audio_windows_critical_sections_wrong_thread_leave_is_rejected_and_owned_drop_retains_storage_with_failure_report(){
  let mut bank=Bank::default();bank.initialize(789,4000,None).unwrap();bank.enter(789).unwrap();let mut bank=std::thread::spawn(move||{assert_eq!(bank.leave(789),Err(Failure::WrongThread));bank}).join().unwrap();assert_eq!(bank.delete(789),Err(Failure::Busy(789)));bank.leave(789).unwrap();bank.delete(789).unwrap();
  let mut bank=Bank::default();let report=bank.report();bank.initialize(900,4000,Some(0)).unwrap();bank.enter(900).unwrap();drop(bank);assert!(matches!(report.failures().as_slice(),[Failure::OwnedAtDrop{reference:900,depth:1,..}]));
 }
}

impl<S:crate::audio_crt_global_dispatch_initialization::Services> crate::audio_crt_windows_dispatch_resolver::Services for Provider<S>{
 fn module_handle(&mut self,name:&str,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{crate::audio_crt_windows_dispatch_resolver::Services::module_handle(&mut self.inner,name,m,d)}
 fn procedure_address(&mut self,module:u32,name:&str,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{crate::audio_crt_windows_dispatch_resolver::Services::procedure_address(&mut self.inner,module,name,m,d)}
}
impl<S:crate::audio_crt_global_dispatch_initialization::Services> crate::audio_crt_global_dispatch_initialization::Services for Provider<S>{fn encode_pointer(&mut self,value:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{crate::audio_crt_global_dispatch_initialization::Services::encode_pointer(&mut self.inner,value,m,d)}}

impl<S:crate::audio_crt_windows_dispatch_resolver::Lookup> crate::audio_crt_windows_dispatch_resolver::Lookup for Provider<S>{fn export_pointer(&self,reference:u32,name:&str)->Result<usize,Error>{self.inner.export_pointer(reference,name)}fn fls_functions(&self,references:[u32;4])->Result<crate::audio_crt_windows_dispatch_resolver::FlsFunctions,Error>{self.inner.fls_functions(references)}}

impl<S:crate::audio_crt_worker_exit::ComServices> crate::audio_crt_worker_exit::ComServices for Provider<S>{
 fn load_library(&mut self,n:&str,f:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.load_library(n,f,m,d)}
 fn procedure(&mut self,r:u32,n:&str,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.procedure(r,n,m,d)}
 fn encode(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.encode(r,m,d)}
 fn decode(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.decode(r,m,d)}
 fn invoke_ro_uninitialize(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.inner.invoke_ro_uninitialize(r,m,d)}
}

impl<S:crate::audio_crt_worker_com_startup::Services> crate::audio_crt_worker_com_startup::Services for Provider<S>{
 fn current_package_id(&mut self,r:u32,l:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<crate::audio_crt_worker_com_startup::PackageQuery,Error>{self.inner.current_package_id(r,l,m,d)}
 fn invoke_ro_initialize(&mut self,r:u32,k:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.invoke_ro_initialize(r,k,m,d)}
}

impl<S:crate::audio_crt_worker_body::CallbackServices> crate::audio_crt_worker_body::CallbackServices for Provider<S>{
 fn worker_callback(&mut self,r:u32,a:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.worker_callback(r,a,m,d)}
}
