from pathlib import Path
import json,hashlib,datetime,shutil,sys
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
from PIL import Image
r=Path('E:/OpenLeague');source=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy')
original=source/'LEVELS/Map10/fogLightingMap.dds';converted=r/'assets/maps/terrain_native/fogLightingMap.png'
with Image.open(original) as a,Image.open(converted) as b:
    a=a.convert('RGBA');b=b.convert('RGBA');assert a.size==b.size and a.tobytes()==b.tobytes();dimensions=a.size;pixelhash=hashlib.sha256(a.tobytes()).hexdigest()
for path in ['Environment/LIT_VS.vs_2_0','Environment/LIT_PS.ps_2_0','FogOfWar/FogOfWar_VS.hls']:
    assert (r/'data/4.20/shaders'/path).read_bytes()==(source/'DATA/Shaders/HLSL'/path).read_bytes()
p=r/'crates/client/src/terrain_material.rs';s=p.read_text();assert 'fog_coordinates: Vec4' not in s
s=s.replace('    #[uniform(27)] terrain_transform: Vec4,','    #[uniform(27)] terrain_transform: Vec4,\n    #[uniform(28)] fog_coordinates: Vec4,')
s=s.replace('        20.,\n        0.,','        20.,\n        native_map_extent(),')
s=s.replace('            terrain_transform: map10_terrain_transform(),','            terrain_transform: map10_terrain_transform(),\n            fog_coordinates: native_map_fog_coordinates(),')
s=s.replace('// SCB max maps to UV1; GLB mirror origin stays15360 independently of SCB extent.','// Current main startup uses native SCB extent for the GLB root mirror origin.')
s=s.replace('let world_z = (15360. - extent) / 20.;','let world_z = (native_map_extent() - extent) / 20.;').replace('(15360. - world_z * 20.)','(native_map_extent() - world_z * 20.)')
s+='''
pub(crate) fn native_map_extent() -> f32 {
 crate::map10_vision_view::Map10VisionView::native_map10().expect("native Map10 geometry").geometry.extent
}
pub(crate) fn native_map_fog_coordinates() -> Vec4 {
 crate::native_fow::FogParams::from_native_extent(native_map_extent()).expect("qualified c230 Map10 bounds").params()
}
#[cfg(test)] mod native_world_texture_coordinates_tests {
 use super::*;
 #[test] fn map_root_inverse_and_fog_lighting_coordinates_follow_actual_startup_and_native_shader() {
  let extent=native_map_extent();let c230=native_map_fog_coordinates();let c233=map10_terrain_transform();
  let root=Transform::from_xyz(0.,0.,extent/20.).with_scale(Vec3::new(0.05,0.05,-0.05));
  for x in [0.,1.,4009.24,7699.3359375,15360.,extent] {
   for z in [0.,1.,4009.24,7699.3359375,15360.,extent] {
    let position=root.transform_point(Vec3::new(x,0.,z));
    let recovered=Vec2::new(position.x*20.,extent-position.z*20.);
    let actual_fog=recovered*c230.xy()+c230.zw();let expected_fog=Vec2::new(x,z)*c230.xy()+c230.zw();
    assert!((actual_fog-expected_fog).abs().max_element()<0.000001);
    let actual_terrain=recovered*c233.xy()+c233.zw();let expected_terrain=Vec2::new(x,z)*c233.xy()+c233.zw();
    assert!((actual_terrain-expected_terrain).abs().max_element()<0.000001);
   }
  }
  // Native fog texture flips Z; colormap does not. They must use separate UVs.
  assert_eq!(Vec2::ZERO*c230.xy()+c230.zw(),Vec2::new(0.,1.));
  assert_eq!(Vec2::ZERO*c233.xy()+c233.zw(),Vec2::ZERO);
  let settings:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map_fog_settings.json")).unwrap();
  assert_eq!((settings["native_z_mirror_origin"].as_f64().unwrap() as f32).to_bits(),extent.to_bits());
 }
}
''';p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/map_fog.rs';s=p.read_text();s=s.replace('    #[texture(118)] #[sampler(119)] pub colormap:Handle<Image>,','    #[texture(118)] #[sampler(119)] pub colormap:Handle<Image>,\n    #[uniform(120)] pub fog_coordinates:Vec4,');s=s.replace('        colormap_lighting_factor:0.,terrain_transform:', '        fog_coordinates:crate::terrain_material::native_map_fog_coordinates(),\n        colormap_lighting_factor:0.,terrain_transform:');s=s.replace('colormap:Handle::default()};','colormap:Handle::default(),fog_coordinates:Vec4::ZERO};');p.write_text(s,encoding='utf-8')
helper='\n// Native c230/c233 affine XZ mapping. Input recovered native world X/Z.\nfn native_map_uv(world_xz:vec2<f32>,coordinates:vec4<f32>)->vec2<f32> {\n return world_xz*coordinates.xy+coordinates.zw;\n}\n'
for name,uniform,coordinates in [('terrain_fow_vertex.wgsl',28,14),('environment_fow_vertex.wgsl',120,100)]:
 p=r/'assets/shaders'/name;s=p.read_text()
 if name.startswith('terrain_'):s=s.replace('struct NativeFowVertexOutput {','@group(#{MATERIAL_BIND_GROUP}) @binding(14) var<uniform> terrain_coordinates:vec4<f32>;\nstruct NativeFowVertexOutput {')
 s=s.replace('struct NativeFowVertexOutput {',f'@group(#{{MATERIAL_BIND_GROUP}}) @binding({uniform}) var<uniform> fog_coordinates:vec4<f32>;\nstruct NativeFowVertexOutput {{')
 s=s.replace('    @location(9) native_terrain_uv:vec2<f32>,','    @location(9) native_terrain_uv:vec2<f32>,\n    @location(10) native_fog_lighting_uv:vec2<f32>,')
 s=s.replace('vec2<f32>(out.world_position.x*20.0,15360.0-out.world_position.z*20.0)','vec2<f32>(out.world_position.x*terrain_coordinates.z,terrain_coordinates.w-out.world_position.z*terrain_coordinates.z)')
 s=s.replace('// Inverse of retained GLB root scale(.05,.05,-.05)/translation Z768.','// Inverse of current GLB root scale(.05,.05,-.05)/native SCB extent translation.')
 s=s.replace('    out.native_terrain_uv=native_xz*terrain_transform.xy+terrain_transform.zw;','    out.native_terrain_uv=native_map_uv(native_xz,terrain_transform);\n    out.native_fog_lighting_uv=native_map_uv(native_xz,fog_coordinates);')
 p.write_text(s+helper,encoding='utf-8')
p=r/'assets/shaders/terrain_height_blend.wgsl';s=p.read_text().replace('@location(9) terrain_uv:vec2<f32>)','@location(9) terrain_uv:vec2<f32>,@location(10) fog_uv:vec2<f32>)').replace('textureSample(fog_lighting,fog_sampler,in.uv_b)','textureSample(fog_lighting,fog_sampler,fog_uv)');p.write_text(s,encoding='utf-8')
p=r/'assets/shaders/native_environment_fog.wgsl';s=p.read_text().replace('@location(9) terrain_uv:vec2<f32>)','@location(9) terrain_uv:vec2<f32>,@location(10) fog_uv:vec2<f32>)').replace('    let native_xz=vec2<f32>(in.world_position.x*opaque.z,opaque.w-in.world_position.z*opaque.z);\n','').replace('textureSample(fog_lighting,fog_sampler,native_xz/denominator)','textureSample(fog_lighting,fog_sampler,fog_uv)');p.write_text(s,encoding='utf-8')
settings=json.loads((r/'data/4.20/map_fog_settings.json').read_text());settings['lighting_uv_policy']='Original LIT_VS fogOfWarTexCoords.xy -> LIT_PS FOGLIGHTING sampler9, c230 native X/Z with negative Z reciprocal and +1 offset. Current map root inverted using actual SCB extent.';settings['limits']=[x for x in settings['limits'] if 'FOG_OF_WAR_PARAMS c230 remains unqualified' not in x];settings['limits'].append('Current c230 shader UV branch qualified from native sources; exact D3D texture sampler, original framebuffer equivalence and all shader variants remain open.');(r/'data/4.20/map_fog_settings.json').write_text(json.dumps(settings,indent=2)+'\n',encoding='utf-8')
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'passed':True,'original_texture':str(original),'source_sha256':hashlib.sha256(original.read_bytes()).hexdigest(),'converted_sha256':hashlib.sha256(converted.read_bytes()).hexdigest(),'rgba_pixels_equal':True,'rgba_pixels_sha256':pixelhash,'dimensions':dimensions,'shader_chain':['FogOfWar_VS.hls FogOfWarTextureCoordinates native worldXZ*c230.xy+c230.zw','LIT_VS m_TexCoord4.xy=fogOfWarTexCoords.xy','LIT_PS fogColor=tex2D(FOGLIGHTING,m_TexCoord4.xy)'],'limits':['Qualified archived HLSL matches original files; native c230 producer verified in existing fow_params_contract. Full native framebuffer/device/sampler equivalence remains open.','Prior terrain vertex fixed15360root inverse corrected against actual current main startup native SCB extent; DECAL root inverse already used configured SCB extent.','Full vision coordinate alignment, dynamic gameplay camera, animated/morphed geometry and all renderer branches remain open.']};(r/'data/4.20/fog_lighting_uv_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2('E:/mapslol3v3/integrate_native_fog_lighting_uv.py',r/'tools/integrate_native_fog_lighting_uv.py');print(json.dumps({'native_texture_pixels_equal':True,'dimensions':dimensions,'fog_lighting_uv':'c230 from recovered native XZ'}))
