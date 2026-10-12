//! Local presentation of the existing generic Vilemaw attack only.
//! Damage, 46-tick cadence, 30-tick preparation and facing remain authoritative
//! and unchanged. The actual loaded clip supplies the visual lifetime, not hit time.
use openleague_core::{attack_presentation::{Attack, Kind, Phase}, vilemaw_attacks, Snapshot, TICK_RATE};

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Selection {
    pub attack: u64,
    pub kind: Kind,
    pub role: &'static str,
    pub started: u64,
    pub age_seconds: f32,
}
#[derive(Debug, Clone, Copy, PartialEq)]
struct Context { attack: Attack, resolved: bool }
#[derive(Debug, Clone, Copy, PartialEq)]
struct Anchor { attack: Attack, age: f64, received_at: f64 }
impl Anchor {
    fn new(attack: Attack, tick: u64, now: f64) -> Self {
        Self { attack, age: tick.saturating_sub(attack.started) as f64 / TICK_RATE as f64, received_at: now }
    }
    fn advance(&mut self, tick: u64, now: f64) -> Result<(), String> {
        let now = now.max(self.received_at);
        let network_age = tick.saturating_sub(self.attack.started) as f64 / TICK_RATE as f64;
        let age = (self.age + (now - self.received_at)).max(network_age);
        if !age.is_finite() { return Err("Vilemaw presentation clock overflow".into()); }
        self.age = age; self.received_at = now; Ok(())
    }
}

#[derive(Debug, Default, Clone, PartialEq)]
pub struct State {
    journal: vilemaw_attacks::Journal,
    context: Option<Context>,
    // One last identity across fog, not an ever-growing map of respawn IDs.
    // The next global attack ID replaces it with a fresh network-age anchor.
    anchor: Option<Anchor>,
    interrupted_through: u64,
    finished: bool,
    error: Option<String>,
}
impl State {
    pub fn reset(&mut self, session: u64) { *self = Self::default(); self.journal.reset(session); }
    pub fn error(&self) -> Option<&str> { self.error.as_deref() }
    pub fn begin_epoch(&mut self, session: u64, epoch: u64) -> Result<bool, String> {
        self.journal.begin_epoch(session, epoch).map_err(|e| format!("invalid Vilemaw presentation epoch: {e:?}"))
    }
    pub fn observe(&mut self, snapshot: &Snapshot, now: f64) -> Result<bool, String> {
        self.observe_ordered(snapshot, None, now)
    }
    pub fn observe_frame(&mut self, snapshot: &Snapshot, ordinal: u64, now: f64) -> Result<bool, String> {
        self.observe_ordered(snapshot, Some(ordinal), now)
    }
    fn observe_ordered(&mut self, snapshot: &Snapshot, ordinal: Option<u64>, now: f64) -> Result<bool, String> {
        if !now.is_finite() { return Err("non-finite Vilemaw presentation clock".into()); }
        let mut next = self.clone();
        let accepted = match ordinal {
            Some(ordinal) => next.journal.accept_frame(snapshot, ordinal),
            None => next.journal.accept(snapshot),
        }.map_err(|e| format!("invalid Vilemaw presentation snapshot: {e:?}"))?;
        if !accepted { return Ok(false); }
        if let Some(anchor) = next.anchor.as_mut() { anchor.advance(snapshot.tick, now)?; }
        let unit = snapshot.units.iter().find(|unit| vilemaw_attacks::is_vilemaw(unit));
        if next.context.is_some_and(|context| unit.is_none_or(|unit| unit.id != context.attack.source)) {
            next.context = None; // visibility loss is not an interruption barrier
        }
        next.finished |= snapshot.winner.is_some() || snapshot.result.is_some();
        if let Some(error) = snapshot.vilemaw_attack_presentation_error.as_ref() {
            next.error.get_or_insert_with(|| error.clone());
        }
        let observations = next.journal.drain();
        if next.journal.unavailable() || next.error.is_some() || next.finished {
            if next.journal.unavailable() && next.error.is_none() {
                next.error = Some("Vilemaw presentation unavailable".into());
            }
            next.context = None; *self = next; return Ok(true);
        }
        for observation in observations {
            let event = observation.event;
            if event.attack.id <= next.interrupted_through { continue; }
            match next.anchor {
                Some(anchor) if event.attack.id < anchor.attack.id => return Err("Vilemaw identity went backwards".into()),
                Some(anchor) if event.attack.id == anchor.attack.id => {
                    if event.attack != anchor.attack { return Err("Vilemaw identity changed".into()); }
                }
                _ => next.anchor = Some(Anchor::new(event.attack, snapshot.tick, now)),
            }
            match event.phase {
                Phase::Started { .. } => next.context = Some(Context { attack: event.attack, resolved: false }),
                Phase::Resolved { .. } => next.context = Some(Context { attack: event.attack, resolved: true }),
                Phase::Cancelled { .. } => next.interrupt(event.attack.id),
            }
        }
        if let Some(unit) = unit {
            let active = unit.attack_presentation.map(|attack| attack.id);
            // Local visual priority, not a change to the pending hit. Running
            // interrupts the clip even if the server retains its old target.
            let blocked = unit.health <= 0. || !unit.health.is_finite()
                || openleague_core::stuns::unit_active(unit, snapshot.tick) || unit.destination.is_some();
            if blocked {
                if let Some(context) = next.context { next.interrupt(context.attack.id); }
                if let Some(active) = active { next.interrupt(active); }
            } else if let Some(context) = next.context {
                let replacement = active.is_some() && active != Some(context.attack.id);
                let disappeared = !context.resolved && active != Some(context.attack.id);
                if replacement || disappeared { next.interrupt(context.attack.id); }
            }
        }
        *self = next; Ok(true)
    }
    fn interrupt(&mut self, id: u64) {
        self.interrupted_through = self.interrupted_through.max(id);
        if self.context.is_some_and(|context| context.attack.id <= id) { self.context = None; }
    }
    /// `now` must remain in the same EffectClock domain as observe(). Paused
    /// EffectClock does not advance age. No fallback duration or 12-tick window.
    pub fn selection(&self, source: u32, now: f64, loaded_attack_duration: Option<f32>) -> Option<Selection> {
        if self.finished || self.error.is_some() || !now.is_finite() { return None; }
        let context = self.context.filter(|context| context.attack.source == source)?;
        let anchor = self.anchor.filter(|anchor| anchor.attack == context.attack)?;
        let duration = loaded_attack_duration.filter(|duration| duration.is_finite() && *duration > 0.)?;
        let age = anchor.age + (now - anchor.received_at).max(0.);
        if !age.is_finite() || age >= f64::from(duration) { return None; }
        Some(Selection { attack: context.attack.id, kind: Kind::Basic, role: "attack",
            started: context.attack.started, age_seconds: age as f32 })
    }
}

#[cfg(test)]
#[path = "vilemaw_attack_animation_tests.rs"]
pub(crate) mod tests;
