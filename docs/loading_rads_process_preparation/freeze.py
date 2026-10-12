"""Freeze exact executed evidence; no native code, OS tests or production writes."""
from pathlib import Path
import sys,json,hashlib,datetime
sys.dont_write_bytecode=True
from verify_inputs import verify
OUT=Path(__file__).resolve().parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def data(name):return json.loads((OUT/name).read_text())
assert not (OUT/'manifest.json').exists(),'already frozen; use a new copy'
dependencies=verify()
for root,expected in [
 (Path('E:/mapslol3v3/loading_rads_native_probe'),'c3d545178f5f37a25bd331a8af4a6a6cf3b282ba0fa6d118e71594708762f3ea'),
 (Path('E:/mapslol3v3/loading_rads_commandline_review'),'a09060fecef18a5f4ad7b639cccf9bb349e762db451a6cc5374ed233e906250f')]:
    assert sha(root/'manifest.json')==expected
    dependencies[str(root/'manifest.json')]=expected
    for name,meta in json.loads((root/'manifest.json').read_text())['files'].items():
        p=root/name;assert sha(p)==meta['sha256'];dependencies[str(p)]=meta['sha256']
suite=data('adapter_checks.json');assert suite['passed'] and suite['checks']==300 and len(suite['runs'])==13
tests={}
for test in suite['runs']:
    report=data(test['report']);assert test['passed'] and report['passed'] and sha(OUT/test['report'])==test['report_sha256']
    tests[test['report']]=test['checks']
    for name,value in report.get('source_hashes',report.get('sources',{})).items():
        if (OUT/name).is_file():assert sha(OUT/name)==value,(test['report'],name)
oracles=[];common=None
for variant,name in [('empty','rads_provider_oracle.json'),('controlled','rads_provider_controlled_oracle.json')]:
    o=data(name)
    assert o['declared_environment_variant']==variant and o['stop']['import']['name']=='HeapReAlloc'
    assert o['stop']['args'][0]==0x71000000 and o['stop']['args'][1]==0 and o['stop']['args'][3]==256
    allocation=next(x for x in reversed(o['crt_events']) if x['api']=='HeapAlloc' and x['result']==o['stop']['args'][2])
    assert allocation['size']==128
    assert o['cleanup_passed'] and not o['provider_returned'] and not o['completed_path'] and not o['passed']
    assert o['rads_module']['state']=='attaching' and o['process_profile_retired']
    assert not any(o['crt_host_backing_after_cleanup'].values()) and o['sync_handles_after_cleanup']==0 and not o['sync_cleanup_errors']
    assert o['open_host_handles_after_cleanup']==0 and o['diagnostic_pipe_handles_after_cleanup']==0
    for key,value in o['generator_hashes'].items():assert sha(OUT/key)==value,(name,key)
    if common is None:common=o['generator_hashes']
    else:assert common==o['generator_hashes']
    profile=o['process_profile_at_end'];state=o['dll_process_state']
    assert profile['memory_unchanged'] and profile['environment_live_allocations']==0
    assert profile['host_argv_imported'] is False and profile['host_environment_imported'] is False
    assert state['argc']==1 and state['argv_sentinel']==0 and state['environment_acp_block']==0 and state['environment_initialized']==1
    assert len(state['environment_values_hex'])==(0 if variant=='empty' else 3)
    assert bytes.fromhex(state['argv_values_hex'][0])==(profile['value'][1:-1]+'\0').encode('ascii')
    assert [x['eax'] for x in o['dll_crt_returns']]==[0,0,0]
    calls=o['dll_initializer_calls'];c=[x for x in calls if x['kind']=='C'];cpp=[x for x in calls if x['kind']=='C++']
    assert len(c)==5 and all(x['returned'] and x['eax_after']==0 for x in c)
    assert len(cpp)==46 and sum(x['returned'] for x in cpp)==45 and not cpp[-1]['returned']
    assert not o['sync_events'] and not o['sync_handles_at_stop']
    source=o['native_slist']['source']
    for key in ['kernel','ntdll']:
        p=Path(source[key+'_path']);assert sha(p)==source[key+'_sha256'];dependencies[str(p)]=source[key+'_sha256']
    assert source['bytes']==19 and o['native_slist']['events']
    visited=set(o['executed_instruction_addresses'])
    assert 0x1003e210 not in visited and 0x1003e3d0 not in visited and 0x9529fa not in visited
    oracles.append({'profile':variant,'file':name,'sha256':sha(OUT/name),'stop':'HeapReAlloc','growth_bytes':[128,256],
       'native_addresses_before_cleanup':len(visited),'dll_addresses_before_cleanup':sum(0x10000000<=a<0x101ac000 for a in visited),
       'c_calls_returned':5,'cpp_calls_started':46,'cpp_calls_returned':45,'argc':1,'environment_entries':len(state['environment_values_hex']),
       'cleanup_passed':True,'emulated_remaining':o['emulated_live_count_after_host_cleanup'],'sync_creation_reached':False,
       'dll_attached':False,'module_handle_published':False,'rads_initialize_reached':False,
       'ini_entered':any(x['stage']=='entry' for x in o['ini_observations']),'ini_returned':any(x['stage']=='return' for x in o['ini_observations']),
       'provider_returned':False})
source_exe=data('rads_provider_oracle.json')['source'];source_exe_sha=data('rads_provider_oracle.json')['source_sha256']
source_dll=data('rads_provider_oracle.json')['rads_module']['source'];source_dll_sha=data('rads_provider_oracle.json')['rads_module']['sha256']
assert sha(Path(source_exe))==source_exe_sha and sha(Path(source_dll))==source_dll_sha
files={}
for p in sorted(list(OUT.glob('*.py'))+list(OUT.glob('*.json'))+list(OUT.glob('*.md'))+list((OUT/'attempts').glob('*.json'))):
    if p.name=='manifest.json':continue
    files[p.relative_to(OUT).as_posix()]={'sha256':sha(p),'bytes':p.stat().st_size}
manifest={'schema':1,'frozen_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'kind':'partial_original_x86_RADS_CRT_process_profile','integrated':False,'complete':False,'rust_compiled':False,
 'provider_complete':False,'dll_attached':False,'native_stop':'HeapReAlloc during atexit128to256 growth',
 'source_exe':source_exe,'source_exe_sha256':source_exe_sha,'source_dll':source_dll,'source_dll_sha256':source_dll_sha,
 'tests':tests,'test_checks':300,'static_adapter_checks':287,'windows_x86_leaf_checks':13,'windows_x86_leaf_profiles':3,
 'oracles':oracles,'common_generator_hashes':common,'files':files,
 'external_dependencies':{p:{'sha256':s} for p,s in sorted(dependencies.items())},
 'preserved_attempts':[p for p in files if p.startswith('attempts/')],
 'review_manifest_hash_note':'Physical CRLF audit manifest is a09060fe...; earlier communicated f08e3142... hashes its LF-normalized text, not the physical file. Reviewer confirmed unchanged source files and this reporting error before freezing.',
 'next_action':'Qualify a new fresh-copy guest reserve and exact real HeapReAlloc ownership/data/pointer-identity transitions; no approximation of same-address growth. Then finish the remaining native initializers and their synchronization/ETW boundaries.',
 'limits':['Neither normal game-process arguments/environment nor complete application startup is recreated.',
  '5 C and45 C++ calls returned;46th C++ interrupted. Not all68 C++ initializers completed.',
  'Sync handles qualified by isolated15checks only; not reached by final native provider traces.',
  'Terminal host hygiene is not native DLL detach/provider/CRT teardown;959/962 emulated blocks remain.',
  'Current Windows x86 SList leaf is separately pinned; it is not a full ntdll loader.',
  'Filesystem confinement assumes no concurrent external mutation; original frozen IO limitations remain.',
  'Historical reports reference their own prior source revisions; only the two final oracles match final generators.']}
(OUT/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(json.dumps({'files':len(files),'checks':300,'manifest_sha256':sha(OUT/'manifest.json'),'oracles':oracles}))
