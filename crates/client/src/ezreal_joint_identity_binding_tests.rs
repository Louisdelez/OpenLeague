//! Real CPU Gltf loading and WorldAsset instancing of the separate local model.
//! These tests require the actual selected asset to be installed by Root later.
//! No renderer, window, native 4.20 binding or exporter parity is claimed.
use super::*;
use bevy::{
    animation::{animated_field, AnimatedBy, AnimationPlugin, AnimationTargetId},
    asset::AssetApp,
    ecs::system::RunSystemOnce,
    gltf::{GltfNode, GltfPlugin, GltfSkin},
    mesh::{skinning::{SkinnedMesh, SkinnedMeshInverseBindposes}, MeshPlugin},
    transform::TransformPlugin,
    world_serialization::{WorldAsset, WorldSerializationPlugin},
};
use serde_json::Value;
use std::{collections::{BTreeMap, BTreeSet}, path::PathBuf, time::{Duration, Instant}};

const MODEL_BYTES: usize = 18_251_728;
const MODEL_SHA256: &str = "74827b456ff82b96474715df2d314da26907e8b0dc256b46d822ca7276a2b7b5";
const HAND: &str = "R_PARENTING_HAND_LOC";
const HAND_PATHS: [&[&str]; 3] = [
    &["skinned_mesh", "root", "waist", "chest", "R_shoulder", "R_uparm", "R_forearm", "R_hand", HAND],
    &["skinned_mesh", "root", "waist", "chest", "L_shoulder", "L_uparm", "L_forearm", HAND],
    &["skinned_mesh", "root", "waist", "chest", "R_shoulder", "R_uparm", "R_forearm", HAND],
];
const MOVING_HAND_PATH: &[&str] = &["skinned_mesh", "root", "waist", "chest", "R_shoulder", "R_uparm", "R_forearm", "R_hand"];

fn repository() -> PathBuf {
    std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..")
}

fn u32_at(bytes: &[u8], offset: usize) -> usize {
    u32::from_le_bytes(bytes[offset..offset + 4].try_into().unwrap()) as usize
}

fn model_document() -> Value {
    let path = repository().join("assets").join(EZREAL_JOINT_IDENTITY_ASSET);
    let bytes = std::fs::read(path).expect("separate local joint-identity asset must exist");
    assert_eq!(bytes.len(), MODEL_BYTES);
    assert_eq!(&bytes[..4], b"glTF");
    assert_eq!(u32_at(&bytes, 4), 2);
    assert_eq!(u32_at(&bytes, 8), bytes.len());
    assert_eq!(u32_at(&bytes, 16), 0x4e4f534a);
    let json_end = 20usize.checked_add(u32_at(&bytes, 12)).unwrap();
    assert!(json_end + 8 <= bytes.len());
    assert_eq!(u32_at(&bytes, json_end + 4), 0x004e4942);
    assert_eq!(json_end + 8 + u32_at(&bytes, json_end), bytes.len());
    let document: Value = serde_json::from_slice(&bytes[20..json_end]).unwrap();
    let manifest: Value = serde_json::from_slice(&std::fs::read(repository().join("assets-manifest.json")).unwrap()).unwrap();
    let expected_path = format!("assets/{EZREAL_JOINT_IDENTITY_ASSET}");
    let rows: Vec<_> = manifest["files"].as_array().unwrap().iter().filter(|r| r["path"] == expected_path).collect();
    assert_eq!(rows.len(), 1);
    assert_eq!(rows[0]["bytes"].as_u64(), Some(MODEL_BYTES as u64));
    assert_eq!(rows[0]["sha256"].as_str(), Some(MODEL_SHA256));
    // SHA is a declared distribution identity here. Root's separate immutable
    // before/after asset guards must calculate the actual file SHA256.
    document
}

fn document_paths(document: &Value) -> Vec<Vec<String>> {
    let nodes = document["nodes"].as_array().unwrap();
    let mut parents = BTreeMap::new();
    for (index, node) in nodes.iter().enumerate() {
        if let Some(children) = node["children"].as_array() {
            for child in children {
                let child = child.as_u64().unwrap() as usize;
                assert!(child < nodes.len() && parents.insert(child, index).is_none());
            }
        }
    }
    (0..nodes.len()).map(|index| {
        let mut chain = vec![index];
        let mut current = index;
        while let Some(parent) = parents.get(&current).copied() {
            assert!(!chain.contains(&parent), "model hierarchy must be acyclic");
            chain.push(parent); current = parent;
        }
        chain.into_iter().rev().map(|i| nodes[i]["name"].as_str().unwrap().to_owned()).collect()
    }).collect()
}

fn target_id(path: &[&str]) -> AnimationTargetId {
    AnimationTargetId::from_iter(path.iter().copied())
}

fn cpu_model() -> (App, Handle<Gltf>, Value) {
    let document = model_document();
    let mut app = App::new();
    // Combine the copied bevy_gltf test_app CPU pattern with the real animation
    // and WorldAsset systems. Keep mesh data: empty load_meshes would remove
    // the SkinnedMesh entities whose instance mappings this suite must verify.
    app.add_plugins((
        MinimalPlugins,
        AssetPlugin { file_path: repository().join("assets").to_str().unwrap().into(), ..default() },
        WorldSerializationPlugin,
        MeshPlugin,
        TransformPlugin,
        AnimationPlugin,
        GltfPlugin::default(),
    ))
    .init_asset::<Image>()
    .init_asset::<SkinnedMeshInverseBindposes>()
    .init_resource::<Catalog>();
    app.finish(); app.cleanup();
    let catalog = Catalog::default();
    let (request, _) = super::request(101, "ezreal", &catalog, app.world().resource::<AssetServer>());
    let model = request.model;
    let registered = app.world().resource::<AssetServer>().get_path(model.id()).unwrap();
    assert_eq!(registered.path(), std::path::Path::new(EZREAL_JOINT_IDENTITY_ASSET));
    let deadline = Instant::now() + Duration::from_secs(30);
    loop {
        app.update();
        let ready = app.world().resource::<Assets<Gltf>>().get(&model).is_some_and(|gltf| {
            let nodes = app.world().resource::<Assets<GltfNode>>();
            let clips = app.world().resource::<Assets<AnimationClip>>();
            let worlds = app.world().resource::<Assets<WorldAsset>>();
            gltf.nodes.len() == 73 && gltf.animations.len() == 52
                && gltf.nodes.iter().all(|handle| nodes.contains(handle))
                && gltf.animations.iter().all(|handle| clips.contains(handle))
                && gltf.scenes.first().is_some_and(|scene| worlds.contains(scene))
        });
        if ready { break; }
        assert!(Instant::now() < deadline, "real local joint-identity GLTF CPU load timed out");
        std::thread::sleep(Duration::from_millis(5));
    }
    (app, model, document)
}

#[test]
fn loaded_joint_model_preserves_all_nodes_curves_and_catalogue_identity() {
    let (app, model, document) = cpu_model();
    let gltf = app.world().resource::<Assets<Gltf>>().get(&model).unwrap();
    let nodes = app.world().resource::<Assets<GltfNode>>();
    let clips = app.world().resource::<Assets<AnimationClip>>();
    let paths = document_paths(&document);
    assert_eq!(paths.len(), 73);
    assert_eq!(paths.iter().collect::<BTreeSet<_>>().len(), 73);
    assert_eq!(gltf.nodes.len(), 73);
    for (index, node) in gltf.nodes.iter().enumerate() {
        let node = nodes.get(node).unwrap();
        assert_eq!(node.index, index);
        assert_eq!(node.name, document["nodes"][index]["name"].as_str().unwrap());
    }
    assert_eq!(gltf.skins.len(), 1);
    let skin = app.world().resource::<Assets<GltfSkin>>().get(&gltf.skins[0]).unwrap();
    assert_eq!(skin.joints.len(), 72);
    for (joint, handle) in skin.joints.iter().enumerate() {
        assert_eq!(nodes.get(handle).unwrap().index, joint + 1);
    }
    assert_eq!(app.world().resource::<Assets<SkinnedMeshInverseBindposes>>().get(&skin.inverse_bind_matrices).unwrap().len(), 72);
    // named_nodes is deliberately a lossy convenience map, not bone identity.
    assert_eq!(nodes.get(gltf.named_nodes.get(HAND).unwrap()).unwrap().index, 71);
    let catalog = Catalog::default();
    assert_eq!(catalog.0["ezreal"]["roles"]["spell1"].as_u64(), Some(38));
    assert_eq!(gltf.animations.len(), 52);
    let mut loaded_curve_total = 0usize;
    for (index, animation) in document["animations"].as_array().unwrap().iter().enumerate() {
        let name = animation["name"].as_str().unwrap();
        assert_eq!(catalog.0["ezreal"]["clips"][index].as_str(), Some(name));
        assert_eq!(gltf.named_animations.get(name).unwrap().id(), gltf.animations[index].id());
        let clip = clips.get(&gltf.animations[index]).unwrap();
        let loaded_curve_count = clip.curves().values().map(Vec::len).sum::<usize>();
        let declared_channel_count = animation["channels"].as_array().unwrap().len();
        assert_eq!(loaded_curve_count, declared_channel_count, "every declared channel must load for clip {index}/{name}");
        loaded_curve_total += loaded_curve_count;
        let ids = HAND_PATHS.map(target_id);
        assert_ne!(ids[0], ids[1]); assert_ne!(ids[0], ids[2]); assert_ne!(ids[1], ids[2]);
        assert!(clip.curves_for_target(ids[0]).is_none());
        assert!(clip.curves_for_target(ids[1]).is_none());
        assert_eq!(clip.curves_for_target(ids[2]).unwrap().len(), 3);
    }
    assert_eq!(loaded_curve_total, 8_415, "all 52 clips must retain every declared channel");
    let clip = clips.get(&gltf.animations[38]).unwrap();
    let id = target_id(HAND_PATHS[2]);
    assert!(clip.sample_clamped(animated_field!(Transform::translation), id, 0.5).is_some());
    assert!(clip.sample_clamped(animated_field!(Transform::rotation), id, 0.5).is_some());
    assert!(clip.sample_clamped(animated_field!(Transform::scale), id, 0.5).is_some());
    let moving = target_id(MOVING_HAND_PATH);
    let start = clip.sample_clamped(animated_field!(Transform::rotation), moving, 0.).unwrap();
    let later = clip.sample_clamped(animated_field!(Transform::rotation), moving, 0.5).unwrap();
    assert!(start.dot(later).abs() < 0.999, "the real Q R_hand curve must exercise different poses");
}

fn descendants(world: &World, root: Entity) -> Vec<Entity> {
    let mut stack = world.get::<Children>(root).map(|children| children.iter().collect::<Vec<_>>()).unwrap_or_default();
    let mut found = Vec::new();
    while let Some(entity) = stack.pop() {
        assert!(!found.contains(&entity), "instance hierarchy must be a tree");
        found.push(entity);
        if let Some(children) = world.get::<Children>(entity) { stack.extend(children.iter()); }
    }
    found
}

fn instance_nodes(world: &World, outer: Entity, paths: &[Vec<String>]) -> Option<Vec<Entity>> {
    let descendants = descendants(world, outer);
    let roots: Vec<_> = descendants.iter().copied().filter(|entity| world.get::<Name>(*entity).is_some_and(|name| name.as_str() == "skinned_mesh")).collect();
    if roots.is_empty() { return None; }
    assert_eq!(roots.len(), 1);
    let model_root = roots[0];
    if world.get::<Actor>(model_root).is_none() { return None; }
    let mut by_path = BTreeMap::new();
    for entity in std::iter::once(model_root).chain(descendants.iter().copied().filter(|entity| *entity != model_root)) {
        let mut current = entity;
        let mut names = Vec::new();
        loop {
            let Some(name) = world.get::<Name>(current) else { break; };
            names.push(name.as_str().to_owned());
            if current == model_root { names.reverse(); assert!(by_path.insert(names, entity).is_none()); break; }
            let Some(parent) = world.get::<ChildOf>(current) else { break; };
            current = parent.parent();
        }
    }
    paths.iter().map(|path| by_path.get(path).copied()).collect()
}

fn near_vec(actual: Vec3, expected: Vec3) { assert!((actual - expected).length() < 0.0001); }
fn near_quat(actual: Quat, expected: Quat) { assert!(actual.normalize().dot(expected.normalize()).abs() > 0.99999); }

#[test]
fn real_world_instances_keep_homonymous_joints_and_sample_independently() {
    let (mut app, model, document) = cpu_model();
    let paths = document_paths(&document);
    let catalog = Catalog::default();
    let mut outer = Vec::new();
    for id in [101, 202] {
        let (request, _) = super::request(id, "ezreal", &catalog, app.world().resource::<AssetServer>());
        assert_eq!(request.model.id(), model.id());
        outer.push(app.world_mut().spawn((request, Transform::default())).id());
    }
    app.world_mut().run_system_once(load_models).unwrap();
    let deadline = Instant::now() + Duration::from_secs(30);
    let instances = loop {
        app.update();
        if let (Some(a), Some(b)) = (instance_nodes(app.world(), outer[0], &paths), instance_nodes(app.world(), outer[1], &paths)) { break [a, b]; }
        assert!(Instant::now() < deadline, "two real WorldAssetRoot/ready instances timed out");
        std::thread::sleep(Duration::from_millis(5));
    };
    let a: BTreeSet<_> = instances[0].iter().copied().collect();
    let b: BTreeSet<_> = instances[1].iter().copied().collect();
    assert_eq!(a.len(), 73); assert_eq!(b.len(), 73); assert!(a.is_disjoint(&b));
    let ids = HAND_PATHS.map(target_id);
    for (instance, entities) in instances.iter().enumerate() {
        let player = entities[0];
        assert!(app.world().get::<AnimationPlayer>(player).is_some());
        assert_eq!(app.world().get::<Actor>(player).unwrap().playback.id, [101, 202][instance]);
        let matches: Vec<_> = descendants(app.world(), outer[instance]).into_iter().filter(|entity| app.world().get::<Name>(*entity).is_some_and(|n| n.as_str() == HAND)).collect();
        assert_eq!(matches.len(), 3);
        for (slot, node) in [60, 70, 71].into_iter().enumerate() {
            assert_eq!(app.world().get::<AnimationTargetId>(entities[node]), Some(&ids[slot]));
            assert_eq!(app.world().get::<AnimatedBy>(entities[node]).unwrap().0, player);
        }
        let skins: Vec<_> = descendants(app.world(), outer[instance]).into_iter().filter_map(|entity| app.world().get::<SkinnedMesh>(entity)).collect();
        assert!(!skins.is_empty(), "real loaded mesh must carry SkinnedMesh");
        for skin in skins {
            assert_eq!(skin.joints.len(), 72);
            for (joint, entity) in skin.joints.iter().enumerate() { assert_eq!(*entity, entities[joint + 1]); }
        }
    }
    let clip = {
        let gltf = app.world().resource::<Assets<Gltf>>().get(&model).unwrap();
        app.world().resource::<Assets<AnimationClip>>().get(&gltf.animations[38]).unwrap().clone()
    };
    let rest: Vec<_> = instances.iter().map(|entities| [60, 70].map(|node| *app.world().get::<Transform>(entities[node]).unwrap())).collect();
    for (instance, entities) in instances.iter().enumerate() {
        let player = entities[0];
        // ready bound the actual production graph. Remove its idle transition
        // bookkeeping only for this direct animation-system sampling exercise.
        app.world_mut().entity_mut(player).remove::<AnimationTransitions>();
        let index = app.world().get::<Actor>(player).unwrap().playback.roles["spell1"];
        let mut active_player = app.world_mut().get_mut::<AnimationPlayer>(player).unwrap();
        active_player.stop_all();
        let active = active_player.play(index);
        active.set_seek_time([0., 0.5][instance]); active.pause();
    }
    app.update(); app.update();
    for (instance, entities) in instances.iter().enumerate() {
        let time = [0., 0.5][instance];
        for node in [10, 71] {
            let id = if node == 10 { target_id(MOVING_HAND_PATH) } else { ids[2] };
            let actual = app.world().get::<Transform>(entities[node]).unwrap();
            near_vec(actual.translation, clip.sample_clamped(animated_field!(Transform::translation), id, time).unwrap());
            near_quat(actual.rotation, clip.sample_clamped(animated_field!(Transform::rotation), id, time).unwrap());
            near_vec(actual.scale, clip.sample_clamped(animated_field!(Transform::scale), id, time).unwrap());
        }
        for (slot, node) in [60, 70].into_iter().enumerate() {
            assert_eq!(*app.world().get::<Transform>(entities[node]).unwrap(), rest[instance][slot], "unanimated homonym local rest must remain its own; ancestors may still move");
        }
    }
    let first = app.world().get::<Transform>(instances[0][10]).unwrap().rotation;
    let second = app.world().get::<Transform>(instances[1][10]).unwrap().rotation;
    assert!(first.normalize().dot(second.normalize()).abs() < 0.999, "different instance Q phases must not cross-animate");
}
