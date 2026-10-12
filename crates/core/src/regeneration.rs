//! Base sustain from decoded native 4.20 stats, expressed per second.
//! Item modifiers, healing reduction and champion-specific passive sustain are separate work.
use crate::*;
#[derive(Debug, Clone, Copy)]
pub struct RegenerationRates {
    pub health_per_second: f32,
    pub resource_per_second: f32,
}
impl Simulation {
    pub fn regeneration_rates(&self, id: u32) -> Option<RegenerationRates> {
        let p = self.players.get(&id)?;
        let growth = &self.growth[&p.champion];
        let factor = progression::growth_total(p.level);
        let items = shop::bonuses(p);
        Some(RegenerationRates {
            health_per_second: ((growth.health_regen + growth.health_regen_growth * factor)
                * (1. + items.health_regen_percent))
                .max(0.),
            resource_per_second: if lifecycle::restores_resource(&p.champion) {
                ((growth.mana_regen + growth.mana_regen_growth * factor)
                    * if lifecycle::uses_mana(&p.champion) {
                        1. + items.mana_regen_percent
                    } else {
                        1.
                    })
                .max(0.)
            } else {
                0.
            },
        })
    }
    pub(crate) fn advance_regeneration(&mut self) {
        let living: Vec<_> = self
            .players
            .values()
            .filter(|p| p.health > 0.)
            .map(|p| p.id)
            .collect();
        for id in living {
            let rates = self.regeneration_rates(id).unwrap();
            let max_resource = self.stats(id).max_mana;
            let passive = self.garen_passive_per_second(id);
            let p = self.players.get_mut(&id).unwrap();
            p.health = (p.health + (rates.health_per_second + passive) * healing::received_multiplier(p,self.tick) / TICK_RATE as f32)
                .min(p.max_health);
            if rates.resource_per_second > 0. {
                p.mana = (p.mana + rates.resource_per_second / TICK_RATE as f32).min(max_resource);
            }
        }
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn game() -> Simulation {
        let mut bytes = Vec::new();
        for _ in 0..400 {
            bytes.extend(0f32.to_le_bytes());
            bytes.extend(0u16.to_le_bytes());
            bytes.extend(0u32.to_le_bytes());
            bytes.push(1);
        }
        Simulation::new(
            Navigation::load(
                r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,
                &bytes,
            )
            .unwrap(),
        )
        .unwrap()
    }
    #[test]
    fn native_base_health_regeneration_is_per_second_and_clamped() {
        let mut s = game();
        let id = s.join("garen").unwrap();
        s.players.get_mut(&id).unwrap().health = 100.;
        for _ in 0..TICK_RATE {
            s.advance();
        }
        assert!((s.regeneration_rates(id).unwrap().health_per_second - 1.568).abs() < 0.0001);
        assert!(
            (s.players[&id].health - 100. - 1.568 - s.players[&id].max_health * 0.004).abs()
                < 0.003
        );
        let max = s.players[&id].max_health;
        s.players.get_mut(&id).unwrap().health = max - 0.001;
        s.advance();
        assert_eq!(s.players[&id].health, max);
    }
    #[test]
    fn mana_and_energy_restore_but_other_resources_do_not() {
        let mut s = game();
        for name in ["ahri", "akali", "renekton", "aatrox", "garen"] {
            let id = s.join(name).unwrap();
            s.players.get_mut(&id).unwrap().mana = 0.;
        }
        for _ in 0..TICK_RATE {
            s.advance();
        }
        for p in s.players.values() {
            let expected = match p.champion.as_str() {
                "akali" => 10.,
                "ahri" => s.growth["ahri"].mana_regen,
                _ => 0.,
            };
            assert!(
                (p.mana - expected).abs() < 0.002,
                "{} {}",
                p.champion,
                p.mana
            );
        }
    }
    #[test]
    fn death_and_match_end_stop_sustain() {
        let mut s = game();
        let id = s.join("garen").unwrap();
        s.damage(id, 100000., false);
        let mana = s.players[&id].mana;
        for _ in 0..30 {
            s.advance();
        }
        assert_eq!(s.players[&id].health, 0.);
        assert_eq!(s.players[&id].mana, mana);
        s.players.get_mut(&id).unwrap().health = 100.;
        s.winner = Some(0);
        s.advance();
        assert_eq!(s.players[&id].health, 100.);
    }
    #[test]
    fn rates_follow_native_nonlinear_level_growth() {
        let mut s = game();
        let id = s.join("ahri").unwrap();
        for level in [1, 2, 11, 18] {
            s.players.get_mut(&id).unwrap().level = level;
            let g = &s.growth["ahri"];
            let factor = progression::growth_total(level);
            let rates = s.regeneration_rates(id).unwrap();
            assert!(
                (rates.health_per_second - g.health_regen - g.health_regen_growth * factor).abs()
                    < 0.00001
            );
            assert!(
                (rates.resource_per_second - g.mana_regen - g.mana_regen_growth * factor).abs()
                    < 0.00001
            );
        }
        assert!(s.regeneration_rates(999).is_none());
    }
}
