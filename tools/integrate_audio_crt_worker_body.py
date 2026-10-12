from pathlib import Path
r=Path('E:/OpenLeague');base=r/'crates/core/src'
def append(name,text):
 p=base/(name+'.rs');p.write_text(p.read_text(encoding='utf-8')+'\n'+text,encoding='utf-8')
p=base/'audio_crt_windows_global_services.rs';s=p.read_text(encoding='utf-8');needle='Encoded{source:u32,pointer:usize}}';assert needle in s;s=s.replace(needle,'Encoded{source:u32,pointer:usize},WorkerCallback{pointer:usize}}')
s+='''
impl NativeGlobal{
 /// Register a host ABI callback without narrowing its address to the PE32 label.
 /// # Safety
 /// Callback code must remain live, not unwind, and accept canonical u32 input.
 /// It must not reenter the shared context guard held by the worker body caller.
 pub unsafe fn register_worker_callback(&mut self,function:unsafe extern "system" fn(u32)->u32)->Result<u32,Failure>{self.register(Reference::WorkerCallback{pointer:function as usize})}
 pub fn invoke_worker_callback(&self,reference:u32,argument:u32)->Result<u32,Failure>{let pointer=match self.references.get(&reference){Some(Reference::WorkerCallback{pointer})=>*pointer,Some(_)=>return Err(Failure::WrongKind),None=>return Err(Failure::UnknownReference(reference))};let callback:unsafe extern "system" fn(u32)->u32=unsafe{std::mem::transmute(pointer)};Ok(unsafe{callback(argument)})}
}
impl crate::audio_crt_worker_body::CallbackServices for NativeGlobal{
 fn worker_callback(&mut self,r:u32,a:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.invoke_worker_callback(r,a).map_err(|_|Error::Backend("registered native worker callback required"))}
}
''';p.write_text(s,encoding='utf-8')
for name in ['audio_crt_windows_process_heap','audio_crt_windows_critical_sections']:
 append(name,'''impl<S:crate::audio_crt_worker_body::CallbackServices> crate::audio_crt_worker_body::CallbackServices for Provider<S>{
 fn worker_callback(&mut self,r:u32,a:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.worker_callback(r,a,m,d)}
}
''')
append('audio_crt_windows_shared_fls','''
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
''')
append('audio_crt_windows_root_startup','''impl<S:Services+crate::audio_crt_worker_exit::ComServices+crate::audio_crt_worker_body::CallbackServices> Startup<S>{
 pub fn prepare_worker_body_exit(&self)->Result<crate::audio_crt_worker_exit::PreparedExit,Failure>{self.slot.as_ref().ok_or(Failure::Closed)?.prepare_worker_body_exit(self.context.clone(),self.dispatch.ok_or(Failure::Closed)?)}
}
''')
(r/'tools/integrate_audio_crt_worker_body.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('Integrated typed full-width callback registry and normal body/exit under root/FLS ownership')
