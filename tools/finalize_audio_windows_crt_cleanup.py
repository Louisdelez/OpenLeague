from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_crt_windows_shared_fls.rs';s=p.read_text().replace('Arc,Mutex,RwLock','Arc,Weak,Mutex,RwLock').replace('struct Inner<S>{allocated_index:','struct Inner<S>{context:Mutex<Option<Weak<SharedContext<S>>>>,allocated_index:').replace('Inner{allocated_index:index','Inner{context:Mutex::new(None),allocated_index:index')
s=s.replace(' pub fn bind_current(&self,context:Arc<SharedContext<S>>,record:u32)->Result<(),Failure>{',' pub fn bind_current(&self,context:Arc<SharedContext<S>>,record:u32)->Result<(),Failure>{\n  self.claim_context(&context)?;')
s=s.replace(' pub fn publish_index(&self,context:&SharedContext<S>)->Result<(),Failure>{',' pub fn publish_index(&self,context:&Arc<SharedContext<S>>)->Result<(),Failure>{\n  self.claim_context(context)?;')
s=s.replace(' pub fn get_or_create_current(&self,context:Arc<SharedContext<S>>,dispatch:ValueDispatch)->Result<u32,Failure>{',' pub fn get_or_create_current(&self,context:Arc<SharedContext<S>>,dispatch:ValueDispatch)->Result<u32,Failure>{\n  self.claim_context(&context)?;')
s=s.replace(' pub fn shutdown_crt(&self,context:&SharedContext<S>)->Result<(),Failure>{',' pub fn shutdown_crt(&self,context:&Arc<SharedContext<S>>)->Result<(),Failure>{\n  self.claim_context(context)?;')
s=s.replace('if index!=self.inner.allocated_index{return Err(Failure::InvalidContext("CRT cleanup global slot ownership mismatch".into()));}','if index!=self.inner.allocated_index&&!(index==u32::MAX&&self.inner.report.failure().is_some()){return Err(Failure::InvalidContext("CRT cleanup global slot ownership mismatch".into()));}')
s=s.replace('  context.with(|c|{\n   crate::audio_path_source_virtual_cleanup::put','  let result=context.with(|c|{\n   crate::audio_path_source_virtual_cleanup::put').replace('  })??;\n  self.inner.cleanup_done.store','  }).and_then(|v|v);\n  if let Err(e)=result{self.inner.report.fail(e.clone());return Err(e);}\n  self.inner.cleanup_done.store')
s+=r'''
impl<S:Services+Send+'static> SharedSlot<S>{
 fn claim_context(&self,context:&Arc<SharedContext<S>>)->Result<(),Failure>{
  let mut assigned=self.inner.context.lock().map_err(|_|Failure::StatePoisoned)?;
  if let Some(old)=&*assigned{match old.upgrade(){Some(old)if Arc::ptr_eq(&old,context)=>Ok(()),_=>Err(Failure::InvalidContext("one global CRT FLS slot must use one canonical context".into()))}}else{*assigned=Some(Arc::downgrade(context));Ok(())}
 }
}
''';p.write_text(s,encoding='utf-8')
# Update standalone probe scaffolding only; production sources are linked unchanged.
mods=['audio_crt_windows_dispatch_resolver','audio_crt_global_dispatch_initialization','audio_crt_static_lock_startup','audio_crt_tls_slot_wrappers','audio_crt_thread_system_startup']
for name in ['probe_windows_shared_fls_component.py','probe_windows_shared_fls_native_pair.py','probe_windows_shared_fls_getter.py']:
 p=r/'tools'/name;s=p.read_text();needle="probe=out/'probe.rs';";assert needle in s
 addition="\nfor module in "+repr(mods)+":\n s+='\\n#[path=\"E:/OpenLeague/crates/core/src/'+module+'.rs\"] mod '+module+';\\n'\n"
 s=s.replace(needle,addition+needle,1);p.write_text(s,encoding='utf-8')
(r/'tools/finalize_audio_windows_crt_cleanup.py').write_text(Path(__file__).read_text(encoding='utf-8-sig'),encoding='utf-8');print('global slot context identity and sticky cleanup failure tracing enforced')
