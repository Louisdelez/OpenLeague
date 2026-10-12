from pathlib import Path
s=Path('E:/OpenLeague/tools/probe_native_grass_model_scale.py').read_text()
s=s.replace('grass_model_bounds_contract.json','grass_destroyed_model_bounds_contract.json').replace('grass_model_bounds_mesh_scan_contract.json','grass_destroyed_model_bounds_mesh_scan_contract.json').replace('native_grass_model_bounds.json','native_grass_destroyed_model_bounds.json').replace('grass_model_scale_contract.json','grass_destroyed_model_scale_contract.json')
exec(compile(s,'native-destroyed-model-scale-probe','exec'))
