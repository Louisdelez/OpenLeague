//! Authoritative physical/magical/true damage shared by champion and world targets.
//! Item penetration precedes resistance mitigation; detailed native modifier policies remain work.
use crate::*;
#[derive(Debug, Clone, Copy, Serialize, Deserialize, PartialEq, Eq)]
pub enum DamageKind {
    Physical,
    Magical,
    True,
}
impl DamageKind {
    #[cfg(test)]
    pub(crate) fn from_magic(magic: bool) -> Self {
        if magic {
            Self::Magical
        } else {
            Self::Physical
        }
    }
}
#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct DamageOutcome {
    pub source: Option<u32>,
    pub target: u32,
    pub kind: DamageKind,
    pub raw: f32,
    pub health_removed: f32,
    pub post_mitigation: f32,
    pub shield_absorbed: f32,
    pub lethal: bool,
}
fn resistance_multiplier(value: f32) -> f32 {
    if value >= 0. {
        100. / (100. + value)
    } else {
        2. - 100. / (100. - value)
    }
}
pub fn mitigate(raw: f32, kind: DamageKind, armor: f32, mr: f32, reduction: f32) -> Option<f32> {
    if !raw.is_finite() || raw < 0. || !reduction.is_finite() || !(0. ..=1.).contains(&reduction) {
        return None;
    }
    let damage = match kind {
        DamageKind::True => raw,
        DamageKind::Physical if armor.is_finite() => raw * resistance_multiplier(armor) * reduction,
        DamageKind::Magical if mr.is_finite() => raw * resistance_multiplier(mr) * reduction,
        _ => return None,
    };
    damage.is_finite().then_some(damage)
}
impl Simulation {
    /// Server simulation event API. No client packet grants direct damage authority.
    /// Ability/attack targeting policies belong to their respective callers.
    pub fn apply_damage(
        &mut self,
        source: Option<u32>,
        target: u32,
        raw: f32,
        kind: DamageKind,
    ) -> Result<DamageOutcome, String> {
        if self.winner.is_some() {
            return Err("match ended".into());
        }
        if !raw.is_finite() || raw < 0. {
            return Err("invalid damage".into());
        }
        if source.is_some_and(|id| self.target_info(id).is_none()) {
            return Err("unknown damage source".into());
        }
        let info = self.target_info(target).ok_or("unknown damage target")?;
        if info.health <= 0. {
            return Err("damage target dead".into());
        }
        if self.protected(target) {
            return Err("damage target protected".into());
        }
        // Capture before health, shields, reveal/effects or either actor can change.
        let death_presentation = self.capture_attack_presentation(target);
        let recap_capture = self.capture_death_recap(source, target);
        let outgoing = raw * self.exhaust_damage_multiplier(source, kind);
        let before = info.health;
        let mut shield_absorbed = 0.;
        let mut post_mitigation = 0.;
        if raw > 0. {
            if self.players.contains_key(&target) {
                let stats = self.stats(target);
                let reduction = if self.tick < self.players[&target].effects.courage_until {
                    0.7
                } else {
                    1.
                };
                let (armor, mr) = self.penetrated_defenses(source, kind, stats.armor, stats.magic_resist)?;
                let amount = mitigate(outgoing, kind, armor, mr, reduction)
                    .ok_or("invalid defense stats")?;
                post_mitigation = amount;
                // Defense failures must not create or refresh kill/assist credit.
                // Keep accepted raw>0 contributions before shields/HP, even if amount is zero.
                if let Some(id)=source {if let Some(owner)=self.combat_owner(id) {self.record_champion_contribution(owner,target);}}
                if amount > 0. {
                    self.note_garen_damage(target, source);
                }
                let (amount, absorbed) = self.absorb_shields(target, amount);
                shield_absorbed = absorbed;
                let p = self.players.get_mut(&target).unwrap();
                p.health = (p.health - amount).max(0.);
                if p.health == 0. {
                    p.windup = None;
                    p.attack_roll = None;
                    p.path.clear();
                    p.destination = None;
                    p.target = None;
                    p.effects = spells::Effects::default();
                    p.shields.clear();
                    p.slows.clear();
                    p.stuns.clear();
                    p.respawn_at = Some(self.tick + lifecycle::base_death_ticks(p.level));
                }
            } else {
                let u = &self.units[&target];
                let (armor, mr) = self.penetrated_defenses(source, kind, u.armor+annie_r::defense(u,self.tick), u.magic_resist+annie_r::defense(u,self.tick))?;
                post_mitigation = mitigate(outgoing, kind, armor, mr, 1.)
                    .ok_or("invalid defense stats")?;
                self.damage_unit(source.unwrap_or(0), target, post_mitigation);
            }
        }
        let after = self
            .target_info(target)
            .ok_or("damage target disappeared")?
            .health;
        if before > 0. && after == 0. {
            self.cancel_captured_attack_presentation(death_presentation, attack_presentation::CancelReason::Death);
        }
        if before>0. && after==0. && self.players.contains_key(&target) {
            self.clear_trundle_r_for(target);
            // RECONSTRUCTION: death-time level/position, before kill experience.
            self.trundle_passive_damage_death(target);
            self.reward_champion_death(source.and_then(|id|self.combat_owner(id)),target);
        }
        let outcome = DamageOutcome {
            source,
            target,
            kind,
            raw,
            health_removed: (before - after).max(0.),
            shield_absorbed,
            post_mitigation,
            lethal: after == 0.,
        };
        self.commit_death_recap(recap_capture, &outcome);
        Ok(outcome)
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn game() -> Simulation {
        let nav = Navigation::load(
            include_str!("../../../assets/maps/tt_navigation_grid.json"),
            include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin"),
        )
        .unwrap();
        let mut s = Simulation::new(nav).unwrap();
        s.enable_map10().unwrap();
        s
    }
    #[test]
    fn resistances_apply_to_their_type_and_true_bypasses_reductions() {
        assert_eq!(
            mitigate(100., DamageKind::Physical, 100., 0., 1.),
            Some(50.)
        );
        assert_eq!(mitigate(100., DamageKind::Magical, 0., 100., 1.), Some(50.));
        assert_eq!(
            mitigate(100., DamageKind::Physical, -100., 0., 1.),
            Some(150.)
        );
        assert_eq!(
            mitigate(100., DamageKind::Magical, 0., -100., 1.),
            Some(150.)
        );
        assert_eq!(
            mitigate(100., DamageKind::True, 10000., 10000., 0.7),
            Some(100.)
        );
    }
    #[test]
    fn invalid_and_zero_damage_never_mutate_health_or_aggro() {
        let mut s = game();
        let id = s.join("garen").unwrap();
        let hp = s.players[&id].health;
        for raw in [f32::NAN, f32::INFINITY, -1.] {
            assert!(s.apply_damage(None, id, raw, DamageKind::True).is_err());
        }
        assert_eq!(s.players[&id].health, hp);
        assert_eq!(
            s.apply_damage(None, id, 0., DamageKind::True)
                .unwrap()
                .health_removed,
            0.
        );
        assert!(s.apply_damage(Some(999), id, 1., DamageKind::True).is_err());
        s.tick = 100 * TICK_RATE - 1;
        s.advance();
        let mob = *s
            .units
            .iter()
            .find(|(_, u)| u.kind == world::Kind::Monster)
            .unwrap()
            .0;
        s.apply_damage(Some(id), mob, 0., DamageKind::Physical)
            .unwrap();
        assert!(s.units[&mob].target.is_none());
    }
    #[test]
    fn true_damage_kills_champion_once_and_reports_actual_health_removed() {
        let mut s = game();
        let id = s.join("garen").unwrap();
        s.players.get_mut(&id).unwrap().effects.courage_until = 999;
        let hp = s.players[&id].health;
        let event = s.apply_damage(None, id, 10000., DamageKind::True).unwrap();
        assert_eq!(event.health_removed, hp);
        assert!(event.lethal);
        assert_eq!(event.kind, DamageKind::True);
        assert!(s.players[&id].respawn_at.is_some());
        assert!(s.apply_damage(None, id, 1., DamageKind::True).is_err());
    }
    #[test]
    fn true_damage_preserves_world_reward_and_structure_protection_rules() {
        let mut s = game();
        let id = s.join("garen").unwrap();
        let nexus = *s
            .units
            .iter()
            .find(|(_, u)| u.kind == world::Kind::Nexus)
            .unwrap()
            .0;
        assert!(s
            .apply_damage(Some(id), nexus, 10000., DamageKind::True)
            .is_err());
        s.tick = 100 * TICK_RATE - 1;
        s.advance();
        let mob = *s
            .units
            .iter()
            .find(|(_, u)| u.kind == world::Kind::Monster)
            .unwrap()
            .0;
        s.units.get_mut(&mob).unwrap().armor = 10000.;
        let hp = s.units[&mob].health;
        let gold = s.players[&id].gold;
        let event = s.apply_damage(Some(id), mob, hp, DamageKind::True).unwrap();
        assert!(event.lethal);
        assert_eq!(event.health_removed, hp);
        assert!(s.players[&id].gold > gold);
        let rewarded = s.players[&id].gold;
        assert!(s.apply_damage(Some(id), mob, hp, DamageKind::True).is_err());
        assert_eq!(s.players[&id].gold, rewarded);
    }

    #[test]
    fn rejected_nonfinite_defenses_do_not_steal_environmental_kill_credit() {
        for kind in [DamageKind::Physical, DamageKind::Magical] {
            let mut s = game();
            let rejected = s.join("garen").unwrap();
            let victim = s.join("annie").unwrap();
            let contributor = s.join("garen").unwrap();
            s.apply_damage(Some(contributor), victim, 1., DamageKind::True).unwrap();
            let before = serde_json::to_value(s.snapshot()).unwrap();
            let gold = s.players[&rejected].gold;
            let experience = s.players[&rejected].experience;
            let original = if kind == DamageKind::Physical {
                let value = s.definitions["annie"].armor;
                s.definitions.get_mut("annie").unwrap().armor = f32::NAN;
                value
            } else {
                let value = s.definitions["annie"].magic_resist;
                s.definitions.get_mut("annie").unwrap().magic_resist = f32::NAN;
                value
            };
            let expected = if kind == DamageKind::Physical {
                "invalid penetration/armor"
            } else {
                "invalid penetration/magic resistance"
            };
            assert_eq!(s.apply_damage(Some(rejected), victim, 1., kind).unwrap_err(), expected);
            if kind == DamageKind::Physical {
                s.definitions.get_mut("annie").unwrap().armor = original;
            } else {
                s.definitions.get_mut("annie").unwrap().magic_resist = original;
            }
            assert_eq!(serde_json::to_value(s.snapshot()).unwrap(), before);
            // The public snapshot above cannot see hidden contribution history.
            // A later environmental death makes a rejected hit's false credit observable.
            s.apply_damage(None, victim, 10000., DamageKind::True).unwrap();
            assert_eq!(s.players[&rejected].score.kills, 0);
            assert_eq!(s.players[&rejected].score.assists, 0);
            assert_eq!(s.players[&rejected].gold, gold);
            assert_eq!(s.players[&rejected].experience, experience);
            assert_eq!(s.players[&contributor].score.kills, 1);
            let snapshot = s.snapshot();
            let death = snapshot.kill_events.last().unwrap();
            assert_eq!(death.killer, Some(contributor));
            assert!(death.assists.is_empty());
        }
    }
    #[test]
    fn finite_mitigation_overflow_cannot_create_or_refresh_assist_credit() {
        for prior_hit in [false, true] {
            let mut s = game();
            let killer = s.join("garen").unwrap();
            let victim = s.join("garen").unwrap();
            let rejected = s.join("garen").unwrap();
            if prior_hit {
                s.apply_damage(Some(rejected), victim, 1., DamageKind::True).unwrap();
                // Same expired-assist boundary as the existing champion_kills tests.
                s.tick = 451;
            }
            s.definitions.get_mut("garen").unwrap().armor = -100.;
            let before = serde_json::to_value(s.snapshot()).unwrap();
            let gold = s.players[&rejected].gold;
            // All inputs are finite: the valid negative-resistance multiplier is1.5,
            // so finite raw MAX overflows during mitigation and must be rejected.
            assert_eq!(s.apply_damage(Some(rejected), victim, f32::MAX, DamageKind::Physical)
                .unwrap_err(), "invalid defense stats");
            assert_eq!(serde_json::to_value(s.snapshot()).unwrap(), before);
            s.apply_damage(Some(killer), victim, 10000., DamageKind::True).unwrap();
            assert_eq!(s.players[&rejected].score.assists, 0);
            assert_eq!(s.players[&rejected].score.kills, 0);
            assert_eq!(s.players[&rejected].gold, gold);
            let snapshot = s.snapshot();
            let death = snapshot.kill_events.last().unwrap();
            assert_eq!(death.killer, Some(killer));
            assert!(death.assists.is_empty());
        }
    }
}
