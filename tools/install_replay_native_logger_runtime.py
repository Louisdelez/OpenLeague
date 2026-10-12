from pathlib import Path
import datetime,shutil
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
backup=r/'docs/plan_history'/('replay-native-logger-runtime-source-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for source,target in [('audio_replay_windows_transport_logger.rs','audio_replay_windows_transport.rs'),('audio_replay_windows_transport_logger_tests.rs','audio_replay_windows_transport_tests.rs')]:
 p=r/'crates/core/src'/target;shutil.copy2(p,backup/target);shutil.copy2(s/source,p)
shutil.copy2(s/'install_replay_native_logger_runtime.py',r/'tools/install_replay_native_logger_runtime.py')
print('Installed native logger runtime ownership; backup:',backup)
