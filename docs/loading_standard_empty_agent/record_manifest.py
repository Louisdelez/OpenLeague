from pathlib import Path
import json,hashlib,datetime,sys
OUT=Path(__file__).resolve().parent;ROOT=Path('E:/OpenLeague');sys.path.insert(0,str(ROOT/'tools/pythonlibs'))
import pefile
proof=json.loads((OUT/'standard_empty_name_probe.json').read_text());assert proof['passed'] and not proof['provider_or_resolver_result_simulated']
assert len(proof['cases'])==16 and sum(len(c['steps']) for c in proof['cases'])==64
assert sum(len(s['events']) for c in proof['cases'] for s in c['steps'])==1952
source=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
raw=source.read_bytes();sha=hashlib.sha256(raw).hexdigest();assert sha==proof['native_sha256'];pe=pefile.PE(data=raw);image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
inputs=[Path('E:/mapslol3v3/replay_loading_record_probe/loading_record_sources.json'),Path('E:/mapslol3v3/loading_metadata_stage/loading_metadata_sources.json'),Path('E:/mapslol3v3/loading_metadata_review/loading_resolver_composition_probe.json'),Path('E:/mapslol3v3/loading_record_tree_agent/loading_record_tree_sources.json')]
regions={}
for path in inputs:
    document=json.loads(path.read_text());entries=document.get('regions',document.get('source_regions',[]))
    for entry in entries:
        address=entry['address'];size=entry.get('size',entry.get('bytes'));data=image[address-base:address-base+size]
        assert data.hex()==entry['hex'] and hashlib.sha256(data).hexdigest()==entry['sha256']
        regions[(address,size)]=dict(address=address,size=size,hex=data.hex(),sha256=hashlib.sha256(data).hexdigest(),reference_source=str(path))
(OUT/'source_regions.json').write_text(json.dumps(dict(native_executable=str(source),native_sha256=sha,regions=list(regions.values())),indent=2)+'\n')
def stamp(p):
    data=p.read_bytes();return dict(path=str(p),bytes=len(data),sha256=hashlib.sha256(data).hexdigest())
files=[stamp(OUT/n) for n in ['probe_standard_empty.py','standard_empty_name_probe.json','native_result.json','native.log','README.md','source_regions.json','record_manifest.py']]
dependencies=inputs+[ROOT/'tools/probe_replay_metadata.py',ROOT/'tools/probe_replay_manager_initialization.py',ROOT/'tools/probe_replay_object_commands.py',ROOT/'tools/probe_whole_announcer_startup.py',Path('E:/mapslol3v3/loading_metadata_review/probe_resolve_composition.py')]
receipt=dict(saved_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,scope='Prepared native evidence for standard57D650 real empty-name branch only',native_executed=True,native_lifetimes=16,native_consumer_calls=64,ordered_events=1952,native_sha256=sha,provider_or_resolver_result_simulated=False,all_owned_allocations_released=True,ui_or_clock_entered=False,rust_port_created=False,windows_branch_connected=False,compiler_run=False,production_files_changed=False,source_regions=len(regions),source_bytes=sum(r['size'] for r in regions.values()),files=files,source_dependencies=[stamp(p) for p in dependencies],next_action='Separately port and qualify standard empty-name branch integration using the real metadata provider; keep full standard UI unsupported until its actual resource consumers and owners are connected.')
(OUT/'preparation_manifest.json').write_text(json.dumps(receipt,indent=2)+'\n');print(json.dumps({k:receipt[k] for k in ['passed','native_lifetimes','native_consumer_calls','ordered_events','rust_port_created','windows_branch_connected','source_regions','source_bytes']}))
