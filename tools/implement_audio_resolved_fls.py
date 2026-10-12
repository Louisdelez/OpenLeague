from pathlib import Path
r=Path('E:/OpenLeague/crates/core/src')
def edit(name,changes):
 p=r/name;s=p.read_text(encoding='utf-8')
 for a,b in changes:
  assert a in s,(name,a[:100]);s=s.replace(a,b)
 p.write_text(s,encoding='utf-8')
table='''
/// Typed full-width Windows FLS entry points. Construction accepts callable
/// function pointers, never unchecked integers or source-image addresses.
pub type FlsAllocFn=unsafe extern "system" fn(Option<unsafe extern "system" fn(*mut std::ffi::c_void)>)->u32;
pub type FlsFreeFn=unsafe extern "system" fn(u32)->i32;
pub type FlsGetFn=unsafe extern "system" fn(u32)->*mut std::ffi::c_void;
pub type FlsSetFn=unsafe extern "system" fn(u32,*mut std::ffi::c_void)->i32;
#[derive(Clone,Copy)]pub struct FlsFunctions{pub(crate) alloc:FlsAllocFn,pub(crate) free:FlsFreeFn,pub(crate) get:FlsGetFn,pub(crate) set:FlsSetFn}
impl FlsFunctions{pub fn new(alloc:FlsAllocFn,free:FlsFreeFn,get:FlsGetFn,set:FlsSetFn)->Self{Self{alloc,free,get,set}}}
'''
edit('audio_crt_windows_dispatch_resolver.rs',[
 ('pub trait Lookup{fn export_pointer(&self,reference:u32,name:&str)->Result<usize,Error>;}','pub trait Lookup{fn export_pointer(&self,reference:u32,name:&str)->Result<usize,Error>;fn fls_functions(&self,_references:[u32;4])->Result<FlsFunctions,Error>{Err(Error::Backend("qualified typed FLS exports required"))}}\n'+table)])
global_method='''
 fn fls_functions(&self,references:[u32;4])->Result<crate::audio_crt_windows_dispatch_resolver::FlsFunctions,Error>{
  use crate::audio_crt_windows_dispatch_resolver::{FlsFunctions,FlsAllocFn,FlsFreeFn,FlsGetFn,FlsSetFn};
  let mut addresses=[0usize;4];
  for(i,name)in["FlsAlloc","FlsFree","FlsGetValue","FlsSetValue"].iter().enumerate(){addresses[i]=self.export_pointer(references[i],name).map_err(|_|Error::Backend("native typed FLS export identity mismatch"))?;if addresses[i]==0{return Err(Error::Backend("native typed FLS export is missing"));}}
  // Registry entries are populated exclusively by GetProcAddress on a live
  // borrowed Windows module; exact export name/kind checked above. Addresses
  // remain full-width and these signatures match the Windows system ABI.
  Ok(unsafe{FlsFunctions::new(std::mem::transmute::<usize,FlsAllocFn>(addresses[0]),std::mem::transmute::<usize,FlsFreeFn>(addresses[1]),std::mem::transmute::<usize,FlsGetFn>(addresses[2]),std::mem::transmute::<usize,FlsSetFn>(addresses[3]))})
 }
'''
edit('audio_crt_windows_global_services.rs',[
 ('self.export_pointer(reference,name).map_err(|_|Error::Backend("native export identity mismatch"))}}','self.export_pointer(reference,name).map_err(|_|Error::Backend("native export identity mismatch"))}'+global_method+'}')])
for name in ['audio_crt_windows_process_heap.rs','audio_crt_windows_critical_sections.rs']:
 edit(name,[('self.inner.export_pointer(reference,name)}}','self.inner.export_pointer(reference,name)}fn fls_functions(&self,references:[u32;4])->Result<crate::audio_crt_windows_dispatch_resolver::FlsFunctions,Error>{self.inner.fls_functions(references)}}')])
edit('audio_crt_windows_shared_fls.rs',[
 ('struct Inner<S>{retirement:', 'struct Inner<S>{api:crate::audio_crt_windows_dispatch_resolver::FlsFunctions,retirement:'),
 ('Self::new_policy(None)','Self::new_policy(None,Self::linked_api())'),
 ('Self::new_policy(Some(retire))','Self::new_policy(Some(retire),Self::linked_api())'),
 ('fn new_policy(retirement:Option<Retirement<S>>)', 'fn linked_api()->crate::audio_crt_windows_dispatch_resolver::FlsFunctions{crate::audio_crt_windows_dispatch_resolver::FlsFunctions::new(FlsAlloc,FlsFree,FlsGetValue,FlsSetValue)}\n /// Production root uses the exact typed exports from its native resolver.\n pub fn new_resolved(retirement:Option<Retirement<S>>,api:crate::audio_crt_windows_dispatch_resolver::FlsFunctions)->Result<Self,Failure>{Self::new_policy(retirement,api)}\n fn new_policy(retirement:Option<Retirement<S>>,api:crate::audio_crt_windows_dispatch_resolver::FlsFunctions)'),
 ('unsafe{FlsAlloc(Some(callback::<S>))}', 'unsafe{(api.alloc)(Some(callback::<S>))}'),
 ('Inner{retirement,','Inner{api,retirement,'),
 ('unsafe{FlsFree(i)}','unsafe{(self.api.free)(i)}'),
 ('unsafe{FlsFree(index)}','unsafe{(self.inner.api.free)(index)}'),
 ('unsafe{FlsGetValue(index)}','unsafe{(self.inner.api.get)(index)}'),
 ('unsafe{FlsSetValue(index,data.cast())}','unsafe{(self.inner.api.set)(index,data.cast())}'),
 ("struct CurrentProvider<'a,S>{retirement:","struct CurrentProvider<'a,S>{api:crate::audio_crt_windows_dispatch_resolver::FlsFunctions,retirement:"),
 ('CurrentProvider{retirement:self.inner.retirement,','CurrentProvider{api:self.inner.api,retirement:self.inner.retirement,'),
 ('unsafe{FlsSetValue(index,next)}','unsafe{(self.api.set)(index,next)}'),
 ])
# CurrentProvider owns the copied table, not the SharedSlot inner field.
p=r/'audio_crt_windows_shared_fls.rs';s=p.read_text();a=s.index("impl<S:Services+Send+'static> crate::audio_crt_tls_value_wrappers::Services");b=s.index("impl<S:Services+Send+'static> crate::audio_global_float_default_power::Windows",a)
s=s[:a]+s[a:b].replace('(self.inner.api.get)','(self.api.get)')+s[b:];p.write_text(s,encoding='utf-8')
edit('audio_crt_windows_root_startup.rs',[
 ('|retirement|match retirement{Some(retire)=>SharedSlot::new_with_retirement(retire),None=>SharedSlot::new()}','|retirement,api|SharedSlot::new_resolved(retirement,api)'),
 ('impl FnOnce(Option<Retirement<S>>)->Result<SharedSlot<S>,Failure>','impl FnOnce(Option<Retirement<S>>,crate::audio_crt_windows_dispatch_resolver::FlsFunctions)->Result<SharedSlot<S>,Failure>'),
 ('Result<Option<ValueDispatch>,Error>','Result<Option<(ValueDispatch,crate::audio_crt_windows_dispatch_resolver::FlsFunctions)>,Error>'),
 ('Ok(Some(ValueDispatch{get:tokens[2],set:tokens[3]}))','let api=c.services.fls_functions(tokens)?;Ok(Some((ValueDispatch{get:tokens[2],set:tokens[3]},api)))'),
 ('let dispatch=match prepared{Ok(Some(dispatch))=>dispatch','let (dispatch,api)=match prepared{Ok(Some(dispatch))=>dispatch'),
 ('match allocate(retirement){','match allocate(retirement,api){'),
 ('|_|if failure_kind=="slot"','|_,api|if failure_kind=="slot"'),
 ('else{SharedSlot::new()},|_,_,_|Ok(false)','else{SharedSlot::new_resolved(None,api)},|_,_,_|Ok(false)'),
 ('Lookup::export_pointer(&self.inner,r,n)}}','Lookup::export_pointer(&self.inner,r,n)}fn fls_functions(&self,references:[u32;4])->Result<crate::audio_crt_windows_dispatch_resolver::FlsFunctions,Error>{crate::audio_crt_windows_dispatch_resolver::Lookup::fls_functions(&self.inner,references)}}')])
Path('E:/OpenLeague/tools/implement_audio_resolved_fls.py').write_text(Path(__file__).read_text(),encoding='utf-8')
print('Typed resolved FLS exports integrated through root allocation, getter/setter and both cleanup paths')
