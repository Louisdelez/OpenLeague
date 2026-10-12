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
#[test]
fn relic_waits_selects_nearest_and_is_consumed_once() {
    let mut s = game();
    let a = s.join("ahri").unwrap();
    let b = s.join("garen").unwrap();
    for id in [a, b] {
        let p = s.players.get_mut(&id).unwrap();
        p.position = config().relic_position;
        p.health = 100.;
        p.mana = 0.;
    }
    s.players.get_mut(&b).unwrap().position.x += 100.;
    s.tick = 5398;
    s.advance();
    assert!(s.snapshot().map10.unwrap().relic_pickup_tick.is_none());
    s.advance();
    let state = s.snapshot().map10.unwrap();
    assert_eq!(state.relic_last_picker, Some(a));
    assert_eq!(state.relic_ready_tick, 8100);
    assert!(
        (s.players[&a].health
            - (194.
                + s.regeneration_rates(a).unwrap().health_per_second * (s.tick - 5398) as f32
                    / 30.))
            .abs()
            < 0.001
    );
    assert!(
        (s.players[&a].mana
            - (90. + s.regeneration_rates(a).unwrap().resource_per_second * 2. / 30.))
            .abs()
            < 0.001
    );
    assert!(
        (s.players[&b].health
            - (100.
                + (s.regeneration_rates(b).unwrap().health_per_second
                    + s.garen_passive_per_second(b))
                    * (if s.tick == 5400 { 2. } else { 1. })
                    / 30.))
            .abs()
            < 0.001
    );
    s.advance();
    assert!(
        (s.players[&a].health
            - (194.
                + s.regeneration_rates(a).unwrap().health_per_second * (s.tick - 5398) as f32
                    / 30.))
            .abs()
            < 0.001
    );
}
#[test]
fn relic_clamps_restore_ignores_dead_and_fury_and_respawns() {
    let mut s = game();
    let dead = s.join("ahri").unwrap();
    let live = s.join("tryndamere").unwrap();
    let p = s.players.get_mut(&dead).unwrap();
    p.position = config().relic_position;
    p.health = 0.;
    let p = s.players.get_mut(&live).unwrap();
    p.position = config().relic_position;
    p.health = p.max_health - 1.;
    p.mana = 0.;
    s.tick = 5399;
    s.advance();
    assert_eq!(s.snapshot().map10.unwrap().relic_last_picker, Some(live));
    assert_eq!(s.players[&live].health, s.players[&live].max_health);
    assert_eq!(s.players[&live].mana, 0.);
    s.players.get_mut(&live).unwrap().position.x += 1000.;
    s.tick = 8099;
    s.advance();
    assert!(s.snapshot().map10.unwrap().relic_available);
}
#[test]
fn haste_decays_expires_and_death_removes_it() {
    let mut s = game();
    let id = s.join("garen").unwrap();
    let p = s.players.get_mut(&id).unwrap();
    p.effects.relic_haste_started = 100;
    p.effects.relic_haste_until = 250;
    assert!((relic_haste(p, 100) - 0.2).abs() < 0.00001);
    assert!((relic_haste(p, 175) - 0.1).abs() < 0.00001);
    assert_eq!(relic_haste(p, 250), 0.);
    s.damage(id, 100000., false);
    assert_eq!(relic_haste(&s.players[&id], 100), 0.);
}
#[test]
fn fountain_only_heals_living_allies_without_overheal() {
    let mut s = game();
    let a = s.join("ahri").unwrap();
    let b = s.join("tryndamere").unwrap();
    let dead = s.join("garen").unwrap();
    let pos = s.players[&a].position;
    for id in [a, b, dead] {
        let p = s.players.get_mut(&id).unwrap();
        p.position = pos;
        p.health = 100.;
        p.mana = 0.;
    }
    s.players.get_mut(&dead).unwrap().health = 0.;
    s.tick = 29;
    s.advance();
    assert!(
        (s.players[&a].health
            - (100.
                + s.players[&a].max_health * 0.15
                + s.regeneration_rates(a).unwrap().health_per_second / 30.))
            .abs()
            < 0.001
    );
    assert!(
        (s.players[&a].mana
            - s.stats(a).max_mana * 0.15
            - s.regeneration_rates(a).unwrap().resource_per_second / 30.)
            .abs()
            < 0.001
    );
    assert!(
        (s.players[&b].health
            - (100.
                + (s.regeneration_rates(b).unwrap().health_per_second
                    + s.garen_passive_per_second(b))
                    * (if s.tick == 5400 { 2. } else { 1. })
                    / 30.))
            .abs()
            < 0.001
    );
    assert_eq!(s.players[&dead].health, 0.);
    let max = s.players[&a].max_health;
    s.players.get_mut(&a).unwrap().health = max - 0.1;
    s.tick = 59;
    s.advance();
    assert_eq!(s.players[&a].health, max);
}
