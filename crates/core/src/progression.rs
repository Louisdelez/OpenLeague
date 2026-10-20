//! Map10 progression from the supplied native curve; XP cannot be granted by client commands.
use crate::*;
#[derive(Clone, Deserialize)]
pub(crate) struct Growth {
    pub health: f32,
    pub mana: f32,
    pub damage: f32,
    pub armor: f32,
    pub mr: f32,
    pub attack_speed_percent: f32,
    pub health_regen: f32,
    pub mana_regen: f32,
    pub health_regen_growth: f32,
    pub mana_regen_growth: f32,
}
#[derive(Debug, Clone, Copy)]
pub struct Stats {
    pub damage: f32,
    pub ability_power: f32,
    pub cooldown_reduction: f32,
    pub armor_penetration: f32,
    pub armor_penetration_percent: f32,
    pub magic_penetration: f32,
    pub magic_penetration_percent: f32,
    pub critical_chance: f32,
    pub critical_multiplier: f32,
    pub life_steal: f32,
    pub armor: f32,
    pub magic_resist: f32,
    pub max_mana: f32,
    pub max_health: f32,
    pub move_speed: f32,
    pub attack_cooldown_ticks: u64,
}
// LOCAL decomposition: total preserves the previous expression/branch exactly.
// Base comes from the actual champion/growth, not a constant; signed bonus also
// includes temporary altar changes. Stats total0 implies bonus=-level_base.
#[derive(Debug, Clone, Copy)]
pub(crate) struct AttackDamageComponents { pub level_base: f32, pub total: f32, pub bonus: f32 }
pub(crate) fn ad_components(base: f32, growth: f32, factor: f32, item: f32, altar: f32, adjustment: f32) -> AttackDamageComponents {
    let level_base = base + growth * factor;
    let existing = (base + growth * factor + item) * altar;
    let total = if adjustment == 0. { existing } else { (existing + adjustment).max(0.) };
    AttackDamageComponents { level_base, total, bonus: total - level_base }
}
pub fn growth_total(level: u8) -> f32 {
    let n = level.clamp(1, 18) as f32 - 1.;
    0.685 * n + 0.035 * n * (n + 1.) / 2.
}
pub(crate) fn threshold(level: u8) -> f32 {
    let value: serde_json::Value = serde_json::from_str(include_str!(
        "../../../data/4.20/experience_curve_map10.json"
    ))
    .expect("native XP curve");
    let v = &value["Values"]["EXP"][format!("Level{}", level)];
    v.as_f64()
        .map(|n| n as f32)
        .unwrap_or_else(|| v.as_str().unwrap().parse().unwrap())
}
impl Simulation {
    pub(crate) fn attack_damage_components(&self, id: u32) -> Result<AttackDamageComponents, String> {
        let p = self.players.get(&id).ok_or("unknown AD owner")?;
        let base = self.definitions.get(&p.champion).ok_or("AD definition missing")?;
        let g = self.growth.get(&p.champion).ok_or("AD growth missing")?;
        Ok(ad_components(base.attack_damage,g.damage,growth_total(p.level),shop::bonuses(p).damage,
            self.altar_damage_multiplier(p.team),self.trundle_q_ad_adjustment(id)))
    }
    pub fn stats(&self, id: u32) -> Stats {
        let p = &self.players[&id];
        let base = &self.definitions[&p.champion];
        let g = &self.growth[&p.champion];
        let factor = growth_total(p.level);
        let items = shop::bonuses(p);
        let bonus_defense = if p.champion == "garen" && p.ranks[1] > 0 {
            1. + spells::garen_value(1, "Effect1", p.ranks[1]) / 100.
        } else {
            1.
        };
        // Pure R lookup; no stats() recursion or persistent base/item mutation.
        let r_defense = self.trundle_r_defense_adjustment(id);
        // Garen W amplifies bonus defenses only; level growth is part of base defenses.
        Stats {
            armor_penetration: items.armor_penetration,
            armor_penetration_percent: items.armor_penetration_percent,
            magic_penetration: items.magic_penetration,
            magic_penetration_percent: items.magic_penetration_percent,
            ability_power: items.ability_power * self.altar_damage_multiplier(p.team),
            cooldown_reduction: items.cooldown_reduction.clamp(0., cooldown::maximum_reduction()),
            // Same totalAD arithmetic; the independent signed component serves R.
            damage: ad_components(base.attack_damage,g.damage,factor,items.damage,
                self.altar_damage_multiplier(p.team),self.trundle_q_ad_adjustment(id)).total,
            critical_chance: (critical::profile(&p.champion).chance
                + critical::profile(&p.champion).chance_growth * factor
                + items.critical_chance)
                .clamp(0., 1.),
            critical_multiplier: (critical::profile(&p.champion).multiplier
                + items.critical_damage)
                .max(1.),
            life_steal: items.life_steal.max(0.),
            armor: {
                let existing=base.armor + g.armor * factor + items.armor * bonus_defense + annie::defense(p,self.tick)
                    - summoner_exhaust::defense_reduction(p, self.tick);
                if r_defense.0==0. {existing} else {existing+r_defense.0}
            },
            magic_resist: {
                let existing=base.magic_resist + g.mr * factor + items.magic_resist * bonus_defense + annie::defense(p,self.tick)
                    - summoner_exhaust::defense_reduction(p, self.tick);
                if r_defense.1==0. {existing} else {existing+r_defense.1}
            },
            max_mana: base.mana
                + g.mana * factor
                + if lifecycle::uses_mana(&p.champion) {
                    items.mana
                } else {
                    0.
                },
            max_health: base.health + g.health * factor + items.health,
            move_speed: self.movement_speed(id),
            attack_cooldown_ticks: ((base.attack_cooldown_ticks as f32
                / (1. + g.attack_speed_percent / 100. * factor + items.attack_speed
                    + trundle_w::attack_speed_bonus(p, self.tick)
                    + self.ezreal_w_attack_speed_bonus(id)
                    + self.ezreal_passive_attack_speed_bonus(id)
                    - summoner_exhaust::attack_speed_bonus_penalty(p, self.tick))
                .max(0.05))
            .round() as u64)
                .max(12),
        }
    }
    /// Server event API. There is deliberately no network action to award XP.
    pub fn award_experience(&mut self, id: u32, amount: f32) -> Result<(), String> {
        if !amount.is_finite() || amount <= 0. {
            return Err("invalid experience award".into());
        }
        let p = self.players.get_mut(&id).ok_or("unknown player")?;
        p.experience += amount;
        let old_factor = growth_total(p.level);
        while p.level < 18 && p.experience >= threshold(p.level + 1) {
            p.level += 1;
        }
        let delta = growth_total(p.level) - old_factor;
        let growth = &self.growth[&p.champion];
        p.max_health += growth.health * delta;
        if p.health > 0. {
            p.health = (p.health + growth.health * delta).min(p.max_health);
            p.mana += growth.mana * delta;
        }
        Ok(())
    }
    pub fn learn(&mut self, id:u32, slot:u8)->Result<(),String> {
        if slot>3 {return Err("invalid skill slot".into());}
        let p=self.players.get(&id).ok_or("unknown player")?;
        let next=next_rank(p,slot)?;
        self.players.get_mut(&id).unwrap().ranks[slot as usize]=next;
        Ok(())
    }
}
// Shared authoritative eligibility, also used by the native learning HUD.
pub fn next_rank(p:&Champion,slot:u8)->Result<u8,String> {
    if slot>3 {return Err("invalid skill slot".into());}
        // Special ranking schemes need dedicated native contracts, never a fabricated fallback.
        // Ezreal R now uses the existing level6/11/16 three-rank contract below.
        if p.champion != "garen" && p.champion != "annie" && p.champion != "trundle" && p.champion != "ezreal" {
            return Err("champion skill progression not implemented".into());
        }
        if p.ranks.iter().map(|n| *n as u16).sum::<u16>() >= p.level as u16 {
            return Err("no skill points".into());
        }
        let next = p.ranks[slot as usize].checked_add(1).ok_or("maximum skill rank")?;
        let gate = if slot == 3 {
            if next > 3 {
                return Err("maximum skill rank".into());
            }
            [6, 11, 16][next as usize - 1]
        } else {
            if next > 5 {
                return Err("maximum skill rank".into());
            }
            2 * next - 1
        };
        if p.level < gate {
            return Err("skill requires a higher level".into());
        }
    Ok(next)
}
