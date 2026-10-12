//! Additive local authenticated-session types. Not the historical Riot protocol.
//! Legacy packets and OLST remain unchanged until their explicit host integration.
use crate::{Action, Snapshot, summoners};
use serde::{Deserialize, Deserializer, Serialize};
use std::fmt;

pub const VERSION: u16 = 1;

/// Capability bytes are serialized only for transport. Never serialize a whole
/// packet to a log; use public_log(). Debug deliberately cannot expose the key.
/// This type does not promise memory zeroization or protection against OS dumps.
#[derive(Clone, Serialize)]
#[serde(transparent)]
pub struct Secret32([u8; 32]);
impl Secret32 {
    pub fn from_bytes(bytes: [u8; 32]) -> Result<Self, &'static str> {
        if bytes == [0; 32] { return Err("zero session capability"); }
        Ok(Self(bytes))
    }
}
impl PartialEq for Secret32 {
    fn eq(&self, other: &Self) -> bool {
        // Fixed-size source-level comparison; not a formal constant-time claim.
        self.0.iter().zip(other.0.iter()).fold(0u8, |d, (a,b)| d | (a ^ b)) == 0
    }
}
impl Eq for Secret32 {}
impl fmt::Debug for Secret32 {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result { f.write_str("Secret32(<redacted>)") }
}
impl<'de> Deserialize<'de> for Secret32 {
    fn deserialize<D: Deserializer<'de>>(d: D) -> Result<Self, D::Error> {
        Self::from_bytes(<[u8;32]>::deserialize(d)?).map_err(serde::de::Error::custom)
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Serialize, Deserialize)]
#[serde(transparent)]
pub struct RequestNonce(pub [u8; 16]);
impl RequestNonce { pub fn valid(self) -> bool { self.0 != [0;16] } }

#[derive(Clone, Copy, Debug, PartialEq, Eq, Serialize, Deserialize)]
pub struct Context { pub session: u64, pub player: u32, pub epoch: u64 }
impl Context {
    pub fn valid(self) -> bool { self.session != 0 && self.player != 0 && self.epoch != 0 }
}

#[derive(Clone, Debug, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct JoinRequest {
    pub version: u16, pub champion: String, pub summoners: [Option<summoners::Spell>;2],
    pub recovery_key: Secret32, pub request_nonce: RequestNonce,
}
#[derive(Clone, Debug, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ResumeRequest {
    pub version: u16, pub expected: Context,
    pub recovery_key: Secret32, pub request_nonce: RequestNonce,
}

/// Authenticated recovery of public context after an ambiguous Welcome delivery.
/// None is reserved for a credential issued for this same owned server before
/// its first accepted Welcome. It never authorizes replacing a known session.
#[derive(Clone, Debug, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ContextRequest {
    pub version: u16, pub expected_session: Option<u64>,
    pub recovery_key: Secret32, pub request_nonce: RequestNonce,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq, Serialize, Deserialize)]
pub enum Availability { Busy, Detached, Retired, Closing }
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct ContextResponse {
    pub request_nonce: RequestNonce, pub context: Context, pub availability: Availability,
}
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct GameplayRejection { pub context: Context, pub sequence: u64, pub reason: String }

#[derive(Clone, Debug, Serialize, Deserialize)]
pub enum Input {
    Command(Action), PauseRequest { paused: bool },
    ClockAck { ordinal: u64 }, Heartbeat, Leave,
}
#[derive(Clone, Debug, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct SessionInput {
    pub version: u16, pub context: Context, pub access_key: Secret32,
    /// All input classes, including Heartbeat/ACK, share this fresh sequence.
    pub sequence: u64, pub input: Input,
}
#[derive(Clone, Debug, Serialize, Deserialize)]
pub enum ClientMessage {
    JoinResumable(JoinRequest), Resume(ResumeRequest), Session(SessionInput),
    ContextQuery(ContextRequest),
}

/// Required result of preparing the *new* clock-delivery recipient.
/// Host integration must derive this from its actual staged queue, not guess it.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Serialize, Deserialize)]
pub enum ClockBootstrap { Running, Paused { through_ordinal: u64 } }
impl ClockBootstrap {
    pub fn required_ordinal(self) -> Result<u64, &'static str> {
        match self {
            Self::Running => Ok(0),
            Self::Paused { through_ordinal: 0 } => Err("paused bootstrap has no clock directive"),
            Self::Paused { through_ordinal } => Ok(through_ordinal),
        }
    }
}
#[derive(Clone, Debug, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Welcome {
    pub version: u16, pub context: Context, pub request_nonce: RequestNonce,
    pub access_key: Secret32, pub next_sequence: u64, pub bootstrap: ClockBootstrap,
}
impl Welcome {
    pub fn public_log(&self) -> serde_json::Value {
        serde_json::json!({"type":"SessionWelcome","version":self.version,
            "context":self.context,"request_nonce":self.request_nonce,
            "next_sequence":self.next_sequence,"bootstrap":self.bootstrap})
    }
}
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct StateEnvelope {
    pub context: Context,
    /// Distinct from simulation tick: paused same-tick payloads can differ.
    pub frame_ordinal: u64,
    /// Recipient clock ordinal required before displaying this state.
    pub clock_ordinal: u64,
    pub snapshot: Snapshot,
}
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct ClockEnvelope { pub context: Context, pub ordinal: u64, pub opcode: u16, pub payload: Vec<u8> }
#[derive(Clone, Copy, Debug, PartialEq, Eq, Serialize, Deserialize)]
pub enum RejectionCode {
    UnsupportedVersion, InvalidRequest, UnknownLease, Retired, Busy,
    StaleEpoch, ReplayExpired, Closing, Unauthorized, StaleSequence, Capacity, Unavailable,
}
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Rejection {
    pub request_nonce: Option<RequestNonce>,
    /// Expose an updated context only after authenticating its recovery key.
    pub context: Option<Context>, pub reason: RejectionCode,
}
#[derive(Clone, Debug, Serialize, Deserialize)]
pub enum ServerMessage {
    SessionWelcome(Welcome), SessionState(StateEnvelope),
    SessionClockControl(ClockEnvelope), SessionRejected(Rejection),
    SessionContext(ContextResponse),
    SessionGameplayRejected(GameplayRejection),
}
impl ClientMessage {
    pub fn public_log(&self) -> serde_json::Value {
        match self {
            Self::JoinResumable(r) => serde_json::json!({"type":"JoinResumable","version":r.version,
                "champion":r.champion,"summoners":r.summoners,"request_nonce":r.request_nonce}),
            Self::Resume(r) => serde_json::json!({"type":"Resume","version":r.version,
                "context":r.expected,"request_nonce":r.request_nonce}),
            Self::Session(r) => serde_json::json!({"type":"SessionInput","version":r.version,
                "context":r.context,"sequence":r.sequence,"input":r.input}),
            Self::ContextQuery(r) => serde_json::json!({"type":"ContextQuery","version":r.version,
                "expected_session":r.expected_session,"request_nonce":r.request_nonce}),
        }
    }
}
impl ServerMessage {
    pub fn public_log(&self) -> serde_json::Value {
        match self {
            Self::SessionWelcome(w) => w.public_log(),
            Self::SessionState(s) => serde_json::json!({"type":"SessionState","context":s.context,
                "frame_ordinal":s.frame_ordinal,"clock_ordinal":s.clock_ordinal,"tick":s.snapshot.tick}),
            Self::SessionClockControl(c) => serde_json::json!({"type":"SessionClockControl","context":c.context,
                "ordinal":c.ordinal,"opcode":c.opcode,"payload_bytes":c.payload.len()}),
            Self::SessionRejected(r) => serde_json::json!({"type":"SessionRejected","request_nonce":r.request_nonce,
                "context":r.context,"reason":r.reason}),
            Self::SessionContext(r) => serde_json::json!({"type":"SessionContext","request_nonce":r.request_nonce,
                "context":r.context,"availability":r.availability}),
            Self::SessionGameplayRejected(r) => serde_json::json!({"type":"SessionGameplayRejected",
                "context":r.context,"sequence":r.sequence,"reason":r.reason}),
        }
    }
}

/// Pure bootstrap barrier. Does not apply a native directive or sample time.
/// Host must only observe_clock after EffectClock actually applied that ordinal.
#[derive(Clone, Debug)]
pub struct BootstrapBarrier {
    context: Context, required: u64, applied: u64, frame: Option<u64>,
}
impl BootstrapBarrier {
    pub fn new(w: &Welcome) -> Result<Self, &'static str> {
        if w.version != VERSION || !w.context.valid() || !w.request_nonce.valid() || w.next_sequence == 0 {
            return Err("invalid session welcome");
        }
        Ok(Self { context:w.context,required:w.bootstrap.required_ordinal()?,applied:0,frame:None })
    }
    pub fn observe_state(&mut self, context: Context, frame: u64, clock_ordinal: u64) -> Result<(), &'static str> {
        if context != self.context { return Err("foreign state context"); }
        if frame == 0 || self.frame.is_some_and(|old| frame <= old) { return Err("stale state frame"); }
        self.required = self.required.max(clock_ordinal); self.frame = Some(frame); Ok(())
    }
    pub fn observe_clock(&mut self, context: Context, applied: u64) -> Result<(), &'static str> {
        if context != self.context { return Err("foreign clock context"); }
        self.applied = self.applied.max(applied); Ok(())
    }
    pub fn ready(&self) -> bool { self.frame.is_some() && self.applied >= self.required }
}

#[cfg(test)] mod tests {
    use super::*;
    fn key() -> Secret32 { Secret32::from_bytes([213;32]).unwrap() }
    fn welcome() -> Welcome { Welcome { version:VERSION,context:Context{session:7,player:3,epoch:2},
        request_nonce:RequestNonce([4;16]),access_key:key(),next_sequence:19,
        bootstrap:ClockBootstrap::Paused{through_ordinal:1} } }
    #[test] fn secret_wire_roundtrip_but_debug_and_public_logs_are_redacted() {
        let w=welcome();let encoded=serde_json::to_vec(&w).unwrap();
        let back:Welcome=serde_json::from_slice(&encoded).unwrap();assert_eq!(back.access_key,w.access_key);
        let msg=ClientMessage::Resume(ResumeRequest{version:VERSION,expected:w.context,
            recovery_key:key(),request_nonce:RequestNonce([4;16])});
        let input=ClientMessage::Session(SessionInput{version:VERSION,context:w.context,
            access_key:key(),sequence:19,input:Input::Heartbeat});
        let join=ClientMessage::JoinResumable(JoinRequest{version:VERSION,champion:"garen".into(),
            summoners:[None,None],recovery_key:key(),request_nonce:RequestNonce([4;16])});
        for text in [format!("{w:?}"),format!("{msg:?}"),w.public_log().to_string(),msg.public_log().to_string(),
            format!("{input:?}"),input.public_log().to_string(),format!("{join:?}"),join.public_log().to_string(),
            ServerMessage::SessionWelcome(w).public_log().to_string()] {
            assert!(!text.contains("213"));assert!(!text.contains("[213"));
        }
        assert!(format!("{:?}",key()).contains("redacted"));
    }
    #[test] fn malformed_capability_lengths_and_zero_are_rejected_without_echoing_bytes() {
        for n in [0,31,33] {assert!(serde_json::from_str::<Secret32>(&serde_json::to_string(&vec![213;n]).unwrap()).is_err());}
        let error=serde_json::from_str::<Secret32>(&serde_json::to_string(&vec![0;32]).unwrap()).unwrap_err();
        assert!(error.to_string().contains("zero session capability"));
    }
    #[test] fn paused_welcome_requires_both_fresh_state_and_applied_clock() {
        let w=welcome();let mut b=BootstrapBarrier::new(&w).unwrap();assert!(!b.ready());
        b.observe_state(w.context,1,1).unwrap();assert!(!b.ready());
        let wrong=Context{epoch:3,..w.context};assert!(b.observe_clock(wrong,99).is_err());assert!(!b.ready());
        b.observe_clock(w.context,1).unwrap();assert!(b.ready());
        b.observe_state(w.context,2,2).unwrap();assert!(!b.ready());
        assert!(b.observe_state(w.context,1,0).is_err());assert!(!b.ready());
        b.observe_clock(w.context,2).unwrap();assert!(b.ready());
        b.observe_clock(w.context,1).unwrap();assert!(b.ready());
    }
    #[test] fn running_bootstrap_still_needs_state_and_rejects_invalid_paused_marker() {
        let mut w=welcome();w.bootstrap=ClockBootstrap::Running;
        let mut b=BootstrapBarrier::new(&w).unwrap();assert!(!b.ready());
        b.observe_state(w.context,1,0).unwrap();assert!(b.ready());
        w.bootstrap=ClockBootstrap::Paused{through_ordinal:0};assert!(BootstrapBarrier::new(&w).is_err());
    }
    #[test] fn additive_messages_leave_legacy_json_unchanged() {
        let legacy=crate::ClientPacket::Join{champion:"garen".into(),summoners:[None,None]};
        assert_eq!(serde_json::to_value(legacy).unwrap(),serde_json::json!({"Join":{"champion":"garen","summoners":[null,null]}}));
        assert!(serde_json::from_value::<ClientMessage>(serde_json::json!({"Join":{"champion":"garen"}})).is_err());
    }
}
