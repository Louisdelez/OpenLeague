from pathlib import Path
s=Path('E:/OpenLeague/tools/probe_native_grass_model_bounds.py').read_text(encoding='utf-8')
old="records=[];inventory=json.loads(Path('E:/mapslol3v3/output/Champions_4_20/import_inventory.json').read_text(encoding='utf-8'))"
new="""records=[];audit=json.loads((r/'docs/world_spatial_source_audit.json').read_text(encoding='utf-8'))
inventory=[dict(kind='champion',status='exported',asset=row['name'],mesh=row['mesh_candidates'][0],source_config=row['config_candidates'][0]) for row in audit['models'] if row['ready_for_native_bounds_probe']]
assert len(inventory)==16
for row in inventory:
 properties=parser['ini'](Path(row['source_config']));row['skin_scale']=properties.get(parser['hashkey']('MeshSkin','SkinScale'))
"""
assert old in s;s=s.replace(old,new).replace('assert len(records)==122','assert len(records)==16')
s=s.replace('grass_model_bounds_contract.json','grass_world_model_bounds_contract.json').replace('native_grass_model_bounds.json','native_grass_world_model_bounds.json').replace('122 base champion resources','16 uniquely associated world/summon resources')
s=s.replace('Related forms/skins/NPC models and actual live actor lifecycle remain open.','Other world models/skins and actual NPC registration remain open.')
exec(compile(s,'native-world-model-box-probe','exec'))
