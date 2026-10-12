from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
p=r/'crates/client/src/terrain_material.rs';s=p.read_text().replace('fn map10_terrain_transform() -> Vec4 {','pub(crate) fn map10_terrain_transform() -> Vec4 {');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/map_fog.rs';s=p.read_text();assert 'colormap_lighting_factor' not in s
s=s.replace('    #[uniform(115)] pub factor_mode:u32,','    #[uniform(115)] pub factor_mode:u32,\n    #[uniform(116)] pub colormap_lighting_factor:f32,\n    #[uniform(117)] pub terrain_transform:Vec4,\n    #[texture(118)] #[sampler(119)] pub colormap:Handle<Image>,')
s=s.replace('    vertex_factors: HashMap<String, f32>,','    vertex_factors: HashMap<String, f32>,\n    colormap_factors: HashMap<String, f32>,')
s=s.replace('        spatial_denominator: data[', '''        colormap_lighting_factor:0.,terrain_transform:crate::terrain_material::map10_terrain_transform(),
        colormap:crate::terrain_material::image(&assets,"maps/terrain_native/compositeColorMap.png".into(),false),
        spatial_denominator: data[''')
s=s.replace('        vertex_factors,\n    });','        vertex_factors,\n        colormap_factors:native_colormap_factors(),\n    });')
s=s.replace('                    extension: FogExtension {','                    extension: FogExtension {\n                        colormap_lighting_factor:catalog.colormap_factors.get(&name.0).copied().unwrap_or(0.),')
s=s.replace('factor_mode:1};','factor_mode:1,colormap_lighting_factor:4.,terrain_transform:Vec4::ZERO,colormap:Handle::default()};')
s=s.replace('vertex_factors:HashMap::new()}','vertex_factors:HashMap::new(),colormap_factors:HashMap::new()}')
s=s.replace('vertex_factors:HashMap::from([(name.clone(),8.)])}','vertex_factors:HashMap::from([(name.clone(),8.)]),colormap_factors:HashMap::new()}')
s=s.replace('assert_eq!(actual.extension.factor_mode,0);','assert_eq!(actual.extension.colormap_lighting_factor,0.);assert_eq!(actual.extension.factor_mode,0);')
s=s.replace(' let report=serde_json::json!({"complete":false,"bound_meshes":bound,',' let colormap_meshes=query.iter().filter(|h|materials.get(&h.0).is_some_and(|m|m.extension.colormap_lighting_factor==4.)).count();\n let report=serde_json::json!({"colormap_meshes":colormap_meshes,"complete":false,"bound_meshes":bound,')
s+='''
// Actual Map10 native selector0 DECAL variants; names mapped through NVR mesh references.
fn native_colormap_factors() -> HashMap<String,f32> {
 let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map10_shader_material_fields.json")).expect("native material fields");
 proof["gltf_materials_matched"].as_array().unwrap().iter().filter(|p| {
  let kind=p["type"].as_u64().unwrap();let flags=p["flags"].as_u64().unwrap();
  kind==1 || (kind==0 && flags&8!=0)
 }).map(|p|(p["name"].as_str().unwrap().to_owned(),4.)).collect()
}
#[cfg(test)] mod native_colormap_tests {
 use super::*;
 #[test] fn all_map10_colormap_routes_match_actual_original_selected_shader_and_empty_emissive_slot() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map10_shader_material_fields.json")).unwrap();
  let handles:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map10_texture_handle_fields.json")).unwrap();
  let factors=native_colormap_factors();assert_eq!(factors.len(),14);
  for binding in proof["gltf_materials_matched"].as_array().unwrap() {
   let index=binding["native_material_index"].as_u64().unwrap();
   let profile=proof["profiles"].as_array().unwrap().iter().find(|p|p["native_material_index"].as_u64()==Some(index)).unwrap();
   let selected=&profile["selector0"][0]["selected"];
   let decal=selected.as_array().unwrap().iter().any(|s|s["name"]=="Environment_LIT_NO_EMISSIVE_DECAL_PS");
   assert_eq!(factors.contains_key(binding["name"].as_str().unwrap()),decal);
   if decal {
    for source in handles["cases"].as_array().unwrap().iter().filter(|c|c["native_material_index"].as_u64()==Some(index)) {
     assert_eq!(source["source_texture_names"][1],"");assert_eq!(source["handle_presence"][1],false);
    }
   }
  }
 }
}
''';p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/actor_fow.rs';s=p.read_text().replace('extension.factor_mode=0;','extension.factor_mode=0;extension.colormap_lighting_factor=0.;');p.write_text(s,encoding='utf-8')
p=r/'assets/shaders/environment_fow_vertex.wgsl';s=p.read_text().replace('struct NativeFowVertexOutput {','@group(#{MATERIAL_BIND_GROUP}) @binding(100) var<uniform> terrain_coordinates:vec4<f32>;\n@group(#{MATERIAL_BIND_GROUP}) @binding(117) var<uniform> terrain_transform:vec4<f32>;\nstruct NativeFowVertexOutput {');s=s.replace('    @location(8) native_height_fades:vec2<f32>,','    @location(8) native_height_fades:vec2<f32>,\n    @location(9) native_terrain_uv:vec2<f32>,');s=s.replace('    return out;','    let native_xz=vec2<f32>(out.world_position.x*terrain_coordinates.z,terrain_coordinates.w-out.world_position.z*terrain_coordinates.z);\n    out.native_terrain_uv=native_xz*terrain_transform.xy+terrain_transform.zw;\n    return out;');p.write_text(s,encoding='utf-8')
p=r/'assets/shaders/native_environment_fog.wgsl';s=p.read_text().replace('@fragment fn fragment(', '@group(#{MATERIAL_BIND_GROUP}) @binding(116) var<uniform> colormap_lighting_factor:f32;\n@group(#{MATERIAL_BIND_GROUP}) @binding(118) var colormap:texture_2d<f32>;\n@group(#{MATERIAL_BIND_GROUP}) @binding(119) var colormap_sampler:sampler;\n@fragment fn fragment(');s=s.replace('@location(8) height_fades:vec2<f32>)','@location(8) height_fades:vec2<f32>,@location(9) terrain_uv:vec2<f32>)');s=s.replace('    var input=pbr_input_from_standard_material', '''#ifdef VERTEX_COLORS
    // Native DECAL shader reads texture alpha and colormap, not control vertex colors.
    if colormap_lighting_factor>0.0 {base_in.color=vec4<f32>(1.0);}
#endif
    var input=pbr_input_from_standard_material''');s=s.replace('    if visibility_ready==1u {','''    if colormap_lighting_factor>0.0 {
        let light=textureSample(colormap,colormap_sampler,terrain_uv).rgb;
        let native=native_decal_lighting(vec4<f32>(to_display(input.material.base_color.rgb),input.material.base_color.a),light,colormap_lighting_factor);
        out.color=vec4<f32>(to_linear(native.rgb),native.a);
    }
    if visibility_ready==1u {''');s+='\n// Native MOD2X_COLORMAP + DECAL + DISABLE_SHADOWS, no emissive handle.\nfn native_decal_lighting(diffuse:vec4<f32>,light:vec3<f32>,factor:f32)->vec4<f32> {\n return vec4<f32>(clamp(diffuse.rgb*(light*factor),vec3<f32>(0.0),vec3<f32>(1.0)),diffuse.a);\n}\n';p.write_text(s,encoding='utf-8')
shutil.copy2('E:/mapslol3v3/integrate_native_decal_lighting.py',r/'tools/integrate_native_decal_lighting.py')
print('Native DECAL colormap routing integrated; actor route explicitly excludes it.')
