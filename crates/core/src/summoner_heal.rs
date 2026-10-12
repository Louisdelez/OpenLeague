//! Native Heal text/range; historical Riot cooldown override and community level/recent policies.
use crate::*;
use std::sync::OnceLock;
#[derive(Deserialize)]
struct Rules {
    cooldown_seconds: f32,
    range: f32,
    heal_level_1: f32,
    heal_per_level: f32,
    speed_fraction: f32,
    speed_seconds: f32,
    recent_seconds: f32,
    recent_multiplier: f32,
}
fn rules() -> &'static Rules {
    static DATA: OnceLock<Rules> = OnceLock::new();
    DATA.get_or_init(|| {
        serde_json::from_str(include_str!("../../../data/4.20/heal_rules.json")).unwrap()
    })
}
pub fn speed_fraction(p: &Champion, tick: u64) -> f32 {
    if tick < p.effects.heal_speed_until {
        rules().speed_fraction
    } else {
        0.
    }
}
pub fn range() -> f32 {
    rules().range
}

impl Simulation {
    pub(crate) fn cast_heal(
        &mut self,
        id: u32,
        slot: u8,
        target: Option<u32>,
    ) -> Result<(), String> {
        let r = rules();
        let owner = &self.players[&id];
        let ally = if let Some(target) = target {
            let p = self.players.get(&target).ok_or("unknown heal ally")?;
            if p.team != owner.team
                || p.health <= 0.
                || target == id
                || owner.position.distance(p.position) > r.range
            {
                return Err("invalid heal ally".into());
            }
            Some(target)
        } else {
            self.players
                .values()
                .filter(|p| {
                    p.id != id
                        && p.team == owner.team
                        && p.health > 0.
                        && p.health < p.max_health
                        && p.position.distance(owner.position) <= r.range
                })
                .min_by(|a, b| {
                    (a.health / a.max_health)
                        .total_cmp(&(b.health / b.max_health))
                        .then(a.id.cmp(&b.id))
                })
                .map(|p| p.id)
        };
        let recipients: Vec<u32> = std::iter::once(id).chain(ally).collect();
        for target in recipients {
            let p = &self.players[&target];
            let amount = (r.heal_level_1 + r.heal_per_level * (p.level.clamp(1, 18) - 1) as f32)
                * if self.tick < p.effects.heal_check_until {
                    r.recent_multiplier
                } else {
                    1.
                };
            self.heal(Some(id), target, amount)?;
            let p = self.players.get_mut(&target).unwrap();
            p.effects.heal_speed_until = self.tick + spells::seconds(r.speed_seconds);
            p.effects.heal_check_until = self.tick + spells::seconds(r.recent_seconds);
        }
        self.players.get_mut(&id).unwrap().summoners.ready_at[slot as usize] =
            self.tick + spells::seconds(r.cooldown_seconds);
        Ok(())
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn game() -> (Simulation, u32, u32, u32) {
        let nav = Navigation::load(
            include_str!("../../../assets/maps/tt_navigation_grid.json"),
            include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin"),
        )
        .unwrap();
        let mut s = Simulation::new(nav).unwrap();
        let a = s
            .join_with_summoners("garen", [Some(summoners::Spell::Heal), None])
            .unwrap();
        let b = s.join("garen").unwrap();
        let c = s
            .join_with_summoners("garen", [Some(summoners::Spell::Heal), None])
            .unwrap();
        let pos = s
            .navigation
            .nearest_walkable(Point { x: 7700., z: 7000. })
            .unwrap();
        for id in [a, b, c] {
            let p = s.players.get_mut(&id).unwrap();
            p.position = pos;
            p.health = 100.;
        }
        (s, a, b, c)
    }
    #[test]
    fn heal_restores_owner_and_one_wounded_ally_with_native_speed_and_historical_cooldown() {
        let (mut s, a, b, c) = game();
        s.players.get_mut(&a).unwrap().effects.silence_until = 90;
        s.cast_summoner(a, 0).unwrap();
        assert_eq!(s.players[&a].health, 190.);
        assert_eq!(s.players[&c].health, 190.);
        assert_eq!(s.players[&b].health, 100.);
        assert_eq!(s.players[&a].summoners.ready_at[0], 7200);
        assert_eq!(s.players[&c].effects.heal_speed_until, 30);
        assert!((s.stats(c).move_speed - 441.8).abs() < 0.01);
        assert!(s.cast_summoner(a, 0).is_err());
        s.tick = 30;
        assert_eq!(s.stats(c).move_speed, 345.);
    }
    #[test]
    fn recent_heal_halves_and_refreshes_without_stacking_then_expires() {
        let (mut s, a, _, c) = game();
        s.cast_summoner(a, 0).unwrap();
        s.cast_summoner(c, 0).unwrap();
        assert_eq!(s.players[&a].health, 235.);
        assert_eq!(s.players[&c].health, 235.);
        assert_eq!(s.players[&a].effects.heal_check_until, 1050);
        s.tick = 1050;
        s.players.get_mut(&a).unwrap().summoners.ready_at[0] = 0;
        s.cast_summoner(a, 0).unwrap();
        assert_eq!(s.players[&a].health, 325.);
    }
    #[test]
    fn explicit_ally_range_enemy_dead_and_unknown_fail_without_cooldown_or_health_changes() {
        let (mut s, a, b, c) = game();
        for target in [b, 999999] {
            assert!(s.cast_summoner_on(a, 0, Some(target)).is_err());
            assert_eq!(s.players[&a].health, 100.);
            assert_eq!(s.players[&a].summoners.ready_at[0], 0);
        }
        s.players.get_mut(&c).unwrap().position.x += 851.;
        assert!(s.cast_summoner_on(a, 0, Some(c)).is_err());
        s.players.get_mut(&c).unwrap().position = s.players[&a].position;
        s.players.get_mut(&c).unwrap().health = 0.;
        assert!(s.cast_summoner_on(a, 0, Some(c)).is_err());
    }
    #[test]
    fn recipient_level_policy_and_clamping_do_not_revive_or_change_resources() {
        let (mut s, a, _, c) = game();
        s.players.get_mut(&a).unwrap().level = 18;
        let mana = s.players[&a].mana;
        s.cast_summoner_on(a, 0, Some(c)).unwrap();
        assert_eq!(s.players[&a].health, 445.);
        assert_eq!(s.players[&c].health, 190.);
        assert_eq!(s.players[&a].mana, mana);
        let out = s.heal(None, a, 10000.).unwrap();
        assert_eq!(s.players[&a].health, s.players[&a].max_health);
        assert!(out.restored < out.requested);
        assert!(s.heal(None, a, f32::NAN).is_err());
        s.players.get_mut(&c).unwrap().health = 0.;
        assert!(s.heal(None, c, 100.).is_err());
        s.winner = Some(0);
        assert!(s.cast_summoner(a, 0).is_err());
    }
}
