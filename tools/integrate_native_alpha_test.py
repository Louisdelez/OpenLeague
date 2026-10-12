from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
(r/'crates/client/src/native_alpha.rs').write_text('''//! Native9AC500 x87 alpha-reference conversion; ordinary world compare mode4 -> D3D GREATER5.
pub fn reference_byte(value:f32)->Result<u8,&'static str> {
 if !value.is_finite() || !(0. ..=1.).contains(&value) {return Err("native alpha reference outside qualified range");}
 // f32*255 fits exactly in f64; preserve x87 product before truncation, not rounded f32 multiply.
 Ok((value as f64*255.).trunc() as u8)
}
pub fn shader_reference(value:f32)->Result<f32,&'static str> {Ok(reference_byte(value)? as f32/255.)}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn production_reference_matches_original_x87_conversion_for_every_cutoff_mode_and_cache_case() {
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/alpha_render_state_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["world_setup_calls"],serde_json::json!([[15,1],[25,5],[24,1]]));
  for c in p["cases"].as_array().unwrap() {let f=f32::from_bits(c["reference_bits"].as_u64().unwrap() as u32);assert_eq!(reference_byte(f).unwrap() as u64,c["quantized_reference"].as_u64().unwrap());}
  for v in [f32::NAN,f32::INFINITY,-0.1,1.1] {assert!(reference_byte(v).is_err());}
 }
}
''',encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');assert 'mod native_alpha;' not in s;s=s.replace('mod environment_render_config;','mod environment_render_config;\nmod native_alpha;');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/map_fog.rs';s=p.read_text(encoding='utf-8');s=s.replace('    #[uniform(120)] pub fog_coordinates:Vec4,','    #[uniform(120)] pub fog_coordinates:Vec4,\n    #[uniform(121)] pub alpha_test_enabled:u32,\n    #[uniform(122)] pub alpha_reference:f32,');s=s.replace('        fog_coordinates:crate::terrain_material::native_map_fog_coordinates(),','        alpha_test_enabled:1,alpha_reference:crate::native_alpha::shader_reference(native_settings.alpha_reference).expect("native map alpha reference"),\n        fog_coordinates:crate::terrain_material::native_map_fog_coordinates(),');s=s.replace('fog_coordinates:Vec4::ZERO};','fog_coordinates:Vec4::ZERO,alpha_test_enabled:1,alpha_reference:1./255.};');s=s.replace('material.base=source.clone();','material.base=native_alpha_base(source,material.extension.alpha_test_enabled);');s=s.replace('                    base: material.clone(),','                    base: native_alpha_base(material,catalog.extension.alpha_test_enabled),');s=s.replace('assert_eq!(actual.extension.colormap_lighting_factor,0.);','assert_eq!(actual.extension.alpha_test_enabled,0);assert_eq!(actual.extension.colormap_lighting_factor,0.);')
s+='''
// The world pass uses its own native alpha comparison. Avoid the earlier glTF0.3 cutoff.
fn native_alpha_base(source:&StandardMaterial,enabled:u32)->StandardMaterial {
 let mut base=source.clone();
 if enabled==1 && matches!(base.alpha_mode,AlphaMode::Mask(_)) {base.alpha_mode=AlphaMode::Mask(0.);}
 base
}
#[cfg(test)] mod native_alpha_policy_tests {
 use super::*;
 #[test] fn native_world_cutoff_replaces_gltf_threshold_while_preserving_blend_and_actor_materials() {
  let source=StandardMaterial {base_color_texture:Some(Handle::default()),base_color:Color::srgba(0.2,0.4,0.6,0.8),alpha_mode:AlphaMode::Mask(0.3),unlit:true,..default()};
  let native=native_alpha_base(&source,1);assert_eq!(native.alpha_mode,AlphaMode::Mask(0.));assert_eq!(native.base_color_texture,source.base_color_texture);assert_eq!(native.base_color,source.base_color);assert_eq!(native_alpha_base(&source,0).alpha_mode,source.alpha_mode);
  let blended=StandardMaterial {alpha_mode:AlphaMode::Blend,..source.clone()};assert_eq!(native_alpha_base(&blended,1).alpha_mode,AlphaMode::Blend);
 }
}
''';p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/actor_fow.rs';s=p.read_text(encoding='utf-8').replace('extension.factor_mode=0;','extension.factor_mode=0;extension.alpha_test_enabled=0;');p.write_text(s,encoding='utf-8')
helper='\n// Native ordinary-world D3D GREATER predicate after reference-byte normalization.\nfn native_alpha_accepts(alpha:f32,reference:f32)->bool {\n return alpha>reference;\n}\n'
p=r/'assets/shaders/native_environment_fog.wgsl';s=p.read_text(encoding='utf-8');s=s.replace('@fragment fn fragment(', '@group(#{MATERIAL_BIND_GROUP}) @binding(121) var<uniform> native_alpha_enabled:u32;\n@group(#{MATERIAL_BIND_GROUP}) @binding(122) var<uniform> native_alpha_reference:f32;\n@fragment fn fragment(');s=s.replace('    input.material.base_color=alpha_discard(input.material,input.material.base_color);','    if native_alpha_enabled==1u {\n        if !native_alpha_accepts(input.material.base_color.a,native_alpha_reference) {discard;}\n    } else {input.material.base_color=alpha_discard(input.material,input.material.base_color);}')
p.write_text(s+helper,encoding='utf-8')
p=r/'crates/client/src/terrain_material.rs';s=p.read_text(encoding='utf-8').replace('    #[uniform(28)] fog_coordinates: Vec4,','    #[uniform(28)] fog_coordinates: Vec4,\n    #[uniform(29)] alpha_reference:f32,');s=s.replace('            fog_coordinates: native_map_fog_coordinates(),','            fog_coordinates: native_map_fog_coordinates(),\n            alpha_reference:crate::native_alpha::shader_reference(native_settings.alpha_reference).expect("native terrain alpha reference"),');p.write_text(s,encoding='utf-8')
p=r/'assets/shaders/terrain_height_blend.wgsl';s=p.read_text(encoding='utf-8').replace('@fragment fn fragment(', '@group(#{MATERIAL_BIND_GROUP}) @binding(29) var<uniform> native_alpha_reference:f32;\n@fragment fn fragment(');s=s.replace('    let c0 = textureSample','    // Native height-blend output alpha is1; world alpha test still applies.\n    if !native_alpha_accepts(1.0,native_alpha_reference) {discard;}\n    let c0 = textureSample');p.write_text(s+helper,encoding='utf-8')
for name in ['probe_native_alpha_state.py','inspect_native_alpha_routes.py','integrate_native_alpha_test.py']:shutil.copy2('E:/mapslol3v3/'+name,r/'tools'/name)
print('Native ordinary-world alpha reference/predicate integrated; actors keep their separate material alpha path.')
