from pathlib import Path
import json
source=Path('E:/mapslol3v3/capture_fow_vertex_normal.py').read_text()
source=source.replace('16019','16028').replace('fow-vertex-normal','native-fog-lighting-uv').replace('fow_vertex_normal_runtime_capture','native_fog_lighting_uv_runtime_capture').replace('-150.png','-155.png').replace('-150.json','-155.json')
source=source.replace("WGPU_BACKEND='vulkan',","WGPU_BACKEND='vulkan',OPENLEAGUE_ENVIRONMENT_FOW_PROBE=str(r/'logs/native-fog-lighting-uv-environment.json'),")
exec(compile(source,__file__,'exec'))
receipt=Path('E:/OpenLeague/docs/native_fog_lighting_uv_runtime_capture.json');data=json.loads(receipt.read_text());bindings=json.loads(Path('E:/OpenLeague/logs/native-fog-lighting-uv-environment.json').read_text());assert bindings['bound_meshes']==bindings['ready_materials'] and bindings['colormap_meshes']>0 and bindings['missing_sources']==0;data['environment_bindings']=bindings;receipt.write_text(json.dumps(data,indent=2)+'\n');print(json.dumps({'environment':bindings}))
