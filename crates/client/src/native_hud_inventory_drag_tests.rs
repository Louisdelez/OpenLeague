use super::*;
use std::{net::UdpSocket,time::Instant};
use bevy::input::{InputPlugin,ButtonState,mouse::MouseButtonInput,keyboard::{KeyboardInput,Key}};

fn synthetic_context()->Context {
    Context{identity:(7,11,Some(2)),window:1,inventory:[Some(1001),Some(2003),None,None,None,None],counts:[1,3,0,0,0,0],
        rectangles:std::array::from_fn(|n|[n as f32*20.,0.,n as f32*20.+16.,16.].map(f32::to_bits))}
}
fn pointer(slot:usize)->Pointer {Pointer{point:Some(Vec2::new(slot as f32*20.+8.,8.)),focused:true,..default()}}
fn press(slot:usize)->Pointer {Pointer{left_pressed:true,left_down:true,..pointer(slot)}}
fn release(slot:usize)->Pointer {Pointer{left_released:true,..pointer(slot)}}
fn begin()->(Capture,Context) {let c=synthetic_context();let mut s=Capture::default();assert!(s.step(&press(1),Some(c.clone())).is_none());assert!(s.blocks_commands());(s,c)}
fn root()->std::path::PathBuf {std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..")}
fn source_hud()->crate::native_zip_provider::StartupHud {let p=root();crate::native_zip_provider::Provider::from_catalog(&p).unwrap().startup_hud(&p).unwrap()}
fn game()->(openleague_core::Simulation,u32) {
    let p=root();let nav=openleague_core::Navigation::load(&std::fs::read_to_string(p.join("assets/maps/tt_navigation_grid.json")).unwrap(),&std::fs::read(p.join("assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();
    let mut g=openleague_core::Simulation::new(nav).unwrap();g.enable_map10().unwrap();let id=g.join("garen").unwrap();
    g.command(id,Action::Buy{item:1001}).unwrap();g.command(id,Action::Buy{item:2003}).unwrap();g.command(id,Action::Buy{item:2003}).unwrap();(g,id)
}

#[test]
fn all_six_native_rectangles_match_rendered_payload_including_empty_destinations() {
    let (panels,_)=super::super::sources(&source_hud()).unwrap();let before=panels.iter().map(|p|p.storage.bytes().to_vec()).collect::<Vec<_>>();
    let mut images=Assets::<Image>::default();let icon=images.add(Image::default());
    let loaded=std::collections::BTreeMap::from([(1001,super::super::Icon{image:icon,asset:"controlled CPU handle".into()})]);
    for dimensions in [[1280,800],[1920,1080]] {for dpi in [1.,1.5,2.] {
        let bounds=rectangles(&panels,dimensions,1.,dpi).unwrap();
        for slot in 0..6 {
            let mut values=[None;6];values[slot]=Some(super::super::Slot{item:1001,count:1,stackable:false});
            let rendered=super::super::icon_payloads(&panels,&loaded,&values,dimensions,1.,dpi).unwrap();let node=&rendered[0].0;
            let (Val::Px(x),Val::Px(y),Val::Px(w),Val::Px(h))=(node.left,node.top,node.width,node.height) else {panic!("logical pixels")};
            assert_eq!(bounds[slot],[x,y,x+w,y+h].map(f32::to_bits));
            assert_eq!(slot_at(&bounds,Some(Vec2::new(x+w*0.5,y+h*0.5))),Some(slot as u8));
        }
    }}
    for (panel,bytes) in panels.iter().zip(before) {assert_eq!(panel.storage.bytes(),bytes);}
    let mut overlap=synthetic_context().rectangles;overlap[2]=overlap[1];assert_eq!(slot_at(&overlap,pointer(1).point),None);
    assert_eq!(slot_at(&synthetic_context().rectangles,Some(Vec2::splat(f32::NAN))),None);
    assert_eq!(slot_at(&synthetic_context().rectangles,Some(Vec2::new(16.,0.))),None);
}

#[test]
fn release_once_swaps_real_authoritative_items_and_counts_at_same_tick() {
    let (mut game,id)=game();let tick=game.tick;let player=&game.players[&id];
    let mut c=synthetic_context();c.inventory=player.inventory;c.counts=player.inventory_counts;
    let mut state=Capture::default();state.step(&press(1),Some(c.clone()));
    assert!(state.step(&Pointer{left_down:true,..pointer(5)},Some(c.clone())).is_none());
    let action=state.step(&release(5),Some(c.clone())).unwrap();assert!(matches!(&action,Action::SwapItemsChecked{from:1,to:5,expected_inventory,expected_counts}
        if expected_inventory==&c.inventory && expected_counts==&c.counts));
    assert_eq!(game.players[&id].inventory[5],None); // No optimistic mutation.
    game.command(id,action).unwrap();assert_eq!(game.players[&id].inventory[1],None);assert_eq!(game.players[&id].inventory[5],Some(2003));assert_eq!(game.players[&id].inventory_counts[5],2);
    assert_eq!(game.tick,tick);assert!(state.blocks_commands());
    assert!(state.step(&release(5),Some(c.clone())).is_none());assert!(!state.blocks_commands());
    let mut swapped=c;swapped.inventory=game.players[&id].inventory;swapped.counts=game.players[&id].inventory_counts;
    state.step(&press(5),Some(swapped.clone()));let action=state.step(&release(0),Some(swapped)).unwrap();game.command(id,action).unwrap();
    assert_eq!(game.players[&id].inventory[0],Some(2003));assert_eq!(game.players[&id].inventory_counts[0],2);assert_eq!(game.players[&id].inventory[5],Some(1001));assert_eq!(game.players[&id].inventory_counts[5],1);
}

#[test]
fn clicks_empty_sources_fast_edges_and_outside_drops_never_use_or_swap_items() {
    let mut state=Capture::default();let c=synthetic_context();
    assert!(state.step(&press(4),Some(c.clone())).is_none());assert!(state.drag.is_none());
    assert!(state.step(&release(1),Some(c.clone())).is_none());
    for end in [pointer(1),Pointer{point:Some(Vec2::new(-5.,20.)),focused:true,..default()},Pointer{focused:true,..default()}] {
        let (mut state,c)=begin();assert!(state.step(&Pointer{left_released:true,..end},Some(c)).is_none());assert!(state.drag.is_none());assert!(state.blocks_commands());
    }
    let mut state=Capture::default();assert!(state.step(&Pointer{left_released:true,..press(1)},Some(c)).is_none());assert!(state.drag.is_none());
}

#[test]
fn captured_pointer_stays_owned_outside_slots_and_right_press_cancels_until_release() {
    let (mut state,c)=begin();
    for point in [Some(Vec2::new(-20.,-30.)),None] {
        assert!(state.step(&Pointer{point,focused:true,left_down:true,..default()},Some(c.clone())).is_none());assert!(state.drag.is_some());assert!(state.blocks_commands());
    }
    state.step(&Pointer{right_pressed:true,left_down:true,..pointer(4)},Some(c.clone()));assert!(state.drag.is_none());assert!(state.cancelled_until_release);
    assert!(state.step(&release(5),Some(c.clone())).is_none());assert!(state.blocks_commands());
    state.step(&pointer(5),Some(c));assert!(!state.blocks_commands());
}

#[test]
fn session_epoch_player_window_geometry_and_actual_inventory_changes_cancel_the_gesture() {
    for variant in 0..8 {
        let (mut state,c)=begin();let mut changed=c.clone();
        match variant {0=>changed.identity.0+=1,1=>changed.identity.1+=1,2=>changed.identity.2=Some(3),3=>changed.identity.2=None,
            4=>changed.window+=1,5=>changed.rectangles[0][0]=1f32.to_bits(),6=>changed.inventory[5]=Some(1001),7=>changed.counts[1]-=1,_=>unreachable!()}
        assert!(state.step(&Pointer{left_down:true,..pointer(5)},Some(changed.clone())).is_none());assert!(state.drag.is_none());
        assert!(state.step(&release(5),Some(changed)).is_none());assert!(state.step(&release(5),Some(c)).is_none());
    }
}

#[test]
fn escape_focus_loss_and_missing_context_do_not_revive_on_later_release() {
    for variant in 0..5 {
        let (mut state,c)=begin();let mut p=Pointer{left_down:true,..pointer(1)};
        match variant {0=>p.escape=true,1=>p.focused=false,2=>p.focus_lost=true,3=>p.left_down=false,4=>{},_=>unreachable!()}
        assert!(state.step(&p,if variant==4 {None}else{Some(c.clone())}).is_none());assert!(state.drag.is_none());
        assert!(state.step(&release(5),Some(c.clone())).is_none());state.step(&pointer(5),Some(c));assert!(!state.blocks_commands());
    }
}

fn application()->(App,Entity,UdpSocket,openleague_core::Simulation,u32) {
    let (game,id)=game();let server=UdpSocket::bind("127.0.0.1:0").unwrap();server.set_nonblocking(true).unwrap();
    let socket=UdpSocket::bind("127.0.0.1:0").unwrap();socket.connect(server.local_addr().unwrap()).unwrap();
    let connection=crate::Connection{socket,link:crate::session_connection::Link::legacy(),id:Some(id),session:Some(game.session),sequence:0,last_join:Instant::now(),champion:"garen".into(),summoners:[None,None],rejection:String::new(),assembler:Default::default(),welcome_history:Default::default()};
    let hud=source_hud();let (panels,_)=super::super::sources(&hud).unwrap();let mut images=Assets::<Image>::default();let icon=images.add(Image::default());
    let atlas=crate::native_hud_atlases::Atlases{entries:vec![crate::native_hud_atlases::AtlasHandle{request:"controlled CPU image".into(),normalized:"ShadowIslesHUDAtlas.dds".into(),image:icon.clone(),width:1,height:1,mips:1,format:"CPU fixture".into()}]};
    let icons=super::super::Icons{panels,images:std::collections::BTreeMap::from([(1001,super::super::Icon{image:icon.clone(),asset:"boots CPU".into()}),(2003,super::super::Icon{image:icon,asset:"potion CPU".into()})]),..default()};
    let mut app=App::new();app.add_plugins((InputPlugin,crate::spell_input::Plugin,crate::native_hud_learning::Plugin));
    app.add_message::<WindowEvent>();
    app.insert_resource(connection).insert_resource(crate::Match{snapshot:Some(game.snapshot()),..default()}).insert_resource(hud).insert_resource(atlas).insert_resource(images).insert_resource(icons)
        .init_resource::<Assets<crate::native_hud_icon_material::IconMaterial>>().init_resource::<Capture>().init_resource::<crate::native_hud_viewport::Viewport>().init_resource::<crate::picking::Terrain>();
    let mut shop=crate::shop_ui::Filters::default();shop.open=false;shop.focused=false;app.insert_resource(shop);
    let window=app.world_mut().spawn((Window{focused:true,resolution:(1280,800).into(),..default()},PrimaryWindow)).id();
    app.add_systems(Update,(super::super::update_icons,input.in_set(InputSet).after(super::super::update_icons),crate::commands).chain());
    app.update();(app,window,server,game,id)
}
fn center(app:&App,slot:usize)->Vec2 {
    let world=app.world();let icons=world.resource::<super::super::Icons>();let rect=rectangles(&icons.panels,[1280,800],1.,1.).unwrap()[slot].map(f32::from_bits);Vec2::new((rect[0]+rect[2])*0.5,(rect[1]+rect[3])*0.5)
}
fn mouse(app:&mut App,window:Entity,slot:usize,state:ButtonState) {
    let point=center(app,slot);app.world_mut().get_mut::<Window>(window).unwrap().set_cursor_position(Some(point));
    app.world_mut().write_message(MouseButtonInput{button:MouseButton::Left,state,window});
    // Winit publishes both the per-type message and this ordered aggregate.
    app.world_mut().write_message(motion(window,point));
    app.world_mut().write_message(button(window,MouseButton::Left,state));
}
fn key(app:&mut App,window:Entity,key_code:KeyCode,state:ButtonState) {
    let event=KeyboardInput{key_code,logical_key:Key::Character("fixture".into()),state,text:None,repeat:false,window};
    app.world_mut().write_message(event.clone());app.world_mut().write_message(WindowEvent::KeyboardInput(event));
}
fn packets(socket:&UdpSocket)->Vec<Action> {
    let mut result=Vec::new();loop {let mut bytes=[0;16384];match socket.recv(&mut bytes) {
        Ok(n)=>{let openleague_core::ClientPacket::Command{action,..}=serde_json::from_slice(&bytes[..n]).unwrap() else {panic!("ordinary command")};result.push(action);},
        Err(error) if error.kind()==std::io::ErrorKind::WouldBlock=>break,Err(error)=>panic!("{error}"),
    }}result
}

#[test]
fn real_input_systems_suppress_world_shortcuts_and_learning_until_release_frame_finishes() {
    let (mut app,window,server,mut game,id)=application();
    mouse(&mut app,window,1,ButtonState::Pressed);app.update();assert!(packets(&server).is_empty());
    for key_code in [KeyCode::KeyE,KeyCode::KeyD,KeyCode::KeyF,KeyCode::Digit1,KeyCode::KeyS] {
        key(&mut app,window,key_code,ButtonState::Pressed);
        crate::native_hud_learning::queue_probe_click(&mut app.world_mut().resource_mut::<crate::native_hud_learning::Live>(),0).unwrap();
        app.update();assert!(packets(&server).is_empty(),"{key_code:?}");
        key(&mut app,window,key_code,ButtonState::Released);app.update();assert!(packets(&server).is_empty());
    }
    mouse(&mut app,window,5,ButtonState::Released);key(&mut app,window,KeyCode::KeyE,ButtonState::Pressed);
    crate::native_hud_learning::queue_probe_click(&mut app.world_mut().resource_mut::<crate::native_hud_learning::Live>(),0).unwrap();
    app.update();let emitted=packets(&server);assert_eq!(emitted.len(),1);assert!(matches!(&emitted[0],Action::SwapItemsChecked{from:1,to:5,expected_inventory,expected_counts}
        if expected_inventory==&game.players[&id].inventory && expected_counts==&game.players[&id].inventory_counts));
    game.command(id,emitted.into_iter().next().unwrap()).unwrap();app.world_mut().resource_mut::<crate::Match>().snapshot=Some(game.snapshot());
    key(&mut app,window,KeyCode::KeyE,ButtonState::Released);app.update();assert!(packets(&server).is_empty()); // No delayed Learn or Cast.
    crate::native_hud_learning::queue_probe_click(&mut app.world_mut().resource_mut::<crate::native_hud_learning::Live>(),0).unwrap();app.update();
    assert!(matches!(packets(&server).as_slice(),[Action::Learn{slot:0}]));
    key(&mut app,window,KeyCode::KeyE,ButtonState::Pressed);app.update();assert!(matches!(packets(&server).as_slice(),[Action::Cast{slot:2,target:None}]));
}

#[test]
fn actual_context_rejects_shop_death_winner_missing_state_and_connection_failure() {
    let (mut app,window,server,_,id)=application();
    mouse(&mut app,window,1,ButtonState::Pressed);app.update();assert!(app.world().resource::<Capture>().drag.is_some());
    app.world_mut().resource_mut::<crate::shop_ui::Filters>().open=true;app.update();assert!(app.world().resource::<Capture>().drag.is_none());
    mouse(&mut app,window,5,ButtonState::Released);app.update();assert!(packets(&server).is_empty());
    app.world_mut().resource_mut::<crate::shop_ui::Filters>().open=false;
    for variant in 0..3 {
        let original=app.world().resource::<crate::Match>().snapshot.clone();
        match variant {0=>app.world_mut().resource_mut::<crate::Match>().snapshot.as_mut().unwrap().players.iter_mut().find(|p|p.id==id).unwrap().health=0.,
            1=>app.world_mut().resource_mut::<crate::Match>().snapshot.as_mut().unwrap().winner=Some(0),2=>app.world_mut().resource_mut::<crate::Match>().snapshot=None,_=>unreachable!()}
        mouse(&mut app,window,1,ButtonState::Pressed);app.update();assert!(app.world().resource::<Capture>().drag.is_none());
        mouse(&mut app,window,5,ButtonState::Released);app.update();assert!(packets(&server).is_empty());app.world_mut().resource_mut::<crate::Match>().snapshot=original;
    }
    mouse(&mut app,window,1,ButtonState::Pressed);app.update();assert!(app.world().resource::<Capture>().drag.is_some());
    app.world_mut().resource_mut::<crate::Connection>().fail_session("controlled transport failure");app.update();
    mouse(&mut app,window,5,ButtonState::Released);app.update();assert!(packets(&server).is_empty());
    app.update();assert!(!app.world().resource::<crate::Connection>().ready());assert!(app.world().resource::<crate::Connection>().inventory_input_identity().is_none());
}

#[test]
fn real_same_tick_inventory_mutation_and_missing_render_payload_cancel_without_command() {
    for missing_image in [false,true] {
        let (mut app,window,server,mut game,id)=application();let tick=game.tick;
        mouse(&mut app,window,1,ButtonState::Pressed);app.update();assert!(app.world().resource::<Capture>().drag.is_some());
        if missing_image {app.world_mut().resource_mut::<super::super::Icons>().signature=None;app.world_mut().resource_mut::<super::super::Icons>().images.remove(&2003);}
        else {game.command(id,Action::Sell{slot:1}).unwrap();app.world_mut().resource_mut::<crate::Match>().snapshot=Some(game.snapshot());assert_eq!(game.tick,tick);}
        app.update();assert!(app.world().resource::<Capture>().drag.is_none());mouse(&mut app,window,5,ButtonState::Released);app.update();assert!(packets(&server).is_empty());
    }
}


#[test]
fn unseen_server_inventory_change_rejects_drag_without_optimism_or_retry() {
    let (mut game,id)=game();let mut c=synthetic_context();
    c.inventory=game.players[&id].inventory;c.counts=game.players[&id].inventory_counts;
    let mut capture=Capture::default();capture.step(&press(1),Some(c.clone()));
    // A real purchase changes only the authoritative quantity. Client has not received it.
    game.command(id,Action::Buy{item:2003}).unwrap();
    let before=serde_json::to_value(&game.players[&id]).unwrap();
    let action=capture.step(&release(5),Some(c.clone())).unwrap();
    assert!(matches!(&action,Action::SwapItemsChecked{from:1,to:5,expected_inventory,expected_counts}
        if expected_inventory==&c.inventory && expected_counts==&c.counts));
    assert_eq!(game.command(id,action).unwrap_err(),"inventory changed");
    assert_eq!(serde_json::to_value(&game.players[&id]).unwrap(),before);
    assert!(capture.drag.is_none());assert!(capture.blocks_commands());
    assert!(capture.step(&release(5),Some(c.clone())).is_none());
    let mut fresh=c;fresh.inventory=game.players[&id].inventory;fresh.counts=game.players[&id].inventory_counts;
    assert!(capture.step(&pointer(5),Some(fresh.clone())).is_none());
    assert!(capture.step(&press(1),Some(fresh.clone())).is_none());
    game.command(id,capture.step(&release(5),Some(fresh)).unwrap()).unwrap();
    assert_eq!(game.players[&id].inventory[5],Some(2003));assert_eq!(game.players[&id].inventory_counts[5],3);
}

#[test]
fn real_input_sends_captured_arrays_and_server_refuses_unseen_change() {
    let (mut app,window,server,mut game,id)=application();
    let captured_inventory=game.players[&id].inventory;
    let captured_counts=game.players[&id].inventory_counts;
    mouse(&mut app,window,1,ButtonState::Pressed);app.update();assert!(packets(&server).is_empty());
    game.command(id,Action::Buy{item:2003}).unwrap(); // No new snapshot delivered to this client.
    let before=serde_json::to_value(&game.players[&id]).unwrap();
    mouse(&mut app,window,5,ButtonState::Released);app.update();
    let emitted=packets(&server);assert_eq!(emitted.len(),1);
    assert!(matches!(&emitted[0],Action::SwapItemsChecked{from:1,to:5,expected_inventory,expected_counts}
        if expected_inventory==&captured_inventory && expected_counts==&captured_counts));
    assert_eq!(game.command(id,emitted.into_iter().next().unwrap()).unwrap_err(),"inventory changed");
    assert_eq!(serde_json::to_value(&game.players[&id]).unwrap(),before);
    assert!(app.world().resource::<Capture>().drag.is_none());
    assert_eq!(app.world().resource::<crate::Match>().snapshot.as_ref().unwrap().players.iter().find(|p|p.id==id).unwrap().inventory_counts,captured_counts);
    app.update();assert!(packets(&server).is_empty()); // No retry or optimistic update on the next frame.
}

fn motion(window:Entity,position:Vec2)->WindowEvent {
    WindowEvent::CursorMoved(bevy::window::CursorMoved{window,position,delta:None})
}
fn button(window:Entity,button:MouseButton,state:ButtonState)->WindowEvent {
    WindowEvent::MouseButtonInput(MouseButtonInput{window,button,state})
}
fn focus(window:Entity,focused:bool)->WindowEvent {
    WindowEvent::WindowFocused(bevy::window::WindowFocused{window,focused})
}
fn ordered(state:&mut Capture,window:Entity,c:Option<Context>,events:&[WindowEvent])->Vec<Action> {
    state.ordered_frame(Some(window),true,c,events.iter(),|_,_,_,_|{})
}
fn move_only(app:&mut App,window:Entity,slot:usize) {
    let point=center(app,slot);app.world_mut().get_mut::<Window>(window).unwrap().set_cursor_position(Some(point));
    app.world_mut().write_message(motion(window,point));
}

#[test]
fn ordered_same_update_drag_uses_original_press_and_exact_checked_arrays() {
    let (mut app,window,server,mut game,id)=application();
    let inventory=game.players[&id].inventory;let counts=game.players[&id].inventory_counts;
    mouse(&mut app,window,0,ButtonState::Pressed);
    move_only(&mut app,window,1);move_only(&mut app,window,4);
    mouse(&mut app,window,5,ButtonState::Released);
    // The Window now contains only the final point and ButtonInput receives both
    // edges in one frame. This reproduces the old consumer's information loss.
    app.update();let emitted=packets(&server);assert_eq!(emitted.len(),1);
    assert!(matches!(&emitted[0],Action::SwapItemsChecked{from:0,to:5,expected_inventory,expected_counts}
        if *expected_inventory==inventory && *expected_counts==counts));
    assert!(app.world().resource::<Capture>().blocks_commands());
    game.command(id,emitted.into_iter().next().unwrap()).unwrap();
    assert_eq!(game.players[&id].inventory[5],Some(1001));assert_eq!(game.players[&id].inventory[0],None);
    app.update();assert!(packets(&server).is_empty());
}

#[test]
fn ordered_press_then_motion_in_first_update_keeps_source_for_next_release() {
    let (mut app,window,server,_,_)=application();
    mouse(&mut app,window,0,ButtonState::Pressed);move_only(&mut app,window,4);
    app.update();assert!(packets(&server).is_empty());
    assert_eq!(app.world().resource::<Capture>().drag.as_ref().unwrap().from,0);
    mouse(&mut app,window,5,ButtonState::Released);app.update();
    assert!(matches!(packets(&server).as_slice(),[Action::SwapItemsChecked{from:0,to:5,..}]));
}

#[test]
fn ordered_press_without_observed_cursor_never_guesses_from_final_window_position() {
    let (mut app,window,server,_,_)=application();
    let point=center(&app,0);app.world_mut().get_mut::<Window>(window).unwrap().set_cursor_position(Some(point));
    app.world_mut().write_message(MouseButtonInput{window,button:MouseButton::Left,state:ButtonState::Pressed});
    app.world_mut().write_message(button(window,MouseButton::Left,ButtonState::Pressed));
    app.update();assert!(app.world().resource::<Capture>().drag.is_none());
    mouse(&mut app,window,5,ButtonState::Released);app.update();assert!(packets(&server).is_empty());
    mouse(&mut app,window,0,ButtonState::Pressed);mouse(&mut app,window,5,ButtonState::Released);app.update();
    assert!(matches!(packets(&server).as_slice(),[Action::SwapItemsChecked{from:0,to:5,..}]));
}

#[test]
fn ordered_other_window_cannot_supply_start_motion_release_or_focus() {
    let mut world=World::new();let window=world.spawn_empty().id();let foreign=world.spawn_empty().id();
    let c=synthetic_context();let mut state=Capture::default();
    let source=pointer(1).point.unwrap();let end=pointer(5).point.unwrap();
    assert!(ordered(&mut state,window,Some(c.clone()),&[
        motion(foreign,source),button(window,MouseButton::Left,ButtonState::Pressed),
        button(window,MouseButton::Left,ButtonState::Released)]).is_empty());
    assert!(state.drag.is_none());
    assert!(ordered(&mut state,window,Some(c.clone()),&[
        motion(window,source),button(window,MouseButton::Left,ButtonState::Pressed),motion(window,end),
        motion(foreign,source),focus(foreign,false),button(foreign,MouseButton::Left,ButtonState::Released)]).is_empty());
    assert_eq!(state.drag.as_ref().unwrap().from,1);
    let out=ordered(&mut state,window,Some(c),&[button(window,MouseButton::Left,ButtonState::Released)]);
    assert!(matches!(out.as_slice(),[Action::SwapItemsChecked{from:1,to:5,..}]));
}

#[test]
fn ordered_focus_escape_resize_scale_and_destroy_cancel_without_resurrection() {
    let mut world=World::new();let window=world.spawn_empty().id();let c=synthetic_context();
    let source=pointer(1).point.unwrap();let end=pointer(5).point.unwrap();
    let interruptions=[
        focus(window,false),
        WindowEvent::KeyboardFocusLost(bevy::input::keyboard::KeyboardFocusLost),
        WindowEvent::WindowResized(bevy::window::WindowResized{window,width:1300.,height:900.}),
        WindowEvent::WindowScaleFactorChanged(bevy::window::WindowScaleFactorChanged{window,scale_factor:1.5}),
        WindowEvent::WindowBackendScaleFactorChanged(bevy::window::WindowBackendScaleFactorChanged{window,scale_factor:2.}),
        WindowEvent::WindowDestroyed(bevy::window::WindowDestroyed{window}),
        WindowEvent::KeyboardInput(KeyboardInput{window,key_code:KeyCode::Escape,logical_key:Key::Escape,state:ButtonState::Pressed,text:None,repeat:false}),
    ];
    for interruption in interruptions {
        let mut state=Capture::default();
        let events=[motion(window,source),button(window,MouseButton::Left,ButtonState::Pressed),interruption,
            focus(window,true),motion(window,end),button(window,MouseButton::Left,ButtonState::Released)];
        assert!(ordered(&mut state,window,Some(c.clone()),&events).is_empty());
        assert!(state.drag.is_none());assert!(state.blocks_commands());
        assert!(ordered(&mut state,window,Some(c.clone()),&[button(window,MouseButton::Left,ButtonState::Released)]).is_empty());
    }
}

#[test]
fn ordered_context_drift_without_events_cancels_until_real_release() {
    let mut world=World::new();let window=world.spawn_empty().id();let c=synthetic_context();
    for variant in 0..7 {
        let mut state=Capture::default();
        assert!(ordered(&mut state,window,Some(c.clone()),&[motion(window,pointer(1).point.unwrap()),button(window,MouseButton::Left,ButtonState::Pressed)]).is_empty());
        let mut altered=c.clone();
        match variant {0=>altered.identity.0+=1,1=>altered.identity.1+=1,2=>altered.identity.2=Some(9),
            3=>altered.inventory[5]=Some(1001),4=>altered.counts[1]+=1,5=>altered.rectangles[0][0]=1f32.to_bits(),6=>{},_=>unreachable!()}
        assert!(ordered(&mut state,window,if variant==6{None}else{Some(altered)},&[]).is_empty());
        assert!(state.drag.is_none());assert!(state.cancelled_until_release);
        assert!(ordered(&mut state,window,Some(c.clone()),&[motion(window,pointer(5).point.unwrap()),button(window,MouseButton::Left,ButtonState::Released)]).is_empty());
        let out=ordered(&mut state,window,Some(c.clone()),&[motion(window,pointer(1).point.unwrap()),button(window,MouseButton::Left,ButtonState::Pressed),motion(window,pointer(5).point.unwrap()),button(window,MouseButton::Left,ButtonState::Released)]);
        assert!(matches!(out.as_slice(),[Action::SwapItemsChecked{from:1,to:5,..}]));
    }
}

#[test]
fn ordered_release_then_more_motion_keeps_world_and_learning_blocked_for_frame() {
    let (mut app,window,server,_,_)=application();
    mouse(&mut app,window,0,ButtonState::Pressed);mouse(&mut app,window,5,ButtonState::Released);
    move_only(&mut app,window,3); // No capture remains at this late motion event.
    key(&mut app,window,KeyCode::KeyE,ButtonState::Pressed);
    crate::native_hud_learning::queue_probe_click(&mut app.world_mut().resource_mut::<crate::native_hud_learning::Live>(),0).unwrap();
    app.update();let out=packets(&server);
    assert!(matches!(out.as_slice(),[Action::SwapItemsChecked{from:0,to:5,..}]));
    assert!(app.world().resource::<Capture>().blocks_commands());
    app.update();assert!(packets(&server).is_empty());
}

#[test]
fn ordered_cursor_exit_repeated_edges_and_new_window_never_replay_a_gesture() {
    let mut world=World::new();let window=world.spawn_empty().id();let replacement=world.spawn_empty().id();let c=synthetic_context();
    let mut state=Capture::default();
    let begin=[motion(window,pointer(1).point.unwrap()),button(window,MouseButton::Left,ButtonState::Pressed)];
    assert!(ordered(&mut state,window,Some(c.clone()),&begin).is_empty());
    assert!(ordered(&mut state,window,Some(c.clone()),&[WindowEvent::CursorLeft(bevy::window::CursorLeft{window}),button(window,MouseButton::Left,ButtonState::Released)]).is_empty());
    assert!(state.drag.is_none());
    assert!(ordered(&mut state,window,Some(c.clone()),&begin).is_empty());
    let out=ordered(&mut state,window,Some(c.clone()),&[motion(window,pointer(5).point.unwrap()),button(window,MouseButton::Left,ButtonState::Pressed),button(window,MouseButton::Left,ButtonState::Released),button(window,MouseButton::Left,ButtonState::Released)]);
    assert!(matches!(out.as_slice(),[Action::SwapItemsChecked{from:1,to:5,..}]));
    assert!(ordered(&mut state,window,Some(c.clone()),&begin).is_empty());
    assert!(ordered(&mut state,replacement,Some(c),&[motion(replacement,pointer(5).point.unwrap()),button(replacement,MouseButton::Left,ButtonState::Released)]).is_empty());
    assert!(state.drag.is_none());assert!(state.blocks_commands());
}

#[test]
fn ordered_resize_after_release_discards_batch_using_unknown_old_geometry() {
    let mut world=World::new();let window=world.spawn_empty().id();let c=synthetic_context();let mut state=Capture::default();
    let events=[motion(window,pointer(1).point.unwrap()),button(window,MouseButton::Left,ButtonState::Pressed),
        motion(window,pointer(5).point.unwrap()),button(window,MouseButton::Left,ButtonState::Released),
        WindowEvent::WindowResized(bevy::window::WindowResized{window,width:1600.,height:1000.})];
    assert!(ordered(&mut state,window,Some(c.clone()),&events).is_empty());
    assert!(state.blocks_commands());assert!(state.ordered.point.is_none());assert!(state.drag.is_none());
    assert!(ordered(&mut state,window,Some(c.clone()),&[button(window,MouseButton::Left,ButtonState::Pressed),button(window,MouseButton::Left,ButtonState::Released)]).is_empty());
    let fresh=[motion(window,pointer(1).point.unwrap()),button(window,MouseButton::Left,ButtonState::Pressed),
        motion(window,pointer(5).point.unwrap()),button(window,MouseButton::Left,ButtonState::Released)];
    assert!(matches!(ordered(&mut state,window,Some(c),&fresh).as_slice(),[Action::SwapItemsChecked{from:1,to:5,..}]));
}

#[test]
fn ordered_keyboard_focus_loss_does_not_latch_focused_window_or_right_button() {
    let mut world=World::new();let window=world.spawn_empty().id();let c=synthetic_context();let mut state=Capture::default();
    let source=motion(window,pointer(1).point.unwrap());let end=motion(window,pointer(5).point.unwrap());
    let press=button(window,MouseButton::Left,ButtonState::Pressed);let release=button(window,MouseButton::Left,ButtonState::Released);
    // A held right button cannot be forgotten merely because its edge is old.
    assert!(ordered(&mut state,window,Some(c.clone()),&[source.clone(),button(window,MouseButton::Right,ButtonState::Pressed)]).is_empty());
    assert!(ordered(&mut state,window,Some(c.clone()),&[press.clone(),end.clone(),release.clone()]).is_empty());
    assert!(state.drag.is_none());
    assert!(ordered(&mut state,window,Some(c.clone()),&[button(window,MouseButton::Right,ButtonState::Released),source.clone(),press.clone()]).is_empty());
    assert!(state.drag.is_some());
    assert!(ordered(&mut state,window,Some(c.clone()),&[WindowEvent::KeyboardFocusLost(bevy::input::keyboard::KeyboardFocusLost),end.clone(),release.clone()]).is_empty());
    assert!(state.drag.is_none());assert!(!state.ordered.right_down);assert!(!state.ordered.left_down);
    // Still Window.focused=true, with no new WindowFocused(true) event.
    assert!(matches!(ordered(&mut state,window,Some(c),&[source,press,end,release]).as_slice(),[Action::SwapItemsChecked{from:1,to:5,..}]));
}
