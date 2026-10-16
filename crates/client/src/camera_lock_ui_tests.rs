use super::*;
use bevy::input::mouse::MouseButtonInput;
fn owner() -> Owner { Owner { pid: std::process::id(), session: 7, player: 21, epoch: Some(3), primary_window: Entity::PLACEHOLDER } }
fn rect() -> Rect { Rect([10.,20.,30.,40.]) }
fn motion() -> WindowEvent { WindowEvent::CursorMoved(bevy::window::CursorMoved { window: Entity::PLACEHOLDER, position: Vec2::new(20.,30.), delta: None }) }
fn button(state: ButtonState) -> WindowEvent { WindowEvent::MouseButtonInput(MouseButtonInput { window: Entity::PLACEHOLDER, button: MouseButton::Left, state }) }
fn frame(capture: &mut Capture, focused: bool, owner: Owner, events: &[WindowEvent]) -> Vec<Gesture> {
    capture.frame(owner.primary_window, focused, rect(), owner, true, 10, false, events.iter())
}
#[test]
fn original_camera_records_keep_rect_uv_atlas_and_select_only_one_appearance() {
    let root = std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
    let mut provider = crate::native_zip_provider::Provider::from_catalog(&root).unwrap(); let hud = provider.startup_hud(&root).unwrap();
    let sources = source(&hud).unwrap(); assert_eq!(sources.len(), 6);
    for (name, uv) in [(NAMES[0],[513.,239.,550.,270.]), (NAMES[1],[672.,239.,709.,270.]), (NAMES[2],[750.,239.,787.,270.]),
        (NAMES[3],[711.,239.,748.,270.]), (NAMES[4],[672.,239.,709.,270.]), (NAMES[5],[750.,239.,787.,270.])] {
        let panel = owned_panel(&sources[name]).unwrap(); let (node, material) = crate::native_hud_panels::payload(&panel,[1280,800],1.,1.,Handle::default()).unwrap();
        assert_eq!(material.parameters.uv.to_array(), uv.map(|v| v / 1024.)); assert!(Rect::from_node(&node).is_ok());
        assert_eq!(panel.storage.flags() & 1, 1); assert_eq!(panel.storage.word(0x1a4), if name.ends_with("Pressed") {13} else {12});
    }
    let mut capture = Capture::default(); frame(&mut capture,true,owner(),&[]);
    assert_eq!(capture.appearance(rect()),0); frame(&mut capture,true,owner(),&[motion()]); assert_eq!(capture.appearance(rect()),1);
    frame(&mut capture,true,owner(),&[button(ButtonState::Pressed)]); assert_eq!(capture.appearance(rect()),2);
}
#[test]
fn ordered_short_click_has_one_owned_release_and_blocks_world_pointer() {
    let mut capture = Capture::default(); frame(&mut capture,true,owner(),&[]);
    let out = frame(&mut capture,true,owner(),&[motion(),button(ButtonState::Pressed),button(ButtonState::Pressed),button(ButtonState::Released),button(ButtonState::Released)]);
    assert_eq!(out.len(),1); assert_eq!(out[0].owner,owner()); assert_eq!(out[0].expected_revision,10); assert!(!out[0].expected_locked);
    assert!(capture.blocks_world_pointer());
}
#[test]
fn background_keyboard_policy_does_not_admit_unfocused_pointer_clicks() {
    let mut capture = Capture::default(); frame(&mut capture,true,owner(),&[]);
    assert!(frame(&mut capture,false,owner(),&[motion(),button(ButtonState::Pressed),button(ButtonState::Released)]).is_empty());
    assert!(capture.armed.is_none());
}
#[test]
fn new_epoch_and_focus_loss_cancel_pointer_lease_without_replaying_release() {
    for variant in 0..2 {
        let mut capture = Capture::default(); frame(&mut capture,true,owner(),&[]);
        frame(&mut capture,true,owner(),&[motion(),button(ButtonState::Pressed)]); assert!(capture.armed.is_some());
        let changed = if variant == 0 { Owner { epoch: Some(4), ..owner() } } else { owner() };
        assert!(frame(&mut capture,variant == 0,changed,&[]).is_empty());
        assert!(frame(&mut capture,true,changed,&[motion(),button(ButtonState::Released)]).is_empty());
    }
}
#[test]
fn foreign_window_events_cannot_toggle_or_steal_an_owned_press() {
    let mut capture = Capture::default(); frame(&mut capture,true,owner(),&[]);
    frame(&mut capture,true,owner(),&[motion(),button(ButtonState::Pressed)]);
    let mut world = World::new(); let foreign = world.spawn_empty().id();
    let events = [WindowEvent::MouseButtonInput(MouseButtonInput { window: foreign, button: MouseButton::Left, state: ButtonState::Released })];
    assert!(frame(&mut capture,true,owner(),&events).is_empty()); assert!(capture.armed.is_some());
    assert_eq!(frame(&mut capture,true,owner(),&[button(ButtonState::Released)]).len(),1);
}
#[test]
fn human_hotkey_change_during_press_prevents_stale_ui_release() {
    let mut setting = Setting::default();
    setting.reconcile(crate::camera_lock::Admission { owner: Some(owner()), ready: true, terminal: false, human_enabled: true });
    let mut capture = Capture::default();
    capture.frame(owner().primary_window,true,rect(),owner(),true,setting.revision(),setting.locked(),std::iter::empty());
    capture.frame(owner().primary_window,true,rect(),owner(),true,setting.revision(),setting.locked(),[motion(),button(ButtonState::Pressed)].iter());
    let request = setting.request(true,Origin::Hotkey).unwrap(); setting.consume(request).unwrap();
    let gesture = capture.frame(owner().primary_window,true,rect(),owner(),true,setting.revision(),setting.locked(),[button(ButtonState::Released)].iter()).pop().unwrap();
    let next = setting.request(!gesture.expected_locked,Origin::Ui).unwrap();
    let request = Request { owner:gesture.owner,expected_revision:gesture.expected_revision,expected_locked:gesture.expected_locked,..next };
    assert_eq!(setting.consume(request),Err(crate::camera_lock::Rejection::StaleRevision));
    assert!(setting.locked()); assert_eq!(setting.last_origin(),Some(Origin::Hotkey));
}
