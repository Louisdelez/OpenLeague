from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_crt_heap.rs';s=p.read_text();s+=r'''
/// Whole original CABB83 process-heap bootstrap.
pub trait Bootstrap{fn process_heap(&mut self)->Result<u32,Error>;}
pub fn initialize(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,s:&mut impl Bootstrap)->Result<u32,Error>{let handle=s.process_heap()?;put(m,d,0x14ae87c,4,handle)?;Ok(u32::from(handle!=0))}
#[cfg(test)]mod bootstrap_tests{
 use super::*;
 struct Api(u32);impl Bootstrap for Api{fn process_heap(&mut self)->Result<u32,Error>{Ok(self.0)}}
 #[test]fn audio_crt_process_heap_initialize_matches12_original_published_null_nonnull_handles_and_boolean_results(){let p:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_process_heap_preparation.json")).unwrap();assert_eq!(p["case_count"],12);for row in p["cases"].as_array().unwrap(){let mut m=BTreeMap::from([(0x14ae87c,Memory{reference:0x14ae87c,raw:(row["before"].as_u64().unwrap()as u32).to_le_bytes().to_vec()})]);let d=BTreeSet::new();let result=initialize(&mut m,&d,&mut Api(row["handle"].as_u64().unwrap()as u32)).unwrap();assert_eq!(result as u64,row["result"].as_u64().unwrap());assert_eq!(get(&m,&d,0x14ae87c,4).unwrap()as u64,row["after"].as_u64().unwrap());}}
}
''';p.write_text(s,encoding='utf-8')
source=r'''
//! Owned real process-heap blocks backing the canonical CRT memory adapter.
//! Host handles/pointers remain full-width; logical32-bit references are explicit.
use std::{collections::{BTreeMap,BTreeSet},ffi::c_void,sync::{Arc,Mutex}};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_global_float_default_power::Windows};
#[link(name="kernel32")]unsafe extern "system"{fn GetProcessHeap()->*mut c_void;fn HeapAlloc(h:*mut c_void,flags:u32,size:usize)->*mut c_void;fn HeapFree(h:*mut c_void,flags:u32,p:*mut c_void)->i32;fn GetLastError()->u32;fn Sleep(milliseconds:u32);}
#[derive(Debug,Clone,PartialEq,Eq)]pub enum Failure{Uninitialized,InvalidReference,UnsupportedFlags,AddressSpace,UnknownReference(u32),WrongSize,MirrorAllocation,Windows{operation:&'static str,code:u32}}
#[derive(Default)]pub struct Report{failures:Mutex<Vec<Failure>>}
impl Report{fn record(&self,e:Failure){self.failures.lock().unwrap_or_else(|p|p.into_inner()).push(e);}pub fn failures(&self)->Vec<Failure>{self.failures.lock().unwrap_or_else(|p|p.into_inner()).clone()}}
struct Block{pointer:Option<usize>,heap:usize,size:usize,report:Arc<Report>}
impl Block{
 fn new(heap:usize,size:usize,report:Arc<Report>)->Option<Self>{let pointer=unsafe{HeapAlloc(heap as*mut c_void,8,size)};if pointer.is_null(){None}else{Some(Self{pointer:Some(pointer as usize),heap,size,report})}}
 // Only zero-initialized HeapAlloc blocks are exposed as byte slices.
 fn bytes(&self)->&[u8]{unsafe{std::slice::from_raw_parts(self.pointer.unwrap()as*const u8,self.size)}}
 fn write(&mut self,raw:&[u8])->Result<(),Failure>{if raw.len()!=self.size{return Err(Failure::WrongSize);}unsafe{std::ptr::copy_nonoverlapping(raw.as_ptr(),self.pointer.unwrap()as*mut u8,self.size)};Ok(())}
 fn free(&mut self)->Result<(),Failure>{if let Some(pointer)=self.pointer{if unsafe{HeapFree(self.heap as*mut c_void,0,pointer as*mut c_void)}==0{return Err(Failure::Windows{operation:"HeapFree",code:unsafe{GetLastError()}});}self.pointer=None;}Ok(())}
}
impl Drop for Block{fn drop(&mut self){if let Err(e)=self.free(){self.report.record(e);}}}
pub struct Heap{label:u32,host:Option<usize>,next:u32,blocks:BTreeMap<u32,Block>,report:Arc<Report>}
impl Heap{
 pub fn new(label:u32,first_reference:u32)->Result<Self,Failure>{if label==0||first_reference==0||first_reference&15!=0{return Err(Failure::InvalidReference);}Ok(Self{label,host:None,next:first_reference,blocks:BTreeMap::new(),report:Arc::new(Report::default())})}
 pub fn initialize(&mut self,m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>)->Result<u32,Error>{crate::audio_crt_heap::initialize(m,d,self)}
 pub fn report(&self)->Arc<Report>{self.report.clone()}
 pub fn outstanding(&self)->usize{self.blocks.len()}
 fn allocate_block(&self,size:usize)->Result<Option<Block>,Failure>{Ok(Block::new(self.host.ok_or(Failure::Uninitialized)?,size,self.report.clone()))}
 /// Restore a captured canonical allocation into a distinct owned physical block.
 /// This is an explicit restoration step, not original calloc/startup execution.
 pub fn adopt(&mut self,reference:u32,m:&BTreeMap<u32,Memory>)->Result<(),Failure>{if reference==0||self.blocks.contains_key(&reference){return Err(Failure::InvalidReference);}let raw=&m.get(&reference).ok_or(Failure::UnknownReference(reference))?.raw;let mut block=self.allocate_block(raw.len())?.ok_or(Failure::Windows{operation:"HeapAlloc",code:unsafe{GetLastError()}})?;block.write(raw)?;self.blocks.insert(reference,block);Ok(())}
 pub fn allocate(&mut self,heap:u32,flags:u32,size:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Failure>{
  if heap!=self.label{return Err(Failure::InvalidReference);}if flags!=8{return Err(Failure::UnsupportedFlags);}let mut reference=self.next;let span=size.max(1).checked_add(15).ok_or(Failure::AddressSpace)?&!15;
  loop{let end=reference.checked_add(span).ok_or(Failure::AddressSpace)?;let overlap=m.iter().find(|(a,v)|reference<(**a as u64+v.raw.len()as u64).min(u32::MAX as u64)as u32&&**a<end);if let Some((a,v))=overlap{reference=(*a as u64+v.raw.len()as u64+15).try_into().map_err(|_|Failure::AddressSpace)?;reference&=!15;}else{break;}}
  let Some(block)=self.allocate_block(size as usize)?else{return Ok(0);};let mut raw=Vec::new();raw.try_reserve_exact(size as usize).map_err(|_|Failure::MirrorAllocation)?;raw.extend_from_slice(block.bytes());self.next=reference.checked_add(span).ok_or(Failure::AddressSpace)?;m.insert(reference,Memory{reference,raw});d.remove(&reference);self.blocks.insert(reference,block);Ok(reference)
 }
 /// Logical writes are flushed at the native free/read boundary. The canonical
 /// mirror is retained for forensic snapshots after physical retirement.
 pub fn synchronize(&mut self,reference:u32,m:&BTreeMap<u32,Memory>)->Result<(),Failure>{self.blocks.get_mut(&reference).ok_or(Failure::UnknownReference(reference))?.write(&m.get(&reference).ok_or(Failure::UnknownReference(reference))?.raw)}
 pub fn physical_bytes(&self,reference:u32)->Result<&[u8],Failure>{Ok(self.blocks.get(&reference).ok_or(Failure::UnknownReference(reference))?.bytes())}
 pub fn free(&mut self,heap:u32,flags:u32,reference:u32,m:&BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Failure>{if heap!=self.label{return Err(Failure::InvalidReference);}if flags!=0{return Err(Failure::UnsupportedFlags);}self.synchronize(reference,m)?;self.blocks.get_mut(&reference).unwrap().free()?;self.blocks.remove(&reference);d.insert(reference);Ok(1)}
}
impl crate::audio_crt_heap::Bootstrap for Heap{fn process_heap(&mut self)->Result<u32,Error>{let handle=unsafe{GetProcessHeap()};if handle.is_null(){self.host=None;return Ok(0);}if self.host.is_some_and(|old|old!=handle as usize){return Err(Error::Backend("process heap changed while attached"));}self.host=Some(handle as usize);Ok(self.label)}}
pub struct Provider<S>{pub inner:S,pub heap:Heap}
impl<S:crate::audio_crt_heap::Services> crate::audio_crt_heap::Services for Provider<S>{
 fn heap_allocate(&mut self,h:u32,f:u32,z:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.heap.allocate(h,f,z,m,d).map_err(|e|{self.heap.report.record(e);Error::Backend("actual process heap allocation ownership failed")})}
 fn heap_free(&mut self,h:u32,f:u32,r:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{match self.heap.free(h,f,r,m,d){Ok(v)=>Ok(v),Err(e@Failure::Windows{operation:"HeapFree",..})=>{self.heap.report.record(e);Ok(0)},Err(e)=>{self.heap.report.record(e);Err(Error::Backend("actual process heap free ownership failed"))}}}
 fn thread_context(&mut self,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.thread_context(m,d)}
 fn last_error(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(unsafe{GetLastError()})}
 fn sleep(&mut self,ms:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{unsafe{Sleep(ms)};Ok(())}
 fn decode_pointer(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.decode_pointer(v,m,d)}
 fn invoke_handler(&mut self,f:u32,z:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.invoke_handler(f,z,m,d)}
}
impl<S:Windows+crate::audio_crt_heap::Services> Windows for Provider<S>{
 fn get_last_error(&mut self,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.get_last_error(m,d)}
 fn set_last_error(&mut self,v:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.inner.set_last_error(v,m,d)}
 fn tls_get_value(&mut self,i:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.tls_get_value(i,m,d)}
 fn tls_set_value(&mut self,i:u32,v:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<bool,Error>{self.inner.tls_set_value(i,v,m,d)}
 fn calloc_thread(&mut self,n:u32,z:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{let r=crate::audio_crt_heap::calloc(m,d,n,z,self)?;Ok((r!=0).then_some(r))}
 fn free_thread(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{crate::audio_crt_heap::free(m,d,r,self)}
 fn current_thread_id(&mut self,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.inner.current_thread_id(m,d)}
 fn thread_lock(&mut self,r:u32,e:bool,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.inner.thread_lock(r,e,m,d)}
}
impl<S:Windows+crate::audio_crt_heap::Services> crate::audio_crt_thread_destructor::Services for Provider<S>{}
'''
(r/'crates/core/src/audio_crt_windows_process_heap.rs').write_text(source,encoding='utf-8');p=r/'crates/core/src/lib.rs';s=p.read_text();s+='\n#[cfg(windows)]\npub mod audio_crt_windows_process_heap;\n';p.write_text(s,encoding='utf-8');(r/'tools/implement_audio_crt_windows_process_heap.py').write_text(Path(__file__).read_text(encoding='utf-8-sig'),encoding='utf-8');print('process-heap owned blocks, mapped adapter and original CRT allocation provider implemented')
