from pathlib import Path
import hashlib,json,itertools,datetime
from fractions import Fraction as F
r=Path('E:/OpenLeague')
s=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Shaders/HLSL')
files=['Environment/LIT_PS.ps_2_0','Environment/BAKED_ENV_PS.ps_2_0','SkinnedMesh/LIT_PROP_PS.ps_2_0','SkinnedMesh/LIT_PROP_LOW_PS.ps_2_0','SkinnedMesh/LIT_AND_WHITE_WITH_DEPTH_PS.ps_2_0','ParticleSystem/SIMPLE_PROJECTED_PS.ps_2_0','FogOfWar/FogOfWar_PS.hls']
manifest=[]
for name in files:
 src=s/name;dst=r/'data/4.20/shaders'/name;dst.parent.mkdir(parents=True,exist_ok=True);dst.write_bytes(src.read_bytes())
 lines=src.read_text().splitlines();manifest.append({'path':name,'source':str(src),'sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'fog_operations':[{'line':i+1,'text':line.strip()} for i,line in enumerate(lines) if any(t in line for t in ['GetFogOfWarFactors','lerp(fowFactors','fowFactors.rgb *=','out_color0.rgb *= fowFactors.a','float fogFarLerp','final fog blend'])]})
cases=[]
for mode,vis,h,a,tint in itertools.product(range(3),[F(0),F(1,4),F(1,2),F(1)],[F(0),F(1,2),F(1)],[F(92,255),F(1,2)],[F(0),F(2)]):
 overlay=[F(1,10),F(1,5),F(3,10),a];t=vis if mode==0 else vis*h if mode==1 else vis+(1-vis)*h
 tint_mix=min(F(1),max(F(0),vis*tint));edge=[F(1,5),F(7,100),F(3,50)]
 expected=[float(overlay[i]+(edge[i]-overlay[i])*tint_mix) for i in range(3)]+[float(a+(1-a)*t)]
 cases.append({'mode':mode,'visibility':float(vis),'height':float(h),'overlay':list(map(float,overlay)),'tint_reciprocal':float(tint),'expected':expected})
proof={'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'reference':'Exact rational arithmetic independently derived from archived original HLSL; original D3D execution not performed.','cases':cases,'sources':manifest,'order':{'projected':['sample diffuse and optional palette','base factors','multiply RGB by factors alpha, preserve diffuse alpha','death','mip visualization'],'lit_environment_high':['lighting/emissive','saturate','toward-fogged factors using c250','blend factors into RGB','optional grass','volumetric top fog blended with factors','far fog blend','death/mip'],'baked_environment':['diffuse','shadow','toward-clear factors using c251','premultiply factors RGB by diffuse alpha','blend factors into RGB','death/mip'],'skinned':['lighting/tint/alpha','base factors blend into RGB','optional height fog','death/mip']},'limits':['Material branch selection and c250 producer remain open.','Animated overlay and FOW_IGNORE_VISIBILITY variants not activated.','No full game or full original-renderer equivalence claim.']}
(r/'data/4.20/fow_factor_shader_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
helper='''// Literal port of FogOfWar_PS.hls, normal overlay UV and visibility branches.
// Edge sharpener is #if0 in the original; tint uses original visibility, not height-adjusted t.
fn native_fow_factors(overlay:vec4<f32>,vis:f32,height:f32,mode:u32,edge:vec4<f32>)->vec4<f32> {
 var t=vis;
 if mode==1u {t=vis*height;}
 if mode==2u {t=mix(vis,1.0,height);}
 let color=mix(overlay.rgb,vec3<f32>(0.2,0.07,0.06),clamp(vis*edge.z,0.0,1.0));
 return vec4<f32>(color,mix(overlay.a,1.0,t));
}
'''
(r/'assets/shaders/fow_factor_functions.wgsl').write_text(helper)
p=r/'crates/client/src/native_fow.rs';text=p.read_text();text+='''
/// Native normal-UV visibility branches: 0 base, 1 toward fogged, 2 toward clear.
/// Caller supplies sampled normalized texture values; no invented edge sharpening.
pub fn shader_factors(overlay:Vec4,vis:f32,height:f32,mode:u32,edge:Vec4)->Vec4 {
    let t=match mode {0=>vis,1=>vis*height,2=>vis+(1.-vis)*height,_=>panic!("unsupported native FoW factor branch")};
    let tint=(vis*edge.z).clamp(0.,1.);
    let color=overlay.truncate()+(Vec3::new(0.2,0.07,0.06)-overlay.truncate())*tint;
    color.extend(overlay.w+(1.-overlay.w)*t)
}
#[cfg(test)] mod factor_tests {
 use super::*;
 #[test] fn native_factor_modes_match_independent_rational_reference() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/fow_factor_shader_contract.json")).unwrap();
  assert_eq!(proof["cases"].as_array().unwrap().len(),144);
  for c in proof["cases"].as_array().unwrap() {
   let f=|k:&str|c[k].as_f64().unwrap() as f32;
   let a=c["overlay"].as_array().unwrap();let overlay=Vec4::from_array(std::array::from_fn(|i|a[i].as_f64().unwrap() as f32));
   let factors=shader_factors(overlay,f("visibility"),f("height"),c["mode"].as_u64().unwrap() as u32,Vec4::new(50.,-49.,f("tint_reciprocal"),0.));
   for(i,x) in factors.to_array().iter().enumerate() {assert!((*x-c["expected"][i].as_f64().unwrap() as f32).abs()<0.000001,"case {c}");}
  }
 }
}
''';p.write_text(text)
p=r/'crates/client/src/projected_render.rs';text=p.read_text().replace('AsBindGroup,Debug,Clone)]','AsBindGroup,Debug,Clone,Default)]');text=text.replace('    /// Scalar diagnostic visibility. A real native FOW texture binding is still required.\n    #[uniform(2)] pub fog_visibility:Vec4,','''    #[uniform(2)] pub visibility_params:Vec4,
    #[texture(3)] #[sampler(4)] pub visibility_map:Handle<Image>,
    #[texture(5)] #[sampler(6)] pub visibility_overlay:Handle<Image>,
    #[uniform(7)] pub visibility_edge:Vec4,
    #[uniform(8)] pub visibility_ready:u32,''');text=text.replace('fog_visibility:Vec4::ONE','..default()');p.write_text(text)
p=r/'crates/client/src/projected_live.rs';text=p.read_text().replace('fog_visibility:Vec4::ONE','..default()');p.write_text(text)
p=r/'crates/client/src/fow_visibility_texture.rs';text=p.read_text();text=text.replace('mut environment:ResMut<Assets<crate::map_fog::FogMaterial>>)','mut environment:ResMut<Assets<crate::map_fog::FogMaterial>>,assets:Res<AssetServer>,mut projected:ResMut<Assets<crate::projected_render::ProjectedMaterial>>)');needle='    let params=Vec4::new(native.x*20.,native.y*20.,native.z,native.w);';assert needle in text;text=text.replace(needle,needle+'''
    // Native catalog-qualified fallback overlay; original DDS conversion is pixel-equal.
    let overlay:Handle<Image>=assets.load("maps/terrain_native/DefaultFogOfWarOverlay.png");
    let ids:Vec<_>=projected.iter().filter(|(_,m)|m.visibility_map!=gpu.output || m.visibility_params!=params || m.visibility_edge!=edge || m.visibility_overlay!=overlay || m.visibility_ready!=1).map(|(id,_)|id).collect();
    for id in ids {let mut m=projected.get_mut(id).expect("existing projected material");m.visibility_map=gpu.output.clone();m.visibility_overlay=overlay.clone();m.visibility_params=params;m.visibility_edge=edge;m.visibility_ready=1;}
''');p.write_text(text)
(r/'assets/shaders/projected_terrain.wgsl').write_text('''// Base native alpha reference 0, native projected material blend/depth specialization.
#import bevy_pbr::forward_io::VertexOutput
@group(#{MATERIAL_BIND_GROUP}) @binding(0) var image:texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(1) var image_sampler:sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(2) var<uniform> visibility_params:vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(3) var visibility_map:texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(4) var visibility_sampler:sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(5) var visibility_overlay:texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(6) var overlay_sampler:sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(7) var<uniform> visibility_edge:vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(8) var<uniform> visibility_ready:u32;
fn display_to_linear(c:vec3<f32>)->vec3<f32> {
 return select(pow((c+vec3<f32>(0.055))/1.055,vec3<f32>(2.4)),c/12.92,c<=vec3<f32>(0.04045));
}
@fragment fn fragment(in:VertexOutput)->@location(0) vec4<f32> {
 let texel=textureSample(image,image_sampler,in.uv);
 var density=1.0;
 if visibility_ready==1u {
  let uv=in.world_position.xz*visibility_params.xy+visibility_params.zw;
  let vis=textureSample(visibility_map,visibility_sampler,uv).r;
  let overlay=textureSample(visibility_overlay,overlay_sampler,uv);
  density=native_fow_factors(overlay,vis,0.0,0u,visibility_edge).a;
 }
 // Native SIMPLE_PROJECTED_PS applies only the factor alpha to RGB; diffuse alpha survives.
 // Palette, death and mip visualization variants remain separate unfinished contracts.
 return vec4<f32>(display_to_linear(texel.rgb*density),texel.a);
}
\n'''+helper)
print(json.dumps({'factor_cases':len(cases),'native_sources':len(files),'projected_live_visibility_bound':True}))
