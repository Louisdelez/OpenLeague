//! Native Q Fire/Fire_Head consumer. Remaining groups and original runtime semantics are open.
use crate::{Match, terrain_material};
use bevy::prelude::*;
use bevy::{
    mesh::MeshVertexBufferLayoutRef,
    pbr::{MaterialPipeline, MaterialPipelineKey},
    reflect::TypePath,
    render::render_resource::{
        AsBindGroup, BlendComponent, BlendFactor, BlendOperation, BlendState,
        RenderPipelineDescriptor, SpecializedMeshPipelineError,
    },
    shader::ShaderRef,
};
use std::{collections::HashMap, sync::OnceLock};
#[derive(Asset, TypePath, AsBindGroup, Debug, Clone)]
pub struct QMaterial {
    #[uniform(0)]
    color: Vec4,
    #[uniform(1)]
    uv_scroll: Vec4,
    #[texture(2)]
    #[sampler(3)]
    texture: Handle<Image>,
    #[uniform(4)]
    atlas: Vec4,
    #[uniform(5)]
    lookup: Vec4,
    #[texture(6)]
    #[sampler(7)]
    color_texture: Option<Handle<Image>>,
}
impl QMaterial {
    fn new(
        texture: Handle<Image>,
        color_texture: Option<Handle<Image>>,
        g: &serde_json::Value,
    ) -> Self {
        Self {
            color: Vec4::ONE,
            uv_scroll: Vec4::ZERO,
            texture,
            atlas: Vec4::new(
                vector2(g, "p-texdiv").x.max(1.),
                vector2(g, "p-texdiv").y.max(1.),
                0.,
                scalar(g, "p-uvscroll-no-alpha", 0.),
            ),
            lookup: Vec4::new(
                0.,
                0.5,
                if color_texture.is_some() { 1. } else { 0. },
                scalar(g, "rendermode", 0.),
            ),
            color_texture,
        }
    }
    fn set(&mut self, color: Vec4, uv: Vec2) {
        self.color = color;
        self.uv_scroll = Vec4::new(uv.x, uv.y, 0., 0.);
    }
}
impl Material for QMaterial {
    fn fragment_shader() -> ShaderRef {
        "shaders/annie_q_particles.wgsl".into()
    }
    fn alpha_mode(&self) -> AlphaMode {
        AlphaMode::Blend
    }
    fn specialize(
        _: &MaterialPipeline,
        d: &mut RenderPipelineDescriptor,
        _: &MeshVertexBufferLayoutRef,
        _: MaterialPipelineKey<Self>,
    ) -> Result<(), SpecializedMeshPipelineError> {
        d.primitive.cull_mode = None; // Community particle quad renderer disables backface culling.
        if let Some(f) = d.fragment.as_mut() {
            for t in f.targets.iter_mut().flatten() {
                t.blend = Some(BlendState {
                    color: BlendComponent {
                        src_factor: BlendFactor::SrcAlpha,
                        dst_factor: BlendFactor::One,
                        operation: BlendOperation::Add,
                    },
                    alpha: BlendComponent::OVER,
                });
            }
        }
        if let Some(z) = d.depth_stencil.as_mut() {
            z.depth_write_enabled = Some(false);
        }
        Ok(())
    }
}
type Key = (u32, u32, u64);
fn data() -> &'static serde_json::Value {
    static D: OnceLock<serde_json::Value> = OnceLock::new();
    D.get_or_init(|| {
        serde_json::from_str(include_str!(
            "../../../data/4.20/particles/annie/Annie_Q_mis.json"
        ))
        .unwrap()
    })
}
fn group(name: &str) -> &'static serde_json::Value {
    &data()["sections"][name]
}
fn scalar(g: &serde_json::Value, k: &str, fallback: f32) -> f32 {
    g[k].as_f64().map(|v| v as f32).unwrap_or(fallback)
}
fn vector(g: &serde_json::Value, k: &str, fallback: Vec3) -> Vec3 {
    g[k].as_array()
        .map(|a| {
            Vec3::new(
                a[0].as_f64().unwrap() as f32,
                a[1].as_f64().unwrap() as f32,
                a[2].as_f64().unwrap() as f32,
            )
        })
        .unwrap_or(fallback)
}
fn curve(g: &serde_json::Value, prefix: &str, x: f32, channel: usize, fallback: f32) -> f32 {
    let mut keys: Vec<(f32, f32)> = (1..=16)
        .filter_map(|i| {
            let a = g[format!("{prefix}{i}")].as_array()?;
            Some((a[0].as_f64()? as f32, a.get(channel)?.as_f64()? as f32))
        })
        .collect();
    keys.sort_by(|a, b| a.0.total_cmp(&b.0));
    if keys.is_empty() {
        return fallback;
    }
    if x <= keys[0].0 {
        return keys[0].1;
    }
    for w in keys.windows(2) {
        if x <= w[1].0 {
            return w[0].1 + (w[1].1 - w[0].1) * (x - w[0].0) / (w[1].0 - w[0].0);
        }
    }
    keys.last().unwrap().1
}
// Reproducible reconstruction; native RNG/distribution and integration not qualified.
fn random(seed: u64, channel: u64) -> f32 {
    let mut x = seed.wrapping_add(channel.wrapping_mul(0x9e3779b97f4a7c15));
    x = (x ^ (x >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
    x = (x ^ (x >> 27)).wrapping_mul(0x94d049bb133111eb);
    ((x ^ (x >> 31)) >> 40) as f32 / 16777216.
}
fn probability(g: &serde_json::Value, name: &str, seed: u64, channel: u64) -> f32 {
    curve(g, &format!("{name}P"), random(seed, channel), 1, 1.)
}
fn keys(last: u64, capacity: usize) -> std::ops::RangeInclusive<u64> {
    last.saturating_sub(capacity as u64)..=last
}
#[derive(Component)]
pub struct QQuad;
struct Particle {
    birth: f64,
    life: f32,
    position: Vec3,
    velocity: Vec3,
    rotation: Quat,
    scale: Vec3,
    seed: u64,
    frame: u32,
}
struct Pool {
    name: &'static str,
    slots: Vec<(Entity, Handle<QMaterial>, Option<Particle>)>,
    last: Option<u64>,
}
// Disintegrate native profile: speed/min/max1400, height100, zero gravity/acceleration.
// Bone transform, target lifetime, collisions and server end signal remain separate boundaries.
fn native_flight_step(moving:[f32;3],fallback:[f32;3],target:Option<[f32;3]>,dt:f32)
    -> Result<openleague_core::native_missile_motion::Motion, &'static str> {
    let mut motion=openleague_core::native_missile_motion::unobstructed1400(moving,fallback,target,dt)?;
    motion.moving_position=openleague_core::native_missile_position_sync::synchronize(motion.moving_position,0.,target.is_some())?;
    Ok(motion)
}
struct Shot {
    started: f64,
    previous: Vec3,
    moving_native: [f32; 3],
    direction_native: [f32; 3],
    target_native: [f32; 3],
    last_update: f64,
    pools: Vec<Pool>,
    ended: Option<f64>,
}
pub(crate) type ProjectionOwner = (Key,f64,Vec3,Vec3,bool);
#[derive(Clone)]
pub(crate) struct ProjectionFrame { pub time:f64, pub owners:Vec<ProjectionOwner> }
#[derive(Resource, Default)]
pub struct Flights {
    session: Option<u64>,
    shots: HashMap<Key, Shot>,
    mesh: Option<Handle<Mesh>>,
    texture: Option<Handle<Image>>,
    reported: bool,
    seen: usize,
    startup_probe_tick: Option<u64>,
    observed_events: Vec<openleague_core::missile_lifecycle::Event>,
    observed_contexts: Vec<openleague_core::Snapshot>,
    pub(crate) projection_frames: Vec<ProjectionFrame>,
    max_quads: usize,
    max_visible: usize,
    captured: bool,
}
impl Flights {
    pub(crate) fn projection_owners(&self)->Vec<((u32,u32,u64),f64,Vec3,Vec3,bool)> {
        self.shots.iter().map(|(key,shot)|(*key,shot.started,Vec3::from_array(shot.moving_native),Vec3::from_array(shot.direction_native),shot.ended.is_some())).collect()
    }
}
fn life(g: &serde_json::Value, seed: u64) -> f32 {
    scalar(g, "p-life", 0.) * probability(g, "p-life", seed, 1)
}
fn capacity(g: &serde_json::Value) -> usize {
    let max = (1..=16)
        .filter_map(|i| g[format!("p-lifeP{i}")][1].as_f64())
        .fold(1., f64::max) as f32;
    (scalar(g, "e-rate", 0.) * scalar(g, "p-life", 0.) * max).ceil() as usize + 1
}
fn born(g: &serde_json::Value, index: u64, key: Key, birth: f64, position: Vec3) -> Particle {
    let seed = index ^ ((key.0 as u64) << 32) ^ key.2;
    let base = vector(g, "p-scale", Vec3::ONE);
    let scale = Vec3::new(
        base.x * curve(g, "p-scaleXP", random(seed, 2), 1, 1.),
        base.y * curve(g, "p-scaleYP", random(seed, 3), 1, 1.),
        1.,
    );
    let q = vector(g, "p-quadrot", Vec3::ZERO);
    let q = Vec3::new(
        q.x,
        q.y * curve(g, "p-quadrotYP", random(seed, 4), 1, 1.),
        q.z,
    ) * std::f32::consts::PI
        / 180.;
    Particle {
        birth,
        life: life(g, seed),
        position: position
            + vector(g, "p-offset", Vec3::ZERO)
                * Vec3::new(
                    probability(g, "p-offsetX", seed, 5),
                    probability(g, "p-offsetY", seed, 6),
                    probability(g, "p-offsetZ", seed, 7),
                )
                / 20.,
        velocity: vector(g, "p-vel", Vec3::ZERO)
            * Vec3::new(
                probability(g, "p-velX", seed, 8),
                probability(g, "p-velY", seed, 9),
                probability(g, "p-velZ", seed, 10),
            )
            / 20.,
        rotation: Quat::from_euler(EulerRot::XYZ, q.x, q.y, q.z),
        scale: scale / 20.,
        seed,
        frame: if scalar(g, "p-randomstartframe", 0.) > 0. {
            (random(seed, 11) * vector2(g, "p-texdiv").element_product()).floor() as u32
        } else {
            scalar(g, "p-startframe", 0.) as u32
        },
    }
}
fn pose(
    g: &serde_json::Value,
    p: &Particle,
    now: f64,
    current: Vec3,
) -> Option<(Transform, Vec4, Vec2)> {
    let t = (now - p.birth) as f32;
    if t < 0. || t >= p.life {
        return None;
    }
    let u = t / p.life;
    let rgba = Vec4::new(
        curve(g, "p-xrgba", u, 1, 1.),
        curve(g, "p-xrgba", u, 2, 1.),
        curve(g, "p-xrgba", u, 3, 1.),
        curve(g, "p-xrgba", u, 4, 1.),
    );
    let bind = g["p-bindtoemitter"]
        .as_array()
        .and_then(|a| a.first())
        .and_then(|v| v.as_f64())
        .map(|v| v as f32)
        .unwrap_or_else(|| scalar(g, "p-bindtoemitter", 0.));
    let drag = vector(g, "p-drag", Vec3::ZERO);
    let displacement = Vec3::new(
        integral_drag(p.velocity.x, drag.x, t),
        integral_drag(p.velocity.y, drag.y, t),
        integral_drag(p.velocity.z, drag.z, t),
    );
    let position =
        p.position.lerp(current, bind) + displacement + vector(g, "p-postoffset", Vec3::ZERO) / 20.;
    let scale = p.scale
        * Vec3::new(
            curve(g, "p-xscale", u, 1, 1.),
            curve(g, "p-xscale", u, 2, 1.),
            1.,
        );
    let uv = vector2(g, "p-uvscroll-rgb")
        * Vec2::new(
            integral_curve(g, "p-uvscroll-rgbXP", t, p.life),
            integral_curve(g, "p-uvscroll-rgbYP", t, p.life),
        );
    Some((
        Transform::from_translation(position)
            .with_rotation(p.rotation)
            .with_scale(Vec3::new(scale.x, scale.y, 1.)),
        rgba,
        uv,
    ))
}
fn integral_drag(v: f32, drag: f32, t: f32) -> f32 {
    if drag.abs() < 1e-6 {
        v * t
    } else {
        v * (1. - (-drag * t).exp()) / drag
    }
}
fn vector2(g: &serde_json::Value, k: &str) -> Vec2 {
    g[k].as_array()
        .map(|a| Vec2::new(a[0].as_f64().unwrap() as f32, a[1].as_f64().unwrap() as f32))
        .unwrap_or(Vec2::ZERO)
}
fn integral_curve(g: &serde_json::Value, prefix: &str, t: f32, life: f32) -> f32 {
    // Piecewise-linear velocity integrated over normalized lifetime.
    let mut xs: Vec<f32> = (1..=16)
        .filter_map(|i| g[format!("{prefix}{i}")][0].as_f64())
        .map(|x| x as f32)
        .filter(|x| *x > 0. && *x < t / life)
        .collect();
    xs.extend([0., t / life]);
    xs.sort_by(f32::total_cmp);
    xs.windows(2)
        .map(|w| {
            (curve(g, prefix, w[0], 1, 1.) + curve(g, prefix, w[1], 1, 1.))
                * 0.5
                * (w[1] - w[0])
                * life
        })
        .sum()
}
// Diagnostic only. Journal events do not carry an epoch/frame ordinal, so
// several snapshots at one session/tick cannot be assigned to an event here.
// Never select the first/last candidate and report that as an exact association.
fn lifecycle_diagnostic(
    event: &openleague_core::missile_lifecycle::Event,
    contexts: &[openleague_core::Snapshot],
) -> serde_json::Value {
    let count = contexts.iter().filter(|s| s.session == event.session && s.tick == event.tick).count();
    let (present, association): (Option<bool>, &str) = match count {
        0 => (Some(false), "missing"),
        1 => (Some(true), "unique_session_tick"),
        _ => (None, "ambiguous_session_tick"),
    };
    serde_json::json!({"session":event.session,"tick":event.tick,"kind":format!("{:?}",event.kind),
        "source":event.missile.source,"target":event.missile.target,"cooldown_ready":event.missile.cooldown_ready,
        "context_present":present,"context_candidates":count,"context_association":association})
}
pub fn update(
    mut commands: Commands,
    clock: Res<crate::native_effect_clock::EffectClock>,
    mut state: ResMut<Match>,
    assets: Res<AssetServer>,
    mut meshes: ResMut<Assets<Mesh>>,
    mut materials: ResMut<Assets<QMaterial>>,
    mut flights: ResMut<Flights>,
    mut quads: Query<(&mut Transform, &mut Visibility), With<QQuad>>,
    children: Query<&Children>,
    bones: Query<(&Name, &GlobalTransform)>,
    cameras: Query<&GlobalTransform, With<Camera3d>>,
) {
    let now = clock.now;
    flights.projection_frames.clear();
    // One-frame inbox: draining bounds storage even during long sessions.
    // Keep exact source/target snapshots for chronological effect reconstruction.
    flights.observed_events = state.missile_journal.drain();
    flights.observed_contexts = std::mem::take(&mut state.missile_contexts);
    if std::env::var_os("OPENLEAGUE_Q_STARTUP_PROBE").is_some() {
        for event in &flights.observed_events {
            warn!("ANNIE_LIFECYCLE {}", lifecycle_diagnostic(event, &flights.observed_contexts));
        }
    }
    let snapshot = state.snapshot.as_ref();
    let session = snapshot.map(|s| s.session);
    if flights.session != session {
        for (_, shot) in flights.shots.drain() {
            for pool in shot.pools {
                for (e, m, _) in pool.slots {
                    commands.entity(e).despawn();
                    materials.remove(m.id());
                }
            }
        }
        flights.session = session;
        flights.startup_probe_tick = None;
    }
    let Some(s) = snapshot else {
        return;
    };
    // Diagnostic observations only: never delay casts or manufacture a launch pose.
    if std::env::var_os("OPENLEAGUE_Q_STARTUP_PROBE").is_some() && flights.startup_probe_tick!=Some(s.tick) {
        flights.startup_probe_tick=Some(s.tick);
        let sources=s.players.iter().filter(|player|player.champion.eq_ignore_ascii_case("annie")).map(|player| {
            let root=state.visuals.get(&player.id);
            let neck=root.is_some_and(|root|children.iter_descendants(*root).filter_map(|e|bones.get(e).ok()).any(|(name,_)|name.as_str().eq_ignore_ascii_case("neck")));
            serde_json::json!({"id":player.id,"root":root.is_some(),"neck":neck})
        }).collect::<Vec<_>>();
        let missiles=s.spell_projectiles.iter().map(|m|serde_json::json!({"source":m.source,"target":m.target,"cooldown_ready":m.cooldown_ready,"target_present":s.players.iter().any(|p|p.id==m.target)||s.units.iter().any(|p|p.id==m.target),"flight_exists":flights.shots.contains_key(&(m.source,m.target,m.cooldown_ready))})).collect::<Vec<_>>();
        warn!("ANNIE_STARTUP {}",serde_json::json!({"session":s.session,"tick":s.tick,"elapsed":now,"sources":sources,"missiles":missiles,"flights_created":flights.seen}));
    }
    if !flights.reported && !s.spell_projectiles.is_empty() {
        warn!(
            "Annie Q VFX partial: Fire/Fire_Head/Embers native fields; Glow path ambiguity and skin mesh consumers remain open; Projected uses a reconstructed owner adapter. Impact not inferred from missile disappearance."
        );
        flights.reported = true;
    }
    if flights.mesh.is_none() {
        flights.mesh = Some(meshes.add(Rectangle::new(1., 1.)));
        flights.texture = Some(terrain_material::image(
            &assets,
            "particles/annie/Annie_Idle_Fire.png".into(),
            true,
        ));
    }
    // Replay accepted snapshot contexts at their observed server-tick spacing.
    // This is a local network clock adapter, not a recovered native clock source.
    let mut contexts = std::mem::take(&mut flights.observed_contexts);
    if contexts.last().is_none_or(|context| context.tick != s.tick) { contexts.push(s.clone()); }
    let latest_tick = s.tick;
    let render_now = now;
    for context in &contexts {
    let s = context;
    let now = render_now - latest_tick.saturating_sub(s.tick) as f64 / openleague_core::TICK_RATE as f64;
    let historical = s.tick < latest_tick;
    let active: HashMap<_, _> = s
        .spell_projectiles
        .iter()
        .map(|m| ((m.source, m.target, m.cooldown_ready), m))
        .collect();
    let gone: Vec<_> = flights
        .shots
        .iter()
        .filter(|(_, shot)| {
            shot.ended.is_some_and(|end| now - end >= 2.)
                && shot
                    .pools
                    .iter()
                    .all(|pool| pool.slots.iter().all(|(_, _, p)| p.is_none()))
        })
        .map(|(key, _)| *key)
        .collect();
    for key in gone {
        let shot = flights.shots.remove(&key).unwrap();
        for pool in shot.pools {
            for (e, m, _) in pool.slots {
                commands.entity(e).despawn();
                materials.remove(m.id());
            }
        }
    }
    for (&key, m) in &active {
        let target = s
            .players
            .iter()
            .find(|p| p.id == m.target)
            .map(|p| Vec3::new(p.position.x, p.height + 100., p.position.z) / 20.)
            .or_else(|| {
                s.units
                    .iter()
                    .find(|p| p.id == m.target)
                    .map(|p| Vec3::new(p.position.x, p.height + 100., p.position.z) / 20.)
            });
        if !flights.shots.contains_key(&key) {
            // A new flight requires an observed target. Existing flights retain the
            // last native target when it disappears from the current snapshot.
            let Some(target) = target else { continue; };
            let neck = state.visuals.get(&m.source).and_then(|root| {
                children
                    .iter_descendants(*root)
                    .filter_map(|e| bones.get(e).ok())
                    .find(|(name, _)| name.as_str().eq_ignore_ascii_case("neck"))
                    .map(|(_, t)| t.translation())
            });
            // Wait for the actual imported bone, rather than invent a launch height.
            // Historical bones are unavailable. For a delayed observation use its
            // authoritative planar missile position and observed target height.
            // Do not substitute the present-day neck pose for a past launch pose.
            let launch = if historical {
                Vec3::new(m.position.x / 20., target.y, m.position.z / 20.)
            } else {
                let Some(launch) = neck else { continue; };
                launch
            };
            let pools = ["Fire", "Fire_Head", "Embers"]
                .map(|name| {
                    let slots = (0..capacity(group(name)))
                        .map(|_| {
                            let material = materials.add(QMaterial::new(
                                if name == "Embers" {
                                    terrain_material::image(
                                        &assets,
                                        "particles/annie/sparks_BW.png".into(),
                                        false,
                                    )
                                } else {
                                    flights.texture.as_ref().unwrap().clone()
                                },
                                if name == "Embers" {
                                    Some(terrain_material::image(
                                        &assets,
                                        "particles/annie/Annie_Embers_RGB.png".into(),
                                        false,
                                    ))
                                } else {
                                    None
                                },
                                group(name),
                            ));
                            let entity = commands
                                .spawn((
                                    Mesh3d(flights.mesh.as_ref().unwrap().clone()),
                                    MeshMaterial3d(material.clone()),
                                    Transform::default(),
                                    Visibility::Hidden,
                                    QQuad,
                                    bevy::light::NotShadowCaster,
                                    bevy::light::NotShadowReceiver,
                                ))
                                .id();
                            (entity, material, None)
                        })
                        .collect();
                    Pool {
                        name,
                        slots,
                        last: None,
                    }
                })
                .into();
            flights.shots.insert(
                key,
                Shot {
                    started: now,
                    previous: launch,
                    moving_native: (launch * 20.).to_array(),
                    direction_native: [0.;3],
                    target_native: (target * 20. - Vec3::Y * 100.).to_array(),
                    last_update: now,
                    pools,
                    ended: None,
                },
            );
            flights.seen += 1;
            flights.captured=false;
        }
        let shot = flights.shots.get_mut(&key).unwrap();
        let target_native = target.map(|target| (target * 20. - Vec3::Y * 100.).to_array());
        let now = now.max(shot.last_update);
        let dt = (now - shot.last_update) as f32;
        let motion = match native_flight_step(shot.moving_native, shot.target_native, target_native, dt) {
            Ok(motion) => motion,
            Err(error) => { warn!("Annie native missile motion rejected: {error}"); continue; }
        };
        shot.moving_native = motion.moving_position;
        shot.direction_native = motion.direction;
        shot.target_native = motion.target;
        shot.last_update = now;
        let anchor = Vec3::from_array(motion.moving_position) / 20.;
        for pool in &mut shot.pools {
            let g = group(pool.name);
            let age = (now - shot.started) as f32;
            let rate = scalar(g, "e-rate", 0.);
            if age > scalar(g, "e-life", f32::INFINITY) {
                continue;
            }
            let last = (age * rate).floor() as u64;
            for index in keys(last, pool.slots.len()) {
                if pool.last.is_some_and(|prior| index <= prior) {
                    continue;
                }
                let birth = shot.started + index as f64 / rate as f64;
                let slot = index as usize % pool.slots.len();
                pool.slots[slot].2 = Some(born(g, index, key, birth, anchor));
            }
            pool.last = Some(last);
        }
        shot.previous = anchor;
    }
    for (key, shot) in &mut flights.shots {
        if !active.contains_key(key) && shot.ended.is_none() {
            shot.ended = Some(now);
        }
        for pool in &mut shot.pools {
            for (e, m, p) in &mut pool.slots {
                if let Ok((mut t, mut v)) = quads.get_mut(*e) {
                    if let Some((pose, color, uv)) = p
                        .as_ref()
                        .and_then(|p| pose(group(pool.name), p, now, shot.previous))
                    {
                        *t = pose;
                        if scalar(group(pool.name), "p-type", 0.) == 0. {
                            if let Some(camera) = cameras.iter().next() {
                                let rotation = camera.rotation();
                                t.rotation = rotation;
                                if let Some(particle) = p.as_ref() {
                                    if scalar(group(pool.name), "p-vecalign", 0.) > 0. {
                                        let vx = particle.velocity.dot(rotation * Vec3::X);
                                        let vy = particle.velocity.dot(rotation * Vec3::Y);
                                        t.rotation =
                                            rotation * Quat::from_rotation_z((-vx).atan2(vy));
                                        let stretch = (particle.velocity.length()
                                            * 20.
                                            * scalar(group(pool.name), "p-vec-velocity-scale", 0.))
                                        .max(scalar(
                                            group(pool.name),
                                            "p-vec-velocity-minscale",
                                            1.,
                                        ));
                                        t.scale.y *= stretch;
                                    }
                                }
                            }
                        }
                        *v = Visibility::Inherited;
                        if let Some(mut mat) = materials.get_mut(m) {
                            mat.set(color, uv);
                            if let Some(particle) = p.as_ref() {
                                mat.atlas.z = particle.frame as f32;
                                let age =
                                    ((now - particle.birth) as f32 / particle.life).clamp(0., 1.);
                                mat.lookup.x = age;
                                mat.lookup.y = random(particle.seed, 12);
                            }
                        }
                    } else {
                        *v = Visibility::Hidden;
                        *p = None;
                    }
                }
            }
        }
    }
    let owners = flights.projection_owners();
    flights.projection_frames.push(ProjectionFrame { time:now, owners });
    }
    flights.max_quads = flights.max_quads.max(quads.iter().count());
    flights.max_visible = flights.max_visible.max(
        quads
            .iter()
            .filter(|(_, v)| **v != Visibility::Hidden)
            .count(),
    );
    if !flights.captured
        && flights
            .shots
            .values()
            .any(|s| s.ended.is_none() && now - s.started >= 0.12)
    {
        if let Ok(path) = std::env::var("OPENLEAGUE_Q_VFX_SCREENSHOT") {
            let p = std::path::Path::new(&path);
            assert_eq!(
                p.parent(),
                Some(std::path::Path::new(r"E:\OpenLeague\logs"))
            );
            commands
                .spawn(bevy::render::view::screenshot::Screenshot::primary_window())
                .observe(bevy::render::view::screenshot::save_to_disk(if flights.seen>1{p.with_file_name(format!("{}-shot{}.png",p.file_stem().unwrap().to_string_lossy(),flights.seen))}else{p.to_path_buf()}));
            flights.captured = true;
        }
    }

    if let Ok(path) = std::env::var("OPENLEAGUE_Q_VFX_PROBE") {
        if flights.seen > 0 && flights.shots.is_empty() {
            let p = std::path::Path::new(&path);
            assert_eq!(
                p.parent(),
                Some(std::path::Path::new(r"E:\OpenLeague\logs"))
            );
            std::fs::write(p,serde_json::to_vec_pretty(&serde_json::json!({"diagnostic":true,"shots_seen":flights.seen,"max_quads":flights.max_quads,"remaining_quads":quads.iter().count(),"max_visible_quads":flights.max_visible,"remaining_materials":materials.len(),"captured":flights.captured,"complete":false,"native_binding":"Annie_Q_mis/neck/targetHeight100","rendered_groups":["Fire","Fire_Head","Embers"]})).unwrap()).unwrap();
        }
    }
}
#[cfg(test)]
mod tests {
    use super::*;

    fn diagnostic_snapshot(session:u64,tick:u64,missiles:Vec<openleague_core::annie::Missile>)->openleague_core::Snapshot {
        serde_json::from_value(serde_json::json!({"session":session,"tick":tick,"roster":[],
            "players":[],"units":[],"winner":null,"map10":null,"spell_projectiles":missiles})).unwrap()
    }
    fn diagnostic_missile()->openleague_core::annie::Missile {
        openleague_core::annie::Missile {source:1,target:2,position:openleague_core::Point{x:10.,z:20.},
            raw:80.,cost:60.,refund_ticks:60,cooldown_ready:100}
    }
    #[test]
    fn lifecycle_diagnostic_same_tick_frames_never_claim_first_context_matches_all_events() {
        let mut journal=openleague_core::missile_lifecycle::Journal::default();
        journal.reset(7);journal.begin_epoch(7,1).unwrap();
        let first=diagnostic_missile();let mut moved=first.clone();moved.position.x=30.;
        let contexts=vec![diagnostic_snapshot(7,10,vec![first]),
            diagnostic_snapshot(7,10,vec![moved]),diagnostic_snapshot(7,10,vec![])];
        for (index,snapshot) in contexts.iter().enumerate() {
            assert!(journal.accept_frame(snapshot.session,index as u64+1,snapshot.tick,&snapshot.spell_projectiles).unwrap());
        }
        let events=journal.drain();assert_eq!(events.len(),3);
        assert_eq!(events.iter().map(|event|event.kind).collect::<Vec<_>>(),
            vec![openleague_core::missile_lifecycle::Kind::Appeared,
                 openleague_core::missile_lifecycle::Kind::Observed,
                 openleague_core::missile_lifecycle::Kind::Disappeared]);
        for event in &events {
            let row=lifecycle_diagnostic(event,&contexts);
            assert!(row["context_present"].is_null());assert_eq!(row["context_candidates"],3);
            assert_eq!(row["context_association"],"ambiguous_session_tick");
        }
        assert_eq!(contexts[0].spell_projectiles[0].position.x,10.);
        assert_eq!(contexts[1].spell_projectiles[0].position.x,30.);
        assert!(contexts[2].spell_projectiles.is_empty());
    }
    #[test]
    fn lifecycle_diagnostic_requires_session_and_tick_and_keeps_unique_legacy_evidence() {
        let event=openleague_core::missile_lifecycle::Event {session:7,tick:10,
            kind:openleague_core::missile_lifecycle::Kind::Appeared,missile:diagnostic_missile()};
        let contexts=vec![diagnostic_snapshot(8,10,vec![]),diagnostic_snapshot(7,9,vec![]),
            diagnostic_snapshot(7,10,vec![diagnostic_missile()])];
        let row=lifecycle_diagnostic(&event,&contexts);
        assert_eq!(row["context_present"],true);assert_eq!(row["context_candidates"],1);
        assert_eq!(row["context_association"],"unique_session_tick");
        let absent=lifecycle_diagnostic(&event,&contexts[..2]);
        assert_eq!(absent["context_present"],false);assert_eq!(absent["context_candidates"],0);
        assert_eq!(absent["context_association"],"missing");
    }
    #[test]
    fn native_flight_consumer_matches384_original_moving_target_frames() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/missile_motion_sequences_contract.json")).unwrap();
        let sequences=p["sequences"].as_array().unwrap();assert_eq!(sequences.len(),48);
        for(n,c) in sequences.iter().enumerate(){
            let v=|row:&serde_json::Value,k:&str|std::array::from_fn(|i|row[k][i].as_f64().unwrap() as f32);
            let mut moving=v(c,"origin");let mut fallback=v(c,"destination");
            for(j,f) in c["frames"].as_array().unwrap().iter().enumerate(){
                let a=native_flight_step(moving,fallback,f["live_target"].as_bool().unwrap().then(||v(f,"target_position")),c["dt"].as_f64().unwrap() as f32).unwrap();
                for(k,values) in [("moving_position_words",a.moving_position),("direction_words",a.direction),("target_words",a.target)]{
                    for i in 0..3{assert_eq!(values[i].to_bits(),f[k][i].as_u64().unwrap() as u32,"sequence{n} frame{j} {k} axis{i}");}
                }
                moving=a.moving_position;fallback=a.target;
            }
        }
    }
    #[test]
    fn native_emission_probability_and_color_lifetime_are_bounded() {
        let g = group("Fire");
        assert_eq!(capacity(g), 26);
        for i in 0..200 {
            assert!((0.25..=0.5).contains(&life(g, i)));
        }
        let p = born(g, 2, (1, 2, 3), 0., Vec3::ZERO);
        assert!(pose(g, &p, p.life as f64, Vec3::ZERO).is_none());
        let (_, color, _) = pose(g, &p, 0., Vec3::ZERO).unwrap();
        assert_eq!(color.w, 0.);
        assert_eq!(curve(g, "p-xrgba", 0.8, 2, 1.), 0.);
        assert_eq!(capacity(group("Fire_Head")), 101);
    }
    #[test]
    fn planar_scale_remains_invertible_and_uv_velocity_integrates() {
        let g = group("Fire");
        let p = born(g, 2, (1, 2, 3), 0., Vec3::ZERO);
        let (t, _, uv) = pose(g, &p, p.life as f64 * 0.5, Vec3::ZERO).unwrap();
        assert_eq!(t.scale.z, 1.);
        assert!(t.scale.x > 0. && t.scale.y > 0.);
        assert!(uv.x < 0.);
        assert_eq!(uv.y, 0.);
        assert!((integral_drag(10., 0., 0.5) - 5.).abs() < 1e-6);
        assert!(
            (integral_curve(g, "p-uvscroll-rgbXP", p.life, p.life) - 0.75 * p.life).abs() < 1e-6
        );
    }
}

#[derive(Resource, Default)]
pub struct VisibilityProbe {
    rows: Vec<serde_json::Value>,
    wrote: bool,
}
pub fn visibility_probe(
    state: Res<Match>,
    time: Res<Time>,
    mut probe: ResMut<VisibilityProbe>,
    flights: Res<Flights>,
    quads: Query<
        (
            &Transform,
            &GlobalTransform,
            &Visibility,
            &ViewVisibility,
            &MeshMaterial3d<QMaterial>,
        ),
        With<QQuad>,
    >,
    cameras: Query<(&Camera, &GlobalTransform), With<Camera3d>>,
    materials: Res<Assets<QMaterial>>,
    images: Res<Assets<Image>>,
) {
    let Ok(path) = std::env::var("OPENLEAGUE_Q_VISIBILITY_PROBE") else {
        return;
    };
    if probe.wrote {
        return;
    }
    let p = std::path::Path::new(&path);
    assert_eq!(
        p.parent(),
        Some(std::path::Path::new(r"E:\OpenLeague\logs"))
    );
    if !quads.is_empty() && probe.rows.len() < 120 {
        let camera = cameras.iter().next();
        let mut rows = vec![];
        for (local, global, visibility, view, handle) in &quads {
            if *visibility == Visibility::Hidden {
                continue;
            }
            let material = materials.get(&handle.0);
            let world = global.translation();
            let screen = camera
                .and_then(|(c, t)| c.world_to_viewport(t, world).ok())
                .map(|s| s.to_array());
            let normal = global
                .affine()
                .transform_vector3(Vec3::Z)
                .normalize_or_zero();
            let facing =
                camera.map(|(_, t)| normal.dot((t.translation() - world).normalize_or_zero()));
            rows.push(serde_json::json!({"local":local.translation.to_array(),"global":world.to_array(),"scale":local.scale.to_array(),"view_visible":view.get(),"screen":screen,"normal_to_camera_dot":facing,"color":material.map(|m|m.color.to_array()),"texture_loaded":material.is_some_and(|m|images.get(&m.texture).is_some())}));
            if rows.len() == 8 {
                break;
            }
        }
        let count = quads.iter().filter(|(_, _, _, v, _)| v.get()).count();
        probe.rows.push(serde_json::json!({"time":time.elapsed_secs_f64(),"tick":state.snapshot.as_ref().map(|s|s.tick),"visible_in_view":count,"ember_in_view":quads.iter().filter(|(_,_,_,v,h)|v.get()&&materials.get(&h.0).is_some_and(|m|m.color_texture.is_some())).count(),"samples":rows}));
    }
    if flights.seen > 0 && flights.shots.is_empty() && quads.is_empty() {
        std::fs::write(
            p,
            serde_json::to_vec_pretty(
                &serde_json::json!({"diagnostic":true,"frames":probe.rows,"complete":false}),
            )
            .unwrap(),
        )
        .unwrap();
        probe.wrote = true;
    }
}

#[cfg(test)]
mod ember_tests {
    use super::*;
    #[test]
    fn native_ember_spawn_offsets_atlas_lifetimes_and_velocity_ranges() {
        let g = group("Embers");
        assert_eq!(capacity(g), 391);
        for index in 0..500 {
            let p = born(g, index, (1, 2, 3), 0., Vec3::ZERO);
            assert!((0.65..=2.6).contains(&p.life));
            assert!(p.frame < 4);
            assert!((-1. ..=1.).contains(&p.position.x));
            assert!((-1. ..=1.).contains(&p.position.y));
            assert!((0.75..=2.25).contains(&p.velocity.x));
            assert!((15. ..=30.).contains(&p.velocity.y));
            assert!(pose(g, &p, p.life as f64, Vec3::ZERO).is_none());
        }
    }
}
