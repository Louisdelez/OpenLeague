use super::*;
use std::{net::UdpSocket,time::Instant};

fn game()->(openleague_core::Simulation,u32) {
    let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let mut game=openleague_core::Simulation::new(nav).unwrap();game.enable_map10().unwrap();let id=game.join("garen").unwrap();(game,id)
}
fn hud()->StartupHud {
    let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
    crate::native_zip_provider::Provider::from_catalog(&root).unwrap().startup_hud(&root).unwrap()
}
#[test]
fn map10_native_bounds_and_three_real_hud_records_align_at_both_dpis() {
    let panels=sources(&hud()).unwrap();assert_eq!(panels.iter().map(|p|p.name.as_str()).collect::<Vec<_>>(),["MinimapContent","MinimapFrame","MinimapPillar"]);
    let projection=Projection::map10().unwrap();let extent=15398.671875;
    for dimensions in [[1280,800],[1920,1080]] {for dpi in [1.,2.] {
        let (node,material)=crate::native_hud_panels::payload(&panels[0],dimensions,1.,dpi,Handle::default()).unwrap();
        let rect=Rect::from_node(&node).unwrap();assert_eq!(material.parameters.vertex_color,Vec4::ONE);assert_eq!(material.parameters.uv,Vec4::new(0.,0.,1.,1.));
        for (point,expected) in [(openleague_core::Point{x:0.,z:0.},Vec2::new(rect.left,rect.top+rect.height)),
            (openleague_core::Point{x:extent,z:extent},Vec2::new(rect.left+rect.width,rect.top)),
            (openleague_core::Point{x:extent*0.5,z:extent*0.5},Vec2::new(rect.left+rect.width*0.5,rect.top+rect.height*0.5))] {
            assert!(projection.project(rect,point).unwrap().distance(expected)<0.001);
        }
        // Actual Map10 spawn/structure points exercise direct X/Z at asymmetric
        // landmarks, not only a mirror identity on an artificial square.
        let config:openleague_core::world::Config=serde_json::from_str(include_str!("../../../data/4.20/map10_world.json")).unwrap();
        let nexuses=config.structures.iter().filter(|s|s.definition.contains("Nexus")).collect::<Vec<_>>();assert_eq!(nexuses.len(),2);
        for s in nexuses {
            let pixel=projection.project(rect,s.position).unwrap();let restored=projection.inverse(rect,pixel).unwrap();
            assert!((restored.x-s.position.x).abs()<0.03 && (restored.z-s.position.z).abs()<0.03);
            assert!((pixel.y-(rect.top+(1.-s.position.z/extent)*rect.height)).abs()<0.001);
        }
    }}
}
#[test]
fn original_icons_decode_and_team_styles_keep_source_colors_and_strip_cells() {
    let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../assets/ui/minimap_native");
    for (name,ext,size) in [("background.dds","dds",(752,752)),("icons.dds","dds",(1008,36)),("MapCircle.png","png",(128,128)),("MinionMapCircle.png","png",(16,16)),("healthPack.dds","dds",(32,32))] {
        let bytes=std::fs::read(root.join(name)).unwrap();
        let image=Image::from_buffer(&bytes,ImageType::Extension(ext),CompressedImageFormats::BC,true,image_sampler(name),RenderAssetUsages::default()).unwrap();
        assert_eq!((image.width(),image.height()),size);
        if name=="background.dds" {
            // Keep all authored BC1 mip bytes; only selection changes. Its lower
            // mips are nearly white and must not replace the colored base image.
            assert_eq!(image.texture_descriptor.mip_level_count,10);
            assert_eq!(image.data.as_deref(),Some(&bytes[128..]));
            let ImageSampler::Descriptor(ref sampler)=image.sampler else {panic!("explicit background sampler required")};
            assert_eq!((sampler.lod_min_clamp,sampler.lod_max_clamp),(0.,0.));
            let mut inherited=sampler.clone();inherited.lod_max_clamp=32.;
            assert_eq!(inherited,ImageSamplerDescriptor::linear());
        } else {
            assert_eq!(image.sampler,ImageSampler::linear());
            if name=="healthPack.dds" {
                assert_eq!(image.texture_descriptor.mip_level_count,6);
                assert_eq!(image.texture_descriptor.format,bevy::render::render_resource::TextureFormat::Bc3RgbaUnormSrgb);
                assert_eq!(image.data.as_deref(),Some(&bytes[128..]));
            }
        }
    }
    let (styles,count)=profile().unwrap();assert_eq!(count,28);
    assert_eq!(styles[&("Champion".into(),0)].color,Vec4::new(0.,0.,1.,1.));assert_eq!(styles[&("Champion".into(),1)].color,Vec4::new(1.,0.,0.,1.));
    assert_eq!(styles[&("HQ".into(),0)].strip,Some(12));assert_eq!(styles[&("HQ".into(),1)].strip,Some(5));
    let relic=&styles[&("HealthPack".into(),255)];
    assert_eq!((relic.width,relic.min_scale),(32.,0.5));assert_eq!(relic.strip,None);
    assert_eq!(relic.color,Vec4::new(220./255.,220./255.,1.,1.));
}
#[test]
fn actual_server_vision_removes_enemy_marker_even_when_roster_retains_identity() {
    let (mut game,own)=game();let enemy=game.join("garen").unwrap();let position=game.players[&own].position;
    let hidden_position=game.players[&enemy].position;
    let rect=Rect{left:0.,top:0.,width:200.,height:200.};let projection=Projection::map10().unwrap();
    game.players.get_mut(&enemy).unwrap().position=position;
    let visible=game.snapshot_for(own).unwrap();assert!(markers(&visible,rect,projection).unwrap().iter().any(|m|m.key==Key::Player(enemy)));
    game.players.get_mut(&enemy).unwrap().position=hidden_position;
    let hidden=game.snapshot_for(own).unwrap();assert!(hidden.roster.iter().any(|p|p.id==enemy));assert!(!hidden.players.iter().any(|p|p.id==enemy));
    assert!(!markers(&hidden,rect,projection).unwrap().iter().any(|m|m.key==Key::Player(enemy)));
    assert!(markers(&hidden,rect,projection).unwrap().iter().any(|m|m.key==Key::Player(own)));
}
pub(super) fn app()->(App,u32) {
    let (game,id)=game();let socket=UdpSocket::bind("127.0.0.1:0").unwrap();
    let connection=crate::Connection{socket,link:crate::session_connection::Link::legacy(),id:Some(id),session:Some(game.session),sequence:0,last_join:Instant::now(),champion:"garen".into(),summoners:[None,None],rejection:String::new(),assembler:Default::default(),welcome_history:Default::default()};
    let mut images=Assets::<Image>::default();let image=images.add(Image::default());let (styles,count)=profile().unwrap();
    let relic=images.add(Image::from_buffer(include_bytes!("../../../assets/ui/minimap_native/healthPack.dds"),ImageType::Extension("dds"),CompressedImageFormats::BC,true,image_sampler("healthPack.dds"),RenderAssetUsages::default()).unwrap());
    let live=Live{panels:sources(&hud()).unwrap(),images:Images{background:image.clone(),champion:image.clone(),minion:image.clone(),strip:image.clone(),relic},styles,strip_count:count,assets_ready:true,..default()};
    let atlases=crate::native_hud_atlases::Atlases{entries:vec![crate::native_hud_atlases::AtlasHandle{request:"CPU lifecycle fixture".into(),normalized:"ShadowIslesHUDAtlas.dds".into(),image,width:1,height:1,mips:1,format:"CPU fixture".into()}]};
    let mut app=App::new();app.insert_resource(connection).insert_resource(crate::Match{snapshot:Some(game.snapshot_for(id).unwrap()),..default()})
        .insert_resource(images).insert_resource(live).insert_resource(atlases).init_resource::<Assets<IconMaterial>>().init_resource::<crate::native_hud_viewport::Viewport>()
        .add_systems(Update,update);
    app.world_mut().spawn((Window{focused:true,resolution:(1280,800).into(),..default()},PrimaryWindow));(app,id)
}
#[test]
fn real_update_retains_entities_and_handles_then_retires_missing_actors_and_session() {
    let (mut app,id)=app();app.update();
    let old=app.world().resource::<Live>().owned.iter().map(|(key,v)|(*key,(v.entity,v.material.id()))).collect::<BTreeMap<_,_>>();assert!(old.len()>3);
    app.world_mut().resource_mut::<crate::Match>().snapshot.as_mut().unwrap().players.iter_mut().find(|p|p.id==id).unwrap().position.x+=50.;app.update();
    for (key,ids) in &old {let current=&app.world().resource::<Live>().owned[key];assert_eq!((current.entity,current.material.id()),*ids);}
    let remove=old.keys().find(|key|matches!(key,Key::Unit(_))).copied().unwrap();
    if let Key::Unit(unit)=remove {app.world_mut().resource_mut::<crate::Match>().snapshot.as_mut().unwrap().units.retain(|u|u.id!=unit);}
    app.update();assert!(!app.world().resource::<Live>().owned.contains_key(&remove));assert!(!app.world().resource::<Assets<IconMaterial>>().contains(old[&remove].1));
    app.world_mut().resource_mut::<crate::Connection>().session=None;app.update();assert!(app.world().resource::<Live>().owned.is_empty());assert!(app.world().resource::<Live>().rect.is_none());
}

#[test]
fn relic_marker_follows_real_visibility_consumption_and_authoritative_respawn() {
    let (mut game,id)=game();let home=game.players[&id].position;
    let initial=game.snapshot().map10.unwrap();
    assert_eq!(initial.relic_position,openleague_core::Point{x:7711.15,z:6722.67});
    let rect=Rect{left:31.,top:47.,width:200.,height:200.};let projection=Projection::map10().unwrap();
    let has_relic=|snapshot:&openleague_core::Snapshot| markers(snapshot,rect,projection).unwrap().iter().any(|m|m.key==Key::Relic);
    // Real MapState before first spawn, visible at the source point but unavailable.
    game.players.get_mut(&id).unwrap().position=initial.relic_position;
    let not_spawned=game.snapshot_for(id).unwrap();assert!(not_spawned.map10.as_ref().unwrap().relic_visible);assert!(!has_relic(&not_spawned));
    game.players.get_mut(&id).unwrap().position=home;game.tick=initial.relic_ready_tick-1;game.advance();
    assert!(game.snapshot().map10.unwrap().relic_available);
    let hidden=game.snapshot_for(id).unwrap();assert!(!hidden.map10.as_ref().unwrap().relic_visible);assert!(!has_relic(&hidden));
    // Both flags are required even if a malformed/stale MapState retains availability.
    let mut hidden_with_available=hidden.clone();hidden_with_available.map10.as_mut().unwrap().relic_available=true;
    assert!(!has_relic(&hidden_with_available));
    game.players.get_mut(&id).unwrap().position=initial.relic_position;
    let revealed=game.snapshot_for(id).unwrap();let rows=markers(&revealed,rect,projection).unwrap();
    let relics=rows.iter().filter(|m|m.key==Key::Relic).collect::<Vec<_>>();assert_eq!(relics.len(),1);
    let relic=relics[0];assert_eq!((relic.style.as_str(),relic.team,relic.texture),("HealthPack",255,Texture::Relic));
    // Independent native-span expectation at the actual asymmetric relic position.
    let expected=Vec2::new(rect.left+7711.15/15398.671875*rect.width,rect.top+(1.-6722.67/15398.671875)*rect.height);
    assert!(relic.point.distance(expected)<0.001);
    game.players.get_mut(&id).unwrap().position=home;assert!(!has_relic(&game.snapshot_for(id).unwrap()));
    game.players.get_mut(&id).unwrap().position=initial.relic_position;assert!(has_relic(&game.snapshot_for(id).unwrap()));
    game.advance();let consumed=game.snapshot_for(id).unwrap();let map=consumed.map10.as_ref().unwrap();
    assert!(map.relic_visible);assert!(!map.relic_available);assert_eq!(map.relic_last_picker,Some(id));assert!(!has_relic(&consumed));
    // Advancing only the client snapshot time cannot fabricate a respawn.
    let mut later=consumed.clone();later.tick=map.relic_ready_tick+30_000;assert!(!has_relic(&later));
    game.players.get_mut(&id).unwrap().position=home;game.tick=map.relic_ready_tick-1;game.advance();
    assert!(game.snapshot().map10.unwrap().relic_available);assert!(!has_relic(&game.snapshot_for(id).unwrap()));
    game.players.get_mut(&id).unwrap().position=initial.relic_position;assert!(has_relic(&game.snapshot_for(id).unwrap()));
}

#[test]
fn relic_draw_keeps_its_binding_and_retires_on_snapshot_and_session_changes() {
    let (mut game,id)=game();game.session=41;let home=game.players[&id].position;
    let map=game.snapshot().map10.unwrap();game.tick=map.relic_ready_tick-1;game.advance();
    game.players.get_mut(&id).unwrap().position=map.relic_position;
    let (mut app,app_id)=app();assert_eq!(app_id,id);
    app.world_mut().resource_mut::<crate::Connection>().session=Some(game.session);
    let present=|app:&mut App,game:&openleague_core::Simulation| {
        app.world_mut().resource_mut::<crate::Match>().snapshot=Some(game.snapshot_for(id).unwrap());app.update();
    };
    let draw=|app:&App| {let owned=&app.world().resource::<Live>().owned[&Key::Relic];(owned.entity,owned.material.id())};
    let retired=|app:&App,old:(Entity,bevy::asset::AssetId<IconMaterial>)| {
        assert!(!app.world().resource::<Live>().owned.contains_key(&Key::Relic));
        assert!(app.world().get_entity(old.0).is_err());assert!(!app.world().resource::<Assets<IconMaterial>>().contains(old.1));
    };
    present(&mut app,&game);let first=draw(&app);
    let material=app.world().resource::<Assets<IconMaterial>>().get(first.1).unwrap();
    assert_eq!(material.texture,app.world().resource::<Live>().images.relic);
    assert_ne!(material.texture,app.world().resource::<Live>().images.champion);
    assert_eq!(material.parameters.uv,Vec4::new(0.,0.,1.,1.));assert_eq!(material.parameters.vertex_color,Vec4::new(220./255.,220./255.,1.,1.));
    let node=app.world().get::<Node>(first.0).unwrap();assert_eq!((node.width,node.height),(Val::Px(16.),Val::Px(16.)));
    present(&mut app,&game);assert_eq!(draw(&app),first);
    game.players.get_mut(&id).unwrap().position=home;present(&mut app,&game);retired(&app,first);
    assert!(app.world().resource::<Live>().owned.contains_key(&Key::Player(id)));
    game.players.get_mut(&id).unwrap().position=map.relic_position;present(&mut app,&game);let revealed=draw(&app);assert_ne!(revealed,first);
    game.advance();present(&mut app,&game);retired(&app,revealed);
    let ready=game.snapshot().map10.unwrap().relic_ready_tick;
    game.players.get_mut(&id).unwrap().position=home;game.tick=ready-1;game.advance();
    game.players.get_mut(&id).unwrap().position=map.relic_position;present(&mut app,&game);let respawned=draw(&app);
    // Losing MapState also retires the relic; no cached marker survives it.
    app.world_mut().resource_mut::<crate::Match>().snapshot.as_mut().unwrap().map10=None;app.update();retired(&app,respawned);
    present(&mut app,&game);let previous_session=draw(&app);
    // The already accepted snapshot must match the current connection identity.
    app.world_mut().resource_mut::<crate::Connection>().session=Some(42);app.update();retired(&app,previous_session);
    assert!(app.world().resource::<Live>().owned.is_empty());
    game.session=42;present(&mut app,&game);assert_ne!(draw(&app),previous_session);assert_eq!(app.world().resource::<Live>().session,Some(42));
    let current=draw(&app);app.world_mut().resource_mut::<crate::Connection>().session=None;app.update();retired(&app,current);
    app.world_mut().resource_mut::<crate::Match>().snapshot=None;
    app.world_mut().resource_mut::<crate::Connection>().session=Some(42);app.update();assert!(app.world().resource::<Live>().owned.is_empty());
}
