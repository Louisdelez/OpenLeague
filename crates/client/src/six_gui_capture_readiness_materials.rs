//! SOURCE CANDIDATE ONLY. Readonly source provenance and bounded diagnostics.
//! This helper proves no prepared resource, FoW encoding, draw or pixel result.
//! It changes no render binding and installs no systems. Parent owns MeshTicket ABI.
use bevy::{prelude::*, asset::AssetId, gltf::{GltfMaterial,GltfMaterialName,GltfMesh,GltfMeshName}};
use serde_json::{json,Value};
use std::collections::HashSet;

mod census {
//! SOURCE STAGE ONLY. Readonly census of material wrapper components on one draw.
//! Registered MeshMaterial3d<M> paths come from MaterialPlugin's real registration.
//! An opaque unregistered component is never classified by imagined trait inspection.
use bevy::{prelude::*,reflect::TypePath};
use std::any::TypeId;
use serde_json::{json,Value};

const COMPONENT_LIMIT:usize=128;
const MATERIAL_LIMIT:usize=16;
const PATH_LIMIT:usize=4096;

#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub(crate) enum KnownBinding { Standard,Fog,Terrain }
#[derive(Clone,Debug,PartialEq,Eq)]
struct ObservedBinding {kind:Option<KnownBinding>,path:String,origin:&'static str}
#[derive(Default,Debug)]
struct Census {materials:Vec<ObservedBinding>,unknown:Vec<Value>,component_count:usize}

fn known_binding(id:TypeId)->Option<KnownBinding> {
    if id==TypeId::of::<MeshMaterial3d<StandardMaterial>>() {Some(KnownBinding::Standard)}
    else if id==TypeId::of::<MeshMaterial3d<crate::map_fog::FogMaterial>>() {Some(KnownBinding::Fog)}
    else if id==TypeId::of::<MeshMaterial3d<crate::terrain_material::TerrainMaterial>>() {Some(KnownBinding::Terrain)}
    else {None}
}
fn is_material_wrapper(path:&str)->bool {
    // Derive the exact Bevy3D wrapper path from TypePath, not a short-name guess.
    let standard=<MeshMaterial3d<StandardMaterial> as TypePath>::type_path();
    let Some(prefix)=standard.split_once('<').map(|(name,_)|name)else{return false;};
    path.strip_prefix(prefix).is_some_and(|suffix|suffix.starts_with('<'))
        // Extra ordinary 2D/UI material wrappers on this same draw are refused,
        // rather than silently omitted from the sole-3D-binding contract.
        ||path.starts_with("bevy_sprite_render::mesh2d::material::MeshMaterial2d<")
        ||path.starts_with("bevy_ui_render::ui_material::MaterialNode<")
}

/// These concrete types are read from the Bevy19 GLTF loader, required transform,
/// visibility and render-entity synchronization definitions and native marker
/// definitions. No membership is inferred from an unregistered string or trait.
fn known_non_material(id:TypeId)->bool {
    let types=[
        TypeId::of::<Mesh3d>(),TypeId::of::<Transform>(),TypeId::of::<GlobalTransform>(),
        TypeId::of::<bevy::transform::components::TransformTreeChanged>(),
        TypeId::of::<bevy::pbr::PreviousGlobalTransform>(),
        TypeId::of::<Visibility>(),TypeId::of::<InheritedVisibility>(),TypeId::of::<ViewVisibility>(),
        TypeId::of::<bevy::camera::visibility::VisibilityClass>(),TypeId::of::<bevy::camera::primitives::Aabb>(),
        TypeId::of::<bevy::camera::visibility::NoFrustumCulling>(),
        TypeId::of::<bevy::camera::visibility::DynamicSkinnedMeshBounds>(),
        TypeId::of::<bevy::animation::AnimationTargetId>(),TypeId::of::<bevy::animation::AnimatedBy>(),
        TypeId::of::<Name>(),TypeId::of::<ChildOf>(),TypeId::of::<Children>(),
        TypeId::of::<bevy::gltf::GltfMeshName>(),TypeId::of::<bevy::gltf::GltfMaterialName>(),
        TypeId::of::<bevy::gltf::GltfExtras>(),TypeId::of::<bevy::gltf::GltfMeshExtras>(),TypeId::of::<bevy::gltf::GltfMaterialExtras>(),
        TypeId::of::<bevy::render::sync_world::SyncToRenderWorld>(),TypeId::of::<bevy::render::sync_world::RenderEntity>(),
        TypeId::of::<bevy::render::sync_world::MainEntity>(),
        TypeId::of::<crate::map_fog::NativeFogBound>(),TypeId::of::<crate::terrain_material::NativeTerrainBound>(),
        TypeId::of::<crate::actor_fow::Bound>(),TypeId::of::<crate::actor_fow::BaselineLease>(),
        TypeId::of::<crate::selector7_depth::DepthPhase>(),TypeId::of::<bevy::mesh::skinning::SkinnedMesh>(),
    ];types.contains(&id)
}

const REQUIRED_PROBE_LIMIT:usize=16;
const REQUIRER_PROBE_LIMIT:usize=4;

/// Readonly metadata only. ComponentId is scoped to this World/process and is
/// never a type selector. Probe results do not change census admission.
fn opaque_probe(world:&World,draw:Entity,component:bevy::ecs::component::ComponentId,observed:Option<TypeId>)->Value {
    let components=world.components();
    let Some(info)=components.get_info(component)else{return json!({"component_metadata_unavailable":true,"admission_changed":false});};
    let candidates=[
        ("bevy_mesh::components::MeshTag",TypeId::of::<bevy::mesh::MeshTag>()),
        ("bevy_render::batching::NoAutomaticBatching",TypeId::of::<bevy::render::batching::NoAutomaticBatching>()),
        ("bevy_camera::visibility::NoAutoAabb",TypeId::of::<bevy::camera::visibility::NoAutoAabb>()),
        ("bevy_camera::visibility::NoCpuCulling",TypeId::of::<bevy::camera::visibility::NoCpuCulling>()),
        ("bevy_mesh::morph::MeshMorphWeights",TypeId::of::<bevy::mesh::morph::MeshMorphWeights>()),
        ("bevy_camera::visibility::render_layers::RenderLayers",TypeId::of::<bevy::camera::visibility::RenderLayers>()),
    ];
    let typed=candidates.iter().map(|(path,id)|{
        let registered=components.get_id(*id);
        let active=registered.and_then(|cid|components.get_info(cid)).is_some_and(|entry|entry.type_id()==Some(*id));
        json!({"concrete_Rust_type":path,"current_registered_component":registered.map(|cid|format!("{cid:?}")),
            "active_registration":active,"actual_opaque_TypeId_equals_concrete_type":observed==Some(*id),
            "same_current_ComponentId_and_TypeId":active&&registered==Some(component)&&observed==Some(*id)})
    }).collect::<Vec<_>>();
    let required=info.required_components().iter_ids().take(REQUIRED_PROBE_LIMIT+1).collect::<Vec<_>>();
    let mut requiring=Vec::new();let mut requiring_truncated=false;let mut required_scans_truncated=false;
    if let Ok(entity)=world.get_entity(draw) {
        for present in entity.archetype().components().iter().take(COMPONENT_LIMIT) {
            let Some(other)=components.get_info(*present)else{continue;};
            let ids=other.required_components().iter_ids().take(REQUIRED_PROBE_LIMIT+1).collect::<Vec<_>>();
            required_scans_truncated|=ids.len()>REQUIRED_PROBE_LIMIT;
            if ids.iter().take(REQUIRED_PROBE_LIMIT).any(|cid|*cid==component) {
                if requiring.len()==REQUIRER_PROBE_LIMIT {requiring_truncated=true;continue;}
                requiring.push(json!({"component":format!("{present:?}"),"actual_Rust_TypeId":other.type_id().map(|id|format!("{id:?}")),
                    "known_non_material_by_exact_TypeId":other.type_id().is_some_and(known_non_material),
                    "known_material_kind":other.type_id().and_then(known_binding).map(|kind|format!("{kind:?}"))}));
            }
        }
    }
    json!({"component":format!("{component:?}"),"actual_Rust_TypeId":observed.map(|id|format!("{id:?}")),
        "layout_size":info.layout().size(),"layout_align":info.layout().align(),"mutable":info.mutable(),
        "typed_source_candidates_only":typed,
        "requires_component_ids":required.iter().take(REQUIRED_PROBE_LIMIT).map(|cid|format!("{cid:?}")).collect::<Vec<_>>(),
        "requires_truncated":required.len()>REQUIRED_PROBE_LIMIT,"required_by_present_draw_components":requiring,
        "required_by_truncated":requiring_truncated,"required_relation_scans_truncated":required_scans_truncated,
        "ComponentId_is_world_scoped_not_semantic_identity":true,"actual_type_identity_must_be_observed":true,
        "admission_changed":false,"resources_ready":false,"visible_pixels_qualified":false})
}

fn census(world:&World,draw:Entity)->Result<Census,String> {
    let entity=world.get_entity(draw).map_err(|_|"material census draw retired")?;
    let components=entity.archetype().components();
    if components.len()>COMPONENT_LIMIT {return Err("material census exceeds128 actual components".into());}
    let registry=world.get_resource::<AppTypeRegistry>().ok_or("actual AppTypeRegistry unavailable for complete material census")?.read();
    let mut result=Census{component_count:components.len(),..Default::default()};
    for component in components {
        let info=world.components().get_info(*component).ok_or("actual component metadata unavailable")?;
        let Some(id)=info.type_id()else{
            result.unknown.push(json!({"component":format!("{component:?}"),"reason":"no Rust TypeId; material census incomplete","readonly_type_probe":opaque_probe(world,draw,*component,None)}));continue;
        };
        // Known 3D wrappers are still required to have their actual reflection
        // registration: arbitrary typed fixture presence is not renderer proof.
        if let Some(kind)=known_binding(id) {
            let Some(registration)=registry.get(id)else {
                result.unknown.push(json!({"component":format!("{component:?}"),"reason":"known material wrapper has no current TypeRegistry entry"}));continue;
            };
            let path=registration.type_info().type_path();
            if path.len()>PATH_LIMIT||!is_material_wrapper(path) {return Err("registered known material path invalid or oversized".into());}
            result.materials.push(ObservedBinding {kind:Some(kind),path:path.to_owned(),origin:"actual_TypeRegistry"});
        }else if known_non_material(id) {
            // This is a precise TypeId exclusion of a documented non-material
            // component. Its lack of debug name does not make the census fail.
            continue;
        }else {
            let reflected=registry.get(id).map(|registration|registration.type_info().type_path());
            let fallback=if reflected.is_none(){Some(info.name().to_string())}else{None};
            let path=reflected.or(fallback.as_deref()).ok_or("component path observation unavailable")?;
            if path.starts_with("<Enable the debug feature")||path.is_empty() {
                result.unknown.push(json!({"component":format!("{component:?}"),"reason":"opaque unregistered component cannot be distinguished from an additional material wrapper","readonly_type_probe":opaque_probe(world,draw,*component,Some(id))}));continue;
            }
            if path.len()>PATH_LIMIT {return Err("component path exceeds bounded material census".into());}
            if is_material_wrapper(path) {
                result.materials.push(ObservedBinding {kind:None,path:path.to_owned(),origin:if reflected.is_some(){"actual_TypeRegistry"}else{"actual_DebugName"}});
            }
            // A concrete registered/debug type path outside the exact wrapper
            // families is classified as non-wrapper, not by a Material trait.
        }
        if result.materials.len()>MATERIAL_LIMIT {return Err("material census exceeds16 wrapper bindings".into());}
    }Ok(result)
}

fn single(result:&Census)->Result<KnownBinding,String> {
    if !result.unknown.is_empty() {return Err(format!("material census incomplete; {} opaque component(s)",result.unknown.len()));}
    if result.materials.len()!=1 {return Err(format!("expected exactly one actual material wrapper; observed {}",result.materials.len()));}
    result.materials[0].kind.ok_or_else(||format!("unsupported current material wrapper: {}",result.materials[0].path))
}

/// Source identity classification only. Caller retains all owner/scene/current
/// CPU/GPU resource checks. No binding or renderer state is modified.
pub(crate) fn binding_kind(world:&World,draw:Entity)->Result<KnownBinding,String> {single(&census(world,draw)?)}
pub(crate) fn diagnostic(world:&World,draw:Entity)->Value {
    match census(world,draw) {
        Ok(result)=>json!({"draw":draw.to_bits(),"component_count":result.component_count,
            "material_bindings":result.materials.iter().map(|item|json!({"path":item.path,"kind":item.kind.map(|kind|format!("{kind:?}")),"origin":item.origin})).collect::<Vec<_>>(),
            "unknown_components":result.unknown,"census_complete":result.unknown.is_empty(),
            "single_supported_binding":single(&result).ok().map(|kind|format!("{kind:?}")),
            "source_provenance_admitted":false,"resources_ready":false,"visible_pixels_qualified":false}),
        Err(error)=>json!({"draw":draw.to_bits(),"census_complete":false,"error":error,
            "source_provenance_admitted":false,"resources_ready":false,"visible_pixels_qualified":false}),
    }
}

#[cfg(test)]mod tests {
    use super::*;
    fn registry()->AppTypeRegistry {
        let registry=AppTypeRegistry::default();{
            let mut types=registry.write();types.register::<MeshMaterial3d<StandardMaterial>>();
            types.register::<MeshMaterial3d<crate::map_fog::FogMaterial>>();
            types.register::<MeshMaterial3d<crate::terrain_material::TerrainMaterial>>();
            types.register::<MeshMaterial3d<crate::spawn_mist_material::MistMaterial>>();
        }registry
    }
    #[test]fn standard_material_census_accepts_sole_registered_Standard_without_all_nonmaterial_debug_names() {
        let mut world=World::new();world.insert_resource(registry());
        let draw=world.spawn((Name::new("source-fixture-only"),Mesh3d(Handle::default()),
            MeshMaterial3d(Handle::<StandardMaterial>::default()),bevy::render::sync_world::SyncToRenderWorld)).id();
        assert_eq!(binding_kind(&world,draw).unwrap(),KnownBinding::Standard);
        assert!(known_non_material(TypeId::of::<bevy::render::sync_world::SyncToRenderWorld>()));
    }
    #[test]fn standard_material_census_rejects_Standard_with_Fog_Terrain_or_registered_custom_wrapper() {
        let mut world=World::new();world.insert_resource(registry());
        let draw=world.spawn(MeshMaterial3d(Handle::<StandardMaterial>::default())).id();
        world.entity_mut(draw).insert(MeshMaterial3d(Handle::<crate::map_fog::FogMaterial>::default()));
        assert!(binding_kind(&world,draw).is_err());
        world.entity_mut(draw).remove::<MeshMaterial3d<crate::map_fog::FogMaterial>>();
        world.entity_mut(draw).insert(MeshMaterial3d(Handle::<crate::terrain_material::TerrainMaterial>::default()));
        assert!(binding_kind(&world,draw).is_err());
        world.entity_mut(draw).remove::<MeshMaterial3d<crate::terrain_material::TerrainMaterial>>();
        world.entity_mut(draw).insert(MeshMaterial3d(Handle::<crate::spawn_mist_material::MistMaterial>::default()));
        assert!(binding_kind(&world,draw).is_err());
    }
    #[test]fn standard_material_census_absent_custom_only_or_opaque_inventory_never_selects_Standard() {
        let mut world=World::new();world.insert_resource(registry());
        let empty=world.spawn_empty().id();assert!(binding_kind(&world,empty).is_err());
        let custom=world.spawn(MeshMaterial3d(Handle::<crate::spawn_mist_material::MistMaterial>::default())).id();
        assert!(binding_kind(&world,custom).is_err());
        let incomplete=Census {materials:vec![ObservedBinding {kind:Some(KnownBinding::Standard),
            path:<MeshMaterial3d<StandardMaterial> as TypePath>::type_path().into(),origin:"source_fixture"}],
            unknown:vec![json!({"reason":"opaque-unregistered"})],component_count:2};
        assert!(single(&incomplete).is_err());
        assert!(binding_kind(&world,Entity::PLACEHOLDER).is_err());
    }
    #[test]fn standard_material_census_rejects_unregistered_custom_wrapper_with_or_without_debug_names() {
        let mut world=World::new();let registry=AppTypeRegistry::default();
        registry.write().register::<MeshMaterial3d<StandardMaterial>>();world.insert_resource(registry);
        let draw=world.spawn((MeshMaterial3d(Handle::<StandardMaterial>::default()),
            MeshMaterial3d(Handle::<crate::spawn_mist_material::MistMaterial>::default()))).id();
        // Actual reflection path if present, or debug path if enabled, identifies
        // another wrapper; an opaque path also refuses a complete census.
        assert!(binding_kind(&world,draw).is_err());
    }
    #[test]fn standard_material_census_excludes_documented_skinned_bounds_and_animation_links_by_concrete_type() {
        assert!(known_non_material(TypeId::of::<bevy::camera::visibility::NoFrustumCulling>()));
        assert!(known_non_material(TypeId::of::<bevy::camera::visibility::DynamicSkinnedMeshBounds>()));
        assert!(known_non_material(TypeId::of::<bevy::animation::AnimationTargetId>()));
        assert!(known_non_material(TypeId::of::<bevy::animation::AnimatedBy>()));
        let mut world=World::new();world.insert_resource(registry());
        let draw=world.spawn((MeshMaterial3d(Handle::<crate::map_fog::FogMaterial>::default()),
            bevy::camera::visibility::DynamicSkinnedMeshBounds,bevy::camera::visibility::NoFrustumCulling)).id();
        assert_eq!(binding_kind(&world,draw).unwrap(),KnownBinding::Fog);
        // These markers never supply a material or make CPU/GPU resources ready.
    }
    #[test]fn standard_material_census_excludes_previous_global_transform_but_retains_opaque_and_custom_refusals() {
        assert!(known_non_material(TypeId::of::<bevy::pbr::PreviousGlobalTransform>()));
        assert!(!known_non_material(TypeId::of::<ProbeOpaqueA>()));
        let mut world=World::new();world.insert_resource(registry());
        let draw=world.spawn((MeshMaterial3d(Handle::<StandardMaterial>::default()),
            bevy::pbr::PreviousGlobalTransform::default())).id();
        assert_eq!(binding_kind(&world,draw).unwrap(),KnownBinding::Standard);
        // An unresolved census stays incomplete independently of debug-name features.
        let mut incomplete=census(&world,draw).unwrap();
        incomplete.unknown.push(json!({"reason":"source-fixture-opaque-unregistered"}));
        assert!(single(&incomplete).is_err());
        world.entity_mut(draw).insert(MeshMaterial3d(Handle::<crate::spawn_mist_material::MistMaterial>::default()));
        assert!(binding_kind(&world,draw).is_err());
        // Identity classification only: no CPU/GPU resource or pixel readiness.
    }
    #[derive(Component,Default)]struct ProbeOpaqueA;
    #[derive(Component)]struct ProbeOpaqueB;
    #[derive(Component)]#[require(ProbeOpaqueA)]struct ProbeRequirer;
    #[test]fn standard_material_opaque_probe_uses_typed_identity_per_world_registration() {
        let mut first=World::new();let draw=first.spawn(bevy::render::batching::NoAutomaticBatching).id();
        let id=first.components().get_id(TypeId::of::<bevy::render::batching::NoAutomaticBatching>()).unwrap();
        let report=opaque_probe(&first,draw,id,first.components().get_info(id).unwrap().type_id());
        let matching=report["typed_source_candidates_only"].as_array().unwrap().iter().filter(|row|row["same_current_ComponentId_and_TypeId"]==true).collect::<Vec<_>>();
        assert_eq!(matching.len(),1);assert_eq!(matching[0]["concrete_Rust_type"],"bevy_render::batching::NoAutomaticBatching");
        assert!(!known_non_material(TypeId::of::<bevy::render::batching::NoAutomaticBatching>()));
        let mut other=World::new();other.spawn((ProbeOpaqueA,ProbeOpaqueB));
        let other_draw=other.spawn(bevy::render::batching::NoAutomaticBatching).id();
        let other_id=other.components().get_id(TypeId::of::<bevy::render::batching::NoAutomaticBatching>()).unwrap();assert_ne!(id,other_id);
        let other_report=opaque_probe(&other,other_draw,other_id,other.components().get_info(other_id).unwrap().type_id());
        assert!(other_report["typed_source_candidates_only"].as_array().unwrap().iter().any(|row|row["same_current_ComponentId_and_TypeId"]==true));
        assert_eq!(report["admission_changed"],false);assert_eq!(other_report["resources_ready"],false);
    }
    #[test]fn standard_material_opaque_probe_reports_required_edges_without_admitting_unknown_or_custom() {
        let mut world=World::new();world.insert_resource(registry());let draw=world.spawn((ProbeRequirer,MeshMaterial3d(Handle::<StandardMaterial>::default()))).id();
        let opaque=world.components().get_id(TypeId::of::<ProbeOpaqueA>()).unwrap();let requiring=world.components().get_id(TypeId::of::<ProbeRequirer>()).unwrap();
        let report=opaque_probe(&world,draw,opaque,world.components().get_info(opaque).unwrap().type_id());
        assert!(report["required_by_present_draw_components"].as_array().unwrap().iter().any(|row|row["component"]==format!("{requiring:?}")));
        assert!(!report["typed_source_candidates_only"].as_array().unwrap().iter().any(|row|row["actual_opaque_TypeId_equals_concrete_type"]==true));
        let incomplete=Census {materials:vec![ObservedBinding {kind:Some(KnownBinding::Standard),path:<MeshMaterial3d<StandardMaterial> as TypePath>::type_path().into(),origin:"source_fixture"}],unknown:vec![report],component_count:3};
        assert!(single(&incomplete).is_err());
        world.entity_mut(draw).insert(MeshMaterial3d(Handle::<crate::spawn_mist_material::MistMaterial>::default()));assert!(binding_kind(&world,draw).is_err());
    }
    #[test]fn standard_material_census_uses_exact_outer_wrapper_path_without_nested_short_name_guessing() {
        assert!(is_material_wrapper(<MeshMaterial3d<StandardMaterial> as TypePath>::type_path()));
        assert!(!is_material_wrapper("other::Ticket<bevy_pbr::mesh_material::MeshMaterial3d<Other>>"));
        assert!(!is_material_wrapper("other::MeshMaterial3d<Other>"));
        assert!(is_material_wrapper("bevy_ui_render::ui_material::MaterialNode<Other>"));
    }
}

}
pub(crate) use census::{binding_kind,KnownBinding};

const ANCESTRY_LIMIT:usize=16_384;
const NAME_LIMIT:usize=1024;
const PRIMITIVE_LIMIT:usize=1024;

fn standard_label(label:&str)->Result<(usize,String),String> {
    let Some(digits)=label.strip_prefix("Material")else{return Err("named GltfMaterial label is not native loader MaterialN".into());};
    if digits.is_empty()||digits.len()>20||!digits.bytes().all(|byte|byte.is_ascii_digit()) {
        return Err("named GltfMaterial index label invalid".into());
    }
    let index=digits.parse::<usize>().map_err(|_|"named GltfMaterial index exceeds current platform")?;
    if index.to_string()!=digits{return Err("named GltfMaterial index is not canonical loader decimal".into());}
    Ok((index,format!("{label}/std")))
}

#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub(crate) enum ExpectedConversion { Terrain, Fog, Ordinary }
fn expectation(terrain:bool,fog:bool)->ExpectedConversion {
    // Real main Update chain binds terrain before map fog, with ApplyDeferred.
    if terrain {ExpectedConversion::Terrain}else if fog {ExpectedConversion::Fog}else{ExpectedConversion::Ordinary}
}

pub(crate) fn expected_conversion(world:&World,name:&str)->Result<ExpectedConversion,String> {
    if name.is_empty()||name.len()>NAME_LIMIT{return Err("bounded actual GltfMaterialName required".into());}
    let terrain=world.get_resource::<crate::terrain_material::TerrainMaterials>().ok_or("actual terrain catalog pending")?;
    let fog=world.get_resource::<crate::map_fog::FogCatalog>().ok_or("actual fog catalog pending")?;
    Ok(expectation(terrain.expects(name),fog.expects(name)))
}

fn descendant(world:&World,draw:Entity,map_root:Entity)->Result<(),String> {
    if draw==map_root||world.get::<crate::map_coordinates::MapRoot>(map_root).is_none()
        ||world.get::<ChildOf>(map_root).is_some(){return Err("ordinary Standard source requires actual top-level MapRoot descendant".into());}
    let mut seen=HashSet::new();let mut cursor=draw;
    loop {
        if !seen.insert(cursor)||seen.len()>ANCESTRY_LIMIT{return Err("MapRoot ancestry cyclic or exceeds bounded observation".into());}
        if cursor==map_root{return Ok(());}
        let parent=world.get::<ChildOf>(cursor).ok_or("draw is outside actual MapRoot")?;
        cursor=parent.parent();
    }
}

#[derive(Debug,Clone,PartialEq,Eq)]
pub(crate) struct StandardSource {
    pub(crate) material:AssetId<StandardMaterial>,
    pub(crate) source_gltf_material:AssetId<GltfMaterial>,
    pub(crate) source_gltf_mesh:AssetId<GltfMesh>,
    pub(crate) source_mesh:AssetId<Mesh>,
    pub(crate) material_name:String,
    pub(crate) mesh_name:String,
    pub(crate) standard_path:String,
}

/// Readonly identity admission only. Caller must already enforce its actual
/// accepted PID/session/player/epoch, SceneReady instance and current camera.
/// The Standard is admitted only for this exact MapRoot and current loaded GLTF,
/// outside native Fog/Terrain conversion, with exact named primitive provenance.
pub(crate) fn standard_source(world:&World,draw:Entity,map_root:Entity,map:AssetId<Gltf>)
    ->Result<StandardSource,String> {
    descendant(world,draw,map_root)?;
    if binding_kind(world,draw)?!=KnownBinding::Standard {return Err("Standard source requires exactly one current Standard binding".into());}
    if world.get_resource::<crate::MapHandle>().map(|handle|handle.0.id())!=Some(map) {
        return Err("Standard provenance belongs to a retired or foreign map asset".into());
    }
    let material=world.get::<MeshMaterial3d<StandardMaterial>>(draw).ok_or("actual Standard draw component pending")?.0.id();
    let mesh=world.get::<Mesh3d>(draw).ok_or("actual draw Mesh3d missing")?.0.id();
    let material_name=&world.get::<GltfMaterialName>(draw).ok_or("actual GltfMaterialName missing")?.0;
    match expected_conversion(world,material_name)? {
        ExpectedConversion::Terrain=>return Err("native Terrain conversion pending; Standard fallback forbidden".into()),
        ExpectedConversion::Fog=>return Err("native Fog conversion pending; Standard fallback forbidden".into()),
        ExpectedConversion::Ordinary=>{},
    }
    let mesh_name=&world.get::<GltfMeshName>(draw).ok_or("actual GltfMeshName missing")?.0;
    if mesh_name.is_empty()||mesh_name.len()>NAME_LIMIT{return Err("bounded actual GltfMeshName required".into());}
    let server=world.get_resource::<AssetServer>().ok_or("actual AssetServer missing")?;
    if !server.is_loaded_with_dependencies(map){return Err("actual map GLTF dependencies pending".into());}
    let models=world.get_resource::<Assets<Gltf>>().ok_or("actual map Assets<Gltf> missing")?;
    let model=models.get(map).ok_or("actual map GLTF CPU asset missing")?;
    if world.get::<bevy::world_serialization::WorldAssetRoot>(map_root).map(|root|root.0.id())!=model.scenes.first().map(|scene|scene.id()) {
        return Err("MapRoot no longer owns scene0 of exact current GLTF".into());
    }
    let named_material=model.named_materials.get(material_name.as_str()).ok_or("draw name is not in current GLTF named_materials")?;
    let named_mesh=model.named_meshes.get(mesh_name.as_str()).ok_or("draw name is not in current GLTF named_meshes")?;
    let source_meshes=world.get_resource::<Assets<GltfMesh>>().ok_or("actual source GltfMesh assets pending")?;
    let source_mesh=source_meshes.get(named_mesh.id()).ok_or("actual named GltfMesh CPU asset pending")?;
    if model.meshes.get(source_mesh.index).map(Handle::id)!=Some(named_mesh.id()) {
        return Err("named GltfMesh is not the exact indexed current map mesh asset".into());
    }
    if source_mesh.primitives.len()>PRIMITIVE_LIMIT{return Err("named GltfMesh primitives exceed bounded observation".into());}
    if !source_mesh.primitives.iter().any(|primitive|primitive.mesh.id()==mesh&&primitive.material.as_ref().map(Handle::id)==Some(named_material.id())) {
        return Err("actual Mesh3d/material does not match a primitive of the named current map GltfMesh".into());
    }
    let source_materials=world.get_resource::<Assets<GltfMaterial>>().ok_or("actual GltfMaterial assets pending")?;
    if source_materials.get(named_material.id()).is_none(){return Err("actual named GltfMaterial CPU asset pending".into());}
    let map_path=server.get_path(map).ok_or("exact map source path unavailable")?;
    let material_path=server.get_path(named_material.id()).ok_or("exact named GltfMaterial path unavailable")?;
    let mesh_path=server.get_path(named_mesh.id()).ok_or("exact named GltfMesh source path unavailable")?;
    if map_path.label().is_some()||map_path.source()!=material_path.source()||map_path.path()!=material_path.path() {
        return Err("named GltfMaterial is not a subasset of exact current map source path".into());
    }
    if mesh_path.source()!=map_path.source()||mesh_path.path()!=map_path.path()
        ||mesh_path.label()!=Some(format!("Mesh{}",source_mesh.index).as_str()) {
        return Err("named GltfMesh is not an exact indexed subasset of current map source".into());
    }
    let label=material_path.label().ok_or("named GltfMaterial label unavailable")?;
    let (index,std_label)=standard_label(label)?;
    if model.materials.get(index).map(Handle::id)!=Some(named_material.id()) {
        return Err("named GltfMaterial does not match its indexed current map material asset".into());
    }
    // Bevy19 PBR handler creates the Standard as MaterialN/std. Lookup only:
    // never load, convert, add, bind or reconstruct a material here.
    let standard_path=material_path.clone_owned().with_label(std_label);
    let standard=server.get_handle::<StandardMaterial>(standard_path.clone()).ok_or("exact existing PBR /std subasset handle pending")?;
    if standard.id()!=material{return Err("actual MeshMaterial3d<StandardMaterial> ID differs from exact GLTF /std source".into());}
    let standards=world.get_resource::<Assets<StandardMaterial>>().ok_or("actual Standard assets pending")?;
    if standards.get(material).is_none()||!server.is_loaded_with_dependencies(material) {
        return Err("exact current Standard CPU asset/dependencies pending".into());
    }
    Ok(StandardSource {material,source_gltf_material:named_material.id(),source_gltf_mesh:named_mesh.id(),source_mesh:mesh,
        material_name:material_name.clone(),mesh_name:mesh_name.clone(),standard_path:standard_path.to_string()})
}

/// Diagnostics enumerate actual ECS metadata and known typed IDs only. They
/// never infer that an unsupported component is Standard or resource-ready.
pub(crate) fn diagnostic(world:&World,draw:Entity)->Value {
    let binding_inventory=census::diagnostic(world,draw);
    let bounded_name=|name:&str|if name.len()<=NAME_LIMIT{json!(name)}else{json!({"name_unavailable":true,"actual_bytes":name.len(),"reason":"name exceeds bounded observation"})};
    json!({"draw":draw.to_bits(),"Name":world.get::<Name>(draw).map(|name|bounded_name(name.as_str())),
        "GltfMeshName":world.get::<GltfMeshName>(draw).map(|name|bounded_name(name.0.as_str())),
        "GltfMaterialName":world.get::<GltfMaterialName>(draw).map(|name|bounded_name(name.0.as_str())),
        "binding_census":binding_inventory,
        "Mesh3d":world.get::<Mesh3d>(draw).map(|mesh|format!("{:?}",mesh.0.id())),
        "Standard":world.get::<MeshMaterial3d<StandardMaterial>>(draw).map(|material|format!("{:?}",material.0.id())),
        "Fog":world.get::<MeshMaterial3d<crate::map_fog::FogMaterial>>(draw).map(|material|format!("{:?}",material.0.id())),
        "Terrain":world.get::<MeshMaterial3d<crate::terrain_material::TerrainMaterial>>(draw).map(|material|format!("{:?}",material.0.id())),
        "known_material_components":usize::from(world.get::<MeshMaterial3d<StandardMaterial>>(draw).is_some())
            +usize::from(world.get::<MeshMaterial3d<crate::map_fog::FogMaterial>>(draw).is_some())
            +usize::from(world.get::<MeshMaterial3d<crate::terrain_material::TerrainMaterial>>(draw).is_some()),
        "material_source_admitted":false,"resources_ready":false,"visible_pixels_qualified":false})
}

#[cfg(test)] mod tests {
    use super::*;
    #[test] fn material_source_overlap_requires_terrain_conversion_before_fog() {
        assert_eq!(expectation(true,true),ExpectedConversion::Terrain);
        assert_eq!(expectation(false,true),ExpectedConversion::Fog);
        assert_eq!(expectation(false,false),ExpectedConversion::Ordinary);
    }
    #[test] fn material_source_foreign_or_missing_MapRoot_ancestry_cannot_be_inferred() {
        let world=World::new();assert!(descendant(&world,Entity::PLACEHOLDER,Entity::PLACEHOLDER).is_err());
    }
    #[test]fn standard_material_source_label_is_exact_canonical_MaterialN_std_not_default_inverted_or_foreign() {
        assert_eq!(standard_label("Material0").unwrap(),(0,"Material0/std".into()));
        assert_eq!(standard_label("Material114").unwrap(),(114,"Material114/std".into()));
        for label in ["DefaultMaterial","Material","Material00","Material1/inverted","Material1/std","Other1","Material-1","Material999999999999999999999"] {
            assert!(standard_label(label).is_err());
        }
    }
}
