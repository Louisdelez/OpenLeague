from pathlib import Path
r=Path('E:/OpenLeague/crates/core/src')
p=r/'audio_crt_windows_dispatch_resolver.rs';s=p.read_text();s=s.replace('impl FlsFunctions{pub fn new(', '/// Safety: pointers must implement the exact Windows FLS ownership, callback,\n/// thread-local storage and LastError contracts for their entire lifetime.\nimpl FlsFunctions{pub unsafe fn new(');p.write_text(s,encoding='utf-8')
p=r/'audio_crt_windows_shared_fls.rs';s=p.read_text();s=s.replace('FlsFunctions{crate::audio_crt_windows_dispatch_resolver::FlsFunctions::new(FlsAlloc,FlsFree,FlsGetValue,FlsSetValue)}','FlsFunctions{unsafe{crate::audio_crt_windows_dispatch_resolver::FlsFunctions::new(FlsAlloc,FlsFree,FlsGetValue,FlsSetValue)}}');p.write_text(s,encoding='utf-8')
p=r/'audio_crt_windows_global_services.rs';s=p.read_text();s+='''
#[cfg(test)]mod resolved_fls_tests{
 use super::*;use crate::audio_crt_windows_dispatch_resolver::Lookup;
 #[test]fn audio_windows_registered_fls_abi_invokes_full_width_alloc_get_set_free_and_rejects_wrong_null_foreign_encoded_and_permuted_references(){
  let mut native=NativeGlobal::new(0x72000000).unwrap();let module=native.module("kernel32.dll").unwrap();
  let mut refs=[0;4];for(i,n)in["FlsAlloc","FlsFree","FlsGetValue","FlsSetValue"].iter().enumerate(){refs[i]=native.procedure(module,n).unwrap();}
  let api=native.fls_functions(refs).unwrap();let index=unsafe{(api.alloc)(None)};assert_ne!(index,u32::MAX);
  unsafe{SetLastError(97)};assert!(unsafe{(api.get)(index)}.is_null());assert_eq!(unsafe{GetLastError()},0);
  let mut marker=0x12345678u64;let pointer=(&mut marker as*mut u64).cast::<c_void>();
  assert_ne!(unsafe{(api.set)(index,pointer)},0);assert_eq!(unsafe{(api.get)(index)},pointer);
  assert_ne!(unsafe{(api.set)(index,std::ptr::null_mut())},0);assert!(unsafe{(api.get)(index)}.is_null());assert_ne!(unsafe{(api.free)(index)},0);
  let encoded=native.encode(0).unwrap();for bad in[0,0x11223344,module,encoded,refs[1]]{let mut v=refs;v[0]=bad;assert!(native.fls_functions(v).is_err());}
  let mut permuted=refs;permuted.swap(2,3);assert!(native.fls_functions(permuted).is_err());
  let missing=native.procedure(module,"OpenLeagueDefinitelyMissingExport").unwrap();assert_eq!(missing,0);let mut v=refs;v[3]=missing;assert!(native.fls_functions(v).is_err());
 }
}
''';p.write_text(s,encoding='utf-8')
p=r/'audio_crt_windows_root_startup.rs';s=p.read_text();s=s.replace('struct Fault{inner:Owned,null_calloc:bool}','struct Fault{inner:Owned,null_calloc:bool,trace_fls:bool}')
s=s.replace('Fault{inner:c.services,null_calloc}','Fault{inner:c.services,null_calloc,trace_fls:false}')
needle='crate::audio_crt_windows_dispatch_resolver::Lookup::fls_functions(&self.inner,references)'
assert needle in s
s=s.replace(needle,'let api=crate::audio_crt_windows_dispatch_resolver::Lookup::fls_functions(&self.inner,references)?;if self.trace_fls{Ok(unsafe{crate::audio_crt_windows_dispatch_resolver::FlsFunctions::new(count_alloc,count_free,count_get,count_set)})}else{Ok(api)}')
tests='''
 static CALLS:[std::sync::atomic::AtomicUsize;4]=[const{std::sync::atomic::AtomicUsize::new(0)};4];
 #[link(name="kernel32")]unsafe extern "system"{fn FlsAlloc(cb:Option<unsafe extern "system" fn(*mut std::ffi::c_void)>)->u32;fn FlsFree(i:u32)->i32;fn FlsGetValue(i:u32)->*mut std::ffi::c_void;fn FlsSetValue(i:u32,p:*mut std::ffi::c_void)->i32;}
 unsafe extern "system" fn count_alloc(cb:Option<unsafe extern "system" fn(*mut std::ffi::c_void)>)->u32{CALLS[0].fetch_add(1,std::sync::atomic::Ordering::SeqCst);unsafe{FlsAlloc(cb)}}
 unsafe extern "system" fn count_free(i:u32)->i32{CALLS[1].fetch_add(1,std::sync::atomic::Ordering::SeqCst);unsafe{FlsFree(i)}}
 unsafe extern "system" fn count_get(i:u32)->*mut std::ffi::c_void{CALLS[2].fetch_add(1,std::sync::atomic::Ordering::SeqCst);unsafe{FlsGetValue(i)}}
 unsafe extern "system" fn count_set(i:u32,p:*mut std::ffi::c_void)->i32{CALLS[3].fetch_add(1,std::sync::atomic::Ordering::SeqCst);unsafe{FlsSetValue(i,p)}}
 fn retire_fault(c:&mut Context<Fault>)->Result<(),Error>{c.services.inner.inner.heap.retire_mirrors(&mut c.memory,&mut c.dead).map(|_|()).map_err(|_|Error::Backend("mirror retirement failed"))}
 #[test]fn audio_windows_root_registered_fls_table_routes_all_four_abi_boundaries_through_fresh_worker_creation_explicit_shutdown_and_drop(){
  let p=fixture();let row=p["cases"].as_array().unwrap().iter().find(|v|v["layout"]=="all"&&v["failure"]=="none").unwrap();
  for implicit in[false,true]{for counter in &CALLS{counter.store(0,std::sync::atomic::Ordering::SeqCst);}let c=prepare(&p,row);let heap=c.services.inner.heap.report();let context=Context{memory:c.memory,dead:c.dead,services:Fault{inner:c.services,null_calloc:false,trace_fls:true}};
   let started=Arc::new(initialize(context,Some(retire_fault)).unwrap());let record=started.initial_record.unwrap();let state=started.context.clone();let slot=started.slot.as_ref().unwrap().clone();assert_eq!(slot.value().unwrap(),record);assert_eq!(started.current().unwrap(),record);
   let(tx,rx)=std::sync::mpsc::channel();let(ready,wait)=std::sync::mpsc::channel();let s=started.clone();let worker=std::thread::spawn(move||{let r=s.current().unwrap();drop(s);ready.send(r).unwrap();rx.recv().unwrap();});let other=wait.recv().unwrap();assert_ne!(record,other);
   if !implicit{started.shutdown().unwrap();started.shutdown().unwrap();}drop(started);tx.send(()).unwrap();worker.join().unwrap();
   assert_eq!(CALLS[0].load(std::sync::atomic::Ordering::SeqCst),1);assert_eq!(CALLS[1].load(std::sync::atomic::Ordering::SeqCst),1);assert!(CALLS[2].load(std::sync::atomic::Ordering::SeqCst)>=4);assert_eq!(CALLS[3].load(std::sync::atomic::Ordering::SeqCst),2);
   assert_eq!((slot.report().attempts(),slot.report().completed(),slot.report().failure()),(2,2,None));assert_eq!((heap.allocations(),heap.frees()),(2,2));state.with(|c|{assert!(c.services.inner.locks.is_empty());assert!(!c.memory.contains_key(&record)&&!c.memory.contains_key(&other));}).unwrap();
  }
 }
'''
needle=' static CALLS:'
assert needle not in s
at=s.index(' struct Fault{');s=s[:at]+tests+s[at:];p.write_text(s,encoding='utf-8')
Path('E:/OpenLeague/tools/test_audio_resolved_fls.py').write_text(Path(__file__).read_text(),encoding='utf-8')
print('Added two full-core ABI identity and routed startup/callback cleanup tests')
