//! Native loading-screen packet consumers57D650 (standard) and5B3230 (tutorial).
//! Record lookup/insertion is real. Service names, clock and the remaining
//! standard-screen UI continuation have explicit boundaries, never fake success.
use crate::audio_announcer_registry_init::Storage;
use crate::audio_loading_record_tree::{self as tree, Kind};
pub use crate::audio_replay_metadata::Error;
pub const SERVICE_GLOBAL: u32 = 0x2d787b8;
pub const PAYLOAD_BYTES: u32 = 25;
pub const TUTORIAL_SCRATCH_BYTES: u32 = 24;

pub trait Boundary: tree::Boundary {
    /// Service virtual+48, source72AD90: constructs a fresh String24 at out.
    /// The key is passed by value. On error the boundary owns its rollback;
    /// on success this consumer owns the returned string until564900 cleanup.
    fn service_name(
        &mut self,
        service: u32,
        target: u32,
        out24: u32,
        key_value: u32,
    ) -> Result<(), &'static str>;
    /// Source993CE0 ST0 rounded by the caller's FSTP f32; exact stored bits.
    fn clock_f32_bits(&mut self) -> Result<u32, &'static str>;
    /// Remaining native57D6CB..57DCE6 UI initialization. The25-byte record
    /// update has already happened. No success is supplied by default.
    fn initialize_standard_record(
        &mut self,
        _recipient: u32,
        _record: u32,
        _payload: u32,
        _scratch: u32,
    ) -> Result<(), &'static str> {
        Err("native loading-screen UI continuation57D6CB is not connected")
    }
}
fn add(a: u32, n: u32) -> Result<u32, Error> {
    a.checked_add(n).ok_or(Error::AddressOverflow)
}
fn word(b: &mut impl Boundary, p: u32, n: u32) -> Result<u32, Error> {
    Ok(b.word(add(p, n)?)?)
}
fn put(b: &mut impl Boundary, p: u32, n: u32, v: u32) -> Result<(), Error> {
    Ok(Storage::write_word(b, add(p, n)?, v)?)
}

// FLD f32 / FSTP f32 under the native masked exception mode preserves every
// finite, infinity and zero bit; signaling NaNs acquire the quiet bit. The
// caller oracle includes signs, subnormals and quiet NaNs. A separate physical
// x87 oracle qualifies signaling NaNs (Unicorn does not quiet them correctly).
fn x87_f32_roundtrip(bits: u32) -> u32 {
    if bits & 0x7f800000 == 0x7f800000 && bits & 0x007fffff != 0 {
        bits | 0x00400000
    } else {
        bits
    }
}
fn destroy_string(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    if word(b, p, 20)? >= 16 {
        //564900 reads the deallocation route before the buffer pointer.
        let route = b.deallocator()?;
        let raw = b.word(p)?;
        b.free(raw, route)?;
    }
    put(b, p, 20, 15)?;
    put(b, p, 16, 0)?;
    b.write_byte(p, 0)?;
    Ok(())
}
fn finish(primary: Result<(), Error>, cleanup: Result<(), Error>) -> Result<(), Error> {
    match (primary, cleanup) {
        (Ok(()), Ok(())) => Ok(()),
        (Err(e), Ok(())) | (Ok(()), Err(e)) => Err(e),
        (Err(primary), Err(cleanup)) => Err(Error::Cleanup {
            primary: Box::new(primary),
            cleanup: Box::new(cleanup),
        }),
    }
}
/// Payload must expose25 readable bytes. Fresh scratchString24 is only used by
/// the tutorial's first-name lookup. The caller must keep it disjoint from the
/// recipient, record tree, payload and live allocations. Standard scratch is
/// interpreted exclusively by its explicit UI continuation boundary.
pub fn receive(
    b: &mut impl Boundary,
    kind: Kind,
    recipient: u32,
    payload: u32,
    scratch: u32,
) -> Result<(), Error> {
    let tree_offset = match kind {
        Kind::Standard => 0x1c,
        Kind::Tutorial => 4,
    };
    let record = tree::record_slot(b, kind, add(recipient, tree_offset)?, payload)?;
    // Native REP MOVSD then MOVSB, ordered read/write pairs (no bulk snapshot).
    for offset in (0..24).step_by(4) {
        let value = word(b, payload, offset)?;
        put(b, record, offset, value)?;
    }
    let flag = b.read_byte(add(payload, 24)?)?;
    b.write_byte(add(record, 24)?, flag)?;
    if b.read_byte(add(record, 24)?)? & 1 != 0 {
        put(b, record, 16, 0)?;
    }
    let length_offset = match kind {
        Kind::Standard => 0x40,
        Kind::Tutorial => 0x38,
    };
    if word(b, record, length_offset)? != 0 {
        return Ok(());
    }
    if matches!(kind, Kind::Standard) {
        return b
            .initialize_standard_record(recipient, record, payload, scratch)
            .map_err(Error::Boundary);
    }
    let key = b.word(payload)?;
    let service = b.word(SERVICE_GLOBAL)?;
    let table = b.word(service)?;
    let target = word(b, table, 0x48)?;
    b.service_name(service, target, scratch, key)
        .map_err(Error::Boundary)?;
    let primary = (|| -> Result<(), Error> {
        if word(b, scratch, 16)? != 0 {
            let value = word(b, record, 16)?;
            put(b, record, 0x44, x87_f32_roundtrip(value))?;
            let value = word(b, record, 12)?;
            put(b, record, 0x40, x87_f32_roundtrip(value))?;
            let clock = b.clock_f32_bits().map_err(Error::Boundary)?;
            put(b, record, 0x48, clock)?;
        }
        Ok(())
    })();
    let cleanup = destroy_string(b, scratch);
    finish(primary, cleanup)
}

#[cfg(test)]
#[path = "audio_loading_screen_packet_tests.rs"]
mod tests;
