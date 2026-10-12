from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path(__file__).parent
shutil.copy2(stage/'native_hud_uv.rs',r/'crates/client/src/native_hud_uv.rs')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8')
if 'mod native_hud_uv;' not in s:s='mod native_hud_uv;\n'+s;p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('UV9A2590 ported with240native cases; layout remains open.')
