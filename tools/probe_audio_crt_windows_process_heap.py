from pathlib import Path
import subprocess
r=Path('E:/OpenLeague');out=r/'tools/hardware/process_heap';out.mkdir(parents=True,exist_ok=True)
s=(r/'tools/hardware/windows_shared_fls_component/probe.rs').read_text();s=s[:s.index('struct SharedApi{')]
for module in ['audio_crt_windows_dispatch_resolver','audio_crt_global_dispatch_initialization','audio_crt_static_lock_startup','audio_crt_tls_slot_wrappers','audio_crt_thread_system_startup','audio_crt_heap','audio_crt_windows_process_heap']:
 s+='\n#[path="E:/OpenLeague/crates/core/src/'+module+'.rs"] mod '+module+';\n'
s+=r'''
fn main(){use audio_crt_windows_process_heap::Heap;let mut m=BTreeMap::from([(0x14ae87c,Memory{reference:0x14ae87c,raw:vec![0;4]})]);let mut d=BTreeSet::new();let mut heap=Heap::new(0x71000000,0x50000000).unwrap();assert_eq!(heap.initialize(&mut m,&d).unwrap(),1);let report=heap.report();for size in[1,944,8192]{let r=heap.allocate(0x71000000,8,size,&mut m,&mut d).unwrap();assert_eq!(heap.physical_bytes(r).unwrap(),vec![0;size as usize]);m.get_mut(&r).unwrap().raw.fill(0x7b);heap.synchronize(r,&m).unwrap();assert_eq!(heap.physical_bytes(r).unwrap(),vec![0x7b;size as usize]);heap.free(0x71000000,0,r,&m,&mut d).unwrap();assert!(d.contains(&r));}heap.allocate(0x71000000,8,64,&mut m,&mut d).unwrap();std::thread::spawn(move||drop(heap)).join().unwrap();assert_eq!((report.allocations(),report.frees()),(4,4));assert!(report.failures().is_empty());println!("PASS actual production process heap allocation/zero/writeback/free/cross-thread Drop; pointer_width={}",std::mem::size_of::<usize>()*8);}
'''
probe=out/'probe.rs';probe.write_text(s,encoding='utf-8')
for target,width in [('x86_64-pc-windows-msvc',64),('i686-pc-windows-msvc',32)]:
 exe=out/f'probe-{width}.exe';log=out/f'probe-{width}.log';build=subprocess.run(['C:/Users/loicd/.cargo/bin/rustc.exe','--edition=2021','--target',target,'-C','debuginfo=0',str(probe),'-o',str(exe)],capture_output=True,text=True);log.write_text(build.stdout+build.stderr,encoding='utf-8');assert build.returncode==0,build.stderr;run=subprocess.run([str(exe)],capture_output=True,text=True);log.write_text(log.read_text()+run.stdout+run.stderr,encoding='utf-8');assert run.returncode==0,run.stdout+run.stderr;print(run.stdout.strip())
(r/'tools/probe_audio_crt_windows_process_heap.py').write_text(Path(__file__).read_text(encoding='utf-8-sig'),encoding='utf-8')
