//! Timed general champion shields. Specific spell-shield/type-specific contracts remain work.
use crate::*;
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Shield {
    pub tag: String,
    pub remaining: f32,
    pub expires_at: u64,
}
impl Simulation {
    /// Called only by authoritative game events, never by a direct client shield command.
    /// Same-tag refresh replaces rather than duplicates a shield. Per-ability stacking is separate.
    pub fn grant_shield(
        &mut self,
        target: u32,
        tag: &str,
        amount: f32,
        duration: u64,
    ) -> Result<(), String> {
        if self.winner.is_some() {
            return Err("match ended".into());
        }
        if tag.is_empty() || !amount.is_finite() || amount <= 0. || duration == 0 {
            return Err("invalid shield".into());
        }
        let p = self
            .players
            .get_mut(&target)
            .ok_or("unknown shield target")?;
        if p.health <= 0. {
            return Err("shield target dead".into());
        }
        p.shields
            .retain(|s| s.tag != tag && s.expires_at > self.tick && s.remaining > 0.);
        p.shields.push(Shield {
            tag: tag.into(),
            remaining: amount,
            expires_at: self.tick.saturating_add(duration),
        });
        Ok(())
    }
    pub(crate) fn advance_shields(&mut self) {
        for p in self.players.values_mut() {
            p.shields
                .retain(|s| p.health > 0. && s.expires_at > self.tick && s.remaining > 0.);
        }
    }
    pub(crate) fn absorb_shields(&mut self, target: u32, mut amount: f32) -> (f32, f32) {
        let p = self.players.get_mut(&target).unwrap();
        p.shields
            .retain(|s| s.expires_at > self.tick && s.remaining > 0.);
        // Consume sooner-expiring shields first; exact per-spell priority remains unqualified.
        p.shields.sort_by_key(|s| s.expires_at);
        let original = amount;
        for shield in &mut p.shields {
            let absorbed = amount.min(shield.remaining);
            shield.remaining -= absorbed;
            amount -= absorbed;
        }
        p.shields.retain(|s| s.remaining > 0.);
        (amount, original - amount)
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
        let id = s.join("garen").unwrap();
        (s, id)
    }
    #[test]
    fn shield_consumes_post_mitigation_damage_and_overflow_hits_health() {
        let (mut s, id) = game();
        s.grant_shield(id, "test", 50., 60).unwrap();
        let hp = s.players[&id].health;
        let event = s
            .apply_damage(None, id, 25., damage::DamageKind::True)
            .unwrap();
        assert_eq!(event.shield_absorbed, 25.);
        assert_eq!(event.health_removed, 0.);
        let event = s
            .apply_damage(None, id, 100., damage::DamageKind::True)
            .unwrap();
        assert_eq!(event.shield_absorbed, 25.);
        assert_eq!(event.health_removed, 75.);
        assert_eq!(s.players[&id].health, hp - 75.);
        assert!(s.players[&id].shields.is_empty());
        s.grant_shield(id, "test", 100., 60).unwrap();
        let raw = 50. * (100. + s.stats(id).armor) / 100.;
        let event = s
            .apply_damage(None, id, raw, damage::DamageKind::Physical)
            .unwrap();
        assert!((event.shield_absorbed - 50.).abs() < 0.001);
        assert_eq!(event.health_removed, 0.);
    }
    #[test]
    fn expiry_refresh_and_death_do_not_leave_stale_shields() {
        let (mut s, id) = game();
        s.grant_shield(id, "test", 50., 60).unwrap();
        s.grant_shield(id, "test", 100., 60).unwrap();
        assert_eq!(s.players[&id].shields.len(), 1);
        s.tick = 60;
        let e = s
            .apply_damage(None, id, 10., damage::DamageKind::True)
            .unwrap();
        assert_eq!(e.shield_absorbed, 0.);
        assert_eq!(e.health_removed, 10.);
        s.grant_shield(id, "new", 50., 60).unwrap();
        s.damage(id, 100000., false);
        assert!(s.players[&id].shields.is_empty());
        assert!(s.grant_shield(id, "dead", 50., 60).is_err());
    }
    #[test]
    fn invalid_shield_events_do_not_change_existing_state() {
        let (mut s, id) = game();
        s.grant_shield(id, "valid", 50., 60).unwrap();
        for amount in [f32::NAN, f32::INFINITY, 0., -1.] {
            assert!(s.grant_shield(id, "invalid", amount, 60).is_err());
        }
        assert_eq!(s.players[&id].shields.len(), 1);
        assert_eq!(s.players[&id].shields[0].remaining, 50.);
    }
}
