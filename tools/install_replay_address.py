from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3');lib=r/'crates/core/src/lib.rs';text=lib.read_text();assert 'pub mod audio_replay_address;' not in text
backup=r/'docs/plan_history'/('replay-address-source-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True);shutil.copy2(lib,backup/lib.name)
for name in ['audio_replay_address.rs','audio_replay_address_tests.rs']:assert not (r/'crates/core/src'/name).exists();shutil.copy2(s/name,r/'crates/core/src'/name)
lib.write_text(text+'\npub mod audio_replay_address;\n',encoding='utf-8')
for name in ['probe_replay_address.py','inspect_replay_configuration_data.py','install_replay_address.py']:shutil.copy2(s/name,r/'tools'/name)
shutil.copy2(s/'replay_address_probe.json',r/'data/4.20/replay_address_probe.json');shutil.copy2(s/'replay-address-probe.log',r/'logs/replay-address-probe.log')
(r/'tools/replay-address-tests.rs').write_text((r/'tools/replay-logger-tests.rs').read_text()+'\n#[path="E:/OpenLeague/crates/core/src/audio_replay_address.rs"] mod audio_replay_address;\n',encoding='utf-8')
print('Installed native address parser/UID and164-case contract:',backup)
