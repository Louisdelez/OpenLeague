//! Native diagnostic path registry8C59F0/8C5A50/8C8000 and8C5E90.
//! Owns an original24-byte-node map, not replay frame serialization.
use crate::audio_announcer_object_lookup as read;
use crate::audio_announcer_registry_init::{self as init, Storage};
use crate::audio_announcer_registry_remove::{self as removal, Backend as Free, Deallocator};
use std::collections::BTreeSet;
pub const FLAG: u32 = 0x2d8bab4;
pub const OBJECT: u32 = 0x2d8bac0;
pub const SIZE: u32 = 0x10a8;
pub const SHUTDOWN: u32 = 0xfa08b0;
#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Read(read::Error),
    Write(init::Error),
    Free(removal::Error),
    Boundary(&'static str),
    InvalidTree,
    AddressOverflow,
    AllocationFailed,
    CapacityExceeded,
    InvalidString,
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
    ///8C8C10 then8C8D30; unavailable crash-report OS/service teardown is not success.
    fn close_active(&mut self, _owner: u32) -> Result<(), &'static str> {
        Err("active crash-report shutdown8C8C10/8C8D30 is unavailable")
    }
    fn delete_callback(
        &mut self,
        _owner: u32,
        _method: u32,
        _free: bool,
    ) -> Result<(), &'static str> {
        Err("crash-report callback destruction is unavailable")
    }
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
fn byte(b: &mut impl Boundary, p: u32, n: u32) -> Result<u8, Error> {
    Ok(b.read_byte(add(p, n)?)?)
}
fn setbyte(b: &mut impl Boundary, p: u32, n: u32, v: u8) -> Result<(), Error> {
    Ok(b.write_byte(add(p, n)?, v)?)
}
fn color(b: &mut impl Boundary, p: u32, c: u8) -> Result<(), Error> {
    setbyte(b, p, 12, c)
}
fn nil(b: &mut impl Boundary, p: u32) -> Result<bool, Error> {
    Ok(byte(b, p, 13)? != 0)
}
fn head(b: &mut impl Boundary, p: u32) -> Result<u32, Error> {
    w(b, p, 0)
}
fn free(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    let route = b.deallocator()?;
    Ok(b.free(p, route)?)
}
fn bytes(b: &mut impl Boundary, p: u32) -> Result<Vec<u8>, Error> {
    if p == 0 {
        return Err(Error::InvalidString);
    }
    let mut out = Vec::new();
    let mut address = p;
    loop {
        let v = b.read_byte(address)?;
        if v == 0 {
            return Ok(out);
        }
        out.push(v);
        address = add(address, 1)?;
    }
}
///8C8000 writes selected fields only; padding and unrelated storage survive.
fn construct_base(b: &mut impl Boundary) -> Result<(), Error> {
    for off in [
        0, 4, 8, 12, 16, 20, 24, 28, 0x40, 0x44, 0x58, 0x64, 0x68, 0x1070, 0x1088, 0x20, 0x34,
    ] {
        put(b, OBJECT, off, 0)?;
    }
    for off in [0x24, 0x48, 0x6c] {
        setbyte(b, OBJECT, off, 0)?;
        setbyte(b, OBJECT, off + 1, 0)?;
    }
    setbyte(b, OBJECT, 0x106c, 0)?;
    for (off, v) in [(0x38, 7), (0x3c, u32::MAX), (0x5c, 7), (0x60, u32::MAX)] {
        put(b, OBJECT, off, v)?;
    }
    Ok(())
}
///8C5A50 normal return. Null sentinel allocation becomes an explicit error.
pub fn construct(b: &mut impl Boundary) -> Result<u32, Error> {
    construct_base(b)?;
    put(b, OBJECT, 0x1090, 0)?;
    put(b, OBJECT, 0x1094, 0)?;
    let sentinel = b.allocate(24)?;
    if sentinel == 0 {
        return Err(Error::AllocationFailed);
    }
    for off in [0, 4, 8] {
        put(b, sentinel, off, sentinel)?;
    }
    color(b, sentinel, 1)?;
    setbyte(b, sentinel, 13, 1)?;
    put(b, OBJECT, 0x1090, sentinel)?;
    put(b, OBJECT, 0x1098, 0)?;
    put(b, OBJECT, 0x109c, 0)?;
    setbyte(b, OBJECT, 0x10a0, 0)?;
    put(b, OBJECT, 0x10a4, 0)?;
    Ok(OBJECT)
}
///8C59F0 publishes bit0 before construction, registers once, and leaves other bits.
pub fn initialize(b: &mut impl Boundary) -> Result<u32, Error> {
    let flag = b.word(FLAG)?;
    if flag & 1 == 0 {
        Storage::write_word(b, FLAG, flag | 1)?;
        construct(b)?;
        b.register_shutdown(SHUTDOWN)?;
    }
    Ok(OBJECT)
}
fn find(b: &mut impl Boundary, tree: u32, key: u32) -> Result<Option<u32>, Error> {
    let sentinel = head(b, tree)?;
    let mut node = w(b, sentinel, 4)?;
    let mut found = sentinel;
    let mut seen = BTreeSet::new();
    while !nil(b, node)? {
        if !seen.insert(node) {
            return Err(Error::InvalidTree);
        }
        if w(b, node, 16)? >= key {
            found = node;
            node = w(b, node, 0)?;
        } else {
            node = w(b, node, 8)?;
        }
    }
    Ok(if found != sentinel && w(b, found, 16)? == key {
        Some(found)
    } else {
        None
    })
}
fn rotate(b: &mut impl Boundary, tree: u32, node: u32, left: bool) -> Result<(), Error> {
    let side = if left { 8 } else { 0 };
    let opposite = 8 - side;
    let pivot = w(b, node, side)?;
    let child = w(b, pivot, opposite)?;
    put(b, node, side, child)?;
    if !nil(b, child)? {
        put(b, child, 4, node)?;
    }
    let parent = w(b, node, 4)?;
    put(b, pivot, 4, parent)?;
    let sentinel = head(b, tree)?;
    if w(b, sentinel, 4)? == node {
        put(b, sentinel, 4, pivot)?;
    } else if w(b, parent, opposite)? == node {
        put(b, parent, opposite, pivot)?;
    } else {
        put(b, parent, side, pivot)?;
    }
    put(b, pivot, opposite, node)?;
    put(b, node, 4, pivot)
}
fn insert_node(b: &mut impl Boundary, tree: u32, node: u32) -> Result<bool, Error> {
    let sentinel = head(b, tree)?;
    let value = w(b, node, 16)?;
    let mut parent = sentinel;
    let mut current = w(b, sentinel, 4)?;
    let mut left = true;
    let mut seen = BTreeSet::new();
    while !nil(b, current)? {
        if !seen.insert(current) {
            return Err(Error::InvalidTree);
        }
        parent = current;
        let existing = w(b, current, 16)?;
        if existing == value {
            free(b, node)?;
            return Ok(false);
        }
        left = value < existing;
        current = w(b, current, if left { 0 } else { 8 })?;
    }
    let count = w(b, tree, 4)?;
    if count >= 0xaaaaaa9 {
        free(b, node)?;
        return Err(Error::CapacityExceeded);
    }
    put(b, tree, 4, count + 1)?;
    put(b, node, 4, parent)?;
    if parent == sentinel {
        put(b, sentinel, 4, node)?;
        put(b, sentinel, 0, node)?;
        put(b, sentinel, 8, node)?;
    } else {
        let side = if left { 0 } else { 8 };
        put(b, parent, side, node)?;
        if w(b, sentinel, side)? == parent {
            put(b, sentinel, side, node)?;
        }
    }
    let mut current = node;
    loop {
        let p = w(b, current, 4)?;
        if byte(b, p, 12)? != 0 {
            break;
        }
        let g = w(b, p, 4)?;
        let is_left = p == w(b, g, 0)?;
        let uncle = w(b, g, if is_left { 8 } else { 0 })?;
        if byte(b, uncle, 12)? == 0 {
            color(b, p, 1)?;
            color(b, uncle, 1)?;
            color(b, g, 0)?;
            current = g;
        } else {
            if current == w(b, p, if is_left { 8 } else { 0 })? {
                current = p;
                rotate(b, tree, current, is_left)?;
            }
            let p = w(b, current, 4)?;
            color(b, p, 1)?;
            let g = w(b, p, 4)?;
            color(b, g, 0)?;
            rotate(b, tree, g, !is_left)?;
        }
    }
    let root = w(b, sentinel, 4)?;
    color(b, root, 1)?;
    Ok(true)
}

fn value_slot(b: &mut impl Boundary, tree: u32, key: u32) -> Result<u32, Error> {
    if let Some(node) = find(b, tree, key)? {
        return add(node, 20);
    }
    let node = b.allocate(24)?;
    if node == 0 {
        return Err(Error::AllocationFailed);
    }
    for off in [0, 4, 8] {
        let sentinel = head(b, tree)?;
        put(b, node, off, sentinel)?;
    }
    color(b, node, 0)?;
    setbyte(b, node, 13, 0)?;
    put(b, node, 16, key)?;
    put(b, node, 20, 0)?;
    if !insert_node(b, tree, node)? {
        return Err(Error::InvalidTree);
    }
    add(node, 20)
}
fn hash(name: &[u8]) -> u32 {
    name.iter().fold(0x811c9dc5u32, |v, &byte| {
        let lower = if byte.is_ascii_uppercase() {
            byte + 32
        } else {
            byte
        };
        v.wrapping_mul(0x1000193) ^ (lower as i8 as i32 as u32)
    })
}
fn active(b: &mut impl Boundary, p: u32) -> Result<bool, Error> {
    Ok(byte(b, p, 0x10a0)? != 0 && byte(b, p, 0x10a4)? & 1 != 0)
}
///8C5D10/8C5DC0/8C5E50: case-folded FNV-1 map and256-byte value rows.
///For paths >=256 bytes the native secure formatter returns-1: its subsequent
///padding overwrites the preceding '=' as well. This exact behavior is retained.
pub fn register_named(
    b: &mut impl Boundary,
    p: u32,
    name: &[u8],
    path: u32,
) -> Result<bool, Error> {
    if !active(b, p)? {
        return Ok(false);
    }
    let name = &name[..name.iter().position(|v| *v == 0).unwrap_or(name.len())];
    let key = hash(name);
    let tree = add(p, 0x1090)?;
    let value = if let Some(node) = find(b, tree, key)? {
        w(b, node, 20)?
    } else {
        let old = w(b, p, 0x109c)?;
        let needed = (name.len() as u32).wrapping_add(0x101);
        let total = old.wrapping_add(needed);
        if total > 0x80000 {
            return Ok(false);
        }
        let base = add(w(b, p, 0x68)?, old)?;
        for (i, &v) in name.iter().enumerate() {
            setbyte(b, base, i as u32, v)?;
        }
        setbyte(b, base, name.len() as u32, b'=')?;
        setbyte(b, base, name.len() as u32 + 1, 0)?;
        let value = add(base, name.len() as u32 + 1)?;
        let slot = value_slot(b, tree, key)?;
        put(b, slot, 0, value)?;
        put(b, p, 0x109c, total)?;
        value
    };
    let text = bytes(b, path)?;
    if text.len() < 256 {
        for (i, &v) in text.iter().enumerate() {
            setbyte(b, value, i as u32, v)?;
        }
        for i in text.len()..255 {
            setbyte(b, value, i as u32, b' ')?;
        }
    } else {
        let start = value.checked_sub(1).ok_or(Error::AddressOverflow)?;
        for i in 0..256 {
            setbyte(b, start, i, b' ')?;
        }
    }
    setbyte(b, value, 255, b'\n')?;
    Ok(true)
}
///8C5E90 increments even if buffer insertion fails; names use signed decimal.
pub fn register_path(b: &mut impl Boundary, p: u32, path: u32) -> Result<bool, Error> {
    if !active(b, p)? {
        return Ok(false);
    }
    let count = w(b, p, 0x1098)?.wrapping_add(1);
    put(b, p, 0x1098, count)?;
    register_named(b, p, format!("LogFile{}", count as i32).as_bytes(), path)
}
fn clear_nodes(
    b: &mut impl Boundary,
    mut node: u32,
    seen: &mut BTreeSet<u32>,
) -> Result<(), Error> {
    while !nil(b, node)? {
        if !seen.insert(node) {
            return Err(Error::InvalidTree);
        }
        let right = w(b, node, 8)?;
        clear_nodes(b, right, seen)?;
        let left = w(b, node, 0)?;
        free(b, node)?;
        node = left;
    }
    Ok(())
}
///8C5AE0 normal destruction of callback and two native wide strings.
fn destroy_base(b: &mut impl Boundary) -> Result<(), Error> {
    let callback = w(b, OBJECT, 0x1088)?;
    if callback != 0 {
        let vt = b.word(callback)?;
        let method = w(b, vt, 16)?;
        b.delete_callback(callback, method, callback != OBJECT + 0x1078)
            .map_err(Error::Boundary)?;
        put(b, OBJECT, 0x1088, 0)?;
    }
    let mut route = b.deallocator()?;
    if w(b, OBJECT, 0x5c)? >= 8 {
        let pointer = w(b, OBJECT, 0x48)?;
        b.free(pointer, route)?;
        if matches!(route, Deallocator::Custom { .. }) {
            route = b.deallocator()?;
        }
    }
    put(b, OBJECT, 0x5c, 7)?;
    put(b, OBJECT, 0x58, 0)?;
    setbyte(b, OBJECT, 0x48, 0)?;
    setbyte(b, OBJECT, 0x49, 0)?;
    if w(b, OBJECT, 0x38)? >= 8 {
        let pointer = w(b, OBJECT, 0x24)?;
        b.free(pointer, route)?;
    }
    put(b, OBJECT, 0x38, 7)?;
    put(b, OBJECT, 0x34, 0)?;
    setbyte(b, OBJECT, 0x24, 0)?;
    setbyte(b, OBJECT, 0x25, 0)?;
    Ok(())
}
///8C5BB0/FA08B0: caller invokes exactly once after successful initialize.
///Like the source, leaves initialization bit and freed sentinel label untouched.
pub fn shutdown(b: &mut impl Boundary) -> Result<(), Error> {
    if byte(b, OBJECT, 0x10a0)? != 0 {
        if byte(b, OBJECT, 0x106c)? != 0 {
            b.close_active(OBJECT).map_err(Error::Boundary)?;
            Storage::write_word(b, 0x2d78de8, 0)?;
            setbyte(b, OBJECT, 0x106c, 0)?;
        }
        setbyte(b, OBJECT, 0x10a0, 0)?;
    }
    let sentinel = w(b, OBJECT, 0x1090)?;
    let root = w(b, sentinel, 4)?;
    clear_nodes(b, root, &mut BTreeSet::new())?;
    for off in [4, 0, 8] {
        put(b, sentinel, off, sentinel)?;
    }
    put(b, OBJECT, 0x1094, 0)?;
    free(b, sentinel)?;
    destroy_base(b)
}
#[cfg(test)]
#[path = "audio_replay_path_registry_tests.rs"]
mod tests;
