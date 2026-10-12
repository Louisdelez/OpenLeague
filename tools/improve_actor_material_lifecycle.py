from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/actor_fow.rs';s=p.read_text(encoding='utf-8')
s=s.replace('use std::collections::HashMap;','use std::collections::{HashMap,HashSet};\nuse bevy::asset::AssetEvent;')
s=s.replace('#[derive(Component)] pub struct Bound;', '''#[derive(Component)] pub struct Bound {pub source:Handle<StandardMaterial>}
#[derive(Resource,Default)] pub struct Cache {
 pub bindings:HashMap<AssetId<StandardMaterial>,Handle<FogMaterial>>,
 pub missing_sources:HashSet<AssetId<StandardMaterial>>,pub synchronized:u64,pub released:u64,
}''')
s=s.replace('query:Query<(Entity,&MeshMaterial3d<StandardMaterial>),(With<Mesh3d>,Without<Bound>)>', 'query:Query<(Entity,&MeshMaterial3d<StandardMaterial>),With<Mesh3d>>')
s=s.replace('mut cache:Local<HashMap<AssetId<StandardMaterial>,Handle<FogMaterial>>>) {', '''mut cache:ResMut<Cache>,owners:Query<(&Bound,&MeshMaterial3d<FogMaterial>)>,mut changes:MessageReader<AssetEvent<StandardMaterial>>) {
 // Cache owns no permanent model lifetime: drop its strong fog handle after the
 // last actual owner disappears. Bevy AssetPlugin collects assets when all strong handles drop.
 let alive:HashSet<_>=owners.iter().map(|(bound,material)|(bound.source.id(),material.0.id())).collect();
 let before=cache.bindings.len();cache.bindings.retain(|source,handle|alive.contains(&(*source,handle.id())));cache.released+=(before-cache.bindings.len()) as u64;
 let retained:HashSet<_>=cache.bindings.keys().copied().collect();cache.missing_sources.retain(|id|retained.contains(id));
 let changed:HashSet<_>=changes.read().filter_map(|e|match e {AssetEvent::Added{id}|AssetEvent::Modified{id}|AssetEvent::LoadedWithDependencies{id}|AssetEvent::Removed{id}=>Some(*id),_=>None}).collect();
 for id in changed {
  let Some(handle)=cache.bindings.get(&id).cloned() else {continue;};
  let Some(source)=base.get(id) else {if cache.missing_sources.insert(id) {warn!("Actor fog source material unavailable: {id:?}; retained previous material, source update not qualified.");}continue;};
  if let Some(mut material)=materials.get_mut(&handle) {material.base=source.clone();cache.synchronized+=1;cache.missing_sources.remove(&id);}
 }
''')
s=s.replace('let handle=cache.entry(original.0.id())','let handle=cache.bindings.entry(original.0.id())').replace('MeshMaterial3d(handle),Bound)', 'MeshMaterial3d(handle),Bound {source:original.0.clone()})')
s=s.replace('gpu:Res<crate::fow_gpu::Images>) {', 'gpu:Res<crate::fow_gpu::Images>,cache:Res<Cache>) {')
s=s.replace('"factor_modes":modes,', '"factor_modes":modes,"cached_materials":cache.bindings.len(),"source_synchronizations":cache.synchronized,"released_cache_entries":cache.released,"missing_sources":cache.missing_sources.len(),')
p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8').replace('        .init_resource::<projected_live::Live>()','        .init_resource::<projected_live::Live>()\n        .init_resource::<actor_fow::Cache>()');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/map_fog.rs';s=p.read_text(encoding='utf-8');s=s.replace('let mut app=App::new();app.init_resource::<Assets<StandardMaterial>>()','let mut app=App::new();app.init_resource::<actor_fow::Cache>().add_message::<bevy::asset::AssetEvent<StandardMaterial>>().init_resource::<Assets<StandardMaterial>>()')
# Tests run Bevy's real asset lifecycle rather than mirroring a manual remove implementation.
position=s.rfind('\n}');assert position>=0
s=s[:position]+'''
 #[test] fn source_edits_and_rebinding_preserve_fog_uniforms_and_retire_unused_assets() {
  use bevy::asset::{AssetApp,AssetPlugin};
  let extension=FogExtension {opaque:Vec4::ZERO,spatial_denominator:15360.,lighting:Handle::default(),vertex_lighting_factor:0.,diagnostic_channel:0,visibility_map:Handle::default(),visibility_params:Vec4::ZERO,visibility_height:Vec4::ZERO,visibility_edge:Vec4::ZERO,visibility_overlay:Handle::default(),visibility_below:Vec4::ZERO,visibility_ready:0,factor_mode:1};
  let mut app=App::new();app.add_plugins((MinimalPlugins,AssetPlugin::default())).init_asset::<StandardMaterial>().init_asset::<FogMaterial>().init_resource::<actor_fow::Cache>().insert_resource(FogCatalog {extension,allowed:HashSet::new(),vertex_factors:HashMap::new()}).add_systems(Update,actor_fow::bind);
  let source=app.world_mut().resource_mut::<Assets<StandardMaterial>>().add(StandardMaterial {unlit:true,..default()});let first_id=source.id();
  let root=app.world_mut().spawn(actor_fow::Root).id();let a=app.world_mut().spawn((ChildOf(root),Mesh3d(Handle::default()),MeshMaterial3d(source.clone()))).id();let b=app.world_mut().spawn((ChildOf(root),Mesh3d(Handle::default()),MeshMaterial3d(source.clone()))).id();app.update();
  let fog=app.world().get::<MeshMaterial3d<FogMaterial>>(a).unwrap().0.clone();let fog_id=fog.id();
  {let mut materials=app.world_mut().resource_mut::<Assets<FogMaterial>>();let mut m=materials.get_mut(&fog).unwrap();m.extension.visibility_ready=1;m.extension.visibility_params=Vec4::new(1.,-1.,0.,1.);}
  {let mut materials=app.world_mut().resource_mut::<Assets<StandardMaterial>>();let mut m=materials.get_mut(&source).unwrap();m.alpha_mode=AlphaMode::Blend;m.base_color=Color::srgba(0.2,0.3,0.4,0.5);m.base_color_texture=Some(Handle::default());}
  app.update();app.update();let actual=app.world().resource::<Assets<FogMaterial>>().get(&fog).unwrap();assert_eq!(actual.base.alpha_mode,AlphaMode::Blend);assert_eq!(actual.base.base_color,Color::srgba(0.2,0.3,0.4,0.5));assert!(actual.base.base_color_texture.is_some());assert_eq!(actual.extension.visibility_ready,1);assert_eq!(actual.extension.visibility_params,Vec4::new(1.,-1.,0.,1.));assert_eq!(actual.extension.factor_mode,0);
  assert_eq!(app.world().get::<MeshMaterial3d<FogMaterial>>(b).unwrap().0,fog);assert!(app.world().resource::<actor_fow::Cache>().synchronized>0);
  // A new material on an existing entity must rebind, even though it already has Bound.
  let replacement=app.world_mut().resource_mut::<Assets<StandardMaterial>>().add(StandardMaterial {alpha_mode:AlphaMode::Mask(0.7),..default()});app.world_mut().entity_mut(a).insert(MeshMaterial3d(replacement.clone()));app.update();assert_ne!(app.world().get::<MeshMaterial3d<FogMaterial>>(a).unwrap().0,fog);assert_eq!(app.world().get::<actor_fow::Bound>(a).unwrap().source,replacement);
  app.world_mut().despawn(a);app.update();assert_eq!(app.world().resource::<actor_fow::Cache>().bindings.len(),1);assert!(app.world().resource::<Assets<FogMaterial>>().get(fog_id).is_some());
  // The source strong handle survives only through remaining owning model instances.
  drop(source);drop(replacement);drop(fog);app.world_mut().despawn(root);for _ in 0..5 {app.update();}
  assert!(app.world().resource::<actor_fow::Cache>().bindings.is_empty());assert!(app.world().resource::<Assets<FogMaterial>>().is_empty());assert!(app.world().resource::<Assets<StandardMaterial>>().get(first_id).is_none());assert!(app.world().resource::<actor_fow::Cache>().released>=2);
 }
'''+s[position:];p.write_text(s,encoding='utf-8');print('Actor source synchronization, rebinding and real asset lifecycle test installed')
