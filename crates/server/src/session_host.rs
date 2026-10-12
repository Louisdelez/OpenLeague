//! Concrete local registry/Simulation/clock composition. UDP I/O stays in main.
//! No raw transport logging; returned messages containing capabilities are wire only.
use std::{collections::HashMap, net::SocketAddr, time::Duration};
use openleague_core::{Simulation, session_transport as t, session_wire};
use crate::{clock_delivery::Delivery, pause::Pause, reconnect::{self as r, Registry}};

#[cfg(test)]
#[path="session_host_tests.rs"]
mod tests;

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
            let snapshot = game.snapshot_for(route.context.player).ok_or("session participant missing from Simulation")?;
            let issued = delivery.issued(route.context.player).ok_or("session clock recipient missing")?;
            let packets = route.frames.encode(&snapshot, issued).map_err(|_| "session state exceeds framing contract")?;
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
