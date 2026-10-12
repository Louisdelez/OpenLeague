//! Native2328-byte network implementation8F6D00/8F6EB0 and interface alias9018C0.
use crate::{
    audio_announcer_object_lookup as read,
    audio_announcer_owner_component_destructor::ControlBoundary,
    audio_announcer_owner_metadata as callback,
    audio_announcer_registry_init::{self as init, Storage},
    audio_announcer_registry_remove as remove, audio_replay_key as key,
    audio_replay_shared_pair as pair, audio_replay_transport_configuration as base,
};
pub const BYTES: u32 = 0x918;
pub const VTABLE: u32 = 0x10d6040;
pub const INTERFACE: u32 = 0xe0;
pub const INTERFACE_VTABLE: u32 = 0x10d6254;
pub const CONTROL_VTABLE: u32 = 0x10d5fdc;
pub const CONTROL_DISPOSE: u32 = 0x5d5fd0;
pub const CLOSE: u32 = 0x8f6fa0;
pub const SCALAR_DELETE: u32 = 0x8f6d90;
#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Read(read::Error),
    Write(init::Error),
    Free(remove::Error),
    Base(base::Error),
    Callback(callback::Error),
    Pair(pair::Error),
    Key(key::Error),
    Boundary(&'static str),
    Overflow,
    UnknownMethod(u32),
    NullKey,
    InvalidInterface,
    Cleanup {
        primary: Box<Error>,
        cleanup: Box<Error>,
    },
}
impl From<read::Error> for Error {
    fn from(v: read::Error) -> Self {
        Self::Read(v)
    }
}
impl From<init::Error> for Error {
    fn from(v: init::Error) -> Self {
        Self::Write(v)
    }
}
impl From<remove::Error> for Error {
    fn from(v: remove::Error) -> Self {
        Self::Free(v)
    }
}
impl From<base::Error> for Error {
    fn from(v: base::Error) -> Self {
        Self::Base(v)
    }
}
impl From<callback::Error> for Error {
    fn from(v: callback::Error) -> Self {
        Self::Callback(v)
    }
}
impl From<pair::Error> for Error {
    fn from(v: pair::Error) -> Self {
        Self::Pair(v)
    }
}
impl From<key::Error> for Error {
    fn from(v: key::Error) -> Self {
        Self::Key(v)
    }
}
pub trait Boundary: base::Boundary + ControlBoundary {
    fn scalar_delete_auxiliary(
        &mut self,
        _p: u32,
        _method: u32,
        _flags: u32,
    ) -> Result<(), &'static str> {
        Err("stream auxiliary scalar deletion is not connected")
    }
}
fn add(p: u32, o: u32) -> Result<u32, Error> {
    p.checked_add(o).ok_or(Error::Overflow)
}
fn put(b: &mut impl Storage, p: u32, o: u32, v: u32) -> Result<(), Error> {
    Ok(Storage::write_word(b, add(p, o)?, v)?)
}
fn free(b: &mut impl remove::Backend, p: u32) -> Result<(), Error> {
    let route = b.deallocator()?;
    Ok(b.free(p, route)?)
}
fn delete_callback(b: &mut impl base::Boundary, p: u32) -> Result<(), Error> {
    if p != 0 {
        let vt = b.word(p)?;
        let method = b.word(vt)?;
        if method != callback::HANDLER_DELETE {
            return Err(Error::UnknownMethod(method));
        }
        callback::scalar_delete_callback(b, p, 1)?;
    }
    Ok(())
}
fn clone_callback(b: &mut impl base::Boundary, p: u32) -> Result<u32, Error> {
    if p == 0 {
        return Ok(0);
    }
    let vt = b.word(p)?;
    let method = b.word(add(vt, 4)?)?;
    if method == 0x5cce40 {
        return crate::audio_replay_callbacks::clone(b, p)
            .map_err(|_| Error::Boundary("parent clone failed"));
    }
    if method != callback::HANDLER_CLONE {
        return Err(Error::UnknownMethod(method));
    }
    Ok(callback::clone_callback(b, p)?)
}
pub fn construct(b: &mut impl base::Boundary, p: u32) -> Result<u32, Error> {
    base::construct(b, p)?;
    put(b, p, 0xe0, 0x1092aac)?;
    put(b, p, 0, VTABLE)?;
    put(b, p, 0xe0, INTERFACE_VTABLE)?;
    for o in [0xe4, 0xe8, 0xec, 0xf0, 0xf8, 0x110, 0xf4] {
        put(b, p, o, 0)?;
    }
    put(b, p, 0x10c, 11)?;
    for i in 0..0x800 {
        b.write_byte(add(p, 0x114 + i)?, 0)?;
    }
    Ok(p)
}
pub fn close(b: &mut impl base::Boundary, p: u32) -> Result<(), Error> {
    let key = b.word(add(p, 0xec)?)?;
    if key != 0 {
        free(b, key)?;
        put(b, p, 0xec, 0)?;
    }
    base::close(b, p)?;
    put(b, p, 12, 0)
}
pub fn destroy(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    put(b, p, 0, VTABLE)?;
    put(b, p, 0xe0, INTERFACE_VTABLE)?;
    let key = b.word(add(p, 0xec)?)?;
    if key != 0 {
        free(b, key)?;
    }
    let resource = b.word(add(p, 0xf0)?)?;
    if resource != 0 {
        let vt = b.word(resource)?;
        let method = b.word(vt)?;
        b.scalar_delete_auxiliary(resource, method, 1)
            .map_err(Error::Boundary)?;
    }
    let control = b.word(add(p, 0xe8)?)?;
    pair::release_control(b, control)?;
    put(b, p, 0xe0, 0x1092aac)?;
    base::destroy(b, p)?;
    Ok(())
}
pub fn scalar_delete(b: &mut impl Boundary, p: u32, flags: u32) -> Result<u32, Error> {
    destroy(b, p)?;
    if flags & 1 != 0 {
        free(b, p)?;
    }
    Ok(p)
}
pub fn dispose_control(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    let object = b.word(add(p, 12)?)?;
    if object != 0 {
        let vt = b.word(object)?;
        let method = b.word(add(vt, 4)?)?;
        if method != SCALAR_DELETE {
            return Err(Error::UnknownMethod(method));
        }
        scalar_delete(b, object, 1)?;
    }
    Ok(())
}
/// The shared control owns the base pointer; its visible raw pointer is base+E0.
pub fn wrap(b: &mut impl StorageControl, destination: u32, object: u32) -> Result<(), Error> {
    let control = b.allocate(16)?;
    if control != 0 {
        for (o, v) in [(4, 1), (8, 1), (0, CONTROL_VTABLE), (12, object)] {
            put(b, control, o, v)?;
        }
    }
    let visible = if object == 0 {
        0
    } else {
        add(object, INTERFACE)?
    };
    let old = b.word(add(destination, 4)?)?;
    pair::release_control(b, old)?;
    put(b, destination, 4, control)?;
    put(b, destination, 0, visible)
}
pub trait StorageControl: Storage + ControlBoundary {}
impl<T: Storage + ControlBoundary> StorageControl for T {}
/// Native8F6EB0 consumes its incoming callback and gives a clone to8FC610.
pub fn configure(
    b: &mut impl base::Boundary,
    interface: u32,
    incoming: u32,
    arguments: [u32; 2],
    key_bytes: &[u8; 16],
    host: Option<&[u8]>,
    port: u32,
    flag: u32,
    extra: u32,
) -> Result<u32, Error> {
    let result = (|| {
        let p = interface
            .checked_sub(INTERFACE)
            .ok_or(Error::InvalidInterface)?;
        b.write_byte(add(interface, 0x28)?, flag as u8)?;
        b.write_byte(add(interface, 0x29)?, 0)?;
        put(b, interface, 0x14, extra)?;
        let key = b.allocate(key::OBJECT_BYTES as u32)?;
        if key == 0 {
            return Err(Error::NullKey);
        }
        if let Err(primary) = key::initialize(b, key, key_bytes, [0; 2]) {
            let cleanup = free(b, key);
            return match cleanup {
                Ok(()) => Err(Error::Key(primary)),
                Err(cleanup) => Err(Error::Cleanup {
                    primary: Box::new(Error::Key(primary)),
                    cleanup: Box::new(cleanup),
                }),
            };
        }
        put(b, interface, 12, key)?;
        let cloned = clone_callback(b, incoming)?;
        Ok(base::configure(
            b,
            p,
            cloned,
            arguments[0],
            arguments[1],
            host,
            port,
        )?)
    })();
    let cleanup = delete_callback(b, incoming);
    match (result, cleanup) {
        (Ok(v), Ok(())) => Ok(v),
        (Err(e), Ok(())) | (Ok(_), Err(e)) => Err(e),
        (Err(primary), Err(cleanup)) => Err(Error::Cleanup {
            primary: Box::new(primary),
            cleanup: Box::new(cleanup),
        }),
    }
}
