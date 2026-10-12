from pathlib import Path
import datetime,json,shutil
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
lib=r/'crates/core/src/lib.rs';root=r/'crates/core/src/audio_crt_windows_root_startup.rs';cargo=r/'crates/core/Cargo.toml'
lt=lib.read_text(encoding='utf-8');rt=root.read_text(encoding='utf-8');ct=cargo.read_text(encoding='utf-8')
assert 'pub mod audio_replay_windows_transport;' not in lt
assert not (r/'crates/core/build.rs').exists()
assert '[build-dependencies]' not in ct
old='mod replay_engine_thread_windows_tests { include!("audio_replay_engine_thread_windows_tests.rs"); }';assert old in rt
backup=r/'docs/plan_history'/('replay-shared-source-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for p in [lib,root,cargo,r/'Cargo.lock']:shutil.copy2(p,backup/p.name)
for name in ['audio_replay_windows_transport.rs','audio_replay_windows_transport_tests.rs','audio_windows_engine_thread_name.rs']:
 assert not (r/'crates/core/src'/name).exists();shutil.copy2(s/name,r/'crates/core/src'/name)
(r/'crates/core/native').mkdir(exist_ok=True)
shutil.copy2(s/'thread_name_seh.c',r/'crates/core/native/thread_name_seh.c');shutil.copy2(s/'openleague_core_build.rs',r/'crates/core/build.rs')
cargo.write_text(ct+'\n[build-dependencies]\ncc = "=1.4.6"\n',encoding='utf-8')
lib.write_text(lt+'\n#[cfg(windows)] pub mod audio_windows_engine_thread_name;\n#[cfg(windows)] pub mod audio_replay_windows_transport;\n',encoding='utf-8')
root.write_text(rt.replace(old,old+'\nmod replay_windows_transport_tests { include!("audio_replay_windows_transport_tests.rs"); }'),encoding='utf-8')
shutil.copy2(s/'qualify_replay_runtime_globals.py',r/'tools/qualify_replay_runtime_globals.py');shutil.copy2(s/'replay_runtime_globals.json',r/'data/4.20/replay_runtime_globals.json');shutil.copy2(s/'install_replay_shared_runtime.py',r/'tools/install_replay_shared_runtime.py')
print(json.dumps({'installed':True,'backup':str(backup)}))
