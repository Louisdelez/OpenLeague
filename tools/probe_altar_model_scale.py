from pathlib import Path
s=Path('E:/OpenLeague/tools/probe_native_grass_model_scale.py').read_text(encoding='utf-8')
s=s.replace('grass_model_bounds_contract.json','grass_altar_model_bounds_contract.json').replace('grass_model_bounds_mesh_scan_contract.json','grass_altar_model_bounds_mesh_scan_contract.json').replace('native_grass_model_bounds.json','native_grass_altar_model_bounds.json').replace('grass_model_scale_contract.json','grass_altar_model_scale_contract.json')
exec(compile(s,'native-altar-model-scale-probe','exec'))
