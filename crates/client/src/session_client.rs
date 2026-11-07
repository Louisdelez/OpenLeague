//! Local resume receive/handshake state. Does not mutate Bevy or sample clocks.
//! Socket/EffectClock/UI integration must honor the returned reset and barrier.
use std::collections::VecDeque;
use openleague_core::{session_transport as t, session_wire};

const MAX_WAITING_STATES: usize = 32;
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ContextOutcome { Waiting, ResumePrepared, Retired }
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum WelcomeOutcome { Duplicate, ResetClock(t::Context) }

pub struct Client {
    original: t::JoinRequest,
    known: Option<t::Context>,
    pending: Option<t::ClientMessage>,
    current: Option<t::Welcome>,
    sequence: u64,
    assembly: Option<session_wire::Assembler>,
    barrier: Option<t::BootstrapBarrier>,
    waiting: VecDeque<t::StateEnvelope>,
    delivered: u64,
    observation_batch: Vec<u64>,
    presented: u64,
    failed: Option<&'static str>,
}

#[cfg(test)]
#[path = "session_client_tests.rs"]
mod tests;
impl Client {
    /// recover=true is for another socket/client of the SAME owned server Run.
    /// The caller supplies a fresh OS nonce; tests supply labeled deterministic values.
    pub fn new(original: t::JoinRequest, recover: bool, nonce: t::RequestNonce) -> Result<Self, &'static str> {
        if original.version != t::VERSION || !original.request_nonce.valid()
            || original.champion.is_empty() || original.champion.len() > 64 {
            return Err("invalid private session bootstrap");
        }
        let mut client = Self { pending: Some(t::ClientMessage::JoinResumable(original.clone())), original,
            known: None, current: None, sequence: 0, assembly: None, barrier: None,
            waiting: VecDeque::new(), delivered: 0, observation_batch: Vec::new(), presented: 0, failed: None };
        if recover { client.recover(nonce)?; }
        Ok(client)
    }
    pub fn pending_request(&self) -> Option<&t::ClientMessage> { self.pending.as_ref() }
    pub fn context(&self) -> Option<t::Context> { self.current.as_ref().map(|w| w.context) }
    pub fn known_context(&self) -> Option<t::Context> { self.known }
    pub fn failure(&self) -> Option<&'static str> { self.failed }
    /// Only fully validated states advance this value. Late/duplicate chunks
    /// must not be mistaken for new server activity by the socket supervisor.
    pub fn received_frame_ordinal(&self)->u64 {
        self.waiting.back().map_or(self.delivered,|frame|frame.frame_ordinal)
    }
    pub fn ready(&self) -> bool {
        self.failed.is_none() && self.pending.is_none() && self.presented != 0
            && self.presented == self.delivered && self.barrier.as_ref().is_some_and(t::BootstrapBarrier::ready)
    }
    /// Read-only admission for the exact frame currently being observed by receive.
    /// Inputs and physical presentation still require ready() after snapshot commit.
    /// Membership is the bounded batch actually returned by take_ready_states, not
    /// the numeric range up to delivered (UDP can skip arbitrary frame ordinals).
    pub fn observation_ready(&self, context: t::Context, frame: u64) -> bool {
        self.failed.is_none() && self.pending.is_none() && self.context() == Some(context)
            && frame != 0 && frame > self.presented
            && self.observation_batch.contains(&frame)
            && self.barrier.as_ref().is_some_and(t::BootstrapBarrier::ready)
    }
    pub fn recover(&mut self, nonce: t::RequestNonce) -> Result<(), &'static str> {
        if !nonce.valid() { return Err("invalid recovery request nonce"); }
        self.pending = Some(t::ClientMessage::ContextQuery(t::ContextRequest { version: t::VERSION,
            expected_session: self.known.map(|c| c.session), recovery_key: self.original.recovery_key.clone(), request_nonce: nonce }));
        self.current = None; self.assembly = None; self.barrier = None; self.waiting.clear();
        self.delivered = 0; self.observation_batch.clear(); self.presented = 0; self.failed = None; Ok(())
    }
    pub fn context_response(&mut self, response: &t::ContextResponse, resume_nonce: t::RequestNonce) -> Result<ContextOutcome, &'static str> {
        let Some(t::ClientMessage::ContextQuery(request)) = self.pending.as_ref() else { return Err("unsolicited session context"); };
        if response.request_nonce != request.request_nonce || !response.context.valid()
            || request.expected_session.is_some_and(|s| s != response.context.session)
            || self.known.is_some_and(|old| old.session != response.context.session || old.player != response.context.player
                || old.epoch > response.context.epoch) {
            return Err("foreign or stale session context");
        }
        if response.availability == t::Availability::Detached && (!resume_nonce.valid() || resume_nonce == request.request_nonce) {
            return Err("invalid resume request nonce");
        }
        self.known = Some(response.context);
        match response.availability {
            t::Availability::Busy => Ok(ContextOutcome::Waiting),
            t::Availability::Detached => {
                self.pending = Some(t::ClientMessage::Resume(t::ResumeRequest { version: t::VERSION,
                    expected: response.context, recovery_key: self.original.recovery_key.clone(), request_nonce: resume_nonce }));
                Ok(ContextOutcome::ResumePrepared)
            }
            t::Availability::Retired | t::Availability::Closing => {
                self.pending = None; self.failed = Some("session recovery was revoked"); Ok(ContextOutcome::Retired)
            }
        }
    }
    pub fn welcome(&mut self, welcome: t::Welcome) -> Result<WelcomeOutcome, &'static str> {
        let barrier = t::BootstrapBarrier::new(&welcome)?;
        if self.pending.is_none() {
            if self.current.as_ref().is_some_and(|old| old.context == welcome.context
                && old.request_nonce == welcome.request_nonce && old.access_key == welcome.access_key
                && old.next_sequence == welcome.next_sequence && old.bootstrap == welcome.bootstrap) {
                return Ok(WelcomeOutcome::Duplicate);
            }
            return Err("unsolicited session welcome");
        }
        let matched = match self.pending.as_ref().unwrap() {
            t::ClientMessage::JoinResumable(request) => welcome.request_nonce == request.request_nonce && welcome.context.epoch == 1
                && self.known.is_none(),
            t::ClientMessage::Resume(request) => welcome.request_nonce == request.request_nonce
                && welcome.context.session == request.expected.session && welcome.context.player == request.expected.player
                && request.expected.epoch.checked_add(1) == Some(welcome.context.epoch),
            _ => false,
        };
        if !matched { return Err("welcome does not match pending handshake"); }
        let assembly = session_wire::Assembler::new(welcome.context).map_err(|_| "invalid welcome context")?;
        self.sequence = welcome.next_sequence - 1;
        self.known = Some(welcome.context); self.pending = None;
        self.assembly = Some(assembly); self.barrier = Some(barrier); self.waiting.clear();
        self.delivered = 0; self.observation_batch.clear(); self.presented = 0; self.failed = None;
        let context = welcome.context; self.current = Some(welcome);
        Ok(WelcomeOutcome::ResetClock(context))
    }
    pub fn rejection(&mut self, rejection: &t::Rejection, next_nonce: t::RequestNonce) -> Result<(), &'static str> {
        let nonce = match self.pending.as_ref() {
            Some(t::ClientMessage::JoinResumable(r)) => r.request_nonce,
            Some(t::ClientMessage::Resume(r)) => r.request_nonce,
            Some(t::ClientMessage::ContextQuery(r)) => r.request_nonce,
            _ => return Err("unsolicited handshake rejection"),
        };
        if rejection.request_nonce != Some(nonce) { return Err("stale handshake rejection"); }
        match rejection.reason {
            t::RejectionCode::Busy => Ok(()),
            t::RejectionCode::StaleEpoch | t::RejectionCode::ReplayExpired => self.recover(next_nonce),
            _ => {
                self.failed = Some("session handshake rejected; no automatic new participant");
                self.pending = None; Ok(())
            }
        }
    }
    pub fn frame(&mut self, bytes: &[u8]) -> Result<(), &'static str> {
        if self.failed.is_some() { return Err("session transport is failed"); }
        let assembly = self.assembly.as_mut().ok_or("state before session welcome")?;
        let frame=match assembly.push(bytes){
            Ok(frame)=>frame,
            // Ordinary UDP duplicates/late fragments are not transport failure.
            Err(session_wire::Error::Stale)=>return Ok(()),
            Err(_)=>return Err("session state fragment rejected"),
        };
        let Some(frame)=frame else{return Ok(());};
        let frame = frame.decode().map_err(|_| "session state body rejected")?;
        if !frame.snapshot.players.iter().any(|p| p.id == frame.context.player) { return Err("own player missing from session state"); }
        if self.waiting.len() >= MAX_WAITING_STATES {
            self.failed = Some("session clock bootstrap state queue full");
            return Err("session clock bootstrap state queue full");
        }
        self.barrier.as_mut().ok_or("state barrier missing")?.observe_state(frame.context, frame.frame_ordinal, frame.clock_ordinal)?;
        self.waiting.push_back(frame); Ok(())
    }
    /// Validate before calling EffectClock.receive. The ordinal is applied only
    /// by clock_applied after that real call succeeded, never at mere receipt.
    pub fn validate_clock(&self, clock: &t::ClockEnvelope) -> Result<(), &'static str> {
        if self.context() != Some(clock.context) || clock.ordinal == 0 || self.failed.is_some() {
            return Err("foreign session clock directive");
        }
        Ok(())
    }
    pub fn clock_applied(&mut self, context: t::Context, acknowledged_ordinal: u64) -> Result<Option<t::ClientMessage>, &'static str> {
        self.barrier.as_mut().ok_or("clock barrier missing")?.observe_clock(context, acknowledged_ordinal)?;
        if acknowledged_ordinal == 0 { return Ok(None); }
        // Repeated directives require a NEW input sequence for the cumulative
        // ACK: an older ACK may have been lost before a newer Heartbeat arrived.
        self.input(t::Input::ClockAck { ordinal: acknowledged_ordinal }).map(Some)
    }
    pub fn take_ready_states(&mut self) -> Vec<t::StateEnvelope> {
        // Each drain, including an empty one, retires the previous observation
        // batch. Main drains only after its local returned-frame queue is empty.
        self.observation_batch.clear();
        if self.failed.is_some() || !self.barrier.as_ref().is_some_and(t::BootstrapBarrier::ready) { return Vec::new(); }
        let states: Vec<_> = self.waiting.drain(..).collect();
        if let Some(last) = states.last() { self.delivered = last.frame_ordinal; }
        self.observation_batch = states.iter().map(|state| state.frame_ordinal).collect();
        states
    }
    /// Call only after the actual main receive path accepted this state (all
    /// gameplay/presentation validation and snapshot commit have succeeded).
    pub fn presented(&mut self, context: t::Context, frame: u64) -> Result<(), &'static str> {
        if self.context() != Some(context) || frame == 0 || frame > self.delivered || frame < self.presented {
            return Err("invalid presented session frame");
        }
        self.presented = frame;
        self.observation_batch.retain(|ordinal| *ordinal > frame);
        Ok(())
    }
    pub fn input(&mut self, input: t::Input) -> Result<t::ClientMessage, &'static str> {
        if self.failed.is_some() { return Err("session transport is failed"); }
        if matches!(&input, t::Input::Command(_) | t::Input::PauseRequest { .. }) && !self.ready() {
            return Err("session bootstrap is not ready");
        }
        let welcome = self.current.as_ref().ok_or("session endpoint is not attached")?;
        let sequence = self.sequence.checked_add(1).ok_or("session input sequence exhausted")?;
        let message = t::ClientMessage::Session(t::SessionInput { version: t::VERSION, context: welcome.context,
            access_key: welcome.access_key.clone(), sequence, input });
        self.sequence = sequence; Ok(message)
    }
}
