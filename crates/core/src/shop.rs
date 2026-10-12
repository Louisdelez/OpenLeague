//! Native component values. Full catalog/effects and reconstructed shop rules remain open.
use crate::*;
use std::sync::OnceLock;
#[derive(Clone, Deserialize)]
pub struct Item {
    pub id: u32,
    pub price: f32,
    pub recipe: Vec<u32>,
    pub name: String,
    pub description: String,
    #[serde(flatten)]
    pub bonuses: Bonuses,
    #[serde(default)]
    pub group: String,
    pub sell_multiplier: f32,
    #[serde(default)]
    pub sell_price: Option<f32>,
    #[serde(default)]
    pub unique_penetration: bool,
    #[serde(default)]
    pub max_stack: u8,
    #[serde(default)]
    pub consumable: Option<consumables::Definition>,
}
#[derive(Deserialize)]
struct ShopPoint {
    point: Point,
}
#[derive(Deserialize)]
struct Config {
    starting_gold: f32,
    shops: Vec<ShopPoint>,
    shop_radius: f32,
    items: Vec<Item>,
}
fn config() -> &'static Config {
    static CONFIG: OnceLock<Config> = OnceLock::new();
    CONFIG.get_or_init(|| {
        serde_json::from_str(include_str!("../../../data/4.20/shop_foundation.json"))
            .expect("verified shop values")
    })
}
pub fn starting_gold() -> f32 {
    config().starting_gold
}
pub fn catalog() -> &'static [Item] {
    &config().items
}
fn item(id: u32) -> Option<&'static Item> {
    catalog().iter().find(|i| i.id == id)
}
#[derive(Debug)]
pub struct Purchase {
    pub cost: f32,
    pub inventory: [Option<u32>; 6],
    pub consumed: Vec<usize>,
    pub counts: [u8; 6],
}
pub fn quote(inventory: &[Option<u32>; 6], target: u32) -> Result<Purchase, String> {
    quote_with_counts(inventory, &inventory.map(|i|u8::from(i.is_some())), target)
}
pub fn inventory_count(p:&Champion,slot:usize)->u8 {
 if p.inventory.get(slot).copied().flatten().is_some() {p.inventory_counts[slot].max(1)} else {0}
}
pub fn quote_with_counts(inventory:&[Option<u32>;6],counts:&[u8;6],target:u32)->Result<Purchase,String> {
 let data=item(target).ok_or("item behavior not implemented")?;
 if data.consumable.is_some() {
  let owned:u32=inventory.iter().enumerate().filter(|(_,id)|**id==Some(target)).map(|(i,_)|u32::from(counts[i].max(1))).sum();
  if owned>=u32::from(data.max_stack) {return Err("item stack limit reached".into());}
  let slot=inventory.iter().position(|id|*id==Some(target)).or_else(||inventory.iter().position(Option::is_none)).ok_or("inventory full")?;
  let mut result=*inventory;let mut next=*counts;next[slot]=if result[slot].is_some() {next[slot].max(1)+1} else {1};result[slot]=Some(target);
  return Ok(Purchase {cost:data.price,inventory:result,counts:next,consumed:Vec::new()});
 }
 let mut plan=plan_in(catalog(),inventory,target)?;
 for i in 0..6 {plan.counts[i]=if plan.inventory[i].is_none() {0} else if plan.inventory[i]==inventory[i] {counts[i].max(1)} else {1};}
 Ok(plan)
}

fn plan_in(items: &[Item], inventory: &[Option<u32>; 6], target: u32) -> Result<Purchase, String> {
    fn find(items: &[Item], id: u32) -> Result<&Item, String> {
        items
            .iter()
            .find(|i| i.id == id)
            .ok_or_else(|| "item behavior not implemented".into())
    }
    fn validate(
        items: &[Item],
        id: u32,
        path: &mut Vec<u32>,
        budget: &mut usize,
    ) -> Result<(), String> {
        if path.contains(&id) || path.len() > 32 || *budget == 0 {
            return Err("invalid recipe graph".into());
        }
        *budget -= 1;
        let data = find(items, id)?;
        if !data.price.is_finite() || data.price < 0. {
            return Err("invalid recipe price".into());
        }
        path.push(id);
        let mut parts = 0.;
        for child in &data.recipe {
            validate(items, *child, path, budget)?;
            parts += find(items, *child)?.price;
        }
        path.pop();
        if parts > data.price + 0.001 {
            return Err("invalid recipe price".into());
        }
        Ok(())
    }
    fn credit(
        items: &[Item],
        id: u32,
        inventory: &mut [Option<u32>; 6],
        consumed: &mut Vec<usize>,
    ) -> Result<f32, String> {
        let data = find(items, id)?;
        if let Some(slot) = inventory.iter().position(|i| *i == Some(id)) {
            inventory[slot] = None;
            consumed.push(slot);
            return Ok(data.price);
        }
        let mut total = 0.;
        for child in &data.recipe {
            total += credit(items, *child, inventory, consumed)?;
        }
        Ok(total)
    }
    validate(items, target, &mut Vec::new(), &mut 2048)?;
    let data = find(items, target)?;
    let mut remaining = *inventory;
    let mut consumed = Vec::new();
    let mut cost = data.price;
    for child in &data.recipe {
        cost -= credit(items, *child, &mut remaining, &mut consumed)?;
    }
    if !cost.is_finite() || cost < 0. {
        return Err("invalid recipe price".into());
    }
    let slot = remaining
        .iter()
        .position(Option::is_none)
        .ok_or("inventory full")?;
    remaining[slot] = Some(target);
    Ok(Purchase {
        cost,
        inventory: remaining,
        counts: remaining.map(|i|u8::from(i.is_some())),
        consumed,
    })
}
/// Base native rates for active-item tooltips; does not include item/passive sustain bonuses.
pub fn regeneration_tooltip(champion: &str, level: u8, item_id: u32) -> Option<f32> {
    let data = item(item_id)?;
    static GROWTH: OnceLock<BTreeMap<String, progression::Growth>> = OnceLock::new();
    let g = GROWTH
        .get_or_init(|| {
            serde_json::from_str(include_str!("../../../data/4.20/champion_growth_420.json"))
                .unwrap()
        })
        .get(champion)?;
    let f = progression::growth_total(level);
    let rate = if data.bonuses.health_regen_percent > 0. {
        (g.health_regen + g.health_regen_growth * f) * data.bonuses.health_regen_percent
    } else if lifecycle::uses_mana(champion) {
        (g.mana_regen + g.mana_regen_growth * f) * data.bonuses.mana_regen_percent
    } else {
        0.
    };
    Some((rate * 5.).round())
}
#[derive(Debug, Clone, Copy, Default, Deserialize)]
#[serde(default)]
pub struct Bonuses {
    pub damage: f32,
    pub ability_power: f32,
    pub cooldown_reduction: f32,
    pub armor_penetration: f32,
    pub armor_penetration_percent: f32,
    pub magic_penetration: f32,
    pub magic_penetration_percent: f32,
    pub armor: f32,
    pub magic_resist: f32,
    pub health: f32,
    pub mana: f32,
    pub health_regen_percent: f32,
    pub mana_regen_percent: f32,
    pub attack_speed: f32,
    pub move_speed: f32,
    pub critical_chance: f32,
    pub critical_damage: f32,
    pub life_steal: f32,
}
pub(crate) fn bonuses(p: &Champion) -> Bonuses {
    let mut unique_cooldowns = std::collections::BTreeSet::new();
    p.inventory
        .iter()
        .flatten()
        .filter_map(|id| item(*id))
        .fold(Bonuses::default(), |mut b, i| {
            let v = i.bonuses;
            b.damage += v.damage;
            b.ability_power += v.ability_power;
            let first = unique_cooldowns.insert(i.id);
            if first { b.cooldown_reduction += v.cooldown_reduction; }
            if first || !i.unique_penetration {
                b.armor_penetration += v.armor_penetration;
                b.magic_penetration += v.magic_penetration;
                b.armor_penetration_percent = 1.-(1.-b.armor_penetration_percent)*(1.-v.armor_penetration_percent);
                b.magic_penetration_percent = 1.-(1.-b.magic_penetration_percent)*(1.-v.magic_penetration_percent);
            }
            b.armor += v.armor;
            b.magic_resist += v.magic_resist;
            b.health += v.health;
            b.mana += v.mana;
            b.health_regen_percent += v.health_regen_percent;
            b.mana_regen_percent += v.mana_regen_percent;
            b.attack_speed += v.attack_speed;
            b.move_speed += v.move_speed;
            b.critical_chance += v.critical_chance;
            b.critical_damage += v.critical_damage;
            b.life_steal += v.life_steal;
            b
        })
}
impl Simulation {
    fn shop_guard(&self, id: u32) -> Result<(), String> {
        if self.winner.is_some() {
            return Err("match ended".into());
        }
        let p = self.players.get(&id).ok_or("unknown player")?;
        if p.health <= 0. {
            return Err("champion dead".into());
        }
        if p.position.distance(config().shops[p.team as usize].point) > config().shop_radius {
            return Err("outside allied shop".into());
        }
        Ok(())
    }
    pub fn buy_item(&mut self, id: u32, item_id: u32) -> Result<(), String> {
        self.shop_guard(id)?;
        let data = item(item_id).ok_or("item behavior not implemented")?;
        if !data.group.is_empty()
            && self.players[&id]
                .inventory
                .iter()
                .flatten()
                .filter_map(|i| item(*i))
                .any(|i| i.group == data.group && !data.recipe.contains(&i.id))
        {
            return Err("item group already owned".into());
        }
        let plan = quote_with_counts(&self.players[&id].inventory, &self.players[&id].inventory_counts, item_id)?;
        if self.players[&id].gold < plan.cost {
            return Err("insufficient gold".into());
        }
        let p = self.players.get_mut(&id).unwrap();
        p.gold -= plan.cost;
        p.inventory = plan.inventory;
        p.inventory_counts = plan.counts;
        self.refresh_item_caps(id);
        Ok(())
    }
    pub fn sell_item(&mut self, id: u32, slot: u8) -> Result<(), String> {
        self.shop_guard(id)?;
        let slot = slot as usize;
        let p = &self.players[&id];
        let item_id = p
            .inventory
            .get(slot)
            .ok_or("invalid inventory slot")?
            .ok_or("empty inventory slot")?;
        let data = item(item_id).ok_or("item behavior not implemented")?;
        let refund = data.sell_price.ok_or("item sale value not qualified")?;
        if !refund.is_finite() || refund < 0. { return Err("invalid item sale value".into()); }
        let p = self.players.get_mut(&id).unwrap();
        let quantity = p.inventory_counts[slot].max(1);
        p.inventory_counts[slot] = quantity-1;
        if quantity==1 {p.inventory[slot] = None;}
        p.gold += refund;
        self.refresh_item_caps(id);
        Ok(())
    }
    fn refresh_item_caps(&mut self, id: u32) {
        let stats = self.stats(id);
        let p = self.players.get_mut(&id).unwrap();
        // Supplied community Stats getters preserve absolute current pools and clamp to new caps.
        // Native purchase pool-adjustment semantics remain to qualify.
        p.max_health = stats.max_health;
        p.health = p.health.min(p.max_health);
        p.mana = p.mana.min(stats.max_mana);
    }
    /// Compare the complete raw state captured by the drag, then use the existing
    /// swap operation in this same exclusive Simulation command. No retries,
    /// normalization, price/stat changes, or partial updates on a mismatch.
    pub fn swap_items_checked(&mut self, id: u32, from: u8, to: u8,
        expected_inventory: [Option<u32>; 6], expected_counts: [u8; 6],
    ) -> Result<(), String> {
        if self.winner.is_some() { return Err("match ended".into()); }
        let p = self.players.get(&id).ok_or("unknown player")?;
        if from >= 6 || to >= 6 { return Err("invalid inventory slot".into()); }
        if p.inventory != expected_inventory || p.inventory_counts != expected_counts {
            return Err("inventory changed".into());
        }
        self.swap_items(id, from, to)
    }
    pub fn swap_items(&mut self, id: u32, from: u8, to: u8) -> Result<(), String> {
        if self.winner.is_some() {
            return Err("match ended".into());
        }
        let p = self.players.get_mut(&id).ok_or("unknown player")?;
        if from >= 6 || to >= 6 {
            return Err("invalid inventory slot".into());
        }
        p.inventory.swap(from as usize, to as usize);
        p.inventory_counts.swap(from as usize, to as usize);
        Ok(())
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn game() -> (Simulation, u32) {
        let nav = Navigation::load(
            include_str!("../../../assets/maps/tt_navigation_grid.json"),
            include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin"),
        )
        .unwrap();
        let mut s = Simulation::new(nav).unwrap();
        s.enable_map10().unwrap();
        let id = s.join("garen").unwrap();
        (s, id)
    }
    #[test]
    fn native_start_and_buy_apply_to_combat_stats() {
        let (mut s, id) = game();
        assert_eq!(s.players[&id].gold, 825.);
        let damage = s.stats(id).damage;
        s.command(id, Action::Buy { item: 1036 }).unwrap();
        assert_eq!(s.players[&id].gold, 465.);
        assert_eq!(s.stats(id).damage, damage + 10.);
        s.buy_item(id, 1029).unwrap();
        assert_eq!(s.players[&id].gold, 165.);
        assert_eq!(s.stats(id).armor, s.definitions["garen"].armor + 15.);
    }
    #[test]
    fn unaffordable_recipe_preserves_components_and_gold() {
        let (mut s, id) = game();
        s.buy_item(id, 1029).unwrap();
        s.buy_item(id, 1036).unwrap();
        let before = s.players[&id].clone();
        assert!(s.buy_item(id, 1031).unwrap_err().contains("gold"));
        assert_eq!(s.players[&id].inventory, before.inventory);
        assert_eq!(s.players[&id].gold, before.gold);
    }
    #[test]
    fn recipe_consumes_once_and_replaces_stats() {
        let (mut s, id) = game();
        s.buy_item(id, 1029).unwrap();
        s.buy_item(id, 1031).unwrap();
        assert_eq!(s.players[&id].gold, 75.);
        assert_eq!(
            s.players[&id].inventory,
            [Some(1031), None, None, None, None, None]
        );
        assert_eq!(s.stats(id).armor, s.definitions["garen"].armor + 40.);
    }
    #[test]
    fn sale_and_swap_preserve_item_identity_and_remove_stats() {
        let (mut s, id) = game();
        s.buy_item(id, 1036).unwrap();
        s.swap_items(id, 0, 5).unwrap();
        assert_eq!(s.players[&id].inventory[5], Some(1036));
        s.sell_item(id, 5).unwrap();
        assert_eq!(s.players[&id].gold, 717.);
        assert_eq!(s.stats(id).damage, s.definitions["garen"].attack_damage);
        let gold = s.players[&id].gold;
        assert!(s.sell_item(id, 5).is_err());
        assert!(s.swap_items(id, 6, 0).is_err());
        assert_eq!(s.players[&id].gold, gold);
    }
    #[test]
    fn full_inventory_buy_is_atomic_and_recipe_can_reuse_slot() {
        let (mut s, id) = game();
        s.players.get_mut(&id).unwrap().inventory = [Some(1029); 6];
        s.players.get_mut(&id).unwrap().gold = 1000.;
        assert!(s.buy_item(id, 1036).unwrap_err().contains("full"));
        assert_eq!(s.players[&id].gold, 1000.);
        s.buy_item(id, 1031).unwrap();
        assert_eq!(s.players[&id].gold, 550.);
        assert_eq!(
            s.players[&id]
                .inventory
                .iter()
                .filter(|i| **i == Some(1029))
                .count(),
            5
        );
    }
    #[test]
    fn enemy_shop_dead_unknown_and_ended_guards_prevent_mutation() {
        let (mut s, id) = game();
        let gold = s.players[&id].gold;
        assert!(s
            .buy_item(id, 1057)
            .unwrap_err()
            .contains("not implemented"));
        s.players.get_mut(&id).unwrap().position = config().shops[1].point;
        assert!(s.buy_item(id, 1036).unwrap_err().contains("shop"));
        s.players.get_mut(&id).unwrap().health = 0.;
        assert!(s.buy_item(id, 1036).unwrap_err().contains("dead"));
        s.winner = Some(0);
        assert!(s.buy_item(id, 1036).unwrap_err().contains("ended"));
        assert_eq!(s.players[&id].gold, gold);
    }
    #[test]
    fn health_pool_preserves_current_and_sale_clamps_without_revival() {
        let (mut s, id) = game();
        let hp = s.players[&id].health;
        let max = s.players[&id].max_health;
        s.buy_item(id, 1028).unwrap();
        assert_eq!(s.players[&id].max_health, max + 150.);
        assert_eq!(s.players[&id].health, hp);
        s.players.get_mut(&id).unwrap().health = max + 100.;
        s.sell_item(id, 0).unwrap();
        assert_eq!(s.players[&id].max_health, max);
        assert_eq!(s.players[&id].health, max);
    }
    #[test]
    fn mana_items_do_not_create_energy_or_manaless_resources() {
        let (mut s, _) = game();
        let ahri = s.join("ahri").unwrap();
        let akali = s.join("akali").unwrap();
        let mana = s.stats(ahri).max_mana;
        s.buy_item(ahri, 1027).unwrap();
        assert_eq!(s.stats(ahri).max_mana, mana + 200.);
        let energy = s.stats(akali).max_mana;
        s.buy_item(akali, 1027).unwrap();
        assert_eq!(s.stats(akali).max_mana, energy);
        s.buy_item(akali, 1004).unwrap();
        let base = s.growth["akali"].mana_regen;
        assert_eq!(
            s.regeneration_rates(akali).unwrap().resource_per_second,
            base
        );
        assert_eq!(s.players[&akali].mana, energy);
    }
    #[test]
    fn base_regeneration_percent_stacks_and_sale_removes_exact_modifier() {
        let (mut s, id) = game();
        let base = s.regeneration_rates(id).unwrap().health_per_second;
        s.buy_item(id, 1006).unwrap();
        s.buy_item(id, 1006).unwrap();
        assert!((s.regeneration_rates(id).unwrap().health_per_second - base * 2.).abs() < 0.00001);
        s.sell_item(id, 0).unwrap();
        assert!((s.regeneration_rates(id).unwrap().health_per_second - base * 1.5).abs() < 0.00001);
        s.award_experience(id, 500.).unwrap();
        let g = &s.growth["garen"];
        let grown = g.health_regen
            + g.health_regen_growth * progression::growth_total(s.players[&id].level);
        assert!(
            (s.regeneration_rates(id).unwrap().health_per_second - grown * 1.5).abs() < 0.00001
        );
    }
    #[test]
    fn boots_group_is_unique_and_dagger_changes_attack_cadence() {
        let (mut s, id) = game();
        let speed = s.stats(id).move_speed;
        let ticks = s.stats(id).attack_cooldown_ticks;
        s.buy_item(id, 1001).unwrap();
        assert_eq!(s.stats(id).move_speed, speed + 25.);
        assert!(s.buy_item(id, 1001).unwrap_err().contains("group"));
        assert_eq!(s.players[&id].gold, 500.);
        s.buy_item(id, 1042).unwrap();
        assert!(s.stats(id).attack_cooldown_ticks < ticks);
        s.sell_item(id, 0).unwrap();
        assert_eq!(s.stats(id).move_speed, speed);
        s.sell_item(id, 1).unwrap();
        assert_eq!(s.stats(id).attack_cooldown_ticks, ticks);
    }
    #[test]
    fn health_item_persists_through_level_gain_death_and_respawn() {
        let (mut s, id) = game();
        s.buy_item(id, 1028).unwrap();
        s.award_experience(id, 500.).unwrap();
        let max = s.stats(id).max_health;
        assert_eq!(s.players[&id].max_health, max);
        s.damage(id, 100000., false);
        s.tick = s.players[&id].respawn_at.unwrap();
        s.advance_respawns();
        assert_eq!(s.players[&id].health, max);
        assert_eq!(s.players[&id].inventory[0], Some(1028));
    }
    #[test]
    fn native_two_component_recipe_credits_both_and_does_not_double_stats() {
        let (mut s, id) = game();
        s.buy_item(id, 1028).unwrap();
        s.buy_item(id, 1006).unwrap();
        let plan = quote(&s.players[&id].inventory, 3801).unwrap();
        assert_eq!(plan.cost, 20.);
        assert_eq!(plan.consumed, vec![0, 1]);
        s.buy_item(id, 3801).unwrap();
        assert_eq!(s.players[&id].gold, 225.);
        assert_eq!(s.players[&id].inventory.iter().flatten().count(), 1);
        assert_eq!(s.stats(id).max_health, s.definitions["garen"].health + 200.);
        assert!((s.regeneration_rates(id).unwrap().health_per_second - 2.352).abs() < 0.00001);
    }
    #[test]
    fn nested_recipe_prefer_finished_child_and_never_consume_same_slot_twice() {
        let mut a = catalog()[0].clone();
        a.id = 9001;
        a.price = 10.;
        a.recipe = vec![];
        let mut b = a.clone();
        b.id = 9002;
        b.price = 30.;
        b.recipe = vec![9001, 9001];
        let mut c = a.clone();
        c.id = 9003;
        c.price = 80.;
        c.recipe = vec![9002, 9001];
        let items = vec![a, b, c];
        let inv = [Some(9002), Some(9001), Some(9001), None, None, None];
        let p = plan_in(&items, &inv, 9003).unwrap();
        assert_eq!(p.cost, 40.);
        assert_eq!(p.consumed, vec![0, 1]);
        assert_eq!(p.inventory[2], Some(9001));
        let p = plan_in(
            &items,
            &[Some(9001), Some(9001), None, None, None, None],
            9003,
        )
        .unwrap();
        assert_eq!(p.cost, 60.);
        assert_eq!(p.consumed, vec![0, 1]);
    }
    #[test]
    fn malformed_recipe_graphs_cannot_mutate_inventory() {
        let mut a = catalog()[0].clone();
        a.id = 9001;
        a.price = 10.;
        a.recipe = vec![9001];
        let inv = [Some(9001), None, None, None, None, None];
        assert!(plan_in(&[a.clone()], &inv, 9001)
            .unwrap_err()
            .contains("graph"));
        a.recipe = vec![9999];
        assert!(plan_in(&[a], &inv, 9001).is_err());
        assert_eq!(inv[0], Some(9001));
    }
    #[test]
    fn native_localized_catalog_and_regeneration_calculator_follow_level() {
        assert!(item(1006).unwrap().name.contains("rafra"));
        assert!(item(3801).unwrap().description.contains("50%"));
        assert_eq!(regeneration_tooltip("garen", 1, 1006), Some(4.));
        assert!(regeneration_tooltip("garen", 18, 1006).unwrap() > 4.);
        assert_eq!(regeneration_tooltip("akali", 1, 1004), Some(0.));
    }

    fn checked(s: &Simulation, id: u32, from: u8, to: u8) -> Action {
        let p = &s.players[&id];
        Action::SwapItemsChecked { from, to, expected_inventory: p.inventory, expected_counts: p.inventory_counts }
    }
    fn checked_game() -> (Simulation, u32) {
        let (mut s, id) = game();
        for item in [1001, 2003, 2003] { s.command(id, Action::Buy { item }).unwrap(); }
        (s, id)
    }
    fn player_json(s: &Simulation, id: u32) -> serde_json::Value {
        serde_json::to_value(&s.players[&id]).unwrap()
    }
    #[test]
    fn checked_swap_moves_items_and_raw_counts_without_other_player_mutation() {
        let (mut s, id) = checked_game();
        for (from, to) in [(1, 5), (5, 0)] {
            let mut expected = s.players[&id].clone();
            expected.inventory.swap(from, to); expected.inventory_counts.swap(from, to);
            let tick = s.tick;
            s.command(id, checked(&s, id, from as u8, to as u8)).unwrap();
            assert_eq!(player_json(&s, id), serde_json::to_value(expected).unwrap());
            assert_eq!(s.tick, tick);
        }
        assert_eq!(s.players[&id].inventory[0], Some(2003));
        assert_eq!(s.players[&id].inventory_counts[0], 2);
    }
    #[test]
    fn checked_swap_rejects_unseen_sale_and_replacement_atomically() {
        let (mut s, id) = checked_game();
        let captured = checked(&s, id, 0, 5);
        s.command(id, Action::Sell { slot: 0 }).unwrap();
        s.command(id, Action::Buy { item: 1036 }).unwrap();
        let before = player_json(&s, id);
        assert_eq!(s.command(id, captured).unwrap_err(), "inventory changed");
        assert_eq!(player_json(&s, id), before);
    }
    #[test]
    fn checked_swap_rejects_count_only_change_with_identical_item_array() {
        let (mut s, id) = checked_game();
        let captured = checked(&s, id, 1, 5);
        let inventory = s.players[&id].inventory;
        s.command(id, Action::Buy { item: 2003 }).unwrap();
        assert_eq!(s.players[&id].inventory, inventory);
        let before = player_json(&s, id);
        assert_eq!(s.command(id, captured).unwrap_err(), "inventory changed");
        assert_eq!(player_json(&s, id), before);
    }
    #[test]
    fn checked_swap_rejects_unrelated_slot_change_and_compares_raw_counts() {
        let (mut s, id) = checked_game();
        let captured = checked(&s, id, 1, 5);
        s.command(id, Action::Buy { item: 1004 }).unwrap();
        let before = player_json(&s, id);
        assert_eq!(s.command(id, captured).unwrap_err(), "inventory changed");
        assert_eq!(player_json(&s, id), before);
        // Explicit diagnostic state: two equal item IDs with distinct raw counts.
        // Neither item normalization nor comparing only the item IDs is sufficient.
        let p = s.players.get_mut(&id).unwrap();
        p.inventory = [Some(2003), Some(2003), None, None, None, None];
        p.inventory_counts = [1, 2, 0, 0, 0, 0];
        let captured = checked(&s, id, 0, 1);
        s.players.get_mut(&id).unwrap().inventory_counts.swap(0, 1);
        let before = player_json(&s, id);
        assert_eq!(s.command(id, captured).unwrap_err(), "inventory changed");
        assert_eq!(player_json(&s, id), before);
        let captured = checked(&s, id, 0, 1);
        s.command(id, captured).unwrap();
        assert_eq!(s.players[&id].inventory_counts, [1, 2, 0, 0, 0, 0]);
        let captured = checked(&s, id, 0, 1);
        s.players.get_mut(&id).unwrap().inventory_counts[0] = 0;
        assert_eq!(s.command(id, captured).unwrap_err(), "inventory changed");
    }
    #[test]
    fn checked_swap_keeps_bounds_death_end_and_unknown_player_guards() {
        let (mut s, id) = checked_game();
        for (from, to) in [(6, 0), (0, 6), (255, 255)] {
            let before = player_json(&s, id);
            assert_eq!(s.command(id, checked(&s, id, from, to)).unwrap_err(), "invalid inventory slot");
            assert_eq!(player_json(&s, id), before);
        }
        let action = checked(&s, id, 0, 5);
        assert_eq!(s.command(u32::MAX, action.clone()).unwrap_err(), "unknown player");
        s.players.get_mut(&id).unwrap().health = 0.;
        let before = player_json(&s, id);
        assert_eq!(s.command(id, action.clone()).unwrap_err(), "champion dead");
        assert_eq!(player_json(&s, id), before);
        s.winner = Some(1);
        assert_eq!(s.command(id, action).unwrap_err(), "match ended");
        assert_eq!(player_json(&s, id), before);
    }
    #[test]
    fn checked_swap_wire_is_bounded_and_legacy_packet_stays_identical() {
        let legacy = serde_json::json!({"Command":{"sequence":7,"action":{"SwapItems":{"from":0,"to":5}}}});
        let packet: ClientPacket = serde_json::from_value(legacy.clone()).unwrap();
        assert_eq!(serde_json::to_value(&packet).unwrap(), legacy);
        let (mut s, id) = checked_game();
        let ClientPacket::Command { action, .. } = packet else { panic!("Command") };
        s.command(id, action).unwrap(); assert_eq!(s.players[&id].inventory[5], Some(1001));
        let expected = serde_json::to_value(checked(&s, id, 1, 0)).unwrap();
        let encoded = serde_json::to_vec(&ClientPacket::Command { sequence:8, action:checked(&s,id,1,0) }).unwrap();
        assert!(encoded.len() < 1024); // Existing server UDP receive buffer is 4096 bytes.
        let ClientPacket::Command { action, sequence } = serde_json::from_slice(&encoded).unwrap() else { panic!("Command") };
        assert_eq!(sequence,8); assert_eq!(serde_json::to_value(action).unwrap(),expected);
        for malformed in 0..7 {
            let mut value = expected.clone(); let fields=&mut value["SwapItemsChecked"];
            match malformed {
                0 => { fields.as_object_mut().unwrap().remove("expected_inventory"); }
                1 => { fields["expected_inventory"].as_array_mut().unwrap().pop(); }
                2 => { fields["expected_counts"].as_array_mut().unwrap().push(serde_json::json!(0)); }
                3 => fields["expected_counts"][0]=serde_json::json!(256),
                4 => fields["from"]=serde_json::json!(256),
                5 => fields["expected_inventory"][0]=serde_json::json!(-1),
                6 => { fields.as_object_mut().unwrap().remove("expected_counts"); }
                _ => unreachable!(),
            }
            assert!(serde_json::from_value::<Action>(value).is_err());
        }
    }
}
