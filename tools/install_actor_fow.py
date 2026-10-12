from pathlib import Path
r=Path('E:/OpenLeague')
p=r/'crates/client/src/actor_fow.rs';p.write_text('''//! Native SkinnedMesh base fog factors on descendants of loaded gameplay/ambient model roots.
//! Material replacement preserves the original StandardMaterial and the mesh/skinning/animation ECS data.
use bevy::prelude::*;
use std::collections::HashMap;
use crate::map_fog::{FogCatalog,FogMaterial};
#[derive(Component)] pub struct Root;
#[derive(Component)] pub struct Bound;
pub fn bind(mut commands:Commands,catalog:Res<FogCatalog>,base:Res<Assets<StandardMaterial>>,mut materials:ResMut<Assets<FogMaterial>>,
 query:Query<(Entity,&MeshMaterial3d<StandardMaterial>),(With<Mesh3d>,Without<Bound>)>,roots:Query<(),With<Root>>,parents:Query<&ChildOf>,
 mut cache:Local<HashMap<AssetId<StandardMaterial>,Handle<FogMaterial>>>) {
 for(entity,original) in &query {
  if !roots.contains(entity) && !parents.iter_ancestors(entity).any(|p|roots.contains(p)) {continue;}
  let Some(source)=base.get(&original.0) else {continue;};
  let handle=cache.entry(original.0.id()).or_insert_with(|| {
   let mut extension=catalog.extension.clone();extension.factor_mode=0;extension.vertex_lighting_factor=0.;
   materials.add(FogMaterial {base:source.clone(),extension})
  }).clone();
  commands.entity(entity).remove::<MeshMaterial3d<StandardMaterial>>().insert((MeshMaterial3d(handle),Bound));
 }
}
pub fn probe(query:Query<(&MeshMaterial3d<FogMaterial>,Option<&bevy::mesh::skinning::SkinnedMesh>),With<Bound>>,materials:Res<Assets<FogMaterial>>,gpu:Res<crate::fow_gpu::Images>) {
 let Ok(path)=std::env::var("OPENLEAGUE_ACTOR_FOW_PROBE") else {return;};
 let mut bound=0;let mut skinned=0;let mut ready=0;let mut textured=0;let mut modes=Vec::new();
 for(handle,skin) in &query {bound+=1;skinned+=usize::from(skin.is_some());if let Some(m)=materials.get(&handle.0) {ready+=usize::from(m.extension.visibility_ready==1 && m.extension.visibility_map==gpu.output);textured+=usize::from(m.base.base_color_texture.is_some());modes.push(m.extension.factor_mode);}}
 let report=serde_json::json!({"complete":false,"bound_meshes":bound,"skinned_meshes":skinned,"ready_materials":ready,"textured_meshes":textured,"factor_modes":modes,"limits":["Actual ECS material/mesh binding observations; pixel attribution and native shader-variant fidelity remain open.","Loaded descendants of gameplay/ambient model roots only; all122champions/skins not exercised by this runtime."]});let _=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap());
}
''',encoding='utf-8')
p=r/'crates/client/src/map_fog.rs';s=p.read_text(encoding='utf-8');s=s.replace('    #[uniform(114)] pub visibility_ready:u32,','    #[uniform(114)] pub visibility_ready:u32,\n    #[uniform(115)] pub factor_mode:u32,');s=s.replace('visibility_below:Vec4::ZERO,visibility_ready:0,','visibility_below:Vec4::ZERO,visibility_ready:0,factor_mode:1,');s+='''
#[cfg(test)] mod actor_binding_tests {
 use super::*;
 use crate::actor_fow;
 #[test] fn native_actor_material_binding_preserves_skin_alpha_texture_and_scene_boundaries() {
  let extension=FogExtension {opaque:Vec4::ZERO,spatial_denominator:15360.,lighting:Handle::default(),vertex_lighting_factor:8.,diagnostic_channel:0,visibility_map:Handle::default(),visibility_params:Vec4::ZERO,visibility_height:Vec4::ZERO,visibility_edge:Vec4::ZERO,visibility_overlay:Handle::default(),visibility_below:Vec4::ZERO,visibility_ready:0,factor_mode:1};
  let mut app=App::new();app.init_resource::<Assets<StandardMaterial>>().init_resource::<Assets<FogMaterial>>().insert_resource(FogCatalog {extension,allowed:HashSet::new(),vertex_factors:HashMap::new()}).add_systems(Update,actor_fow::bind);
  let source=StandardMaterial {base_color_texture:Some(Handle::default()),alpha_mode:AlphaMode::Mask(0.3),double_sided:true,unlit:true,perceptual_roughness:0.2,metallic:0.5,..default()};
  let material=app.world_mut().resource_mut::<Assets<StandardMaterial>>().add(source.clone());let root=app.world_mut().spawn(actor_fow::Root).id();let intermediate=app.world_mut().spawn(ChildOf(root)).id();let joint=app.world_mut().spawn_empty().id();
  let entity=app.world_mut().spawn((ChildOf(intermediate),Mesh3d(Handle::default()),MeshMaterial3d(material.clone()),bevy::mesh::skinning::SkinnedMesh {inverse_bindposes:Handle::default(),joints:vec![joint]},Transform::from_xyz(1.,2.,3.))).id();
  let decor=app.world_mut().spawn((Mesh3d(Handle::default()),MeshMaterial3d(material.clone()))).id();
  app.update();let handle=app.world().get::<MeshMaterial3d<FogMaterial>>(entity).unwrap().0.clone();let actual=app.world().resource::<Assets<FogMaterial>>().get(&handle).unwrap();
  assert_eq!(actual.base.base_color_texture,source.base_color_texture);assert_eq!(actual.base.alpha_mode,source.alpha_mode);assert!(actual.base.double_sided && actual.base.unlit);assert_eq!(actual.base.perceptual_roughness,0.2);assert_eq!(actual.base.metallic,0.5);assert_eq!(actual.extension.factor_mode,0);assert_eq!(actual.extension.vertex_lighting_factor,0.);
  assert_eq!(app.world().get::<bevy::mesh::skinning::SkinnedMesh>(entity).unwrap().joints,vec![joint]);assert_eq!(app.world().get::<Transform>(entity).unwrap().translation,Vec3::new(1.,2.,3.));assert!(app.world().get::<MeshMaterial3d<StandardMaterial>>(decor).is_some());
  let late=app.world_mut().spawn((ChildOf(root),Mesh3d(Handle::default()),MeshMaterial3d(material))).id();app.update();assert_eq!(app.world().get::<MeshMaterial3d<FogMaterial>>(late).unwrap().0,handle);assert_eq!(app.world().resource::<Assets<FogMaterial>>().len(),1);
 }
}
''';p.write_text(s,encoding='utf-8')
p=r/'assets/shaders/native_environment_fog.wgsl';s=p.read_text(encoding='utf-8').replace('@fragment fn fragment','@group(#{MATERIAL_BIND_GROUP}) @binding(115) var<uniform> factor_mode:u32;\n@fragment fn fragment');s=s.replace('native_fow_factors(overlay,vis,height,1u,visibility_edge)','native_fow_factors(overlay,vis,height,factor_mode,visibility_edge)');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/animation.rs';s=p.read_text(encoding='utf-8');needle='.insert((WorldAssetRoot(scene.clone()), playback, visibility))';assert needle in s;s=s.replace(needle,'.insert((WorldAssetRoot(scene.clone()), playback, visibility, crate::actor_fow::Root))');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/map_ambient.rs';s=p.read_text(encoding='utf-8');needle='WorldAssetRoot(model.scenes.first().expect("native scene").clone()),';assert needle in s;s=s.replace(needle,needle+'\n                crate::actor_fow::Root,');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');s='mod actor_fow;\n'+s;s=s.replace('.after(map_fog::bind).after(terrain_material::bind)', '.after(map_fog::bind).after(actor_fow::bind).after(terrain_material::bind)');needle='        .add_systems(Update, fow_champion_sources::update';assert needle in s;s=s.replace(needle,'''        .add_systems(Update, actor_fow::bind.after(animation::load_models).after(map_ambient::load_models).after(map_fog::bind).before(fow_visibility_texture::bind_materials))
        .add_systems(Update, actor_fow::probe.after(fow_visibility_texture::bind_materials).before(render_probe::capture))
'''+needle);p.write_text(s,encoding='utf-8')
print('Actor base factor material consumer and hierarchy/skinning test installed')
