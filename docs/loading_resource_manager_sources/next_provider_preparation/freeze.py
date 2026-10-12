"""Verify read-only evidence and freeze this bounded preparation, not integration."""
from pathlib import Path
import sys, importlib.util, json, hashlib, datetime
sys.dont_write_bytecode=True
ROOT=Path(__file__).resolve().parent
FROZEN=Path('E:/OpenLeague/docs/loading_standard_resource_preparation')
spec=importlib.util.spec_from_file_location('source',FROZEN/'extract_resource.py')
src=importlib.util.module_from_spec(spec);spec.loader.exec_module(src)
EXPECTED='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
assert src.digest==EXPECTED
def record(path):
    b=path.read_bytes();return {'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}
source=json.loads((ROOT/'provider_source.json').read_text())
for region in source['regions']+source['data']:
    b=src.read(region['address'],region['size'])
    assert b.hex()==region['hex'] and hashlib.sha256(b).hexdigest()==region['sha256']
directory=json.loads((ROOT/'directory_lifecycle_oracle.json').read_text())
assert directory['passed'] and not directory['complete'] and len(directory['cases'])==4
assert all(c['all_owned_allocations_freed'] and len(c['allocations'])==len(c['frees'])==17 for c in directory['cases'])
blocked=json.loads((ROOT/'provider_probe_state.json').read_text())
assert not blocked['passed'] and blocked['stop']['import']['name']=='CreateDirectoryA'
assert blocked['open_find_handles']==0 and len(blocked['io_events'])==34
crt=json.loads((ROOT/'empty_context_provider_oracle.json').read_text())
assert not crt['passed'] and crt['pc']=='0xbb40e64e'
inventory=json.loads((ROOT/'asset_inventory.json').read_text())
assert len(inventory['files'])==31
for item in inventory['files']:
    actual=record(Path(item['path']));assert actual['sha256']==item['sha256'] and actual['bytes']==item['bytes']
dependencies=[FROZEN/'extract_resource.py',FROZEN/'probe_resource.py',FROZEN/'source_regions.json',
    FROZEN/'source_dependency_regions.json',FROZEN/'source_data_regions.json',
    Path('E:/OpenLeague/data/4.20/search_context_defaults_contract.json'),
    Path('E:/OpenLeague/crates/client/src/map_resource_provider.rs'),
    Path('E:/OpenLeague/crates/client/src/map10_native_config.rs')]
manifest={'schema':1,'frozen_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'kind':'native_resource_provider_bounded_preparation','integrated':False,'complete':False,
    'rust_compiled':False,'production_modified':False,'source_deployment_modified':False,
    'source_pe':{'path':str(src.EXE),'sha256':EXPECTED},
    'qualification':{'directory_lifetimes_passed':4,'directory_calls_passed':8,'default_context_provider_completed':False,
        'default_context_stop':'CreateDirectoryA before execution','empty_context_provider_completed':False,
        'empty_context_stop':'uninitialized native CRT execution at BB40E64E','asset_files_inspected':31,
        'native_ini_read_completed':False,'texture_rendering_completed':False},
    'regions_verified':len(source['regions'])+len(source['data']),
    'files':{p.name:record(p) for p in sorted(ROOT.iterdir()) if p.is_file() and p.name!='manifest.json'},
    'external_dependencies':{str(p):record(p) for p in dependencies}}
(ROOT/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(json.dumps({'files':len(manifest['files']),'regions':manifest['regions_verified'],'manifest':record(ROOT/'manifest.json')}))
