
//! Owned real process-heap blocks backing the canonical CRT memory adapter.
//! Host handles/pointers remain full-width; logical32-bit references are explicit.
use std::{collections::{BTreeMap,BTreeSet},ffi::c_void,sync::{Arc,Mutex,atomic::{AtomicU32,Ordering}}};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_global_float_default_power::Windows};
#[link(name="kernel32")]unsafe extern "system"{fn GetProcessHeap()->*mut c_void;fn HeapAlloc(h:*mut c_void,flags:u32,size:usize)->*mut c_void;fn HeapFree(h:*mut c_void,flags:u32,p:*mut c_void)->i32;fn GetLastError()->u32;fn Sleep(milliseconds:u32);}
#[derive(Debug,Clone,PartialEq,Eq)]pub enum Failure{Uninitialized,InvalidReference,UnsupportedFlags,AddressSpace,UnknownReference(u32),WrongSize,MirrorAllocation,RetirementConflict(u32),Windows{operation:&'static str,code:u32}}
#[derive(Default)]pub struct Report{failures:Mutex<Vec<Failure>>,allocations:AtomicU32,frees:AtomicU32}
impl Report{fn record(&self,e:Failure){self.failures.lock().unwrap_or_else(|p|p.into_inner()).push(e);}pub fn allocations(&self)->u32{self.allocations.load(Ordering::Acquire)}pub fn frees(&self)->u32{self.frees.load(Ordering::Acquire)}pub fn failures(&self)->Vec<Failure>{self.failures.lock().unwrap_or_else(|p|p.into_inner()).clone()}}
struct Block{pointer:Option<usize>,heap:usize,size:usize,report:Arc<Report>}
impl Block{
 fn new(heap:usize,size:usize,report:Arc<Report>)->Option<Self>{let pointer=unsafe{HeapAlloc(heap as*mut c_void,8,size)};if pointer.is_null(){None}else{{report.allocations.fetch_add(1,Ordering::AcqRel);Some(Self{pointer:Some(pointer as usize),heap,size,report})}}}
 // Only zero-initialized HeapAlloc blocks are exposed as byte slices.
 fn bytes(&self)->&[u8]{unsafe{std::slice::from_raw_parts(self.pointer.unwrap()as*const u8,self.size)}}
 fn write(&mut self,raw:&[u8])->Result<(),Failure>{if raw.len()!=self.size{return Err(Failure::WrongSize);}unsafe{std::ptr::copy_nonoverlapping(raw.as_ptr(),self.pointer.unwrap()as*mut u8,self.size)};Ok(())}
 fn free(&mut self)->Result<(),Failure>{if let Some(pointer)=self.pointer{if unsafe{HeapFree(self.heap as*mut c_void,0,pointer as*mut c_void)}==0{return Err(Failure::Windows{operation:"HeapFree",code:unsafe{GetLastError()}});}self.pointer=None;self.report.frees.fetch_add(1,Ordering::AcqRel);}Ok(())}
}
impl Drop for Block{fn drop(&mut self){if let Err(e)=self.free(){self.report.record(e);}}}
pub struct Heap{label:u32,host:Option<usize>,next:u32,blocks:BTreeMap<u32,Block>,retired:BTreeMap<u32,usize>,report:Arc<Report>}
impl Heap{
 pub fn new(label:u32,first_reference:u32)->Result<Self,Failure>{if label==0||first_reference==0||first_reference&15!=0{return Err(Failure::InvalidReference);}Ok(Self{label,host:None,next:first_reference,blocks:BTreeMap::new(),retired:BTreeMap::new(),report:Arc::new(Report::default())})}
 pub fn initialize(&mut self,m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>)->Result<u32,Error>{crate::audio_crt_heap::initialize(m,d,self)}
 pub fn report(&self)->Arc<Report>{self.report.clone()}
 pub fn outstanding(&self)->usize{self.blocks.len()}
 /// Call only after the original callback and any diagnostic snapshot readers
 /// have finished. The canonical map must not replace an owned allocation
 /// between allocation, free and retirement. This operation owns only the
 /// entries freed by this heap; unrelated dead memory remains untouched.
 pub fn retire_mirrors(&mut self,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<usize,Failure>{
  // Preflight the complete batch before changing either memory or tombstones.
  for (&reference,&size) in &self.retired{
   let v=m.get(&reference).ok_or(Failure::RetirementConflict(reference))?;
   if self.blocks.contains_key(&reference)||!d.contains(&reference)||v.reference!=reference||v.raw.len()!=size{return Err(Failure::RetirementConflict(reference));}
   let end=reference as u64+size.max(1)as u64;
   if m.iter().any(|(&a,v)|a!=reference&&(a as u64)<end&&(reference as u64)<a as u64+v.raw.len().max(1)as u64){return Err(Failure::RetirementConflict(reference));}
  }
  let count=self.retired.len();for &reference in self.retired.keys(){m.remove(&reference);d.remove(&reference);}self.retired.clear();Ok(count)
 }
 pub fn retained_mirrors(&self)->usize{self.retired.len()}

 fn allocate_block(&self,size:usize)->Result<Option<Block>,Failure>{Ok(Block::new(self.host.ok_or(Failure::Uninitialized)?,size,self.report.clone()))}
 /// Restore a captured canonical allocation into a distinct owned physical block.
 /// This is an explicit restoration step, not original calloc/startup execution.
 pub fn adopt(&mut self,reference:u32,m:&BTreeMap<u32,Memory>)->Result<(),Failure>{if reference==0||self.blocks.contains_key(&reference)||self.retired.contains_key(&reference){return Err(Failure::InvalidReference);}let raw=&m.get(&reference).ok_or(Failure::UnknownReference(reference))?.raw;
 let end=reference as u64+raw.len().max(1)as u64;if end>u32::MAX as u64{return Err(Failure::AddressSpace);}
 if self.blocks.iter().map(|(&a,b)|(a,b.size)).chain(self.retired.iter().map(|(&a,&size)|(a,size))).any(|(a,size)|(a as u64)<end&&(reference as u64)<a as u64+size.max(1)as u64){return Err(Failure::InvalidReference);}
 let mut block=self.allocate_block(raw.len())?.ok_or(Failure::Windows{operation:"HeapAlloc",code:unsafe{GetLastError()}})?;block.write(raw)?;self.blocks.insert(reference,block);Ok(())}
 pub fn allocate(&mut self,heap:u32,flags:u32,size:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Failure>{
  if heap!=self.label{return Err(Failure::InvalidReference);}if flags!=8{return Err(Failure::UnsupportedFlags);}let mut reference=self.next;let span=size.max(1).checked_add(15).ok_or(Failure::AddressSpace)?&!15;
  loop{let end=reference.checked_add(span).ok_or(Failure::AddressSpace)?;
   let occupied=m.iter().map(|(&a,v)|(a,v.raw.len())).chain(self.blocks.iter().map(|(&a,b)|(a,b.size))).chain(self.retired.iter().map(|(&a,&size)|(a,size)));
   if let Some((a,size))=occupied.filter(|(a,size)|(reference as u64)<*a as u64+(*size).max(1)as u64&&(*a as u64)<end as u64).next(){reference=(a as u64+size.max(1)as u64+15).try_into().map_err(|_|Failure::AddressSpace)?;reference&=!15;}else{break;}
  }
  let Some(block)=self.allocate_block(size as usize)?else{return Ok(0);};let mut raw=Vec::new();raw.try_reserve_exact(size as usize).map_err(|_|Failure::MirrorAllocation)?;raw.extend_from_slice(block.bytes());self.next=reference.checked_add(span).ok_or(Failure::AddressSpace)?;m.insert(reference,Memory{reference,raw});d.remove(&reference);self.blocks.insert(reference,block);Ok(reference)
 }
 /// Logical writes are flushed at the native free/read boundary. The canonical
 /// mirror is retained for forensic snapshots after physical retirement.
 pub fn synchronize(&mut self,reference:u32,m:&BTreeMap<u32,Memory>)->Result<(),Failure>{self.blocks.get_mut(&reference).ok_or(Failure::UnknownReference(reference))?.write(&m.get(&reference).ok_or(Failure::UnknownReference(reference))?.raw)}
 pub fn physical_bytes(&self,reference:u32)->Result<&[u8],Failure>{Ok(self.blocks.get(&reference).ok_or(Failure::UnknownReference(reference))?.bytes())}
 pub fn free(&mut self,heap:u32,flags:u32,reference:u32,m:&BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Failure>{if heap!=self.label{return Err(Failure::InvalidReference);}if flags!=0{return Err(Failure::UnsupportedFlags);}self.synchronize(reference,m)?;self.blocks.get_mut(&reference).unwrap().free()?;let size=self.blocks.remove(&reference).unwrap().size;self.retired.insert(reference,size);d.insert(reference);Ok(1)}
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

#[cfg(test)]mod tests{
 use super::*;use serde_json::Value;
 #[link(name="kernel32")]unsafe extern "system"{fn SetLastError(value:u32);fn GetCurrentThreadId()->u32;}
 struct Control;
 impl crate::audio_crt_heap::Services for Control{
  fn heap_allocate(&mut self,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("real heap provider must allocate"))}
  fn heap_free(&mut self,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("real heap provider must free"))}
  fn thread_context(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(0)}
  fn last_error(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(unsafe{GetLastError()})}
  fn sleep(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{Err(Error::Backend("real heap provider must sleep"))}
  fn decode_pointer(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("handler decoding not supplied in this fixture"))}
  fn invoke_handler(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("handler not supplied in this fixture"))}
 }
 impl Windows for Control{
  fn get_last_error(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(unsafe{GetLastError()})}
  fn set_last_error(&mut self,v:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{unsafe{SetLastError(v)};Ok(())}
  fn tls_get_value(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("real shared slot must get"))}
  fn current_thread_id(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(unsafe{GetCurrentThreadId()})}
 }
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn defaults(m:&mut BTreeMap<u32,Memory>){let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_process_heap_preparation.json")).unwrap();for v in p["runtime_globals"].as_array().unwrap(){let reference=v["reference"].as_u64().unwrap()as u32;let raw=bytes(v["raw"].as_str().unwrap());if crate::audio_path_memory::read(m,reference,raw.len()).is_err(){m.insert(reference,Memory{reference,raw});}}if crate::audio_path_memory::read(m,0x14ae87c,4).is_err(){m.insert(0x14ae87c,Memory{reference:0x14ae87c,raw:vec![0;4]});}}
 #[test]fn audio_windows_process_heap_real_zero_bytes_mapped_writeback_overlap_retirement_and_drop_free_ownership(){
  let mut m=BTreeMap::from([(0x50000000,Memory{reference:0x50000000,raw:vec![9;16]})]);let mut d=BTreeSet::new();defaults(&mut m);let mut heap=Heap::new(0x71000000,0x50000000).unwrap();assert!(matches!(heap.allocate(0x71000000,8,944,&mut m,&mut d),Err(Failure::Uninitialized)));assert_eq!(heap.initialize(&mut m,&d).unwrap(),1);let report=heap.report();
  for size in[1,944,8192]{let reference=heap.allocate(0x71000000,8,size,&mut m,&mut d).unwrap();assert_ne!(reference,0x50000000);assert_eq!(heap.physical_bytes(reference).unwrap(),vec![0;size as usize]);m.get_mut(&reference).unwrap().raw.fill(0x7b);heap.synchronize(reference,&m).unwrap();assert_eq!(heap.physical_bytes(reference).unwrap(),vec![0x7b;size as usize]);assert_eq!(heap.free(0x71000000,0,reference,&m,&mut d).unwrap(),1);assert!(d.contains(&reference));assert!(matches!(heap.free(0x71000000,0,reference,&m,&mut d),Err(Failure::UnknownReference(_))));}
  let reference=heap.allocate(0x71000000,8,64,&mut m,&mut d).unwrap();assert_eq!(heap.outstanding(),1);assert!(heap.physical_bytes(reference).is_ok());std::thread::spawn(move||drop(heap)).join().unwrap();assert_eq!((report.allocations(),report.frees()),(4,4));assert!(report.failures().is_empty());
 }
 #[test]fn audio_windows_process_heap_original_calloc_provider_uses_actual_blocks_minimum_one_and_overflow_fallback_errno(){
  let mut m=BTreeMap::new();let mut d=BTreeSet::new();defaults(&mut m);let mut heap=Heap::new(0x71000000,0x50000000).unwrap();heap.initialize(&mut m,&d).unwrap();let report=heap.report();let mut provider=Provider{inner:Control,heap};for(n,z,expected)in[(0,0,1),(0,u32::MAX,1),(1,944,944),(3,17,51)]{let reference=crate::audio_crt_heap::calloc(&mut m,&mut d,n,z,&mut provider).unwrap();assert_eq!(m[&reference].raw,vec![0;expected]);crate::audio_crt_heap::free(&mut m,&mut d,reference,&mut provider).unwrap();}
  assert_eq!(crate::audio_crt_heap::calloc(&mut m,&mut d,u32::MAX,2,&mut provider).unwrap(),0);assert_eq!(crate::audio_path_source_virtual_cleanup::get(&m,&d,0x1222998,4).unwrap(),12);assert_eq!(provider.heap.outstanding(),0);assert_eq!((report.allocations(),report.frees()),(4,4));assert!(report.failures().is_empty());
 }
 #[test]fn audio_windows_process_heap_real_constructor_shared_fls_and_real_locks_release6_restored_original_contexts_and_new_owned_records(){
  use crate::audio_crt_windows_shared_fls::{SharedContext,SharedSlot,ValueDispatch};use crate::audio_crt_windows_fls_slot::Context;use crate::audio_crt_windows_critical_sections::{Bank,Provider as Locks};
  let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_paired_thread_lifetime_preparation.json")).unwrap();let mut count=0;
  for row in p["cases"].as_array().unwrap().iter().filter(|v|v["layout"]=="all"&&v["reverse"]==false){let mut m=p["regions"].as_array().unwrap().iter().map(|v|{let reference=v["reference"].as_u64().unwrap()as u32;let raw=bytes(row["after_startup"][v["name"].as_str().unwrap()].as_str().unwrap());(reference,Memory{reference,raw})}).collect::<BTreeMap<_,_>>();let d=BTreeSet::new();defaults(&mut m);let mut heap=Heap::new(0x71000000,0x50000000).unwrap();heap.initialize(&mut m,&d).unwrap();heap.adopt(0x40012000,&m).unwrap();let heap_report=heap.report();let mut locks=Bank::default();for j in 0..36{let r=crate::audio_path_source_virtual_cleanup::get(&m,&d,0x1223580+j*8,4).unwrap();if r!=0&&locks.section(r).is_err(){locks.initialize(r,4000,Some(0)).unwrap();}}let lock_report=locks.report();let context=Arc::new(SharedContext::new(Context{memory:m,dead:d,services:Locks{inner:Provider{inner:Control,heap},locks}}));let slot=SharedSlot::new().unwrap();slot.publish_index(&context).unwrap();slot.bind_current(context.clone(),0x40012000).unwrap();
   let(tx,rx)=std::sync::mpsc::channel();let(ready,wait)=std::sync::mpsc::channel();let s=slot.clone();let c=context.clone();let worker=std::thread::spawn(move||{unsafe{SetLastError(97)};let record=s.get_or_create_current(c,ValueDispatch{get:0x40004020,set:0x40004030}).unwrap();assert_eq!(unsafe{GetLastError()},97);ready.send((record,unsafe{GetCurrentThreadId()})).unwrap();rx.recv().unwrap();});let(record,tid)=wait.recv().unwrap();
   context.with(|c|{let region=p["regions"].as_array().unwrap().iter().find(|v|v["reference"]==0x40013000u64).unwrap();let mut expected=bytes(row["after_second_constructor"][region["name"].as_str().unwrap()].as_str().unwrap());expected[..4].copy_from_slice(&tid.to_le_bytes());assert_eq!(c.memory[&record].raw,expected);c.services.inner.heap.synchronize(record,&c.memory).unwrap();assert_eq!(c.services.inner.heap.physical_bytes(record).unwrap(),expected);assert_eq!(c.services.inner.heap.outstanding(),2);}).unwrap();
   slot.shutdown_crt(&context).unwrap();tx.send(()).unwrap();worker.join().unwrap();assert_eq!(slot.report().completed(),2);context.with(|c|{assert_eq!(c.services.inner.heap.outstanding(),0);assert!(c.services.locks.is_empty());assert!(c.dead.contains(&record)&&c.dead.contains(&0x40012000));for v in p["regions"].as_array().unwrap(){let a=v["reference"].as_u64().unwrap()as u32;if a==0x40013000{continue;}let expected=bytes(row["after"][v["name"].as_str().unwrap()].as_str().unwrap());for(j,byte)in expected.iter().enumerate(){let at=a+j as u32;if(0x14ae988..0x14ae988+36*24).contains(&at){continue;}assert_eq!(crate::audio_path_memory::read(&c.memory,at,1).unwrap()[0],*byte,"native nonopaque bank at {at:x}");}}}).unwrap();context.with(|c|{assert_eq!(c.services.inner.heap.retire_mirrors(&mut c.memory,&mut c.dead).unwrap(),2);assert!(!c.memory.contains_key(&record)&&!c.memory.contains_key(&0x40012000));assert!(!c.dead.contains(&record)&&!c.dead.contains(&0x40012000));}).unwrap();assert_eq!((heap_report.allocations(),heap_report.frees()),(2,2));assert!(heap_report.failures().is_empty()&&lock_report.failures().is_empty());count+=1;
  }assert_eq!(count,6);
 }

 #[test]fn audio_windows_process_heap_post_callback_mirror_retirement_is_atomic_and_bounded(){
  let mut m=BTreeMap::new();let mut d=BTreeSet::from([0x60000000]);defaults(&mut m);let baseline=m.len();let mut heap=Heap::new(0x71000000,0x50000000).unwrap();heap.initialize(&mut m,&d).unwrap();let report=heap.report();
  for _ in 0..256{let mut refs=Vec::new();for size in[1,944,8192]{let a=heap.allocate(0x71000000,8,size,&mut m,&mut d).unwrap();refs.push(a);heap.free(0x71000000,0,a,&m,&mut d).unwrap();}let a=refs[0];let b=refs[2];m.get_mut(&b).unwrap().raw.push(0);assert_eq!(heap.retire_mirrors(&mut m,&mut d),Err(Failure::RetirementConflict(b)));assert!(m.contains_key(&a)&&d.contains(&a));m.get_mut(&b).unwrap().raw.pop();assert_eq!(heap.retire_mirrors(&mut m,&mut d).unwrap(),3);assert_eq!(heap.retained_mirrors(),0);assert_eq!(m.len(),baseline);assert_eq!(d,BTreeSet::from([0x60000000]));}
  assert_eq!((report.allocations(),report.frees()),(768,768));assert!(report.failures().is_empty());
 }
 #[test]fn audio_windows_process_heap_reserves_live_and_retired_ranges_even_without_mirrors(){
  let mut m=BTreeMap::new();let mut d=BTreeSet::new();defaults(&mut m);let mut heap=Heap::new(0x71000000,0x50000000).unwrap();heap.initialize(&mut m,&d).unwrap();m.insert(0x50000000,Memory{reference:0x50000000,raw:vec![0;32]});heap.adopt(0x50000000,&m).unwrap();let saved=m.remove(&0x50000000).unwrap();let a=heap.allocate(0x71000000,8,16,&mut m,&mut d).unwrap();assert_eq!(a,0x50000020);m.insert(0x50000010,Memory{reference:0x50000010,raw:vec![0;16]});assert_eq!(heap.adopt(0x50000010,&m),Err(Failure::InvalidReference));m.remove(&0x50000010);m.insert(0x50000000,saved);heap.free(0x71000000,0,0x50000000,&m,&mut d).unwrap();heap.free(0x71000000,0,a,&m,&mut d).unwrap();assert_eq!(heap.retire_mirrors(&mut m,&mut d).unwrap(),2);
 }

 type OwnedServices=crate::audio_crt_windows_critical_sections::Provider<Provider<Control>>;
 fn retire_owned(c:&mut crate::audio_crt_windows_fls_slot::Context<OwnedServices>)->Result<(),Error>{c.services.inner.heap.retire_mirrors(&mut c.memory,&mut c.dead).map(|_|()).map_err(|_|Error::Backend("physical heap mirror retirement rejected"))}
 fn optional_owned_context(p:&Value,row:&Value)->(Arc<crate::audio_crt_windows_shared_fls::SharedContext<OwnedServices>>,Arc<Report>,Vec<u32>,BTreeSet<u32>){
  let mut m=BTreeMap::new();for v in p["regions"].as_array().unwrap(){let reference=v["reference"].as_u64().unwrap()as u32;let raw=bytes(row["before_detach"][v["name"].as_str().unwrap()].as_str().unwrap());if reference==0x40007000{for j in 0..8{let a=reference+j*32;m.insert(a,Memory{reference:a,raw:raw[j as usize*32..(j as usize+1)*32].to_vec()});}}else{m.insert(reference,Memory{reference,raw});}}
  defaults(&mut m);let mut d=BTreeSet::new();let mut heap=Heap::new(0x71000000,0x50000000).unwrap();heap.initialize(&mut m,&d).unwrap();let mut owners=vec![0x40012000];for j in 0..7{if row["strings"]=="all"||(row["strings"]=="alternating"&&j%2==0){owners.push(0x40007000+j*32);}}if row["exception"]=="heap"{owners.push(0x400070e0);}if row["multibyte"].as_str().unwrap().starts_with("custom"){owners.push(0x40010000);}for &a in &owners{heap.adopt(a,&m).unwrap();}let report=heap.report();let mut locks=crate::audio_crt_windows_critical_sections::Bank::default();for j in 0..36{let a=crate::audio_path_memory::read(&m,0x1223580+j*8,4).map(|v|u32::from_le_bytes(v.try_into().unwrap())).unwrap_or(0);if a!=0&&locks.section(a).is_err(){locks.initialize(a,4000,Some(0)).unwrap();}}
  let freed=row["freed"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).filter(|v|*v!=0).collect();let context=Arc::new(crate::audio_crt_windows_shared_fls::SharedContext::new(crate::audio_crt_windows_fls_slot::Context{memory:m,dead:std::mem::take(&mut d),services:crate::audio_crt_windows_critical_sections::Provider{inner:Provider{inner:Control,heap},locks}}));(context,report,owners,freed)
 }
 #[test]fn audio_windows_fls_optional_owned_buffers_retire_automatically_in252_native_thread_exit_and_slot_close_cases(){
  use crate::audio_crt_windows_shared_fls::SharedSlot;let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_optional_thread_buffers_preparation.json")).unwrap();let mut count=0;
  for row in p["cases"].as_array().unwrap(){for exit in [false,true]{let(context,report,owners,freed)=optional_owned_context(&p,row);let slot=SharedSlot::new_with_retirement(retire_owned).unwrap();if exit{let s=slot.clone();let c=context.clone();std::thread::spawn(move||{s.bind_current(c,0x40012000).unwrap();assert_eq!(s.value().unwrap(),0x40012000);}).join().unwrap();slot.close().unwrap();}else{slot.bind_current(context.clone(),0x40012000).unwrap();slot.close().unwrap();}assert_eq!((slot.report().attempts(),slot.report().completed(),slot.report().failure()),(1,1,None));slot.close().unwrap();assert_eq!(slot.report().completed(),1);assert_eq!(report.frees()as usize,freed.len());context.with(|c|{assert!(c.dead.is_empty());assert_eq!(c.services.inner.heap.retained_mirrors(),0);assert_eq!(c.services.inner.heap.outstanding(),owners.len()-freed.len());for &a in &freed{assert!(!c.memory.contains_key(&a));}for v in p["regions"].as_array().unwrap(){let a=v["reference"].as_u64().unwrap()as u32;let expected=bytes(row["after"][v["name"].as_str().unwrap()].as_str().unwrap());for(j,&byte)in expected.iter().enumerate(){let at=a+j as u32;if freed.iter().any(|r|at>=*r&&(at as u64)<*r as u64+if *r==0x40012000{956}else if *r==0x40010000{4}else{32}){continue;}assert_eq!(crate::audio_path_memory::read(&c.memory,at,1).unwrap()[0],byte,"native surviving byte {at:x}");}}}).unwrap();drop(slot);drop(context);assert_eq!(report.allocations(),report.frees());assert!(report.failures().is_empty());count+=1;}}assert_eq!(count,252);
 }
 #[test]fn audio_windows_fls_retirement_failure_is_sticky_after_source_destruction_without_false_completion(){
  let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_optional_thread_buffers_preparation.json")).unwrap();let(context,report,_,freed)=optional_owned_context(&p,&p["cases"][0]);let slot=crate::audio_crt_windows_shared_fls::SharedSlot::new_with_retirement(|_|Err(Error::Backend("injected retirement failure"))).unwrap();slot.bind_current(context.clone(),0x40012000).unwrap();assert!(slot.close().is_err());assert_eq!((slot.report().attempts(),slot.report().completed()),(1,0));assert!(slot.report().failure().is_some());assert!(slot.close().is_err());context.with(|c|{assert_eq!(c.dead,freed);assert!(c.memory.contains_key(&0x40012000));assert_eq!(c.services.inner.heap.retained_mirrors(),1);assert_eq!(c.services.inner.heap.outstanding(),0);}).unwrap();assert_eq!((report.allocations(),report.frees()),(1,1));
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
