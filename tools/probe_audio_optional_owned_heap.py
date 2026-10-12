from pathlib import Path
import json,subprocess,hashlib
r=Path('E:/OpenLeague');out=r/'tools/hardware/optional_owned_heap';out.mkdir(parents=True,exist_ok=True)
p=json.loads((r/'data/4.20/audio_crt_optional_thread_buffers_preparation.json').read_text());files=[]
for i,row in enumerate(p['cases']):
 lines=[]
 for kind,bank in [('I',row['before_detach']),('F',row['after'])]:
  for v in p['regions']:
   a=v['reference'];raw=bytes.fromhex(bank[v['name']])
   # The eight adjacent supplied buffers are eight owners, never one heap block.
   if a==0x40007000:
    for j in range(8):lines.append(f'{kind}\t{a+j*32:x}\t{raw[j*32:(j+1)*32].hex()}')
   else:lines.append(f'{kind}\t{a:x}\t{raw.hex()}')
 owners=[0x40012000]
 for j in range(7):
  if row['strings']=='all'or(row['strings']=='alternating'and j%2==0):owners.append(0x40007000+j*32)
 if row['exception']=='heap':owners.append(0x400070e0)
 if row['multibyte'].startswith('custom'):owners.append(0x40010000)
 lines.extend(f'O\t{a:x}\t'for a in owners)
 lines.extend(f'D\t{a:x}\t'for a in row['freed']if a)
 path=out/f'case_{i}.tsv';path.write_text('\n'.join(lines)+'\n');files.append(path)
s=(r/'tools/hardware/process_heap_contexts/probe.rs').read_text().split('fn main(){')[0]
s+=r'''
fn main(){use audio_crt_windows_process_heap::{Heap,Provider};use audio_crt_windows_critical_sections::{Bank as Locks,Provider as LockProvider};let directory=std::env::args().nth(1).unwrap();
 for i in 0..126{let text=std::fs::read_to_string(format!("{directory}/case_{i}.tsv")).unwrap();let mut m=BTreeMap::new();let mut expected=BTreeMap::new();let mut owners=Vec::new();let mut freed=BTreeSet::new();for line in text.lines(){let f=line.split('\t').collect::<Vec<_>>();let a=u32::from_str_radix(f[1],16).unwrap();match f[0]{"I"=>{m.insert(a,Memory{reference:a,raw:bytes(f[2])});},"F"=>{expected.insert(a,bytes(f[2]));},"O"=>owners.push(a),"D"=>{freed.insert(a);},_=>panic!("bad kind")}}
  m.insert(0x14ae87c,Memory{reference:0x14ae87c,raw:vec![0;4]});let mut d=BTreeSet::new();let mut heap=Heap::new(0x71000000,0x50000000).unwrap();heap.initialize(&mut m,&d).unwrap();for &a in &owners{heap.adopt(a,&m).unwrap();assert_eq!(heap.physical_bytes(a).unwrap(),m[&a].raw);}let report=heap.report();let mut locks=Locks::default();for j in 0..36{let a=0x1223580+j*8;let reference=audio_path_memory::read(&m,a,4).map(|v|u32::from_le_bytes(v.try_into().unwrap())).unwrap_or(0);if reference!=0&&locks.section(reference).is_err(){locks.initialize(reference,4000,Some(0)).unwrap();}}
  let mut services=LockProvider{inner:Provider{inner:Control,heap},locks};audio_crt_thread_destructor::destroy(&mut m,&mut d,0x40012000,&mut services).unwrap();assert_eq!(d,freed,"case {i} exact native freed owners");assert_eq!(report.frees()as usize,freed.len());for (&a,raw)in &expected{assert_eq!(audio_path_memory::read(&m,a,raw.len()).unwrap(),*raw,"case {i} native bytes {a:x}");}assert_eq!(services.inner.heap.retire_mirrors(&mut m,&mut d).unwrap(),freed.len());assert!(d.is_empty());for a in &owners{if freed.contains(a){assert!(!m.contains_key(a));}else{services.inner.heap.synchronize(*a,&m).unwrap();assert_eq!(services.inner.heap.physical_bytes(*a).unwrap(),m[a].raw);}}
  assert_eq!(services.inner.heap.outstanding(),owners.len()-freed.len());drop(services);assert_eq!(report.allocations(),report.frees());assert!(report.failures().is_empty());
 }println!("PASS126 native optional-buffer destruction cases: real individual heap owners/locks, exact final bytes/frees, retirement and surviving references; pointer_width={}",std::mem::size_of::<usize>()*8);
}
'''
probe=out/'probe.rs';probe.write_text(s);files.append(probe)
for target,width in [('x86_64-pc-windows-msvc',64),('i686-pc-windows-msvc',32)]:
 exe=out/f'probe-{width}.exe';log=out/f'probe-{width}.log';build=subprocess.run(['C:/Users/loicd/.cargo/bin/rustc.exe','--edition=2021','--target',target,'-C','debuginfo=0',str(probe),'-o',str(exe)],capture_output=True,text=True);log.write_text(build.stdout+build.stderr);assert build.returncode==0,build.stderr;run=subprocess.run([str(exe),str(out)],capture_output=True,text=True);log.write_text(log.read_text()+run.stdout+run.stderr);assert run.returncode==0,run.stderr;print(run.stdout.strip());files.extend([exe,log])
(r/'tools/probe_audio_optional_owned_heap.py').write_text(Path(__file__).read_text())
files.extend([r/'tools/probe_audio_optional_owned_heap.py',r/'crates/core/src/audio_crt_windows_process_heap.rs',r/'data/4.20/audio_crt_optional_thread_buffers_preparation.json'])
receipt={'passed':True,'complete':False,'cases':252,'cases_per_architecture':126,'architectures':[32,64],'limits':['Captured intermediate ownership states restored explicitly; normal optional-buffer constructors not yet implemented.','Source destructor directly invoked; optional-buffer OS FLS callback dispatch and normal audio workers remain unqualified.','Custom locales and dynamic locks remain to be connected.'],'files_sha256':{str(p.relative_to(r)):hashlib.sha256(p.read_bytes()).hexdigest()for p in files}}
(r/'docs/audio_optional_owned_heap_validation.json').write_text(json.dumps(receipt,indent=2)+'\n')
