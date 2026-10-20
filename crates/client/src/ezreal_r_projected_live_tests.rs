use super::*;
use bevy::{asset::RenderAssetUsages, mesh::PrimitiveTopology};
use openleague_core::Point;

#[derive(Resource)]
struct Input { frame: Frame, samples: Vec<CurrentR3d> }
fn host(mut commands: Commands, mut live: ResMut<Live>, mut current: ResMut<Current>,
    mut meshes: ResMut<Assets<Mesh>>, mut materials: ResMut<Assets<StrictMaterial>>,
    surfaces: Res<TerrainSurfaces>, profile: Res<Profile>, input: Res<Input>, owned: OwnedQuery) {
    let result = synchronize(&mut commands, &mut live, &mut current, &mut meshes,
        &mut materials, &surfaces, &profile, &input.frame, &input.samples, &owned);
    if let Err(error) = result {
        clear(&mut live, &mut current, &mut commands, &mut meshes, &mut materials);
        live.last_error = Some(error);
    }
}
fn sample(session: u64) -> CurrentR3d {
    CurrentR3d { key: Key { session, owner: 17, team: 0, ordinal: 5 }, incarnation: 1,
        position: Point { x: 7684., z: 6934. }, y_native: 149.5,
        direction: Point { x: 1., z: 0. }, sample_tick: 50, frame_ordinal: 9 }
}
// Concrete ECS/receiver fixture. This triangle is deliberately a test fixture,
// not an assertion that a restored GLB, GPU, client window or native PE ran.
fn app() -> (App, Entity) {
    let (snapshot, viewer, map, sources, texture, mut images) =
        crate::fow_visibility_texture::transport_snapshot_tests::published_fixture();
    let team = snapshot.roster.iter().find(|row| row.id == viewer).unwrap().team;
    let source = sources.mask_stamp(&map, snapshot.session, team).unwrap();
    let mut app = App::new();
    let camera = app.world_mut().spawn_empty().id();
    let tex = images.add(Image::default()); let color = images.add(Image::default());
    let overlay = images.add(Image::default()); let visibility = images.add(Image::default());
    app.insert_resource(Profile { authored: Authored::load().unwrap(), texture: tex, color, overlay })
        .insert_resource(Input { frame: Frame { frontier: Frontier { source, accepted_epoch: 7, camera },
            visibility, params: Vec4::ONE, edge: Vec4::ONE }, samples: vec![sample(snapshot.session)] })
        .init_resource::<Live>().init_resource::<Current>().init_resource::<Assets<Mesh>>()
        .init_resource::<Assets<StrictMaterial>>().init_resource::<TerrainSurfaces>()
        .init_resource::<crate::native_environment_draw::Quality>()
        .add_message::<AssetEvent<Mesh>>()
        .add_systems(Update, (crate::projected_terrain::collect, host).chain());
    let tree: openleague_core::native_projected_receivers::Receivers =
        serde_json::from_str(include_str!("../../../data/4.20/map10_receiver_tree.json")).unwrap();
    let object = *tree.select([7084., 6334., 8284., 7534.], 3).unwrap().first().unwrap();
    let mut mesh = Mesh::new(PrimitiveTopology::TriangleList, RenderAssetUsages::default());
    mesh.insert_attribute(Mesh::ATTRIBUTE_POSITION, vec![
        [380., 5., 340.], [390., 7., 340.], [380., 8., 350.]]);
    let handle = app.world_mut().resource_mut::<Assets<Mesh>>().add(mesh);
    let terrain = app.world_mut().spawn((Mesh3d(handle), GlobalTransform::IDENTITY,
        bevy::gltf::GltfMeshName(format!("MapGeo_Instance_{object}")))).id();
    // These are real CPU publication resources; they grant no GPU readiness.
    app.insert_resource(images).insert_resource(map).insert_resource(sources).insert_resource(texture);
    (app, terrain)
}

#[test]
fn projected_profile_matches_original_group2_offsets_and_exact_texture_names() {
    let bytes = include_bytes!("../../../data/4.20/particles/ezreal/Ezreal_TrueShot_mis.troybin");
    assert_eq!(bytes.len(), 4141);
    let field = |key: usize, value: usize, hash: u32| {
        assert_eq!(u32::from_le_bytes(bytes[key..key+4].try_into().unwrap()), hash);
        let offset = u16::from_le_bytes(bytes[value..value+2].try_into().unwrap()) as usize + 2933;
        let end = bytes[offset..].iter().position(|b| *b == 0).unwrap() + offset;
        std::str::from_utf8(&bytes[offset..end]).unwrap()
    };
    assert_eq!(field(1033, 2305, 102142779), "Projected");
    let authored = Authored::load().unwrap();
    assert_eq!(field(2181, 2879, 3825555067).parse::<f32>().unwrap(), authored.particle_scale);
    assert_eq!(field(1393, 2485, 1173480762).parse::<f32>().unwrap(), authored.range);
    assert_eq!(field(2137, 2857, 3605511176).parse::<f32>().unwrap(), authored.fading);
    assert_eq!(field(1485, 2531, 1620417932), "disintegrate-light.dds");
    assert_eq!(field(1293, 2435, 692597219), "color-hold.tga");
    assert_eq!(u32::from_le_bytes(bytes[153..157].try_into().unwrap()), 2403397097);
    assert_eq!(bytes[216], 7);
    let png = include_bytes!("../../../assets/particles/ezreal/r_projected/color-hold.png");
    assert_eq!(&png[..8], b"\x89PNG\r\n\x1a\n");
    assert_eq!(u32::from_be_bytes(png[16..20].try_into().unwrap()), 8);
    assert_eq!(u32::from_be_bytes(png[20..24].try_into().unwrap()), 8);
}

#[test]
fn current_xyz_enters_native_height_shader_input_without_ground_or_actor_lookup() {
    let a = Authored::load().unwrap(); let sample = sample(9); let p = a.projection(&sample).unwrap();
    assert_eq!(p.native_height, Some(Vec3::new(sample.y_native, 250., 100.)));
    assert_eq!(p.native_bounds_xz, Vec4::new(7084., 6334., 8284., 7534.));
    assert!((p.uv(Vec3::new(sample.position.x/20., 900., sample.position.z/20.)) - Vec2::splat(0.5)).abs().max_element() < 0.00001);
    assert_eq!(p.height_factor(Vec3::new(0., (sample.y_native+300.)/20., 0.)), 0.5);
    let mut bad = sample; bad.y_native = f32::NAN; assert!(a.projection(&bad).is_none());
    bad = sample; bad.position.x = f32::INFINITY; assert!(a.projection(&bad).is_none());
    bad = sample; bad.direction.z = f32::NEG_INFINITY; assert!(a.projection(&bad).is_none());
    // Projected particle angle is separate from missile orientation. Retain
    // the direction in sample identity; this bounded profile has angle0.
    let mut turned = sample; turned.direction = Point { x: 0., z: -1. };
    assert_eq!(a.projection(&turned).unwrap().world_to_uv, p.world_to_uv);
}

#[test]
fn host_spawns_unique_no_batch_draws_and_preserves_foreign_materials_on_loss() {
    let (mut app, _) = app();
    let second = { let mut s = app.world().resource::<Input>().samples[0]; s.key.ordinal += 1; s };
    app.world_mut().resource_mut::<Input>().samples.push(second);
    let foreign = app.world_mut().resource_mut::<Assets<StrictMaterial>>()
        .add(StrictMaterial::new(ProjectedMaterial::default()));
    let entity = app.world_mut().spawn(MeshMaterial3d(foreign.clone())).id();
    app.update(); assert_eq!(app.world().resource::<Live>().rows.len(), 2);
    assert_eq!(app.world().resource::<Current>().test_len(), 2);
    let mut ids = BTreeSet::new();
    for draw in app.world().resource::<Live>().rows.values() {
        assert!(app.world().get::<NoAutomaticBatching>(draw.entity).is_some());
        assert!(app.world().get::<bevy::light::NotShadowCaster>(draw.entity).is_some());
        assert!(ids.insert(draw.material.id()));
        assert_eq!(app.world().resource::<Current>().test_admission(draw.entity).unwrap().pool_incarnation, 1);
    }
    app.world_mut().resource_mut::<Current>().invalidate();
    app.world_mut().resource_mut::<Input>().samples.clear(); app.update();
    assert_eq!(app.world().resource::<Current>().test_len(), 0);
    assert!(app.world().resource::<Live>().rows.is_empty());
    assert_eq!(app.world().resource::<Assets<StrictMaterial>>().len(), 1);
    assert!(app.world().get_entity(entity).is_ok());
    assert!(app.world().resource::<Assets<StrictMaterial>>().contains(foreign.id()));
}

#[test]
fn paused_xyz_keeps_provenance_but_reauthorizes_under_current_fow_and_then_retires() {
    let (mut app, _) = app();
    let (mut snapshot, viewer, mut map, mut sources, _, _) =
        crate::fow_visibility_texture::transport_snapshot_tests::published_fixture();
    let team = snapshot.roster.iter().find(|r| r.id == viewer).unwrap().team;
    snapshot.roster.iter_mut().find(|r| r.id == viewer).unwrap().champion = "ezreal".into();
    snapshot.players.iter_mut().find(|p| p.id == viewer).unwrap().champion = "ezreal".into();
    snapshot.ezreal_r_projectiles = vec![openleague_core::ezreal_r::VisibleMissile {
        session: snapshot.session, owner: viewer, team, ordinal: 5,
        position: Point { x: 7684., z: 6934. }, direction: Point { x: 1., z: 0. },
    }];
    let height = |snapshot: &mut openleague_core::Snapshot, y: f32| {
        snapshot.ezreal_r_current_heights = Some(serde_json::json!({
            "policy": openleague_core::ezreal_r::CURRENT_HEIGHT_POLICY,
            "rows": [{"owner": viewer, "team": team, "ordinal": 5, "y_native": y}],
        }));
    };
    height(&mut snapshot, 149.5);
    let context = openleague_core::session_transport::Context { session: snapshot.session, player: viewer, epoch: 7 };
    let mut state = crate::ezreal_r_passive_presentation::State::default();
    state.reset_session(snapshot.session, viewer); state.begin_epoch(Some(7));
    state.observe_accepted_frame(&snapshot, viewer, 2., false, true, Some((context, 9))).unwrap();
    { let mut input = app.world_mut().resource_mut::<Input>();
        input.samples = state.r_samples_3d(&snapshot, viewer, snapshot.session, Some(7), 2., true);
        input.frame.frontier.source = sources.mask_stamp(&map, snapshot.session, team).unwrap(); }
    app.update();
    let key = app.world().resource::<Input>().samples[0].key;
    let draw = &app.world().resource::<Live>().rows[&key];
    let (entity, mesh, material, frozen, revision) =
        (draw.entity, draw.mesh.id(), draw.material.id(), draw.sample, draw.input_revision);
    assert_eq!((frozen.sample_tick, frozen.frame_ordinal), (snapshot.tick, 9));
    let old = app.world().resource::<Current>().test_admission(entity).unwrap();
    // A real accepted OLSR ordinal advances while pause freezes the entire XYZ
    // sample and its provenance. Receive revokes before the newest frame wins.
    app.world_mut().resource_mut::<Current>().invalidate();
    snapshot.tick += 1; snapshot.ezreal_r_projectiles[0].position.x += 900.;
    height(&mut snapshot, -45.);
    state.observe_accepted_frame(&snapshot, viewer, 2., true, true, Some((context, 10))).unwrap();
    crate::fow_champion_sources::mask_provenance_tests::cycle(&mut sources, &snapshot, viewer, &mut map).unwrap();
    { let mut input = app.world_mut().resource_mut::<Input>();
        input.samples = state.r_samples_3d(&snapshot, viewer, snapshot.session, Some(7), 2., true);
        assert_eq!(input.samples, vec![frozen]);
        input.frame.frontier.source = sources.mask_stamp(&map, snapshot.session, team).unwrap(); }
    app.update();
    let draw = &app.world().resource::<Live>().rows[&key];
    assert_eq!(draw.sample, frozen); assert_eq!(draw.input_revision, revision);
    assert_eq!((draw.entity, draw.mesh.id(), draw.material.id()), (entity, mesh, material));
    let new = app.world().resource::<Current>().test_admission(entity).unwrap();
    assert!(new.token > old.token);
    assert_eq!(new.frontier.source.represented_tick, snapshot.tick);
    assert_eq!(new.frontier.source.represented_tick, frozen.sample_tick + 1);
    assert_eq!(draw.sample.frame_ordinal, 9, "current authorization must not relabel sample provenance");
    // The next accepted packet lacks only Y: XZ remains valid but the real
    // 3D State and owned draw must both disappear, including while paused.
    app.world_mut().resource_mut::<Current>().invalidate();
    snapshot.ezreal_r_current_heights = None;
    state.observe_accepted_frame(&snapshot, viewer, 2., true, true, Some((context, 11))).unwrap();
    assert_eq!(state.r_samples(&snapshot, viewer, snapshot.session, Some(7), 2., true).len(), 1);
    app.world_mut().resource_mut::<Input>().samples =
        state.r_samples_3d(&snapshot, viewer, snapshot.session, Some(7), 2., true);
    assert!(app.world().resource::<Input>().samples.is_empty());
    app.update();
    assert!(app.world().resource::<Current>().test_admission(entity).is_none());
    assert!(app.world().get_entity(entity).is_err());
}

#[test]
fn same_batch_y_gap_incarnation_change_rebuilds_and_updates_only_owned_inputs() {
    let (mut app, _) = app(); app.update();
    let key = app.world().resource::<Input>().samples[0].key;
    let draw = &app.world().resource::<Live>().rows[&key];
    let (old, old_material) = (draw.entity, draw.material.id());
    app.world_mut().resource_mut::<Current>().invalidate();
    { let mut input = app.world_mut().resource_mut::<Input>();
        let sample = &mut input.samples[0]; sample.incarnation += 1;
        sample.y_native += 50.; sample.frame_ordinal += 2; }
    app.update();
    let draw = &app.world().resource::<Live>().rows[&key];
    assert_ne!(draw.entity, old); assert_ne!(draw.material.id(), old_material);
    assert_eq!(draw.sample.y_native, 199.5);
    assert!(app.world().get_entity(old).is_err());
    assert!(!app.world().resource::<Assets<StrictMaterial>>().contains(old_material));
}

#[test]
fn geometry_transform_or_removal_rebuilds_or_withholds_the_projected_draw() {
    let (mut app, terrain) = app(); app.update();
    let key = app.world().resource::<Input>().samples[0].key;
    let old = app.world().resource::<Live>().rows[&key].entity;
    app.world_mut().entity_mut(terrain).insert(GlobalTransform::from_translation(Vec3::Y));
    app.update(); assert_ne!(app.world().resource::<Live>().rows[&key].entity, old);
    app.world_mut().entity_mut(terrain).despawn(); app.update();
    assert!(app.world().resource::<Live>().rows.is_empty());
    assert_eq!(app.world().resource::<Current>().test_len(), 0);
}

#[test]
fn missing_no_batch_duplicate_identity_and_revision_overflow_revoke_all_owned_draws() {
    let (mut app, _) = app(); app.update();
    let key = app.world().resource::<Input>().samples[0].key;
    let old = app.world().resource::<Live>().rows[&key].entity;
    app.world_mut().entity_mut(old).remove::<NoAutomaticBatching>(); app.update();
    assert_ne!(app.world().resource::<Live>().rows[&key].entity, old);
    let duplicate = app.world().resource::<Input>().samples[0];
    app.world_mut().resource_mut::<Input>().samples.push(duplicate); app.update();
    assert!(app.world().resource::<Live>().rows.is_empty());
    assert_eq!(app.world().resource::<Current>().test_len(), 0);
    app.world_mut().resource_mut::<Input>().samples.truncate(1);
    app.world_mut().resource_mut::<Live>().revision = u64::MAX; app.update();
    assert!(app.world().resource::<Live>().exhausted);
    assert_eq!(app.world().resource::<Current>().test_len(), 0);
    assert!(app.world().resource::<Live>().rows.is_empty());
}

#[test]
fn uniform_xyz_change_reuses_geometry_but_replaces_exact_material_inputs() {
    let (mut app, _) = app(); app.update();
    let key = app.world().resource::<Input>().samples[0].key;
    let draw = &app.world().resource::<Live>().rows[&key];
    let (entity, mesh, material, revision, source) =
        (draw.entity, draw.mesh.id(), draw.material.id(), draw.input_revision, draw.source.clone());
    { let mut input = app.world_mut().resource_mut::<Input>();
        input.samples[0].y_native += 0.25; input.samples[0].sample_tick += 1; input.samples[0].frame_ordinal += 1; }
    app.update();
    let draw = &app.world().resource::<Live>().rows[&key];
    assert_eq!((draw.entity, draw.mesh.id(), draw.material.id()), (entity, mesh, material));
    assert!(draw.input_revision > revision); assert_ne!(draw.source, source);
    assert_eq!(app.world().resource::<Assets<StrictMaterial>>().get(material).unwrap().source_key(), Some(draw.source.clone()));
}
