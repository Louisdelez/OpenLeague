//! Native40-byte LogOut_File resource8F8E10, open8F8F10, write8F8ED0 and close8F8F90.
//! This writes diagnostic text; it does not serialize replay frames.
use crate::{
    audio_announcer_object_lookup as read, audio_announcer_owner_control as control,
    audio_announcer_owner_metadata as callback,
    audio_announcer_registry_init::{self as init, Storage},
    audio_announcer_registry_remove as remove, audio_replay_logger as logger,
    audio_replay_shared_pair as pair,
};
pub const MEMBER: u32 = 0x8f8ed0;
pub const CONTROL_VTABLE: u32 = 0x1085f8c;
pub const CONTROL_DISPOSE: u32 = 0x5d6340;
#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Read(read::Error),
    Write(init::Error),
    Free(remove::Error),
    Logger(logger::Error),
    Control(control::Error),
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
impl From<logger::Error> for Error {
    fn from(e: logger::Error) -> Self {
        Self::Logger(e)
    }
}
impl From<control::Error> for Error {
    fn from(e: control::Error) -> Self {
        Self::Control(e)
    }
}
impl From<pair::Error> for Error {
    fn from(e: pair::Error) -> Self {
        Self::Pair(e)
    }
}
pub trait Boundary: logger::Output {
    fn lock(&mut self, object: u32, enter: bool) -> Result<(), &'static str>;
    /// Original narrow fopen; zero is an observed open failure, Err is unavailable.
    fn file_open(&mut self, path: u32, mode: &[u8]) -> Result<u32, &'static str>;
    fn file_close(&mut self, file: u32) -> Result<i32, &'static str>;
    /// Original fprintf(file,"%s",message). The source ignores its numeric result.
    fn file_message(&mut self, file: u32, message: u32) -> Result<i32, &'static str>;
}
/// The path registration is the source8C59F0 getter followed by8C5E90.
/// It is called for every nonnull path, even when opening its file returned0.
pub trait Preparation: Boundary + pair::Boundary {
    fn register_path(&mut self, path: u32) -> Result<(), &'static str>;
}
fn add(p: u32, n: u32) -> Result<u32, Error> {
    p.checked_add(n).ok_or(Error::AddressOverflow)
}
fn word(b: &mut impl Boundary, p: u32, n: u32) -> Result<u32, Error> {
    Ok(b.word(add(p, n)?)?)
}
fn put(b: &mut impl Boundary, p: u32, n: u32, v: u32) -> Result<(), Error> {
    Ok(Storage::write_word(b, add(p, n)?, v)?)
}
fn locked<B: Boundary, T>(
    b: &mut B,
    p: u32,
    f: impl FnOnce(&mut B) -> Result<T, Error>,
) -> Result<T, Error> {
    b.lock(p, true).map_err(Error::Boundary)?;
    let v = f(b);
    let unlock = b.lock(p, false).map_err(Error::Boundary);
    match (v, unlock) {
        (Ok(v), Ok(())) => Ok(v),
        (Err(e), Ok(())) | (Ok(_), Err(e)) => Err(e),
        (Err(primary), Err(cleanup)) => Err(Error::Cleanup {
            primary: Box::new(primary),
            cleanup: Box::new(cleanup),
        }),
    }
}
pub fn construct(b: &mut impl Boundary, p: u32, scratch: u32) -> Result<u32, Error> {
    b.write_byte(p, 0)?;
    put(b, p, 4, 0)?;
    b.initialize_critical_section(add(p, 8)?)
        .map_err(Error::Boundary)?;
    put(b, p, 32, 0)?;
    b.write_byte(add(p, 36)?, 0)?;
    let incoming = b.allocate(12)?;
    if incoming != 0 {
        for (o, v) in [(0, callback::HANDLER_VTABLE), (4, p), (8, MEMBER)] {
            put(b, incoming, o, v)?;
        }
    }
    put(b, scratch, 4, incoming)?;
    let owner = logger::initialize(b)?;
    logger::append_callback(b, owner, add(scratch, 4)?, scratch)?;
    Ok(p)
}
fn log_state(b: &mut impl Boundary, stopped: bool) -> Result<(), Error> {
    let owner = logger::initialize(b)?;
    let message = if stopped {
        b"LogOut_File: : logfile stopped".as_slice()
    } else {
        b"LogOut_File: : logfile started".as_slice()
    };
    locked(b, owner, |b| {
        Ok(logger::write_message(b, owner, message, None, 0)?)
    })
}
pub fn open(b: &mut impl Boundary, p: u32, path: u32) -> Result<u8, Error> {
    if b.byte(add(p, 36)?).map_err(Error::Boundary)? == 0 {
        locked(b, p, |b| {
            let first = b.file_open(path, b"wc").map_err(Error::Boundary)?;
            put(b, p, 32, first)?;
            if first != 0 {
                let _ = b.file_close(first).map_err(Error::Boundary)?;
                let next = b.file_open(path, b"ac").map_err(Error::Boundary)?;
                put(b, p, 32, next)?;
                if next != 0 {
                    b.write_byte(add(p, 36)?, 1)?;
                }
            }
            Ok(())
        })?;
    }
    log_state(b, false)?;
    Ok(b.byte(add(p, 36)?).map_err(Error::Boundary)?)
}
pub fn message(b: &mut impl Boundary, p: u32, message: u32) -> Result<u8, Error> {
    if b.byte(add(p, 36)?).map_err(Error::Boundary)? == 0 {
        return Ok(0);
    }
    let file = word(b, p, 32)?;
    if file == 0 || message == 0 {
        return Ok(0);
    }
    let _ = b.file_message(file, message).map_err(Error::Boundary)?;
    Ok(1)
}
pub fn close(b: &mut impl Boundary, p: u32) -> Result<u8, Error> {
    if b.byte(add(p, 36)?).map_err(Error::Boundary)? != 0 {
        log_state(b, true)?;
        if word(b, p, 32)? != 0 {
            locked(b, p, |b| {
                let file = word(b, p, 32)?;
                let _ = b.file_close(file).map_err(Error::Boundary)?;
                put(b, p, 32, 0)?;
                b.write_byte(add(p, 36)?, 0)?;
                Ok(())
            })?;
        }
    }
    Ok((b.byte(add(p, 36)?).map_err(Error::Boundary)? == 0) as u8)
}
///5F9D70/5D6340 only delete the critical section and allocation. Their parent
/// must close first; they do not unregister the logger's cloned raw callback.
pub fn destroy(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    b.delete_critical_section(add(p, 8)?)
        .map_err(Error::Boundary)?;
    let route = b.deallocator().map_err(Error::Free)?;
    b.free(p, route).map_err(Error::Free)
}
/// Native5D6340 disposal reads the current raw pointer and skips a null resource.
/// File closure and logger-chain retirement belong to the source parent lifetime.
pub fn dispose_control(b: &mut impl Boundary, control: u32) -> Result<(), Error> {
    let resource = word(b, control, 12)?;
    if resource != 0 {
        destroy(b, resource)?;
    }
    Ok(())
}
/// Enabled branch of8FB650 only. The enclosing opening preparation handles the
/// metadata argument and low-byte recording gate. Caller owns16 scratch bytes.
/// The true return is source586220's logger-ready byte, not file-open success.
pub fn prepare(
    b: &mut impl Preparation,
    stream: u32,
    path: u32,
    scratch: u32,
) -> Result<bool, Error> {
    let resource = b.allocate(40)?;
    if resource != 0 {
        construct(b, resource, add(scratch, 8)?)?;
    }
    put(b, scratch, 0, 0)?;
    put(b, scratch, 4, 0)?;
    control::replace_pair_with_vtable(b, scratch, resource, CONTROL_VTABLE)?;
    pair::move_assign(b, add(stream, 0x30)?, scratch)?;
    pair::destroy(b, scratch)?;
    logger::initialize(b)?;
    //586220 is mov al,1; ret. It does not inspect the logger's file state.
    if path != 0 {
        let current = word(b, stream, 0x30)?;
        let _ = open(b, current, path)?;
        b.register_path(path).map_err(Error::Boundary)?;
    }
    Ok(true)
}
