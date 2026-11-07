use super::*;
use openleague_core::{death_recap, damage::DamageKind, Navigation};

fn game() -> Simulation {
    let nav = Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),
        include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
    let mut game = Simulation::new(nav).unwrap(); game.session = u64::MAX - 9;
    game.enable_map10().unwrap(); game.units.clear(); game
}
fn decode(packets: &[Vec<u8>], context: t::Context) -> t::StateEnvelope {
    let mut assembler = session_wire::Assembler::new(context).unwrap(); let mut result = None;
    for packet in packets {
        if let Some(frame) = assembler.push(packet).unwrap() { result = Some(frame.decode().unwrap()); }
    }
    result.unwrap()
}
struct Keys(u8);
impl r::Entropy for Keys {
    fn access_key(&mut self) -> Result<t::Secret32, r::EntropyUnavailable> {
        self.0 = self.0.checked_add(1).expect("fixture entropy exhausted");
        Ok(t::Secret32::from_bytes([self.0; 32]).unwrap())
    }
}
#[test]
fn authenticated_routes_receive_only_their_persistent_own_death_recap() {
    let mut game = game(); let mut host = Host::new(game.session).unwrap();
    let (mut delivery, mut pause) = (Delivery::default(), Pause::default());
    let mut welcomes = Vec::new();
    let mut keys = Keys(82);
    let mut access_keys = Vec::new();
    for i in 1_u8..=2 {
        let peer: SocketAddr = ([127, 0, 0, 1], 11000 + u16::from(i)).into();
        let request = t::JoinRequest { version: t::VERSION, champion: "garen".into(), summoners: [None, None],
            recovery_key: t::Secret32::from_bytes([i; 32]).unwrap(), request_nonce: t::RequestNonce([i; 16]) };
        let response = host.handle(t::ClientMessage::JoinResumable(request), peer, false, &mut game,
            &mut delivery, &mut pause, Duration::ZERO, true, &mut keys).unwrap();
        let Some(t::ServerMessage::SessionWelcome(welcome)) = response else { panic!("Welcome required") };
        access_keys.push(welcome.access_key.clone());
        welcomes.push((peer, welcome.context));
    }
    assert!(access_keys[0] != access_keys[1], "authenticated routes need distinct access keys");
    let victim = welcomes[0].1.player;
    let hit = game.apply_damage(None, victim, 1_000_000., DamageKind::True).unwrap(); assert!(hit.lethal);
    for (peer, packets) in host.states(&game, &delivery).unwrap() {
        let ctx = welcomes.iter().find(|x| x.0 == peer).unwrap().1;
        let frame = decode(&packets, ctx); assert_eq!(frame.context, ctx);
        let recap = death_recap::decode_view(frame.snapshot.death_recap.as_ref(), game.session, ctx.player, game.tick).unwrap();
        assert_eq!(recap.is_some(), ctx.player == victim);
        if let Some(recap) = recap { assert_eq!(recap.rows[0].true_damage.health_removed, hit.health_removed); }
    }
    assert!(game.snapshot_for(victim).unwrap().death_recap.is_none());
    // A resumed authenticated context can show persistent death state; no one-shot baseline is used.
    let ctx = t::Context { epoch: 2, ..welcomes[0].1 };
    let mut sender = session_wire::Sender::new(ctx).unwrap();
    let snapshot = game.snapshot_for_atomic(victim).unwrap();
    let frame = decode(&current_state_packets(&mut sender, snapshot.clone(), 7).unwrap(), ctx);
    assert_eq!(frame.frame_ordinal, 1); assert_eq!(frame.snapshot.death_recap, snapshot.death_recap);
}
#[test]
fn valid_recap_omits_atomically_at_real_frame_limit_without_consuming_an_ordinal() {
    let mut game = game(); let victim = game.join("garen").unwrap();
    game.apply_damage(None, victim, 1_000_000., DamageKind::True).unwrap();
    let ordinary = game.snapshot_for_atomic(victim).unwrap(); assert!(ordinary.death_recap.is_some());
    let ctx = t::Context { session: game.session, player: victim, epoch: 8 };
    let mut padded = ordinary.clone(); padded.death_recap = None;
    padded.attack_presentation_error = Some(String::new());
    let envelope = t::StateEnvelope { context: ctx, frame_ordinal: 1, clock_ordinal: 7, snapshot: padded.clone() };
    let base = serde_json::to_vec(&envelope).unwrap().len();
    assert!(base < session_wire::MAX_FRAME);
    padded.attack_presentation_error = Some("x".repeat(session_wire::MAX_FRAME - base));
    padded.death_recap = ordinary.death_recap.clone();
    let mut sender = session_wire::Sender::new(ctx).unwrap();
    let fallback = decode(&current_state_packets(&mut sender, padded.clone(), 7).unwrap(), ctx);
    assert_eq!(fallback.frame_ordinal, 1); assert_eq!(fallback.clock_ordinal, 7);
    assert!(fallback.snapshot.death_recap.is_none());
    assert!(fallback.snapshot.ezreal_r_current_heights.is_none());
    assert!(fallback.snapshot.ezreal_r_accepted_impacts.is_none());
    assert!(fallback.snapshot.ezreal_r_accepted_casts.is_none());
    assert!(fallback.snapshot.ezreal_w_current_missiles.is_none());
    assert!(fallback.snapshot.ezreal_e_accepted_releases.is_none());
    assert!(fallback.snapshot.ezreal_e_current_bolts.is_none());
    assert_eq!(fallback.snapshot.ezreal_q_accepted_impacts, ordinary.ezreal_q_accepted_impacts);
    assert_eq!(fallback.snapshot.accepted_casts, ordinary.accepted_casts);
    assert_eq!(fallback.snapshot.players[0].health, ordinary.players[0].health);
    let next = decode(&current_state_packets(&mut sender, ordinary.clone(), 7).unwrap(), ctx);
    assert_eq!(next.frame_ordinal, 2); assert_eq!(next.snapshot.death_recap, ordinary.death_recap);
    padded.attack_presentation_error = Some("x".repeat(session_wire::MAX_FRAME));
    assert!(current_state_packets(&mut sender, padded, 7).is_err());
    assert_eq!(decode(&current_state_packets(&mut sender, ordinary, 7).unwrap(), ctx).frame_ordinal, 3);
}
