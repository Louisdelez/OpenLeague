//! Controlled snapshots only. These tests do not run the server AI or a GUI.
use super::*;
use openleague_core::{attack_presentation::{Audience, CancelReason, State as Facts}, Navigation, Simulation};

pub(crate) const SOURCE: u32 = 900;
pub(crate) fn all() -> Audience { Audience::from_visibility(true, true) }
pub(crate) fn facts() -> Facts { Facts::new(vilemaw_attacks::limits()) }
pub(crate) fn snapshot(tick: u64, facts: &Facts, active: Option<Attack>) -> Snapshot {
    let mut cells = Vec::new();
    for _ in 0..16 { cells.extend(0f32.to_le_bytes()); cells.extend(0u16.to_le_bytes()); cells.extend(0u32.to_le_bytes()); cells.push(1); }
    let nav = Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":4,"height":4}"#, &cells).unwrap();
    let mut game = Simulation::new(nav).unwrap(); game.session = 7; game.join("garen").unwrap();
    let mut snapshot = game.snapshot(); snapshot.tick = tick;
    snapshot.units.push(serde_json::from_value(serde_json::json!({
        "id":SOURCE,"name":"controlled boss","definition":"TT_Spiderboss","kind":"Boss","team":2,
        "position":{"x":75.,"z":75.},"height":0.,"facing":1.5707964,
        "health":4000.,"max_health":4000.,"damage":100.,"armor":20.,"magic_resist":0.,
        "gold":150.,"experience":0.,"target":1,"destination":null,"next_attack":56,
        "silence_until":0,"respawn_at":null,"attack_presentation":active
    })).unwrap());
    snapshot.vilemaw_attack_events = facts.events(); snapshot
}
fn state(facts: &Facts) -> State {
    let mut state = State::default(); state.reset(7); state.observe(&snapshot(0, facts, None), 0.).unwrap(); state
}
fn selected(state: &State, now: f64) -> Selection { state.selection(SOURCE, now, Some(55. / 30.)).unwrap() }
fn hidden(mut snapshot: Snapshot) -> Snapshot {
    snapshot.units.clear(); snapshot.vilemaw_attack_events.clear(); snapshot
}

#[test]
fn basic_uses_clip_past_twelve_ticks_resolution_preserves_age_and_next_id_replaces() {
    let mut facts = facts(); let mut state = state(&facts);
    let first = facts.begin(SOURCE, 10, 40, Kind::Basic, all()).unwrap();
    state.observe(&snapshot(31, &facts, Some(first)), 0.7).unwrap();
    assert_eq!(selected(&state, 0.7).kind, Kind::Basic);
    assert!((selected(&state, 0.7).age_seconds - 0.7).abs() < 0.00001);
    facts.resolve(first, 40, Kind::Basic, true, all()).unwrap();
    state.observe(&snapshot(40, &facts, None), 1.).unwrap();
    assert_eq!(selected(&state, 1.).attack, first.id);
    assert!((selected(&state, 1.).age_seconds - 1.).abs() < 0.00001);
    let next = facts.begin(SOURCE, 56, 86, Kind::Basic, all()).unwrap();
    state.observe(&snapshot(57, &facts, Some(next)), 1.57).unwrap();
    assert_eq!(selected(&state, 1.57).attack, next.id);
    assert!((selected(&state, 1.57).age_seconds - 1. / 30.).abs() < 0.00001);
}

#[test]
fn no_duration_fallback_or_rejuvenation_and_new_identity_is_not_prematurely_expired() {
    let mut facts = facts(); let mut state = state(&facts);
    let first = facts.begin(SOURCE, 10, 40, Kind::Basic, all()).unwrap();
    state.observe(&snapshot(11, &facts, Some(first)), 1.).unwrap();
    for duration in [None, Some(0.), Some(-1.), Some(f32::NAN), Some(f32::INFINITY)] {
        assert!(state.selection(SOURCE, 1., duration).is_none());
    }
    assert!(state.selection(SOURCE, 11., Some(55. / 30.)).is_none());
    state.observe(&snapshot(12, &facts, Some(first)), 11.).unwrap();
    assert!(state.selection(SOURCE, 11., Some(55. / 30.)).is_none());
    facts.resolve(first, 40, Kind::Basic, true, all()).unwrap();
    state.observe(&snapshot(40, &facts, None), 11.).unwrap();
    assert!(state.selection(SOURCE, 11., Some(55. / 30.)).is_none());
    let next = facts.begin(SOURCE, 56, 86, Kind::Basic, all()).unwrap();
    state.observe(&snapshot(57, &facts, Some(next)), 11.1).unwrap();
    assert_eq!(selected(&state, 11.1).attack, next.id);
    assert!((selected(&state, 11.1).age_seconds - 1. / 30.).abs() < 0.00001);
}

#[test]
fn fog_within_a_receive_batch_removes_output_but_active_return_keeps_age() {
    let mut facts = facts(); let mut state = state(&facts);
    let attack = facts.begin(SOURCE, 10, 40, Kind::Basic, all()).unwrap();
    state.observe(&snapshot(11, &facts, Some(attack)), 0.).unwrap();
    state.observe(&hidden(snapshot(12, &facts, None)), 0.1).unwrap();
    assert!(state.selection(SOURCE, 0.1, Some(2.)).is_none());
    state.observe(&snapshot(20, &facts, Some(attack)), 0.5).unwrap();
    assert!(selected(&state, 0.5).age_seconds > 0.5);
    state.observe(&hidden(snapshot(21, &facts, None)), 0.5).unwrap();
    facts.resolve(attack, 40, Kind::Basic, true, all()).unwrap();
    state.observe(&snapshot(40, &facts, None), 1.).unwrap();
    assert!(state.selection(SOURCE, 1., Some(2.)).is_none(), "terminal history after fog is not a new attack");
}

#[test]
fn expired_identity_does_not_restart_after_delayed_fog_return() {
    let mut facts = facts(); let mut state = state(&facts);
    let attack = facts.begin(SOURCE, 10, 40, Kind::Basic, all()).unwrap();
    state.observe(&snapshot(11, &facts, Some(attack)), 0.).unwrap();
    state.observe(&hidden(snapshot(12, &facts, None)), 3.).unwrap();
    state.observe(&snapshot(13, &facts, Some(attack)), 3.).unwrap();
    assert!(state.selection(SOURCE, 3., Some(55. / 30.)).is_none());
}

#[test]
fn missing_active_identity_and_real_interruptions_do_not_resume_the_same_attack() {
    for block in 0..4 {
        let mut facts = facts(); let mut state = state(&facts);
        let attack = facts.begin(SOURCE, 10, 40, Kind::Basic, all()).unwrap();
        state.observe(&snapshot(11, &facts, Some(attack)), 0.).unwrap();
        let mut blocked = snapshot(12, &facts, Some(attack));
        match block {
            0 => { blocked.units[0].health = 0.; blocked.units[0].attack_presentation = None; }
            1 => blocked.units[0].stuns.push(openleague_core::stuns::Stun { tag:"controlled test only".into(), source:None, expires_at:13 }),
            2 => blocked.units[0].destination = Some(openleague_core::Point { x:100., z:75. }),
            _ => blocked.units[0].attack_presentation = None,
        }
        state.observe(&blocked, 0.1).unwrap();
        assert!(state.selection(SOURCE, 0.1, Some(2.)).is_none());
        state.observe(&snapshot(13, &facts, Some(attack)), 0.2).unwrap();
        assert!(state.selection(SOURCE, 0.2, Some(2.)).is_none());
    }
    // This injects a Stun in a snapshot; it does not claim the public Boss stun API admits it.
}

#[test]
fn cancellation_and_finished_match_clear_until_new_session() {
    let mut facts = facts(); let mut state = state(&facts);
    let attack = facts.begin(SOURCE, 10, 40, Kind::Basic, all()).unwrap();
    state.observe(&snapshot(11, &facts, Some(attack)), 0.).unwrap();
    facts.cancel(attack, 12, CancelReason::Death, all()).unwrap();
    state.observe(&snapshot(12, &facts, None), 0.1).unwrap();
    assert!(state.selection(SOURCE, 0.1, Some(2.)).is_none());
    let next = facts.begin(SOURCE, 56, 86, Kind::Basic, all()).unwrap();
    let mut ended = snapshot(57, &facts, Some(next)); ended.winner = Some(0);
    state.observe(&ended, 1.5).unwrap(); state.observe(&snapshot(58, &facts, Some(next)), 1.6).unwrap();
    assert!(state.selection(SOURCE, 1.6, Some(2.)).is_none());
    state.reset(8); let mut fresh = snapshot(58, &facts, Some(next)); fresh.session = 8;
    state.observe(&fresh, 0.).unwrap(); assert_eq!(selected(&state, 0.).attack, next.id);
}

#[test]
fn respawn_source_replaces_the_single_anchor_and_keeps_global_attack_identity() {
    let mut facts = facts(); let mut state = state(&facts);
    let old = facts.begin(SOURCE, 10, 40, Kind::Basic, all()).unwrap();
    state.observe(&snapshot(11, &facts, Some(old)), 0.).unwrap();
    facts.cancel(old, 12, CancelReason::Death, all()).unwrap();
    state.observe(&snapshot(12, &facts, None), 0.1).unwrap();
    state.observe(&hidden(snapshot(13, &facts, None)), 10.).unwrap();
    let fresh = facts.begin(SOURCE + 1, 100, 130, Kind::Basic, all()).unwrap();
    let mut respawn = snapshot(101, &facts, Some(fresh)); respawn.units[0].id = SOURCE + 1;
    respawn.vilemaw_attack_events.retain(|event| event.attack.source == SOURCE + 1);
    state.observe(&respawn, 11.).unwrap();
    assert!(state.selection(SOURCE, 11., Some(2.)).is_none());
    let selected = state.selection(SOURCE + 1, 11., Some(2.)).unwrap();
    assert_eq!(selected.attack, fresh.id); assert!((selected.age_seconds - 1. / 30.).abs() < 0.00001);
    assert_eq!(state.anchor.unwrap().attack, fresh);
}

#[test]
fn same_tick_frames_epoch_resume_and_explicit_clock_pause_do_not_restart() {
    let mut facts = facts(); let mut state = State::default(); state.reset(7); state.begin_epoch(7, 1).unwrap();
    state.observe_frame(&snapshot(0, &facts, None), 1, 5.).unwrap();
    let attack = facts.begin(SOURCE, 10, 40, Kind::Basic, all()).unwrap();
    let active = snapshot(40, &facts, Some(attack));
    state.observe_frame(&active, 2, 5.).unwrap(); let initial = selected(&state, 5.);
    assert_eq!(initial.age_seconds, 1.);
    facts.resolve(attack, 40, Kind::Basic, true, all()).unwrap(); let resolved = snapshot(40, &facts, None);
    state.observe_frame(&resolved, 3, 5.).unwrap(); assert_eq!(selected(&state, 5.), initial);
    let saved = state.clone(); assert!(!state.observe_frame(&active, 2, 5.).unwrap()); assert_eq!(state, saved);
    assert!(state.begin_epoch(7, 2).unwrap()); state.observe_frame(&resolved, 1, 5.).unwrap();
    assert_eq!(selected(&state, 5.), initial); assert!(!state.begin_epoch(7, 1).unwrap());
    assert!(!state.observe_frame(&active, 1, 5.).unwrap());
    assert!((selected(&state, 5.2).age_seconds - 1.2).abs() < 0.00001);
}

#[test]
fn live_start_and_resolution_together_seek_old_age_but_first_observer_ignores_history() {
    let mut facts = facts(); let mut state = state(&facts);
    let attack = facts.begin(SOURCE, 10, 40, Kind::Basic, all()).unwrap(); facts.resolve(attack, 40, Kind::Basic, false, all()).unwrap();
    state.observe(&snapshot(41, &facts, None), 0.).unwrap();
    assert_eq!(selected(&state, 0.).attack, attack.id); assert!((selected(&state, 0.).age_seconds - 31. / 30.).abs() < 0.00001);
    let mut late = State::default(); late.reset(7); late.observe(&snapshot(41, &facts, None), 0.).unwrap();
    assert!(late.selection(SOURCE, 0., Some(2.)).is_none());
}

#[test]
fn malformed_fact_is_transactional_and_server_diagnostic_is_sticky_without_blocking_game_state() {
    let mut facts = facts(); let mut state = state(&facts);
    let attack = facts.begin(SOURCE, 10, 40, Kind::Basic, all()).unwrap();
    let mut bad = snapshot(11, &facts, Some(attack)); bad.vilemaw_attack_events[0].phase = Phase::Started { kind:Kind::GarenQ };
    let saved = state.clone(); assert!(state.observe(&bad, 0.).is_err()); assert_eq!(state, saved);
    let mut failed = snapshot(11, &facts, Some(attack)); failed.vilemaw_attack_presentation_error = Some("controlled capacity diagnostic".into());
    assert!(state.observe(&failed, 0.).unwrap()); assert!(state.error().is_some());
    assert!(state.observe(&snapshot(12, &facts, Some(attack)), 0.1).unwrap());
    assert!(state.selection(SOURCE, 0.1, Some(2.)).is_none());
    state.reset(7); assert!(state.error().is_none());
    assert!(state.observe(&snapshot(12, &facts, Some(attack)), 0.).unwrap()); assert!(selected(&state, 0.).age_seconds > 0.);
}
