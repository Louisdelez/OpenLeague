//! Native game-side replay manager728E20/728FD0/728EE0 and open/start7297E0.
//! The parent, its stream, metadata and callbacks must share one address bank.
use crate::{
    audio_announcer_object_lookup as read, audio_announcer_owner_control as control,
    audio_announcer_registry_init::{self as init, Storage},
    audio_announcer_registry_remove as removal, audio_replay_callbacks as callbacks,
    audio_replay_metadata as metadata, audio_replay_opening as opening,
    audio_replay_shared_pair as pair, audio_replay_stream as stream,
    audio_replay_stream_running as running,
};
pub const BYTES: u32 = 68;
pub const VTABLE: u32 = 0x10b012c;
pub const SCALAR_DELETE: u32 = 0x728ea0;
pub const CURRENT_ID: u32 = 0x123df84;
pub const OBJECT: u32 = 0x2d78240;
pub const POINTER: u32 = 0x2d78520;
pub const REINITIALIZE: u32 = 0x2d784e6;
pub const REGISTERED: u32 = 0x2d78288;
pub const SHUTDOWN: u32 = 0x5d81b0;
#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Read(read::Error),
    Write(init::Error),
    Free(removal::Error),
    Callback(callbacks::Error),
    Metadata(metadata::Error),
    Control(control::Error),
    Pair(pair::Error),
    Stream(stream::Error),
    Opening(opening::Error),
    Running(running::Error),
    Boundary(&'static str),
    AddressOverflow,
    UnknownMethod(u32),
    Cleanup {
        primary: Box<Error>,
        cleanup: Box<Error>,
    },
}
macro_rules! convert {
    ($t:ty,$v:ident) => {
        impl From<$t> for Error {
            fn from(e: $t) -> Self {
                Self::$v(e)
            }
        }
    };
}
convert!(read::Error, Read);
convert!(init::Error, Write);
convert!(removal::Error, Free);
convert!(callbacks::Error, Callback);
convert!(metadata::Error, Metadata);
convert!(control::Error, Control);
convert!(pair::Error, Pair);
convert!(stream::Error, Stream);
convert!(opening::Error, Opening);
convert!(running::Error, Running);
pub trait Boundary:
    opening::Boundary + running::Boundary + metadata::Boundary + callbacks::Boundary
{
}
fn add(p: u32, o: u32) -> Result<u32, Error> {
    p.checked_add(o).ok_or(Error::AddressOverflow)
}
fn put(b: &mut impl Storage, p: u32, o: u32, v: u32) -> Result<(), Error> {
    Ok(Storage::write_word(b, add(p, o)?, v)?)
}
fn free(b: &mut impl removal::Backend, p: u32) -> Result<(), Error> {
    let route = b.deallocator()?;
    Ok(b.free(p, route)?)
}
fn allocate_engine(b: &mut impl callbacks::Boundary, bytes: u32) -> Result<u32, Error> {
    b.allocate_callback_clone(bytes).map_err(Error::Boundary)
}
fn finish<T>(a: Result<T, Error>, c: Result<(), Error>) -> Result<T, Error> {
    match (a, c) {
        (Ok(v), Ok(())) => Ok(v),
        (Err(e), Ok(())) | (Ok(_), Err(e)) => Err(e),
        (Err(primary), Err(cleanup)) => Err(Error::Cleanup {
            primary: Box::new(primary),
            cleanup: Box::new(cleanup),
        }),
    }
}
/// Native728E20 uses the current global identifier, preserving inline string padding.
pub fn construct(b: &mut impl Storage, p: u32) -> Result<u32, Error> {
    put(b, p, 0, VTABLE)?;
    let id = b.word(CURRENT_ID)?;
    put(b, p, 4, id)?;
    put(b, p, 0x1c, 15)?;
    put(b, p, 0x18, 0)?;
    b.write_byte(add(p, 8)?, 0)?;
    for o in [0x20, 0x24, 0x28, 0x2c, 0x30, 0x34, 0x38, 0x40] {
        put(b, p, o, 0)?;
    }
    b.write_byte(add(p, 0x3c)?, 0)?;
    Ok(p)
}
fn install(b: &mut impl Boundary, p: u32, o: u32, f: u32) -> Result<(), Error> {
    let temporary = callbacks::factory(b, f, p)?;
    let cloned = callbacks::clone(b, temporary).map_err(Error::Callback);
    let result = (|| {
        let cloned = cloned?;
        let old = b.word(add(p, o)?)?;
        put(b, p, o, 0)?;
        put(b, p, o, cloned)?;
        callbacks::delete(b, old)?;
        Ok(())
    })();
    let cleanup = callbacks::delete(b, temporary).map_err(Error::Callback);
    finish(result, cleanup)
}
/// Full normal-return728FD0. Scratch8 is caller-owned pair/output storage.
/// The native method does not make repeated initialization safe by clearing old streams.
pub fn initialize(b: &mut impl Boundary, p: u32, scratch: u32) -> Result<bool, Error> {
    install(b, p, 0x2c, 0x733540)?;
    install(b, p, 0x20, 0x7335c0)?;
    install(b, p, 0x24, 0x733640)?;
    let bundle = allocate_engine(b, 20)?;
    if bundle != 0 {
        callbacks::construct_bundle(b, bundle)?;
    }
    put(b, p, 0x28, bundle)?;
    for (f, o) in [(0x7336c0, 12), (0x733740, 16)] {
        let incoming = callbacks::factory(b, f, p)?;
        callbacks::parent_replace(b, p, o, scratch, incoming)?;
        let old = b.word(scratch)?;
        callbacks::delete(b, old)?;
    }
    let incoming = callbacks::factory(b, 0x733840, p)?;
    let bundle = b.word(add(p, 0x28)?)?;
    callbacks::replace(b, bundle, 4, scratch, incoming)?;
    let old = b.word(scratch)?;
    callbacks::delete(b, old)?;
    let nested = allocate_engine(b, 120)?;
    if nested != 0 {
        stream::construct(b, nested)?;
    }
    put(b, p, 0x30, nested)?;
    let object = allocate_engine(b, 512)?;
    if object != 0 {
        metadata::construct(b, object)?;
    }
    put(b, scratch, 0, 0)?;
    put(b, scratch, 4, 0)?;
    control::replace_pair(b, scratch, object)?;
    pair::move_assign(b, add(p, 0x34)?, scratch)?;
    let id = b.word(CURRENT_ID)?;
    put(b, p, 4, id)?;
    Ok(true)
}
/// Native728EE0: bundle, stream, callback40, metadata, callbacks2C/24/20, string.
pub fn destroy(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    put(b, p, 0, VTABLE)?;
    let bundle = b.word(add(p, 0x28)?)?;
    if bundle != 0 {
        let vt = b.word(bundle)?;
        let method = b.word(vt)?;
        if method != 0x728ae0 {
            return Err(Error::UnknownMethod(method));
        }
        callbacks::delete_bundle(b, bundle, 1)?;
    }
    let nested = b.word(add(p, 0x30)?)?;
    if nested != 0 {
        let vt = b.word(nested)?;
        let method = b.word(add(vt, 8)?)?;
        if method != 0x8f67c0 {
            return Err(Error::UnknownMethod(method));
        }
        stream::scalar_delete(b, nested, 1)?;
    }
    let callback = b.word(add(p, 0x40)?)?;
    callbacks::delete(b, callback)?;
    pair::destroy(b, add(p, 0x34)?)?;
    for o in [0x2c, 0x24, 0x20] {
        let callback = b.word(add(p, o)?)?;
        callbacks::delete(b, callback)?;
    }
    if b.word(add(p, 0x1c)?)? >= 16 {
        let data = b.word(add(p, 8)?)?;
        free(b, data)?;
    }
    put(b, p, 0x1c, 15)?;
    put(b, p, 0x18, 0)?;
    b.write_byte(add(p, 8)?, 0)?;
    Ok(())
}
pub fn scalar_delete(b: &mut impl Boundary, p: u32, flags: u32) -> Result<u32, Error> {
    destroy(b, p)?;
    if flags & 1 != 0 {
        free(b, p)?;
    }
    Ok(p)
}
/// Twelve parent arguments grouped by their source use. start[3..6] explicitly
/// carries the three uninitialized source stack words, unused by8F6AF0 today.
pub struct Request<'a> {
    pub arguments: [u32; 2],
    pub key: &'a [u8; 16],
    pub host: Option<&'a [u8]>,
    pub start: [u32; 6],
    pub mode: u32,
    pub flag: u32,
    pub extra: u32,
    pub recording_path: u32,
    pub recording: u32,
}
/// Native7297E0: own a temporary callback, open with literal port0, clean the
/// temporary, and start only when opening returned0. Scratch24 belongs to caller.
pub fn open(b: &mut impl Boundary, p: u32, r: Request<'_>, scratch: u32) -> Result<u32, Error> {
    let configured = b.word(add(p, 0x40)?)?;
    let temporary = if configured != 0 {
        callbacks::clone(b, configured)?
    } else {
        callbacks::factory(b, 0x7337c0, p)?
    };
    let result = (|| {
        let incoming = callbacks::clone(b, temporary)?;
        let nested = b.word(add(p, 0x30)?)?;
        Ok(opening::open(
            b,
            nested,
            opening::Request {
                callback: incoming,
                arguments: r.arguments,
                key: r.key,
                host: r.host,
                port: 0,
                mode: r.mode,
                flag: r.flag,
                extra: r.extra,
                recording_path: r.recording_path,
                recording: r.recording,
            },
            scratch,
        )?)
    })();
    let cleanup = callbacks::delete(b, temporary).map_err(Error::Callback);
    let code = finish(result, cleanup)?;
    if code != 0 {
        return Ok(code);
    }
    let nested = b.word(add(p, 0x30)?)?;
    Ok(running::start(b, nested, r.start)?)
}
/// Lazy source5CF1E0 singleton, including reinitialization registration flags.
pub fn get(b: &mut impl Boundary) -> Result<u32, Error> {
    let current = b.word(POINTER)?;
    if current != 0 {
        return Ok(current);
    }
    if crate::audio_replay_object_manager::Boundary::read_byte(b, REINITIALIZE)? != 0 {
        b.write_byte(REINITIALIZE, 0)?;
        b.write_byte(REGISTERED, 1)?;
    }
    let p = construct(b, OBJECT)?;
    put(b, POINTER, 0, p)?;
    if crate::audio_replay_object_manager::Boundary::read_byte(b, REGISTERED)? == 0 {
        b.register_shutdown(SHUTDOWN)?;
    }
    Ok(p)
}
/// Source5D81B0 expects an initialized singleton; no fabricated null success.
pub fn shutdown(b: &mut impl Boundary) -> Result<(), Error> {
    let p = b.word(POINTER)?;
    let vt = b.word(p)?;
    let f = b.word(vt)?;
    if f != SCALAR_DELETE {
        return Err(Error::UnknownMethod(f));
    }
    scalar_delete(b, p, 0)?;
    put(b, POINTER, 0, 0)?;
    b.write_byte(REINITIALIZE, 1)?;
    Ok(())
}
