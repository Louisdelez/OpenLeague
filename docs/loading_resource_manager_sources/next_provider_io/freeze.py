"""Pin the bounded IO preparation and exact failed/native evidence separately."""
from pathlib import Path
import sys,importlib.util,json,hashlib,datetime
sys.dont_write_bytecode=True
OUT=Path(__file__).resolve().parent
EXTRACT=Path('E:/OpenLeague/docs/loading_standard_resource_preparation/extract_resource.py')
spec=importlib.util.spec_from_file_location('src',EXTRACT);src=importlib.util.module_from_spec(spec);spec.loader.exec_module(src)
PE_HASH='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
assert src.digest==PE_HASH
def record(p):
    b=p.read_bytes();return {'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}
regions=[]
for role,address,size in [('native_path_create_and_followup_window',0x8b38cc,64),
    ('stopped_crt_dispatch_window',0xcabda8,64),('crt_caller_window',0xc99eeb,64)]:
    b=src.read(address,size);regions.append({'role':role,'address':address,'rva':address-src.BASE,'size':size,'hex':b.hex(),'sha256':hashlib.sha256(b).hexdigest()})
(OUT/'source_regions.json').write_text(json.dumps({'source':str(src.EXE),'source_sha256':PE_HASH,'regions':regions},indent=2)+'\n')
tests=json.loads((OUT/'io_isolation_tests.json').read_text());native=json.loads((OUT/'native_io_oracle.json').read_text());failed=json.loads((OUT/'native_io_uninitialized_crt.json').read_text())
assert tests['passed'] and tests['check_count']==36 and tests['open_handles']==0
assert tests['source_sha256_before']==tests['source_sha256_after']==record(Path(tests['source_file']))['sha256']
assert not native['passed'] and native['stop']['address']==0xcabda8 and native['open_host_handles_after_cleanup']==0
assert not failed['passed'] and failed['pc']=='0xbb40e64e'
creates=[e for e in native['io_events'] if e['api']=='CreateDirectoryA']
assert len(creates)==1 and creates[0]['result']==1
assert Path(creates[0]['physical_path']).resolve().is_relative_to(OUT.resolve())
names=['isolated_io.py','test_isolated_io.py','probe_native_io.py','io_isolation_tests.json',
    'native_io_oracle.json','native_io_uninitialized_crt.json','README.md','source_regions.json','freeze.py']
deps=[EXTRACT,Path('E:/mapslol3v3/loading_resource_provider_next/probe_provider.py'),
    Path('E:/mapslol3v3/loading_resource_provider_next/manifest.json'),
    Path('E:/OpenLeague/tools/probe_replay_stream_opening.py'),
    Path('E:/OpenLeague/tools/probe_replay_object_commands.py'),
    Path('E:/OpenLeague/tools/probe_native_audio_crt_thread_system_startup.py')]
manifest={'schema':1,'frozen_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'kind':'confined_native_provider_io_preparation','integrated':False,'complete':False,'rust_compiled':False,
    'source_pe':{'path':str(src.EXE),'sha256':PE_HASH},
    'qualification':{'bridge_checks_passed':36,'native_provider_complete':False,
        'explicit_stop':'CABDA8 before uninitialized CRT dispatch','earlier_error_preserved':'BB40E64E UcError',
        'scratch_config_profile':'initially absent; actual CreateDirectory returns1; original D Config remains present',
        'requires_no_concurrent_filesystem_mutation':True,'writable_junction_injection_tested':False,
        'writable_hardlink_injection_tested':False,'source_or_production_writes':False},
    'files':{n:record(OUT/n) for n in names},'external_dependencies':{str(p):record(p) for p in deps}}
(OUT/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(json.dumps({'files':len(names),'manifest':record(OUT/'manifest.json')}))
