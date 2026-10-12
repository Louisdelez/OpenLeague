from pathlib import Path
import json
source=Path('E:/mapslol3v3/capture_fow_vertex_normal.py').read_text(encoding='utf-8')
source=source.replace('16019','16030').replace('fow-vertex-normal','native-environment-config-retry').replace('fow_vertex_normal_runtime_capture','native_environment_config_retry_runtime_capture').replace('-150.png','-157.png').replace('-150.json','-157.json')
source=source.replace("WGPU_BACKEND='vulkan',","WGPU_BACKEND='vulkan',OPENLEAGUE_ENVIRONMENT_FOW_PROBE=str(r/'logs/native-environment-config-retry-environment.json'),")
exec(compile(source,__file__,'exec'))
receipt=Path('E:/OpenLeague/docs/native_environment_config_retry_runtime_capture.json');data=json.loads(receipt.read_text(encoding='utf-8'));bindings=json.loads(Path('E:/OpenLeague/logs/native-environment-config-retry-environment.json').read_text(encoding='utf-8'));assert bindings['bound_meshes']==bindings['ready_materials'] and bindings['colormap_meshes']>0 and bindings['missing_sources']==0;data['environment_bindings']=bindings;data['capture_retry_reason']='Initial main-source edit decoded UTF8 as cp1252 and corrupted HUD accents; repaired source and installer to explicitUTF8, rebuilt and recaptured. Initial encoding-failure capture retained separately.';receipt.write_text(json.dumps(data,indent=2)+'\n',encoding='utf-8');print(json.dumps({'environment':bindings}))
