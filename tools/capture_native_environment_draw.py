from pathlib import Path
import json
source=Path('E:/mapslol3v3/capture_native_alpha_test.py').read_text(encoding='utf-8').replace('16031','16033').replace('native-alpha-test','native-environment-draw').replace('native_alpha_test','native_environment_draw').replace('-159','-163')
exec(compile(source,__file__,'exec'))
p=Path('E:/OpenLeague/docs/native_environment_draw_runtime_capture.json');d=json.loads(p.read_text(encoding='utf-8'));env=d['environment_bindings'];assert env['native_blended_meshes']>0 and env['native_opaque_meshes']>0 and env['native_blended_meshes']+env['native_opaque_meshes']==env['bound_meshes'];assert d['actor_bindings']['native_draw_meshes']==0
print(json.dumps({'native_blended_meshes':env['native_blended_meshes'],'native_opaque_meshes':env['native_opaque_meshes'],'actor_native_draw_meshes':d['actor_bindings']['native_draw_meshes']}))
