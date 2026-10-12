use super::*;
use openleague_core::{Action, Navigation, Simulation};

fn game() -> Simulation {
    let mut cells = Vec::new();
    for _ in 0..16 {
        cells.extend(0f32.to_le_bytes()); cells.extend(0u16.to_le_bytes());
        cells.extend(0u32.to_le_bytes()); cells.push(1);
    }
    let nav = Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":4,"height":4}"#, &cells).unwrap();
    let mut game = Simulation::new(nav).unwrap();
    game.session = 7;
    assert_eq!(game.join("garen").unwrap(), 1);
    game
}
fn snapshot(tick: u64, started: u64, end: u64) -> Snapshot {
    let mut snap = game().snapshot();
    snap.tick = tick;
    let p = &mut snap.players[0];
    p.effects.courage_until = end;
    p.cooldown_totals[1] = Some(720);
    p.cooldowns[1] = started + 720;
    snap
}
fn state() -> State { State::new(7, 6).unwrap() }
fn selected(state: &State, now: f64) -> Sustained { state.sustained(1, now).unwrap() }
fn near(a: f32, b: f32) { assert!((a-b).abs() < 0.0001, "{a} != {b}"); }

#[test]
fn w_real_casts_commit_identity_for_all_ranks_cdr_and_during_judgment() {
    for rank in 1..=5 { for cdr in [false, true] {
        let mut game = game();
        game.tick = 37;
        let p = game.players.get_mut(&1).unwrap();
        p.level = 18; p.ranks[1] = rank; p.ranks[2] = 1;
        if cdr { p.inventory[0] = Some(3108); }
        game.command(1, Action::Cast { slot: 2, target: None }).unwrap();
        game.command(1, Action::Cast { slot: 1, target: None }).unwrap();
        let mut state = state();
        state.observe(&game.snapshot(), 2.).unwrap();
        let item = selected(&state, 2.);
        assert_eq!(item.identity.started, 37);
        assert_eq!(item.identity.end, game.players[&1].effects.courage_until);
        near(item.age_seconds, 0.);
        assert!(game.players[&1].effects.spin_until > game.tick);
        // Changing current rank/items does not rewrite a committed cast.
        game.players.get_mut(&1).unwrap().ranks[1] = 5;
        game.players.get_mut(&1).unwrap().inventory[0] = None;
        game.tick += 1;
        state.observe(&game.snapshot(), 2.).unwrap();
        assert_eq!(selected(&state, 2.).identity, item.identity);
        let committed = (game.players[&1].cooldowns[1], game.players[&1].cooldown_totals[1],
            game.players[&1].effects.courage_until);
        assert!(game.command(1, Action::Cast { slot: 1, target: None }).is_err());
        assert_eq!((game.players[&1].cooldowns[1], game.players[&1].cooldown_totals[1],
            game.players[&1].effects.courage_until), committed);
    }}
}

#[test]
fn w_delayed_first_sight_is_sustained_at_network_age_not_a_new_burst() {
    let mut state = state();
    state.observe(&snapshot(40, 10, 160), 4.).unwrap();
    let value = selected(&state, 4.);
    assert_eq!(value.identity, Identity { session: 7, source: 1, started: 10, end: 160 });
    near(value.age_seconds, 1.);
    near(selected(&state, 4.25).age_seconds, 1.25);
    assert!(state.sustained(1, 8.).is_none()); // bonus duration, not cooldown end
}

#[test]
fn w_same_cast_snapshots_rank_change_and_clock_pause_never_restart_age() {
    let mut state = state();
    state.observe(&snapshot(11, 10, 160), 3.).unwrap();
    let mut next = snapshot(20, 10, 160);
    next.players[0].ranks[1] = 5;
    state.observe(&next, 3.5).unwrap();
    near(selected(&state, 3.5).age_seconds, 1./30. + 0.5);
    // Repeated EffectClock.now while paused advances no local time.
    for _ in 0..8 { near(selected(&state, 3.5).age_seconds, 1./30. + 0.5); }
    // Scale is already reflected in EffectClock.now; no wall clock is sampled here.
    near(selected(&state, 3.75).age_seconds, 1./30. + 0.75);
    let before = state.clone();
    assert!(!state.observe(&next, 4.).unwrap());
    assert_eq!(state, before);
}

#[test]
fn w_hidden_intermediate_snapshot_removes_output_and_keeps_only_age() {
    let mut state = state();
    state.observe(&snapshot(11, 10, 160), 1.).unwrap();
    let mut hidden = snapshot(12, 10, 160); hidden.players.clear();
    state.observe(&hidden, 1.1).unwrap();
    assert!(state.sustained(1, 1.1).is_none());
    assert!(state.visible.is_empty()); assert_eq!(state.anchors.len(), 1);
    state.observe(&snapshot(40, 10, 160), 2.).unwrap();
    near(selected(&state, 2.).age_seconds, 1./30. + 1.);
    assert_eq!(selected(&state, 2.).identity.started, 10);
}

#[test]
fn w_fog_return_does_not_revive_expired_age_but_next_cast_has_its_own_anchor() {
    let mut state = state();
    state.observe(&snapshot(11, 10, 70), 1.).unwrap();
    let mut hidden = snapshot(12, 10, 70); hidden.players.clear();
    state.observe(&hidden, 10.).unwrap();
    state.observe(&snapshot(13, 10, 70), 10.1).unwrap();
    assert!(state.sustained(1, 10.1).is_none());
    state.observe(&snapshot(731, 730, 790), 10.2).unwrap();
    near(selected(&state, 10.2).age_seconds, 1./30.);
    assert_eq!(selected(&state, 10.2).identity.started, 730);
}

#[test]
fn w_explicit_clear_death_and_respawn_do_not_resume_the_same_identity() {
    for reason in 0..3 {
        let mut state = state();
        state.observe(&snapshot(11, 10, 160), 1.).unwrap();
        let mut stopped = snapshot(12, 10, 160);
        match reason {
            0 => stopped.players[0].effects.courage_until = 0,
            1 => stopped.players[0].health = 0.,
            _ => stopped.players[0].respawn_at = Some(15),
        }
        state.observe(&stopped, 1.1).unwrap();
        state.observe(&snapshot(13, 10, 160), 1.2).unwrap();
        assert!(state.sustained(1, 1.2).is_none());
    }
}

#[test]
fn w_departure_completion_and_session_reset_retire_local_contexts() {
    let mut state = state();
    state.observe(&snapshot(11, 10, 160), 1.).unwrap();
    let mut departed = snapshot(12, 10, 160); departed.players.clear(); departed.roster.clear();
    state.observe(&departed, 1.1).unwrap();
    assert!(state.anchors.is_empty()); assert!(state.sustained(1, 1.1).is_none());
    state.observe(&snapshot(13, 10, 160), 1.2).unwrap();
    let mut ended = snapshot(14, 10, 160); ended.winner = Some(0);
    state.observe(&ended, 1.3).unwrap();
    state.observe(&snapshot(15, 10, 160), 1.4).unwrap();
    assert!(state.sustained(1, 1.4).is_none());
    state.reset(8);
    assert!(state.anchors.is_empty()); assert!(state.sustained(1, 2.).is_none());
    assert!(state.observe(&snapshot(16, 10, 160), 2.).is_err());
    let mut fresh = snapshot(11, 10, 160); fresh.session = 8;
    state.observe(&fresh, 2.).unwrap();
    assert_eq!(selected(&state, 2.).identity.session, 8);
}

#[test]
fn w_two_actors_have_independent_identities_and_visibility() {
    let mut snap = snapshot(40, 10, 160);
    let mut other = snap.players[0].clone(); other.id = 2;
    other.cooldowns[1] = 750; other.effects.courage_until = 90;
    snap.players.push(other);
    let mut roster = snap.roster[0].clone(); roster.id = 2; snap.roster.push(roster);
    let mut state = state(); state.observe(&snap, 3.).unwrap();
    assert_eq!(state.sustained(1, 3.).unwrap().identity.started, 10);
    assert_eq!(state.sustained(2, 3.).unwrap().identity.started, 30);
    snap.tick = 41; snap.players.retain(|p| p.id == 2);
    state.observe(&snap, 3.1).unwrap();
    assert!(state.sustained(1, 3.1).is_none());
    assert!(state.sustained(2, 3.1).is_some());
}

#[test]
fn w_bad_committed_state_is_transactional_and_inactive_legacy_is_unknown() {
    let mut state = state();
    state.observe(&snapshot(11, 10, 160), 1.).unwrap();
    let saved = state.clone();
    for invalid in 0..9 {
        let mut snap = snapshot(12, 10, 160);
        let p = &mut snap.players[0];
        match invalid {
            0 => p.cooldown_totals[1] = None,
            1 => p.cooldown_totals[1] = Some(0),
            2 => p.cooldowns[1] = 1,
            3 => p.cooldowns[1] = 740, // future start
            4 => p.effects.courage_until = 800, // beyond committed cooldown
            5 => p.effects.courage_until = 161, // same cast changed end
            6 => p.cooldowns[1] = 729, // older start on a newer snapshot
            7 => p.health = f32::NAN,
            _ => snap.session = 8,
        }
        assert!(state.observe(&snap, 2.).is_err(), "invalid case {invalid}");
        assert_eq!(state, saved);
    }
    for now in [f64::NAN, f64::INFINITY, -1.] {
        assert!(state.observe(&snapshot(12, 10, 160), now).is_err()); assert_eq!(state, saved);
        assert!(state.sustained(1, now).is_none());
    }
    let mut old = snapshot(12, 10, 0); old.players[0].cooldown_totals[1] = None;
    state.observe(&old, 2.).unwrap(); assert!(state.sustained(1, 2.).is_none());
}

#[test]
fn w_duplicate_unknown_sources_and_capacity_overflow_are_rejected_before_commit() {
    assert!(State::new(7, 0).is_err());
    let state = State::new(7, 1).unwrap();
    for invalid in 0..4 {
        let mut candidate = state.clone(); let mut snap = snapshot(11, 10, 160);
        match invalid {
            0 => snap.players.push(snap.players[0].clone()),
            1 => snap.roster.push(snap.roster[0].clone()),
            2 => snap.roster.clear(),
            _ => { let mut other = snap.roster[0].clone(); other.id = 2; snap.roster.push(other); }
        }
        assert!(candidate.observe(&snap, 1.).is_err()); assert_eq!(candidate, state);
    }
}

#[test]
fn w_no_spell_clip_movement_spin_or_attack_state_is_changed_by_observation() {
    let mut snap = snapshot(11, 10, 160);
    snap.players[0].effects.spin_until = 100;
    snap.players[0].destination = Some(openleague_core::Point { x: 25., z: 75. });
    let bytes = serde_json::to_vec(&snap).unwrap();
    let mut state = state(); state.observe(&snap, 1.).unwrap();
    assert!(state.sustained(1, 1.).is_some());
    assert_eq!(serde_json::to_vec(&snap).unwrap(), bytes);
}


#[test]
fn same_tick_frame_visibility_clear_and_departure_retire_courage_without_age_restart() {
    let mut state=state();state.begin_epoch(7,1).unwrap();let active=snapshot(11,10,160);
    state.observe_frame(&active,1,5.).unwrap();let before=selected(&state,5.);
    state.observe_frame(&active,2,5.).unwrap();assert_eq!(selected(&state,5.),before);
    let mut hidden=active.clone();hidden.players.clear();state.observe_frame(&hidden,3,5.).unwrap();
    assert!(state.sustained(1,5.).is_none());state.observe_frame(&active,4,5.).unwrap();
    assert_eq!(selected(&state,5.),before);
    let mut cleared=active.clone();cleared.players[0].effects.courage_until=0;
    state.observe_frame(&cleared,5,5.).unwrap();state.observe_frame(&active,6,5.).unwrap();
    assert!(state.sustained(1,5.).is_none());
    hidden.roster.clear();state.observe_frame(&hidden,7,5.).unwrap();assert!(state.anchors.is_empty());
}
#[test]
fn same_session_epoch_preserves_courage_anchor_and_rejects_replayed_frames() {
    let mut state=state();state.begin_epoch(7,1).unwrap();let active=snapshot(11,10,160);
    state.observe_frame(&active,9,5.).unwrap();let before=selected(&state,5.25);
    state.begin_epoch(7,2).unwrap();state.observe_frame(&active,1,5.25).unwrap();
    assert_eq!(selected(&state,5.25),before);
    let saved=state.clone();assert!(!state.begin_epoch(7,2).unwrap());assert!(!state.begin_epoch(7,1).unwrap());
    let mut cleared=active.clone();cleared.players[0].effects.courage_until=0;
    assert!(!state.observe_frame(&cleared,1,6.).unwrap());assert_eq!(state,saved);
    cleared.tick=10;assert!(!state.observe_frame(&cleared,2,6.).unwrap());assert_eq!(state,saved);
    assert!(state.observe_frame(&active,0,5.).is_err());assert!(state.begin_epoch(7,0).is_err());assert_eq!(state,saved);
    let mut bad=active.clone();bad.players[0].cooldown_totals[1]=None;
    assert!(state.observe_frame(&bad,2,5.25).is_err());assert_eq!(state,saved);
    state.observe_frame(&active,2,5.25).unwrap();assert_eq!(selected(&state,5.25),before);
    state.reset(8);state.begin_epoch(8,1).unwrap();let mut fresh=snapshot(1,0,150);fresh.session=8;
    state.observe_frame(&fresh,1,5.25).unwrap();assert_eq!(selected(&state,5.25).identity.session,8);
}
