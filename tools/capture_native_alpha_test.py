from pathlib import Path
import json
source=Path('E:/mapslol3v3/capture_fow_vertex_normal.py').read_text(encoding='utf-8')
source=source.replace('16019','16031').replace('fow-vertex-normal','native-alpha-test').replace('fow_vertex_normal_runtime_capture','native_alpha_test_runtime_capture').replace('-150.png','-159.png').replace('-150.json','-159.json')
source=source.replace("WGPU_BACKEND='vulkan',","WGPU_BACKEND='vulkan',OPENLEAGUE_ENVIRONMENT_FOW_PROBE=str(r/'logs/native-alpha-test-environment.json'),")
exec(compile(source,__file__,'exec'))
receipt=Path('E:/OpenLeague/docs/native_alpha_test_runtime_capture.json');data=json.loads(receipt.read_text(encoding='utf-8'));bindings=json.loads(Path('E:/OpenLeague/logs/native-alpha-test-environment.json').read_text(encoding='utf-8'));assert bindings['bound_meshes']==bindings['ready_materials']==bindings['native_alpha_meshes'] and bindings['colormap_meshes']>0 and bindings['missing_sources']==0;assert bindings['alpha_reference_bits']==[998277249];assert data['actor_bindings']['native_alpha_meshes']==0;data['environment_bindings']=bindings;receipt.write_text(json.dumps(data,indent=2)+'\n',encoding='utf-8');print(json.dumps({'environment':bindings}))
