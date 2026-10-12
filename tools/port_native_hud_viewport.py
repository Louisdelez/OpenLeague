from pathlib import Path
import shutil
r=Path('E:/OpenLeague');s=Path(__file__).parent
shutil.copy2(s/'native_hud_viewport.rs',r/'crates/client/src/native_hud_viewport.rs')
p=r/'crates/client/src/main.rs';text=p.read_text(encoding='utf-8')
if 'mod native_hud_viewport;' not in text:text='mod native_hud_viewport;\n'+text
if '.add_plugins(native_hud_viewport::Plugin)' not in text:text=text.replace('.add_plugins(native_hud_atlases::Plugin)','.add_plugins(native_hud_atlases::Plugin)\n        .add_plugins(native_hud_viewport::Plugin)')
p.write_text(text,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('HUD viewport runtime integrated; original full resize lifecycle still open')
