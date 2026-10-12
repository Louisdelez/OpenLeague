from pathlib import Path
import json,itertools,hashlib,datetime,shutil
r=Path('E:/OpenLeague')
env=(r/'assets/shaders/native_environment_fog.wgsl').read_text(encoding='utf-8')
terrain=(r/'assets/shaders/terrain_height_blend.wgsl').read_text(encoding='utf-8')
original=(r/'data/4.20/shaders/Environment/LIT_PS.ps_2_0').read_text(encoding='utf-8')
assert 'lerp( fragment.m_Color0, FOG_COLOR, fogOpacity )' in original
def extract(s,name):
 start=s.index('    if fog_profile.z==1u {') if name=='environment' else s.index('    if fog_profile.z==0u {')
 end=s.index('    out.color=main_pass_post_lighting_processing',start) if name=='environment' else s.index('\n}',start)
 code=s[start:end]
 for a,b in [('textureSample(fog_lighting,fog_sampler,fog_uv).rgb','p.fog.rgb'),('textureSample(colormap,colormap_sampler,terrain_uv).a','p.params.x'),('textureSample(colormap,color_sampler,terrain_uv).a','p.params.x'),('textureSample(cloud_opacity,cloud_sampler,high_fog.zw).r','p.params.y')]:code=code.replace(a,b)
 pre='let high_fog=p.high;let fog_factors=p.factors;let fog_mod2x=u32(p.params.z);let fog_profile=vec4<u32>(p.profile);let fog_constant=vec4<f32>(34.0/255.0,62.0/255.0,84.0/255.0,1.0);'
 if name=='environment':pre+='var out:Result;out.color=vec4<f32>(to_linear(p.world.rgb),p.world.a);';code+='return out.color;'
 else:pre+='let display=p.world.rgb;';code=code.replace('display_to_linear','to_linear')
 return f'fn {name}(p:Input)->vec4<f32> {{\n{pre}\n{code}\n}}'
convert=env[env.index('fn to_linear('):env.index('@group(#{MATERIAL_BIND_GROUP}) @binding(109)')]
shader='''struct Input {world:vec4<f32>,fog:vec4<f32>,factors:vec4<f32>,high:vec4<f32>,params:vec4<f32>,profile:vec4<f32>};
struct Result {color:vec4<f32>};
@group(0) @binding(0) var<storage,read> inputs:array<Input>;
@group(0) @binding(1) var<storage,read_write> output:array<vec4<f32>>;
'''+convert+extract(env,'environment')+extract(terrain,'terrain')+'''
@compute @workgroup_size(1) fn main(@builtin(global_invocation_id) i:vec3<u32>) {
 output[i.x*2u]=environment(inputs[i.x]);output[i.x*2u+1u]=terrain(inputs[i.x]);
}
'''
(r/'logs/native-fog-profile-probe.wgsl').write_text(shader,encoding='utf-8')
def linear(c):return c/12.92 if c<=.04045 else ((c+.055)/1.055)**2.4
def mix(a,b,t):return a+(b-a)*t
cases=[]
for top,far,cloud,alpha,mod2x,profile in itertools.product([0.,.5,1.],[-1.,.25,1.,2.],[0.,.2,1.],[0.,.25,1.],[0,1],[(1,0,1,0),(2,1,1,0),(2,0,1,0),(2,1,0,0)]):
 world=[.2,.6,.9,.42];fog=[.12,.24,.32,1.];factors=[.15,.07,.02,.3];t=max(0.,min(1.,far))
 if not profile[2]:display=world[:3]
 elif profile[0]==1:display=[mix(world[i],[34/255,62/255,84/255][i],t) for i in range(3)]
 else:
  opacity=max(0.,min(1.,top*alpha*2)) if mod2x else top
  if profile[1]:opacity*=cloud
  opacity=mix(opacity,1.,t);fogtop=[mix(factors[i],fog[i],.3) for i in range(3)]
  display=[mix(world[i],mix(fogtop[i],fog[i],t),opacity) for i in range(3)]
 rgb=[linear(x) for x in display]
 cases.append(dict(inputs=world+fog+factors+[top,far,0.,0.]+[alpha,cloud,float(mod2x),0.]+list(profile),expected=rgb+[world[3]]+rgb+[1.]))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,cases=cases,case_count=len(cases),production_shader_hashes={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in ['assets/shaders/native_environment_fog.wgsl','assets/shaders/terrain_height_blend.wgsl']},limits=['Production low/high/disabled fragment blocks extracted unchanged; texture sampling replaced by explicit fixtures.','Independent double-precision HLSL formula reference; complete texture/raster/frame/material-variant routing remains unqualified.','Environment level selection tested separately against 1408 original instruction fixtures; live user option retrieval/menu remains open.'])
(r/'data/4.20/native_fog_profile_gpu_cases.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),production_blocks_extracted=True)))
