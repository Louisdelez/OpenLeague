//! Private E Complex strict draw bridge. Current is replaced on every accepted frame
//! and invalidated on loss before rendering. Complex current geometry only, at most 64 bindings.
use std::{any::TypeId, collections::{HashMap, HashSet}};
use bevy::{prelude::*, asset::AssetId, core_pipeline::core_3d::Transparent3d,
    pbr::{DrawMaterial, MaterialBindGroupAllocators, MaterialPlugin, PreparedMaterial,
        RenderMaterialInstances, RenderMeshInstances},
    render::{Extract, ExtractSchedule, Render, RenderApp, RenderStartup, RenderSystems,
        batching::NoAutomaticBatching,
        erased_render_asset::{prepare_erased_assets, AssetExtractionSystems, ErasedRenderAssets, ExtractedAssets},
        render_asset::{prepare_assets, RenderAssets}, renderer::RenderDevice, texture::GpuImage,
        render_phase::{Draw, DrawError, DrawFunctions, PhaseItem, RenderCommandState,
            SortedRenderPhase, TrackedRenderPass, ViewSortedRenderPhases},
        render_resource::BindGroupId, sync_world::{MainEntity, RenderEntity}}};
use crate::{fow_champion_sources::MaskSourceStamp,
    ezreal_e_complex_material::{current_image_bindings, ImageBindings, SourceKey, StrictData, StrictMaterial}};

pub(crate) const MAX_BINDINGS: usize = 64;

#[derive(Clone)]
pub(crate) struct Frontier {
    pub(crate) source: MaskSourceStamp,
    pub(crate) accepted_epoch: u64,
    pub(crate) camera: Entity,
}
impl Frontier {
    fn same(&self, other: &Self) -> bool {
        self.accepted_epoch == other.accepted_epoch && self.camera == other.camera
            && self.source.same_episode(&other.source)
    }
}
#[derive(Clone)]
pub(crate) struct Request {
    pub(crate) entity: Entity,
    pub(crate) material: Handle<StrictMaterial>,
    pub(crate) pool_incarnation: u64,
    pub(crate) input_revision: u64,
}
#[derive(Clone)]
pub(crate) struct Admission {
    pub(crate) token: u64,
    pub(crate) entity: MainEntity,
    pub(crate) material: AssetId<StrictMaterial>,
    pub(crate) pool_incarnation: u64,
    pub(crate) input_revision: u64,
    pub(crate) frontier: Frontier,
}
impl Admission {
    pub(crate) fn same(&self, other: &Self) -> bool {
        self.token == other.token && self.entity == other.entity && self.material == other.material
            && self.pool_incarnation == other.pool_incarnation && self.input_revision == other.input_revision
            && self.frontier.same(&other.frontier)
    }
    fn same_request(&self, frontier: &Frontier, request: &Request) -> bool {
        self.entity == MainEntity::from(request.entity) && self.material == request.material.id()
            && self.pool_incarnation == request.pool_incarnation && self.input_revision == request.input_revision
            && self.frontier.same(frontier)
    }
}
#[derive(Clone)]
struct MainRow { admission: Admission, _material: Handle<StrictMaterial> }

/// No history per projectile/publication. One current set plus a checked serial.
#[derive(Resource, Default)]
pub(crate) struct Current {
    rows: HashMap<MainEntity, MainRow>,
    serial: u64,
    exhausted: bool,
}
impl Current {
    pub(crate) fn invalidate(&mut self) { self.rows.clear(); }
    #[cfg(test)]
    pub(crate) fn test_admission(&self, entity: Entity) -> Option<Admission> {
        self.rows.get(&MainEntity::from(entity)).map(|row| row.admission.clone())
    }
    #[cfg(test)]
    pub(crate) fn test_len(&self) -> usize { self.rows.len() }
    pub(crate) fn replace(&mut self, frontier: Frontier, requests: Vec<Request>) -> Result<(), &'static str> {
        let result = self.replace_checked(frontier, requests);
        if result.is_err() { self.invalidate(); }
        result
    }
    fn replace_checked(&mut self, frontier: Frontier, requests: Vec<Request>) -> Result<(), &'static str> {
        if self.exhausted { return Err("strict E Complex admission serial exhausted"); }
        if frontier.source.team >= 2 || requests.len() > MAX_BINDINGS { return Err("invalid strict E Complex audience or budget"); }
        let mut next = HashMap::with_capacity(requests.len());
        let mut materials = HashSet::with_capacity(requests.len());
        for request in requests {
            let entity = MainEntity::from(request.entity);
            if request.pool_incarnation == 0 || next.contains_key(&entity) || !materials.insert(request.material.id()) {
                return Err("ambiguous strict E Complex instance/material");
            }
            let admission = if let Some(old) = self.rows.get(&entity).filter(|row| row.admission.same_request(&frontier, &request)) {
                old.admission.clone()
            } else {
                let Some(serial) = self.serial.checked_add(1) else {
                    self.exhausted = true; return Err("strict E Complex admission serial exhausted");
                };
                self.serial = serial;
                Admission { token: serial, entity, material: request.material.id(),
                    pool_incarnation: request.pool_incarnation, input_revision: request.input_revision, frontier: frontier.clone() }
            };
            next.insert(entity, MainRow { admission, _material: request.material });
        }
        self.rows = next;
        Ok(())
    }
}

#[derive(Clone)]
struct Spec {
    admission: Admission,
    inputs: SourceKey,
    source: StrictMaterial,
    render_view: Entity,
}
#[derive(Resource, Default)]
struct ExtractedCurrent { rows: HashMap<MainEntity, Spec> }

fn extract_current(current: Extract<Option<Res<Current>>>, assets: Extract<Option<Res<Assets<StrictMaterial>>>>,
    meshes: Extract<Query<(&MeshMaterial3d<StrictMaterial>, Has<NoAutomaticBatching>)>>,
    cameras: Extract<Query<&RenderEntity, With<Camera3d>>>, mut target: ResMut<ExtractedCurrent>,
) {
    let mut next = HashMap::new();
    if let (Some(current), Some(assets)) = (current.as_ref(), assets.as_ref()) {
        if !current.exhausted && current.rows.len() <= MAX_BINDINGS {
            for (entity, row) in &current.rows {
                let admission = &row.admission;
                let Ok((mesh_material, no_auto)) = meshes.get(entity.id()) else { continue; };
                if !no_auto || mesh_material.id() != admission.material { continue; }
                let Ok(camera) = cameras.get(admission.frontier.camera) else { continue; };
                let Some(source) = assets.get(admission.material) else { continue; };
                let Some(inputs) = source.source_key() else { continue; };
                next.insert(*entity, Spec { admission: admission.clone(), inputs,
                    source: source.for_admission(admission), render_view: camera.id() });
            }
        }
    }
    // Direct replacement in Extract, with no Commands backlog and no carried
    // PreparedMaterial/strong transport proof in this authority table.
    target.rows = next;
}

#[derive(Clone)]
pub(crate) struct PreparationContext {
    pub(crate) admission: Admission,
    pub(crate) inputs: SourceKey,
    pub(crate) physical: ImageBindings,
    pub(crate) recovery: u64,
}
#[derive(Resource, Default)]
pub(crate) struct PreparationContexts {
    pub(crate) current: HashMap<AssetId<StrictMaterial>, PreparationContext>,
}
#[derive(Clone)]
struct Handed { admission: Admission, inputs: SourceKey, physical: Option<(ImageBindings, u64)> }
#[derive(Resource, Default)]
struct LastHanded { rows: HashMap<AssetId<StrictMaterial>, Handed>, replay: bool }

fn purge(extracted: &mut ExtractedAssets<MeshMaterial3d<StrictMaterial>>, id: AssetId<StrictMaterial>) {
    extracted.extracted.retain(|(candidate, _)| *candidate != id);
    extracted.added.remove(&id); extracted.modified.remove(&id); extracted.removed.insert(id);
}
fn reconcile_handoff(current: &ExtractedCurrent, contexts: &PreparationContexts, last: &mut LastHanded,
    extracted: &mut ExtractedAssets<MeshMaterial3d<StrictMaterial>>,
) {
    let desired: HashSet<_> = current.rows.values().map(|s| s.admission.material).collect();
    for id in last.rows.keys().copied().filter(|id| !desired.contains(id)).collect::<Vec<_>>() {
        purge(extracted, id); last.rows.remove(&id);
    }
    // The entire type is private opt-in. Unadmitted raw Main extractions are
    // discarded before they can allocate or enter a normal retry queue.
    extracted.extracted.retain(|(id, _)| desired.contains(id));
    extracted.added.retain(|id| desired.contains(id));
    extracted.modified.retain(|id| desired.contains(id));
    for spec in current.rows.values() {
        let id = spec.admission.material;
        let context = contexts.current.get(&id);
        let physical = context.map(|c| (c.physical, c.recovery));
        let old = last.rows.get(&id);
        let same_source = old.is_some_and(|old| old.admission.same(&spec.admission) && old.inputs == spec.inputs);
        // A missing image may temporarily prevent binding preparation. Keep an
        // already handed binding until a new physical/recovery context differs;
        // the actual Draw rechecks all images and requires a fresh Encoded proof.
        let same_binding = physical.is_none() || old.is_some_and(|old| old.physical == physical);
        let standard_fresh = extracted.extracted.iter().any(|(candidate, _)| *candidate == id)
            || extracted.added.contains(&id) || extracted.modified.contains(&id) || extracted.removed.contains(&id);
        if !last.replay && same_source && same_binding && !standard_fresh { continue; }
        extracted.extracted.retain(|(candidate, _)| *candidate != id);
        extracted.extracted.push((id, spec.source.clone()));
        extracted.added.insert(id); extracted.modified.remove(&id); extracted.removed.remove(&id);
        // Persist BEFORE generic prepare, including Retry. Never advance this
        // state during Extract, whose per-frame arrays may be cleared repeatedly.
        last.rows.insert(id, Handed { admission: spec.admission.clone(), inputs: spec.inputs.clone(), physical });
    }
    last.replay = false;
}
fn handoff(world: &mut World) {
    let Some(current) = world.get_resource::<ExtractedCurrent>() else { return; };
    let mut contexts = PreparationContexts::default();
    for spec in current.rows.values() {
        let source = &spec.admission.frontier.source;
        let Some(features) = world.get_resource::<RenderDevice>().map(RenderDevice::features) else { continue; };
        let Some(physical) = world.get_resource::<RenderAssets<GpuImage>>().and_then(|gpu| current_image_bindings(&spec.inputs, gpu, features)) else { continue; };
        // PrepareAssets runs BEFORE this frame's FoW Encoded pass. Binding a
        // current output is preparation only; waiting for Encoded here would
        // starve every frame whose CPU publication has just changed.
        let Some(recovery) = crate::fow_gpu::output_recovery_for_preparation(world, source, spec.inputs.output()) else { continue; };
        contexts.current.insert(spec.admission.material, PreparationContext { admission: spec.admission.clone(), inputs: spec.inputs.clone(),
            physical, recovery });
    }
    world.insert_resource(contexts);
    world.resource_scope(|world, mut last: Mut<LastHanded>| {
        world.resource_scope(|world, mut extracted: Mut<ExtractedAssets<MeshMaterial3d<StrictMaterial>>>| {
            reconcile_handoff(world.resource::<ExtractedCurrent>(), world.resource::<PreparationContexts>(), &mut last, &mut extracted);
        });
    });
}
fn restart(mut last: ResMut<LastHanded>, mut contexts: ResMut<PreparationContexts>) {
    last.replay = true; contexts.current.clear();
}

fn mesh_is_single(meshes: &RenderMeshInstances, entity: MainEntity) -> bool {
    meshes.render_mesh_queue_data(entity).is_some_and(|mesh| !mesh.should_batch())
}
fn route_phase(phase: &mut SortedRenderPhase<Transparent3d>, instances: &RenderMaterialInstances,
    current: &ExtractedCurrent, draw: bevy::render::render_phase::DrawFunctionId,
) {
    phase.items.retain(|_, item| {
        let instance = instances.instances.get(&item.main_entity());
        let strict = instance.is_some_and(|i| i.asset_id.type_id() == TypeId::of::<StrictMaterial>());
        if !strict {
            // A retained former-owned item can outlive its instance. It must
            // not keep an owned route; foreign standard items remain untouched.
            return item.draw_function != draw;
        }
        let Some(spec) = current.rows.get(&item.main_entity()) else { return false; };
        // Bevy's ordinary PBR queue uses (Entity::PLACEHOLDER, MainEntity).
        // Its SetMaterialBindGroup and DrawMesh resolve the mesh by MainEntity.
        if spec.admission.entity != item.main_entity() || instance.unwrap().asset_id != spec.admission.material.untyped() { return false; }
        item.draw_function = draw;
        true
    });
}
fn route_retained(mut phases: ResMut<ViewSortedRenderPhases<Transparent3d>>, instances: Res<RenderMaterialInstances>,
    current: Res<ExtractedCurrent>, functions: Res<DrawFunctions<Transparent3d>>,
) {
    let draw = functions.read().get_id::<StrictDraw>();
    let Some(draw) = draw else {
        for phase in phases.values_mut() {
            phase.items.retain(|_, item| instances.instances.get(&item.main_entity())
                .is_none_or(|i| i.asset_id.type_id() != TypeId::of::<StrictMaterial>()));
        }
        return;
    };
    for phase in phases.values_mut() { route_phase(phase, &instances, &current, draw); }
}

/// PBR mesh identity and the exact render camera are independent. This is only
/// the identity gate; it does not authorize GPU commands or material bindings.
fn draw_spec_for_view<'w>(world: &'w World, view: Entity, item: &Transparent3d) -> Option<&'w Spec> {
    let spec = world.get_resource::<ExtractedCurrent>()?.rows.get(&item.main_entity())?;
    if spec.admission.entity != item.main_entity() || spec.render_view != view { return None; }
    if world.get::<MainEntity>(view)?.id() != spec.admission.frontier.camera { return None; }
    Some(spec)
}

/// None means no delegation. IDs only; no proof or mutable Arc escapes World.
fn authorised(world: &World, view: Entity, item: &Transparent3d) -> Option<BindGroupId> {
    if item.batch_range.end.checked_sub(item.batch_range.start)? != 1 { return None; }
    let spec = draw_spec_for_view(world, view, item)?;
    if !mesh_is_single(world.get_resource::<RenderMeshInstances>()?, item.main_entity()) { return None; }
    let instances = world.get_resource::<RenderMaterialInstances>()?;
    let instance = instances.instances.get(&item.main_entity())?;
    if instance.asset_id.type_id() != TypeId::of::<StrictMaterial>() || instance.asset_id != spec.admission.material.untyped() { return None; }
    let material = world.get_resource::<ErasedRenderAssets<PreparedMaterial>>()?.get(instance.asset_id)?;
    if material.properties.bindless || material.properties.shadows_enabled || material.properties.prepass_enabled
        || material.properties.reads_view_transmission_texture || material.properties.alpha_mode != AlphaMode::Blend { return None; }
    let data = material.properties.material_key.to_key::<StrictData>();
    let capture = data.capture.as_ref()?;
    if !capture.admission.same(&spec.admission) || capture.inputs != spec.inputs { return None; }
    let features = world.get_resource::<RenderDevice>()?.features();
    let physical = current_image_bindings(&spec.inputs, world.get_resource::<RenderAssets<GpuImage>>()?, features)?;
    if physical != capture.physical { return None; }
    let (output_texture, output_view) = physical.output();
    let source = &spec.admission.frontier.source;
    let proof = crate::fow_gpu::encoded_output_for_team(world, source.session, source.team, spec.inputs.output())?;
    if proof.recovery() != capture.recovery || !proof.matches_source(source)
        || !proof.matches_output(source.session, source.team, spec.inputs.output(), output_texture, output_view) { return None; }
    let allocators = world.get_resource::<MaterialBindGroupAllocators>()?;
    let allocator = allocators.get(&instance.asset_id.type_id())?;
    let group = allocator.get(material.binding.group)?.bind_group()?;
    Some(group.id())
}
struct StrictDraw { inner: RenderCommandState<Transparent3d, DrawMaterial> }
impl Draw<Transparent3d> for StrictDraw {
    fn prepare(&mut self, world: &World) { self.inner.prepare(world); }
    fn draw<'w>(&mut self, world: &'w World, pass: &mut TrackedRenderPass<'w>, view: Entity, item: &Transparent3d) -> Result<(), DrawError> {
        if authorised(world, view, item).is_none() { return Ok(()); }
        // Same immutable World, exact same lookup as SetMaterialBindGroup.
        // Never reacquire DrawFunctions.write() from inside its held lock.
        self.inner.draw(world, pass, view, item)
    }
}
fn register_draw(world: &mut World) {
    if world.resource::<DrawFunctions<Transparent3d>>().read().get_id::<StrictDraw>().is_some() { return; }
    let inner = RenderCommandState::<Transparent3d, DrawMaterial>::new(world);
    world.resource::<DrawFunctions<Transparent3d>>().write().add(StrictDraw { inner });
}

pub(crate) struct Plugin;
impl bevy::prelude::Plugin for Plugin {
    fn build(&self, app: &mut App) {
        app.init_resource::<Current>().add_plugins(MaterialPlugin::<StrictMaterial>::default());
        if let Some(render) = app.get_sub_app_mut(RenderApp) {
            render.init_resource::<ExtractedCurrent>().init_resource::<LastHanded>().init_resource::<PreparationContexts>()
                .add_systems(ExtractSchedule, extract_current.after(AssetExtractionSystems))
                .add_systems(RenderStartup, (register_draw, restart))
                .add_systems(Render, handoff.in_set(RenderSystems::PrepareAssets)
                    .after(prepare_assets::<GpuImage>).before(prepare_erased_assets::<MeshMaterial3d<StrictMaterial>>))
                .add_systems(Render, route_retained.after(RenderSystems::Queue).before(RenderSystems::PhaseSort)
                    .before(RenderSystems::PrepareResourcesBatchPhases));
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use bevy::{core_pipeline::core_3d::TransparentSortingInfo3d, ecs::schedule::Schedule,
        render::{MainWorld, render_phase::PhaseItemExtraIndex, render_resource::CachedRenderPipelineId}};
    fn frontier(camera: Entity) -> Frontier {
        let (snapshot, viewer, mut map, mut sources) = crate::fow_champion_sources::mask_provenance_tests::native_fixture();
        crate::fow_champion_sources::mask_provenance_tests::cycle(&mut sources, &snapshot, viewer, &mut map).unwrap();
        let team = snapshot.roster.iter().find(|p| p.id == viewer).unwrap().team;
        Frontier { source: sources.mask_stamp(&map, snapshot.session, team).unwrap(), accepted_epoch: 7, camera }
    }
    fn source() -> StrictMaterial {
        crate::ezreal_e_complex_material::fixture_material()
    }
    fn phase_item(entity: Entity, main: MainEntity, draw: bevy::render::render_phase::DrawFunctionId) -> Transparent3d {
        Transparent3d { sorting_info: TransparentSortingInfo3d::AlwaysOnTop, distance: 0., pipeline: CachedRenderPipelineId::INVALID,
            entity: (entity, main), draw_function: draw, batch_range: 0..1, extra_index: PhaseItemExtraIndex::None, indexed: false }
    }
    #[test]
    fn every_accepted_gap_epoch_view_and_instance_change_revoke_old_material_admission_without_replay() {
        let mut world = World::new(); let camera = world.spawn_empty().id(); let entity = world.spawn_empty().id();
        let mut materials = Assets::<StrictMaterial>::default(); let material = materials.add(source());
        let f = frontier(camera); let request = Request { entity, material, pool_incarnation: 1, input_revision: 2 };
        let key = MainEntity::from(entity); let mut current = Current::default();
        current.replace(f.clone(), vec![request.clone()]).unwrap(); let first = current.rows[&key].admission.clone();
        current.replace(f.clone(), vec![request.clone()]).unwrap(); assert!(first.same(&current.rows[&key].admission));
        current.invalidate(); current.replace(f.clone(), vec![request.clone()]).unwrap();
        assert!(!first.same(&current.rows[&key].admission), "gap+return before Extract cannot resurrect the old prepared Data");
        let prior = current.rows[&key].admission.clone(); let mut next = f.clone(); next.accepted_epoch += 1;
        current.replace(next, vec![request.clone()]).unwrap(); assert!(!prior.same(&current.rows[&key].admission));
        let prior = current.rows[&key].admission.clone(); let mut next = f.clone(); next.camera = world.spawn_empty().id();
        current.replace(next, vec![request.clone()]).unwrap(); assert!(!prior.same(&current.rows[&key].admission));
        let prior = current.rows[&key].admission.clone(); let mut request = request; request.pool_incarnation += 1;
        current.replace(f, vec![request]).unwrap(); assert!(!prior.same(&current.rows[&key].admission));
        current.serial = u64::MAX; current.invalidate();
        let row = current.replace(frontier(camera), vec![Request { entity, material: materials.add(source()), pool_incarnation: 8, input_revision: 0 }]);
        assert!(row.is_err()); assert!(current.exhausted); assert!(current.rows.is_empty());
    }
    #[test]
    fn real_extract_and_assets_keep_latest_source_across_47_skipped_renders_and_retire_owned_retry_only() {
        let mut main = MainWorld::default(); let camera = main.spawn((Camera3d::default(), RenderEntity::from(Entity::from_bits(1001)))).id();
        let mut materials = Assets::<StrictMaterial>::default(); let material = materials.add(source()); let foreign = materials.add(source());
        // The PBR mesh itself need not carry a RenderEntity: queueing and DrawMesh
        // use MainEntity. The camera keeps its separate exact RenderEntity.
        let entity = main.spawn((MeshMaterial3d(material.clone()), NoAutomaticBatching)).id();
        let mut current = Current::default(); let f = frontier(camera);
        let mut request = Request { entity, material: material.clone(), pool_incarnation: 1, input_revision: 0 };
        current.replace(f.clone(), vec![request.clone()]).unwrap(); main.insert_resource(current); main.insert_resource(materials);
        let mut render = World::new(); render.insert_resource(main); render.init_resource::<ExtractedCurrent>();
        render.init_resource::<LastHanded>(); render.init_resource::<PreparationContexts>();
        render.init_resource::<ExtractedAssets<MeshMaterial3d<StrictMaterial>>>();
        let mut extract = Schedule::new(ExtractSchedule); extract.add_systems(extract_current);
        extract.run(&mut render);
        let initial = render.resource::<ExtractedCurrent>().rows[&entity.into()].admission.clone();
        render.resource_scope(|world, mut last: Mut<LastHanded>| world.resource_scope(|world, mut assets: Mut<ExtractedAssets<MeshMaterial3d<StrictMaterial>>>| {
            reconcile_handoff(world.resource::<ExtractedCurrent>(), world.resource::<PreparationContexts>(), &mut last, &mut assets);
        }));
        assert_eq!(render.resource::<LastHanded>().rows.len(), 1);
        for revision in 1..=47 {
            request.input_revision = revision;
            render.resource_mut::<MainWorld>().resource_mut::<Current>().replace(f.clone(), vec![request.clone()]).unwrap();
            let mut fresh = render.resource_mut::<ExtractedAssets<MeshMaterial3d<StrictMaterial>>>();
            fresh.extracted.clear(); fresh.added.clear(); fresh.modified.clear(); fresh.removed.clear(); drop(fresh);
            extract.run(&mut render);
            assert!(render.resource::<LastHanded>().rows[&material.id()].admission.same(&initial), "Extract does not forget the queued Render owner");
        }
        render.resource_scope(|world, mut last: Mut<LastHanded>| world.resource_scope(|world, mut assets: Mut<ExtractedAssets<MeshMaterial3d<StrictMaterial>>>| {
            reconcile_handoff(world.resource::<ExtractedCurrent>(), world.resource::<PreparationContexts>(), &mut last, &mut assets);
        }));
        let latest = render.resource::<LastHanded>().rows[&material.id()].admission.clone(); assert_eq!(latest.input_revision, 47);
        assert_eq!(render.resource::<ExtractedAssets<MeshMaterial3d<StrictMaterial>>>().extracted.len(), 1);
        // A foreign material of the SAME private type cannot gain a contract;
        // no removed/unload is injected for an ID never handed by this bridge.
        render.resource_mut::<ExtractedAssets<MeshMaterial3d<StrictMaterial>>>().extracted.push((foreign.id(), source()));
        render.resource_mut::<MainWorld>().remove_resource::<Current>(); extract.run(&mut render);
        render.resource_scope(|world, mut last: Mut<LastHanded>| world.resource_scope(|world, mut assets: Mut<ExtractedAssets<MeshMaterial3d<StrictMaterial>>>| {
            reconcile_handoff(world.resource::<ExtractedCurrent>(), world.resource::<PreparationContexts>(), &mut last, &mut assets);
        }));
        let assets = render.resource::<ExtractedAssets<MeshMaterial3d<StrictMaterial>>>();
        assert!(assets.removed.contains(&material.id())); assert!(!assets.removed.contains(&foreign.id()));
        assert!(render.resource::<LastHanded>().rows.is_empty());
        assert!(assets.extracted.is_empty());
    }
    #[test]
    fn retained_phase_routes_only_opted_in_instances_and_never_delegates_without_real_gpu_binding() {
        let mut world = World::new(); let camera = world.spawn_empty().id(); let entity = world.spawn_empty().id(); let other = world.spawn_empty().id();
        let render_view = world.spawn(MainEntity::from(camera)).id();
        let mut materials = Assets::<StrictMaterial>::default(); let material = materials.add(source());
        let f = frontier(camera); let mut current = Current::default();
        current.replace(f, vec![Request { entity, material: material.clone(), pool_incarnation: 1, input_revision: 0 }]).unwrap();
        let admission = current.rows[&entity.into()].admission.clone();
        let mut extracted = ExtractedCurrent::default(); let source = materials.get(material.id()).unwrap();
        extracted.rows.insert(entity.into(), Spec { admission, inputs: source.source_key().unwrap(), source: source.clone(), render_view });
        let functions = DrawFunctions::<Transparent3d>::default();
        struct EmptyDraw; impl Draw<Transparent3d> for EmptyDraw {
            fn draw<'w>(&mut self, _: &'w World, _: &mut TrackedRenderPass<'w>, _: Entity, _: &Transparent3d) -> Result<(), DrawError> { Ok(()) }
        }
        let foreign_draw = functions.write().add(EmptyDraw);
        let own_draw = functions.write().add(EmptyDraw);
        let mut instances = RenderMaterialInstances::default();
        let mut phase = SortedRenderPhase::<Transparent3d>::default();
        phase.add_retained(phase_item(Entity::PLACEHOLDER, entity.into(), foreign_draw));
        phase.add_retained(phase_item(Entity::PLACEHOLDER, other.into(), foreign_draw));
        // No instance means no legitimate strict material; foreign items survive
        // byte-for-byte in their relevant fields, and no GPU readiness is forged.
        route_phase(&mut phase, &instances, &extracted, own_draw); assert_eq!(phase.items.len(), 2);
        let row = instances.current_change_tick;
        instances.instances.insert(entity.into(), bevy::pbr::RenderMaterialInstance { asset_id: material.id().untyped(), last_change_tick: row });
        route_phase(&mut phase, &instances, &extracted, own_draw);
        let owned_key = (Entity::PLACEHOLDER, entity.into()); let foreign_key = (Entity::PLACEHOLDER, other.into());
        assert_eq!(phase.items[&owned_key].draw_function, own_draw);
        assert_eq!(phase.items[&owned_key].entity(), Entity::PLACEHOLDER);
        assert_eq!(phase.items[&foreign_key].draw_function, foreign_draw);
        world.insert_resource(extracted); world.insert_resource(instances);
        assert!(draw_spec_for_view(&world, render_view, &phase.items[&owned_key]).is_some(), "real PBR PLACEHOLDER items pass the MainEntity mesh identity gate");
        assert!(draw_spec_for_view(&world, camera, &phase.items[&owned_key]).is_none(), "the render camera is still exact, not replaced by the Main camera entity");
        world.entity_mut(render_view).insert(MainEntity::from(other));
        assert!(draw_spec_for_view(&world, render_view, &phase.items[&owned_key]).is_none(), "a render-view mapping to another Main camera is rejected");
        world.entity_mut(render_view).insert(MainEntity::from(camera));
        assert!(authorised(&world, render_view, &phase.items[&owned_key]).is_none(), "CPU contract is never a prepared GPU group or encoded proof");
        world.resource_mut::<ExtractedCurrent>().rows.clear();
        route_phase(&mut phase, world.resource::<RenderMaterialInstances>(), world.resource::<ExtractedCurrent>(), own_draw);
        assert_eq!(phase.items.len(), 1); assert_eq!(phase.items[&foreign_key].draw_function, foreign_draw);
    }

    #[test]
    fn actual_extracted_mesh_batching_flag_is_checked_independently_of_main_contract() {
        use bevy::pbr::{RenderMeshInstancesGpu, RenderMeshInstanceGpu,
            RenderMeshInstanceSharedFlatBlob, RenderMeshInstanceGpuFlatBlob, RenderMeshInstanceFlags};
        let mut world = World::new(); let entity = MainEntity::from(world.spawn_empty().id());
        let mut meshes = RenderMeshInstancesGpu::default();
        let instance = RenderMeshInstanceGpu {
            shared: RenderMeshInstanceSharedFlatBlob::default(),
            gpu_specific: RenderMeshInstanceGpuFlatBlob::default(), render_layers: None,
        };
        instance.shared.set_flags(RenderMeshInstanceFlags::AUTOMATIC_BATCHING);
        meshes.insert(entity, instance);
        let meshes = RenderMeshInstances::GpuBuilding(meshes);
        assert!(!mesh_is_single(&meshes, entity));
        let RenderMeshInstances::GpuBuilding(rows) = &meshes else { unreachable!() };
        rows[&entity].shared.set_flags(RenderMeshInstanceFlags::empty());
        assert!(mesh_is_single(&meshes, entity));
        assert!(!mesh_is_single(&meshes, MainEntity::from(world.spawn_empty().id())));
        // This exercises actual PBR extracted data only, not a GPU draw or a
        // claim that the future Main consumer has installed NoAutomaticBatching.
    }

    #[test]
    fn bounded_unique_bindings_clear_the_channel_on_any_ambiguous_replacement() {
        let mut world=World::new();let camera=world.spawn_empty().id();let f=frontier(camera);
        let mut materials=Assets::<StrictMaterial>::default();
        let rows:Vec<_>=(0..MAX_BINDINGS).map(|_|Request {entity:world.spawn_empty().id(),
            material:materials.add(source()),pool_incarnation:1,input_revision:0}).collect();
        let mut current=Current::default();current.replace(f.clone(),rows.clone()).unwrap();
        assert_eq!(current.test_len(),MAX_BINDINGS);
        let mut over=rows.clone();over.push(Request {entity:world.spawn_empty().id(),material:materials.add(source()),
            pool_incarnation:1,input_revision:0});
        assert!(current.replace(f.clone(),over).is_err());assert_eq!(current.test_len(),0);
        for bad in 0..4 {
            current.replace(f.clone(),rows.clone()).unwrap();let mut next=rows.clone();let mut audience=f.clone();
            match bad {0=>next[1].material=next[0].material.clone(),1=>next[1].entity=next[0].entity,
                2=>next[0].pool_incarnation=0,3=>audience.source.team=2,_=>unreachable!()}
            assert!(current.replace(audience,next).is_err());assert_eq!(current.test_len(),0);
        }
    }
}
