//! Native shared pair5CC070/5BD3C0 and replay accessors738AC0/729CF0.
use crate::audio_announcer_object_lookup::{self as lookup, Memory};
use crate::audio_announcer_owner_component_destructor::ControlBoundary;
use crate::audio_announcer_registry_init::{self as init, Storage};
#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Read(lookup::Error),
    Write(init::Error),
    Boundary(&'static str),
    AddressOverflow,
}
impl From<lookup::Error> for Error {
    fn from(e: lookup::Error) -> Self {
        Self::Read(e)
    }
}
impl From<init::Error> for Error {
    fn from(e: init::Error) -> Self {
        Self::Write(e)
    }
}
fn add(a: u32, b: u32) -> Result<u32, Error> {
    a.checked_add(b).ok_or(Error::AddressOverflow)
}
pub trait Boundary: ControlBoundary {
    /// Atomic fetch-add; returns the previous value, preserving native wrapping.
    fn increment_reference(&mut self, address: u32) -> Result<u32, &'static str>;
}
pub(crate) fn release_control<B: Memory + ControlBoundary>(
    b: &mut B,
    control: u32,
) -> Result<(), Error> {
    if control != 0
        && b.decrement_reference(add(control, 4)?)
            .map_err(Error::Boundary)?
            == 1
    {
        let vt = b.word(control)?;
        let callback = b.word(vt)?;
        b.dispose(control, callback).map_err(Error::Boundary)?;
        if b.decrement_reference(add(control, 8)?)
            .map_err(Error::Boundary)?
            == 1
        {
            let vt = b.word(control)?;
            let callback = b.word(add(vt, 4)?)?;
            b.release_control(control, callback)
                .map_err(Error::Boundary)?;
        }
    }
    Ok(())
}
/// Read source first; increment before releasing destination, including self-copy.
/// Native callbacks may mutate source storage; captured pair values are retained.
pub fn copy<B: Storage + Boundary>(b: &mut B, destination: u32, source: u32) -> Result<(), Error> {
    let control = b.word(add(source, 4)?)?;
    let object = b.word(source)?;
    if control != 0 {
        b.increment_reference(add(control, 4)?)
            .map_err(Error::Boundary)?;
    }
    let old = b.word(add(destination, 4)?)?;
    release_control(b, old)?;
    b.write_word(add(destination, 4)?, control)?;
    b.write_word(destination, object)?;
    Ok(())
}
/// Native5BD470 copies into a fresh temporary, publishes destination, then
/// releases its former control. Unlike5CC070, callbacks observe the new pair.
pub fn copy_assign<B: Storage + Boundary>(
    b: &mut B,
    destination: u32,
    source: u32,
) -> Result<u32, Error> {
    let control = b.word(add(source, 4)?)?;
    let object = b.word(source)?;
    if control != 0 {
        b.increment_reference(add(control, 4)?)
            .map_err(Error::Boundary)?;
    }
    let old = b.word(add(destination, 4)?)?;
    b.write_word(add(destination, 4)?, control)?;
    b.write_word(destination, object)?;
    release_control(b, old)?;
    Ok(destination)
}
/// Native5BD4E0: consume source, publish destination, then release old control.
/// Self-move preserves ownership. Both pairs must be valid owning storage;
/// partially overlapping pairs and aliasing the native temporary stack are excluded.
/// Disposal callbacks observe the new destination and may mutate either pair.
pub fn move_assign<B: Storage + ControlBoundary>(
    b: &mut B,
    destination: u32,
    source: u32,
) -> Result<u32, Error> {
    let control = b.word(add(source, 4)?)?;
    b.write_word(add(source, 4)?, 0)?;
    let object = b.word(source)?;
    b.write_word(source, 0)?;
    let old = b.word(add(destination, 4)?)?;
    b.write_word(add(destination, 4)?, control)?;
    b.write_word(destination, object)?;
    release_control(b, old)?;
    Ok(destination)
}
/// Native destructor does not zero the borrowed pair storage after release.
pub fn destroy<B: Memory + ControlBoundary>(b: &mut B, pair: u32) -> Result<(), Error> {
    let control = b.word(add(pair, 4)?)?;
    release_control(b, control)
}
/// Output is fresh/uninitialized pair storage, not an existing owning pair.
pub fn from_nested<B: Storage + Boundary>(
    b: &mut B,
    nested: u32,
    output: u32,
) -> Result<u32, Error> {
    b.write_word(output, 0)?;
    b.write_word(add(output, 4)?, 0)?;
    copy(b, output, add(nested, 0x6c)?)?;
    Ok(output)
}
/// Native729CF0: absent nested object produces an empty pair, otherwise acquire.
pub fn from_manager<B: Storage + Boundary>(
    b: &mut B,
    manager: u32,
    output: u32,
) -> Result<u32, Error> {
    let nested = b.word(add(manager, 0x30)?)?;
    if nested == 0 {
        b.write_word(output, 0)?;
        b.write_word(add(output, 4)?, 0)?;
        Ok(output)
    } else {
        from_nested(b, nested, output)
    }
}

#[cfg(test)]
#[path = "audio_replay_shared_pair_tests.rs"]
mod tests;
