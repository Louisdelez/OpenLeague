from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_crt_windows_shared_fls.rs';s=p.read_text();s+=r'''
/// Canonical decoded FLS function references supplied by the verified resolver.
/// They identify dispatch in the 32-bit source image; they are not host pointers.
#[derive(Clone,Copy)]pub struct ValueDispatch{pub get:u32,pub set:u32}
struct CurrentProvider<'a,S>{services:&'a mut S,context:Arc<SharedContext<S>>,bound:&'a mut BTreeSet<u32>,report:Arc<Report>,index:u32,dispatch:ValueDispatch}
impl<S:Services+Send+'static> crate::audio_crt_tls_value_wrappers::Services for CurrentProvider<'_,S>{
 fn get_value(&mut self,function:u32,index:u32,_:&mut std::collections::BTreeMap<u32,crate::audio_plugin_factory::Memory>,_:&mut BTreeSet<u32>)->Result<u32,crate::audio_bus_bank::Error>{
  if function==0||function!=self.dispatch.get||index!=self.index{return Err(crate::audio_bus_bank::Error::Backend("shared FLS getter dispatch/index mismatch"));}
  let data=unsafe{FlsGetValue(index)};Ok(if data.is_null(){0}else{unsafe{(*data.cast::<Data<S>>()).record}})
 }
 fn set_value(&mut self,function:u32,index:u32,record:u32,m:&mut std::collections::BTreeMap<u32,crate::audio_plugin_factory::Memory>,d:&mut BTreeSet<u32>)->Result<u32,crate::audio_bus_bank::Error>{
  use crate::audio_bus_bank::Error;
  if function==0||function!=self.dispatch.set||index!=self.index{return Err(Error::Backend("shared FLS setter dispatch/index mismatch"));}
  let saved=unsafe{GetLastError()};let old=unsafe{FlsGetValue(index)};unsafe{SetLastError(saved)};
  let old_record=if old.is_null(){0}else{unsafe{(*old.cast::<Data<S>>()).record}};
  if record!=0{crate::audio_path_source_virtual_cleanup::live(m,d,record,0x3bc)?;if record!=old_record&&self.bound.contains(&record){return Err(Error::Backend("CRT record already bound to another thread"));}}
  let next=if record==0{std::ptr::null_mut()}else{Box::into_raw(Box::new(Data{context:self.context.clone(),record,report:self.report.clone()})).cast::<c_void>()};
  let result=unsafe{FlsSetValue(index,next)}as u32;
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
 pub fn publish_index(&self,context:&SharedContext<S>)->Result<(),Failure>{
  let guard=self.inner.index.try_read().map_err(|_|Failure::SlotClosing)?;let index=guard.ok_or(Failure::Closed)?;
  context.with(|c|crate::audio_path_source_virtual_cleanup::put(&mut c.memory,&c.dead,0x12230cc,4,index).map_err(|e|Failure::InvalidContext(format!("{e:?}"))))?
 }
 /// Execute the original CA91A9 getter/CA9218 constructor with real encoded FLS values.
 /// One state lock covers construction and binding without recursively acquiring it.
 pub fn get_or_create_current(&self,context:Arc<SharedContext<S>>,dispatch:ValueDispatch)->Result<u32,Failure>{
  let guard=self.inner.index.try_read().map_err(|_|Failure::SlotClosing)?;let index=guard.ok_or(Failure::Closed)?;
  context.access(|state|{
   let Context{memory,dead,services}=&mut state.context;
   if crate::audio_path_source_virtual_cleanup::get(memory,dead,0x12230cc,4).map_err(|e|Failure::InvalidContext(format!("{e:?}")))?!=index{return Err(Failure::InvalidContext("original CRT global slot index not published".into()));}
   let mut provider=CurrentProvider{services,context:context.clone(),bound:&mut state.bound,report:self.inner.report.clone(),index,dispatch};
   crate::audio_crt_thread_context::get_context(memory,dead,&mut provider).map_err(|e|Failure::InvalidContext(format!("{e:?}")))
  })?
 }
}
''';p.write_text(s,encoding='utf-8');(r/'tools/implement_audio_windows_shared_fls_getter.py').write_text(Path(__file__).read_text(encoding='utf-8-sig'),encoding='utf-8')
print('original getter/constructor connected to actual shared FLS')
