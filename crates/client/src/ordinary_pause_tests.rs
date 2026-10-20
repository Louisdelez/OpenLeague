use super::*;
const ID: Identity = ((1u64 << 53) + 17, 42, Some((1u64 << 53) + 23));
fn ready() -> State { let mut state = State::default(); state.update(Some(ID), true, (0, false, false), 10.); state }
fn pending(state: &mut State, paused: bool) {
    state.pending = Some(Pending { sequence: (1u64 << 53) + 9, paused, sent_at: 10. });
}
#[test]
fn request_is_not_a_pause_and_refusal_keeps_received_state() {
    let mut state = ready(); pending(&mut state, true);
    assert_eq!(state.observed, Some((0, Mode::Running))); assert!(state.label().contains("Demande de pause envoyee"));
    let context = t::Context { session: ID.0, player: ID.1, epoch: ID.2.unwrap() };
    state.rejected(Some(context), Some((1u64 << 53) + 8), "pause disabled by local match host");
    assert!(state.pending.is_some(), "unrelated input rejection cannot consume pause");
    state.rejected(Some(t::Context { epoch: context.epoch + 1, ..context }), Some((1u64 << 53) + 9), "pause disabled by local match host");
    assert!(state.pending.is_some());
    state.rejected(Some(context), Some((1u64 << 53) + 9), "pause disabled by local match host");
    assert!(state.pending.is_none()); assert_eq!(state.observed, Some((0, Mode::Running)));
    assert!(state.label().contains("le serveur ne l'autorise pas"));
}
#[test]
fn new_clock_ordinal_acknowledges_pause_then_delayed_and_final_resume() {
    let mut state = ready(); pending(&mut state, true);
    state.update(Some(ID), true, (1, true, false), 10.1);
    assert!(state.pending.is_none()); assert_eq!(state.observed, Some((1, Mode::Paused)));
    pending(&mut state, false); state.update(Some(ID), true, (2, true, true), 10.2);
    assert!(state.pending.is_none()); assert_eq!(state.observed, Some((2, Mode::Resuming)));
    // EffectClock can finish its local countdown at ordinal2. Only ordinal3
    // represents the final server resume, so the UI stays conservative here.
    state.update(Some(ID), true, (2, false, false), 16.);
    assert_eq!(state.observed, Some((2, Mode::Resuming)));
    state.update(None, false, (2, false, false), 16.01);
    state.update(Some(ID), true, (2, false, false), 16.02);
    assert_eq!(state.observed, Some((2, Mode::Resuming)), "a readiness gap cannot relabel the same clock ordinal");
    state.update(Some(ID), true, (3, false, false), 16.1);
    assert_eq!(state.observed, Some((3, Mode::Running)));
}
#[test]
fn timeout_and_connection_epoch_changes_never_requeue_a_request() {
    let mut state = ready(); pending(&mut state, true);
    state.update(Some(ID), true, (0, false, false), 13.);
    assert!(state.pending.is_none()); assert!(state.label().contains("demande non renvoyee"));
    state.update(Some(ID), true, (1, true, false), 14.);
    assert_eq!(state.observed, Some((1, Mode::Paused)), "a late authoritative reply still updates status");
    pending(&mut state, false); state.update(None, false, (1, true, false), 15.);
    assert!(state.pending.is_none()); assert!(!state.available);
    state.update(Some((ID.0, ID.1, Some(ID.2.unwrap() + 1))), true, (0, false, false), 16.);
    assert!(state.pending.is_none()); assert_eq!(state.observed, Some((0, Mode::Running)));
}
#[test]
fn clock_regression_and_nonfinite_time_close_requests_without_changing_clock() {
    let mut state = ready(); state.update(Some(ID), true, (4, true, false), 11.); pending(&mut state, false);
    state.update(Some(ID), true, (3, false, false), 12.); assert!(!state.available); assert!(state.pending.is_none());
    assert_eq!(state.observed, Some((4, Mode::Paused)));
    state.update(Some(ID), true, (4, true, false), f64::NAN); assert!(!state.available);
}
#[test]
fn legacy_only_resolves_known_pause_errors_and_never_other_commands() {
    let mut state = State::default(); state.update(Some((ID.0, ID.1, None)), true, (0, false, false), 10.);
    pending(&mut state, true); state.rejected(None, None, "not enough gold"); assert!(state.pending.is_some());
    state.rejected(None, None, "pause disabled by local match host");
    assert!(state.pending.is_none()); assert_eq!(state.feedback, Some(Feedback::Disabled));
}
#[test]
fn pause_taps_are_once_only_and_focus_shop_epoch_reopening_discards_gestures() {
    let mut controls = Controls { window: Some(Entity::PLACEHOLDER), ..default() };
    assert!(!controls.consume(Some(ID), true));
    controls.key(KeyCode::Pause, ButtonState::Pressed, false); assert!(controls.consume(Some(ID), true));
    controls.key(KeyCode::Pause, ButtonState::Pressed, true); assert!(!controls.consume(Some(ID), true));
    controls.key(KeyCode::KeyR, ButtonState::Pressed, false); assert!(!controls.consume(Some(ID), true));
    controls.key(KeyCode::Pause, ButtonState::Released, false); controls.key(KeyCode::Pause, ButtonState::Pressed, false);
    assert!(!controls.consume(Some(ID), false)); assert!(!controls.consume(Some(ID), true));
    controls.key(KeyCode::Pause, ButtonState::Pressed, true); assert!(!controls.consume(Some(ID), true));
    controls.key(KeyCode::Pause, ButtonState::Released, false); controls.key(KeyCode::Pause, ButtonState::Pressed, false);
    assert!(!controls.consume(Some((ID.0, ID.1, Some(ID.2.unwrap() + 1))), true));
}
#[test]
fn real_keyboard_messages_ignore_other_keys_and_keep_global_button_state() {
    use bevy::input::{InputPlugin, keyboard::Key};
    let mut app = App::new(); app.add_plugins(InputPlugin).init_resource::<Controls>();
    let window = app.world_mut().spawn((Window { focused: true, ..default() }, PrimaryWindow)).id();
    app.add_systems(PreUpdate, collect.after(InputSystems)); app.update();
    app.world_mut().resource_mut::<Controls>().consume(Some(ID), true);
    for code in [KeyCode::KeyR, KeyCode::Pause] {
        app.world_mut().write_message(KeyboardInput { key_code: code, logical_key: Key::Character("fixture".into()),
            state: ButtonState::Pressed, text: None, repeat: false, window });
    }
    app.update(); assert!(app.world_mut().resource_mut::<Controls>().consume(Some(ID), true));
    assert!(app.world().resource::<ButtonInput<KeyCode>>().pressed(KeyCode::KeyR));
    app.world_mut().get_mut::<Window>(window).unwrap().focused = false;
    app.update(); assert!(!app.world().resource::<Controls>().armed);
    app.world_mut().get_mut::<Window>(window).unwrap().focused = true;
    app.update(); assert!(!app.world_mut().resource_mut::<Controls>().consume(Some(ID), true));
}

#[test]
fn clickable_label_waits_for_received_state_and_never_offers_an_optimistic_resume() {
    let mut state = ready(); assert_eq!(state.button_label(), ("Pause", true));
    pending(&mut state, true); assert_eq!(state.button_label(), ("Demande envoyee", false));
    assert_eq!(state.observed, Some((0, Mode::Running)));
    state.update(Some(ID), true, (1, true, false), 10.1);
    assert_eq!(state.button_label(), ("Reprendre", true));
    pending(&mut state, false); state.update(Some(ID), true, (2, true, true), 10.2);
    assert_eq!(state.button_label(), ("Reprise en cours", false));
    state.update(Some(ID), true, (2, false, false), 16.);
    assert_eq!(state.button_label(), ("Reprise en cours", false), "local countdown is not final server authority");
    state.update(Some(ID), true, (3, false, false), 16.1);
    assert_eq!(state.button_label(), ("Pause", true));
    state.update(None, false, (3, false, false), 16.2);
    assert_eq!(state.button_label(), ("Pause indisponible", false));
}

#[test]
fn button_and_keyboard_share_one_gate_and_never_replay_held_interaction_after_a_gap() {
    let mut controls = Controls { window: Some(Entity::PLACEHOLDER), ..default() };
    assert!(!controls.consume(Some(ID), true));
    controls.button(Interaction::Pressed, true);
    controls.key(KeyCode::Pause, ButtonState::Pressed, false);
    assert!(controls.consume(Some(ID), true)); assert!(!controls.consume(Some(ID), true));
    controls.button(Interaction::Pressed, false); assert!(!controls.consume(Some(ID), true));
    controls.button(Interaction::Pressed, true); assert!(!controls.consume(Some(ID), false));
    controls.button(Interaction::Pressed, false); assert!(!controls.consume(Some(ID), true));
    assert!(!controls.consume(Some(ID), true), "held click is not retried when availability returns");
    controls.button(Interaction::Hovered, true); assert!(!controls.consume(Some(ID), true));
    controls.button(Interaction::Pressed, true); assert!(controls.consume(Some(ID), true));
    controls.button(Interaction::Pressed, true);
    let next = Some((ID.0, ID.1, Some(ID.2.unwrap() + 1)));
    assert!(!controls.consume(next, true));
    controls.button(Interaction::Pressed, false); assert!(!controls.consume(next, true));
}

// These tests use the real ECS drive, authenticated Connection and clock. They
// set Bevy Interaction directly; they do not claim native pointer/GPU coverage.
#[cfg(windows)]
fn clickable_hud_fixture() -> (App, std::net::UdpSocket, Entity, Entity, t::Context) {
    use std::{net::UdpSocket, time::{Duration, Instant}};
    let nav = openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),
        include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let mut game = openleague_core::Simulation::new(nav).unwrap(); game.session = ID.0;
    let player = game.join("garen").unwrap(); let snapshot = game.snapshot();
    let server = UdpSocket::bind("127.0.0.1:0").unwrap();
    server.set_read_timeout(Some(Duration::from_millis(100))).unwrap();
    let socket = UdpSocket::bind("127.0.0.1:0").unwrap();
    socket.connect(server.local_addr().unwrap()).unwrap(); socket.set_nonblocking(true).unwrap();
    let nonce = t::RequestNonce([17; 16]);
    let client = crate::session_client::Client::new(t::JoinRequest { version: t::VERSION, champion: "garen".into(),
        summoners: [Some(openleague_core::summoners::Spell::Smite), None],
        recovery_key: t::Secret32::from_bytes([18; 32]).unwrap(), request_nonce: nonce }, false, t::RequestNonce([19; 16])).unwrap();
    let mut connection = crate::Connection { socket, link: crate::session_connection::Link::new(Some(client)),
        id: None, session: None, sequence: 0, last_join: Instant::now() - Duration::from_secs(2),
        champion: "garen".into(), summoners: [Some(openleague_core::summoners::Spell::Smite), None],
        rejection: String::new(), assembler: Default::default(), welcome_history: Default::default() };
    let context = t::Context { session: snapshot.session, player, epoch: 1 };
    let welcome = t::Welcome { version: t::VERSION, context, request_nonce: nonce,
        access_key: t::Secret32::from_bytes([20; 32]).unwrap(), next_sequence: 1, bootstrap: t::ClockBootstrap::Running };
    let incoming = connection.decode_datagram(&serde_json::to_vec(&t::ServerMessage::SessionWelcome(welcome)).unwrap()).unwrap();
    assert!(matches!(incoming, Some(crate::session_connection::Incoming::Welcome { .. })));
    connection.id = Some(player); connection.session = Some(context.session);
    let mut sender = openleague_core::session_wire::Sender::new(context).unwrap();
    for bytes in sender.encode(&snapshot, 0).unwrap() { assert!(connection.decode_datagram(&bytes).unwrap().is_none()); }
    let crate::session_connection::Incoming::State { snapshot, delivery } = connection.take_ready_states().pop().unwrap()
        else { panic!("real OLSR state"); };
    assert!(!connection.ready()); connection.presented(delivery).unwrap(); assert!(connection.ready());
    let mut app = App::new(); app.add_plugins(bevy::input::InputPlugin);
    app.insert_resource(connection); app.insert_resource(crate::Match { snapshot: Some(snapshot), ..default() });
    let mut shop = crate::shop_ui::Filters::default(); shop.open = false; shop.focused = false;
    app.insert_resource(shop); app.init_resource::<Time<Real>>(); app.init_resource::<Controls>();
    crate::native_effect_clock::install_test_clock(&mut app);
    app.add_plugins(crate::native_effect_clock::Plugin);
    app.add_systems(PreUpdate, collect.after(InputSystems)).add_systems(Update, drive);
    let window = app.world_mut().spawn((Window { focused: true, ..default() }, PrimaryWindow)).id();
    let button = app.world_mut().spawn((Button, PauseButton, BackgroundColor::default())).id();
    app.world_mut().spawn((PauseHud, Text::new("")));
    app.world_mut().spawn((PauseButtonLabel, Text::new("")));
    app.update(); app.update();
    assert!(app.world().resource::<Controls>().armed);
    (app, server, window, button, context)
}

#[cfg(windows)]
fn button_gesture(app: &mut App, button: Entity) {
    *app.world_mut().get_mut::<Interaction>(button).unwrap() = Interaction::Hovered; app.update();
    *app.world_mut().get_mut::<Interaction>(button).unwrap() = Interaction::Pressed; app.update();
}
#[cfg(windows)]
fn received_input(server: &std::net::UdpSocket) -> t::SessionInput {
    let mut bytes = [0; 16384]; let n = server.recv(&mut bytes).unwrap();
    let t::ClientMessage::Session(input) = serde_json::from_slice(&bytes[..n]).unwrap() else { panic!("authenticated input"); };
    input
}
#[cfg(windows)]
fn apply_button_clock(app: &mut App, context: t::Context, ordinal: u64, opcode: u16, payload: &[u8]) {
    app.world_mut().resource_scope(|world, mut connection: Mut<crate::Connection>| {
        let mut clock = world.resource_mut::<crate::native_effect_clock::EffectClock>();
        crate::session_connection::apply_clock(&mut connection, &mut clock, Some(context), context.session, ordinal, opcode, payload).unwrap();
    });
}

#[cfg(windows)]
#[test]
fn real_ecs_button_sends_once_displays_refusal_and_resumes_only_from_applied_clock() {
    let (mut app, server, _, button, context) = clickable_hud_fixture();
    button_gesture(&mut app, button); let first = received_input(&server);
    assert_eq!(first.context, context); assert!(matches!(first.input, t::Input::PauseRequest { paused: true }));
    assert!(!app.world().resource::<crate::native_effect_clock::EffectClock>().paused());
    assert_eq!(app.world().resource::<crate::Match>().pause_control.button_label(), ("Demande envoyee", false));
    app.update(); assert!(server.recv(&mut [0; 16384]).is_err(), "held Interaction must not send twice");
    let reject = t::ServerMessage::SessionGameplayRejected(t::GameplayRejection { context, sequence: first.sequence,
        reason: "pause disabled by local match host".into() });
    let incoming = app.world_mut().resource_mut::<crate::Connection>().decode_datagram(&serde_json::to_vec(&reject).unwrap()).unwrap();
    let Some(crate::session_connection::Incoming::GameplayRejected { context, sequence, reason }) = incoming else { panic!("refusal"); };
    app.world_mut().resource_mut::<crate::Match>().pause_control.rejected(Some(context), Some(sequence), &reason);
    app.update();
    let mut labels = app.world_mut().query_filtered::<&Text, With<PauseHud>>();
    assert!(labels.single(app.world()).unwrap().contains("le serveur ne l'autorise pas"));
    assert_eq!(app.world().resource::<crate::Match>().pause_control.button_label(), ("Pause", true));
    button_gesture(&mut app, button); let second = received_input(&server); assert_eq!(second.sequence, first.sequence + 1);
    let mut pause = [0; 14]; pause[9..13].copy_from_slice(&30i32.to_le_bytes()); pause[13] = 1;
    apply_button_clock(&mut app, context, 1, 0xa1, &pause);
    assert!(matches!(received_input(&server).input, t::Input::ClockAck { ordinal: 1 }));
    app.update(); assert!(app.world().resource::<crate::native_effect_clock::EffectClock>().paused());
    let mut labels = app.world_mut().query_filtered::<&Text, With<PauseButtonLabel>>();
    assert_eq!(labels.single(app.world()).unwrap().0, "Reprendre");
    button_gesture(&mut app, button); let resume = received_input(&server);
    assert!(resume.sequence > second.sequence); assert!(matches!(resume.input, t::Input::PauseRequest { paused: false }));
    assert!(app.world().resource::<crate::native_effect_clock::EffectClock>().paused(), "click does not apply resume");
    apply_button_clock(&mut app, context, 2, 0x0a, &[0; 10]);
    assert!(matches!(received_input(&server).input, t::Input::ClockAck { ordinal: 2 }));
    app.update(); assert!(!app.world().resource::<crate::native_effect_clock::EffectClock>().paused());
    assert_eq!(app.world().resource::<crate::Match>().pause_control.button_label(), ("Pause", true));
    assert!(server.recv(&mut [0; 16384]).is_err());
}

#[cfg(windows)]
#[test]
fn real_ecs_button_drops_focus_shop_and_disconnected_clicks_without_later_retry() {
    let (mut app, server, window, button, _) = clickable_hud_fixture();
    app.world_mut().get_mut::<Window>(window).unwrap().focused = false;
    button_gesture(&mut app, button); assert!(server.recv(&mut [0; 16384]).is_err());
    app.world_mut().get_mut::<Window>(window).unwrap().focused = true;
    app.update(); app.update(); assert!(server.recv(&mut [0; 16384]).is_err());
    app.world_mut().resource_mut::<crate::shop_ui::Filters>().open = true;
    button_gesture(&mut app, button); assert!(server.recv(&mut [0; 16384]).is_err());
    app.world_mut().resource_mut::<crate::shop_ui::Filters>().open = false;
    app.update(); app.update(); assert!(server.recv(&mut [0; 16384]).is_err());
    button_gesture(&mut app, button); assert!(matches!(received_input(&server).input, t::Input::PauseRequest { paused: true }));
    app.world_mut().resource_mut::<crate::Connection>().network_interrupted();
    button_gesture(&mut app, button); app.update();
    assert!(server.recv(&mut [0; 16384]).is_err());
    assert_eq!(app.world().resource::<crate::Match>().pause_control.button_label(), ("Pause indisponible", false));
}
