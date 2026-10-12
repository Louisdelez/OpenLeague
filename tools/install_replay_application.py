from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3');lib=r/'crates/core/src/lib.rs'
text=lib.read_text();assert 'pub mod audio_replay_runtime_image;' not in text and 'pub mod audio_replay_windows_application;' not in text
backup=r/'docs/plan_history'/('replay-application-source-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True);shutil.copy2(lib,backup/lib.name)
for name in ['audio_replay_runtime_image.rs','audio_replay_windows_application.rs']:
 assert not (r/'crates/core/src'/name).exists();shutil.copy2(s/name,r/'crates/core/src'/name)
target=r/'data/4.20/runtime';target.mkdir(exist_ok=True)
for name in ['replay_runtime_image.bin','replay_runtime_image_manifest.json']:shutil.copy2(s/name,target/name)
for name in ['extract_replay_runtime_image.py','install_replay_application.py']:shutil.copy2(s/name,r/'tools'/name)
lib.write_text(text+'\npub mod audio_replay_runtime_image;\n#[cfg(windows)] pub mod audio_replay_windows_application;\n',encoding='utf-8')
print('Installed production initial image and application lifetime:',backup)
