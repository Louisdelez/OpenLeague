//! Native SkinnedMesh base fog factors on descendants of loaded gameplay/ambient model roots.
//! Material replacement preserves the original StandardMaterial and the mesh/skinning/animation ECS data.
use bevy::prelude::*;
use std::collections::{HashMap,HashSet};
use bevy::asset::AssetEvent;
use crate::map_fog::{FogCatalog,FogMaterial};
#[derive(Component)] pub struct Root;
#[derive(Component)] pub struct Bound {pub source:Handle<StandardMaterial>}
/// A private override keeps the exact shared baseline live and reloadable.
/// This is a component lease, not another cache entry or a new material.
#[derive(Component,Clone)] pub struct BaselineLease {
 pub source:Handle<StandardMaterial>,pub previous:Handle<FogMaterial>,
}
#[derive(Resource,Default)] pub struct Cache {
 pub bindings:HashMap<AssetId<StandardMaterial>,Handle<FogMaterial>>,
 pub missing_sources:HashSet<AssetId<StandardMaterial>>,pub synchronized:u64,pub released:u64,
}
pub fn bind(mut commands:Commands,catalog:Res<FogCatalog>,base:Res<Assets<StandardMaterial>>,mut materials:ResMut<Assets<FogMaterial>>,
 query:Query<(Entity,&MeshMaterial3d<StandardMaterial>),With<Mesh3d>>,roots:Query<(),With<Root>>,parents:Query<&ChildOf>,
 mut cache:ResMut<Cache>,owners:Query<(&Bound,&MeshMaterial3d<FogMaterial>)>,leases:Query<&BaselineLease>,mut changes:MessageReader<AssetEvent<StandardMaterial>>) {
 // Cache owns no permanent model lifetime: drop its strong fog handle after the
 // last actual owner disappears. Bevy AssetPlugin collects assets when all strong handles drop.
 let alive:HashSet<_>=owners.iter().map(|(bound,material)|(bound.source.id(),material.0.id()))
  .chain(leases.iter().map(|lease|(lease.source.id(),lease.previous.id()))).collect();
 let before=cache.bindings.len();cache.bindings.retain(|source,handle|alive.contains(&(*source,handle.id())));cache.released+=(before-cache.bindings.len()) as u64;
 let retained:HashSet<_>=cache.bindings.keys().copied().collect();cache.missing_sources.retain(|id|retained.contains(id));
 let changed:HashSet<_>=changes.read().filter_map(|e|match e {AssetEvent::Added{id}|AssetEvent::Modified{id}|AssetEvent::LoadedWithDependencies{id}|AssetEvent::Removed{id}=>Some(*id),_=>None}).collect();
 for id in changed {
  let Some(handle)=cache.bindings.get(&id).cloned() else {continue;};
  let Some(source)=base.get(id) else {if cache.missing_sources.insert(id) {warn!("Actor fog source material unavailable: {id:?}; retained previous material, source update not qualified.");}continue;};
  if let Some(mut material)=materials.get_mut(&handle) {material.base=source.clone();cache.synchronized+=1;cache.missing_sources.remove(&id);}
 }

 for(entity,original) in &query {
  if !roots.contains(entity) && !parents.iter_ancestors(entity).any(|p|roots.contains(p)) {continue;}
  let Some(source)=base.get(&original.0) else {continue;};
  let handle=cache.bindings.entry(original.0.id()).or_insert_with(|| {
   let mut extension=catalog.extension.clone();extension.native_draw_mode=0;extension.factor_mode=0;extension.alpha_test_enabled=0;extension.colormap_lighting_factor=0.;extension.vertex_lighting_factor=0.;
   materials.add(FogMaterial {base:source.clone(),extension})
  }).clone();
  commands.entity(entity).remove::<MeshMaterial3d<StandardMaterial>>().insert((MeshMaterial3d(handle),Bound {source:original.0.clone()}));
 }
}
pub fn probe(query:Query<(&MeshMaterial3d<FogMaterial>,Option<&bevy::mesh::skinning::SkinnedMesh>),With<Bound>>,materials:Res<Assets<FogMaterial>>,gpu:Res<crate::fow_gpu::Images>,cache:Res<Cache>) {
 let Ok(path)=std::env::var("OPENLEAGUE_ACTOR_FOW_PROBE") else {return;};
 let mut bound=0;let mut skinned=0;let mut ready=0;let mut textured=0;let mut modes=Vec::new();
 for(handle,skin) in &query {bound+=1;skinned+=usize::from(skin.is_some());if let Some(m)=materials.get(&handle.0) {ready+=usize::from(m.extension.visibility_ready==1 && m.extension.visibility_map==gpu.output);textured+=usize::from(m.base.base_color_texture.is_some());modes.push(m.extension.factor_mode);}}
 let native_alpha_meshes=query.iter().filter(|(h,_)|materials.get(&h.0).is_some_and(|m|m.extension.alpha_test_enabled==1)).count();
 let native_draw_meshes=query.iter().filter(|(h,_)|materials.get(&h.0).is_some_and(|m|m.extension.native_draw_mode!=0)).count();
 let report=serde_json::json!({"native_draw_meshes":native_draw_meshes,"native_alpha_meshes":native_alpha_meshes,"complete":false,"bound_meshes":bound,"skinned_meshes":skinned,"ready_materials":ready,"textured_meshes":textured,"factor_modes":modes,"cached_materials":cache.bindings.len(),"source_synchronizations":cache.synchronized,"released_cache_entries":cache.released,"missing_sources":cache.missing_sources.len(),"limits":["Actual ECS material/mesh binding observations; pixel attribution and native shader-variant fidelity remain open.","Loaded descendants of gameplay/ambient model roots only; all122champions/skins not exercised by this runtime."]});let _=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap());
}
