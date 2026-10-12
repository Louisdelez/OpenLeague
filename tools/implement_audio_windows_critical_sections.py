from pathlib import Path
r=Path('E:/OpenLeague');source=r'''
//! Real Windows critical sections mapped from canonical 32-bit CRT references.
//! Native opaque storage is pinned on the host; it is never copied into 24-byte PE banks.
use std::{cell::UnsafeCell,collections::{BTreeMap,BTreeSet},ffi::c_void,marker::PhantomData,rc::Rc,sync::{Arc,Mutex}};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_global_float_default_power::Windows};
#[repr(C)]struct Native{debug:*mut c_void,lock:i32,recursion:i32,owner:*mut c_void,semaphore:*mut c_void,spin:usize}
#[link(name="kernel32")]unsafe extern "system"{
 fn InitializeCriticalSectionEx(p:*mut Native,spin:u32,flags:u32)->i32;
 fn InitializeCriticalSectionAndSpinCount(p:*mut Native,spin:u32)->i32;
 fn EnterCriticalSection(p:*mut Native);fn LeaveCriticalSection(p:*mut Native);fn DeleteCriticalSection(p:*mut Native);
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
'''
(r/'crates/core/src/audio_crt_windows_critical_sections.rs').write_text(source,encoding='utf-8')
p=r/'crates/core/src/lib.rs';s=p.read_text();s+='\n#[cfg(windows)]\npub mod audio_crt_windows_critical_sections;\n';p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/audio_crt_thread_system_startup.rs';s=p.read_text();a=s.index(' for j in 0..36{');b=s.index('\npub fn initialize',a);body=s[a:b];assert body.endswith(' Ok(())\n}');s=s[:a]+' cleanup_lock_table(m,d,s,|s,r,m,d|s.delete_critical_section(r,m,d))\n}\n/// Original CB027B two-pass lock retirement, also used after real OS callbacks.\npub fn cleanup_lock_table<S:Windows>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,s:&mut S,mut delete:impl FnMut(&mut S,u32,&mut BTreeMap<u32,Memory>,&mut BTreeSet<u32>)->Result<(),Error>)->Result<(),Error>{\n'+body.replace('s.delete_critical_section(reference,m,d)?','delete(s,reference,m,d)?')+s[b:];p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/audio_crt_windows_shared_fls.rs';s=p.read_text().replace('AtomicU32,Ordering','AtomicU32,AtomicBool,Ordering').replace('struct Inner<S>{index:', 'struct Inner<S>{allocated_index:u32,cleanup_done:AtomicBool,index:').replace('Inner{index:RwLock::new(Some(index))','Inner{allocated_index:index,cleanup_done:AtomicBool::new(false),index:RwLock::new(Some(index))')
s+=r'''
/// Only the original lock-retirement dependency is needed after OS slot closure.
pub trait LockCleanup{fn delete_critical_section(&mut self,reference:u32,m:&mut std::collections::BTreeMap<u32,crate::audio_plugin_factory::Memory>,dead:&mut BTreeSet<u32>)->Result<(),crate::audio_bus_bank::Error>;}
impl<S:Services+LockCleanup+Send+'static> SharedSlot<S>{
 /// Finish original CA9341 cleanup in callback-safe phases. The canonical state
 /// lock is released during FlsFree, then original CB027B deletion resumes.
 pub fn shutdown_crt(&self,context:&SharedContext<S>)->Result<(),Failure>{
  let mut guard=self.inner.index.try_write().map_err(|_|Failure::SlotClosing)?;
  if self.inner.cleanup_done.load(Ordering::Acquire){return match self.inner.report.failure(){Some(e)=>Err(e),None=>Ok(())};}
  context.with(|c|{let index=crate::audio_path_source_virtual_cleanup::get(&c.memory,&c.dead,0x12230cc,4).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?;if index!=self.inner.allocated_index{return Err(Failure::InvalidContext("CRT cleanup global slot ownership mismatch".into()));}Ok(())})??;
  if let Some(index)=*guard{if unsafe{FlsFree(index)}==0{return Err(Failure::Windows{operation:"FlsFree",code:unsafe{GetLastError()}});}*guard=None;}
  context.with(|c|{
   crate::audio_path_source_virtual_cleanup::put(&mut c.memory,&c.dead,0x12230cc,4,u32::MAX).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?;
   // Failed destructor may still own locks; retain them instead of unsafe deletion.
   if let Some(e)=self.inner.report.failure(){return Err(e);}
   crate::audio_crt_thread_system_startup::cleanup_lock_table(&mut c.memory,&mut c.dead,&mut c.services,|s,r,m,d|s.delete_critical_section(r,m,d)).map_err(|e|Failure::Destructor(format!("{e:?}")))
  })??;
  self.inner.cleanup_done.store(true,Ordering::Release);Ok(())
 }
}
''';p.write_text(s,encoding='utf-8');(r/'tools/implement_audio_windows_critical_sections.py').write_text(Path(__file__).read_text(encoding='utf-8-sig'),encoding='utf-8');print('production OS critical sections and callback-safe source lock retirement implemented')
