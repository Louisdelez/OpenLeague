from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_crt_windows_global_services.rs';s=p.read_text()
s=s.replace('fn SetLastError(value:u32);}', 'fn SetLastError(value:u32);fn GetCurrentThreadId()->u32;fn Sleep(milliseconds:u32);}')
extra=r'''
// The heap/lock/FLS adapters override their own boundaries. Missing current-context
// and source-handler execution services fail explicitly instead of using a fake
// NULL errno context or executing a canonical source-code label as a host pointer.
impl crate::audio_global_float_default_power::Windows for NativeGlobal{
 fn get_last_error(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(unsafe{GetLastError()})}
 fn set_last_error(&mut self,value:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{unsafe{SetLastError(value)};Ok(())}
 fn tls_get_value(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("encoded FLS current-thread provider required"))}
 fn current_thread_id(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(unsafe{GetCurrentThreadId()})}
}
impl crate::audio_crt_heap::Services for NativeGlobal{
 fn heap_allocate(&mut self,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("owned process heap provider required"))}
 fn heap_free(&mut self,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("owned process heap provider required"))}
 fn thread_context(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("original errno current-context service required"))}
 fn last_error(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Ok(unsafe{GetLastError()})}
 fn sleep(&mut self,milliseconds:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{unsafe{Sleep(milliseconds)};Ok(())}
 fn decode_pointer(&mut self,reference:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.decode(reference).map_err(|_|Error::Backend("native pointer decoding registry failure"))}
 fn invoke_handler(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("original source new-handler executor required"))}
}
'''
anchor='#[cfg(test)]mod tests{';assert anchor in s;s=s.replace(anchor,extra+anchor)
# Exercise resolution through the complete global -> owned heap -> real lock chain.
needle='   assert!(d.is_empty());count+=1;'
replacement='''   let mut heap=crate::audio_crt_windows_process_heap::Heap::new(0x71000000,0x50000000).unwrap();m.insert(0x14ae87c,Memory{reference:0x14ae87c,raw:vec![0;4]});heap.initialize(&mut m,&d).unwrap();let report=heap.report();let mut services=crate::audio_crt_windows_critical_sections::Provider{inner:crate::audio_crt_windows_process_heap::Provider{inner:native,heap},locks:crate::audio_crt_windows_critical_sections::Bank::default()};assert_eq!(crate::audio_crt_global_dispatch_initialization::initialize(&mut m,&mut d,&mut services).unwrap(),result);let record=services.inner.heap.allocate(0x71000000,8,956,&mut m,&mut d).unwrap();services.inner.heap.free(0x71000000,0,record,&m,&mut d).unwrap();assert_eq!(services.inner.heap.retire_mirrors(&mut m,&mut d).unwrap(),1);assert_eq!((report.allocations(),report.frees()),(1,1));assert!(report.failures().is_empty());assert!(d.is_empty());count+=1;'''
assert needle in s;s=s.replace(needle,replacement)
p.write_text(s,encoding='utf-8')
for module in ['audio_crt_windows_process_heap','audio_crt_windows_critical_sections']:
 p=r/f'crates/core/src/{module}.rs';s=p.read_text();s+=r'''
impl<S:crate::audio_crt_global_dispatch_initialization::Services> crate::audio_crt_windows_dispatch_resolver::Services for Provider<S>{
 fn module_handle(&mut self,name:&str,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{crate::audio_crt_windows_dispatch_resolver::Services::module_handle(&mut self.inner,name,m,d)}
 fn procedure_address(&mut self,module:u32,name:&str,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{crate::audio_crt_windows_dispatch_resolver::Services::procedure_address(&mut self.inner,module,name,m,d)}
}
impl<S:crate::audio_crt_global_dispatch_initialization::Services> crate::audio_crt_global_dispatch_initialization::Services for Provider<S>{fn encode_pointer(&mut self,value:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{crate::audio_crt_global_dispatch_initialization::Services::encode_pointer(&mut self.inner,value,m,d)}}
'''
 p.write_text(s,encoding='utf-8')
(r/'tools/connect_audio_windows_global_services.py').write_text(Path(__file__).read_text(),encoding='utf-8');print('Connected real global services through physical heap and lock providers; unsupplied errno/handler/FLS boundaries fail explicitly')
