use super::*;
fn game() -> Simulation {
    let nav = Navigation::load(
        include_str!("../../../assets/maps/tt_navigation_grid.json"),
        include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin"),
    )
    .unwrap();
    let mut s = Simulation::new(nav).unwrap();
    s.enable_map10().unwrap();
    s
}
fn advance(s: &mut Simulation, count: u64) {
    for _ in 0..count {
        s.advance();
    }
}
fn named(s: &Simulation, name: &str) -> u32 {
    s.units.values().find(|u| u.name == name).unwrap().id
}
#[test]
fn native_first_wave_uses_75_seconds_and_staggered_three_melee_three_casters() {
    let mut s = game();
    assert_eq!(s.units.len(), 18);
    s.tick = 75 * TICK_RATE - 2;
    s.advance();
    assert!(!s.units.values().any(|u| u.kind.lane()));
    s.advance();
    assert_eq!(
        s.units.values().filter(|u| u.kind == Kind::Melee).count(),
        4
    );
    advance(&mut s, 119);
    assert_eq!(s.units.values().filter(|u| u.kind.lane()).count(), 20);
    s.advance();
    assert_eq!(
        s.units.values().filter(|u| u.kind == Kind::Melee).count(),
        12
    );
    assert_eq!(
        s.units.values().filter(|u| u.kind == Kind::Caster).count(),
        12
    );
}
#[test]
fn third_wave_adds_native_cannon_and_lane_upgrades() {
    let mut s = game();
    s.tick = 135 * TICK_RATE - 1;
    let w = s.world.as_mut().unwrap();
    w.wave = 3;
    w.next_slot = 135 * TICK_RATE;
    advance(&mut s, 145);
    assert_eq!(
        s.units.values().filter(|u| u.kind == Kind::Siege).count(),
        4
    );
    let melee = s.units.values().find(|u| u.kind == Kind::Melee).unwrap();
    assert_eq!(melee.max_health, 465.);
    assert_eq!(melee.damage, 12.5);
    assert!((melee.gold - 19.).abs() < 0.001);
    assert_eq!(melee.experience, 64.);
}
#[test]
fn structure_dependencies_prevent_early_nexus_damage_and_end_match_after_chain() {
    let mut s = game();
    let blue = s.join("garen").unwrap();
    let purple = s.join("garen").unwrap();
    let nexus = named(&s, "HQ_T1");
    let start = s.units[&nexus].health;
    s.hit(purple, nexus, 1000000., false);
    assert_eq!(s.units[&nexus].health, start);
    assert!(s.protected(nexus));
    let inner = named(&s, "Turret_T1_L_02");
    let inhib_tower = named(&s, "Turret_T1_C_06");
    let inhib = named(&s, "Barracks_T1_L1");
    let nexus_tower = named(&s, "Turret_T1_C_01");
    assert!(s.command(blue, Action::Attack { target: inner }).is_err());
    assert!(s
        .command(
            purple,
            Action::Attack {
                target: inhib_tower
            }
        )
        .unwrap_err()
        .contains("protected"));
    for id in [inner, inhib_tower, inhib, nexus_tower, nexus] {
        assert!(!s.protected(id));
        s.hit(purple, id, 1000000., false);
        assert_eq!(s.units[&id].health, 0.);
    }
    assert_eq!(s.winner, Some(1));
    assert!(s.command(purple, Action::Stop).is_err());
    let tick = s.tick;
    s.advance();
    assert_eq!(s.tick, tick);
}
#[test]
fn inhibitor_respawn_restores_protection_and_super_minions_are_wave_scoped() {
    let mut s = game();
    let a = s.join("garen").unwrap();
    let inner = named(&s, "Turret_T2_L_02");
    let tower = named(&s, "Turret_T2_L_01");
    let inhib = named(&s, "Barracks_T2_L1");
    for id in [inner, tower, inhib] {
        s.hit(a, id, 1000000., false);
    }
    s.tick = 75 * TICK_RATE - 1;
    s.advance();
    assert_eq!(
        s.units
            .values()
            .filter(|u| u.team == 0 && u.kind == Kind::Super)
            .count(),
        1
    );
    let respawn = s.units[&inhib].respawn_at.unwrap();
    s.tick = respawn - 1;
    s.advance();
    assert_eq!(s.units[&inhib].health, s.units[&inhib].max_health);
    assert!(s.protected(named(&s, "Turret_T2_C_01")));
}
#[test]
fn lane_last_hit_gold_and_native_xp_are_granted_once_and_shared_in_native_radius() {
    let mut s = game();
    let a = s.join("garen").unwrap();
    s.join("ahri").unwrap();
    let ally = s.join("garen").unwrap();
    let point = s.players[&a].position;
    let victim = s
        .spawn_unit(
            "Red_Minion_Basic",
            "xp_test",
            1,
            point,
            0.,
            0.,
            None,
            Some(0),
        )
        .unwrap();
    s.hit(a, victim, 100000., false);
    assert!((s.players[&a].gold - shop::starting_gold() - 18.8).abs() < 0.001);
    assert_eq!(s.players[&a].experience, 32.);
    assert_eq!(s.players[&ally].experience, 32.);
    s.hit(a, victim, 100000., false);
    assert_eq!(s.players[&a].experience, 32.);
    assert!((s.players[&a].gold - shop::starting_gold() - 18.8).abs() < 0.001);
}
#[test]
fn monster_kill_xp_is_exclusive_and_camp_retaliation_is_shared() {
    let mut s = game();
    let a = s.join("garen").unwrap();
    s.join("ahri").unwrap();
    let ally = s.join("garen").unwrap();
    s.tick = 100 * TICK_RATE - 1;
    s.advance();
    let ids = s
        .world
        .as_ref()
        .unwrap()
        .camps
        .iter()
        .find(|c| c.config.index == 1)
        .unwrap()
        .members
        .clone();
    let victim = ids[0];
    let before_kill = s.players[&a].gold;
    s.hit(a, victim, 10., false);
    assert!(ids.iter().all(|id| s.units[id].target == Some(a)));
    s.hit(a, victim, 100000., false);
    assert_eq!(s.players[&a].experience, 120.);
    assert_eq!(s.players[&ally].experience, 0.);
    assert_eq!(s.players[&a].gold, before_kill + 33.);
}
#[test]
fn camps_respawn_only_after_all_monsters_die() {
    let mut s = game();
    let a = s.join("garen").unwrap();
    s.tick = 100 * TICK_RATE - 1;
    s.advance();
    let ids = s.world.as_ref().unwrap().camps[0].members.clone();
    s.hit(a, ids[0], 100000., false);
    s.advance();
    assert!(s.world.as_ref().unwrap().camps[0].spawn_at.is_none());
    for id in &ids[1..] {
        s.hit(a, *id, 100000., false);
    }
    s.advance();
    let next = s.world.as_ref().unwrap().camps[0].spawn_at.unwrap();
    s.tick = next - 2;
    s.advance();
    assert!(s.world.as_ref().unwrap().camps[0]
        .members
        .iter()
        .all(|id| s.units.get(id).is_none_or(|u| u.health == 0.)));
    s.advance();
    let fresh = &s.world.as_ref().unwrap().camps[0].members;
    assert_eq!(fresh.len(), 3);
    assert!(fresh
        .iter()
        .all(|id| !ids.contains(id) && s.units[id].health > 0.));
}
#[test]
fn judgment_reduces_lane_minion_damage_and_ultimate_rejects_monsters() {
    let mut s = game();
    let a = s.join("garen").unwrap();
    s.command(a, Action::Learn { slot: 2 }).unwrap();
    let point = s.players[&a].position;
    let minion = s
        .spawn_unit(
            "Red_Minion_Basic",
            "spin_minion",
            1,
            point,
            0.,
            0.,
            None,
            Some(0),
        )
        .unwrap();
    let monster = s
        .spawn_unit("TT_NWraith", "spin_monster", 2, point, 0., 0., None, None)
        .unwrap();
    let mh = s.units[&minion].health;
    let wh = s.units[&monster].health;
    let raw = 10. + 0.35 * s.stats(a).damage;
    s.command(
        a,
        Action::Cast {
            slot: 2,
            target: None,
        },
    )
    .unwrap();
    advance(&mut s, 15);
    assert!((mh - s.units[&minion].health - raw * 0.75).abs() < 0.02);
    assert!((wh - s.units[&monster].health - raw * 100. / 115.).abs() < 0.02);
    s.tick = 1000;
    s.award_experience(a, 2525.).unwrap();
    s.command(a, Action::Learn { slot: 3 }).unwrap();
    assert!(s
        .command(
            a,
            Action::Cast {
                slot: 3,
                target: Some(monster)
            }
        )
        .is_err());
}
