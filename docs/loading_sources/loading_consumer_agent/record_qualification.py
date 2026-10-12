from pathlib import Path
import json,hashlib,sys,datetime
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile
out=Path(__file__).resolve().parent
exe=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
raw=exe.read_bytes();sha=hashlib.sha256(raw).hexdigest()
assert sha=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase
sources=json.loads(Path('E:/mapslol3v3/replay_loading_record_probe/loading_record_sources.json').read_text())
for r in sources['regions']:
    assert pe.get_data(r['address']-base,r['size']).hex()==r['hex']
for role,address,size in [('string_destructor564900',0x564900,0x50),('service_global',0x2d787b8,4),('deallocator_callback',0x14bef40,8)]:
    data=pe.get_data(address-base,size)
    # Global BSS can be represented by zero-filled mapped bytes in the PE image.
    if len(data)!=size:data=pe.get_memory_mapped_image()[address-base:address-base+size]
    assert len(data)==size
    sources['regions'].append(dict(role=role,address=address,size=size,hex=data.hex(),sha256=hashlib.sha256(data).hexdigest()))
(out/'loading_consumer_sources.json').write_text(json.dumps(sources,indent=2)+'\n')
def entry(path):
    data=path.read_bytes();return dict(path=str(path),bytes=len(data),sha256=hashlib.sha256(data).hexdigest())
names=['audio_loading_screen_packet.rs','audio_loading_screen_packet_tests.rs','loading_consumer_harness.rs','probe_tutorial_first_name.py','tutorial_first_name_probe.json','probe_x87_copy.py','x87_copy_hardware.json','loading_consumer_sources.json','string_clock_source.txt','compile.log','tests.log','QUALIFICATION.md','record_qualification.py']
external=[Path('E:/mapslol3v3/replay_loading_record_probe/replay_loading_existing_record_probe.json'),Path('E:/mapslol3v3/replay_loading_record_probe/probe_existing_records.py'),Path('E:/mapslol3v3/loading_record_tree_agent/audio_loading_record_tree.rs'),Path('E:/mapslol3v3/loading_record_tree_agent/qualification_manifest.json')]
tutorial=json.loads((out/'tutorial_first_name_probe.json').read_text());hardware=json.loads((out/'x87_copy_hardware.json').read_text())
assert len(tutorial['cases'])==256 and sum(len(c['events']) for c in tutorial['cases'])==7136
assert len(hardware['cases'])==26
assert '4 passed; 0 failed' in (out/'tests.log').read_text()
receipt=dict(prepared_at_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,scope='Scratch generic loading-screen packet consumers; tutorial caller contract; standard UI explicitly unsupported',native_executable_sha256=sha,native_source_regions=len(sources['regions']),native_source_bytes=sum(r['size'] for r in sources['regions']),native_existing_record_calls=1600,native_tutorial_first_name_calls=256,native_tutorial_first_name_events=7136,physical_x87_cases=26,rust_tests_passed=4,rust_tests_failed=0,rust_tests_filtered=15,production_modified=False,windows_qualified=False,network_qualified=False,files=[entry(out/n) for n in names],external_dependencies=[entry(p) for p in external],limits=tutorial['limits']+['Standard first-record UI returns explicit unsupported error. No production/runtime/UI qualification.','Physical x87 helper is separate from PE caller execution; alternate FPU modes and status/exception flags are not ported.'])
(out/'qualification_manifest.json').write_text(json.dumps(receipt,indent=2)+'\n')
print(json.dumps({k:receipt[k] for k in ['passed','complete','native_source_regions','native_source_bytes','native_existing_record_calls','native_tutorial_first_name_calls','physical_x87_cases','rust_tests_passed']}))
