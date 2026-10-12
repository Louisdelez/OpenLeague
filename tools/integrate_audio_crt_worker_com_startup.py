from pathlib import Path
r=Path('E:/OpenLeague/crates/core/src')
native='''
impl NativeGlobal{
 pub fn package_query(&self,reference:u32,initial_length:u32)->Result<crate::audio_crt_worker_com_startup::PackageQuery,Failure>{
  let module=match self.references.get(&reference){Some(Reference::Procedure{module,..})=>*module,Some(_)=>return Err(Failure::WrongKind),None=>return Err(Failure::UnknownReference(reference))};match self.references.get(&module){Some(Reference::Module{name,..})if name.eq_ignore_ascii_case("kernel32.dll")=>{},_=>return Err(Failure::InitializationOwnership)}
  let pointer=self.export_pointer(reference,"GetCurrentPackageId")?;let function:unsafe extern "system" fn(*mut u32,*mut u8)->i32=unsafe{std::mem::transmute(pointer)};let mut length=initial_length;let result=unsafe{function(&mut length,std::ptr::null_mut())};let _error=NativeError(unsafe{GetLastError()});Ok(crate::audio_crt_worker_com_startup::PackageQuery{result:result as u32,length})
 }
}
impl crate::audio_crt_worker_com_startup::Services for NativeGlobal{
 fn current_package_id(&mut self,r:u32,l:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<crate::audio_crt_worker_com_startup::PackageQuery,Error>{self.package_query(r,l).map_err(|_|Error::Backend("qualified package query failed"))}
 fn invoke_ro_initialize(&mut self,r:u32,k:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.ro_initialize(r,k).map_err(|_|Error::Backend("owned COM initialization failed"))}
}
'''
p=r/'audio_crt_windows_global_services.rs';p.write_text(p.read_text(encoding='utf-8-sig')+native,encoding='utf-8')
forward='''
impl<S:crate::audio_crt_worker_com_startup::Services> crate::audio_crt_worker_com_startup::Services for Provider<S>{
 fn current_package_id(&mut self,r:u32,l:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<crate::audio_crt_worker_com_startup::PackageQuery,Error>{self.inner.current_package_id(r,l,m,d)}
 fn invoke_ro_initialize(&mut self,r:u32,k:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.invoke_ro_initialize(r,k,m,d)}
}
'''
for name in ['audio_crt_windows_process_heap.rs','audio_crt_windows_critical_sections.rs']:
 p=r/name;p.write_text(p.read_text()+forward,encoding='utf-8')
provider=forward.replace(' for Provider<S>',' for CurrentProvider<\'_,S>').replace('S:crate::audio_crt_worker_com_startup::Services','S:Services+crate::audio_crt_worker_com_startup::Services+Send+\'static').replace('self.inner.','self.services.')
shared=provider+'''
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
'''
p=r/'audio_crt_windows_shared_fls.rs';p.write_text(p.read_text()+shared,encoding='utf-8')
p=r/'audio_crt_windows_root_startup.rs';p.write_text(p.read_text()+'''
impl<S:Services+crate::audio_crt_worker_com_startup::Services> Startup<S>{pub fn initialize_worker_com(&self)->Result<u32,Failure>{self.slot.as_ref().ok_or(Failure::Closed)?.initialize_worker_com(self.context.clone(),self.dispatch.ok_or(Failure::Closed)?)} }
''',encoding='utf-8')
Path('E:/OpenLeague/tools/integrate_audio_crt_worker_com_startup.py').write_text(Path(__file__).read_text(),encoding='utf-8');print('Actual named package/COM ABIs and atomic worker constructor/flag stage integrated')
