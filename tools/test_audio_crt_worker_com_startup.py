from pathlib import Path
r=Path('E:/OpenLeague/crates/core/src')
p=r/'audio_crt_windows_root_startup.rs';s=p.read_text();at=s.index(' struct Fault{');test='''
 #[test]fn audio_windows_worker_com_stage_integrates_actual_package_query_or_cached_positive_gate_real_initializer_and_complete_worker_exit_in12_fresh_contexts(){
  let p=fixture();let mut count=0;for row in p["cases"].as_array().unwrap().iter().filter(|v|v["layout"]=="all"&&v["failure"]=="none"){for cached in[false,true]{let mut c=prepare(&p,row);c.memory.insert(0x14ae5f8,Memory{reference:0x14ae5f8,raw:vec![0;16]});c.memory.insert(0x122343c,Memory{reference:0x122343c,raw:if cached{1u32}else{u32::MAX}.to_le_bytes().to_vec()});let heap=c.services.inner.heap.report();let started=Arc::new(initialize(c,Some(retire)).unwrap());let state=started.context.clone();let slot=started.slot.as_ref().unwrap().clone();let s=started.clone();let worker=std::thread::spawn(move||{let record=s.initialize_worker_com().unwrap();let flag=s.context.with(|c|{let flag=get(&c.memory,&c.dead,record+0x3b4,4).unwrap();let package=get(&c.memory,&c.dead,0x122343c,4).unwrap();assert!(package<=1);if cached{assert_eq!((package,flag),(1,1));}assert_eq!(c.services.inner.inner.pending_ro_initializations(),flag as usize);flag}).unwrap();assert_eq!(s.prepare_worker_exit(97).unwrap().code,97);s.context.with(|c|{assert_eq!(c.services.inner.inner.pending_ro_initializations(),0);assert!(!c.memory.contains_key(&record));}).unwrap();flag});let flag=worker.join().unwrap();started.shutdown().unwrap();assert_eq!((slot.report().attempts(),slot.report().completed(),slot.report().failure()),(1,1,None));assert_eq!((heap.allocations(),heap.frees()),(2,2));let report=state.with(|c|c.services.inner.inner.com_report()).unwrap();drop(state);drop(slot);drop(started);let n=flag as usize;assert_eq!((report.loads(),report.releases(),report.initializations(),report.uninitializations()),(2*n,2*n,n,n));assert!(heap.failures().is_empty()&&report.failures().is_empty());count+=1;}}assert_eq!(count,12);
 }
''';p.write_text(s[:at]+test+s[at:],encoding='utf-8')
p=r/'audio_crt_windows_global_services.rs';s=p.read_text();s+='''
#[cfg(test)]mod package_and_com_stage_tests{
 use super::*;
 #[test]fn audio_windows_package_query_checks_typed_export_provenance_and_real_com_initializer_preserves_source_s_false_flag_separate_from_two_owned_obligations(){
  std::thread::spawn(||{let mut native=NativeGlobal::new(0x76000000).unwrap();let module=native.module("kernel32.dll").unwrap();let package=native.procedure(module,"GetCurrentPackageId").unwrap();let query=native.package_query(package,0).unwrap();assert!(query.result==122||query.result==15700,"current actual package state");let wrong=native.procedure(module,"GetCurrentThreadId").unwrap();assert_eq!(native.package_query(wrong,0),Err(Failure::NameMismatch));assert!(native.package_query(0,0).is_err());assert!(native.package_query(module,0).is_err());let encoded=native.encode(package).unwrap();assert!(native.package_query(encoded,0).is_err());
   let mut memory=BTreeMap::new();let mut dead=BTreeSet::new();memory.insert(0x14ae5f8,Memory{reference:0x14ae5f8,raw:vec![0;8]});assert_eq!(crate::audio_crt_worker_com_startup::initialize_com(&mut memory,&mut dead,&mut native).unwrap(),1);assert_eq!(crate::audio_crt_worker_com_startup::initialize_com(&mut memory,&mut dead,&mut native).unwrap(),0);assert_eq!(native.pending_ro_initializations(),2);
   // Explicit test-owned balancing, separate from original strict-zero flag.
   let module=native.load_combase("combase.dll",0x800).unwrap();let release=native.procedure(module,"RoUninitialize").unwrap();native.ro_uninitialize(release).unwrap();native.ro_uninitialize(release).unwrap();assert_eq!(native.pending_ro_initializations(),0);
  }).join().unwrap();
 }
}
''';p.write_text(s,encoding='utf-8')
# Result comparison in package test needs comparable raw query values.
p=r/'audio_crt_worker_com_startup.rs';s=p.read_text().replace('#[derive(Debug,Clone,Copy)]pub struct PackageQuery','#[derive(Debug,Clone,Copy,PartialEq,Eq)]pub struct PackageQuery');p.write_text(s,encoding='utf-8')
Path('E:/OpenLeague/tools/test_audio_crt_worker_com_startup.py').write_text(Path(__file__).read_text(),encoding='utf-8');print('Added12 actual worker COM stages and actual query/strict S_FALSE ownership test')
