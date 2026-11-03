//! Local resumed-session state framing. Independent of the legacy OLST wire.
//! Every frame, including a short one, binds context plus a monotone ordinal.
use crate::session_transport::{Context, StateEnvelope};

const MAGIC: &[u8; 4] = b"OLSR";
const HEADER: usize = 40;
const CHUNK: usize = 1200 - HEADER;
pub const MAX_FRAME: usize = 1024 * 1024;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Error {
    Context, Exhausted, Length, Header, Stale, ConflictingFragment, Decode,
}

pub struct Sender { context: Context, last: u64 }
impl Sender {
    pub fn new(context: Context) -> Result<Self, Error> {
        if !context.valid() { return Err(Error::Context); }
        Ok(Self { context, last: 0 })
    }
    pub fn encode(&mut self, snapshot: &crate::Snapshot, clock_ordinal: u64) -> Result<Vec<Vec<u8>>, Error> {
        if snapshot.session != self.context.session { return Err(Error::Context); }
        let ordinal = self.last.checked_add(1).ok_or(Error::Exhausted)?;
        let frame = StateEnvelope { context: self.context, frame_ordinal: ordinal,
            clock_ordinal, snapshot: snapshot.clone() };
        let bytes = serde_json::to_vec(&frame).map_err(|_| Error::Decode)?;
        let datagrams = fragment(self.context, ordinal, &bytes)?;
        self.last = ordinal;
        Ok(datagrams)
    }
}

fn fragment(context: Context, ordinal: u64, payload: &[u8]) -> Result<Vec<Vec<u8>>, Error> {
    if !context.valid() || ordinal == 0 { return Err(Error::Context); }
    if payload.is_empty() || payload.len() > MAX_FRAME { return Err(Error::Length); }
    let count = payload.len().div_ceil(CHUNK);
    let mut packets = Vec::with_capacity(count);
    for (index, part) in payload.chunks(CHUNK).enumerate() {
        let mut bytes = Vec::with_capacity(HEADER + part.len());
        bytes.extend(MAGIC);
        bytes.extend(context.session.to_le_bytes());
        bytes.extend(context.player.to_le_bytes());
        bytes.extend(context.epoch.to_le_bytes());
        bytes.extend(ordinal.to_le_bytes());
        bytes.extend((index as u16).to_le_bytes());
        bytes.extend((count as u16).to_le_bytes());
        bytes.extend((payload.len() as u32).to_le_bytes());
        bytes.extend(part);
        packets.push(bytes);
    }
    Ok(packets)
}

pub struct Completed { context: Context, ordinal: u64, payload: Vec<u8> }
impl Completed {
    pub fn decode(self) -> Result<StateEnvelope, Error> {
        let state: StateEnvelope = serde_json::from_slice(&self.payload).map_err(|_| Error::Decode)?;
        if state.context != self.context || state.frame_ordinal != self.ordinal
            || state.snapshot.session != self.context.session {
            return Err(Error::Context);
        }
        Ok(state)
    }
}

/// One bounded assembly only; a newer frame retires an incomplete older frame.
/// Corruption poisons its ordinal. A later fragment cannot revive that frame.
pub struct Assembler {
    context: Context, floor: u64, closed: bool,
    length: usize, parts: Vec<Option<Vec<u8>>>,
}
impl Assembler {
    pub fn new(context: Context) -> Result<Self, Error> {
        if !context.valid() { return Err(Error::Context); }
        Ok(Self { context, floor: 0, closed: false, length: 0, parts: Vec::new() })
    }
    pub fn push(&mut self, bytes: &[u8]) -> Result<Option<Completed>, Error> {
        if bytes.len() < HEADER || bytes.len() > 1200 || &bytes[..4] != MAGIC { return Err(Error::Header); }
        let context = Context {
            session: u64::from_le_bytes(bytes[4..12].try_into().unwrap()),
            player: u32::from_le_bytes(bytes[12..16].try_into().unwrap()),
            epoch: u64::from_le_bytes(bytes[16..24].try_into().unwrap()),
        };
        if context != self.context { return Err(Error::Context); }
        let ordinal = u64::from_le_bytes(bytes[24..32].try_into().unwrap());
        let index = u16::from_le_bytes(bytes[32..34].try_into().unwrap()) as usize;
        let count = u16::from_le_bytes(bytes[34..36].try_into().unwrap()) as usize;
        let length = u32::from_le_bytes(bytes[36..40].try_into().unwrap()) as usize;
        if length == 0 || length > MAX_FRAME || count != length.div_ceil(CHUNK) || index >= count {
            return Err(Error::Length);
        }
        if bytes.len() != HEADER + (length - index * CHUNK).min(CHUNK) { return Err(Error::Length); }
        if ordinal == 0 || ordinal < self.floor || (ordinal == self.floor && self.closed) { return Err(Error::Stale); }
        if ordinal > self.floor {
            self.floor = ordinal; self.closed = false; self.length = length;
            self.parts = vec![None; count];
        }
        if self.length != length || self.parts.len() != count {
            self.closed = true; self.parts.clear(); return Err(Error::ConflictingFragment);
        }
        let part = &bytes[HEADER..];
        if let Some(previous) = &self.parts[index] {
            if previous != part {
                self.closed = true; self.parts.clear(); return Err(Error::ConflictingFragment);
            }
            return Ok(None);
        }
        self.parts[index] = Some(part.to_vec());
        if self.parts.iter().any(Option::is_none) { return Ok(None); }
        let mut payload = Vec::with_capacity(length);
        for part in &mut self.parts { payload.extend(part.take().expect("all fragments present")); }
        self.parts.clear(); self.closed = true;
        Ok(Some(Completed { context, ordinal, payload }))
    }
}

#[cfg(test)] mod tests {
    use super::*;
    fn context() -> Context { Context { session: 19, player: 21, epoch: 3 } }
    #[test] fn same_tick_equal_and_different_lengths_cannot_mix_between_ordinals() {
        // Controlled serialized payloads at one simulation tick; no game execution.
        for length in [5000, 6400] {
            let one = [br#"{"tick":77,"data":""#.as_slice(), &vec![b'A'; 4960], br#""}"#].concat();
            let two = [br#"{"tick":77,"data":""#.as_slice(), &vec![b'B'; length - 40], br#""}"#].concat();
            let a = fragment(context(), 1, &one).unwrap(); let b = fragment(context(), 2, &two).unwrap();
            let mut state = Assembler::new(context()).unwrap();
            assert!(state.push(&a[0]).unwrap().is_none()); assert!(state.push(&b[0]).unwrap().is_none());
            for part in &a[1..] { assert!(matches!(state.push(part), Err(Error::Stale))); }
            let mut done = None;
            for part in b[1..].iter().rev() { if let Some(value) = state.push(part).unwrap() { done = Some(value); } }
            assert_eq!(done.unwrap().payload, two);
            assert!(matches!(state.push(&b[0]), Err(Error::Stale)));
        }
    }
    #[test] fn foreign_epoch_player_or_session_never_mutates_current_assembly() {
        let payload = vec![7; 3000]; let own = fragment(context(), 1, &payload).unwrap();
        let mut state = Assembler::new(context()).unwrap(); state.push(&own[0]).unwrap();
        for context in [Context { epoch: 2, ..context() }, Context { player: 22, ..context() }, Context { session: 20, ..context() }] {
            for part in fragment(context, 100, &payload).unwrap() { assert!(matches!(state.push(&part), Err(Error::Context))); }
        }
        assert!(state.push(&own[1]).unwrap().is_none());
        assert_eq!(state.push(&own[2]).unwrap().unwrap().payload, payload);
    }
    #[test] fn conflicting_duplicates_poison_ordinal_but_identical_duplicates_are_safe() {
        let packets = fragment(context(), 1, &vec![7; 3000]).unwrap();
        let mut state = Assembler::new(context()).unwrap(); state.push(&packets[0]).unwrap();
        assert!(state.push(&packets[0]).unwrap().is_none());
        let mut changed = packets[0].clone(); changed[HEADER] ^= 1;
        assert!(matches!(state.push(&changed), Err(Error::ConflictingFragment)));
        for part in &packets { assert!(matches!(state.push(part), Err(Error::Stale))); }
        let new = fragment(context(), 2, b"next").unwrap();
        assert_eq!(state.push(&new[0]).unwrap().unwrap().payload, b"next");
    }
    #[test] fn short_frames_are_also_bound_and_malformed_sizes_never_allocate() {
        let mut state = Assembler::new(context()).unwrap();
        assert!(matches!(state.push(b"{}"), Err(Error::Header)));
        let good = fragment(context(), 1, b"{}").unwrap(); let mut bad = good[0].clone();
        bad[36..40].copy_from_slice(&u32::MAX.to_le_bytes());
        assert!(matches!(state.push(&bad), Err(Error::Length))); assert_eq!(state.floor, 0); assert!(state.parts.is_empty());
        assert!(state.push(&good[0]).unwrap().unwrap().decode().is_err());
        assert!(matches!(state.push(&good[0]), Err(Error::Stale)));
        assert!(fragment(context(), 0, b"{}").is_err()); assert!(fragment(context(), 1, &vec![0; MAX_FRAME + 1]).is_err());
    }
}
