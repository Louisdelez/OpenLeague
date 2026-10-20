use super::*;
use openleague_core::{damage::DamageKind, death_recap::{Recap, Row}, session_transport as t,
    session_wire, Navigation, Point, Simulation};

fn game() -> (Simulation, u32, u32) {
    let nav = Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),
        include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let mut s = Simulation::new(nav).unwrap(); s.session = (1_u64 << 53) + 13;
    s.enable_map10().unwrap(); s.units.clear();
    let victim = s.join("garen").unwrap(); let attacker = s.join("annie").unwrap();
    s.players.get_mut(&attacker).unwrap().position = s.players[&victim].position;
    (s, victim, attacker)
}
fn identity(s: &Snapshot, victim: u32) -> Option<Identity> { Some((s.session, victim, Some(1))) }
fn kill(s: &mut Simulation, victim: u32, attacker: Option<u32>) {
    assert!(s.apply_damage(attacker, victim, 1_000_000., DamageKind::True).unwrap().lethal);
}
fn transported(snapshot: &Snapshot, victim: u32) -> Snapshot {
    let context = t::Context { session: snapshot.session, player: victim, epoch: 1 };
    let mut sender = session_wire::Sender::new(context).unwrap();
    let mut assembler = session_wire::Assembler::new(context).unwrap();
    let mut received = None;
    for bytes in sender.encode(snapshot, 0).unwrap() {
        if let Some(frame) = assembler.push(&bytes).unwrap() { received = Some(frame.decode().unwrap().snapshot); }
    }
    received.unwrap()
}

#[test]
fn real_damage_through_atomic_transport_displays_actual_hp_and_shield_separately() {
    let (mut s, v, a) = game(); s.tick = 451;
    s.grant_shield(v, "fixture", 100., 1000).unwrap();
    let physical = s.apply_damage(Some(a), v, 20., DamageKind::Physical).unwrap();
    let magical = s.apply_damage(Some(a), v, 200., DamageKind::Magical).unwrap();
    let lethal = s.apply_damage(Some(a), v, 1_000_000., DamageKind::True).unwrap();
    assert!(lethal.lethal); assert!(lethal.health_removed < lethal.post_mitigation);
    let wire = transported(&s.snapshot_for_atomic(v).unwrap(), v);
    let before = serde_json::to_value(&wire).unwrap();
    let p = panel(&wire, identity(&wire, v), true).unwrap();
    assert_eq!(p.rows.len(), 1); let row = &p.rows[0];
    assert_eq!(row.source, "annie"); assert!(row.lethal);
    assert_eq!(row.physical, amount(Amount { health_removed: physical.health_removed, shield_absorbed: physical.shield_absorbed }));
    assert_eq!(row.magical, amount(Amount { health_removed: magical.health_removed, shield_absorbed: magical.shield_absorbed }));
    assert_eq!(row.true_damage, amount(Amount { health_removed: lethal.health_removed, shield_absorbed: lethal.shield_absorbed }));
    assert_eq!(before, serde_json::to_value(&wire).unwrap(), "UI projection is read-only");
    assert!(p.summary.contains("15,0 s")); assert!(!p.summary.contains("1000000"));
}

#[test]
fn hidden_damage_stays_anonymous_after_reveal_and_without_any_attacker_lookup() {
    let (mut s, v, a) = game();
    s.players.get_mut(&a).unwrap().team = 1;
    s.players.get_mut(&a).unwrap().position = Point { x: 100_000., z: 100_000. };
    assert!(!s.visible_to(0, a)); kill(&mut s, v, Some(a));
    let first = transported(&s.snapshot_for_atomic(v).unwrap(), v);
    let expected = panel(&first, identity(&first, v), true).unwrap();
    assert_eq!(expected.rows[0].source, "Source masquée");
    s.players.get_mut(&a).unwrap().team = 0;
    s.players.get_mut(&a).unwrap().champion = "ezreal".into();
    s.tick += death_recap::WINDOW_TICKS + 1; // Persistent dead state, without invoking respawn.
    let mut later = transported(&s.snapshot_for_atomic(v).unwrap(), v);
    assert_eq!(panel(&later, identity(&later, v), true), Some(expected.clone()));
    later.players.retain(|p| p.id == v); later.units.clear();
    assert_eq!(panel(&later, identity(&later, v), true), Some(expected));
}

#[test]
fn unavailable_foreign_legacy_live_ended_and_malformed_views_hide_immediately() {
    let (mut s, v, a) = game(); kill(&mut s, v, Some(a));
    let base = transported(&s.snapshot_for_atomic(v).unwrap(), v);
    for id in [None, Some((base.session, v, None)), Some((base.session, v, Some(0))),
        Some((base.session + 1, v, Some(1))), Some((base.session, a, Some(1)))] {
        assert!(panel(&base, id, true).is_none());
    }
    assert!(panel(&base, identity(&base, v), false).is_none());
    let mut changed = base.clone(); changed.death_recap = None;
    assert!(panel(&changed, identity(&changed, v), true).is_none());
    changed = base.clone(); changed.players.iter_mut().find(|p| p.id == v).unwrap().health = 1.;
    assert!(panel(&changed, identity(&changed, v), true).is_none());
    changed = base.clone(); changed.winner = Some(1);
    assert!(panel(&changed, identity(&changed, v), true).is_none());
    changed = base.clone(); let duplicate = changed.players.iter().find(|p| p.id == v).unwrap().clone(); changed.players.push(duplicate);
    assert!(panel(&changed, identity(&changed, v), true).is_none());
    changed = base.clone(); changed.death_recap.as_mut().unwrap()["rows"][0]["position"] = serde_json::json!([1,2]);
    assert!(panel(&changed, identity(&changed, v), true).is_none());
    assert!(panel(&s.snapshot_for(v).unwrap(), identity(&base, v), true).is_none());
}

#[test]
fn actual_connection_requires_presented_olsr_and_recovers_persistent_death_on_new_epoch() {
    use std::{net::UdpSocket, time::Instant};
    use crate::session_connection::Incoming;
    let (mut s, v, a) = game(); kill(&mut s, v, Some(a));
    let snapshot = s.snapshot_for_atomic(v).unwrap();
    let nonce = t::RequestNonce([17; 16]);
    let client = crate::session_client::Client::new(t::JoinRequest { version: t::VERSION, champion: "garen".into(),
        summoners: [None, None], recovery_key: t::Secret32::from_bytes([18; 32]).unwrap(), request_nonce: nonce }, false, nonce).unwrap();
    let mut connection = crate::Connection { socket: UdpSocket::bind("127.0.0.1:0").unwrap(), link: crate::session_connection::Link::new(Some(client)),
        id: Some(v), session: Some(s.session), sequence: 0, last_join: Instant::now(), champion: "garen".into(),
        summoners: [None, None], rejection: String::new(), assembler: Default::default(), welcome_history: Default::default() };
    let context = t::Context { session: s.session, player: v, epoch: 1 };
    let welcome = t::Welcome { version: t::VERSION, context, request_nonce: nonce,
        access_key: t::Secret32::from_bytes([19; 32]).unwrap(), next_sequence: 1, bootstrap: t::ClockBootstrap::Running };
    assert!(matches!(connection.decode_datagram(&serde_json::to_vec(&t::ServerMessage::SessionWelcome(welcome)).unwrap()).unwrap(), Some(Incoming::Welcome { .. })));
    let mut sender = session_wire::Sender::new(context).unwrap();
    for bytes in sender.encode(&snapshot, 0).unwrap() { connection.decode_datagram(&bytes).unwrap(); }
    let Incoming::State { snapshot: delivered, delivery } = connection.take_ready_states().pop().unwrap() else { panic!("atomic snapshot"); };
    assert!(panel(&delivered, connection.inventory_input_identity(), true).is_none());
    connection.presented(delivery).unwrap();
    let first = panel(&delivered, connection.inventory_input_identity(), true).unwrap();
    assert_eq!(first.identity.0, s.session); assert!(s.session > (1_u64 << 53));
    connection.network_interrupted();
    assert!(panel(&delivered, connection.inventory_input_identity(), true).is_none());
    // Isolate a fresh paused reconnect using the real Client recovery contract;
    // no OS clock is sampled and no native pause behavior is claimed here.
    let request = t::JoinRequest { version: t::VERSION, champion: "garen".into(), summoners: [None, None],
        recovery_key: t::Secret32::from_bytes([21; 32]).unwrap(), request_nonce: t::RequestNonce([22;16]) };
    let mut resumed = crate::session_client::Client::new(request, true, t::RequestNonce([23;16])).unwrap();
    let epoch = (1_u64 << 53) + 9;
    let previous = t::Context { epoch: epoch - 1, ..context };
    resumed.context_response(&t::ContextResponse { request_nonce: t::RequestNonce([23;16]), context: previous,
        availability: t::Availability::Detached }, t::RequestNonce([24;16])).unwrap();
    let current = t::Context { epoch, ..context };
    resumed.welcome(t::Welcome { version: t::VERSION, context: current, request_nonce: t::RequestNonce([24;16]),
        access_key: t::Secret32::from_bytes([25;32]).unwrap(), next_sequence: 1,
        bootstrap: t::ClockBootstrap::Paused { through_ordinal: 1 } }).unwrap();
    let mut sender = session_wire::Sender::new(current).unwrap();
    for bytes in sender.encode(&snapshot, 1).unwrap() { resumed.frame(&bytes).unwrap(); }
    assert!(resumed.take_ready_states().is_empty()); resumed.clock_applied(current, 1).unwrap();
    let received = resumed.take_ready_states().pop().unwrap(); assert!(!resumed.ready());
    resumed.presented(current, received.frame_ordinal).unwrap(); assert!(resumed.ready());
    let panel = panel(&received.snapshot, Some((s.session, v, Some(epoch))), resumed.ready()).unwrap();
    assert_eq!(panel.rows, first.rows); assert_eq!(panel.identity.2, epoch);
    assert_eq!(panel.identity.3, first.identity.3, "persistent recap has no event baseline suppression");
}

#[test]
fn real_respawn_retires_old_recap_and_a_second_death_has_a_distinct_identity() {
    let (mut s, v, a) = game(); kill(&mut s, v, Some(a));
    let first = s.snapshot_for_atomic(v).unwrap();
    let first_panel = panel(&first, identity(&first, v), true).unwrap();
    s.tick = s.players[&v].respawn_at.unwrap() - 1; s.advance();
    let alive = s.snapshot_for_atomic(v).unwrap(); assert!(s.players[&v].health > 0.);
    assert!(panel(&alive, identity(&alive, v), true).is_none());
    kill(&mut s, v, None); let second = s.snapshot_for_atomic(v).unwrap();
    let second_panel = panel(&second, identity(&second, v), true).unwrap();
    assert_eq!(second_panel.identity.3, first_panel.identity.3 + 1);
    assert_eq!(second_panel.rows.len(), 1); assert_eq!(second_panel.rows[0].source, "Source masquée");
}

#[test]
fn bounded_decoder_fixture_keeps_full_width_identity_and_finite_wide_totals() {
    let (mut s, v, _) = game(); kill(&mut s, v, None);
    let mut snapshot = s.snapshot_for_atomic(v).unwrap();
    let rows = (0..death_recap::MAX_ROWS).map(|i| Row { key: (i + 1) as u8,
        source: if i < 16 { Source::Champion { champion: "LongCanonicalChampionLabelFixture".into() } }
            else if i == 16 { Source::Unknown } else { Source::Other },
        physical: Amount { health_removed: f32::MAX, shield_absorbed: f32::MAX },
        magical: Amount::default(), true_damage: Amount::default(), lethal: i == 17 }).collect();
    let r = Recap { policy: death_recap::POLICY.into(), session: s.session, victim: v, death_ordinal: u64::MAX,
        death_tick: s.tick, window_start: s.tick.saturating_sub(death_recap::WINDOW_TICKS), truncated: true, rows };
    snapshot.death_recap = Some(serde_json::to_value(r).unwrap());
    let wire = transported(&snapshot, v); let p = panel(&wire, identity(&wire, v), true).unwrap();
    assert_eq!(p.identity.3, u64::MAX); assert_eq!(p.rows.len(), death_recap::MAX_ROWS);
    assert!(p.footnote.starts_with("Historique partiel"));
    assert!(!p.summary.contains("inf")); assert!(!p.summary.contains("NaN"));
    assert!(p.summary.contains("6.1e39")); assert!(p.rows[0].source.ends_with('…'));
    assert!(!format!("{}{}", p.summary, p.footnote).contains(&s.session.to_string()));
}

#[test]
fn layout_bounds_cover_full_source_census_and_invalid_windows_retire() {
    for rows in [1, 2, death_recap::MAX_ROWS] {
        for (width, height) in [(640.,480.), (1280.,800.), (1920.,1080.)] {
            let l = layout(width, height, rows).unwrap();
            assert!(l.left >= 16. && l.left + l.width <= width - 16.);
            assert!(l.top + l.height <= height); assert!(l.font >= 9. && l.font <= 16.);
            assert!(l.row * (rows as f32 + 6.5) <= l.height, "footer stays in the panel");
        }
    }
    for (w,h,n) in [(f32::NAN,800.,1), (1280.,f32::INFINITY,1), (639.,800.,1), (1280.,479.,1), (1280.,800.,0), (1280.,800.,19)] {
        assert!(layout(w,h,n).is_none());
    }
}

#[derive(Resource)] struct Desired(Option<(Panel, Layout)>);
fn fixture_render(mut commands: Commands, mut live: ResMut<Live>, roots: Query<(), With<RecapRoot>>, desired: Res<Desired>) {
    reconcile(&mut commands, &mut live, &roots, desired.0.clone(), Handle::default());
}
#[test]
fn ecs_reuses_only_owned_panel_and_retires_all_children_without_touching_other_ui() {
    let (mut s, v, a) = game(); kill(&mut s, v, Some(a));
    let snap = s.snapshot_for_atomic(v).unwrap(); let p = panel(&snap, identity(&snap,v),true).unwrap();
    let shape = layout(1280.,800.,p.rows.len()).unwrap();
    let mut app = App::new(); app.init_resource::<Live>().insert_resource(Desired(Some((p.clone(),shape)))).add_systems(Update,fixture_render);
    let foreign = app.world_mut().spawn((Name::new("OtherHud"), Text::new("preserve"))).id();
    app.update(); let root = app.world().resource::<Live>().root.unwrap();
    let children: Vec<Entity> = app.world().get::<Children>(root).unwrap()[..].iter().copied().collect();
    assert!(!children.is_empty());
    for &child in &children { assert!(app.world().get::<bevy::picking::Pickable>(child).is_some()); }
    app.update(); assert_eq!(app.world().resource::<Live>().root,Some(root));
    app.world_mut().resource_mut::<Desired>().0 = None; app.update();
    assert!(app.world().get_entity(root).is_err()); assert!(children.iter().all(|child| app.world().get_entity(*child).is_err()));
    assert!(app.world().get_entity(foreign).is_ok());
    app.world_mut().resource_mut::<Desired>().0 = Some((p,shape)); app.update();
    let replacement = app.world().resource::<Live>().root.unwrap(); assert_ne!(replacement,root);
    app.world_mut().entity_mut(replacement).despawn(); app.update();
    let recovered = app.world().resource::<Live>().root.unwrap(); assert_ne!(recovered,replacement);
    app.world_mut().resource_mut::<Desired>().0 = None; app.update();
    assert!(app.world().get_entity(recovered).is_err()); assert!(app.world().get_entity(foreign).is_ok());
}
