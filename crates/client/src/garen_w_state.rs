//! Local sustained Courage presentation, derived from the current server contract.
//! This does not reconstruct the native six-effect caller, particles or Spell2.
//! Read every accepted snapshot before coalescing; the caller supplies EffectClock.now.
use openleague_core::{Champion, Snapshot, TICK_RATE};
use std::collections::{BTreeMap, BTreeSet};

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct Identity {
    pub session: u64,
    pub source: u32,
    pub started: u64,
    pub end: u64,
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Sustained {
    pub identity: Identity,
    pub age_seconds: f32,
}

#[derive(Debug, Clone, Copy, PartialEq)]
struct Anchor {
    identity: Identity,
    age: f64,
    received_at: f64,
    retired: bool,
}
impl Anchor {
    fn new(identity: Identity, tick: u64, now: f64) -> Self {
        Self { identity, age: (tick - identity.started) as f64 / TICK_RATE as f64,
            received_at: now, retired: false }
    }
    fn advance(&mut self, tick: u64, now: f64) -> Result<(), String> {
        let now = now.max(self.received_at);
        let network_age = tick.saturating_sub(self.identity.started) as f64 / TICK_RATE as f64;
        let age = (self.age + (now - self.received_at)).max(network_age);
        if !age.is_finite() { return Err("Courage presentation clock overflow".into()); }
        self.age = age;
        self.received_at = now;
        Ok(())
    }
}

#[derive(Debug, Clone, PartialEq)]
pub struct State {
    session: u64,
    capacity: usize,
    latest_tick: Option<u64>,
    epoch: Option<u64>,
    last_frame: Option<u64>,
    // One identity per Garen still in the public roster; fog keeps only this age.
    anchors: BTreeMap<u32, Anchor>,
    visible: BTreeSet<u32>,
    finished: bool,
}

impl State {
    pub fn new(session: u64, capacity: usize) -> Result<Self, String> {
        if capacity == 0 { return Err("Courage presentation capacity must be positive".into()); }
        Ok(Self { session, capacity, latest_tick: None, epoch: None, last_frame: None, anchors: BTreeMap::new(),
            visible: BTreeSet::new(), finished: false })
    }
    pub fn reset(&mut self, session: u64) {
        self.session = session;
        self.latest_tick = None;
        self.epoch = None;
        self.last_frame = None;
        self.anchors.clear();
        self.visible.clear();
        self.finished = false;
    }

    /// No partial mutation on Err. Duplicate/older ticks return false unchanged.
    /// A new session is adopted only through reset(), not from an arbitrary packet.
    pub fn begin_epoch(&mut self, session: u64, epoch: u64) -> Result<bool, String> {
        if session != self.session { return Err("Courage snapshot belongs to another session".into()); }
        if epoch == 0 { return Err("invalid Courage frame epoch".into()); }
        if self.epoch.is_some_and(|old| epoch <= old) { return Ok(false); }
        self.epoch = Some(epoch); self.last_frame = None; Ok(true)
    }
    pub fn observe(&mut self, snapshot: &Snapshot, now: f64) -> Result<bool, String> {
        self.observe_ordered(snapshot, None, now)
    }
    pub fn observe_frame(&mut self, snapshot: &Snapshot, frame: u64, now: f64) -> Result<bool, String> {
        self.observe_ordered(snapshot, Some(frame), now)
    }
    fn observe_ordered(&mut self, snapshot: &Snapshot, frame: Option<u64>, now: f64) -> Result<bool, String> {
        if !now.is_finite() || now < 0. { return Err("invalid Courage effect clock".into()); }
        if snapshot.session != self.session { return Err("Courage snapshot belongs to another session".into()); }
        if let Some(frame) = frame {
            if frame == 0 { return Err("invalid Courage frame ordinal".into()); }
            if self.epoch.is_none() { return Err("Courage frame epoch missing".into()); }
            if self.last_frame.is_some_and(|old| frame <= old) { return Ok(false); }
        }
        if self.latest_tick.is_some_and(|tick| snapshot.tick < tick || (frame.is_none() && snapshot.tick == tick)) { return Ok(false); }
        let mut roster = BTreeMap::new();
        for entry in &snapshot.roster {
            if roster.insert(entry.id, entry.champion.as_str()).is_some() {
                return Err("duplicate Courage roster source".into());
            }
        }
        if roster.values().filter(|champion| **champion == "garen").count() > self.capacity {
            return Err("Courage roster exceeds configured capacity".into());
        }
        let mut seen = BTreeSet::new();
        let mut current = BTreeMap::new();
        for player in &snapshot.players {
            if !seen.insert(player.id) { return Err("duplicate visible Courage source".into()); }
            if roster.get(&player.id).copied() != Some(player.champion.as_str()) {
                return Err("visible Courage source disagrees with roster".into());
            }
            if player.champion == "garen" {
                current.insert(player.id, active_identity(snapshot.session, snapshot.tick, player)?);
            }
        }
        let mut next = self.clone();
        next.anchors.retain(|source, _| roster.get(source).copied() == Some("garen"));
        for anchor in next.anchors.values_mut() { anchor.advance(snapshot.tick, now)?; }
        next.visible.clear(); // Includes a hidden intermediate snapshot in one receive batch.
        next.finished |= snapshot.winner.is_some() || snapshot.result.is_some();
        if !next.finished {
            for (source, identity) in current {
                let Some(identity) = identity else {
                    // Death/explicit cleared bonus cannot revive the old identity.
                    // This is local cleanup, not native PersistThruDeath or Fade.
                    if let Some(anchor) = next.anchors.get_mut(&source) { anchor.retired = true; }
                    continue;
                };
                if let Some(previous) = next.anchors.get(&source) {
                    if identity.started < previous.identity.started {
                        return Err("Courage identity went backwards".into());
                    }
                    if identity.started == previous.identity.started && identity != previous.identity {
                        return Err("Courage identity changed within one cast".into());
                    }
                }
                if next.anchors.get(&source).is_none_or(|a| a.identity != identity) {
                    // New casts use their own network age, never a previous cast's extrapolation.
                    next.anchors.insert(source, Anchor::new(identity, snapshot.tick, now));
                }
                if !next.anchors[&source].retired { next.visible.insert(source); }
            }
        }
        next.latest_tick = Some(snapshot.tick);
        if let Some(frame) = frame { next.last_frame = Some(frame); }
        *self = next;
        Ok(true)
    }

    /// The caller must use the same monotonic EffectClock domain as observe().
    /// First sight or resumed visibility yields only a sustained state. There is
    /// deliberately no Created/Burst/Fade output and no animation role change.
    pub fn sustained(&self, source: u32, now: f64) -> Option<Sustained> {
        if self.finished || !self.visible.contains(&source) || !now.is_finite() || now < 0. { return None; }
        let anchor = self.anchors.get(&source).filter(|anchor| !anchor.retired)?;
        let age = anchor.age + (now - anchor.received_at).max(0.);
        let duration = (anchor.identity.end - anchor.identity.started) as f64 / TICK_RATE as f64;
        if !age.is_finite() || age >= duration || age > f32::MAX as f64 { return None; }
        Some(Sustained { identity: anchor.identity, age_seconds: age as f32 })
    }
}

fn active_identity(session: u64, tick: u64, player: &Champion) -> Result<Option<Identity>, String> {
    if !player.health.is_finite() { return Err("non-finite Courage source health".into()); }
    let end = player.effects.courage_until;
    if player.health <= 0. || player.respawn_at.is_some() || end <= tick { return Ok(None); }
    let total = player.cooldown_totals[1].filter(|total| *total > 0)
        .ok_or("active Courage lacks committed cooldown total")?;
    let ready = player.cooldowns[1];
    let started = ready.checked_sub(total).ok_or("Courage cooldown underflow")?;
    if started > tick || end <= started || end > ready {
        return Err("incoherent Courage start/end/cooldown".into());
    }
    Ok(Some(Identity { session, source: player.id, started, end }))
}

#[cfg(test)]
#[path = "garen_w_state_tests.rs"]
mod tests;
