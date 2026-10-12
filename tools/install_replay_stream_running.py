from pathlib import Path
import json,hashlib,shutil,datetime
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
files={n:'crates/core/src/'+n for n in ['audio_replay_stream_running.rs','audio_replay_stream_running_tests.rs','audio_replay_stream_tests.rs','audio_replay_windows_opening.rs','audio_replay_windows_opening_tests.rs','audio_replay_windows_transport.rs','audio_replay_transport_thread.rs','audio_replay_runtime_image.rs','lib.rs']}
files['main_replay_running.rs']='crates/client/src/main.rs'
for n in ['replay_stream_start_stop_probe.json','replay_stream_running_contract.json']:files[n]='data/4.20/'+n
for n in ['replay_runtime_image.bin','replay_runtime_image_manifest.json']:files[n]='data/4.20/runtime/'+n
for n in ['probe_replay_stream_start_stop.py','probe_replay_stream_running_contract.py','extract_replay_runtime_image.py','prepare_replay_stream_running.py','prepare_replay_running_tests.py','prepare_replay_running_client.py','install_replay_stream_running.py']:files[n]='tools/'+n
for n in ['replay-running-compile.log','replay-running-tests.log']:files[n]='logs/'+n
for n in ['replay_stream_start_stop_probe.json','replay_stream_running_contract.json']:assert json.loads((s/n).read_text())['passed']
assert '47 passed; 0 failed' in(s/'replay-running-tests.log').read_text()
backup=r/'docs/plan_history'/('replay-stream-running-source-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for source in files:assert (s/source).is_file(),source
manifest={}
for source,target in files.items():
 p=r/target
 if p.exists():
  old=backup/target;old.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,old)
  manifest[target]=hashlib.sha256(p.read_bytes()).hexdigest()
 else:manifest[target]=None
 shutil.copy2(s/source,p)
# Standalone harness path must not be used by the production module.
p=r/'crates/core/src/audio_replay_transport_thread.rs'
p.write_text(p.read_text(encoding='utf-8').replace('"E:/OpenLeague/crates/core/src/audio_replay_transport_thread_tests_native.rs"','"audio_replay_transport_thread_tests_native.rs"'),encoding='utf-8')
(backup/'input_hashes.json').write_text(json.dumps(manifest,indent=2))
print('Installed source stream lifecycle and Windows integration. Backup: '+str(backup))
