//! Original TT_Relic GLB. Visibility/lifetime follow the accepted server state.
//! Idle playback is a local presentation binding; native pickup clip timing is unknown.
use bevy::{prelude::*, world_serialization::{WorldAssetRoot, WorldInstanceReady}};
use crate::{Connection, Match};

const ASSET: &str = "forms/tt_relic.glb";
const IDLE: &str = "OdinHealthRelic_Idle";
const IDLE_INDEX: usize = 3;
#[derive(Component)] struct Relic;
#[derive(Component)] struct Pending(Handle<Gltf>);
#[derive(Component)] struct Ready {
    _model: Handle<Gltf>,
    graph: Handle<AnimationGraph>,
    idle: AnimationNodeIndex,
}
#[derive(Resource, Default)] struct Live { owner: Option<(u64, Entity)> }

pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self, app: &mut App) {
        app.init_resource::<Live>()
            .add_systems(Update, (update, load).chain().after(crate::receive)
                .before(crate::render_probe::capture));
    }
}

fn placement(snapshot: &openleague_core::Snapshot, session: Option<u64>, ready: bool)
    -> Option<(u64, Transform)> {
    if !ready || session != Some(snapshot.session) || snapshot.winner.is_some() { return None; }
    let map = snapshot.map10.as_ref()?;
    if !map.relic_visible || !map.relic_available { return None; }
    let point = Vec3::new(map.relic_position.x, map.relic_height, map.relic_position.z);
    if !point.is_finite() { return None; }
    let units = crate::map_coordinates::NATIVE_UNITS_PER_WORLD_UNIT;
    Some((snapshot.session, Transform::from_translation(point / units)
        .with_scale(Vec3::splat(1. / units))))
}

fn update(mut commands: Commands, state: Res<Match>, connection: Res<Connection>,
    assets: Res<AssetServer>, mut live: ResMut<Live>, mut roots: Query<&mut Transform, With<Relic>>) {
    let desired = state.snapshot.as_ref().and_then(|s| placement(s, connection.session, connection.ready()));
    if let Some((session, entity)) = live.owner {
        if let Some((desired_session, transform)) = desired.as_ref() {
            if session == *desired_session {
                if let Ok(mut existing) = roots.get_mut(entity) { *existing = *transform; return; }
            }
        }
        if let Ok(mut entity_commands) = commands.get_entity(entity) { entity_commands.despawn(); }
        live.owner = None;
    }
    if let Some((session, transform)) = desired {
        let entity = commands.spawn((Relic, Name::new("OpenLeague::Map10Relic"), transform,
            Visibility::Inherited, Pending(assets.load(ASSET)))).id();
        live.owner = Some((session, entity));
    }
}

fn load(mut commands: Commands, models: Res<Assets<Gltf>>, clips: Res<Assets<AnimationClip>>,
    mut graphs: ResMut<Assets<AnimationGraph>>, pending: Query<(Entity, &Pending)>) {
    for (entity, pending) in &pending {
        let Some(model) = models.get(&pending.0) else { continue; };
        let Some(idle) = model.named_animations.get(IDLE) else {
            error!("TT_Relic lacks the verified idle clip"); continue;
        };
        if model.animations.get(IDLE_INDEX) != Some(idle) {
            error!("TT_Relic idle name/index mismatch"); continue;
        }
        if clips.get(idle).is_none() { continue; }
        let Some(scene) = model.scenes.first() else { continue; };
        let (graph, indices) = AnimationGraph::from_clips(model.animations.clone());
        commands.entity(entity).insert((WorldAssetRoot(scene.clone()), crate::actor_fow::Root,
            Ready { _model: pending.0.clone(), graph: graphs.add(graph), idle: indices[IDLE_INDEX] }))
            .remove::<Pending>().observe(start_idle);
    }
}

fn start_idle(event: On<WorldInstanceReady>, mut commands: Commands, roots: Query<&Ready>,
    children: Query<&Children>, mut players: Query<&mut AnimationPlayer>) {
    let Ok(ready) = roots.get(event.entity) else { return; };
    for entity in children.iter_descendants(event.entity) {
        if let Ok(mut player) = players.get_mut(entity) {
            player.play(ready.idle).repeat();
            commands.entity(entity).insert(AnimationGraphHandle(ready.graph.clone()));
        }
    }
}

#[cfg(test)]
#[path = "map_relic_world_tests.rs"]
mod tests;
