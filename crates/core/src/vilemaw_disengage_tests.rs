//! Synthetic simulation fixtures for a declared local reset policy, not Riot AI evidence.
use super::*;
use crate::attack_presentation::{Attack, Phase};

fn game() -> (Simulation, u32, u32) {
    let mut bytes = Vec::new();
    for _ in 0..6000 {
        bytes.extend_from_slice(&0_f32.to_le_bytes());
        bytes.extend_from_slice(&0_u16.to_le_bytes());
        bytes.extend_from_slice(&0_u32.to_le_bytes()); bytes.push(1);
    }
    let navigation = Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":100,"height":60}"#, &bytes).unwrap();
    let mut s = Simulation::new(navigation).unwrap();
    s.enable_map10().unwrap(); s.units.clear();
    let world = s.world.as_mut().unwrap(); world.camps.clear(); world.next_slot = u64::MAX;
    let player = s.join("garen").unwrap();
    let p = s.players.get_mut(&player).unwrap(); p.position = Point { x: 2200., z: 1500. }; p.health = 5000.;
    let boss = s.spawn_unit(vilemaw_attacks::DEFINITION, "camp_fixture", 2,
        Point { x: 2000., z: 1500. }, 0., 0., Some(8), None).unwrap();
    s.tick = 10; (s, boss, player)
}
fn provoke(s: &mut Simulation, player: u32, boss: u32) {
    s.hit_result(player, boss, 1., false).unwrap();
    assert_eq!(s.units[&boss].target, Some(player));
}
fn active(s: &Simulation, boss: u32) -> Attack { s.vilemaw_attacks.active(boss).unwrap() }
fn terminal(s: &Simulation, attack: Attack) -> Vec<Phase> {
    s.snapshot().vilemaw_attack_events.into_iter().filter(|event| event.attack == attack)
        .map(|event| event.phase).filter(|phase| !matches!(phase, Phase::Started { .. })).collect()
}
fn outside(s: &mut Simulation, player: u32) { s.players.get_mut(&player).unwrap().position.x = 3600.; }
fn finish_old_attack(s: &mut Simulation) {
    for tick in [18, 26, 34, 40, 42] { s.tick = tick; s.advance_npc_ai(); }
}

#[test]
fn living_target_outside_range_resolves_committed_hit_then_resets_at_ai_poll() {
    let (mut s, boss, player) = game(); provoke(&mut s, player, boss); s.advance_npc_ai();
    let attack = active(&s, boss); let health = s.players[&player].health;
    assert_eq!((attack.release, s.units[&boss].next_attack, s.units[&boss].next_ai), (40, 56, 18));
    assert!(s.units[&boss].health < s.units[&boss].max_health);
    outside(&mut s, player); s.tick = 17; s.advance_npc_ai();
    assert_eq!(s.units[&boss].target, Some(player)); // Existing 8-tick observation cadence.
    s.tick = 18; s.advance_npc_ai();
    assert_eq!(s.units[&boss].target, Some(player)); assert!(terminal(&s, attack).is_empty());
    assert!(s.units[&boss].health < s.units[&boss].max_health);
    for tick in [26, 34] { s.tick = tick; s.advance_npc_ai(); }
    s.tick = 40; s.advance_npc_ai();
    assert!(s.players[&player].health < health); assert!(s.players[&player].health > 0.);
    assert_eq!(s.units[&boss].target, Some(player)); // Next IA poll is 42.
    assert_eq!(terminal(&s, attack), vec![Phase::Resolved { kind: attack_presentation::Kind::Basic, hit_succeeded: true }]);
    let after_committed_hit = s.players[&player].health;
    s.tick = 42; s.advance_npc_ai();
    assert_eq!(s.units[&boss].target, None); assert_eq!(s.units[&boss].health, s.units[&boss].max_health);
    assert!(s.units[&boss].destination.is_none()); assert!(s.units[&boss].path.is_empty());
    assert_eq!(s.units[&boss].next_attack, 56);
    assert!(!s.world.as_ref().unwrap().attacks.iter().any(|pending| pending.source == boss));
    s.tick = 80; s.advance_npc_ai();
    assert_eq!(s.players[&player].health, after_committed_hit);
    assert_eq!(terminal(&s, attack).len(), 1);
}

#[test]
fn range_boundary_is_inclusive_and_uses_target_radius_not_boss_radius() {
    let (mut s, boss, player) = game();
    let radius = s.target_info(player).unwrap().radius;
    assert_ne!(radius, s.target_info(boss).unwrap().radius);
    s.players.get_mut(&player).unwrap().position.x = 2000. + 1200. + radius;
    s.units.get_mut(&boss).unwrap().next_attack = u64::MAX; // Observe retention without a committed hit.
    provoke(&mut s, player, boss); s.advance_npc_ai();
    assert_eq!(s.units[&boss].target, Some(player));
    s.players.get_mut(&player).unwrap().position.x += 1.; s.tick = 18; s.advance_npc_ai();
    assert_eq!(s.units[&boss].target, None);
    assert!(s.world.as_ref().unwrap().attacks.is_empty());
}

#[test]
fn proximity_does_not_reacquire_but_another_real_provocation_starts_new_identity() {
    let (mut s, boss, first) = game(); let second = s.join("garen").unwrap();
    s.players.get_mut(&second).unwrap().position = Point { x: 2300., z: 1500. };
    provoke(&mut s, first, boss); s.advance_npc_ai(); let old = active(&s, boss);
    outside(&mut s, first); finish_old_attack(&mut s);
    s.tick = 56; s.advance_npc_ai(); assert_eq!(s.units[&boss].target, None);
    assert!(s.vilemaw_attacks.active(boss).is_none());
    let first_health = s.players[&first].health; let second_health = s.players[&second].health;
    provoke(&mut s, second, boss); s.advance_npc_ai(); let new = active(&s, boss);
    assert!(new.id > old.id); assert_eq!((new.started, new.release), (56, 86));
    let boss_health = s.units[&boss].health;
    s.tick = 86; s.advance_npc_ai();
    assert_eq!(s.units[&boss].health, boss_health); // No reset while engaged in range.
    assert!(s.players[&second].health < second_health); assert_eq!(s.players[&first].health, first_health);
    assert_eq!(terminal(&s, new), vec![Phase::Resolved { kind: attack_presentation::Kind::Basic, hit_succeeded: true }]);
}

#[test]
fn dead_missing_or_allied_current_target_preserves_pending_result_then_resets() {
    for case in 0..3 {
        let (mut s, boss, player) = game(); provoke(&mut s, player, boss); s.advance_npc_ai();
        let attack = active(&s, boss);
        match case { 0 => s.players.get_mut(&player).unwrap().health = 0.,
            1 => { s.remove_player(player).unwrap(); },
            _ => s.players.get_mut(&player).unwrap().team = 2 }
        s.tick = 18; s.advance_npc_ai(); assert!(terminal(&s, attack).is_empty());
        finish_old_attack(&mut s);
        assert_eq!(s.units[&boss].target, None);
        let terminal = terminal(&s, attack); assert_eq!(terminal.len(), 1);
        assert!(matches!(terminal[0], Phase::Resolved { .. }));
        if case < 2 { assert!(matches!(terminal[0], Phase::Resolved { hit_succeeded: false, .. })); }
        assert!(!s.world.as_ref().unwrap().attacks.iter().any(|pending| pending.source == boss));
    }
}

#[test]
fn target_change_in_range_preserves_captured_attack_until_real_resolution() {
    let (mut s, boss, first) = game(); let second = s.join("garen").unwrap();
    s.players.get_mut(&second).unwrap().position = Point { x: 2300., z: 1500. };
    provoke(&mut s, first, boss); s.advance_npc_ai(); let attack = active(&s, boss);
    let before = s.players[&first].health; let other = s.players[&second].health;
    s.tick = 18; provoke(&mut s, second, boss); s.advance_npc_ai();
    assert!(terminal(&s, attack).is_empty());
    s.tick = attack.release; s.advance_npc_ai();
    assert!(s.players[&first].health < before); assert_eq!(s.players[&second].health, other);
    assert_eq!(terminal(&s, attack), vec![Phase::Resolved { kind: attack_presentation::Kind::Basic, hit_succeeded: true }]);
}

#[test]
fn presentation_capacity_failure_does_not_prevent_gameplay_reset() {
    let (mut s, boss, player) = game();
    let other = s.spawn_unit(vilemaw_attacks::DEFINITION, "capacity_fixture", 2,
        Point { x: 2100., z: 1500. }, 0., 0., Some(9), None).unwrap();
    provoke(&mut s, player, boss); provoke(&mut s, player, other); s.advance_npc_ai();
    assert!(s.vilemaw_attacks.error().is_some());
    assert_eq!(s.world.as_ref().unwrap().attacks.len(), 2);
    outside(&mut s, player); let before = s.players[&player].health;
    finish_old_attack(&mut s);
    for id in [boss, other] {
        assert_eq!(s.units[&id].target, None); assert_eq!(s.units[&id].health, s.units[&id].max_health);
    }
    assert!(s.world.as_ref().unwrap().attacks.is_empty()); assert!(s.vilemaw_attacks.error().is_some());
    assert!(s.players[&player].health < before); let after_committed_hits = s.players[&player].health;
    s.tick = 80; s.advance_npc_ai(); assert_eq!(s.players[&player].health, after_committed_hits);
}

#[test]
fn mobile_neutral_and_camp_less_identity_fixture_keep_existing_policy() {
    let (mut s, boss, player) = game(); s.units.get_mut(&boss).unwrap().home = None;
    provoke(&mut s, player, boss); outside(&mut s, player); s.advance_npc_ai();
    assert_eq!(s.units[&boss].target, Some(player));
    let mob = s.spawn_unit("TT_NWraith", "mobile_fixture", 2,
        Point { x: 2000., z: 1500. }, 0., 0., Some(1), None).unwrap();
    provoke(&mut s, player, mob); s.advance_npc_ai();
    assert_eq!(s.units[&mob].target, Some(player)); assert!(s.units[&mob].destination.is_some());
}

#[test]
fn reset_keeps_already_launched_and_other_source_pending_work() {
    let (mut s, boss, player) = game(); let second = s.join("garen").unwrap();
    s.players.get_mut(&second).unwrap().position = Point { x: 2400., z: 1500. };
    let other = s.spawn_unit("TT_NWraith2", "other_attack_fixture", 2,
        Point { x: 2000., z: 1600. }, 0., 0., None, None).unwrap();
    let unit = s.units.get_mut(&other).unwrap(); unit.next_ai = u64::MAX; unit.next_attack = u64::MAX;
    provoke(&mut s, player, boss); s.advance_npc_ai(); let attack = active(&s, boss);
    // Diagnostic launched projectile, not a claim that today's Vilemaw emits one.
    // Its already-owned identity must resolve, never become a cancellation.
    let pending = s.world.as_mut().unwrap().attacks.iter_mut().find(|value| value.source == boss).unwrap();
    pending.ranged = true; pending.launched = true;
    s.world.as_mut().unwrap().attacks.push(Pending { source: other, target: second,
        damage: 11., resolves: 100, releases: 100, ranged: false, launched: false, presentation: None });
    outside(&mut s, player); s.tick = 18; s.advance_npc_ai();
    let pending = &s.world.as_ref().unwrap().attacks;
    assert_eq!(pending.len(), 2);
    assert!(pending.iter().any(|value| value.source == boss && value.launched));
    assert!(pending.iter().any(|value| value.source == other));
    assert!(terminal(&s, attack).is_empty());
    let health = (s.players[&player].health, s.players[&second].health);
    finish_old_attack(&mut s);
    assert_eq!(s.units[&boss].target, None); assert_eq!(s.units[&boss].health, s.units[&boss].max_health);
    assert_eq!(s.world.as_ref().unwrap().attacks.len(), 1);
    assert_eq!(s.world.as_ref().unwrap().attacks[0].source, other);
    assert_eq!(s.players[&second].health, health.1);
    s.tick = 100; s.advance_npc_ai();
    assert!(s.players[&player].health < health.0); assert!(s.players[&second].health < health.1);
    assert_eq!(terminal(&s, attack), vec![Phase::Resolved { kind: attack_presentation::Kind::Basic, hit_succeeded: true }]);
    assert!(s.world.as_ref().unwrap().attacks.is_empty());
}
