//! Ordinary attack life steal. Historical edge cases and champion modifiers remain unqualified.
use crate::*;
impl Simulation {
    pub(crate) fn basic_attack_hit(
        &mut self,
        source: u32,
        target: u32,
        raw: f32,
    ) -> Result<damage::DamageOutcome, String> {
        let attacker = self.target_info(source).ok_or("unknown attack source")?;
        let enemy = self.target_info(target).ok_or("unknown attack target")?;
        if attacker.team == enemy.team {
            return Err("invalid enemy target".into());
        }
        let structure = self.units.get(&target).is_some_and(|u| u.kind.structure());
        let retaliation=if raw>0. {self.molten_retaliation(target,source)} else {None};
        let outcome = self.apply_damage(Some(source), target, raw, damage::DamageKind::Physical)?;
        if !structure && self.players.get(&source).is_some_and(|p| p.health > 0.) {
            let rate = self.stats(source).life_steal;
            let amount = outcome.post_mitigation * rate;
            if amount.is_finite() && amount > 0. {
                self.heal(Some(source),source,amount)?;
            }
        }
        if let Some(raw)=retaliation {let _=self.apply_damage(Some(target),source,raw,damage::DamageKind::Magical);}
        Ok(outcome)
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
        s.buy_item(a, 1053).unwrap();
        (s, a, b)
    }
    #[test]
    fn native_recipe_credits_sword_and_sale_removes_attack_and_lifesteal_stats() {
        let nav = Navigation::load(
            include_str!("../../../assets/maps/tt_navigation_grid.json"),
            include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin"),
        )
        .unwrap();
        let mut s = Simulation::new(nav).unwrap();
        let a = s.join("garen").unwrap();
        let ad = s.stats(a).damage;
        s.buy_item(a, 1036).unwrap();
        s.buy_item(a, 1053).unwrap();
        assert_eq!(s.players[&a].gold, 25.);
        assert_eq!(s.players[&a].inventory[0], Some(1053));
        assert!(s.players[&a].inventory[1].is_none());
        assert_eq!(s.stats(a).damage, ad + 10.);
        assert!((s.stats(a).life_steal - 0.08).abs() < 0.00001);
        s.sell_item(a, 0).unwrap();
        assert_eq!(s.players[&a].gold, 585.);
        assert_eq!(s.stats(a).damage, ad);
        assert_eq!(s.stats(a).life_steal, 0.);
    }
    #[test]
    fn ordinary_attack_heals_from_mitigated_damage_without_overheal() {
        let (mut s, a, b) = game();
        s.apply_damage(None, a, 100., damage::DamageKind::True)
            .unwrap();
        let hp = s.players[&a].health;
        let outcome = s.basic_attack_hit(a, b, 100.).unwrap();
        assert!(outcome.post_mitigation < 100.);
        assert!((s.players[&a].health - hp - outcome.post_mitigation * 0.08).abs() < 0.001);
        s.players.get_mut(&a).unwrap().health = s.players[&a].max_health - 1.;
        s.basic_attack_hit(a, b, 100.).unwrap();
        assert_eq!(s.players[&a].health, s.players[&a].max_health);
    }
    #[test]
    fn direct_spell_damage_of_any_type_does_not_trigger_lifesteal() {
        let (mut s, a, b) = game();
        s.apply_damage(None, a, 100., damage::DamageKind::True)
            .unwrap();
        let hp = s.players[&a].health;
        for kind in [
            damage::DamageKind::Physical,
            damage::DamageKind::Magical,
            damage::DamageKind::True,
        ] {
            s.apply_damage(Some(a), b, 20., kind).unwrap();
            assert_eq!(s.players[&a].health, hp);
        }
    }
    #[test]
    fn shield_and_overkill_heal_basis_follow_explicit_community_contract() {
        let (mut s, a, b) = game();
        s.apply_damage(None, a, 100., damage::DamageKind::True)
            .unwrap();
        s.grant_shield(b, "fixture", 1000., 90).unwrap();
        let hp = s.players[&a].health;
        let enemy_hp = s.players[&b].health;
        let shielded = s.basic_attack_hit(a, b, 100.).unwrap();
        assert_eq!(shielded.health_removed, 0.);
        assert_eq!(s.players[&b].health, enemy_hp);
        assert!((s.players[&a].health - hp - shielded.post_mitigation * 0.08).abs() < 0.001);
        s.players.get_mut(&b).unwrap().shields.clear();
        s.players.get_mut(&b).unwrap().health = 1.;
        let hp = s.players[&a].health;
        let lethal = s.basic_attack_hit(a, b, 100.).unwrap();
        assert_eq!(lethal.health_removed, 1.);
        assert!(lethal.post_mitigation > 1.);
        assert!((s.players[&a].health - hp - lethal.post_mitigation * 0.08).abs() < 0.001);
    }
    #[test]
    fn released_attack_from_dead_shooter_deals_damage_without_revival() {
        let (mut s, a, b) = game();
        s.apply_damage(None, a, 100000., damage::DamageKind::True)
            .unwrap();
        let hp = s.players[&b].health;
        s.basic_attack_hit(a, b, 100.).unwrap();
        assert!(s.players[&b].health < hp);
        assert_eq!(s.players[&a].health, 0.);
        assert!(s.players[&a].respawn_at.is_some());
    }
    #[test]
    fn missing_dead_and_friendly_targets_cannot_grant_healing() {
        let (mut s, a, b) = game();
        s.apply_damage(None, a, 100., damage::DamageKind::True)
            .unwrap();
        let hp = s.players[&a].health;
        let c = s.join("garen").unwrap();
        assert!(s.basic_attack_hit(a, c, 100.).is_err());
        assert!(s.basic_attack_hit(a, 999999, 100.).is_err());
        s.apply_damage(None, b, 100000., damage::DamageKind::True)
            .unwrap();
        assert!(s.basic_attack_hit(a, b, 100.).is_err());
        assert_eq!(s.players[&a].health, hp);
    }
}
