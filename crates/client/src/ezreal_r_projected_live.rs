//! Local current-point adapter for Ezreal_TrueShot_mis / group 2 Projected.
//! XYZ is one accepted server sample. No launch, elapsed particle age, actor Y,
//! pitch, hidden trajectory or other Troy group is reconstructed here.
use bevy::{prelude::*, render::batching::NoAutomaticBatching};
use std::collections::{BTreeMap, BTreeSet};
use crate::{ezreal_r_passive_presentation::{CurrentR3d, Key},
    ezreal_r_projected_draw::{Current, Frontier, Request},
    ezreal_r_projected_material::{SourceKey, StrictMaterial},
    projected_render::ProjectedMaterial, projected_surface::TerrainProjection,
    projected_terrain::TerrainSurfaces};

const MAX_R: usize = 64;
const TEXTURE: &str = "particles/ezreal/r_projected/disintegrate-light.png";
const COLOR: &str = "particles/ezreal/r_projected/color-hold.png";

#[derive(Clone, Copy, Debug, serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct Authored { particle_scale: f32, range: f32, fading: f32 }
impl Authored {
    fn load() -> Result<Self, &'static str> {
        let value: Self = serde_json::from_str(include_str!("../../../data/4.20/particles/ezreal/r_projected_profile.json"))
            .map_err(|_| "invalid R Projected authored resource")?;
        if value.particle_scale != 600. || value.range != 250. || value.fading != 100. {
            return Err("unsupported R Projected authored profile");
        }
        Ok(value)
    }
    fn projection(self, sample: &CurrentR3d) -> Option<TerrainProjection> {
        let position = Vec3::new(sample.position.x, sample.y_native, sample.position.z);
        if !position.is_finite() || !sample.direction.x.is_finite() || !sample.direction.z.is_finite() {
            return None;
        }
        // The 9414A9 emitter factor starts at1; absent owner-scale coefficients
        // remain0 (91EFE4..91F087). Scale bias defaults1/1 (91EB75/91EBF0).
        // System c0 and bc are explicitly LOCAL unit inputs: their dynamic R
        // producers are not supplied. Native scalar angle starts0 (91C0C0);
        // it is separate from the missile's pose direction, retained in sample.
        // Scale600 is HALF-size, never width600. No pitch is inferred.
        let local_system_c0 = 1.; let local_system_bc = 1.;
        let inputs = crate::projected_inputs::ProjectionInputs::new(position,
            self.particle_scale, 1., local_system_c0, local_system_bc, Vec2::ONE, 0.).ok()?;
        TerrainProjection::new(inputs.position.xz(), inputs.half_size, inputs.angle)?
            .with_native_height(sample.y_native, self.range, self.fading)
    }
}

#[derive(Resource)]
struct Profile { authored: Authored, texture: Handle<Image>, color: Handle<Image>, overlay: Handle<Image> }
fn setup(mut commands: Commands, assets: Res<AssetServer>) {
    match Authored::load() {
        Ok(authored) => { commands.insert_resource(Profile { authored,
            texture: crate::terrain_material::projected_image(&assets, TEXTURE.into()),
            color: crate::terrain_material::projected_image(&assets, COLOR.into()),
            overlay: assets.load("maps/terrain_native/DefaultFogOfWarOverlay.png") }); }
        Err(error) => warn!("R Projected disabled: {error}"),
    }
}
#[derive(Component)]
struct Owned;
struct Draw {
    entity: Entity, mesh: Handle<Mesh>, material: Handle<StrictMaterial>,
    geometry: (u64, Vec<Entity>), source: SourceKey, sample: CurrentR3d,
    input_revision: u64,
}
#[derive(Resource, Default)]
struct Live { rows: BTreeMap<Key, Draw>, revision: u64, exhausted: bool, last_error: Option<&'static str> }
impl Live {
    fn next_revision(&mut self) -> Option<u64> {
        let Some(next) = self.revision.checked_add(1) else { self.exhausted = true; return None; };
        self.revision = next; Some(next)
    }
}
#[derive(Clone)]
struct Frame { frontier: Frontier, visibility: Handle<Image>, params: Vec4, edge: Vec4 }
fn material(profile: &Profile, frame: &Frame, projection: TerrainProjection) -> Option<StrictMaterial> {
    let height = projection.native_height?;
    let result = StrictMaterial::new(ProjectedMaterial {
        texture: profile.texture.clone(), color_texture: profile.color.clone(),
        // Restored color-hold DDS is uniformly RGBA255 (8x8). A central lookup
        // consumes that resource without inventing a particle life coordinate.
        color_lookup: Vec4::new(0.5, 0.5, 1., 0.),
        visibility_map: frame.visibility.clone(), visibility_overlay: profile.overlay.clone(),
        visibility_params: frame.params, visibility_edge: frame.edge, visibility_ready: 1,
        world_to_projection: projection.world_to_uv,
        projection_height: Vec4::new(height.x, height.y, height.z, 1.),
    });
    result.source_key()?; Some(result)
}
fn release(draw: Draw, commands: &mut Commands, meshes: &mut Assets<Mesh>, materials: &mut Assets<StrictMaterial>) {
    commands.entity(draw.entity).try_despawn();
    meshes.remove(draw.mesh.id()); materials.remove(draw.material.id());
}
fn clear(live: &mut Live, current: &mut Current, commands: &mut Commands,
    meshes: &mut Assets<Mesh>, materials: &mut Assets<StrictMaterial>) {
    current.invalidate();
    for (_, draw) in std::mem::take(&mut live.rows) { release(draw, commands, meshes, materials); }
}
type OwnedQuery<'w, 's> = Query<'w, 's,
    (&'static Mesh3d, &'static MeshMaterial3d<StrictMaterial>, &'static Transform, Has<NoAutomaticBatching>), With<Owned>>;

/// Host tests use actual ECS entities, the native receiver tree and an explicit
/// triangle fixture. They do not fabricate restored-mesh or GPU observations.
fn synchronize(commands: &mut Commands, live: &mut Live, current: &mut Current,
    meshes: &mut Assets<Mesh>, materials: &mut Assets<StrictMaterial>,
    surfaces: &TerrainSurfaces, profile: &Profile, frame: &Frame,
    samples: &[CurrentR3d], owned: &OwnedQuery) -> Result<(), &'static str> {
    if live.exhausted || samples.len() > MAX_R { return Err("R Projected capacity exhausted"); }
    let mut seen = BTreeSet::new();
    let mut prepared = Vec::with_capacity(samples.len());
    for &sample in samples {
        if sample.key.session != frame.frontier.source.session || sample.key.team > 1
            || sample.incarnation == 0 || !seen.insert(sample.key) {
            return Err("invalid or duplicate R Projected identity");
        }
        let projection = profile.authored.projection(&sample).ok_or("invalid R XYZ projection")?;
        let source = material(profile, frame, projection).ok_or("invalid R projected material")?;
        let source_key = source.source_key().ok_or("invalid R material source key")?;
        prepared.push((sample, projection, source, source_key));
    }
    let retired: Vec<_> = live.rows.keys().filter(|key| !seen.contains(key)).copied().collect();
    for key in retired { release(live.rows.remove(&key).unwrap(), commands, meshes, materials); }
    let mut requests = Vec::with_capacity(prepared.len());
    for (sample, projection, source, source_key) in prepared {
        let geometry = surfaces.geometry_key(projection);
        let reusable = live.rows.get(&sample.key).is_some_and(|draw| {
            draw.sample.incarnation == sample.incarnation && draw.geometry == geometry
                && meshes.contains(draw.mesh.id()) && materials.contains(draw.material.id())
                && owned.get(draw.entity).is_ok_and(|(mesh, material, transform, no_batch)|
                    mesh.0.id() == draw.mesh.id() && material.0.id() == draw.material.id()
                        && *transform == Transform::IDENTITY && no_batch)
        });
        if !reusable {
            if let Some(draw) = live.rows.remove(&sample.key) { release(draw, commands, meshes, materials); }
            // Empty or unavailable restored receivers never become a synthetic plane.
            let Some(mesh) = surfaces.projected_mesh(projection) else { continue; };
            let revision = live.next_revision().ok_or("R input revision exhausted")?;
            let mesh = meshes.add(mesh); let material = materials.add(source);
            let entity = commands.spawn((Owned, Mesh3d(mesh.clone()), MeshMaterial3d(material.clone()),
                Transform::IDENTITY, GlobalTransform::IDENTITY, Visibility::Inherited,
                NoAutomaticBatching, bevy::light::NotShadowCaster, bevy::light::NotShadowReceiver)).id();
            live.rows.insert(sample.key, Draw { entity, mesh, material, geometry,
                source: source_key, sample, input_revision: revision });
        } else {
            let changed = live.rows.get(&sample.key).is_some_and(|draw|
                draw.sample != sample || draw.source != source_key);
            if changed {
                let revision = live.next_revision().ok_or("R input revision exhausted")?;
                let draw = live.rows.get_mut(&sample.key).unwrap();
                if draw.source != source_key {
                    *materials.get_mut(draw.material.id()).ok_or("R material removed during sync")? = source;
                }
                draw.sample = sample; draw.source = source_key; draw.input_revision = revision;
            }
        }
        let draw = &live.rows[&sample.key];
        requests.push(Request { entity: draw.entity, material: draw.material.clone(),
            pool_incarnation: sample.incarnation, input_revision: draw.input_revision });
    }
    // Frozen sample tick/frame during pause remain unchanged in Draw.sample.
    // Authorization always uses the current accepted epoch and current FoW source.
    current.replace(frame.frontier.clone(), requests)
}

fn update(mut commands: Commands,
    inputs: (Res<crate::native_effect_clock::EffectClock>, Res<crate::Match>, Res<crate::Connection>,
        Res<TerrainSurfaces>, Res<crate::fow_champion_sources::Sources>,
        Res<crate::map10_vision_view::Map10VisionView>, Res<crate::fow_visibility_texture::VisibilityTexture>,
        Res<crate::fow_gpu::Images>),
    profile: Option<Res<Profile>>, images: Res<Assets<Image>>,
    mut meshes: ResMut<Assets<Mesh>>, mut materials: ResMut<Assets<StrictMaterial>>,
    mut live: ResMut<Live>, mut current: ResMut<Current>,
    cameras: Query<(Entity, &Camera), With<Camera3d>>, owned: OwnedQuery) {
    let (clock, state, connection, surfaces, sources, map, texture, gpu) = inputs;
    let result = (|| {
        let profile = profile.as_deref().ok_or("R Projected profile unavailable")?;
        let (session, viewer, Some(epoch)) = connection.inventory_input_identity()
            .ok_or("R current session unavailable")? else { return Err("R requires atomic OLSR delivery"); };
        if !clock.presentation_ready() || !clock.now.is_finite() { return Err("R presentation clock unavailable"); }
        let snapshot = state.snapshot.as_ref().ok_or("R snapshot absent")?;
        if snapshot.session != session || snapshot.winner.is_some() { return Err("R session ended or changed"); }
        let team = snapshot.roster.iter().find(|row| row.id == viewer).ok_or("R viewer absent")?.team;
        let mut active = cameras.iter().filter(|(_, camera)| camera.is_active);
        let (camera, _) = active.next().ok_or("R camera absent")?;
        if active.next().is_some() { return Err("R camera ambiguous"); }
        let source = sources.mask_stamp(&map, session, team).ok_or("R FoW source unavailable")?;
        if source.represented_tick != snapshot.tick { return Err("R FoW source tick stale"); }
        let publication = texture.publication_for(&sources, &map, session, team)
            .ok_or("R FoW publication unavailable")?;
        if !publication.source.same_episode(&source) { return Err("R FoW episode changed"); }
        let uniforms = texture.settings.shader_parameters(map.geometry.extent)
            .map_err(|_| "R FoW uniforms unavailable")?;
        for handle in [&profile.texture, &profile.color, &profile.overlay, &gpu.output] {
            if !images.contains(handle.id()) { return Err("R texture unavailable"); }
        }
        let native = Vec4::from_array(uniforms.coordinates);
        let frame = Frame { frontier: Frontier { source, accepted_epoch: epoch, camera },
            visibility: gpu.output.clone(), params: Vec4::new(native.x * 20., native.y * 20., native.z, native.w),
            edge: Vec4::from_array(uniforms.edge) };
        let samples = state.ezreal_passive_hud.r_samples_3d(snapshot, viewer, session,
            Some(epoch), clock.now, true);
        synchronize(&mut commands, &mut live, &mut current, &mut meshes, &mut materials,
            &surfaces, profile, &frame, &samples, &owned)
    })();
    if let Err(error) = result {
        clear(&mut live, &mut current, &mut commands, &mut meshes, &mut materials);
        if live.last_error != Some(error) { debug!("R Projected waiting: {error}"); live.last_error = Some(error); }
    } else { live.last_error = None; }
}
pub(crate) struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self, app: &mut App) {
        app.init_resource::<Live>().add_systems(Startup, setup)
            .add_systems(PostUpdate, update.after(crate::projected_terrain::collect)
                .after(bevy::asset::AssetEventSystems)
                .before(bevy::camera::visibility::VisibilitySystems::CalculateBounds)
                .before(bevy::camera::visibility::VisibilitySystems::VisibilityPropagate));
    }
}

#[cfg(test)]
#[path = "ezreal_r_projected_live_tests.rs"]
mod tests;
