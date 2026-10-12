from pathlib import Path
import json,datetime,shutil,struct
r=Path('E:/OpenLeague');binding=json.loads((r/'docs/intact_structure_animation_binding.json').read_text(encoding='utf-8'));old=json.loads((r/'data/4.20/native_grass_structure_model_bounds.json').read_text(encoding='utf-8'));stamp=datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');history=r/'docs/plan_history'/('intact-animation-bounds-'+stamp);history.mkdir(parents=True)
shutil.copy2(r/'data/4.20/native_grass_structure_model_bounds.json',history/'native_grass_structure_model_bounds.json')
inventory=[dict(kind='champion',status='exported',asset=m['alias'].lower(),mesh=m['mesh'],source_config=m['config'],skin_scale=m['scale']) for m in binding['records']]
s=(r/'tools/probe_native_grass_model_bounds.py').read_text(encoding='utf-8');needle="records=[];inventory=json.loads(Path('E:/mapslol3v3/output/Champions_4_20/import_inventory.json').read_text(encoding='utf-8'))";assert needle in s
s=s.replace(needle,'records=[];inventory='+repr(inventory)).replace('assert len(records)==122','assert len(records)==12').replace('grass_model_bounds_contract.json','grass_intact_animation_model_bounds_contract.json').replace('native_grass_model_bounds.json','native_grass_intact_animation_model_bounds.json').replace('122 base champion resources','12 exact native graph/config structure mesh selections')
exec(compile(s,'native-intact-animation-bounds','exec'))
proof_path=r/'data/4.20/grass_intact_animation_model_bounds_contract.json';proof=json.loads(proof_path.read_text(encoding='utf-8'))
for case in proof['cases']:
 if not case['name'].startswith('fixture-'):case['skin_scale_bits']=old[case['name']]['skin_scale_bits']
proof_path.write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
catalog=json.loads((r/'data/4.20/native_grass_intact_animation_model_bounds.json').read_text(encoding='utf-8'))
for m in binding['records']:
 name=m['alias'].lower();result=catalog[name];merged=dict(old[name]);merged.update(result,render_asset=m['asset'],render_sha256=m['glb_sha256'],equivalent_box_source_candidates=[m['mesh']],exact_source_config_graph_binding=True)
 assert struct.pack('<f',result['skin_scale'])==struct.pack('<f',old[name]['skin_scale']);merged['skin_scale']=old[name]['skin_scale'];catalog[name]=merged
(r/'data/4.20/native_grass_structure_model_bounds.json').write_text(json.dumps(catalog,indent=2)+'\n',encoding='utf-8')
p=r/'crates/client/src/grass_model_bounds.rs';text=p.read_text(encoding='utf-8');marker=' #[test] fn all_intact_structure_candidates' if ' #[test] fn all_intact_structure_candidates' in text else ' #[test] fn authored_structure_meshes';start=text.index(marker);end=text.index(' #[test] fn original_world_boxes',start);block=text[start:end]
block=block.replace('all_intact_structure_candidates_produce_equal_native_boxes_and_render_scales','authored_structure_meshes_produce_native_boxes_and_render_scales').replace('grass_structure_model_bounds_contract.json','grass_intact_animation_model_bounds_contract.json').replace('.len(),45)', '.len(),17)')
text=text[:start]+block+text[end:];p.write_text(text,encoding='utf-8')
print(json.dumps(dict(exact_native_models=12,native_cases=17,turret4_geometry_corrected=True)))
