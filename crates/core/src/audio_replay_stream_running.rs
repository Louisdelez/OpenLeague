//! Native8F6AF0 start,8FB580 launch and8FB860/8FB7B0 worker loop.
//! Concrete network host creation/connection remains an explicit runtime boundary.
use crate::audio_announcer_object_lookup as read;
use crate::audio_announcer_registry_init as init;
use crate::audio_replay_stream as stream;
use crate::audio_replay_transport_thread as thread;
use std::collections::BTreeSet;

pub const WORKER: u32 = 0x8fb860;
#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Read(read::Error),
    Write(init::Error),
    Stream(stream::Error),
    Thread(thread::Error),
    Boundary(&'static str),
    AddressOverflow,
    InvalidHierarchy,
    UnknownMethod(u32),
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
impl From<stream::Error> for Error {
    fn from(e: stream::Error) -> Self {
        Self::Stream(e)
    }
}
impl From<thread::Error> for Error {
    fn from(e: thread::Error) -> Self {
        Self::Thread(e)
    }
}
pub trait Boundary: stream::Boundary {
    fn launch_stream_worker(&mut self, launch: &thread::Launch) -> Result<u32, &'static str>;
    fn start_implementation(
        &mut self,
        _object: u32,
        method: u32,
        args: &[u32],
    ) -> Result<u8, &'static str> {
        match (method, args.len()) {
            (0x573fb0, 2) | (0x6fa510, 4) => Ok(1),
            _ => Err("replay host creation/connection method is not connected"),
        }
    }
    fn sleep(&mut self, milliseconds: u32) -> Result<(), &'static str>;
    fn poll_implementation(&mut self, _object: u32, method: u32) -> Result<(), &'static str> {
        if method == 0x8f6670 {
            self.sleep(1000)
        } else {
            Err("replay active host polling is not connected")
        }
    }
}
fn add(p: u32, o: u32) -> Result<u32, Error> {
    p.checked_add(o).ok_or(Error::AddressOverflow)
}
fn word(b: &mut impl Boundary, p: u32, o: u32) -> Result<u32, Error> {
    Ok(b.word(add(p, o)?)?)
}
fn byte(b: &mut impl Boundary, p: u32, o: u32, v: u8) -> Result<(), Error> {
    Ok(b.write_byte(add(p, o)?, v)?)
}
pub fn has_state(b: &mut impl Boundary, p: u32, id: u32) -> Result<bool, Error> {
    let mut node = word(b, p, 0x44)?;
    let mut visited = BTreeSet::new();
    while node != 0 {
        if !visited.insert(node) {
            return Err(Error::InvalidHierarchy);
        }
        if word(b, node, 12)? == id {
            return Ok(true);
        }
        node = word(b, node, 16)?;
    }
    Ok(false)
}
///8FB780/8FB580 return1 after publishing the thread pair, including raw thread0.
/// The API boundary must report unavailable creation as an error, never as zero.
pub fn launch(b: &mut impl Boundary, p: u32) -> Result<u8, Error> {
    byte(b, p, 4, 0)?;
    byte(b, p, 5, 1)?;
    let raw = b
        .launch_stream_worker(&thread::Launch {
            callback: WORKER,
            argument: p,
            tag: *b"NetMain2\0\0\0\0\0\0\0\0",
            name: b"BaseApp::ThreadProc",
        })
        .map_err(Error::Boundary)?;
    thread::replace_thread_at(b, add(p, 8)?, raw)?;
    Ok(1)
}
/// State3 is required. Event1 publishes state4 before either implementation call.
/// Native return6/7 does not roll back the state or stop its worker.
pub fn start(b: &mut impl Boundary, p: u32, args: [u32; 6]) -> Result<u32, Error> {
    if !has_state(b, p, 3)? {
        return Ok(8);
    }
    if launch(b, p)? == 0 {
        let vt = b.word(p)?;
        let f = word(b, vt, 12)?;
        if f != 0x8f6bc0 {
            return Err(Error::UnknownMethod(f));
        }
        stream::stop(b, p)?;
        return Ok(5);
    }
    stream::dispatch_event(b, add(p, 0x40)?, 1)?;
    let object = word(b, p, 0x64)?;
    let vt = b.word(object)?;
    let f = word(b, vt, 8)?;
    if b.start_implementation(object, f, &[0, 0])
        .map_err(Error::Boundary)?
        == 0
    {
        return Ok(6);
    }
    // Both object and vtable are reloaded after the first virtual call.
    let object = word(b, p, 0x64)?;
    let vt = b.word(object)?;
    let f = word(b, vt, 12)?;
    Ok(
        if b.start_implementation(object, f, &[args[0], args[1], args[2], 8])
            .map_err(Error::Boundary)?
            == 0
        {
            7
        } else {
            0
        },
    )
}
pub fn request_exit(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    byte(b, p, 5, 0)
}
///8FB860's normal path: null argument is ignored. Its exception handler is not
/// substituted by a success result.5FA160 and5642D0 are verified native no-ops.
pub fn worker(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    if p == 0 {
        return Ok(());
    }
    while b.read_byte(add(p, 5)?)? != 0 {
        // Native code only rereads pause here, not the outer running flag.
        while b.read_byte(add(p, 6)?)? != 0 {
            b.sleep(100).map_err(Error::Boundary)?;
        }
        let vt = b.word(p)?;
        let f = b.word(vt)?;
        if f != 0x8f6c40 {
            return Err(Error::UnknownMethod(f));
        }
        let object = word(b, p, 0x64)?;
        let vt = b.word(object)?;
        let f = word(b, vt, 0x24)?;
        b.poll_implementation(object, f).map_err(Error::Boundary)?;
    }
    Ok(())
}
