//! Controlled simulation fixtures, not native server behavior or runtime proof.
use super::*;
use crate::attack_presentation::{Attack, Audience, CancelReason, Event, Kind as AttackKind, Phase};

fn game(champion: &str) -> (Simulation, u32, u32) {
    let mut cells = Vec::new();
    for _ in 0..400 {
        cells.extend_from_slice(&0_f32.to_le_bytes()); cells.extend_from_slice(&0_u16.to_le_bytes());
        cells.extend_from_slice(&0_u32.to_le_bytes()); cells.push(1);
    }
    let navigation = Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#, &cells).unwrap();
    let mut s = Simulation::new(navigation).unwrap();
    s.session = 830;
    s.enable_map10().unwrap();
    s.units.clear();
    let world = s.world.as_mut().unwrap();
    world.camps.clear(); world.next_slot = u64::MAX;
    let player = s.join(champion).unwrap();
    let p = s.players.get_mut(&player).unwrap();
    p.position = Point { x: 500., z: 100. }; p.health = 5000.;
    let boss = s.spawn_unit(vilemaw_attacks::DEFINITION, "boss_fixture", 2,
        Point { x: 200., z: 100. }, 0., 0., None, None).unwrap();
    let unit = s.units.get_mut(&boss).unwrap();
    unit.target = Some(player); unit.next_ai = u64::MAX;
    s.tick = 10;
    (s, boss, player)
}
fn begin(s: &mut Simulation, boss: u32) -> Attack {
    s.advance_npc_ai();
    s.snapshot().units.iter().find(|unit| unit.id == boss).unwrap().attack_presentation.unwrap()
}
fn events(s: &Simulation, attack: Attack) -> Vec<Event> {
    s.snapshot().vilemaw_attack_events.into_iter().filter(|event| event.attack == attack).collect()
}
fn terminal(s: &Simulation, attack: Attack, phase: Phase) {
    let terminal: Vec<_> = events(s, attack).into_iter().filter(|event| !matches!(event.phase, Phase::Started { .. })).collect();
    assert_eq!(terminal.len(), 1);
    assert_eq!(terminal[0].phase, phase);
    assert!(s.vilemaw_attacks.active(attack.source).is_none());
    assert!(s.vilemaw_attacks.error().is_none());
}
fn resolved(s: &Simulation, attack: Attack, success: bool) {
    terminal(s, attack, Phase::Resolved { kind: AttackKind::Basic, hit_succeeded: success });
}

#[test]
fn vilemaw_existing_attack_keeps_46_30_100_and_records_result_once() {
    let (mut s, boss, target) = game("garen");
    let definition = &s.world.as_ref().unwrap().config.definitions[vilemaw_attacks::DEFINITION];
    assert_eq!((definition.attack_cooldown, definition.attack_windup, definition.damage, definition.projectile_speed), (46, 30, 100., 0.));
    let initial = s.players[&target].health;
    let expected = damage::mitigate(100., damage::DamageKind::Physical, s.stats(target).armor, s.stats(target).magic_resist, 1.).unwrap();
    let attack = begin(&mut s, boss);
    assert_eq!((attack.started, attack.release, s.units[&boss].next_attack), (10, 40, 56));
    assert_eq!(events(&s, attack)[0].phase, Phase::Started { kind: AttackKind::Basic });
    s.tick = 39; s.advance_npc_ai(); assert_eq!(s.players[&target].health, initial);
    s.tick = 40; s.advance_npc_ai(); resolved(&s, attack, true);
    assert!((initial - s.players[&target].health - expected).abs() < 0.001);
    let health = s.players[&target].health;
    s.advance_npc_ai(); resolved(&s, attack, true); assert_eq!(s.players[&target].health, health);
    s.tick = 56; let next = begin(&mut s, boss); assert!(next.id > attack.id);
    assert_eq!((next.started, next.release), (56, 86));
    assert!(s.snapshot().attack_events.is_empty());
}

#[test]
fn vilemaw_target_change_and_leave_do_not_cancel_the_captured_pending_target() {
    let (mut s, boss, old) = game("garen");
    let other = s.join("garen").unwrap();
    s.players.get_mut(&other).unwrap().position = Point { x: 550., z: 100. };
    let old_health = s.players[&old].health; let other_health = s.players[&other].health;
    let attack = begin(&mut s, boss);
    s.units.get_mut(&boss).unwrap().target = Some(other);
    s.tick = 20; s.advance_npc_ai(); assert_eq!(events(&s, attack).len(), 1);
    s.tick = attack.release; s.advance_npc_ai(); resolved(&s, attack, true);
    assert!(s.players[&old].health < old_health); assert_eq!(s.players[&other].health, other_health);
    let (mut s, boss, target) = game("garen"); let attack = begin(&mut s, boss);
    s.remove_player(target).unwrap(); assert_eq!(events(&s, attack).len(), 1);
    s.tick = attack.release - 1; s.advance_npc_ai(); assert_eq!(events(&s, attack).len(), 1);
    s.tick = attack.release; s.advance_npc_ai(); resolved(&s, attack, false);
}

#[test]
fn vilemaw_invalid_damage_and_zero_damage_preserve_real_result_meaning() {
    for (raw, success) in [(f32::NAN, false), (0., true)] {
        let (mut s, boss, target) = game("garen");
        s.units.get_mut(&boss).unwrap().damage = raw; // Explicit fault/zero fixture.
        let health = s.players[&target].health;
        let attack = begin(&mut s, boss); s.tick = attack.release; s.advance_npc_ai();
        resolved(&s, attack, success); assert_eq!(s.players[&target].health, health);
    }
}

#[test]
fn vilemaw_death_while_pending_vector_is_detached_cancels_exactly_once() {
    let (mut s, boss, target) = game("garen"); let attack = begin(&mut s, boss);
    let killer = s.spawn_unit("TT_NWraith2", "killer_fixture", 0, Point { x: 210., z: 100. }, 0., 0., None, None).unwrap();
    s.units.get_mut(&killer).unwrap().next_ai = u64::MAX;
    s.units.get_mut(&killer).unwrap().next_attack = u64::MAX;
    // A real hit processed before the boss's Pending, inside the detached Vec.
    s.world.as_mut().unwrap().attacks.insert(0, Pending { source: killer, target: boss,
        damage: 100_000., resolves: attack.release, releases: attack.release, ranged: false, launched: false, presentation: None });
    let health = s.players[&target].health;
    s.tick = attack.release; s.advance_npc_ai();
    assert_eq!(s.units[&boss].health, 0.); assert_eq!(s.players[&target].health, health);
    terminal(&s, attack, Phase::Cancelled { reason: CancelReason::Death });
    s.interrupt_unit_windup(boss); s.advance_npc_ai();
    terminal(&s, attack, Phase::Cancelled { reason: CancelReason::Death });
    assert!(!s.world.as_ref().unwrap().attacks.iter().any(|pending| pending.source == boss));
}

#[test]
fn vilemaw_lethal_molten_retaliation_keeps_the_applied_hit_resolution() {
    let (mut s, boss, annie) = game("annie");
    let p = s.players.get_mut(&annie).unwrap(); p.level = 2; p.ranks[2] = 1; p.mana = 100.;
    s.cast(annie, 2, None).unwrap();
    s.units.get_mut(&boss).unwrap().health = 1.;
    let health = s.players[&annie].health;
    let attack = begin(&mut s, boss); s.tick = attack.release; s.advance_npc_ai();
    assert!(s.players[&annie].health < health); assert_eq!(s.units[&boss].health, 0.);
    resolved(&s, attack, true);
    assert!(!events(&s, attack).iter().any(|event| matches!(event.phase, Phase::Cancelled { .. })));
    s.interrupt_unit_windup(boss); resolved(&s, attack, true);
}

#[test]
fn vilemaw_match_end_during_hit_resolves_current_but_retires_waiting_attack() {
    let (mut s, boss, _) = game("garen");
    let key = s.world.as_ref().unwrap().config.definitions.iter().find(|(_, def)| def.kind == Kind::Nexus).unwrap().0.clone();
    let nexus = s.spawn_unit(&key, "nexus_fixture", 0, Point { x: 250., z: 100. }, 0., 0., None, None).unwrap();
    s.units.get_mut(&nexus).unwrap().health = 1.;
    s.units.get_mut(&boss).unwrap().target = Some(nexus);
    let attack = begin(&mut s, boss); s.tick = attack.release; s.advance_npc_ai();
    assert_eq!(s.winner, Some(1)); assert_eq!(s.units[&nexus].health, 0.);
    assert_eq!(s.units[&boss].damage, 100.); assert_eq!(s.units[&boss].next_attack, 56);
    assert!(s.final_results().is_some()); resolved(&s, attack, true);
    assert!(!events(&s, attack).iter().any(|event| matches!(event.phase, Phase::Cancelled { .. })));
    s.advance(); resolved(&s, attack, true);
    let (mut s, boss, _) = game("garen"); let waiting = begin(&mut s, boss);
    s.winner = Some(0); s.advance();
    terminal(&s, waiting, Phase::Cancelled { reason: CancelReason::MatchEnded });
    assert_eq!(s.units[&boss].next_attack, 56);
}

#[test]
fn vilemaw_stun_refusal_is_unchanged_and_injected_removal_is_not_a_gameplay_claim() {
    let (mut s, boss, player) = game("garen"); let attack = begin(&mut s, boss);
    assert_eq!(s.grant_stun(Some(player), boss, "fixture", 30).unwrap_err(), "boss stun policy not qualified");
    assert_eq!(events(&s, attack).len(), 1);
    // Only an internal invalid/controlled-state fixture reaches this branch.
    s.units.get_mut(&boss).unwrap().stuns.push(stuns::Stun { tag: "injected".into(), source: Some(player), expires_at: 100 });
    s.tick = 11; s.advance_npc_ai();
    terminal(&s, attack, Phase::Cancelled { reason: CancelReason::Control });
    s.advance_npc_ai(); terminal(&s, attack, Phase::Cancelled { reason: CancelReason::Control });
}

#[test]
fn vilemaw_capacity_diagnostic_does_not_change_two_boss_combat_or_garen_six() {
    let (mut s, boss, target) = game("garen");
    let second = s.spawn_unit(vilemaw_attacks::DEFINITION, "unexpected_second_boss", 2,
        Point { x: 250., z: 100. }, 0., 0., None, None).unwrap();
    let unit = s.units.get_mut(&second).unwrap(); unit.target = Some(target); unit.next_ai = u64::MAX;
    for _ in 1..6 { s.join("garen").unwrap(); }
    let players: Vec<_> = s.players.keys().copied().collect();
    for (index, id) in players.iter().copied().enumerate() {
        let p = s.players.get_mut(&id).unwrap(); p.position = Point { x: 220., z: 100. };
        // The six-source bank is exercised directly; no attack timing is inferred.
        s.attack_presentation.begin(id, 10, 100, AttackKind::Basic, Audience::from_visibility(true, true)).unwrap();
        assert_eq!(s.attack_presentation.active_len(), index + 1);
    }
    let health = s.players[&target].health;
    let expected = damage::mitigate(100., damage::DamageKind::Physical, s.stats(target).armor, s.stats(target).magic_resist, 1.).unwrap();
    s.advance_npc_ai();
    assert!(s.vilemaw_attacks.error().unwrap().contains("ActiveLimit"));
    let first = s.snapshot().vilemaw_attack_events[0].attack;
    assert_eq!(first.source, boss); assert_eq!(s.snapshot().attack_events.len(), 6);
    assert!(s.snapshot().units.iter().all(|unit| unit.attack_presentation.is_none()));
    s.tick = 40; s.advance_npc_ai();
    assert!((health - s.players[&target].health - 2. * expected).abs() < 0.002);
    assert!(s.vilemaw_attacks.active(boss).is_none());
    assert!(s.snapshot().vilemaw_attack_events.iter().any(|event| event.attack == first && matches!(event.phase, Phase::Resolved { hit_succeeded: true, .. })));
    assert!(s.attack_presentation_error.is_none());
}

#[test]
fn vilemaw_filtered_identity_requires_historical_source_and_target_visibility() {
    let (mut s, boss, target) = game("garen");
    let viewer = s.join("garen").unwrap();
    s.players.get_mut(&viewer).unwrap().position = Point { x: 250., z: 100. };
    s.players.get_mut(&viewer).unwrap().vision_radius_modifiers = vision::RadiusModifiers { percent_bubble_radius_mod: -1., flat_bubble_radius_mod: 75. };
    assert!(s.interactions.is_some()); assert!(s.visible_to(1, boss)); assert!(!s.visible_to(1, target));
    let attack = begin(&mut s, boss);
    let view = s.snapshot_for(viewer).unwrap();
    assert!(view.vilemaw_attack_events.is_empty());
    assert!(view.units.iter().find(|unit| unit.id == boss).unwrap().attack_presentation.is_none());
    s.players.get_mut(&viewer).unwrap().vision_radius_modifiers = Default::default();
    assert!(s.visible_to(1, target)); assert!(s.snapshot_for(viewer).unwrap().vilemaw_attack_events.is_empty());
    s.tick = attack.release; s.advance_npc_ai();
    let view = s.snapshot_for(viewer).unwrap(); assert_eq!(view.vilemaw_attack_events.len(), 1);
    assert!(matches!(view.vilemaw_attack_events[0].phase, Phase::Resolved { hit_succeeded: true, .. }));
    let json = serde_json::to_value(&view.vilemaw_attack_events[0]).unwrap();
    assert!(json["attack"].get("target").is_none());
    s.players.get_mut(&viewer).unwrap().position = Point { x: 950., z: 950. };
    s.players.get_mut(&viewer).unwrap().vision_radius_modifiers = vision::RadiusModifiers { percent_bubble_radius_mod: -1., flat_bubble_radius_mod: 1. };
    assert!(!s.visible_to(1, boss)); assert!(s.snapshot_for(viewer).unwrap().vilemaw_attack_events.is_empty());
}

#[test]
fn vilemaw_lethal_hit_preserves_audience_before_target_vision_disappears() {
    let (mut s, boss, target) = game("garen");
    s.players.get_mut(&target).unwrap().health = 1.;
    assert!(s.visible_to(0, boss));
    let attack = begin(&mut s, boss);
    s.tick = attack.release; s.advance_npc_ai();
    assert_eq!(s.players[&target].health, 0.); resolved(&s, attack, true);
    assert!(!s.visible_to(0, boss));
    assert!(s.snapshot_for(target).unwrap().vilemaw_attack_events.is_empty());
    // A fresh teammate restores current visibility. Historical permission for
    // the impact must have been captured before its target lost vision on death.
    let opposing = s.join("garen").unwrap(); assert_eq!(s.players[&opposing].team, 1);
    let allied = s.join("garen").unwrap(); assert_eq!(s.players[&allied].team, 0);
    s.players.get_mut(&allied).unwrap().position = Point { x: 210., z: 100. };
    assert!(s.visible_to(0, boss));
    let restored = s.snapshot_for(target).unwrap();
    assert!(restored.vilemaw_attack_events.iter().any(|event| event.attack == attack &&
        matches!(event.phase, Phase::Resolved { hit_succeeded: true, .. })));
}

#[test]
fn vilemaw_camp_respawn_creates_new_unit_and_monotone_attack_identity() {
    let navigation = Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"), include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let mut s = Simulation::new(navigation).unwrap(); s.enable_map10().unwrap();
    let player = s.join("garen").unwrap();
    s.tick = 600 * TICK_RATE; s.advance_world();
    let boss = s.units.values().find(|unit| vilemaw_attacks::is_vilemaw(unit)).unwrap().id;
    let position = s.units[&boss].position;
    s.players.get_mut(&player).unwrap().position = position;
    s.units.get_mut(&boss).unwrap().target = Some(player);
    let attack = begin(&mut s, boss);
    s.apply_damage(Some(player), boss, 100_000., damage::DamageKind::True).unwrap();
    terminal(&s, attack, Phase::Cancelled { reason: CancelReason::Death });
    s.tick += 1; s.advance_world();
    let spawn_at = s.world.as_ref().unwrap().camps.iter().find(|camp| camp.config.index == 8).unwrap().spawn_at.unwrap();
    assert_eq!(spawn_at, s.tick + 300 * TICK_RATE);
    s.tick += 3 * TICK_RATE; s.advance_world(); assert!(!s.units.contains_key(&boss));
    s.tick = spawn_at; s.advance_world();
    let new = s.units.values().find(|unit| vilemaw_attacks::is_vilemaw(unit)).unwrap().id;
    assert_ne!(new, boss); assert!(s.snapshot().units.iter().find(|unit| unit.id == new).unwrap().attack_presentation.is_none());
    s.players.get_mut(&player).unwrap().health = 5000.;
    s.players.get_mut(&player).unwrap().position = s.units[&new].position;
    s.units.get_mut(&new).unwrap().target = Some(player);
    let fresh = begin(&mut s, new); assert!(fresh.id > attack.id);
}
