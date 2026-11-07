//! Readonly main-world resource barrier for baseline/combat captures only.
//! CPU scene/visibility and GPU resource witnesses are separate from successful
//! draw execution and from pixels. No game, camera, input or clock is changed.
//! Existing GLTF Standard draws have partial render-resource support only.
//! Their shader lacks Native FoW; native texture/shadow/pass fidelity is not inferred.
use bevy::{
    prelude::*,
    asset::{AssetId, VisitAssetDependencies},
    camera::{NormalizedRenderTarget, RenderTarget, visibility::VisibleEntities},
    gltf::{GltfMeshName, GltfMaterialName},
    mesh::skinning::{SkinnedMesh, SkinnedMeshInverseBindposes},
    render::extract_resource::ExtractResourcePlugin,
    ui_render::ui_material::MaterialNode,
    window::PrimaryWindow,
    world_serialization::{WorldAsset, WorldAssetRoot, WorldInstance, WorldInstanceReady, InstanceId},
};
use std::{any::TypeId, collections::HashSet};
#[path = "six_gui_capture_readiness_materials.rs"]
pub(crate) mod materials;
#[path = "six_gui_capture_readiness_types.rs"]
pub(crate) mod types;
#[path = "six_gui_capture_readiness_gpu.rs"]
mod gpu;
use types::{Frame, GpuReport, MeshMaterial, MeshRole, MeshTicket, Owner, Scope,
    Shared, Skin, UiMaterial, UiRole, UiTicket};

const ENV: &str = "OPENLEAGUE_SIX_GUI_OBSERVATION";
const DESCENDANT_LIMIT: usize = 16_384;

/// Only the actual global WorldInstanceReady event may create this marker.
/// Both scene asset and concrete instance must still match the current root.
#[derive(Component, Clone, Copy)]
struct SceneReady { asset: AssetId<WorldAsset>, instance: InstanceId }

#[derive(SystemSet, Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub(crate) struct Collect;
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self, app: &mut App) {
        if std::env::var_os(ENV).is_none() { return; }
        let shared = Shared::default();
        app.insert_resource(shared.clone()).init_resource::<Frame>()
            .add_plugins(ExtractResourcePlugin::<Frame>::default())
            .add_observer(scene_ready)
            .add_systems(PostUpdate, collect.in_set(Collect)
                .after(bevy::camera::visibility::VisibilitySystems::CheckVisibility)
                .after(bevy::transform::TransformSystems::Propagate)
                .after(bevy::ui::UiSystems::PostLayout));
        gpu::install(app, shared);
    }
}
fn scene_ready(event: On<WorldInstanceReady>, mut commands: Commands,
    roots: Query<(&WorldAssetRoot, Option<&crate::map_coordinates::MapRoot>, Option<&crate::animation::Playback>)>) {
    let Ok((asset, map, playback)) = roots.get(event.entity) else { return; };
    if map.is_some() || playback.is_some() {
        commands.entity(event.entity).insert(SceneReady { asset: asset.0.id(), instance: event.instance_id });
    }
}

fn unique(world: &World, label: &str, predicate: impl Fn(&bevy::ecs::world::EntityRef<'_>) -> bool)
    -> Result<Entity, String> {
    let mut found = None;
    for entity in world.iter_entities().filter(predicate) {
        if found.replace(entity.id()).is_some() { return Err(format!("{label}: duplicate current entity")); }
    }
    found.ok_or_else(|| format!("{label}: current entity missing"))
}
fn accepted(world: &World) -> Result<(Owner, u8, u64, String), String> {
    let connection = world.get_resource::<crate::Connection>().ok_or("ordinary Connection missing")?;
    let (session, player, epoch) = connection.inventory_input_identity().ok_or("ordinary accepted transport identity pending")?;
    let snapshot = world.get_resource::<crate::Match>().and_then(|m| m.snapshot.as_ref())
        .ok_or("own received Snapshot pending")?;
    if snapshot.session != session { return Err("own Snapshot session differs".into()); }
    let local = snapshot.players.iter().find(|p| p.id == player).ok_or("own Snapshot actor missing")?;
    if local.team > 1 || !snapshot.roster.iter().any(|p| p.id == player && p.team == local.team) {
        return Err("own Snapshot team/roster differs".into());
    }
    if snapshot.map10.is_none() { return Err("own received Map10 state pending".into()); }
    Ok((Owner { pid: std::process::id(), session, player, epoch }, local.team, snapshot.tick, local.champion.clone()))
}
fn scene_current(world: &World, entity: Entity) -> bool {
    world.get::<SceneReady>(entity).is_some_and(|ready|
        world.get::<WorldAssetRoot>(entity).is_some_and(|root| root.0.id() == ready.asset)
        && world.get::<WorldInstance>(entity).is_some_and(|instance| **instance == ready.instance))
}
fn dependencies(world: &World, id: impl Into<bevy::asset::UntypedAssetId>, label: &str) -> Result<(), String> {
    let server = world.get_resource::<AssetServer>().ok_or("AssetServer missing")?;
    let id = id.into();
    if !server.is_loaded_with_dependencies(id) {
        return Err(format!("{label}: dependencies pending or failed ({:?})", server.get_load_state(id)));
    }
    Ok(())
}
fn normal_camera(world: &World, window: Entity) -> Result<(Entity, NormalizedRenderTarget), String> {
    let expected = RenderTarget::Window(bevy::window::WindowRef::Entity(window)).normalize(Some(window))
        .ok_or("actual primary-window target cannot normalize")?;
    let camera = unique(world, "normal primary Camera3d", |entity|
        entity.contains::<Camera3d>() && entity.get::<Camera>().is_some_and(|c| c.is_active && c.invert_culling)
        && entity.get::<RenderTarget>().and_then(|t| t.normalize(Some(window))).as_ref() == Some(&expected))?;
    let transform = world.get::<GlobalTransform>(camera).ok_or("normal camera transform pending")?;
    if !transform.to_matrix().is_finite() { return Err("normal camera transform is not finite".into()); }
    if world.get::<Camera>(camera).and_then(|c| c.physical_target_size()).is_none_or(|s| s.x == 0 || s.y == 0) {
        return Err("normal camera target layout pending".into());
    }
    Ok((camera, expected))
}
fn descendants(world: &World, root: Entity) -> Result<Vec<Entity>, String> {
    let mut stack = vec![(root, None)]; let mut seen = HashSet::new(); let mut out = Vec::new();
    while let Some((entity, parent)) = stack.pop() {
        if !seen.insert(entity) { return Err("scene hierarchy contains a cycle/duplicate".into()); }
        if seen.len() > DESCENDANT_LIMIT { return Err("scene hierarchy exceeds bounded traversal".into()); }
        if world.get_entity(entity).is_err() { return Err("scene hierarchy references a retired entity".into()); }
        if let Some(parent) = parent {
            if world.get::<ChildOf>(entity).map(|link| link.parent()) != Some(parent) {
                return Err("scene hierarchy parent identity differs".into());
            }
        }
        out.push(entity);
        if let Some(children) = world.get::<Children>(entity) {
            for child in children.iter() { stack.push((child, Some(entity))); }
        }
    }
    Ok(out)
}
fn under_root(world: &World, entity: Entity, root: Entity) -> bool {
    let mut next = Some(entity); let mut seen = HashSet::new();
    while let Some(entity) = next {
        if !seen.insert(entity) || seen.len() > DESCENDANT_LIMIT { return false; }
        if entity == root { return world.get_entity(root).is_ok(); }
        next = world.get::<ChildOf>(entity).map(|link| link.parent());
    }
    false
}
fn ticket_owned(world: &World, ticket: &MeshTicket, scope: &Scope) -> bool {
    let root = match ticket.role { MeshRole::LocalModel => scope.model_root, MeshRole::Terrain => scope.map_root };
    under_root(world, ticket.draw, root)
        && ticket.skin.as_ref().is_none_or(|skin| skin.joints.iter().all(|joint| under_root(world, *joint, root)))
}
fn visible_mesh(world: &World, draw: Entity, camera: Entity) -> bool {
    world.get::<InheritedVisibility>(draw).is_some_and(|v| v.get())
        && world.get::<ViewVisibility>(draw).is_some_and(|v| v.get())
        && world.get::<VisibleEntities>(camera).is_some_and(|v| v.get(TypeId::of::<Mesh3d>()).contains(&draw))
}
fn normalize_images(mut images: Vec<AssetId<Image>>) -> Vec<AssetId<Image>> {
    images.sort_unstable(); images.dedup(); images
}
fn fog_images(material: &crate::map_fog::FogMaterial) -> Vec<AssetId<Image>> {
    let mut images = Vec::new();
    material.base.visit_dependencies(&mut |id| {
        if id.type_id() == TypeId::of::<Image>() { images.push(id.typed::<Image>()); }
    });
    let extension = &material.extension;
    images.extend([extension.lighting.id(), extension.cloud_opacity.id(), extension.colormap.id(),
        extension.visibility_map.id(), extension.visibility_overlay.id()]);
    normalize_images(images)
}
fn material_images(world: &World, material: MeshMaterial) -> Result<(Vec<AssetId<Image>>, Option<AssetId<Image>>, bool), String> {
    match material {
        MeshMaterial::Fog(id) => {
            let value = world.get_resource::<Assets<crate::map_fog::FogMaterial>>().and_then(|a| a.get(id))
                .ok_or("own FogMaterial CPU asset pending")?;
            Ok((fog_images(value), Some(value.extension.visibility_map.id()), value.extension.visibility_ready == 1))
        },
        MeshMaterial::Terrain(id) => {
            let value = world.get_resource::<Assets<crate::terrain_material::TerrainMaterial>>().and_then(|a| a.get(id))
                .ok_or("own TerrainMaterial CPU asset pending")?;
            Ok((normalize_images(value.capture_images().into_iter().map(Handle::id).collect()),
                Some(value.visibility_map.id()), value.visibility_ready == 1))
        },
        MeshMaterial::Standard(id) => {
            let value=world.get_resource::<Assets<StandardMaterial>>().and_then(|a|a.get(id))
                .ok_or("exact own StandardMaterial CPU asset pending")?;
            dependencies(world,id,"exact GLTF StandardMaterial")?;
            let mut images=Vec::new();value.visit_dependencies(&mut |id|{
                if id.type_id()==TypeId::of::<Image>() {images.push(id.typed::<Image>());}
            });
            // None/false describes the existing Standard shader accurately;
            // global FoW encoding is a separate scope/GPU obligation.
            Ok((normalize_images(images),None,false))
        },
    }
}
fn image_cpu(world: &World, id: AssetId<Image>, label: &str) -> Result<(), String> {
    let image = world.get_resource::<Assets<Image>>().and_then(|images| images.get(id))
        .ok_or_else(|| format!("{label}: CPU image absent (pending, failed or render-only provenance unknown)"))?;
    if image.width() == 0 || image.height() == 0 { return Err(format!("{label}: CPU image dimensions invalid")); }
    // Generated ordinary font/portrait images have no AssetServer load record.
    // Presence is an actual CPU resource observation, never an upload witness.
    if world.get_resource::<AssetServer>().is_some_and(|server| server.get_load_state(id).is_some()) {
        dependencies(world, id, label)?;
    }
    Ok(())
}
fn skin(world: &World, draw: Entity) -> Result<Option<Skin>, String> {
    let Some(skin) = world.get::<SkinnedMesh>(draw) else { return Ok(None); };
    if skin.joints.is_empty() || skin.joints.len() > DESCENDANT_LIMIT {
        return Err("actual skin joint count empty or exceeds traversal bound".into());
    }
    let inverse = world.get_resource::<Assets<SkinnedMeshInverseBindposes>>().and_then(|a| a.get(skin.inverse_bindposes.id()))
        .ok_or("actual skin inverse-bind CPU asset pending")?;
    if inverse.len() < skin.joints.len() || inverse.iter().take(skin.joints.len()).any(|m| !m.is_finite()) {
        return Err("actual variable skin inverse-bind palette incomplete/nonfinite".into());
    }
    let mut seen = HashSet::new();
    for joint in &skin.joints {
        if !seen.insert(*joint) || !world.get::<GlobalTransform>(*joint).is_some_and(|t| t.to_matrix().is_finite()) {
            return Err("actual skin joint entity duplicated, pending or nonfinite".into());
        }
    }
    Ok(Some(Skin { inverse: skin.inverse_bindposes.id(), joints: skin.joints.clone() }))
}
/// Read only the rejected entity. Names/types help determine the next bounded
/// material correction; they never substitute for a supported CPU/GPU ticket.
fn diagnostic_text(value:&str)->serde_json::Value {
    if value.len()<=1_024 {return serde_json::Value::String(value.into());}
    serde_json::json!({"prefix":value.chars().take(256).collect::<String>(),
        "source_bytes":value.len(),"truncated":true,"exact_value_unknown":true})
}
fn rejected_material_diagnostic(world: &World, draw: Entity) -> serde_json::Value {
    let fog=world.get::<MeshMaterial3d<crate::map_fog::FogMaterial>>(draw);
    let terrain=world.get::<MeshMaterial3d<crate::terrain_material::TerrainMaterial>>(draw);
    let standard=world.get::<MeshMaterial3d<StandardMaterial>>(draw);
    let mut material_components=Vec::new();let mut custom=Vec::new();let mut names_available=false;
    let mut inventory_truncated=false;let mut component_count=None;
    let known=[TypeId::of::<MeshMaterial3d<crate::map_fog::FogMaterial>>(),
        TypeId::of::<MeshMaterial3d<crate::terrain_material::TerrainMaterial>>(),
        TypeId::of::<MeshMaterial3d<StandardMaterial>>()];
    let registry=world.get_resource::<AppTypeRegistry>().map(|r|r.read());
    let entity_present=match world.get_entity(draw) {
        Ok(entity)=>{
            let components=entity.archetype().components();component_count=Some(components.len());
            inventory_truncated=components.len()>128;names_available=!inventory_truncated;
            // MaterialPlugin registers MeshMaterial3d<M>. The readonly reflect
            // registry can retain its type path even without Bevy debug names.
            // Missing registry/debug metadata remains unknown, never inferred.
            for id in components.iter().take(128) {
                if let Some(info)=world.components().get_info(*id) {
                    let reflected=info.type_id().and_then(|id|registry.as_ref().and_then(|r|r.get(id)))
                        .map(|registration|registration.type_info().type_path());
                    let name=reflected.map(str::to_owned).unwrap_or_else(||info.name().to_string());
                    if name.starts_with("<Enable the debug feature") {names_available=false;continue;}
                    if name.contains("::MeshMaterial3d<") {
                        if material_components.len()>=16 {inventory_truncated=true;names_available=false;continue;}
                        if info.type_id().is_none_or(|id|!known.contains(&id)) {custom.push(diagnostic_text(&name));}
                        material_components.push(diagnostic_text(&name));
                    }
                }else{names_available=false;}
            }true
        },
        Err(_)=>false,
    };
    serde_json::json!({"draw":draw.to_bits(),"entity_present":entity_present,
        "name":world.get::<Name>(draw).map(|n|diagnostic_text(n.as_str())),
        "gltf_mesh_name":world.get::<GltfMeshName>(draw).map(|n|diagnostic_text(&n.0)),
        "gltf_material_name":world.get::<GltfMaterialName>(draw).map(|n|diagnostic_text(&n.0)),
        "supported_binding_state":match (fog.is_some(),terrain.is_some()) {
            (true,true)=>"ambiguous_Fog_and_Terrain",(true,false)=>"single_Fog",(false,true)=>"single_Terrain",
            (false,false)=>"absent_supported_Fog_or_Terrain",
        },
        "Fog":fog.map(|m|format!("{:?}",m.id())),"Terrain":terrain.map(|m|format!("{:?}",m.id())),
        "Standard":standard.map(|m|format!("{:?}",m.id())),
        "component_type_names_available":names_available,"material_component_type_names":material_components,
        "custom_material_component_type_names":custom,"component_count":component_count,"component_inventory_truncated":inventory_truncated,
        "material_binding_accepted":false,"resources_ready":false,
        "DrawMaterial_success_observed":false,"visible_pixels_qualified":false})
}
fn mesh_material(world:&World,draw:Entity)->Result<MeshMaterial,String> {
    let fog=world.get::<MeshMaterial3d<crate::map_fog::FogMaterial>>(draw);
    let terrain=world.get::<MeshMaterial3d<crate::terrain_material::TerrainMaterial>>(draw);
    match (fog,terrain) {
        (Some(fog),None)=>Ok(MeshMaterial::Fog(fog.id())),
        (None,Some(terrain))=>Ok(MeshMaterial::Terrain(terrain.id())),
        _=>Err(format!("visible own mesh has absent/ambiguous Fog/Terrain material; observed={}",
            rejected_material_diagnostic(world,draw))),
    }
}
fn mesh_ticket(world: &World, draw: Entity, role: MeshRole, scope:&Scope) -> Result<MeshTicket, String> {
    let mesh = world.get::<Mesh3d>(draw).ok_or("own Mesh3d pending")?;
    let cpu = world.get_resource::<Assets<Mesh>>().and_then(|a| a.get(mesh.id())).ok_or("own mesh CPU asset pending/render-only")?;
    if cpu.count_vertices() == 0 { return Err("own mesh has no CPU vertices".into()); }
    let binding=materials::binding_kind(world,draw).map_err(|error|format!("{error}; observed={}",materials::diagnostic(world,draw)))?;
    let (material,standard_source)=match binding {
        materials::KnownBinding::Fog=>(MeshMaterial::Fog(world.get::<MeshMaterial3d<crate::map_fog::FogMaterial>>(draw).ok_or("current Fog binding absent")?.id()),None),
        materials::KnownBinding::Terrain=>(MeshMaterial::Terrain(world.get::<MeshMaterial3d<crate::terrain_material::TerrainMaterial>>(draw).ok_or("current Terrain binding absent")?.id()),None),
        materials::KnownBinding::Standard=>{
            if role!=MeshRole::Terrain {return Err("Standard render-resource support is limited to actual MapRoot meshes".into());}
            let source=materials::standard_source(world,draw,scope.map_root,scope.map)?;
            (MeshMaterial::Standard(source.material),Some(source))
        },
    };
    let (images, native_visibility, bound) = material_images(world, material)?;
    let output = world.get_resource::<crate::fow_gpu::Images>().ok_or("current FoW output handle pending")?.output.id();
    if output!=scope.visibility_output {return Err("global scene FoW output differs from exact current scope".into());}
    match material {
        MeshMaterial::Standard(_)=>if native_visibility.is_some()||bound {return Err("Standard shader must not claim a Native FoW binding".into());},
        MeshMaterial::Fog(_)|MeshMaterial::Terrain(_)=>if !bound||native_visibility!=Some(output) {return Err("material is not bound to the exact current FoW output".into());},
    }
    for id in &images {
        if *id != output { image_cpu(world, *id, "mesh material texture")?; }
    }
    // output uses RENDER_WORLD-only storage: its CPU identity is observed here;
    // its allocation and exact session/team encoded passes are GPU obligations.
    Ok(MeshTicket { role, draw, mesh: mesh.id(), material, images, native_visibility, skin: skin(world, draw)?,standard_source })
}
fn ui_visible(world: &World, draw: Entity, camera: Entity) -> bool {
    world.get::<Node>(draw).is_some_and(|node| node.display != Display::None)
        && world.get::<InheritedVisibility>(draw).is_some_and(|v| v.get())
        && world.get::<ComputedNode>(draw).is_some_and(|n| n.size().is_finite() && n.size().min_element() > 0.)
        && world.get::<bevy::ui::ComputedUiTargetCamera>(draw).and_then(|c| c.get()) == Some(camera)
}
fn ui_images(world: &World, material: UiMaterial) -> Result<Vec<AssetId<Image>>, String> {
    match material {
        UiMaterial::Icon(id) => {
            let icon = world.get_resource::<Assets<crate::native_hud_icon_material::IconMaterial>>().and_then(|a| a.get(id))
                .ok_or("actual HUD IconMaterial CPU asset pending")?;
            if !icon.parameters.uv.is_finite() || !icon.parameters.tint.is_finite() || !icon.parameters.vertex_color.is_finite()
                || icon.parameters.tint.w <= 0. || icon.parameters.vertex_color.w <= 0. || icon.parameters.mode.x == 2. {
                return Err("actual HUD icon parameters invisible/nonfinite".into());
            }
            Ok(vec![icon.texture.id()])
        },
        UiMaterial::Font(id) => {
            let font = world.get_resource::<Assets<crate::native_font_material::FontMaterial>>().and_then(|a| a.get(id))
                .ok_or("actual HUD FontMaterial CPU asset pending")?;
            if !font.parameters.uv.is_finite() || !font.parameters.fill_uv.is_finite()
                || !font.parameters.color0.is_finite() || !font.parameters.color1.is_finite() {
                return Err("actual HUD font parameters nonfinite".into());
            }
            Ok(normalize_images(vec![font.font.id(), font.fill.id()]))
        },
    }
}
fn ui_ticket(world: &World, draw: Entity, role: UiRole, camera: Entity) -> Result<UiTicket, String> {
    let name = match role { UiRole::Frame => "NativeMap10HudPanel", UiRole::Portrait => "NativeMap10ChampionPortrait", UiRole::Glyph => "NativeMap10HudGlyph" };
    if !world.get::<Name>(draw).is_some_and(|n| n.as_str() == name) { return Err("actual HUD node source name/role differs".into()); }
    if !ui_visible(world, draw, camera) { return Err("actual HUD node visibility/size/normal target pending".into()); }
    let icon = world.get::<MaterialNode<crate::native_hud_icon_material::IconMaterial>>(draw);
    let font = world.get::<MaterialNode<crate::native_font_material::FontMaterial>>(draw);
    let material = match (role, icon, font) {
        (UiRole::Frame | UiRole::Portrait, Some(icon), None) => UiMaterial::Icon(icon.0.id()),
        (UiRole::Glyph, None, Some(font)) => UiMaterial::Font(font.0.id()),
        _ => return Err("actual HUD node material type/role differs".into()),
    };
    let images = ui_images(world, material)?;
    for id in &images { image_cpu(world, *id, "HUD material texture")?; }
    Ok(UiTicket { role, draw, material, images })
}
fn animation_ready(world: &World, local: &[Entity]) -> bool {
    local.iter().any(|entity|
        world.get::<AnimationPlayer>(*entity).is_some_and(|p| p.playing_animations().next().is_some())
        && world.get::<crate::animation::Actor>(*entity).is_some()
        && world.get::<AnimationGraphHandle>(*entity).is_some_and(|g|
            world.get_resource::<Assets<AnimationGraph>>().is_some_and(|a| a.get(g.id()).is_some())))
}

fn collect_frame(world: &World, serial: u64) -> Frame {
    let mut frame = Frame { serial, ..default() };
    let setup = (|| -> Result<(Scope, Vec<Entity>, Vec<Entity>), String> {
        let (owner, team, tick, champion) = accepted(world)?; frame.source_tick = Some(tick);
        let window = unique(world, "primary Window", |e| e.contains::<PrimaryWindow>() && e.contains::<Window>())?;
        let dimensions = world.get::<Window>(window).unwrap();
        if dimensions.physical_width() == 0 || dimensions.physical_height() == 0 { return Err("primary Window dimensions pending".into()); }
        let (camera, target) = normal_camera(world, window)?;
        let map_root = unique(world, "MapRoot", |e| e.contains::<crate::map_coordinates::MapRoot>() && e.contains::<WorldAssetRoot>())?;
        if world.get::<ChildOf>(map_root).is_some() { return Err("MapRoot is not a top-level scene owner".into()); }
        let model_root = unique(world, "local Playback root", |e| e.get::<crate::animation::Playback>()
            .is_some_and(|p| p.network_id() == owner.player && p.model_name().eq_ignore_ascii_case(&champion)))?;
        if world.get::<ChildOf>(model_root).is_some() || world.get::<crate::actor_fow::Root>(model_root).is_none() {
            return Err("local Playback root is not an owned actor root".into());
        }
        let model = world.get::<crate::animation::Playback>(model_root).unwrap().model_asset_id();
        let map = world.get_resource::<crate::MapHandle>().ok_or("actual MapHandle missing")?.0.id();
        let model_scene=world.get::<WorldAssetRoot>(model_root).ok_or("local current scene root absent")?.0.id();
        let map_scene=world.get::<WorldAssetRoot>(map_root).ok_or("map current scene root absent")?.0.id();
        let model_instance=**world.get::<WorldInstance>(model_root).ok_or("local current scene instance absent")?;
        let map_instance=**world.get::<WorldInstance>(map_root).ok_or("map current scene instance absent")?;
        let visibility_output=world.get_resource::<crate::fow_gpu::Images>().ok_or("actual global scene FoW output pending")?.output.id();
        let scope = Scope { owner, team, window, camera, target, model_root, map_root, model, map,
            model_scene,map_scene,model_instance,map_instance,visibility_output };
        // Identity survives terminal/death; full-scene visibility may correctly
        // become missing. Terminal widgets use their separate existing guards.
        frame.scope = Some(scope.clone());
        for (root, id, label) in [(model_root, model, "local GLTF"), (map_root, map, "MapHandle GLTF")] {
            dependencies(world, id, label)?;
            let gltf = world.get_resource::<Assets<Gltf>>().and_then(|a| a.get(id)).ok_or_else(|| format!("{label}: parent GLTF CPU asset pending"))?;
            let scene = gltf.scenes.first().ok_or_else(|| format!("{label}: scene missing"))?;
            if world.get::<WorldAssetRoot>(root).map(|r| r.0.id()) != Some(scene.id()) || !scene_current(world, root) {
                return Err(format!("{label}: exact scene/WorldInstanceReady instance pending"));
            }
            dependencies(world, scene.id(), label)?;
        }
        Ok((scope, descendants(world, model_root)?, descendants(world, map_root)?))
    })();
    let (scope, local, terrain) = match setup { Ok(value) => value, Err(error) => { frame.missing.push(error); return frame; } };
    if !animation_ready(world, &local) { frame.missing.push("local actual animation player/graph/playing clip pending".into()); }
    for (role, entities) in [(MeshRole::LocalModel, local), (MeshRole::Terrain, terrain)] {
        let mut count = 0;
        for draw in entities.into_iter().filter(|e| world.get::<Mesh3d>(*e).is_some() && visible_mesh(world, *e, scope.camera)) {
            count += 1;
            match mesh_ticket(world, draw, role,&scope) {
                Ok(ticket) if ticket_owned(world, &ticket, &scope) => frame.meshes.push(ticket),
                Ok(_) => frame.missing.push(format!("{role:?} draw {}: mesh/skin escaped its actual scene owner", draw.to_bits())),
                Err(error) => frame.missing.push(format!("{role:?} draw {}: {error}", draw.to_bits())),
            }
        }
        if count == 0 { frame.missing.push(format!("{role:?}: no actual mesh visible in the normal primary camera")); }
    }
    if !frame.meshes.iter().any(|t| t.role == MeshRole::LocalModel && t.skin.is_some()) {
        frame.missing.push("local variable-count skin ticket pending".into());
    }
    for (name, role, exact) in [("NativeMap10HudPanel", UiRole::Frame, Some(3)),
        ("NativeMap10ChampionPortrait", UiRole::Portrait, Some(1)), ("NativeMap10HudGlyph", UiRole::Glyph, None)] {
        let draws = world.iter_entities().filter(|e| e.get::<Name>().is_some_and(|n| n.as_str() == name)).map(|e| e.id()).collect::<Vec<_>>();
        if draws.is_empty() || exact.is_some_and(|n| draws.len() != n) {
            frame.missing.push(format!("{name}: actual node count {} differs from {:?}", draws.len(), exact));
        }
        for draw in draws { match ui_ticket(world, draw, role, scope.camera) {
            Ok(ticket) => frame.ui.push(ticket), Err(error) => frame.missing.push(format!("{name} {}: {error}", draw.to_bits())),
        }}
    }
    if !world.get_resource::<crate::native_hud_widgets::Live>().is_some_and(|live| live.healthy()) {
        frame.missing.push("actual native HUD widget producer pending/error".into());
    }
    frame.meshes.sort_by_key(|ticket| ticket.draw.to_bits()); frame.ui.sort_by_key(|ticket| ticket.draw.to_bits());
    frame
}
fn collect(world: &mut World) {
    let serial = world.resource::<Frame>().serial.checked_add(1);
    let Some(serial) = serial else {
        world.resource_mut::<Frame>().missing = vec!["CPU extraction serial exhausted".into()]; return;
    };
    let frame = collect_frame(world, serial); world.insert_resource(frame);
}

fn current_missing(world: &World, frame: &Frame) -> Vec<String> {
    let mut missing = Vec::new();
    let Some(scope) = &frame.scope else { return vec!["CPU scope unavailable".into()]; };
    if world.get_resource::<crate::fow_gpu::Images>().map(|images|images.output.id())!=Some(scope.visibility_output) {
        missing.push("CPU scope current global scene FoW output changed or missing".into());
    }
    match accepted(world) {
        Ok((owner, team, tick, champion)) if owner == scope.owner && team == scope.team && frame.source_tick.is_some_and(|t| t <= tick)
            && world.get::<crate::animation::Playback>(scope.model_root).is_some_and(|p|p.model_name().eq_ignore_ascii_case(&champion)) => {},
        _ => missing.push("CPU scope no longer matches accepted current owner/team/source tick".into()),
    }
    if world.get::<PrimaryWindow>(scope.window).is_none() || normal_camera(world, scope.window).ok() != Some((scope.camera, scope.target.clone())) {
        missing.push("CPU scope current primary camera/normalized target differs".into());
    }
    if world.get_resource::<crate::MapHandle>().map(|m| m.0.id()) != Some(scope.map)
        || world.get::<crate::animation::Playback>(scope.model_root).map(|p| (p.network_id(), p.model_asset_id())) != Some((scope.owner.player, scope.model))
        || world.get::<crate::map_coordinates::MapRoot>(scope.map_root).is_none()
        || world.get::<crate::actor_fow::Root>(scope.model_root).is_none()
        || world.get::<ChildOf>(scope.map_root).is_some() || world.get::<ChildOf>(scope.model_root).is_some()
        || !scene_current(world, scope.map_root) || !scene_current(world, scope.model_root)
        || world.get::<WorldAssetRoot>(scope.model_root).map(|r|r.0.id())!=Some(scope.model_scene)
        || world.get::<WorldAssetRoot>(scope.map_root).map(|r|r.0.id())!=Some(scope.map_scene)
        || world.get::<WorldInstance>(scope.model_root).map(|r|**r)!=Some(scope.model_instance)
        || world.get::<WorldInstance>(scope.map_root).map(|r|**r)!=Some(scope.map_instance) {
        missing.push("CPU scope current map/model/scene ownership differs".into());
    }
    for (root, id, label) in [(scope.model_root, scope.model, "current local GLTF"), (scope.map_root, scope.map, "current map GLTF")] {
        if let Err(error) = dependencies(world, id, label) { missing.push(error); }
        match world.get_resource::<Assets<Gltf>>().and_then(|a|a.get(id)).and_then(|g|g.scenes.first()) {
            Some(scene) if world.get::<WorldAssetRoot>(root).map(|r|r.0.id()) == Some(scene.id()) => {
                if let Err(error) = dependencies(world, scene.id(), label) { missing.push(error); }
            },
            _ => missing.push(format!("{label}: current CPU parent scene/root identity pending or changed")),
        }
    }
    for (role, root) in [(MeshRole::LocalModel,scope.model_root),(MeshRole::Terrain,scope.map_root)] {
        match descendants(world,root) {
            Ok(entities) => {
                if role == MeshRole::LocalModel && !animation_ready(world,&entities) {
                    missing.push("current local animation player/graph/clip pending".into());
                }
                let mut actual = entities.into_iter().filter(|e|world.get::<Mesh3d>(*e).is_some() && visible_mesh(world,*e,scope.camera))
                    .map(Entity::to_bits).collect::<Vec<_>>(); actual.sort_unstable();
                let mut recorded = frame.meshes.iter().filter(|t|t.role==role).map(|t|t.draw.to_bits()).collect::<Vec<_>>();recorded.sort_unstable();
                if actual != recorded { missing.push(format!("current {role:?} visible owned mesh census changed/pending")); }
            },
            Err(error) => missing.push(format!("current {role:?} hierarchy: {error}")),
        }
    }
    for ticket in &frame.meshes {
        if !ticket_owned(world, ticket, scope) || !visible_mesh(world, ticket.draw, scope.camera) {
            missing.push(format!("CPU current mesh ticket {} owner/visibility changed", ticket.draw.to_bits()));
        } else { match mesh_ticket(world,ticket.draw,ticket.role,scope) {
            Ok(current) if &current==ticket => {},
            Ok(_) => missing.push(format!("CPU current mesh ticket {} asset/skin identity changed",ticket.draw.to_bits())),
            Err(error) => missing.push(format!("CPU current mesh ticket {}: {error}",ticket.draw.to_bits())),
        }}
    }
    for (role,name) in [(UiRole::Frame,"NativeMap10HudPanel"),(UiRole::Portrait,"NativeMap10ChampionPortrait"),(UiRole::Glyph,"NativeMap10HudGlyph")] {
        let mut actual=world.iter_entities().filter(|e|e.get::<Name>().is_some_and(|n|n.as_str()==name)).map(|e|e.id().to_bits()).collect::<Vec<_>>();actual.sort_unstable();
        let mut recorded=frame.ui.iter().filter(|t|t.role==role).map(|t|t.draw.to_bits()).collect::<Vec<_>>();recorded.sort_unstable();
        if actual!=recorded {missing.push(format!("current {name} census changed/pending"));}
    }
    if !world.get_resource::<crate::native_hud_widgets::Live>().is_some_and(|live|live.healthy()) {
        missing.push("current actual native HUD widget producer pending/error".into());
    }
    for ticket in &frame.ui {
        match ui_ticket(world, ticket.draw, ticket.role, scope.camera) {
            Ok(current) if &current==ticket => {},
            Ok(_) => missing.push(format!("CPU current HUD ticket {} identity changed",ticket.draw.to_bits())),
            Err(error) => missing.push(format!("CPU current HUD ticket {}: {error}",ticket.draw.to_bits())),
        }
    }
    missing
}
fn gpu_report(world: &World) -> Result<Option<GpuReport>, String> {
    let shared = world.get_resource::<Shared>().ok_or("main/render Shared bridge absent")?;
    shared.0.lock().map(|report| report.clone()).map_err(|_| "main/render GPU report mutex poisoned".into())
}
fn assessment(world: &World, frame: &Frame, report: Option<&GpuReport>) -> Vec<String> {
    let mut missing = frame.missing.clone(); missing.extend(current_missing(world, frame));
    if frame.serial == 0 { missing.push("CPU extraction frame not observed".into()); }
    match report {
        None => missing.push("GPU resource report not observed".into()),
        Some(report) => {
            if !types::compatible(frame, report) { missing.push("GPU report stale or owner/scope/tickets differ".into()); }
            missing.extend(report.missing.iter().map(|m| format!("GPU: {m}")));
            if report.draw_material_success_observed || report.visible_pixels_qualified {
                missing.push("GPU resource report carries unsupported draw/pixel qualification".into());
            }
        },
    }
    missing.sort(); missing.dedup(); missing
}
fn scope_json(scope: &Scope) -> serde_json::Value {
    serde_json::json!({"owner":{"pid":scope.owner.pid,"session":scope.owner.session,"player":scope.owner.player,"epoch":scope.owner.epoch},
        "team":scope.team,"window":scope.window.to_bits(),"camera":scope.camera.to_bits(),"target":format!("{:?}",scope.target),
        "model_root":scope.model_root.to_bits(),"map_root":scope.map_root.to_bits(),"model":format!("{:?}",scope.model),"map":format!("{:?}",scope.map),
        "model_scene":format!("{:?}",scope.model_scene),"map_scene":format!("{:?}",scope.map_scene),
        "model_instance":format!("{:?}",scope.model_instance),"map_instance":format!("{:?}",scope.map_instance),
        "scene_FoW_output":format!("{:?}",scope.visibility_output)})
}
pub(crate) fn status(world: &World) -> serde_json::Value {
    let Some(frame) = world.get_resource::<Frame>() else {
        return serde_json::json!({"enabled":false,"resources_ready":false,"missing":["capture resource barrier not enabled"],"draw_material_success_observed":false,"visible_pixels_qualified":false});
    };
    let report = gpu_report(world);
    let mut missing = assessment(world, frame, report.as_ref().ok().and_then(|r| r.as_ref()));
    if let Err(error) = &report { missing.push(error.clone()); }
    let report = report.ok().flatten();
    serde_json::json!({"enabled":true,"resources_ready":missing.is_empty(),"scope":frame.scope.as_ref().map(scope_json),
        "CPU_serial":frame.serial,"CPU_source_tick":frame.source_tick,"GPU_serial":report.as_ref().map(|r|r.serial),"missing":missing,
        "mesh_tickets":frame.meshes.iter().map(|t|serde_json::json!({"role":format!("{:?}",t.role),"draw":t.draw.to_bits(),"mesh":format!("{:?}",t.mesh),"material":format!("{:?}",t.material),"image_count":t.images.len(),
            "native_FoW_binding_output":t.native_visibility.map(|id|format!("{id:?}")),"skin_joints":t.skin.as_ref().map(|s|s.joints.len()),
            "Standard_source":t.standard_source.as_ref().map(|s|serde_json::json!({"gltf_material":format!("{:?}",s.source_gltf_material),"gltf_mesh":format!("{:?}",s.source_gltf_mesh),
                "mesh":format!("{:?}",s.source_mesh),"material_name":s.material_name,"mesh_name":s.mesh_name,"Standard_path":s.standard_path,
                "Standard_shader_native_FoW_binding_present":false,"native_texture_shadow_pass_or_pixels_qualified":false}))})).collect::<Vec<_>>(),
        "ui_tickets":frame.ui.iter().map(|t|serde_json::json!({"role":format!("{:?}",t.role),"draw":t.draw.to_bits(),"material":format!("{:?}",t.material),"image_count":t.images.len()})).collect::<Vec<_>>(),
        "image_identities":normalize_images(frame.meshes.iter().flat_map(|t|t.images.iter().copied()).chain(frame.ui.iter().flat_map(|t|t.images.iter().copied())).collect()).iter().map(|i|format!("{i:?}")).collect::<Vec<_>>(),
        "exact_image_skin_and_ticket_vectors_compared_in_memory":report.is_some(),
        "exact_ticket_vector_match":report.as_ref().map(|r|frame.scope.as_ref()==Some(&r.scope)&&frame.meshes==r.meshes&&frame.ui==r.ui),
        "GPU_report_fresh":report.as_ref().map(|r|types::fresh(frame.serial,r.serial)),"FoW_output_CPU_presence_claimed":false,
        "GPU_observations":report.as_ref().map(|r|serde_json::json!({"mesh_resource_rows":r.observations["mesh_rows"].as_array().map(Vec::len),
            "UI_resource_phase_rows":r.observations["UI_rows"].as_array().map(Vec::len),"readonly_render_graph_after_camera_and_FoW":r.observations["readonly_render_graph_after_camera_and_FoW"],
            "opaque_multidraw_entity_membership_may_be_unknown":true,"raw_current_rows_retained_in_memory":true,
            "DrawMaterial_success_observed":false,"visible_pixels_qualified":false})),"draw_material_success_observed":false,"visible_pixels_qualified":false,
        "scope_limit":"Baseline/combat resources only; MapRoot census includes Standard sprites. Their native FoW/texture/shadow/pass parity is unqualified. Global scene FoW, terminal widgets, legal actions, transport and human pixels are separate.",
        "complete":false})
}
pub(crate) fn capture_eligible(world: &World) -> bool {
    let Some(frame) = world.get_resource::<Frame>() else { return false; };
    let Ok(Some(report)) = gpu_report(world) else { return false; };
    assessment(world, frame, Some(&report)).is_empty()
}
pub(crate) fn token(world: &World) -> Option<serde_json::Value> {
    let frame = world.get_resource::<Frame>()?; let report = gpu_report(world).ok()??;
    if !assessment(world, frame, Some(&report)).is_empty() { return None; }
    Some(serde_json::json!({"scope":scope_json(frame.scope.as_ref()?),"CPU_serial":frame.serial,"CPU_source_tick":frame.source_tick,
        "GPU_serial":report.serial,"mesh_count":frame.meshes.len(),"ui_count":frame.ui.len(),"exact_ticket_vectors_matched":true,
        "resources_ready":true,"draw_material_success_observed":false,"visible_pixels_qualified":false}))
}

#[cfg(test)] mod tests {
    use super::*;
    #[test] fn six_gui_capture_disabled_or_missing_report_never_fabricates_ready_token() {
        let mut world = World::new(); assert!(!capture_eligible(&world)); assert!(token(&world).is_none());
        world.insert_resource(Frame::default()); world.insert_resource(Shared::default());
        assert!(!capture_eligible(&world)); assert!(token(&world).is_none());
        assert_eq!(status(&world)["resources_ready"],false);
        assert_eq!(status(&world)["visible_pixels_qualified"],false);
    }
    #[test] fn six_gui_capture_tree_and_parent_guard_do_not_admit_foreign_scene_entities() {
        let mut world = World::new(); let root = world.spawn_empty().id(); let foreign = world.spawn_empty().id();
        let child = world.spawn(ChildOf(foreign)).id();
        // A normal valid hierarchy yields only its own root; no world injection
        // is used to manufacture a SceneReady/runtime report in this definition.
        assert_eq!(descendants(&world,root).unwrap(),vec![root]);
        assert_eq!(world.get::<ChildOf>(child).unwrap().parent(),foreign);
        assert!(!under_root(&world,child,root)); assert!(under_root(&world,child,foreign));
    }
    #[test] fn six_gui_capture_scene_ready_is_not_inferred_from_a_root_handle() {
        let mut world = World::new(); let root = world.spawn(WorldAssetRoot(Handle::default())).id();
        assert!(!scene_current(&world,root)); assert!(world.get::<SceneReady>(root).is_none());
    }
    #[test] fn six_gui_capture_mesh_and_HUD_assets_cannot_use_default_handles_as_loaded_proof() {
        let world = World::new(); assert!(image_cpu(&world,Handle::<Image>::default().id(),"fixture").is_err());
        assert!(ui_images(&world,UiMaterial::Icon(Handle::<crate::native_hud_icon_material::IconMaterial>::default().id())).is_err());
    }
    #[test] fn six_gui_capture_skin_uses_actual_joint_count_and_rejects_missing_or_nonfinite_palette() {
        let mut world = World::new();
        let a = world.spawn(GlobalTransform::IDENTITY).id(); let b = world.spawn(GlobalTransform::IDENTITY).id();
        let mut inverses = Assets::<SkinnedMeshInverseBindposes>::default();
        let inverse = inverses.add(SkinnedMeshInverseBindposes::from(vec![Mat4::IDENTITY,Mat4::IDENTITY]));
        world.insert_resource(inverses);
        let draw = world.spawn(SkinnedMesh { inverse_bindposes:inverse.clone(), joints:vec![a,b] }).id();
        assert_eq!(skin(&world,draw).unwrap().unwrap().joints.len(),2);
        world.get_mut::<SkinnedMesh>(draw).unwrap().joints.push(a);
        assert!(skin(&world,draw).is_err());
        world.get_mut::<SkinnedMesh>(draw).unwrap().joints=vec![a,b];
        *world.resource_mut::<Assets<SkinnedMeshInverseBindposes>>().get_mut(inverse.id()).unwrap()
            = SkinnedMeshInverseBindposes::from(vec![Mat4::IDENTITY,Mat4::from_cols_array(&[f32::NAN;16])]);
        assert!(skin(&world,draw).is_err());
    }
    #[test] fn six_gui_capture_material_diagnostic_keeps_unsupported_standard_and_custom_draws_unavailable() {
        let mut world=World::new();
        let standard=world.spawn((Name::new("Original_Navigation_Surface"),
            GltfMeshName("Reconstructed_Playable_Ground".into()),
            GltfMaterialName("ReconstructedTerrainFallback_NVRMaterial_TT_Jungle1".into()),
            MeshMaterial3d(Handle::<StandardMaterial>::default()))).id();
        let observed=rejected_material_diagnostic(&world,standard);
        assert_eq!(observed["draw"],standard.to_bits());assert_eq!(observed["entity_present"],true);
        assert_eq!(observed["name"],"Original_Navigation_Surface");
        assert_eq!(observed["gltf_mesh_name"],"Reconstructed_Playable_Ground");
        assert_eq!(observed["gltf_material_name"],"ReconstructedTerrainFallback_NVRMaterial_TT_Jungle1");
        assert!(observed["Standard"].is_string());assert!(observed["Fog"].is_null());assert!(observed["Terrain"].is_null());
        assert_eq!(observed["supported_binding_state"],"absent_supported_Fog_or_Terrain");
        assert_eq!(observed["material_binding_accepted"],false);assert_eq!(observed["resources_ready"],false);
        assert!(mesh_material(&world,standard).is_err());
        assert!(materials::standard_source(&world,standard,Entity::PLACEHOLDER,Handle::<Gltf>::default().id()).is_err());
        // An existing real custom Material type remains unsupported by this
        // barrier; its mere component/name never supplies GPU readiness.
        let registry=AppTypeRegistry::default();registry.write().register::<MeshMaterial3d<crate::spawn_mist_material::MistMaterial>>();
        world.insert_resource(registry);
        let custom=world.spawn(MeshMaterial3d(Handle::<crate::spawn_mist_material::MistMaterial>::default())).id();
        let observed=rejected_material_diagnostic(&world,custom);
        assert!(observed["Standard"].is_null());assert_eq!(observed["material_binding_accepted"],false);
        assert!(observed["custom_material_component_type_names"].as_array().unwrap().iter()
            .any(|name|name.as_str()==Some(<MeshMaterial3d<crate::spawn_mist_material::MistMaterial> as bevy::reflect::TypePath>::type_path())));
        assert!(mesh_material(&world,custom).is_err());assert!(!capture_eligible(&world));assert!(token(&world).is_none());
    }
    #[test] fn six_gui_capture_material_diagnostic_distinguishes_absent_ambiguous_and_retired_entities() {
        let mut world=World::new();let absent=world.spawn_empty().id();
        assert_eq!(rejected_material_diagnostic(&world,absent)["supported_binding_state"],"absent_supported_Fog_or_Terrain");
        assert!(mesh_material(&world,absent).is_err());
        let fog=Handle::<crate::map_fog::FogMaterial>::default();let terrain=Handle::<crate::terrain_material::TerrainMaterial>::default();
        let draw=world.spawn(MeshMaterial3d(fog.clone())).id();
        assert_eq!(mesh_material(&world,draw).unwrap(),MeshMaterial::Fog(fog.id()));
        world.entity_mut(draw).insert(MeshMaterial3d(terrain.clone()));
        let observed=rejected_material_diagnostic(&world,draw);
        assert_eq!(observed["supported_binding_state"],"ambiguous_Fog_and_Terrain");
        assert!(observed["Fog"].is_string());assert!(observed["Terrain"].is_string());assert!(mesh_material(&world,draw).is_err());
        world.entity_mut(draw).remove::<MeshMaterial3d<crate::map_fog::FogMaterial>>();
        assert_eq!(mesh_material(&world,draw).unwrap(),MeshMaterial::Terrain(terrain.id()));
        world.despawn(draw);let observed=rejected_material_diagnostic(&world,draw);
        assert_eq!(observed["entity_present"],false);assert_eq!(observed["component_type_names_available"],false);
        assert!(mesh_material(&world,draw).is_err());
        assert_eq!(observed["visible_pixels_qualified"],false);assert_eq!(observed["DrawMaterial_success_observed"],false);
        let long_name="🕷".repeat(1_025);world.entity_mut(absent).insert(Name::new(long_name.clone()));
        let observed=rejected_material_diagnostic(&world,absent);
        assert_eq!(observed["name"]["source_bytes"],long_name.len());
        assert_eq!(observed["name"]["truncated"],true);assert_eq!(observed["name"]["exact_value_unknown"],true);
        assert!(observed["name"]["prefix"].as_str().unwrap().len()<=1_024);
    }
}
