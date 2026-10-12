//! Perseverance: Riot-authored 4.17 tier changes and native 4.20 dynamic tooltip.
//! Shielded-hit policy, unknown environmental sources and exact native tick behavior remain reconstructed.
use crate::*;
use std::sync::OnceLock;
#[derive(Deserialize)]
struct Tier {
    level: u8,
    cooldown_seconds: u64,
    max_health_per_second: f32,
}
#[derive(Deserialize)]
struct Rules {
    tiers: Vec<Tier>,
}
fn tier(level: u8) -> &'static Tier {
    static DATA: OnceLock<Rules> = OnceLock::new();
    DATA.get_or_init(|| {
        serde_json::from_str(include_str!("../../../data/4.20/garen_passive_rules.json")).unwrap()
    })
    .tiers
    .iter()
    .rev()
    .find(|r| level >= r.level)
    .unwrap()
}
impl Simulation {
    pub fn garen_passive_per_second(&self, id: u32) -> f32 {
        let Some(p) = self.players.get(&id) else {
            return 0.;
        };
        if p.champion != "garen" || p.health <= 0. || self.winner.is_some() {
            return 0.;
        }
        let rule = tier(p.level);
        if p.perseverance_interrupted_at
            .is_some_and(|at| self.tick.saturating_sub(at) < rule.cooldown_seconds * TICK_RATE)
        {
            return 0.;
        }
        p.max_health * rule.max_health_per_second
    }
    pub(crate) fn note_garen_damage(&mut self, target: u32, source: Option<u32>) {
        let Some(p) = self.players.get(&target) else {
            return;
        };
        if p.champion != "garen" {
            return;
        }
        if let Some(attacker) = source.and_then(|id| self.players.get(&id)) {
            if attacker.team == p.team {
                return;
            }
        }
        if let Some(unit) = source.and_then(|id| self.units.get(&id)) {
            if unit.team == p.team
                || unit.kind.lane()
                || (p.level >= 11 && unit.kind == world::Kind::Monster)
            {
                return;
            }
        }
        self.players
            .get_mut(&target)
            .unwrap()
            .perseverance_interrupted_at = Some(self.tick);
    }
    /// Explicit server event for non-damaging enemy ability hits; no client action grants this authority.
    pub fn record_enemy_ability_hit(&mut self, target: u32) -> Result<(), String> {
        if self.winner.is_some() {
            return Err("match ended".into());
        }
        let p = self
            .players
            .get_mut(&target)
            .ok_or("unknown ability target")?;
        if p.health <= 0. {
            return Err("ability target dead".into());
        }
        if p.champion == "garen" {
            p.perseverance_interrupted_at = Some(self.tick);
        }
        Ok(())
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
        let pos = s
            .navigation
            .nearest_walkable(Point { x: 7700., z: 7000. })
            .unwrap();
        for id in [a, b] {
            s.players.get_mut(&id).unwrap().position = pos;
        }
        (s, a, b)
    }
    #[test]
    fn tiers_use_current_max_health_and_exact_cooldown_boundary() {
        let (mut s, a, b) = game();
        for (level, wait, rate) in [(1, 270, 0.004), (11, 180, 0.008), (16, 120, 0.02)] {
            s.players.get_mut(&a).unwrap().level = level;
            s.tick = 1000;
            s.apply_damage(Some(b), a, 10., damage::DamageKind::True)
                .unwrap();
            assert_eq!(s.garen_passive_per_second(a), 0.);
            s.tick = 1000 + wait - 1;
            assert_eq!(s.garen_passive_per_second(a), 0.);
            s.tick += 1;
            assert!(
                (s.garen_passive_per_second(a) - s.players[&a].max_health * rate).abs() < 0.0001
            );
        }
    }
    #[test]
    fn lane_minions_never_interrupt_and_ordinary_monsters_stop_only_before_eleven() {
        let (mut s, a, _) = game();
        let pos = s.players[&a].position;
        let minion = s
            .spawn_unit("Red_Minion_Basic", "lane", 1, pos, 0., 0., None, None)
            .unwrap();
        s.apply_damage(Some(minion), a, 10., damage::DamageKind::True)
            .unwrap();
        assert!(s.players[&a].perseverance_interrupted_at.is_none());
        let monster = s
            .spawn_unit("TT_NGolem", "camp", 2, pos, 0., 0., None, None)
            .unwrap();
        s.apply_damage(Some(monster), a, 10., damage::DamageKind::True)
            .unwrap();
        assert_eq!(s.players[&a].perseverance_interrupted_at, Some(0));
        s.tick = 30;
        s.players.get_mut(&a).unwrap().level = 11;
        s.apply_damage(Some(monster), a, 10., damage::DamageKind::True)
            .unwrap();
        assert_eq!(s.players[&a].perseverance_interrupted_at, Some(0));
        let boss = s
            .spawn_unit("TT_Spiderboss", "epic", 2, pos, 0., 0., None, None)
            .unwrap();
        s.apply_damage(Some(boss), a, 10., damage::DamageKind::True)
            .unwrap();
        assert_eq!(s.players[&a].perseverance_interrupted_at, Some(30));
    }
    #[test]
    fn blocked_damage_does_not_interrupt_but_shielded_enemy_hit_and_enemy_ability_do() {
        let (mut s, a, b) = game();
        s.apply_damage(Some(b), a, 0., damage::DamageKind::True)
            .unwrap();
        assert!(s.players[&a].perseverance_interrupted_at.is_none());
        s.grant_shield(a, "fixture", 100., 90).unwrap();
        s.apply_damage(Some(b), a, 10., damage::DamageKind::True)
            .unwrap();
        assert_eq!(s.players[&a].perseverance_interrupted_at, Some(0));
        s.tick = 100;
        s.record_enemy_ability_hit(a).unwrap();
        assert_eq!(s.players[&a].perseverance_interrupted_at, Some(100));
        assert!(s.record_enemy_ability_hit(999999).is_err());
    }
    #[test]
    fn initial_passive_adds_to_base_regeneration_and_never_revives_or_runs_after_match_end() {
        let (mut s, a, _) = game();
        s.players.get_mut(&a).unwrap().health = 100.;
        let expected =
            s.regeneration_rates(a).unwrap().health_per_second + s.players[&a].max_health * 0.004;
        for _ in 0..30 {
            s.advance();
        }
        assert!((s.players[&a].health - 100. - expected).abs() < 0.003);
        s.apply_damage(None, a, 100000., damage::DamageKind::True)
            .unwrap();
        assert_eq!(s.garen_passive_per_second(a), 0.);
        assert!(s.record_enemy_ability_hit(a).is_err());
        s.players.get_mut(&a).unwrap().health = 100.;
        s.winner = Some(0);
        assert_eq!(s.garen_passive_per_second(a), 0.);
    }
}
