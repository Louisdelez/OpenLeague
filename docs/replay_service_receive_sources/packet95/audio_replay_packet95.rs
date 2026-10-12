//! LoL 4.20 packet 0x95: 58A6F2 -> 577E90 -> 5CC140.
//! The recipient virtual method is explicit; no gameplay handler is synthesized.
use crate::audio_announcer_object_lookup as lookup;
use crate::audio_announcer_registry_init::{self as init, Storage};
use crate::audio_replay_shared_pair as pair;

pub const GLOBAL_PAIR: u32 = 0x14c761c;
pub const SCRATCH_BYTES: u32 = 8;
#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Read(lookup::Error),
    Write(init::Error),
    Pair(pair::Error),
    Boundary(&'static str),
    AddressOverflow,
    Cleanup { cause: Box<Error>, cleanup: pair::Error },
}
impl From<lookup::Error> for Error { fn from(e: lookup::Error) -> Self { Self::Read(e) } }
impl From<init::Error> for Error { fn from(e: init::Error) -> Self { Self::Write(e) } }
impl From<pair::Error> for Error { fn from(e: pair::Error) -> Self { Self::Pair(e) } }
fn add(a: u32, n: u32) -> Result<u32, Error> { a.checked_add(n).ok_or(Error::AddressOverflow) }

pub trait Boundary: Storage + pair::Boundary {
    /// Native thiscall: ECX=recipient, one borrowed payload pointer, callee ret4.
    /// The return value is ignored. Payload validity belongs to the real handler.
    fn receive_payload(&mut self, recipient: u32, method: u32, payload: u32) -> Result<(), &'static str>;
}

/// Native5CC140 takes destination in ECX and ignores its one stack argument.
/// Unlike5CC070, it reads global object BEFORE control. It retains both across
/// disposal, increments before releasing the destination, then writes control
/// before object. Destination must already contain an owning pair or zeros.
pub fn acquire_global<B: Storage + pair::Boundary>(b: &mut B, destination: u32) -> Result<(), Error> {
    let object = b.word(GLOBAL_PAIR)?;
    let control = b.word(GLOBAL_PAIR + 4)?;
    if control != 0 { b.increment_reference(add(control, 4)?).map_err(Error::Boundary)?; }
    let old = b.word(add(destination, 4)?)?;
    pair::release_control(b, old)?;
    b.write_word(add(destination, 4)?, control)?;
    b.write_word(destination, object)?;
    Ok(())
}

/// Native577E90. Scratch is eight writable caller-owned bytes, disjoint from
/// globals, payload and live allocations. The global object is a wrapper: its
/// first word is the recipient, whose first virtual method receives payload.
/// After invocation, the temporary control is re-read and released, without
/// zeroing scratch. Explicit Rust boundary/read failures also release this
/// acquired reference; those failure paths are not an MSVC-unwinding port.
pub fn consume_payload<B: Boundary>(b: &mut B, payload: u32, scratch: u32) -> Result<(), Error> {
    b.write_word(scratch, 0)?;
    b.write_word(add(scratch, 4)?, 0)?;
    acquire_global(b, scratch)?;
    let invocation = (|| -> Result<(), Error> {
        let object = b.word(scratch)?;
        if object != 0 {
            let recipient = b.word(object)?;
            let table = b.word(recipient)?;
            let method = b.word(table)?;
            b.receive_payload(recipient, method, payload).map_err(Error::Boundary)?;
        }
        Ok(())
    })();
    let cleanup = pair::destroy(b, scratch);
    match (invocation, cleanup) {
        (Ok(()), Ok(())) => Ok(()),
        (Err(e), Ok(())) => Err(e),
        (Ok(()), Err(e)) => Err(Error::Pair(e)),
        (Err(cause), Err(cleanup)) => Err(Error::Cleanup { cause: Box::new(cause), cleanup }),
    }
}

/// The caller has selected588290's event0x95 branch. Source uses packet+5
/// for both ordinary and extended headers and returns AL1 on normal completion,
/// including an empty global pair. No payload bytes are read here.
pub fn consume_packet<B: Boundary>(b: &mut B, packet: u32, scratch: u32) -> Result<u8, Error> {
    consume_payload(b, add(packet, 5)?, scratch)?;
    Ok(1)
}

#[cfg(test)]
#[path = "audio_replay_packet95_tests.rs"]
mod tests;
