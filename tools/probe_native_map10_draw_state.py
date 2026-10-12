from pathlib import Path
import json
source=Path('E:/mapslol3v3/probe_native_material_draw_state.py').read_text(encoding='utf-8')
profiles=json.loads(Path('E:/OpenLeague/data/4.20/map10_shader_material_fields.json').read_text(encoding='utf-8'))['gltf_materials_matched']
pairs=sorted({(p['type'],p['flags']) for p in profiles})
source=source.replace('itertools.product(range(16),range(5),range(16),[-1,0,1,2],range(16))','[(0,kind,flags,3,initial) for kind,flags in '+repr(pairs)+' for initial in range(16)]')
source=source.replace('data/4.20/material_draw_state_contract.json','data/4.20/map10_material_draw_state_contract.json').replace('This proof covers types0..4, flags0..15, selectors0..15, quality-1/0/1/2 and16initial state combinations; other values unqualified.','This proof covers all9actual Map10 type/flag combinations under selector0, native static quality3 and16initial state combinations; other runtime profiles unqualified.')
assert 'data/4.20/map10_material_draw_state_contract.json' in source
exec(compile(source,__file__,'exec'))
