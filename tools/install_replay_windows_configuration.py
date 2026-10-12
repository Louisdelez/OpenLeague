from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
files={
 'audio_replay_windows_transport.rs':'crates/core/src/audio_replay_windows_transport.rs',
 'audio_replay_windows_configuration.rs':'crates/core/src/audio_replay_windows_configuration.rs',
 'audio_replay_windows_configuration_tests.rs':'crates/core/src/audio_replay_windows_configuration_tests.rs',
 'audio_replay_runtime_image.rs':'crates/core/src/audio_replay_runtime_image.rs',
 'audio_replay_windows_application.rs':'crates/core/src/audio_replay_windows_application.rs',
 'main_replay_windows_configuration.rs':'crates/client/src/main.rs',
 'replay_runtime_image.bin':'data/4.20/runtime/replay_runtime_image.bin',
 'replay_runtime_image_manifest.json':'data/4.20/runtime/replay_runtime_image_manifest.json',
}
for name in ['extract_replay_runtime_image.py','prepare_replay_windows_configuration.py','prepare_replay_configuration_client.py','install_replay_windows_configuration.py']:files[name]='tools/'+name
assert not (r/'crates/core/src/audio_replay_windows_configuration.rs').exists()
backup=r/'docs/plan_history'/('replay-windows-configuration-source-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for source,target in files.items():
 p=r/target
 if p.exists():dest=backup/target;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,dest)
 shutil.copy2(s/source,p)
print('Installed Windows configuration ownership and client probe; originals backed up:',backup)
