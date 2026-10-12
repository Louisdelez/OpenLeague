from pathlib import Path
import re
r=Path('E:/OpenLeague');p=r/'crates/client/src/selector7_depth.rs';s=p.read_text(encoding='utf-8').replace('commands.entity(*child).insert((mesh.clone(),MeshMaterial3d(handle)))','commands.entity(*child).insert((mesh.clone(),MeshMaterial3d(handle),DepthPhase {source:source.0.clone()}))').replace('if let Some(m)=materials.get_mut(&handle) {*m=depth;}','if let Some(mut m)=materials.get_mut(&handle) {*m=depth;}');p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/map_fog.rs';s=p.read_text(encoding='utf-8');extension=re.search(r'let extension=FogExtension \{native_draw_mode:2,.*?\};',s).group(0).replace('alpha_test_enabled:1','alpha_test_enabled:0')
test='''
#[cfg(test)] mod selector7_lifecycle_tests {
 use super::*;
 #[test] fn depth_descendant_shares_geometry_tracks_source_replacement_and_releases_on_parent_despawn() {
 EXTENSION
 let name=crate::native_environment_draw::selector7_names(3).into_iter().next().unwrap();let mut app=App::new();app.add_plugins((MinimalPlugins,AssetPlugin::default())).init_asset::<FogMaterial>().init_resource::<crate::selector7_depth::Cache>().insert_resource(FogCatalog {extension:extension.clone(),allowed:HashSet::new(),vertex_factors:HashMap::new(),colormap_factors:HashMap::new(),draw_modes:HashMap::new(),selector7_names:HashSet::from([name.clone()])}).add_systems(Update,crate::selector7_depth::synchronize);
 let source=app.world_mut().resource_mut::<Assets<FogMaterial>>().add(FogMaterial {base:StandardMaterial {alpha_mode:AlphaMode::Blend,..default()},extension});let mesh=Mesh3d(Handle::default());let parent=app.world_mut().spawn((GltfMaterialName(name),NativeFogBound {source:Handle::default()},mesh.clone(),MeshMaterial3d(source.clone()),Transform::from_xyz(1.,2.,3.))).id();app.update();app.update();
 let (child,side)= {let world=app.world_mut();let mut q=world.query::<(Entity,&crate::selector7_depth::DepthPhase,&MeshMaterial3d<FogMaterial>,&ChildOf,&Mesh3d,&Transform)>();let (child,phase,material,parent_link,actual_mesh,t)=q.single(world).unwrap();assert_eq!(parent_link.parent(),parent);assert_eq!(phase.source,source);assert_eq!(actual_mesh.0,mesh.0);assert_eq!(*t,Transform::IDENTITY);(child,material.0.clone())};
 {let mut materials=app.world_mut().resource_mut::<Assets<FogMaterial>>();let m=materials.get_mut(&source).unwrap();m.base.base_color=Color::srgba(0.2,0.4,0.6,0.8);m.base.base_color_texture=Some(Handle::default());}app.update();let m=app.world().resource::<Assets<FogMaterial>>().get(&side).unwrap();assert_eq!(m.base.base_color,Color::srgba(0.2,0.4,0.6,0.8));assert!(m.base.base_color_texture.is_some());assert_eq!(m.extension.native_draw_mode,3);assert_eq!(m.extension.alpha_test_enabled,1);assert_eq!(m.extension.alpha_reference,229./255.);
 let replacement=app.world_mut().resource_mut::<Assets<FogMaterial>>().add(app.world().resource::<Assets<FogMaterial>>().get(&source).unwrap().clone());app.world_mut().entity_mut(parent).insert(MeshMaterial3d(replacement.clone()));app.update();app.update();assert_eq!(app.world().get::<crate::selector7_depth::DepthPhase>(child).unwrap().source,replacement);assert_eq!(app.world().resource::<crate::selector7_depth::Cache>().materials.len(),1);
 drop(side);app.world_mut().entity_mut(parent).despawn();app.update();app.update();assert!(app.world().get_entity(child).is_err());assert!(app.world().resource::<crate::selector7_depth::Cache>().materials.is_empty());
 }
}
'''.replace('EXTENSION',extension)
test=test.replace('let replacement=app.world_mut().resource_mut::<Assets<FogMaterial>>().add(app.world().resource::<Assets<FogMaterial>>().get(&source).unwrap().clone());','let replacement_material=app.world().resource::<Assets<FogMaterial>>().get(&source).unwrap().clone();let replacement=app.world_mut().resource_mut::<Assets<FogMaterial>>().add(replacement_material);')
s+=test;p.write_text(s,encoding='utf-8');print('Added actual descendant ownership, texture update, replacement and parent removal test.')
