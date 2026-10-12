from pathlib import Path
import json,hashlib,re,subprocess,sys,datetime
OUT=Path(__file__).resolve().parent;ROOT=Path('E:/OpenLeague')
def stamp(p):
 d=p.read_bytes();return {'sha256':hashlib.sha256(d).hexdigest(),'bytes':len(d)}
harness=OUT/'loading_owner_harness.rs';dependencies=[Path(p) for p in re.findall(r'#\[path="([^"]+)"\]',harness.read_text(encoding='utf-8-sig'))]
before={str(p):stamp(p) for p in dependencies}
command=[str(Path.home()/'.cargo/bin/rustc.exe'),'--edition','2021','--test',str(harness),'-L','dependency='+str(ROOT/'target/debug/deps'),'--extern','serde_json='+str(ROOT/'target/debug/deps/libserde_json-06e1b1b57f0ae5f7.rlib'),'-o',str(OUT/'loading_owner_tests.exe')]
with (OUT/'compile.log').open('w',encoding='utf-8') as f:compiled=subprocess.run(command,stdout=f,stderr=subprocess.STDOUT,timeout=60)
assert compiled.returncode==0,(OUT/'compile.log').read_text(encoding='utf-8')
with (OUT/'tests.log').open('w',encoding='utf-8') as f:tested=subprocess.run([str(OUT/'loading_owner_tests.exe'),'audio_replay_loading_owner','--test-threads=1'],stdout=f,stderr=subprocess.STDOUT,timeout=60)
assert tested.returncode==0,(OUT/'tests.log').read_text(encoding='utf-8')
assert before=={str(p):stamp(p) for p in dependencies},'Dependency mutated during qualification'
sys.path.insert(0,str(ROOT/'tools/pythonlibs'));import pefile
source=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe')
raw=source.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862';image=pefile.PE(data=raw).get_memory_mapped_image()
proof=json.loads((OUT/'loading_owner_probe.json').read_text(encoding='utf-8'));assert proof['passed']
for region in proof['source_regions']:
 data=image[region['address']-0x400000:region['address']-0x400000+region['size']];assert data.hex()==region['hex'] and hashlib.sha256(data).hexdigest()==region['sha256']
regions=[]
for label,p,n in [('loading_control_vtables',0x1085e5c,32),('loading_language_literal',0x1088ab0,6),('loading_language_global',0x2d78d08,4),('loading_active_global',0x2d77e44,4)]:
 data=image[p-0x400000:p-0x400000+n];regions.append({'label':label,'kind':1,'address':p,'size':n,'hex':data.hex(),'sha256':hashlib.sha256(data).hexdigest()})
(OUT/'windows_adapter/runtime_image_additions.json').write_text(json.dumps({'source_sha256':digest,'production_integrated':False,'regions':regions,'existing_global_pair':{'address':0x14c761c,'size':8},'canonical_crt_flag':{'address':0x14ae870,'size':4,'must_not_duplicate_into_transport':True}},indent=2)+'\n',encoding='utf-8')
files={str(p.relative_to(OUT)):stamp(p) for p in sorted(OUT.rglob('*')) if p.is_file() and p.name not in ['qualification_manifest.json','loading_owner_tests.pdb']}
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'production_integrated':False,'production_files_changed':False,'cargo_run':False,'rust_compilation_run':True,'rust_tests_passed':2,'rust_tests_failed':0,'dependent_tests_filtered':74,'native_constructor_destructor_lifetimes':len(proof['cases']),'native_publication_cases':len(proof['publications']),'native_source_regions_independently_verified':len(proof['source_regions']),'native_sha256':digest,'windows_adapter_compiled':False,'windows_adapter_test_run':False,'command':command,'files':files,'compiled_dependencies':before}
(OUT/'qualification_manifest.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps({k:v for k,v in receipt.items() if k not in ['files','compiled_dependencies','command']}))
