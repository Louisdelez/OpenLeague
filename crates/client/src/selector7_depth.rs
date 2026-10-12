//! Original selector7 depth-only then blended draws, qualified through95B140/95B300/95AFC0.
use bevy::{prelude::*,gltf::GltfMaterialName};
use std::collections::{HashMap,HashSet};
use crate::map_fog::{FogCatalog,FogMaterial,NativeFogBound};
#[derive(Component)] pub struct DepthPhase {pub source:Handle<FogMaterial>}
#[derive(Resource,Default)] pub struct Cache {pub materials:HashMap<AssetId<FogMaterial>,Handle<FogMaterial>>}
pub fn material(source:&FogMaterial)->FogMaterial {let mut m=source.clone();m.base.alpha_mode=AlphaMode::Mask(0.);m.extension.native_draw_mode=3;m.extension.alpha_test_enabled=1;m.extension.alpha_reference=crate::native_environment_draw::depth_phase_reference();m}
pub fn synchronize(mut commands:Commands,catalog:Res<FogCatalog>,mut materials:ResMut<Assets<FogMaterial>>,mut cache:ResMut<Cache>,
 originals:Query<(Entity,&GltfMaterialName,&Mesh3d,&MeshMaterial3d<FogMaterial>),With<NativeFogBound>>,
 phases:Query<(Entity,&DepthPhase,&ChildOf,&MeshMaterial3d<FogMaterial>)>) {
 let alive:HashSet<_>=phases.iter().map(|(_,p,_,m)|(p.source.id(),m.0.id())).collect();cache.materials.retain(|source,handle|alive.contains(&(*source,handle.id())));
 let parents:HashMap<_,_>=phases.iter().map(|(e,_,parent,_)|(parent.parent(),e)).collect();
 let mut refreshed=HashSet::new();
 for (entity,name,mesh,source) in &originals {
  if !catalog.selector7_names.contains(&name.0) {continue;}
  if refreshed.insert(source.0.id()) {
   let Some(original)=materials.get(&source.0).cloned() else {continue;};let depth=material(&original);
   if let Some(handle)=cache.materials.get(&source.0.id()).cloned() {if let Some(mut m)=materials.get_mut(&handle) {*m=depth;}} else {let handle=materials.add(depth);cache.materials.insert(source.0.id(),handle);}
  }
  let Some(handle)=cache.materials.get(&source.0.id()).cloned() else {continue;};
  if let Some(child)=parents.get(&entity) {commands.entity(*child).insert((mesh.clone(),MeshMaterial3d(handle),DepthPhase {source:source.0.clone()}));} else {commands.spawn((Name::new("Native selector7 depth phase"),mesh.clone(),MeshMaterial3d(handle),Transform::IDENTITY,Visibility::Inherited,ChildOf(entity),DepthPhase {source:source.0.clone()}));}
 }
}
pub fn probe(phases:Query<(&DepthPhase,&MeshMaterial3d<FogMaterial>)>,materials:Res<Assets<FogMaterial>>,cache:Res<Cache>) {
 let Ok(path)=std::env::var("OPENLEAGUE_SELECTOR7_DEPTH_PROBE") else {return;};let mut ready=0;let mut depth_only=0;let mut reference_bits=std::collections::BTreeSet::new();let mut source_alpha_disabled=0;
 for (phase,handle) in &phases {if let Some(m)=materials.get(&handle.0) {ready+=usize::from(m.extension.visibility_ready==1);depth_only+=usize::from(m.extension.native_draw_mode==3 && m.extension.alpha_test_enabled==1 && m.base.alpha_mode==AlphaMode::Mask(0.));reference_bits.insert(m.extension.alpha_reference.to_bits());}if materials.get(&phase.source).is_some_and(|s|s.extension.alpha_test_enabled==0 && s.extension.native_draw_mode==2) {source_alpha_disabled+=1;}}
 let report=serde_json::json!({"complete":false,"depth_phase_meshes":phases.iter().count(),"ready_materials":ready,"depth_only_materials":depth_only,"reference_bits":reference_bits,"blended_sources_alpha_disabled":source_alpha_disabled,"cached_materials":cache.materials.len(),"limits":["Actual ECS descendants share original mesh and inherited transform/visibility; native full scene ordering, filtered alpha precision and framebuffer equivalence remain open."]});let _=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap());
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn actual_six_native_profiles_use_depth_phase_and_expected_reference() {let names=crate::native_environment_draw::selector7_names(3);assert_eq!(names.len(),6);assert!(crate::native_environment_draw::selector7_names(0).is_empty());assert_eq!(crate::native_environment_draw::depth_phase_reference(),229./255.);assert!(crate::native_environment_draw::depth_write(3));let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/selector7_batches_contract.json")).unwrap();assert_eq!(proof["passed"],true);for c in proof["cases"].as_array().unwrap() {let count=c["batch_count"].as_u64().unwrap() as usize;for d in &c["draws"].as_array().unwrap()[..count] {assert_eq!(d["depth_write"],true);assert_eq!(d["color_write"],0);assert_eq!(d["alpha_enabled"],true);}for d in &c["draws"].as_array().unwrap()[count..] {assert_eq!(d["depth_write"],false);assert_eq!(d["alpha_enabled"],false);assert_eq!(d["blend_enabled"],true);}}}
}
