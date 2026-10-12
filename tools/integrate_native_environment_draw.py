from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
module='''//! Native95AD40 material state prefix. Full pass order and quality settings dispatch remain open.
use bevy::{prelude::*,render::render_resource::{BlendState,BlendComponent,BlendFactor,BlendOperation,RenderPipelineDescriptor}};
#[derive(Resource,Clone,Debug)] pub struct Quality {pub value:i32,pub revision:u32}
impl Default for Quality {fn default()->Self {let d:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/environment_quality_contract.json")).expect("native quality evidence");Self {value:d["static_pe_initial_quality"].as_i64().unwrap() as i32,revision:0}}}
impl Quality {#[allow(dead_code)] pub fn apply(&mut self,input:i32) {let value=input.clamp(0,4);if value!=self.value {self.value=value;self.revision=self.revision.wrapping_add(1);}}}
// 0 inherits base material, 1 opaque native route, 2 blended native route.
pub fn route(selector:u32,kind:u32,flags:u32,quality:i32)->Option<u32> {
 if matches!(selector,5|6|9|10|14) {return None;}
 Some(if matches!(kind,1|2) || flags&4!=0 && quality>0 {2} else {1})
}
pub fn blend_state()->BlendState {let component=BlendComponent {src_factor:BlendFactor::SrcAlpha,dst_factor:BlendFactor::OneMinusSrcAlpha,operation:BlendOperation::Add};BlendState {color:component,alpha:component}}
pub fn apply_pipeline(descriptor:&mut RenderPipelineDescriptor,mode:u32) {
 if mode==0 {return;}
 assert!(matches!(mode,1|2),"unsupported native material draw mode");
 if let Some(fragment)=descriptor.fragment.as_mut() {if let Some(Some(target))=fragment.targets.first_mut() {target.blend=if mode==2 {Some(blend_state())} else {None};}}
 if let Some(depth)=descriptor.depth_stencil.as_mut() {depth.depth_write_enabled=Some(mode==1);}
 // Preserve Bevy reversed-Z projection/comparison; native depth comparison initialization is a separate scope.
}
pub fn map10_modes(quality:i32)->std::collections::HashMap<String,u32> {
 let d:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map10_shader_material_fields.json")).expect("native Map10 profiles");
 d["gltf_materials_matched"].as_array().unwrap().iter().map(|p|(p["name"].as_str().unwrap().to_owned(),route(0,p["type"].as_u64().unwrap() as u32,p["flags"].as_u64().unwrap() as u32,quality).unwrap())).collect()
}
#[cfg(test)] mod tests {
 use super::*;
 fn proof(name:&str)->serde_json::Value {serde_json::from_str(&std::fs::read_to_string(std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../data/4.20").join(name)).unwrap()).unwrap()}
 #[test] fn material_route_matches_every_original_depth_and_blend_fixture() {
  let d=proof("material_draw_state_contract.json");assert_eq!(d["passed"],true);
  for c in d["cases"].as_array().unwrap() {let result=route(c["selector"].as_u64().unwrap() as u32,c["material_type"].as_u64().unwrap() as u32,c["flags"].as_u64().unwrap() as u32,c["quality"].as_i64().unwrap() as i32);assert_eq!(result.is_none(),c["skipped"].as_bool().unwrap());if let Some(mode)=result {assert_eq!(mode==2,c["blend_enabled_after"].as_bool().unwrap());assert_eq!(mode==1,c["depth_write_after"].as_bool().unwrap());assert_eq!(c["depth_enabled_after"],true);}}
 }
 #[test] fn quality_change_and_wrapping_revision_match_original_producer() {let d=proof("environment_quality_contract.json");for c in d["cases"].as_array().unwrap() {let mut s=Quality {value:c["previous"].as_i64().unwrap() as i32,revision:c["initial_revision"].as_u64().unwrap() as u32};s.apply(c["input"].as_i64().unwrap() as i32);assert_eq!(s.value,c["quality"].as_i64().unwrap() as i32);assert_eq!(s.revision,c["revision"].as_u64().unwrap() as u32);}}
 #[test] fn actual_map_profiles_select_ten_blended_materials_at_native_static_startup() {let q=Quality::default();assert_eq!(q.value,3);let modes=map10_modes(q.value);assert_eq!(modes.len(),87);assert_eq!(modes.values().filter(|v|**v==2).count(),10);let low=map10_modes(0);assert_eq!(low.values().filter(|v|**v==2).count(),4);assert_eq!(blend_state().alpha,blend_state().color);}
}
'''
(r/'crates/client/src/native_environment_draw.rs').write_text(module,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');assert 'mod native_environment_draw;' not in s;s=s.replace('mod environment_render_config;','mod environment_render_config;\nmod native_environment_draw;').replace('.init_resource::<environment_render_config::State>()','.init_resource::<environment_render_config::State>()\n        .init_resource::<native_environment_draw::Quality>()');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/map_fog.rs';s=p.read_text(encoding='utf-8');s=s.replace('pub struct FogExtension {','#[bind_group_data(u32)]\npub struct FogExtension {\n    pub native_draw_mode:u32,');s=s.replace('impl MaterialExtension for FogExtension {','impl From<&FogExtension> for u32 {fn from(value:&FogExtension)->Self {value.native_draw_mode}}\nimpl MaterialExtension for FogExtension {\n    fn specialize(_: &bevy::pbr::MaterialExtensionPipeline,descriptor:&mut bevy::render::render_resource::RenderPipelineDescriptor,_:&bevy::mesh::MeshVertexBufferLayoutRef,key:bevy::pbr::MaterialExtensionKey<Self>)->Result<(),bevy::render::render_resource::SpecializedMeshPipelineError> {crate::native_environment_draw::apply_pipeline(descriptor,key.bind_group_data);Ok(())}');s=s.replace('    colormap_factors: HashMap<String, f32>,','    colormap_factors: HashMap<String, f32>,\n    draw_modes:HashMap<String,u32>,');s=s.replace('native_settings:Res<crate::environment_render_config::State>)','native_settings:Res<crate::environment_render_config::State>,quality:Res<crate::native_environment_draw::Quality>)');s=s.replace('    native_settings.require_current_material_profile()', '    println!("Native environment quality={} (original PE initial profile; user settings dispatch pending)",quality.value);\n    native_settings.require_current_material_profile()');s=s.replace('alpha_test_enabled:1,','native_draw_mode:0,alpha_test_enabled:1,');s=s.replace('colormap_factors:native_colormap_factors(),','colormap_factors:native_colormap_factors(),\n        draw_modes:crate::native_environment_draw::map10_modes(quality.value),');s=s.replace('colormap_factors:HashMap::new()', 'colormap_factors:HashMap::new(),draw_modes:HashMap::new()');s=s.replace('material.base=native_alpha_base(source,material.extension.alpha_test_enabled)','material.base=native_draw_base(source,material.extension.alpha_test_enabled,material.extension.native_draw_mode)');s=s.replace('base: native_alpha_base(material,catalog.extension.alpha_test_enabled),','base: native_draw_base(material,catalog.extension.alpha_test_enabled,catalog.draw_modes.get(&name.0).copied().unwrap_or(0)),');s=s.replace('                        colormap_lighting_factor:catalog.colormap_factors', '                        native_draw_mode:catalog.draw_modes.get(&name.0).copied().unwrap_or(0),\n                        colormap_lighting_factor:catalog.colormap_factors');s+='''
fn native_draw_base(source:&StandardMaterial,alpha_enabled:u32,mode:u32)->StandardMaterial {
 let mut base=native_alpha_base(source,alpha_enabled);
 match mode {1=>base.alpha_mode=AlphaMode::Mask(0.),2=>base.alpha_mode=AlphaMode::Blend,0=>{},_=>panic!("unsupported native material mode")};base
}
#[cfg(test)] mod native_draw_policy_tests {
 use super::*;
 #[test] fn native_blend_overrides_source_cutout_and_survives_real_source_update() {
  let extension=FogExtension {native_draw_mode:2,opaque:Vec4::ZERO,spatial_denominator:15360.,lighting:Handle::default(),vertex_lighting_factor:0.,diagnostic_channel:0,visibility_map:Handle::default(),visibility_params:Vec4::ZERO,visibility_height:Vec4::ZERO,visibility_edge:Vec4::ZERO,visibility_overlay:Handle::default(),visibility_below:Vec4::ZERO,visibility_ready:0,factor_mode:1,colormap_lighting_factor:0.,terrain_transform:Vec4::ZERO,colormap:Handle::default(),fog_coordinates:Vec4::ZERO,alpha_test_enabled:1,alpha_reference:1./255.};
  let name="NativeBlendFixture".to_string();let mut app=App::new();app.add_plugins((MinimalPlugins,AssetPlugin::default())).init_asset::<StandardMaterial>().init_asset::<FogMaterial>().init_resource::<Cache>().insert_resource(FogCatalog {extension,allowed:HashSet::from([name.clone()]),vertex_factors:HashMap::new(),colormap_factors:HashMap::new(),draw_modes:HashMap::from([(name.clone(),2)])}).add_systems(Update,bind);
  let source=app.world_mut().resource_mut::<Assets<StandardMaterial>>().add(StandardMaterial {alpha_mode:AlphaMode::Mask(0.3),..default()});let entity=app.world_mut().spawn((Mesh3d(Handle::default()),GltfMaterialName(name),MeshMaterial3d(source.clone()))).id();app.update();app.update();let handle=app.world().get::<MeshMaterial3d<FogMaterial>>(entity).unwrap().0.clone();assert_eq!(app.world().resource::<Assets<FogMaterial>>().get(&handle).unwrap().base.alpha_mode,AlphaMode::Blend);
  app.world_mut().resource_mut::<Assets<StandardMaterial>>().get_mut(&source).unwrap().alpha_mode=AlphaMode::Opaque;app.update();app.update();let m=app.world().resource::<Assets<FogMaterial>>().get(&handle).unwrap();assert_eq!(m.base.alpha_mode,AlphaMode::Blend);assert_eq!(m.extension.native_draw_mode,2);assert!(app.world().resource::<Cache>().synchronized>0);
  assert_eq!(native_draw_base(&StandardMaterial::default(),1,1).alpha_mode,AlphaMode::Mask(0.));
 }
}
'''.replace('\n+','\n')
needle=' let report=serde_json::json!({"native_alpha_meshes":native_alpha_meshes'
assert needle in s;s=s.replace(needle,' let native_blended_meshes=query.iter().filter(|h|materials.get(&h.0).is_some_and(|m|m.extension.native_draw_mode==2 && m.base.alpha_mode==AlphaMode::Blend)).count();\n let native_opaque_meshes=query.iter().filter(|h|materials.get(&h.0).is_some_and(|m|m.extension.native_draw_mode==1 && m.base.alpha_mode==AlphaMode::Mask(0.))).count();\n let report=serde_json::json!({"native_blended_meshes":native_blended_meshes,"native_opaque_meshes":native_opaque_meshes,"native_alpha_meshes":native_alpha_meshes');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/actor_fow.rs';s=p.read_text(encoding='utf-8').replace('extension.factor_mode=0;','extension.native_draw_mode=0;extension.factor_mode=0;');p.write_text(s,encoding='utf-8')
shutil.copy2(__file__,r/'tools'/Path(__file__).name)
print('Installed native quality resource, material alpha/depth routing and separate-alpha pipeline blend.')
