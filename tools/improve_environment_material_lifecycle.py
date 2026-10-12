from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/map_fog.rs';s=p.read_text(encoding='utf-8')
old='pub struct NativeFogBound;';assert s.count(old)==1
s=s.replace(old,'''pub struct NativeFogBound {pub source:Handle<StandardMaterial>}
#[derive(Resource,Default)] pub struct Cache {
 pub bindings:HashMap<AssetId<StandardMaterial>,Handle<FogMaterial>>,
 pub missing_sources:HashSet<AssetId<StandardMaterial>>,pub synchronized:u64,pub released:u64,
}''')
old='''        Without<NativeFogBound>,
    >,
    mut cache: Local<HashMap<AssetId<StandardMaterial>, Handle<FogMaterial>>>,
    mut count: Local<usize>,
) {
    for (entity, name, original) in &query {''';assert s.count(old)==1
s=s.replace(old,'''        With<Mesh3d>,
    >,
    mut cache: ResMut<Cache>,
    owners:Query<(&NativeFogBound,&MeshMaterial3d<FogMaterial>)>,
    mut changes:MessageReader<bevy::asset::AssetEvent<StandardMaterial>>,
    mut count: Local<usize>,
) {
    use bevy::asset::AssetEvent;
    let alive:HashSet<_>=owners.iter().map(|(bound,material)|(bound.source.id(),material.0.id())).collect();
    let before=cache.bindings.len();cache.bindings.retain(|source,handle|alive.contains(&(*source,handle.id())));cache.released+=(before-cache.bindings.len()) as u64;
    let retained:HashSet<_>=cache.bindings.keys().copied().collect();cache.missing_sources.retain(|id|retained.contains(id));
    let changed:HashSet<_>=changes.read().filter_map(|e|match e {AssetEvent::Added{id}|AssetEvent::Modified{id}|AssetEvent::LoadedWithDependencies{id}|AssetEvent::Removed{id}=>Some(*id),_=>None}).collect();
    for id in changed {
        let Some(handle)=cache.bindings.get(&id).cloned() else {continue;};
        let Some(source)=base.get(id) else {if cache.missing_sources.insert(id) {warn!("Environment fog source material unavailable: {id:?}; retained previous material, source update not qualified.");}continue;};
        if let Some(mut material)=materials.get_mut(&handle) {material.base=source.clone();cache.synchronized+=1;cache.missing_sources.remove(&id);}
    }
    for (entity, name, original) in &query {''')
s=s.replace('''        let handle = cache
            .entry(original.0.id())''','''        let handle = cache.bindings
            .entry(original.0.id())''')
s=s.replace('''            .insert((MeshMaterial3d(handle), NativeFogBound));''','''            .insert((MeshMaterial3d(handle), NativeFogBound {source:original.0.clone()}));''')
s+='''
pub fn probe_lifecycle(cache:Res<Cache>,materials:Res<Assets<FogMaterial>>,query:Query<&MeshMaterial3d<FogMaterial>,With<NativeFogBound>>) {
 let Ok(path)=std::env::var("OPENLEAGUE_ENVIRONMENT_FOW_PROBE") else {return;};
 let bound=query.iter().count();let ready=query.iter().filter(|h|materials.get(&h.0).is_some_and(|m|m.extension.visibility_ready==1)).count();
 let report=serde_json::json!({"complete":false,"bound_meshes":bound,"ready_materials":ready,"cached_materials":cache.bindings.len(),"source_synchronizations":cache.synchronized,"released_cache_entries":cache.released,"missing_sources":cache.missing_sources.len(),"limits":["ECS ownership and readiness observations; material-edit pixel equivalence and whole-match release remain open.","Full native material variant shader execution remains open."]});let _=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap());
}
#[cfg(test)] mod environment_lifecycle_tests {
 use super::*;
 #[test] fn environment_source_changes_rebinding_and_gc_preserve_native_controls_and_scene_scope() {
  use bevy::asset::{AssetApp,AssetPlugin};
  let extension=FogExtension {opaque:Vec4::ZERO,spatial_denominator:15360.,lighting:Handle::default(),vertex_lighting_factor:0.,diagnostic_channel:0,visibility_map:Handle::default(),visibility_params:Vec4::ZERO,visibility_height:Vec4::ZERO,visibility_edge:Vec4::ZERO,visibility_overlay:Handle::default(),visibility_below:Vec4::ZERO,visibility_ready:0,factor_mode:1};
  let name="NVRFixture".to_string();let mut app=App::new();app.add_plugins((MinimalPlugins,AssetPlugin::default())).init_asset::<StandardMaterial>().init_asset::<FogMaterial>().init_resource::<Cache>().insert_resource(FogCatalog {extension,allowed:HashSet::from([name.clone()]),vertex_factors:HashMap::from([(name.clone(),8.)])}).add_systems(Update,bind);
  let source=app.world_mut().resource_mut::<Assets<StandardMaterial>>().add(StandardMaterial {unlit:true,..default()});let source_id=source.id();
  let a=app.world_mut().spawn((Mesh3d(Handle::default()),GltfMaterialName(name.clone()),MeshMaterial3d(source.clone()))).id();let b=app.world_mut().spawn((Mesh3d(Handle::default()),GltfMaterialName(name.clone()),MeshMaterial3d(source.clone()))).id();let outside=app.world_mut().spawn((Mesh3d(Handle::default()),GltfMaterialName("Outside".into()),MeshMaterial3d(source.clone()))).id();app.update();
  let fog=app.world().get::<MeshMaterial3d<FogMaterial>>(a).unwrap().0.clone();assert_eq!(app.world().get::<MeshMaterial3d<FogMaterial>>(b).unwrap().0,fog);assert!(app.world().get::<MeshMaterial3d<StandardMaterial>>(outside).is_some());
  {let mut materials=app.world_mut().resource_mut::<Assets<FogMaterial>>();let mut m=materials.get_mut(&fog).unwrap();m.extension.visibility_ready=1;m.extension.visibility_params=Vec4::new(1.,-1.,0.,1.);}
  {let mut materials=app.world_mut().resource_mut::<Assets<StandardMaterial>>();let mut m=materials.get_mut(&source).unwrap();m.base_color=Color::srgba(0.2,0.4,0.6,0.8);m.alpha_mode=AlphaMode::Blend;m.base_color_texture=Some(Handle::default());}
  app.update();app.update();let actual=app.world().resource::<Assets<FogMaterial>>().get(&fog).unwrap();assert_eq!(actual.base.base_color,Color::srgba(0.2,0.4,0.6,0.8));assert_eq!(actual.base.alpha_mode,AlphaMode::Blend);assert!(actual.base.base_color_texture.is_some());assert_eq!(actual.extension.vertex_lighting_factor,8.);assert_eq!(actual.extension.factor_mode,1);assert_eq!(actual.extension.visibility_ready,1);assert_eq!(actual.extension.visibility_params,Vec4::new(1.,-1.,0.,1.));assert!(app.world().resource::<Cache>().synchronized>0);
  let replacement=app.world_mut().resource_mut::<Assets<StandardMaterial>>().add(StandardMaterial {alpha_mode:AlphaMode::Mask(0.4),..default()});app.world_mut().entity_mut(a).insert(MeshMaterial3d(replacement.clone()));app.update();assert_ne!(app.world().get::<MeshMaterial3d<FogMaterial>>(a).unwrap().0,fog);assert_eq!(app.world().get::<NativeFogBound>(a).unwrap().source,replacement);
  app.world_mut().despawn(a);app.update();assert_eq!(app.world().resource::<Cache>().bindings.len(),1);assert!(app.world().resource::<Assets<FogMaterial>>().get(&fog).is_some());
  drop(source);drop(replacement);drop(fog);app.world_mut().despawn(b);app.world_mut().despawn(outside);for _ in 0..5 {app.update();}assert!(app.world().resource::<Cache>().bindings.is_empty());assert!(app.world().resource::<Assets<FogMaterial>>().is_empty());assert!(app.world().resource::<Assets<StandardMaterial>>().get(source_id).is_none());assert!(app.world().resource::<Cache>().released>=2);
 }
}
''';p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');assert '.init_resource::<map_fog::Cache>()' not in s;s=s.replace('.init_resource::<actor_fow::Cache>()','.init_resource::<actor_fow::Cache>()\n        .init_resource::<map_fog::Cache>()');needle='.add_systems(Update, actor_fow::probe.after(fow_visibility_texture::bind_materials).before(render_probe::capture))';assert s.count(needle)==1;s=s.replace(needle,needle+'\n        .add_systems(Update, map_fog::probe_lifecycle.after(fow_visibility_texture::bind_materials).before(render_probe::capture))');p.write_text(s,encoding='utf-8');assert 'map_fog::probe_lifecycle' in s
print('Environment source updates, rebinding and resource collection installed')
