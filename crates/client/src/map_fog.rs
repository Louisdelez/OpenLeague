use bevy::{
    gltf::GltfMaterialName,
    pbr::{ExtendedMaterial, MaterialExtension},
    prelude::*,
    reflect::TypePath,
    render::render_resource::AsBindGroup,
    shader::ShaderRef,
};
use std::collections::{HashMap, HashSet};
#[derive(Asset, TypePath, AsBindGroup, Debug, Clone)]
#[bind_group_data(u32)]
pub struct FogExtension {
    #[uniform(123)] pub high_fog0:Vec4,
    #[uniform(124)] pub high_fog1:Vec4,
    #[uniform(125)] pub cloud_phase:Vec4,
    #[texture(126)] #[sampler(127)] pub cloud_opacity:Handle<Image>,
    #[uniform(128)] pub fog_mod2x:u32,
    #[uniform(129)] pub fog_profile:UVec4,
    #[uniform(130)] pub fog_constant:Vec4,

    pub native_draw_mode:u32,
    #[uniform(100)]
    pub opaque: Vec4,
    #[uniform(101)]
    pub spatial_denominator: f32,
    #[texture(102)]
    #[sampler(103)]
    pub lighting: Handle<Image>,
    #[uniform(104)]
    pub vertex_lighting_factor: f32,
    #[uniform(105)]
    pub diagnostic_channel: u32,
    #[texture(106)] #[sampler(107)] pub visibility_map:Handle<Image>,
    #[uniform(108)] pub visibility_params:Vec4,
    #[uniform(109)] pub visibility_height:Vec4,
    #[uniform(110)] pub visibility_edge:Vec4,
    #[texture(111)] #[sampler(112)] pub visibility_overlay:Handle<Image>,
    #[uniform(113)] pub visibility_below:Vec4,
    #[uniform(114)] pub visibility_ready:u32,
    #[uniform(115)] pub factor_mode:u32,
    #[uniform(116)] pub colormap_lighting_factor:f32,
    #[uniform(117)] pub terrain_transform:Vec4,
    #[texture(118)] #[sampler(119)] pub colormap:Handle<Image>,
    #[uniform(120)] pub fog_coordinates:Vec4,
    #[uniform(121)] pub alpha_test_enabled:u32,
    #[uniform(122)] pub alpha_reference:f32,
}
impl From<&FogExtension> for u32 {fn from(value:&FogExtension)->Self {value.native_draw_mode}}
impl MaterialExtension for FogExtension {
    fn specialize(_: &bevy::pbr::MaterialExtensionPipeline,descriptor:&mut bevy::render::render_resource::RenderPipelineDescriptor,_:&bevy::mesh::MeshVertexBufferLayoutRef,key:bevy::pbr::MaterialExtensionKey<Self>)->Result<(),bevy::render::render_resource::SpecializedMeshPipelineError> {crate::native_environment_draw::apply_pipeline(descriptor,key.bind_group_data);Ok(())}
    fn vertex_shader()->ShaderRef { "shaders/environment_fow_vertex.wgsl".into() }
    fn fragment_shader() -> ShaderRef {
        "shaders/native_environment_fog.wgsl".into()
    }
}
pub type FogMaterial = ExtendedMaterial<StandardMaterial, FogExtension>;
#[derive(Resource)]
pub struct FogCatalog {
    pub extension: FogExtension,
    allowed: HashSet<String>,
    vertex_factors: HashMap<String, f32>,
    colormap_factors: HashMap<String, f32>,
    draw_modes:HashMap<String,u32>,
    pub selector7_names:HashSet<String>,
}
#[derive(Component)]
pub struct NativeFogBound {pub source:Handle<StandardMaterial>}
#[derive(Resource,Default)] pub struct Cache {
 pub bindings:HashMap<AssetId<StandardMaterial>,Handle<FogMaterial>>,
 pub missing_sources:HashSet<AssetId<StandardMaterial>>,pub synchronized:u64,pub released:u64,
}
pub fn setup(mut commands: Commands, assets: Res<AssetServer>,native_settings:Res<crate::environment_render_config::State>,quality:Res<crate::native_environment_draw::Quality>) {
    println!("Native environment quality={} (original PE initial profile; user settings dispatch pending)",quality.value);
    native_settings.require_current_material_profile().expect("native environment material profile");
    println!("Native environment renderer={} height_blend={} colormap={} shadow_dynamic_only={} alpha_reference={} (alpha draw-state qualification pending)",native_settings.renderer,native_settings.height_blend,native_settings.colormap,native_settings.shadow_dynamic_only,native_settings.alpha_reference);
    let data: serde_json::Value =
        serde_json::from_str(include_str!("../../../data/4.20/map_fog_settings.json"))
            .expect("native map fog configuration");
    let p = data["fog_data1"].as_array().unwrap();
    let extension = FogExtension {
        high_fog0:crate::native_high_fog::fog_vectors().0,
        high_fog1:crate::native_high_fog::fog_vectors().1,
        cloud_phase:Vec4::from_array(crate::native_cloud_phase::Phase::default().constants(2000.)),
        cloud_opacity:crate::native_high_fog::cloud_image(&assets),
        fog_mod2x:u32::from(native_settings.colormap),
        fog_profile:crate::native_high_fog::profile_uniform(3),
        fog_constant:crate::native_high_fog::fog_constant(),
        opaque: Vec4::new(
            p[1].as_f64().unwrap() as f32,
            p[2].as_f64().unwrap() as f32,
            crate::map_coordinates::NATIVE_UNITS_PER_WORLD_UNIT,
            0., // Reserved: world Z is direct; native texture UV still uses c230.
        ),
        visibility_map:Handle::default(),visibility_params:Vec4::ZERO,visibility_height:Vec4::ZERO,visibility_edge:Vec4::ZERO,visibility_overlay:Handle::default(),visibility_below:Vec4::ZERO,visibility_ready:0,factor_mode:1,
        native_draw_mode:0,alpha_test_enabled:1,alpha_reference:crate::native_alpha::shader_reference(native_settings.alpha_reference).expect("native map alpha reference"),
        fog_coordinates:crate::terrain_material::native_map_fog_coordinates(),
        colormap_lighting_factor:0.,terrain_transform:crate::terrain_material::map10_terrain_transform(),
        colormap:crate::terrain_material::image(&assets,"maps/terrain_native/compositeColorMap.png".into(),false),
        spatial_denominator: data["spatial_denominator"].as_f64().unwrap() as f32,
        vertex_lighting_factor: 0.,
        diagnostic_channel: if crate::fow_visibility_texture::parameter_diagnostic_enabled() {4} else if crate::fow_visibility_texture::diagnostic_enabled() {3} else if std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some() {
            std::env::var("OPENLEAGUE_PROBE_CHANNEL")
                .ok()
                .and_then(|s| s.parse::<u32>().ok())
                .filter(|v| *v <= 2)
                .unwrap_or(0)
        } else {
            0
        },
        lighting: crate::terrain_material::image(
            &assets,
            data["fog_lighting"].as_str().unwrap().into(),
            false,
        ),
    };
    let allowed = data["environment_materials"]
        .as_array()
        .unwrap()
        .iter()
        .map(|x| x.as_str().unwrap().to_owned())
        .collect();
    let vertex: serde_json::Value =
        serde_json::from_str(include_str!("../../../data/4.20/environment_lighting.json"))
            .expect("native environment vertex lighting");
    let vertex_factors = vertex["material_factors"]
        .as_object()
        .unwrap()
        .iter()
        .map(|(name, factor)| (name.clone(), factor.as_f64().unwrap() as f32))
        .collect();
    commands.insert_resource(FogCatalog {
        extension,
        allowed,
        vertex_factors,
        colormap_factors:native_colormap_factors(),
        draw_modes:crate::native_environment_draw::map10_modes(quality.value),
        selector7_names:crate::native_environment_draw::selector7_names(quality.value),
    });
}
pub fn bind(
    mut commands: Commands,
    catalog: Res<FogCatalog>,
    base: Res<Assets<StandardMaterial>>,
    mut materials: ResMut<Assets<FogMaterial>>,
    query: Query<
        (Entity, &GltfMaterialName, &MeshMaterial3d<StandardMaterial>),
        With<Mesh3d>,
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
        if let Some(mut material)=materials.get_mut(&handle) {material.base=native_draw_base(source,material.extension.alpha_test_enabled,material.extension.native_draw_mode);cache.synchronized+=1;cache.missing_sources.remove(&id);}
    }
    for (entity, name, original) in &query {
        if !catalog.allowed.contains(&name.0) {
            continue;
        }
        let Some(material) = base.get(&original.0) else {
            continue;
        };
        let handle = cache.bindings
            .entry(original.0.id())
            .or_insert_with(|| {
                materials.add(FogMaterial {
                    base: native_draw_base(material,catalog.extension.alpha_test_enabled,catalog.draw_modes.get(&name.0).copied().unwrap_or(0)),
                    extension: FogExtension {
                        alpha_test_enabled:if catalog.selector7_names.contains(&name.0) {0} else {catalog.extension.alpha_test_enabled},
                        native_draw_mode:catalog.draw_modes.get(&name.0).copied().unwrap_or(0),
                        colormap_lighting_factor:catalog.colormap_factors.get(&name.0).copied().unwrap_or(0.),
                        vertex_lighting_factor: catalog
                            .vertex_factors
                            .get(&name.0)
                            .copied()
                            .unwrap_or(0.),
                        ..catalog.extension.clone()
                    },
                })
            })
            .clone();
        commands
            .entity(entity)
            .remove::<MeshMaterial3d<StandardMaterial>>()
            .insert((MeshMaterial3d(handle), NativeFogBound {source:original.0.clone()}));
        *count += 1;
        if *count == 1 {
            println!("Native environment fog bound");
        }
    }
}

/// Dump loaded geometry and bindings only for an explicitly enabled diagnostic.
pub fn dump_probe(
    time: Res<Time>,
    mut written: Local<bool>,
    meshes: Res<Assets<Mesh>>,
    materials: Res<Assets<FogMaterial>>,
    query: Query<(
        &bevy::gltf::GltfMeshName,
        &Mesh3d,
        &GlobalTransform,
        Option<&MeshMaterial3d<FogMaterial>>,
    )>,
) {
    if *written
        || time.elapsed_secs() < 50.
        || std::env::var_os("OPENLEAGUE_SCREENSHOT").is_none()
        || std::env::var("OPENLEAGUE_PROBE_LOADED_MESHES").as_deref() != Ok("1")
    {
        return;
    }
    fn attribute(mesh: &Mesh, key: bevy::mesh::MeshVertexAttribute) -> serde_json::Value {
        use bevy::mesh::VertexAttributeValues;
        match mesh.attribute(key) {
            Some(VertexAttributeValues::Float32x2(v)) => serde_json::json!(v),
            Some(VertexAttributeValues::Float32x3(v)) => serde_json::json!(v),
            Some(VertexAttributeValues::Float32x4(v)) => serde_json::json!(v),
            _ => serde_json::Value::Null,
        }
    }
    let mut rows = Vec::new();
    for (name, handle, transform, material) in &query {
        if !["MapGeo_Instance_365", "MapGeo_Instance_534"].contains(&name.0.as_str()) {
            continue;
        }
        let Some(mesh) = meshes.get(&handle.0) else {
            continue;
        };
        let bound = material.and_then(|m| materials.get(&m.0));
        rows.push(serde_json::json!({"mesh":name.0,"world_matrix":transform.to_matrix().to_cols_array(),
            "native_factor":bound.map(|m|m.extension.vertex_lighting_factor),"diagnostic_channel":bound.map(|m|m.extension.diagnostic_channel),
            "positions":attribute(mesh,Mesh::ATTRIBUTE_POSITION),"uv":attribute(mesh,Mesh::ATTRIBUTE_UV_0),"colors":attribute(mesh,Mesh::ATTRIBUTE_COLOR),
            "indices":mesh.indices().map(|v|v.iter().collect::<Vec<_>>())}));
    }
    if rows.len() < 2 {
        return;
    }
    let path = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("../../logs/native_vertex_loaded_meshes.json");
    std::fs::write(path, serde_json::to_vec_pretty(&rows).unwrap())
        .expect("write native mesh diagnostic");
    println!("Native loaded mesh diagnostic: {} instances", rows.len());
    *written = true;
}

#[cfg(test)] mod actor_binding_tests {
 use super::*;
 use crate::actor_fow;
 #[test] fn native_actor_material_binding_preserves_skin_alpha_texture_and_scene_boundaries() {
  let extension=FogExtension {high_fog0:Vec4::ZERO,high_fog1:Vec4::ZERO,cloud_phase:Vec4::ZERO,cloud_opacity:Handle::default(),fog_mod2x:0,fog_profile:UVec4::new(2,1,1,0),fog_constant:Vec4::ZERO,opaque:Vec4::ZERO,spatial_denominator:15360.,lighting:Handle::default(),vertex_lighting_factor:8.,diagnostic_channel:0,visibility_map:Handle::default(),visibility_params:Vec4::ZERO,visibility_height:Vec4::ZERO,visibility_edge:Vec4::ZERO,visibility_overlay:Handle::default(),visibility_below:Vec4::ZERO,visibility_ready:0,factor_mode:1,colormap_lighting_factor:4.,terrain_transform:Vec4::ZERO,colormap:Handle::default(),fog_coordinates:Vec4::ZERO,native_draw_mode:0,alpha_test_enabled:1,alpha_reference:1./255.};
  let mut app=App::new();app.init_resource::<actor_fow::Cache>().add_message::<bevy::asset::AssetEvent<StandardMaterial>>().init_resource::<Assets<StandardMaterial>>().init_resource::<Assets<FogMaterial>>().insert_resource(FogCatalog {extension,allowed:HashSet::new(),vertex_factors:HashMap::new(),colormap_factors:HashMap::new(),draw_modes:HashMap::new(),selector7_names:HashSet::new()}).add_systems(Update,actor_fow::bind);
  let source=StandardMaterial {base_color_texture:Some(Handle::default()),alpha_mode:AlphaMode::Mask(0.3),double_sided:true,unlit:true,perceptual_roughness:0.2,metallic:0.5,..default()};
  let material=app.world_mut().resource_mut::<Assets<StandardMaterial>>().add(source.clone());let root=app.world_mut().spawn(actor_fow::Root).id();let intermediate=app.world_mut().spawn(ChildOf(root)).id();let joint=app.world_mut().spawn_empty().id();
  let entity=app.world_mut().spawn((ChildOf(intermediate),Mesh3d(Handle::default()),MeshMaterial3d(material.clone()),bevy::mesh::skinning::SkinnedMesh {inverse_bindposes:Handle::default(),joints:vec![joint]},Transform::from_xyz(1.,2.,3.))).id();
  let decor=app.world_mut().spawn((Mesh3d(Handle::default()),MeshMaterial3d(material.clone()))).id();
  app.update();let handle=app.world().get::<MeshMaterial3d<FogMaterial>>(entity).unwrap().0.clone();let actual=app.world().resource::<Assets<FogMaterial>>().get(&handle).unwrap();
  assert_eq!(actual.base.base_color_texture,source.base_color_texture);assert_eq!(actual.base.alpha_mode,source.alpha_mode);assert!(actual.base.double_sided && actual.base.unlit);assert_eq!(actual.base.perceptual_roughness,0.2);assert_eq!(actual.base.metallic,0.5);assert_eq!(actual.extension.alpha_test_enabled,0);assert_eq!(actual.extension.colormap_lighting_factor,0.);assert_eq!(actual.extension.factor_mode,0);assert_eq!(actual.extension.vertex_lighting_factor,0.);
  assert_eq!(app.world().get::<bevy::mesh::skinning::SkinnedMesh>(entity).unwrap().joints,vec![joint]);assert_eq!(app.world().get::<Transform>(entity).unwrap().translation,Vec3::new(1.,2.,3.));assert!(app.world().get::<MeshMaterial3d<StandardMaterial>>(decor).is_some());
  let late=app.world_mut().spawn((ChildOf(root),Mesh3d(Handle::default()),MeshMaterial3d(material))).id();app.update();assert_eq!(app.world().get::<MeshMaterial3d<FogMaterial>>(late).unwrap().0,handle);assert_eq!(app.world().resource::<Assets<FogMaterial>>().len(),1);
 }
 #[test] fn source_edits_and_rebinding_preserve_fog_uniforms_and_retire_unused_assets() {
  use bevy::asset::{AssetApp,AssetPlugin};
  let extension=FogExtension {high_fog0:Vec4::ZERO,high_fog1:Vec4::ZERO,cloud_phase:Vec4::ZERO,cloud_opacity:Handle::default(),fog_mod2x:0,fog_profile:UVec4::new(2,1,1,0),fog_constant:Vec4::ZERO,opaque:Vec4::ZERO,spatial_denominator:15360.,lighting:Handle::default(),vertex_lighting_factor:0.,diagnostic_channel:0,visibility_map:Handle::default(),visibility_params:Vec4::ZERO,visibility_height:Vec4::ZERO,visibility_edge:Vec4::ZERO,visibility_overlay:Handle::default(),visibility_below:Vec4::ZERO,visibility_ready:0,factor_mode:1,colormap_lighting_factor:4.,terrain_transform:Vec4::ZERO,colormap:Handle::default(),fog_coordinates:Vec4::ZERO,native_draw_mode:0,alpha_test_enabled:1,alpha_reference:1./255.};
  let mut app=App::new();app.add_plugins((MinimalPlugins,AssetPlugin::default())).init_asset::<StandardMaterial>().init_asset::<FogMaterial>().init_resource::<actor_fow::Cache>().insert_resource(FogCatalog {extension,allowed:HashSet::new(),vertex_factors:HashMap::new(),colormap_factors:HashMap::new(),draw_modes:HashMap::new(),selector7_names:HashSet::new()}).add_systems(Update,actor_fow::bind);
  let source=app.world_mut().resource_mut::<Assets<StandardMaterial>>().add(StandardMaterial {unlit:true,..default()});let first_id=source.id();
  let root=app.world_mut().spawn(actor_fow::Root).id();let a=app.world_mut().spawn((ChildOf(root),Mesh3d(Handle::default()),MeshMaterial3d(source.clone()))).id();let b=app.world_mut().spawn((ChildOf(root),Mesh3d(Handle::default()),MeshMaterial3d(source.clone()))).id();app.update();
  let fog=app.world().get::<MeshMaterial3d<FogMaterial>>(a).unwrap().0.clone();let fog_id=fog.id();
  {let mut materials=app.world_mut().resource_mut::<Assets<FogMaterial>>();let mut m=materials.get_mut(&fog).unwrap();m.extension.visibility_ready=1;m.extension.visibility_params=Vec4::new(1.,-1.,0.,1.);}
  {let mut materials=app.world_mut().resource_mut::<Assets<StandardMaterial>>();let mut m=materials.get_mut(&source).unwrap();m.alpha_mode=AlphaMode::Blend;m.base_color=Color::srgba(0.2,0.3,0.4,0.5);m.base_color_texture=Some(Handle::default());}
  app.update();app.update();let actual=app.world().resource::<Assets<FogMaterial>>().get(&fog).unwrap();assert_eq!(actual.base.alpha_mode,AlphaMode::Blend);assert_eq!(actual.base.base_color,Color::srgba(0.2,0.3,0.4,0.5));assert!(actual.base.base_color_texture.is_some());assert_eq!(actual.extension.visibility_ready,1);assert_eq!(actual.extension.visibility_params,Vec4::new(1.,-1.,0.,1.));assert_eq!(actual.extension.alpha_test_enabled,0);assert_eq!(actual.extension.colormap_lighting_factor,0.);assert_eq!(actual.extension.factor_mode,0);
  assert_eq!(app.world().get::<MeshMaterial3d<FogMaterial>>(b).unwrap().0,fog);assert!(app.world().resource::<actor_fow::Cache>().synchronized>0);
  // A new material on an existing entity must rebind, even though it already has Bound.
  let replacement=app.world_mut().resource_mut::<Assets<StandardMaterial>>().add(StandardMaterial {alpha_mode:AlphaMode::Mask(0.7),..default()});app.world_mut().entity_mut(a).insert(MeshMaterial3d(replacement.clone()));app.update();assert_ne!(app.world().get::<MeshMaterial3d<FogMaterial>>(a).unwrap().0,fog);assert_eq!(app.world().get::<actor_fow::Bound>(a).unwrap().source,replacement);
  app.world_mut().despawn(a);app.update();assert_eq!(app.world().resource::<actor_fow::Cache>().bindings.len(),1);assert!(app.world().resource::<Assets<FogMaterial>>().get(fog_id).is_some());
  // The source strong handle survives only through remaining owning model instances.
  drop(source);drop(replacement);drop(fog);app.world_mut().despawn(root);for _ in 0..5 {app.update();}
  assert!(app.world().resource::<actor_fow::Cache>().bindings.is_empty());assert!(app.world().resource::<Assets<FogMaterial>>().is_empty());assert!(app.world().resource::<Assets<StandardMaterial>>().get(first_id).is_none());assert!(app.world().resource::<actor_fow::Cache>().released>=2);
 }

}

pub fn probe_lifecycle(cache:Res<Cache>,materials:Res<Assets<FogMaterial>>,query:Query<&MeshMaterial3d<FogMaterial>,With<NativeFogBound>>) {
 let Ok(path)=std::env::var("OPENLEAGUE_ENVIRONMENT_FOW_PROBE") else {return;};
 let bound=query.iter().count();let ready=query.iter().filter(|h|materials.get(&h.0).is_some_and(|m|m.extension.visibility_ready==1)).count();
 let colormap_meshes=query.iter().filter(|h|materials.get(&h.0).is_some_and(|m|m.extension.colormap_lighting_factor==4.)).count();
 let native_alpha_meshes=query.iter().filter(|h|materials.get(&h.0).is_some_and(|m|m.extension.alpha_test_enabled==1)).count();
 let alpha_reference_bits:std::collections::BTreeSet<_>=query.iter().filter_map(|h|materials.get(&h.0).map(|m|m.extension.alpha_reference.to_bits())).collect();
 let native_blended_meshes=query.iter().filter(|h|materials.get(&h.0).is_some_and(|m|m.extension.native_draw_mode==2 && m.base.alpha_mode==AlphaMode::Blend)).count();
 let native_opaque_meshes=query.iter().filter(|h|materials.get(&h.0).is_some_and(|m|m.extension.native_draw_mode==1 && m.base.alpha_mode==AlphaMode::Mask(0.))).count();
 let report=serde_json::json!({"native_blended_meshes":native_blended_meshes,"native_opaque_meshes":native_opaque_meshes,"native_alpha_meshes":native_alpha_meshes,"alpha_reference_bits":alpha_reference_bits,"colormap_meshes":colormap_meshes,"complete":false,"bound_meshes":bound,"ready_materials":ready,"cached_materials":cache.bindings.len(),"source_synchronizations":cache.synchronized,"released_cache_entries":cache.released,"missing_sources":cache.missing_sources.len(),"limits":["ECS ownership and readiness observations; material-edit pixel equivalence and whole-match release remain open.","Full native material variant shader execution remains open."]});let _=std::fs::write(path,serde_json::to_vec_pretty(&report).unwrap());
}
#[cfg(test)] mod environment_lifecycle_tests {
 use super::*;
 #[test] fn environment_source_changes_rebinding_and_gc_preserve_native_controls_and_scene_scope() {
  use bevy::asset::{AssetApp,AssetPlugin};
  let extension=FogExtension {high_fog0:Vec4::ZERO,high_fog1:Vec4::ZERO,cloud_phase:Vec4::ZERO,cloud_opacity:Handle::default(),fog_mod2x:0,fog_profile:UVec4::new(2,1,1,0),fog_constant:Vec4::ZERO,opaque:Vec4::ZERO,spatial_denominator:15360.,lighting:Handle::default(),vertex_lighting_factor:0.,diagnostic_channel:0,visibility_map:Handle::default(),visibility_params:Vec4::ZERO,visibility_height:Vec4::ZERO,visibility_edge:Vec4::ZERO,visibility_overlay:Handle::default(),visibility_below:Vec4::ZERO,visibility_ready:0,factor_mode:1,colormap_lighting_factor:4.,terrain_transform:Vec4::ZERO,colormap:Handle::default(),fog_coordinates:Vec4::ZERO,native_draw_mode:0,alpha_test_enabled:1,alpha_reference:1./255.};
  let name="NVRFixture".to_string();let mut app=App::new();app.add_plugins((MinimalPlugins,AssetPlugin::default())).init_asset::<StandardMaterial>().init_asset::<FogMaterial>().init_resource::<Cache>().insert_resource(FogCatalog {extension,allowed:HashSet::from([name.clone()]),vertex_factors:HashMap::from([(name.clone(),8.)]),colormap_factors:HashMap::new(),draw_modes:HashMap::new(),selector7_names:HashSet::new()}).add_systems(Update,bind);
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

// Actual Map10 native selector0 DECAL variants; names mapped through NVR mesh references.
fn native_colormap_factors() -> HashMap<String,f32> {
 let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map10_shader_material_fields.json")).expect("native material fields");
 proof["gltf_materials_matched"].as_array().unwrap().iter().filter(|p| {
  let kind=p["type"].as_u64().unwrap();let flags=p["flags"].as_u64().unwrap();
  kind==1 || (kind==0 && flags&8!=0)
 }).map(|p|(p["name"].as_str().unwrap().to_owned(),4.)).collect()
}
#[cfg(test)] mod native_colormap_tests {
 use super::*;
 #[test] fn all_map10_colormap_routes_match_actual_original_selected_shader_and_empty_emissive_slot() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map10_shader_material_fields.json")).unwrap();
  let handles:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map10_texture_handle_fields.json")).unwrap();
  let factors=native_colormap_factors();assert_eq!(factors.len(),14);
  for binding in proof["gltf_materials_matched"].as_array().unwrap() {
   let index=binding["native_material_index"].as_u64().unwrap();
   let profile=proof["profiles"].as_array().unwrap().iter().find(|p|p["native_material_index"].as_u64()==Some(index)).unwrap();
   let selected=&profile["selector0"][0]["selected"];
   let decal=selected.as_array().unwrap().iter().any(|s|s["name"]=="Environment_LIT_NO_EMISSIVE_DECAL_PS");
   assert_eq!(factors.contains_key(binding["name"].as_str().unwrap()),decal);
   if decal {
    for source in handles["cases"].as_array().unwrap().iter().filter(|c|c["native_material_index"].as_u64()==Some(index)) {
     assert_eq!(source["source_texture_names"][1],"");assert_eq!(source["handle_presence"][1],false);
    }
   }
  }
 }
}

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

fn native_draw_base(source:&StandardMaterial,alpha_enabled:u32,mode:u32)->StandardMaterial {
 let mut base=native_alpha_base(source,alpha_enabled);
 match mode {1=>base.alpha_mode=AlphaMode::Mask(0.),2=>base.alpha_mode=AlphaMode::Blend,0=>{},_=>panic!("unsupported native material mode")};base
}
#[cfg(test)] mod native_draw_policy_tests {
 use super::*;
 #[test] fn native_blend_overrides_source_cutout_and_survives_real_source_update() {
  let extension=FogExtension {high_fog0:Vec4::ZERO,high_fog1:Vec4::ZERO,cloud_phase:Vec4::ZERO,cloud_opacity:Handle::default(),fog_mod2x:0,fog_profile:UVec4::new(2,1,1,0),fog_constant:Vec4::ZERO,native_draw_mode:2,opaque:Vec4::ZERO,spatial_denominator:15360.,lighting:Handle::default(),vertex_lighting_factor:0.,diagnostic_channel:0,visibility_map:Handle::default(),visibility_params:Vec4::ZERO,visibility_height:Vec4::ZERO,visibility_edge:Vec4::ZERO,visibility_overlay:Handle::default(),visibility_below:Vec4::ZERO,visibility_ready:0,factor_mode:1,colormap_lighting_factor:0.,terrain_transform:Vec4::ZERO,colormap:Handle::default(),fog_coordinates:Vec4::ZERO,alpha_test_enabled:1,alpha_reference:1./255.};
  let name="NativeBlendFixture".to_string();let mut app=App::new();app.add_plugins((MinimalPlugins,AssetPlugin::default())).init_asset::<StandardMaterial>().init_asset::<FogMaterial>().init_resource::<Cache>().insert_resource(FogCatalog {extension,allowed:HashSet::from([name.clone()]),vertex_factors:HashMap::new(),colormap_factors:HashMap::new(),draw_modes:HashMap::from([(name.clone(),2)]),selector7_names:HashSet::new()}).add_systems(Update,bind);
  let source=app.world_mut().resource_mut::<Assets<StandardMaterial>>().add(StandardMaterial {alpha_mode:AlphaMode::Mask(0.3),..default()});let entity=app.world_mut().spawn((Mesh3d(Handle::default()),GltfMaterialName(name),MeshMaterial3d(source.clone()))).id();app.update();app.update();let handle=app.world().get::<MeshMaterial3d<FogMaterial>>(entity).unwrap().0.clone();assert_eq!(app.world().resource::<Assets<FogMaterial>>().get(&handle).unwrap().base.alpha_mode,AlphaMode::Blend);
  app.world_mut().resource_mut::<Assets<StandardMaterial>>().get_mut(&source).unwrap().alpha_mode=AlphaMode::Opaque;app.update();app.update();let m=app.world().resource::<Assets<FogMaterial>>().get(&handle).unwrap();assert_eq!(m.base.alpha_mode,AlphaMode::Blend);assert_eq!(m.extension.native_draw_mode,2);assert!(app.world().resource::<Cache>().synchronized>0);
  assert_eq!(native_draw_base(&StandardMaterial::default(),1,1).alpha_mode,AlphaMode::Mask(0.));
 }
}

#[cfg(test)] mod selector7_lifecycle_tests {
 use super::*;
 #[test] fn depth_descendant_shares_geometry_tracks_source_replacement_and_releases_on_parent_despawn() {
 let extension=FogExtension {high_fog0:Vec4::ZERO,high_fog1:Vec4::ZERO,cloud_phase:Vec4::ZERO,cloud_opacity:Handle::default(),fog_mod2x:0,fog_profile:UVec4::new(2,1,1,0),fog_constant:Vec4::ZERO,native_draw_mode:2,opaque:Vec4::ZERO,spatial_denominator:15360.,lighting:Handle::default(),vertex_lighting_factor:0.,diagnostic_channel:0,visibility_map:Handle::default(),visibility_params:Vec4::ZERO,visibility_height:Vec4::ZERO,visibility_edge:Vec4::ZERO,visibility_overlay:Handle::default(),visibility_below:Vec4::ZERO,visibility_ready:0,factor_mode:1,colormap_lighting_factor:0.,terrain_transform:Vec4::ZERO,colormap:Handle::default(),fog_coordinates:Vec4::ZERO,alpha_test_enabled:0,alpha_reference:1./255.};
 let name=crate::native_environment_draw::selector7_names(3).into_iter().next().unwrap();let mut app=App::new();app.add_plugins((MinimalPlugins,AssetPlugin::default())).init_asset::<FogMaterial>().init_resource::<crate::selector7_depth::Cache>().insert_resource(FogCatalog {extension:extension.clone(),allowed:HashSet::new(),vertex_factors:HashMap::new(),colormap_factors:HashMap::new(),draw_modes:HashMap::new(),selector7_names:HashSet::from([name.clone()])}).add_systems(Update,crate::selector7_depth::synchronize);
 let source=app.world_mut().resource_mut::<Assets<FogMaterial>>().add(FogMaterial {base:StandardMaterial {alpha_mode:AlphaMode::Blend,..default()},extension});let mesh=Mesh3d(Handle::default());let parent=app.world_mut().spawn((GltfMaterialName(name),NativeFogBound {source:Handle::default()},mesh.clone(),MeshMaterial3d(source.clone()),Transform::from_xyz(1.,2.,3.))).id();app.update();app.update();
 let (child,side)= {let world=app.world_mut();let mut q=world.query::<(Entity,&crate::selector7_depth::DepthPhase,&MeshMaterial3d<FogMaterial>,&ChildOf,&Mesh3d,&Transform)>();let (child,phase,material,parent_link,actual_mesh,t)=q.single(world).unwrap();assert_eq!(parent_link.parent(),parent);assert_eq!(phase.source,source);assert_eq!(actual_mesh.0,mesh.0);assert_eq!(*t,Transform::IDENTITY);(child,material.0.clone())};
 {let mut materials=app.world_mut().resource_mut::<Assets<FogMaterial>>();let mut m=materials.get_mut(&source).unwrap();m.base.base_color=Color::srgba(0.2,0.4,0.6,0.8);m.base.base_color_texture=Some(Handle::default());}app.update();let m=app.world().resource::<Assets<FogMaterial>>().get(&side).unwrap();assert_eq!(m.base.base_color,Color::srgba(0.2,0.4,0.6,0.8));assert!(m.base.base_color_texture.is_some());assert_eq!(m.extension.native_draw_mode,3);assert_eq!(m.extension.alpha_test_enabled,1);assert_eq!(m.extension.alpha_reference,229./255.);
 let replacement_material=app.world().resource::<Assets<FogMaterial>>().get(&source).unwrap().clone();let replacement=app.world_mut().resource_mut::<Assets<FogMaterial>>().add(replacement_material);app.world_mut().entity_mut(parent).insert(MeshMaterial3d(replacement.clone()));app.update();app.update();assert_eq!(app.world().get::<crate::selector7_depth::DepthPhase>(child).unwrap().source,replacement);assert_eq!(app.world().resource::<crate::selector7_depth::Cache>().materials.len(),1);
 drop(side);app.world_mut().entity_mut(parent).despawn();app.update();app.update();assert!(app.world().get_entity(child).is_err());assert!(app.world().resource::<crate::selector7_depth::Cache>().materials.is_empty());
 }
}

#[cfg(test)] mod native_parameter_consistency_test {
 #[test] fn map10_fog_vectors_match_original_loaded_config_consumer_bits() {
  let settings:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map_fog_settings.json")).unwrap();
  let native:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_fog_consumer_contract.json")).unwrap();
  assert_eq!(native["passed"],true);
  for (key,address) in [("fog_data0","0x14beed4"),("fog_data1","0x14beee4")] {
   for (actual,expected) in settings[key].as_array().unwrap().iter().zip(native["shader_field_vectors"][address].as_array().unwrap()) {
    assert_eq!((actual.as_f64().unwrap() as f32).to_bits(),(expected.as_f64().unwrap() as f32).to_bits());
   }
   assert_eq!(settings[key].as_array().unwrap().len(),4);
  }
 }
}

#[cfg(test)] mod native_fog_profile_binding_tests {
 use super::*; use crate::native_high_fog::{profile_uniform,fog_constant,synchronize};
 #[test] fn native_environment_levels_update_existing_materials_and_future_catalog() {
  let extension=FogExtension {high_fog0:Vec4::ZERO,high_fog1:Vec4::ZERO,cloud_phase:Vec4::ZERO,cloud_opacity:Handle::default(),fog_mod2x:0,fog_profile:UVec4::new(2,1,1,0),fog_constant:Vec4::ZERO,opaque:Vec4::ZERO,spatial_denominator:15360.,lighting:Handle::default(),vertex_lighting_factor:8.,diagnostic_channel:0,visibility_map:Handle::default(),visibility_params:Vec4::ZERO,visibility_height:Vec4::ZERO,visibility_edge:Vec4::ZERO,visibility_overlay:Handle::default(),visibility_below:Vec4::ZERO,visibility_ready:0,factor_mode:1,colormap_lighting_factor:4.,terrain_transform:Vec4::ZERO,colormap:Handle::default(),fog_coordinates:Vec4::ZERO,native_draw_mode:0,alpha_test_enabled:1,alpha_reference:1./255.};
  let mut catalog=FogCatalog {extension,allowed:HashSet::new(),vertex_factors:HashMap::new(),colormap_factors:HashMap::new(),draw_modes:HashMap::new(),selector7_names:HashSet::new()};
  let mut fog=Assets::default();let mut terrain=Assets::default();
  let handle=fog.add(crate::map_fog::FogMaterial {base:StandardMaterial::default(),extension:catalog.extension.clone()});
  for level in [3,1,0,2,4,1,3] {
   let profile=profile_uniform(level);let constants=Vec4::new(0.0005,0.25,0.5,0.);
   synchronize(profile,constants,&mut fog,&mut terrain,&mut catalog);
   assert_eq!(catalog.extension.fog_profile,profile);
   assert_eq!(fog.get(&handle).unwrap().extension.fog_profile,profile);
   assert_eq!(fog.get(&handle).unwrap().extension.cloud_phase,constants);
   assert_eq!(profile.x,if level<=1 {1}else{2});assert_eq!(profile.y,u32::from(level>=2));assert_eq!(profile.z,1);
  }
  assert_eq!(fog_constant(),Vec4::new(34./255.,62./255.,84./255.,1.));
 }
}

// Add at module scope in map_fog.rs. Tests are explicit CPU ECS fixtures.
#[cfg(test)]
#[path = "garen_w_material_host_tests.rs"]
mod garen_w_material_host_tests;
