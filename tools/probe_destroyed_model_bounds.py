from pathlib import Path
import json
r=Path('E:/OpenLeague');recovery=json.loads((r/'docs/map10_destroyed_asset_recovery.json').read_text());inventory=[]
for row in recovery['aliases']:
 source=recovery['models'][row['selected_model']];inventory.append(dict(kind='champion',status='exported',asset=row['alias'],mesh=source['mesh'],source_config=source['source_config'],skin_scale=source['skin_scale']))
assert len(inventory)==12;s=(r/'tools/probe_native_grass_model_bounds.py').read_text();old="records=[];inventory=json.loads(Path('E:/mapslol3v3/output/Champions_4_20/import_inventory.json').read_text(encoding='utf-8'))";assert old in s;s=s.replace(old,'records=[];inventory='+repr(inventory)).replace('assert len(records)==122','assert len(records)==12')
s=s.replace('grass_model_bounds_contract.json','grass_destroyed_model_bounds_contract.json').replace('native_grass_model_bounds.json','native_grass_destroyed_model_bounds.json').replace('122 base champion resources','12 Map10 destroyed aliases selecting4 recovered original resources')
exec(compile(s,'native-destroyed-model-box-probe','exec'))
