//! Current-height projection tests. Real Map10 data and accepted casts; no native runtime claim.
use super::*;

fn game(enabled: bool) -> (Simulation, u32, u32) {
    let nav = Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),
        include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let mut s = Simulation::new(nav).unwrap(); s.session = u64::MAX - 7;
    s.enable_map10().unwrap(); if enabled { s.enable_map10_cast_ground().unwrap(); }
    s.units.clear();
    let owner = s.join("ezreal").unwrap(); let viewer = s.join("garen").unwrap();
    for id in [owner, viewer] { let p = s.players.get_mut(&id).unwrap(); p.health = 10000.; p.max_health = 10000.; }
    let p = s.players.get_mut(&owner).unwrap(); p.level = 6; p.ranks[3] = 1; p.mana = 2000.;
    s.ezreal_r.session = Some(s.session); s.ezreal_r.next_ordinal = (1u64 << 53) + 3;
    (s, owner, viewer)
}
fn cast(s: &mut Simulation, owner: u32) {
    let origin = s.players[&owner].position;
    s.command(owner, Action::CastAt { slot: 3, point: Point { x: origin.x + 1000., z: origin.z } }).unwrap();
}
fn until(s: &mut Simulation, tick: u64) { while s.tick < tick { s.tick += 1; s.advance_ezreal_r(); } }
fn visible(s: &mut Simulation, viewer: u32) -> VisibleMissile {
    let position = s.ezreal_r.flights[0].shot.view().position;
    s.players.get_mut(&viewer).unwrap().position = position;
    let rows = s.ezreal_r_projection(viewer); assert_eq!(rows.len(), 1); rows[0]
}
fn only_height(snapshot: &Snapshot) -> f32 {
    let raw = snapshot.ezreal_r_current_heights.as_ref().expect("available current height");
    let object = raw.as_object().unwrap(); assert_eq!(object.len(), 2); assert_eq!(raw["policy"], CURRENT_HEIGHT_POLICY);
    let rows = raw["rows"].as_array().unwrap(); assert_eq!(rows.len(), 1);
    let keys: std::collections::BTreeSet<_> = rows[0].as_object().unwrap().keys().map(String::as_str).collect();
    assert_eq!(keys, ["ordinal", "owner", "team", "y_native"].into_iter().collect());
    rows[0]["y_native"].as_f64().unwrap() as f32
}

#[test]
fn current_height_reveals_only_visible_flight_after_hidden_cast_and_preserves_private_state() {
    let (mut s, owner, viewer) = game(true); cast(&mut s, owner);
    assert!(s.snapshot_for_atomic(owner).unwrap().ezreal_r_current_heights.is_none());
    assert!(s.snapshot_for_atomic(viewer).unwrap().ezreal_r_current_heights.is_none());
    until(&mut s, 90); let row = visible(&mut s, viewer);
    assert!(!s.visible_to(1, owner), "fixture must keep caster outside viewer vision");
    let before = format!("{:?}|{:?}", s.ezreal_r, s.players);
    let snapshot = s.snapshot_for_atomic(viewer).unwrap();
    assert!(!snapshot.players.iter().any(|p| p.id == owner)); assert_eq!(snapshot.ezreal_r_projectiles, [row]);
    let expected = s.ezreal_r.flights[0].vertical.as_ref().unwrap()
        .current_y(s.ezreal_r.flights[0].shot.view().identity, s.tick, row.position).unwrap();
    assert_eq!(only_height(&snapshot).to_bits(), expected.to_bits());
    assert_eq!(format!("{:?}|{:?}", s.ezreal_r, s.players), before);
    s.players.get_mut(&viewer).unwrap().position = Point { x: 14321., z: 7235. };
    let hidden = s.snapshot_for_atomic(viewer).unwrap();
    assert!(hidden.ezreal_r_projectiles.is_empty()); assert!(hidden.ezreal_r_current_heights.is_none());
    until(&mut s, 91); let current = visible(&mut s, viewer);
    let revealed = s.snapshot_for_atomic(viewer).unwrap(); assert_eq!(revealed.tick, 91);
    assert_eq!(revealed.ezreal_r_projectiles, [current]); assert!(only_height(&revealed).is_finite());
    assert_ne!(row.position, current.position);
    s.winner = Some(0); assert!(s.snapshot_for_atomic(viewer).unwrap().ezreal_r_current_heights.is_none());
}

#[test]
fn unavailable_or_mismatched_vertical_state_never_falls_back_to_actor_or_old_height() {
    let (mut disabled, owner, _) = game(false); cast(&mut disabled, owner); until(&mut disabled, 30);
    let snapshot = disabled.snapshot_for_atomic(owner).unwrap();
    assert_eq!(snapshot.ezreal_r_projectiles.len(), 1); assert!(snapshot.ezreal_r_current_heights.is_none());
    let (mut s, owner, viewer) = game(true); cast(&mut s, owner); until(&mut s, 30);
    let row = visible(&mut s, viewer); assert!(s.ezreal_r_current_height_projection(viewer, &[row]).is_some());
    for changed in [VisibleMissile { position: Point { x: row.position.x + 1., ..row.position }, ..row },
        VisibleMissile { session: row.session - 1, ..row }, VisibleMissile { ordinal: row.ordinal + 1, ..row },
        VisibleMissile { team: 1, ..row }, VisibleMissile { direction: Point { x: 0., z: 1. }, ..row }] {
        assert!(s.ezreal_r_current_height_projection(viewer, &[changed]).is_none());
    }
    assert!(s.ezreal_r_current_height_projection(viewer, &[row, row]).is_none());
    // Advance only XZ deliberately: current row exists, private Y is still tick30.
    let identity = s.ezreal_r.flights[0].shot.view().identity; s.tick = 31;
    s.ezreal_r.flights[0].shot.advance(identity, 31, &[]).unwrap(); visible(&mut s, viewer);
    let stale = s.snapshot_for_atomic(viewer).unwrap();
    assert_eq!(stale.ezreal_r_projectiles.len(), 1); assert!(stale.ezreal_r_current_heights.is_none());
    assert!(s.players[&owner].height.is_finite());
}

#[test]
fn atomic_height_is_optional_legacy_compatible_and_preserves_full_u64_identity() {
    let (mut s, owner, _) = game(true); cast(&mut s, owner); until(&mut s, 30);
    assert!(s.snapshot().ezreal_r_current_heights.is_none());
    let legacy = s.snapshot_for(owner).unwrap(); assert!(legacy.ezreal_r_current_heights.is_none());
    let legacy_json = serde_json::to_value(&legacy).unwrap(); assert!(legacy_json.get("ezreal_r_current_heights").is_none());
    let decoded: Snapshot = serde_json::from_value(legacy_json).unwrap(); assert!(decoded.ezreal_r_current_heights.is_none());
    let current = s.snapshot_for_atomic(owner).unwrap(); assert!(only_height(&current).is_finite());
    let decoded: Snapshot = serde_json::from_slice(&serde_json::to_vec(&current).unwrap()).unwrap();
    assert_eq!(decoded.session, u64::MAX - 7);
    assert_eq!(decoded.ezreal_r_current_heights.as_ref().unwrap()["rows"][0]["ordinal"].as_u64(), Some((1u64 << 53) + 3));
    assert_eq!(decoded.ezreal_r_projectiles[0].ordinal, (1u64 << 53) + 3);
    // Optional Value accepts an unknown extension without corrupting ordinary gameplay decoding.
    let mut unknown = serde_json::to_value(&legacy).unwrap(); unknown["ezreal_r_current_heights"] = serde_json::json!("future schema");
    let unknown: Snapshot = serde_json::from_value(unknown).unwrap(); assert_eq!(unknown.tick, current.tick);
    assert_eq!(unknown.ezreal_r_projectiles, current.ezreal_r_projectiles);
}

#[test]
fn current_height_budget_is_sixty_four_and_has_no_partial_overflow_publication() {
    let (mut s, owner, _) = game(true); cast(&mut s, owner); until(&mut s, 30);
    let seed = s.ezreal_r.flights[0].cast_ground_seed.clone(); let origin = s.players[&owner].position;
    let aim = Point { x: origin.x + 1000., z: origin.z }; s.ezreal_r.flights.clear();
    for i in 0..=MAX_CASTS {
        let identity = Identity { session: s.session, owner, team: 0, ordinal: (1u64 << 53) + 3 + i as u64 };
        let shot = Shot::new(identity, origin, aim, Params { speed_units_per_second: SPEED,
            tick_rate: TICK_RATE as u32, max_distance: RANGE, projectile_radius: RADIUS,
            launch_tick: 30, expires_at_tick: 331, mode: Mode::Pierce,
            limits: Limits { targets_per_step: MAX_TARGETS, unique_hits: MAX_TARGETS } }).unwrap();
        let vertical = capture_vertical_release(&seed, s.map10_cast_ground, s.players[&owner].height, identity, 30, aim);
        assert!(vertical.is_ok());
        s.ezreal_r.flights.push(Flight { shot, raw: 350., accepted_hits: 0, direction: Point { x: 1., z: 0. },
            cast_ground_seed: seed.clone(), vertical });
        if i == MAX_CASTS - 1 {
            let snapshot = s.snapshot_for_atomic(owner).unwrap(); assert_eq!(snapshot.ezreal_r_projectiles.len(), 64);
            let rows = snapshot.ezreal_r_current_heights.as_ref().unwrap()["rows"].as_array().unwrap();
            assert_eq!(rows.len(), 64); assert_eq!(rows[63]["ordinal"].as_u64(), Some((1u64 << 53) + 66));
        }
    }
    let overflow = s.snapshot_for_atomic(owner).unwrap();
    assert!(overflow.ezreal_r_projectiles.is_empty()); assert!(overflow.ezreal_r_current_heights.is_none());
}
