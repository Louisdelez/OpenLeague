//! Native 4.20 Exhaust values; policies not recovered from original server remain explicit.
use crate::*;
use std::sync::OnceLock;
#[derive(Deserialize)]
struct Rules {
    cooldown_seconds: f32,
    duration_seconds: f32,
    range: f32,
    slow_fraction: f32,
    attack_speed_bonus_penalty: f32,
    defense_reduction: f32,
    damage_reduction_fraction: f32,
}
fn rules() -> &'static Rules {
    static DATA: OnceLock<Rules> = OnceLock::new();
    DATA.get_or_init(|| {
        serde_json::from_str(include_str!("../../../data/4.20/exhaust_rules.json")).unwrap()
    })
}
pub fn range() -> f32 {
    rules().range
}
pub fn defense_reduction(p: &Champion, tick: u64) -> f32 {
    if tick < p.effects.exhaust_until {
        rules().defense_reduction
    } else {
        0.
    }
}
pub fn attack_speed_bonus_penalty(p: &Champion, tick: u64) -> f32 {
    if tick < p.effects.exhaust_until {
        rules().attack_speed_bonus_penalty
    } else {
        0.
    }
}
impl Simulation {
    pub(crate) fn exhaust_damage_multiplier(
        &self,
        source: Option<u32>,
        kind: damage::DamageKind,
    ) -> f32 {
        if kind == damage::DamageKind::True {
            return 1.;
        }
        if source
            .and_then(|id| self.players.get(&id))
            .is_some_and(|p| self.tick < p.effects.exhaust_until)
        {
            1. - rules().damage_reduction_fraction
        } else {
            1.
        }
    }
    pub(crate) fn cast_exhaust(
        &mut self,
        id: u32,
        slot: u8,
        target: Option<u32>,
    ) -> Result<(), String> {
        let r = rules();
        let target = target.ok_or("exhaust requires enemy champion target")?;
        let owner = &self.players[&id];
        let victim = self
            .players
            .get(&target)
            .ok_or("unknown exhaust champion")?;
        if victim.team == owner.team
            || victim.health <= 0.
            || owner.position.distance(victim.position) > r.range
        {
            return Err("invalid exhaust enemy".into());
        }
        if !self.visible_to(owner.team, target) {
            return Err("exhaust enemy hidden".into());
        }
        // Slow can be purged independently by native Garen Q; retain other debuff effects.
        self.grant_slow(
            target,
            "SummonerExhaustSlow",
            r.slow_fraction,
            spells::seconds(r.duration_seconds),
        )?;
        self.record_enemy_ability_hit(target)?;
        self.record_champion_contribution(id,target);
        self.players.get_mut(&target).unwrap().effects.exhaust_until =
            self.tick + spells::seconds(r.duration_seconds);
        self.players.get_mut(&id).unwrap().summoners.ready_at[slot as usize] =
            self.tick + spells::seconds(r.cooldown_seconds);
        Ok(())
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn game() -> (Simulation, u32, u32, u32) {
        let mut s = Simulation::new(
            Navigation::load(
                include_str!("../../../assets/maps/tt_navigation_grid.json"),
                include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin"),
            )
            .unwrap(),
        )
        .unwrap();
        s.enable_map10().unwrap();
        let a = s
            .join_with_summoners("garen", [Some(summoners::Spell::Exhaust), None])
            .unwrap();
        let b = s
            .join_with_summoners("garen", [Some(summoners::Spell::Exhaust), None])
            .unwrap();
        let c = s.join("garen").unwrap();
        let position = s
            .navigation
            .nearest_walkable(Point { x: 7700., z: 7000. })
            .unwrap();
        for id in [a, b, c] {
            s.players.get_mut(&id).unwrap().position = position;
        }
        (s, a, b, c)
    }
    #[test]
    fn four_native_effects_expire_without_health_resource_or_rank_changes() {
        let (mut s, a, b, _) = game();
        let before = s.stats(b);
        let health = s.players[&b].health;
        let mana = s.players[&a].mana;
        s.players.get_mut(&a).unwrap().effects.silence_until = 90;
        s.cast_summoner_on(a, 0, Some(b)).unwrap();
        let after = s.stats(b);
        assert!((after.move_speed - 241.5).abs() < 0.001);
        assert!((after.armor - before.armor + 10.).abs() < 0.001);
        assert!((after.magic_resist - before.magic_resist + 10.).abs() < 0.001);
        assert_eq!(
            after.attack_cooldown_ticks,
            ((before.attack_cooldown_ticks as f32 / 0.7).round() as u64).max(12)
        );
        assert_eq!(s.players[&b].effects.exhaust_until, 75);
        assert_eq!(s.players[&b].slows[0].expires_at, 75);
        assert_eq!(s.players[&b].perseverance_interrupted_at, Some(0));
        assert_eq!(s.players[&a].summoners.ready_at[0], 6300);
        assert_eq!(s.players[&a].mana, mana);
        assert_eq!(s.players[&b].health, health);
        s.tick = 75;
        assert_eq!(s.stats(b).armor, before.armor);
        assert_eq!(s.stats(b).move_speed, before.move_speed);
        assert_eq!(
            s.stats(b).attack_cooldown_ticks,
            before.attack_cooldown_ticks
        );
        assert_eq!(
            s.exhaust_damage_multiplier(Some(b), damage::DamageKind::Physical),
            1.
        );
    }
    #[test]
    fn invalid_targets_are_atomic_and_duplicate_loadouts_remain_rejected() {
        let (mut s, a, b, c) = game();
        for target in [None, Some(a), Some(c), Some(999999)] {
            assert!(s.cast_summoner_on(a, 0, target).is_err());
            assert_eq!(s.players[&a].summoners.ready_at[0], 0);
            assert!(s.players[&b].slows.is_empty());
            assert_eq!(s.players[&b].effects.exhaust_until, 0);
        }
        s.players.get_mut(&b).unwrap().position.x += 651.;
        assert!(s.cast_summoner_on(a, 0, Some(b)).is_err());
        s.players.get_mut(&b).unwrap().position = s.players[&a].position;
        s.players.get_mut(&b).unwrap().health = 0.;
        assert!(s.cast_summoner_on(a, 0, Some(b)).is_err());
        assert!(s
            .join_with_summoners("garen", [Some(summoners::Spell::Exhaust); 2])
            .is_err());
        s.winner = Some(0);
        assert!(s.cast_summoner_on(a, 0, Some(b)).is_err());
    }
    #[test]
    fn q_purges_only_slow_and_w_shortens_only_current_slow_control_contract() {
        let (mut s, a, b, _) = game();
        s.learn(b, 0).unwrap();
        s.cast_summoner_on(a, 0, Some(b)).unwrap();
        s.cast(b, 0, None).unwrap();
        assert!(s.players[&b].slows.is_empty());
        assert_eq!(s.players[&b].effects.exhaust_until, 75);
        assert!(
            (s.exhaust_damage_multiplier(Some(b), damage::DamageKind::Physical) - 0.6).abs()
                < 0.001
        );
        let (mut s, a, b, _) = game();
        s.learn(b, 1).unwrap();
        s.cast(b, 1, None).unwrap();
        s.cast_summoner_on(a, 0, Some(b)).unwrap();
        assert_eq!(s.players[&b].slows[0].expires_at, 53);
        assert_eq!(s.players[&b].effects.exhaust_until, 75);
    }
    #[test]
    fn outgoing_physical_magical_reduction_combines_with_w_shields_and_true_bypass() {
        let (mut s, a, b, _) = game();
        s.cast_summoner_on(a, 0, Some(b)).unwrap();
        for kind in [damage::DamageKind::Physical, damage::DamageKind::Magical] {
            let stats = s.stats(a);
            let expected =
                damage::mitigate(100. * 0.6, kind, stats.armor, stats.magic_resist, 1.).unwrap();
            let hit = s.apply_damage(Some(b), a, 100., kind).unwrap();
            assert!((hit.health_removed - expected).abs() < 0.001);
            assert_eq!(hit.raw, 100.);
        }
        s.learn(a, 1).unwrap();
        s.cast(a, 1, None).unwrap();
        s.grant_shield(a, "test", 100., 90).unwrap();
        let expected = damage::mitigate(
            100. * 0.6,
            damage::DamageKind::Physical,
            s.stats(a).armor,
            s.stats(a).magic_resist,
            0.7,
        )
        .unwrap();
        let hit = s
            .apply_damage(Some(b), a, 100., damage::DamageKind::Physical)
            .unwrap();
        assert!((hit.shield_absorbed - expected).abs() < 0.001);
        assert_eq!(hit.health_removed, 0.);
        let hit = s
            .apply_damage(Some(b), a, 100., damage::DamageKind::True)
            .unwrap();
        assert_eq!(hit.post_mitigation, 100.);
    }
    #[test]
    fn world_damage_uses_same_reduction_once_and_death_clears_status() {
        let (mut s, a, b, _) = game();
        s.tick = 2999;
        s.advance();
        s.cast_summoner_on(a, 0, Some(b)).unwrap();
        let mob = *s
            .units
            .iter()
            .find(|(_, u)| u.kind == world::Kind::Monster)
            .unwrap()
            .0;
        let u = &s.units[&mob];
        let expected = damage::mitigate(
            60.,
            damage::DamageKind::Physical,
            u.armor,
            u.magic_resist,
            1.,
        )
        .unwrap();
        let hit = s
            .apply_damage(Some(b), mob, 100., damage::DamageKind::Physical)
            .unwrap();
        assert!((hit.health_removed - expected).abs() < 0.001);
        assert!((hit.post_mitigation - expected).abs() < 0.001);
        s.apply_damage(None, b, 10000., damage::DamageKind::True)
            .unwrap();
        assert_eq!(s.players[&b].effects.exhaust_until, 0);
        assert!(s.players[&b].slows.is_empty());
    }
    #[test]
    fn refresh_does_not_stack_and_percentage_attack_speed_policy_accounts_for_items() {
        let (mut s, a, b, c) = game();
        s.players.get_mut(&c).unwrap().summoners.spells[0] = Some(summoners::Spell::Exhaust);
        s.players.get_mut(&b).unwrap().inventory[0] = Some(1042); // Fixture: Dagger stat, not a client currency grant.
        let base = s.definitions["garen"].attack_cooldown_ticks;
        s.cast_summoner_on(a, 0, Some(b)).unwrap();
        let armor = s.stats(b).armor;
        let items = shop::bonuses(&s.players[&b]);
        assert_eq!(
            s.stats(b).attack_cooldown_ticks,
            ((base as f32 / (1. + items.attack_speed - 0.3)).round() as u64).max(12)
        );
        s.tick = 10;
        s.cast_summoner_on(c, 0, Some(b)).unwrap();
        assert_eq!(s.players[&b].effects.exhaust_until, 85);
        assert_eq!(s.players[&b].slows.len(), 1);
        assert_eq!(s.stats(b).armor, armor);
        assert!(
            (s.exhaust_damage_multiplier(Some(b), damage::DamageKind::Magical) - 0.6).abs() < 0.001
        );
    }
}
