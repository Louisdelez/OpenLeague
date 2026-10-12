use super::*;
use bevy::input::mouse::MouseButtonInput;
fn rect()->Rect {Rect{left:100.,top:100.,width:200.,height:200.}}
fn context()->Context {Context{identity:(u64::MAX-7,21,Some(3)),window:Entity::PLACEHOLDER,rect:rect().bits()}}
fn motion(p:Vec2)->WindowEvent {WindowEvent::CursorMoved(bevy::window::CursorMoved{window:Entity::PLACEHOLDER,position:p,delta:None})}
fn button(button:MouseButton,state:ButtonState)->WindowEvent {WindowEvent::MouseButtonInput(MouseButtonInput{window:Entity::PLACEHOLDER,button,state})}
fn frame(capture:&mut Capture,context:Option<Context>,events:&[WindowEvent])->Vec<Intent> {capture.frame(Some(Entity::PLACEHOLDER),true,Some(rect()),context,events.iter())}
fn ready()->Capture {let mut capture=Capture::default();frame(&mut capture,Some(context()),&[]);capture}
#[test]
fn ordered_short_clicks_have_one_intent_and_block_underlying_world_for_the_frame() {
    let mut capture=ready();let center=Vec2::new(200.,200.);
    let events=[motion(center),button(MouseButton::Right,ButtonState::Pressed),button(MouseButton::Right,ButtonState::Pressed),button(MouseButton::Right,ButtonState::Released),motion(Vec2::ZERO)];
    assert!(matches!(frame(&mut capture,Some(context()),&events).as_slice(),[Intent::Move(p)] if *p==center));assert!(capture.blocks_world_pointer());
    assert!(frame(&mut capture,Some(context()),&[]).is_empty());assert!(!capture.blocks_world_pointer());
    let clicks=[motion(center),button(MouseButton::Left,ButtonState::Pressed),motion(Vec2::new(220.,220.)),button(MouseButton::Left,ButtonState::Released)];
    assert!(matches!(frame(&mut capture,Some(context()),&clicks).as_slice(),[Intent::Camera(_),Intent::Camera(_)]));assert!(!capture.drag);assert!(capture.blocks_world_pointer());
}
#[test]
fn epoch_gate_resize_and_focus_loss_cancel_drag_without_later_replay() {
    for variant in 0..4 {
        let mut capture=ready();let events=[motion(Vec2::splat(200.)),button(MouseButton::Left,ButtonState::Pressed)];frame(&mut capture,Some(context()),&events);assert!(capture.drag);
        let mut changed=context();let gate=match variant {0=>{changed.identity.2=Some(4);Some(changed)},1=>None,_=>Some(changed)};
        let events=match variant {2=>vec![WindowEvent::WindowResized(bevy::window::WindowResized{window:Entity::PLACEHOLDER,width:640.,height:480.})],3=>vec![WindowEvent::WindowFocused(bevy::window::WindowFocused{window:Entity::PLACEHOLDER,focused:false})],_=>vec![]};
        assert!(frame(&mut capture,gate,&events).is_empty());assert!(!capture.drag);
        assert!(frame(&mut capture,Some(context()),&[motion(Vec2::splat(230.)),button(MouseButton::Left,ButtonState::Released)]).is_empty());
    }
}
#[test]
fn native_inverse_moves_only_to_actual_walkable_cells_without_nearest_substitution() {
    let projection=Projection::map10().unwrap();let nav=crate::picking::Terrain::default();
    let metadata=&nav.0.metadata;let mut walkable=None;let mut blocked=None;
    for z in 0..metadata.height {for x in 0..metadata.width {
        let p=openleague_core::Point{x:metadata.min[0]+(x as f32+0.5)*metadata.cell_size,z:metadata.min[2]+(z as f32+0.5)*metadata.cell_size};
        let Some(screen)=projection.project(rect(),p).filter(|p|rect().contains(*p)) else {continue;};
        let inverse=projection.inverse(rect(),screen).unwrap();
        if nav.0.ground(p).is_some() {walkable.get_or_insert((p,inverse));}else{blocked.get_or_insert(inverse);}
        if walkable.is_some() && blocked.is_some() {break;}
    }if walkable.is_some() && blocked.is_some(){break;}}
    let (point,inverse)=walkable.unwrap();assert!((point.x-inverse.x).abs()<0.02 && (point.z-inverse.z).abs()<0.02);assert!(nav.0.ground(inverse).is_some());assert!(nav.0.ground(blocked.unwrap()).is_none());
    assert!(projection.inverse(rect(),Vec2::ZERO).is_none());assert!(projection.inverse(rect(),Vec2::splat(f32::NAN)).is_none());
}
#[test]
fn actual_input_sends_one_move_keeps_self_cast_and_closes_on_connection_failure() {
    use std::net::UdpSocket;
    let (mut app,id)=super::super::tests::app();
    let server=UdpSocket::bind("127.0.0.1:0").unwrap();server.set_nonblocking(true).unwrap();
    app.world().resource::<crate::Connection>().socket.connect(server.local_addr().unwrap()).unwrap();
    app.add_plugins((bevy::input::InputPlugin,crate::spell_input::Plugin)).add_message::<WindowEvent>()
        .init_resource::<Capture>().init_resource::<crate::native_hud_inventory::Capture>()
        .init_resource::<crate::native_hud_learning::Live>().init_resource::<crate::ordinary_camera_input::Controls>()
        .init_resource::<crate::picking::Terrain>().insert_resource(crate::CameraFocus(Vec3::ZERO));
    let mut shop=crate::shop_ui::Filters::default();shop.open=false;shop.focused=false;app.insert_resource(shop);
    app.add_systems(Update,(input.after(super::super::update),crate::commands.after(input)));
    app.update();
    let mut windows=app.world_mut().query_filtered::<Entity,With<PrimaryWindow>>();
    let window=windows.iter(app.world()).next().unwrap();
    let rect=app.world().resource::<Live>().rect.unwrap();
    let own=app.world().resource::<crate::Match>().snapshot.as_ref().unwrap().players.iter().find(|p|p.id==id).unwrap().position;
    let cursor=Projection::map10().unwrap().project(rect,own).unwrap();
    let send=|app:&mut App,state:ButtonState| {
        app.world_mut().write_message(WindowEvent::CursorMoved(bevy::window::CursorMoved{window,position:cursor,delta:None}));
        app.world_mut().write_message(WindowEvent::MouseButtonInput(MouseButtonInput{window,button:MouseButton::Right,state}));
        app.world_mut().write_message(MouseButtonInput{window,button:MouseButton::Right,state});
    };
    send(&mut app,ButtonState::Pressed);send(&mut app,ButtonState::Released);
    app.world_mut().write_message(bevy::input::keyboard::KeyboardInput{key_code:KeyCode::KeyE,logical_key:bevy::input::keyboard::Key::Character("e".into()),state:ButtonState::Pressed,text:None,repeat:false,window});
    app.update();let mut bytes=[0u8;16384];let n=server.recv(&mut bytes).unwrap();
    let packet:openleague_core::ClientPacket=serde_json::from_slice(&bytes[..n]).unwrap();
    assert!(matches!(packet,openleague_core::ClientPacket::Command{sequence:1,action:openleague_core::Action::Move{point}} if (point.x-own.x).abs()<0.03 && (point.z-own.z).abs()<0.03));
    let n=server.recv(&mut bytes).unwrap();let second:openleague_core::ClientPacket=serde_json::from_slice(&bytes[..n]).unwrap();
    assert!(matches!(second,openleague_core::ClientPacket::Command{sequence:2,action:openleague_core::Action::Cast{slot:2,target:None}}));
    assert_eq!(server.recv(&mut bytes).unwrap_err().kind(),std::io::ErrorKind::WouldBlock);
    app.update();assert_eq!(server.recv(&mut bytes).unwrap_err().kind(),std::io::ErrorKind::WouldBlock);
    app.world_mut().resource_mut::<crate::Connection>().fail_session("controlled test disconnect");
    send(&mut app,ButtonState::Pressed);send(&mut app,ButtonState::Released);app.update();
    assert_eq!(server.recv(&mut bytes).unwrap_err().kind(),std::io::ErrorKind::WouldBlock);
    assert!(!app.world().resource::<crate::Connection>().ready());assert!(app.world().resource::<crate::Connection>().rejection.contains("controlled test disconnect"));
}

// Controlled CPU command scene, with a real camera ray and an eligible ally.
// These fixtures exercise dispatch, not GUI input, rendering or server healing.
fn heal_command_scene()->(App,std::net::UdpSocket,u32,Entity,Entity) {
    use bevy::camera::{CameraProjection,RenderTargetInfo};
    let (mut app,id)=super::super::tests::app();
    let server=std::net::UdpSocket::bind("127.0.0.1:0").unwrap();server.set_nonblocking(true).unwrap();
    app.world().resource::<crate::Connection>().socket.connect(server.local_addr().unwrap()).unwrap();
    let ally={
        let mut state=app.world_mut().resource_mut::<crate::Match>();let snapshot=state.snapshot.as_mut().unwrap();
        let mut ally=snapshot.players.iter().find(|p|p.id==id).unwrap().clone();
        ally.id=snapshot.players.iter().map(|p|p.id).max().unwrap()+1;
        ally.position.x+=100.;let ally_id=ally.id;snapshot.players.push(ally);ally_id
    };
    app.init_resource::<ButtonInput<KeyCode>>().init_resource::<ButtonInput<MouseButton>>()
        .init_resource::<crate::spell_input::Shortcuts>().init_resource::<Capture>()
        .init_resource::<crate::native_hud_inventory::Capture>().init_resource::<crate::native_hud_learning::Live>()
        .init_resource::<crate::picking::Terrain>();
    let mut shop=crate::shop_ui::Filters::default();shop.open=false;shop.focused=false;app.insert_resource(shop);
    let mut projection=PerspectiveProjection::default();projection.update(1280.,800.);
    let mut camera=Camera::default();camera.computed.target_info=Some(RenderTargetInfo{physical_size:UVec2::new(1280,800),scale_factor:1.});
    camera.computed.clip_from_view=projection.get_clip_from_view();
    let camera=app.world_mut().spawn((camera,GlobalTransform::default())).id();
    let window=app.world_mut().query_filtered::<Entity,With<PrimaryWindow>>().single(app.world()).unwrap();
    app.add_systems(Update,crate::commands.after(super::super::update));app.update();
    (app,server,ally,window,camera)
}
fn aim_command_pointer_at_ally(app:&mut App,ally:u32,window:Entity,camera:Entity,cursor:Vec2) {
    let rect=app.world().resource::<Live>().rect.unwrap();
    let (point,height)={let state=app.world().resource::<crate::Match>();let ally=state.snapshot.as_ref().unwrap().players.iter().find(|p|p.id==ally).unwrap();(ally.position,ally.height)};
    let mut pose=Transform::from_translation(Vec3::new(0.,100.,0.)).looking_at(Vec3::ZERO,Vec3::Z);
    let ray=app.world().get::<Camera>(camera).unwrap().viewport_to_world(&GlobalTransform::from(pose),cursor).unwrap();
    let hit=ray.origin+*ray.direction*((height/20.-ray.origin.y)/ray.direction.y);
    pose.translation.x+=point.x/20.-hit.x;pose.translation.z+=point.z/20.-hit.z;
    app.world_mut().entity_mut(camera).insert(GlobalTransform::from(pose));
    app.world_mut().get_mut::<Window>(window).unwrap().set_cursor_position(Some(cursor));
    let identity=app.world().resource::<crate::Connection>().inventory_input_identity().unwrap();
    let context=Some(Context{identity,window,rect:rect.bits()});
    let mut capture=Capture::default();capture.frame(Some(window),true,Some(rect),context,std::iter::empty());
    let event=WindowEvent::CursorMoved(bevy::window::CursorMoved{window,position:cursor,delta:None});
    assert!(capture.frame(Some(window),true,Some(rect),context,std::iter::once(&event)).is_empty());
    assert_eq!(capture.blocks_world_pointer(),rect.contains(cursor));app.insert_resource(capture);
    // Without the overlay gate, this actual ray would pick the ally.
    let ray=app.world().get::<Camera>(camera).unwrap().viewport_to_world(app.world().get::<GlobalTransform>(camera).unwrap(),cursor).unwrap();
    let own=app.world().resource::<crate::Connection>().id.unwrap();
    assert_eq!(crate::picking::allied_target(app.world().resource::<crate::Match>().snapshot.as_ref().unwrap(),own,(ray.origin*20.).to_array(),ray.direction.to_array()),Some(ally));
}
fn next_command(server:&std::net::UdpSocket)->openleague_core::ClientPacket {
    let mut bytes=[0u8;16384];let n=server.recv(&mut bytes).unwrap();serde_json::from_slice(&bytes[..n]).unwrap()
}
fn no_command(server:&std::net::UdpSocket) {
    let mut bytes=[0u8;16384];assert_eq!(server.recv(&mut bytes).unwrap_err().kind(),std::io::ErrorKind::WouldBlock);
}
#[test]
fn heal_d_and_f_over_minimap_skip_world_pick_and_preserve_optional_target_outside() {
    use openleague_core::{Action,ClientPacket,summoners::Spell};
    for (slot,key) in [(0u8,KeyCode::KeyD),(1,KeyCode::KeyF)] {
        let (mut app,server,ally,window,camera)=heal_command_scene();
        app.world_mut().resource_mut::<crate::Connection>().summoners[slot as usize]=Some(Spell::Heal);
        let rect=app.world().resource::<Live>().rect.unwrap();let center=Vec2::new(rect.left+rect.width/2.,rect.top+rect.height/2.);
        aim_command_pointer_at_ally(&mut app,ally,window,camera,center);
        app.world_mut().resource_mut::<ButtonInput<KeyCode>>().press(key);app.update();
        assert!(matches!(next_command(&server),ClientPacket::Command{sequence:1,action:Action::SummonerTarget{slot:s,target:None}} if s==slot));no_command(&server);
        app.world_mut().resource_mut::<ButtonInput<KeyCode>>().clear();app.update();no_command(&server);
        // A real pointer outside the overlay retains the existing optional ally pick.
        let outside=Vec2::splat(8.);assert!(!rect.contains(outside));
        aim_command_pointer_at_ally(&mut app,ally,window,camera,outside);
        {let mut keys=app.world_mut().resource_mut::<ButtonInput<KeyCode>>();keys.release(key);keys.press(key);}
        app.update();
        assert!(matches!(next_command(&server),ClientPacket::Command{sequence:2,action:Action::SummonerTarget{slot:s,target:Some(t)}} if s==slot && t==ally));no_command(&server);
        // The Heal shortcut still obeys the existing closed-connection gate.
        aim_command_pointer_at_ally(&mut app,ally,window,camera,center);
        app.world_mut().resource_mut::<crate::Connection>().fail_session("controlled heal disconnect");
        {let mut keys=app.world_mut().resource_mut::<ButtonInput<KeyCode>>();keys.release(key);keys.press(key);}
        app.update();no_command(&server);assert!(app.world().resource::<crate::Connection>().rejection.contains("controlled heal disconnect"));
    }
}
#[test]
fn target_required_summoners_and_underlying_world_pointer_stay_blocked_over_minimap() {
    use openleague_core::summoners::Spell;
    for spell in [Spell::Exhaust,Spell::Ignite,Spell::Smite] {for (slot,key) in [(0usize,KeyCode::KeyD),(1,KeyCode::KeyF)] {
        let (mut app,server,ally,window,camera)=heal_command_scene();
        app.world_mut().resource_mut::<crate::Connection>().summoners[slot]=Some(spell);
        let rect=app.world().resource::<Live>().rect.unwrap();
        aim_command_pointer_at_ally(&mut app,ally,window,camera,Vec2::new(rect.left+rect.width/2.,rect.top+rect.height/2.));
        app.world_mut().resource_mut::<ButtonInput<KeyCode>>().press(key);app.update();no_command(&server);
        assert!(app.world().resource::<crate::Connection>().rejection.contains("Visez une cible"));
        app.world_mut().resource_mut::<ButtonInput<KeyCode>>().clear();
        // Only the commands system receives this button state: this verifies
        // no underlying world action; the separate minimap Move is unchanged.
        app.world_mut().resource_mut::<ButtonInput<MouseButton>>().press(MouseButton::Right);app.update();no_command(&server);
        assert_eq!(app.world().resource::<crate::Connection>().sequence,0);
    }}
}
