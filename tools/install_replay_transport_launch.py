from pathlib import Path
import datetime,json,shutil
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
p=r/'crates/core/src/lib.rs';text=p.read_text(encoding='utf-8');addition='pub mod audio_replay_transport_thread;';assert addition not in text
backup=r/'docs/plan_history'/('replay-launch-source-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for name in ['lib.rs','audio_replay_shared_pair.rs','audio_crt_windows_worker_thread.rs','audio_replay_transport_thread_tests.rs']:shutil.copy2(r/'crates/core/src'/name,backup/name)
for name in ['audio_replay_transport_thread.rs','audio_replay_transport_thread_tests_native.rs','audio_replay_shared_pair.rs','audio_crt_windows_worker_thread.rs','audio_replay_transport_thread_tests.rs']:shutil.copy2(s/name,r/'crates/core/src'/name)
for name in ['qualify_replay_thread_waits.py','qualify_replay_transport_launch.py']:shutil.copy2(s/name,r/'tools'/name)
for name in ['replay_thread_waits_contract.json','replay_transport_launch_contract.json']:shutil.copy2(s/name,r/'data/4.20'/name)
p.write_text(text+'\n'+addition+'\n',encoding='utf-8')
h=(r/'tools/replay-transport-tests.rs').read_text(encoding='utf-8')+'\n#[path="E:/OpenLeague/crates/core/src/audio_replay_transport_thread.rs"] mod audio_replay_transport_thread;\n';(r/'tools/replay-launch-tests.rs').write_text(h,encoding='utf-8')
print(json.dumps({'installed':True,'backup':str(backup)}))
