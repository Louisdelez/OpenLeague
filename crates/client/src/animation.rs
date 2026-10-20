//! Only bind clip indices whose native names were checked against the actual GLBs.
use crate::Match;
use bevy::{
    prelude::*,
    world_serialization::{WorldAssetRoot, WorldInstanceReady},
};
use std::collections::HashMap;
const EZREAL_JOINT_IDENTITY_ASSET: &str = "champions/ezreal_joint_identity_local.glb";

// Ownership is attached to the actual AnimationPlayer, independently of its
// role string. It permits retiring only the exact R node this channel started.
#[derive(Component, Default)]
pub struct EzrealRCastPose { active: Option<OwnedEzrealR>, retiring: bool }
struct OwnedEzrealR {
    identity: crate::ezreal_r_cast_animation::Identity,
    node: AnimationNodeIndex,
    graph: bevy::asset::AssetId<AnimationGraph>,
    clip: bevy::asset::AssetId<AnimationClip>,
    model: bevy::asset::AssetId<Gltf>,
}
fn stop_ezreal_r_pose(player: &mut AnimationPlayer, pose: Option<&mut EzrealRCastPose>,
    current_graph: Option<bevy::asset::AssetId<AnimationGraph>>) {
    let Some(pose) = pose else { return; };
    let Some(owned) = pose.active.as_ref() else { pose.retiring = false; return; };
    // A replacement graph can reuse the index for a foreign clip. Keep one
    // bounded retirement slot until the original graph returns or this player
    // is removed; new R poses on this player remain blocked in the meantime.
    if current_graph != Some(owned.graph) { pose.retiring = true; return; }
    player.stop(owned.node);
    pose.active = None;
    pose.retiring = false;
}
fn canonical_ezreal_r_clip(catalog: &Catalog, model: &Gltf) -> bool {
    catalog.0["ezreal"]["roles"]["spell4"].as_u64() == Some(41)
        && catalog.0["ezreal"]["clips"][41].as_str() == Some("ezreal_spell4")
        && model.animations.get(41).zip(model.named_animations.get("ezreal_spell4"))
            .is_some_and(|(indexed, named)| indexed.id() == named.id())
}

#[derive(Component, Default)]
pub struct EzrealWCastPose { active: Option<OwnedEzrealW>, retiring: bool }
struct OwnedEzrealW {
    identity: crate::ezreal_w_cast_animation::Identity,
    node: AnimationNodeIndex,
    graph: bevy::asset::AssetId<AnimationGraph>,
    clip: bevy::asset::AssetId<AnimationClip>,
    model: bevy::asset::AssetId<Gltf>,
}
fn stop_ezreal_w_pose(player: &mut AnimationPlayer, pose: Option<&mut EzrealWCastPose>,
    current_graph: Option<bevy::asset::AssetId<AnimationGraph>>) {
    let Some(pose) = pose else { return; };
    let Some(owned) = pose.active.as_ref() else { pose.retiring = false; return; };
    // A replacement graph can reuse the index for a foreign clip. Keep one
    // bounded retirement slot until the original graph returns or this player
    // is removed; new W poses on this player remain blocked in the meantime.
    if current_graph != Some(owned.graph) { pose.retiring = true; return; }
    player.stop(owned.node);
    pose.active = None;
    pose.retiring = false;
}
fn canonical_ezreal_w_clip(catalog: &Catalog, model: &Gltf) -> bool {
    catalog.0["ezreal"]["roles"]["spell2"].as_u64() == Some(39)
        && catalog.0["ezreal"]["clips"][39].as_str() == Some("ezreal_spell2")
        && model.animations.get(39).zip(model.named_animations.get("ezreal_spell2"))
            .is_some_and(|(indexed, named)| indexed.id() == named.id())
}


#[derive(Component, Default)]
pub struct EzrealECastPose { active: Option<OwnedEzrealE>, retiring: bool }
struct OwnedEzrealE {
    identity: crate::ezreal_e_cast_animation::Identity,
    node: AnimationNodeIndex,
    graph: bevy::asset::AssetId<AnimationGraph>,
    clip: bevy::asset::AssetId<AnimationClip>,
    model: bevy::asset::AssetId<Gltf>,
}
fn stop_ezreal_e_pose(player: &mut AnimationPlayer, pose: Option<&mut EzrealECastPose>,
    current_graph: Option<bevy::asset::AssetId<AnimationGraph>>) {
    let Some(pose) = pose else { return; };
    let Some(owned) = pose.active.as_ref() else { pose.retiring = false; return; };
    // A replacement graph can reuse the index for a foreign clip. Keep one
    // bounded retirement slot until the original graph returns or this player
    // is removed; new E poses on this player remain blocked in the meantime.
    if current_graph != Some(owned.graph) { pose.retiring = true; return; }
    player.stop(owned.node);
    pose.active = None;
    pose.retiring = false;
}
fn canonical_ezreal_e_clip(catalog: &Catalog, model: &Gltf) -> bool {
    catalog.0["ezreal"]["roles"]["spell3"].as_u64() == Some(40)
        && catalog.0["ezreal"]["clips"][40].as_str() == Some("ezreal_spell3")
        && model.animations.get(40).zip(model.named_animations.get("ezreal_spell3"))
            .is_some_and(|(indexed, named)| indexed.id() == named.id())
}


#[cfg(all(test, windows))]
#[path = "ezreal_e_cast_animation_binding_tests.rs"]
mod ezreal_e_cast_animation_binding_tests;

#[cfg(all(test, windows))]
#[path = "ezreal_w_cast_animation_binding_tests.rs"]
mod ezreal_w_cast_animation_binding_tests;

#[cfg(all(test, windows))]
mod ezreal_r_cast_animation_binding_tests {
    use super::*;
    use openleague_core::{Simulation, Snapshot};
    use crate::ezreal_r_cast_animation::test_support::{game, cast};
    use bevy::animation::{AnimationDelta, advance_animations,
        transition::{advance_transitions, expire_completed_transitions}};

    fn fixture_with_clip(clip: AnimationClip) -> (App, App, Simulation, u32, Entity, AnimationNodeIndex, AnimationNodeIndex) {
        let mut owner = App::new(); crate::native_effect_clock::install_test_clock(&mut owner);
        owner.add_plugins(crate::native_effect_clock::Plugin); owner.update();
        let clock = owner.world_mut().remove_resource::<crate::native_effect_clock::EffectClock>().unwrap();
        assert!(clock.presentation_ready());
        let (game, id) = game();
        let mut app = App::new(); app.add_plugins(bevy::app::TaskPoolPlugin::default());
        app.init_resource::<Time>().init_resource::<Assets<AnimationClip>>().init_resource::<Assets<AnimationGraph>>()
            .init_resource::<AnimationDelta>().insert_resource(clock)
            .add_systems(Update, (animate, advance_transitions, advance_animations, expire_completed_transitions).chain());
        let clip = app.world_mut().resource_mut::<Assets<AnimationClip>>().add(clip);
        let mut graph = AnimationGraph::new(); let mut roles = HashMap::new();
        for role in ["idle", "run", "attack", "death", "spell1", "spell4", "stun", "foreign"] {
            roles.insert(role.to_owned(), graph.add_clip(clip.clone(), 1., graph.root));
        }
        let r = roles["spell4"]; let foreign = roles["foreign"];
        let graph = app.world_mut().resource_mut::<Assets<AnimationGraph>>().add(graph);
        let playback = Playback { id, model_name: "ezreal".into(), graph: graph.clone(), _model: Handle::default(), roles,
            clips: HashMap::from([("spell1".into(), clip.clone()), ("spell4".into(), clip)]), durations: HashMap::new() };
        let mut player = AnimationPlayer::default(); player.play(foreign).repeat();
        let entity = app.world_mut().spawn((player, AnimationTransitions::new(), AnimationGraphHandle(graph),
            EzrealRCastPose::default(), Actor { playback, role: "idle".into(), previous_attack: 0,
                attack_until: 0, critical: false, presentation: None })).id();
        let mut state = Match::default(); state.attack_visuals.reset(7);
        state.ezreal_q_cast_visuals.reset(7); state.ezreal_r_cast_visuals.reset(7);
        let snapshot = game.snapshot_for(id).unwrap();
        state.ezreal_q_cast_visuals.observe_accepted(&snapshot, 0., true, false).unwrap();
        state.ezreal_r_cast_visuals.observe_accepted(&snapshot, 0., true, false).unwrap();
        state.snapshot = Some(snapshot); app.insert_resource(state);
        (app, owner, game, id, entity, r, foreign)
    }
    fn fixture() -> (App, App, Simulation, u32, Entity, AnimationNodeIndex, AnimationNodeIndex) {
        let mut clip = AnimationClip::default(); clip.set_duration(3.0666668); fixture_with_clip(clip)
    }
    fn observe(app: &mut App, snapshot: Snapshot, now: f64) {
        let (ready, paused) = {
            let mut clock = app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>();
            clock.now = now; (clock.presentation_ready(), clock.paused())
        };
        let mut state = app.world_mut().resource_mut::<Match>();
        state.attack_visuals.observe(&snapshot, now).unwrap();
        state.ezreal_q_cast_visuals.observe_accepted(&snapshot, now, ready, paused).unwrap();
        let Match { ezreal_r_cast_visuals, ezreal_q_cast_visuals, .. } = &mut *state;
        ezreal_r_cast_visuals.observe_with_q(&snapshot, now, ready, paused, ezreal_q_cast_visuals).unwrap();
        state.snapshot = Some(snapshot);
    }
    fn publish(app: &mut App, snapshot: Snapshot, now: f64) { observe(app, snapshot, now); app.update(); }
    fn retired_only_r(app: &App, entity: Entity, r: AnimationNodeIndex, foreign: AnimationNodeIndex) {
        let player = app.world().get::<AnimationPlayer>(entity).unwrap();
        assert!(player.animation(r).is_none()); assert!(player.animation(foreign).is_some());
        assert!(app.world().get::<EzrealRCastPose>(entity).unwrap().active.is_none());
    }
    #[test]
    fn actual_player_uses_effect_age_freezes_on_pause_and_retires_at_core_release_without_rescale() {
        let (mut app, _owner, mut game, id, entity, r, foreign) = fixture();
        let snapshot = cast(&mut game, id); let before = serde_json::to_value(&snapshot).unwrap();
        publish(&mut app, snapshot.clone(), 0.1);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role, "spell4");
        assert_eq!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(r).unwrap().seek_time(), 0.);
        publish(&mut app, snapshot.clone(), 0.3);
        let age = app.world().get::<AnimationPlayer>(entity).unwrap().animation(r).unwrap().seek_time();
        assert!((age - 0.2).abs() < 0.00001, "authored duration must not scale the local 30-tick cast");
        let mut pause = vec![0; 14]; pause[9..13].copy_from_slice(&30i32.to_le_bytes()); pause[13] = 1;
        app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().receive(1, 0xa1, &pause).unwrap();
        let mut paused = snapshot.clone(); paused.tick = 125; publish(&mut app, paused, 0.3);
        for _ in 0..3 {
            app.world_mut().resource_mut::<Time>().advance_by(std::time::Duration::from_secs(1));
            app.world_mut().resource_mut::<AnimationDelta>().0 = 0.; app.update();
            assert_eq!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(r).unwrap().seek_time(), age);
        }
        app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().receive(2, 0x0a, &[0; 10]).unwrap();
        while game.tick < 130 { game.advance(); }
        let released = game.snapshot_for(id).unwrap(); assert!(released.ezreal_r_casts.is_empty());
        publish(&mut app, released, 0.4); retired_only_r(&app, entity, r, foreign);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role, "idle");
        assert_eq!(serde_json::to_value(&snapshot).unwrap(), before);
    }
    #[test]
    fn death_forced_stun_and_silence_remove_owned_r_and_cannot_rearm_after_control() {
        for (mode, role) in [(0, "death"), (1, "run"), (2, "stun"), (3, "idle")] {
            let (mut app, _owner, mut game, id, entity, r, foreign) = fixture();
            let snapshot = cast(&mut game, id); publish(&mut app, snapshot.clone(), 0.1);
            let mut blocked = snapshot.clone(); blocked.tick = 101;
            let actor = blocked.players.iter_mut().find(|p| p.id == id).unwrap();
            match mode { 0 => actor.health = 0.,
                1 => {
                    actor.effects.trundle_e_push = Some(openleague_core::trundle_e::ForcedMovement { started: 101, until: 112 });
                    assert!(openleague_core::trundle_e::champion_forced(actor, 101), "forced fixture must be active before publication");
                },
                2 => actor.stuns.push(openleague_core::stuns::Stun { tag: "fixture".into(), source: None, expires_at: 120 }),
                _ => actor.effects.silence_until = 120 }
            let before = serde_json::to_value(&blocked).unwrap(); publish(&mut app, blocked, 0.12);
            retired_only_r(&app, entity, r, foreign); assert_eq!(app.world().get::<Actor>(entity).unwrap().role, role);
            assert_eq!(serde_json::to_value(app.world().resource::<Match>().snapshot.as_ref().unwrap()).unwrap(), before);
            let mut recovered = snapshot.clone(); recovered.tick = 102; publish(&mut app, recovered, 0.14);
            retired_only_r(&app, entity, r, foreign);
        }
    }
    #[test]
    fn clip_graph_scene_clock_and_visibility_loss_consume_r_without_stopping_foreign_animation() {
        for mode in 0..8 {
            let (mut app, _owner, mut game, id, entity, r, foreign) = fixture(); let snapshot = cast(&mut game, id);
            if mode == 0 { app.world_mut().get_mut::<Actor>(entity).unwrap().playback.clips.remove("spell4"); }
            publish(&mut app, snapshot.clone(), 0.1);
            if mode == 0 {
                retired_only_r(&app, entity, r, foreign);
                let clip = app.world().get::<Actor>(entity).unwrap().playback.clips["spell1"].clone();
                app.world_mut().get_mut::<Actor>(entity).unwrap().playback.clips.insert("spell4".into(), clip);
                publish(&mut app, snapshot.clone(), 0.12); retired_only_r(&app, entity, r, foreign); continue;
            }
            if mode == 1 {
                let playback = app.world().get::<Actor>(entity).unwrap().playback.clone(); let graph = playback.graph.clone();
                app.world_mut().despawn(entity);
                let replacement = app.world_mut().spawn((AnimationPlayer::default(), AnimationTransitions::new(),
                    AnimationGraphHandle(graph), EzrealRCastPose::default(), Actor { playback, role: "idle".into(),
                        previous_attack: 0, attack_until: 0, critical: false, presentation: None })).id();
                app.update(); assert!(app.world().get::<AnimationPlayer>(replacement).unwrap().animation(r).is_none()); continue;
            }
            match mode {
                2 => { app.insert_resource(crate::native_effect_clock::EffectClock::default()); },
                3 => app.world_mut().resource_mut::<Match>().snapshot = None,
                4 => { let mut hidden = snapshot.clone(); hidden.tick = 101; hidden.players.retain(|p| p.id != id); hidden.ezreal_r_casts.clear();
                    observe(&mut app, hidden, 0.12); },
                5 => {
                    let mut clip = AnimationClip::default(); clip.set_duration(5.);
                    let handle = app.world_mut().resource_mut::<Assets<AnimationClip>>().add(clip);
                    let mut replacement = AnimationGraph::new();
                    let mut nodes = Vec::new();
                    for _ in 0..8 { nodes.push(replacement.add_clip(handle.clone(), 1., replacement.root)); }
                    assert_eq!(nodes[5], r, "new graph really reuses the owned node index");
                    let graph = app.world_mut().resource_mut::<Assets<AnimationGraph>>().add(replacement);
                    app.world_mut().get_mut::<AnimationGraphHandle>(entity).unwrap().0 = graph;
                    let mut player = app.world_mut().get_mut::<AnimationPlayer>(entity).unwrap();
                    player.stop(r); player.play(r).set_seek_time(0.75).pause();
                },
                6 => { let mut changed = AnimationClip::default(); changed.set_duration(3.);
                    let handle = app.world_mut().resource_mut::<Assets<AnimationClip>>().add(changed);
                    app.world_mut().get_mut::<Actor>(entity).unwrap().playback.clips.insert("spell4".into(), handle); },
                _ => { app.world_mut().entity_mut(entity).remove::<AnimationGraphHandle>(); },
            }
            app.update();
            if mode == 5 || mode == 7 {
                let player = app.world().get::<AnimationPlayer>(entity).unwrap();
                if mode == 5 {
                    assert_eq!(player.animation(r).unwrap().seek_time(), 0.75, "foreign replacement graph's clip must survive");
                } else { assert!(player.animation(r).is_some(), "missing graph defers targeted retirement"); }
                assert!(player.animation(foreign).is_some());
                let pose = app.world().get::<EzrealRCastPose>(entity).unwrap();
                assert!(pose.active.is_some() && pose.retiring);
                let graph = app.world().get::<Actor>(entity).unwrap().playback.graph.clone();
                app.world_mut().entity_mut(entity).insert(AnimationGraphHandle(graph));
                app.update(); retired_only_r(&app, entity, r, foreign);
                publish(&mut app, snapshot.clone(), 0.12); retired_only_r(&app, entity, r, foreign);
            } else { retired_only_r(&app, entity, r, foreign); }
        }
    }
    #[test]
    fn received_batch_gap_and_q_conflict_do_not_reappear_on_the_first_render() {
        for q_conflict in [false, true] {
            let (mut app, _owner, mut game, id, entity, r, foreign) = fixture();
            let snapshot = cast(&mut game, id); observe(&mut app, snapshot.clone(), 0.1);
            let mut gap = snapshot.clone(); gap.tick = 101;
            if q_conflict {
                let (mut q_game, _) = crate::ezreal_r_cast_animation::test_support::game(); q_game.tick = 100;
                q_game.command(id, openleague_core::Action::CastAt { slot: 0, point: openleague_core::Point { x: 700., z: 100. } }).unwrap();
                gap.players.iter_mut().find(|p| p.id == id).unwrap().effects.ezreal_q = q_game.players[&id].effects.ezreal_q.clone();
            } else { gap.ezreal_r_casts.clear(); }
            observe(&mut app, gap, 0.11);
            let mut restored = snapshot.clone(); restored.tick = 102; observe(&mut app, restored, 0.12); app.update();
            retired_only_r(&app, entity, r, foreign);
            assert_ne!(app.world().get::<Actor>(entity).unwrap().role, "spell1");
        }
    }
    #[test]
    fn no_cast_or_role_name_alone_never_owns_or_stops_a_foreign_r_node() {
        let (mut app, _owner, _game, _id, entity, r, foreign) = fixture();
        app.world_mut().get_mut::<AnimationPlayer>(entity).unwrap().play(r).pause();
        app.world_mut().get_mut::<Actor>(entity).unwrap().role = "spell4".into();
        app.update();
        let player = app.world().get::<AnimationPlayer>(entity).unwrap();
        assert!(player.animation(r).is_some() && player.animation(foreign).is_some());
        assert!(app.world().get::<EzrealRCastPose>(entity).unwrap().active.is_none());
    }
    #[test]
    fn real_glb_canonical_spell4_loads_unchanged_and_drives_actual_player_at_unscaled_age() {
        use bevy::{asset::AssetApp, animation::AnimationPlugin,
            gltf::GltfPlugin, mesh::{MeshPlugin, skinning::SkinnedMeshInverseBindposes},
            transform::TransformPlugin, world_serialization::WorldSerializationPlugin};
        let root = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
        let mut loader = App::new();
        loader.add_plugins((MinimalPlugins, AssetPlugin { file_path: root.join("assets").to_str().unwrap().into(), ..default() },
            WorldSerializationPlugin, MeshPlugin, TransformPlugin, AnimationPlugin, GltfPlugin::default()))
            .init_asset::<Image>().init_asset::<SkinnedMeshInverseBindposes>();
        loader.finish(); loader.cleanup();
        let model: Handle<Gltf> = loader.world().resource::<AssetServer>().load(EZREAL_JOINT_IDENTITY_ASSET);
        let deadline = std::time::Instant::now() + std::time::Duration::from_secs(30);
        let handle = loop {
            loader.update();
            if let Some(gltf) = loader.world().resource::<Assets<Gltf>>().get(&model) {
                assert!(canonical_ezreal_r_clip(&Catalog::default(), gltf));
                let handle = gltf.animations[41].clone();
                if loader.world().resource::<Assets<AnimationClip>>().contains(&handle) { break handle; }
            }
            assert!(std::time::Instant::now() < deadline, "real Ezreal spell4 CPU load timed out");
            std::thread::sleep(std::time::Duration::from_millis(5));
        };
        let clip = loader.world_mut().resource_mut::<Assets<AnimationClip>>().remove(handle.id()).unwrap();
        assert_eq!(clip.curves().values().map(Vec::len).sum::<usize>(), 207);
        assert!((clip.duration() - 3.066666841506958).abs() < 0.000001);
        let (mut app, _owner, mut game, id, entity, r, _) = fixture_with_clip(clip);
        let snapshot = cast(&mut game, id); publish(&mut app, snapshot.clone(), 0.1); publish(&mut app, snapshot, 0.6);
        let active = app.world().get::<AnimationPlayer>(entity).unwrap().animation(r).unwrap();
        assert_eq!(active.seek_time(), 0.5); assert_eq!(active.speed(), 1.);
        // Actual loaded curves + host player only: no GPU pixels, bone-to-world
        // placement, native transition/clip timing or projectile origin claim.
    }
}
#[derive(Resource)]
pub struct Catalog(serde_json::Value);
impl Catalog {
    /// Local admission of the packaged restored base model. This does not
    /// manufacture a skin field or prove the native keyword selector. No Actor
    /// lookup is required when the caster body is hidden.
    pub(crate) fn r_sparks_base_model_selected(&self) -> bool {
        self.0.get("ezreal").and_then(|e|e.get("asset")).and_then(|v|v.as_str())
            == Some(EZREAL_JOINT_IDENTITY_ASSET)
    }
}
#[cfg(test)]
mod r_sparks_catalog_tests {
    use super::*;
    #[test]
    fn only_exact_restored_base_selection_is_admitted_without_any_actor() {
        let mut world=World::new(); world.insert_resource(Catalog::default());
        assert!(world.resource::<Catalog>().r_sparks_base_model_selected());
        // Bevy resources also occupy entities; the contract excludes Actor components.
        assert_eq!(world.query::<&Actor>().iter(&world).count(),0);
        world.resource_mut::<Catalog>().0["ezreal"]["asset"]=serde_json::json!("champions/ezreal.glb");
        assert!(!world.resource::<Catalog>().r_sparks_base_model_selected());
        world.resource_mut::<Catalog>().0["ezreal"].as_object_mut().unwrap().remove("asset");
        assert!(!world.resource::<Catalog>().r_sparks_base_model_selected());
    }
}

impl Default for Catalog {
    fn default() -> Self {
        let mut catalog: serde_json::Value =
            serde_json::from_str(include_str!("../../../data/4.20/animation_manifest.json"))
                .expect("verified champion animations");
        let world: serde_json::Value = serde_json::from_str(include_str!(
            "../../../data/4.20/world_animation_manifest.json"
        ))
        .expect("verified world animations");
        for (name, entry) in world.as_object().unwrap() {
            catalog
                .as_object_mut()
                .unwrap()
                .insert(name.clone(), entry.clone());
        }
        // Keep the packaged catalogue intact; select the separate local joint-identity
        // model through its asset field. Historical six-frame regression stays separate.
        catalog["ezreal"]["asset"] =
            serde_json::Value::String(EZREAL_JOINT_IDENTITY_ASSET.into());
        Self(catalog)
    }
}
#[derive(Component, Clone)]
pub struct Playback {
    id: u32,
    model_name: String,
    graph: Handle<AnimationGraph>,
    _model: Handle<Gltf>,
    roles: HashMap<String, AnimationNodeIndex>,
    clips: HashMap<String, Handle<AnimationClip>>,
    durations: HashMap<String, u64>,
}
impl Playback {
    pub fn model_asset_id(&self)->bevy::asset::AssetId<Gltf> {self._model.id()}
    pub fn network_id(&self)->u32 {self.id}
    pub fn model_name(&self)->&str {&self.model_name}
}
#[derive(Component)]
pub struct Actor {
    playback: Playback,
    role: String,
    previous_attack: u64,
    attack_until: u64,
    critical: bool,
    presentation: Option<(u64, openleague_core::attack_presentation::Kind)>,
}
#[derive(Component)]
pub struct ModelRequest {
    id: u32,
    name: String,
    model: Handle<Gltf>,
}
pub fn request(
    id: u32,
    name: &str,
    catalog: &Catalog,
    assets: &AssetServer,
) -> (ModelRequest, f32) {
    (
        ModelRequest {
            id,
            name: name.into(),
            model: assets.load(
                catalog.0[name]["asset"]
                    .as_str()
                    .map(str::to_owned)
                    .unwrap_or_else(|| format!("champions/{name}.glb")),
            ),
        },
        catalog.0[name]["scale"].as_f64().unwrap_or(1.) as f32,
    )
}
pub fn load_models(
    mut commands: Commands,
    models: Res<Assets<Gltf>>,
    catalog: Res<Catalog>,
    mut graphs: ResMut<Assets<AnimationGraph>>,
    requests: Query<(Entity, &ModelRequest)>,
) {
    for (entity, request) in &requests {
        let Some(model) = models.get(&request.model) else {
            continue;
        };
        let Some(scene) = model.scenes.first() else {
            continue;
        };
        // Build from handles supplied by the loaded parent GLTF. Loading each
        // labeled clip separately can repeatedly respawn the scene during loading.
        let (graph, indices) = AnimationGraph::from_clips(model.animations.clone());
        let mut roles: HashMap<String, AnimationNodeIndex> = catalog.0[&request.name]["roles"]
            .as_object()
            .unwrap()
            .iter()
            .filter_map(|(name, index)| {
                Some((name.clone(), *indices.get(index.as_u64()? as usize)?))
            })
            .collect();
        // Only the checked canonical GLTF clip may provide Ezreal's R role.
        if request.name == "ezreal" && !canonical_ezreal_r_clip(&catalog, model) {
            roles.remove("spell4");
        }
        if request.name == "ezreal" && !canonical_ezreal_w_clip(&catalog, model) {
            roles.remove("spell2");
        }
        if request.name == "ezreal" && !canonical_ezreal_e_clip(&catalog, model) {
            roles.remove("spell3");
        }
        let playback = Playback {
            id: request.id,
            model_name: request.name.clone(),
            graph: graphs.add(graph),
            _model: request.model.clone(),
            roles,
            clips: catalog.0[&request.name]["roles"].as_object().unwrap().iter()
                .filter_map(|(role,index)|Some((role.clone(),model.animations.get(index.as_u64()? as usize)?.clone())))
                .collect(),
            durations: catalog.0[&request.name]["duration_ticks"]
                .as_object()
                .map(|m| {
                    m.iter()
                        .filter_map(|(name, value)| Some((name.clone(), value.as_u64()?)))
                        .collect()
                })
                .unwrap_or_default(),
        };
        let visibility = if std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some()
            && std::env::var("OPENLEAGUE_PROBE_ENV_ONLY").as_deref() == Ok("1")
        {
            Visibility::Hidden
        } else {
            Visibility::Inherited
        };
        commands
            .entity(entity)
            .insert((WorldAssetRoot(scene.clone()), playback, visibility, crate::actor_fow::Root))
            .remove::<ModelRequest>()
            .observe(ready);
    }
}
pub fn ready(
    event: On<WorldInstanceReady>,
    mut commands: Commands,
    children: Query<&Children>,
    roots: Query<&Playback>,
    mut players: Query<&mut AnimationPlayer>,
) {
    let Ok(playback) = roots.get(event.entity) else {
        return;
    };
    if crate::nexus_idle_particles::supports_model(playback.model_name()) {
        commands.entity(event.entity).insert(crate::nexus_idle_particles::ModelReady);
    }
    for child in children.iter_descendants(event.entity) {
        if let Ok(mut player) = players.get_mut(child) {
            println!(
                "OpenLeague animation graph attached: player {} / {} verified roles",
                playback.id,
                playback.roles.len()
            );
            let mut transitions = AnimationTransitions::new();
            let mut role = String::new();
            if let Some(index) = playback.roles.get("idle") {
                let active=transitions.play(&mut player,*index,std::time::Duration::ZERO);
                if !crate::structure_animation_clock::configure(&playback.model_name,"idle",active) {active.repeat();}
                role = "idle".into();
            }
            commands.entity(child).insert((
                AnimationGraphHandle(playback.graph.clone()),
                transitions,
                EzrealRCastPose::default(),
                EzrealWCastPose::default(),
                EzrealECastPose::default(),
                Actor {
                    playback: playback.clone(),
                    role,
                    previous_attack: 0,
                    attack_until: 0,
                    critical: false,
                    presentation: None,
                },
            ));
        }
    }
}
pub fn animate(
    mut state: ResMut<Match>,
    connection: Option<Res<crate::Connection>>,
    clock: Res<crate::native_effect_clock::EffectClock>,
    clips: Res<Assets<AnimationClip>>,
    mut actors: Query<(Entity, &mut AnimationPlayer, &mut AnimationTransitions, &mut Actor,
        Option<&AnimationGraphHandle>, Option<&mut EzrealRCastPose>, Option<&mut EzrealWCastPose>, Option<&mut EzrealECastPose>)>,
) {
    // Explicit field borrows keep the new W state independent of attack journals.
    let state=&mut *state;
    let w_ready = connection.as_ref().is_some_and(|c| c.ready()) && clock.presentation_ready();
    if !w_ready { state.ezreal_w_cast_visuals.suspend(); state.ezreal_e_cast_visuals.suspend(); }
    let Some(snapshot) = &state.snapshot else {
        state.ezreal_q_cast_visuals.suspend();
        state.ezreal_r_cast_visuals.suspend();
        state.ezreal_w_cast_visuals.suspend();
        state.ezreal_e_cast_visuals.suspend();
        for (_,mut player,_,actor,graph,mut r_pose,mut w_pose,mut e_pose) in &mut actors {
            stop_ezreal_e_pose(&mut player, e_pose.as_deref_mut(), graph.map(|graph| graph.0.id()));
            stop_ezreal_w_pose(&mut player, w_pose.as_deref_mut(), graph.map(|graph| graph.0.id()));
            stop_ezreal_r_pose(&mut player, r_pose.as_deref_mut(), graph.map(|graph| graph.0.id()));
            stop_ezreal_q_on_exit(&mut player,&actor.playback.model_name,&actor.role,
                false,actor.playback.roles.get("spell1").copied());
        }
        return;
    };
    for (entity, mut player, mut transitions, mut actor, graph, mut r_pose, mut w_pose, mut e_pose) in &mut actors {
        if e_pose.as_ref().is_some_and(|pose| pose.retiring) {
            stop_ezreal_e_pose(&mut player, e_pose.as_deref_mut(), graph.map(|graph| graph.0.id()));
        }
        if r_pose.as_ref().is_some_and(|pose| pose.retiring) {
            stop_ezreal_r_pose(&mut player, r_pose.as_deref_mut(), graph.map(|graph| graph.0.id()));
        }
        if let Some(altar) = snapshot
            .map10
            .as_ref()
            .and_then(|m| m.altars.iter().find(|a| a.id == actor.playback.id))
        {
            let captured = altar.captured_tick.is_some_and(|tick| {
                snapshot.tick
                    < tick
                        + actor
                            .playback
                            .durations
                            .get("capture")
                            .copied()
                            .unwrap_or(1)
            });
            let role = if captured {
                "capture"
            } else if altar.capturing.is_some() {
                "idle"
            } else if snapshot.tick < altar.locked_until {
                "locked"
            } else if snapshot.tick
                < altar.locked_until + actor.playback.durations.get("unlock").copied().unwrap_or(1)
            {
                "unlock"
            } else {
                "idle"
            };
            if actor.role != role {
                if let Some(index) = actor.playback.roles.get(role).copied() {
                    let active =
                        transitions.play(&mut player, index, std::time::Duration::from_millis(80));
                    if role == "idle" || role == "locked" {
                        active.repeat();
                    }
                    actor.role = role.to_string();
                }
            }
            continue;
        }
        let actor_state =
            if let Some(champion) = snapshot.players.iter().find(|p| p.id == actor.playback.id) {
                Some((
                    champion.health,
                    champion.next_attack,
                    openleague_core::trundle_e::champion_forced(champion,snapshot.tick),
                    champion.destination.is_some() && champion.effects.annie_q.is_none() && champion.effects.annie_w.is_none() && champion.effects.annie_r.is_none() && !openleague_core::stuns::active(champion,snapshot.tick),
                    champion.effects.ultimate.is_some(),
                    snapshot.tick < champion.effects.spin_until,
                    champion.windup.as_ref().map(|w| w.critical),
                    true,
                    openleague_core::stuns::active(champion,snapshot.tick),
                    if champion.effects.annie_q.is_some() {Some("spell1")} else if champion.effects.annie_w.is_some() {Some("spell2")} else if champion.effects.annie_r.is_some() {Some("spell4")} else {None},
                ))
            } else {
                snapshot
                    .units
                    .iter()
                    .find(|u| u.id == actor.playback.id)
                    .map(|u| {
                        (
                            u.health,
                            u.next_attack,
                            openleague_core::trundle_e::unit_forced(u,snapshot.tick),
                            u.destination.is_some() && !openleague_core::stuns::unit_active(u,snapshot.tick),
                            false,
                            false,
                            None,
                            false,
                            openleague_core::stuns::unit_active(u,snapshot.tick),
                            if !openleague_core::stuns::unit_active(u,snapshot.tick) && u.pet.as_ref().is_some_and(|pet|snapshot.tick<pet.spawned+actor.playback.durations.get("spawn").copied().unwrap_or(0)) {Some("spawn")} else {None},
                        )
                    })
            };
        let Some((health, next_attack, forced, moving, ultimate, spin, critical, champion, stunned, cast_role)) = actor_state else {
            // Retire only this canonical Q channel even if the scene is still
            // present during FoW fade. Other champion/structure paths keep their behavior.
            if actor.playback.model_name=="ezreal" {
                state.ezreal_q_cast_visuals.retire(actor.playback.id);
                state.ezreal_r_cast_visuals.retire(actor.playback.id);
                state.ezreal_w_cast_visuals.retire(actor.playback.id);
                state.ezreal_e_cast_visuals.retire(actor.playback.id);
                stop_ezreal_q_on_exit(&mut player,&actor.playback.model_name,&actor.role,
                    false,actor.playback.roles.get("spell1").copied());
            }
            stop_ezreal_r_pose(&mut player, r_pose.as_deref_mut(), graph.map(|graph| graph.0.id()));
            stop_ezreal_w_pose(&mut player, w_pose.as_deref_mut(), graph.map(|graph| graph.0.id()));
            stop_ezreal_e_pose(&mut player, e_pose.as_deref_mut(), graph.map(|graph| graph.0.id()));
            continue;
        };
        let identity_champion = champion && openleague_core::attacks::supports_champion_presentation(&actor.playback.model_name);
        // A canonical model stays identity-driven even on a mismatched fixture:
        // never manufacture an attack from that source's cooldown deadline.
        let matching_champion = identity_champion && snapshot.players.iter().any(|source|
            source.id == actor.playback.id && source.champion == actor.playback.model_name);
        let garen = matching_champion && actor.playback.model_name == "garen";
        let vilemaw = !champion && actor.playback.model_name == openleague_core::vilemaw_attacks::DEFINITION
            && snapshot.units.iter().any(|unit| unit.id == actor.playback.id && openleague_core::vilemaw_attacks::is_vilemaw(unit));
        let identity_driven = identity_champion || vilemaw;
        let mut presentation = if matching_champion {
            let duration = if garen { openleague_core::garen_q_resource::binding().ok()
                .and_then(|binding| actor.playback.clips.get(binding.presentation_role()))
                .and_then(|handle| clips.get(handle)).map(AnimationClip::duration) }
                else if actor.playback.model_name=="trundle" {
                    actor.playback.clips.get("spell1").and_then(|handle|clips.get(handle)).map(AnimationClip::duration)
                } else { None };
            state.attack_visuals.selection(actor.playback.id, clock.now, duration)
        } else if vilemaw {
            let duration = actor.playback.clips.get("attack")
                .and_then(|handle| clips.get(handle)).map(AnimationClip::duration);
            state.vilemaw_visuals.selection(actor.playback.id, clock.now, duration)
                .map(|selected| crate::attack_animation::Selection { attack:selected.attack, kind:selected.kind,
                    role:selected.role, started:selected.started, age_seconds:selected.age_seconds })
        } else { None };
        // Missing champion crit roles use the existing attack clip while keeping
        // the exact critical identity and age. The boss channel is independent.
        if identity_champion && !actor.playback.roles.contains_key("crit") {
            if let Some(selected) = presentation.as_mut().filter(|selected| selected.role == "crit") { selected.role = "attack"; }
        }
        let presentation_key = presentation.as_ref().map(|p|(p.attack,p.kind));
        let new_attack = if identity_driven { presentation_key.is_some() && presentation_key != actor.presentation }
            else { next_attack > actor.previous_attack };
        if !identity_driven && new_attack {
            actor.previous_attack = next_attack;
            actor.attack_until = snapshot.tick + 12;
            actor.critical = critical.unwrap_or(false);
        }
        if !identity_driven { if let Some(value) = critical {
            actor.critical = value;
        } }
        if champion && critical.is_none() && next_attack <= snapshot.tick {
            actor.attack_until = 0;
        }
        if forced || stunned || identity_driven { actor.attack_until = 0; }
        let trundle=matching_champion && actor.playback.model_name=="trundle";
        let windup=snapshot.players.iter().find(|source|source.id==actor.playback.id)
            .is_some_and(|source|source.windup.is_some());
        // R preserves gameplay movement: its one-shot may glide while the
        // accepted destination remains unchanged. Only W needs the idle gate.
        let r_eligible=health.is_finite() && health>0. && !forced && !stunned && !ultimate && !spin && cast_role.is_none();
        let ordinary=r_eligible && !moving;
        let w_idle=ordinary && !windup && presentation.is_none();
        let duration_for=|role:&str|actor.playback.clips.get(role).and_then(|handle|clips.get(handle))
            .filter(|_|actor.playback.roles.contains_key(role)).map(AnimationClip::duration);
        let ezreal=champion && actor.playback.model_name=="ezreal"
            && snapshot.players.iter().any(|source|source.id==actor.playback.id && source.champion=="ezreal");
        let e_cast_present = snapshot.ezreal_e_casts.iter().any(|cast| cast.owner == actor.playback.id);
        let r_cast_present = snapshot.ezreal_r_casts.iter().any(|cast| cast.owner == actor.playback.id);
        let source = snapshot.players.iter().find(|source| source.id == actor.playback.id);
        let r_source_eligible = source.is_some_and(|source| snapshot.tick >= source.effects.silence_until
            && source.effects.ezreal_q.is_none() && source.effects.ezreal_w.is_none());
        let r_binding = actor.playback.roles.get("spell4").copied()
            .zip(actor.playback.clips.get("spell4").map(Handle::id));
        let graph_matches = graph.is_some_and(|graph| graph.0.id() == actor.playback.graph.id());
        if r_pose.as_ref().and_then(|pose| pose.active.as_ref()).is_some_and(|owned|
            !graph_matches || r_binding != Some((owned.node, owned.clip))
                || actor.playback.graph.id() != owned.graph || actor.playback._model.id() != owned.model) {
            state.ezreal_r_cast_visuals.retire(actor.playback.id);
        }
        let ezreal_r_selection = if ezreal {
            state.ezreal_r_cast_visuals.select(actor.playback.id, entity.to_bits(), clock.now,
                duration_for("spell4"), r_eligible && !windup && r_source_eligible && !e_cast_present
                    && r_pose.as_ref().is_some_and(|pose| !pose.retiring) && graph_matches, clock.presentation_ready())
        } else { state.ezreal_r_cast_visuals.retire(actor.playback.id); None };
        let w_cast_present = snapshot.ezreal_w_casts.iter().any(|cast| cast.owner == actor.playback.id);
        let w_binding = actor.playback.roles.get("spell2").copied()
            .zip(actor.playback.clips.get("spell2").map(Handle::id));
        if w_pose.as_ref().and_then(|pose| pose.active.as_ref()).is_some_and(|owned|
            !graph_matches || w_binding != Some((owned.node, owned.clip))
                || actor.playback.graph.id() != owned.graph || actor.playback._model.id() != owned.model) {
            state.ezreal_w_cast_visuals.retire(actor.playback.id);
        }
        // Existing committed W may finish under later CC; its body still follows
        // authoritative position. This never changes gameplay or facing.
        let ezreal_w_selection = if ezreal {
            state.ezreal_w_cast_visuals.select(actor.playback.id, entity.to_bits(), clock.now,
                duration_for("spell2"), health.is_finite() && health > 0. && !ultimate && !spin
                    && cast_role.is_none() && !windup && !r_cast_present && !e_cast_present
                    && source.is_some_and(|source| source.effects.ezreal_q.is_none())
                    && w_pose.as_ref().is_some_and(|pose| !pose.retiring) && graph_matches, w_ready)
        } else { state.ezreal_w_cast_visuals.retire(actor.playback.id); None };

        let e_binding = actor.playback.roles.get("spell3").copied()
            .zip(actor.playback.clips.get("spell3").map(Handle::id));
        if e_pose.as_ref().and_then(|pose| pose.active.as_ref()).is_some_and(|owned|
            !graph_matches || e_binding != Some((owned.node, owned.clip))
                || actor.playback.graph.id() != owned.graph || actor.playback._model.id() != owned.model) {
            state.ezreal_e_cast_visuals.retire(actor.playback.id);
        }
        let ezreal_e_selection = if ezreal {
            state.ezreal_e_cast_visuals.select(actor.playback.id, entity.to_bits(), clock.now,
                duration_for("spell3"), r_eligible && !windup && r_source_eligible
                    && !r_cast_present && !w_cast_present
                    && e_pose.as_ref().is_some_and(|pose| !pose.retiring) && graph_matches, w_ready)
        } else { state.ezreal_e_cast_visuals.retire(actor.playback.id); None };

        let q_selection=if ezreal {
            state.ezreal_q_cast_visuals.select(actor.playback.id,entity.to_bits(),clock.now,
                duration_for("spell1"),r_eligible && !windup && !r_cast_present && !w_cast_present && !e_cast_present,clock.presentation_ready())
        } else {None};
        let journal_supported=trundle && state.trundle_cast_visuals.supported();
        let cast_selection=if journal_supported {
            // Legacy Zone state cannot recreate a W pose after journal mode.
            state.trundle_w_visuals.retire(actor.playback.id);
            state.trundle_cast_visuals.select(actor.playback.id,entity.to_bits(),clock.now,
                [duration_for("spell2"),duration_for("spell4")],[w_idle,r_eligible],clock.presentation_ready())
        } else {None};
        let legacy_w=if trundle && !journal_supported {
            state.trundle_w_visuals.select(actor.playback.id,entity.to_bits(),clock.now,duration_for("spell2"),w_idle,clock.presentation_ready())
        } else {None};
        let w_selection=cast_selection.filter(|selected|selected.kind==openleague_core::accepted_cast_presentation::Kind::W)
            .map(|selected|CastSeek{age_seconds:selected.age_seconds,first:selected.first})
            .or_else(||legacy_w.map(|selected|CastSeek{age_seconds:selected.age_seconds,first:selected.first}));
        let r_selection=cast_selection.filter(|selected|selected.kind==openleague_core::accepted_cast_presentation::Kind::R)
            .map(|selected|CastSeek{age_seconds:selected.age_seconds,first:selected.first});
        let role = if crate::nexus_ceremony::holds_default_idle(actor.playback.id,snapshot.result.as_ref()) {
            "idle"
        } else if health <= 0. {
            "death"
        } else if ezreal_w_selection.is_some() {
            "spell2"
        } else if forced {
            // Authoritative CANCEL_ORDER leaves destination empty during a push.
            // Use its real received motion state; never manufacture a move or stun.
            "run"
        } else if ultimate {
            "spell4"
        } else if spin {
            "spell3"
        } else if let Some(role)=cast_role {role
        } else if stunned {
            if actor.playback.roles.contains_key("stun") { "stun" } else { "idle" }
        } else if ezreal_e_selection.is_some() {
            "spell3"
        } else if ezreal_r_selection.is_some() {
            "spell4"
        } else if q_selection.is_some() {
            "spell1"
        } else if vilemaw && moving {
            // The verified boss catalog has no run role today. Do not retain
            // an attack merely because that missing role cannot be played.
            if actor.playback.roles.contains_key("run") { "run" } else { "idle" }
        } else if r_selection.is_some() {
            "spell4"
        } else if w_selection.is_some() {
            "spell2"
        } else if identity_driven {
            presentation.as_ref().map(|p|p.role).unwrap_or(if moving { "run" } else { "idle" })
        } else if critical.is_some() || snapshot.tick < actor.attack_until {
            if actor.critical && actor.playback.roles.contains_key("crit") {
                "crit"
            } else {
                "attack"
            }
        } else if moving {
            "run"
        } else {
            "idle"
        };
        stop_trundle_w_on_exit(&mut player,&actor.playback.model_name,&actor.role,
            w_selection.is_some(),actor.playback.roles.get("spell2").copied());
        stop_trundle_r_on_exit(&mut player,&actor.playback.model_name,&actor.role,
            r_selection.is_some(),actor.playback.roles.get("spell4").copied());
        stop_ezreal_q_on_exit(&mut player,&actor.playback.model_name,&actor.role,
            q_selection.is_some(),actor.playback.roles.get("spell1").copied());
        let keep_e = role == "spell3" && ezreal_e_selection.is_some();
        if !keep_e || e_pose.as_ref().and_then(|pose| pose.active.as_ref()).is_some_and(|owned|
            ezreal_e_selection.is_some_and(|selection| selection.identity != owned.identity)) {
            stop_ezreal_e_pose(&mut player, e_pose.as_deref_mut(), graph.map(|graph| graph.0.id()));
        }
        let keep_w = role == "spell2" && ezreal_w_selection.is_some();
        if !keep_w || w_pose.as_ref().and_then(|pose| pose.active.as_ref()).is_some_and(|owned|
            ezreal_w_selection.is_some_and(|selection| selection.identity != owned.identity)) {
            stop_ezreal_w_pose(&mut player, w_pose.as_deref_mut(), graph.map(|graph| graph.0.id()));
        }
        let keep_r = role == "spell4" && ezreal_r_selection.is_some();
        if !keep_r || r_pose.as_ref().and_then(|pose| pose.active.as_ref()).is_some_and(|owned|
            ezreal_r_selection.is_some_and(|selection| selection.identity != owned.identity)) {
            stop_ezreal_r_pose(&mut player, r_pose.as_deref_mut(), graph.map(|graph| graph.0.id()));
        }
        let Some(index) = actor.playback.roles.get(role).copied() else {
            continue;
        };
        actor.presentation = if presentation.as_ref().is_some_and(|p|p.role==role) {presentation_key} else {None};
        let starts_selected_attack = new_attack && (!identity_driven || presentation.as_ref().is_some_and(|p|p.role==role));
        let starts_selected_w=role=="spell2" && (w_selection.as_ref().is_some_and(|selected|selected.first)
            || ezreal_w_selection.as_ref().is_some_and(|selected|selected.first));
        let starts_selected_r=role=="spell4" && (r_selection.as_ref().is_some_and(|selected|selected.first)
            || ezreal_r_selection.as_ref().is_some_and(|selected|selected.first));
        let starts_selected_e=role=="spell3" && ezreal_e_selection.as_ref().is_some_and(|selected|selected.first);
        let starts_selected_q=role=="spell1" && q_selection.as_ref().is_some_and(|selected|selected.first);
        if actor.role == role && !starts_selected_attack && !starts_selected_w && !starts_selected_r && !starts_selected_q && !starts_selected_e {
            if role=="spell1" {
                if let Some(selected)=q_selection {
                    if !hold_trundle_w_pose(&mut player,index,selected.age_seconds) {state.ezreal_q_cast_visuals.retire(actor.playback.id);}
                }
            } else if role=="spell2" {
                if let Some(selected)=ezreal_w_selection {
                    if !hold_trundle_w_pose(&mut player,index,selected.age_seconds) {
                        state.ezreal_w_cast_visuals.retire(actor.playback.id);
                        stop_ezreal_w_pose(&mut player,w_pose.as_deref_mut(),graph.map(|graph|graph.0.id()));
                    }
                } else if let Some(selected)=w_selection {
                    if !hold_trundle_w_pose(&mut player,index,selected.age_seconds) {
                        state.trundle_w_visuals.retire(actor.playback.id);
                        state.trundle_cast_visuals.retire(actor.playback.id);
                    }
                }
            } else if role=="spell3" {
                if let Some(selected)=ezreal_e_selection {
                    if !hold_trundle_w_pose(&mut player,index,selected.age_seconds) {
                        state.ezreal_e_cast_visuals.retire(actor.playback.id);
                        stop_ezreal_e_pose(&mut player,e_pose.as_deref_mut(),graph.map(|graph|graph.0.id()));
                    }
                }
            } else if role=="spell4" {
                if let Some(selected) = ezreal_r_selection {
                    if !hold_trundle_w_pose(&mut player, index, selected.age_seconds) {
                        state.ezreal_r_cast_visuals.retire(actor.playback.id);
                        stop_ezreal_r_pose(&mut player, r_pose.as_deref_mut(), graph.map(|graph| graph.0.id()));
                    }
                } else if let Some(selected)=r_selection {
                    if !hold_trundle_w_pose(&mut player,index,selected.age_seconds) {state.trundle_cast_visuals.retire(actor.playback.id);}
                }
            }
            continue;
        }
        let active = transitions.play(&mut player, index, std::time::Duration::from_millis(80));
        if let Some(presentation) = presentation.as_ref().filter(|p|p.role==role) {
            // Start at the already-observed age without retroactively firing
            // clip events. Loaded Q/Vilemaw durations are not gameplay impact times.
            active.set_seek_time(presentation.age_seconds);
        } else if role=="spell1" && q_selection.is_some() {
            // The clip is sampled only at EffectClock age; Bevy must not also
            // advance it or emit retroactive animation events on this seek.
            if let Some(selected)=q_selection {active.set_seek_time(selected.age_seconds);active.pause();}
        } else if role=="spell2" {
            if let Some(selected)=ezreal_w_selection {active.set_seek_time(selected.age_seconds);active.pause();}
            else if let Some(selected)=w_selection {active.set_seek_time(selected.age_seconds);active.pause();}
        } else if role=="spell3" && ezreal_e_selection.is_some() {
            if let Some(selected)=ezreal_e_selection {active.set_seek_time(selected.age_seconds);active.pause();}
        } else if role=="spell4" {
            if let Some(selected) = ezreal_r_selection { active.set_seek_time(selected.age_seconds); active.pause(); }
            else if let Some(selected)=r_selection {active.set_seek_time(selected.age_seconds);active.pause();}
        }
        if !crate::structure_animation_clock::configure(&actor.playback.model_name,role,active)
            && ["idle", "run", "spell3"].contains(&role) && ezreal_e_selection.is_none() {active.repeat();}
        if let (Some(selected), Some(pose), Some((node, clip))) =
            (ezreal_r_selection.filter(|_| role == "spell4"), r_pose.as_deref_mut(), r_binding) {
            pose.active = Some(OwnedEzrealR { identity: selected.identity, node, clip,
                graph: actor.playback.graph.id(), model: actor.playback._model.id() });
        }
        if let (Some(selected), Some(pose), Some((node, clip))) =
            (ezreal_w_selection.filter(|_| role == "spell2"), w_pose.as_deref_mut(), w_binding) {
            pose.active = Some(OwnedEzrealW { identity: selected.identity, node, clip,
                graph: actor.playback.graph.id(), model: actor.playback._model.id() });
        }
        if let (Some(selected), Some(pose), Some((node, clip))) =
            (ezreal_e_selection.filter(|_| role == "spell3"), e_pose.as_deref_mut(), e_binding) {
            pose.active = Some(OwnedEzrealE { identity: selected.identity, node, clip,
                graph: actor.playback.graph.id(), model: actor.playback._model.id() });
        }
        actor.role = role.into();
    }
}

#[derive(Clone,Copy)]
struct CastSeek {age_seconds:f32,first:bool}

// Only the outgoing canonical Ezreal Q node is owned by this channel.
// Remove it even when the next role is unavailable; never stop_all/resume_all.
fn stop_ezreal_q_on_exit(player:&mut AnimationPlayer,model:&str,previous_role:&str,
    q_selected:bool,q_index:Option<AnimationNodeIndex>) {
    if model=="ezreal" && previous_role=="spell1" && !q_selected {
        if let Some(index)=q_index {player.stop(index);}
    }
}

fn stop_trundle_r_on_exit(player:&mut AnimationPlayer,model:&str,previous_role:&str,
    r_selected:bool,r_index:Option<AnimationNodeIndex>) {
    if model=="trundle" && previous_role=="spell4" && !r_selected {
        if let Some(index)=r_index {player.stop(index);}
    }
}

/// Paused clips are deliberately not faded by AnimationTransitions::play.
/// Remove exactly the outgoing W clip before any other role is selected, even
/// if that role is absent. Never stop/resume another actor, role or attack.
fn stop_trundle_w_on_exit(player:&mut AnimationPlayer,model:&str,previous_role:&str,
    w_selected:bool,w_index:Option<AnimationNodeIndex>) {
    if model=="trundle" && previous_role=="spell2" && !w_selected {
        if let Some(index)=w_index {player.stop(index);}
    }
}

/// Only the W pose is held at its EffectClock-derived age. This applies newer
/// received tick corrections too; no global clock or other role is paused.
fn hold_trundle_w_pose(player:&mut AnimationPlayer,index:AnimationNodeIndex,age:f32)->bool {
    let Some(active)=player.animation_mut(index) else {return false;};
    active.set_seek_time(age);active.pause();true
}

/// Optional observation of actual AnimationPlayers; never alters gameplay or playback.
pub fn destruction_probe(time: Res<Time>, state: Res<Match>, actors: Query<(Entity, &AnimationPlayer, &Actor)>, children: Query<&Children>, joints: Query<(&Name,&Transform)>, mut last: Local<f32>) {
    let Ok(path)=std::env::var("OPENLEAGUE_DESTRUCTION_ANIMATION_PROBE") else {return;};
    if time.elapsed_secs()-*last<0.2 {return;}
    *last=time.elapsed_secs();
    let rows:Vec<_>=actors.iter().filter(|(_,_,a)|a.playback.model_name.contains("Turret")||a.playback.model_name.contains("Inhibitor")||a.playback.model_name.contains("Nexus")).map(|(entity,player,actor)| {
        let clips:Vec<_>=player.playing_animations().map(|(_,a)|serde_json::json!({"elapsed":a.elapsed(),"seek_time":a.seek_time(),"completions":a.completions(),"finished":a.is_finished()})).collect();
        let pose:Vec<_>=children.iter_descendants(entity).filter_map(|e|joints.get(e).ok()).map(|(name,t)|serde_json::json!({"name":name.as_str(),"translation":t.translation.to_array(),"rotation":t.rotation.to_array(),"scale":t.scale.to_array()})).collect();
        serde_json::json!({"id":actor.playback.id,"model":actor.playback.model_name,"role":actor.role,"active_clips":clips,"joint_pose":pose})
    }).collect();
    if rows.is_empty() {return;}
    let record=serde_json::json!({"time":time.elapsed_secs(),"tick":state.snapshot.as_ref().map(|s|s.tick),"actors":rows});
    use std::io::Write;
    if let Ok(mut file)=std::fs::OpenOptions::new().create(true).append(true).open(path) {let _=writeln!(file,"{record}");}
}

pub fn synchronize_finished_structure_clocks(mut actors:Query<(&mut AnimationPlayer,&Actor)>) {
 for (mut player,actor) in &mut actors {
  for (_,active) in player.playing_animations_mut() {
   crate::structure_animation_clock::clamp_finished(&actor.playback.model_name,&actor.role,active);
  }
 }
}

/// Opt-in observation of actual Garen AnimationPlayers; never changes input or playback.
pub fn garen_attack_probe(time:Res<Time>,clock:Res<crate::native_effect_clock::EffectClock>,state:Res<Match>,catalog:Res<Catalog>,actors:Query<(&AnimationPlayer,&Actor)>,roots:Query<&Transform,With<crate::actor_fow::Root>>,mut previous:Local<f64>) {
    let Ok(path)=std::env::var("OPENLEAGUE_GAREN_ATTACK_PROBE") else{return;};
    let now=time.elapsed_secs_f64();if now-*previous<0.025{return;}*previous=now;
    let Some(snapshot)=&state.snapshot else{return;};
    let rows:Vec<_>=actors.iter().filter(|(_,a)|a.playback.model_name=="garen").map(|(player,actor)| {
        let root=state.visuals.get(&actor.playback.id).and_then(|entity|roots.get(*entity).ok());
        let state=snapshot.players.iter().find(|p|p.id==actor.playback.id);
        let clips:Vec<_>=player.playing_animations().map(|(index,active)|serde_json::json!({"graph_node":index.index(),"seek_time":active.seek_time(),"elapsed":active.elapsed(),"finished":active.is_finished()})).collect();
        serde_json::json!({"source":actor.playback.id,"role":actor.role,"clip":catalog.0["garen"]["roles"][&actor.role],"presentation":actor.presentation.map(|(id,kind)|serde_json::json!({"attack":id,"kind":kind})),"windup":state.and_then(|p|p.windup.as_ref()),"empowered_until":state.map(|p|p.effects.empowered_until),"position_native":state.map(|p|p.position),"facing_native":state.and_then(|p|p.facing),"root_rotation":root.map(|t|t.rotation.to_array()),"render_forward":root.map(|t|(t.rotation*Vec3::Z).to_array()),"clips":clips})
    }).collect();
    if rows.is_empty(){return;}
    let record=serde_json::json!({"session":snapshot.session,"tick":snapshot.tick,"wall_time":now,"presentation_clock":clock.diagnostic(),"error":state.attack_visuals.error(),"q_resource_contract":openleague_core::garen_q_resource::binding().map(|binding|binding.diagnostic()).map_err(str::to_owned),"actors":rows});
    use std::io::Write;
    if let Ok(mut file)=std::fs::OpenOptions::new().create(true).append(true).open(path){let _=writeln!(file,"{record}");}
}

#[cfg(test)] mod attack_binding_tests {
    use super::*;
    use openleague_core::{attack_presentation::{State as Events,Kind,Audience,CancelReason},attacks::Windup};

    fn fixture()->(App,openleague_core::Simulation,u32,u32,Entity) {
        let mut cells=Vec::new();for _ in 0..400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
        let nav=openleague_core::Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap();
        let mut game=openleague_core::Simulation::new(nav).unwrap();game.session=7;
        let id=game.join("garen").unwrap();let target=game.join("garen").unwrap();
        let mut assets=Assets::<AnimationClip>::default();let mut q=AnimationClip::default();q.set_duration(1.);let q=assets.add(q);
        let roles=HashMap::from([("idle".into(),AnimationNodeIndex::new(0)),("spell1".into(),AnimationNodeIndex::new(1)),("attack".into(),AnimationNodeIndex::new(2)),("crit".into(),AnimationNodeIndex::new(3))]);
        let playback=Playback{id,model_name:"garen".into(),graph:Handle::default(),_model:Handle::default(),roles,clips:HashMap::from([("spell1".into(),q)]),durations:HashMap::new()};
        let mut state=Match::default();state.attack_visuals.reset(7);let snapshot=game.snapshot();state.attack_visuals.observe(&snapshot,0.).unwrap();state.snapshot=Some(snapshot);
        let mut app=App::new();app.init_resource::<Time>().init_resource::<crate::native_effect_clock::EffectClock>().insert_resource(assets).insert_resource(state).add_systems(Update,animate);
        let entity=app.world_mut().spawn((AnimationPlayer::default(),AnimationTransitions::new(),Actor{playback,role:"idle".into(),previous_attack:0,attack_until:0,critical:false,presentation:None})).id();
        (app,game,id,target,entity)
    }
    fn publish(app:&mut App,game:&openleague_core::Simulation,events:&Events,now:f64) {
        app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().now=now;
        let mut snapshot=game.snapshot();snapshot.attack_events=events.events();
        let mut state=app.world_mut().resource_mut::<Match>();state.attack_visuals.observe(&snapshot,now).unwrap();state.snapshot=Some(snapshot);
        app.update();
    }
    #[test] fn actual_player_does_not_restart_at_resolution_and_new_same_role_attack_restarts_at_age() {
        let (mut app,mut game,id,target,entity)=fixture();let mut events=Events::default();let audience=Audience::from_visibility(true,true);
        let attack=events.begin(id,1,4,Kind::GarenQ,audience).unwrap();game.tick=2;
        game.players.get_mut(&id).unwrap().windup=Some(Windup{target,started:1,release:4,cancelable:true,critical:false,presentation:Some(attack)});
        publish(&mut app,&game,&events,0.1);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"spell1");
        let index=AnimationNodeIndex::new(1);
        assert!((app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time()-1./30.).abs()<0.0001);
        app.world_mut().get_mut::<AnimationPlayer>(entity).unwrap().animation_mut(index).unwrap().set_seek_time(0.15);
        events.resolve(attack,4,Kind::GarenQ,true,audience).unwrap();game.tick=4;game.players.get_mut(&id).unwrap().windup=None;
        publish(&mut app,&game,&events,0.2);
        assert_eq!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time(),0.15);
        let next=events.begin(id,50,54,Kind::GarenQ,audience).unwrap();game.tick=51;
        game.players.get_mut(&id).unwrap().windup=Some(Windup{target,started:50,release:54,cancelable:true,critical:false,presentation:Some(next)});
        publish(&mut app,&game,&events,1.7);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().presentation,Some((next.id,Kind::GarenQ)));
        assert!((app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time()-1./30.).abs()<0.0001);
        events.cancel(next,52,CancelReason::Order,audience).unwrap();game.tick=52;
        let player=game.players.get_mut(&id).unwrap();player.windup=None;player.next_attack=99;
        publish(&mut app,&game,&events,1.74);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"idle");
        assert_eq!(app.world().get::<Actor>(entity).unwrap().presentation,None);
    }
    #[test] fn catalog_garen_roles_reference_the_audited_native_clips() {
        let q = openleague_core::garen_q_resource::binding().unwrap();
        assert_eq!((q.resource_name(),q.animation_name(),q.presentation_role()),("GarenQAttack","Spell1","spell1"));
        let catalog=Catalog::default();let garen=&catalog.0["garen"];
        for (role,index,name) in [("spell1",23,"Garen_2013_spell1"),("attack",0,"Garen_2013_Attack_01"),("crit",4,"Garen_2013_Crit")] {
            assert_eq!(garen["roles"][role].as_u64(),Some(index));assert_eq!(garen["clips"][index as usize].as_str(),Some(name));
        }
    }
    #[test] fn host_time_does_not_expire_an_attack_while_presentation_clock_is_held() {
        let (mut app,mut game,id,target,entity)=fixture();let mut events=Events::default();
        let attack=events.begin(id,1,4,Kind::GarenQ,Audience::from_visibility(true,true)).unwrap();game.tick=2;
        game.players.get_mut(&id).unwrap().windup=Some(Windup{target,started:1,release:4,cancelable:true,critical:false,presentation:Some(attack)});
        publish(&mut app,&game,&events,0.1);
        app.world_mut().resource_mut::<Time>().advance_by(std::time::Duration::from_secs(20));
        app.update();
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"spell1");
        app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().now=1.2;
        app.update();
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"idle");
    }


    fn scoped_fixture(name:&str)->(App,openleague_core::Simulation,u32,u32,Entity) {
        let(mut app,mut game,id,target,entity)=fixture();
        game.players.get_mut(&id).unwrap().champion=name.into();
        app.world_mut().get_mut::<Actor>(entity).unwrap().playback.model_name=name.into();
        // The production Annie/Ashe catalogues supply death; add it to this small ECS fixture too.
        app.world_mut().get_mut::<Actor>(entity).unwrap().playback.roles.insert("death".into(),AnimationNodeIndex::new(4));
        app.world_mut().resource_mut::<Match>().attack_visuals.reset(7);
        (app,game,id,target,entity)
    }
    #[test]
    fn annie_ashe_animation_seeks_delayed_start_ignores_duplicate_and_restarts_new_identity() {
        for name in ["annie","ashe"] {
            let(mut app,mut game,id,target,entity)=scoped_fixture(name);let mut facts=Events::default();let audience=Audience::from_visibility(true,true);
            let attack=facts.begin(id,10,30,Kind::Basic,audience).unwrap();game.tick=18;
            game.players.get_mut(&id).unwrap().windup=Some(Windup{target,started:10,release:30,cancelable:true,critical:false,presentation:Some(attack)});
            publish(&mut app,&game,&facts,10.);let index=AnimationNodeIndex::new(2);
            assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"attack");
            assert!((app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time()-8./30.).abs()<0.0001);
            app.world_mut().get_mut::<AnimationPlayer>(entity).unwrap().animation_mut(index).unwrap().set_seek_time(0.35);
            publish(&mut app,&game,&facts,10.);
            assert_eq!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time(),0.35);
            facts.cancel(attack,19,CancelReason::Order,audience).unwrap();let next=facts.begin(id,20,35,Kind::Basic,audience).unwrap();game.tick=21;
            game.players.get_mut(&id).unwrap().windup=Some(Windup{target,started:20,release:35,cancelable:true,critical:false,presentation:Some(next)});
            publish(&mut app,&game,&facts,10.1);
            assert_eq!(app.world().get::<Actor>(entity).unwrap().presentation,Some((next.id,Kind::Basic)));
            assert!((app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time()-1./30.).abs()<0.0001);
        }
    }
    #[test]
    fn annie_ashe_critical_without_catalog_role_falls_back_with_same_identity_and_seek() {
        for name in ["annie","ashe"] {
            let(mut app,mut game,id,target,entity)=scoped_fixture(name);let mut facts=Events::default();let audience=Audience::from_visibility(true,true);
            app.world_mut().get_mut::<Actor>(entity).unwrap().playback.roles.remove("crit");
            let attack=facts.begin(id,1,20,Kind::Critical,audience).unwrap();game.tick=3;
            game.players.get_mut(&id).unwrap().windup=Some(Windup{target,started:1,release:20,cancelable:true,critical:true,presentation:Some(attack)});
            publish(&mut app,&game,&facts,1.);let index=AnimationNodeIndex::new(2);
            let actor=app.world().get::<Actor>(entity).unwrap();assert_eq!(actor.role,"attack");assert_eq!(actor.presentation,Some((attack.id,Kind::Critical)));
            assert!((app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time()-2./30.).abs()<0.0001);
            game.players.get_mut(&id).unwrap().health=0.;publish(&mut app,&game,&facts,1.);
            assert!(app.world().get::<Actor>(entity).unwrap().presentation.is_none());
        }
    }

    #[test]
    fn all_canonical_basic_and_critical_animation_bindings_preserve_identity_age() {
        let catalog=Catalog::default();let canonical=openleague_core::champion_catalog().unwrap();
        assert_eq!(canonical.len(),122);let mut missing=0;
        for name in canonical.keys() { for kind in [Kind::Basic,Kind::Critical] {
            let(mut app,mut game,id,target,entity)=scoped_fixture(name);
            let has_crit=catalog.0[name]["roles"].get("crit").is_some();
            assert!(catalog.0[name]["roles"].get("attack").is_some());
            if !has_crit {app.world_mut().get_mut::<Actor>(entity).unwrap().playback.roles.remove("crit");}
            if kind==Kind::Critical && !has_crit {missing+=1;}
            let mut facts=Events::default();let audience=Audience::from_visibility(true,true);
            let attack=facts.begin(id,10,30,kind,audience).unwrap();game.tick=18;
            game.players.get_mut(&id).unwrap().windup=Some(Windup{target,started:10,release:30,cancelable:true,critical:kind==Kind::Critical,presentation:Some(attack)});
            publish(&mut app,&game,&facts,10.);
            let role=if kind==Kind::Critical && has_crit {"crit"} else {"attack"};
            let index=AnimationNodeIndex::new(if role=="crit" {3} else {2});
            let actor=app.world().get::<Actor>(entity).unwrap();
            assert_eq!(actor.role,role,"{name}");assert_eq!(actor.presentation,Some((attack.id,kind)),"{name}");
            assert!((app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time()-8./30.).abs()<0.0001,"{name}");
            app.world_mut().get_mut::<AnimationPlayer>(entity).unwrap().animation_mut(index).unwrap().set_seek_time(0.35);
            publish(&mut app,&game,&facts,10.);
            assert_eq!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(index).unwrap().seek_time(),0.35,"{name}");
        }}
        // Synthetic ECS nodes exercise selection/seek; this does not load the GLBs.
        assert_eq!(missing,34);
    }
    #[test]
    fn all_canonical_models_without_attack_facts_ignore_future_cooldown_deadlines() {
        for name in openleague_core::champion_catalog().unwrap().keys() {
            let(mut app,mut game,id,_,entity)=scoped_fixture(name);game.tick=100;
            let source=game.players.get_mut(&id).unwrap();source.windup=None;source.next_attack=120;
            publish(&mut app,&game,&Events::default(),10.);
            let actor=app.world().get::<Actor>(entity).unwrap();
            assert_eq!(actor.role,"idle","{name}");assert_eq!(actor.presentation,None,"{name}");assert_eq!(actor.attack_until,0,"{name}");
        }
    }
    #[test]
    fn canonical_model_mismatch_does_not_consume_another_champions_identity() {
        let(mut app,mut game,id,target,entity)=scoped_fixture("ahri");
        game.players.get_mut(&id).unwrap().champion="garen".into();
        let mut facts=Events::default();let attack=facts.begin(id,10,30,Kind::GarenQ,Audience::from_visibility(true,true)).unwrap();game.tick=18;
        let source=game.players.get_mut(&id).unwrap();source.next_attack=120;
        source.windup=Some(Windup{target,started:10,release:30,cancelable:true,critical:false,presentation:Some(attack)});
        publish(&mut app,&game,&facts,10.);
        let actor=app.world().get::<Actor>(entity).unwrap();
        assert_eq!(actor.role,"idle");assert_eq!(actor.presentation,None);assert_eq!(actor.attack_until,0);
    }
}

// Test-only constructor for explicit ECS fixtures, not a production model path.
#[cfg(test)]
pub(crate) fn material_test_playback(id:u32,model:Handle<Gltf>)->Playback {
    Playback {id,model_name:"Garen".into(),graph:Handle::default(),_model:model,
        roles:HashMap::new(),clips:HashMap::new(),durations:HashMap::new()}
}

#[cfg(test)]
#[path = "vilemaw_animation_binding_tests.rs"]
mod vilemaw_binding_tests;

#[path = "vilemaw_animation_probe.rs"]
pub(crate) mod vilemaw_probe;

// Append inside crate::animation for controlled actor identity fixtures only.
#[cfg(test)]
pub(crate) fn endgame_test_playback(id:u32,name:&str,model:Handle<Gltf>)->Playback {
    let mut playback=material_test_playback(id,model);
    playback.model_name=name.into();
    playback
}

#[cfg(test)]
mod gnar_ashe_source_asset_binding_tests {
    use super::*;
// SOURCE PROPOSAL ONLY: insert into animation::attack_binding_tests after review.
// One new test definition; no production playback/dispatch change, no new module.
#[test]
fn catalog_gnar_spell4_and_ashe_E_bind_existing_installed_glb_clips() {
    let catalog = Catalog::default();
    let root = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
    for (name, role, index, clip, count) in [
        ("gnar", "spell4", 64usize, "Gnar_Idle1_NATIVE_SPELL4_SOURCE", 65usize),
        ("ashe", "spell3", 18usize, "ashe_spell2", 20usize),
    ] {
        assert_eq!(catalog.0[name]["roles"][role].as_u64(), Some(index as u64));
        assert_eq!(catalog.0[name]["clips"][index].as_str(), Some(clip));
        let path = root.join("assets/champions").join(format!("{name}.glb"));
        let data = std::fs::read(path).unwrap();
        assert!(data.len() >= 20 && data.len() <= 64 * 1024 * 1024);
        assert_eq!(&data[..4], b"glTF");
        let word = |at| u32::from_le_bytes(data[at..at+4].try_into().unwrap()) as usize;
        assert_eq!(word(4), 2);
        assert_eq!(word(8), data.len());
        assert_eq!(word(16), 0x4e4f534a);
        let end = 20usize.checked_add(word(12)).unwrap();
        assert!(end <= data.len());
        let glb: serde_json::Value = serde_json::from_slice(&data[20..end]).unwrap();
        let animations = glb["animations"].as_array().unwrap();
        assert_eq!(animations.len(), count);
        assert_eq!(animations[index]["name"].as_str(), Some(clip));
        assert!(!animations[index]["channels"].as_array().unwrap().is_empty());
        for role_index in catalog.0[name]["roles"].as_object().unwrap().values() {
            assert!((role_index.as_u64().unwrap() as usize) < animations.len());
        }
    }
}
}


#[cfg(test)]
mod trundle_w_clock_binding_tests {
    use super::*;
    use bevy::animation::{AnimationDelta,advance_animations,
        transition::{advance_transitions,expire_completed_transitions}};
    #[test]
    fn actual_w_pose_uses_explicit_age_while_non_w_clip_and_wall_time_continue() {
        let mut app=App::new();app.add_plugins(bevy::app::TaskPoolPlugin::default());
        app.init_resource::<Time>().init_resource::<Assets<AnimationClip>>().init_resource::<Assets<AnimationGraph>>()
            .init_resource::<AnimationDelta>()
            .add_systems(Update,(advance_transitions,advance_animations,expire_completed_transitions).chain());
        let mut w=AnimationClip::default();w.set_duration(0.73333335);
        let w=app.world_mut().resource_mut::<Assets<AnimationClip>>().add(w);
        let mut attack=AnimationClip::default();attack.set_duration(100.);
        let attack=app.world_mut().resource_mut::<Assets<AnimationClip>>().add(attack);
        let mut graph=AnimationGraph::new();let w_index=graph.add_clip(w,1.,graph.root);
        let attack_index=graph.add_clip(attack.clone(),1.,graph.root);
        let run_index=graph.add_clip(attack.clone(),1.,graph.root);
        let death_index=graph.add_clip(attack,1.,graph.root);
        let graph=app.world_mut().resource_mut::<Assets<AnimationGraph>>().add(graph);
        let mut player=AnimationPlayer::default();player.play(w_index);player.play(attack_index).repeat();
        assert!(hold_trundle_w_pose(&mut player,w_index,0.2));
        let entity=app.world_mut().spawn((player,AnimationGraphHandle(graph.clone()))).id();
        for age in [0.2,0.2,0.3] {
            assert!(hold_trundle_w_pose(&mut app.world_mut().get_mut::<AnimationPlayer>(entity).unwrap(),w_index,age));
            app.world_mut().resource_mut::<Time>().advance_by(std::time::Duration::from_secs(2));
            app.world_mut().resource_mut::<AnimationDelta>().0=0.125;app.update();
            let player=app.world().get::<AnimationPlayer>(entity).unwrap();
            assert_eq!(player.animation(w_index).unwrap().seek_time(),age);
            assert!(player.animation(w_index).unwrap().is_paused());
            assert!(!player.animation(attack_index).unwrap().is_paused());
        }
        let player=app.world().get::<AnimationPlayer>(entity).unwrap();
        assert_eq!(player.animation(attack_index).unwrap().seek_time(),0.375);
        assert_eq!(app.world().resource::<Time>().elapsed_secs(),6.);
        let mut recreated=AnimationPlayer::default();
        assert!(!hold_trundle_w_pose(&mut recreated,w_index,0.3),"missing/recreated player must not silently start the old clip");
        for (role,index) in [("attack",attack_index),("run",run_index),("death",death_index)] {
            let mut player=AnimationPlayer::default();let mut transitions=AnimationTransitions::new();
            transitions.play(&mut player,w_index,std::time::Duration::ZERO);
            assert!(hold_trundle_w_pose(&mut player,w_index,0.2));
            assert!(player.animation(w_index).unwrap().is_paused());
            stop_trundle_w_on_exit(&mut player,"trundle","spell2",false,Some(w_index));
            assert!(player.animation(w_index).is_none(),"outgoing paused W must be removed before {role}");
            transitions.play(&mut player,index,std::time::Duration::from_millis(80));
            assert!(!player.animation(index).unwrap().is_paused());
            let entity=app.world_mut().spawn((player,transitions,AnimationGraphHandle(graph.clone()))).id();
            app.world_mut().resource_mut::<Time>().advance_by(std::time::Duration::from_secs(1));
            app.world_mut().resource_mut::<AnimationDelta>().0=0.125;app.update();
            let player=app.world().get::<AnimationPlayer>(entity).unwrap();
            assert!(player.animation(w_index).is_none(),"W cannot remain as an untracked paused contributor");
            let active=player.animation(index).unwrap();assert!(!active.is_paused());
            assert_eq!(active.seek_time(),0.125);assert_eq!(active.weight(),1.);
        }
        let mut missing=AnimationPlayer::default();missing.play(w_index);
        assert!(hold_trundle_w_pose(&mut missing,w_index,0.2));
        stop_trundle_w_on_exit(&mut missing,"trundle","spell2",false,Some(w_index));
        assert!(missing.animation(w_index).is_none(),"cleanup also precedes a missing next role");
        let mut foreign=AnimationPlayer::default();foreign.play(w_index);
        stop_trundle_w_on_exit(&mut foreign,"annie","spell2",false,Some(w_index));
        assert!(foreign.animation(w_index).is_some(),"another champion's spell2 is never removed");
    }
}


#[cfg(test)]
mod trundle_e_forced_binding_tests {
    use super::*;
    use openleague_core::{Point, attack_presentation::{State as Events, Kind, Audience}, attacks::Windup};

    fn fixture()->(App,openleague_core::Simulation,u32,u32,Entity) {
        let mut cells=Vec::new();for _ in 0..400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
        let nav=openleague_core::Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap();
        let mut game=openleague_core::Simulation::new(nav).unwrap();game.session=7;game.tick=101;
        let id=game.join("trundle").unwrap();let target=game.join("garen").unwrap();
        game.players.get_mut(&id).unwrap().position=Point{x:100.,z:100.};
        let mut clips=Assets::<AnimationClip>::default();let mut clip=AnimationClip::default();clip.set_duration(1.);let clip=clips.add(clip);
        let roles=HashMap::from([("idle".into(),AnimationNodeIndex::new(0)),("spell1".into(),AnimationNodeIndex::new(1)),
            ("attack".into(),AnimationNodeIndex::new(2)),("crit".into(),AnimationNodeIndex::new(3)),("spell2".into(),AnimationNodeIndex::new(4)),
            ("run".into(),AnimationNodeIndex::new(5)),("death".into(),AnimationNodeIndex::new(6)),("spell3".into(),AnimationNodeIndex::new(7))]);
        let playback=Playback{id,model_name:"trundle".into(),graph:Handle::default(),_model:Handle::default(),roles,
            clips:HashMap::from([("spell1".into(),clip.clone()),("spell2".into(),clip)]),durations:HashMap::new()};
        let mut state=Match::default();state.attack_visuals.reset(7);state.trundle_w_visuals.reset(7);
        let mut app=App::new();app.init_resource::<crate::native_effect_clock::EffectClock>()
            .insert_resource(clips).insert_resource(state).add_systems(Update,animate);
        let entity=app.world_mut().spawn((AnimationPlayer::default(),AnimationTransitions::new(),Actor{playback,role:"idle".into(),previous_attack:0,attack_until:0,critical:false,presentation:None})).id();
        (app,game,id,target,entity)
    }
    fn push(_owner:u32,started:u64)->openleague_core::trundle_e::ForcedMovement {
        openleague_core::trundle_e::ForcedMovement{started,until:started+5}
    }
    fn publish(app:&mut App,snapshot:openleague_core::Snapshot,now:f64) {
        app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().now=now;
        let mut state=app.world_mut().resource_mut::<Match>();
        state.attack_visuals.observe(&snapshot,now).unwrap();state.trundle_w_visuals.observe_accepted(&snapshot,now).unwrap();state.snapshot=Some(snapshot);
        app.update();
    }
    #[test]
    fn received_forced_champion_runs_before_w_windup_and_cast_without_fake_order() {
        let(mut app,mut game,id,target,entity)=fixture();
        let mut facts=Events::default();let attack=facts.begin(id,100,110,Kind::Basic,Audience::from_visibility(true,true)).unwrap();
        let p=game.players.get_mut(&id).unwrap();p.ranks[1]=1;
        p.effects.trundle_w=Some(openleague_core::trundle_w::Zone{owner:id,center:p.position,rank:1,starts:100,until:340});
        p.effects.trundle_e_push=Some(push(id,101));
        p.windup=Some(Windup{target,started:100,release:110,cancelable:true,critical:false,presentation:Some(attack)});
        assert!(p.destination.is_none() && p.stuns.is_empty());
        let w_index=AnimationNodeIndex::new(4);app.world_mut().get_mut::<Actor>(entity).unwrap().role="spell2".into();
        app.world_mut().get_mut::<AnimationPlayer>(entity).unwrap().play(w_index).pause();
        let mut snapshot=game.snapshot();snapshot.attack_events=facts.events();let original=serde_json::to_value(&snapshot).unwrap();
        publish(&mut app,snapshot.clone(),0.);
        let actor=app.world().get::<Actor>(entity).unwrap();assert_eq!(actor.role,"run");assert!(actor.presentation.is_none());
        assert!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(w_index).is_none());
        assert_eq!(serde_json::to_value(app.world().resource::<Match>().snapshot.as_ref().unwrap()).unwrap(),original);
        assert!(game.players[&id].destination.is_none() && game.players[&id].stuns.is_empty());
        // A received expired push cannot suppress an otherwise valid existing attack.
        game.tick=106;game.players.get_mut(&id).unwrap().effects.spin_until=0;
        let mut expired=game.snapshot();expired.attack_events=facts.events();publish(&mut app,expired,0.1);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"attack");
        game.tick=107;game.players.get_mut(&id).unwrap().effects.spin_until=110;game.players.get_mut(&id).unwrap().effects.trundle_e_push=Some(push(id,107));
        let mut casting=game.snapshot();casting.attack_events=facts.events();publish(&mut app,casting,0.15);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"run","forced motion also wins over a received cast role");
        game.players.get_mut(&id).unwrap().health=0.;
        let mut dead=game.snapshot();dead.attack_events=facts.events();publish(&mut app,dead,0.2);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"death");
    }
    #[test]
    fn received_forced_unit_with_no_destination_beats_legacy_attack_and_expires_to_idle() {
        let(mut app,game,id,_,entity)=fixture();let unit_id=1000;
        let mut unit:openleague_core::world::Unit=serde_json::from_value(serde_json::json!({
            "id":unit_id,"name":"fixture","definition":"Blue_Minion_Basic","kind":"Melee","team":1,
            "position":{"x":100.,"z":100.},"height":0.,"facing":0.,"health":100.,"max_health":100.,
            "damage":1.,"armor":0.,"magic_resist":0.,"gold":0.,"experience":0.,"target":null,"destination":null,
            "next_attack":120,"silence_until":0,"respawn_at":null})).unwrap();
        {let mut actor=app.world_mut().get_mut::<Actor>(entity).unwrap();actor.playback.id=unit_id;actor.playback.model_name="Blue_Minion_Basic".into();}
        let mut ordinary=game.snapshot();ordinary.units.push(unit.clone());publish(&mut app,ordinary,0.);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"attack","no push preserves existing NPC attack selection");
        unit.trundle_e_push=Some(push(id,102));let mut forced=game.snapshot();forced.tick=102;forced.units.push(unit.clone());
        publish(&mut app,forced,0.1);assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"run");
        assert_eq!(app.world().get::<Actor>(entity).unwrap().attack_until,0);
        assert!(unit.destination.is_none() && unit.stuns.is_empty());
        let mut expired=game.snapshot();expired.tick=107;expired.units.push(unit);publish(&mut app,expired,0.2);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"idle");
    }
}


#[cfg(test)]
mod trundle_r_clock_binding_tests {
    use super::*;
    use bevy::animation::{AnimationDelta,advance_animations,
        transition::{advance_transitions,expire_completed_transitions}};
    #[test]
    fn actual_r_replaces_paused_w_and_exits_to_current_attack_run_death_without_global_stop() {
        let mut app=App::new();app.add_plugins(bevy::app::TaskPoolPlugin::default());
        app.init_resource::<Time>().init_resource::<Assets<AnimationClip>>().init_resource::<Assets<AnimationGraph>>()
            .init_resource::<AnimationDelta>()
            .add_systems(Update,(advance_transitions,advance_animations,expire_completed_transitions).chain());
        let mut clip=AnimationClip::default();clip.set_duration(100.);
        let clip=app.world_mut().resource_mut::<Assets<AnimationClip>>().add(clip);
        let mut graph=AnimationGraph::new();let w=graph.add_clip(clip.clone(),1.,graph.root);
        let r=graph.add_clip(clip.clone(),1.,graph.root);let foreign=graph.add_clip(clip.clone(),1.,graph.root);
        let nexts=[graph.add_clip(clip.clone(),1.,graph.root),graph.add_clip(clip.clone(),1.,graph.root),graph.add_clip(clip,1.,graph.root)];
        let graph=app.world_mut().resource_mut::<Assets<AnimationGraph>>().add(graph);
        for (role,next) in ["attack","run","death"].into_iter().zip(nexts) {
            let mut player=AnimationPlayer::default();let mut transitions=AnimationTransitions::new();
            transitions.play(&mut player,w,std::time::Duration::ZERO);
            assert!(hold_trundle_w_pose(&mut player,w,0.2));player.play(foreign).repeat();
            stop_trundle_w_on_exit(&mut player,"trundle","spell2",false,Some(w));
            assert!(player.animation(w).is_none());
            transitions.play(&mut player,r,std::time::Duration::from_millis(80));
            assert!(hold_trundle_w_pose(&mut player,r,0.1));
            assert!(hold_trundle_w_pose(&mut player,r,0.3));
            assert_eq!(player.animation(r).unwrap().seek_time(),0.3);
            stop_trundle_r_on_exit(&mut player,"trundle","spell4",false,Some(r));
            assert!(player.animation(r).is_none(),"paused R removed before {role} lookup");
            assert!(player.animation(foreign).is_some(),"only outgoing R may be stopped");
            transitions.play(&mut player,next,std::time::Duration::from_millis(80));
            let entity=app.world_mut().spawn((player,transitions,AnimationGraphHandle(graph.clone()))).id();
            app.world_mut().resource_mut::<Time>().advance_by(std::time::Duration::from_secs(1));
            app.world_mut().resource_mut::<AnimationDelta>().0=0.125;app.update();
            let player=app.world().get::<AnimationPlayer>(entity).unwrap();
            assert!(player.animation(w).is_none() && player.animation(r).is_none());
            let next=player.animation(next).unwrap();assert!(!next.is_paused());assert_eq!(next.seek_time(),0.125);assert_eq!(next.weight(),1.);
            assert!(player.animation(foreign).is_some());
        }
        let mut player=AnimationPlayer::default();player.play(r).pause();player.play(foreign).repeat();
        stop_trundle_r_on_exit(&mut player,"trundle","spell4",false,Some(r));
        assert!(player.animation(r).is_none(),"also removed before a missing next role");assert!(player.animation(foreign).is_some());
        player.play(r).pause();stop_trundle_r_on_exit(&mut player,"annie","spell4",false,Some(r));
        assert!(player.animation(r).is_some(),"foreign model role cannot be stopped");
        stop_trundle_r_on_exit(&mut player,"trundle","spell4",true,Some(r));assert!(player.animation(r).is_some());
    }
}

#[cfg(all(test,windows))]
mod ezreal_q_cast_animation_binding_tests {
    use super::*;
    use openleague_core::{Action,Navigation,Point,Simulation,Snapshot};
    use bevy::animation::{AnimationDelta,advance_animations,
        transition::{advance_transitions,expire_completed_transitions}};

    // The owner remains alive in the returned App. Use the same initialized
    // process EffectClock as production, with explicit samples in this CPU test.
    fn fixture()->(App,App,Simulation,u32,Entity,AnimationNodeIndex,AnimationNodeIndex) {
        let mut owner=App::new();crate::native_effect_clock::install_test_clock(&mut owner);
        owner.add_plugins(crate::native_effect_clock::Plugin);owner.update();
        let clock=owner.world_mut().remove_resource::<crate::native_effect_clock::EffectClock>().unwrap();
        assert!(clock.presentation_ready());
        let mut cells=Vec::new();for _ in 0..400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
        let nav=Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,&cells).unwrap();
        let mut game=Simulation::new(nav).unwrap();game.session=7;game.tick=99;
        let id=game.join("ezreal").unwrap();game.players.get_mut(&id).unwrap().position=Point{x:100.,z:100.};
        let target=game.join("garen").unwrap();game.players.get_mut(&target).unwrap().position=Point{x:400.,z:100.};
        game.command(id,Action::Learn{slot:0}).unwrap();
        let mut app=App::new();app.add_plugins(bevy::app::TaskPoolPlugin::default());
        app.init_resource::<Time>().init_resource::<Assets<AnimationClip>>().init_resource::<Assets<AnimationGraph>>()
            .init_resource::<AnimationDelta>().insert_resource(clock)
            .add_systems(Update,(animate,advance_transitions,advance_animations,expire_completed_transitions).chain());
        let mut clip=AnimationClip::default();clip.set_duration(0.8);
        let clip=app.world_mut().resource_mut::<Assets<AnimationClip>>().add(clip);
        let mut graph=AnimationGraph::new();let mut roles=HashMap::new();
        for role in ["idle","run","attack","death","spell1","stun","foreign"] {
            roles.insert(role.to_string(),graph.add_clip(clip.clone(),1.,graph.root));
        }
        let q=roles["spell1"];let foreign=roles["foreign"];
        let graph=app.world_mut().resource_mut::<Assets<AnimationGraph>>().add(graph);
        let playback=Playback{id,model_name:"ezreal".into(),graph:graph.clone(),_model:Handle::default(),roles,
            clips:HashMap::from([("spell1".into(),clip)]),durations:HashMap::new()};
        let mut player=AnimationPlayer::default();player.play(foreign).repeat();
        let entity=app.world_mut().spawn((player,AnimationTransitions::new(),AnimationGraphHandle(graph),
            Actor{playback,role:"idle".into(),previous_attack:0,attack_until:0,critical:false,presentation:None})).id();
        let mut state=Match::default();state.attack_visuals.reset(7);state.ezreal_q_cast_visuals.reset(7);
        state.ezreal_q_cast_visuals.observe_accepted(&game.snapshot(),0.,true,false).unwrap();state.snapshot=Some(game.snapshot());
        app.insert_resource(state);(app,owner,game,id,entity,q,foreign)
    }
    fn publish(app:&mut App,snapshot:Snapshot,now:f64) {
        let (ready,paused)={let mut clock=app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>();clock.now=now;(clock.presentation_ready(),clock.paused())};
        let mut state=app.world_mut().resource_mut::<Match>();
        state.attack_visuals.observe(&snapshot,now).unwrap();
        state.ezreal_q_cast_visuals.observe_accepted(&snapshot,now,ready,paused).unwrap();state.snapshot=Some(snapshot);
        app.update();
    }
    fn cast(game:&mut Simulation,id:u32)->Snapshot {
        game.tick=100;game.command(id,Action::CastAt{slot:0,point:Point{x:700.,z:100.}}).unwrap();game.snapshot()
    }
    #[test]
    fn native_base_spell1_real_player_seeks_once_pause_and_core_release_restore_run_then_idle() {
        let(mut app,_owner,mut game,id,entity,q,foreign)=fixture();
        let catalog:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/animation_manifest.json")).unwrap();
        assert_eq!(catalog["ezreal"]["roles"]["spell1"],38);assert_eq!(catalog["ezreal"]["clips"][38],"ezreal_spell1");
        game.command(id,Action::Move{point:Point{x:800.,z:100.}}).unwrap();
        let snapshot=cast(&mut game,id);let original=serde_json::to_value(&snapshot).unwrap();publish(&mut app,snapshot.clone(),0.1);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"spell1");
        assert_eq!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(q).unwrap().seek_time(),0.);
        assert_eq!(serde_json::to_value(app.world().resource::<Match>().snapshot.as_ref().unwrap()).unwrap(),original);
        publish(&mut app,snapshot.clone(),0.2);
        assert!((app.world().get::<AnimationPlayer>(entity).unwrap().animation(q).unwrap().seek_time()-0.1).abs()<0.00001);
        let mut pause=vec![0;14];pause[9..13].copy_from_slice(&30i32.to_le_bytes());pause[13]=1;
        app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().receive(1,0xa1,&pause).unwrap();
        assert!(app.world().resource::<crate::native_effect_clock::EffectClock>().paused());
        let mut paused_snapshot=snapshot.clone();paused_snapshot.tick=106;
        publish(&mut app,paused_snapshot,0.2);
        assert!((app.world().get::<AnimationPlayer>(entity).unwrap().animation(q).unwrap().seek_time()-0.1).abs()<0.00001,
            "received tick corrections must not move a paused pose");
        for _ in 0..3 {
            app.world_mut().resource_mut::<Time>().advance_by(std::time::Duration::from_secs(1));
            app.world_mut().resource_mut::<AnimationDelta>().0=0.;app.update();
            assert!((app.world().get::<AnimationPlayer>(entity).unwrap().animation(q).unwrap().seek_time()-0.1).abs()<0.00001);
        }
        app.world_mut().resource_mut::<crate::native_effect_clock::EffectClock>().receive(2,0x0a,&[0;10]).unwrap();
        for _ in 0..8 {game.advance();}
        assert!(game.players[&id].effects.ezreal_q.is_none());
        publish(&mut app,game.snapshot(),0.37);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"run");
        assert!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(q).is_none());
        assert!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(foreign).is_some());
        game.players.get_mut(&id).unwrap().destination=None;game.tick+=1;publish(&mut app,game.snapshot(),0.4);
        assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"idle");
    }
    #[test]
    fn received_death_forced_stun_win_and_current_attack_resumes_without_global_stop_or_order_mutation() {
        use openleague_core::{attack_presentation::{State as Events,Kind,Audience},attacks::Windup};
        for (mode,expected) in [(0,"death"),(1,"run"),(2,"stun")] {
            let(mut app,_owner,mut game,id,entity,q,foreign)=fixture();
            let snapshot=cast(&mut game,id);publish(&mut app,snapshot.clone(),0.1);
            let mut interrupted=snapshot.clone();interrupted.tick=101;
            let p=interrupted.players.iter_mut().find(|p|p.id==id).unwrap();
            if mode==0 {p.health=0.;}
            else if mode==1 {p.effects.trundle_e_push=Some(openleague_core::trundle_e::ForcedMovement{started:101,until:107});}
            else {p.stuns.push(openleague_core::stuns::Stun{tag:"fixture".into(),source:None,expires_at:107});}
            let before=serde_json::to_value(&interrupted).unwrap();publish(&mut app,interrupted,0.12);
            assert_eq!(app.world().get::<Actor>(entity).unwrap().role,expected);
            assert!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(q).is_none());
            assert!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(foreign).is_some());
            assert_eq!(serde_json::to_value(app.world().resource::<Match>().snapshot.as_ref().unwrap()).unwrap(),before);
            let mut restored=snapshot;restored.tick=102;
            let mut events=Events::default();let attack=events.begin(id,102,109,Kind::Basic,Audience::from_visibility(true,true)).unwrap();
            restored.attack_events=events.events();let target=restored.players.iter().find(|p|p.id!=id).unwrap().id;
            let p=restored.players.iter_mut().find(|p|p.id==id).unwrap();
            p.effects.ezreal_q=None;p.windup=Some(Windup{target,started:102,release:109,cancelable:true,critical:false,presentation:Some(attack)});
            publish(&mut app,restored,0.14);assert_eq!(app.world().get::<Actor>(entity).unwrap().role,"attack");
        }
    }
    #[test]
    fn actual_missing_clip_scene_replacement_clock_failure_and_no_snapshot_retire_only_owned_q() {
        for mode in 0..5 {
            let(mut app,_owner,mut game,id,entity,q,foreign)=fixture();let snapshot=cast(&mut game,id);
            if mode==0 {app.world_mut().get_mut::<Actor>(entity).unwrap().playback.clips.clear();}
            publish(&mut app,snapshot.clone(),0.1);
            if mode==0 {
                assert_ne!(app.world().get::<Actor>(entity).unwrap().role,"spell1");
                let mut loaded=AnimationClip::default();loaded.set_duration(0.8);
                let handle=app.world_mut().resource_mut::<Assets<AnimationClip>>().add(loaded);
                app.world_mut().get_mut::<Actor>(entity).unwrap().playback.clips.insert("spell1".into(),handle);
                publish(&mut app,snapshot.clone(),0.12);assert_ne!(app.world().get::<Actor>(entity).unwrap().role,"spell1");
            } else if mode==1 {
                let playback=app.world().get::<Actor>(entity).unwrap().playback.clone();
                app.world_mut().despawn(entity);
                let replacement=app.world_mut().spawn((AnimationPlayer::default(),AnimationTransitions::new(),
                    Actor{playback,role:"idle".into(),previous_attack:0,attack_until:0,critical:false,presentation:None})).id();
                app.update();assert_ne!(app.world().get::<Actor>(replacement).unwrap().role,"spell1");
            } else {
                if mode==2 {app.insert_resource(crate::native_effect_clock::EffectClock::default());}
                else if mode==3 {app.world_mut().resource_mut::<Match>().snapshot=None;}
                else {
                    assert!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(q).is_some(),"real Q node was started before FoW loss");
                    let mut hidden=snapshot.clone();hidden.tick=101;hidden.players.retain(|p|p.id!=id);
                    assert!(hidden.roster.iter().any(|p|p.id==id),"FoW loss keeps the owner rostered");
                    let before=serde_json::to_value(&hidden).unwrap();publish(&mut app,hidden,0.12);
                    assert_eq!(serde_json::to_value(app.world().resource::<Match>().snapshot.as_ref().unwrap()).unwrap(),before);
                }
                app.update();assert!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(q).is_none());
                assert!(app.world().get::<AnimationPlayer>(entity).unwrap().animation(foreign).is_some());
            }
        }
        let mut player=AnimationPlayer::default();let q=AnimationNodeIndex::new(1);let foreign=AnimationNodeIndex::new(2);
        player.play(q).pause();player.play(foreign).repeat();
        stop_ezreal_q_on_exit(&mut player,"ezreal","spell1",false,Some(q));
        assert!(player.animation(q).is_none() && player.animation(foreign).is_some());
        player.play(q).pause();stop_ezreal_q_on_exit(&mut player,"annie","spell1",false,Some(q));assert!(player.animation(q).is_some());
    }
}

#[cfg(test)]
mod ezreal_integer_frame_asset_binding_tests {
    use super::*;
    use bevy::asset::{AssetApp, AssetPlugin};
    use serde_json::Value;
    use std::{fs, path::{Path, PathBuf}};

    const ASSET: &str = "champions/ezreal_integer_frames_preserved_json.glb";
    const DECLARED_SHA256: &str = "6d54436a1b805c465a5797e462d4cc913822dbe119f157db080db8034804045b";
    const CORRECTED: [(usize, &str, usize, f32); 6] = [
        (20, "ezreal_cyber_Recall_Windup", 25, 24.0 / 31.0),
        (21, "ezreal_cyber_run", 25, 24.0 / 31.0),
        (22, "ezreal_cyber_run_fast", 25, 24.0 / 31.0),
        (36, "ezreal_laugh", 126, 125.0 / 30.0),
        (45, "ezreal_tpa_dance", 341, 340.0 / 30.0),
        (47, "ezreal_tpa_fingerbone", 15, 14.0 / 30.0),
    ];

    fn repository() -> PathBuf {
        Path::new(env!("CARGO_MANIFEST_DIR")).join("../..")
    }

    // This exercises the production request and AssetServer path binding. It
    // neither waits for a Gltf loader nor claims scene/GPU/render validation.
    fn asset_app() -> App {
        let mut app = App::new();
        app.add_plugins((MinimalPlugins, AssetPlugin {
            file_path: repository().join("assets").to_str().unwrap().into(),
            ..default()
        })).init_asset::<Gltf>();
        app
    }

    fn requested_path(app: &App, catalog: &Catalog, name: &str) -> PathBuf {
        let server = app.world().resource::<AssetServer>();
        let (request, scale) = super::request(7, name, catalog, server);
        assert_eq!(request.id, 7);
        assert_eq!(request.name, name);
        assert_eq!(scale, catalog.0[name]["scale"].as_f64().unwrap_or(1.) as f32);
        server.get_path(request.model.id()).expect("request has a registered asset path")
            .path().to_path_buf()
    }

    #[test]
    fn catalog_request_uses_unique_corrected_ezreal_glb_and_preserves_other_models() {
        let catalog = Catalog::default();
        let mut original: Value = serde_json::from_str(include_str!(
            "../../../data/4.20/animation_manifest.json")).unwrap();
        let world: Value = serde_json::from_str(include_str!(
            "../../../data/4.20/world_animation_manifest.json")).unwrap();
        for (name, entry) in world.as_object().unwrap() {
            original.as_object_mut().unwrap().insert(name.clone(), entry.clone());
        }
        assert!(original["ezreal"].get("asset").is_none(), "the packaged catalogue remains unchanged");
        let old_ezreal = original["ezreal"].clone();
        original["ezreal"]["asset"] = Value::String(EZREAL_JOINT_IDENTITY_ASSET.into());
        assert_eq!(catalog.0, original, "only Ezreal's existing asset property is overridden");
        let mut restored = catalog.0["ezreal"].clone();
        restored.as_object_mut().unwrap().remove("asset");
        assert_eq!(restored, old_ezreal, "roles, clip order, scales and duration metadata are untouched");
        let app = asset_app();
        assert_eq!(requested_path(&app, &catalog, "ezreal"), Path::new(EZREAL_JOINT_IDENTITY_ASSET));
        assert_eq!(requested_path(&app, &catalog, "garen"), Path::new("champions/garen.glb"));
    }

    struct Glb {
        json: Value,
        bin: Vec<u8>,
    }

    fn u32_at(bytes: &[u8], offset: usize) -> usize {
        u32::from_le_bytes(bytes.get(offset..offset.checked_add(4).unwrap())
            .expect("bounded GLB integer").try_into().unwrap()) as usize
    }

    fn parse_glb(bytes: &[u8]) -> Glb {
        assert_eq!(bytes.get(..4), Some(b"glTF".as_slice()));
        assert_eq!(u32_at(bytes, 4), 2);
        assert_eq!(u32_at(bytes, 8), bytes.len());
        let json_len = u32_at(bytes, 12);
        assert_eq!(u32_at(bytes, 16), 0x4e4f534a);
        let json_end = 20usize.checked_add(json_len).unwrap();
        let json: Value = serde_json::from_slice(bytes.get(20..json_end).unwrap()).unwrap();
        let bin_len = u32_at(bytes, json_end);
        assert_eq!(u32_at(bytes, json_end + 4), 0x004e4942);
        let bin_start = json_end.checked_add(8).unwrap();
        assert_eq!(bin_start.checked_add(bin_len).unwrap(), bytes.len());
        assert_eq!(json["buffers"].as_array().unwrap().len(), 1);
        assert!(json["buffers"][0].get("uri").is_none());
        let data_len = json["buffers"][0]["byteLength"].as_u64().unwrap() as usize;
        assert!(data_len <= bin_len && bin_len - data_len < 4);
        Glb { json, bin: bytes[bin_start..bin_start + data_len].to_vec() }
    }

    // Animation-only FLOAT accessors, including explicit strides. No Gltf or
    // native decoder is substituted by this bounded CPU consistency check.
    fn samples(glb: &Glb, accessor_index: usize) -> (usize, usize, Vec<u8>) {
        let a = &glb.json["accessors"][accessor_index];
        assert_eq!(a["componentType"].as_u64(), Some(5126));
        assert!(a.get("sparse").is_none());
        let lanes = match a["type"].as_str().unwrap() {
            "SCALAR" => 1, "VEC3" => 3, "VEC4" => 4,
            other => panic!("unexpected animation accessor {other}"),
        };
        let width = lanes * 4;
        let count = a["count"].as_u64().unwrap() as usize;
        assert!(count > 0);
        let view = &glb.json["bufferViews"][a["bufferView"].as_u64().unwrap() as usize];
        assert_eq!(view["buffer"].as_u64(), Some(0));
        let view_offset = view["byteOffset"].as_u64().unwrap_or(0) as usize;
        let view_len = view["byteLength"].as_u64().unwrap() as usize;
        let offset = a["byteOffset"].as_u64().unwrap_or(0) as usize;
        let stride = view["byteStride"].as_u64().map(|n| n as usize).unwrap_or(width);
        assert!(stride >= width);
        let end = offset.checked_add((count - 1).checked_mul(stride).unwrap())
            .unwrap().checked_add(width).unwrap();
        assert!(end <= view_len);
        assert!(view_offset.checked_add(view_len).unwrap() <= glb.bin.len());
        let mut packed = Vec::with_capacity(count.checked_mul(width).unwrap());
        for i in 0..count {
            let start = view_offset + offset + i * stride;
            packed.extend_from_slice(&glb.bin[start..start + width]);
        }
        (count, width, packed)
    }

    fn floats(bytes: &[u8]) -> Vec<f32> {
        assert_eq!(bytes.len() % 4, 0);
        bytes.chunks_exact(4).map(|b| f32::from_le_bytes(b.try_into().unwrap())).collect()
    }

    // The historical append-only model remains a separate strict regression.
    // Restore only its asset selection; roles, clips, scale and duration stay current.
    fn historical_six_frame_catalog() -> Catalog {
        let mut catalog = Catalog::default();
        catalog.0["ezreal"]["asset"] = Value::String(ASSET.into());
        catalog
    }

    #[test]
    fn selected_glb_preserves_forty_six_clips_and_adds_six_terminal_sample_frames() {
        let catalog = historical_six_frame_catalog();
        let app = asset_app();
        let path = requested_path(&app, &catalog, "ezreal");
        assert_eq!(path, Path::new(ASSET));
        let selected = fs::read(repository().join("assets").join(&path)).expect("selected model exists");
        let previous = fs::read(repository().join("assets/champions/ezreal.glb"))
            .expect("original model is preserved alongside the unique model");
        assert_eq!(selected.len(), 20_433_436);
        assert_eq!(previous.len(), 18_232_556);
        let manifest: Value = serde_json::from_slice(&fs::read(repository().join("assets-manifest.json")).unwrap()).unwrap();
        let rows: Vec<_> = manifest["files"].as_array().unwrap().iter()
            .filter(|r| r["path"] == format!("assets/{}", path.to_str().unwrap().replace('\\', "/"))).collect();
        assert_eq!(rows.len(), 1);
        assert_eq!(rows[0]["bytes"].as_u64(), Some(selected.len() as u64));
        assert_eq!(rows[0]["sha256"].as_str(), Some(DECLARED_SHA256));
        // The row declares the SHA. This test does not calculate it: Root's
        // separate before/after build guards verify the actual file SHA256.
        let old = parse_glb(&previous);
        let new = parse_glb(&selected);
        assert!(new.bin.starts_with(&old.bin), "every historical BIN byte is preserved");
        let old_animations = old.json["animations"].as_array().unwrap();
        let new_animations = new.json["animations"].as_array().unwrap();
        assert_eq!(old_animations.len(), 52);
        assert_eq!(new_animations.len(), 52);
        let old_accessors = old.json["accessors"].as_array().unwrap();
        let new_accessors = new.json["accessors"].as_array().unwrap();
        let old_views = old.json["bufferViews"].as_array().unwrap();
        let new_views = new.json["bufferViews"].as_array().unwrap();
        let mut preserved_negative_zeros = 0;
        for (index, (after, before)) in new_accessors[..old_accessors.len()].iter().zip(old_accessors).enumerate() {
            for bound in ["min", "max"] {
                if let Some(values) = before[bound].as_array() {
                    for (component, value) in values.iter().enumerate() {
                        if value.as_f64().map(f64::to_bits) == Some((-0.0_f64).to_bits()) {
                            assert_eq!(after[bound][component].as_f64().map(f64::to_bits), Some((-0.0_f64).to_bits()), "signed zero accessor {index}/{bound}/{component}");
                            preserved_negative_zeros += 1;
                        }
                    }
                }
            }
            assert_eq!(after, before, "historical accessor {index}");
        }
        assert_eq!(preserved_negative_zeros, 409);
        for (index, (after, before)) in new_views[..old_views.len()].iter().zip(old_views).enumerate() {
            assert_eq!(after, before, "historical buffer view {index}");
        }
        assert_eq!(new_accessors.len() - old_accessors.len(), 2106);
        assert_eq!(new_views.len() - old_views.len(), 2106);
        let mut changed_samplers = 0;
        let mut appended = std::collections::BTreeSet::new();
        for (index, (before, after)) in old_animations.iter().zip(new_animations).enumerate() {
            assert_eq!(after["name"], before["name"], "ordered clip {index}");
            let Some((_, expected_name, frame_count, end_seconds)) = CORRECTED.iter().find(|row| row.0 == index) else {
                assert_eq!(after, before, "unmodified clip {index}");
                continue;
            };
            assert_eq!(after["name"].as_str(), Some(*expected_name));
            assert_eq!(after["channels"], before["channels"]);
            let before_samplers = before["samplers"].as_array().unwrap();
            let after_samplers = after["samplers"].as_array().unwrap();
            assert_eq!(after_samplers.len(), before_samplers.len());
            changed_samplers += after_samplers.len();
            for (old_sampler, new_sampler) in before_samplers.iter().zip(after_samplers) {
                let mut restored_sampler = new_sampler.clone();
                for role in ["input", "output"] {
                    let old_index = old_sampler[role].as_u64().unwrap() as usize;
                    let new_index = new_sampler[role].as_u64().unwrap() as usize;
                    assert!(new_index >= old_accessors.len() && new_index < new_accessors.len());
                    assert!(appended.insert(new_index), "each appended accessor has one sampler role");
                    let (old_count, old_width, old_bytes) = samples(&old, old_index);
                    let (new_count, new_width, new_bytes) = samples(&new, new_index);
                    assert_eq!(new_count, *frame_count);
                    assert_eq!(old_count + 1, new_count);
                    assert_eq!(new_width, old_width);
                    assert_eq!(&new_bytes[..old_bytes.len()], old_bytes.as_slice(), "old {role} samples of clip {index}");
                    assert!(floats(&new_bytes[old_bytes.len()..]).iter().all(|v| v.is_finite()));
                    if role == "input" {
                        assert_eq!(new_width, 4);
                        let times = floats(&new_bytes);
                        assert!(times.windows(2).all(|w| w[0] < w[1]));
                        assert!((times.last().unwrap() - end_seconds).abs() < 0.000_01);
                    }
                    restored_sampler[role] = old_sampler[role].clone();
                }
                assert_eq!(restored_sampler, *old_sampler, "sampler policy/interpolation is preserved");
            }
        }
        assert_eq!(changed_samplers, 1053);
        assert_eq!(appended.len(), 2106);
        // Reversing only the documented append and six sampler redirects must
        // recover the whole original JSON, including mesh/skin/material data.
        let mut reverted = new.json.clone();
        reverted["accessors"].as_array_mut().unwrap().truncate(old_accessors.len());
        reverted["bufferViews"].as_array_mut().unwrap().truncate(old_views.len());
        reverted["buffers"] = old.json["buffers"].clone();
        for (index, _, _, _) in CORRECTED {
            reverted["animations"][index] = old_animations[index].clone();
        }
        assert!(reverted == old.json, "whole original JSON must reverse exactly");
        // Last-key timing is checked above; native duration/loop/hold semantics,
        // duplicate-joint binding and actual Gltf/GPU playback remain unqualified.
    }
}

#[cfg(test)]
#[path = "ezreal_joint_identity_binding_tests.rs"]
mod ezreal_joint_identity_binding_tests;
