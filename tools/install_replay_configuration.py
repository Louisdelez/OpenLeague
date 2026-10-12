from pathlib import Path
import shutil,datetime,json
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3');lib=r/'crates/core/src/lib.rs';old=lib.read_text()
assert 'pub mod audio_replay_transport_configuration;' not in old
for name,count in [('replay_configuration_ownership_probe.json',32),('replay_transport_cleanup_probe.json',24)]:
 v=json.loads((s/name).read_text());assert v['passed'] and len(v.get('cases',v.get('queues')))==count
 assert v['native_sha256']=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
backup=r/'docs/plan_history'/('replay-configuration-source-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True);shutil.copy2(lib,backup/lib.name)
for name in ['audio_replay_transport_configuration.rs','audio_replay_transport_configuration_tests.rs']:
 assert not (r/'crates/core/src'/name).exists();shutil.copy2(s/name,r/'crates/core/src'/name)
lib.write_text(old+'\npub mod audio_replay_transport_configuration;\n',encoding='utf-8')
for name in ['probe_replay_configuration_ownership.py','probe_replay_transport_cleanup.py','install_replay_configuration.py']:shutil.copy2(s/name,r/'tools'/name)
for name in ['replay_configuration_ownership_probe.json','replay_transport_cleanup_probe.json']:shutil.copy2(s/name,r/'data/4.20'/name)
for name in ['replay-configuration-ownership-probe.log','replay-transport-cleanup-probe.log']:shutil.copy2(s/name,r/'logs'/name)
(r/'tools/replay-configuration-tests.rs').write_text((r/'tools/replay-address-tests.rs').read_text()+'\n#[path="E:/OpenLeague/crates/core/src/audio_replay_transport_configuration.rs"] mod audio_replay_transport_configuration;\n',encoding='utf-8')
print('Installed native configuration and cleanup port:',backup)
