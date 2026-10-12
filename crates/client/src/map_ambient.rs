//! Full native ambient loops, separate from authoritative champion/altar animation.
use bevy::{
    prelude::*,
    world_serialization::{WorldAssetRoot, WorldInstanceReady},
};
use std::collections::{HashMap, HashSet};

#[derive(Resource)]
pub struct Catalog(serde_json::Value);
impl Default for Catalog {
    fn default() -> Self {
        Self(
            serde_json::from_str(include_str!("../../../data/4.20/map_ambient_manifest.json"))
                .expect("native ambient manifest"),
        )
    }
}
#[derive(Component)]
pub struct Request {
    model: Handle<Gltf>,
    pub(crate) native: String,
    pub(crate) id: String,
}
#[derive(Component, Clone)]
pub struct Playback {
    _model: Handle<Gltf>,
    graph: Handle<AnimationGraph>,
    pub(crate) clip: AnimationNodeIndex,
    pub(crate) id: String,
    pub(crate) native: String,
    name: String,
    duration: f32,
}
#[derive(Component)]
pub struct AmbientPlayer(pub(crate) Playback, pub(crate) Entity);
#[derive(Component)]
pub struct Suppressed;
#[derive(Resource, Default)]
pub struct Probe {
    started: Option<f64>,
    poses: HashMap<Entity, [f32; 16]>,
    finished: bool,
}

pub fn setup(mut commands: Commands, assets: Res<AssetServer>, catalog: Res<Catalog>) {
    let hidden = std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some()
        && std::env::var("OPENLEAGUE_PROBE_ENV_ONLY").as_deref() == Ok("1");
    for placement in catalog.0["placements"].as_array().expect("placements") {
        let native = placement["native_asset"].as_str().unwrap();
        let id = placement["id"].as_str().unwrap();
        let mut matrix = [0f32; 16];
        for (i, value) in placement["matrix"].as_array().unwrap().iter().enumerate() {
            matrix[i] = value.as_f64().unwrap() as f32;
        }
        commands.spawn((
            Name::new(format!("OpenLeagueAmbient::{id}")),
            crate::map_coordinates::ambient_transform(Mat4::from_cols_array(&matrix),
                crate::terrain_material::native_map_extent()).expect("qualified legacy ambient placement"),
            if hidden {
                Visibility::Hidden
            } else {
                Visibility::Inherited
            },
            Request {
                model: assets.load(
                    catalog.0["assets"][native]["asset"]
                        .as_str()
                        .unwrap()
                        .to_owned(),
                ),
                native: native.into(),
                id: id.into(),
            },
        ));
    }
}

pub fn hide_embedded(
    mut commands: Commands,
    catalog: Res<Catalog>,
    mut nodes: Query<(Entity, &Name, &mut Visibility), Without<Suppressed>>,
) {
    let hidden: HashSet<&str> = catalog.0["hidden_embedded_roots"]
        .as_array()
        .unwrap()
        .iter()
        .map(|s| s.as_str().unwrap())
        .collect();
    for (entity, name, mut visibility) in &mut nodes {
        if hidden.contains(name.as_str()) {
            *visibility = Visibility::Hidden;
            commands.entity(entity).insert(Suppressed);
        }
    }
}

pub fn load_models(
    mut commands: Commands,
    models: Res<Assets<Gltf>>,
    mut clips: ResMut<Assets<AnimationClip>>,
    catalog: Res<Catalog>,
    mut graphs: ResMut<Assets<AnimationGraph>>,
    requests: Query<(Entity, &Request)>,
) {
    for (entity, request) in &requests {
        let Some(model) = models.get(&request.model) else {
            continue;
        };
        let entry = &catalog.0["assets"][&request.native];
        let selected = entry["primary_clip"].as_u64().unwrap() as usize;
        let name = entry["primary_name"].as_str().unwrap();
        let clip_handle = model
            .named_animations
            .get(name)
            .expect("native primary clip name");
        assert_eq!(
            model.animations.get(selected),
            Some(clip_handle),
            "native clip index/name mismatch"
        );
        let Some(mut clip) = clips.get_mut(clip_handle) else {
            continue;
        };
        let duration = entry["duration"].as_f64().unwrap() as f32;
        assert!(
            (clip.duration() - duration).abs() < 0.001,
            "native animation truncated"
        );
        let duration = crate::map_events::native_period(&request.native);
        clip.set_duration(duration);
        let (graph, indices) = AnimationGraph::from_clips(model.animations.clone());
        let playback = Playback {
            _model: request.model.clone(),
            graph: graphs.add(graph),
            clip: indices[selected],
            id: request.id.clone(),
            native: request.native.clone(),
            name: name.into(),
            duration,
        };
        commands
            .entity(entity)
            .insert((
                WorldAssetRoot(model.scenes.first().expect("native scene").clone()),
                crate::actor_fow::Root,
                playback,
            ))
            .remove::<Request>()
            .observe(ready);
    }
}

fn ready(
    event: On<WorldInstanceReady>,
    mut commands: Commands,
    children: Query<&Children>,
    roots: Query<&Playback>,
    mut players: Query<&mut AnimationPlayer>,
) {
    let Ok(playback) = roots.get(event.entity) else {
        return;
    };
    for entity in children.iter_descendants(event.entity) {
        if let Ok(mut player) = players.get_mut(entity) {
            player.play(playback.clip).repeat();
            commands.entity(entity).insert((
                AnimationGraphHandle(playback.graph.clone()),
                AmbientPlayer(playback.clone(), event.entity),
            ));
            println!(
                "OpenLeague native ambient loop: {} / {} / {:.6}s",
                playback.id, playback.name, playback.duration
            );
        }
    }
}

pub fn probe(
    time: Res<Time>,
    catalog: Res<Catalog>,
    mut probe: ResMut<Probe>,
    players: Query<(&AnimationPlayer, &AmbientPlayer)>,
    roots: Query<(Entity, &Playback, &GlobalTransform)>,
    children: Query<&Children>,
    transforms: Query<&Transform>,
    suppressed: Query<&Name, With<Suppressed>>,
) {
    let Ok(path) = std::env::var("OPENLEAGUE_AMBIENT_PROBE") else {
        return;
    };
    if path.is_empty() {
        return;
    }
    if probe.finished
        || players.iter().count() != catalog.0["placements"].as_array().unwrap().len()
        || suppressed.iter().count() != catalog.0["hidden_embedded_roots"].as_array().unwrap().len()
    {
        return;
    }
    let now = time.elapsed_secs_f64();
    if probe.started.is_none() {
        for (root, _, _) in &roots {
            for entity in children.iter_descendants(root) {
                if let Ok(transform) = transforms.get(entity) {
                    probe
                        .poses
                        .insert(entity, transform.to_matrix().to_cols_array());
                }
            }
        }
        probe.started = Some(now);
        return;
    }
    if now - probe.started.unwrap() < 5.0 {
        return;
    }
    let poses: Vec<_> = roots.iter().map(|(root, playback, global)| {
        let mut changed = 0;
        let mut max_delta = 0f32;
        for entity in children.iter_descendants(root) {
            if let (Some(before), Ok(current)) = (probe.poses.get(&entity), transforms.get(entity)) {
                let delta = before.iter().zip(current.to_matrix().to_cols_array()).map(|(a,b)| (a-b).abs()).fold(0f32, f32::max);
                max_delta = max_delta.max(delta);
                if delta > 0.00001 { changed += 1; }
            }
        }
        serde_json::json!({"id":playback.id,"native_asset":playback.native,"changed_local_transforms":changed,"max_local_matrix_delta":max_delta,"world_matrix":global.to_matrix().to_cols_array()})
    }).collect();
    let loops: Vec<_> = players.iter().map(|(player, ambient)| {
        let active = player.animation(ambient.0.clip).expect("native loop active");
        serde_json::json!({"id":ambient.0.id,"native_asset":ambient.0.native,"clip":ambient.0.name,"duration":ambient.0.duration,"elapsed":active.elapsed(),"seek_time":active.seek_time(),"finished":active.is_finished()})
    }).collect();
    let report = serde_json::json!({"sample_interval_seconds":now-probe.started.unwrap(),"players":loops,"poses":poses,"suppressed_roots":suppressed.iter().map(|n| n.as_str()).collect::<Vec<_>>(),"complete":false,"scope":"Native primary ambient loops only; native blend/event/FX/audio graphs and full visual fidelity remain incomplete"});
    let path = std::path::PathBuf::from(path);
    if !path.is_absolute() || path.parent() != Some(std::path::Path::new(r"E:\OpenLeague\logs")) {
        eprintln!("Ignoring ambient probe path outside project logs");
        probe.finished = true;
        return;
    }
    std::fs::write(path, serde_json::to_vec_pretty(&report).unwrap()).expect("write ambient probe");
    probe.finished = true;
}

#[cfg(test)]
impl AmbientPlayer {
 pub(crate) fn clock_test_fixture(clip:AnimationNodeIndex,root:Entity)->Self {
  Self(Playback{_model:Handle::default(),graph:Handle::default(),clip,id:"clock-test".into(),native:"clock-test".into(),name:"clock-test".into(),duration:1.},root)
 }
}
