//! Secure successful exit retires a session; secure error/crash/silence preserves recovery.
//! Legacy AppExit behavior remains unchanged, including error exits.
use bevy::prelude::*;
use bevy::app::AppExit;
use crate::Connection;

#[derive(Component)]
pub struct ReturnButton;

pub fn return_button(state: Res<crate::Match>, connection: Res<Connection>, view: Res<crate::native_endgame_ui::View>,
    mouse: Res<ButtonInput<MouseButton>>, mut buttons: Query<(&Interaction, &mut Node, &mut BackgroundColor), With<ReturnButton>>,
    mut armed: Local<(Option<u64>, bool)>, mut exits: MessageWriter<AppExit>) {
    let result = state.snapshot.as_ref().and_then(|s| s.result.as_ref());
    let session = result.map(|r| r.session);
    if armed.0 != session { *armed = (session, false); }
    let visible = view.dismissed && result.is_some_and(|r| connection.session == Some(r.session)
        && r.players.iter().any(|p| Some(p.id) == connection.id));
    for (interaction, mut node, mut color) in &mut buttons {
        node.display = if visible { Display::Flex } else { Display::None };
        *color = BackgroundColor(match interaction {
            Interaction::Hovered => Color::srgb_u8(55, 79, 88),
            Interaction::Pressed => Color::srgb_u8(24, 37, 45),
            Interaction::None => Color::srgb_u8(38, 55, 66),
        });
        if !visible { armed.1 = false; continue; }
        if *interaction == Interaction::Pressed { armed.1 = true; }
        if mouse.just_released(MouseButton::Left) {
            if armed.1 && *interaction == Interaction::Hovered { exits.write(AppExit::Success); }
            armed.1 = false;
        }
    }
}

pub fn on_exit(mut exits: MessageReader<AppExit>, mut connection: ResMut<Connection>, mut sent: Local<bool>) {
    let mut observed=false;let mut failed=false;
    for exit in exits.read() {observed=true;failed|=!matches!(exit,AppExit::Success);}
    if !observed || *sent {return;}*sent=true;
    // A secure nonzero exit remains recoverable; legacy departure is unchanged.
    if failed && connection.resumable() {return;}
    if let Err(error)=send(&mut connection) {eprintln!("Session departure: {error}; owned server drain remains authoritative");}
}
fn send(connection:&mut Connection)->Result<(),String> {connection.depart()}

#[cfg(test)] mod tests {
    use super::*;
    #[test] fn return_requires_visible_results_and_armed_release_inside_button() {
        let navigation = openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),
            include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut game = openleague_core::Simulation::new(navigation).unwrap();game.session = 19;
        let id = game.join("garen").unwrap();game.winner = Some(0);game.advance();
        let connection = Connection { link: crate::session_connection::Link::legacy(), socket: std::net::UdpSocket::bind("127.0.0.1:0").unwrap(), id: Some(id), session: Some(19), sequence: 0,
            last_join: std::time::Instant::now(), champion: "garen".into(), summoners: [None, None],
            rejection: String::new(), assembler: Default::default(), welcome_history: Default::default() };
        let mut app = App::new();
        app.add_message::<AppExit>().init_resource::<ButtonInput<MouseButton>>().init_resource::<crate::native_endgame_ui::View>()
            .insert_resource(connection).insert_resource(crate::Match { snapshot: Some(game.snapshot()), ..default() })
            .add_systems(Update, return_button);
        let button = app.world_mut().spawn((ReturnButton, Interaction::Pressed, Node::default(), BackgroundColor::default())).id();
        app.update();assert_eq!(app.world().get::<Node>(button).unwrap().display, Display::None);
        app.world_mut().resource_mut::<crate::native_endgame_ui::View>().dismissed = true;
        *app.world_mut().get_mut::<Interaction>(button).unwrap() = Interaction::Hovered;
        let release = |app: &mut App| { let mut mouse = app.world_mut().resource_mut::<ButtonInput<MouseButton>>();mouse.press(MouseButton::Left);mouse.release(MouseButton::Left); };
        release(&mut app);app.update();
        let mut cursor = bevy::ecs::message::MessageCursor::<AppExit>::default();
        assert_eq!(cursor.read(app.world().resource::<Messages<AppExit>>()).count(), 0);
        app.world_mut().resource_mut::<ButtonInput<MouseButton>>().clear();
        *app.world_mut().get_mut::<Interaction>(button).unwrap() = Interaction::Pressed;app.update();
        *app.world_mut().get_mut::<Interaction>(button).unwrap() = Interaction::None;release(&mut app);app.update();
        assert_eq!(cursor.read(app.world().resource::<Messages<AppExit>>()).count(), 0);
        app.world_mut().resource_mut::<ButtonInput<MouseButton>>().clear();
        *app.world_mut().get_mut::<Interaction>(button).unwrap() = Interaction::Pressed;app.update();
        *app.world_mut().get_mut::<Interaction>(button).unwrap() = Interaction::Hovered;release(&mut app);app.update();
        assert_eq!(cursor.read(app.world().resource::<Messages<AppExit>>()).count(), 1);
        app.world_mut().resource_mut::<Connection>().session = Some(20);app.update();
        assert_eq!(app.world().get::<Node>(button).unwrap().display, Display::None);
    }
    #[test] fn exit_sends_current_identity_once_and_checks_overflow() {
        let receiver = std::net::UdpSocket::bind("127.0.0.1:0").unwrap();
        receiver.set_read_timeout(Some(std::time::Duration::from_millis(150))).unwrap();
        let socket = std::net::UdpSocket::bind("127.0.0.1:0").unwrap();
        socket.connect(receiver.local_addr().unwrap()).unwrap();
        let connection = Connection { link: crate::session_connection::Link::legacy(), socket, id: Some(3), session: Some(19), sequence: 41,
            last_join: std::time::Instant::now(), champion: "garen".into(), summoners: [None, None],
            rejection: String::new(), assembler: Default::default(), welcome_history: Default::default() };
        let mut app = App::new();
        app.add_message::<AppExit>().insert_resource(connection).add_systems(Last, on_exit);
        app.update();
        let mut bytes = [0u8; 512];
        assert!(receiver.recv(&mut bytes).is_err());
        app.world_mut().write_message(AppExit::Success);app.update();
        let n = receiver.recv(&mut bytes).unwrap();
        assert!(matches!(serde_json::from_slice::<openleague_core::ClientPacket>(&bytes[..n]).unwrap(),
            openleague_core::ClientPacket::Leave { session: 19, player: 3, sequence: 42 }));
        app.world_mut().write_message(AppExit::Success);app.update();
        assert!(receiver.recv(&mut bytes).is_err());
        let mut connection = app.world_mut().resource_mut::<Connection>();
        connection.link=crate::session_connection::Link::legacy();
        connection.sequence = u64::MAX;
        assert!(send(&mut connection).unwrap_err().contains("overflow"));
        connection.session = None;
        assert!(send(&mut connection).is_ok());
        assert!(receiver.recv(&mut bytes).is_err());
    }

    #[test] fn error_exit_preserves_secure_reservation_but_retains_legacy_departure() {
        use openleague_core::session_transport as t;
        for secure in [false,true] {
            let receiver=std::net::UdpSocket::bind("127.0.0.1:0").unwrap();
            receiver.set_read_timeout(Some(std::time::Duration::from_millis(100))).unwrap();
            let socket=std::net::UdpSocket::bind("127.0.0.1:0").unwrap();socket.connect(receiver.local_addr().unwrap()).unwrap();
            let client=secure.then(||{
                // Controlled protocol fixture only, no real launcher or crash.
                let mut client=crate::session_client::Client::new(t::JoinRequest{version:t::VERSION,champion:"garen".into(),
                    summoners:[None,None],recovery_key:t::Secret32::from_bytes([17;32]).unwrap(),request_nonce:t::RequestNonce([18;16])},false,t::RequestNonce([19;16])).unwrap();
                client.welcome(t::Welcome{version:t::VERSION,context:t::Context{session:19,player:3,epoch:1},request_nonce:t::RequestNonce([18;16]),
                    access_key:t::Secret32::from_bytes([20;32]).unwrap(),next_sequence:1,bootstrap:t::ClockBootstrap::Running}).unwrap();client
            });
            let connection=Connection{socket,link:crate::session_connection::Link::new(client),id:Some(3),session:Some(19),sequence:0,
                last_join:std::time::Instant::now(),champion:"garen".into(),summoners:[None,None],rejection:String::new(),assembler:Default::default(),welcome_history:Default::default()};
            let mut app=App::new();app.add_message::<AppExit>().insert_resource(connection).add_systems(Last,on_exit);
            app.world_mut().write_message(AppExit::error());app.update();
            let mut bytes=[0;1024];let received=receiver.recv(&mut bytes);
            if secure {assert!(received.is_err());assert_eq!(app.world().resource::<Connection>().id,Some(3));}
            else {let n=received.unwrap();assert!(matches!(serde_json::from_slice::<openleague_core::ClientPacket>(&bytes[..n]).unwrap(),openleague_core::ClientPacket::Leave{player:3,..}));}
        }
    }
}
