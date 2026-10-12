use super::*;
fn game() -> Simulation {
    let nav = Navigation::load(
        include_str!("../../../../assets/maps/tt_navigation_grid.json"),
        include_bytes!("../../../../assets/maps/tt_navigation_grid.cells.bin"),
    )
    .unwrap();
    let mut s = Simulation::new(nav).unwrap();
    s.enable_map10().unwrap();
    s
}
fn step(s: &mut Simulation, n: u64) {
    for _ in 0..n {
        s.advance();
    }
}
#[test]
fn initial_lock_capture_and_ninety_second_lock_are_authoritative() {
    let mut s = game();
    let id = s.join("garen").unwrap();
    s.players.get_mut(&id).unwrap().position = config().altars[0].position;
    s.tick = 5398;
    s.advance();
    assert_eq!(s.owned_altars(0), 0);
    s.advance();
    assert_eq!(s.snapshot().map10.unwrap().altars[0].capturing, Some(0));
    step(&mut s, 239);
    assert_eq!(s.owned_altars(0), 0);
    s.advance();
    let a = &s.snapshot().map10.unwrap().altars[0];
    assert_eq!(a.owner, Some(0));
    assert_eq!(a.locked_until, s.tick + 2700);
    assert_eq!(a.captured_tick, Some(s.tick));
}
#[test]
fn contest_pauses_empty_resets_team_switch_resets_and_dead_cannot_capture() {
    let mut s = game();
    let blue = s.join("garen").unwrap();
    let red = s.join("ahri").unwrap();
    let pos = config().altars[0].position;
    s.players.get_mut(&blue).unwrap().position = pos;
    s.tick = 5399;
    step(&mut s, 11);
    let before = s.snapshot().map10.unwrap().altars[0].progress_ticks;
    assert_eq!(before, 10);
    s.players.get_mut(&red).unwrap().position = pos;
    step(&mut s, 10);
    let a = &s.snapshot().map10.unwrap().altars[0];
    assert!(a.contested);
    assert_eq!(a.progress_ticks, before);
    s.players.get_mut(&blue).unwrap().position.x += 1500.;
    s.advance();
    let a = &s.snapshot().map10.unwrap().altars[0];
    assert_eq!(a.capturing, Some(1));
    assert_eq!(a.progress_ticks, 0);
    s.players.get_mut(&red).unwrap().health = 0.;
    s.advance();
    let a = &s.snapshot().map10.unwrap().altars[0];
    assert_eq!(a.capturing, None);
    assert_eq!(a.progress_ticks, 0);
}
#[test]
fn locked_altar_cannot_be_stolen_and_damage_bonus_is_removed_when_lost() {
    let mut s = game();
    let blue = s.join("garen").unwrap();
    let red = s.join("garen").unwrap();
    let base = s.stats(blue).damage;
    for a in &mut s.interactions.as_mut().unwrap().state.altars {
        a.owner = Some(0);
        a.locked_until = 6000;
    }
    assert!((s.stats(blue).damage - base * 1.1).abs() < 0.001);
    s.players.get_mut(&red).unwrap().position = config().altars[0].position;
    s.tick = 5998;
    s.advance();
    assert_eq!(s.owned_altars(0), 2);
    s.advance();
    step(&mut s, 240);
    assert_eq!(s.owned_altars(1), 1);
    assert_eq!(s.stats(blue).damage, base);
    assert!(s.snapshot().map10.unwrap().revealed_by_altar.is_empty());
}
#[test]
fn native_unit_kill_bonus_is_granted_once_and_enemy_presence_is_flagged() {
    let mut s = game();
    let blue = s.join("garen").unwrap();
    let red = s.join("ahri").unwrap();
    s.interactions.as_mut().unwrap().state.altars[0].owner = Some(0);
    s.players.get_mut(&red).unwrap().position = config().altars[0].position;
    s.advance();
    assert!(s.snapshot().map10.unwrap().revealed_by_altar.contains(&red));
    s.tick = 2249;
    s.advance();
    let victim = s
        .units
        .values()
        .find(|u| u.team == 1 && u.kind.lane())
        .unwrap()
        .id;
    let before_kill = s.players[&blue].gold;
    s.hit(blue, victim, 100000., false);
    assert!((s.players[&blue].gold - before_kill - 21.8).abs() < 0.001);
    s.hit(blue, victim, 100000., false);
    assert!((s.players[&blue].gold - before_kill - 21.8).abs() < 0.001);
}
