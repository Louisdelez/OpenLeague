from pathlib import Path
import json,itertools,hashlib,datetime,struct
r=Path('E:/OpenLeague');settings=json.loads((r/'data/4.20/map_fog_settings.json').read_text(encoding='utf-8'))
def f(x):return struct.unpack('<f',struct.pack('<f',x))[0]
def extract(name):
 source=(r/f'assets/shaders/{name}_fow_vertex.wgsl').read_text(encoding='utf-8')
 start=source.index('    // Fog.hls:');end=source.index('    return out;',start);body=source[start:end]
 return f'''fn {name}(p:Input)->vec4<f32> {{
 var out:Result;out.world_position=p.world;out.position=p.clip;
 let high_fog0=p.fog0;let high_fog1=p.fog1;let cloud_phase=p.phase;
 let terrain_coordinates=vec4<f32>(0.0,0.0,20.0,15398.671875);
 let native_xz=vec2<f32>(out.world_position.x*terrain_coordinates.z,terrain_coordinates.w-out.world_position.z*terrain_coordinates.z);
 {body}
 return out.native_high_fog;
}}'''
shader='''struct Input {world:vec4<f32>,fog0:vec4<f32>,fog1:vec4<f32>,clip:vec4<f32>,phase:vec4<f32>};
struct Result {world_position:vec4<f32>,position:vec4<f32>,native_high_fog:vec4<f32>};
@group(0) @binding(0) var<storage,read> inputs:array<Input>;
@group(0) @binding(1) var<storage,read_write> output:array<vec4<f32>>;
'''+extract('environment')+extract('terrain')+'''
@compute @workgroup_size(1) fn main(@builtin(global_invocation_id) i:vec3<u32>) {output[i.x*2u]=environment(inputs[i.x]);output[i.x*2u+1u]=terrain(inputs[i.x]);}
'''
(r/'logs/native-high-fog-vertex-probe.wgsl').write_text(shader,encoding='utf-8')
cases=[];d0=settings['fog_data0'];d1=settings['fog_data1'];phase_proof=json.loads((r/'data/4.20/native_cloud_phase_contract.json').read_text(encoding='utf-8'))
phases=[c['constants'] for c in phase_proof['cases'][::6]]
for y,clipxy,phase in itertools.product([-100.,0.,22.222299,100.,188.8889,300.],[(-1.,-1.),(0.,0.),(.5,.5),(1.,0.),(2.,2.)],phases):
 world=[f(618.9771484375),f(y/20),f(364.4970458984375),1.];clip=[*clipxy,0.,1.]
 radial=max(0.,min(1.,1.-clip[0]**2-clip[1]**2))*d0[2]+d0[3]
 height=max(0.,min(1.,world[1]*20*d0[0]+d0[1]));top=1.-(d1[0]+(1.-d1[0])*max(height,radial))
 far=world[1]*20*d1[1]+d1[2]
 uv=[world[0]*20*phase[0]+phase[1],(15398.671875-world[2]*20)*phase[0]+phase[2]]
 result=[top,far,*uv];cases.append(dict(inputs=world+d0+d1+clip+phase,expected=result+result))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,cases=cases,case_count=len(cases),
 production_shader_hashes={f'assets/shaders/{n}_fow_vertex.wgsl':hashlib.sha256((r/f'assets/shaders/{n}_fow_vertex.wgsl').read_bytes()).hexdigest() for n in ['environment','terrain']},
 original_fog_hlsl_sha256=hashlib.sha256((r/'data/4.20/shaders/Fog/Fog.hls').read_bytes()).hexdigest(),
 reference='Independent double-precision evaluation of original Fog.hls value/opaque layer and LIT_VS cloud mapping, using controlled native heights, clip coordinates and native phase fixtures.',
 limits=['Production vertex arithmetic bodies extracted into compute harness. Supplied world/clip positions bypass actual mesh transform and camera projection.',
 'Clamps at vertex verified; perspective interpolation/rasterization, original native clock and physical texture sampling remain unqualified.'])
(r/'data/4.20/native_high_fog_vertex_gpu_cases.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(vertex_cases=len(cases))))
