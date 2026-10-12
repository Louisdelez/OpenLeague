from pathlib import Path
import json
r=Path('E:/OpenLeague');report=json.loads((r/'docs/structure_spatial_geometry_matches.json').read_text());inventory=[]
for row in report['models']:
 if not row['config']:continue
 for i,match in enumerate(row['source_matches']):
  inventory.append(dict(kind='champion',status='exported',asset=row['name'].lower()+'__candidate_'+str(i),mesh=match['mesh'],source_config=row['config'],skin_scale=row['fields']['SkinScale']))
assert len({row['asset'].split('__candidate_')[0] for row in inventory})==12
s=(r/'tools/probe_native_grass_model_bounds.py').read_text(encoding='utf-8')
old="records=[];inventory=json.loads(Path('E:/mapslol3v3/output/Champions_4_20/import_inventory.json').read_text(encoding='utf-8'))"
new='records=[];inventory='+repr(inventory)
assert old in s;s=s.replace(old,new).replace('assert len(records)==122','assert len(records)=='+str(len(inventory)))
s=s.replace('grass_model_bounds_contract.json','grass_structure_model_bounds_contract.json').replace('native_grass_model_bounds.json','native_grass_structure_model_bounds_candidates.json').replace('122 base champion resources','12 intact structure model identities with all original position-equivalent source candidates')
exec(compile(s,'native-structure-model-box-probe','exec'))
proof=json.loads((r/'data/4.20/grass_structure_model_bounds_contract.json').read_text());catalog={}
for row in report['models']:
 if not row['config']:continue
 name=row['name'].lower();cases=[c for c in proof['cases'] if c['name'].startswith(name+'__candidate_')]
 assert len(cases)==len(row['source_matches']);assert len({tuple(c['provider_bounds_bits']) for c in cases})==1,(name,'ambiguous native model bounds')
 chosen=next((c for c in cases if Path(c['mesh']).parent.name.lower()==name),cases[0]);chosen=dict(chosen,name=name,equivalent_box_source_candidates=[c['mesh'] for c in cases],render_asset=row['render_asset'],render_sha256=row['render_sha256'],position_set_sha256=row['position_set_sha256'])
 catalog[name]=chosen
(r/'data/4.20/native_grass_structure_model_bounds.json').write_text(json.dumps(catalog,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(intact_structures=len(catalog),candidate_box_cases=len(proof['cases'])-5,all_candidate_boxes_equal=True)))
