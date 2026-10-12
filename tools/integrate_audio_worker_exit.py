from pathlib import Path
r=Path('E:/OpenLeague/crates/core/src')
def edit(name,changes):
 p=r/name;s=p.read_text(encoding='utf-8')
 for a,b in changes:assert a in s,(name,a[:80]);s=s.replace(a,b)
 p.write_text(s,encoding='utf-8')
edit('audio_crt_worker_exit.rs',[
 ('pub trait Services:crate::audio_crt_thread_destructor::Services+crate::audio_crt_tls_value_wrappers::Services{','pub trait ComServices{'),
 ('pub fn release_com(', 'pub trait Services:ComServices+crate::audio_crt_thread_destructor::Services+crate::audio_crt_tls_value_wrappers::Services{}\nimpl<S:ComServices+crate::audio_crt_thread_destructor::Services+crate::audio_crt_tls_value_wrappers::Services> Services for S{}\npub fn release_com('),
 ('impl Services for Api{','impl ComServices for Api{')])
edit('audio_crt_windows_global_services.rs',[
 ('fn Sleep(milliseconds:u32);','fn Sleep(milliseconds:u32);fn LoadLibraryExW(name:*const u16,file:*mut c_void,flags:u32)->*mut c_void;fn FreeLibrary(module:*mut c_void)->i32;'),
 ('NameMismatch,AddressSpace,CodecMismatch}','NameMismatch,AddressSpace,CodecMismatch,InvalidFlags,InitializationOwnership}'),
 ('events:Option<Vec<Event>>}','events:Option<Vec<Event>>,owned_modules:Vec<usize>,ro_counts:BTreeMap<u32,u32>}'),
 ('references:BTreeMap::new(),events:None}','references:BTreeMap::new(),events:None,owned_modules:vec![],ro_counts:BTreeMap::new()}')])
native='''
impl NativeGlobal{
 pub fn loaded_module_count(&self)->usize{self.owned_modules.len()}
 pub fn pending_ro_initializations(&self)->usize{self.ro_counts.values().map(|v|*v as usize).sum()}
 pub fn load_combase(&mut self,name:&str,flags:u32)->Result<u32,Failure>{
  if !name.eq_ignore_ascii_case("combase.dll"){return Err(Failure::InvalidName);}if flags!=0x800{return Err(Failure::InvalidFlags);}
  let wide=name.encode_utf16().chain(Some(0)).collect::<Vec<_>>();let pointer=unsafe{LoadLibraryExW(wide.as_ptr(),std::ptr::null_mut(),flags)}as usize;let _error=NativeError(unsafe{GetLastError()});
  if pointer==0{return Ok(0);}self.owned_modules.push(pointer);self.register(Reference::Module{name:name.into(),pointer})
 }
 fn ro_export(&self,reference:u32,name:&str)->Result<usize,Failure>{
  let module=match self.references.get(&reference){Some(Reference::Procedure{module,..})=>*module,Some(_)=>return Err(Failure::WrongKind),None=>return Err(Failure::UnknownReference(reference))};
  match self.references.get(&module){Some(Reference::Module{name:module_name,pointer})if module_name.eq_ignore_ascii_case("combase.dll")&&self.owned_modules.contains(pointer)=>{},_=>return Err(Failure::InitializationOwnership)}
  self.export_pointer(reference,name)
 }
 /// Every nonnegative HRESULT creates an adapter-owned obligation on this
 /// exact OS thread; original strict-zero flag interpretation is a separate port.
 pub fn ro_initialize(&mut self,reference:u32,kind:u32)->Result<u32,Failure>{
  if kind>1{return Err(Failure::InvalidFlags);}let pointer=self.ro_export(reference,"RoInitialize")?;
  let thread=unsafe{GetCurrentThreadId()};let count=self.ro_counts.get(&thread).copied().unwrap_or(0);if count==u32::MAX{return Err(Failure::AddressSpace);}
  let function:unsafe extern "system" fn(u32)->i32=unsafe{std::mem::transmute(pointer)};let result=unsafe{function(kind)};let _error=NativeError(unsafe{GetLastError()});if result>=0{self.ro_counts.insert(thread,count+1);}Ok(result as u32)
 }
 pub fn ro_uninitialize(&mut self,reference:u32)->Result<(),Failure>{
  let pointer=self.ro_export(reference,"RoUninitialize")?;let thread=unsafe{GetCurrentThreadId()};let count=self.ro_counts.get(&thread).copied().unwrap_or(0);if count==0{return Err(Failure::InitializationOwnership);}
  let function:unsafe extern "system" fn()=unsafe{std::mem::transmute(pointer)};unsafe{function()};let _error=NativeError(unsafe{GetLastError()});if count==1{self.ro_counts.remove(&thread);}else{self.ro_counts.insert(thread,count-1);}Ok(())
 }
}
impl Drop for NativeGlobal{fn drop(&mut self){
 // Never uninitialize another thread's apartment. Outstanding obligations
 // retain their modules; callers must inspect/resolve them before adapter drop.
 if !self.ro_counts.is_empty(){return;}let saved=unsafe{GetLastError()};for pointer in self.owned_modules.drain(..).rev(){unsafe{FreeLibrary(pointer as*mut c_void)};}unsafe{SetLastError(saved)};
}}
impl crate::audio_crt_worker_exit::ComServices for NativeGlobal{
 fn load_library(&mut self,n:&str,f:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.load_combase(n,f).map_err(|_|Error::Backend("owned combase module lookup failed"))}
 fn procedure(&mut self,r:u32,n:&str,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.procedure(r,n).map_err(|_|Error::Backend("COM export lookup failed"))}
 fn encode(&mut self,r:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.encode(r).map_err(|_|Error::Backend("COM pointer encode failed"))}
 fn decode(&mut self,r:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{NativeGlobal::decode(self,r).map_err(|_|Error::Backend("COM pointer decode failed"))}
 fn invoke_ro_uninitialize(&mut self,r:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.ro_uninitialize(r).map_err(|_|Error::Backend("owned current-thread COM release failed"))}
}
'''
p=r/'audio_crt_windows_global_services.rs';p.write_text(p.read_text()+native,encoding='utf-8')
forward='''
impl<S:crate::audio_crt_worker_exit::ComServices> crate::audio_crt_worker_exit::ComServices for Provider<S>{
 fn load_library(&mut self,n:&str,f:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.load_library(n,f,m,d)}
 fn procedure(&mut self,r:u32,n:&str,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.procedure(r,n,m,d)}
 fn encode(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.encode(r,m,d)}
 fn decode(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.decode(r,m,d)}
 fn invoke_ro_uninitialize(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.inner.invoke_ro_uninitialize(r,m,d)}
}
'''
for n in ['audio_crt_windows_process_heap.rs','audio_crt_windows_critical_sections.rs']:
 p=r/n;p.write_text(p.read_text()+forward,encoding='utf-8')
provider=forward.replace(' for Provider<S>',' for CurrentProvider<\'_,S>').replace('S:crate::audio_crt_worker_exit::ComServices','S:Services+crate::audio_crt_worker_exit::ComServices+Send+\'static').replace('self.inner.','self.services.')
shared='''
impl<S:Services+Send+'static> crate::audio_crt_thread_destructor::Services for CurrentProvider<'_,S>{}
'''+provider+'''
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
'''
# Shared file uses qualified std types elsewhere; import short names for the adapter.
p=r/'audio_crt_windows_shared_fls.rs';p.write_text(p.read_text()+'\nuse std::collections::BTreeMap;use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};\n'+shared,encoding='utf-8')
p=r/'audio_crt_windows_root_startup.rs';p.write_text(p.read_text()+'''
impl<S:Services+crate::audio_crt_worker_exit::ComServices> Startup<S>{
 pub fn prepare_worker_exit(&self,code:u32)->Result<crate::audio_crt_worker_exit::PreparedExit,Failure>{self.slot.as_ref().ok_or(Failure::Closed)?.prepare_worker_exit(self.context.clone(),self.dispatch.ok_or(Failure::Closed)?,code)}
}
''',encoding='utf-8')
Path('E:/OpenLeague/tools/integrate_audio_worker_exit.py').write_text(Path(__file__).read_text(),encoding='utf-8');print('Actual owned COM services and original explicit worker exit integrated with shared FLS/root')

