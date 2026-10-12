from pathlib import Path
r=Path('E:/OpenLeague');s=(r/'tools/hardware/actual_packet_failure/probe.rs').read_text(encoding='utf-8');a=s.index('struct Capsule{');b=s.index('fn main(){',a);helper=s[a:b];a=s.index('let inherit=i&4');b=s.index(' }println!',a);body=s[a:b]
module='''
mod packet_failure_tests{
 use super::*;use std::ffi::c_void;
 use crate::{audio_crt_worker_packet,audio_crt_windows_worker_thread,audio_path_source_virtual_cleanup,audio_path_memory};
 #[link(name="kernel32")]unsafe extern "system"{fn SetLastError(value:u32);fn GetLastError()->u32;}
 unsafe extern "system" fn body_callback(argument:u32)->u32{argument}
'''+helper+'''
 #[test]fn audio_windows_packet_actual_create_thread_error1305_48_fresh_contexts_free_packet_map_doserrno_errno_reclaim_capsule_preserve_slot_outputs_and_source_counter_retention(){
 let p=fixture();let mut i=0;for row in p["cases"].as_array().unwrap().iter().filter(|v|v["layout"]=="all"&&v["failure"]=="none"){for _ in 0..8{
 let c=prepare(&p,row);let report=c.services.inner.heap.report();let lock_report=c.services.locks.report();let started=Arc::new(initialize(c,Some(retire)).unwrap());let context=started.context.clone();let slot=started.slot.as_ref().unwrap().clone();let record=started.initial_record.unwrap();
'''+body+'''
 i+=1;
 }}assert_eq!(i,48);
 }
}
'''
p=r/'crates/core/src/audio_crt_windows_root_startup.rs';s=p.read_text(encoding='utf-8');needle=' struct Fault';assert needle in s and 'mod packet_failure_tests'not in s;s=s.replace(needle,module+needle,1);p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/audio_crt_windows_worker_thread.rs';s=p.read_text(encoding='utf-8');s+='''
#[cfg(test)]mod security_tests{
 use super::*;
 unsafe extern "system" fn start(_:*mut c_void)->u32{97}
 #[test]fn audio_windows_worker_security_borrow_checks_label_and_native_layout_then_accepts_revision1_descriptor_suspended_wait_resume_and_owned_close(){let mut descriptor=[0u8;40];descriptor[0]=1;let mut security=unsafe{Security::from_descriptor(0x74000000,&mut descriptor,false)}.unwrap();assert_eq!(security.attributes.length,if cfg!(target_pointer_width="64"){24}else{12});let report=Arc::new(Report::default());let request=ThreadRequest{security:0x74000000,stack_size:0,entry:0xc9c3dc,packet:0,flags:4,thread_id_output:0};let mut mismatch=request;mismatch.security=0x74000010;assert!(matches!(unsafe{Thread::spawn_with_security(0x73000000,mismatch,start,std::ptr::null_mut(),report.clone(),&mut security)},Err(Failure::SecurityLabelMismatch)));assert_eq!((report.created(),report.closed()),(0,0));let thread=unsafe{Thread::spawn_with_security(0x73000000,request,start,std::ptr::null_mut(),report.clone(),&mut security)}.unwrap();assert_eq!(thread.wait(0).unwrap(),Wait::Timeout);assert_eq!(thread.resume().unwrap(),1);assert_eq!(thread.wait(5000).unwrap(),Wait::Exited(97));drop(thread);assert_eq!((report.created(),report.closed()),(1,1));assert!(report.failures().is_empty());}
}
''';p.write_text(s,encoding='utf-8');(r/'tools/add_audio_packet_failure_core_tests.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Added48 real failure regressions and actual valid security-descriptor ABI qualification')
