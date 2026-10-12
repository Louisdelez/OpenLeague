from pathlib import Path
import subprocess,json,hashlib,datetime
r=Path('E:/OpenLeague');out=r/'tools/hardware/heap_mirror_retirement';out.mkdir(parents=True,exist_ok=True)
base=(r/'tools/hardware/process_heap/probe.rs').read_text().split('fn main(){')[0]
body=r'''
fn main(){use audio_crt_windows_process_heap::{Heap,Failure};
 let mut m=BTreeMap::from([(0x14ae87c,Memory{reference:0x14ae87c,raw:vec![0;4]}),(0x60000000,Memory{reference:0x60000000,raw:vec![2;4]})]);let mut d=BTreeSet::from([0x60000000]);let mut heap=Heap::new(0x71000000,0x50000000).unwrap();heap.initialize(&mut m,&d).unwrap();let report=heap.report();
 // Every completed callback batch releases its mirrors/tombstones, keeping
 // unrelated passive memory and dead metadata intact across repeated cycles.
 for cycle in 0..1024 {let mut refs=Vec::new();for size in [1,944,8192]{let a=heap.allocate(0x71000000,8,size,&mut m,&mut d).unwrap();m.get_mut(&a).unwrap().raw.fill(cycle as u8);refs.push(a);}for a in refs.iter(){heap.free(0x71000000,0,*a,&m,&mut d).unwrap();}assert_eq!(heap.retained_mirrors(),3);assert_eq!(heap.retire_mirrors(&mut m,&mut d).unwrap(),3);assert_eq!(heap.retained_mirrors(),0);assert_eq!(m.len(),2);assert_eq!(d,BTreeSet::from([0x60000000]));for a in refs {assert!(!m.contains_key(&a));assert!(heap.physical_bytes(a).is_err());}}
 let a=heap.allocate(0x71000000,8,16,&mut m,&mut d).unwrap();let b=heap.allocate(0x71000000,8,32,&mut m,&mut d).unwrap();heap.free(0x71000000,0,a,&m,&mut d).unwrap();heap.free(0x71000000,0,b,&m,&mut d).unwrap();
 // Batch preflight must not partially retire a valid earlier allocation.
 m.get_mut(&b).unwrap().raw.push(0);assert_eq!(heap.retire_mirrors(&mut m,&mut d),Err(Failure::RetirementConflict(b)));assert!(m.contains_key(&a)&&d.contains(&a));m.get_mut(&b).unwrap().raw.pop();
 d.remove(&b);assert!(heap.retire_mirrors(&mut m,&mut d).is_err());assert_eq!(heap.retained_mirrors(),2);d.insert(b);
 m.insert(b+1,Memory{reference:b+1,raw:vec![0;1]});assert!(heap.retire_mirrors(&mut m,&mut d).is_err());m.remove(&(b+1));
 assert!(heap.adopt(a,&m).is_err());assert_eq!(heap.retire_mirrors(&mut m,&mut d).unwrap(),2);assert_eq!(heap.retire_mirrors(&mut m,&mut d).unwrap(),0);
 // A live physical allocation remains reserved even when its mirror is absent.
 let reference=0x70000000;m.insert(reference,Memory{reference,raw:vec![0;48]});heap.adopt(reference,&m).unwrap();m.remove(&reference);assert_eq!(heap.retire_mirrors(&mut m,&mut d).unwrap(),0);assert_eq!(heap.outstanding(),1);assert_eq!(heap.physical_bytes(reference).unwrap().len(),48);drop(heap);
 assert_eq!(report.allocations(),3075);assert_eq!(report.frees(),3075);assert!(report.failures().is_empty());
 println!("PASS 1024 repeated 3-buffer retirement cycles; atomic conflicts, unrelated tombstones, live ownership, Drop; pointer_width={}",std::mem::size_of::<usize>()*8);
}
'''
probe=out/'probe.rs';probe.write_text(base+body,encoding='utf-8')
for target,width in [('x86_64-pc-windows-msvc',64),('i686-pc-windows-msvc',32)]:
 exe=out/f'probe-{width}.exe';log=out/f'probe-{width}.log';build=subprocess.run(['C:/Users/loicd/.cargo/bin/rustc.exe','--edition=2021','--target',target,'-C','debuginfo=0',str(probe),'-o',str(exe)],capture_output=True,text=True);log.write_text(build.stdout+build.stderr,encoding='utf-8');assert build.returncode==0,build.stderr;run=subprocess.run([str(exe)],capture_output=True,text=True);log.write_text(log.read_text()+run.stdout+run.stderr,encoding='utf-8');assert run.returncode==0,run.stdout+run.stderr;print(run.stdout.strip())
(r/'tools/probe_audio_heap_mirror_retirement.py').write_text(Path(__file__).read_text(),encoding='utf-8')
files=[r/'crates/core/src/audio_crt_windows_process_heap.rs',r/'tools/probe_audio_heap_mirror_retirement.py',probe]+list(out.glob('*.log'))+list(out.glob('*.exe'))
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'cycles_per_architecture':1024,'architectures':[32,64],'physical_allocations_per_architecture':3075,'physical_frees_per_architecture':3075,'limits':['Explicit post-callback retirement API; automatic normal-client worker retirement remains to be integrated.','Canonical map ownership contract forbids replacing owned entries before retirement; size, reference, overlap and dead-marker conflicts are checked.','Original root startup, secondary/custom locale ownership and normal physical audio playback remain incomplete.'],'files_sha256':{str(p.relative_to(r)).replace('\\','/'):hashlib.sha256(p.read_bytes()).hexdigest()for p in files}}
(r/'docs/audio_heap_mirror_retirement_validation.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
