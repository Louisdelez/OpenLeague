//! Native901A70/901B80/8F9000/901C00 logger ownership and8F92B0 dispatch.
//! Canonical labels never become host pointers. The caller owns synchronization.
use crate::{
    audio_announcer_object_lookup as read, audio_announcer_owner_metadata as callback,
    audio_announcer_registry_init::{self as init, Storage},
    audio_announcer_registry_remove as remove,
};
pub const POINTER: u32 = 0x2d78ec4;
pub const REINITIALIZE: u32 = 0x2d78ec1;
pub const REGISTERED: u32 = 0x2d78ec2;
pub const LOGGER: u32 = 0x2d78ed0;
pub const SHUTDOWN: u32 = 0x901c00;
pub const DEFAULT_MEMBER: u32 = 0x573fa0;
pub const INVOKE: u32 = 0x5cce30;
pub const BUFFER: u32 = 0x2d8d358;
pub const CAPACITY: usize = 2560;
#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Read(read::Error),
    Write(init::Error),
    Callback(callback::Error),
    Free(remove::Error),
    Boundary(&'static str),
    AddressOverflow,
    UnknownCallback(u32),
    NullCallback,
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
impl From<callback::Error> for Error {
    fn from(e: callback::Error) -> Self {
        Self::Callback(e)
    }
}
pub trait Boundary: Storage + remove::Backend + callback::Boundaries {
    fn byte(&mut self, address: u32) -> Result<u8, &'static str>;
    fn initialize_critical_section(&mut self, address: u32) -> Result<(), &'static str>;
    fn delete_critical_section(&mut self, address: u32) -> Result<(), &'static str>;
}
pub trait Output: Boundary {
    /// SYSTEMTIME word order, with the native local wall clock supplied explicitly.
    fn local_time(&mut self) -> Result<[u16; 8], &'static str>;
    ///5CCE30 tail-calls the configured member with its owner and the static buffer.
    /// Unknown members must fail explicitly;573FA0 is implemented here as a no-op.
    fn invoke_member(&mut self, owner: u32, member: u32, message: u32) -> Result<u8, &'static str>;
}
fn add(p: u32, n: u32) -> Result<u32, Error> {
    p.checked_add(n).ok_or(Error::AddressOverflow)
}
fn finish<T>(value: Result<T, Error>, cleanup: Result<(), Error>) -> Result<T, Error> {
    match (value, cleanup) {
        (Ok(v), Ok(())) => Ok(v),
        (Err(e), Ok(())) | (Ok(_), Err(e)) => Err(e),
        (Err(primary), Err(cleanup)) => Err(Error::Cleanup {
            primary: Box::new(primary),
            cleanup: Box::new(cleanup),
        }),
    }
}
pub const COMPOSITE_VTABLE: u32 = 0x10d5f64;
pub const COMPOSITE_DELETE: u32 = 0x901860;
pub const COMPOSITE_CLONE: u32 = 0x901750;
pub const COMPOSITE_INVOKE: u32 = 0x901840;
/// Native virtual callback deletion, including recursive composite children.
pub fn delete(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    if p == 0 {
        return Ok(());
    }
    let vt = b.word(p)?;
    let method = b.word(vt)?;
    match method {
        callback::HANDLER_DELETE => {
            callback::scalar_delete_callback(b, p, 1)?;
            Ok(())
        }
        COMPOSITE_DELETE => {
            delete_composite(b, p, 1)?;
            Ok(())
        }
        _ => Err(Error::UnknownCallback(method)),
    }
}
pub fn delete_composite(b: &mut impl Boundary, p: u32, flags: u32) -> Result<u32, Error> {
    let second = b.word(add(p, 8)?)?;
    delete(b, second)?;
    let first = b.word(add(p, 4)?)?;
    delete(b, first)?;
    Storage::write_word(b, p, 0x1084ed4)?;
    if flags & 1 != 0 {
        let route = b.deallocator().map_err(Error::Free)?;
        b.free(p, route).map_err(Error::Free)?;
    }
    Ok(p)
}
pub fn clone_callback(b: &mut impl Boundary, p: u32) -> Result<u32, Error> {
    if p == 0 {
        return Ok(0);
    }
    let vt = b.word(p)?;
    let method = b.word(add(vt, 4)?)?;
    if method == callback::HANDLER_CLONE {
        return Ok(callback::clone_callback(b, p)?);
    }
    if method != COMPOSITE_CLONE {
        return Err(Error::UnknownCallback(method));
    }
    let q = b.allocate_callback_clone(12).map_err(Error::Boundary)?;
    if q == 0 {
        return Ok(0);
    }
    Storage::write_word(b, q, COMPOSITE_VTABLE)?;
    let first = b.word(add(p, 4)?)?;
    let first = clone_callback(b, first)?;
    Storage::write_word(b, add(q, 4)?, first)?;
    let second = b.word(add(p, 8)?)?;
    let second = clone_callback(b, second)?;
    Storage::write_word(b, add(q, 8)?, second)?;
    Ok(q)
}
///9016C0 clones two wrappers; inputs are addresses containing callback pointers.
pub fn construct_composite(
    b: &mut impl Boundary,
    p: u32,
    first: u32,
    second: u32,
) -> Result<u32, Error> {
    Storage::write_word(b, p, COMPOSITE_VTABLE)?;
    let a = b.word(first)?;
    let a = clone_callback(b, a)?;
    Storage::write_word(b, add(p, 4)?, a)?;
    let c = b.word(second)?;
    let c = clone_callback(b, c)?;
    Storage::write_word(b, add(p, 8)?, c)?;
    Ok(p)
}
///9014F0 creates and clones a temporary composite, then deletes the temporary.
pub fn compose(b: &mut impl Boundary, out: u32, first: u32, second: u32) -> Result<(), Error> {
    let p = b.allocate(12)?;
    if p != 0 {
        construct_composite(b, p, first, second)?;
    }
    let q = clone_callback(b, p)?;
    Storage::write_word(b, out, q)?;
    delete(b, p)
}
///8F9380 consumes the incoming wrapper's callback and keeps a clone of the
/// composed chain. Scratch is one caller-owned word, not an engine allocation.
pub fn append_callback(
    b: &mut impl Boundary,
    logger: u32,
    incoming_slot: u32,
    scratch: u32,
) -> Result<(), Error> {
    let field = add(logger, 32)?;
    compose(b, scratch, field, incoming_slot)?;
    let temp = b.word(scratch)?;
    let cloned = clone_callback(b, temp)?;
    let old = b.word(field)?;
    Storage::write_word(b, field, 0)?;
    Storage::write_word(b, field, cloned)?;
    delete(b, old)?;
    delete(b, temp)?;
    let incoming = b.word(incoming_slot)?;
    delete(b, incoming)
}
pub fn invoke_callback(b: &mut impl Output, p: u32, message: u32) -> Result<u8, Error> {
    if p == 0 {
        return Err(Error::NullCallback);
    }
    let vt = b.word(p)?;
    let method = b.word(add(vt, 8)?)?;
    if method == COMPOSITE_INVOKE {
        let a = b.word(add(p, 4)?)?;
        let _ = invoke_callback(b, a, message)?;
        let c = b.word(add(p, 8)?)?;
        return invoke_callback(b, c, message);
    }
    if method != INVOKE {
        return Err(Error::UnknownCallback(method));
    }
    let owner = b.word(add(p, 4)?)?;
    let member = b.word(add(p, 8)?)?;
    if member == DEFAULT_MEMBER {
        Ok(1)
    } else {
        b.invoke_member(owner, member, message)
            .map_err(Error::Boundary)
    }
}
///8F9000 publishes the clone before deleting the previous and temporary callbacks.
pub fn replace_default(b: &mut impl Boundary, logger: u32) -> Result<(), Error> {
    let field = add(logger, 32)?;
    let temporary = b.allocate(12)?;
    if temporary != 0 {
        for (offset, value) in [
            (0, callback::HANDLER_VTABLE),
            (4, logger),
            (8, DEFAULT_MEMBER),
        ] {
            Storage::write_word(b, add(temporary, offset)?, value)?;
        }
    }
    let action = (|| {
        let cloned = if temporary == 0 {
            0
        } else {
            let vt = b.word(temporary)?;
            let method = b.word(add(vt, 4)?)?;
            if method != callback::HANDLER_CLONE {
                return Err(Error::UnknownCallback(method));
            }
            callback::clone_callback(b, temporary)?
        };
        let old = b.word(field)?;
        Storage::write_word(b, field, 0)?;
        Storage::write_word(b, field, cloned)?;
        delete(b, old)
    })();
    finish(action, delete(b, temporary))
}
///901B80 preserves the three padding bytes after the mutex flag.
pub fn construct(b: &mut impl Boundary) -> Result<u32, Error> {
    b.write_byte(LOGGER, 0)?;
    Storage::write_word(b, LOGGER + 4, 0)?;
    b.initialize_critical_section(LOGGER + 8)
        .map_err(Error::Boundary)?;
    Storage::write_word(b, LOGGER + 32, 0)?;
    match replace_default(b, LOGGER) {
        Ok(()) => Ok(LOGGER),
        Err(e) => finish(
            Err(e),
            b.delete_critical_section(LOGGER + 8)
                .map_err(Error::Boundary),
        ),
    }
}
///901A70 is lazy. Registering shutdown does not itself set REGISTERED.
pub fn initialize(b: &mut impl Boundary) -> Result<u32, Error> {
    let existing = b.word(POINTER)?;
    if existing != 0 {
        return Ok(existing);
    }
    if b.byte(REINITIALIZE).map_err(Error::Boundary)? != 0 {
        b.write_byte(REINITIALIZE, 0)?;
        b.write_byte(REGISTERED, 1)?;
    }
    let logger = construct(b)?;
    Storage::write_word(b, POINTER, logger)?;
    if b.byte(REGISTERED).map_err(Error::Boundary)? == 0 {
        b.register_shutdown(SHUTDOWN)?;
    }
    Ok(logger)
}
///901C00 requires an initialized logger. The freed callback label is retained in
/// static storage exactly as in the source; it must not be dereferenced afterward.
pub fn shutdown(b: &mut impl Boundary) -> Result<(), Error> {
    let logger = b.word(POINTER)?;
    let p = b.word(add(logger, 32)?)?;
    delete(b, p)?;
    b.delete_critical_section(add(logger, 8)?)
        .map_err(Error::Boundary)?;
    Storage::write_word(b, POINTER, 0)?;
    b.write_byte(REINITIALIZE, 1)?;
    Ok(())
}
fn cbytes(s: &[u8]) -> &[u8] {
    &s[..s.iter().position(|v| *v == 0).unwrap_or(s.len())]
}
fn append(buffer: &mut Vec<u8>, s: &[u8]) {
    let n = s.len().min(CAPACITY - 1 - buffer.len());
    buffer.extend_from_slice(&s[..n]);
}
///8F92B0 formats raw narrow bytes with the native24/2560-byte truncation limits.
/// The caller holds the logger mutex. The CRT also zeroes the final buffer byte;
/// bytes between the string terminator and that final byte remain untouched.
pub fn write_message(
    b: &mut impl Output,
    logger: u32,
    message: &[u8],
    source: Option<&[u8]>,
    line: u32,
) -> Result<(), Error> {
    let t = b.local_time().map_err(Error::Boundary)?;
    let stamp = format!(
        "{:04}-{:02}-{:02}T{:02}-{:02}-{:02}",
        t[0], t[1], t[3], t[4], t[5], t[6]
    );
    let mut output = Vec::with_capacity(CAPACITY);
    append(&mut output, &stamp.as_bytes()[..stamp.len().min(23)]);
    append(&mut output, b": ");
    append(&mut output, cbytes(message));
    if let Some(source) = source {
        append(&mut output, b". Line: ");
        append(&mut output, (line as i32).to_string().as_bytes());
        append(&mut output, b", file: ");
        append(&mut output, cbytes(source));
    }
    append(&mut output, b"\n");
    output.push(0);
    for (i, v) in output.into_iter().enumerate() {
        b.write_byte(BUFFER + i as u32, v)?;
    }
    b.write_byte(BUFFER + CAPACITY as u32 - 1, 0)?;
    let p = b.word(add(logger, 32)?)?;
    let _ = invoke_callback(b, p, BUFFER)?;
    Ok(())
}
#[cfg(windows)]
pub fn local_time() -> [u16; 8] {
    #[link(name = "kernel32")]
    unsafe extern "system" {
        fn GetLocalTime(output: *mut u16);
    }
    let mut words = [0; 8];
    unsafe {
        GetLocalTime(words.as_mut_ptr());
    }
    words
}
#[cfg(test)]
#[path = "audio_replay_logger_tests.rs"]
mod tests;
