//! Timed champion slows and native Garen Q purge. Ordering/stacking still require historical qualification.
use crate::*;
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Slow {
    pub tag: String,
    pub fraction: f32,
    pub expires_at: u64,
}
pub fn strongest(p: &Champion, tick: u64) -> f32 {
    if p.health <= 0. {
        return 0.;
    }
    p.slows
        .iter()
        .filter(|s| s.expires_at > tick)
        .map(|s| s.fraction)
        .fold(0., f32::max)
}
impl Simulation {
    pub fn grant_slow(
        &mut self,
        target: u32,
        tag: &str,
        fraction: f32,
        duration: u64,
    ) -> Result<(), String> {
        if self.winner.is_some() {
            return Err("match ended".into());
        }
        if tag.is_empty()
            || !fraction.is_finite()
            || fraction <= 0.
            || fraction > 1.
            || duration == 0
        {
            return Err("invalid slow".into());
        }
        let p = self.players.get_mut(&target).ok_or("unknown slow target")?;
        if p.health <= 0. {
            return Err("slow target dead".into());
        }
        let duration = spells::control_duration(p, self.tick, duration);
        p.slows.retain(|s| s.tag != tag && s.expires_at > self.tick);
        p.slows.push(Slow {
            tag: tag.into(),
            fraction,
            expires_at: self.tick.saturating_add(duration),
        });
        Ok(())
    }
    pub(crate) fn advance_slows(&mut self) {
        for p in self.players.values_mut() {
            p.slows
                .retain(|s| p.health > 0. && s.expires_at > self.tick);
        }
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
        let a = s.join("garen").unwrap();
        (s, a)
    }
    #[test]
    fn strongest_slow_wins_and_expiry_restores_weaker_remaining_effect() {
        let (mut s, a) = game();
        s.grant_slow(a, "weak", 0.2, 15).unwrap();
        s.grant_slow(a, "strong", 0.6, 6).unwrap();
        assert_eq!(strongest(&s.players[&a], s.tick), 0.6);
        assert!((s.stats(a).move_speed - 179.).abs() < 0.001);
        for _ in 0..6 {
            s.advance();
        }
        assert_eq!(strongest(&s.players[&a], s.tick), 0.2);
        assert_eq!(s.players[&a].slows.len(), 1);
        for _ in 0..9 {
            s.advance();
        }
        assert!(s.players[&a].slows.is_empty());
        assert_eq!(s.stats(a).move_speed, 345.);
    }
    #[test]
    fn tag_refresh_replaces_without_duplicate_stacking() {
        let (mut s, a) = game();
        s.grant_slow(a, "same", 0.8, 10).unwrap();
        s.tick = 3;
        s.grant_slow(a, "same", 0.3, 20).unwrap();
        assert_eq!(s.players[&a].slows.len(), 1);
        assert_eq!(s.players[&a].slows[0].expires_at, 23);
        assert_eq!(strongest(&s.players[&a], s.tick), 0.3);
    }
    #[test]
    fn rejected_q_preserves_slows_and_successful_native_q_purges_all_tags_only() {
        let (mut s, a) = game();
        s.learn(a, 0).unwrap();
        s.grant_slow(a, "one", 0.2, 60).unwrap();
        s.grant_slow(a, "two", 0.7, 60).unwrap();
        s.grant_shield(a, "other", 100., 90).unwrap();
        s.players.get_mut(&a).unwrap().effects.silence_until = 30;
        assert!(s.cast(a, 0, None).is_err());
        assert_eq!(s.players[&a].slows.len(), 2);
        s.players.get_mut(&a).unwrap().effects.silence_until = 0;
        s.cast(a, 0, None).unwrap();
        assert!(s.players[&a].slows.is_empty());
        assert_eq!(s.players[&a].shields.len(), 1);
        assert!(s.stats(a).move_speed > 345.);
    }
    #[test]
    fn invalid_events_are_atomic_and_dead_or_ended_targets_rejected() {
        let (mut s, a) = game();
        s.grant_slow(a, "valid", 0.2, 30).unwrap();
        for fraction in [f32::NAN, f32::INFINITY, -1., 0., 1.1] {
            assert!(s.grant_slow(a, "bad", fraction, 30).is_err());
            assert_eq!(s.players[&a].slows.len(), 1);
        }
        assert!(s.grant_slow(a, "", 0.5, 30).is_err());
        assert!(s.grant_slow(a, "bad", 0.5, 0).is_err());
        assert!(s.grant_slow(999999, "bad", 0.5, 30).is_err());
        s.apply_damage(None, a, 100000., damage::DamageKind::True)
            .unwrap();
        assert!(s.players[&a].slows.is_empty());
        assert!(s.grant_slow(a, "dead", 0.5, 30).is_err());
        s.winner = Some(0);
        assert!(s.grant_slow(a, "ended", 0.5, 30).is_err());
    }
    #[test]
    fn native_w_passive_amplifies_bonus_resistances_and_sale_removes_bonus() {
        let (mut s, a) = game();
        s.buy_item(a, 1029).unwrap();
        s.buy_item(a, 1033).unwrap();
        let before = s.stats(a);
        s.learn(a, 1).unwrap();
        let learned = s.stats(a);
        assert!((learned.armor - before.armor - 3.).abs() < 0.001);
        assert!((learned.magic_resist - before.magic_resist - 5.).abs() < 0.001);
        let base = s.definitions["garen"].armor;
        s.sell_item(a, 0).unwrap();
        assert!((s.stats(a).armor - base).abs() < 0.001);
    }
    #[test]
    fn native_w_duration_reduction_is_captured_at_application_not_reapplied_each_tick() {
        let (mut s, a) = game();
        s.learn(a, 1).unwrap();
        s.cast(a, 1, None).unwrap();
        s.grant_slow(a, "cc", 0.5, 100).unwrap();
        assert_eq!(s.players[&a].slows[0].expires_at, 70);
        for _ in 0..65 {
            s.advance();
        }
        assert_eq!(s.players[&a].slows[0].expires_at, 70);
        for _ in 0..5 {
            s.advance();
        }
        assert!(s.players[&a].slows.is_empty());
    }
}
