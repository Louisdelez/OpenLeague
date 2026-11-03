//! Concrete local registry/Simulation/clock composition. UDP I/O stays in main.
//! No raw transport logging; returned messages containing capabilities are wire only.
use std::{collections::HashMap, net::SocketAddr, time::Duration};
use openleague_core::{Simulation, session_transport as t, session_wire};
use crate::{clock_delivery::Delivery, pause::Pause, reconnect::{self as r, Registry}};

#[cfg(test)]
#[path="session_host_tests.rs"]
mod tests;
#[cfg(test)]
#[path="session_host_e_presentation_tests.rs"]
mod e_presentation_tests;

pub struct OsEntropy;
impl r::Entropy for OsEntropy {
    fn access_key(&mut self) -> Result<t::Secret32, r::EntropyUnavailable> {
        let bytes = openleague_core::session_random::bytes().map_err(|_| r::EntropyUnavailable)?;
        t::Secret32::from_bytes(bytes).map_err(|_| r::EntropyUnavailable)
    }
}
struct Route { context: t::Context, frames: session_wire::Sender }
pub struct Host { registry: Registry, routes: HashMap<SocketAddr, Route> }
impl Host {
    pub fn new(session: u64) -> Result<Self, r::Error> {
        Ok(Self { registry: Registry::new(session, r::Limits::default())?, routes: HashMap::new() })
    }
    pub fn forbids_legacy(&self, peer: SocketAddr) -> bool { self.registry.forbids_legacy(peer) }
    pub fn participants(&self) -> usize { self.registry.live_players() }
    fn reserve_route(&mut self) -> Result<(), &'static str> {
        self.routes.try_reserve(1).map_err(|_| "session route allocation failed")
    }
    fn route(&mut self, peer: SocketAddr, welcome: &t::Welcome) {
        // Registry emits only nonzero validated contexts; reserve_route preceded commit.
        let frames = session_wire::Sender::new(welcome.context).expect("committed registry context");
        self.routes.insert(peer, Route { context: welcome.context, frames });
    }
    fn apply(&mut self, changes: Vec<r::Transition>, game: &mut Simulation, delivery: &mut Delivery) {
        for change in changes {
            match change {
                r::Transition::Detached(endpoint) => {
                    self.routes.remove(&endpoint.peer); delivery.remove(endpoint.context.player);
                }
                r::Transition::Retired { player, endpoint, .. } => {
                    if let Some(endpoint) = endpoint { self.routes.remove(&endpoint.peer); }
                    game.remove_player(player); delivery.remove(player);
                }
            }
        }
    }
    pub fn poll(&mut self, now: Duration, draining: bool, game: &mut Simulation, delivery: &mut Delivery) -> Result<(), &'static str> {
        let changes = if draining { self.registry.begin_drain(now) } else { self.registry.poll(now) }
            .map_err(|_| "session registry time/retirement failed")?;
        self.apply(changes, game, delivery); Ok(())
    }
    /// legacy_peer is authoritative membership in the old endpoint table. A
    /// legacy participant cannot be replaced by merely supplying a new secret.
    pub fn handle(&mut self, message: t::ClientMessage, peer: SocketAddr, legacy_peer: bool,
        game: &mut Simulation, delivery: &mut Delivery, pause: &mut Pause,
        now: Duration, allow_pause: bool, entropy: &mut impl r::Entropy,
    ) -> Result<Option<t::ServerMessage>, &'static str> {
        if legacy_peer {
            let nonce=match &message {
                t::ClientMessage::JoinResumable(r)=>Some(r.request_nonce),
                t::ClientMessage::Resume(r)=>Some(r.request_nonce),
                t::ClientMessage::ContextQuery(r)=>Some(r.request_nonce),t::ClientMessage::Session(_)=>None,
            };
            return Ok(Some(rejected(nonce, r::Error::PeerOccupied)));
        }
        match message {
            t::ClientMessage::ContextQuery(request) => Ok(Some(match self.registry.query_context(&request, now) {
                Ok(response) => t::ServerMessage::SessionContext(response),
                Err(error) => rejected(Some(request.request_nonce), error),
            })),
            t::ClientMessage::JoinResumable(request) => {
                self.reserve_route()?;
                let prepared = match self.registry.prepare_join(peer, &request, now, entropy) {
                    Ok(value) => value, Err(error) => return preparation_error(Some(request.request_nonce), error),
                };
                let welcome = match prepared {
                    r::JoinPreparation::Replay(welcome) => return Ok(Some(t::ServerMessage::SessionWelcome(welcome))),
                    r::JoinPreparation::New(pending) => {
                        let player = match game.join_with_summoners(&request.champion, request.summoners) {
                            Ok(player) => player,
                            Err(_) => return Ok(Some(rejected(Some(request.request_nonce), r::Error::InvalidRequest))),
                        };
                        let clock = match delivery.prepare_recipient(player, pause, now) {
                            Ok(clock) => clock,
                            Err(error) => { game.remove_player(player); return Err(error); }
                        };
                        let welcome = match pending.commit(player, clock.bootstrap()) {
                            Ok(welcome) => welcome,
                            Err(_) => {
                                // player was created by this exact attempt, never an existing ID.
                                game.remove_player(player); return Err("new session commit failed");
                            }
                        };
                        delivery.install_recipient(clock); welcome
                    }
                };
                self.route(peer, &welcome); Ok(Some(t::ServerMessage::SessionWelcome(welcome)))
            }
            t::ClientMessage::Resume(request) => {
                self.reserve_route()?;
                let prepared = match self.registry.prepare_resume(peer, &request, now, entropy) {
                    Ok(value) => value, Err(error) => return preparation_error(Some(request.request_nonce), error),
                };
                let attached = match prepared {
                    r::ResumePreparation::Replay(welcome) => return Ok(Some(t::ServerMessage::SessionWelcome(welcome))),
                    r::ResumePreparation::New(pending) => {
                        let clock = delivery.prepare_recipient(request.expected.player, pause, now)?;
                        let attached = pending.commit(clock.bootstrap()).map_err(|_| "resumed session commit failed")?;
                        delivery.install_recipient(clock); attached
                    }
                };
                if let Some(previous) = attached.previous {
                    // The clock queue just installed belongs to the new epoch: do not remove it.
                    self.routes.remove(&previous.peer);
                }
                self.route(peer, &attached.welcome); Ok(Some(t::ServerMessage::SessionWelcome(attached.welcome)))
            }
            t::ClientMessage::Session(request) => {
                let prepared = match self.registry.prepare_input(peer, &request, now) {
                    Ok(value) => value, Err(error) => return Ok(Some(rejected(None, error))),
                };
                let ack = if let t::Input::ClockAck { ordinal } = prepared.input() {
                    let Some(issued) = delivery.issued(request.context.player) else { return Err("active session lost its clock recipient"); };
                    match r::PreparedAck::check(request.context, *ordinal, issued) {
                        Ok(proof) => Some(proof), Err(error) => return Ok(Some(rejected(None, error))),
                    }
                } else { None };
                let accepted = prepared.commit(ack).map_err(|_| "prepared session input commit failed")?;
                if let Some(change) = accepted.transition { self.apply(vec![change], game, delivery); return Ok(None); }
                let outcome = match accepted.input {
                    t::Input::ClockAck { ordinal } => delivery.acknowledge(accepted.context.player, ordinal).map_err(str::to_string),
                    t::Input::Heartbeat => Ok(()),
                    t::Input::PauseRequest { paused } => {
                        if !allow_pause { Err("pause disabled by local match host".into()) }
                        else if game.final_results().is_some() { Err("match already finished".into()) }
                        else { pause.request(accepted.context.player, paused, now, delivery).map_err(str::to_string) }
                    }
                    t::Input::Command(action) => {
                        if pause.is_paused() { Err("match is paused".into()) }
                        else { game.command(accepted.context.player, action) }
                    }
                    t::Input::Leave => unreachable!("committed Leave has a retirement transition"),
                };
                Ok(outcome.err().map(|reason| t::ServerMessage::SessionGameplayRejected(t::GameplayRejection {
                    context: accepted.context, sequence: accepted.sequence, reason,
                })))
            }
        }
    }
    pub fn clocks(&self, delivery: &Delivery) -> Vec<(SocketAddr, t::ServerMessage)> {
        self.routes.iter().flat_map(|(peer, route)| delivery.pending(route.context.player).map(move |event| (*peer,
            t::ServerMessage::SessionClockControl(t::ClockEnvelope { context: route.context,
                ordinal: event.ordinal, opcode: event.opcode, payload: event.payload.clone() })))).collect()
    }
    pub fn states(&mut self, game: &Simulation, delivery: &Delivery) -> Result<Vec<(SocketAddr, Vec<Vec<u8>>)>, &'static str> {
        let mut messages = Vec::new();
        for (peer, route) in &mut self.routes {
            let snapshot = game.snapshot_for_atomic(route.context.player).ok_or("session participant missing from Simulation")?;
            let issued = delivery.issued(route.context.player).ok_or("session clock recipient missing")?;
            let packets = current_state_packets(&mut route.frames, snapshot, issued)?;
            messages.push((*peer, packets));
        }
        Ok(messages)
    }
}

fn preparation_error(nonce: Option<t::RequestNonce>, error: r::Error) -> Result<Option<t::ServerMessage>, &'static str> {
    match error {
        r::Error::EntropyUnavailable => Err("OS session randomness unavailable"),
        r::Error::KeyCollision => Err("OS session capability collided; registration not committed"),
        r::Error::ClockWentBack => Err("session registry clock moved backwards"),
        r::Error::CounterExhausted => Err("session sequence or epoch exhausted"),
        _ => Ok(Some(rejected(nonce, error))),
    }
}

fn rejected(nonce: Option<t::RequestNonce>, error: r::Error) -> t::ServerMessage {
    let (reason, context) = match error {
        r::Error::UnsupportedVersion => (t::RejectionCode::UnsupportedVersion, None),
        r::Error::UnknownLease => (t::RejectionCode::UnknownLease, None),
        r::Error::Retired | r::Error::EndpointRetired => (t::RejectionCode::Retired, None),
        r::Error::Busy | r::Error::PeerOccupied => (t::RejectionCode::Busy, None),
        r::Error::StaleEpoch { current } => (t::RejectionCode::StaleEpoch, Some(current)),
        r::Error::ReplayExpired => (t::RejectionCode::ReplayExpired, None),
        r::Error::Closing => (t::RejectionCode::Closing, None),
        r::Error::Unauthorized => (t::RejectionCode::Unauthorized, None),
        r::Error::StaleSequence | r::Error::StaleAck => (t::RejectionCode::StaleSequence, None),
        r::Error::Capacity => (t::RejectionCode::Capacity, None),
        _ => (t::RejectionCode::InvalidRequest, None),
    };
    t::ServerMessage::SessionRejected(t::Rejection { request_nonce: nonce, context, reason })
}

/// Optional R/W/E presentation extensions cannot make gameplay state unavailable.
/// Sender commits its ordinal only after successful fragmentation; a Length
/// retry therefore binds the entire fallback snapshot to one unchanged ordinal.
fn current_state_packets(frames: &mut session_wire::Sender, mut snapshot: openleague_core::Snapshot,
    clock_ordinal: u64) -> Result<Vec<Vec<u8>>, &'static str> {
    match frames.encode(&snapshot, clock_ordinal) {
        Ok(packets) => Ok(packets),
        Err(session_wire::Error::Length) => {
            let had_recap = snapshot.death_recap.take().is_some();
            let had_height = snapshot.ezreal_r_current_heights.take().is_some();
            let had_w_missiles = snapshot.ezreal_w_current_missiles.take().is_some();
            let had_e_bolts = snapshot.ezreal_e_current_bolts.take().is_some();
            let had_e_releases = snapshot.ezreal_e_accepted_releases.take().is_some();
            let had_impacts = snapshot.ezreal_r_accepted_impacts.take().is_some();
            let had_casts = snapshot.ezreal_r_accepted_casts.take().is_some();
            let had_w_casts = !snapshot.ezreal_w_casts.is_empty();
            snapshot.ezreal_w_casts.clear();
            let had_e_casts = !snapshot.ezreal_e_casts.is_empty();
            snapshot.ezreal_e_casts.clear();
            if !had_recap && !had_height && !had_impacts && !had_casts && !had_w_casts && !had_e_casts && !had_w_missiles && !had_e_bolts && !had_e_releases { return Err("session state exceeds framing contract"); }
            frames.encode(&snapshot, clock_ordinal).map_err(|_| "session base state exceeds framing contract")
        }
        Err(_) => Err("session state exceeds framing contract"),
    }
}

#[cfg(test)]
mod current_height_tests {
    use super::*;
    fn game() -> Simulation {
        let nav = openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),
            include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut game = Simulation::new(nav).unwrap(); game.session = u64::MAX - 7;
        game.enable_map10().unwrap(); game.enable_map10_cast_ground().unwrap(); game.units.clear(); game
    }
    fn context(game: &Simulation, player: u32) -> t::Context { t::Context { session: game.session, player, epoch: 7 } }
    fn decode(packets: &[Vec<u8>], context: t::Context) -> t::StateEnvelope {
        let mut assembler = session_wire::Assembler::new(context).unwrap(); let mut done = None;
        for packet in packets { if let Some(frame) = assembler.push(packet).unwrap() { done = Some(frame.decode().unwrap()); } }
        done.unwrap()
    }
    fn height(snapshot: &mut openleague_core::Snapshot, owner: u32, x: f32, y: f32) {
        snapshot.ezreal_r_projectiles = vec![openleague_core::ezreal_r::VisibleMissile {
            session: snapshot.session, owner, team: 0, ordinal: u64::MAX - 3,
            position: openleague_core::Point { x, z: 7297. }, direction: openleague_core::Point { x: 1., z: 0. },
        }];
        snapshot.ezreal_r_current_heights = Some(serde_json::json!({
            "policy":openleague_core::ezreal_r::CURRENT_HEIGHT_POLICY,
            "rows":[{"owner":owner,"team":0,"ordinal":u64::MAX-3,"y_native":y}],
        }));
    }
    struct Keys;
    impl r::Entropy for Keys {
        fn access_key(&mut self) -> Result<t::Secret32, r::EntropyUnavailable> {
            Ok(t::Secret32::from_bytes([80;32]).unwrap())
        }
    }

    #[test]
    fn actual_resumable_host_publishes_cast_height_with_atomic_context_but_legacy_stays_empty() {
        let mut game = game(); let mut host = Host::new(game.session).unwrap();
        let (mut delivery, mut pause) = (Delivery::default(), Pause::default());
        let peer: SocketAddr = ([127,0,0,1],10001).into();
        let request = t::JoinRequest { version:t::VERSION, champion:"ezreal".into(), summoners:[None,None],
            recovery_key:t::Secret32::from_bytes([1;32]).unwrap(), request_nonce:t::RequestNonce([1;16]) };
        let response = host.handle(t::ClientMessage::JoinResumable(request), peer, false, &mut game,
            &mut delivery, &mut pause, Duration::ZERO, true, &mut Keys).unwrap();
        let Some(t::ServerMessage::SessionWelcome(welcome)) = response else { panic!("expected Welcome") };
        let owner = welcome.context.player; let p = game.players.get_mut(&owner).unwrap();
        p.level = 6; p.ranks[3] = 1; p.mana = 2000.; let origin = p.position;
        let command = t::ClientMessage::Session(t::SessionInput { version:t::VERSION, context:welcome.context,
            access_key:welcome.access_key, sequence:1, input:t::Input::Command(openleague_core::Action::CastAt {
                slot:3, point:openleague_core::Point { x:origin.x+1000.,z:origin.z } }) });
        assert!(host.handle(command,peer,false,&mut game,&mut delivery,&mut pause,Duration::ZERO,true,&mut Keys).unwrap().is_none());
        let pending = decode(&host.states(&game,&delivery).unwrap()[0].1,welcome.context);
        assert!(pending.snapshot.ezreal_r_current_heights.is_none());
        for _ in 0..30 { game.advance(); }
        let messages = host.states(&game,&delivery).unwrap(); assert_eq!(messages.len(),1); assert_eq!(messages[0].0,peer);
        let frame = decode(&messages[0].1,welcome.context); assert_eq!(frame.context,welcome.context);
        assert_eq!(frame.frame_ordinal,2); assert_eq!(frame.snapshot.tick,30); assert_eq!(frame.clock_ordinal,0);
        assert_eq!(frame.snapshot.ezreal_r_projectiles.len(),1);
        let raw = frame.snapshot.ezreal_r_current_heights.as_ref().expect("actual cast-height producer reached Host");
        assert_eq!(raw["rows"].as_array().unwrap().len(),1); assert!(raw["rows"][0]["y_native"].as_f64().unwrap().is_finite());
        assert!(game.snapshot_for(owner).unwrap().ezreal_r_current_heights.is_none());
    }

    #[test]
    fn same_tick_current_xyz_cannot_mix_frames_and_conflicting_fragment_retires_whole_frame() {
        let mut game = game(); let owner = game.join("ezreal").unwrap(); let context = context(&game,owner);
        let mut first = game.snapshot_for(owner).unwrap(); height(&mut first,owner,1100.,125.);
        let mut second = first.clone(); height(&mut second,owner,1200.,-5.);
        // Real Snapshot envelopes are fragmented; no custom framing or coordinate side channel.
        let mut sender = session_wire::Sender::new(context).unwrap();
        let one = current_state_packets(&mut sender,first.clone(),0).unwrap();
        let two = current_state_packets(&mut sender,second.clone(),0).unwrap();
        assert!(one.len()>1 && two.len()>1);
        let mut assembler = session_wire::Assembler::new(context).unwrap();
        assert!(assembler.push(&one[0]).unwrap().is_none()); assert!(assembler.push(&two[0]).unwrap().is_none());
        for packet in &one[1..] { assert!(matches!(assembler.push(packet),Err(session_wire::Error::Stale))); }
        let mut received = None;
        for packet in two[1..].iter().rev() { if let Some(frame) = assembler.push(packet).unwrap() { received=Some(frame.decode().unwrap()); } }
        let received = received.unwrap(); assert_eq!(received.frame_ordinal,2); assert_eq!(received.snapshot.tick,first.tick);
        assert_eq!(received.snapshot.session,u64::MAX-7);
        assert_eq!(received.snapshot.ezreal_r_projectiles,second.ezreal_r_projectiles);
        assert_eq!(received.snapshot.ezreal_r_current_heights,second.ezreal_r_current_heights);
        assert_eq!(received.snapshot.ezreal_r_projectiles[0].ordinal,u64::MAX-3);
        let three = current_state_packets(&mut sender,first,0).unwrap();
        assert!(assembler.push(&three[0]).unwrap().is_none()); let mut conflict=three[0].clone();
        *conflict.last_mut().unwrap() ^= 1;
        assert!(matches!(assembler.push(&conflict),Err(session_wire::Error::ConflictingFragment)));
        for packet in &three { assert!(matches!(assembler.push(packet),Err(session_wire::Error::Stale))); }
        let four = current_state_packets(&mut sender,second,0).unwrap(); assert_eq!(decode(&four,context).frame_ordinal,4);
    }

    #[test]
    fn optional_height_budget_drops_whole_extension_without_consuming_extra_ordinal() {
        let mut game = game(); let owner = game.join("ezreal").unwrap(); let context = context(&game,owner);
        let mut ordinary = game.snapshot_for(owner).unwrap(); height(&mut ordinary,owner,1100.,125.);
        let mut oversized = ordinary.clone(); oversized.ezreal_r_current_heights=Some(serde_json::json!("x".repeat(session_wire::MAX_FRAME)));
        let mut sender=session_wire::Sender::new(context).unwrap();
        let fallback=decode(&current_state_packets(&mut sender,oversized,9).unwrap(),context);
        assert_eq!(fallback.frame_ordinal,1); assert_eq!(fallback.clock_ordinal,9);
        assert!(fallback.snapshot.ezreal_r_current_heights.is_none());
        assert_eq!(fallback.snapshot.ezreal_r_projectiles,ordinary.ezreal_r_projectiles);
        let next=decode(&current_state_packets(&mut sender,ordinary.clone(),9).unwrap(),context);
        assert_eq!(next.frame_ordinal,2); assert_eq!(next.snapshot.ezreal_r_current_heights,ordinary.ezreal_r_current_heights);
        // Base state still over the bound must fail, without leaking a partial state or reserving an ordinal.
        let mut invalid=ordinary.clone(); invalid.attack_presentation_error=Some("x".repeat(session_wire::MAX_FRAME));
        assert!(current_state_packets(&mut sender,invalid,9).is_err());
        assert_eq!(decode(&current_state_packets(&mut sender,ordinary,9).unwrap(),context).frame_ordinal,3);
    }

    #[test]
    fn optional_r_impact_budget_omits_whole_r_extensions_and_preserves_ordinal_and_gameplay() {
        let mut game=game();let owner=game.join("ezreal").unwrap();let ctx=context(&game,owner);
        let ordinary=game.snapshot_for_atomic(owner).unwrap();
        let expected=serde_json::to_value(&ordinary).unwrap();
        for with_height in [false,true] {
            let mut oversized=ordinary.clone();
            // Deliberately oversized codec fixture; no gameplay injection or real impact is claimed.
            oversized.ezreal_r_accepted_impacts=Some(serde_json::json!("x".repeat(session_wire::MAX_FRAME)));
            if with_height {height(&mut oversized,owner,1100.,125.);}
            let current=oversized.ezreal_r_projectiles.clone();let q=oversized.ezreal_q_accepted_impacts.clone();
            let casts=oversized.accepted_casts.clone();let mut sender=session_wire::Sender::new(ctx).unwrap();
            let fallback=decode(&current_state_packets(&mut sender,oversized,17).unwrap(),ctx);
            assert_eq!(fallback.frame_ordinal,1);assert_eq!(fallback.clock_ordinal,17);
            assert!(fallback.snapshot.ezreal_r_accepted_impacts.is_none());
            assert!(fallback.snapshot.ezreal_r_current_heights.is_none());
            assert_eq!(fallback.snapshot.ezreal_r_projectiles,current);
            assert_eq!(fallback.snapshot.ezreal_q_accepted_impacts,q);assert_eq!(fallback.snapshot.accepted_casts,casts);
            let next=decode(&current_state_packets(&mut sender,ordinary.clone(),17).unwrap(),ctx);
            assert_eq!(next.frame_ordinal,2);assert_eq!(serde_json::to_value(next.snapshot).unwrap(),expected);
            let mut bad=ordinary.clone();bad.attack_presentation_error=Some("x".repeat(session_wire::MAX_FRAME));
            assert!(current_state_packets(&mut sender,bad,17).is_err());
            assert_eq!(decode(&current_state_packets(&mut sender,ordinary.clone(),17).unwrap(),ctx).frame_ordinal,3);
        }
    }

    #[test]
    fn optional_w_cast_budget_omits_whole_channel_at_same_ordinal_and_preserves_gameplay() {
        let mut game=game();let owner=game.join("ezreal").unwrap();let ctx=context(&game,owner);
        let actor=game.players.get_mut(&owner).unwrap();actor.level=6;actor.ranks[1]=1;actor.ranks[3]=1;actor.mana=2000.;
        let aim=openleague_core::Point{x:actor.position.x+100.,z:actor.position.z};
        // A real accepted R fact survives its release, then coexists with current W.
        game.command(owner,openleague_core::Action::CastAt{slot:3,point:aim}).unwrap();
        for _ in 0..30 { game.advance(); }
        game.command(owner,openleague_core::Action::CastAt{slot:1,point:aim}).unwrap();
        let mut ordinary=game.snapshot_for_atomic(owner).unwrap();assert_eq!(ordinary.ezreal_w_casts.len(),1);
        assert_eq!(ordinary.ezreal_r_accepted_casts.as_ref().unwrap()["events"].as_array().unwrap().len(),1);
        height(&mut ordinary,owner,1100.,125.); // Existing valid height codec fixture.
        assert!(ordinary.ezreal_r_accepted_impacts.is_some()); // Real empty accepted-hit projection.
        let row=ordinary.ezreal_w_casts[0];let mut oversized=ordinary.clone();
        // Codec-only oversized vector, not a claim of this many legal casts.
        oversized.ezreal_w_casts=vec![row;session_wire::MAX_FRAME/64];
        let mut sender=session_wire::Sender::new(ctx).unwrap();
        let fallback=decode(&current_state_packets(&mut sender,oversized,19).unwrap(),ctx);
        assert_eq!(fallback.frame_ordinal,1);assert_eq!(fallback.clock_ordinal,19);assert!(fallback.snapshot.ezreal_w_casts.is_empty());
        let mut expected=ordinary.clone();expected.ezreal_w_casts.clear();expected.ezreal_r_current_heights=None;expected.ezreal_r_accepted_impacts=None;expected.ezreal_r_accepted_casts=None;expected.ezreal_e_current_bolts=None;expected.ezreal_e_accepted_releases=None;
        assert_eq!(serde_json::to_value(fallback.snapshot).unwrap(),serde_json::to_value(expected).unwrap());
        let next=decode(&current_state_packets(&mut sender,ordinary.clone(),19).unwrap(),ctx);
        assert_eq!(next.frame_ordinal,2);assert_eq!(next.snapshot.ezreal_w_casts,ordinary.ezreal_w_casts);
        assert_eq!(next.snapshot.ezreal_r_current_heights,ordinary.ezreal_r_current_heights);
        assert_eq!(next.snapshot.ezreal_r_accepted_impacts,ordinary.ezreal_r_accepted_impacts);
        assert_eq!(next.snapshot.ezreal_r_accepted_casts,ordinary.ezreal_r_accepted_casts);
        let mut bad=ordinary.clone();bad.attack_presentation_error=Some("x".repeat(session_wire::MAX_FRAME));
        assert!(current_state_packets(&mut sender,bad,19).is_err());
        assert_eq!(decode(&current_state_packets(&mut sender,ordinary,19).unwrap(),ctx).frame_ordinal,3);
    }

    #[test]
    fn optional_oncast_length_fallback_preserves_gameplay_and_other_journals_with_one_ordinal(){
        let mut game=game();let owner=game.join("ezreal").unwrap();let ctx=context(&game,owner);
        let p=game.players.get_mut(&owner).unwrap();p.level=6;p.ranks[3]=1;p.mana=2000.;let origin=p.position;
        game.command(owner,openleague_core::Action::CastAt{slot:3,point:openleague_core::Point{x:origin.x+1000.,z:origin.z}}).unwrap();
        let mut ordinary=game.snapshot_for_atomic(owner).unwrap();assert_eq!(ordinary.ezreal_r_accepted_casts.as_ref().unwrap()["events"].as_array().unwrap().len(),1);
        height(&mut ordinary,owner,1100.,125.);let mut over=ordinary.clone();over.ezreal_r_accepted_casts=Some(serde_json::json!("x".repeat(session_wire::MAX_FRAME)));
        let mut sender=session_wire::Sender::new(ctx).unwrap();let out=decode(&current_state_packets(&mut sender,over,17).unwrap(),ctx);
        assert_eq!(out.frame_ordinal,1);assert_eq!(out.clock_ordinal,17);let mut expected=ordinary.clone();
        expected.ezreal_r_accepted_casts=None;expected.ezreal_e_current_bolts=None;expected.ezreal_e_accepted_releases=None;expected.ezreal_r_current_heights=None;expected.ezreal_r_accepted_impacts=None;expected.ezreal_w_casts.clear();
        assert_eq!(serde_json::to_value(out.snapshot).unwrap(),serde_json::to_value(expected).unwrap());
        let normal=decode(&current_state_packets(&mut sender,ordinary.clone(),17).unwrap(),ctx);assert_eq!(normal.frame_ordinal,2);
        assert_eq!(serde_json::to_value(normal.snapshot).unwrap(),serde_json::to_value(&ordinary).unwrap());
        let mut bad=ordinary.clone();bad.attack_presentation_error=Some("x".repeat(session_wire::MAX_FRAME));assert!(current_state_packets(&mut sender,bad,17).is_err());
        assert_eq!(decode(&current_state_packets(&mut sender,ordinary,17).unwrap(),ctx).frame_ordinal,3);
    }
    #[test]
    fn optional_e_budget_drops_whole_optional_channels_preserves_base_state_and_frame_identity() {
        let mut cells=Vec::new();for _ in 0..6400 {cells.extend(0f32.to_le_bytes());cells.extend(0u16.to_le_bytes());cells.extend(0u32.to_le_bytes());cells.push(1);}
        let nav=openleague_core::Navigation::load(r#"{"min":[0,0,0],"cellSize":50,"width":80,"height":80}"#,&cells).unwrap();
        let mut game=Simulation::new(nav).unwrap();game.session=u64::MAX-7;
        let owner=game.join("ezreal").unwrap();let other=game.join("ezreal").unwrap();let ctx=context(&game,owner);
        for (id,x) in [(owner,200.),(other,1000.)] {let p=game.players.get_mut(&id).unwrap();
            p.position=openleague_core::Point{x,z:300.};p.level=6;p.ranks=[0,1,1,1];p.mana=2000.;}
        game.command(owner,openleague_core::Action::CastAt{slot:3,point:openleague_core::Point{x:2000.,z:300.}}).unwrap();
        for _ in 0..30 {game.advance();}
        game.command(owner,openleague_core::Action::CastAt{slot:2,point:openleague_core::Point{x:400.,z:300.}}).unwrap();
        game.command(other,openleague_core::Action::CastAt{slot:1,point:openleague_core::Point{x:2000.,z:300.}}).unwrap();
        let mut ordinary=game.snapshot_for_atomic(owner).unwrap();assert_eq!(ordinary.ezreal_e_casts.len(),1);assert_eq!(ordinary.ezreal_w_casts.len(),1);
        assert_eq!(ordinary.ezreal_r_accepted_casts.as_ref().unwrap()["events"].as_array().unwrap().len(),1);
        assert!(ordinary.ezreal_r_accepted_impacts.is_some());height(&mut ordinary,owner,1100.,125.);
        ordinary.ezreal_w_current_missiles=Some(serde_json::json!({"policy":openleague_core::ezreal_w_projectile_view::POLICY,
            "rows":[{"owner":owner,"team":0,"ordinal":u64::MAX,"x":1100,"z":7297,"y_native":125,"dx":1,"dz":0}]}));
        let mut oversized=ordinary.clone();oversized.ezreal_e_casts=vec![ordinary.ezreal_e_casts[0];session_wire::MAX_FRAME/64];
        let mut sender=session_wire::Sender::new(ctx).unwrap();
        let fallback=decode(&current_state_packets(&mut sender,oversized,19).unwrap(),ctx);
        assert_eq!(fallback.frame_ordinal,1);assert_eq!(fallback.clock_ordinal,19);
        let mut expected=ordinary.clone();expected.ezreal_e_casts.clear();expected.ezreal_w_casts.clear();
        expected.ezreal_w_current_missiles=None;
        expected.ezreal_r_current_heights=None;expected.ezreal_r_accepted_impacts=None;expected.ezreal_r_accepted_casts=None;expected.ezreal_e_current_bolts=None;expected.ezreal_e_accepted_releases=None;
        assert_eq!(serde_json::to_value(fallback.snapshot).unwrap(),serde_json::to_value(expected).unwrap());
        let next=decode(&current_state_packets(&mut sender,ordinary.clone(),19).unwrap(),ctx);assert_eq!(next.frame_ordinal,2);
        assert_eq!(serde_json::to_value(next.snapshot).unwrap(),serde_json::to_value(&ordinary).unwrap());
        let mut bad=ordinary.clone();bad.attack_presentation_error=Some("x".repeat(session_wire::MAX_FRAME));
        assert!(current_state_packets(&mut sender,bad,19).is_err());
        assert_eq!(decode(&current_state_packets(&mut sender,ordinary,19).unwrap(),ctx).frame_ordinal,3);
    }

    #[test]
    fn optional_w_current_xyz_budget_is_atomic_and_never_reserves_failed_ordinal(){
        let mut game=game();let owner=game.join("ezreal").unwrap();let ctx=context(&game,owner);
        let mut ordinary=game.snapshot_for_atomic(owner).unwrap();
        ordinary.ezreal_w_current_missiles=Some(serde_json::json!({"policy":openleague_core::ezreal_w_projectile_view::POLICY,
            "rows":[{"owner":owner,"team":0,"ordinal":u64::MAX,"x":1100,"z":7297,"y_native":125,"dx":1,"dz":0}]}));
        let mut sender=session_wire::Sender::new(ctx).unwrap();
        let first=decode(&current_state_packets(&mut sender,ordinary.clone(),7).unwrap(),ctx);
        assert_eq!(first.snapshot.ezreal_w_current_missiles,ordinary.ezreal_w_current_missiles);
        let mut over=ordinary.clone();over.ezreal_w_current_missiles=Some(serde_json::json!("x".repeat(session_wire::MAX_FRAME)));
        let mut expected=ordinary.clone();expected.ezreal_w_current_missiles=None;expected.ezreal_r_current_heights=None;
        expected.ezreal_r_accepted_impacts=None;expected.ezreal_r_accepted_casts=None;expected.ezreal_e_current_bolts=None;expected.ezreal_e_accepted_releases=None;expected.ezreal_w_casts.clear();
        let fallback=decode(&current_state_packets(&mut sender,over,7).unwrap(),ctx);
        assert_eq!(fallback.frame_ordinal,2);assert_eq!(fallback.clock_ordinal,7);
        assert_eq!(serde_json::to_value(&fallback.snapshot).unwrap(),serde_json::to_value(expected).unwrap());
        let mut invalid=ordinary.clone();invalid.attack_presentation_error=Some("x".repeat(session_wire::MAX_FRAME));
        assert!(current_state_packets(&mut sender,invalid,7).is_err());
        let next=decode(&current_state_packets(&mut sender,ordinary.clone(),7).unwrap(),ctx);
        assert_eq!(next.frame_ordinal,3);assert_eq!(next.snapshot.ezreal_w_current_missiles,ordinary.ezreal_w_current_missiles);
    }

}

#[cfg(test)]
#[path = "session_death_recap_tests.rs"]
mod death_recap_tests;
