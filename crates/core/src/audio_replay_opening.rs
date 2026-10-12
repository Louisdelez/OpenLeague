//! Native8F68D0 stream selection, configuration, manager attachment and state event.
//! Recording/file preparation remains an explicit boundary until its native owner is connected.
use crate::{
    audio_announcer_object_lookup as read, audio_announcer_owner_control as control,
    audio_announcer_owner_metadata as callback,
    audio_announcer_registry_init::{self as init, Storage},
    audio_announcer_registry_remove as remove, audio_replay_manager_control as managers,
    audio_replay_object_manager as manager, audio_replay_shared_pair as pair,
    audio_replay_stream as stream, audio_replay_stream_transport as transport,
};
pub const NULL_VTABLE: u32 = 0x10d5fec;
pub const NULL_DELETE: u32 = 0x8f6680;
#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Read(read::Error),
    Write(init::Error),
    Free(remove::Error),
    Callback(callback::Error),
    Control(control::Error),
    Pair(pair::Error),
    Stream(stream::Error),
    Transport(transport::Error),
    Manager(manager::Error),
    Boundary(&'static str),
    Overflow,
    InvalidHierarchy,
    UnknownMethod(u32),
    NullImplementation,
    Cleanup {
        primary: Box<Error>,
        cleanup: Box<Error>,
    },
}
macro_rules! conversion {
    ($t:ty,$v:ident) => {
        impl From<$t> for Error {
            fn from(e: $t) -> Self {
                Self::$v(e)
            }
        }
    };
}
conversion!(read::Error, Read);
conversion!(init::Error, Write);
conversion!(remove::Error, Free);
conversion!(callback::Error, Callback);
conversion!(control::Error, Control);
conversion!(pair::Error, Pair);
conversion!(stream::Error, Stream);
conversion!(transport::Error, Transport);
conversion!(manager::Error, Manager);
pub trait Boundary: stream::Boundary + transport::Boundary {
    /// Native8FB650 creates a40-byte file-log resource and registers its logger
    /// callback when enabled. Never report success until that resource exists.
    fn prepare_recording(&mut self, _stream: u32, _path: u32) -> Result<bool, &'static str> {
        Err("native8FB650 recording resource/logger/file preparation is not connected")
    }
}
pub struct Request<'a> {
    pub callback: u32,
    pub arguments: [u32; 2],
    pub key: &'a [u8; 16],
    pub host: Option<&'a [u8]>,
    pub port: u32,
    pub mode: u32,
    pub flag: u32,
    pub extra: u32,
    pub recording_path: u32,
    pub recording: u32,
}
fn add(p: u32, o: u32) -> Result<u32, Error> {
    p.checked_add(o).ok_or(Error::Overflow)
}
fn put(b: &mut impl Storage, p: u32, o: u32, v: u32) -> Result<(), Error> {
    Ok(Storage::write_word(b, add(p, o)?, v)?)
}
fn free(b: &mut impl remove::Backend, p: u32) -> Result<(), Error> {
    let d = b.deallocator()?;
    Ok(b.free(p, d)?)
}
fn finish<T>(a: Result<T, Error>, b: Result<(), Error>) -> Result<T, Error> {
    match (a, b) {
        (Ok(v), Ok(())) => Ok(v),
        (Err(e), Ok(())) | (Ok(_), Err(e)) => Err(e),
        (Err(primary), Err(cleanup)) => Err(Error::Cleanup {
            primary: Box::new(primary),
            cleanup: Box::new(cleanup),
        }),
    }
}
fn delete_callback(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    if p != 0 {
        let vt = b.word(p)?;
        let f = b.word(vt)?;
        if f != callback::HANDLER_DELETE {
            return Err(Error::UnknownMethod(f));
        }
        callback::scalar_delete_callback(b, p, 1)?;
    }
    Ok(())
}
fn clone_callback(b: &mut impl Boundary, p: u32) -> Result<u32, Error> {
    if p == 0 {
        return Ok(0);
    }
    let vt = b.word(p)?;
    let f = b.word(add(vt, 4)?)?;
    if f == 0x5cce40 {
        return crate::audio_replay_callbacks::clone(b, p)
            .map_err(|_| Error::Boundary("parent clone failed"));
    }
    if f != callback::HANDLER_CLONE {
        return Err(Error::UnknownMethod(f));
    }
    Ok(callback::clone_callback(b, p)?)
}
/// Native8FB650 consumes its by-value metadata pair; recording path owns I/O.
pub fn prepare(
    b: &mut impl Boundary,
    p: u32,
    path: u32,
    enabled: u32,
    metadata: u32,
) -> Result<bool, Error> {
    let result = (|| {
        if b.word(metadata)? != 0 {
            pair::copy_assign(b, add(p, 0x38)?, metadata)?;
        }
        if enabled as u8 != 0 {
            b.prepare_recording(p, path).map_err(Error::Boundary)
        } else {
            Ok(true)
        }
    })();
    let cleanup = pair::destroy(b, metadata).map_err(Error::Pair);
    finish(result, cleanup)
}
pub fn construct_null(b: &mut impl Storage, p: u32) -> Result<u32, Error> {
    for (o, v) in [(0, NULL_VTABLE), (4, 0), (8, 0), (12, 0)] {
        put(b, p, o, v)?;
    }
    Ok(p)
}
pub fn scalar_delete_null(b: &mut impl Boundary, p: u32, flags: u32) -> Result<u32, Error> {
    put(b, p, 0, NULL_VTABLE)?;
    let c = b.word(add(p, 12)?)?;
    pair::release_control(b, c)?;
    put(b, p, 0, 0x1092aac)?;
    if flags & 1 != 0 {
        free(b, p)?;
    }
    Ok(p)
}
/// Native8F65B0/8F6600 consumes a shared-pair argument after copy assignment.
pub fn attach_manager(b: &mut impl Boundary, interface: u32, incoming: u32) -> Result<(), Error> {
    let result = (|| {
        let vt = b.word(interface)?;
        let f = b.word(add(vt, 4)?)?;
        let offset = match f {
            0x8f65b0 => 4,
            0x8f6600 => 8,
            _ => return Err(Error::UnknownMethod(f)),
        };
        pair::copy_assign(b, add(interface, offset)?, incoming)?;
        Ok(())
    })();
    let cleanup = pair::destroy(b, incoming).map_err(Error::Pair);
    finish(result, cleanup)
}
/// scratch is24 bytes of caller-owned, non-overlapping temporary pair storage.
/// A state other than1 is a native no-op returning0 and consuming the callback.
pub fn open(b: &mut impl Boundary, p: u32, r: Request<'_>, scratch: u32) -> Result<u32, Error> {
    let result = (|| {
        let mut current = b.word(add(p, 0x44)?)?;
        let mut visited = std::collections::BTreeSet::new();
        loop {
            if current == 0 {
                return Ok(0);
            }
            if !visited.insert(current) {
                return Err(Error::InvalidHierarchy);
            }
            if b.word(add(current, 12)?)? == 1 {
                break;
            }
            current = b.word(add(current, 16)?)?;
        }
        for o in (0..24).step_by(4) {
            put(b, scratch, o, 0)?;
        }
        if !prepare(b, p, r.recording_path, r.recording, scratch)? {
            return Ok(4);
        }
        let implementation = if r.mode as u8 != 0 {
            let q = b.allocate(16)?;
            if q != 0 {
                construct_null(b, q)?;
            }
            control::replace_pair(b, scratch, q)?;
            q
        } else {
            let q = b.allocate(transport::BYTES)?;
            if q != 0 {
                transport::construct(b, q)?;
            }
            transport::wrap(b, scratch, q)?;
            if q == 0 {
                0
            } else {
                add(q, transport::INTERFACE)?
            }
        };
        pair::move_assign(b, add(p, 0x64)?, scratch)?;
        pair::destroy(b, scratch)?;
        if implementation == 0 {
            return Err(Error::NullImplementation);
        }
        let incoming = clone_callback(b, r.callback)?;
        let configure = (|| {
            let vt = b.word(implementation)?;
            let f = b.word(add(vt, 16)?)?;
            match f {
                0x8f6eb0 => Ok(transport::configure(
                    b,
                    implementation,
                    incoming,
                    r.arguments,
                    r.key,
                    r.host,
                    r.port,
                    r.flag,
                    r.extra,
                )?),
                0x8f6650 => {
                    delete_callback(b, incoming)?;
                    Ok(0)
                }
                _ => {
                    delete_callback(b, incoming)?;
                    Err(Error::UnknownMethod(f))
                }
            }
        })()?;
        let object = b.allocate(48)?;
        if object != 0 {
            manager::construct(b, object)?;
        }
        let temporary = add(scratch, 8)?;
        managers::replace_pair(b, temporary, object)?;
        pair::move_assign(b, add(p, 0x6c)?, temporary)?;
        pair::destroy(b, temporary)?;
        let argument = add(scratch, 16)?;
        pair::copy(b, argument, add(p, 0x6c)?)?;
        // The source rereads the current implementation after manager publication.
        let implementation = b.word(add(p, 0x64)?)?;
        attach_manager(b, implementation, argument)?;
        if configure == 0 {
            stream::dispatch_event(b, add(p, 0x40)?, 0)?;
        }
        Ok(configure)
    })();
    let cleanup = delete_callback(b, r.callback);
    finish(result, cleanup)
}
