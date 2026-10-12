//! Local presentation policy consuming authoritative attack facts.
//! Q uses the loaded clip duration; this does not establish native impact or
//! recovery timing. No gameplay action, buff consumption or Bevy dependency.

use openleague_core::{attack_presentation::{Attack, Journal, Kind, Limits, Phase, VisibleSource}, Snapshot, TICK_RATE};
use std::collections::{BTreeMap, BTreeSet};

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Selection {
    pub attack: u64,
    pub kind: Kind,
    pub role: &'static str,
    pub started: u64,
    pub age_seconds: f32,
}

#[derive(Debug, Clone, Copy, PartialEq)]
struct Context {
    attack: Attack,
    kind: Kind,
    resolved: bool,
    active_windup: bool,
}

#[derive(Debug, Clone, Copy, PartialEq)]
struct Anchor {
    attack: Attack,
    age: f64,
    received_at: f64,
}
impl Anchor {
    fn new(attack: Attack, tick: u64, now: f64) -> Self {
        Self { attack, age: tick.saturating_sub(attack.started) as f64 / TICK_RATE as f64, received_at: now }
    }
    fn advance(&mut self, tick: u64, now: f64) -> Result<(), String> {
        let clock_now = now.max(self.received_at);
        let network_age = tick.saturating_sub(self.attack.started) as f64 / TICK_RATE as f64;
        let age = (self.age + (clock_now - self.received_at).max(0.)).max(network_age);
        if !age.is_finite() { return Err("attack presentation clock overflow".into()); }
        self.age = age;
        self.received_at = clock_now;
        Ok(())
    }
}

#[derive(Debug, Default, Clone, PartialEq)]
pub struct State {
    journal: Journal,
    contexts: BTreeMap<u32, Context>,
    // Only actual interruptions create barriers. Fog disappearance does not.
    // Retained only for participants still present in the public roster.
    interrupted: BTreeMap<u32, u64>,
    // Last identity per participant, surviving fog but not roster departure.
    // A new identity receives a fresh network-age anchor, independently of any
    // earlier extrapolation. Journal keeps the exact server tick separately.
    anchors: BTreeMap<u32, Anchor>,
    error: Option<String>,
    finished: bool,
}

impl State {
    pub fn with_limits(limits: Limits) -> Self {
        Self { journal: Journal::new(limits), ..Self::default() }
    }

    pub fn reset(&mut self, session: u64) {
        let limits = self.journal.limits();
        *self = Self::with_limits(limits);
        self.journal.reset(session);
    }

    pub fn error(&self) -> Option<&str> { self.error.as_deref() }

    /// Call for EACH accepted snapshot, before latest-state coalescing.
    /// Ordinary errors leave this State unchanged. The caller can clone it,
    /// validate other journals and commit only after the whole packet passes.
    /// A server presentation error instead accepts the game snapshot, exposes
    /// a sticky diagnostic and disables presentations until session reset.
    pub fn begin_epoch(&mut self, session: u64, epoch: u64) -> Result<bool, String> {
        self.journal.begin_epoch(session, epoch).map_err(|error| format!("invalid attack epoch: {error:?}"))
    }
    pub fn observe(&mut self, snapshot: &Snapshot, now: f64) -> Result<bool, String> {
        self.observe_ordered(snapshot, None, now)
    }
    /// Current authenticated epoch only; preserve the EffectClock domain.
    pub fn observe_frame(&mut self, snapshot: &Snapshot, frame: u64, now: f64) -> Result<bool, String> {
        self.observe_ordered(snapshot, Some(frame), now)
    }
    fn observe_ordered(&mut self, snapshot: &Snapshot, frame: Option<u64>, now: f64) -> Result<bool, String> {
        if !now.is_finite() { return Err("attack presentation received a non-finite clock".into()); }
        openleague_core::garen_q_resource::binding().map_err(str::to_owned)?;
        let roster: BTreeSet<_> = snapshot.roster.iter()
            .filter(|entry| entry.champion == "garen").map(|entry| entry.id).collect();
        if roster.len() > self.journal.limits().active_sources() {
            return Err("attack presentation roster exceeds configured capacity".into());
        }
        let players: BTreeMap<_, _> = snapshot.players.iter()
            .filter(|player| player.champion == "garen").map(|player| (player.id, player)).collect();
        if players.keys().any(|source| !roster.contains(source)) {
            return Err("visible attack source absent from the session roster".into());
        }
        // Build from the original player slice, so duplicate sources are still
        // rejected by Journal instead of being hidden by BTreeMap collection.
        let visible: Vec<_> = snapshot.players.iter().filter(|player| player.champion == "garen")
            .map(|player| VisibleSource { source: player.id,
                active_attack: player.windup.as_ref().and_then(|windup| windup.presentation.as_ref()).map(|attack| attack.id) })
            .collect();
        let mut next = self.clone();
        let accepted = match frame {
            Some(frame) => next.journal.accept_frame(snapshot.session, frame, snapshot.tick, &visible, &snapshot.attack_events),
            None => next.journal.accept(snapshot.session, snapshot.tick, &visible, &snapshot.attack_events),
        }.map_err(|error| format!("invalid attack presentation snapshot: {error:?}"))?;
        if !accepted { return Ok(false); }
        next.anchors.retain(|source, _| roster.contains(source));
        for anchor in next.anchors.values_mut() { anchor.advance(snapshot.tick, now)?; }
        next.interrupted.retain(|source, _| roster.contains(source));
        // Fog/loss of visibility discards old context immediately, including
        // when several snapshots arrive before a single animation frame.
        next.contexts.retain(|source, _| players.contains_key(source));
        next.finished |= snapshot.winner.is_some() || snapshot.result.is_some();
        if let Some(error) = snapshot.attack_presentation_error.as_ref() {
            if next.error.is_none() { next.error = Some(error.clone()); }
        }
        let observations = next.journal.drain();
        if next.finished || next.error.is_some() {
            next.contexts.clear();
            *self = next;
            return Ok(true);
        }
        for observation in observations {
            let event = observation.event;
            let source = event.attack.source;
            if next.interrupted.get(&source).is_some_and(|id| event.attack.id <= *id) { continue; }
            next.anchor(event.attack, snapshot.tick, now)?;
            match event.phase {
                Phase::Cancelled { .. } => next.interrupt(source, event.attack.id),
                Phase::Started { kind } => {
                    next.contexts.insert(source, Context { attack: event.attack, kind,
                        resolved: false, active_windup: false });
                }
                Phase::Resolved { kind, .. } => {
                    // Preserve the original start tick; resolution is never a
                    // new playback origin, including a Basic -> GarenQ change.
                    next.contexts.insert(source, Context { attack: event.attack, kind,
                        resolved: true, active_windup: false });
                }
            }
        }
        for (&source, player) in &players {
            let active = player.windup.as_ref().and_then(|windup| windup.presentation.as_ref()).map(|attack| attack.id);
            let blocked = player.health <= 0. || openleague_core::stuns::active(player, snapshot.tick)
                || snapshot.tick < player.effects.spin_until || player.effects.ultimate.is_some();
            if blocked {
                if let Some(context) = next.contexts.get(&source).copied() { next.interrupt(source, context.attack.id); }
                if let Some(id) = active { next.interrupt(source, id); }
                continue;
            }
            if let Some(context) = next.contexts.get(&source).copied() {
                let same_windup = active == Some(context.attack.id);
                let replacement_windup = player.windup.is_some() && !same_windup;
                let disappeared_without_terminal = !context.resolved && !same_windup;
                // Local presentation choice: movement after impact interrupts
                // recovery, while an actual current windup keeps priority.
                let moving_after_hit = context.resolved && !same_windup && player.destination.is_some();
                if replacement_windup || disappeared_without_terminal || moving_after_hit {
                    next.interrupt(source, context.attack.id);
                } else if let Some(context) = next.contexts.get_mut(&source) {
                    context.active_windup = same_windup;
                }
            }
        }
        *self = next;
        Ok(true)
    }

    fn anchor(&mut self, attack: Attack, tick: u64, now: f64) -> Result<(), String> {
        if let Some(previous) = self.anchors.get(&attack.source) {
            if attack.id < previous.attack.id { return Err("attack presentation identity went backwards".into()); }
            if attack.id == previous.attack.id {
                if attack != previous.attack { return Err("attack presentation anchor identity changed".into()); }
                // advance() already updated this identity before draining.
                return Ok(());
            }
        }
        self.anchors.insert(attack.source, Anchor::new(attack, tick, now));
        Ok(())
    }

    fn interrupt(&mut self, source: u32, attack: u64) {
        self.interrupted.entry(source).and_modify(|old| *old = (*old).max(attack)).or_insert(attack);
        if self.contexts.get(&source).is_some_and(|context| context.attack.id <= attack) {
            self.contexts.remove(&source);
        }
    }

    /// `now` is EffectClock.now in both observe and selection: the caller owns
    /// pause/scale, as for AnimationDelta. Never substitute wall-clock elapsed.
    /// Supply Q duration from the actual loaded clip.
    pub fn selection(&self, source: u32, now: f64, q_duration: Option<f32>) -> Option<Selection> {
        if self.finished || self.error.is_some() || !now.is_finite() { return None; }
        let context = self.contexts.get(&source)?;
        let anchor = self.anchors.get(&source).filter(|anchor| anchor.attack == context.attack)?;
        let age = anchor.age + (now - anchor.received_at).max(0.);
        if !age.is_finite() || age > f32::MAX as f64 { return None; }
        let role = match context.kind {
            Kind::GarenQ => {
                let duration = q_duration.filter(|duration| duration.is_finite() && *duration > 0.)?;
                if age >= f64::from(duration) { return None; }
                openleague_core::garen_q_resource::binding().ok()?.presentation_role()
            }
            Kind::Basic | Kind::Critical => {
                // Existing local 12-tick visual window, extended only while
                // the snapshot still proves this exact windup is active.
                if age >= 12. / TICK_RATE as f64 && !context.active_windup { return None; }
                if context.kind == Kind::Critical { "crit" } else { "attack" }
            }
        };
        Some(Selection { attack: context.attack.id, kind: context.kind, role,
            started: context.attack.started, age_seconds: age as f32 })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use openleague_core::{attack_presentation::{Audience, CancelReason, State as Facts}, attacks::Windup,
        Navigation, Point, Simulation};

    #[test]
    fn q_registry_selection_consumes_verified_alias_and_actual_duration() {
        let binding = openleague_core::garen_q_resource::binding().unwrap();
        let mut facts = Facts::default();
        let attack = facts.begin(1, 1, 10, Kind::GarenQ, all()).unwrap();
        let mut state = State::default(); state.reset(7);
        state.observe(&snapshot(2, &facts, Some(attack)), 1.).unwrap();
        let selected = state.selection(1, 1., Some(1.)).unwrap();
        assert_eq!(selected.role, binding.presentation_role());
        assert_eq!(selected.kind, binding.kind_at_observation(true, false));
        assert_eq!(binding.resource_name(), "GarenQAttack");
        assert!(state.selection(1, 1., None).is_none());
        assert!(state.selection(1, 1., Some(0.01)).is_none());
        assert!(state.error().is_none());
    }

    fn snapshot(tick: u64, facts: &Facts, active: Option<Attack>) -> Snapshot {
        let mut cells = Vec::new();
        for _ in 0..16 { cells.extend(0f32.to_le_bytes()); cells.extend(0u16.to_le_bytes()); cells.extend(0u32.to_le_bytes()); cells.push(1); }
        let nav = Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":4,"height":4}"#, &cells).unwrap();
        let mut game = Simulation::new(nav).unwrap();
        assert_eq!(game.join("garen").unwrap(), 1);
        let mut snapshot = game.snapshot();
        snapshot.session = 7;
        snapshot.tick = tick;
        snapshot.attack_events = facts.events_for(0, |_| true).unwrap();
        snapshot.players[0].windup = active.map(|attack| Windup { target: 2, started: attack.started,
            release: attack.release, cancelable: true, critical: false, presentation: Some(attack) });
        snapshot
    }
    fn all() -> Audience { Audience::from_visibility(true, true) }
    fn state(facts: &Facts) -> State {
        let mut state = State::default(); state.reset(7);
        state.observe(&snapshot(0, facts, None), 1.).unwrap(); state
    }
    fn selected(state: &State, now: f64) -> Selection { state.selection(1, now, Some(1.)).unwrap() }

    #[test]
    fn q_resolution_preserves_start_then_next_basic_replaces_it() {
        let mut facts = Facts::default(); let mut state = state(&facts);
        let q = facts.begin(1, 1, 10, Kind::GarenQ, all()).unwrap();
        state.observe(&snapshot(2, &facts, Some(q)), 1.).unwrap();
        assert_eq!(selected(&state, 1.).role, "spell1");
        facts.resolve(q, 10, Kind::GarenQ, true, all()).unwrap();
        state.observe(&snapshot(10, &facts, None), 1.2).unwrap();
        let observed = selected(&state, 1.3);
        assert_eq!(observed.attack, q.id); assert_eq!(observed.started, 1);
        assert!((observed.age_seconds - 0.4).abs() < 0.0001);
        let basic = facts.begin(1, 11, 20, Kind::Basic, all()).unwrap();
        state.observe(&snapshot(12, &facts, Some(basic)), 1.3).unwrap();
        assert_eq!(selected(&state, 1.3).role, "attack");
        assert_eq!(selected(&state, 1.3).attack, basic.id);
    }

    #[test]
    fn critical_uses_crit_and_only_live_windup_extends_the_local_window() {
        let mut facts = Facts::default(); let mut state = state(&facts);
        let attack = facts.begin(1, 1, 30, Kind::Critical, all()).unwrap();
        state.observe(&snapshot(20, &facts, Some(attack)), 1.).unwrap();
        assert_eq!(selected(&state, 1.).role, "crit");
        facts.resolve(attack, 30, Kind::Critical, true, all()).unwrap();
        state.observe(&snapshot(30, &facts, None), 2.).unwrap();
        assert!(state.selection(1, 2., None).is_none());
    }

    #[test]
    fn visibility_gap_during_one_receive_batch_drops_old_terminal_but_resumes_active_age() {
        let mut facts = Facts::default(); let mut state = state(&facts);
        let q = facts.begin(1, 1, 20, Kind::GarenQ, all()).unwrap();
        state.observe(&snapshot(2, &facts, Some(q)), 1.).unwrap();
        let mut hidden = snapshot(3, &facts, None); hidden.players.clear(); hidden.attack_events.clear();
        state.observe(&hidden, 1.).unwrap();
        assert!(state.selection(1, 1., Some(1.)).is_none());
        state.observe(&snapshot(10, &facts, Some(q)), 1.).unwrap();
        assert!((selected(&state, 1.).age_seconds - 0.3).abs() < 0.0001);
        hidden.tick = 11; state.observe(&hidden, 1.).unwrap();
        facts.resolve(q, 20, Kind::GarenQ, true, all()).unwrap();
        state.observe(&snapshot(21, &facts, None), 1.).unwrap();
        assert!(state.selection(1, 1., Some(1.)).is_none());
    }

    #[test]
    fn missing_windup_without_terminal_interrupts_and_cannot_restart_same_identity() {
        let mut facts = Facts::default(); let mut state = state(&facts);
        let q = facts.begin(1, 1, 20, Kind::GarenQ, all()).unwrap();
        state.observe(&snapshot(2, &facts, Some(q)), 1.).unwrap();
        state.observe(&snapshot(3, &facts, None), 1.).unwrap();
        assert!(state.selection(1, 1., Some(1.)).is_none());
        let mut hidden = snapshot(4, &facts, None); hidden.players.clear(); hidden.attack_events.clear();
        state.observe(&hidden, 1.).unwrap();
        state.observe(&snapshot(5, &facts, Some(q)), 1.).unwrap();
        assert!(state.selection(1, 1., Some(1.)).is_none());
    }

    #[test]
    fn death_stun_spin_and_ultimate_interrupt_without_resumption_after_clear() {
        for block in 0..4 {
            let mut facts = Facts::default(); let mut state = state(&facts);
            let q = facts.begin(1, 1, 20, Kind::GarenQ, all()).unwrap();
            state.observe(&snapshot(2, &facts, Some(q)), 1.).unwrap();
            let mut blocked = snapshot(3, &facts, Some(q));
            match block {
                0 => blocked.players[0].health = 0.,
                1 => blocked.players[0].stuns.push(openleague_core::stuns::Stun { tag: "fixture".into(), source: None, expires_at: 4 }),
                2 => blocked.players[0].effects.spin_until = 4,
                _ => blocked.players[0].effects.ultimate = Some(openleague_core::spells::Ultimate { target: 2, rank: 1, resolves: 4 }),
            }
            state.observe(&blocked, 1.).unwrap();
            assert!(state.selection(1, 1., Some(1.)).is_none());
            let mut hidden = snapshot(4, &facts, None); hidden.players.clear(); hidden.attack_events.clear();
            state.observe(&hidden, 1.).unwrap();
            state.observe(&snapshot(5, &facts, Some(q)), 1.).unwrap();
            assert!(state.selection(1, 1., Some(1.)).is_none());
        }
    }

    #[test]
    fn completed_match_never_resumes_before_reset() {
        let mut facts = Facts::default(); let mut state = state(&facts);
        let q = facts.begin(1, 1, 20, Kind::GarenQ, all()).unwrap();
        state.observe(&snapshot(2, &facts, Some(q)), 1.).unwrap();
        let mut ended = snapshot(3, &facts, None); ended.winner = Some(0);
        state.observe(&ended, 1.).unwrap();
        state.observe(&snapshot(4, &facts, Some(q)), 1.).unwrap();
        assert!(state.selection(1, 1., Some(1.)).is_none());
    }

    #[test]
    fn delayed_q_uses_original_age_and_requires_real_finite_duration() {
        let mut facts = Facts::default(); let mut state = State::default(); state.reset(7);
        let q = facts.begin(1, 1, 60, Kind::GarenQ, all()).unwrap();
        state.observe(&snapshot(16, &facts, Some(q)), 5.).unwrap();
        assert!((selected(&state, 5.25).age_seconds - 0.75).abs() < 0.0001);
        assert!(state.selection(1, 5.5, Some(1.)).is_none());
        for duration in [None, Some(0.), Some(-1.), Some(f32::NAN), Some(f32::INFINITY)] {
            assert!(state.selection(1, 5., duration).is_none());
        }
        state.observe(&snapshot(40, &facts, Some(q)), 6.).unwrap();
        assert!(state.selection(1, 6., Some(1.)).is_none());
    }

    #[test]
    fn resolution_kind_change_does_not_restart_age_or_change_identity() {
        let mut facts = Facts::default(); let mut state = state(&facts);
        let attack = facts.begin(1, 1, 10, Kind::Basic, all()).unwrap();
        state.observe(&snapshot(2, &facts, Some(attack)), 1.).unwrap();
        facts.resolve(attack, 10, Kind::GarenQ, false, all()).unwrap();
        state.observe(&snapshot(10, &facts, None), 1.2).unwrap();
        assert_eq!(selected(&state, 1.2).role, "spell1");
        assert_eq!(selected(&state, 1.2).attack, attack.id);
        assert!((selected(&state, 1.2).age_seconds - 0.3).abs() < 0.0001);
    }

    #[test]
    fn late_newer_snapshot_and_resolution_do_not_rewind_an_expired_attack() {
        let mut facts = Facts::default(); let mut state = state(&facts);
        let q = facts.begin(1, 1, 20, Kind::GarenQ, all()).unwrap();
        state.observe(&snapshot(2, &facts, Some(q)), 1.).unwrap();
        assert!(state.selection(1, 2., Some(1.)).is_none());
        state.observe(&snapshot(3, &facts, Some(q)), 2.1).unwrap();
        assert!(state.selection(1, 2.1, Some(1.)).is_none());
        facts.resolve(q, 20, Kind::GarenQ, true, all()).unwrap();
        state.observe(&snapshot(20, &facts, None), 2.2).unwrap();
        assert!(state.selection(1, 2.2, Some(1.)).is_none());
    }

    #[test]
    fn fog_return_cannot_rewind_an_expired_identity_on_a_delayed_tick() {
        let mut facts = Facts::default(); let mut state = state(&facts);
        let q = facts.begin(1, 1, 60, Kind::GarenQ, all()).unwrap();
        state.observe(&snapshot(2, &facts, Some(q)), 1.).unwrap();
        assert!(state.selection(1, 2., Some(1.)).is_none());
        let mut hidden = snapshot(3, &facts, None); hidden.players.clear(); hidden.attack_events.clear();
        state.observe(&hidden, 2.1).unwrap();
        state.observe(&snapshot(4, &facts, Some(q)), 2.2).unwrap();
        assert!(state.selection(1, 2.2, Some(1.)).is_none());
    }

    #[test]
    fn new_identity_after_long_delay_starts_at_its_own_network_age() {
        let mut facts = Facts::default(); let mut state = state(&facts);
        let old = facts.begin(1, 1, 20, Kind::GarenQ, all()).unwrap();
        state.observe(&snapshot(2, &facts, Some(old)), 1.).unwrap();
        assert!(state.selection(1, 11., Some(1.)).is_none());
        state.observe(&snapshot(3, &facts, Some(old)), 11.).unwrap();
        assert!(state.selection(1, 11., Some(1.)).is_none());
        facts.resolve(old, 20, Kind::GarenQ, true, all()).unwrap();
        let fresh = facts.begin(1, 21, 30, Kind::GarenQ, all()).unwrap();
        state.observe(&snapshot(22, &facts, Some(fresh)), 11.1).unwrap();
        let selected = selected(&state, 11.1);
        assert_eq!(selected.attack, fresh.id);
        assert_eq!(selected.role, "spell1");
        assert!((selected.age_seconds - 1. / 30.).abs() < 0.0001);
    }

    #[test]
    fn explicit_effect_clock_pause_and_scale_do_not_use_wall_time() {
        let mut facts = Facts::default(); let mut state = state(&facts);
        let q = facts.begin(1, 1, 60, Kind::GarenQ, all()).unwrap();
        state.observe(&snapshot(2, &facts, Some(q)), 10.).unwrap();
        let paused = selected(&state, 10.);
        // Any number of frames with a frozen EffectClock has the same age.
        assert_eq!(selected(&state, 10.), paused);
        assert!(!state.observe(&snapshot(2, &facts, Some(q)), 10.).unwrap());
        assert_eq!(selected(&state, 10.), paused);
        let scaled = selected(&state, 10.125);
        assert!((scaled.age_seconds - paused.age_seconds - 0.125).abs() < 0.0001);
        state.observe(&snapshot(3, &facts, Some(q)), 10.125).unwrap();
        assert!((selected(&state, 10.125).age_seconds - scaled.age_seconds).abs() < 0.0001);
    }

    #[test]
    fn movement_interrupts_only_recovery_and_buff_alone_never_starts_an_attack() {
        let mut facts = Facts::default(); let mut state = state(&facts);
        let mut only_buff = snapshot(1, &facts, None); only_buff.players[0].effects.empowered_until = 500;
        state.observe(&only_buff, 1.).unwrap();
        assert!(state.selection(1, 1., Some(1.)).is_none());
        let q = facts.begin(1, 2, 10, Kind::GarenQ, all()).unwrap();
        let mut moving = snapshot(3, &facts, Some(q)); moving.players[0].destination = Some(Point { x: 10., z: 20. });
        state.observe(&moving, 1.).unwrap(); assert_eq!(selected(&state, 1.).role, "spell1");
        facts.resolve(q, 10, Kind::GarenQ, true, all()).unwrap();
        let mut recovery = snapshot(10, &facts, None); recovery.players[0].destination = moving.players[0].destination;
        state.observe(&recovery, 1.).unwrap();
        assert!(state.selection(1, 1., Some(1.)).is_none());
        state.observe(&snapshot(11, &facts, None), 1.).unwrap();
        assert!(state.selection(1, 1., Some(1.)).is_none());
    }

    #[test]
    fn cancellation_and_server_error_disable_presentation_while_valid_game_state_is_accepted() {
        let mut facts = Facts::default(); let mut state = state(&facts);
        let q = facts.begin(1, 1, 20, Kind::GarenQ, all()).unwrap();
        state.observe(&snapshot(2, &facts, Some(q)), 1.).unwrap();
        facts.cancel(q, 3, CancelReason::Order, all()).unwrap();
        state.observe(&snapshot(3, &facts, None), 1.).unwrap();
        assert!(state.selection(1, 1., Some(1.)).is_none());
        let next = facts.begin(1, 4, 20, Kind::GarenQ, all()).unwrap();
        let mut errored = snapshot(5, &facts, Some(next)); errored.attack_presentation_error = Some("fixture server failure".into());
        assert!(state.observe(&errored, 2.).unwrap());
        assert_eq!(state.error(), Some("fixture server failure"));
        state.observe(&snapshot(6, &facts, Some(next)), 2.).unwrap();
        assert!(state.selection(1, 2., Some(1.)).is_none());
        state.reset(7);
        assert!(state.error().is_none());
        state.observe(&snapshot(7, &facts, Some(next)), 3.).unwrap();
        assert_eq!(selected(&state, 3.).attack, next.id);
    }

    #[test]
    fn invalid_journal_clock_or_session_is_transactional_and_stale_is_ignored() {
        let mut facts = Facts::default(); let mut state = state(&facts);
        let q = facts.begin(1, 1, 10, Kind::GarenQ, all()).unwrap();
        state.observe(&snapshot(2, &facts, Some(q)), 1.).unwrap();
        let before = state.clone();
        facts.resolve(q, 10, Kind::GarenQ, true, all()).unwrap();
        let mut bad = snapshot(10, &facts, None); bad.attack_events.reverse();
        assert!(state.observe(&bad, 2.).is_err()); assert_eq!(state, before);
        let mut other = snapshot(11, &facts, None); other.session = 8;
        assert!(state.observe(&other, 2.).is_err()); assert_eq!(state, before);
        assert!(state.observe(&snapshot(11, &facts, None), f64::NAN).is_err()); assert_eq!(state, before);
        assert!(!state.observe(&snapshot(1, &facts, None), 0.).unwrap()); assert_eq!(state, before);
        assert!(state.selection(1, f64::INFINITY, Some(1.)).is_none());
    }

    #[test]
    fn frame_cancel_at_same_tick_retires_q_and_cannot_restart_from_duplicate_frame() {
        let mut facts=Facts::default();let q=facts.begin(1,10,20,Kind::GarenQ,all()).unwrap();
        let mut state=State::default();state.reset(7);state.begin_epoch(7,1).unwrap();
        let started=snapshot(11,&facts,Some(q));state.observe_frame(&started,1,5.).unwrap();
        let before=selected(&state,5.);
        state.observe_frame(&started,2,5.).unwrap();assert_eq!(selected(&state,5.),before);
        facts.cancel(q,11,CancelReason::Order,all()).unwrap();
        let cancelled=snapshot(11,&facts,None);state.observe_frame(&cancelled,3,5.).unwrap();
        assert!(state.selection(1,5.,Some(1.)).is_none());let saved=state.clone();
        assert!(!state.observe_frame(&started,2,6.).unwrap());assert_eq!(state,saved);
        state.begin_epoch(7,2).unwrap();state.observe_frame(&cancelled,1,5.).unwrap();
        assert!(state.selection(1,5.,Some(1.)).is_none());
    }
    #[test]
    fn new_epoch_and_same_tick_visibility_preserve_q_identity_age_and_no_restart() {
        let mut facts=Facts::default();let q=facts.begin(1,10,50,Kind::GarenQ,all()).unwrap();
        let mut state=State::default();state.reset(7);state.begin_epoch(7,1).unwrap();
        let active=snapshot(11,&facts,Some(q));state.observe_frame(&active,9,5.).unwrap();
        let before=selected(&state,5.25);state.begin_epoch(7,2).unwrap();
        state.observe_frame(&active,1,5.25).unwrap();assert_eq!(selected(&state,5.25),before);
        let mut hidden=active.clone();hidden.players.clear();hidden.attack_events.clear();
        state.observe_frame(&hidden,2,5.25).unwrap();assert!(state.selection(1,5.25,Some(1.)).is_none());
        state.observe_frame(&active,3,5.25).unwrap();assert_eq!(selected(&state,5.25),before);
        hidden.roster.clear();state.observe_frame(&hidden,4,5.25).unwrap();
        assert!(state.contexts.is_empty());assert!(state.anchors.is_empty());
        assert!(state.interrupted.is_empty());assert!(state.selection(1,5.25,Some(1.)).is_none());
    }
}
