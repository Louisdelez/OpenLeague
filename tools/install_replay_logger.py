from pathlib import Path
import datetime,shutil
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3');lib=r/'crates/core/src/lib.rs'
assert 'pub mod audio_replay_logger;' not in lib.read_text()
backup=r/'docs/plan_history'/('replay-logger-source-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
shutil.copy2(lib,backup/lib.name)
for name in ['audio_replay_logger.rs','audio_replay_logger_tests.rs']:
 assert not (r/'crates/core/src'/name).exists();shutil.copy2(s/name,r/'crates/core/src'/name)
lib.write_text(lib.read_text()+'\npub mod audio_replay_logger;\n',encoding='utf-8')
for name in ['probe_replay_logger_format.py','check_replay_logger_probe.py','install_replay_logger.py']:shutil.copy2(s/name,r/'tools'/name)
shutil.copy2(s/'replay_logger_format_probe.json',r/'data/4.20/replay_logger_format_probe.json')
shutil.copy2(s/'replay-logger-format-probe.log',r/'logs/replay-logger-format-probe.log')
(r/'tools/replay-logger-tests.rs').write_text((r/'tools/replay-engine-tests.rs').read_text()+'\n#[path="E:/OpenLeague/crates/core/src/audio_replay_logger.rs"] mod audio_replay_logger;\n',encoding='utf-8')
print('Installed logger sources, native contract and isolated harness; backup:',backup)
