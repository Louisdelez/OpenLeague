from pathlib import Path
import shutil
r=Path('E:/OpenLeague');shutil.copy2(Path('E:/mapslol3v3/native_scalar_curve.rs'),r/'crates/core/src/native_scalar_curve.rs');p=r/'crates/core/src/lib.rs';s=p.read_text(encoding='utf-8')
if 'pub mod native_scalar_curve;' not in s:s=s.replace('pub mod camera_pan;','pub mod camera_pan;\npub mod native_scalar_curve;');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Installed native scalar curve core module')
