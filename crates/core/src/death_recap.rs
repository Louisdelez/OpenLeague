//! Local owner-only damage recap. The fixed 15 s window and caps are local policy.
//! Captured labels describe pre-hit knowledge, never current hidden actors.
use crate::{damage::{DamageKind, DamageOutcome}, world, Simulation, TICK_RATE};
use serde::{Deserialize, Serialize};
use std::collections::{BTreeMap, VecDeque};

pub const POLICY: &str = "local_owner_death_recap_v1";
pub const WINDOW_TICKS: u64 = 15 * TICK_RATE;
pub const MAX_HITS: usize = 256;
pub const MAX_OWNERS: usize = 6;
pub const MAX_VISIBLE_ROWS: usize = 16;
pub const MAX_ROWS: usize = MAX_VISIBLE_ROWS + 2;
pub const MAX_BYTES: usize = 8192;

#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
#[serde(tag = "type", rename_all = "snake_case", deny_unknown_fields)]
pub enum Source {
    Champion { champion: String },
    Unit { kind: world::Kind, definition: String },
    Unknown,
    Other,
}
#[derive(Clone, Copy, Default, Debug, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Amount { pub health_removed: f32, pub shield_absorbed: f32 }
#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Row {
    /// Recap-local ordinal; never a world entity ID.
    pub key: u8,
    pub source: Source,
    pub physical: Amount,
    pub magical: Amount,
    pub true_damage: Amount,
    pub lethal: bool,
}
#[derive(Clone, Debug, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Recap {
    pub policy: String,
    pub session: u64,
    pub victim: u32,
    pub death_ordinal: u64,
    pub death_tick: u64,
    pub window_start: u64,
    pub truncated: bool,
    pub rows: Vec<Row>,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum DecodeError { Shape, Bound, Context }

fn label(s: &str) -> bool {
    !s.is_empty() && s.len() <= 64 && s.bytes().all(|b| b.is_ascii_alphanumeric() || b == b'_')
}
fn amount(a: Amount) -> bool {
    a.health_removed.is_finite() && a.health_removed >= 0.
        && a.shield_absorbed.is_finite() && a.shield_absorbed >= 0.
}
fn positive(a: Amount) -> bool { a.health_removed > 0. || a.shield_absorbed > 0. }
fn valid(r: &Recap) -> bool {
    if r.policy != POLICY || r.victim == 0 || r.death_ordinal == 0
        || r.window_start != r.death_tick.saturating_sub(WINDOW_TICKS)
        || r.rows.is_empty() || r.rows.len() > MAX_ROWS { return false; }
    let (mut known, mut unknown, mut other, mut lethal) = (0, 0, 0, 0);
    for (i, row) in r.rows.iter().enumerate() {
        if usize::from(row.key) != i + 1 || !amount(row.physical) || !amount(row.magical)
            || !amount(row.true_damage)
            || ![row.physical, row.magical, row.true_damage].into_iter().any(positive) { return false; }
        match &row.source {
            Source::Champion { champion } => { if !label(champion) { return false; } known += 1; }
            Source::Unit { definition, .. } => { if !label(definition) { return false; } known += 1; }
            Source::Unknown => unknown += 1,
            Source::Other => other += 1,
        }
        if row.lethal {
            lethal += 1;
            if ![row.physical, row.magical, row.true_damage].into_iter().any(|a| a.health_removed > 0.) { return false; }
        }
    }
    known <= MAX_VISIBLE_ROWS && unknown <= 1 && other <= 1 && lethal == 1
}
/// This validates a persistent own-death DTO; the caller must also require
/// accepted OLSR/session readiness and a currently dead canonical own player.
pub fn decode_view(value: Option<&serde_json::Value>, session: u64, victim: u32,
    snapshot_tick: u64) -> Result<Option<Recap>, DecodeError> {
    let Some(value) = value else { return Ok(None); };
    if serde_json::to_vec(value).map_err(|_| DecodeError::Shape)?.len() > MAX_BYTES { return Err(DecodeError::Bound); }
    let r: Recap = serde_json::from_value(value.clone()).map_err(|_| DecodeError::Shape)?;
    if !valid(&r) { return Err(DecodeError::Shape); }
    if r.session != session || r.victim != victim || r.death_tick > snapshot_tick { return Err(DecodeError::Context); }
    Ok(Some(r))
}

#[derive(Clone, PartialEq)]
struct Known { id: u32, source: Source }
pub(crate) struct Capture { session: u64, tick: u64, victim: u32, known: Option<Known> }
struct Hit { tick: u64, known: Option<Known>, kind: DamageKind, amount: Amount, lethal: bool }
#[derive(Default)]
struct Life {
    hits: VecDeque<Hit>, last_tick: u64, lost_through: Option<u64>,
    death_ordinal: u64, recap: Option<Recap>, invalid: bool,
}
#[derive(Default)]
pub(crate) struct State { session: Option<u64>, lives: BTreeMap<u32, Life> }
impl State {
    fn commit(&mut self, c: Capture, outcome: &DamageOutcome) {
        if self.session != Some(c.session) {
            self.session = Some(c.session); self.lives.clear();
        }
        if outcome.target != c.victim { return; }
        let a = Amount { health_removed: outcome.health_removed, shield_absorbed: outcome.shield_absorbed };
        if amount(a) && !positive(a) { return; }
        if !self.lives.contains_key(&c.victim) && self.lives.len() >= MAX_OWNERS { return; }
        let life = self.lives.entry(c.victim).or_default();
        if life.recap.is_some() { return; }
        if !amount(a) || c.tick < life.last_tick { life.invalid = true; }
        life.last_tick = c.tick;
        if life.invalid { return; }
        let start = c.tick.saturating_sub(WINDOW_TICKS);
        while life.hits.front().is_some_and(|h| h.tick < start) { life.hits.pop_front(); }
        if life.lost_through.is_some_and(|t| t < start) { life.lost_through = None; }
        if life.hits.len() == MAX_HITS {
            life.lost_through = life.hits.pop_front().map(|h| h.tick);
        }
        life.hits.push_back(Hit { tick: c.tick, known: c.known, kind: outcome.kind, amount: a, lethal: outcome.lethal });
        if outcome.lethal {
            let Some(ordinal) = life.death_ordinal.checked_add(1) else { life.invalid = true; return; };
            life.death_ordinal = ordinal;
            life.recap = freeze(c.session, c.victim, c.tick, ordinal, life);
            if life.recap.is_none() { life.invalid = true; }
            life.hits.clear();
        }
    }
    pub(crate) fn respawn(&mut self, session: u64, victim: u32) {
        if self.session != Some(session) { return; }
        if let Some(life) = self.lives.get_mut(&victim) {
            let ordinal = life.death_ordinal;
            *life = Life { death_ordinal: ordinal, ..Default::default() };
        }
    }
    pub(crate) fn remove(&mut self, victim: u32) { self.lives.remove(&victim); }
}
fn freeze(session: u64, victim: u32, tick: u64, ordinal: u64, life: &Life) -> Option<Recap> {
    // Keep private IDs only while grouping; the serialized rows never contain them.
    let mut keys: Vec<Option<Known>> = Vec::new();
    let mut rows: Vec<Row> = Vec::new();
    let mut other = None;
    let mut unknown = None;
    let mut visible = 0;
    for hit in &life.hits {
        let existing = if let Some(k) = &hit.known { keys.iter().position(|v| v.as_ref() == Some(k)) }
            else { unknown };
        let index = if let Some(i) = existing { i } else {
            let (source, key) = if let Some(k) = &hit.known {
                if visible == MAX_VISIBLE_ROWS {
                    if let Some(i) = other { add(&mut rows[i], hit)?; continue; }
                    (Source::Other, None)
                } else { visible += 1; (k.source.clone(), Some(k.clone())) }
            } else { (Source::Unknown, None) };
            let i = rows.len();
            match source { Source::Other => other = Some(i), Source::Unknown => unknown = Some(i), _ => {} }
            keys.push(key);
            rows.push(Row { key: (i + 1) as u8, source, physical: Amount::default(),
                magical: Amount::default(), true_damage: Amount::default(), lethal: false });
            i
        };
        add(&mut rows[index], hit)?;
    }
    let recap = Recap { policy: POLICY.into(), session, victim, death_ordinal: ordinal, death_tick: tick,
        window_start: tick.saturating_sub(WINDOW_TICKS), truncated: life.lost_through.is_some(), rows };
    if !valid(&recap) || serde_json::to_vec(&recap).ok()?.len() > MAX_BYTES { return None; }
    Some(recap)
}
fn add(row: &mut Row, hit: &Hit) -> Option<()> {
    let target = match hit.kind { DamageKind::Physical => &mut row.physical,
        DamageKind::Magical => &mut row.magical, DamageKind::True => &mut row.true_damage };
    target.health_removed += hit.amount.health_removed;
    target.shield_absorbed += hit.amount.shield_absorbed;
    if !amount(*target) { return None; }
    row.lethal |= hit.lethal;
    Some(())
}
impl Simulation {
    pub(crate) fn capture_death_recap(&self, source: Option<u32>, target: u32) -> Option<Capture> {
        let victim = self.players.get(&target)?;
        if victim.id != target || victim.team > 1 || !victim.health.is_finite() || victim.health <= 0. { return None; }
        let known = source.filter(|&id| self.visible_to(victim.team, id)).and_then(|id| {
            if let Some(p) = self.players.get(&id) {
                (p.id == id && label(&p.champion) && self.definitions.contains_key(&p.champion))
                    .then(|| Known { id, source: Source::Champion { champion: p.champion.clone() } })
            } else {
                let u = self.units.get(&id)?;
                let definition = self.world.as_ref()?.config.definitions.get(&u.definition)?;
                (u.id == id && u.kind == definition.kind && label(&u.definition))
                    .then(|| Known { id, source: Source::Unit { kind: u.kind, definition: u.definition.clone() } })
            }
        });
        Some(Capture { session: self.session, tick: self.tick, victim: target, known })
    }
    pub(crate) fn commit_death_recap(&mut self, capture: Option<Capture>, outcome: &DamageOutcome) {
        if let Some(c) = capture {
            if c.session == self.session && c.tick == self.tick { self.death_recap.commit(c, outcome); }
        }
    }
    pub(crate) fn death_recap_projection(&self, viewer: u32) -> Option<serde_json::Value> {
        let p = self.players.get(&viewer)?;
        if p.id != viewer || !p.health.is_finite() || p.health > 0. || p.respawn_at.is_none()
            || self.winner.is_some() || self.death_recap.session != Some(self.session) { return None; }
        let recap = self.death_recap.lives.get(&viewer)?.recap.as_ref()?;
        if recap.session != self.session || recap.victim != viewer || recap.death_tick > self.tick { return None; }
        serde_json::to_value(recap).ok()
    }
}

#[cfg(test)]
#[path = "death_recap_tests.rs"]
mod tests;
