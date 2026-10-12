"""Seal existing reports only. No probes, compiler or production changes."""
from pathlib import Path
import sys,json,hashlib,datetime
sys.dont_write_bytecode=True
from verify_inputs import verify
OUT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def data(n):return json.loads((OUT/n).read_text())
assert not (OUT/'manifest.json').exists()
deps=verify()
for directory,filename,pin in [
 ('loading_rads_commandline_probe','manifest.json','de3171f52c7387491f4be3883996bbee71209270f3f64293ae4679a85ba1c71c'),
 ('loading_rads_reallocation_preparation','preparation_manifest.json','e01c0e15e4c4d81ad6bf5d17b308def0d428ad51d4ee1327bb6208ad6ef0741f')]:
 root=OUT.parent/directory;p=root/filename;assert sha(p)==pin;deps[str(p)]=pin
 m=json.loads(p.read_text())
 for rel,meta in m['files'].items():
  q=root/rel;assert sha(q)==meta['sha256'];deps[str(q)]=meta['sha256']
 for rel,meta in m.get('external_dependencies',{}).items():
  q=Path(rel);assert sha(q)==meta['sha256'];deps[str(q)]=meta['sha256']
s=data('adapter_checks.json');assert s['passed'] and s['checks']==1034 and len(s['runs'])==17
assert sha(OUT/'run_checks.py')==s['generator_sha256']
tests={}
for t in s['runs']:
 r=data(t['report']);assert t['exit_code']==0 and t['passed'] and r['passed']
 assert sha(OUT/t['report'])==t['report_sha256']
 assert r.get('check_count',len(r.get('checks',[])))==t['checks']
 tests[t['report']]=t['checks']
 for n,v in r.get('source_hashes',r.get('sources',{})).items():
  if (OUT/n).is_file():assert sha(OUT/n)==v,(t['report'],n)
assert sum(tests.values())==1034
st=data('native_strlen_tail_tests.json')
assert (st['completed_original_strlen_invocations'],st['interrupted_original_strlen_invocations'],st['manual_invocation_context_setups'])==(68,3,2)
assert all(st['remaining'][k]==0 for k in ['raw_owners','mapped_regions','live_owners']) and not st['remaining']['interrupted'] and not st['cleanup_errors']
oracles=[];common=None
for variant,name,addresses,dll_addresses,rpm,returns,raw in [('empty','rads_provider_oracle.json',19167,5536,2,3,36),('controlled','rads_provider_controlled_oracle.json',19254,5624,7,12,39)]:
 o=data(name);assert o['declared_environment_variant']==variant
 assert o['stop']['import']['name']=='GetModuleHandleA' and o['stop']['import']['iat']==0x101311C4 and o['stop']['args'][0]==0x10176C64
 assert o['cleanup_passed'] and not any(o[k] for k in ['passed','complete','provider_returned','completed_path'])
 assert o['rads_module']['state']=='attaching' and o['process_profile_retired']
 assert not any(o['crt_host_backing_after_cleanup'].values())
 for k in ['sync_handles_after_cleanup','sync_cleanup_errors','crt_heap_mirror_cleanup_errors','open_host_handles_after_cleanup','diagnostic_pipe_handles_after_cleanup','unstarted_callbacks_at_end','interrupted_callbacks','crt_heap_bounds_events','sync_events']:assert not o[k],k
 before=o['crt_heap_mirrors_at_stop'];after=o['crt_heap_mirrors_after_cleanup']
 assert before['raw_owners']==raw and before['mapped_regions']==raw
 assert all(after[k]==0 for k in ['raw_owners','mapped_regions','live_owners']) and not after['interrupted']
 assert o['emulated_live_count_after_host_cleanup']==928
 growth=[e for e in o['crt_heap_mirror_events'] if e['operation']=='HeapReAlloc']
 assert len(growth)==1 and growth[0]['old_size']==128 and growth[0]['size']==256 and growth[0]['moved'] and growth[0]['phase']=='live'
 pol=o['native_strlen_tail'];reads=pol['physical_reads']
 assert len(reads)==rpm and all(r['success'] and not r['injected'] and r['requested']==r['transferred'] and 1<=r['requested']<=3 for r in reads)
 assert not pol['unretired_invocations'] and sum(e['kind']=='native_return' for e in pol['events'])==returns
 for n,v in o['generator_hashes'].items():assert sha(OUT/n)==v,(name,n)
 if common is None:common=o['generator_hashes']
 else:assert common==o['generator_hashes']
 assert len(common)==12
 p=o['process_profile_at_end'];state=o['dll_process_state']
 assert p['memory_unchanged'] and not p['environment_live_allocations'] and not p['host_argv_imported'] and not p['host_environment_imported']
 assert state['argc']==1 and state['argv_sentinel']==0 and state['environment_acp_block']==0 and state['environment_initialized']==1
 assert len(state['environment_values_hex'])==(0 if variant=='empty' else 3)
 assert [x['eax'] for x in o['dll_crt_returns']]==[0,0,0]
 c=[x for x in o['dll_initializer_calls'] if x['kind']=='C'];cpp=[x for x in o['dll_initializer_calls'] if x['kind']=='C++']
 assert len(c)==5 and all(x['returned'] and x['eax_after']==0 for x in c)
 assert len(cpp)==51 and sum(x['returned'] for x in cpp)==50 and not cpp[-1]['returned']
 visited=set(o['executed_instruction_addresses']);assert len(visited)==addresses and sum(0x10000000<=a<0x101AC000 for a in visited)==dll_addresses
 assert 0x1003e210 not in visited and 0x1003e3d0 not in visited and 0x9529fa not in visited
 oracles.append({'profile':variant,'file':name,'sha256':sha(OUT/name),'stop':'GetModuleHandleA','argument_ascii':'kernel32','argument_va':0x10176C64,'iat_va':0x101311C4,'native_addresses_before_cleanup':addresses,'dll_addresses_before_cleanup':dll_addresses,'actual_reallocation':growth[0],'c_calls_returned':5,'cpp_calls_started':51,'cpp_calls_returned':50,'rpm_observations':rpm,'native_strlen_returns':returns,'cleanup_passed':True,'crt_raw_at_stop':raw,'crt_mappings_at_stop':raw,'crt_raw_after_cleanup':0,'crt_mappings_after_cleanup':0,'emulated_engine_remaining':928,'dll_attached':False,'module_handle_published':False,'rads_initialize_reached':False,'sync_creation_reached':False,'ini_entered':any(x['stage']=='entry' for x in o['ini_observations']),'ini_returned':any(x['stage']=='return' for x in o['ini_observations']),'provider_returned':False})
o=data('rads_provider_oracle.json');exe=o['source'];dll=o['rads_module']['source']
assert sha(Path(exe))==o['source_sha256'] and sha(Path(dll))==o['rads_module']['sha256']
files={}
for p in sorted(list(OUT.glob('*.py'))+list(OUT.glob('*.json'))+list(OUT.glob('*.md'))+[p for p in (OUT/'attempts').rglob('*') if p.is_file()]):
 if p.name!='manifest.json':files[p.relative_to(OUT).as_posix()]={'sha256':sha(p),'bytes':p.stat().st_size}
m={'schema':1,'frozen_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'kind':'partial_original_x86_RADS_heap_reallocation','integrated':False,'complete':False,'rust_compiled':False,'provider_complete':False,'dll_attached':False,'native_stop':'GetModuleHandleA(kernel32) after real atexit128to256 growth','source_exe':exe,'source_exe_sha256':o['source_sha256'],'source_dll':dll,'source_dll_sha256':o['rads_module']['sha256'],'tests':tests,'test_checks':1034,'static_adapter_checks':667,'test_classification_note':'Inherited field static_adapter_checks means bounded adapter/ABI checks, including real OS calls and synthetic x86; not static-only.','windows_x86_leaf_checks':13,'windows_x86_leaf_profiles':3,'original_rads_strlen_checks':354,'original_rads_strlen_completed_invocations':68,'original_rads_strlen_interrupted_invocations':3,'manual_strlen_context_setups':2,'oracles':oracles,'common_generator_hashes':common,'files':files,'external_dependencies':{p:{'sha256':v} for p,v in sorted(deps.items())},'preserved_attempts':[p for p in files if p.startswith('attempts/')],'next_action':'Fresh copy: real borrowed GetModuleHandleA(kernel32) and A/W identity, without LoadLibrary/FreeLibrary expansion.','limits':['No Rust or complete DLL/provider integration.','Only flags0 HeapReAlloc; injected failures remain distinct from real observations.','Native strlen padding is actual current-process backing, not historical x86/x64 parity or extra logical capacity.','5 C and50 C++ returned;51st C++ interrupted.','Host hygiene retires CRT blocks/mappings, but928 engine allocations remain per emulator; no full native teardown.','Filesystem confinement assumes no concurrent external mutation; previous bridge limits remain.','Historical attempts have historical source revisions; final two profiles share12 final generator hashes.']}
(OUT/'manifest.json').write_bytes((json.dumps(m,indent=2)+'\n').encode())
print(json.dumps({'files':len(files),'dependencies':len(deps),'checks':1034,'manifest_sha256':sha(OUT/'manifest.json')}))
