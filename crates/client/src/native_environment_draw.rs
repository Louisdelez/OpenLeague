//! Native95AD40 material state prefix. Full pass order and quality settings dispatch remain open.
use bevy::{prelude::*,render::render_resource::{BlendState,BlendComponent,BlendFactor,BlendOperation,RenderPipelineDescriptor}};
#[derive(Resource,Clone,Debug)] pub struct Quality {pub value:i32,pub revision:u32}
impl Default for Quality {fn default()->Self {let option=crate::native_graphics_options::IntegerOptions::default().read(crate::native_graphics_options::ENVIRONMENT_ID);assert!(!option.assertion_required,"native environment default missing");Self {value:option.value,revision:0}}}
impl Quality {#[allow(dead_code)] pub fn apply(&mut self,input:i32) {let value=input.clamp(0,4);if value!=self.value {self.value=value;self.revision=self.revision.wrapping_add(1);}}}
// 0 inherits base material, 1 opaque native route, 2 blended native route.
pub fn route(selector:u32,kind:u32,flags:u32,quality:i32)->Option<u32> {
 if matches!(selector,5|6|9|10|14) {return None;}
 Some(if matches!(kind,1|2) || flags&4!=0 && quality>0 {2} else {1})
}
pub fn blend_state()->BlendState {let component=BlendComponent {src_factor:BlendFactor::SrcAlpha,dst_factor:BlendFactor::OneMinusSrcAlpha,operation:BlendOperation::Add};BlendState {color:component,alpha:component}}
pub fn depth_write(mode:u32)->bool {assert!(matches!(mode,1|2|3));mode!=2}
pub fn color_write(mode:u32)->bevy::render::render_resource::ColorWrites {if mode==3 {bevy::render::render_resource::ColorWrites::empty()} else {bevy::render::render_resource::ColorWrites::ALL}}
pub fn apply_pipeline(descriptor:&mut RenderPipelineDescriptor,mode:u32) {
 if mode==0 {return;}
 assert!(matches!(mode,1|2|3),"unsupported native material draw mode");
 if let Some(fragment)=descriptor.fragment.as_mut() {if let Some(Some(target))=fragment.targets.first_mut() {target.blend=if mode==2 {Some(blend_state())} else {None};target.write_mask=color_write(mode);}}
 if let Some(depth)=descriptor.depth_stencil.as_mut() {depth.depth_write_enabled=Some(depth_write(mode));}
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
  for filename in ["material_draw_state_contract.json","map10_material_draw_state_contract.json"] {let d=proof(filename);assert_eq!(d["passed"],true);
  for c in d["cases"].as_array().unwrap() {let result=route(c["selector"].as_u64().unwrap() as u32,c["material_type"].as_u64().unwrap() as u32,c["flags"].as_u64().unwrap() as u32,c["quality"].as_i64().unwrap() as i32);assert_eq!(result.is_none(),c["skipped"].as_bool().unwrap());if let Some(mode)=result {assert_eq!(mode==2,c["blend_enabled_after"].as_bool().unwrap());assert_eq!(mode==1,c["depth_write_after"].as_bool().unwrap());assert_eq!(c["depth_enabled_after"],true);assert_eq!(depth_write(mode),c["depth_write_after"].as_bool().unwrap());}}}
 }
 #[test] fn quality_change_and_wrapping_revision_match_original_producer() {let d=proof("environment_quality_contract.json");for c in d["cases"].as_array().unwrap() {let mut s=Quality {value:c["previous"].as_i64().unwrap() as i32,revision:c["initial_revision"].as_u64().unwrap() as u32};s.apply(c["input"].as_i64().unwrap() as i32);assert_eq!(s.value,c["quality"].as_i64().unwrap() as i32);assert_eq!(s.revision,c["revision"].as_u64().unwrap() as u32);}}
 #[test] fn actual_map_profiles_select_ten_blended_materials_at_native_static_startup() {let q=Quality::default();assert_eq!(q.value,3);let modes=map10_modes(q.value);assert_eq!(modes.len(),87);assert_eq!(modes.values().filter(|v|**v==2).count(),10);let low=map10_modes(0);assert_eq!(low.values().filter(|v|**v==2).count(),4);assert_eq!(blend_state().alpha,blend_state().color);}
}

pub fn selector7_names(quality:i32)->std::collections::HashSet<String> {
 let d:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map10_shader_material_fields.json")).unwrap();
 if quality<=0 {return Default::default();}
 d["gltf_materials_matched"].as_array().unwrap().iter().filter(|p|p["flags"].as_u64().unwrap()&4!=0).map(|p|p["name"].as_str().unwrap().to_owned()).collect()
}
pub fn depth_phase_reference()->f32 {static VALUE:std::sync::OnceLock<f32>=std::sync::OnceLock::new();*VALUE.get_or_init(|| {let d:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/selector7_depth_phase_contract.json")).unwrap();d["quantized_reference_byte"].as_u64().unwrap() as f32/255.})}
