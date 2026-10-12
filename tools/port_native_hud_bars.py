from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');p=r/'crates/client/src/native_hud_bars.rs';assert not p.exists();shutil.copy2(stage/p.name,p)
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');assert 'mod native_hud_bars;' not in s;s='mod native_hud_bars;\n'+s;s=s.replace('.add_plugins(native_hud_portraits::Plugin)','.add_plugins(native_hud_portraits::Plugin)\n        .add_plugins(native_hud_bars::Plugin)');p.write_text(s,encoding='utf-8');print('Native HP/mana bar transport added; non-mana resource variants remain open')
