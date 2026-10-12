from pathlib import Path
import json,hashlib,subprocess
r=Path('E:/OpenLeague');out=r/'tools/hardware/actual_worker_exit';out.mkdir(parents=True,exist_ok=True)
s=(r/'tools/hardware/cookie_root_startup/probe.rs').read_text()
needle='fn main(){use';assert needle in s
extra='''
#[path="E:/OpenLeague/crates/core/src/audio_crt_worker_exit.rs"]mod audio_crt_worker_exit;
type Owned=audio_crt_windows_critical_sections::Provider<audio_crt_windows_process_heap::Provider<audio_crt_windows_global_services::NativeGlobal>>;
struct Worker{root:Arc<audio_crt_windows_root_startup::Startup<Owned>>,ready:std::sync::mpsc::Sender<u32>,code:u32,com:bool}
#[link(name="kernel32")]unsafe extern "system"{fn CreateThread(attributes:*mut c_void,stack:usize,start:Option<unsafe extern "system" fn(*mut c_void)->u32>,parameter:*mut c_void,flags:u32,thread:*mut u32)->*mut c_void;fn WaitForSingleObject(handle:*mut c_void,time:u32)->u32;fn GetExitCodeThread(handle:*mut c_void,code:*mut u32)->i32;fn CloseHandle(handle:*mut c_void)->i32;fn ExitThread(code:u32)->!;}
unsafe extern "system" fn native_worker(parameter:*mut c_void)->u32{
 let code={let data=unsafe{Box::from_raw(parameter.cast::<Worker>())};let record=data.root.current().unwrap();if data.com{data.root.context.with(|c|{let native=&mut c.services.inner.inner;let module=native.load_combase("combase.dll",0x800).unwrap();let init=native.procedure(module,"RoInitialize").unwrap();assert_eq!(native.ro_initialize(init,1).unwrap(),0);audio_path_source_virtual_cleanup::put(&mut c.memory,&c.dead,record+0x3b4,4,1).unwrap();}).unwrap();}let exit=data.root.prepare_worker_exit(data.code).unwrap();assert_eq!(data.root.slot.as_ref().unwrap().value().unwrap(),0);data.root.context.with(|c|{assert!(!c.memory.contains_key(&record));assert_eq!(c.services.inner.inner.pending_ro_initializations(),0);}).unwrap();data.ready.send(record).unwrap();exit.code};
 // All Rust-owned worker locals and capsule were dropped above. No live Rust
 // frames with destructors are bypassed by the original terminal OS boundary.
 unsafe{ExitThread(code)}
}
'''
s=s.replace(needle,extra+needle)
s=s.replace('m.insert(audio_security_cookie::COMPLEMENT,','m.insert(0x14ae600,Memory{reference:0x14ae600,raw:vec![0;8]});m.insert(audio_security_cookie::COMPLEMENT,')
start=s.index('let(tx,rx)=std::sync::mpsc::channel();');end=s.index('assert_eq!((slot.report().attempts()',start)
replacement='''let(ready,wait)=std::sync::mpsc::channel();let exit_code=[0,97,u32::MAX][i%3];let capsule=Box::into_raw(Box::new(Worker{root:started.clone(),ready,code:exit_code,com:i%2!=0}));let handle=unsafe{CreateThread(std::ptr::null_mut(),0,Some(native_worker),capsule.cast(),0,std::ptr::null_mut())};assert!(!handle.is_null());let second=wait.recv().unwrap();assert_ne!(record,second);assert_eq!(unsafe{WaitForSingleObject(handle,5000)},0);let mut actual_code=0;assert_ne!(unsafe{GetExitCodeThread(handle,&mut actual_code)},0);assert_eq!(actual_code,exit_code);assert_ne!(unsafe{CloseHandle(handle)},0);assert_eq!(report.allocations(),2);assert_eq!(report.frees(),1);assert_eq!(slot.report().attempts(),0);started.shutdown().unwrap();'''
s=s[:start]+replacement+s[end:];s=s.replace('(2,2,None)','(1,1,None)');s=s.replace('two-callback retirement','explicit worker retirement and one main callback; actual ExitThread codes0/97/MAX')
probe=out/'probe.rs';probe.write_text(s,encoding='utf-8');files=[probe]+list((r/'tools/hardware/fresh_native_contexts').glob('case_*.tsv'))
for target,width in [('x86_64-pc-windows-msvc',64),('i686-pc-windows-msvc',32)]:
 exe=out/f'probe-{width}.exe';log=out/f'probe-{width}.log';build=subprocess.run(['C:/Users/loicd/.cargo/bin/rustc.exe','--edition=2021','--target',target,'-C','debuginfo=0',str(probe),'-o',str(exe)],capture_output=True,text=True);log.write_text(build.stdout+build.stderr);assert build.returncode==0,build.stderr;run=subprocess.run([str(exe),str(r/'tools/hardware/fresh_native_contexts')],capture_output=True,text=True,timeout=30);log.write_text(log.read_text()+run.stdout+run.stderr);assert run.returncode==0,run.stdout+run.stderr;print(run.stdout.strip());files.extend([exe,log])
tool=r/'tools/probe_audio_actual_worker_exit.py';tool.write_text(Path(__file__).read_text(),encoding='utf-8');files.append(tool)
for n in ['audio_crt_worker_exit','audio_crt_windows_global_services','audio_crt_windows_process_heap','audio_crt_windows_critical_sections','audio_crt_windows_shared_fls','audio_crt_windows_root_startup']:files.append(r/f'crates/core/src/{n}.rs')
receipt={'passed':True,'complete':False,'cases':12,'architectures':[32,64],'actual_com_initialized_workers':6,'actual_exit_codes':[0,97,4294967295],'restored_thread_records':0,'limits':['Actual CreateThread/RoInitialize/original worker exit preparation and RoUninitialize/ExitThread/GetExitCodeThread executed. Source COM flag is explicitly supplied after successful actual initialization; original package detection/startup flag producer still unintegrated.','Rust capsule and owned locals dropped before terminal ExitThread. Full original worker start body, SEH and native TLS fallback remain incomplete. Normal audio client playback remains incomplete.'],'files_sha256':{str(f.relative_to(r)):hashlib.sha256(f.read_bytes()).hexdigest()for f in files}}
(r/'docs/audio_actual_worker_exit_hardware_validation.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
