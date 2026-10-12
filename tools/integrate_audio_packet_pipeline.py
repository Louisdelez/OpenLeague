from pathlib import Path
r=Path('E:/OpenLeague');b=r/'crates/core/src'
def append(name,text):
 p=b/(name+'.rs');p.write_text(p.read_text(encoding='utf-8')+'\n'+text,encoding='utf-8')
append('audio_crt_worker_packet','''
/// Injectable syscall boundary; the source producer still performs all packet writes.
pub struct Creator<'a,W,F>{pub windows:&'a mut W,pub spawn:F}
impl<W:crate::audio_global_float_default_power::Windows,F> crate::audio_global_float_default_power::Windows for Creator<'_,W,F>{
 fn get_last_error(&mut self,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.windows.get_last_error(m,d)}
 fn set_last_error(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.windows.set_last_error(v,m,d)}
 fn tls_get_value(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.windows.tls_get_value(v,m,d)}
 fn tls_set_value(&mut self,i:u32,v:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<bool,Error>{self.windows.tls_set_value(i,v,m,d)}
 fn calloc_thread(&mut self,n:u32,z:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{self.windows.calloc_thread(n,z,m,d)}
 fn free_thread(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.windows.free_thread(r,m,d)}
 fn current_thread_id(&mut self,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.windows.current_thread_id(m,d)}
 fn thread_lock(&mut self,r:u32,e:bool,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.windows.thread_lock(r,e,m,d)}
}
impl<W:crate::audio_global_float_default_power::Windows,F:FnMut(ThreadRequest,&mut W,&mut BTreeMap<u32,Memory>,&mut BTreeSet<u32>)->Result<u32,Error>> Services for Creator<'_,W,F>{
 fn create_worker_thread(&mut self,r:ThreadRequest,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{(self.spawn)(r,self.windows,m,d)}
}
''')
append('audio_crt_windows_shared_fls','''
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
''')
append('audio_crt_windows_root_startup','''
impl<S:Services> Startup<S>{
 pub fn create_worker_packet<F:FnMut(crate::audio_crt_worker_packet::ThreadRequest,&mut S,&mut std::collections::BTreeMap<u32,crate::audio_plugin_factory::Memory>,&mut std::collections::BTreeSet<u32>)->Result<u32,Error>>(&self,request:crate::audio_crt_worker_packet::Request,spawn:F)->Result<u32,Failure>{self.slot.as_ref().ok_or(Failure::Closed)?.create_worker_packet(self.context.clone(),self.dispatch.ok_or(Failure::Closed)?,request,spawn)}
}
impl<S:Services+crate::audio_crt_worker_com_startup::Services> Startup<S>{
 pub fn initialize_worker_packet(&self,incoming:u32)->Result<crate::audio_crt_worker_entry::Entry,Failure>{self.slot.as_ref().ok_or(Failure::Closed)?.initialize_worker_packet(self.context.clone(),self.dispatch.ok_or(Failure::Closed)?,incoming)}
}
''')
(r/'tools/integrate_audio_packet_pipeline.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Integrated source producer and entry/COM into guarded root/FLS pipeline')
