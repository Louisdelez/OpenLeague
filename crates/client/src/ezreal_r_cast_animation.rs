//! Optional animation of received, body-visible Ezreal R Pending casts.
//! releases-30 is the existing LOCAL simulation policy, not a native clip clock.
//! The EffectClock supplies elapsed age; no pose, heading or gameplay is invented.
use openleague_core::{Snapshot, TICK_RATE, ezreal_r::{VisibleCast, WINDUP_TICKS}};
use std::collections::{BTreeMap, BTreeSet};

const MAX_OWNERS: usize = 64;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Identity {
    pub session: u64, pub epoch: u64, pub owner: u32, pub team: u8,
    pub ordinal: u64, pub releases: u64,
}
#[derive(Debug, Clone, Copy, PartialEq)]
struct Record {
    ordinal: u64, releases: u64, team: u8, direction: [u32; 2],
    age: f64, received_at: f64, claimed_by: Option<u64>, retired: bool,
}
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Selection { pub identity: Identity, pub age_seconds: f32, pub first: bool }

#[derive(Debug, Default, Clone, PartialEq)]
pub struct State {
    session: Option<u64>, epoch: u64, tick: Option<u64>, clock: Option<f64>,
    visible: BTreeSet<u32>, records: BTreeMap<u32, Record>,
    q_conflicts: BTreeSet<u32>, ready: bool, finished: bool,
}
impl State {
    pub fn reset(&mut self, session: u64) {
        if self.session != Some(session) { *self = Self { session: Some(session), ..Self::default() }; }
        else { self.suspend(); self.epoch = 0; self.tick = None; self.clock = None; self.visible.clear(); }
    }
    pub fn begin_epoch(&mut self, session: u64, epoch: u64) {
        if epoch == 0 || (self.session == Some(session) && epoch <= self.epoch) { return; }
        if self.session != Some(session) { self.reset(session); }
        self.suspend(); self.epoch = epoch; self.tick = None; self.clock = None; self.visible.clear();
    }
    pub fn retire(&mut self, owner: u32) {
        if let Some(record) = self.records.get_mut(&owner) { record.retired = true; }
    }
    pub fn suspend(&mut self) {
        for record in self.records.values_mut() { record.retired = true; }
        self.ready = false; self.q_conflicts.clear();
    }
    /// Called after Q observation for EVERY accepted packet, before coalescing.
    /// A simultaneous Q/R body cannot leave either pose armed for a later frame.
    pub fn observe_with_q(&mut self, snapshot: &Snapshot, now: f64, ready: bool,
        paused: bool, q: &mut crate::ezreal_q_cast_animation::State,
    ) -> Result<bool, String> {
        let accepted = self.observe_accepted(snapshot, now, ready, paused)?;
        if accepted { for owner in &self.q_conflicts { q.retire(*owner); } }
        Ok(accepted)
    }
    /// Malformed optional rows cannot change gameplay. Retire this channel on
    /// rejection so invalidity followed by recovery in one batch never replays it.
    pub fn observe_accepted(&mut self, snapshot: &Snapshot, now: f64,
        clock_ready: bool, clock_paused: bool,
    ) -> Result<bool, String> {
        if self.session != Some(snapshot.session) || self.tick.is_some_and(|tick| snapshot.tick < tick) {
            return Ok(false);
        }
        if !now.is_finite() || self.clock.is_some_and(|old| now < old) {
            self.suspend(); return Err("Ezreal R presentation clock invalid".into());
        }
        let mut next = self.clone();
        match next.observe_inner(snapshot, now, clock_ready, clock_paused) {
            Ok(()) => { *self = next; Ok(true) }
            Err(error) => { self.suspend(); Err(error) }
        }
    }
    fn observe_inner(&mut self, snapshot: &Snapshot, now: f64,
        clock_ready: bool, clock_paused: bool,
    ) -> Result<(), String> {
        if snapshot.roster.len() > MAX_OWNERS || snapshot.players.len() > MAX_OWNERS
            || snapshot.ezreal_r_casts.len() > MAX_OWNERS {
            return Err("Ezreal R presentation owner budget exceeded".into());
        }
        let mut roster = BTreeMap::new();
        for entry in &snapshot.roster {
            if entry.id == 0 || entry.team > 1 || roster.insert(entry.id, (entry.team, entry.champion.as_str())).is_some() {
                return Err("Ezreal R presentation roster invalid".into());
            }
        }
        let mut visible = BTreeMap::new();
        let mut player_ids = BTreeSet::new();
        for actor in &snapshot.players {
            if !player_ids.insert(actor.id) { return Err("Ezreal R duplicate visible body".into()); }
            if actor.champion != "ezreal" { continue; }
            if !roster.get(&actor.id).is_some_and(|(team, name)| *name == "ezreal" && *team == actor.team) {
                return Err("Ezreal R visible owner invalid".into());
            }
            visible.insert(actor.id, actor);
        }
        let mut casts = BTreeMap::new();
        for cast in &snapshot.ezreal_r_casts {
            let starts = cast.releases.checked_sub(WINDUP_TICKS).ok_or("Ezreal R release precedes local windup")?;
            let length = f64::from(cast.direction.x).hypot(f64::from(cast.direction.z));
            if cast.session != snapshot.session || cast.owner == 0 || cast.team > 1 || cast.ordinal == 0
                || starts > snapshot.tick || !cast.direction.finite() || !(0.999..=1.001).contains(&length)
                || !visible.get(&cast.owner).is_some_and(|actor| actor.team == cast.team)
                || casts.insert(cast.owner, cast).is_some() {
                return Err("Ezreal R cast identity, body, geometry or time invalid".into());
            }
            if let Some(old) = self.records.get(&cast.owner) {
                if cast.ordinal < old.ordinal || cast.team != old.team
                    || (cast.ordinal == old.ordinal && (cast.releases != old.releases || bits(cast) != old.direction))
                    || (cast.ordinal > old.ordinal && cast.releases <= old.releases) {
                    return Err("Ezreal R cast identity changed or regressed".into());
                }
            }
        }
        let baseline = self.tick.is_none() || !self.ready;
        let previous_tick = self.tick;
        let previous_visible = self.visible.clone();
        self.finished |= snapshot.winner.is_some() || snapshot.result.is_some();
        self.q_conflicts.clear();
        // Only roster departure frees a consumed ordinal. FoW loss never does.
        self.records.retain(|owner, _| roster.get(owner).is_some_and(|(_, name)| *name == "ezreal"));
        for (&owner, cast) in &casts {
            let starts = cast.releases - WINDUP_TICKS;
            if self.records.get(&owner).is_none_or(|old| cast.ordinal > old.ordinal) {
                self.records.insert(owner, Record {
                    ordinal: cast.ordinal, releases: cast.releases, team: cast.team, direction: bits(cast),
                    age: snapshot.tick.saturating_sub(starts) as f64 / TICK_RATE as f64,
                    received_at: now, claimed_by: None,
                    retired: baseline || !previous_visible.contains(&owner) || !clock_ready || clock_paused
                        || self.finished || previous_tick.is_some_and(|tick| starts < tick),
                });
            }
        }
        for (&owner, record) in &mut self.records {
            let Some(actor) = visible.get(&owner) else { record.retired = true; continue; };
            let Some(cast) = casts.get(&owner).filter(|cast| cast.ordinal == record.ordinal) else {
                record.retired = true; continue;
            };
            let starts = record.releases - WINDUP_TICKS;
            let elapsed = record.age + (now - record.received_at);
            let age = if clock_paused { record.age } else {
                elapsed.max(snapshot.tick.saturating_sub(starts) as f64 / TICK_RATE as f64)
            };
            if !age.is_finite() || age < 0. { return Err("Ezreal R presentation age invalid".into()); }
            record.age = age; record.received_at = now;
            let q_conflict = actor.effects.ezreal_q.is_some();
            if q_conflict { self.q_conflicts.insert(owner); }
            if self.finished || !clock_ready || snapshot.tick >= cast.releases || age >= window()
                || !actor.health.is_finite() || actor.health <= 0. || !actor.position.finite()
                || openleague_core::trundle_e::champion_forced(actor, snapshot.tick)
                || openleague_core::stuns::active(actor, snapshot.tick)
                || snapshot.tick < actor.effects.silence_until || actor.windup.is_some()
                || q_conflict || actor.effects.ezreal_w.is_some() {
                record.retired = true;
            }
        }
        self.visible = visible.keys().copied().collect();
        self.tick = Some(snapshot.tick); self.clock = Some(now); self.ready = clock_ready;
        Ok(())
    }
    /// A replaced player or unavailable clip consumes this launch permanently.
    /// Duration is a bound, never a scale factor for the authored animation.
    pub fn select(&mut self, owner: u32, entity: u64, now: f64, duration: Option<f32>,
        eligible: bool, clock_ready: bool,
    ) -> Option<Selection> {
        if !clock_ready || !self.ready || !now.is_finite() || self.clock.is_some_and(|old| now < old) {
            self.suspend(); return None;
        }
        self.clock = Some(now);
        let record = self.records.get_mut(&owner)?;
        if record.retired { return None; }
        let age = record.age + (now - record.received_at);
        let duration = duration.filter(|value| value.is_finite() && *value > 0.);
        if !eligible || duration.is_none() || !age.is_finite() || age < 0. || age >= window()
            || duration.is_some_and(|duration| age >= f64::from(duration))
            || record.claimed_by.is_some_and(|old| old != entity) {
            record.retired = true; return None;
        }
        let first = record.claimed_by.is_none(); record.claimed_by = Some(entity);
        record.age = age; record.received_at = now;
        Some(Selection { identity: Identity { session: self.session?, epoch: self.epoch, owner,
            team: record.team, ordinal: record.ordinal, releases: record.releases }, age_seconds: age as f32, first })
    }
}
fn bits(cast: &VisibleCast) -> [u32; 2] { [cast.direction.x.to_bits(), cast.direction.z.to_bits()] }
fn window() -> f64 { WINDUP_TICKS as f64 / TICK_RATE as f64 }

#[cfg(test)]
pub(crate) mod test_support {
    use openleague_core::{Action, Navigation, Point, Simulation, Snapshot};
    pub(crate) fn game() -> (Simulation, u32) {
        let mut cells = Vec::new();
        for _ in 0..400 { cells.extend(0f32.to_le_bytes()); cells.extend(0u16.to_le_bytes()); cells.extend(0u32.to_le_bytes()); cells.push(1); }
        let nav = Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":20,"height":20}"#, &cells).unwrap();
        let mut game = Simulation::new(nav).unwrap(); game.session = 7; game.tick = 99;
        let owner = game.join("ezreal").unwrap();
        let actor = game.players.get_mut(&owner).unwrap();
        actor.position = Point { x: 100., z: 100. }; actor.level = 6; actor.ranks = [1,0,0,1]; actor.mana = 2000.;
        (game, owner)
    }
    pub(crate) fn cast(game: &mut Simulation, owner: u32) -> Snapshot {
        game.tick = 100;
        game.command(owner, Action::CastAt { slot: 3, point: Point { x: 700., z: 100. } }).unwrap();
        let snapshot = game.snapshot_for(owner).unwrap();
        assert_eq!(snapshot.ezreal_r_casts.len(), 1, "real Pending projection required");
        snapshot
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use super::test_support::{game, cast};
    use openleague_core::{Point, Simulation};
    fn fixture() -> (Simulation, u32, State) {
        let (game, owner) = game(); let mut state = State::default(); state.reset(7);
        state.observe_accepted(&game.snapshot_for(owner).unwrap(), 0., true, false).unwrap();
        (game, owner, state)
    }
    fn select(state: &mut State, owner: u32, entity: u64, now: f64) -> Option<Selection> {
        state.select(owner, entity, now, Some(3.0666668), true, true)
    }
    #[test]
    fn real_pending_projection_duplicate_pause_and_exclusive_release_do_not_rescale_or_mutate() {
        let (mut game, owner, mut state) = fixture(); let snapshot = cast(&mut game, owner);
        let original = serde_json::to_value(&snapshot).unwrap();
        state.observe_accepted(&snapshot, 0.1, true, false).unwrap();
        let first = select(&mut state, owner, 10, 0.1).unwrap();
        assert!(first.first); assert_eq!(first.age_seconds, 0.); assert_eq!(first.identity.ordinal, snapshot.ezreal_r_casts[0].ordinal);
        state.observe_accepted(&snapshot, 0.3, true, false).unwrap();
        let age = select(&mut state, owner, 10, 0.3).unwrap().age_seconds;
        assert!((age - 0.2).abs() < 0.00001);
        let mut paused = snapshot.clone(); paused.tick = 125;
        state.observe_accepted(&paused, 0.3, true, true).unwrap();
        assert_eq!(select(&mut state, owner, 10, 0.3).unwrap().age_seconds, age);
        state.observe_accepted(&paused, 0.3, true, false).unwrap();
        assert!((select(&mut state, owner, 10, 0.3).unwrap().age_seconds - 25. / 30.).abs() < 0.00001);
        game.tick = 130; let released = game.snapshot_for(owner).unwrap();
        assert!(released.ezreal_r_casts.is_empty());
        state.observe_accepted(&released, 0.4, true, false).unwrap();
        assert!(select(&mut state, owner, 10, 0.4).is_none());
        assert_eq!(serde_json::to_value(&snapshot).unwrap(), original);
    }
    #[test]
    fn accepted_absence_control_and_end_in_one_batch_cannot_rearm_same_ordinal() {
        for mode in 0..7 {
            let (mut game, owner, mut state) = fixture(); let snapshot = cast(&mut game, owner);
            state.observe_accepted(&snapshot, 0.1, true, false).unwrap();
            let mut interruption = snapshot.clone(); interruption.tick = 101;
            let actor = interruption.players.iter_mut().find(|p| p.id == owner).unwrap();
            match mode {
                0 => interruption.ezreal_r_casts.clear(),
                1 => { interruption.ezreal_r_casts.clear(); interruption.players.retain(|p| p.id != owner); },
                2 => actor.health = 0.,
                3 => actor.stuns.push(openleague_core::stuns::Stun { tag: "fixture".into(), source: None, expires_at: 120 }),
                4 => {
                    actor.effects.trundle_e_push = Some(openleague_core::trundle_e::ForcedMovement { started: 101, until: 112 });
                    assert!(openleague_core::trundle_e::champion_forced(actor, 101), "forced fixture must be active before observation");
                },
                5 => actor.effects.silence_until = 120,
                _ => interruption.winner = Some(0),
            }
            state.observe_accepted(&interruption, 0.11, true, false).unwrap();
            let mut restored = snapshot.clone(); restored.tick = 102;
            state.observe_accepted(&restored, 0.12, true, false).unwrap();
            assert!(select(&mut state, owner, 10, 0.12).is_none(), "case {mode}");
        }
    }
    #[test]
    fn baseline_epoch_fog_reveal_and_late_discovery_do_not_reconstruct_cast_history() {
        for mode in 0..5 {
            let (mut game, owner, mut state) = fixture(); let snapshot = cast(&mut game, owner);
            match mode {
                0 => state.begin_epoch(7, 2),
                1 => { state.reset(8); let mut other = snapshot.clone(); other.session = 8; other.ezreal_r_casts[0].session = 8;
                    state.observe_accepted(&other, 0.1, true, false).unwrap(); assert!(select(&mut state, owner, 10, 0.1).is_none()); continue; },
                2 => { let mut hidden = snapshot.clone(); hidden.players.clear(); hidden.ezreal_r_casts.clear();
                    state.observe_accepted(&hidden, 0.1, true, false).unwrap(); },
                3 => { let mut absent = snapshot.clone(); absent.tick = 104; absent.ezreal_r_casts.clear();
                    state.observe_accepted(&absent, 0.1, true, false).unwrap(); },
                _ => state.suspend(),
            }
            let mut later = snapshot.clone(); later.tick = 105;
            state.observe_accepted(&later, 0.2, true, false).unwrap();
            assert!(select(&mut state, owner, 10, 0.2).is_none(), "case {mode}");
        }
        let (mut game, owner, mut state) = fixture(); let mut delayed = cast(&mut game, owner); delayed.tick = 106;
        state.observe_accepted(&delayed, 0.1, true, false).unwrap();
        assert!((select(&mut state, owner, 10, 0.1).unwrap().age_seconds - 0.2).abs() < 0.00001);
    }
    #[test]
    fn malformed_identity_clock_missing_clip_and_player_replacement_consume_without_replay() {
        for mode in 0..12 {
            let (mut game, owner, mut state) = fixture(); let snapshot = cast(&mut game, owner);
            state.observe_accepted(&snapshot, 0.1, true, false).unwrap();
            assert!(select(&mut state, owner, 10, 0.1).is_some());
            if mode < 6 {
                let mut bad = snapshot.clone(); bad.tick = 101;
                match mode { 0 => bad.ezreal_r_casts[0].direction = Point { x: 0., z: 1. },
                    1 => bad.ezreal_r_casts[0].ordinal = 0, 2 => bad.ezreal_r_casts[0].session = 8,
                    3 => bad.ezreal_r_casts[0].releases += 1,
                    4 => { let duplicate = bad.ezreal_r_casts[0]; bad.ezreal_r_casts.push(duplicate); },
                    _ => bad.ezreal_r_casts[0].direction.x = f32::NAN }
                assert!(state.observe_accepted(&bad, 0.11, true, false).is_err());
            } else { match mode {
                6 => { assert!(state.select(owner, 10, 0.11, None, true, true).is_none()); },
                7 => { assert!(select(&mut state, owner, 11, 0.11).is_none()); },
                8 => { assert!(state.observe_accepted(&snapshot, f64::NAN, true, false).is_err()); },
                9 => { assert!(select(&mut state, owner, 10, 0.09).is_none()); },
                10 => { assert!(state.select(owner, 10, 0.11, Some(0.005), true, true).is_none()); },
                _ => { assert!(state.select(owner, 10, 0.11, Some(4.), true, false).is_none()); },
            } }
            let mut restored = snapshot.clone(); restored.tick = 102;
            state.observe_accepted(&restored, 0.12, true, false).unwrap();
            assert!(select(&mut state, owner, 10, 0.12).is_none(), "case {mode}");
        }
    }
    #[test]
    fn stale_packets_are_inert_bounded_departures_free_storage_and_new_ordinals_can_start() {
        let (mut game, owner, mut state) = fixture(); let snapshot = cast(&mut game, owner);
        state.observe_accepted(&snapshot, 0.1, true, false).unwrap();
        let mut stale = snapshot.clone(); stale.tick = 99;
        let before = state.clone(); assert_eq!(state.observe_accepted(&stale, 0.2, true, false), Ok(false)); assert_eq!(state, before);
        let mut absent = snapshot.clone(); absent.tick = 130; absent.ezreal_r_casts.clear();
        state.observe_accepted(&absent, 1.1, true, false).unwrap();
        // Advance the real Pending through release before a fresh command.
        while game.tick < 130 { game.advance(); }
        game.tick = 131; game.players.get_mut(&owner).unwrap().cooldowns[3] = 0;
        game.command(owner, openleague_core::Action::CastAt { slot: 3, point: Point { x: 700., z: 100. } }).unwrap();
        let fresh = game.snapshot_for(owner).unwrap();
        state.observe_accepted(&fresh, 1.2, true, false).unwrap();
        assert!(select(&mut state, owner, 10, 1.2).unwrap().identity.ordinal > snapshot.ezreal_r_casts[0].ordinal);
        let mut departed = fresh.clone(); departed.players.clear(); departed.roster.clear(); departed.ezreal_r_casts.clear();
        state.observe_accepted(&departed, 1.3, true, false).unwrap(); assert!(state.records.is_empty());
    }
    #[test]
    fn simultaneous_real_q_lock_and_r_row_retire_both_before_a_later_packet() {
        let (mut game, owner, mut state) = fixture();
        let baseline = game.snapshot_for(owner).unwrap();
        let mut q = crate::ezreal_q_cast_animation::State::default(); q.reset(7);
        q.observe_accepted(&baseline, 0., true, false).unwrap();
        let mut q_game = test_support::game().0; q_game.tick = 100;
        q_game.command(owner, openleague_core::Action::CastAt { slot: 0, point: Point { x: 700., z: 100. } }).unwrap();
        let lock = q_game.players[&owner].effects.ezreal_q.clone();
        let mut conflict = cast(&mut game, owner); conflict.players.iter_mut().find(|p| p.id == owner).unwrap().effects.ezreal_q = lock;
        q.observe_accepted(&conflict, 0.1, true, false).unwrap();
        state.observe_with_q(&conflict, 0.1, true, false, &mut q).unwrap();
        let mut restored = conflict.clone(); restored.tick = 101; restored.ezreal_r_casts.clear();
        q.observe_accepted(&restored, 0.12, true, false).unwrap();
        state.observe_with_q(&restored, 0.12, true, false, &mut q).unwrap();
        assert!(q.select(owner, 10, 0.12, Some(0.8), true, true).is_none());
        assert!(select(&mut state, owner, 10, 0.12).is_none());
    }
}
