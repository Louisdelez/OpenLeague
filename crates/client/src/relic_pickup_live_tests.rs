//! Local host transaction/lifecycle checks using native pickup profiles and force
//! consumers. Accepted snapshot events and ECS model readiness are controlled
//! fixtures; these tests do not qualify the historical trigger or GPU rendering.
use super::*;
use serde_json::{json, Value};
use std::{net::UdpSocket, time::Instant};

fn initialized() -> Live {
    Live {
        rng: Rng55::seeded(0x12345678),
        initialized: true,
        error: None,
        ..Live::default()
    }
}

/// A ready legacy local connection is an explicit test policy. No network packet
/// is sent, and this does not assert authenticated transport/native trigger parity.
fn fixture(request_count: usize, ready: bool) -> (World, Vec<Entity>, Vec<events::Key>) {
    let mut cells = Vec::new();
    for _ in 0..16 {
        cells.extend(0f32.to_le_bytes());
        cells.extend(0u16.to_le_bytes());
        cells.extend(0u32.to_le_bytes());
        cells.push(1);
    }
    let navigation = openleague_core::Navigation::load(
        r#"{"min":[0,0,0],"cellSize":50,"width":4,"height":4}"#,
        &cells,
    ).unwrap();
    let mut sim = openleague_core::Simulation::new(navigation).unwrap();
    sim.session = 7;
    let ids = (0..request_count).map(|_| sim.join("garen").unwrap()).collect::<Vec<_>>();
    let mut snapshot = sim.snapshot();
    snapshot.tick = 100;
    snapshot.map10 = Some(openleague_core::interactions::MapState {
        nexus_crystal: Default::default(), altars: vec![], revealed_by_altar: vec![],
        relic_visible: true, relic_position: openleague_core::Point { x: 50., z: 50. },
        relic_height: 0., relic_available: false, relic_ready_tick: 1000,
        relic_last_picker: None, relic_pickup_tick: None,
    });
    let mut world = World::new();
    let mut state = crate::Match { snapshot: Some(snapshot), ..Default::default() };
    let mut roots = Vec::new();
    for &id in &ids {
        let root = world.spawn((crate::actor_fow::Root,
            GlobalTransform::from(Transform::from_xyz(3. + id as f32, 4., 5.)
                .with_scale(Vec3::splat(0.05))))).id();
        if ready {
            world.entity_mut(root).insert(crate::animation::material_test_playback(id, Handle::default()));
        }
        state.visuals.insert(id, root);
        roots.push(root);
    }
    world.insert_resource(state);
    world.insert_resource(crate::Connection {
        socket: UdpSocket::bind("127.0.0.1:0").unwrap(),
        link: crate::session_connection::Link::legacy(), id: ids.first().copied(),
        session: Some(7), sequence: 0, last_join: Instant::now(), champion: "garen".into(),
        summoners: [None, None], rejection: String::new(), assembler: Default::default(),
        welcome_history: Default::default(),
    });
    // Baseline first, then actual event adapter creates each new accepted request.
    events::synchronize(&mut world);
    let mut keys = Vec::new();
    for (index, &picker) in ids.iter().enumerate() {
        let tick = 101 + index as u64;
        let key = events::Key { session: 7, pickup_tick: tick, picker };
        {
            let mut state = world.resource_mut::<crate::Match>();
            let snapshot = state.snapshot.as_mut().unwrap();
            snapshot.tick = tick;
            let map = snapshot.map10.as_mut().unwrap();
            map.relic_pickup_tick = Some(tick);
            map.relic_last_picker = Some(picker);
        }
        events::synchronize(&mut world);
        keys.push(key);
    }
    assert_eq!(world.resource::<events::Host>().requests.len(), request_count);
    (world, roots, keys)
}

/// Capture every mutable native array/owner field, including retained retired
/// slots. Equal active counts alone would miss partial updates and RNG leakage.
fn state_words(live: &Live) -> Value {
    let effects = live.effects.iter().map(|(key, effect)| {
        let hosts = effect.hosts.iter().map(|host| {
            let state = &host.state;
            let storage = state.particles.as_ref().map(|p| json!({
                "last_time": p.last_time, "life": p.life, "ages": p.ages, "active": p.active,
                "positions": p.positions, "velocities": p.velocities, "scales": p.scales,
                "factors": p.factors, "scalar": p.scalar, "rates": p.rates,
                "auxiliary": p.auxiliary, "attribute_a": p.attribute_a, "attribute_b": p.attribute_b,
                "previous_heights": p.previous_heights, "bounds": format!("{:?}", p.bounds), "counter": p.counter,
            }));
            json!({ "ordinal": host.ordinal, "time": host.time.to_bits(), "storage": storage,
                "resource": state.frame.particles, "helper": format!("{:?}", state.frame.helper),
                "animation": format!("{:?}", state.frame.animation), "tail": format!("{:?}", state.frame.tail),
                "current": state.pose.current, "previous": state.pose.previous,
                "inverse": state.pose.initial_inverse, "birth": state.birth,
                "emission": format!("{:?}", state.emission),
            })
        }).collect::<Vec<_>>();
        let profiles = effect.profiles.iter().map(|p| format!("{:?}", (
            &p.parameters.rate, &p.parameters.life, &p.parameters.quad_rotation,
            &p.parameters.size, &p.parameters.angular_velocity, &p.parameters.size_over_life,
            &p.parameters.offset, &p.parameters.velocity,
        ))).collect::<Vec<_>>();
        json!({ "key": [key.session, key.pickup_tick, u64::from(key.picker)],
            "start": effect.started.to_bits(), "owner": format!("{:?}", effect.owner),
            "profiles": profiles, "forces": format!("{:?}", effect.forces), "hosts": hosts })
    }).collect::<Vec<_>>();
    json!({ "ordinal": live.ordinal, "rng_words": live.rng.words.to_vec(),
        "rng_cursors": [live.rng.first, live.rng.second], "effects": effects,
        "clock": live.last_clock.map(f64::to_bits), "initialized": live.initialized, "error": live.error })
}

#[test]
fn fourth_group_of_later_request_failure_preserves_every_state_and_rng() {
    let (mut world, _, keys) = fixture(2, true);
    let mut requests = world.remove_resource::<events::Host>().unwrap();
    let mut live = initialized();
    live.commit(live.planned(&requests, 10.).unwrap(), &mut requests).unwrap();
    let healthy = live.planned(&requests, 10.1).unwrap();
    assert_eq!(healthy.groups().count(), 8);
    for key in &keys {
        for index in 0..4 {
            assert!(healthy.next.effects[key].hosts[index].state.emission.counter
                > live.effects[key].hosts[index].state.emission.counter);
        }
    }
    assert_ne!(healthy.next.rng.words, live.rng.words);
    // Only the last request's last native xscale source is damaged. Earlier
    // requests/groups really advance in the healthy control plan above.
    live.effects.get_mut(keys.last().unwrap()).unwrap().profiles[3]
        .parameters.size_over_life.table.clear();
    let before = state_words(&live);
    let requests_before = request_tokens(&requests);
    assert!(live.planned(&requests, 10.1).is_err());
    assert_eq!(state_words(&live), before);
    assert_eq!(request_tokens(&requests), requests_before);
    assert!(requests.retired.is_empty());
}

#[test]
fn all_native_group_lifetimes_finish_before_atomic_request_completion() {
    let (mut world, _, keys) = fixture(1, true);
    let key = keys[0];
    let mut requests = world.remove_resource::<events::Host>().unwrap();
    let mut live = initialized();
    live.commit(live.planned(&requests, 10.).unwrap(), &mut requests).unwrap();
    let mut completed = false;
    for frame in 1..=120 {
        let before = state_words(&live);
        let plan = live.planned(&requests, f64::from(10f32 + frame as f32 * 0.05)).unwrap();
        assert_eq!(state_words(&live), before, "preparation changed live state");
        assert!(requests.requests.contains_key(&key), "request completed before publication");
        if !plan.completed.is_empty() {
            assert_eq!(plan.completed, vec![key]);
            assert_eq!(plan.retired, vec![key]);
            assert_eq!(plan.groups().count(), 0);
            assert!(live.effects.contains_key(&key));
            live.commit(plan, &mut requests).unwrap();
            assert!(live.effects.is_empty());
            assert!(!requests.requests.contains_key(&key));
            assert_eq!(requests.retired.last().unwrap().reason, "completed");
            completed = true;
            break;
        }
        live.commit(plan, &mut requests).unwrap();
    }
    assert!(completed, "qualified finite pickup lifetimes failed to drain");
}

#[test]
fn owner_loss_and_new_session_retire_state_without_completing_or_replaying() {
    for session_change in [false, true] {
        let (mut world, roots, keys) = fixture(1, true);
        let key = keys[0];
        let mut live = initialized();
        {
            let mut requests = world.remove_resource::<events::Host>().unwrap();
            live.commit(live.planned(&requests, 10.).unwrap(), &mut requests).unwrap();
            world.insert_resource(requests);
        }
        if session_change {
            world.resource_mut::<crate::Connection>().session = Some(8);
            world.resource_mut::<crate::Match>().snapshot.as_mut().unwrap().session = 8;
        } else {
            world.despawn(roots[0]);
        }
        events::synchronize(&mut world);
        let mut requests = world.remove_resource::<events::Host>().unwrap();
        assert!(requests.requests.is_empty());
        assert!(requests.retired.iter().any(|r| r.key == key && r.reason != "completed"));
        let before = state_words(&live);
        let plan = live.planned(&requests, 10.1).unwrap();
        assert_eq!(state_words(&live), before);
        assert_eq!(plan.retired, vec![key]);
        assert!(plan.completed.is_empty());
        assert_eq!(plan.groups().count(), 0);
        live.commit(plan, &mut requests).unwrap();
        assert!(live.effects.is_empty());
        world.insert_resource(requests);
        events::synchronize(&mut world);
        assert!(world.resource::<events::Host>().requests.is_empty(), "lost owner/history was replayed");
    }
}

#[test]
fn delayed_model_pose_waits_without_births_or_rng_then_starts_from_real_pose() {
    let (mut world, roots, keys) = fixture(1, false);
    let key = keys[0];
    let mut requests = world.remove_resource::<events::Host>().unwrap();
    assert!(requests.requests[&key].owner.is_none());
    let mut live = initialized();
    let words = live.rng.words;
    let cursors = (live.rng.first, live.rng.second);
    let waiting = live.planned(&requests, 10.).unwrap();
    assert_eq!(waiting.groups().count(), 0);
    assert!(waiting.completed.is_empty());
    live.commit(waiting, &mut requests).unwrap();
    assert!(live.effects.is_empty());
    assert_eq!(live.rng.words, words);
    assert_eq!((live.rng.first, live.rng.second), cursors);
    assert!(requests.requests.contains_key(&key));
    world.insert_resource(requests);
    world.entity_mut(roots[0]).insert(crate::animation::material_test_playback(key.picker, Handle::default()));
    events::synchronize(&mut world);
    let mut requests = world.remove_resource::<events::Host>().unwrap();
    let actual_pose = requests.requests[&key].owner.unwrap();
    let ready = live.planned(&requests, 11.).unwrap();
    assert_eq!(ready.groups().count(), 4);
    assert_eq!(ready.next.effects[&key].started, 11.);
    for group in ready.groups() {
        assert_eq!(group.owner.binding, actual_pose.binding);
        assert_eq!(group.owner.native_position, actual_pose.native_position);
        assert_eq!(group.host.state.birth, vec![11f32.to_bits()]);
        assert_eq!(group.host.state.pose.current[12..15], actual_pose.native_position);
    }
    live.commit(ready, &mut requests).unwrap();
    assert!(live.planned(&requests, 10.9).is_err(), "regressed canonical clock was accepted");
}

#[test]
fn stale_rng_ordinal_or_owner_frame_rejects_commit_without_side_effects() {
    for changed in 0..3 {
        let (mut world, _, keys) = fixture(1, true);
        let mut requests = world.remove_resource::<events::Host>().unwrap();
        let mut live = initialized();
        let plan = live.planned(&requests, 10.).unwrap();
        plan.validate(&live, &requests).unwrap();
        match changed {
            0 => { live.rng.fraction(); }
            1 => { live.ordinal += 1; }
            _ => {
                let owner = requests.requests.get_mut(&keys[0]).unwrap().owner.as_mut().unwrap();
                owner.native_position[0] = (f32::from_bits(owner.native_position[0]) + 1.).to_bits();
            }
        }
        let before = state_words(&live);
        let requests_before = request_tokens(&requests);
        assert!(plan.validate(&live, &requests).is_err());
        assert!(live.commit(plan, &mut requests).is_err());
        assert_eq!(state_words(&live), before);
        assert_eq!(request_tokens(&requests), requests_before);
        assert!(requests.retired.is_empty());
    }
}
