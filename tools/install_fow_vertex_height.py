from pathlib import Path
import json,hashlib
r=Path('E:/OpenLeague');b=Path('C:/Users/loicd/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/bevy_pbr-0.19.0/src/render')
helper='''// Native FogOfWar_VS.hls: clamp in vertex stage BEFORE perspective interpolation.
fn native_fow_vertex_height(world_y:f32,clear:vec4<f32>,below:vec4<f32>)->vec2<f32> {
 return vec2<f32>(clamp(world_y*clear.x+clear.y,0.0,1.0),clamp(world_y*below.z+below.w,0.0,1.0));
}
'''
(r/'assets/shaders/fow_vertex_height_functions.wgsl').write_text(helper,encoding='utf-8')
original=(b/'mesh.wgsl').read_text(encoding='utf-8');io=(b/'forward_io.wgsl').read_text(encoding='utf-8');out=io[io.index('struct VertexOutput {'):io.index('struct FragmentOutput {')].strip().replace('struct VertexOutput','struct NativeFowVertexOutput');out=out[:out.rfind('}')]+ '    @location(8) native_height_fades:vec2<f32>,\n}'
for name,clear,below in [('terrain_fow_vertex.wgsl',21,25),('environment_fow_vertex.wgsl',109,113)]:
 s=original[:original.index('@fragment')].replace('forward_io::{Vertex, VertexOutput},','forward_io::Vertex,').replace('-> VertexOutput','-> NativeFowVertexOutput').replace('var out: VertexOutput;','var out: NativeFowVertexOutput;')
 s=s.replace('    return out;', '    out.native_height_fades=native_fow_vertex_height(out.world_position.y*20.0,height_clear,height_below);\n    return out;')
 header=f'''// Bevy0.19 default mesh vertex path retained for skinning/morphs/normals/UVs/colors.
// Additional native height interpolant, shared by production terrain/environment consumers.
@group(#{{MATERIAL_BIND_GROUP}}) @binding({clear}) var<uniform> height_clear:vec4<f32>;
@group(#{{MATERIAL_BIND_GROUP}}) @binding({below}) var<uniform> height_below:vec4<f32>;
'''
 (r/'assets/shaders'/name).write_text(header+out+'\n'+s+'\n'+helper,encoding='utf-8')
for filename,trait,asset in [('terrain_material.rs','impl Material for TerrainMaterial {','terrain_fow_vertex.wgsl'),('map_fog.rs','impl MaterialExtension for FogExtension {','environment_fow_vertex.wgsl')]:
 p=r/'crates/client/src'/filename;s=p.read_text(encoding='utf-8');assert trait in s;s=s.replace(trait,trait+f'\n    fn vertex_shader()->ShaderRef {{ "shaders/{asset}".into() }}');p.write_text(s,encoding='utf-8')
p=r/'assets/shaders/terrain_height_blend.wgsl';s=p.read_text(encoding='utf-8');s=s.replace('@fragment fn fragment(in: VertexOutput)', '@fragment fn fragment(in: VertexOutput,@location(8) height_fades:vec2<f32>)');needle='        let height=clamp(in.world_position.y*20.0*visibility_below.z+visibility_below.w,0.0,1.0);\n';assert needle in s;s=s.replace(needle,'').replace('native_fow_factors(overlay,vis,height,1u,visibility_edge)','native_fow_factors(overlay,vis,height_fades.y,1u,visibility_edge)').replace('vec3<f32>(native.z,visibility_edge.x*0.5,native.y)','vec3<f32>(height_fades.x,visibility_edge.x*0.5,native.y)');p.write_text(s,encoding='utf-8')
p=r/'assets/shaders/native_environment_fog.wgsl';s=p.read_text(encoding='utf-8');s=s.replace('is_front: bool) -> FragmentOutput', 'is_front: bool,@location(8) height_fades:vec2<f32>) -> FragmentOutput');assert needle in s;s=s.replace(needle,'').replace('native_fow_factors(overlay,vis,height,factor_mode,visibility_edge)','native_fow_factors(overlay,vis,height_fades.y,factor_mode,visibility_edge)').replace('vec3<f32>(native.z,visibility_edge.x*0.5,native.y)','vec3<f32>(height_fades.x,visibility_edge.x*0.5,native.y)');p.write_text(s,encoding='utf-8')
receipt={'complete':False,'bevy_sources':{n:hashlib.sha256((b/n).read_bytes()).hexdigest() for n in ['mesh.wgsl','forward_io.wgsl']},'native_vertex_source_sha256':hashlib.sha256((r/'data/4.20/shaders/FogOfWar/FogOfWar_VS.hls').read_bytes()).hexdigest(),'limits':['Retained Bevy vertex transport; native height clamp and interpolation order copied. Original full renderer/morph/pose equivalence remains open.']}
(r/'docs/fow_vertex_transport_sources.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8');print('Native height clamp moved to vertex interpolant location8')
