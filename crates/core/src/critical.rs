//! Native critical numeric values. SplitMix64 sampling is reconstructed, not Riot streak correction.
use crate::*;
use std::sync::OnceLock;
#[derive(Deserialize)]
pub(crate) struct Profile {
    pub chance: f32,
    pub chance_growth: f32,
    pub multiplier: f32,
    #[serde(flatten)]
    pub attack: attacks::Profile,
}
pub(crate) fn profile(champion: &str) -> &'static Profile {
    static DATA: OnceLock<BTreeMap<String, Profile>> = OnceLock::new();
    &DATA.get_or_init(|| {
        serde_json::from_str(include_str!("../../../data/4.20/critical_contracts.json")).unwrap()
    })[champion]
}
impl Simulation {
    pub(crate) fn roll_critical(&mut self, chance: f32) -> bool {
        if !chance.is_finite() || chance <= 0. {
            return false;
        }
        if chance >= 1. {
            return true;
        }
        if self.critical_rng == 0 {
            self.critical_rng = self.session ^ 0x243f6a8885a308d3;
        }
        self.critical_rng = self.critical_rng.wrapping_add(0x9e3779b97f4a7c15);
        let mut value = self.critical_rng;
        value = (value ^ (value >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
        value = (value ^ (value >> 27)).wrapping_mul(0x94d049bb133111eb);
        value ^= value >> 31;
        let sample = (value >> 40) as f64 / 16777216.;
        sample < chance as f64
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn game() -> (Simulation, u32, u32) {
        let nav = Navigation::load(
            include_str!("../../../assets/maps/tt_navigation_grid.json"),
            include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin"),
        )
        .unwrap();
        let mut s = Simulation::new(nav).unwrap();
        s.enable_map10().unwrap();
        let a = s.join("garen").unwrap();
        let b = s.join("garen").unwrap();
        (s, a, b)
    }
    #[test]
    fn native_crit_components_stack_sell_and_cap_without_changing_base_damage() {
        let (mut s, a, _) = game();
        let ad = s.stats(a).damage;
        s.buy_item(a, 1051).unwrap();
        s.buy_item(a, 1051).unwrap();
        assert_eq!(s.players[&a].gold, 25.);
        assert!((s.stats(a).critical_chance - 0.16).abs() < 0.00001);
        assert_eq!(s.stats(a).critical_multiplier, 2.);
        assert_eq!(s.stats(a).damage, ad);
        s.sell_item(a, 0).unwrap();
        assert!((s.stats(a).critical_chance - 0.08).abs() < 0.00001);
        s.players.get_mut(&a).unwrap().inventory = [Some(1018); 6];
        assert!((s.stats(a).critical_chance - 0.9).abs() < 0.00001);
        s.players.get_mut(&a).unwrap().inventory = [None; 6];
        assert_eq!(s.stats(a).critical_chance, 0.);
    }
    #[test]
    fn critical_roll_rejects_invalid_inputs_and_zero_and_one_are_exact() {
        let (mut s, _, _) = game();
        for chance in [f32::NAN, f32::INFINITY, -1., 0.] {
            assert!(!s.roll_critical(chance));
        }
        assert!(s.roll_critical(1.));
        assert!(s.roll_critical(2.));
    }
    #[test]
    fn cancelled_windup_preserves_roll_and_does_not_draw_again() {
        let (mut s, a, b) = game();
        s.buy_item(a, 1051).unwrap();
        let position = s.players[&a].position;
        s.players.get_mut(&b).unwrap().position = Point {
            x: position.x + 50.,
            z: position.z,
        };
        s.command(a, Action::Attack { target: b }).unwrap();
        s.advance();
        let critical = s.players[&a].windup.as_ref().unwrap().critical;
        let rng = s.critical_rng;
        s.command(a, Action::Stop).unwrap();
        s.command(a, Action::Attack { target: b }).unwrap();
        s.advance();
        assert_eq!(s.players[&a].windup.as_ref().unwrap().critical, critical);
        assert_eq!(s.critical_rng, rng);
    }
    #[test]
    fn critical_damage_is_doubled_before_armor_and_cannot_damage_during_windup() {
        let (mut s, a, b) = game(); // Move both away from either fountain; this fixture injects the attack outcome only.
        let position = s
            .navigation
            .nearest_walkable(Point { x: 7700., z: 7000. })
            .unwrap();
        s.players.get_mut(&a).unwrap().position = position;
        s.players.get_mut(&b).unwrap().position = position;
        s.players.get_mut(&a).unwrap().attack_roll = Some(true);
        let hp = s.players[&b].health;
        let armor = s.stats(b).armor;
        let ad = s.stats(a).damage;
        s.command(a, Action::Attack { target: b }).unwrap();
        s.advance();
        let windup = s.players[&a].windup.clone().unwrap();
        assert!(windup.critical);
        assert_eq!(s.players[&b].health, hp);
        while s.tick < windup.release {
            s.advance();
        }
        assert!((hp - s.players[&b].health - ad * 2. * 100. / (100. + armor)).abs() < 0.001);
        assert!(s.players[&a].attack_roll.is_none());
    }
    #[test]
    fn death_discards_saved_critical_roll() {
        let (mut s, a, _) = game();
        s.players.get_mut(&a).unwrap().attack_roll = Some(true);
        s.apply_damage(None, a, 100000., damage::DamageKind::True)
            .unwrap();
        assert!(s.players[&a].attack_roll.is_none());
    }
}
