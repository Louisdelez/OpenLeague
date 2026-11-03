use super::*;

fn owner() -> Owner { Owner { pid: std::process::id(), session: 7, player: 21,
    epoch: Some(3), primary_window: Entity::PLACEHOLDER } }
fn ready() -> Setting {
    let mut setting = Setting::default();
    setting.reconcile(Admission { owner: Some(owner()), ready: true, terminal: false, human_enabled: true }); setting
}
fn observer(setting: &Setting, locked: bool, id: u64) -> Request { setting.request(locked, Origin::Observer(id)).unwrap() }

#[test]
fn native_default_remains_unlocked_and_invalid_configuration_is_explicit() {
    let source = include_str!("../../../data/4.20/configuration/defaults/Game.cfg");
    assert!(source.split("[HUD]").nth(1).unwrap().lines().take_while(|l| !l.starts_with('[')).any(|l| l.trim() == "LockCamera=0"));
    assert!(!Setting::default().locked()); assert_eq!(configured(Some(b"0")), Ok(false));
    assert_eq!(configured(Some(b"1")), Ok(true)); assert!(configured(None).is_err()); assert!(configured(Some(b"2")).is_err());
}

#[test]
fn owner_pid_session_player_epoch_and_window_are_all_guarded() {
    let base = owner(); let mut world = World::new(); let other = world.spawn_empty().id();
    let owners = [Owner { pid: base.pid.wrapping_add(1), ..base }, Owner { session: 8, ..base },
        Owner { player: 22, ..base }, Owner { epoch: Some(4), ..base }, Owner { primary_window: other, ..base }];
    for foreign in owners {
        let mut setting = ready(); let mut request = observer(&setting, true, 11); request.owner = foreign;
        assert_eq!(setting.consume(request), Err(Rejection::ForeignOwner)); assert!(!setting.locked());
    }
}

#[test]
fn expected_revision_state_and_serial_refuse_stale_requests_without_change() {
    for kind in 0..3 {
        let mut setting = ready(); let before = (setting.revision(), setting.last_serial(), setting.locked());
        let mut request = observer(&setting, true, 11);
        match kind { 0 => request.expected_revision += 1, 1 => request.expected_locked = true, _ => request.serial = 0 }
        assert!(setting.consume(request).is_err()); assert_eq!(before, (setting.revision(), setting.last_serial(), setting.locked()));
    }
}

#[test]
fn readiness_and_terminal_boundaries_refuse_mutation_and_invalidate_lease() {
    for terminal in [false, true] {
        let mut setting = ready(); let request = observer(&setting, true, 11);
        let lease = setting.acquire_observer(request).unwrap();
        setting.reconcile(Admission { owner: Some(owner()), ready: terminal, terminal, human_enabled: false });
        let request = observer(&setting, false, 11);
        assert_eq!(setting.consume(request), Err(if terminal { Rejection::Terminal } else { Rejection::NotReady }));
        assert_eq!(setting.restore_observer(&lease, setting.last_serial() + 1), Err(Rejection::StaleRevision));
        assert!(!setting.follows_authoritative_target());
    }
}

#[test]
fn background_lock_can_follow_but_unfocused_human_hotkey_and_ui_are_refused() {
    let mut setting = ready(); let request = observer(&setting, true, 11); setting.consume(request).unwrap();
    setting.reconcile(Admission { owner: Some(owner()), ready: true, terminal: false, human_enabled: false });
    assert!(setting.follows_authoritative_target());
    for origin in [Origin::Hotkey, Origin::Ui, Origin::Minimap] {
        let request = setting.request(false, origin).unwrap(); assert_eq!(setting.consume(request), Err(Rejection::HumanGate));
    }
    assert!(setting.locked());
}

#[test]
fn clean_observer_lease_restores_once_and_new_epoch_cannot_restore() {
    let mut setting = ready(); let request = observer(&setting, true, 11); let lease = setting.acquire_observer(request).unwrap();
    let serial = setting.last_serial() + 1; setting.restore_observer(&lease, serial).unwrap(); assert!(!setting.locked());
    assert_eq!(setting.restore_observer(&lease, serial + 1), Err(Rejection::StaleRevision));
    let request = observer(&setting, true, 12); let lease = setting.acquire_observer(request).unwrap();
    setting.reconcile(Admission { owner: Some(Owner { epoch: Some(4), ..owner() }), ready: true, terminal: false, human_enabled: true });
    assert_eq!(setting.restore_observer(&lease, 1), Err(Rejection::ForeignOwner)); assert!(!setting.locked());
}

#[test]
fn human_changes_and_human_noops_invalidate_observer_restoration() {
    for desired in [false, true] {
        let mut setting = ready(); let request = observer(&setting, true, 11); let lease = setting.acquire_observer(request).unwrap();
        let request = setting.request(desired, Origin::Hotkey).unwrap(); setting.consume(request).unwrap();
        let serial = setting.last_serial() + 1;
        assert_eq!(setting.restore_observer(&lease, serial), Err(Rejection::StaleRevision)); assert_eq!(setting.locked(), desired);
    }
}

#[test]
fn observer_setting_operations_preserve_already_pressed_human_buttons() {
    let mut keys = ButtonInput::<KeyCode>::default(); keys.press(KeyCode::KeyY); keys.press(KeyCode::Space); keys.press(KeyCode::ArrowLeft);
    let mut mouse = ButtonInput::<MouseButton>::default(); mouse.press(MouseButton::Left);
    let mut setting = ready(); let request = observer(&setting, true, 11); let lease = setting.acquire_observer(request).unwrap();
    let serial = setting.last_serial() + 1; setting.restore_observer(&lease, serial).unwrap();
    for key in [KeyCode::KeyY, KeyCode::Space, KeyCode::ArrowLeft] { assert!(keys.pressed(key)); assert!(keys.just_pressed(key)); }
    assert!(mouse.pressed(MouseButton::Left)); assert!(mouse.just_pressed(MouseButton::Left));
}

#[test]
fn physical_ui_observer_and_minimap_share_one_revision_consumer() {
    let mut setting = ready();
    for (origin, desired) in [(Origin::Hotkey, true), (Origin::Ui, false), (Origin::Observer(11), true), (Origin::Minimap, false)] {
        let before = setting.revision(); let request = setting.request(desired, origin).unwrap();
        let result = setting.consume(request).unwrap(); assert_eq!(result.revision, before + 1);
        assert_eq!(result.origin, origin); assert_eq!(setting.locked(), desired);
    }
}
