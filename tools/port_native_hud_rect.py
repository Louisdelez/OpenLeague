from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path(__file__).parent
shutil.copy2(stage/'native_hud_rect.rs',r/'crates/client/src/native_hud_rect.rs')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8')
s=s.replace('mod native_hud_uv;\n','')
if 'mod native_hud_rect;' not in s:s='mod native_hud_rect;\n'+s
p.write_text(s,encoding='utf-8')
obsolete=r/'crates/client/src/native_hud_uv.rs'
if obsolete.exists():obsolete.unlink()
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Native Rect arithmetic ported; layout integration remains open.')
