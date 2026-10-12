from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path(__file__).parent
shutil.copy2(stage/'native_hud_anchor.rs',r/'crates/client/src/native_hud_anchor.rs')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8')
if 'mod native_hud_anchor;' not in s:s='mod native_hud_anchor;\n'+s;p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Native Anchor96cases ported; pixel positioning remains open.')
