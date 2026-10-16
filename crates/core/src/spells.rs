//! Garen 4.20 native numeric contracts. Visuals, passive, cancellation and item interactions remain separate work.
use crate::*;
use std::sync::OnceLock;
#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct Effects {
    #[serde(default, skip_serializing_if="Option::is_none")]
    pub trundle_e_push: Option<trundle_e::ForcedMovement>,
    #[serde(default)]
    pub trundle_q: trundle_q::State,
    #[serde(default)]
    pub trundle_w: Option<trundle_w::Zone>,
    #[serde(default)]
    pub trundle_r: Option<trundle_r::Drain>,
    #[serde(default)]
    pub pyromania: u8,
    #[serde(default)]
    pub annie_r: Option<annie_r::Pending>,
    #[serde(default)]
    pub annie_w: Option<annie_w::Pending>,
    #[serde(default)]
    pub molten_until: u64,
    #[serde(default)]
    pub molten_rank: u8,
    #[serde(default)]
    pub annie_q: Option<annie::Pending>,
    #[serde(default)]
    pub health_potion_ticks: u64,
    #[serde(default)]
    pub mana_potion_ticks: u64,
    #[serde(default)]
    pub ignite: Option<summoner_ignite::Burn>,
    pub speed_until: u64,
    #[serde(default)]
    pub heal_speed_until: u64,
    #[serde(default)]
    pub heal_check_until: u64,
    #[serde(default)]
    pub exhaust_until: u64,
    pub relic_haste_started: u64,
    pub relic_haste_until: u64,
    pub empowered_until: u64,
    pub courage_until: u64,
    pub silence_until: u64,
    pub spin_until: u64,
    pub next_spin: u64,
    pub spin_rank: u8,
    pub ultimate: Option<Ultimate>,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Ultimate {
    pub target: u32,
    pub rank: u8,
    pub resolves: u64,
}
static VALUES: OnceLock<Vec<serde_json::Value>> = OnceLock::new();
pub fn garen_value(slot: u8, effect: &str, rank: u8) -> f32 {
    let rows = VALUES.get_or_init(|| {
        serde_json::from_str(include_str!("../../../data/4.20/native_spells_420.json"))
            .expect("native spells")
    });
    let row = rows
        .iter()
        .find(|r| {
            r["champion"]
                .as_str()
                .is_some_and(|s| s.eq_ignore_ascii_case("garen"))
                && r["slot"].as_u64() == Some(slot as u64)
        })
        .expect("native Garen slot");
    let key = if effect == "Cooldown" {
        format!("Cooldown{rank}")
    } else if effect == "CastRange" {
        "CastRange".into()
    } else {
        format!("{effect}Level{rank}Amount")
    };
    let value = &row["values"][key];
    value.as_f64().map(|v| v as f32).unwrap_or_else(|| {
        value
            .as_str()
            .expect("numeric native value")
            .parse()
            .expect("native number")
    })
}
pub fn seconds(value: f32) -> u64 {
    (value * TICK_RATE as f32).ceil() as u64
}
pub(crate) fn control_duration(p: &Champion, tick: u64, duration: u64) -> u64 {
    if tick < p.effects.courage_until {
        (duration as f32 * 0.7).ceil() as u64
    } else {
        duration
    }
}
impl Simulation {
    pub fn cast(&mut self, id: u32, slot: u8, target: Option<u32>) -> Result<(), String> {
        if slot > 3 {
            return Err("invalid skill slot".into());
        }
        let p = self.players.get(&id).ok_or("unknown player")?;
        if trundle_e::champion_forced(p,self.tick) {return Err("champion in forced movement".into());}
        if p.health <= 0. {
            return Err("champion dead".into());
        }
        if stuns::active(p,self.tick) && !(p.champion=="annie"&&slot==3&&self.tibbers(id).is_some()) {return Err("champion stunned".into());}
        if p.champion == "annie" {return self.cast_annie(id,slot,target);}
        if p.champion == "trundle" && slot == 1 {return Err("Trundle W requires a ground point".into());}
        if p.champion == "trundle" && slot == 3 {return self.cast_trundle_r(id,target);}
        if p.champion == "trundle" {return self.cast_trundle_q(id,slot,target);}
        if p.champion != "garen" {
            return Err("champion spell not implemented".into());
        }
        let rank = p.ranks[slot as usize];
        if rank == 0 {
            return Err("skill not learned".into());
        }
        if self.tick < p.effects.silence_until {
            return Err("champion silenced".into());
        }
        // Native GarenECancel is a recast while Judgment is active, despite its cooldown.
        // Keep the original cooldown; historical minimum-recast timing still needs qualification.
        if slot == 2 && self.tick < p.effects.spin_until && p.effects.ultimate.is_none() {
            let p = self.players.get_mut(&id).unwrap();
            p.effects.spin_until = self.tick;
            p.effects.next_spin = 0;
            p.effects.spin_rank = 0;
            return Ok(());
        }
        if p.effects.ultimate.is_some() || (slot != 1 && self.tick < p.effects.spin_until) {
            return Err("skill blocked during cast".into());
        }
        if self.tick < p.cooldowns[slot as usize] {
            return Err("skill on cooldown".into());
        }
        if slot == 3 {
            let target = target.ok_or("ultimate requires enemy champion")?;
            let enemy = self.players.get(&target).ok_or("unknown target")?;
            if enemy.team == p.team || enemy.health <= 0. {
                return Err("invalid enemy target".into());
            }
            if !self.visible_to(p.team, target) {
                return Err("ultimate target not visible".into());
            }
            if p.position.distance(enemy.position) > garen_value(3, "CastRange", rank) {
                return Err("ultimate target out of range".into());
            }
        }
        let cooldown = cooldown::ticks(garen_value(slot, "Cooldown", rank), self.stats(id).cooldown_reduction);
        let p = self.players.get_mut(&id).unwrap();
        p.cooldowns[slot as usize] = self.tick + cooldown;
        p.cooldown_totals[slot as usize] = Some(cooldown);
        match slot {
            0 => {
                p.slows.clear();
                p.effects.speed_until = self.tick + seconds(garen_value(0, "Effect5", rank));
                p.effects.empowered_until = self.tick + seconds(garen_value(0, "Effect6", rank));
            }
            1 => p.effects.courage_until = self.tick + seconds(garen_value(1, "Effect4", rank)),
            2 => {
                p.effects.spin_until = self.tick + seconds(garen_value(2, "Effect2", rank));
                p.effects.next_spin = self.tick + 15;
                p.effects.spin_rank = rank;
            }
            3 => {
                p.path.clear();
                p.destination = None;
                p.target = None;
                p.effects.ultimate = Some(Ultimate {
                    target: target.unwrap(),
                    rank,
                    resolves: self.tick + 15,
                });
            }
            _ => unreachable!(),
        }
        Ok(())
    }
    pub(crate) fn apply_silence(&mut self, target: u32, until: u64) {
        if let Some(unit) = self.units.get_mut(&target) {
            if !unit.kind.structure() {
                unit.silence_until = unit.silence_until.max(until);
            }
            return;
        }
        let p = self.players.get_mut(&target).unwrap();
        let duration = until.saturating_sub(self.tick);
        let duration = control_duration(p, self.tick, duration);
        p.effects.silence_until = p.effects.silence_until.max(self.tick + duration);
        // Garen's uncancellable ultimate completes. Judgment is not stopped by silence.
    }
    #[cfg(test)]
    pub(crate) fn damage(&mut self, target: u32, raw: f32, magic: bool) {
        let _ = self.apply_damage(None, target, raw, damage::DamageKind::from_magic(magic));
    }
    pub(crate) fn advance_spells(&mut self) {
        let mut pulses = Vec::new();
        let mut ultimates = Vec::new();
        for p in self.players.values_mut() {
            if p.health <= 0. {
                continue;
            }
            if p.effects.spin_rank > 0
                && self.tick >= p.effects.next_spin
                && p.effects.next_spin <= p.effects.spin_until
            {
                pulses.push((p.id, p.team, p.position, p.effects.spin_rank));
                p.effects.next_spin += 15;
                if p.effects.next_spin > p.effects.spin_until {
                    p.effects.spin_rank = 0;
                }
            }
            if p.effects
                .ultimate
                .as_ref()
                .is_some_and(|u| self.tick >= u.resolves)
            {
                ultimates.push((p.id, p.effects.ultimate.take().unwrap()));
            }
        }
        for (id, team, position, rank) in pulses {
            if self.players[&id].health <= 0. {
                continue;
            }
            let damage = garen_value(2, "Effect1", rank) / 2.
                + self.stats(id).damage * garen_value(2, "Effect3", rank) / 200.;
            let targets: Vec<_> = self
                .players
                .values()
                .filter(|p| {
                    p.team != team && p.health > 0. && position.distance(p.position) <= 325.
                })
                .map(|p| p.id)
                .collect();
            for target in targets {
                // Judgment is a physical spell, not a basic-attack hit.
                let _ = self.apply_damage(Some(id), target, damage, damage::DamageKind::Physical);
            }
            let targets: Vec<_> = self
                .units
                .values()
                .filter(|u| {
                    u.team != team
                        && u.health > 0.
                        && !u.kind.structure()
                        && position.distance(u.position) <= 325.
                })
                .map(|u| (u.id, u.kind.lane()))
                .collect();
            for (target, lane) in targets {
                let _ = self.apply_damage(
                    Some(id), target, damage * if lane { 0.75 } else { 1. },
                    damage::DamageKind::Physical,
                );
            }
        }
        for (id, u) in ultimates {
            if self.players[&id].health <= 0. {
                continue;
            }
            if let Some(target) = self
                .players
                .get(&u.target)
                .filter(|p| p.health > 0. && p.team != self.players[&id].team)
            {
                let raw = garen_value(3, "Effect1", u.rank)
                    + (target.max_health - target.health) / garen_value(3, "Effect2", u.rank);
                let _ = self.apply_damage(Some(id), u.target, raw, damage::DamageKind::Magical);
            }
        }
    }
}
