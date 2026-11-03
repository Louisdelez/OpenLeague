//! Shared movement speed. Soft-cap ordering and stacking remain reconstructed pending historical qualification.
use crate::*;
use std::sync::OnceLock;
#[derive(Deserialize)]
struct Rules {
    low_threshold: f32,
    middle_threshold: f32,
    high_threshold: f32,
    low_ratio: f32,
    middle_ratio: f32,
    high_ratio: f32,
}
fn rules() -> &'static Rules {
    static R: OnceLock<Rules> = OnceLock::new();
    R.get_or_init(|| {
        serde_json::from_str(include_str!("../../../data/4.20/movement_rules.json")).unwrap()
    })
}
pub fn soft_cap(raw: f32) -> f32 {
    if !raw.is_finite() || raw < 0. {
        return 0.;
    }
    let r = rules();
    if raw < r.low_threshold {
        return r.low_threshold + (raw - r.low_threshold) * r.low_ratio;
    }
    if raw > r.high_threshold {
        return r.middle_threshold
            + (r.high_threshold - r.middle_threshold) * r.middle_ratio
            + (raw - r.high_threshold) * r.high_ratio;
    }
    if raw >= r.middle_threshold {
        return r.middle_threshold + (raw - r.middle_threshold) * r.middle_ratio;
    }
    raw
}
pub fn effective_speed(p: &Champion, flat: f32, tick: u64) -> f32 { effective_speed_with_slow(p,flat,tick,0.) }
fn effective_speed_with_slow(p: &Champion, flat: f32, tick: u64, extra_slow:f32) -> f32 {
    let q = if p.champion == "garen" && p.ranks[0] > 0 && tick < p.effects.speed_until {
        spells::garen_value(0, "Effect2", p.ranks[0]) / 100.
    } else {
        0.
    };
    let heal = summoner_heal::speed_fraction(p, tick);
    soft_cap(
        flat * (1. + q + heal + interactions::relic_haste(p, tick) + trundle_w::movement_bonus(p, tick))
            * (1. - slows::strongest(p, tick).max(extra_slow)),
    )
}

impl Simulation {
    /// Native E tooltip supplies the 20% penalty; center-in-NPC-radius contact is reconstructed.
    pub fn movement_speed(&self, id: u32) -> f32 {
        let p = &self.players[&id];
        let flat = self.definitions[&p.champion].move_speed + shop::bonuses(p).move_speed;
        effective_speed_with_slow(p, flat, self.tick, self.trundle_e_slow(id)) * self.spin_crossing_multiplier(id)
    }
    pub(crate) fn spin_crossing_multiplier(&self, id: u32) -> f32 {
        let p = &self.players[&id];
        if p.champion != "garen" || p.health <= 0. || self.tick >= p.effects.spin_until {
            return 1.;
        }
        let Some(world) = &self.world else {
            return 1.;
        };
        let crossing = self.units.values().any(|u| {
            u.health > 0.
                && (u.kind.lane() || matches!(u.kind, world::Kind::Monster | world::Kind::Boss))
                && world
                    .config
                    .definitions
                    .get(&u.definition)
                    .is_some_and(|d| p.position.distance(u.position) <= d.radius)
        });
        if crossing {
            0.8
        } else {
            1.
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn game() -> (Simulation, u32) {
        let mut bytes = Vec::new();
        for _ in 0..400 {
            bytes.extend(0f32.to_le_bytes());
            bytes.extend(0u16.to_le_bytes());
            bytes.extend(0u32.to_le_bytes());
            bytes.push(1);
        }
        let nav = Navigation::load(
            r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,
            &bytes,
        )
        .unwrap();
        let mut s = Simulation::new(nav).unwrap();
        let a = s.join("garen").unwrap();
        s.players.get_mut(&a).unwrap().position = Point { x: 25., z: 25. };
        (s, a)
    }
    #[test]
    fn community_thresholds_are_continuous_and_excess_speed_is_reduced() {
        assert_eq!(soft_cap(200.), 210.);
        assert_eq!(soft_cap(220.), 220.);
        assert_eq!(soft_cap(415.), 415.);
        assert_eq!(soft_cap(490.), 475.);
        assert_eq!(soft_cap(500.), 480.);
        for boundary in [220., 415., 490.] {
            assert!(soft_cap(boundary - 0.001) <= soft_cap(boundary));
            assert!(soft_cap(boundary + 0.001) >= soft_cap(boundary));
            assert!((soft_cap(boundary - 0.001) - soft_cap(boundary + 0.001)).abs() < 0.003);
        }
    }
    #[test]
    fn invalid_numeric_inputs_cannot_produce_nonfinite_movement() {
        for raw in [f32::NAN, f32::INFINITY, f32::NEG_INFINITY, -1.] {
            assert_eq!(soft_cap(raw), 0.);
        }
        assert!(soft_cap(f32::MAX).is_finite());
    }
    #[test]
    fn native_q_and_boots_speed_match_actual_thirty_tick_walk_distance() {
        let (mut s, a) = game();
        s.players.get_mut(&a).unwrap().inventory[0] = Some(1001);
        s.learn(a, 0).unwrap();
        s.cast(a, 0, None).unwrap();
        let expected = s.stats(a).move_speed;
        assert!((expected - 479.75).abs() < 0.001);
        s.command(
            a,
            Action::Move {
                point: Point { x: 825., z: 25. },
            },
        )
        .unwrap();
        let start = s.players[&a].position;
        for _ in 0..30 {
            s.advance();
        }
        assert!((s.players[&a].position.distance(start) - expected).abs() < 0.02);
        assert!((s.stats(a).move_speed - expected).abs() < 0.001);
    }
    #[test]
    fn native_q_expiry_restores_item_modified_speed_without_cancelling_order() {
        let (mut s, a) = game();
        s.players.get_mut(&a).unwrap().inventory[0] = Some(1001);
        s.learn(a, 0).unwrap();
        s.cast(a, 0, None).unwrap();
        s.command(
            a,
            Action::Move {
                point: Point { x: 825., z: 25. },
            },
        )
        .unwrap();
        let expiry = s.players[&a].effects.speed_until;
        while s.tick < expiry {
            s.advance();
        }
        assert_eq!(s.stats(a).move_speed, 370.);
        assert!(s.players[&a].destination.is_some());
    }
    #[test]
    fn relic_decay_and_expiry_feed_the_same_post_bonus_soft_cap() {
        let (mut s, a) = game();
        s.players.get_mut(&a).unwrap().inventory[0] = Some(1001);
        s.learn(a, 0).unwrap();
        s.cast(a, 0, None).unwrap();
        let p = s.players.get_mut(&a).unwrap();
        p.effects.relic_haste_started = 0;
        p.effects.relic_haste_until = 150;
        assert!((effective_speed(p, 370., 0) - 516.75).abs() < 0.001);
        assert!((effective_speed(p, 370., 75) - 407.).abs() < 0.001);
        assert_eq!(effective_speed(p, 370., 150), 370.);
    }
}

#[cfg(test)]
mod crossing_tests {
    use super::*;
    fn game() -> (Simulation, u32, u32) {
        let mut bytes = Vec::new();
        for _ in 0..400 {
            bytes.extend(0f32.to_le_bytes());
            bytes.extend(0u16.to_le_bytes());
            bytes.extend(0u32.to_le_bytes());
            bytes.push(1);
        }
        let nav = Navigation::load(
            r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#,
            &bytes,
        )
        .unwrap();
        let mut s = Simulation::new(nav).unwrap();
        s.enable_map10().unwrap();
        let a = s.join("garen").unwrap();
        s.players.get_mut(&a).unwrap().position = Point { x: 100., z: 100. };
        s.learn(a, 2).unwrap();
        let unit = s
            .spawn_unit(
                "Blue_Minion_Basic",
                "crossing",
                0,
                Point { x: 100., z: 100. },
                0.,
                0.,
                None,
                None,
            )
            .unwrap();
        (s, a, unit)
    }
    #[test]
    fn native_spin_penalty_applies_to_allied_minions_and_monsters_but_not_champions_or_structures()
    {
        let (mut s, a, u) = game();
        assert_eq!(s.stats(a).move_speed, 345.);
        s.cast(a, 2, None).unwrap();
        assert!((s.stats(a).move_speed - 276.).abs() < 0.001);
        for kind in [world::Kind::Monster, world::Kind::Boss, world::Kind::Caster] {
            s.units.get_mut(&u).unwrap().kind = kind;
            assert_eq!(s.spin_crossing_multiplier(a), 0.8);
        }
        s.units.get_mut(&u).unwrap().kind = world::Kind::Turret;
        assert_eq!(s.spin_crossing_multiplier(a), 1.);
        let b = s.join("garen").unwrap();
        s.players.get_mut(&b).unwrap().position = s.players[&a].position;
        assert_eq!(s.spin_crossing_multiplier(a), 1.);
    }
    #[test]
    fn crossing_ends_at_native_radius_death_and_recast_without_stacking_multiple_units() {
        let (mut s, a, u) = game();
        s.cast(a, 2, None).unwrap();
        s.spawn_unit(
            "Blue_Minion_Basic",
            "second",
            0,
            Point { x: 100., z: 100. },
            0.,
            0.,
            None,
            None,
        )
        .unwrap();
        assert_eq!(s.spin_crossing_multiplier(a), 0.8);
        s.units.retain(|id, _| *id == u);
        s.players.get_mut(&a).unwrap().position.x = 148.;
        assert_eq!(s.spin_crossing_multiplier(a), 0.8);
        s.players.get_mut(&a).unwrap().position.x = 148.01;
        assert_eq!(s.spin_crossing_multiplier(a), 1.);
        s.players.get_mut(&a).unwrap().position.x = 100.;
        s.units.get_mut(&u).unwrap().health = 0.;
        assert_eq!(s.spin_crossing_multiplier(a), 1.);
        s.units.get_mut(&u).unwrap().health = 100.;
        s.cast(a, 2, None).unwrap();
        assert_eq!(s.spin_crossing_multiplier(a), 1.);
    }
    #[test]
    fn actual_walking_uses_same_penalty_as_stats_and_expiry_restores_speed() {
        let (mut s, a, u) = game();
        s.world
            .as_mut()
            .unwrap()
            .config
            .definitions
            .get_mut("Blue_Minion_Basic")
            .unwrap()
            .radius = 10000.;
        s.units.get_mut(&u).unwrap().damage = 0.;
        s.players.get_mut(&a).unwrap().position = Point { x: 125., z: 125. };
        s.cast(a, 2, None).unwrap();
        s.command(
            a,
            Action::Move {
                point: Point { x: 825., z: 125. },
            },
        )
        .unwrap();
        let start = s.players[&a].position;
        for _ in 0..30 {
            s.advance();
        }
        assert!((s.players[&a].position.distance(start) - 276.).abs() < 0.02);
        let expiry = s.players[&a].effects.spin_until;
        s.tick = expiry;
        assert_eq!(s.stats(a).move_speed, 345.);
    }
}
