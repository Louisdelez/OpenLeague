from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path(__file__).parent
shutil.copy2(stage/'native_hud_layout.rs',r/'crates/client/src/native_hud_layout.rs')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8')
if 'mod native_hud_layout;' not in s:s='mod native_hud_layout;\n'+s;p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Native HUD rectangle transform ported;576native cases.')
