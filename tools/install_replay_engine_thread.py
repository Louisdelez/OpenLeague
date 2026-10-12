from pathlib import Path
import datetime,json,shutil
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
lib=r/'crates/core/src/lib.rs';root=r/'crates/core/src/audio_crt_windows_root_startup.rs'
lt=lib.read_text(encoding='utf-8');rt=root.read_text(encoding='utf-8')
assert 'pub mod audio_replay_engine_thread;' not in lt
old='mod replay_transport_thread_tests { include!("audio_replay_transport_thread_tests.rs"); }'
assert old in rt
backup=r/'docs/plan_history'/('replay-engine-source-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for p in [lib,root]:shutil.copy2(p,backup/p.name)
for name in ['audio_replay_engine_thread.rs','audio_replay_engine_thread_tests.rs','audio_crt_windows_engine_worker.rs','audio_replay_engine_thread_windows_tests.rs']:
 assert not (r/'crates/core/src'/name).exists()
 shutil.copy2(s/name,r/'crates/core/src'/name)
lib.write_text(lt+'\npub mod audio_replay_engine_thread;\n#[cfg(windows)] pub mod audio_crt_windows_engine_worker;\n',encoding='utf-8')
root.write_text(rt.replace(old,old+'\nmod replay_engine_thread_windows_tests { include!("audio_replay_engine_thread_windows_tests.rs"); }'),encoding='utf-8')
h=(r/'tools/replay-launch-tests.rs').read_text(encoding='utf-8')+'\n#[path="E:/OpenLeague/crates/core/src/audio_replay_engine_thread.rs"] mod audio_replay_engine_thread;\n'
(r/'tools/replay-engine-tests.rs').write_text(h,encoding='utf-8')
shutil.copy2(s/'install_replay_engine_thread.py',r/'tools/install_replay_engine_thread.py')
print(json.dumps({'installed':True,'backup':str(backup)}))
