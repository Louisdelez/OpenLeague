from pathlib import Path
import json,hashlib,subprocess
r=Path('E:/OpenLeague');out=r/'tools/hardware/resolved_fls';out.mkdir(parents=True,exist_ok=True)
s=(r/'tools/hardware/cookie_root_startup/probe.rs').read_text()
extra='''
fn qualify_fls(){use audio_crt_windows_dispatch_resolver::Lookup;let mut native=audio_crt_windows_global_services::NativeGlobal::new(0x76000000).unwrap();let module=native.module("kernel32.dll").unwrap();let mut refs=[0;4];for(i,n)in["FlsAlloc","FlsFree","FlsGetValue","FlsSetValue"].iter().enumerate(){refs[i]=native.procedure(module,n).unwrap();}let api=native.fls_functions(refs).unwrap();let index=unsafe{(api.alloc)(None)};assert_ne!(index,u32::MAX);unsafe{SetLastError(97)};assert!(unsafe{(api.get)(index)}.is_null());assert_eq!(unsafe{GetLastError()},0);let mut marker=0x12345678u64;let pointer=(&mut marker as*mut u64).cast::<c_void>();assert_ne!(unsafe{(api.set)(index,pointer)},0);assert_eq!(unsafe{(api.get)(index)},pointer);assert_ne!(unsafe{(api.set)(index,std::ptr::null_mut())},0);assert!(unsafe{(api.get)(index)}.is_null());assert_ne!(unsafe{(api.free)(index)},0);let encoded=native.encode(0).unwrap();for bad in[0,0x11223344,module,encoded,refs[1]]{let mut v=refs;v[0]=bad;assert!(native.fls_functions(v).is_err());}let mut v=refs;v.swap(2,3);assert!(native.fls_functions(v).is_err());println!("PASS actual typed registered FLS ABI allocation/full-width value/clear/free and6 invalid reference shapes; pointer_width={}",std::mem::size_of::<usize>()*8);}
'''
s=s.replace('fn main(){use','fn main(){qualify_fls();use',1);s+=extra
needle='let mut v=refs;v.swap(2,3);'
assert needle in s
s=s.replace(needle,'let other=native.module("KernelBase.dll").unwrap();assert_ne!(other,0);let mut other_refs=[0;4];for(i,n)in["FlsAlloc","FlsFree","FlsGetValue","FlsSetValue"].iter().enumerate(){other_refs[i]=native.procedure(other,n).unwrap();}assert!(native.fls_functions(other_refs).is_err());'+needle)
s=s.replace('and6 invalid reference shapes','and7 invalid reference/module shapes')
probe=out/'probe.rs';probe.write_text(s,encoding='utf-8');files=[probe]
for target,width in [('x86_64-pc-windows-msvc',64),('i686-pc-windows-msvc',32)]:
 exe=out/f'probe-{width}.exe';log=out/f'probe-{width}.log'
 build=subprocess.run(['C:/Users/loicd/.cargo/bin/rustc.exe','--edition=2021','--target',target,'-C','debuginfo=0',str(probe),'-o',str(exe)],capture_output=True,text=True);log.write_text(build.stdout+build.stderr);assert build.returncode==0,build.stderr
 run=subprocess.run([str(exe),str(r/'tools/hardware/fresh_native_contexts')],capture_output=True,text=True,timeout=30);log.write_text(log.read_text()+run.stdout+run.stderr);assert run.returncode==0,run.stdout+run.stderr;print(run.stdout.strip());files.extend([exe,log])
tool=r/'tools/probe_audio_resolved_fls.py';tool.write_text(Path(__file__).read_text(),encoding='utf-8');files.append(tool)
for n in ['audio_crt_windows_dispatch_resolver','audio_crt_windows_global_services','audio_crt_windows_shared_fls','audio_crt_windows_root_startup','audio_crt_windows_process_heap','audio_crt_windows_critical_sections']:files.append(r/f'crates/core/src/{n}.rs')
files+=list((r/'tools/hardware/fresh_native_contexts').glob('case_*.tsv'))
receipt={'passed':True,'complete':False,'architectures':[32,64],'root_cases':12,'typed_abi_cycles':2,'invalid_reference_shapes':14,'restored_thread_records':0,'limits':['Actual registered full-width Windows FLS functions used for allocation, storage and cleanup. Six original startup bank configurations per architecture, after explicit cookie/reference/index/ID/export/codec normalization.','Partial availability/legacy TLS root, OS exhaustion, SEH and normal client audible playback remain incomplete. Routing spy coverage is separately exercised by full-core tests.'],'files_sha256':{str(p.relative_to(r)):hashlib.sha256(p.read_bytes()).hexdigest() for p in files}}
(r/'docs/audio_resolved_fls_hardware_validation.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
