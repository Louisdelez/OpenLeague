//! Native224-byte transport configuration8FC230/8FC610 and owned cleanup.
//! Host/packet implementations are explicit dynamic dependencies, not success stubs.
use crate::{
    audio_announcer_object_lookup as read, audio_announcer_owner_metadata as callback,
    audio_announcer_registry_init::{self as init, Storage},
    audio_announcer_registry_remove as remove, audio_replay_address as address,
    audio_replay_transport_startup as startup,
};
pub const VTABLE: u32 = 0x10d5fa4;
pub const CLOSE: u32 = 0x8fc7b0;
pub const SCALAR_DELETE: u32 = 0x8fc2d0;
pub const CLOCK_BASE: u32 = 0x2d78ec8;
pub const UID_SCRATCH: u32 = 0x2d8dd58;
pub const PARAMETERS_INVALID: &str = "Net Status: Initialize failed: parameters invalid.";
pub const RESOLUTION_FAILED: &str = "Net Status: Initialize failed: local address resolution.";
pub const INITIALIZED: &str = "Net Status: low-level initialize success.";
pub const UID_ERROR: &str = "Server: Error, main failed to register server with UID";
pub const SOURCE_FILE:&str="E:/jenkins/workspace/game-code-Releases-4-20-public-win32/code/Game/Core/RiotNetwork/Protocol/BaseEnet.cpp";
#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Read(read::Error),
    Write(init::Error),
    Free(remove::Error),
    Callback(callback::Error),
    Address(address::Error),
    Boundary(&'static str),
    Overflow,
    NullQueueProxy,
    UnknownCallback(u32),
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
impl From<remove::Error> for Error {
    fn from(e: remove::Error) -> Self {
        Self::Free(e)
    }
}
impl From<callback::Error> for Error {
    fn from(e: callback::Error) -> Self {
        Self::Callback(e)
    }
}
impl From<address::Error> for Error {
    fn from(e: address::Error) -> Self {
        Self::Address(e)
    }
}
pub trait Boundary: Storage + remove::Backend + callback::Boundaries + address::Boundary {
    fn byte(&mut self, p: u32) -> Result<u8, &'static str>;
    fn initialize_critical_section(&mut self, p: u32) -> Result<(), &'static str>;
    fn delete_critical_section(&mut self, p: u32) -> Result<(), &'static str>;
    fn mutex(&mut self, p: u32, enter: bool) -> Result<(), &'static str>;
    fn initialize_transport(&mut self) -> Result<u8, &'static str>;
    fn drain_transport(&mut self) -> Result<(), &'static str>;
    fn release_transport(&mut self) -> Result<(), &'static str>;
    fn milliseconds(&mut self) -> Result<u32, &'static str>;
    fn logger(&mut self) -> Result<u32, &'static str>;
    /// Called while the native logger mutex is held.
    fn log(&mut self, message: &str, source: Option<&str>, line: u32) -> Result<(), &'static str>;
    /// Explicit initial bytes for the native8FCA30 local sockaddr storage.
    fn address_frame(&mut self) -> Result<[u8; 16], &'static str>;
    fn packet_callback(&mut self, p: u32, method: u32) -> Result<(), &'static str>;
    fn packet_free(&mut self, p: u32, method: u32) -> Result<(), &'static str>;
    fn flush_host(
        &mut self,
        p: u32,
        event_output: u32,
        check_timeouts: u32,
    ) -> Result<(), &'static str>;
    fn reset_peer(&mut self, p: u32, reason: u32) -> Result<(), &'static str>;
    fn destroy_host(&mut self, p: u32) -> Result<(), &'static str>;
    fn close_derived_transport(&mut self, _p: u32) -> Result<(), &'static str> {
        Err("derived8F6FA0 close is not connected")
    }
}
fn add(p: u32, n: u32) -> Result<u32, Error> {
    p.checked_add(n).ok_or(Error::Overflow)
}
fn finish<T>(result: Result<T, Error>, cleanup: Result<(), Error>) -> Result<T, Error> {
    match (result, cleanup) {
        (Ok(v), Ok(())) => Ok(v),
        (Err(e), Ok(())) | (Ok(_), Err(e)) => Err(e),
        (Err(primary), Err(cleanup)) => Err(Error::Cleanup {
            primary: Box::new(primary),
            cleanup: Box::new(cleanup),
        }),
    }
}
fn locked<B: Boundary, T>(
    b: &mut B,
    p: u32,
    f: impl FnOnce(&mut B) -> Result<T, Error>,
) -> Result<T, Error> {
    b.mutex(p, true).map_err(Error::Boundary)?;
    let value = f(b);
    let cleanup = b.mutex(p, false).map_err(Error::Boundary);
    finish(value, cleanup)
}
fn message(b: &mut impl Boundary, text: &str) -> Result<(), Error> {
    let logger = b.logger().map_err(Error::Boundary)?;
    locked(b, logger, |b| b.log(text, None, 0).map_err(Error::Boundary))
}
fn delete_callback(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    if p == 0 {
        return Ok(());
    }
    let vt = b.word(p)?;
    let method = b.word(vt)?;
    if method != callback::HANDLER_DELETE {
        return Err(Error::UnknownCallback(method));
    }
    callback::scalar_delete_callback(b, p, 1)?;
    Ok(())
}
fn write16(b: &mut impl Storage, p: u32, v: u16) -> Result<(), Error> {
    b.write_byte(p, v as u8)?;
    b.write_byte(add(p, 1)?, (v >> 8) as u8)?;
    Ok(())
}
pub fn construct(b: &mut impl Boundary, p: u32) -> Result<u32, Error> {
    Storage::write_word(b, p, VTABLE)?;
    for offset in [8, 12, 0xa0, 0xa4, 0xa8, 0xac, 0xb0, 0xb4, 0xb8] {
        Storage::write_word(b, add(p, offset)?, 0)?;
    }
    let q = add(p, 0xa8)?;
    let proxy = b.allocate(8)?;
    if proxy == 0 {
        return Err(Error::NullQueueProxy);
    }
    Storage::write_word(b, q, proxy)?;
    Storage::write_word(b, proxy, 0)?;
    Storage::write_word(b, add(proxy, 4)?, 0)?;
    Storage::write_word(b, proxy, q)?;
    b.write_byte(add(p, 0xbc)?, 0)?;
    Storage::write_word(b, add(p, 0xc0)?, 0)?;
    b.initialize_critical_section(add(p, 0xc4)?)
        .map_err(Error::Boundary)?;
    Storage::write_word(b, add(p, 0xdc)?, 0)?;
    write16(b, add(p, 0x14)?, 0)?;
    Storage::write_word(b, add(p, 0x10)?, 0)?;
    Ok(p)
}
///8FC930 removes packets while retaining deque blocks for subsequent reuse.
pub fn reset_queue(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    locked(b, add(p, 0xbc)?, |b| {
        let q = add(p, 0xa8)?;
        while b.word(add(q, 16)?)? != 0 {
            let proxy = b.word(q)?;
            let owner = b.word(proxy)?;
            let slots = b.word(add(owner, 4)?)?;
            let capacity = b.word(add(owner, 8)?)?;
            let index = capacity.wrapping_sub(1) & b.word(add(q, 12)?)?;
            let block = b.word(add(slots, index.checked_mul(4).ok_or(Error::Overflow)?)?)?;
            // The source copies all five event words before invoking packet cleanup.
            for offset in [0, 4, 8, 12] {
                let _ = b.word(add(block, offset)?)?;
            }
            let packet = b.word(add(block, 16)?)?;
            if packet != 0 {
                let method = b.word(add(packet, 16)?)?;
                if method != 0 {
                    b.packet_callback(packet, method).map_err(Error::Boundary)?;
                }
                if b.byte(add(packet, 4)?).map_err(Error::Boundary)? & 4 == 0 {
                    let payload = b.word(add(packet, 8)?)?;
                    let free = b.word(startup::DEALLOCATOR)?;
                    b.packet_free(payload, free).map_err(Error::Boundary)?;
                }
                let free = b.word(startup::DEALLOCATOR)?;
                b.packet_free(packet, free).map_err(Error::Boundary)?;
            }
            let count = b.word(add(q, 16)?)?.wrapping_sub(1);
            Storage::write_word(b, add(q, 16)?, count)?;
            let next = if count == 0 {
                0
            } else {
                b.word(add(q, 12)?)?.wrapping_add(1)
            };
            Storage::write_word(b, add(q, 12)?, next)?;
        }
        Ok(())
    })
}
///5E26A0 tears down storage only; packet ownership is handled by reset_queue.
fn clear_storage(b: &mut impl Boundary, q: u32) -> Result<(), Error> {
    if b.word(add(q, 16)?)? != 0 {
        Storage::write_word(b, add(q, 12)?, 0)?;
        Storage::write_word(b, add(q, 16)?, 0)?;
    }
    let count = b.word(add(q, 8)?)?;
    let mut route = b.deallocator()?;
    for index in (0..count).rev() {
        let slots = b.word(add(q, 4)?)?;
        let block = b.word(add(slots, index.checked_mul(4).ok_or(Error::Overflow)?)?)?;
        if block != 0 {
            if let remove::Deallocator::Custom { callback, .. } = route {
                let context = b.word(0x14bef44)?;
                b.free(block, remove::Deallocator::Custom { callback, context })?;
                route = b.deallocator()?;
            } else {
                b.free(block, route)?;
            }
        }
    }
    let slots = b.word(add(q, 4)?)?;
    if slots != 0 {
        let actual = match route {
            remove::Deallocator::Custom { callback, .. } => remove::Deallocator::Custom {
                callback,
                context: b.word(0x14bef44)?,
            },
            other => other,
        };
        b.free(slots, actual)?;
    }
    Storage::write_word(b, add(q, 8)?, 0)?;
    Storage::write_word(b, add(q, 4)?, 0)?;
    Ok(())
}
pub fn destroy(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    Storage::write_word(b, p, VTABLE)?;
    let cb = b.word(add(p, 0xdc)?)?;
    delete_callback(b, cb)?;
    b.delete_critical_section(add(p, 0xc4)?)
        .map_err(Error::Boundary)?;
    let q = add(p, 0xa8)?;
    clear_storage(b, q)?;
    let proxy = b.word(q)?;
    let route = b.deallocator()?;
    b.free(proxy, route)?;
    Storage::write_word(b, q, 0)?;
    Ok(())
}
pub fn scalar_delete(b: &mut impl Boundary, p: u32, flags: u32) -> Result<u32, Error> {
    destroy(b, p)?;
    if flags & 1 != 0 {
        let route = b.deallocator()?;
        b.free(p, route)?;
    }
    Ok(p)
}
///8FC830 flushes the current host then resets each peer under the global mutex.
pub fn flush(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    locked(b, startup::MUTEX, |b| {
        let host = b.word(add(p, 8)?)?;
        if host != 0 {
            let elapsed = b
                .milliseconds()
                .map_err(Error::Boundary)?
                .wrapping_sub(b.word(CLOCK_BASE)?);
            Storage::write_word(b, add(host, 0x28)?, elapsed)?;
            b.flush_host(host, 0, 0).map_err(Error::Boundary)?;
            let host = b.word(add(p, 8)?)?;
            let count = b.word(add(host, 0x24)?)?;
            for i in 0..count {
                let host = b.word(add(p, 8)?)?;
                let peers = b.word(add(host, 0x20)?)?;
                b.reset_peer(add(peers, i.checked_mul(0x158).ok_or(Error::Overflow)?)?, 0)
                    .map_err(Error::Boundary)?;
            }
        }
        Ok(())
    })
}
pub fn close(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    flush(b, p)?;
    locked(b, startup::MUTEX, |b| {
        let host = b.word(add(p, 8)?)?;
        if host != 0 {
            b.destroy_host(host).map_err(Error::Boundary)?;
            Storage::write_word(b, add(p, 8)?, 0)?;
        }
        Ok(())
    })?;
    b.release_transport().map_err(Error::Boundary)
}
fn close_virtual(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    let vt = b.word(p)?;
    let method = b.word(vt)?;
    if method == crate::audio_replay_stream_transport::CLOSE {
        return b.close_derived_transport(p).map_err(Error::Boundary);
    }
    if method != CLOSE {
        return Err(Error::UnknownCallback(method));
    }
    close(b, p)
}
///8FCA30's output at+A0 is a CRC UID. +10 is IPv4, not an address family.
pub fn resolve_address(
    b: &mut impl Boundary,
    p: u32,
    host: &[u8],
    port: u16,
) -> Result<bool, Error> {
    let mut socket = b.address_frame().map_err(Error::Boundary)?;
    let mut text = [0; 128];
    let target = add(p, 0x18)?;
    for (i, v) in text.iter_mut().enumerate() {
        *v = b.byte(add(target, i as u32)?).map_err(Error::Boundary)?;
    }
    let mut capacity = 128;
    let result = address::resolve(b, host, port, &mut socket, &mut text, &mut capacity);
    for (i, v) in text.into_iter().enumerate() {
        b.write_byte(add(target, i as u32)?, v)?;
    }
    let uid = result?;
    Storage::write_word(b, add(p, 0xa0)?, uid)?;
    if uid == 0 {
        let logger = b.logger().map_err(Error::Boundary)?;
        locked(b, logger, |b| {
            //8F90B0 formats into the separate128-byte static buffer, preserving its tail.
            for (i, v) in UID_ERROR.bytes().chain([0]).enumerate() {
                b.write_byte(add(UID_SCRATCH, i as u32)?, v)?;
            }
            b.log(UID_ERROR, Some(SOURCE_FILE), 240)
                .map_err(Error::Boundary)
        })?;
        return Ok(false);
    }
    Storage::write_word(
        b,
        add(p, 0x10)?,
        u32::from_le_bytes(socket[4..8].try_into().unwrap()),
    )?;
    write16(b, add(p, 0x14)?, port)?;
    Ok(true)
}
/// Takes ownership of the incoming callback, including all normal error-code exits.
pub fn configure(
    b: &mut impl Boundary,
    p: u32,
    incoming: u32,
    argument1: u32,
    argument2: u32,
    host: Option<&[u8]>,
    port: u32,
) -> Result<u32, Error> {
    let result = (|| {
        let _ = b.initialize_transport().map_err(Error::Boundary)?;
        b.drain_transport().map_err(Error::Boundary)?;
        let cloned = if incoming == 0 {
            0
        } else {
            let vt = b.word(incoming)?;
            let method = b.word(add(vt, 4)?)?;
            if method == 0x5cce40 {
                crate::audio_replay_callbacks::clone(b, incoming)
                    .map_err(|_| Error::Boundary("parent clone failed"))?
            } else {
                if method != callback::HANDLER_CLONE {
                    return Err(Error::UnknownCallback(method));
                }
                callback::clone_callback(b, incoming)?
            }
        };
        let field = add(p, 0xdc)?;
        let old = b.word(field)?;
        Storage::write_word(b, field, 0)?;
        Storage::write_word(b, field, cloned)?;
        delete_callback(b, old)?;
        if b.word(startup::STATUS)? == 3 {
            return Ok(1);
        }
        let clock = b.milliseconds().map_err(Error::Boundary)?;
        Storage::write_word(b, CLOCK_BASE, clock)?;
        reset_queue(b, p)?;
        let host = host.map(|h| &h[..h.iter().position(|v| *v == 0).unwrap_or(h.len())]);
        if host.is_none_or(|h| h.len() >= 128) {
            message(b, PARAMETERS_INVALID)?;
            close_virtual(b, p)?;
            return Ok(2);
        }
        if !resolve_address(b, p, host.unwrap(), port as u16)? {
            message(b, RESOLUTION_FAILED)?;
            close_virtual(b, p)?;
            return Ok(3);
        }
        Storage::write_word(b, add(p, 0x98)?, argument1)?;
        Storage::write_word(b, add(p, 0x9c)?, argument2)?;
        message(b, INITIALIZED)?;
        Ok(0)
    })();
    finish(result, delete_callback(b, incoming))
}
#[cfg(test)]
#[path = "audio_replay_transport_configuration_tests.rs"]
mod tests;
