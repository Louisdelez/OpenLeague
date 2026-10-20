//! Bounded application checks for the original Doran's Blade numeric data.
//! These controlled Simulation fixtures do not qualify historical LoL gameplay or GUI pixels.
use openleague_core::{damage::DamageKind, shop, spells, Action, Navigation, Point, Simulation, TICK_RATE};

fn game() -> (Simulation, u32) {
    let navigation = Navigation::load(
        include_str!("../../../assets/maps/tt_navigation_grid.json"),
        include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin"),
    ).unwrap();
    // The real Garen definition and native Map10 navigation are used. World AI is
    // deliberately disabled so regeneration/attack impacts have no competing NPCs.
    let mut simulation = Simulation::new(navigation).unwrap();
    let garen = simulation.join("garen").unwrap();
    (simulation, garen)
}

fn close(actual: f32, expected: f32) {
    assert!((actual - expected).abs() <= 0.001, "{actual} != {expected}");
}

#[test]
fn doran_blade_purchase_and_sale_use_native_price_and_all_three_bonuses() {
    let (mut simulation, garen) = game();
    let initial = simulation.stats(garen);
    let current_health = simulation.players[&garen].health;
    assert_eq!(simulation.players[&garen].gold, 825.);
    assert_eq!(simulation.players[&garen].champion, "garen");
    simulation.command(garen, Action::Buy { item: 1055 }).unwrap();
    assert_eq!(simulation.players[&garen].gold, 385.);
    assert_eq!(simulation.players[&garen].inventory, [Some(1055), None, None, None, None, None]);
    assert_eq!(shop::inventory_count(&simulation.players[&garen], 0), 1);
    let purchased = simulation.stats(garen);
    close(purchased.max_health, initial.max_health + 70.);
    close(purchased.damage, initial.damage + 7.);
    assert!((purchased.life_steal - 0.029999999329447746_f32).abs() < 1e-6);
    assert_eq!(simulation.players[&garen].health, current_health,
        "preserve the current application's absolute pool policy; native semantics remain unqualified");
    let snapshot = simulation.snapshot();
    let replicated = snapshot.players.iter().find(|p| p.id == garen).unwrap();
    assert_eq!(replicated.inventory[0], Some(1055));
    assert_eq!(replicated.gold, 385.);
    close(replicated.max_health, initial.max_health + 70.);
    simulation.command(garen, Action::Sell { slot: 0 }).unwrap();
    assert_eq!(simulation.players[&garen].gold, 561.);
    assert_eq!(simulation.players[&garen].inventory, [None; 6]);
    let sold = simulation.stats(garen);
    close(sold.max_health, initial.max_health);
    close(sold.damage, initial.damage);
    assert_eq!(sold.life_steal, initial.life_steal);
}

#[test]
fn doran_blade_rejected_purchase_does_not_modify_inventory_money_or_caps() {
    for case in 0..3 {
        let (mut simulation, garen) = game();
        match case {
            0 => simulation.players.get_mut(&garen).unwrap().gold = 439.,
            1 => {
                let outside = simulation.navigation.nearest_walkable(Point { x: 7700., z: 7000. }).unwrap();
                simulation.players.get_mut(&garen).unwrap().position = outside;
            }
            2 => {
                let champion = simulation.players.get_mut(&garen).unwrap();
                champion.inventory = [Some(1036); 6];
                champion.inventory_counts = [1; 6];
            }
            _ => unreachable!(),
        }
        let before = serde_json::to_value(&simulation.players[&garen]).unwrap();
        let stats_before = simulation.stats(garen);
        let rejected = simulation.command(garen, Action::Buy { item: 1055 }).unwrap_err();
        assert!(rejected.contains(match case { 0 => "insufficient gold", 1 => "outside allied shop", _ => "inventory full" }), "{rejected}");
        assert_eq!(serde_json::to_value(&simulation.players[&garen]).unwrap(), before);
        let after = simulation.stats(garen);
        assert_eq!(after.max_health, stats_before.max_health);
        assert_eq!(after.damage, stats_before.damage);
        assert_eq!(after.life_steal, stats_before.life_steal);
    }
}

fn combat_game() -> (Simulation, u32, u32) {
    let (mut simulation, garen) = game();
    simulation.command(garen, Action::Buy { item: 1055 }).unwrap();
    let enemy = simulation.join("garen").unwrap();
    let position = simulation.navigation.nearest_walkable(Point { x: 7700., z: 7000. }).unwrap();
    // Explicit controlled positions, not an ordinary-play observation.
    for id in [garen, enemy] { simulation.players.get_mut(&id).unwrap().position = position; }
    simulation.apply_damage(None, garen, 100., DamageKind::True).unwrap();
    assert_eq!(simulation.garen_passive_per_second(garen), 0.);
    (simulation, garen, enemy)
}

#[test]
fn doran_blade_lifesteal_applies_once_to_ordinary_and_q_empowered_attack_impacts() {
    for empowered in [false, true] {
        let (mut simulation, garen, enemy) = combat_game();
        if empowered {
            simulation.learn(garen, 0).unwrap();
            simulation.cast(garen, 0, None).unwrap();
        }
        let stats = simulation.stats(garen);
        // Retain the currently implemented Q coefficient; this item does not qualify it.
        let raw = if empowered { 1.4 * stats.damage + spells::garen_value(0, "Effect1", 1) } else { stats.damage };
        let damage = raw * 100. / (100. + simulation.stats(enemy).armor);
        let initial_health = simulation.players[&garen].health;
        let enemy_health = simulation.players[&enemy].health;
        let regeneration = simulation.regeneration_rates(garen).unwrap().health_per_second;
        let initial_tick = simulation.tick;
        simulation.command(garen, Action::Attack { target: enemy }).unwrap();
        simulation.advance();
        let release = simulation.players[&garen].windup.as_ref().unwrap().release;
        assert!(release > simulation.tick && release - initial_tick < 30);
        close(simulation.players[&enemy].health, enemy_health);
        while simulation.tick < release { simulation.advance(); }
        close(enemy_health - simulation.players[&enemy].health, damage);
        let elapsed = (simulation.tick - initial_tick) as f32 / TICK_RATE as f32;
        close(simulation.players[&garen].health, initial_health + regeneration * elapsed + damage * stats.life_steal);
        if empowered { assert_eq!(simulation.players[&garen].effects.empowered_until, 0); }
        // Advance one extra tick before the next attack can be released.
        let after_impact = simulation.players[&garen].health;
        simulation.advance();
        close(simulation.players[&garen].health, after_impact + regeneration / TICK_RATE as f32);
    }
}

#[test]
fn doran_blade_lifesteal_does_not_apply_to_judgment_spell_pulses() {
    let (mut simulation, garen, enemy) = combat_game();
    simulation.learn(garen, 2).unwrap();
    let stats = simulation.stats(garen);
    let raw = spells::garen_value(2, "Effect1", 1) / 2.
        + stats.damage * spells::garen_value(2, "Effect3", 1) / 200.;
    let damage = raw * 100. / (100. + simulation.stats(enemy).armor);
    let initial_health = simulation.players[&garen].health;
    let enemy_health = simulation.players[&enemy].health;
    let regeneration = simulation.regeneration_rates(garen).unwrap().health_per_second;
    let enemy_regeneration = simulation.regeneration_rates(enemy).unwrap().health_per_second;
    let initial_tick = simulation.tick;
    simulation.cast(garen, 2, None).unwrap();
    let pulse = simulation.players[&garen].effects.next_spin;
    while simulation.tick < pulse { simulation.advance(); }
    // Judgment runs before regeneration in advance(); unlike basic attacks, its
    // victim receives base regeneration in this same impact tick. Enemy damage
    // has interrupted Perseverance, so no passive regeneration is included here.
    assert_eq!(simulation.garen_passive_per_second(enemy), 0.);
    close(enemy_health - simulation.players[&enemy].health, damage - enemy_regeneration / TICK_RATE as f32);
    let elapsed = (simulation.tick - initial_tick) as f32 / TICK_RATE as f32;
    close(simulation.players[&garen].health, initial_health + regeneration * elapsed);
}
