from pathlib import Path
import shutil,json
r=Path('E:/OpenLeague');stage=Path(__file__).parent
for name in ['native_hud_anchor.rs','native_hud_property_text.rs']:shutil.copy2(stage/name,r/'crates/client/src'/name)
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8')
if 'mod native_hud_property_text;' not in s:s='mod native_hud_property_text;\n'+s;p.write_text(s,encoding='utf-8')
p=r/'data/4.20/native_hud_anchor_contract.json';d=json.loads(p.read_text());d.update(format=' %f , %f',storage_scope='Raw32-bit scanner output words in96boundary fixtures; not integer parser qualification.',adapters=['Formatted scanner32-bit output words and assignment count supplied; original floating parser grammar not qualified by these96cases.','Logger adapted; original partial-write preservation, successful copy and return branches execute.']);p.write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print('Native HUD property scanner1147cases ported; Anchor usesf32.')
