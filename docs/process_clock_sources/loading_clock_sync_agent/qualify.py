from pathlib import Path
import subprocess,hashlib,json,datetime,sys,re
OUT=Path(__file__).resolve().parent;R=Path('E:/OpenLeague')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
tracked=['audio_clock_once.rs','audio_clock_once_tests.rs','clock_sync_harness.rs','clock_sync_probe.json','probe_clock_sync.py']
before={p:sha(OUT/p) for p in tracked}
command=[str(Path.home()/'.cargo/bin/rustc.exe'),'--edition','2021','--test',str(OUT/'clock_sync_harness.rs'),'-L','dependency='+str(R/'target/debug/deps'),'--extern','serde_json='+str(R/'target/debug/deps/libserde_json-06e1b1b57f0ae5f7.rlib'),'-o',str(OUT/'clock_sync_tests.exe')]
with (OUT/'compile.log').open('w',encoding='utf-8') as out:r=subprocess.run(command,stdout=out,stderr=subprocess.STDOUT,timeout=60)
assert r.returncode==0,(OUT/'compile.log').read_text(encoding='utf-8')
with (OUT/'tests.log').open('w',encoding='utf-8') as out:r=subprocess.run([str(OUT/'clock_sync_tests.exe'),'--test-threads=1'],stdout=out,stderr=subprocess.STDOUT,timeout=60)
assert r.returncode==0,(OUT/'tests.log').read_text(encoding='utf-8')
assert before=={p:sha(OUT/p) for p in tracked}
sys.path.insert(0,str(R/'tools/pythonlibs'));import pefile
proof=json.loads((OUT/'clock_sync_probe.json').read_text(encoding='utf-8'));source=Path(proof['source']);assert sha(source)==proof['native_sha256'];image=pefile.PE(str(source)).get_memory_mapped_image()
for row in proof['source_regions']:
 data=image[row['address']-0x400000:row['address']-0x400000+row['size']];assert data.hex()==row['hex'] and hashlib.sha256(data).hexdigest()==row['sha256']
summary={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'production_modified':False,'cargo_run':False,'rustc_command':command,'native_lifetimes':len(proof['cases']),'native_boundary_lifetimes':len(proof['boundary_cases']),'native_outer_cases':len(proof['outer_cases']),'native_allocation_cases':len(proof['allocation_cases']),'source_regions_independently_verified':len(proof['source_regions']),'rust_tests':5,'native_sha256':proof['native_sha256'],'files':{p.name:{'sha256':sha(p),'bytes':p.stat().st_size} for p in sorted(OUT.iterdir()) if p.is_file() and p.name!='qualification_manifest.json'},'limits':proof['limits']+['Rust tests compare the explicit inner-boundary oracle; they do not establish host ConCRT/FIFO/Win32 availability. Host Result rollback cases are distinct from native SEH.']}
(OUT/'qualification_manifest.json').write_text(json.dumps(summary,indent=2)+'\n',encoding='utf-8')
print(json.dumps({k:v for k,v in summary.items() if k not in ['files','limits','rustc_command']}))
