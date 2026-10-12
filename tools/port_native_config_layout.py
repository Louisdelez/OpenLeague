from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path(__file__).parent
for name in ['native_config_layout.rs','native_user_settings.rs']:shutil.copy2(stage/name,r/'crates/client/src'/name)
p=r/'crates/client/src/main.rs';text=p.read_text(encoding='utf-8')
if 'mod native_config_layout;' not in text:text='mod native_config_layout;\n'+text
anchor='    let mut quality=native_environment_draw::Quality::default();'
if 'Game.cfg layout_mode=' not in text:text=text.replace(anchor,'    eprintln!("Game.cfg layout_mode={} layout_scores={:?}",settings.layout_mode,settings.layout_scores);\n'+anchor,1)
p.write_text(text,encoding='utf-8')
for name in ['port_native_config_layout.py','native_config_layout.rs','native_user_settings.rs']:shutil.copy2(stage/name,r/'tools'/name)
print('Native classifier connected to startup; project root remains supplied by OpenLeague.')
