from pathlib import Path
import datetime,shutil,json
r=Path('E:/OpenLeague');archive=r/'docs/plan_history'/('native-high-fog-source-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
names=['crates/client/src/main.rs','crates/client/src/map_fog.rs','crates/client/src/terrain_material.rs','assets/shaders/environment_fow_vertex.wgsl','assets/shaders/terrain_fow_vertex.wgsl','assets/shaders/native_environment_fog.wgsl','assets/shaders/terrain_height_blend.wgsl']
def read(p):return (r/p).read_text(encoding='utf-8')
def save(p,s):(r/p).write_text(s,encoding='utf-8')
for p in names:shutil.copy2(r/p,archive/Path(p).name)
for name,start in [('map_fog',123),('terrain_material',30)]:
 p=f'crates/client/src/{name}.rs';s=read(p)
 marker='pub struct FogExtension {' if name=='map_fog' else 'pub struct TerrainMaterial {'
 fields=f'''\n    #[uniform({start})] pub high_fog0:Vec4,
    #[uniform({start+1})] pub high_fog1:Vec4,
    #[uniform({start+2})] pub cloud_phase:Vec4,
    #[texture({start+3})] #[sampler({start+4})] pub cloud_opacity:Handle<Image>,
    #[uniform({start+5})] pub fog_mod2x:u32,
'''
 assert marker in s;s=s.replace(marker,marker+fields,1)
 marker='opaque: Vec4::new(' if name=='map_fog' else 'scales,\n            terrain_transform:'
 init='''high_fog0:crate::native_high_fog::fog_vectors().0,
        high_fog1:crate::native_high_fog::fog_vectors().1,
        cloud_phase:Vec4::from_array(crate::native_cloud_phase::Phase::default().constants(2000.)),
        cloud_opacity:crate::native_high_fog::cloud_image(&assets),
        fog_mod2x:u32::from(native_settings.colormap),
        '''
 assert marker in s;s=s.replace(marker,init+marker,1);save(p,s)
for shader,start in [('environment_fow_vertex',123),('terrain_fow_vertex',30)]:
 p=f'assets/shaders/{shader}.wgsl';s=read(p)
 s=f'''@group(#{{MATERIAL_BIND_GROUP}}) @binding({start}) var<uniform> high_fog0:vec4<f32>;
@group(#{{MATERIAL_BIND_GROUP}}) @binding({start+1}) var<uniform> high_fog1:vec4<f32>;
@group(#{{MATERIAL_BIND_GROUP}}) @binding({start+2}) var<uniform> cloud_phase:vec4<f32>;
'''+s
 marker='    @location(10) native_fog_lighting_uv:vec2<f32>,';assert marker in s;s=s.replace(marker,marker+'\n    @location(11) native_high_fog:vec4<f32>,',1)
 marker='    return out;';assert s.count(marker)==1
 code='''    // Fog.hls: clamp radial/height at the vertex, preserve unclamped far layer.
    let screen=out.position.xy/out.position.w;
    let radial=clamp(1.0-dot(screen,screen),0.0,1.0)*high_fog0.z+high_fog0.w;
    let height=clamp(out.world_position.y*terrain_coordinates.z*high_fog0.x+high_fog0.y,0.0,1.0);
    let top=1.0-mix(high_fog1.x,1.0,max(height,radial));
    let far=out.world_position.y*terrain_coordinates.z*high_fog1.y+high_fog1.z;
    out.native_high_fog=vec4<f32>(top,far,native_xz*cloud_phase.xx+cloud_phase.yz);
'''
 s=s.replace(marker,code+marker);save(p,s)
for shader,start in [('native_environment_fog',123),('terrain_height_blend',30)]:
 p=f'assets/shaders/{shader}.wgsl';s=read(p)
 s=f'''@group(#{{MATERIAL_BIND_GROUP}}) @binding({start+3}) var cloud_opacity:texture_2d<f32>;
@group(#{{MATERIAL_BIND_GROUP}}) @binding({start+4}) var cloud_sampler:sampler;
@group(#{{MATERIAL_BIND_GROUP}}) @binding({start+5}) var<uniform> fog_mod2x:u32;
'''+s
 marker='@location(10) fog_uv:vec2<f32>)';assert marker in s;s=s.replace(marker,'@location(10) fog_uv:vec2<f32>,@location(11) high_fog:vec4<f32>)',1)
 marker='    if visibility_ready==1u {';assert s.count(marker)==1;s=s.replace(marker,'    var fog_factors=vec4<f32>(0.0,0.0,0.0,1.0);\n'+marker,1)
 marker='        let factors=native_fow_factors(';assert marker in s
 # Preserve actual factors for native top layer modulation.
 line=next(x for x in s.splitlines() if marker in x);s=s.replace(line,line+'\n        fog_factors=factors;',1)
 if shader=='native_environment_fog':
  a=s.index('    // Map10 native Fog.hls opaque layer');b=s.index('    out.color=main_pass_post_lighting_processing',a)
  code='''    let fog=textureSample(fog_lighting,fog_sampler,fog_uv).rgb;
    var top=high_fog.x;
    if fog_mod2x==1u {top=clamp(top*textureSample(colormap,colormap_sampler,terrain_uv).a*2.0,0.0,1.0);}
    top*=textureSample(cloud_opacity,cloud_sampler,high_fog.zw).r;
    let far=clamp(high_fog.y,0.0,1.0);
    let top_color=mix(fog_factors.rgb,fog,fog_factors.a);
    let amount=mix(top,1.0,far);
    let fog_color=mix(top_color,fog,far);
    out.color=vec4<f32>(to_linear(mix(to_display(out.color.rgb),fog_color,amount)),out.color.a);
'''
 else:
  a=s.index('    let fog_amount=');b=s.index('\n}',a)
  code='''    let fog=textureSample(fog_lighting,fog_sampler,fog_uv).rgb;
    var top=high_fog.x;
    if fog_mod2x==1u {top=clamp(top*textureSample(colormap,color_sampler,terrain_uv).a*2.0,0.0,1.0);}
    top*=textureSample(cloud_opacity,cloud_sampler,high_fog.zw).r;
    let far=clamp(high_fog.y,0.0,1.0);
    let top_color=mix(fog_factors.rgb,fog,fog_factors.a);
    return vec4<f32>(display_to_linear(mix(display,mix(top_color,fog,far),mix(top,1.0,far))),1.0);'''
 s=s[:a]+code+s[b:];save(p,s)
p='crates/client/src/main.rs';s=read(p);s='mod native_high_fog;\n'+s;s=s.replace('.init_resource::<map_fog::Cache>()','.init_resource::<map_fog::Cache>()\n        .init_resource::<native_high_fog::CloudState>()\n        .add_systems(Update,native_high_fog::advance.after(map_fog::bind).after(terrain_material::bind).before(render_probe::capture))',1);save(p,s)
save('crates/client/src/native_high_fog.rs','''//! Map10 native high-fog/cloud binding. Current profile uses PE initial fog quality2.
//! Bevy frame delta adapts the native clock; final settings dispatch remains unqualified.
use bevy::{prelude::*,image::{ImageLoaderSettings,ImageSampler,ImageSamplerDescriptor,ImageFilterMode,ImageAddressMode}};
#[derive(Resource,Default)] pub struct CloudState {phase:crate::native_cloud_phase::Phase}
pub fn fog_vectors()->(Vec4,Vec4) {
 let d:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map_fog_settings.json")).unwrap();
 let v=|key:&str|Vec4::from_array(std::array::from_fn(|i|d[key][i].as_f64().unwrap() as f32));(v("fog_data0"),v("fog_data1"))
}
pub fn cloud_image(assets:&AssetServer)->Handle<Image> {
 assets.load_builder().with_settings(|s:&mut ImageLoaderSettings| {
 s.is_srgb=false;s.sampler=ImageSampler::Descriptor(ImageSamplerDescriptor {address_mode_u:ImageAddressMode::Repeat,address_mode_v:ImageAddressMode::Repeat,mag_filter:ImageFilterMode::Linear,min_filter:ImageFilterMode::Linear,mipmap_filter:ImageFilterMode::Linear,..default()});
 }).load("maps/terrain_native/cloudOpacityMap.png")
}
pub fn advance(time:Res<Time>,mut state:ResMut<CloudState>,mut fog:ResMut<Assets<crate::map_fog::FogMaterial>>,mut terrain:ResMut<Assets<crate::terrain_material::TerrainMaterial>>,mut catalog:ResMut<crate::map_fog::FogCatalog>) {
 state.phase.advance(time.delta_secs(),time.delta_secs(),0.009999999776482582,0.009999999776482582);
 let constants=Vec4::from_array(state.phase.constants(2000.));catalog.extension.cloud_phase=constants;
 for (_,mut m) in fog.iter_mut() {m.extension.cloud_phase=constants;}
 for (_,mut m) in terrain.iter_mut() {m.cloud_phase=constants;}
}
''')
print(json.dumps(dict(source_changed=True,archive=str(archive),runtime_verified=False)))
