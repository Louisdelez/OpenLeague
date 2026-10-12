use super::*;

#[test]
fn camera_keys_match_original_gameevents_default_bindings() {
    let source = include_str!("../../../data/4.20/configuration/defaults/Input.ini");
    let events = source.split("[GameEvents]").nth(1).unwrap().split('\n')
        .map(str::trim).take_while(|line| !line.starts_with('[')).collect::<Vec<_>>();
    for binding in ["evtCameraLockToggle = [y]", "evtCameraSnap = [Space]",
        "evtScrollUp = [Up Arrow]", "evtScrollDown = [Down Arrow]",
        "evtScrollLeft = [Left Arrow]", "evtScrollRight = [Right Arrow]"] {
        assert!(events.contains(&binding), "missing original binding: {binding}");
    }
}

fn context() -> Context { Context { identity: Some((7, 21)), enabled: true, target: Some(Vec3::new(370., 0., 385.)) } }
fn ready() -> Controls {
    let mut input = Controls { window: Some(Entity::PLACEHOLDER), ..default() };
    input.apply(context(), 0.016, &mut Vec3::ZERO); input
}
fn down(input: &mut Controls, key: KeyCode) { input.key(key, ButtonState::Pressed, false); }
fn up(input: &mut Controls, key: KeyCode) { input.key(key, ButtonState::Released, false); }

#[test]
fn press_release_in_one_frame_pans_once_while_frame_end_pressed_is_false() {
    let mut input = ready(); let mut focus = Vec3::ZERO;
    down(&mut input, KeyCode::ArrowRight); up(&mut input, KeyCode::ArrowRight);
    assert!(!input.held.contains(&KeyCode::ArrowRight));
    input.apply(context(), 0.02, &mut focus); assert_eq!(focus, Vec3::new(3., 0., 0.));
    input.apply(context(), 0.02, &mut focus); assert_eq!(focus, Vec3::new(3., 0., 0.));
}

#[test]
fn held_pan_preserves_existing_speed_and_does_not_add_tap_to_hold() {
    let mut input = ready(); let mut focus = Vec3::ZERO;
    down(&mut input, KeyCode::ArrowUp); input.apply(context(), 0.02, &mut focus);
    input.clear_frame(); input.apply(context(), 0.02, &mut focus); assert_eq!(focus.z, -6.);
    up(&mut input, KeyCode::ArrowUp); input.apply(context(), 0.02, &mut focus); assert_eq!(focus.z, -6.);
}

#[test]
fn opposing_taps_cancel_and_unrelated_gameplay_keys_are_untouched() {
    let mut input = ready(); let mut focus = Vec3::ZERO;
    for key in [KeyCode::ArrowLeft, KeyCode::ArrowRight, KeyCode::KeyE, KeyCode::KeyD, KeyCode::KeyF, KeyCode::KeyP] {
        down(&mut input, key); up(&mut input, key);
    }
    input.apply(context(), 0.02, &mut focus); assert_eq!(focus, Vec3::ZERO); assert!(input.held.is_empty());
}

#[test]
fn space_short_tap_centers_once_and_hold_follows_then_releases() {
    let mut input = ready(); let mut focus = Vec3::ZERO;
    down(&mut input, KeyCode::Space); up(&mut input, KeyCode::Space);
    input.apply(context(), 0.02, &mut focus); assert_eq!(Some(focus), context().target);
    let next = Context { target: Some(Vec3::new(400., 0., 400.)), ..context() };
    input.apply(next, 0.02, &mut focus); assert_eq!(Some(focus), context().target);
    down(&mut input, KeyCode::Space); input.apply(next, 0.02, &mut focus); assert_eq!(Some(focus), next.target);
    up(&mut input, KeyCode::Space); input.apply(context(), 0.02, &mut focus); assert_eq!(Some(focus), next.target);
}

#[test]
fn y_toggles_once_with_repeat_ignored_and_locked_follow_takes_priority_over_pan() {
    let mut input = ready(); let mut focus = Vec3::ZERO;
    down(&mut input, KeyCode::KeyY); down(&mut input, KeyCode::ArrowRight);
    input.apply(context(), 0.02, &mut focus); assert!(input.follow); assert_eq!(Some(focus), context().target);
    input.key(KeyCode::KeyY, ButtonState::Pressed, true); input.apply(context(), 0.02, &mut focus); assert!(input.follow);
    up(&mut input, KeyCode::KeyY); down(&mut input, KeyCode::KeyY); up(&mut input, KeyCode::KeyY);
    input.apply(context(), 0.02, &mut focus); assert!(!input.follow); assert_eq!(focus.x, 373.);
}

#[test]
fn blocked_frame_and_reopening_discard_gestures_without_replaying_os_repeats() {
    let mut input = ready(); let mut focus = Vec3::ZERO;
    down(&mut input, KeyCode::ArrowRight); down(&mut input, KeyCode::KeyY); down(&mut input, KeyCode::Space);
    input.apply(Context { enabled: false, ..context() }, 0.02, &mut focus);
    assert!(!input.follow); assert_eq!(focus, Vec3::ZERO); assert!(!input.accepts_wheel(Entity::PLACEHOLDER));
    input.key(KeyCode::ArrowRight, ButtonState::Pressed, true);
    down(&mut input, KeyCode::Space); input.apply(context(), 0.02, &mut focus); // reopening frame
    input.key(KeyCode::ArrowRight, ButtonState::Pressed, true); input.apply(context(), 0.02, &mut focus);
    assert_eq!(focus, Vec3::ZERO); assert!(input.held.is_empty());
    up(&mut input, KeyCode::ArrowRight); down(&mut input, KeyCode::ArrowRight);
    input.apply(context(), 0.02, &mut focus); assert_eq!(focus.x, 3.);
}

#[test]
fn same_session_recovery_preserves_only_follow_new_player_or_session_resets_it() {
    let mut input = ready(); let mut focus = Vec3::ZERO;
    down(&mut input, KeyCode::KeyY); up(&mut input, KeyCode::KeyY); input.apply(context(), 0.02, &mut focus);
    input.apply(Context { enabled: false, ..context() }, 0.02, &mut focus); assert!(input.follow);
    focus = Vec3::ZERO; input.apply(context(), 0.02, &mut focus); assert_eq!(focus, Vec3::ZERO);
    input.apply(context(), 0.02, &mut focus); assert_eq!(Some(focus), context().target);
    for identity in [(7, 22), (8, 22)] {
        down(&mut input, KeyCode::ArrowRight); let changed = Context { identity: Some(identity), ..context() };
        input.apply(changed, 0.02, &mut focus); assert!(!input.follow); assert!(input.held.is_empty());
    }
}

#[test]
fn absent_or_nonfinite_authoritative_target_suspends_without_guessing_position() {
    for target in [None, Some(Vec3::splat(f32::NAN)), Some(Vec3::splat(f32::INFINITY))] {
        let mut input = ready(); let mut focus = Vec3::ONE; down(&mut input, KeyCode::Space);
        input.apply(Context { target, ..context() }, 0.02, &mut focus); assert_eq!(focus, Vec3::ONE); assert!(!input.armed);
    }
}

#[test]
fn nonfinite_or_zero_frame_delta_never_adds_motion_or_queues_a_later_tap() {
    for delta in [0., -1., f32::NAN, f32::INFINITY] {
        let mut input = ready(); let mut focus = Vec3::ZERO;
        down(&mut input, KeyCode::ArrowRight); up(&mut input, KeyCode::ArrowRight);
        input.apply(context(), delta, &mut focus); input.apply(context(), 0.02, &mut focus); assert_eq!(focus, Vec3::ZERO);
    }
}

#[test]
fn focus_loss_and_window_replacement_discard_taps_and_do_not_consume_other_readers() {
    use bevy::input::{InputPlugin, keyboard::Key};
    let mut app = App::new(); app.add_plugins(InputPlugin).init_resource::<Controls>().add_systems(PreUpdate, collect.after(InputSystems));
    let window = app.world_mut().spawn((Window { focused: true, ..default() }, PrimaryWindow)).id(); app.update();
    { let mut input = app.world_mut().resource_mut::<Controls>(); input.apply(context(), 0.02, &mut Vec3::ZERO); }
    for state in [ButtonState::Pressed, ButtonState::Released] {
        app.world_mut().write_message(KeyboardInput { key_code: KeyCode::ArrowRight, logical_key: Key::ArrowRight, state, text: None, repeat: false, window });
    }
    app.update(); assert!(app.world().resource::<Controls>().taps[3]);
    assert!(!app.world().resource::<ButtonInput<KeyCode>>().pressed(KeyCode::ArrowRight));
    assert!(app.world().resource::<ButtonInput<KeyCode>>().just_pressed(KeyCode::ArrowRight));
    app.world_mut().write_message(KeyboardFocusLost); app.update();
    { let input = app.world().resource::<Controls>(); assert!(input.held.is_empty()); assert!(!input.taps[3]); assert!(!input.armed); }
    app.world_mut().despawn(window);
    let replacement = app.world_mut().spawn((Window { focused: true, ..default() }, PrimaryWindow)).id(); app.update();
    assert_eq!(app.world().resource::<Controls>().window, Some(replacement)); assert!(!app.world().resource::<Controls>().armed);
}

#[test]
fn wheel_permission_is_primary_window_only_and_disappears_during_gate() {
    let mut input = ready(); input.apply(context(), 0.02, &mut Vec3::ZERO);
    assert!(input.accepts_wheel(Entity::PLACEHOLDER));
    let mut world = World::new(); let other = world.spawn_empty().id(); assert!(!input.accepts_wheel(other));
    input.apply(Context { enabled: false, ..context() }, 0.02, &mut Vec3::ZERO); assert!(!input.accepts_wheel(Entity::PLACEHOLDER));
}

#[test]
fn local_inspection_does_not_advance_or_require_game_time_or_living_state() {
    // The control boundary accepts only identity/ready/visible position, never
    // mutates Snapshot or EffectClock, and does not predict a respawn position.
    let mut input = ready(); let mut focus = Vec3::ZERO;
    down(&mut input, KeyCode::KeyY); up(&mut input, KeyCode::KeyY);
    input.apply(context(), 0., &mut focus); assert_eq!(Some(focus), context().target);
    let observed_respawn = Context { target: Some(Vec3::new(50., 0., 250.)), ..context() };
    input.apply(observed_respawn, 0., &mut focus); assert_eq!(Some(focus), observed_respawn.target);
}
