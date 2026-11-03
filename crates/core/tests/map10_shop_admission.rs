//! Source-only prepared regression contracts. No test execution is claimed.
//! Requires the post-Doran 33-item catalogue and the shared Map10 admission table.
use openleague_core::{shop, Action, Navigation, Simulation};

fn game() -> (Simulation, u32) {
    let navigation = Navigation::load(
        include_str!("../../../assets/maps/tt_navigation_grid.json"),
        include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin"),
    ).unwrap();
    let mut simulation = Simulation::new(navigation).unwrap();
    simulation.enable_map10().unwrap();
    let garen = simulation.join("garen").unwrap();
    (simulation, garen)
}

#[test]
fn all_33_foundation_flags_match_riot_420_basic_maps_and_item_overrides() {
    let source: serde_json::Value = serde_json::from_str(include_str!(
        "../../../data/4.20/native_ddragon_items_420.json",
    )).unwrap();
    assert_eq!(source["version"], "4.20.1");
    let default = source["basic"]["maps"]["10"].as_bool().unwrap();
    assert_eq!(shop::catalog().len(), 33, "post-Doran prerequisite");
    let mut allowed = 0;
    let mut denied = Vec::new();
    for item in shop::catalog() {
        let row = &source["data"][item.id.to_string()];
        assert!(row.is_object(), "Riot source missing {}", item.id);
        let expected = row.get("maps").and_then(|maps| maps.get("10"))
            .map(|value| value.as_bool().unwrap()).unwrap_or(default);
        assert_eq!(shop::map10_available(item.id), Some(expected), "item {}", item.id);
        if expected { allowed += 1; } else { denied.push(item.id); }
    }
    denied.sort_unstable();
    assert_eq!(allowed, 31);
    assert_eq!(denied, vec![1038, 1058]);
    assert_eq!(shop::map10_available(1055), Some(true));
}

#[test]
fn both_excluded_items_are_rejected_atomically_with_sufficient_gold_and_empty_or_full_inventory() {
    for item_id in [1038, 1058] {
        for full in [false, true] {
            let (mut simulation, garen) = game();
            // Explicit authoritative fixtures isolate map admission from price/space.
            let champion = simulation.players.get_mut(&garen).unwrap();
            champion.gold = 10000.;
            if full {
                champion.inventory = [Some(1036); 6];
                champion.inventory_counts = [1; 6];
            }
            let before = serde_json::to_value(&simulation.players[&garen]).unwrap();
            let stats_before = simulation.stats(garen);
            let tick = simulation.tick;
            let rejection = simulation.command(garen, Action::Buy { item: item_id }).unwrap_err();
            assert_eq!(rejection, "item unavailable on Map10");
            assert_eq!(serde_json::to_value(&simulation.players[&garen]).unwrap(), before);
            assert_eq!(simulation.tick, tick);
            let after = simulation.stats(garen);
            assert_eq!(after.damage, stats_before.damage);
            assert_eq!(after.ability_power, stats_before.ability_power);
            assert_eq!(after.max_health, stats_before.max_health);
            assert_eq!(after.life_steal, stats_before.life_steal);
        }
    }
}

#[test]
fn all_31_admitted_items_still_buy_through_the_normal_map10_command_path() {
    for item in shop::catalog().iter().filter(|item| shop::map10_available(item.id) == Some(true)) {
        let (mut simulation, garen) = game();
        simulation.players.get_mut(&garen).unwrap().gold = 10000.;
        simulation.command(garen, Action::Buy { item: item.id }).unwrap();
        assert!(simulation.players[&garen].inventory.contains(&Some(item.id)), "item {}", item.id);
        assert_eq!(simulation.players[&garen].gold, 10000. - item.price);
    }
}

#[test]
fn global_definitions_and_existing_excluded_inventory_keep_stats_swap_and_sale() {
    for item_id in [1038, 1058] {
        let item = shop::catalog().iter().find(|item| item.id == item_id).unwrap();
        let (mut simulation, garen) = game();
        let base = simulation.stats(garen);
        let champion = simulation.players.get_mut(&garen).unwrap();
        // A retained legacy inventory is not authorized for a new acquisition.
        champion.gold = 0.;
        champion.inventory[0] = Some(item_id);
        champion.inventory_counts[0] = 1;
        assert_eq!(simulation.stats(garen).damage, base.damage + item.bonuses.damage);
        assert_eq!(simulation.stats(garen).ability_power, base.ability_power + item.bonuses.ability_power);
        simulation.command(garen, Action::SwapItems { from: 0, to: 5 }).unwrap();
        assert_eq!(simulation.players[&garen].inventory[5], Some(item_id));
        simulation.command(garen, Action::Sell { slot: 5 }).unwrap();
        assert_eq!(simulation.players[&garen].gold, item.sell_price.unwrap());
        assert_eq!(simulation.players[&garen].inventory, [None; 6]);
        assert_eq!(simulation.stats(garen).damage, base.damage);
        assert_eq!(simulation.stats(garen).ability_power, base.ability_power);
    }
}

#[test]
fn missing_map_admission_is_unknown_and_never_invented_as_allowed() {
    assert_eq!(shop::map10_available(u32::MAX), None);
}
