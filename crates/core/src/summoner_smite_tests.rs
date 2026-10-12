use super::*;

fn game() -> (Simulation, u32) {
    let nav = Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),
        include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let mut s = Simulation::new(nav).unwrap();
    s.enable_map10().unwrap();
    let caster = s.join_with_summoners("garen", [Some(summoners::Spell::Smite), None]).unwrap();
    s.players.get_mut(&caster).unwrap().position = Point { x: 7700., z: 7000. };
    // Fixtures below isolate targeting/damage from the independently tested fog system.
    s.interactions = None;
    (s, caster)
}
fn unit(s: &mut Simulation, definition: &str, team: u8) -> u32 {
    s.spawn_unit(definition, "smite fixture", team, Point { x: 7750., z: 7000. },
        0., 0., None, None).unwrap()
}
fn reject_unchanged(s: &mut Simulation, caster: u32, slot: u8, target: Option<u32>) {
    let before = serde_json::to_vec(&s.snapshot()).unwrap();
    assert!(s.cast_summoner_on(caster, slot, target).is_err());
    assert_eq!(serde_json::to_vec(&s.snapshot()).unwrap(), before);
}

#[test]
fn smite_all18_official_levels_use_shared_true_damage_without_exhaust_or_resistance_reduction() {
    let official: serde_json::Value = serde_json::from_str(
        include_str!("../../../data/4.20/native_summoners_420.json")).unwrap();
    for level in 1..=18 {
        let (mut s, caster) = game();
        let target = unit(&mut s, "TT_NWraith", 2);
        let p = s.players.get_mut(&caster).unwrap();
        p.level = level;
        p.effects.exhaust_until = 999;
        p.mana = 0.;
        let victim = s.units.get_mut(&target).unwrap();
        victim.health = 5000.; victim.max_health = 5000.;
        victim.armor = 10000.; victim.magic_resist = 10000.;
        let expected = official["data"]["SummonerSmite"]["vars"][0]["coeff"][(level - 1) as usize]
            .as_f64().unwrap() as f32;
        assert_eq!(damage_at_level(level), Some(expected));
        s.command(caster, Action::SummonerTarget { slot: 0, target: Some(target) }).unwrap();
        assert_eq!(s.units[&target].health, 5000. - expected);
        assert_eq!(s.players[&caster].mana, 0.);
        assert_eq!(s.players[&caster].summoners.ready_at, [2700, 0]);
    }
    assert_eq!(damage_at_level(12), Some(720.)); // Never the erroneous community420.
    assert_eq!(damage_at_level(0), None);
    assert_eq!(damage_at_level(19), None);
}

#[test]
fn smite_native_tags_allow_large_epic_minions_and_enemy_tibbers_but_not_small_monsters() {
    let accepted = ["TT_NWraith", "TT_NGolem", "TT_NWolf", "TT_Spiderboss",
        "Blue_Minion_Basic", "Blue_Minion_Wizard", "Blue_Minion_MechCannon",
        "Blue_Minion_MechMelee", "Red_Minion_Basic", "Red_Minion_Wizard",
        "Red_Minion_MechCannon", "Red_Minion_MechMelee", "annietibbers"];
    for name in accepted {
        let (mut s, caster) = game();
        let target = unit(&mut s, name, if name.starts_with("TT_") { 2 } else { 1 });
        s.cast_summoner_on(caster, 0, Some(target)).unwrap();
    }
    for name in ["TT_NWraith2", "TT_NGolem2", "TT_NWolf2", "TT_OrderTurret1",
        "TT_OrderInhibitor", "OrderNexus"] {
        let (mut s, caster) = game();
        let target = unit(&mut s, name, 2);
        reject_unchanged(&mut s, caster, 0, Some(target));
    }
}

#[test]
fn smite_rejects_missing_champions_allies_dead_unknown_resource_and_kind_mismatch_atomically() {
    let (mut s, caster) = game();
    let champion = s.join("garen").unwrap();
    let target = unit(&mut s, "TT_NWraith", 2);
    for t in [None, Some(caster), Some(champion), Some(u32::MAX)] {
        reject_unchanged(&mut s, caster, 0, t);
    }
    s.units.get_mut(&target).unwrap().team = s.players[&caster].team;
    reject_unchanged(&mut s, caster, 0, Some(target));
    s.units.get_mut(&target).unwrap().team = 2;
    s.units.get_mut(&target).unwrap().health = 0.;
    reject_unchanged(&mut s, caster, 0, Some(target));
    s.units.get_mut(&target).unwrap().health = 100.;
    s.units.get_mut(&target).unwrap().definition = "not_registered".into();
    reject_unchanged(&mut s, caster, 0, Some(target));
    s.units.get_mut(&target).unwrap().definition = "TT_NWraith".into();
    s.units.get_mut(&target).unwrap().kind = world::Kind::Pet;
    reject_unchanged(&mut s, caster, 0, Some(target));
}

#[test]
fn smite_center_range760_is_inclusive_and_nonfinite_positions_are_refused() {
    let (mut s, caster) = game();
    let target = unit(&mut s, "TT_NWraith", 2);
    s.units.get_mut(&target).unwrap().position.x = 8461.;
    reject_unchanged(&mut s, caster, 0, Some(target));
    s.units.get_mut(&target).unwrap().position.x = f32::NAN;
    assert!(s.cast_summoner_on(caster, 0, Some(target)).is_err());
    assert_eq!(s.players[&caster].summoners.ready_at[0], 0);
    s.units.get_mut(&target).unwrap().position.x = 8460.;
    s.cast_summoner_on(caster, 0, Some(target)).unwrap();
}

#[test]
fn smite_hidden_target_is_rejected_by_server_even_if_supplied_in_action() {
    let (mut s, caster) = game();
    s.enable_interactions();
    let target = unit(&mut s, "TT_NWraith", 2);
    s.units.retain(|id, _| *id == target);
    let from = s.navigation.index(s.players[&caster].position).unwrap();
    let to = s.navigation.index(s.units[&target].position).unwrap();
    assert_ne!(from, to);
    s.navigation.cells[from].2 &= !1;
    s.navigation.cells[to].2 |= 1;
    assert!(!s.visible_to(s.players[&caster].team, target));
    reject_unchanged(&mut s, caster, 0, Some(target));
}

#[test]
fn smite_provisional90_second_deadline_is_exact_and_spent_only_after_damage() {
    let (mut s, caster) = game();
    let target = unit(&mut s, "TT_Spiderboss", 2);
    s.tick = 7;
    s.cast_summoner_on(caster, 0, Some(target)).unwrap();
    assert_eq!(s.players[&caster].summoners.ready_at[0], 2707);
    s.tick = 2706;
    reject_unchanged(&mut s, caster, 0, Some(target));
    s.tick = 2707;
    s.cast_summoner_on(caster, 0, Some(target)).unwrap();
    assert_eq!(s.players[&caster].summoners.ready_at[0], 5407);
    s.tick = u64::MAX - 100;
    reject_unchanged(&mut s, caster, 0, Some(target));
}

#[test]
fn smite_native_disabled_flag_permits_stun_and_silence_without_resource_or_order_cost() {
    let (mut s, caster) = game();
    let target = unit(&mut s, "TT_NWraith", 2);
    s.grant_stun(None, caster, "fixture", 100).unwrap();
    let p = s.players.get_mut(&caster).unwrap();
    p.effects.silence_until = 100;
    p.destination = Some(Point { x: 7800., z: 7000. });
    p.target = Some(target); p.mana = 0.;
    let destination = p.destination;
    assert!(stuns::allows_disabled("SummonerSmite").unwrap());
    s.command(caster, Action::SummonerTarget { slot: 0, target: Some(target) }).unwrap();
    assert_eq!(s.players[&caster].destination, destination);
    assert_eq!(s.players[&caster].target, Some(target));
    assert_eq!(s.players[&caster].mana, 0.);
    assert!(stuns::active(&s.players[&caster], s.tick));
}

#[test]
fn smite_jungle_upgrades_legacy_items_unknown_items_and_variant_names_are_explicitly_unsupported() {
    for item in rules().unsupported_jungle_items.iter().copied().chain([u32::MAX]) {
        let (mut s, caster) = game();
        let target = unit(&mut s, "TT_NWraith", 2);
        s.players.get_mut(&caster).unwrap().inventory[0] = Some(item);
        reject_unchanged(&mut s, caster, 0, Some(target));
    }
    for name in ["S5_SummonerSmiteQuick", "S5_SummonerSmiteDuel", "S5_SummonerSmitePlayerGanker",
        "S5_SummonerSmiteAOE_Regen", "ItemSmiteAoE"] {
        assert!(serde_json::from_value::<summoners::Spell>(serde_json::json!(name)).is_err());
    }
    let (mut s, caster) = game();
    let target = unit(&mut s, "TT_NWraith", 2);
    s.players.get_mut(&caster).unwrap().inventory[0] = Some(2003); // Potion is not a Smite upgrade.
    s.cast_summoner_on(caster, 0, Some(target)).unwrap();
}

#[test]
fn smite_shared_damage_retains_kill_rewards_xp_camp_aggro_and_does_not_reward_twice() {
    let (mut s, caster) = game();
    s.tick = 2999; s.advance(); // Ordinary Map10 camp producer, no client spawn command.
    let target = *s.units.iter().find(|(_, u)| u.definition == "TT_NWraith").unwrap().0;
    s.players.get_mut(&caster).unwrap().position = s.units[&target].position;
    let camp = s.units[&target].camp;
    s.units.get_mut(&target).unwrap().health = 1.;
    let gold = s.players[&caster].gold;
    let experience = s.players[&caster].experience;
    s.cast_summoner_on(caster, 0, Some(target)).unwrap();
    assert_eq!(s.units[&target].health, 0.);
    assert!(s.players[&caster].gold > gold);
    assert!(s.players[&caster].experience > experience);
    assert!(s.units.values().filter(|u| u.camp == camp && u.health > 0.).all(|u| u.target == Some(caster)));
    s.players.get_mut(&caster).unwrap().summoners.ready_at[0] = 0;
    reject_unchanged(&mut s, caster, 0, Some(target));
}

#[test]
fn smite_shared_protection_and_invalid_world_resource_do_not_spend_cooldown() {
    let (mut s, caster) = game();
    let target = unit(&mut s, "TT_NWraith", 2);
    // Explicit fixture exercises the shared damage guard even for an eligible tag.
    let protected_name = s.world.as_ref().unwrap().config.structures.iter()
        .find(|rule| !rule.depends_all.is_empty() || !rule.depends_any.is_empty()).unwrap().name.clone();
    s.units.get_mut(&target).unwrap().name = protected_name;
    assert!(s.protected(target));
    reject_unchanged(&mut s, caster, 0, Some(target));
    s.units.get_mut(&target).unwrap().name = "smite fixture".into();
    s.world.as_mut().unwrap().config.definitions.remove("TT_NWraith");
    reject_unchanged(&mut s, caster, 0, Some(target));
}

#[test]
fn smite_common_dead_match_slots_level_and_resource_guards_do_not_mutate() {
    let (mut s, caster) = game();
    let target = unit(&mut s, "TT_NWraith", 2);
    for slot in [1, 2, 255] { reject_unchanged(&mut s, caster, slot, Some(target)); }
    reject_unchanged(&mut s, u32::MAX, 0, Some(target));
    for level in [0, 19] {
        s.players.get_mut(&caster).unwrap().level = level;
        reject_unchanged(&mut s, caster, 0, Some(target));
    }
    s.players.get_mut(&caster).unwrap().level = 1;
    s.players.get_mut(&caster).unwrap().mana = -1.;
    reject_unchanged(&mut s, caster, 0, Some(target));
    s.players.get_mut(&caster).unwrap().mana = 0.;
    s.players.get_mut(&caster).unwrap().health = 0.;
    reject_unchanged(&mut s, caster, 0, Some(target));
    s.players.get_mut(&caster).unwrap().health = 100.;
    s.winner = Some(0);
    reject_unchanged(&mut s, caster, 0, Some(target));
}

#[test]
fn smite_loadout_and_target_action_roundtrip_through_existing_wire_schema() {
    let (mut s, caster) = game();
    let target = unit(&mut s, "TT_NWraith", 2);
    let action: Action = serde_json::from_str(&format!(
        r#"{{"SummonerTarget":{{"slot":0,"target":{target}}}}}"#)).unwrap();
    s.command(caster, action).unwrap();
    let restored: Snapshot = serde_json::from_slice(&serde_json::to_vec(&s.snapshot()).unwrap()).unwrap();
    assert_eq!(restored.players.iter().find(|p| p.id == caster).unwrap().summoners.spells[0],
        Some(summoners::Spell::Smite));
    let count = s.players.len();
    assert!(s.join_with_summoners("garen", [Some(summoners::Spell::Smite); 2]).is_err());
    assert_eq!(s.players.len(), count);
}
