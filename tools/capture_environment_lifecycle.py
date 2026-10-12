from pathlib import Path
import json
source=Path('E:/mapslol3v3/capture_fow_vertex_normal.py').read_text()
source=source.replace('16019','16023').replace('fow-vertex-normal','environment-lifecycle-normal').replace('fow_vertex_normal_runtime_capture','environment_lifecycle_runtime_capture').replace('-150.png','-152.png').replace('-150.json','-152.json')
source=source.replace("WGPU_BACKEND='vulkan',","WGPU_BACKEND='vulkan',OPENLEAGUE_ENVIRONMENT_FOW_PROBE=str(r/'logs/environment-lifecycle-bindings.json'),")
exec(compile(source,__file__,'exec'))
receipt=Path('E:/OpenLeague/docs/environment_lifecycle_runtime_capture.json');data=json.loads(receipt.read_text());bindings=json.loads(Path('E:/OpenLeague/logs/environment-lifecycle-bindings.json').read_text());assert bindings['bound_meshes']==bindings['ready_materials'] and bindings['bound_meshes']>0 and bindings['cached_materials']>0 and bindings['missing_sources']==0;data['environment_bindings']=bindings;receipt.write_text(json.dumps(data,indent=2)+'\n');print(json.dumps({'environment':bindings}))
