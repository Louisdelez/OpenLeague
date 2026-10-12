from pathlib import Path
import json,hashlib,shutil,datetime
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
files={n:'crates/core/src/'+n for n in ['audio_replay_logger.rs','audio_replay_logger_tests.rs','audio_replay_recording_resource.rs','audio_replay_recording_resource_tests.rs','audio_replay_windows_recording.rs','audio_replay_windows_recording_tests.rs','audio_replay_windows_transport.rs','audio_replay_windows_application.rs','audio_replay_runtime_image.rs','lib.rs']}
files['main_replay_recording.rs']='crates/client/src/main.rs'
for n in ['replay_logger_composite_probe.json','replay_recording_file_probe.json']:files[n]='data/4.20/'+n;assert json.loads((s/n).read_text(encoding='utf-8'))['passed']
for n in ['replay_runtime_image.bin','replay_runtime_image_manifest.json']:files[n]='data/4.20/runtime/'+n
for n in ['probe_replay_logger_composite.py','probe_replay_recording_file.py','prepare_replay_logger_composite.py','prepare_replay_recording_tests.py','prepare_replay_windows_recording.py','prepare_replay_recording_client.py','extract_replay_runtime_image.py','install_replay_recording.py']:files[n]='tools/'+n
for n in ['replay-recording-tests.log','replay-recording-compile.log']:files[n]='logs/'+n
assert '49 passed; 0 failed' in(s/'replay-recording-tests.log').read_text(encoding='utf-8')
for n in files:assert (s/n).is_file(),n
backup=r/'docs/plan_history'/('replay-recording-source-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
inputs={}
for name,target in files.items():
 p=r/target
 if p.exists():
  old=backup/target;old.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,old);inputs[target]=hashlib.sha256(p.read_bytes()).hexdigest()
 else:inputs[target]=None
 shutil.copy2(s/name,p)
(backup/'input_hashes.json').write_text(json.dumps(inputs,indent=2),encoding='utf-8')
print('Installed native logger chain and diagnostic-file boundary. Backup: '+str(backup))
