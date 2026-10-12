use super::*;
use std::{net::UdpSocket, time::Instant};

fn simulation() -> openleague_core::Simulation {
    let root = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
    let nav = openleague_core::Navigation::load(
        &std::fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json")).unwrap(),
        &std::fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();
    let mut sim = openleague_core::Simulation::new(nav).unwrap();
    sim.enable_map10().unwrap(); sim.session = 41; sim.join("garen").unwrap(); sim
}
fn transported(sim: &openleague_core::Simulation) -> openleague_core::Snapshot {
    let mut assembler = openleague_core::wire::StateAssembler::default();
    let mut result = None;
    for bytes in openleague_core::wire::state_datagrams(&sim.snapshot()).unwrap() {
        if let Some(packet) = assembler.push(&bytes, Some(sim.session)) { result = Some(packet); }
    }
    let openleague_core::ServerPacket::State(snapshot) = serde_json::from_slice(&result.unwrap()).unwrap()
        else { panic!("state packet required") }; snapshot
}
#[test]
fn native_relic_glb_idle_index_and_embedded_texture_are_valid() {
    let root = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
    let data = std::fs::read(root.join("assets").join(ASSET)).unwrap();
    assert_eq!(&data[..4], b"glTF");
    let word = |offset| u32::from_le_bytes(data[offset..offset+4].try_into().unwrap()) as usize;
    assert_eq!(word(4), 2); assert_eq!(word(8), data.len());
    assert_eq!(word(16), 0x4e4f534a);
    let document: serde_json::Value = serde_json::from_slice(&data[20..20+word(12)]).unwrap();
    assert_eq!(document["animations"].as_array().unwrap().len(), 8);
    assert_eq!(document["animations"][IDLE_INDEX]["name"], IDLE);
    let image = &document["images"][0]; assert_eq!(image["mimeType"], "image/png");
    let view = &document["bufferViews"][image["bufferView"].as_u64().unwrap() as usize];
    assert_eq!(view["buffer"], 0);
    let binary = 20 + word(12); assert_eq!(word(binary+4), 0x004e4942);
    let offset = binary + 8 + view["byteOffset"].as_u64().unwrap_or(0) as usize;
    let length = view["byteLength"].as_u64().unwrap() as usize;
    let png = &data[offset..offset+length]; assert_eq!(&png[..8], b"\x89PNG\r\n\x1a\n");
    assert_eq!(document["materials"][0]["pbrMetallicRoughness"]["baseColorTexture"]["index"], 0);
}
#[test]
fn relic_world_lifetime_uses_transport_state_and_clears_session_and_visibility() {
    let mut sim = simulation();
    // Transport of real Map10 server state; the initial authoritative delay prevents spawning.
    assert!(placement(&transported(&sim), Some(sim.session), true).is_none());
    sim.tick = 180 * openleague_core::TICK_RATE; sim.advance();
    let snapshot = transported(&sim); let map = snapshot.map10.as_ref().unwrap();
    assert!(map.relic_available);
    let connection = Connection { socket: UdpSocket::bind("127.0.0.1:0").unwrap(),
        link: crate::session_connection::Link::legacy(), id: snapshot.players.first().map(|p|p.id),
        session: Some(sim.session), sequence: 0, last_join: Instant::now(), champion: "garen".into(),
        summoners: [None,None], rejection: String::new(), assembler: Default::default(), welcome_history: Default::default() };
    let mut app = App::new();
    app.add_plugins((MinimalPlugins, bevy::asset::AssetPlugin::default())).init_asset::<Gltf>()
        .insert_resource(connection).insert_resource(Match {snapshot: Some(snapshot.clone()), ..default()})
        .init_resource::<Live>().add_systems(Update, update);
    app.update(); let first = app.world().resource::<Live>().owner.unwrap();
    let transform = app.world().get::<Transform>(first.1).unwrap();
    assert_eq!(transform.translation, Vec3::new(map.relic_position.x,map.relic_height,map.relic_position.z)/20.);
    assert_eq!(transform.scale, Vec3::splat(0.05));
    app.update(); assert_eq!(app.world().resource::<Live>().owner, Some(first));
    for failure in 0..5 {
        let mut next = snapshot.clone();
        match failure {0 => next.map10.as_mut().unwrap().relic_available=false,
            1 => next.map10.as_mut().unwrap().relic_visible=false,
            2 => next.session+=1, 3 => next.winner=Some(0), _ => next.map10=None}
        app.world_mut().resource_mut::<Match>().snapshot=Some(next); app.update();
        assert!(app.world().resource::<Live>().owner.is_none());
        app.world_mut().resource_mut::<Match>().snapshot=Some(snapshot.clone()); app.update();
        assert!(app.world().resource::<Live>().owner.is_some());
    }
    app.world_mut().resource_mut::<Match>().snapshot=None; app.update();
    assert!(app.world().resource::<Live>().owner.is_none());
    assert!(app.world().get_entity(first.1).is_err());
}
