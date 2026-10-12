from pathlib import Path
r=Path('E:/OpenLeague');s=(r/'tools/hardware/actual_packet_pipeline/probe.rs').read_text(encoding='utf-8');a=s.index('struct Worker{');b=s.index('#[path=',a);helper=s[a:b].replace('Worker','PacketWorker').replace('native_worker','packet_native_worker')
a=s.index('let(ready,wait)=std::sync::mpsc::channel();');b=s.index(' }println!',a);body=s[a:b].replace('Worker','PacketWorker').replace('native_worker','packet_native_worker').replace('CALLBACKS','PIPELINE_CALLBACKS')
module='''
mod packet_pipeline_tests{
 use super::*;use std::ffi::c_void;
 use crate::{audio_crt_windows_root_startup,audio_crt_worker_entry,audio_crt_worker_packet,audio_crt_windows_worker_thread,audio_path_source_virtual_cleanup};
 #[link(name="kernel32")]unsafe extern "system"{fn SetLastError(value:u32);}
 static PIPELINE_CALLBACKS:std::sync::atomic::AtomicUsize=std::sync::atomic::AtomicUsize::new(0);
 unsafe extern "system" fn body_callback(argument:u32)->u32{PIPELINE_CALLBACKS.fetch_add(1,std::sync::atomic::Ordering::SeqCst);argument}
'''+helper+'''
 #[test]fn audio_windows_packet_to_thread_pipeline_48_fresh_native_contexts_adopt_or_transfer_original_packet_com_body_callback_physical_exit_suspension_and_owned_handle_retirement(){
 let p=fixture();let mut i=0;for row in p["cases"].as_array().unwrap().iter().filter(|v|v["layout"]=="all"&&v["failure"]=="none"){for mode in 0..8{
 let existing=mode&4!=0;let com=mode&2!=0;let suspended=mode&1!=0;let mut c=prepare(&p,row);
 c.memory.insert(0x14ae5f8,Memory{reference:0x14ae5f8,raw:vec![0;16]});c.memory.insert(0x122343c,Memory{reference:0x122343c,raw:u32::MAX.to_le_bytes().to_vec()});
 let report=c.services.inner.heap.report();let lock_report=c.services.locks.report();let started=Arc::new(initialize(c,Some(retire)).unwrap());let context=started.context.clone();let slot=started.slot.as_ref().unwrap().clone();let record=started.initial_record.unwrap();assert!(started.initialize_worker_packet(record).is_err());
'''+body+'''
 assert!(started.initialize_worker_packet(packet).is_err());i+=1;
 }}assert_eq!(i,48);
 }
}
'''
p=r/'crates/core/src/audio_crt_windows_root_startup.rs';s=p.read_text(encoding='utf-8');needle=' struct Fault';assert needle in s and 'mod packet_pipeline_tests'not in s;s=s.replace(needle,module+needle,1);p.write_text(s,encoding='utf-8');(r/'tools/add_audio_packet_pipeline_core_test.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Added48 real source packet-to-OS pipeline regressions')
