//! Native transport launch8FC380/drain8FC480 and engine thread wait/retirement.
//! Creating the engine80-byte thread via8A8B80 remains a required platform boundary.
use crate::audio_announcer_object_lookup as read;
use crate::audio_announcer_owner_component_destructor::ControlBoundary;
use crate::audio_announcer_registry_init::{self as init, Storage};
use crate::audio_announcer_registry_remove::{self as removal, Backend as Removal};
use crate::audio_replay_shared_pair as pair;
pub const PAIR: u32 = 0x2d6ed70;
pub const CONTROL_VTABLE: u32 = 0x1085f2c;
pub const DISPOSE: u32 = 0x5d6740;
#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Read(read::Error),
    Write(init::Error),
    Free(removal::Error),
    Pair(pair::Error),
    Boundary(&'static str),
    AddressOverflow,
    Cleanup {
        primary: Box<Error>,
        cleanup: Box<Error>,
    },
}
impl From<read::Error> for Error {
    fn from(e: read::Error) -> Self {
        Self::Read(e)
    }
}
impl From<init::Error> for Error {
    fn from(e: init::Error) -> Self {
        Self::Write(e)
    }
}
impl From<removal::Error> for Error {
    fn from(e: removal::Error) -> Self {
        Self::Free(e)
    }
}
impl From<pair::Error> for Error {
    fn from(e: pair::Error) -> Self {
        Self::Pair(e)
    }
}
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Launch {
    pub callback: u32,
    pub argument: u32,
    pub tag: [u8; 16],
    pub name: &'static [u8],
}
pub trait Boundary: Storage + Removal + ControlBoundary {
    fn current_thread_id(&mut self) -> Result<u32, &'static str>;
    fn wait_handle(&mut self, handle: u32, timeout: u32) -> Result<u32, &'static str>;
    fn close_handle(&mut self, handle: u32) -> Result<u32, &'static str>;
    fn last_error(&mut self) -> Result<u32, &'static str>;
    fn mutex(&mut self, address: u32, enter: bool) -> Result<(), &'static str>;
    fn delete_critical_section(&mut self, address: u32) -> Result<(), &'static str>;
    /// Execute8A8B80-equivalent creation, including owned engine thread storage.
    /// A Windows creation failure returns0; unsupported adapters return Err.
    fn create_worker(&mut self, launch: &Launch) -> Result<u32, &'static str>;
    fn exchange_status(&mut self, value: u32) -> Result<u32, &'static str>;
}
fn add(a: u32, b: u32) -> Result<u32, Error> {
    a.checked_add(b).ok_or(Error::AddressOverflow)
}
fn put(b: &mut impl Boundary, address: u32, value: u32) -> Result<(), Error> {
    Ok(Storage::write_word(b, address, value)?)
}
fn locked<B: Boundary, T>(
    b: &mut B,
    address: u32,
    action: impl FnOnce(&mut B) -> Result<T, Error>,
) -> Result<T, Error> {
    b.mutex(address, true).map_err(Error::Boundary)?;
    let result = action(b);
    let cleanup = b.mutex(address, false).map_err(Error::Boundary);
    match (result, cleanup) {
        (Ok(v), Ok(())) => Ok(v),
        (Err(e), Ok(())) | (Ok(_), Err(e)) => Err(e),
        (Err(primary), Err(cleanup)) => Err(Error::Cleanup {
            primary: Box::new(primary),
            cleanup: Box::new(cleanup),
        }),
    }
}
fn windows_error(b: &mut impl Boundary) -> Result<u32, Error> {
    Ok(if b.last_error().map_err(Error::Boundary)? == 6 {
        2
    } else {
        4
    })
}
///8A9240: wait alone, without querying an exit code or closing the handle.
pub fn wait(b: &mut impl Boundary, thread: u32, timeout: u32) -> Result<u32, Error> {
    let handle = b.word(thread)?;
    wait_raw(b, handle, timeout)
}
fn wait_raw(b: &mut impl Boundary, handle: u32, timeout: u32) -> Result<u32, Error> {
    match b.wait_handle(handle, timeout).map_err(Error::Boundary)? {
        0 => Ok(0),
        258 => Ok(1),
        u32::MAX => windows_error(b),
        _ => Ok(4),
    }
}
///8A9210 and8A9190. Nonzero CloseHandle results are native success.
fn close_raw(b: &mut impl Boundary, handle: u32, wait_first: bool) -> Result<u32, Error> {
    if wait_first {
        let result = wait_raw(b, handle, u32::MAX)?;
        if result != 0 {
            return Ok(result);
        }
    }
    if b.close_handle(handle).map_err(Error::Boundary)? != 0 {
        Ok(0)
    } else {
        windows_error(b)
    }
}
///8A8DF0 takes the same recursive mutex twice. Inner release precedes publishing
/// handle/id zero; outer release follows. Errors retain the handle and id.
pub fn apply_close(b: &mut impl Boundary, thread: u32, wait_first: bool) -> Result<u32, Error> {
    let mutex = add(thread, 4)?;
    locked(b, mutex, |b| {
        let result = locked(b, mutex, |b| {
            let handle = b.word(thread)?;
            if handle == 0 {
                Ok(2)
            } else {
                close_raw(b, handle, wait_first)
            }
        })?;
        if result == 0 {
            put(b, thread, 0)?;
            put(b, add(thread, 0x24)?, 0)?;
        }
        Ok(result)
    })
}
///8A8C50 returns3 for self-join before any Windows wait.
pub fn join(b: &mut impl Boundary, thread: u32, timeout: u32) -> Result<u32, Error> {
    let current = b.current_thread_id().map_err(Error::Boundary)?;
    if current == b.word(add(thread, 0x24)?)? {
        return Ok(3);
    }
    let result = wait(b, thread, timeout)?;
    if result == 0 {
        apply_close(b, thread, true)
    } else {
        Ok(result)
    }
}
fn free(b: &mut impl Boundary, address: u32) -> Result<(), Error> {
    let route = b.deallocator()?;
    Ok(b.free(address, route)?)
}
///5D51C0 frees unconditionally, even when closing the handle failed. The ignored
/// native stack argument is not a scalar-delete flag.564900 clears the name.
pub fn destroy(b: &mut impl Boundary, thread: u32) -> Result<u32, Error> {
    if b.word(thread)? != 0 {
        apply_close(b, thread, false)?;
    }
    let name = add(thread, 0x38)?;
    if b.word(add(name, 20)?)? >= 16 {
        let data = b.word(name)?;
        free(b, data)?;
    }
    put(b, add(name, 20)?, 15)?;
    put(b, add(name, 16)?, 0)?;
    b.write_byte(name, 0)?;
    b.delete_critical_section(add(thread, 12)?)
        .map_err(Error::Boundary)?;
    free(b, thread)?;
    Ok(thread)
}
pub fn dispose(b: &mut impl Boundary, control: u32) -> Result<(), Error> {
    let thread = b.word(add(control, 12)?)?;
    if thread != 0 {
        destroy(b, thread)?;
    }
    Ok(())
}
///8FC480 deliberately skips the whole body for raw==0, even with a nonnull
/// control. Otherwise clears the published pair before releasing its control.
pub fn drain(b: &mut impl Boundary) -> Result<(), Error> {
    let thread = b.word(PAIR)?;
    if thread == 0 {
        return Ok(());
    }
    let current = b.current_thread_id().map_err(Error::Boundary)?;
    if current != b.word(add(thread, 0x24)?)? && wait(b, thread, 10000)? == 0 {
        apply_close(b, thread, true)?;
    }
    let control = b.word(PAIR + 4)?;
    put(b, PAIR + 4, 0)?;
    put(b, PAIR, 0)?;
    pair::release_control(b, control)?;
    Ok(())
}
///5CB260: create the new control before publishing; release the old one after.
pub fn replace_thread_at<B: Storage + ControlBoundary>(
    b: &mut B,
    destination: u32,
    thread: u32,
) -> Result<(), Error> {
    let control = b.allocate(16)?;
    if control != 0 {
        for (offset, value) in [(4, 1), (8, 1), (0, CONTROL_VTABLE), (12, thread)] {
            Storage::write_word(b, add(control, offset)?, value)?;
        }
    }
    let old = b.word(add(destination, 4)?)?;
    Storage::write_word(b, add(destination, 4)?, control)?;
    Storage::write_word(b, destination, thread)?;
    pair::release_control(b, old)?;
    Ok(())
}
///8FC380 returns low-byte1 independently of creation/worker success. STATUS is
/// the native readiness indicator; callers must inspect it separately.
pub fn initialize(b: &mut impl Boundary) -> Result<u8, Error> {
    if b.word(crate::audio_replay_transport_startup::STATUS)? != 2 {
        b.exchange_status(1).map_err(Error::Boundary)?;
        let thread = b
            .create_worker(&Launch {
                callback: 0x8fc100,
                argument: 0,
                tag: *b"EnetSysInit\0\0\0\0\0",
                name: b"Enet::SystemInitThread",
            })
            .map_err(Error::Boundary)?;
        replace_thread_at(b, PAIR, thread)?;
    }
    drain(b)?;
    Ok(1)
}
#[cfg(test)]
#[path = "audio_replay_transport_thread_tests_native.rs"]
pub(crate) mod tests;
