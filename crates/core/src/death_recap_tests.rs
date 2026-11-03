use super::*;
use crate::{Navigation, Point};

fn game() -> (Simulation, u32, u32) {
    let nav = Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),
        include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let mut s = Simulation::new(nav).unwrap();
    s.session = (1_u64 << 53) + 13;
    s.enable_map10().unwrap(); s.units.clear();
    let victim = s.join("garen").unwrap(); let attacker = s.join("annie").unwrap();
    s.players.get_mut(&attacker).unwrap().position = s.players[&victim].position;
    assert!(s.visible_to(s.players[&victim].team, attacker));
    (s, victim, attacker)
}
fn recap(s: &Simulation, victim: u32) -> Recap {
    let snapshot = s.snapshot_for_atomic(victim).unwrap();
    decode_view(snapshot.death_recap.as_ref(), s.session, victim, s.tick).unwrap().unwrap()
}
fn kill(s: &mut Simulation, victim: u32, source: Option<u32>) {
    let result = s.apply_damage(source, victim, 1_000_000., DamageKind::True).unwrap();
    assert!(result.lethal);
}
fn npc(s: &mut Simulation, victim: u32, kind: world::Kind) -> u32 {
    let name = s.world.as_ref().unwrap().config.definitions.iter()
        .find(|(_, d)| d.kind == kind).unwrap().0.clone();
    let p = &s.players[&victim]; let (team, position, height) = (p.team, p.position, p.height);
    s.spawn_unit(&name, "private display name", 1 - team, position, height, 0., None, None).unwrap()
}
fn assert_no_private_fields(value: &serde_json::Value) {
    match value {
        serde_json::Value::Object(object) => {
            for (key, child) in object {
                assert!(!["owner", "source_id", "position", "hit_tick", "hit_count"].contains(&key.as_str()),
                    "private field: {key}");
                assert_no_private_fields(child);
            }
        }
        serde_json::Value::Array(rows) => rows.iter().for_each(assert_no_private_fields),
        _ => {}
    }
}
fn assert_no_hidden_names(value: &serde_json::Value, names: &[&str]) {
    match value {
        serde_json::Value::String(text) => assert!(!names.contains(&text.as_str()), "hidden name: {text}"),
        serde_json::Value::Object(object) => object.values().for_each(|v| assert_no_hidden_names(v, names)),
        serde_json::Value::Array(rows) => rows.iter().for_each(|v| assert_no_hidden_names(v, names)),
        _ => {}
    }
}
#[test]
fn real_npc_attack_shields_mitigation_and_overkill_use_accepted_outcomes() {
    let (mut s, v, _) = game(); let source = npc(&mut s, v, world::Kind::Melee);
    s.grant_shield(v, "fixture", 100., 1000).unwrap();
    let physical = s.basic_attack_hit(source, v, 20.).unwrap();
    assert_eq!(physical.health_removed, 0.); assert!(physical.shield_absorbed > 0.);
    let magical = s.apply_damage(Some(source), v, 200., DamageKind::Magical).unwrap();
    let hp = s.players[&v].health;
    let lethal = s.apply_damage(Some(source), v, 1_000_000., DamageKind::True).unwrap();
    assert_eq!(lethal.health_removed, hp); assert!(lethal.post_mitigation > hp);
    let r = recap(&s, v); assert_eq!(r.rows.len(), 1);
    let row = &r.rows[0]; assert!(matches!(row.source, Source::Unit { kind: world::Kind::Melee, .. }));
    assert_eq!(row.physical, Amount { health_removed: physical.health_removed, shield_absorbed: physical.shield_absorbed });
    assert_eq!(row.magical, Amount { health_removed: magical.health_removed, shield_absorbed: magical.shield_absorbed });
    assert_eq!(row.true_damage.health_removed, hp); assert!(row.lethal); assert!(!r.truncated);
}
#[test]
fn rejected_and_zero_effect_calls_leave_no_journal_but_full_shield_does() {
    let (mut s, v, a) = game();
    for raw in [f32::NAN, f32::INFINITY, -1.] { assert!(s.apply_damage(Some(a), v, raw, DamageKind::True).is_err()); }
    assert!(s.apply_damage(Some(u32::MAX), v, 5., DamageKind::True).is_err());
    s.apply_damage(Some(a), v, 0., DamageKind::True).unwrap();
    assert!(s.death_recap.lives.is_empty());
    s.grant_shield(v, "shield", 10., 1000).unwrap();
    s.apply_damage(Some(a), v, 5., DamageKind::True).unwrap();
    assert_eq!(s.death_recap.lives[&v].hits.len(), 1);
    assert!(s.snapshot_for_atomic(v).unwrap().death_recap.is_none());
    kill(&mut s, v, Some(a));
    assert_eq!(recap(&s, v).rows[0].true_damage.shield_absorbed, 10.);
}
#[test]
fn visible_identity_is_captured_before_lethal_removes_the_last_vision_source() {
    let (mut s, v, a) = game();
    kill(&mut s, v, Some(a));
    assert!(!s.visible_to(s.players[&v].team, a));
    let r = recap(&s, v);
    assert_eq!(r.rows[0].source, Source::Champion { champion: "annie".into() });
    s.players.get_mut(&a).unwrap().champion = "ezreal".into();
    s.remove_player(a).unwrap();
    s.tick += WINDOW_TICKS + 1;
    assert_eq!(recap(&s, v), r); // Frozen longer than the recording window, no late lookup.
}
#[test]
fn hidden_sources_are_one_anonymous_summary_without_late_de_redaction() {
    let (mut s, v, a) = game(); let b = s.join("ezreal").unwrap();
    for id in [a, b] { let p = s.players.get_mut(&id).unwrap(); p.team = 1; p.position = Point { x: 100_000., z: 100_000. }; }
    assert!(!s.visible_to(0, a)); assert!(!s.visible_to(0, b));
    s.apply_damage(Some(a), v, 5., DamageKind::True).unwrap();
    kill(&mut s, v, Some(b));
    let r = recap(&s, v); assert_eq!(r.rows.len(), 1); assert_eq!(r.rows[0].source, Source::Unknown);
    for id in [a, b] { s.players.get_mut(&id).unwrap().team = 0; }
    assert!(s.visible_to(0, a)); assert_eq!(recap(&s, v), r);
    let value = serde_json::to_value(&r).unwrap(); assert_no_private_fields(&value);
    assert_no_hidden_names(&value, &["annie", "ezreal"]);
}
#[test]
fn pet_label_never_exports_its_owner_and_none_is_unknown() {
    let (mut s, v, a) = game(); let pet = npc(&mut s, v, world::Kind::Pet);
    s.units.get_mut(&pet).unwrap().pet = Some(crate::annie_r::Pet {
        owner: a, rank: 1, spawned: s.tick, expires: s.tick + 1000, next_aura: s.tick + 30,
        order: crate::annie_r::Order::Follow, molten_until: 0, molten_rank: 0,
    });
    s.players.get_mut(&a).unwrap().position = Point { x: 100_000., z: 100_000. };
    assert_eq!(s.combat_owner(pet), Some(a));
    assert!(!s.visible_to(0, a)); assert!(s.visible_to(0, pet));
    s.apply_damage(Some(pet), v, 10., DamageKind::True).unwrap(); kill(&mut s, v, None);
    let r = recap(&s, v);
    assert!(matches!(r.rows[0].source, Source::Unit { kind: world::Kind::Pet, .. }));
    assert_eq!(r.rows[1].source, Source::Unknown);
    let value = serde_json::to_value(&r).unwrap(); assert_no_private_fields(&value);
    assert_no_hidden_names(&value, &["annie"]);
}
#[test]
fn projection_is_exact_victim_only_and_generic_legacy_remain_empty() {
    let (mut s, v, a) = game(); let ally = s.join("ezreal").unwrap();
    kill(&mut s, v, Some(a));
    assert!(s.snapshot_for_atomic(v).unwrap().death_recap.is_some());
    for viewer in [a, ally] { assert!(s.snapshot_for_atomic(viewer).unwrap().death_recap.is_none()); }
    assert!(s.snapshot_for(v).unwrap().death_recap.is_none()); assert!(s.snapshot().death_recap.is_none());
    assert!(s.snapshot_for_atomic(u32::MAX).is_none());
    s.session += 1; assert!(s.snapshot_for_atomic(v).unwrap().death_recap.is_none());
}
#[test]
fn fixed_window_includes_exact_boundary_and_does_not_disclose_first_hidden_hit_time() {
    let (mut s, v, _) = game(); s.tick = 1;
    s.apply_damage(None, v, 3., DamageKind::True).unwrap(); s.tick = 2;
    s.apply_damage(None, v, 7., DamageKind::True).unwrap();
    s.tick = WINDOW_TICKS + 2; let hp = s.players[&v].health; kill(&mut s, v, None);
    let r = recap(&s, v); assert_eq!(r.window_start, 2); assert!(!r.truncated);
    assert_eq!(r.rows[0].true_damage.health_removed, 7. + hp);
}
#[test]
fn capacity_marks_only_overlapping_lost_history_and_keeps_lethal_hit() {
    for wait in [false, true] {
        let (mut s, v, _) = game(); s.players.get_mut(&v).unwrap().health = 100_000.;
        for _ in 0..MAX_HITS + 2 { s.apply_damage(None, v, 1., DamageKind::True).unwrap(); }
        assert_eq!(s.death_recap.lives[&v].hits.len(), MAX_HITS);
        if wait { s.tick = WINDOW_TICKS + 1; }
        let hp = s.players[&v].health; kill(&mut s, v, None); let r = recap(&s, v);
        assert_eq!(r.truncated, !wait); assert!(r.rows[0].lethal);
        assert_eq!(r.rows[0].true_damage.health_removed, hp + if wait { 0. } else { (MAX_HITS - 1) as f32 });
    }
}
#[test]
fn respawn_clears_only_after_placement_succeeds_and_keeps_u64_death_identity() {
    let (mut s, v, a) = game();
    s.apply_damage(Some(a), v, 1., DamageKind::True).unwrap();
    s.death_recap.lives.get_mut(&v).unwrap().death_ordinal = (1_u64 << 53) + 9;
    kill(&mut s, v, Some(a)); let first = recap(&s, v);
    let value = serde_json::from_slice::<serde_json::Value>(&serde_json::to_vec(&first).unwrap()).unwrap();
    assert_eq!(decode_view(Some(&value), s.session, v, s.tick).unwrap().unwrap().death_ordinal, (1_u64 << 53) + 10);
    s.tick = s.players[&v].respawn_at.unwrap();
    let cells = s.navigation.cells.clone();
    for c in &mut s.navigation.cells { c.1 = false; }
    s.advance_respawns(); assert_eq!(recap(&s, v), first);
    s.navigation.cells = cells; s.advance_respawns();
    assert!(s.players[&v].health > 0.); assert!(s.snapshot_for_atomic(v).unwrap().death_recap.is_none());
    kill(&mut s, v, None); assert_eq!(recap(&s, v).death_ordinal, first.death_ordinal + 1);
    s.remove_player(v).unwrap(); assert!(!s.death_recap.lives.contains_key(&v));
}
#[test]
fn visible_row_cap_preserves_recorded_totals_in_other_summary() {
    let (mut s, v, _) = game(); let mut total = 0.;
    for _ in 0..MAX_VISIBLE_ROWS + 2 {
        let source = npc(&mut s, v, world::Kind::Melee);
        total += s.apply_damage(Some(source), v, 1., DamageKind::True).unwrap().health_removed;
    }
    let hp = s.players[&v].health; kill(&mut s, v, None); total += hp;
    let r = recap(&s, v); assert_eq!(r.rows.len(), MAX_ROWS);
    assert_eq!(r.rows.iter().filter(|r| r.source == Source::Other).count(), 1);
    assert_eq!(r.rows.iter().map(|r| r.true_damage.health_removed).sum::<f32>(), total);
    assert!(!r.truncated); assert!(serde_json::to_vec(&r).unwrap().len() <= MAX_BYTES);
}
#[test]
fn healing_does_not_rewrite_recorded_hp_loss() {
    let (mut s, v, _) = game(); let start = s.players[&v].health;
    s.apply_damage(None, v, 10., DamageKind::True).unwrap();
    assert_eq!(s.heal(None, v, 10.).unwrap().restored, 10.);
    kill(&mut s, v, None);
    assert_eq!(recap(&s, v).rows[0].true_damage.health_removed, start + 10.);
}
#[test]
fn exhausted_identity_or_sum_overflow_only_disables_presentation() {
    let (mut s, v, _) = game(); s.apply_damage(None, v, 1., DamageKind::True).unwrap();
    s.death_recap.lives.get_mut(&v).unwrap().death_ordinal = u64::MAX;
    kill(&mut s, v, None); assert_eq!(s.players[&v].health, 0.);
    assert!(s.snapshot_for_atomic(v).unwrap().death_recap.is_none());
    // A private aggregation fixture isolates finite-sum overflow; no native damage is claimed.
    let mut life = Life::default();
    for lethal in [false, true] { life.hits.push_back(Hit { tick: 0, known: None, kind: DamageKind::True,
        amount: Amount { health_removed: f32::MAX, shield_absorbed: 0. }, lethal }); }
    assert!(freeze(7, 1, 0, 1, &life).is_none());
}
#[test]
fn strict_decoder_rejects_cross_owner_future_unknown_fields_and_oversize() {
    let (mut s, v, a) = game(); kill(&mut s, v, Some(a)); let r = recap(&s, v);
    let raw = serde_json::to_value(&r).unwrap();
    assert_eq!(decode_view(Some(&raw), s.session, a, s.tick), Err(DecodeError::Context));
    assert_eq!(decode_view(Some(&raw), s.session + 1, v, s.tick), Err(DecodeError::Context));
    let mut future = raw.clone(); future["death_tick"] = serde_json::json!(s.tick + 1);
    assert!(decode_view(Some(&future), s.session, v, s.tick).is_err());
    let mut private = raw.clone(); private["rows"][0]["source_id"] = serde_json::json!(a);
    assert_eq!(decode_view(Some(&private), s.session, v, s.tick), Err(DecodeError::Shape));
    let mut malformed = raw.clone(); malformed["rows"][0]["physical"]["health_removed"] = serde_json::json!(-1.);
    assert!(decode_view(Some(&malformed), s.session, v, s.tick).is_err());
    assert_eq!(decode_view(Some(&serde_json::json!("x".repeat(MAX_BYTES))), s.session, v, s.tick), Err(DecodeError::Bound));
    assert_eq!(decode_view(None, s.session, v, s.tick), Ok(None));
}
