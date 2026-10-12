from pathlib import Path
import json,subprocess,hashlib
r=Path('E:/OpenLeague');out=r/'tools/hardware/fls_custom_locale_owned_heap';out.mkdir(parents=True,exist_ok=True)
p=json.loads((r/'data/4.20/audio_crt_custom_locale_lifecycle_preparation.json').read_text());files=[]
for i,row in enumerate(p['cases']):
 allocations=row['supplied_custom_allocations']+row['allocations'];owners={v['reference']:v['size']for v in allocations};lines=[]
 for kind,bank in [('I',row['before_detach']),('F',row['after_detach'])]:
  for v in p['regions']:
   a=v['reference'];raw=bytes.fromhex(bank[v['name']]);end=a+len(raw);cuts={a,end}
   for ref,size in owners.items():
    if a<ref<end:cuts.add(ref)
    if a<ref+size<end:cuts.add(ref+size)
   cuts=sorted(cuts)
   for first,last in zip(cuts,cuts[1:]):lines.append(f'{kind}\t{first:x}\t{raw[first-a:last-a].hex()}')
 lines.extend(f'O\t{a:x}\t'for a in owners)
 lines.extend(f'D\t{a:x}\t'for a in row['freed']if a)
 path=out/f'case_{i}.tsv';path.write_text('\n'.join(lines)+'\n');files.append(path)
s=(r/'tools/hardware/fls_optional_retirement/probe.rs').read_text().replace('0..126','0..16').replace('PASS252 real FLS optional-buffer cases','PASS32 real FLS custom-locale nested-allocation cases')
needle='assert_eq!(c.services.inner.heap.outstanding(),owners.len()-freed.len());'
extra='''for &a in &owners{if !freed.contains(&a){c.services.inner.heap.synchronize(a,&c.memory).unwrap();assert_eq!(c.services.inner.heap.physical_bytes(a).unwrap(),c.memory[&a].raw);}}'''
assert needle in s;s=s.replace(needle,needle+extra)
probe=out/'probe.rs';probe.write_text(s);files.append(probe)
for target,width in [('x86_64-pc-windows-msvc',64),('i686-pc-windows-msvc',32)]:
 exe=out/f'probe-{width}.exe';log=out/f'probe-{width}.log';build=subprocess.run(['C:/Users/loicd/.cargo/bin/rustc.exe','--edition=2021','--target',target,'-C','debuginfo=0',str(probe),'-o',str(exe)],capture_output=True,text=True);log.write_text(build.stdout+build.stderr);assert build.returncode==0,build.stderr;run=subprocess.run([str(exe),str(out)],capture_output=True,text=True);log.write_text(log.read_text()+run.stdout+run.stderr);assert run.returncode==0,run.stderr;print(run.stdout.strip());files.extend([exe,log])
(r/'tools/probe_audio_fls_custom_locale_owned_heap.py').write_text(Path(__file__).read_text(),encoding='utf-8')
files.extend([r/'tools/probe_audio_fls_custom_locale_owned_heap.py',r/'crates/core/src/audio_crt_windows_process_heap.rs',r/'crates/core/src/audio_crt_windows_shared_fls.rs',r/'crates/core/src/audio_crt_custom_locale_destructor.rs',r/'data/4.20/audio_crt_custom_locale_lifecycle_preparation.json'])
receipt={'passed':True,'complete':False,'cases':64,'cases_per_architecture':32,'architectures':[32,64],'limits':['Captured first context and supplied custom-locale allocations restored explicitly, with original default-locale references already released in the capture. Normal locale producer is not yet implemented.','Real FLS exit/close callbacks and real heap/locks exercise original nested destruction; custom time payload pointers in these16 native states are NULL.','Shared count2 retains custom locale buffers until explicit context teardown; automatic retirement only removes source-freed blocks.','Normal audio worker dispatch, dynamic lock allocations and full original startup remain incomplete.'],'files_sha256':{str(p.relative_to(r)):hashlib.sha256(p.read_bytes()).hexdigest()for p in files}}
(r/'docs/audio_fls_custom_locale_owned_heap_validation.json').write_text(json.dumps(receipt,indent=2)+'\n')
