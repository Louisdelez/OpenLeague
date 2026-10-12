from pathlib import Path
import datetime,hashlib,json,shutil
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
for name,h in json.loads((s/'replay_opening_source_inputs.json').read_text()).items():assert hashlib.sha256((r/name).read_bytes()).hexdigest()==h,name
files={n:'crates/core/src/'+n for n in ['audio_replay_opening.rs','audio_replay_opening_tests.rs','audio_replay_shared_pair.rs','audio_replay_pair_move_tests.rs','audio_replay_stream_transport_tests.rs','audio_replay_transport_configuration_tests.rs','audio_replay_windows_opening.rs','audio_replay_windows_opening_tests.rs','audio_replay_windows_transport.rs','audio_replay_windows_configuration.rs','audio_replay_windows_application.rs','audio_replay_runtime_image.rs']}
files.update({'lib_replay_opening.rs':'crates/core/src/lib.rs','main_replay_opening.rs':'crates/client/src/main.rs','replay_opening_tables.json':'data/4.20/replay_opening_tables.json'})
for n in['replay_runtime_image.bin','replay_runtime_image_manifest.json']:files[n]='data/4.20/runtime/'+n
for n in['prepare_replay_opening.py','prepare_replay_windows_opening.py','prepare_replay_opening_client.py','install_replay_opening.py','extract_replay_runtime_image.py','extract_replay_opening_tables.py']:files[n]='tools/'+n
for n in['replay-opening-compile.log','replay-opening-tests.log']:files[n]='logs/'+n
backup=r/'docs/plan_history'/('replay-opening-source-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for source,target in files.items():
 p=r/target
 if p.exists():old=backup/target;old.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,old)
 shutil.copy2(s/source,p)
print('Installed stream opening and shared Windows ownership; backup: '+str(backup))
