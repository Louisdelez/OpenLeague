from pathlib import Path
s=Path('E:/OpenLeague/tools/probe_native_grass_model_scale.py').read_text(encoding='utf-8')
s=s.replace('grass_model_bounds_contract.json','grass_structure_model_bounds_contract.json').replace('grass_model_bounds_mesh_scan_contract.json','grass_structure_model_bounds_mesh_scan_contract.json').replace('native_grass_model_bounds.json','native_grass_structure_model_bounds.json').replace('grass_model_scale_contract.json','grass_structure_model_scale_contract.json')
old=" if c['name'] in catalog:c.update(skin_scale_authored=catalog[c['name']]['skin_scale_authored'],skin_scale=catalog[c['name']]['skin_scale'],skin_scale_bits=catalog[c['name']]['skin_scale_bits'])"
new=" name=c['name'].split('__candidate_')[0]\n if name in catalog:c.update(skin_scale_authored=catalog[name]['skin_scale_authored'],skin_scale=catalog[name]['skin_scale'],skin_scale_bits=catalog[name]['skin_scale_bits'])"
assert old in s;s=s.replace(old,new)
exec(compile(s,'native-structure-model-scale-probe','exec'))
