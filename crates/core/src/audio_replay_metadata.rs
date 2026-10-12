//! Original512-byte parent replay metadata:727DE0 base and728FD0 inline suffix.
//! Construction, clear7280B0, destruction727F80/729D20 and standard control5A3220.
//! Frame parsing and metadata update methods are separate contracts.
use crate::audio_announcer_object_lookup as read;
use crate::audio_announcer_registry_init::{self as init, Storage};
use crate::audio_announcer_registry_remove::{self as removal, Backend as Free, Deallocator};
use std::collections::BTreeSet;
pub const BYTES: u32 = 512;
pub const VTABLE: u32 = 0x10b00c4;
pub const BASE_VTABLE: u32 = 0x10b0138;
pub const SCALAR_DELETE: u32 = 0x729d20;
pub const CONTROL_VTABLE: u32 = 0x1085f4c;
pub const DISPOSE: u32 = 0x5a3220;
#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Read(read::Error),
    Write(init::Error),
    Free(removal::Error),
    Boundary(&'static str),
    InvalidTree,
    AddressOverflow,
    AllocationFailed(u32),
    UnknownDestructor(u32),
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
pub trait Boundary: Storage + Free {
    fn read_byte(&mut self, address: u32) -> Result<u8, read::Error>;
    ///Lock header has flag+0, owner+4 and a24-byte native critical section at+8.
    fn initialize_lock(&mut self, header: u32) -> Result<(), &'static str>;
    fn destroy_lock(&mut self, header: u32) -> Result<(), &'static str>;
    fn enter_lock(&mut self, header: u32) -> Result<(), &'static str>;
    fn leave_lock(&mut self, header: u32) -> Result<(), &'static str>;
}
fn add(p: u32, n: u32) -> Result<u32, Error> {
    p.checked_add(n).ok_or(Error::AddressOverflow)
}
fn w(b: &mut impl Boundary, p: u32, n: u32) -> Result<u32, Error> {
    Ok(b.word(add(p, n)?)?)
}
fn put(b: &mut impl Boundary, p: u32, n: u32, v: u32) -> Result<(), Error> {
    Ok(Storage::write_word(b, add(p, n)?, v)?)
}
fn byte(b: &mut impl Boundary, p: u32, n: u32, v: u8) -> Result<(), Error> {
    Ok(b.write_byte(add(p, n)?, v)?)
}
fn free(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    let route = b.deallocator()?;
    Ok(b.free(p, route)?)
}
fn nil(b: &mut impl Boundary, p: u32) -> Result<bool, Error> {
    Ok(b.read_byte(add(p, 13)?)? != 0)
}
fn empty_string(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    put(b, p, 20, 15)?;
    put(b, p, 16, 0)?;
    byte(b, p, 0, 0)
}
fn destroy_string(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    if w(b, p, 20)? >= 16 {
        let raw = w(b, p, 0)?;
        free(b, raw)?;
    }
    empty_string(b, p)
}
fn sentinel(b: &mut impl Boundary, bytes: u32) -> Result<u32, Error> {
    let p = b.allocate(bytes)?;
    if p == 0 {
        return Err(Error::AllocationFailed(bytes));
    }
    for offset in [0, 4, 8] {
        put(b, p, offset, p)?;
    }
    byte(b, p, 12, 1)?;
    byte(b, p, 13, 1)?;
    Ok(p)
}
///Caller allocates512 bytes via the engine allocator, as728FD0 does.
///Only source-initialized bytes change; +4 and all padding retain allocation fill.
pub fn construct(b: &mut impl Boundary, p: u32) -> Result<u32, Error> {
    put(b, p, 0, BASE_VTABLE)?;
    for (offset, size) in [(8, 56), (16, 48), (24, 24)] {
        put(b, p, offset, 0)?;
        put(b, p, offset + 4, 0)?;
        let head = sentinel(b, size)?;
        put(b, p, offset, head)?;
    }
    for offset in [0x1a0, 0x1a4, 0x1a8, 0x1ac] {
        put(b, p, offset, 0)?;
    }
    empty_string(b, add(p, 0x1b0)?)?;
    byte(b, p, 0x1c8, 0)?;
    put(b, p, 0x1cc, 0)?;
    b.initialize_lock(add(p, 0x1c8)?).map_err(Error::Boundary)?;
    for offset in 0x20..0x1a0 {
        byte(b, p, offset, 0)?;
    }
    put(b, p, 0, VTABLE)?;
    empty_string(b, add(p, 0x1e8)?)?;
    Ok(p)
}
///728150 returns only AL. Counts above48 fail before entering the lock;
///unknown IDs still enter and leave it when the count passes that check.
pub fn set_count(b: &mut impl Boundary, p: u32, id: u32, count: u32) -> Result<u8, Error> {
    if count > 48 {
        return Ok(0);
    }
    let lock = add(p, 0x1c8)?;
    b.enter_lock(lock).map_err(Error::Boundary)?;
    let result = (|| -> Result<u8, Error> {
        let offset = match id {
            100 => 0x1a0,
            200 => 0x1a4,
            _ => return Ok(0),
        };
        put(b, p, offset, count)?;
        Ok(1)
    })();
    let unlock = b.leave_lock(lock).map_err(Error::Boundary);
    match (result, unlock) {
        (Ok(value), Ok(())) => Ok(value),
        (Err(e), Ok(())) | (Ok(_), Err(e)) => Err(e),
        (Err(primary), Err(cleanup)) => Err(Error::Cleanup {
            primary: Box::new(primary),
            cleanup: Box::new(cleanup),
        }),
    }
}
///7281C0 takes no lock and selects the counter bank using only selector's
///low byte. An unknown ID returns zero without touching metadata memory.
pub fn get_count(b: &mut impl Boundary, p: u32, id: u32, selector: u32) -> Result<u32, Error> {
    let offset = match (id, selector as u8 != 0) {
        (100, false) => 0x1a8,
        (200, false) => 0x1ac,
        (100, true) => 0x1a0,
        (200, true) => 0x1a4,
        _ => return Ok(0),
    };
    w(b, p, offset)
}

///5C65C0 visits right subtree, then current string/node, then left subtree.
///A custom string deallocator can replace its route before the node is freed.
fn clear_nodes(
    b: &mut impl Boundary,
    mut p: u32,
    strings: bool,
    seen: &mut BTreeSet<u32>,
) -> Result<(), Error> {
    while !nil(b, p)? {
        if !seen.insert(p) {
            return Err(Error::InvalidTree);
        }
        let right = w(b, p, 8)?;
        clear_nodes(b, right, strings, seen)?;
        let left = w(b, p, 0)?;
        let mut route = b.deallocator()?;
        if strings {
            if w(b, p, 0x2c)? >= 16 {
                let raw = w(b, p, 0x18)?;
                b.free(raw, route)?;
                if matches!(route, Deallocator::Custom { .. }) {
                    route = b.deallocator()?;
                }
            }
            put(b, p, 0x2c, 15)?;
            put(b, p, 0x28, 0)?;
            byte(b, p, 0x18, 0)?;
        }
        b.free(p, route)?;
        p = left;
    }
    Ok(())
}
fn clear_tree(b: &mut impl Boundary, p: u32, strings: bool) -> Result<(), Error> {
    let head = w(b, p, 0)?;
    let root = w(b, head, 4)?;
    clear_nodes(b, root, strings, &mut BTreeSet::new())?;
    for offset in [4, 0, 8] {
        put(b, head, offset, head)?;
    }
    put(b, p, 4, 0)
}
///7280B0 clears the two string maps and fixed arrays under the metadata lock.
///It preserves the third map, source counts1A0..1AC and both standalone strings.
pub fn clear(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    let lock = add(p, 0x1c8)?;
    b.enter_lock(lock).map_err(Error::Boundary)?;
    let result = (|| {
        for offset in [8, 16] {
            clear_tree(b, add(p, offset)?, true)?;
        }
        for offset in 0x20..0x1a0 {
            byte(b, p, offset, 0)?;
        }
        Ok(())
    })();
    let unlock = b.leave_lock(lock).map_err(Error::Boundary);
    match (result, unlock) {
        (Ok(()), Ok(())) => Ok(()),
        (Err(e), Ok(())) | (Ok(()), Err(e)) => Err(e),
        (Err(primary), Err(cleanup)) => Err(Error::Cleanup {
            primary: Box::new(primary),
            cleanup: Box::new(cleanup),
        }),
    }
}
fn destroy_base(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    put(b, p, 0, BASE_VTABLE)?;
    clear(b, p)?;
    b.destroy_lock(add(p, 0x1c8)?).map_err(Error::Boundary)?;
    destroy_string(b, add(p, 0x1b0)?)?;
    for (offset, strings) in [(24, false), (16, true), (8, true)] {
        let tree = add(p, offset)?;
        clear_tree(b, tree, strings)?;
        let head = w(b, tree, 0)?;
        free(b, head)?;
    }
    Ok(())
}
pub fn destroy(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    put(b, p, 0, VTABLE)?;
    destroy_string(b, add(p, 0x1e8)?)?;
    destroy_base(b, p)
}
pub fn scalar_delete(b: &mut impl Boundary, p: u32, flags: u32) -> Result<u32, Error> {
    destroy(b, p)?;
    if flags & 1 != 0 {
        free(b, p)?;
    }
    Ok(p)
}
///The standard control's raw+12 pointer is read at disposal time. Counters and
///control release remain owned by the existing shared-pair implementation.
pub fn dispose_control(b: &mut impl Boundary, control: u32) -> Result<(), Error> {
    let p = w(b, control, 12)?;
    if p != 0 {
        let vt = b.word(p)?;
        let method = b.word(vt)?;
        if method != SCALAR_DELETE {
            return Err(Error::UnknownDestructor(method));
        }
        scalar_delete(b, p, 1)?;
    }
    Ok(())
}
#[cfg(test)]
#[path = "audio_replay_metadata_tests.rs"]
mod tests;
