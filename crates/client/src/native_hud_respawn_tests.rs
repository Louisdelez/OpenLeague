use super::*;
use std::{net::UdpSocket,time::Instant};
fn simulation()->(openleague_core::Simulation,u32,u32) {
    let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
    let nav=openleague_core::Navigation::load(&std::fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json")).unwrap(),&std::fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();
    let mut sim=openleague_core::Simulation::new(nav).unwrap();sim.enable_map10().unwrap();sim.session=41;
    let a=sim.join("garen").unwrap();let b=sim.join("garen").unwrap();(sim,a,b)
}
fn transported(sim:&openleague_core::Simulation)->openleague_core::Snapshot {
    let mut assembler=openleague_core::wire::StateAssembler::default();let mut received=None;
    for bytes in openleague_core::wire::state_datagrams(&sim.snapshot()).unwrap() {
        if let Some(packet)=assembler.push(&bytes,Some(sim.session)) {received=Some(packet);}
    }
    let openleague_core::ServerPacket::State(snapshot)=serde_json::from_slice(&received.unwrap()).unwrap() else {panic!("state required")};snapshot
}
fn hud()->StartupHud {
    let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
    crate::native_zip_provider::Provider::from_catalog(&root).unwrap().startup_hud(&root).unwrap()
}
#[test]
fn death_timer_tracks_real_lethal_damage_tick_boundaries_and_respawn_through_transport() {
    let (mut sim,a,b)=simulation();assert!(countdown(&transported(&sim),Some(a)).is_none());
    sim.apply_damage(None,a,10_000.,openleague_core::damage::DamageKind::True).unwrap();
    let end=sim.players[&a].respawn_at.unwrap();assert_eq!(end-sim.tick,16*30);
    for remaining in [480u64,479,451,450,31,30,29,1,0] {
        sim.tick=end-remaining;let snapshot=transported(&sim);
        let expected=match remaining {480|479|451=>"16",450=>"15",31=>"2",30|29|1=>"1",0=>"0",_=>unreachable!()};
        assert_eq!(countdown(&snapshot,Some(a)).as_deref(),Some(expected));
        assert!(!crate::native_hud_widgets::snapshot_values(&snapshot,Some(b)).unwrap().unwrap().contains_key("RespawnTimer"));
        assert_eq!(crate::native_hud_widgets::snapshot_values_with_mode(&snapshot,Some(a),0).unwrap().unwrap()["RespawnTimer"],expected,"spell cooldown preference must not suppress death timer");
    }
    sim.advance();let alive=transported(&sim);assert!(countdown(&alive,Some(a)).is_none());
    assert!(!crate::native_hud_widgets::snapshot_values(&alive,Some(a)).unwrap().unwrap().contains_key("RespawnTimer"));
    assert!(countdown(&alive,None).is_none());assert!(countdown(&alive,Some(u32::MAX)).is_none());
}
#[test]
fn original_respawn_frame_preserves_texture_uv_layer_tint_and_dpi_transport() {
    let hud=hud();let panel=source_panel(&hud).unwrap();let storage=&panel.storage;
    assert_eq!(storage.word(0x1a4),2);assert_eq!(storage.word(0x1dc),0xb4ffffff);
    let atlas=hud.shadow_isles_atlases.iter().find(|a|a.normalized.rsplit(['/', '\\']).next()==Some("HUDAtlas.dds")).unwrap();
    assert_eq!(crate::native_hud_atlases::decode(&atlas.bytes,bevy::image::CompressedImageFormats::BC).unwrap().data.as_deref(),Some(&atlas.bytes[128..]));
    for dimensions in [[1280,800],[1920,1080]] {
        let (node,material)=crate::native_hud_panels::payload(&panel,dimensions,1.0,1.0,Handle::default()).unwrap();
        assert_eq!(material.parameters.uv,Vec4::new(962./1024.,274./1024.,968./1024.,280./1024.));
        assert_eq!(material.parameters.vertex_color,Vec4::new(1.,1.,1.,180./255.));assert_eq!(material.parameters.mode.x,0.);
        let (scaled,_)=crate::native_hud_panels::payload(&panel,dimensions,1.0,2.0,Handle::default()).unwrap();
        if let (Val::Px(a),Val::Px(b))=(node.width,scaled.width) {assert_eq!(a,b*2.);}else {panic!("physical pixel width required")}
    }
}
#[test]
fn real_respawn_frame_ecs_retires_on_life_session_loss_and_match_end() {
    let (mut sim,a,b)=simulation();sim.apply_damage(None,a,10_000.,openleague_core::damage::DamageKind::True).unwrap();
    let source=hud();let mut images=Assets::<Image>::default();let atlas_image=images.add(Image::default());
    let atlases=crate::native_hud_atlases::Atlases{entries:vec![crate::native_hud_atlases::AtlasHandle{request:"CPU lifecycle fixture".into(),normalized:"DATA/menu/textures/HUDAtlas.dds".into(),image:atlas_image.clone(),width:1024,height:1024,mips:1,format:"CPU fixture".into()}]};
    let connection=crate::Connection{socket:UdpSocket::bind("127.0.0.1:0").unwrap(),link:crate::session_connection::Link::legacy(),id:Some(a),session:Some(sim.session),sequence:0,last_join:Instant::now(),champion:"garen".into(),summoners:[None,None],rejection:String::new(),assembler:Default::default(),welcome_history:Default::default()};
    let mut app=App::new();app.insert_resource(source).insert_resource(images).insert_resource(atlases).insert_resource(connection)
        .insert_resource(crate::Match{snapshot:Some(transported(&sim)),..default()})
        .init_resource::<crate::native_hud_viewport::Viewport>().init_resource::<Assets<IconMaterial>>().add_plugins(Plugin);
    app.world_mut().spawn((Window{resolution:(1280,800).into(),..default()},PrimaryWindow));app.update();
    let current=|app:&App| {let live=app.world().resource::<Live>();(live.entity.unwrap(),live.material.as_ref().unwrap().id())};
    let retired=|app:&App,old:(Entity,bevy::asset::AssetId<IconMaterial>)| {let live=app.world().resource::<Live>();assert!(live.entity.is_none());assert!(live.material.is_none());assert!(app.world().get_entity(old.0).is_err());assert!(!app.world().resource::<Assets<IconMaterial>>().contains(old.1));};
    let first=current(&app);assert_eq!(app.world().resource::<Assets<IconMaterial>>().get(first.1).unwrap().texture,atlas_image);
    app.update();assert_eq!(current(&app),first);
    app.world_mut().resource_mut::<crate::Connection>().id=Some(b);app.update();retired(&app,first);
    app.world_mut().resource_mut::<crate::Connection>().id=Some(a);app.update();let second=current(&app);
    app.world_mut().resource_mut::<crate::Connection>().session=Some(42);app.update();retired(&app,second);
    app.world_mut().resource_mut::<crate::Connection>().session=Some(41);app.update();let third=current(&app);
    app.world_mut().resource_mut::<crate::Connection>().session=None;app.update();retired(&app,third);
    app.world_mut().resource_mut::<crate::Connection>().session=Some(41);app.update();let fourth=current(&app);
    app.world_mut().resource_mut::<crate::Match>().snapshot=None;app.update();retired(&app,fourth);
    app.world_mut().resource_mut::<crate::Match>().snapshot=Some(transported(&sim));app.update();let fifth=current(&app);
    sim.winner=Some(0);app.world_mut().resource_mut::<crate::Match>().snapshot=Some(transported(&sim));app.update();retired(&app,fifth);
    sim.winner=None;let end=sim.players[&a].respawn_at.unwrap();sim.tick=end;sim.advance();
    app.world_mut().resource_mut::<crate::Match>().snapshot=Some(transported(&sim));app.update();assert!(app.world().resource::<Live>().entity.is_none());
}
