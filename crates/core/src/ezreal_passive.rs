//! Partial LOCAL Rising Spell Force policy, not recovered server callbacks.
//! Primary text4.20.1:10% AS,6seconds,max5. Root-approved reconstruction:
//! one stack per accepted distinct Q/W/E/R contact, shared180tick refresh,
//! including real allied/self W buff contact (caster only), never cast-only.
//! Private state contributes additively to real AA stats; owner-only HUD count is optional.
use crate::*;

pub const STACK_TICKS: u64 = 6 * TICK_RATE;
pub const MAX_STACKS: u8 = 5;
const MAX_OWNERS: usize = 64;
const MAX_FAULTS: usize = 32;

#[derive(Debug, Clone, Copy)]
struct Buff { team: u8, stacks: u8, last_hit: u64, until: u64 }
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Fault { pub tick: u64, pub owner: u32, pub reason: &'static str }
#[derive(Debug, Default)]
pub(crate) struct State {
    session: Option<u64>, last_tick: Option<u64>, buffs: BTreeMap<u32, Buff>, faults: VecDeque<Fault>,
}
impl State {
    fn fault(&mut self, tick: u64, owner: u32, reason: &'static str) {
        if self.faults.len() == MAX_FAULTS { self.faults.pop_front(); }
        self.faults.push_back(Fault { tick, owner, reason });
    }
}
impl Simulation {
    pub(crate) fn clear_ezreal_passive(&mut self) {
        self.ezreal_passive.buffs.clear(); self.ezreal_passive.session = Some(self.session);
        self.ezreal_passive.last_tick = None;
    }
    pub(crate) fn remove_ezreal_passive_owner(&mut self, owner: u32) { self.ezreal_passive.buffs.remove(&owner); }
    pub(crate) fn prune_ezreal_passive(&mut self) {
        if self.winner.is_some() || self.ezreal_passive.session.is_some_and(|s| s != self.session)
            || self.ezreal_passive.last_tick.is_some_and(|t| self.tick < t) {
            self.clear_ezreal_passive();
        }
        self.ezreal_passive.session = Some(self.session); self.ezreal_passive.last_tick = Some(self.tick);
        let players = &self.players; let tick = self.tick;
        self.ezreal_passive.buffs.retain(|id, buff| {
            players.get(id).is_some_and(|p| p.id == *id && p.champion == "ezreal" && p.team == buff.team
                && p.health.is_finite() && p.health > 0.)
                && (1..=MAX_STACKS).contains(&buff.stacks) && buff.last_hit <= tick && tick < buff.until
                && buff.last_hit.checked_add(STACK_TICKS) == Some(buff.until)
        });
    }
    /// Trusted consumed-contact hook only. It is not an action, damage API or
    /// decoder of replayable network/presentation facts. It cannot reject damage.
    /// Each caller owns once-only contact consumption before calling this hook.
    pub(crate) fn accepted_ezreal_ability_contact(&mut self, owner: u32, team: u8, session: u64) {
        self.prune_ezreal_passive(); // Expire BEFORE a new hit, including same tick.
        if self.winner.is_some() || session != self.session || team > 1
            || !self.players.get(&owner).is_some_and(|p| p.id == owner && p.champion == "ezreal" && p.team == team
                && p.health.is_finite() && p.health > 0.) { return; }
        let Some(until) = self.tick.checked_add(STACK_TICKS) else {
            self.ezreal_passive.fault(self.tick, owner, "passive expiry clock overflow"); return;
        };
        if !self.ezreal_passive.buffs.contains_key(&owner) && self.ezreal_passive.buffs.len() >= MAX_OWNERS {
            self.ezreal_passive.fault(self.tick, owner, "passive owner budget exhausted"); return;
        }
        let stacks = self.ezreal_passive.buffs.get(&owner).map_or(1, |b| b.stacks.saturating_add(1).min(MAX_STACKS));
        self.ezreal_passive.buffs.insert(owner, Buff { team, stacks, last_hit: self.tick, until });
    }
    /// Validated local getter, also used by the owner-only count projection.
    pub fn ezreal_passive_stacks(&self, owner: u32) -> u8 {
        if self.winner.is_some() || self.ezreal_passive.session != Some(self.session)
            || self.ezreal_passive.last_tick.is_some_and(|t| self.tick < t) { return 0; }
        let Some(buff) = self.ezreal_passive.buffs.get(&owner) else { return 0; };
        if !self.players.get(&owner).is_some_and(|p| p.id == owner && p.champion == "ezreal" && p.team == buff.team
            && p.health.is_finite() && p.health > 0.) || !(1..=MAX_STACKS).contains(&buff.stacks)
            || buff.last_hit > self.tick || self.tick >= buff.until
            || buff.last_hit.checked_add(STACK_TICKS) != Some(buff.until) { return 0; }
        buff.stacks
    }
    pub(crate) fn ezreal_passive_attack_speed_bonus(&self, owner: u32) -> f32 {
        f32::from(self.ezreal_passive_stacks(owner)) * 0.10
    }
    pub fn ezreal_passive_faults(&self) -> Vec<Fault> { self.ezreal_passive.faults.iter().cloned().collect() }
}
/// Owner-only LOCAL HUD value. Expiry remains authoritative in the existing
/// getter; this DTO exposes neither a timer nor a hit target/location.
#[derive(Debug, Clone, Copy, Serialize, Deserialize, PartialEq, Eq)]
pub struct OwnerPassive { pub session: u64, pub owner: u32, pub stacks: u8 }
impl Simulation {
    pub(crate) fn ezreal_passive_self_projection(&self, viewer: u32) -> Option<OwnerPassive> {
        if self.winner.is_some() || !self.players.get(&viewer).is_some_and(|p|
            p.id == viewer && p.champion == "ezreal" && p.team <= 1
                && p.health.is_finite() && p.health > 0.) { return None; }
        Some(OwnerPassive { session: self.session, owner: viewer, stacks: self.ezreal_passive_stacks(viewer) })
    }
}

#[cfg(test)]
#[path = "ezreal_passive_tests.rs"]
mod tests;
