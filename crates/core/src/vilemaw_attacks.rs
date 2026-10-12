//! Presentation identity of OpenLeague's EXISTING generic Vilemaw attack.
//! No native AI, special spell, attack timing or damage policy is introduced.
//! The one-source capacity describes the current Map10 camp, not a Riot limit.
use crate::{attack_presentation as attack, world, Simulation, Snapshot};

pub const DEFINITION: &str = "TT_Spiderboss";
pub fn is_vilemaw(unit: &world::Unit) -> bool {
    unit.kind == world::Kind::Boss && unit.definition == DEFINITION
}
pub fn limits() -> attack::Limits {
    attack::Limits::new(1).expect("fixed one-source local capacity fits usize")
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Stage { Windup, Resolving }
#[derive(Debug, Clone, Copy)]
struct Active { attack: attack::Attack, target: u32, stage: Stage }

/// Kept in Simulation, never in World or its temporarily detached Pending Vec.
/// Target and execution stage are private and never serialized.
pub(crate) struct State {
    journal: attack::State,
    active: Option<Active>,
    error: Option<String>,
}
impl Default for State {
    fn default() -> Self { Self { journal: attack::State::new(limits()), active: None, error: None } }
}
impl State {
    fn result<T>(&mut self, result: Result<T, attack::Error>) -> Option<T> {
        match result {
            Ok(value) => Some(value),
            Err(error) => {
                self.error.get_or_insert_with(|| format!("Vilemaw attack presentation unavailable: {error:?}"));
                None
            }
        }
    }
    fn begin(&mut self, source: u32, target: u32, tick: u64, release: u64, audience: attack::Audience) -> Option<attack::Attack> {
        if self.error.is_some() { return None; }
        let result = self.journal.begin(source, tick, release, attack::Kind::Basic, audience);
        let value = self.result(result)?;
        self.active = Some(Active { attack: value, target, stage: Stage::Windup });
        Some(value)
    }
    fn windup(&self, source: u32) -> Option<Active> {
        self.active.filter(|active| active.attack.source == source && active.stage == Stage::Windup)
    }
    /// Snapshot-only identity. Diagnostics make presentation unavailable but do
    /// not prevent terminal cleanup of a previously tracked attack.
    pub(crate) fn active(&self, source: u32) -> Option<attack::Attack> {
        if self.error.is_some() { return None; }
        self.windup(source).map(|active| active.attack)
    }
    fn resolving(&mut self, value: attack::Attack) -> bool {
        if let Some(active) = self.active.as_mut().filter(|active| active.attack == value && active.stage == Stage::Windup) {
            active.stage = Stage::Resolving;
            true
        } else { false }
    }
    fn cancel(&mut self, value: attack::Attack, tick: u64, reason: attack::CancelReason, audience: attack::Audience) {
        if !self.active.is_some_and(|active| active.attack == value && active.stage == Stage::Windup) { return; }
        let result = self.journal.cancel(value, tick, reason, audience);
        self.active = None;
        self.result(result);
    }
    fn resolve(&mut self, value: attack::Attack, tick: u64, success: bool, audience: attack::Audience) {
        if !self.active.is_some_and(|active| active.attack == value && active.stage == Stage::Resolving) { return; }
        let result = self.journal.resolve(value, tick, attack::Kind::Basic, success, audience);
        self.active = None;
        self.result(result);
    }
    pub(crate) fn events(&self) -> Vec<attack::Event> { self.journal.events() }
    pub(crate) fn events_for(&self, team: u8, visible: impl FnMut(u32) -> bool) -> Result<Vec<attack::Event>, attack::Error> {
        self.journal.events_for(team, visible)
    }
    pub(crate) fn error(&self) -> Option<&str> { self.error.as_deref() }
}

#[derive(Clone, Copy)]
pub(crate) struct Captured { attack: attack::Attack, audience: attack::Audience }
impl Simulation {
    fn vilemaw_audience(&self, source: u32, target: u32) -> attack::Audience {
        attack::Audience::from_visibility(
            self.visible_to(0, source) && self.visible_to(0, target),
            self.visible_to(1, source) && self.visible_to(1, target))
    }
    pub(crate) fn begin_vilemaw_attack(&mut self, source: u32, target: u32, release: u64) -> Option<attack::Attack> {
        if self.winner.is_some() || !self.units.get(&source).is_some_and(is_vilemaw) { return None; }
        let audience = self.vilemaw_audience(source, target);
        self.vilemaw_attacks.begin(source, target, self.tick, release, audience)
    }
    pub(crate) fn capture_vilemaw_attack(&self, source: u32) -> Option<Captured> {
        let active = self.vilemaw_attacks.windup(source)?;
        Some(Captured { attack: active.attack, audience: self.vilemaw_audience(source, active.target) })
    }
    pub(crate) fn capture_active_vilemaw_attack(&self) -> Option<Captured> {
        self.capture_vilemaw_attack(self.vilemaw_attacks.active?.attack.source)
    }
    pub(crate) fn cancel_captured_vilemaw_attack(&mut self, captured: Option<Captured>, reason: attack::CancelReason) {
        let Some(captured) = captured else { return; };
        self.vilemaw_attacks.cancel(captured.attack, self.tick, reason, captured.audience);
    }
    pub(crate) fn cancel_vilemaw_attack(&mut self, source: u32, reason: attack::CancelReason) {
        let captured = self.capture_vilemaw_attack(source);
        self.cancel_captured_vilemaw_attack(captured, reason);
    }
    pub(crate) fn finish_vilemaw_attacks(&mut self) {
        let captured = self.capture_active_vilemaw_attack();
        self.cancel_captured_vilemaw_attack(captured, attack::CancelReason::MatchEnded);
    }
    pub(crate) fn vilemaw_discard_reason(&self, source: u32) -> attack::CancelReason {
        match self.units.get(&source) {
            None => attack::CancelReason::Departure,
            Some(unit) if unit.health <= 0. => attack::CancelReason::Death,
            _ => attack::CancelReason::Control,
        }
    }
    /// Capture before damage, then protect this in-flight operation against a
    /// reentrant source death (Annie retaliation) or match-end callback.
    pub(crate) fn begin_vilemaw_resolution(&mut self, value: Option<attack::Attack>) -> Option<Captured> {
        let value = value?;
        let captured = self.capture_vilemaw_attack(value.source)?;
        if captured.attack != value || !self.vilemaw_attacks.resolving(value) { return None; }
        Some(captured)
    }
    pub(crate) fn resolve_vilemaw_attack(&mut self, captured: Option<Captured>, success: bool) {
        let Some(captured) = captured else { return; };
        self.vilemaw_attacks.resolve(captured.attack, self.tick, success, captured.audience);
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Error {
    Protocol(attack::Error),
    InvalidProfile,
    InvalidActiveAttack,
    NonBasic,
}
impl From<attack::Error> for Error {
    fn from(error: attack::Error) -> Self { Self::Protocol(error) }
}

/// Separate receive journal: no Garen roster, clock, animation or gameplay.
/// Transport authenticates the epoch/frame; the client supplies EffectClock
/// only to its eventual age consumer after this transaction succeeds.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Journal { inner: attack::Journal, unavailable: bool }
impl Default for Journal {
    fn default() -> Self { Self { inner: attack::Journal::new(limits()), unavailable: false } }
}
impl Journal {
    pub fn reset(&mut self, session: u64) { self.inner.reset(session); self.unavailable = false; }
    pub fn begin_epoch(&mut self, session: u64, epoch: u64) -> Result<bool, Error> {
        self.inner.begin_epoch(session, epoch).map_err(Into::into)
    }
    pub fn limits(&self) -> attack::Limits { self.inner.limits() }
    pub fn unavailable(&self) -> bool { self.unavailable }
    pub fn accept(&mut self, snapshot: &Snapshot) -> Result<bool, Error> { self.accept_ordered(snapshot, None) }
    pub fn accept_frame(&mut self, snapshot: &Snapshot, ordinal: u64) -> Result<bool, Error> {
        self.accept_ordered(snapshot, Some(ordinal))
    }
    fn accept_ordered(&mut self, snapshot: &Snapshot, ordinal: Option<u64>) -> Result<bool, Error> {
        // A server-side presentation failure is not a gameplay/transport error.
        // Retain frame/session/tick ordering while permanently retiring this
        // presentation channel, including unexpected multi-boss capacity cases.
        let unavailable = self.unavailable || snapshot.vilemaw_attack_presentation_error.is_some();
        let visible: Vec<_> = if unavailable { Vec::new() } else {
            snapshot.units.iter().filter(|unit| is_vilemaw(unit)).map(|unit|
                attack::VisibleSource { source: unit.id, active_attack: unit.attack_presentation.map(|a| a.id) }).collect()
        };
        let events: &[attack::Event] = if unavailable { &[] } else { &snapshot.vilemaw_attack_events };
        let mut candidate = self.inner.clone();
        let accepted = match ordinal {
            Some(ordinal) => candidate.accept_frame(snapshot.session, ordinal, snapshot.tick, &visible, events),
            None => candidate.accept(snapshot.session, snapshot.tick, &visible, events),
        }?;
        // Preserve existing replay/decreasing-tick semantics before validating
        // stale payload metadata. No candidate state is published on any error.
        if !accepted { return Ok(false); }
        if unavailable {
            candidate.drain();
            self.inner = candidate;
            self.unavailable = true;
            return Ok(true);
        }
        for event in &snapshot.vilemaw_attack_events {
            if matches!(event.phase, attack::Phase::Started { kind } | attack::Phase::Resolved { kind, .. } if kind != attack::Kind::Basic) {
                return Err(Error::NonBasic);
            }
        }
        for unit in &snapshot.units {
            if let Some(active) = unit.attack_presentation {
                if !is_vilemaw(unit) { return Err(Error::InvalidProfile); }
                if unit.health <= 0. || !unit.health.is_finite() || active.source != unit.id
                    || active.started > snapshot.tick || !snapshot.vilemaw_attack_events.iter().any(|event|
                        event.attack == active && matches!(event.phase, attack::Phase::Started { kind: attack::Kind::Basic })) {
                    return Err(Error::InvalidActiveAttack);
                }
            }
        }
        self.inner = candidate;
        Ok(true)
    }
    pub fn drain(&mut self) -> Vec<attack::Observation> { self.inner.drain() }
    pub fn pending_len(&self) -> usize { self.inner.pending_len() }
}

#[cfg(test)]
#[path = "vilemaw_attack_journal_tests.rs"]
mod tests;
