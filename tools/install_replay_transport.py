from pathlib import Path
import datetime,json,shutil
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
backup=r/'docs/plan_history'/('replay-transport-source-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for name in ['lib.rs','audio_crt_windows_root_startup.rs']:
 p=r/'crates/core/src'/name;shutil.copy2(p,backup/name)
for name in ['audio_replay_transport_startup.rs','audio_replay_transport_startup_tests.rs','audio_replay_transport_thread_tests.rs']:shutil.copy2(s/name,r/'crates/core/src'/name)
for name in ['probe_replay_transport_threads.py','qualify_replay_transport_startup.py']:shutil.copy2(s/name,r/'tools'/name)
for name in ['replay_transport_thread_probe.json','replay_transport_startup_contract.json']:shutil.copy2(s/name,r/'data/4.20'/name)
p=r/'crates/core/src/lib.rs';v=p.read_text(encoding='utf-8');addition='pub mod audio_replay_transport_startup;';assert addition not in v;p.write_text(v+'\n'+addition+'\n',encoding='utf-8')
p=r/'crates/core/src/audio_crt_windows_root_startup.rs';v=p.read_text(encoding='utf-8');anchor='mod packet_failure_tests{';assert v.count(anchor)==1;v=v.replace(anchor,'mod replay_transport_thread_tests { include!("audio_replay_transport_thread_tests.rs"); }\n\n'+anchor);p.write_text(v,encoding='utf-8')
h=(r/'tools/replay-stream-tests.rs').read_text(encoding='utf-8');h+='\n#[path="E:/OpenLeague/crates/core/src/audio_replay_transport_startup.rs"] mod audio_replay_transport_startup;\n';(r/'tools/replay-transport-tests.rs').write_text(h,encoding='utf-8')
print(json.dumps({'installed':True,'source_backup':str(backup)}))
