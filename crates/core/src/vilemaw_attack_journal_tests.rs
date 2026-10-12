use super::*;
use attack::{Audience, CancelReason, Delivery, Kind, Phase};

fn unit(source: u32, active: Option<attack::Attack>) -> world::Unit {
    serde_json::from_value(serde_json::json!({
        "id":source,"name":"boss_fixture","definition":DEFINITION,"kind":"Boss","team":2,
        "position":{"x":200.0,"z":100.0},"height":0.0,"facing":0.0,
        "health":3200.0,"max_health":3200.0,"damage":100.0,"armor":75.0,"magic_resist":45.0,
        "gold":25.0,"experience":400.0,"target":null,"destination":null,
        "next_attack":0,"silence_until":0,"respawn_at":null,"attack_presentation":active
    })).unwrap()
}
fn snapshot(tick: u64, facts: &attack::State, source: u32, active: Option<attack::Attack>) -> Snapshot {
    serde_json::from_value(serde_json::json!({
        "session":830,"tick":tick,"roster":[],"players":[],"units":[unit(source,active)],
        "winner":null,"map10":null,"vilemaw_attack_events":facts.events()
    })).unwrap()
}
fn audience() -> Audience { Audience::from_visibility(true, true) }
fn new_journal() -> Journal { let mut journal = Journal::default(); journal.reset(830); journal }

#[test]
fn vilemaw_journal_delivers_between_snapshot_start_and_resolution_only_once() {
    let mut facts = attack::State::new(limits()); let mut journal = new_journal();
    journal.accept(&snapshot(9, &facts, 10, None)).unwrap();
    let action = facts.begin(10, 10, 40, Kind::Basic, audience()).unwrap();
    facts.resolve(action, 40, Kind::Basic, true, audience()).unwrap();
    assert!(journal.accept(&snapshot(40, &facts, 10, None)).unwrap());
    let observed = journal.drain(); assert_eq!(observed.len(), 2);
    assert!(observed.iter().all(|item| item.delivery == Delivery::Live && item.event.attack == action));
    assert!(!journal.accept(&snapshot(40, &facts, 10, None)).unwrap());
    journal.accept(&snapshot(41, &facts, 10, None)).unwrap(); assert!(journal.drain().is_empty());
    let mut fresh = new_journal();
    fresh.accept(&snapshot(41, &facts, 10, None)).unwrap(); assert!(fresh.drain().is_empty());
}

#[test]
fn vilemaw_journal_same_tick_frames_epoch_rebind_and_backward_ticks_keep_facts() {
    let mut facts = attack::State::new(limits()); let mut journal = new_journal();
    journal.begin_epoch(830, 1).unwrap();
    journal.accept_frame(&snapshot(10, &facts, 10, None), 1).unwrap();
    let action = facts.begin(10, 10, 10, Kind::Basic, audience()).unwrap(); // Explicit zero-windup transport fixture.
    journal.accept_frame(&snapshot(10, &facts, 10, Some(action)), 2).unwrap();
    assert_eq!(journal.drain().len(), 1);
    facts.resolve(action, 10, Kind::Basic, true, audience()).unwrap();
    journal.accept_frame(&snapshot(10, &facts, 10, None), 3).unwrap();
    assert!(matches!(journal.drain()[0].event.phase, Phase::Resolved { .. }));
    let before = journal.clone();
    assert!(!journal.accept_frame(&snapshot(10, &facts, 10, None), 3).unwrap()); assert_eq!(journal, before);
    assert!(!journal.accept_frame(&snapshot(9, &facts, 10, None), 4).unwrap()); assert_eq!(journal, before);
    assert!(journal.begin_epoch(830, 2).unwrap());
    journal.accept_frame(&snapshot(10, &facts, 10, None), 1).unwrap(); assert!(journal.drain().is_empty());
    assert!(!journal.begin_epoch(830, 1).unwrap());
    journal.reset(831);
    assert!(matches!(journal.accept(&snapshot(10, &facts, 10, None)), Err(Error::Protocol(attack::Error::SessionMismatch))));
}

#[test]
fn vilemaw_journal_fog_purges_queue_and_returns_only_the_active_identity() {
    let mut facts = attack::State::new(limits()); let mut journal = new_journal();
    let action = facts.begin(10, 10, 40, Kind::Basic, audience()).unwrap();
    journal.accept(&snapshot(10, &facts, 10, Some(action))).unwrap(); assert_eq!(journal.pending_len(), 1);
    let mut hidden = snapshot(11, &facts, 10, None); hidden.units.clear(); hidden.vilemaw_attack_events.clear();
    journal.accept(&hidden).unwrap(); assert!(journal.drain().is_empty());
    journal.accept(&snapshot(12, &facts, 10, Some(action))).unwrap();
    let resumed = journal.drain(); assert_eq!(resumed.len(), 1); assert_eq!(resumed[0].delivery, Delivery::ResumeActive);
    hidden.tick = 13; journal.accept(&hidden).unwrap();
    facts.resolve(action, 40, Kind::Basic, true, audience()).unwrap();
    journal.accept(&snapshot(40, &facts, 10, None)).unwrap(); assert!(journal.drain().is_empty());
}

#[test]
fn vilemaw_journal_rejects_nonbasic_foreign_profile_and_missing_started_transactionally() {
    let mut facts = attack::State::new(limits()); let mut journal = new_journal();
    journal.accept(&snapshot(9, &facts, 10, None)).unwrap();
    let action = facts.begin(10, 10, 40, Kind::Basic, audience()).unwrap();
    let good = snapshot(10, &facts, 10, Some(action)); let before = journal.clone();
    let mut invalid = good.clone(); invalid.vilemaw_attack_events[0].phase = Phase::Started { kind: Kind::GarenQ };
    assert_eq!(journal.accept(&invalid), Err(Error::NonBasic)); assert_eq!(journal, before);
    let mut invalid = good.clone(); invalid.units[0].definition = "annietibbers".into();
    assert!(journal.accept(&invalid).is_err()); assert_eq!(journal, before);
    let mut invalid = good.clone(); invalid.vilemaw_attack_events.clear();
    assert_eq!(journal.accept(&invalid), Err(Error::InvalidActiveAttack)); assert_eq!(journal, before);
    let mut invalid = good.clone(); invalid.units[0].attack_presentation.as_mut().unwrap().source = 11;
    assert_eq!(journal.accept(&invalid), Err(Error::InvalidActiveAttack)); assert_eq!(journal, before);
    assert!(journal.accept(&good).unwrap()); assert_eq!(journal.drain().len(), 1);
}

#[test]
fn vilemaw_journal_same_tick_disappearance_and_cancellation_never_reemit_start() {
    let mut facts = attack::State::new(limits()); let mut journal = new_journal(); journal.begin_epoch(830, 1).unwrap();
    journal.accept_frame(&snapshot(9, &facts, 10, None), 1).unwrap();
    let action = facts.begin(10, 10, 40, Kind::Basic, audience()).unwrap();
    journal.accept_frame(&snapshot(10, &facts, 10, Some(action)), 2).unwrap(); journal.drain();
    facts.cancel(action, 10, CancelReason::Death, audience()).unwrap();
    let mut dead = snapshot(10, &facts, 10, None); dead.units[0].health = 0.;
    journal.accept_frame(&dead, 3).unwrap();
    let terminal = journal.drain(); assert_eq!(terminal.len(), 1); assert!(matches!(terminal[0].event.phase, Phase::Cancelled { .. }));
    let mut hidden = dead.clone(); hidden.units.clear(); hidden.vilemaw_attack_events.clear();
    journal.accept_frame(&hidden, 4).unwrap(); journal.accept_frame(&dead, 5).unwrap();
    assert!(journal.drain().is_empty());
}

#[test]
fn vilemaw_journal_server_diagnostic_accepts_gameplay_and_retires_only_presentation() {
    let mut facts = attack::State::new(limits()); let mut journal = new_journal(); journal.begin_epoch(830, 1).unwrap();
    let action = facts.begin(10, 10, 40, Kind::Basic, audience()).unwrap();
    journal.accept_frame(&snapshot(10, &facts, 10, Some(action)), 1).unwrap();
    let mut failure = snapshot(10, &facts, 10, None);
    failure.units.push(unit(11, None)); // The real diagnostic path must not reject combat for >capacity.
    failure.vilemaw_attack_presentation_error = Some("fixture ActiveLimit".into());
    assert!(journal.accept_frame(&failure, 2).unwrap()); assert!(journal.unavailable()); assert!(journal.drain().is_empty());
    journal.begin_epoch(830, 2).unwrap();
    journal.accept_frame(&snapshot(10, &facts, 10, Some(action)), 1).unwrap();
    assert!(journal.unavailable()); assert!(journal.drain().is_empty());
    journal.reset(831); assert!(!journal.unavailable());
    let mut new_session = snapshot(10, &facts, 10, Some(action)); new_session.session = 831;
    journal.accept(&new_session).unwrap(); assert_eq!(journal.drain().len(), 1);
}

#[test]
fn vilemaw_journal_duplicate_frame_diagnostic_cannot_disable_a_valid_channel() {
    let mut facts = attack::State::new(limits()); let mut journal = new_journal(); journal.begin_epoch(830, 1).unwrap();
    let action = facts.begin(10, 10, 40, Kind::Basic, audience()).unwrap();
    let good = snapshot(10, &facts, 10, Some(action)); journal.accept_frame(&good, 1).unwrap(); journal.drain();
    let before = journal.clone(); let mut stale = good;
    stale.vilemaw_attack_presentation_error = Some("stale diagnostic".into());
    assert!(!journal.accept_frame(&stale, 1).unwrap()); assert_eq!(journal, before); assert!(!journal.unavailable());
}

#[test]
fn vilemaw_snapshot_fields_are_backward_compatible_and_journal_capacity_is_separate() {
    let facts = attack::State::new(limits()); let mut json = serde_json::to_value(snapshot(0, &facts, 10, None)).unwrap();
    json.as_object_mut().unwrap().remove("vilemaw_attack_events");
    json.as_object_mut().unwrap().remove("vilemaw_attack_presentation_error");
    json["units"][0].as_object_mut().unwrap().remove("attack_presentation");
    let old: Snapshot = serde_json::from_value(json).unwrap();
    assert!(old.vilemaw_attack_events.is_empty()); assert!(old.vilemaw_attack_presentation_error.is_none());
    assert!(old.units[0].attack_presentation.is_none());
    assert_eq!(Journal::default().limits().active_sources(), 1);
    assert_eq!(attack::Limits::default().active_sources(), 6);
}
