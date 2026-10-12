//! Explicit ECS fixtures. These tests do not load DDS bytes or execute a GPU.
//! Include as a child of map_fog so the fixture can construct FogCatalog.
use super::*;
use crate::{actor_fow, animation, garen_w_material_host as host};
use bevy::asset::{AssetApp,AssetPlugin};
use bevy::mesh::skinning::SkinnedMesh;

fn extension()->FogExtension {
 FogExtension {high_fog0:Vec4::ZERO,high_fog1:Vec4::ZERO,cloud_phase:Vec4::ZERO,
 cloud_opacity:Handle::default(),fog_mod2x:0,fog_profile:UVec4::new(2,1,1,0),
 fog_constant:Vec4::ZERO,opaque:Vec4::ZERO,spatial_denominator:15360.,
 lighting:Handle::default(),vertex_lighting_factor:0.,diagnostic_channel:0,
 visibility_map:Handle::default(),visibility_params:Vec4::ZERO,visibility_height:Vec4::ZERO,
 visibility_edge:Vec4::ZERO,visibility_overlay:Handle::default(),visibility_below:Vec4::ZERO,
 visibility_ready:0,factor_mode:1,colormap_lighting_factor:4.,terrain_transform:Vec4::ZERO,
 colormap:Handle::default(),fog_coordinates:Vec4::ZERO,native_draw_mode:0,
 alpha_test_enabled:1,alpha_reference:1./255.}
}
struct Fixture {app:App,model:Handle<Gltf>,source:Handle<StandardMaterial>,base_image:Handle<Image>,w_image:Handle<Image>}
impl Fixture {
 fn new()->Self {
  let mut app=App::new();
  app.add_plugins((MinimalPlugins,AssetPlugin::default()))
   .init_asset::<StandardMaterial>().init_asset::<FogMaterial>().init_asset::<Image>().init_asset::<Gltf>()
   .init_resource::<actor_fow::Cache>().init_resource::<host::Requests>()
   .insert_resource(FogCatalog {extension:extension(),allowed:HashSet::new(),vertex_factors:HashMap::new(),
      colormap_factors:HashMap::new(),draw_modes:HashMap::new(),selector7_names:HashSet::new()})
   .add_systems(Update,(actor_fow::bind,host::synchronize).chain());
  let model=app.world().resource::<Assets<Gltf>>().reserve_handle();
  let base_image=app.world_mut().resource_mut::<Assets<Image>>().add(Image::default());
  let w_image=app.world_mut().resource_mut::<Assets<Image>>().add(Image::default());
  app.insert_resource(host::Profile {model:model.clone(),texture:w_image.clone()});
  app.world_mut().resource_mut::<host::Requests>().reset(10);
  let source=app.world_mut().resource_mut::<Assets<StandardMaterial>>().add(StandardMaterial {
   base_color_texture:Some(base_image.clone()),base_color:Color::srgba(0.2,0.3,0.4,0.5),
   unlit:true,double_sided:true,alpha_mode:AlphaMode::Mask(0.3),metallic:0.7,perceptual_roughness:0.4,..default()});
  Self {app,model,source,base_image,w_image}
 }
 fn root(&mut self,id:u32)->Entity {
  self.app.world_mut().spawn((actor_fow::Root,Visibility::Visible,
   animation::material_test_playback(id,self.model.clone()))).id()
 }
 fn primitive(&mut self,root:Entity)->Entity {
  let joint=self.app.world_mut().spawn_empty().id();
  self.app.world_mut().spawn((ChildOf(root),Mesh3d(Handle::default()),MeshMaterial3d(self.source.clone()),
   SkinnedMesh {inverse_bindposes:Handle::default(),joints:vec![joint]},Transform::from_xyz(1.,2.,3.))).id()
 }
 fn request(&mut self,root:Entity,source:u32,owner:u32) {
  self.app.world_mut().resource_mut::<host::Requests>().insert_base(root,source,owner).unwrap();
 }
 fn update(&mut self) {self.app.update();}
 fn handle(&self,e:Entity)->Handle<FogMaterial> {self.app.world().get::<MeshMaterial3d<FogMaterial>>(e).unwrap().0.clone()}
 fn material(&self,h:&Handle<FogMaterial>)->&FogMaterial {self.app.world().resource::<Assets<FogMaterial>>().get(h).unwrap()}
}

#[test]
fn w_private_materials_preserve_neighbors_skin_components_and_exact_baseline() {
 let mut f=Fixture::new();let a=f.root(1);let b=f.root(2);let pa=f.primitive(a);let pb=f.primitive(b);f.update();
 let baseline=f.handle(pa);assert_eq!(baseline,f.handle(pb));
 let joints=f.app.world().get::<SkinnedMesh>(pa).unwrap().joints.clone();
 let mesh=f.app.world().get::<Mesh3d>(pa).unwrap().0.clone();
 f.request(a,1,11);f.update();let private_a=f.handle(pa);assert_ne!(private_a,baseline);
 assert_eq!(f.handle(pb),baseline);assert_eq!(f.material(&baseline).base.base_color_texture,Some(f.base_image.clone()));
 assert_eq!(f.material(&private_a).base.base_color_texture,Some(f.w_image.clone()));
 assert_eq!(f.material(&private_a).base.base_color,f.material(&baseline).base.base_color);
 assert_eq!(f.material(&private_a).base.alpha_mode,AlphaMode::Mask(0.3));
 assert_eq!(f.material(&private_a).base.metallic,0.7);assert!(f.material(&private_a).base.unlit);
 assert_eq!(f.app.world().get::<SkinnedMesh>(pa).unwrap().joints,joints);
 assert_eq!(f.app.world().get::<Mesh3d>(pa).unwrap().0,mesh);
 assert_eq!(f.app.world().get::<Transform>(pa).unwrap().translation,Vec3::new(1.,2.,3.));
 f.request(b,2,21);f.update();let private_b=f.handle(pb);assert_ne!(private_a,private_b);
 f.app.world_mut().resource_mut::<host::Requests>().remove_root(a);f.update();
 assert_eq!(f.handle(pa),baseline);assert_eq!(f.handle(pb),private_b);
 assert!(f.app.world().get::<host::Guard>(pa).is_none());assert!(f.app.world().get::<actor_fow::BaselineLease>(pa).is_none());
 f.app.world_mut().resource_mut::<host::Requests>().clear();f.update();assert_eq!(f.handle(pb),baseline);
}

#[test]
fn w_all_overridden_baselines_stay_cached_and_reload_without_losing_live_fog() {
 let mut f=Fixture::new();let a=f.root(1);let b=f.root(2);let pa=f.primitive(a);let pb=f.primitive(b);f.update();
 let baseline=f.handle(pa);f.request(a,1,1);f.request(b,2,1);f.update();let private=f.handle(pa);
 {let mut assets=f.app.world_mut().resource_mut::<Assets<FogMaterial>>();let mut m=assets.get_mut(&private).unwrap();
  m.extension.visibility_ready=1;m.extension.visibility_params=Vec4::ONE;m.extension.cloud_phase=Vec4::splat(3.);}
 {let mut assets=f.app.world_mut().resource_mut::<Assets<StandardMaterial>>();let mut m=assets.get_mut(&f.source).unwrap();
  m.base_color=Color::srgb(0.6,0.5,0.4);m.perceptual_roughness=0.8;}
 f.update();f.update();
 assert_eq!(f.app.world().resource::<actor_fow::Cache>().bindings.get(&f.source.id()),Some(&baseline));
 assert_eq!(f.material(&baseline).base.perceptual_roughness,0.8);assert_eq!(f.material(&private).base.perceptual_roughness,0.8);
 assert_eq!(f.material(&private).extension.visibility_params,Vec4::ONE);
 assert_eq!(f.material(&private).extension.cloud_phase,Vec4::splat(3.));
 assert_eq!(f.material(&private).base.base_color_texture,Some(f.w_image.clone()));
 f.app.world_mut().resource_mut::<host::Requests>().clear();f.update();assert_eq!(f.handle(pa),baseline);assert_eq!(f.handle(pb),baseline);
 assert!(f.app.world().resource::<actor_fow::Cache>().synchronized>0);
}

#[test]
fn w_external_rebinding_is_never_clobbered_on_retirement() {
 let mut f=Fixture::new();let root=f.root(1);let p=f.primitive(root);f.update();f.request(root,1,1);f.update();
 let private=f.handle(p);let mut external_material=f.material(&private).clone();external_material.base.base_color=Color::srgb(1.,0.,0.);
 let external=f.app.world_mut().resource_mut::<Assets<FogMaterial>>().add(external_material);
 f.app.world_mut().entity_mut(p).insert(MeshMaterial3d(external.clone()));f.update();
 assert_eq!(f.handle(p),external);assert!(f.app.world().get::<host::Guard>(p).is_none());
 f.app.world_mut().resource_mut::<host::Requests>().clear();f.update();assert_eq!(f.handle(p),external);
 // A real StandardMaterial rebind changes Bound.source too; the old guard cannot restore over it.
 f.app.world_mut().resource_mut::<host::Requests>().reset(10); // A new explicit fixture session after clear().
 let second=f.primitive(root);f.update();f.request(root,1,2);f.update();
 let replacement=f.app.world_mut().resource_mut::<Assets<StandardMaterial>>().add(StandardMaterial {base_color_texture:Some(f.base_image.clone()),..default()});
 f.app.world_mut().entity_mut(second).insert(MeshMaterial3d(replacement.clone()));f.update();
 let rebound=f.handle(second);assert_eq!(f.app.world().get::<actor_fow::Bound>(second).unwrap().source,replacement);
 assert!(f.app.world().get::<host::Guard>(second).is_none());
 f.app.world_mut().resource_mut::<host::Requests>().clear();f.update();assert_eq!(f.handle(second),rebound);
}

#[test]
fn w_equal_priority_refresh_keeps_order_and_removal_reveals_previous_owner() {
 let mut f=Fixture::new();let root=f.root(1);let p=f.primitive(root);f.update();let baseline=f.handle(p);
 f.request(root,1,11);f.request(root,1,22);f.request(root,1,11);f.update();
 assert_eq!(f.app.world().get::<host::Guard>(p).unwrap().owner,22);let private=f.handle(p);
 f.app.world_mut().resource_mut::<host::Requests>().remove(root,22).unwrap();f.update();
 assert_eq!(f.app.world().get::<host::Guard>(p).unwrap().owner,11);assert_eq!(f.handle(p),private);
 f.app.world_mut().resource_mut::<host::Requests>().remove(root,11).unwrap();f.update();assert_eq!(f.handle(p),baseline);
}

#[test]
fn w_late_children_hidden_roots_sessions_and_despawn_retire_leases() {
 let mut f=Fixture::new();let root=f.root(1);f.request(root,1,1);f.update();let p=f.primitive(root);f.update();
 let baseline=f.app.world().get::<host::Guard>(p).unwrap().previous.clone();
 f.app.world_mut().entity_mut(root).insert(Visibility::Hidden);f.update();assert_eq!(f.handle(p),baseline);
 f.app.world_mut().entity_mut(root).insert(Visibility::Visible);f.update();assert!(f.app.world().get::<host::Guard>(p).is_some());
 f.app.world_mut().resource_mut::<host::Requests>().reset(11);f.update();assert_eq!(f.handle(p),baseline);
 f.request(root,1,2);f.update();assert_eq!(f.app.world().get::<host::Guard>(p).unwrap().session,11);
 drop(baseline);f.app.world_mut().despawn(root);for _ in 0..5 {f.update();}
 assert_eq!(f.app.world().resource::<host::Requests>().root_count(),0);
 assert!(f.app.world().resource::<actor_fow::Cache>().bindings.is_empty());
 let mut guards=f.app.world_mut().query::<&host::Guard>();assert_eq!(guards.iter(f.app.world()).count(),0);
 let mut leases=f.app.world_mut().query::<&actor_fow::BaselineLease>();assert_eq!(leases.iter(f.app.world()).count(),0);
 assert!(f.app.world().resource::<Assets<FogMaterial>>().is_empty());
}

#[test]
fn w_null_or_unloaded_baseline_and_unloaded_dds_preserve_baseline() {
 let mut f=Fixture::new();let root=f.root(1);let p=f.primitive(root);f.update();let baseline=f.handle(p);f.request(root,1,1);
 {let mut a=f.app.world_mut().resource_mut::<Assets<StandardMaterial>>();a.get_mut(&f.source).unwrap().base_color_texture=None;}
 f.update();f.update();assert_eq!(f.handle(p),baseline);assert!(f.app.world().get::<host::Guard>(p).is_none());
 assert!(f.app.world().resource::<host::Diagnostics>().issues[&p].contains("nonnull"));
 {let mut a=f.app.world_mut().resource_mut::<Assets<StandardMaterial>>();a.get_mut(&f.source).unwrap().base_color_texture=Some(f.base_image.clone());}
 f.update();f.update();assert!(f.app.world().get::<host::Guard>(p).is_some());
 f.app.world_mut().resource_mut::<Assets<Image>>().remove(f.w_image.id());f.update();
 assert_eq!(f.handle(p),baseline);assert!(f.app.world().resource::<host::Diagnostics>().issues[&p].contains("DDS"));
 let loaded_w=f.app.world_mut().resource_mut::<Assets<Image>>().add(Image::default());
 f.app.world_mut().resource_mut::<host::Profile>().texture=loaded_w;
 f.app.world_mut().resource_mut::<Assets<Image>>().remove(f.base_image.id());f.update();assert_eq!(f.handle(p),baseline);
 assert!(f.app.world().resource::<host::Diagnostics>().issues[&p].contains("nonnull"));
}

#[test]
fn w_requires_exact_base_asset_and_rejects_foreign_source_without_mutation() {
 let mut f=Fixture::new();let root=f.root(1);let p=f.primitive(root);f.update();let baseline=f.handle(p);
 f.request(root,1,1);assert!(f.app.world_mut().resource_mut::<host::Requests>().insert_base(root,2,2).is_err());
 let other=f.app.world().resource::<Assets<Gltf>>().reserve_handle();
 let base=f.model.clone();
 f.app.world_mut().entity_mut(root).insert(animation::material_test_playback(1,other));f.update();
 assert_eq!(f.handle(p),baseline);assert!(f.app.world().resource::<host::Diagnostics>().issues[&p].contains("base Garen"));
 f.app.world_mut().entity_mut(root).insert(animation::material_test_playback(1,base));f.update();
 assert!(f.app.world().get::<host::Guard>(p).is_some());
 let other=f.app.world().resource::<Assets<Gltf>>().reserve_handle();
 f.app.world_mut().entity_mut(root).insert(animation::material_test_playback(1,other));f.update();
 assert_eq!(f.handle(p),baseline);assert!(f.app.world().get::<host::Guard>(p).is_none());
}

#[test]
fn w_removed_binding_contract_retires_only_its_guard_without_guessing_source() {
 let mut f=Fixture::new();let root=f.root(1);let p=f.primitive(root);f.update();f.request(root,1,1);f.update();
 let private=f.handle(p);f.app.world_mut().entity_mut(p).remove::<actor_fow::Bound>();f.update();
 assert_eq!(f.handle(p),private);assert!(f.app.world().get::<host::Guard>(p).is_none());
 assert!(f.app.world().get::<actor_fow::BaselineLease>(p).is_none());
 assert!(f.app.world().resource::<host::Diagnostics>().issues[&p].contains("removed externally"));
 // This is loss of source authority, not a successful native restoration.
 assert_eq!(f.app.world().resource::<host::Diagnostics>().restored,0);
 assert_eq!(f.app.world().resource::<host::Diagnostics>().superseded,1);
}

#[test]
fn w_probe_reports_actual_fixture_handles_before_during_and_after_override() {
 // Diagnostic CPU fixture only: it does not assert an observed match or pixels.
 use openleague_core::{Navigation,Simulation};
 let mut bytes=Vec::new();for _ in 0..16 {bytes.extend(0f32.to_le_bytes());bytes.extend(0u16.to_le_bytes());bytes.extend(0u32.to_le_bytes());bytes.push(1);}
 let navigation=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":4,"height":4}"#,&bytes).unwrap();
 let mut game=Simulation::new(navigation).unwrap();game.session=10;game.join("garen").unwrap();
 let snapshot=game.snapshot();let source=snapshot.players[0].id;
 let mut f=Fixture::new();let root=f.root(source);let p=f.primitive(root);f.update();let baseline=f.handle(p);
 let mut state=crate::Match::default();state.snapshot=Some(snapshot);state.visuals.insert(source,root);
 f.app.insert_resource(state).init_resource::<crate::native_effect_clock::EffectClock>().init_resource::<crate::garen_w_live::Bindings>();
 let before=crate::garen_w_probe::snapshot(f.app.world_mut());
 assert_eq!(before["meshes"].as_array().unwrap().len(),1);assert!(before["meshes"][0]["guard"].is_null());
 f.request(root,source,1);f.update();let private=f.handle(p);
 let active=crate::garen_w_probe::snapshot(f.app.world_mut());
 assert_eq!(active["meshes"][0]["current"]["id"],format!("{:?}",private.id()));
 assert_eq!(active["meshes"][0]["guard"]["previous"]["id"],format!("{:?}",baseline.id()));
 assert_eq!(active["meshes"][0]["guard"]["current_is_private"],true);
 assert_eq!(active["meshes"][0]["skinned_joints"],1);
 f.app.world_mut().resource_mut::<host::Requests>().clear();f.update();
 let after=crate::garen_w_probe::snapshot(f.app.world_mut());
 assert_eq!(after["meshes"][0]["current"]["id"],format!("{:?}",baseline.id()));
 assert!(after["meshes"][0]["guard"].is_null());assert!(after["meshes"][0]["baseline_lease"].is_null());
 assert_eq!(after["limits"]["pixels_qualified"],false);
}
