use super::*;
fn simulation() -> (Simulation, u32, u32) {
    let metadata = r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#;
    let mut bytes = Vec::new();
    for _ in 0..400 {
        bytes.extend(0f32.to_le_bytes());
        bytes.extend(0u16.to_le_bytes());
        bytes.extend(0u32.to_le_bytes());
        bytes.push(1);
    }
    let mut s = Simulation::new(Navigation::load(metadata, &bytes).unwrap()).unwrap();
    let a = s.join("garen").unwrap();
    let b = s.join("garen").unwrap();
    s.players.get_mut(&a).unwrap().position = Point { x: 100., z: 100. };
    s.players.get_mut(&b).unwrap().position = Point { x: 150., z: 100. };
    (s, a, b)
}
fn learn(s: &mut Simulation, id: u32, slot: u8) {
    s.command(id, Action::Learn { slot }).unwrap();
}
#[test]
fn native_map10_curve_and_growth_are_applied() {
    let (mut s, a, _) = simulation();
    let base = s.players[&a].max_health;
    s.award_experience(a, 299.).unwrap();
    assert_eq!(s.players[&a].level, 1);
    s.award_experience(a, 1.).unwrap();
    assert_eq!(s.players[&a].level, 2);
    assert!((s.players[&a].max_health - base - s.growth["garen"].health * 0.72).abs() < 0.01);
    s.award_experience(a, 400.).unwrap();
    assert_eq!(s.players[&a].level, 3);
    s.award_experience(a, 100000.).unwrap();
    assert_eq!(s.players[&a].level, 18);
    assert!(s.award_experience(a, f32::NAN).is_err());
}
#[test]
fn rank_gates_budget_and_maximum_are_enforced() {
    let (mut s, a, _) = simulation();
    assert!(s.command(a, Action::Learn { slot: 3 }).is_err());
    learn(&mut s, a, 0);
    assert!(s.command(a, Action::Learn { slot: 1 }).is_err());
    s.award_experience(a, 300.).unwrap();
    assert!(s.command(a, Action::Learn { slot: 0 }).is_err());
    learn(&mut s, a, 1);
    s.award_experience(a, 2225.).unwrap();
    assert_eq!(s.players[&a].level, 6);
    learn(&mut s, a, 3);
    assert!(s.command(a, Action::Learn { slot: 3 }).is_err());
    s.award_experience(a, 100000.).unwrap();
    for _ in 0..4 {
        learn(&mut s, a, 0);
    }
    assert!(s.command(a, Action::Learn { slot: 0 }).is_err());
    for _ in 0..2 {
        learn(&mut s, a, 3);
    }
    assert!(s.command(a, Action::Learn { slot: 3 }).is_err());
    assert!(s.command(a, Action::Learn { slot: 4 }).is_err());
}
#[test]
fn q_empowers_once_and_silences_with_server_cooldown() {
    let (mut s, a, b) = simulation();
    learn(&mut s, a, 0);
    learn(&mut s, b, 0);
    s.command(
        a,
        Action::Cast {
            slot: 0,
            target: None,
        },
    )
    .unwrap();
    assert_eq!(s.players[&a].cooldowns[0], 240);
    assert!(s
        .command(
            a,
            Action::Cast {
                slot: 0,
                target: None
            }
        )
        .is_err());
    let health = s.players[&b].health;
    let expected = (1.4 * s.stats(a).damage + 30.) * 100. / (100. + s.stats(b).armor);
    s.command(a, Action::Attack { target: b }).unwrap();
    s.advance();
    let release = s.players[&a].windup.as_ref().unwrap().release;
    while s.tick < release {
        s.advance();
    }
    // Base target regeneration after the impact occurs on the next tick.
    assert!((health - s.players[&b].health - expected).abs() < 0.01);
    assert_eq!(s.players[&a].effects.empowered_until, 0);
    assert_eq!(s.players[&b].effects.silence_until, s.tick + 45);
    assert!(s
        .command(
            b,
            Action::Cast {
                slot: 0,
                target: None
            }
        )
        .unwrap_err()
        .contains("silenced"));
}
#[test]
fn courage_reduces_damage_and_cc_but_does_not_raise_base_armor() {
    let (mut s, a, b) = simulation();
    learn(&mut s, a, 0);
    learn(&mut s, b, 1);
    let armor = s.stats(b).armor;
    s.command(
        b,
        Action::Cast {
            slot: 1,
            target: None,
        },
    )
    .unwrap();
    assert_eq!(s.stats(b).armor, armor);
    let start = s.players[&b].health;
    s.damage(b, 100., false);
    assert!((start - s.players[&b].health - 70. * 100. / (100. + armor)).abs() < 0.01);
    s.apply_silence(b, 30);
    assert_eq!(s.players[&b].effects.silence_until, 21);
}
#[test]
fn judgment_has_six_pulses_and_blocks_attacks() {
    let (mut s, a, b) = simulation();
    learn(&mut s, a, 2);
    let start = s.players[&b].health;
    let pulse = (10. + 0.35 * s.stats(a).damage) * 100. / (100. + s.stats(b).armor);
    s.command(
        a,
        Action::Cast {
            slot: 2,
            target: None,
        },
    )
    .unwrap();
    assert!(s.command(a, Action::Attack { target: b }).is_err());
    for _ in 0..14 {
        s.advance();
    }
    assert_eq!(s.players[&b].health, start);
    s.advance();
    assert!(
        (start - s.players[&b].health - pulse
            + s.regeneration_rates(b).unwrap().health_per_second / 30.)
            .abs()
            < 0.01
    );
    for _ in 0..90 {
        s.advance();
    }
    assert!(
        (start - s.players[&b].health - 6. * pulse
            + s.regeneration_rates(b).unwrap().health_per_second * 91. / 30.)
            .abs()
            < 0.02
    );
}
#[test]
fn ultimate_validates_target_and_resolves_with_captured_rank_magic_damage() {
    let (mut s, a, b) = simulation();
    assert!(s
        .command(
            a,
            Action::Cast {
                slot: 3,
                target: Some(b)
            }
        )
        .is_err());
    s.award_experience(a, 2525.).unwrap();
    learn(&mut s, a, 3);
    assert!(s
        .command(
            a,
            Action::Cast {
                slot: 3,
                target: Some(a)
            }
        )
        .is_err());
    s.players.get_mut(&b).unwrap().position = Point { x: 900., z: 900. };
    assert!(s
        .command(
            a,
            Action::Cast {
                slot: 3,
                target: Some(b)
            }
        )
        .is_err());
    s.players.get_mut(&b).unwrap().position = Point { x: 150., z: 100. };
    s.players.get_mut(&b).unwrap().health -= 100.;
    let start = s.players[&b].health;
    let base_regen = s.regeneration_rates(b).unwrap().health_per_second / 30.;
    let regen = base_regen + s.garen_passive_per_second(b) / 30.;
    let expected = (175. + (100. - 14. * regen) / 3.5) * 100. / (100. + s.stats(b).magic_resist);
    s.command(
        a,
        Action::Cast {
            slot: 3,
            target: Some(b),
        },
    )
    .unwrap();
    assert_eq!(s.players[&a].cooldowns[3], 4800);
    assert!(s.command(a, Action::Stop).is_err());
    s.award_experience(a, 4375.).unwrap();
    learn(&mut s, a, 3);
    for _ in 0..14 {
        s.advance();
    }
    assert!((s.players[&b].health - start - 14. * regen).abs() < 0.002);
    s.advance();
    assert!((start - s.players[&b].health - expected + 14. * regen + base_regen).abs() < 0.01);
}
#[test]
fn dead_caster_cannot_resolve_ultimate_or_move() {
    let (mut s, a, b) = simulation();
    s.award_experience(a, 2525.).unwrap();
    learn(&mut s, a, 3);
    s.command(
        a,
        Action::Cast {
            slot: 3,
            target: Some(b),
        },
    )
    .unwrap();
    let start = s.players[&b].health;
    s.damage(a, 100000., true);
    for _ in 0..20 {
        s.advance();
    }
    assert_eq!(s.players[&b].health, start);
    assert!(s
        .command(
            a,
            Action::Move {
                point: Point { x: 200., z: 200. }
            }
        )
        .is_err());
}
#[test]
fn unsupported_champion_kit_is_rejected_instead_of_invented() {
    let (mut s, _, _) = simulation();
    let a = s.join("ahri").unwrap();
    assert!(s
        .command(a, Action::Learn { slot: 0 })
        .unwrap_err()
        .contains("not implemented"));
    assert!(s
        .command(
            a,
            Action::Cast {
                slot: 0,
                target: None
            }
        )
        .unwrap_err()
        .contains("not implemented"));
}

#[test]
fn attack_order_pursues_then_stops_in_range() {
    let (mut s, a, b) = simulation();
    s.players.get_mut(&b).unwrap().position = Point { x: 550., z: 100. };
    let start = s.players[&b].health;
    s.command(a, Action::Attack { target: b }).unwrap();
    for _ in 0..100 {
        s.advance();
    }
    assert!(s.players[&a].position.x > 100.);
    assert!(s.players[&b].health < start);
    assert!(
        s.players[&a].position.distance(s.players[&b].position)
            <= s.definitions["garen"].attack_range + s.target_info(b).unwrap().radius
    );
    assert!(s.players[&a].destination.is_none());
}
#[test]
fn invalidated_attack_target_clears_pursuit() {
    let (mut s, a, b) = simulation();
    s.players.get_mut(&b).unwrap().position = Point { x: 550., z: 100. };
    s.command(a, Action::Attack { target: b }).unwrap();
    s.advance();
    assert!(s.players[&a].destination.is_some());
    s.players.remove(&b);
    let position = s.players[&a].position;
    s.advance();
    assert_eq!(position, s.players[&a].position);
    assert!(s.players[&a].target.is_none());
}
#[test]
fn move_order_replaces_pursuit_and_stop_cancels_it() {
    let (mut s, a, b) = simulation();
    s.command(a, Action::Attack { target: b }).unwrap();
    s.command(
        a,
        Action::Move {
            point: Point { x: 400., z: 400. },
        },
    )
    .unwrap();
    assert!(s.players[&a].target.is_none());
    s.command(a, Action::Stop).unwrap();
    let point = s.players[&a].position;
    s.advance();
    assert_eq!(s.players[&a].position, point);
}

#[test]
fn native_fountain_spawn_uses_source_points_and_navigation() {
    let metadata = include_str!("../../../assets/maps/tt_navigation_grid.json");
    let cells = include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin");
    let navigation = Navigation::load(metadata, cells).unwrap();
    let mut s = Simulation::new(navigation).unwrap();
    let sources: Vec<serde_json::Value> = serde_json::from_str(include_str!(
        "../../../data/4.20/champion_spawns_map10.json"
    ))
    .unwrap();
    for team in 0..2 {
        let id = s.join("garen").unwrap();
        let source: Point = serde_json::from_value(sources[team]["point"].clone()).unwrap();
        assert_eq!(s.players[&id].team, team as u8);
        assert!(s.navigation.ground(s.players[&id].position).is_some());
        if s.navigation.ground(source).is_some() {
            assert_eq!(s.players[&id].position, source);
        } else {
            assert_eq!(
                s.players[&id].position,
                s.navigation.nearest_walkable(source).unwrap()
            );
        }
    }
}

#[test]
fn judgment_recast_cancels_future_damage_preserves_cooldown_and_restores_attacks() {
    let (mut s, a, b) = simulation();
    learn(&mut s, a, 2);
    s.cast(a, 2, None).unwrap();
    let cooldown = s.players[&a].cooldowns[2];
    for _ in 0..16 {
        s.advance();
    }
    assert!(s.players[&b].health < s.players[&b].max_health);
    s.cast(a, 2, None).unwrap();
    assert_eq!(s.players[&a].effects.spin_rank, 0);
    assert_eq!(s.players[&a].effects.next_spin, 0);
    assert_eq!(s.players[&a].effects.spin_until, s.tick);
    assert_eq!(s.players[&a].cooldowns[2], cooldown);
    let health = s.players[&b].health;
    for _ in 0..90 {
        s.advance();
    }
    assert!(s.players[&b].health >= health);
    assert!(s.cast(a, 2, None).unwrap_err().contains("cooldown"));
    s.command(a, Action::Attack { target: b }).unwrap();
}
#[test]
fn silenced_judgment_recast_is_rejected_without_mutating_active_spin() {
    let (mut s, a, _) = simulation();
    learn(&mut s, a, 2);
    s.cast(a, 2, None).unwrap();
    let until = s.players[&a].effects.spin_until;
    let cooldown = s.players[&a].cooldowns[2];
    s.apply_silence(a, 30);
    assert!(s.cast(a, 2, None).unwrap_err().contains("silenced"));
    assert_eq!(s.players[&a].effects.spin_until, until);
    assert_eq!(s.players[&a].cooldowns[2], cooldown);
    assert_eq!(s.players[&a].effects.spin_rank, 1);
}

// Subsystem fixtures deliberately omit world AI/regeneration between cast and pulse.
// They exercise the actual cast/advance_spells path, not apply_damage in isolation.
fn judgment_game(enemy: &str) -> (Simulation, u32, u32) {
    let nav = Navigation::load(
        include_str!("../../../assets/maps/tt_navigation_grid.json"),
        include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin"),
    ).unwrap();
    let mut s = Simulation::new(nav).unwrap();
    s.enable_map10().unwrap();
    s.interactions = None;
    let a = s.join("garen").unwrap();
    let b = s.join(enemy).unwrap();
    s.buy_item(a, 1053).unwrap();
    let point = s.navigation.nearest_walkable(Point { x: 7700., z: 7000. }).unwrap();
    for id in [a, b] {
        s.players.get_mut(&id).unwrap().position = point;
    }
    s.players.get_mut(&a).unwrap().health = 100.;
    assert!((s.stats(a).life_steal - 0.08).abs() < 0.00001);
    (s, a, b)
}
fn first_judgment_pulse(s: &mut Simulation, source: u32) {
    s.cast(source, 2, None).unwrap();
    s.tick = s.players[&source].effects.next_spin;
    s.advance_spells();
}

#[test]
fn judgment_all_ranks_damage_players_without_lifesteal_or_molten_retaliation() {
    for (rank, base, ad_ratio) in [(1, 20., 0.70), (2, 45., 0.80),
        (3, 70., 0.90), (4, 95., 1.00), (5, 120., 1.10)] {
        let (mut s, a, b) = judgment_game("annie");
        // Rank is a fixture; cast admission and pulse execution are production code.
        s.players.get_mut(&a).unwrap().ranks[2] = rank;
        s.learn(b, 2).unwrap();
        s.cast(b, 2, None).unwrap();
        let hp = s.players[&b].health;
        let expected = (base + ad_ratio * s.stats(a).damage) / 2.
            * 100. / (100. + s.stats(b).armor);
        first_judgment_pulse(&mut s, a);
        assert!((hp - s.players[&b].health - expected).abs() < 0.001);
        assert_eq!(s.players[&a].health, 100., "E must neither heal nor retaliate");
        let hp = s.players[&b].health;
        s.advance_spells();
        assert_eq!(s.players[&b].health, hp, "same tick cannot duplicate a pulse");
    }
}

#[test]
fn judgment_preserves_courage_shields_passive_interruption_and_assist_credit() {
    let (mut s, a, b) = judgment_game("garen");
    s.learn(a, 2).unwrap();
    s.learn(b, 1).unwrap();
    s.cast(b, 1, None).unwrap();
    s.grant_shield(b, "judgment-test", 100., 90).unwrap();
    let hp = s.players[&b].health;
    let expected = (10. + 0.35 * s.stats(a).damage)
        * 100. / (100. + s.stats(b).armor) * 0.7;
    first_judgment_pulse(&mut s, a);
    assert_eq!(s.players[&b].health, hp);
    assert!((s.players[&b].shields[0].remaining - (100. - expected)).abs() < 0.001);
    assert_eq!(s.players[&b].perseverance_interrupted_at, Some(s.tick));
    assert_eq!(s.players[&a].health, 100.);
    // A shielded E hit still contributes to the existing champion kill bookkeeping.
    let ally = s.join("garen").unwrap();
    assert_eq!(s.players[&ally].team, s.players[&a].team);
    s.apply_damage(Some(ally), b, 10000., damage::DamageKind::True).unwrap();
    let event = s.kill_rewards.events.back().unwrap();
    assert_eq!(event.killer, Some(ally));
    assert_eq!(event.assists, vec![a]);
    assert_eq!(s.players[&a].score.assists, 1);
}

#[test]
fn judgment_units_keep_armor_lane_penalty_and_camp_aggro_without_lifesteal() {
    let (mut s, a, b) = judgment_game("garen");
    s.learn(a, 2).unwrap();
    let point = s.players[&a].position;
    s.players.get_mut(&b).unwrap().position.x += 1000.;
    let minion = s.spawn_unit("Red_Minion_Basic", "test-lane", 1, point, 0., 0., None, None).unwrap();
    let camp = s.world.as_ref().unwrap().config.camps[0].index;
    let monster = s.spawn_unit("TT_NGolem", "test-camp", 2, point, 0., 0., Some(camp), None).unwrap();
    let ally = s.spawn_unit("Red_Minion_Basic", "test-ally", 0, point, 0., 0., None, None).unwrap();
    let tower = s.units.values().find(|u| u.kind == world::Kind::Turret && u.team == 1).unwrap().id;
    s.units.get_mut(&tower).unwrap().position = point;
    // Deliberately distinct defenses detect accidental magical/true routing.
    for id in [minion, monster] {
        let u = s.units.get_mut(&id).unwrap();
        u.armor = 100.;
        u.magic_resist = 0.;
    }
    let raw = 10. + 0.35 * s.stats(a).damage;
    let before = [minion, monster, ally, tower].map(|id| s.units[&id].health);
    first_judgment_pulse(&mut s, a);
    assert!((before[0] - s.units[&minion].health - raw * 0.75 / 2.).abs() < 0.001);
    assert!((before[1] - s.units[&monster].health - raw / 2.).abs() < 0.001);
    assert_eq!(s.units[&monster].target, Some(a));
    assert_eq!(s.units[&ally].health, before[2]);
    assert_eq!(s.units[&tower].health, before[3]);
    assert_eq!(s.players[&a].health, 100.);
}

#[test]
fn judgment_does_not_trigger_tibbers_molten_shield_but_basic_hits_still_do() {
    let (mut s, a, annie) = judgment_game("annie");
    s.learn(a, 2).unwrap();
    s.players.get_mut(&annie).unwrap().level = 6;
    s.learn(annie, 3).unwrap();
    s.learn(annie, 2).unwrap();
    let point = s.players[&a].position;
    // Survive the real summon burst before isolating the subsequent E interaction.
    let max_health = s.players[&a].max_health;
    s.players.get_mut(&a).unwrap().health = max_health;
    s.cast_at(annie, 3, point).unwrap();
    s.tick = 8;
    s.advance_annie_r();
    assert!(s.players[&a].health > 0.);
    let pet = s.tibbers(annie).unwrap();
    s.cast(annie, 2, None).unwrap();
    s.players.get_mut(&annie).unwrap().position.x += 1000.;
    s.players.get_mut(&a).unwrap().health = 100.;
    let hp = s.units[&pet].health;
    let expected = (10. + 0.35 * s.stats(a).damage) * 100.
        / (100. + s.units[&pet].armor + annie_r::defense(&s.units[&pet], s.tick));
    first_judgment_pulse(&mut s, a);
    assert!((hp - s.units[&pet].health - expected).abs() < 0.001);
    assert_eq!(s.players[&a].health, 100.);
    s.basic_attack_hit(a, pet, 10.).unwrap();
    assert!(s.players[&a].health < 100., "the pet's basic-hit reaction remains enabled");
}

#[test]
fn judgment_lethal_player_pulse_preserves_kill_reward_and_death_once() {
    let (mut s, a, b) = judgment_game("garen");
    s.learn(a, 2).unwrap();
    s.players.get_mut(&b).unwrap().health = 1.;
    let gold = s.players[&a].gold;
    first_judgment_pulse(&mut s, a);
    assert_eq!(s.players[&b].health, 0.);
    assert!(s.players[&b].respawn_at.is_some());
    assert_eq!(s.players[&a].score.kills, 1);
    assert_eq!(s.players[&b].score.deaths, 1);
    assert_eq!(s.players[&a].gold, gold + 400.);
    assert_eq!(s.players[&a].experience, 165.);
    assert_eq!(s.kill_rewards.events.len(), 1);
    assert_eq!(s.kill_rewards.events.back().unwrap().killer, Some(a));
    assert_eq!(s.players[&a].health, 100.);
    s.tick += 15;
    s.advance_spells();
    assert_eq!(s.kill_rewards.events.len(), 1);
    assert_eq!(s.players[&a].gold, gold + 400.);
}

#[test]
fn judgment_lethal_unit_pulse_preserves_gold_experience_and_retirement_once() {
    for definition in ["Red_Minion_Basic", "TT_NGolem"] {
        let (mut s, a, b) = judgment_game("garen");
        s.learn(a, 2).unwrap();
        let point = s.players[&a].position;
        s.players.get_mut(&b).unwrap().position.x += 1000.;
        let target = s.spawn_unit(definition, "test-reward", 2, point, 0., 0., None, None).unwrap();
        let reward = s.units[&target].gold;
        let experience = s.units[&target].experience;
        assert!(reward > 0. && experience > 0.);
        s.units.get_mut(&target).unwrap().health = 1.;
        let gold = s.players[&a].gold;
        first_judgment_pulse(&mut s, a);
        assert_eq!(s.units[&target].health, 0.);
        assert_eq!(s.units[&target].remove_at, Some(s.tick + 3 * TICK_RATE));
        assert_eq!(s.players[&a].gold, gold + reward);
        assert_eq!(s.players[&a].experience, experience);
        s.tick += 15;
        s.advance_spells();
        assert_eq!(s.players[&a].gold, gold + reward);
        assert_eq!(s.players[&a].experience, experience);
    }
}

#[test]
fn ordinary_attacks_and_decisive_strike_keep_existing_hit_reactions() {
    for empowered in [false, true] {
        let (mut s, a, b) = judgment_game("annie");
        s.learn(b, 2).unwrap();
        s.cast(b, 2, None).unwrap();
        if empowered {
            s.learn(a, 0).unwrap();
            s.cast(a, 0, None).unwrap();
        }
        let raw = if empowered { 1.4 * s.stats(a).damage + 30. } else { s.stats(a).damage };
        let damage = raw * 100. / (100. + s.stats(b).armor);
        let retaliation = 20. * 100. / (100. + s.stats(a).magic_resist);
        // Ordinary and Q-empowered basic attacks share life steal and Molten retaliation.
        let healing = damage * 0.08;
        let hp = s.players[&b].health;
        s.command(a, Action::Attack { target: b }).unwrap();
        s.advance_attacks();
        s.tick = s.players[&a].windup.as_ref().unwrap().release;
        s.advance_attacks();
        assert!((hp - s.players[&b].health - damage).abs() < 0.001);
        assert!((s.players[&a].health - (100. + healing - retaliation)).abs() < 0.001);
        if empowered {
            assert_eq!(s.players[&a].effects.empowered_until, 0);
            assert_eq!(s.players[&b].effects.silence_until, s.tick + 45);
        }
    }
}

#[test]
fn decisive_strike_heals_once_at_release_before_molten_retaliation() {
    let (mut s, a, b) = judgment_game("annie");
    s.learn(a, 0).unwrap();
    s.learn(b, 2).unwrap();
    s.cast(b, 2, None).unwrap();
    let damage = (1.4 * s.stats(a).damage + 30.) * 100. / (100. + s.stats(b).armor);
    let healing = damage * 0.08;
    let retaliation = 20. * 100. / (100. + s.stats(a).magic_resist);
    // The source survives only if the attack heals before the captured retaliation.
    let before = retaliation - healing / 2.;
    assert!(before > 0. && before < retaliation);
    s.players.get_mut(&a).unwrap().health = before;
    let enemy_hp = s.players[&b].health;
    s.cast(a, 0, None).unwrap();
    assert_eq!(s.players[&a].health, before, "Q activation is not an impact");
    // Existing Q policy ignores the saved critical roll; this change preserves it.
    s.players.get_mut(&a).unwrap().attack_roll = Some(true);
    s.command(a, Action::Attack { target: b }).unwrap();
    s.advance_attacks();
    let windup = s.players[&a].windup.clone().unwrap();
    assert!(!windup.critical && windup.release > s.tick);
    s.tick = windup.release - 1;
    s.advance_attacks();
    assert_eq!(s.players[&a].health, before);
    assert_eq!(s.players[&b].health, enemy_hp);
    s.tick = windup.release;
    s.advance_attacks();
    assert!((enemy_hp - s.players[&b].health - damage).abs() < 0.001);
    assert!((s.players[&a].health - (before + healing - retaliation)).abs() < 0.001);
    assert!(s.players[&a].health > 0. && s.players[&a].respawn_at.is_none());
    assert_eq!(s.players[&a].effects.empowered_until, 0);
    assert_eq!(s.players[&b].effects.silence_until, s.tick + 45);
    let source_hp = s.players[&a].health;
    let enemy_hp = s.players[&b].health;
    s.advance_attacks();
    assert_eq!(s.players[&a].health, source_hp, "same tick cannot heal twice");
    assert_eq!(s.players[&b].health, enemy_hp);
}

#[test]
fn decisive_strike_lifesteal_keeps_world_target_eligibility() {
    for kind in 0..3 {
        let (mut s, a, b) = judgment_game("garen");
        s.learn(a, 0).unwrap();
        let position = s.players[&a].position;
        let target = if kind < 2 {
            let definition = if kind == 0 { "Red_Minion_Basic" } else { "TT_NGolem" };
            let team = if kind == 0 { s.players[&b].team } else { 2 };
            s.spawn_unit(definition, "q-lifesteal-test", team, position, 0., 0., None, None).unwrap()
        } else {
            let team = s.players[&b].team;
            let target = *s.units.iter().find(|(id, u)|
                u.kind == world::Kind::Turret && u.team == team && !s.protected(**id)
            ).expect("map10 contains an attackable outer turret").0;
            // Only spatial isolation is a fixture; real structure eligibility remains active.
            s.units.get_mut(&target).unwrap().position = position;
            target
        };
        let structure = s.units[&target].kind.structure();
        assert_eq!(structure, kind == 2);
        let enemy_hp = s.units[&target].health;
        let damage = (1.4 * s.stats(a).damage + 30.) * 100. / (100. + s.units[&target].armor);
        assert!(enemy_hp > damage);
        s.cast(a, 0, None).unwrap();
        s.command(a, Action::Attack { target }).unwrap();
        s.advance_attacks();
        s.tick = s.players[&a].windup.as_ref().unwrap().release;
        s.advance_attacks();
        assert!((enemy_hp - s.units[&target].health - damage).abs() < 0.001);
        let healing = if structure { 0. } else { damage * 0.08 };
        assert!((s.players[&a].health - (100. + healing)).abs() < 0.001);
        assert_eq!(s.players[&a].effects.empowered_until, 0);
    }
}

#[test]
fn decisive_strike_rejected_or_cancelled_attacks_do_not_heal_or_consume_q() {
    for stop in [false, true] {
        let (mut s, a, b) = judgment_game("garen");
        s.learn(a, 0).unwrap();
        s.cast(a, 0, None).unwrap();
        let empowered_until = s.players[&a].effects.empowered_until;
        let hp = s.players[&b].health;
        let protected = s.units.values().find(|u| u.kind == world::Kind::Fountain).unwrap().id;
        assert!(s.protected(protected));
        for target in [a, u32::MAX, protected] {
            assert!(s.command(a, Action::Attack { target }).is_err());
            assert_eq!(s.players[&a].health, 100.);
            assert_eq!(s.players[&a].effects.empowered_until, empowered_until);
        }
        s.command(a, Action::Attack { target: b }).unwrap();
        s.advance_attacks();
        let release = s.players[&a].windup.as_ref().unwrap().release;
        assert!(release < empowered_until);
        if stop {
            s.command(a, Action::Stop).unwrap();
        } else {
            // The pending attack is invalidated at release, before the hit wrapper.
            s.players.get_mut(&b).unwrap().position.x += 1000.;
        }
        s.tick = release;
        s.advance_attacks();
        assert!(s.players[&a].windup.is_none());
        assert_eq!(s.players[&a].health, 100.);
        assert_eq!(s.players[&b].health, hp);
        assert_eq!(s.players[&a].effects.empowered_until, empowered_until);
    }
}
