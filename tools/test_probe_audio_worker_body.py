from pathlib import Path
import subprocess,json,hashlib
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_crt_windows_root_startup.rs';s=p.read_text(encoding='utf-8');a=s.index(' #[test]fn audio_windows_worker_com_stage');b=s.index(' struct Fault',a);test=s[a:b].replace('audio_windows_worker_com_stage_integrates_actual_package_query_or_cached_positive_gate_real_initializer_and_complete_worker_exit_in12_fresh_contexts','audio_windows_normal_worker_body_integrates_actual_callback_raw_result_com_balance_and_explicit_retirement_in12_fresh_contexts')
needle='assert_eq!(s.prepare_worker_exit(97).unwrap().code,97);';assert needle in test
test=test.replace(needle,'''s.context.with(|c|{let callback=unsafe{c.services.inner.inner.register_worker_callback(normal_worker_callback)}.unwrap();put(&mut c.memory,&c.dead,record+0x54,4,callback).unwrap();put(&mut c.memory,&c.dead,record+0x58,4,97).unwrap();}).unwrap();assert_eq!(s.prepare_worker_body_exit().unwrap().code,97);''')
test=' unsafe extern "system" fn normal_worker_callback(argument:u32)->u32{argument}\n'+test
if 'fn audio_windows_normal_worker_body_integrates_actual_callback'not in s:s=s[:b]+test+s[b:];p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/audio_crt_windows_global_services.rs';s=p.read_text(encoding='utf-8');s+='''
#[cfg(test)]mod worker_callback_tests{
 use super::*;
 unsafe extern "system" fn callback(argument:u32)->u32{unsafe{SetLastError(73)};argument}
 #[test]fn audio_windows_worker_callback_registry_preserves_full_width_system_abi_u32_results_last_error_and_rejects_unregistered_export_encoded_or_module_refs(){let mut native=NativeGlobal::new(0x76000000).unwrap();let reference=unsafe{native.register_worker_callback(callback)}.unwrap();assert_eq!(unsafe{native.register_worker_callback(callback)}.unwrap(),reference);for argument in [0,97,u32::MAX]{assert_eq!(native.invoke_worker_callback(reference,argument).unwrap(),argument);assert_eq!(unsafe{GetLastError()},73);}let module=native.module("kernel32.dll").unwrap();let export=native.procedure(module,"GetCurrentThreadId").unwrap();let encoded=native.encode(reference).unwrap();for r in [module,export,encoded]{assert_eq!(native.invoke_worker_callback(r,0),Err(Failure::WrongKind));}for r in [0,0xffffffff]{assert_eq!(native.invoke_worker_callback(r,0),Err(Failure::UnknownReference(r)));}}
}
''';
if p.read_text(encoding='utf-8').count('mod worker_callback_tests')==0:p.write_text(s,encoding='utf-8')
out=r/'tools/hardware/actual_worker_body';out.mkdir(parents=True,exist_ok=True)
s=(r/'tools/hardware/actual_com_startup/probe.rs').read_text(encoding='utf-8')
needle='let exit=data.root.prepare_worker_exit(data.code).unwrap();';assert needle in s
s=s.replace(needle,'''data.root.context.with(|c|{let callback=unsafe{c.services.inner.inner.register_worker_callback(body_callback)}.unwrap();audio_path_source_virtual_cleanup::put(&mut c.memory,&c.dead,record+0x54,4,callback).unwrap();audio_path_source_virtual_cleanup::put(&mut c.memory,&c.dead,record+0x58,4,data.code).unwrap();}).unwrap();let exit=data.root.prepare_worker_body_exit().unwrap();assert_eq!(exit.code,data.code);''')
s=s.replace('fn main(){use','''#[path="E:/OpenLeague/crates/core/src/audio_crt_worker_body.rs"]mod audio_crt_worker_body;
static CALLBACKS:std::sync::atomic::AtomicUsize=std::sync::atomic::AtomicUsize::new(0);
unsafe extern "system" fn body_callback(argument:u32)->u32{CALLBACKS.fetch_add(1,std::sync::atomic::Ordering::SeqCst);argument}
fn main(){use''')
needle='assert_ne!(unsafe{CloseHandle(handle)},0);';s=s.replace(needle,needle+'assert_eq!(CALLBACKS.load(std::sync::atomic::Ordering::SeqCst),i+1);')
s=s.replace('original package/COM flag producer, explicit worker retirement and one main callback','original package/COM flag producer, actual body callback/raw return, explicit worker retirement and one main callback')
probe=out/'probe.rs';probe.write_text(s,encoding='utf-8');files=[probe]+list((r/'tools/hardware/fresh_native_contexts').glob('case_*.tsv'))
for target,width in [('x86_64-pc-windows-msvc',64),('i686-pc-windows-msvc',32)]:
 exe=out/f'probe-{width}.exe';log=out/f'probe-{width}.log';build=subprocess.run(['C:/Users/loicd/.cargo/bin/rustc.exe','--edition=2021','--target',target,'-C','debuginfo=0',str(probe),'-o',str(exe)],capture_output=True,text=True);log.write_text(build.stdout+build.stderr,encoding='utf-8');assert build.returncode==0,build.stderr;run=subprocess.run([str(exe),str(r/'tools/hardware/fresh_native_contexts')],capture_output=True,text=True,timeout=30);log.write_text(log.read_text(encoding='utf-8')+run.stdout+run.stderr,encoding='utf-8');assert run.returncode==0,run.stdout+run.stderr;print(run.stdout.strip());files.extend([exe,log])
tool=r/'tools/test_probe_audio_worker_body.py';tool.write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');files.append(tool)
for n in ['audio_crt_worker_body','audio_crt_worker_exit','audio_crt_windows_global_services','audio_crt_windows_shared_fls','audio_crt_windows_root_startup','audio_crt_windows_process_heap','audio_crt_windows_critical_sections']:files.append(r/f'crates/core/src/{n}.rs')
receipt={'passed':True,'complete':False,'cases':12,'architectures':[32,64],'physical_thread_exit_codes':[0,97,4294967295],'actual_callback_calls':12,'limits':['Normal original required-context/callback/raw-result/exit order integrated in real CreateThread workers. Callback invocation counted exactly once, original package/COM producer invoked and physical ExitThread codes verified, explicit retirement prevents duplicate FLS destruction.','Full original packet entry/transfer, native exception/SEH and source S_FALSE lifetime path still incomplete. Positive package cache remains supplied source input; these callbacks use canonical u32 scalar arguments rather than arbitrary host pointers.'],'files_sha256':{str(f.relative_to(r)):hashlib.sha256(f.read_bytes()).hexdigest()for f in files}}
(r/'docs/audio_actual_worker_body_hardware_validation.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
