//! Partial base missile1 presentation only. No target, flight integration, collision,
//! impact, audio, magicdust, Pulse/Cyber, or native rendering parity is implemented.
//! Every anchor comes from the already accepted, audience-filtered Q projection.
use bevy::prelude::*;
use bevy::{mesh::MeshVertexBufferLayoutRef, pbr::{MaterialPipeline, MaterialPipelineKey},
    reflect::TypePath, render::render_resource::{AsBindGroup, BlendComponent, BlendFactor,
    BlendOperation, BlendState, RenderPipelineDescriptor, SpecializedMeshPipelineError},
    shader::ShaderRef};
use bevy::render::view::screenshot::{save_to_disk, Screenshot};
use openleague_core::Snapshot;
use std::{collections::{BTreeMap, BTreeSet}, sync::OnceLock};

// Local safety policies, not recovered native constants.
const MAX_FACTS: usize = openleague_core::ezreal_q::MAX_CASTS * MAX_FLIGHT_TICKS as usize;
const STALE_SECONDS: f64 = 0.2;
const MAX_FLIGHT_TICKS: u64 = 19;
const SLOTS: usize = 7; // ceil(60 * .05 * max life multiplier2) + one.
const ATLAS_PATH: &str = "particles/ezreal_q_base/mysticshot_mis.png";
const RAMP_PATH: &str = "particles/ezreal_q_base/color-hold.png";

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct Key { session: u64, owner: u32, ordinal: u64, viewer_team: u8 }
#[derive(Clone, Debug)]
struct Record {
    key: Key, incarnation: u64, caster_team: u8, launched: u64, direction: [f32; 2],
    anchor: Vec3, tick: u64, receipt: f64, age_at_receipt: f64,
}
#[derive(Clone, Debug)]
struct Facts { caster_team: u8, launched: u64, direction: [f32; 2] }
#[derive(Clone, Debug, Default)]
pub(crate) struct State {
    session: Option<u64>, epoch: Option<u64>, viewer: Option<(u32, u8)>,
    last_tick: Option<u64>, last_now: Option<f64>, ended: bool,
    generation: u64, next_incarnation: u64, known: BTreeMap<Key, Facts>, records: BTreeMap<Key, Record>,
}
impl State {
    pub(crate) fn reset(&mut self, session: u64) {
        let generation = self.generation.wrapping_add(1);
        *self = Self { session: Some(session), generation, ..Self::default() };
    }
    pub(crate) fn begin_epoch(&mut self, session: u64, epoch: u64) {
        if epoch == 0 || (self.session == Some(session) && self.epoch.is_some_and(|old| epoch <= old)) { return; }
        if self.session != Some(session) || self.epoch != Some(epoch) {
            self.reset(session); self.epoch = Some(epoch);
        }
    }
    fn retire(&mut self, key: Key) { self.records.remove(&key); }
    fn retire_all(&mut self) { self.records.clear(); }
    // Optional presentation never rejects or modifies an accepted gameplay packet.
    pub(crate) fn observe_accepted(&mut self, s: &Snapshot, viewer: u32,
        now: f64, clock_ready: bool, paused: bool) -> Result<(), &'static str> {
        if self.session.is_none() { self.reset(s.session); }
        if self.session != Some(s.session) { return Err("Q presentation session mismatch"); }
        if self.last_tick.is_some_and(|t| s.tick < t) { return Err("Q presentation tick regressed"); }
        let mut next = self.clone();
        match next.observe(s, viewer, now, clock_ready, paused) {
            Ok(()) => { *self = next; Ok(()) }
            Err(error) => {
                // This optional packet cannot leave stale visuals. A subsequent
                // valid current projection may restore only its current pose.
                self.retire_all();
                Err(error)
            }
        }
    }
    fn observe(&mut self, s: &Snapshot, viewer: u32, now: f64,
        clock_ready: bool, paused: bool) -> Result<(), &'static str> {
        if s.roster.len() > 256 || s.players.len() > 256 { return Err("Q presentation actor budget"); }
        if s.ezreal_q_projectiles.len() > openleague_core::ezreal_q::MAX_CASTS {
            return Err("Q presentation flight budget");
        }
        let viewers: Vec<_> = s.roster.iter().filter(|p| p.id == viewer).collect();
        if viewers.len() != 1 || viewer == 0 || viewers[0].team > 1 { return Err("Q presentation needs one observing roster identity"); }
        let context = (viewer, viewers[0].team);
        if self.viewer != Some(context) {
            self.retire_all(); self.known.clear(); self.viewer = Some(context);
            self.generation = self.generation.wrapping_add(1);
        }
        let healthy = clock_ready && now.is_finite() && now >= 0.
            && self.last_now.is_none_or(|before| now >= before);
        self.ended |= s.winner.is_some();
        let mut ids = BTreeSet::new();
        let mut valid = Vec::new();
        for m in &s.ezreal_q_projectiles {
            let key = Key { session: m.session, owner: m.owner, ordinal: m.ordinal, viewer_team: context.1 };
            let direction = [m.direction.x, m.direction.z];
            let length = direction[0].hypot(direction[1]);
            if m.session != s.session || m.ordinal == 0 || !ids.insert(key)
                || !m.position.finite() || !m.direction.finite() || !length.is_finite()
                || (length - 1.).abs() > 0.001 || m.launched > s.tick
                || s.tick.saturating_sub(m.launched) >= MAX_FLIGHT_TICKS {
                return Err("invalid Q projection identity/geometry/window");
            }
            let owners: Vec<_> = s.players.iter().filter(|p| p.id == m.owner).collect();
            let roster: Vec<_> = s.roster.iter().filter(|p| p.id == m.owner).collect();
            // Source visibility is required too. A released flight may outlive
            // owner health; the authoritative Core expressly permits this.
            if owners.len() != 1 || roster.len() != 1 { continue; }
            let p = owners[0]; let r = roster[0];
            if !p.champion.eq_ignore_ascii_case("ezreal") || !r.champion.eq_ignore_ascii_case("ezreal")
                || p.team != m.team || r.team != m.team || !p.height.is_finite() { continue; }
            let anchor = Vec3::new(m.position.x, p.height + 100., m.position.z) / 20.;
            if !anchor.is_finite() { return Err("invalid Q presentation height"); }
            valid.push((key, m, anchor));
        }
        valid.sort_by_key(|v| v.0);
        self.known.retain(|_, f| s.tick.saturating_sub(f.launched) < MAX_FLIGHT_TICKS);
        let current: BTreeSet<_> = valid.iter().map(|v| v.0).collect();
        self.records.retain(|key, _| current.contains(key));
        for (key, m, anchor) in valid {
            if let Some(f) = self.known.get(&key) {
                if f.caster_team != m.team || f.launched != m.launched
                    || f.direction.map(f32::to_bits) != [m.direction.x.to_bits(), m.direction.z.to_bits()] {
                    return Err("Q immutable identity changed");
                }
            } else {
                if self.known.len() == MAX_FACTS { return Err("Q presentation fact history budget"); }
                self.known.insert(key, Facts { caster_team: m.team, launched: m.launched,
                    direction: [m.direction.x, m.direction.z] });
            }
            if let Some(old) = self.records.get_mut(&key) {
                if old.caster_team != m.team || old.launched != m.launched
                    || old.direction.map(f32::to_bits) != [m.direction.x.to_bits(), m.direction.z.to_bits()]
                    || (old.tick == s.tick && old.anchor != anchor && !paused) {
                    return Err("Q immutable identity changed");
                }
                if !healthy { continue; }
                // Pause can still consume absence/end, but network tick changes
                // cannot move a held anchor or refresh its EffectClock lifetime.
                if !paused && s.tick > old.tick {
                    old.age_at_receipt = (s.tick.saturating_sub(m.launched) as f64 / openleague_core::TICK_RATE as f64)
                        .max(old.age_at_receipt + now - old.receipt);
                    old.anchor = anchor; old.tick = s.tick; old.receipt = now;
                }
                continue;
            }
            // A persistent flight is not a transient cast event. A first, revealed
            // or recovered *current* projection may show its current point/age.
            // No past movement, emission or impact is reconstructed from it.
            if !healthy || self.ended { continue; }
            // Distinct from the native flight key. An absence/error then reveal
            // within one receive batch must not preserve an old rendered pool.
            let incarnation = self.next_incarnation.checked_add(1).ok_or("Q presentation incarnation exhausted")?;
            self.next_incarnation = incarnation;
            self.records.insert(key, Record { key, incarnation, caster_team: m.team, launched: m.launched,
                direction: [m.direction.x, m.direction.z], anchor, tick: s.tick, receipt: now,
                age_at_receipt: s.tick.saturating_sub(m.launched) as f64 / openleague_core::TICK_RATE as f64 });
        }
        if !healthy || self.ended { self.retire_all(); }
        self.last_tick = Some(s.tick);
        self.last_now = if healthy { Some(now) } else { None };
        Ok(())
    }
    fn frame(&mut self, s: Option<&Snapshot>, now: f64, clock_ready: bool) {
        if self.ended || !clock_ready || !now.is_finite() || now < 0.
            || self.last_now.is_some_and(|before| now < before)
            || s.is_none_or(|s| Some(s.session) != self.session || s.winner.is_some()) {
            self.retire_all(); return;
        }
        self.records.retain(|_, r| now >= r.receipt && now - r.receipt < STALE_SECONDS);
        self.last_now = Some(now);
    }
}

#[derive(Clone, Copy)]
struct Profile { rate: f64, life: f64, scale: Vec2 }
fn profile() -> Option<Profile> {
    static VALUE: OnceLock<Option<Profile>> = OnceLock::new();
    *VALUE.get_or_init(|| {
        let j: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/ezreal_q_base_missile1.json")).ok()?;
        let g = &j["native_section"];
        // Exact bounded base profile. Unsupported edits disable the presentation.
        if g["KeywordsExcluded"] != "CyberEzreal" || g["p-texture"] != "mysticshot_mis.tga"
            || g["p-rgba"] != "color-hold.tga" || g["p-texdiv"] != serde_json::json!([3., 3.])
            || g["p-numframes"] != 9 || g["p-randomstartframe"] != 1
            || g["p-type"] != 1 || g["rendermode"] != 0 || g["e-rate"] != 60
            || g["p-scale"] != serde_json::json!([100., 400., 100.])
            || g["p-lifeP1"] != serde_json::json!([0., 1.]) || g["p-lifeP2"] != serde_json::json!([1., 2.])
            || g["p-scaleXP1"] != serde_json::json!([0., 1.]) || g["p-scaleXP2"] != serde_json::json!([1., 1.1]) {
            return None;
        }
        let life = g["p-life"].as_f64()?;
        if !life.is_finite() || !(0.049..0.051).contains(&life) { return None; }
        Some(Profile { rate: 60., life, scale: Vec2::new(100., 400.) / 20. })
    })
}
// Reconstructed deterministic uniform RNG; native seed/distribution is unknown.
fn random(seed: u64, channel: u64) -> f32 {
    let mut x = seed.wrapping_add(channel.wrapping_mul(0x9e3779b97f4a7c15));
    x = (x ^ (x >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
    x = (x ^ (x >> 27)).wrapping_mul(0x94d049bb133111eb);
    ((x ^ (x >> 31)) >> 40) as f32 / 16777216.
}
#[derive(Clone)]
struct Particle { birth: f64, life: f64, anchor: Vec3, rotation: Quat, scale: Vec2, frame: u32, row: f32 }
impl Particle {
    fn born(r: &Record, now: f64, emission: u64, p: Profile) -> Self {
        let seed = r.key.session ^ r.key.ordinal.rotate_left(19) ^ ((r.key.owner as u64) << 32) ^ emission;
        let yaw = r.direction[0].atan2(r.direction[1]);
        Self { birth: now, life: p.life * (1. + f64::from(random(seed, 1))), anchor: r.anchor,
            // Reconstructed horizontal streak orientation, not native p-quadrot.
            rotation: Quat::from_rotation_y(yaw) * Quat::from_rotation_x(std::f32::consts::FRAC_PI_2),
            scale: p.scale * Vec2::new(1. + 0.1 * random(seed, 2), 1.),
            frame: (random(seed, 11) * 9.).floor() as u32, row: random(seed, 12) }
    }
    fn pose(&self, now: f64) -> Option<(Transform, Vec4)> {
        let age = now - self.birth;
        if !age.is_finite() || age < 0. || age >= self.life { return None; }
        Some((Transform::from_translation(self.anchor).with_rotation(self.rotation)
            .with_scale(Vec3::new(self.scale.x, self.scale.y, 1.)),
            Vec4::new(self.frame as f32, (age / self.life) as f32, self.row, 0.)))
    }
}
fn seed_current_slots(r: &Record, now: f64, emission: u64, p: Profile) -> Vec<Option<Particle>> {
    // Exactly one current sample even after a long historical gap. Other slots
    // start empty, never backfilled from old emissions or an earlier incarnation.
    (0..SLOTS).map(|index| (index == 0).then(|| Particle::born(r, now, emission, p))).collect()
}

#[derive(Asset, TypePath, AsBindGroup, Debug, Clone)]
pub(crate) struct QMaterial {
    #[uniform(0)] params: Vec4,
    #[texture(1)] #[sampler(2)] atlas: Handle<Image>,
    #[texture(3)] #[sampler(4)] ramp: Handle<Image>,
}
impl Material for QMaterial {
    fn fragment_shader() -> ShaderRef { "shaders/ezreal_q_base_missile1.wgsl".into() }
    fn alpha_mode(&self) -> AlphaMode { AlphaMode::Blend }
    fn specialize(_: &MaterialPipeline, d: &mut RenderPipelineDescriptor,
        _: &MeshVertexBufferLayoutRef, _: MaterialPipelineKey<Self>) -> Result<(), SpecializedMeshPipelineError> {
        // Explicit local additive policy. Native blend/precedence remains unknown.
        d.primitive.cull_mode = None;
        if let Some(fragment) = d.fragment.as_mut() {
            for target in fragment.targets.iter_mut().flatten() {
                target.blend = Some(BlendState { color: BlendComponent { src_factor: BlendFactor::SrcAlpha,
                    dst_factor: BlendFactor::One, operation: BlendOperation::Add }, alpha: BlendComponent::OVER });
            }
        }
        if let Some(z) = d.depth_stencil.as_mut() { z.depth_write_enabled = Some(false); }
        Ok(())
    }
}
#[derive(Component)]
pub(crate) struct QQuad;
struct Slot { entity: Entity, material: Handle<QMaterial>, particle: Option<Particle> }
struct Rendered { owner_entity: Entity, incarnation: u64, last_emission: u64, slots: Vec<Slot> }
#[derive(Resource, Default)]
pub(crate) struct Live {
    generation: u64, mesh: Option<Handle<Mesh>>, atlas: Option<Handle<Image>>, ramp: Option<Handle<Image>>,
    shots: BTreeMap<Key, Rendered>,
    // Opt-in diagnostic only, once per Live resource lifetime; never resets a flight.
    flight_capture_requested: bool,
}
fn release(commands: &mut Commands, materials: &mut Assets<QMaterial>, shot: Rendered) {
    for slot in shot.slots { commands.entity(slot.entity).despawn(); materials.remove(slot.material.id()); }
}
fn retire_old_incarnations(commands: &mut Commands, materials: &mut Assets<QMaterial>, live: &mut Live, channel: &State) {
    let retired: Vec<_> = live.shots.iter().filter_map(|(key, shot)| {
        (!channel.records.get(key).is_some_and(|record| record.incarnation == shot.incarnation)).then_some(*key)
    }).collect();
    for key in retired {
        if let Some(shot) = live.shots.remove(&key) { release(commands, materials, shot); }
    }
}
// AssetServer integration is optional presentation only. Loading never gates
// snapshot/network acceptance; recovery may show a still-current flight only.
pub(crate) fn update(mut commands: Commands, clock: Res<crate::native_effect_clock::EffectClock>,
    mut state: ResMut<crate::Match>, assets: Res<AssetServer>, images: Res<Assets<Image>>,
    mut meshes: ResMut<Assets<Mesh>>, mut materials: ResMut<Assets<QMaterial>>, mut live: ResMut<Live>,
    mut quads: Query<(&mut Transform, &mut Visibility), With<QQuad>>, owners: Query<(), Without<QQuad>>,
    cpu_visibility: Query<(&InheritedVisibility, &ViewVisibility), With<QQuad>>) {
    if live.mesh.is_none() {
        live.mesh = Some(meshes.add(Rectangle::new(1., 1.)));
        live.atlas = Some(crate::terrain_material::image(&assets, ATLAS_PATH.into(), false));
        live.ramp = Some(crate::terrain_material::image(&assets, RAMP_PATH.into(), false));
    }
    let now = clock.now;
    let crate::Match { snapshot, ezreal_q_projectile_visuals: channel, visuals, .. } = &mut *state;
    channel.frame(snapshot.as_ref(), now, clock.presentation_ready());
    let p = profile();
    let ready = p.is_some() && live.atlas.as_ref().and_then(|h| images.get(h))
            .is_some_and(|i| i.texture_descriptor.size.width == 384 && i.texture_descriptor.size.height == 384)
        && live.ramp.as_ref().and_then(|h| images.get(h))
            .is_some_and(|i| i.texture_descriptor.size.width == 8 && i.texture_descriptor.size.height == 8)
        && live.mesh.as_ref().is_some_and(|h| meshes.get(h).is_some());
    if live.generation != channel.generation {
        for (_, shot) in std::mem::take(&mut live.shots) { release(&mut commands, &mut materials, shot); }
        live.generation = channel.generation;
    }
    retire_old_incarnations(&mut commands, &mut materials, &mut live, channel);
    let gone: Vec<_> = live.shots.iter().filter_map(|(key, shot)| {
        let valid = ready && channel.records.contains_key(key) && visuals.get(&key.owner) == Some(&shot.owner_entity)
            && owners.get(shot.owner_entity).is_ok()
            && shot.slots.iter().all(|slot| quads.get(slot.entity).is_ok() && materials.get(&slot.material).is_some());
        (!valid).then_some(*key)
    }).collect();
    for key in gone {
        if let Some(shot) = live.shots.remove(&key) { release(&mut commands, &mut materials, shot); }
    }
    let Some(p) = p.filter(|_| ready) else { return; };
    let records: Vec<_> = channel.records.values().cloned().collect();
    for r in records {
        let Some(&owner_entity) = visuals.get(&r.key.owner).filter(|e| owners.get(**e).is_ok()) else {
            channel.retire(r.key); continue;
        };
        let emission = ((r.age_at_receipt + (now - r.receipt).max(0.)) * p.rate).floor() as u64;
        if !live.shots.contains_key(&r.key) {
            let mut slots = Vec::new();
            for particle in seed_current_slots(&r, now, emission, p) {
                let (pose, params) = particle.as_ref().and_then(|p| p.pose(now)).unwrap_or_default();
                let material = materials.add(QMaterial { params,
                    atlas: live.atlas.as_ref().unwrap().clone(), ramp: live.ramp.as_ref().unwrap().clone() });
                let entity = commands.spawn((Mesh3d(live.mesh.as_ref().unwrap().clone()), MeshMaterial3d(material.clone()),
                    pose, if particle.is_some() { Visibility::Inherited } else { Visibility::Hidden }, QQuad, bevy::light::NotShadowCaster,
                    bevy::light::NotShadowReceiver)).id();
                slots.push(Slot { entity, material, particle });
            }
            live.shots.insert(r.key, Rendered { owner_entity, incarnation: r.incarnation, last_emission: emission, slots });
        }
        let shot = live.shots.get_mut(&r.key).unwrap();
        if !clock.paused() && shot.last_emission != emission {
            // At most one current birth per render frame. Missed frames never
            // backfill a trail from a past or guessed projectile trajectory.
            shot.slots[emission as usize % SLOTS].particle = Some(Particle::born(&r, now, emission, p));
            shot.last_emission = emission;
        }
        for slot in &mut shot.slots {
            if let Ok((mut transform, mut visibility)) = quads.get_mut(slot.entity) {
                if let Some((pose, params)) = slot.particle.as_ref().and_then(|v| v.pose(now)) {
                    *transform = pose; *visibility = Visibility::Inherited;
                    if let Some(mut m) = materials.get_mut(&slot.material) { m.params = params; }
                } else { *visibility = Visibility::Hidden; slot.particle = None; }
            }
        }
    }
    // A screenshot request is diagnostic only. It never creates a flight,
    // adjusts time, pauses play or changes visibility/material/particle state.
    if !live.flight_capture_requested {
        if let Ok(path) = std::env::var("OPENLEAGUE_EZREAL_Q_FLIGHT_SCREENSHOT") {
            let minimum_ordinal = match std::env::var("OPENLEAGUE_EZREAL_Q_FLIGHT_SCREENSHOT_MIN_ORDINAL") {
                Err(std::env::VarError::NotPresent) => Some(1),
                Ok(value) if !value.is_empty() && value.bytes().all(|b| b.is_ascii_digit()) =>
                    value.parse::<u64>().ok().filter(|value| *value > 0),
                _ => None,
            };
            let minimum_flight_age = match std::env::var("OPENLEAGUE_EZREAL_Q_FLIGHT_SCREENSHOT_MIN_FLIGHT_AGE_SECONDS") {
                Err(std::env::VarError::NotPresent) => Some(0.),
                Ok(value) => value.parse::<f64>().ok().filter(|value| value.is_finite() && *value >= 0.),
                _ => None,
            };
            // Absent options preserve the original first-flight diagnostic.
            // Invalid options disable capture; they never silently select defaults.
            if let (Some(minimum_ordinal), Some(minimum_flight_age)) =
                (minimum_ordinal, minimum_flight_age.filter(|_| !path.trim().is_empty())) {
                let candidate = live.shots.iter().find_map(|(key, shot)| {
                    let record = channel.records.get(key)?;
                    // Same already-existing projection age used for emission.
                    // This gate never changes clock, record, birth or rendering.
                    let flight_age = record.age_at_receipt + (now - record.receipt).max(0.);
                    if key.ordinal < minimum_ordinal || !flight_age.is_finite()
                        || flight_age < minimum_flight_age { return None; }
                    let current = snapshot.as_ref()?;
                    if record.incarnation != shot.incarnation || current.session != key.session
                        || channel.last_tick != Some(current.tick)
                        || visuals.get(&key.owner) != Some(&shot.owner_entity)
                        || owners.get(shot.owner_entity).is_err() { return None; }
                    let material_ready = shot.slots.iter().filter(|slot| materials.get(&slot.material).is_some()).count();
                    let visible_quads = shot.slots.iter().filter(|slot| {
                        slot.particle.as_ref().is_some_and(|p| p.pose(now).is_some())
                            && quads.get(slot.entity).is_ok_and(|(_, visibility)| *visibility != Visibility::Hidden)
                            && cpu_visibility.get(slot.entity).is_ok_and(|(hierarchy, view)| hierarchy.get() && view.get())
                            && materials.get(&slot.material).is_some()
                    }).count();
                    // commands.spawn alone is insufficient: quads must exist in ECS
                    // with current particles/materials and last propagated CPU
                    // hierarchy/view visibility. PostUpdate has not run yet;
                    // these flags do not prove current-frame or GPU visibility.
                    (visible_quads > 0).then_some((*key, record.incarnation, record.tick,
                        current.tick, visible_quads, material_ready, flight_age))
                });
                if let Some((key, incarnation, record_tick, snapshot_tick, visible_quads, material_ready, flight_age)) = candidate {
                    commands.spawn(Screenshot::primary_window()).observe(save_to_disk(path.clone()));
                    live.flight_capture_requested = true;
                    println!("OpenLeague Ezreal Q flight probe: {}", serde_json::json!({
                        "event": "capture_requested", "session": key.session, "owner": key.owner,
                        "ordinal": key.ordinal, "viewer_team": key.viewer_team, "incarnation": incarnation,
                        "minimum_ordinal": minimum_ordinal, "flight_age_seconds": flight_age,
                        "minimum_flight_age_seconds": minimum_flight_age,
                        "record_tick": record_tick, "snapshot_tick": snapshot_tick, "effect_clock": now,
                        "paused": clock.paused(), "last_propagated_cpu_visible_quads": visible_quads,
                        "materials_cpu_ready": material_ready, "capture_path": path,
                        "pixels_observed": false, "GPU_ready_proven": false,
                        "current_frame_visibility_proven": false
                    }));
                }
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use openleague_core::{Action, Navigation, Point, Simulation, ezreal_q::VisibleMissile};
    fn game() -> (Simulation, u32) {
        let nav = Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),
            include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut g = Simulation::new(nav).unwrap(); g.session = 752;
        let id = g.join("ezreal").unwrap(); (g, id)
    }
    fn missile(s: &Snapshot, owner: u32, ordinal: u64) -> VisibleMissile {
        let p = s.players.iter().find(|p| p.id == owner).unwrap();
        VisibleMissile { session: s.session, owner, team: p.team, ordinal, position: p.position,
            direction: Point { x: 1., z: 0. }, launched: s.tick }
    }
    fn live() -> (State, Snapshot, u32) {
        let (g, id) = game(); let mut s = g.snapshot();
        let mut c = State::default(); c.observe_accepted(&s, id, 1., true, false).unwrap();
        s.tick += 1; s.ezreal_q_projectiles.push(missile(&s, id, (1u64 << 53) + 3));
        c.observe_accepted(&s, id, 1.01, true, false).unwrap(); (c, s, id)
    }
    #[test]
    fn exact_authoritative_anchors_full_u64_identity_duplicates_and_snapshots_are_preserved() {
        let (mut c, mut s, id) = live(); let before = serde_json::to_value(&s).unwrap();
        assert_eq!(c.records.len(), 1); let first = c.records.values().next().unwrap().clone();
        assert_eq!(first.key.ordinal, (1u64 << 53) + 3);
        assert_eq!(first.anchor.x, s.ezreal_q_projectiles[0].position.x / 20.);
        c.observe_accepted(&s, id, 1.1, true, false).unwrap();
        assert_eq!(c.records.values().next().unwrap().receipt, first.receipt);
        assert_eq!(serde_json::to_value(&s).unwrap(), before);
        c.frame(Some(&s), 1.22, true); assert!(c.records.is_empty());
        s.tick += 1;
        c.observe_accepted(&s, id, 1.23, true, false).unwrap(); assert_eq!(c.records.len(), 1);
    }
    #[test]
    fn accepted_pause_freezes_network_corrections_while_current_new_flights_have_only_a_held_point() {
        let (mut c, mut s, id) = live(); let old = c.records.values().next().unwrap().anchor;
        s.tick += 1; s.ezreal_q_projectiles[0].position.x += 66.;
        c.observe_accepted(&s, id, 1.01, true, true).unwrap();
        assert_eq!(c.records.values().next().unwrap().anchor, old);
        let old_key = *c.records.keys().next().unwrap();
        s.ezreal_q_projectiles.clear(); s.ezreal_q_projectiles.push(missile(&s, id, old_key.ordinal + 1));
        c.observe_accepted(&s, id, 1.01, true, true).unwrap(); assert_eq!(c.records.len(), 1);
        let r = c.records.values().next().unwrap(); let p = Particle::born(r, 1.01, 0, profile().unwrap());
        let held = p.pose(1.01); assert_eq!(p.pose(1.01), held);
        s.tick += 1; c.observe_accepted(&s, id, 1.02, true, false).unwrap(); assert_eq!(c.records.len(), 1);
    }
    #[test]
    fn fog_absence_departure_end_clock_failure_hide_immediately_and_current_reveal_has_no_history() {
        for mode in 0..5 {
            let (mut c, mut s, id) = live(); let before = s.clone();
            match mode {
                0 => { s.players.clear(); }, 1 => { s.ezreal_q_projectiles.clear(); },
                2 => { s.winner = Some(0); }, 3 => {}, _ => { s.roster.retain(|p| p.id != id); },
            }
            let _ = c.observe_accepted(&s, id, 1.02, mode != 3, false);
            assert!(c.records.is_empty());
            let mut reveal = before.clone(); reveal.tick += 1;
            c.observe_accepted(&reveal, id, 1.03, true, false).unwrap();
            if mode == 2 { assert!(c.records.is_empty()); continue; }
            assert_eq!(c.records.len(), 1);
            let current = c.records.values().next().unwrap();
            let particle = Particle::born(current, 1.03, 1, profile().unwrap());
            assert_eq!(particle.birth, 1.03); assert_eq!(particle.anchor, current.anchor);
        }
    }
    #[test]
    fn baseline_epoch_session_audience_and_repaired_current_projection_show_only_current_pose() {
        let (mut c, mut s, id) = live();
        c.begin_epoch(s.session, 9); c.observe_accepted(&s, id, 1.02, true, false).unwrap(); assert_eq!(c.records.len(), 1);
        s.tick += 1; s.ezreal_q_projectiles[0].ordinal += 1;
        c.observe_accepted(&s, id, 1.03, true, false).unwrap(); assert_eq!(c.records.len(), 1);
        s.roster.iter_mut().find(|p| p.id == id).unwrap().team ^= 1;
        c.observe_accepted(&s, id, 1.04, true, false).unwrap(); assert!(c.records.is_empty());
        s.roster.iter_mut().find(|p| p.id == id).unwrap().team ^= 1;
        c.observe_accepted(&s, id, 1.05, true, false).unwrap(); assert_eq!(c.records.len(), 1);
        s.session += 1; s.ezreal_q_projectiles[0].session = s.session;
        assert!(c.observe_accepted(&s, id, 1.06, true, false).is_err());
        c.reset(s.session);
        c.observe_accepted(&s, id, 1.06, true, false).unwrap(); assert_eq!(c.records.len(), 1);
        s.tick += 1; s.ezreal_q_projectiles[0].ordinal += 1; s.ezreal_q_projectiles[0].launched = s.tick;
        c.observe_accepted(&s, id, 1.07, true, false).unwrap(); assert_eq!(c.records.len(), 1);
        let clean = s.clone(); s.ezreal_q_projectiles[0].direction.x = -1.;
        assert!(c.observe_accepted(&s, id, 1.08, true, false).is_err()); assert!(c.records.is_empty());
        c.observe_accepted(&clean, id, 1.09, true, false).unwrap(); assert_eq!(c.records.len(), 1);
        let anchor = c.records.values().next().unwrap().anchor;
        let mut stale = clean.clone(); stale.tick -= 1;
        assert!(c.observe_accepted(&stale, id, 1.10, true, false).is_err());
        assert_eq!(c.records.values().next().unwrap().anchor, anchor);
        c.begin_epoch(clean.session, 12); c.observe_accepted(&clean, id, 1.11, true, false).unwrap();
        let generation = c.generation; c.begin_epoch(clean.session, 11); assert_eq!(c.generation, generation);
    }
    #[test]
    fn bounds_invalid_geometry_and_missing_resources_never_mutate_gameplay() {
        let (mut c, mut s, id) = live();
        c.retire_all(); s.tick += 1; c.observe_accepted(&s, id, 1.02, true, false).unwrap(); assert_eq!(c.records.len(), 1);
        s.ezreal_q_projectiles[0].ordinal += 1; s.ezreal_q_projectiles[0].position.x = f32::NAN;
        assert!(c.observe_accepted(&s, id, 1.03, true, false).is_err()); assert!(c.records.is_empty());
        s.ezreal_q_projectiles.clear(); s.tick += 1; c.observe_accepted(&s, id, 1.04, true, false).unwrap();
        let m = missile(&s, id, 9007199254741000); s.ezreal_q_projectiles = vec![m; openleague_core::ezreal_q::MAX_CASTS + 1];
        assert!(c.observe_accepted(&s, id, 1.05, true, false).is_err()); assert!(c.records.is_empty());
    }
    #[test]
    fn decoded_base_profile_native_ramp_paths_curves_and_effect_time_hold_are_explicit() {
        let p = profile().unwrap(); assert_eq!(p.rate, 60.); assert!((p.life - 0.05).abs() < 1e-7);
        let (c, _, _) = live(); let r = c.records.values().next().unwrap();
        let a = Particle::born(r, 2., 0, p); let b = Particle::born(r, 2., 0, p);
        assert!((0.05..0.101).contains(&a.life)); assert!((5.0..5.5).contains(&a.scale.x));
        assert_eq!(a.frame, b.frame); assert!(a.frame < 9); assert_eq!(a.pose(2.01), b.pose(2.01));
        assert_eq!(a.pose(2.01), a.pose(2.01)); assert!(a.pose(3.).is_none());
        assert!(ATLAS_PATH.starts_with("particles/ezreal_q_base/")); assert!(RAMP_PATH.starts_with("particles/ezreal_q_base/"));
    }
    #[test]
    fn released_core_q_projects_targetless_positions_until_actual_disappearance_without_damage_mutation() {
        let (mut game, id) = game(); let mut c = State::default();
        c.observe_accepted(&game.snapshot(), id, 0., true, false).unwrap();
        game.command(id, Action::Learn { slot: 0 }).unwrap();
        let p = game.players[&id].position;
        game.command(id, Action::CastAt { slot: 0, point: Point { x: p.x + 800., z: p.z } }).unwrap();
        let release = game.players[&id].effects.ezreal_q.as_ref().unwrap().releases;
        while game.tick < release { game.advance(); }
        let s = game.snapshot(); assert_eq!(s.ezreal_q_projectiles.len(), 1);
        let bytes = serde_json::to_value(&s).unwrap();
        c.observe_accepted(&s, id, 0.1, true, false).unwrap(); assert_eq!(c.records.len(), 1);
        assert_eq!(serde_json::to_value(&s).unwrap(), bytes);
        game.advance(); let s = game.snapshot();
        c.observe_accepted(&s, id, 0.13, true, false).unwrap();
        assert_eq!(c.records.values().next().unwrap().anchor.x, s.ezreal_q_projectiles[0].position.x / 20.);
        while !game.snapshot().ezreal_q_projectiles.is_empty() { game.advance(); }
        let ended = game.snapshot(); c.observe_accepted(&ended, id, 0.15, true, false).unwrap(); assert!(c.records.is_empty());
    }
    #[test]
    fn dead_owner_retains_authorized_released_flight_but_absent_owner_retires_immediately() {
        let (mut c, mut s, id) = live(); s.tick += 1;
        s.players.iter_mut().find(|p| p.id == id).unwrap().health = 0.;
        let before = serde_json::to_value(&s).unwrap();
        c.observe_accepted(&s, id, 1.02, true, false).unwrap();
        assert_eq!(c.records.len(), 1); assert_eq!(serde_json::to_value(&s).unwrap(), before);
        s.players.clear(); s.tick += 1;
        c.observe_accepted(&s, id, 1.03, true, false).unwrap(); assert!(c.records.is_empty());
    }
    #[test]
    fn late_resource_current_age_seeds_only_one_current_birth_and_never_old_positions() {
        let (mut c, mut s, id) = live();
        s.tick += 4; s.ezreal_q_projectiles[0].position.x += 250.;
        c.observe_accepted(&s, id, 1.1, true, false).unwrap();
        let r = c.records.values().next().unwrap();
        let emission = (r.age_at_receipt * profile().unwrap().rate).floor() as u64;
        assert!(emission >= 8);
        let particle = Particle::born(r, 1.11, emission, profile().unwrap());
        assert_eq!(particle.birth, 1.11);
        assert_eq!(particle.anchor.x, s.ezreal_q_projectiles[0].position.x / 20.);
        assert!(particle.pose(1.10).is_none());
        let mut hidden = s.clone(); hidden.tick += 1; hidden.ezreal_q_projectiles.clear();
        c.observe_accepted(&hidden, id, 1.12, true, false).unwrap(); assert!(c.records.is_empty());
    }
    #[test]
    fn ecs_pool_retirement_removes_owned_entities_materials_and_preserves_foreign_objects() {
        #[derive(Resource)] struct Pending(Option<Rendered>);
        fn retire(mut commands: Commands, mut materials: ResMut<Assets<QMaterial>>, mut pending: ResMut<Pending>) {
            if let Some(shot) = pending.0.take() { release(&mut commands, &mut materials, shot); }
        }
        let mut app = App::new(); app.init_resource::<Assets<QMaterial>>();
        let owner = app.world_mut().spawn_empty().id();
        let foreign = app.world_mut().spawn_empty().id();
        let foreign_material = app.world_mut().resource_mut::<Assets<QMaterial>>().add(QMaterial {
            params: Vec4::ZERO, atlas: Handle::default(), ramp: Handle::default() });
        let mut slots = Vec::new();
        for _ in 0..SLOTS {
            let material = app.world_mut().resource_mut::<Assets<QMaterial>>().add(QMaterial {
                params: Vec4::ZERO, atlas: Handle::default(), ramp: Handle::default() });
            let entity = app.world_mut().spawn((Transform::default(), Visibility::Inherited, QQuad)).id();
            slots.push(Slot { entity, material, particle: None });
        }
        let owned: Vec<_> = slots.iter().map(|s| (s.entity, s.material.clone())).collect();
        app.insert_resource(Pending(Some(Rendered { owner_entity: owner, incarnation: 0, last_emission: 0, slots })))
            .add_systems(Update, retire); app.update();
        for (e, m) in owned {
            assert!(app.world().get_entity(e).is_err());
            assert!(app.world().resource::<Assets<QMaterial>>().get(&m).is_none());
        }
        assert!(app.world().get_entity(owner).is_ok()); assert!(app.world().get_entity(foreign).is_ok());
        assert!(app.world().resource::<Assets<QMaterial>>().get(&foreign_material).is_some());
    }
    #[test]
    fn same_batch_absence_malformed_or_clock_gap_retires_populated_incarnation_before_current_reveal() {
        #[derive(Resource)] struct Channel(State);
        fn reconcile(mut commands: Commands, mut materials: ResMut<Assets<QMaterial>>, mut live: ResMut<Live>, channel: Res<Channel>) {
            retire_old_incarnations(&mut commands, &mut materials, &mut live, &channel.0);
        }
        for mode in 0..3 {
            let (mut channel, mut s, id) = live();
            let first = s.ezreal_q_projectiles[0].clone();
            let mut second = first.clone(); second.ordinal += 100; second.position.x += 200.;
            s.ezreal_q_projectiles.push(second); s.tick += 1;
            channel.observe_accepted(&s, id, 1.02, true, false).unwrap();
            let a = channel.records.values().find(|r| r.key.ordinal == first.ordinal).unwrap().clone();
            let b = channel.records.values().find(|r| r.key.ordinal != first.ordinal).unwrap().clone();
            // Healthy duplicate and continuous position updates retain their pool.
            channel.observe_accepted(&s, id, 1.02, true, false).unwrap();
            assert_eq!(channel.records[&a.key].incarnation, a.incarnation);
            s.tick += 1; s.ezreal_q_projectiles[0].position.x += 1.;
            channel.observe_accepted(&s, id, 1.02, true, false).unwrap();
            assert_eq!(channel.records[&a.key].incarnation, a.incarnation);
            let generation = channel.generation;
            let mut app = App::new(); app.init_resource::<Assets<QMaterial>>();
            let owner = app.world_mut().spawn_empty().id();
            let mut cache = Live::default(); cache.generation = generation;
            let mut pools = Vec::new();
            for record in [&a, &b] {
                let mut slots = Vec::new();
                for _ in 0..SLOTS {
                    let material = app.world_mut().resource_mut::<Assets<QMaterial>>().add(QMaterial {
                        params: Vec4::ZERO, atlas: Handle::default(), ramp: Handle::default() });
                    let entity = app.world_mut().spawn((Transform::from_translation(record.anchor), Visibility::Inherited, QQuad)).id();
                    slots.push(Slot { entity, material, particle: Some(Particle::born(record, 1.02, 0, profile().unwrap())) });
                }
                pools.push(slots.iter().map(|s| (s.entity, s.material.clone())).collect::<Vec<_>>());
                cache.shots.insert(record.key, Rendered { owner_entity: owner, incarnation: record.incarnation, last_emission: 0, slots });
            }
            let mut gap = s.clone();
            match mode {
                0 => gap.ezreal_q_projectiles.retain(|m| m.ordinal != a.key.ordinal),
                1 => gap.ezreal_q_projectiles[0].direction.x = f32::NAN,
                _ => {},
            }
            let result = channel.observe_accepted(&gap, id, 1.02, mode != 2, false);
            assert_eq!(result.is_err(), mode == 1);
            assert!(!channel.records.contains_key(&a.key));
            let mut reveal = s.clone(); reveal.tick += 1; reveal.ezreal_q_projectiles[0].position.x += 400.;
            channel.observe_accepted(&reveal, id, 1.02, true, false).unwrap();
            let current = channel.records[&a.key].clone();
            assert_ne!(current.incarnation, a.incarnation); assert_eq!(channel.generation, generation);
            if mode == 0 { assert_eq!(channel.records[&b.key].incarnation, b.incarnation); }
            app.insert_resource(cache).insert_resource(Channel(channel)).add_systems(Update, reconcile);
            app.update();
            assert!(!app.world().resource::<Live>().shots.contains_key(&a.key));
            for (entity, material) in &pools[0] {
                assert!(app.world().get_entity(*entity).is_err());
                assert!(app.world().resource::<Assets<QMaterial>>().get(material).is_none());
            }
            for (entity, material) in &pools[1] {
                assert_eq!(app.world().get_entity(*entity).is_ok(), mode == 0);
                assert_eq!(app.world().resource::<Assets<QMaterial>>().get(material).is_some(), mode == 0);
            }
            let seeded = seed_current_slots(&current, 1.02, 12, profile().unwrap());
            assert_eq!(seeded.iter().filter(|p| p.is_some()).count(), 1);
            let born = seeded[0].as_ref().unwrap();
            assert_eq!(born.birth, 1.02); assert_eq!(born.anchor, current.anchor); assert_ne!(born.anchor, a.anchor);
            assert!(app.world().get_entity(owner).is_ok());
        }
    }
}
