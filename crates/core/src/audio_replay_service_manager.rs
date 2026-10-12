//! Source service72A800 callback publication and72A780 manager open/start.
use crate::{
    audio_announcer_object_lookup as read,
    audio_announcer_registry_init::{self as init, Storage},
    audio_replay_callbacks as callbacks, audio_replay_game_manager as manager,
    audio_replay_metadata as metadata,
};
pub const INITIALIZE: u32 = 0x72a800;
pub const EXTRA: u32 = 0x2d62a48;
#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Read(read::Error),
    Write(init::Error),
    Callback(callbacks::Error),
    Manager(manager::Error),
    UnknownMethod(u32),
    AddressOverflow,
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
impl From<callbacks::Error> for Error {
    fn from(e: callbacks::Error) -> Self {
        Self::Callback(e)
    }
}
impl From<manager::Error> for Error {
    fn from(e: manager::Error) -> Self {
        Self::Manager(e)
    }
}
fn add(p: u32, n: u32) -> Result<u32, Error> {
    p.checked_add(n).ok_or(Error::AddressOverflow)
}
/// Caller supplies8 bytes for the parent metadata temporary. The source ignores
/// the initialization byte, replaces callback20 then24, and consumes both temps.
pub fn initialize(b: &mut impl manager::Boundary, service: u32, scratch: u32) -> Result<(), Error> {
    let parent = manager::get(b)?;
    let _ = manager::initialize(b, parent, scratch)?;
    for (offset, factory, member) in [(0x20, 0x658f70, 0x738a3a), (0x24, 0x7338c0, 0x72b950)] {
        let temporary = callbacks::factory_member(b, factory, service, member, 0)?;
        let parent = manager::get(b)?;
        let incoming = callbacks::clone(b, temporary)?;
        let field = add(parent, offset)?;
        let old = b.word(field)?;
        Storage::write_word(b, field, 0)?;
        Storage::write_word(b, field, incoming)?;
        callbacks::delete(b, old)?;
        callbacks::delete(b, temporary)?;
    }
    Ok(())
}
pub struct Request<'a> {
    pub arguments: [u32; 2],
    pub key: &'a [u8; 16],
    pub host: Option<&'a [u8]>,
    pub start: [u32; 6],
    pub flag: u32,
    pub recording_path: u32,
    pub recording: u32,
}
/// Scratch24 is reused after initialization. The final three start words are
/// explicit caller-frame residue; source8F6AF0 currently ignores those words.
pub fn open(
    b: &mut impl manager::Boundary,
    service: u32,
    r: Request<'_>,
    scratch: u32,
) -> Result<u32, Error> {
    let vt = b.word(service)?;
    let method = b.word(add(vt, 0x1c)?)?;
    if method != INITIALIZE {
        return Err(Error::UnknownMethod(method));
    }
    initialize(b, service, scratch)?;
    let enabled = metadata::Boundary::read_byte(b, add(service, 0x122)?)?;
    let extra = b.word(EXTRA)?;
    let mode = if enabled != 0 && metadata::Boundary::read_byte(b, add(service, 0x12f)?)? == 0 {
        1
    } else {
        0
    };
    let parent = manager::get(b)?;
    Ok(manager::open(
        b,
        parent,
        manager::Request {
            arguments: r.arguments,
            key: r.key,
            host: r.host,
            start: r.start,
            mode,
            flag: r.flag,
            extra,
            recording_path: r.recording_path,
            recording: r.recording,
        },
        scratch,
    )?)
}
