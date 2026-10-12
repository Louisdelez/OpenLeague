from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
for name in ['native_hud_icon_material.rs','native_hud_panels.rs']:
 p=r/'crates/client/src'/name;assert not p.exists();shutil.copy2(stage/name,p)
p=r/'assets/shaders/native_hud_icon.wgsl';assert not p.exists();shutil.copy2(stage/p.name,p)
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');assert 'mod native_hud_panels;' not in s;s='mod native_hud_panels;\nmod native_hud_icon_material;\n'+s;s=s.replace('.add_plugins(native_hud_widgets::Plugin)','.add_plugins(native_hud_widgets::Plugin)\n        .add_plugins(native_hud_panels::Plugin)');p.write_text(s,encoding='utf-8')
print('Three native frames and Icon material installed')
