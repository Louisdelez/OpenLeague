//! Draft for the local OpenLeague snapshot protocol, not the original wire format.
//! No damage, timing, animation playback, or visibility calculation lives here.
//! Audience is supplied from authoritative visibility and never serialized.

use serde::{Deserialize, Serialize};
use std::collections::{BTreeMap, BTreeSet, VecDeque};

// Local storage policies. These are not recovered Riot constants.
pub const HISTORY_CAPACITY: usize = 128;
/// Matches the current local Simulation::join limit, not a native constant.
pub const DEFAULT_ACTIVE_SOURCES: usize = 6;
pub const MAX_PENDING: usize = 512;

/// Trusted session configuration, never inferred from an incoming packet.
/// Server and receiver must use the same limits. No allocation is made here.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Limits {
    active_sources: usize,
    snapshot_events: usize,
    seen_events: usize,
    pending_events: usize,
}
impl Limits {
    pub fn new(active_sources: usize) -> Result<Self, Error> {
        if active_sources == 0 { return Err(Error::InvalidCapacity); }
        let snapshot_events = HISTORY_CAPACITY.checked_add(active_sources).ok_or(Error::InvalidCapacity)?;
        let seen_events = snapshot_events.checked_mul(2).ok_or(Error::InvalidCapacity)?;
        Ok(Self { active_sources, snapshot_events, seen_events, pending_events: MAX_PENDING.max(seen_events) })
    }
    pub fn active_sources(self) -> usize { self.active_sources }
    pub fn snapshot_events(self) -> usize { self.snapshot_events }
    pub fn seen_events(self) -> usize { self.seen_events }
    pub fn pending_events(self) -> usize { self.pending_events }
}
impl Default for Limits {
    fn default() -> Self { Self::new(DEFAULT_ACTIVE_SOURCES).expect("fixed default capacity fits usize") }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum Kind {
    Basic,
    Critical,
    GarenQ,
}

/// The identity and facts recorded at the beginning of one attack.
/// `id` is the sequence of its Started event; it does not change at resolution.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub struct Attack {
    pub id: u64,
    pub source: u32,
    pub started: u64,
    pub release: u64,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum CancelReason {
    Order,
    TargetInvalid,
    Control,
    Death,
    OtherCast,
    Respawn,
    Departure,
    MatchEnded,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum Phase {
    /// Only the audience at this tick may receive the beginning's kind.
    Started { kind: Kind },
    /// Kind actually chosen by combat at release, without the private beginning
    /// kind. Success means the hit operation succeeded, not damage > 0.
    Resolved { kind: Kind, hit_succeeded: bool },
    Cancelled { reason: CancelReason },
}
impl Phase {
    fn terminal(self) -> bool { !matches!(self, Self::Started { .. }) }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub struct Event {
    pub sequence: u64,
    pub tick: u64,
    pub attack: Attack,
    pub phase: Phase,
}

/// Private simulation metadata. Intentionally has no serde implementation.
/// Calculate both team decisions before mutating the hit/target. A true value
/// means that team's existing visibility rules admitted the source AND target.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Audience([bool; 2]);
impl Audience {
    pub fn from_visibility(team0: bool, team1: bool) -> Self { Self([team0, team1]) }
    fn admits(self, team: u8) -> bool { self.0[usize::from(team)] }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct Stored { event: Event, audience: Audience }

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Error {
    InvalidCapacity,
    InvalidFrame,
    EpochRequired,
    InvalidSource,
    InvalidTeam,
    InvalidAttack,
    InvalidEvent,
    TimeWentBackwards,
    SequenceExhausted,
    ActiveLimit,
    AlreadyActive,
    NoActiveAttack,
    AttackMismatch,
    SessionMismatch,
    TooManyVisibleSources,
    DuplicateVisibleSource,
    TooManyEvents,
    EventOrder,
    EventFromInvisibleSource,
    EventAfterSnapshot,
    ActiveTerminalConflict,
    ConflictingSequence,
    ConflictingAttack,
    AttackWentBackwards,
    TerminalAlreadyObserved,
    PendingLimit,
}

fn valid_attack(attack: &Attack) -> Result<(), Error> {
    if attack.source == 0 || attack.id == 0 || attack.release < attack.started {
        return Err(Error::InvalidAttack);
    }
    Ok(())
}
fn valid_event(event: &Event) -> Result<(), Error> {
    valid_attack(&event.attack)?;
    if event.sequence == 0 || event.tick < event.attack.started {
        return Err(Error::InvalidEvent);
    }
    match event.phase {
        Phase::Started { .. } if event.sequence != event.attack.id || event.tick != event.attack.started => {
            Err(Error::InvalidEvent)
        }
        Phase::Resolved { .. } if event.sequence <= event.attack.id || event.tick < event.attack.release => {
            Err(Error::InvalidEvent)
        }
        Phase::Cancelled { .. } if event.sequence <= event.attack.id => Err(Error::InvalidEvent),
        _ => Ok(()),
    }
}

/// One State belongs to one Simulation/session. Construct a new State for a new
/// session; never reset its counters while retaining the old network session.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct State {
    limits: Limits,
    next_sequence: u64,
    last_tick: Option<u64>,
    history: VecDeque<Stored>,
    // Pinned Started facts prevent a long active windup from falling out of the
    // ring before an eligible observer receives it. The configured capacity
    // bounds them separately from history; a full State rejects new beginnings.
    active: BTreeMap<u32, Stored>,
}
impl Default for State {
    fn default() -> Self { Self::new(Limits::default()) }
}
impl State {
    pub fn new(limits: Limits) -> Self {
        Self { limits, next_sequence: 1, last_tick: None, history: VecDeque::new(), active: BTreeMap::new() }
    }
    pub fn limits(&self) -> Limits { self.limits }
    fn next(&self, tick: u64) -> Result<(u64, u64), Error> {
        if self.last_tick.is_some_and(|previous| tick < previous) { return Err(Error::TimeWentBackwards); }
        let next = self.next_sequence.checked_add(1).ok_or(Error::SequenceExhausted)?;
        Ok((self.next_sequence, next))
    }
    fn commit(&mut self, stored: Stored, next: u64) {
        self.next_sequence = next;
        self.last_tick = Some(stored.event.tick);
        self.history.push_back(stored);
        while self.history.len() > HISTORY_CAPACITY { self.history.pop_front(); }
    }
    pub fn begin(&mut self, source: u32, started: u64, release: u64, kind: Kind,
        audience: Audience) -> Result<Attack, Error> {
        if source == 0 { return Err(Error::InvalidSource); }
        if release < started { return Err(Error::InvalidAttack); }
        if self.active.contains_key(&source) { return Err(Error::AlreadyActive); }
        if self.active.len() >= self.limits.active_sources { return Err(Error::ActiveLimit); }
        let (sequence, next) = self.next(started)?;
        let attack = Attack { id: sequence, source, started, release };
        let stored = Stored { event: Event { sequence, tick: started, attack, phase: Phase::Started { kind } }, audience };
        self.active.insert(source, stored);
        self.commit(stored, next);
        Ok(attack)
    }
    pub fn active(&self, source: u32) -> Option<&Attack> {
        self.active.get(&source).map(|entry| &entry.event.attack)
    }
    fn finish(&mut self, attack: Attack, tick: u64, phase: Phase, audience: Audience) -> Result<Event, Error> {
        valid_attack(&attack)?;
        let current = self.active.get(&attack.source).ok_or(Error::NoActiveAttack)?;
        if current.event.attack != attack { return Err(Error::AttackMismatch); }
        let (sequence, next) = self.next(tick)?;
        let event = Event { sequence, tick, attack, phase };
        valid_event(&event)?;
        self.active.remove(&attack.source);
        self.commit(Stored { event, audience }, next);
        Ok(event)
    }
    pub fn resolve(&mut self, attack: Attack, tick: u64, kind: Kind, hit_succeeded: bool,
        audience: Audience) -> Result<Event, Error> {
        self.finish(attack, tick, Phase::Resolved { kind, hit_succeeded }, audience)
    }
    pub fn cancel(&mut self, attack: Attack, tick: u64, reason: CancelReason,
        audience: Audience) -> Result<Event, Error> {
        self.finish(attack, tick, Phase::Cancelled { reason }, audience)
    }
    /// For authoritative removal paths only. No active presentation means no
    /// event, allowing repeated cleanup without inventing another cancellation.
    pub fn cancel_active(&mut self, source: u32, tick: u64, reason: CancelReason,
        audience: Audience) -> Result<Option<Event>, Error> {
        let Some(attack) = self.active(source).copied() else { return Ok(None); };
        self.cancel(attack, tick, reason, audience).map(Some)
    }
    /// Omniscient internal snapshot only. Never send this directly to a peer:
    /// snapshot_for must replace it with events_for before serialization.
    pub fn events(&self) -> Vec<Event> {
        let mut selected = BTreeMap::new();
        for entry in self.history.iter().chain(self.active.values()) {
            selected.insert(entry.event.sequence, entry.event);
        }
        selected.into_values().collect()
    }
    /// Only Event crosses the wire. Historical audience AND current source
    /// visibility must allow each fact. Do not substitute a roster-only check.
    /// The predicate must read one immutable authoritative visibility snapshot.
    pub fn events_for(&self, team: u8, mut source_visible: impl FnMut(u32) -> bool) -> Result<Vec<Event>, Error> {
        if team > 1 { return Err(Error::InvalidTeam); }
        let mut selected = BTreeMap::new();
        for entry in self.history.iter().chain(self.active.values()) {
            if entry.audience.admits(team) && source_visible(entry.event.attack.source) {
                selected.insert(entry.event.sequence, entry.event);
            }
        }
        Ok(selected.into_values().collect())
    }
    pub fn history_len(&self) -> usize { self.history.len() }
    pub fn active_len(&self) -> usize { self.active.len() }
}

/// Derived by the receiver from currently visible Garen states, not from the
/// public roster. None means there is no active windup at this snapshot tick.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct VisibleSource { pub source: u32, pub active_attack: Option<u64> }

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Delivery {
    Live,
    /// First observation or return to visibility. Resume the current attack at
    /// its observed age; do not treat this as another Started gameplay event.
    ResumeActive,
}
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Observation {
    pub snapshot_tick: u64,
    pub event: Event,
    pub delivery: Delivery,
    /// A newer attack superseded an unfinished observed one. This can indicate
    /// filtered/lost/evicted history; it is not evidence of the old attack's hit.
    pub supersedes_unfinished: bool,
}
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct Tracked { attack: Attack, terminal: bool }

/// Independent of latest-state coalescing. All validation is completed on a
/// candidate before publication. Bounded retained sequence comparisons detect
/// conflicting replays in that window; ancient evicted facts are not an audit.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Journal {
    limits: Limits,
    session: Option<u64>,
    last_tick: Option<u64>,
    epoch: Option<u64>,
    last_frame: Option<u64>,
    highest_sequence: u64,
    visible: BTreeSet<u32>,
    seen: BTreeMap<u64, Event>,
    tracked: BTreeMap<u32, Tracked>,
    pending: Vec<Observation>,
}
impl Default for Journal {
    fn default() -> Self { Self::new(Limits::default()) }
}
impl Journal {
    pub fn new(limits: Limits) -> Self {
        Self { limits, session: None, last_tick: None, epoch: None, last_frame: None, highest_sequence: 0,
            visible: BTreeSet::new(), seen: BTreeMap::new(), tracked: BTreeMap::new(), pending: Vec::new() }
    }
    pub fn limits(&self) -> Limits { self.limits }
    /// Caller establishes this session from its accepted Welcome handshake.
    /// Session-local facts are cleared, but the trusted capacity is preserved.
    pub fn reset(&mut self, session: u64) { *self = Self { session: Some(session), ..Self::new(self.limits) }; }
    /// Only after an accepted Welcome. Same-session recovery keeps every seen
    /// fact, pending observation and actor identity; only frame order restarts.
    /// A duplicate/older epoch does not reopen the frame replay window.
    pub fn begin_epoch(&mut self, session: u64, epoch: u64) -> Result<bool, Error> {
        if self.session != Some(session) { return Err(Error::SessionMismatch); }
        if epoch == 0 { return Err(Error::InvalidFrame); }
        if self.epoch.is_some_and(|old| epoch <= old) { return Ok(false); }
        self.epoch = Some(epoch); self.last_frame = None; Ok(true)
    }
    /// Legacy transport preserves its strictly increasing tick contract.
    pub fn accept(&mut self, session: u64, tick: u64, visible: &[VisibleSource], events: &[Event]) -> Result<bool, Error> {
        self.accept_ordered(session, None, tick, visible, events)
    }
    /// Context/epoch authentication and clock readiness belong to transport.
    /// A fresh frame may change visibility or append facts without advancing tick.
    pub fn accept_frame(&mut self, session: u64, frame: u64, tick: u64,
        visible: &[VisibleSource], events: &[Event]) -> Result<bool, Error> {
        self.accept_ordered(session, Some(frame), tick, visible, events)
    }
    fn accept_ordered(&mut self, session: u64, frame: Option<u64>, tick: u64,
        visible: &[VisibleSource], events: &[Event]) -> Result<bool, Error> {
        if self.session != Some(session) { return Err(Error::SessionMismatch); }
        if let Some(frame) = frame {
            if frame == 0 { return Err(Error::InvalidFrame); }
            if self.epoch.is_none() { return Err(Error::EpochRequired); }
            if self.last_frame.is_some_and(|old| frame <= old) { return Ok(false); }
        }
        if self.last_tick.is_some_and(|last| tick < last || (frame.is_none() && tick == last)) { return Ok(false); }
        if visible.len() > self.limits.active_sources { return Err(Error::TooManyVisibleSources); }
        if events.len() > self.limits.snapshot_events { return Err(Error::TooManyEvents); }
        let mut sources = BTreeMap::new();
        for source in visible {
            if source.source == 0 || source.active_attack == Some(0) { return Err(Error::InvalidSource); }
            if sources.insert(source.source, source.active_attack).is_some() { return Err(Error::DuplicateVisibleSource); }
        }
        let mut previous_sequence = 0;
        for event in events {
            valid_event(event)?;
            if event.sequence <= previous_sequence { return Err(Error::EventOrder); }
            previous_sequence = event.sequence;
            let active = sources.get(&event.attack.source).ok_or(Error::EventFromInvisibleSource)?;
            if event.tick > tick { return Err(Error::EventAfterSnapshot); }
            if event.phase.terminal() && *active == Some(event.attack.id) { return Err(Error::ActiveTerminalConflict); }
            if self.seen.get(&event.sequence).is_some_and(|old| old != event) { return Err(Error::ConflictingSequence); }
        }
        // Validate even history that will not be animated on first visibility.
        // The union is bounded by seen_events + snapshot_events, and is keyed
        // by sequence to avoid counting repeated snapshots as extra terminals.
        let mut retained = self.seen.clone();
        retained.extend(events.iter().map(|event| (event.sequence, *event)));
        let mut identities: BTreeMap<u64, Tracked> = BTreeMap::new();
        for event in retained.values() {
            if let Some(previous) = identities.get(&event.attack.id) {
                if previous.attack != event.attack { return Err(Error::ConflictingAttack); }
                if previous.terminal { return Err(Error::TerminalAlreadyObserved); }
            }
            identities.insert(event.attack.id, Tracked { attack: event.attack, terminal: event.phase.terminal() });
        }
        let mut candidate = self.clone();
        candidate.seen = retained;
        candidate.tracked.retain(|source, _| sources.contains_key(source));
        // This is a presentation queue, not an immutable observation archive.
        // Cull queued presentation when an actor disappears within one receive
        // batch so it cannot be replayed after that actor returns to visibility.
        candidate.pending.retain(|item| sources.contains_key(&item.event.attack.source));
        for event in events {
            let first_visible = !self.visible.contains(&event.attack.source);
            if first_visible {
                if matches!(event.phase, Phase::Started { .. }) && sources[&event.attack.source] == Some(event.attack.id) {
                    candidate.queue(tick, *event, Delivery::ResumeActive)?;
                }
            } else if event.sequence > self.highest_sequence
                && !self.last_tick.is_some_and(|last| event.tick < last) {
                candidate.queue(tick, *event, Delivery::Live)?;
            }
        }
        while candidate.seen.len() > self.limits.seen_events { candidate.seen.pop_first(); }
        candidate.highest_sequence = candidate.highest_sequence.max(previous_sequence);
        candidate.visible = sources.keys().copied().collect();
        candidate.last_tick = Some(tick);
        if let Some(frame) = frame { candidate.last_frame = Some(frame); }
        *self = candidate;
        Ok(true)
    }
    fn queue(&mut self, snapshot_tick: u64, event: Event, delivery: Delivery) -> Result<(), Error> {
        let mut supersedes_unfinished = false;
        if let Some(previous) = self.tracked.get(&event.attack.source) {
            if event.attack.id < previous.attack.id { return Err(Error::AttackWentBackwards); }
            if event.attack.id == previous.attack.id {
                if event.attack != previous.attack { return Err(Error::ConflictingAttack); }
                if previous.terminal { return Err(Error::TerminalAlreadyObserved); }
            } else {
                supersedes_unfinished = !previous.terminal;
            }
        }
        if self.pending.len() >= self.limits.pending_events { return Err(Error::PendingLimit); }
        self.tracked.insert(event.attack.source, Tracked { attack: event.attack, terminal: event.phase.terminal() });
        self.pending.push(Observation { snapshot_tick, event, delivery, supersedes_unfinished });
        Ok(())
    }
    /// Drain once per presentation consumer. No gameplay action is generated.
    pub fn drain(&mut self) -> Vec<Observation> { std::mem::take(&mut self.pending) }
    pub fn pending_len(&self) -> usize { self.pending.len() }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn everyone() -> Audience { Audience::from_visibility(true, true) }
    fn visible(source: u32, active: Option<Attack>) -> VisibleSource {
        VisibleSource { source, active_attack: active.map(|attack| attack.id) }
    }
    fn facts(state: &State) -> Vec<Event> { state.events_for(0, |_| true).unwrap() }

    #[test]
    fn one_identity_preserves_start_and_actual_resolution_without_consuming_gameplay_state() {
        let mut state = State::default();
        let attack = state.begin(1, 10, 20, Kind::Basic, everyone()).unwrap();
        let resolved = state.resolve(attack, 20, Kind::GarenQ, false, everyone()).unwrap();
        assert_eq!(resolved.attack, attack);
        assert_eq!(facts(&state)[0].phase, Phase::Started { kind: Kind::Basic });
        assert_eq!(resolved.phase, Phase::Resolved { kind: Kind::GarenQ, hit_succeeded: false });
        assert_eq!(facts(&state).iter().map(|event| event.sequence).collect::<Vec<_>>(), [1, 2]);
        assert!(state.active(1).is_none());
        assert_eq!(state.resolve(attack, 20, Kind::GarenQ, true, everyone()), Err(Error::NoActiveAttack));
        let next = state.begin(1, 21, 31, Kind::Basic, everyone()).unwrap();
        assert_eq!(next.id, 3);
    }

    #[test]
    fn failed_server_transitions_do_not_mutate_identity_history_or_counter() {
        let mut state = State::default();
        let attack = state.begin(1, 10, 20, Kind::GarenQ, everyone()).unwrap();
        let before = state.clone();
        assert_eq!(state.begin(1, 11, 20, Kind::Basic, everyone()), Err(Error::AlreadyActive));
        assert_eq!(state.resolve(attack, 19, Kind::Basic, true, everyone()), Err(Error::InvalidEvent));
        assert_eq!(state.cancel(Attack { release: 21, ..attack }, 11, CancelReason::Order, everyone()), Err(Error::AttackMismatch));
        assert_eq!(state.cancel(attack, 9, CancelReason::Order, everyone()), Err(Error::TimeWentBackwards));
        assert_eq!(state, before);
        state.next_sequence = u64::MAX;
        let before = state.clone();
        assert_eq!(state.cancel(attack, 11, CancelReason::Order, everyone()), Err(Error::SequenceExhausted));
        assert_eq!(state, before);
    }

    #[test]
    fn cancellation_is_terminal_and_repeated_cleanup_does_not_make_another_fact() {
        let mut state = State::default();
        let attack = state.begin(1, 10, 20, Kind::GarenQ, everyone()).unwrap();
        let event = state.cancel_active(1, 11, CancelReason::Control, everyone()).unwrap().unwrap();
        assert_eq!(event.attack, attack);
        assert_eq!(event.phase, Phase::Cancelled { reason: CancelReason::Control });
        assert!(state.cancel_active(1, 11, CancelReason::Control, everyone()).unwrap().is_none());
        assert_eq!(state.history_len(), 2);
    }

    #[test]
    fn six_active_sources_and_ring_are_bounded_without_evicting_live_identity() {
        let mut state = State::default();
        for source in 1..=6 { state.begin(source, 0, 10_000, Kind::Basic, everyone()).unwrap(); }
        let before = state.clone();
        assert_eq!(state.begin(7, 0, 1, Kind::Basic, everyone()), Err(Error::ActiveLimit));
        assert_eq!(state, before);
        state.cancel_active(6, 1, CancelReason::Order, everyone()).unwrap();
        for tick in 2..150 {
            let attack = state.begin(6, tick, tick, Kind::Basic, everyone()).unwrap();
            state.resolve(attack, tick, Kind::Basic, true, everyone()).unwrap();
        }
        let wire = facts(&state);
        assert_eq!(state.history_len(), HISTORY_CAPACITY);
        assert_eq!(state.active_len(), 5);
        assert_eq!(wire.len(), HISTORY_CAPACITY + 5);
        assert_eq!(wire.first().unwrap().sequence, 1);
        assert!(wire.windows(2).all(|pair| pair[0].sequence < pair[1].sequence));
    }

    #[test]
    fn configurable_capacity_is_shared_and_survives_session_reset() {
        assert_eq!(Limits::new(0), Err(Error::InvalidCapacity));
        assert_eq!(Limits::new(usize::MAX), Err(Error::InvalidCapacity));
        assert_eq!(Limits::new(usize::MAX / 2), Err(Error::InvalidCapacity));
        let limits = Limits::new(10).unwrap();
        assert_eq!(limits.active_sources(), 10);
        assert_eq!(limits.snapshot_events(), 138);
        assert_eq!(limits.seen_events(), 276);
        assert_eq!(limits.pending_events(), 512);
        let mut state = State::new(limits);
        let mut visible_sources = Vec::new();
        for source in 1..=10 {
            let attack = state.begin(source, 0, 20, Kind::Basic, everyone()).unwrap();
            visible_sources.push(visible(source, Some(attack)));
        }
        let before = state.clone();
        assert_eq!(state.begin(11, 0, 20, Kind::Basic, everyone()), Err(Error::ActiveLimit));
        assert_eq!(state, before);
        let mut journal = Journal::new(limits); journal.reset(7);
        journal.accept(7, 1, &visible_sources, &facts(&state)).unwrap();
        assert_eq!(journal.drain().len(), 10);
        journal.reset(8);
        assert_eq!(journal.limits(), limits);
        assert_eq!(journal.pending_len(), 0);
        journal.accept(8, 1, &visible_sources, &facts(&state)).unwrap();
        assert_eq!(journal.drain().len(), 10);
        let mut wrong_capacity = Journal::default(); wrong_capacity.reset(8);
        let before = wrong_capacity.clone();
        assert_eq!(wrong_capacity.accept(8, 1, &visible_sources, &facts(&state)), Err(Error::TooManyVisibleSources));
        assert_eq!(wrong_capacity, before);
    }

    #[test]
    fn historical_audience_and_current_visibility_both_gate_plain_wire_facts() {
        let mut state = State::default();
        let attack = state.begin(1, 1, 2, Kind::GarenQ, Audience::from_visibility(true, false)).unwrap();
        state.resolve(attack, 2, Kind::GarenQ, true, Audience::from_visibility(false, true)).unwrap();
        assert_eq!(state.events_for(0, |_| true).unwrap().iter().map(|event| event.sequence).collect::<Vec<_>>(), [1]);
        assert_eq!(state.events_for(1, |_| true).unwrap().iter().map(|event| event.sequence).collect::<Vec<_>>(), [2]);
        assert!(state.events_for(0, |_| false).unwrap().is_empty());
        assert_eq!(state.events_for(2, |_| true), Err(Error::InvalidTeam));
        let text = serde_json::to_string(&facts(&state)).unwrap();
        assert!(!text.contains("audience") && !text.contains("target"));
        let decoded: Vec<Event> = serde_json::from_str(&text).unwrap();
        assert_eq!(decoded, facts(&state));
    }

    #[test]
    fn whole_attack_between_snapshots_and_receive_coalescing_retain_facts_once() {
        let mut state = State::default();
        let mut journal = Journal::default(); journal.reset(7);
        journal.accept(7, 0, &[visible(1, None)], &[]).unwrap();
        let attack = state.begin(1, 1, 2, Kind::GarenQ, everyone()).unwrap();
        state.resolve(attack, 2, Kind::GarenQ, true, everyone()).unwrap();
        journal.accept(7, 3, &[visible(1, None)], &facts(&state)).unwrap();
        journal.accept(7, 4, &[visible(1, None)], &facts(&state)).unwrap();
        let observed = journal.drain();
        assert_eq!(observed.len(), 2);
        assert!(observed.iter().all(|item| item.event.attack.id == attack.id && item.delivery == Delivery::Live));
        assert_eq!(observed[0].event.phase, Phase::Started { kind: Kind::GarenQ });
        assert!(matches!(observed[1].event.phase, Phase::Resolved { .. }));
        assert!(journal.drain().is_empty());
    }

    #[test]
    fn first_visibility_resumes_only_current_attack_and_never_replays_old_terminal_history() {
        let mut state = State::default();
        let old = state.begin(1, 1, 2, Kind::GarenQ, everyone()).unwrap();
        state.resolve(old, 2, Kind::GarenQ, true, everyone()).unwrap();
        let active = state.begin(1, 3, 20, Kind::Basic, everyone()).unwrap();
        let mut journal = Journal::default(); journal.reset(7);
        journal.accept(7, 4, &[visible(1, Some(active))], &facts(&state)).unwrap();
        let observed = journal.drain();
        assert_eq!(observed.len(), 1);
        assert_eq!(observed[0].event.attack, active);
        assert_eq!(observed[0].delivery, Delivery::ResumeActive);
        journal.accept(7, 5, &[], &[]).unwrap();
        journal.accept(7, 6, &[visible(1, Some(active))], &facts(&state)).unwrap();
        assert_eq!(journal.drain()[0].delivery, Delivery::ResumeActive);
        journal.reset(8);
        state.resolve(active, 20, Kind::Basic, true, everyone()).unwrap();
        journal.accept(8, 21, &[visible(1, None)], &facts(&state)).unwrap();
        assert!(journal.drain().is_empty());
    }

    #[test]
    fn malformed_batch_rolls_back_pending_seen_and_tick_then_valid_retry_succeeds() {
        let mut state = State::default();
        let mut journal = Journal::default(); journal.reset(7);
        journal.accept(7, 0, &[visible(1, None)], &[]).unwrap();
        let attack = state.begin(1, 1, 2, Kind::Basic, everyone()).unwrap();
        state.resolve(attack, 2, Kind::Basic, true, everyone()).unwrap();
        let mut bad = facts(&state);
        bad[1].attack.release = 3; // Valid fields, inconsistent identity with Started.
        bad[1].tick = 3;
        let before = journal.clone();
        assert_eq!(journal.accept(7, 3, &[visible(1, None)], &bad), Err(Error::ConflictingAttack));
        assert_eq!(journal, before);
        assert!(journal.accept(7, 3, &[visible(1, None)], &facts(&state)).unwrap());
        let before = journal.clone();
        let mut changed = facts(&state);
        changed[1].phase = Phase::Resolved { kind: Kind::Critical, hit_succeeded: true };
        assert_eq!(journal.accept(7, 4, &[visible(1, None)], &changed), Err(Error::ConflictingSequence));
        assert_eq!(journal, before);
    }

    #[test]
    fn ignored_bootstrap_history_still_rejects_changed_identity_and_two_terminals() {
        let mut state = State::default();
        let attack = state.begin(1, 1, 2, Kind::Basic, everyone()).unwrap();
        state.resolve(attack, 2, Kind::Basic, true, everyone()).unwrap();
        let mut journal = Journal::default(); journal.reset(7);
        let before = journal.clone();
        let mut bad = facts(&state);
        bad[1].attack.release = 3;
        bad[1].tick = 3;
        assert_eq!(journal.accept(7, 3, &[visible(1, None)], &bad), Err(Error::ConflictingAttack));
        assert_eq!(journal, before);
        let mut twice = facts(&state);
        twice.push(Event { sequence: 3, tick: 3, attack, phase: Phase::Cancelled { reason: CancelReason::Death } });
        assert_eq!(journal.accept(7, 3, &[visible(1, None)], &twice), Err(Error::TerminalAlreadyObserved));
        assert_eq!(journal, before);
        journal.accept(7, 3, &[visible(1, None)], &facts(&state)).unwrap();
        assert!(journal.drain().is_empty());
    }

    #[test]
    fn retained_history_rejects_cross_batch_identity_mutation_even_when_not_delivered() {
        let mut state = State::default();
        let attack = state.begin(1, 1, 2, Kind::Basic, everyone()).unwrap();
        let mut journal = Journal::default(); journal.reset(7);
        journal.accept(7, 1, &[visible(1, None)], &facts(&state)).unwrap();
        assert!(journal.drain().is_empty());
        let before = journal.clone();
        let changed = Event { sequence: 2, tick: 3, attack: Attack { release: 3, ..attack },
            phase: Phase::Resolved { kind: Kind::Basic, hit_succeeded: true } };
        assert_eq!(journal.accept(7, 3, &[visible(1, None)], &[changed]), Err(Error::ConflictingAttack));
        assert_eq!(journal, before);
        let valid = state.resolve(attack, 2, Kind::Basic, true, everyone()).unwrap();
        journal.accept(7, 3, &[visible(1, None)], &[valid]).unwrap();
        assert_eq!(journal.drain().len(), 1);
    }

    #[test]
    fn sequence_gaps_do_not_invent_missing_start_or_old_resolution() {
        let mut state = State::default();
        let attack = state.begin(1, 1, 2, Kind::GarenQ, Audience::from_visibility(false, true)).unwrap();
        state.resolve(attack, 2, Kind::Basic, true, everyone()).unwrap();
        let mut journal = Journal::default(); journal.reset(7);
        journal.accept(7, 0, &[visible(1, None)], &[]).unwrap();
        journal.accept(7, 3, &[visible(1, None)], &facts(&state)).unwrap();
        let observed = journal.drain();
        assert_eq!(observed.len(), 1);
        assert_eq!(observed[0].event.sequence, 2);
        // The visible terminal must not disclose the unobserved beginning kind.
        assert!(!serde_json::to_string(&observed[0].event).unwrap().contains("GarenQ"));
        assert!(matches!(observed[0].event.phase, Phase::Resolved { kind: Kind::Basic, .. }));
        assert!(!observed[0].supersedes_unfinished);
    }

    #[test]
    fn replacement_marks_unfinished_observation_without_fabricating_a_hit() {
        let mut state = State::default();
        let mut journal = Journal::default(); journal.reset(7);
        journal.accept(7, 0, &[visible(1, None)], &[]).unwrap();
        let first = state.begin(1, 1, 4, Kind::GarenQ, everyone()).unwrap();
        journal.accept(7, 2, &[visible(1, Some(first))], &facts(&state)).unwrap();
        journal.drain();
        state.cancel(first, 2, CancelReason::Order, Audience::from_visibility(false, true)).unwrap();
        let next = state.begin(1, 3, 6, Kind::Basic, everyone()).unwrap();
        journal.accept(7, 4, &[visible(1, Some(next))], &facts(&state)).unwrap();
        let observed = journal.drain();
        assert_eq!(observed.len(), 1);
        assert_eq!(observed[0].event.attack, next);
        assert!(observed[0].supersedes_unfinished);
        assert_eq!(observed[0].event.phase, Phase::Started { kind: Kind::Basic });
    }

    #[test]
    fn invisible_sources_old_sessions_bad_order_and_active_terminal_are_refused_without_mutation() {
        let mut state = State::default();
        let attack = state.begin(1, 1, 2, Kind::Basic, everyone()).unwrap();
        state.resolve(attack, 2, Kind::Basic, true, everyone()).unwrap();
        let mut journal = Journal::default(); journal.reset(7);
        let before = journal.clone();
        assert_eq!(journal.accept(8, 3, &[visible(1, None)], &facts(&state)), Err(Error::SessionMismatch));
        assert_eq!(journal.accept(7, 3, &[], &facts(&state)), Err(Error::EventFromInvisibleSource));
        assert_eq!(journal.accept(7, 3, &[visible(1, Some(attack))], &facts(&state)), Err(Error::ActiveTerminalConflict));
        let mut reversed = facts(&state); reversed.reverse();
        assert_eq!(journal.accept(7, 3, &[visible(1, None)], &reversed), Err(Error::EventOrder));
        assert_eq!(journal, before);
        journal.accept(7, 3, &[visible(1, None)], &facts(&state)).unwrap();
        let before = journal.clone();
        assert!(!journal.accept(7, 2, &[], &reversed).unwrap());
        assert_eq!(journal, before);
    }

    #[test]
    fn visibility_loss_culls_pending_presentation_and_pending_limit_is_transactional() {
        let mut state = State::default();
        let attack = state.begin(1, 1, 10, Kind::GarenQ, everyone()).unwrap();
        let mut journal = Journal::default(); journal.reset(7);
        journal.accept(7, 1, &[visible(1, Some(attack))], &facts(&state)).unwrap();
        assert_eq!(journal.pending_len(), 1);
        journal.accept(7, 2, &[], &[]).unwrap();
        assert!(journal.drain().is_empty());
        journal.accept(7, 3, &[visible(1, Some(attack))], &facts(&state)).unwrap();
        let item = journal.pending[0];
        journal.pending = vec![item; MAX_PENDING]; // Explicit bound fixture.
        state.cancel(attack, 4, CancelReason::Order, everyone()).unwrap();
        let before = journal.clone();
        assert_eq!(journal.accept(7, 4, &[visible(1, None)], &facts(&state)), Err(Error::PendingLimit));
        assert_eq!(journal, before);
    }

    #[test]
    fn frame_order_delivers_same_tick_cancel_once_without_reemitting_start() {
        let mut facts = State::default();
        let attack = facts.begin(1, 10, 20, Kind::GarenQ, everyone()).unwrap();
        let mut journal = Journal::default(); journal.reset(7); journal.begin_epoch(7, 1).unwrap();
        journal.accept_frame(7, 1, 10, &[visible(1, Some(attack))], &facts.events()).unwrap();
        let start = journal.drain(); assert_eq!(start.len(), 1); assert_eq!(start[0].delivery, Delivery::ResumeActive);
        journal.accept_frame(7, 2, 10, &[visible(1, Some(attack))], &facts.events()).unwrap();
        assert!(journal.drain().is_empty());
        facts.cancel(attack, 10, CancelReason::Order, everyone()).unwrap();
        assert!(journal.accept_frame(7, 3, 10, &[visible(1, None)], &facts.events()).unwrap());
        let terminal = journal.drain(); assert_eq!(terminal.len(), 1);
        assert_eq!(terminal[0].snapshot_tick, 10); assert_eq!(terminal[0].delivery, Delivery::Live);
        assert_eq!(terminal[0].event.phase, Phase::Cancelled { reason: CancelReason::Order });
        let saved = journal.clone();
        assert!(!journal.accept_frame(7, 3, 11, &[], &[]).unwrap());
        assert!(!journal.accept_frame(7, 4, 9, &[], &[]).unwrap()); assert_eq!(journal, saved);
        assert!(journal.accept_frame(7, 4, 10, &[visible(1, None)], &facts.events()).unwrap());
        assert!(journal.drain().is_empty());
    }

    #[test]
    fn frame_order_visibility_and_epoch_keep_history_without_replaying_it() {
        let mut facts = State::default();
        let attack = facts.begin(1, 10, 20, Kind::Basic, everyone()).unwrap();
        let mut journal = Journal::default(); journal.reset(7); journal.begin_epoch(7, 1).unwrap();
        journal.accept_frame(7, 8, 10, &[visible(1, Some(attack))], &facts.events()).unwrap();
        assert_eq!(journal.pending_len(), 1);
        journal.accept_frame(7, 9, 10, &[], &[]).unwrap(); assert!(journal.drain().is_empty());
        journal.accept_frame(7, 10, 10, &[visible(1, Some(attack))], &facts.events()).unwrap();
        assert_eq!(journal.drain()[0].delivery, Delivery::ResumeActive);
        assert!(journal.begin_epoch(7, 2).unwrap());
        assert!(journal.accept_frame(7, 1, 10, &[visible(1, Some(attack))], &facts.events()).unwrap());
        assert!(journal.drain().is_empty());
        let saved = journal.clone(); assert!(!journal.begin_epoch(7, 1).unwrap());
        assert!(!journal.begin_epoch(7, 2).unwrap()); assert_eq!(journal, saved);
        assert!(!journal.accept_frame(7, 1, 10, &[], &[]).unwrap());
        facts.cancel(attack, 10, CancelReason::Departure, everyone()).unwrap();
        journal.accept_frame(7, 2, 10, &[], &[]).unwrap();
        journal.accept_frame(7, 3, 10, &[visible(1, None)], &facts.events()).unwrap();
        assert!(journal.drain().is_empty()); // No old terminal on renewed visibility.
    }

    #[test]
    fn frame_validation_is_transactional_and_reset_is_reserved_for_new_session() {
        let mut facts = State::default();
        let attack = facts.begin(1, 10, 20, Kind::GarenQ, everyone()).unwrap();
        let mut journal = Journal::default(); journal.reset(7); let saved = journal.clone();
        assert_eq!(journal.accept_frame(7, 1, 10, &[], &[]), Err(Error::EpochRequired));
        assert_eq!(journal.begin_epoch(7, 0), Err(Error::InvalidFrame));
        assert_eq!(journal.begin_epoch(8, 1), Err(Error::SessionMismatch)); assert_eq!(journal, saved);
        journal.begin_epoch(7, 1).unwrap(); let saved = journal.clone();
        assert_eq!(journal.accept_frame(7, 0, 10, &[], &[]), Err(Error::InvalidFrame));
        assert!(journal.accept_frame(7, 1, 10, &[], &facts.events()).is_err()); assert_eq!(journal, saved);
        assert!(journal.accept_frame(7, 1, 10, &[visible(1, Some(attack))], &facts.events()).unwrap());
        journal.drain(); journal.reset(8); journal.begin_epoch(8, 1).unwrap();
        assert!(journal.accept_frame(8, 1, 1, &[], &[]).unwrap()); assert!(journal.drain().is_empty());
    }
}
