//! Base Smite only. Riot 4.20.1 damage table and original client fields.
//! Cooldown90 and center-distance760 are explicit local reconstruction policies;
//! original Map10 server cooldown/range geometry and jungle upgrades remain unknown.
use crate::*;
use std::sync::OnceLock;

#[derive(Deserialize)]
struct TargetProfile {
    kind: world::Kind,
    tags: Vec<String>,
}
#[derive(Deserialize)]
struct Rules {
    damage_by_level: [f32; 18],
    cast_range: f32,
    provisional_client_default_cooldown_seconds: u64,
    required_any_tag: Vec<String>,
    targets: BTreeMap<String, TargetProfile>,
    unsupported_jungle_items: Vec<u32>,
}
fn rules() -> &'static Rules {
    static DATA: OnceLock<Rules> = OnceLock::new();
    DATA.get_or_init(|| {
        serde_json::from_str(include_str!("../../../data/4.20/smite_rules.json"))
            .expect("verified bounded Smite profile")
    })
}
pub fn range() -> f32 { rules().cast_range }
pub fn damage_at_level(level: u8) -> Option<f32> {
    level.checked_sub(1).and_then(|index| rules().damage_by_level.get(index as usize)).copied()
}
pub fn provisional_cooldown_ticks() -> u64 {
    rules().provisional_client_default_cooldown_seconds * TICK_RATE
}

/// Shared cursor/server preflight. Visibility is checked separately by the server;
/// the client only supplies candidates present in its visibility-filtered snapshot.
pub fn validate_target(owner: &Champion, victim: &world::Unit) -> Result<(), String> {
    if owner.team > 1 || !owner.health.is_finite() || owner.health <= 0.
        || !owner.position.finite() {
        return Err("invalid Smite caster state".into());
    }
    if victim.id == owner.id || victim.team > 2 || victim.team == owner.team
        || !victim.health.is_finite() || victim.health <= 0. || !victim.position.finite() {
        return Err("invalid Smite enemy or neutral target".into());
    }
    let profile = rules().targets.get(&victim.definition)
        .ok_or("Smite target resource is not qualified")?;
    if profile.kind != victim.kind || !profile.tags.iter()
        .any(|tag| rules().required_any_tag.contains(tag)) {
        return Err("Smite target lacks a required native tag".into());
    }
    // Current engine convention, not a qualification of native range geometry.
    let distance = owner.position.distance(victim.position);
    if !distance.is_finite() || distance > range() {
        return Err("Smite target out of range".into());
    }
    Ok(())
}

impl Simulation {
    pub(crate) fn cast_smite(&mut self, id: u32, slot: u8, target: Option<u32>)
        -> Result<(), String>
    {
        // Common summoner dispatch already checks slot/loadout/life/stun/cooldown/match.
        let target = target.ok_or("Smite requires an enemy minion or eligible neutral target")?;
        let owner = self.players.get(&id).ok_or("unknown Smite caster")?;
        if !owner.mana.is_finite() || owner.mana < 0. {
            return Err("invalid Smite caster resource state".into());
        }
        for item in owner.inventory.iter().flatten() {
            if rules().unsupported_jungle_items.contains(item) {
                return Err("Smite jungle-item interaction is not implemented".into());
            }
            if !shop::catalog().iter().any(|known| known.id == *item) {
                return Err("Smite inventory item behavior is not implemented".into());
            }
        }
        let raw = damage_at_level(owner.level).ok_or("invalid Smite caster level")?;
        let victim = self.units.get(&target).ok_or("Smite cannot target a champion or unknown unit")?;
        validate_target(owner, victim)?;
        if self.target_info(target).is_none() {
            return Err("Smite target world resource is unavailable".into());
        }
        if !self.visible_to(owner.team, target) {
            return Err("Smite target not visible".into());
        }
        let ready_at = self.tick.checked_add(provisional_cooldown_ticks())
            .ok_or("Smite cooldown deadline overflow")?;
        // Real shared damage path retains protection, aggro, death, rewards and XP.
        // All preflight above is read-only; no resource or cooldown is spent on rejection.
        self.apply_damage(Some(id), target, raw, damage::DamageKind::True)?;
        self.players.get_mut(&id).unwrap().summoners.ready_at[slot as usize] = ready_at;
        Ok(())
    }
}

#[cfg(test)]
#[path = "summoner_smite_tests.rs"]
mod tests;
