from pathlib import Path
import datetime,hashlib,json,shutil
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
files={}
def add(base,name,target):files[base/name]=target
for n in ['audio_replay_windows_opening.rs','audio_replay_windows_transport.rs','audio_replay_windows_recording.rs','audio_replay_windows_recording_tests.rs','audio_replay_runtime_image.rs','lib.rs']:add(s,n,'crates/core/src/'+n)
for n in ['audio_replay_recording_resource.rs','audio_replay_recording_resource_tests.rs']:add(s/'replay_parent_agent',n,'crates/core/src/'+n)
for n in ['audio_replay_path_registry.rs','audio_replay_path_registry_tests.rs']:add(s/'replay_path_agent',n,'crates/core/src/'+n)
add(s,'main_replay_stream_recording.rs','crates/client/src/main.rs')
for n in ['replay_runtime_image.bin','replay_runtime_image_manifest.json']:add(s,n,'data/4.20/runtime/'+n)
for n in ['replay_parent_open_lifetime_probe.json','replay_recording_preparation_probe.json']:add(s/'replay_parent_agent',n,'data/4.20/'+n)
for n in ['replay_path_registry_probe.json','replay_path_registry_edges_probe.json']:add(s/'replay_path_agent',n,'data/4.20/'+n)
for n in ['probe_parent_order.py','probe_recording_preparation.py']:add(s/'replay_parent_agent',n,'tools/'+n)
for n in ['probe_replay_path_registry.py','probe_replay_path_registry_edges.py']:add(s/'replay_path_agent',n,'tools/'+n)
for n in ['prepare_replay_stream_recording_windows.py','prepare_replay_stream_recording_tests_client.py','extract_replay_runtime_image.py','install_replay_stream_recording.py']:add(s,n,'tools/'+n)
add(s/'replay_parent_agent','parent_order_report.md','docs/replay_parent_order_report.md')
add(s/'replay_parent_agent','replay-preparation-tests.log','logs/replay-preparation-tests.log')
add(s/'replay_path_agent','path_registry_tests.log','logs/replay-path-registry-tests.log')
add(s/'replay_parent_agent','probe_parent_order.log','logs/replay-parent-order-probe.log')
add(s/'replay_path_agent','replay_path_registry_tables.json','data/4.20/replay_path_registry_tables.json')
assert '6 passed; 0 failed' in (s/'replay_parent_agent/replay-preparation-tests.log').read_text(encoding='utf-8')
assert '3 passed; 0 failed' in (s/'replay_path_agent/path_registry_tests.log').read_text(encoding='utf-8')
for p,target in files.items():
 assert p.is_file(),p
 if target.endswith('_probe.json'):assert json.loads(p.read_text(encoding='utf-8'))['passed'],p
backup=r/'docs/plan_history'/('replay-stream-recording-source-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
hashes={}
for p,target in files.items():
 dest=r/target
 if dest.exists():
  old=backup/target;old.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(dest,old);hashes[target]=hashlib.sha256(dest.read_bytes()).hexdigest()
 else:hashes[target]=None
 dest.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,dest)
(backup/'input_hashes.json').write_text(json.dumps(hashes,indent=2),encoding='utf-8')
print(json.dumps({'installed':len(files),'backup':str(backup)}))
