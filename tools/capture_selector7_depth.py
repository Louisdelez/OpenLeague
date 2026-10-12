from pathlib import Path
import json,struct
source=Path('E:/mapslol3v3/capture_fow_vertex_normal.py').read_text(encoding='utf-8').replace('16019','16035').replace('fow-vertex-normal','selector7-depth').replace('fow_vertex_normal_runtime_capture','selector7_depth_runtime_capture').replace('-150.png','-165.png').replace('-150.json','-165.json')
source=source.replace("WGPU_BACKEND='vulkan',","WGPU_BACKEND='vulkan',OPENLEAGUE_ENVIRONMENT_FOW_PROBE=str(r/'logs/selector7-depth-environment.json'),OPENLEAGUE_SELECTOR7_DEPTH_PROBE=str(r/'logs/selector7-depth-phase.json'),")
exec(compile(source,__file__,'exec'))
r=Path('E:/OpenLeague');load=lambda p:json.loads((r/p).read_text(encoding='utf-8'))
p=r/'docs/selector7_depth_runtime_capture.json';d=json.loads(p.read_text(encoding='utf-8'));env=load('logs/selector7-depth-environment.json');phase=load('logs/selector7-depth-phase.json')
assert env['bound_meshes']==env['ready_materials']==2269 and env['native_blended_meshes']+env['native_opaque_meshes']==2269 and env['missing_sources']==0
assert phase['depth_phase_meshes']>0 and phase['depth_phase_meshes']==phase['ready_materials']==phase['depth_only_materials']==phase['blended_sources_alpha_disabled']
assert env['native_alpha_meshes']+phase['depth_phase_meshes']==2269 and phase['cached_materials']==6
bits=struct.unpack('<I',struct.pack('<f',229./255.))[0];assert phase['reference_bits']==[bits];assert d['actor_bindings']['native_draw_meshes']==0
d['environment_bindings']=env;d['depth_phase_bindings']=phase;p.write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print(json.dumps({'environment':env,'depth_phase':phase}))
