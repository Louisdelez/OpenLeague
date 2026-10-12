//! Native24-byte metadata state tree64D040 and markers728A40/728A60.
//! The containing metadata object constructs and destroys the sentinel/tree.
use crate::audio_announcer_object_lookup as read;
use crate::audio_announcer_registry_init::{self as init, Storage};
use crate::audio_announcer_registry_remove as removal;
pub use crate::audio_replay_metadata::Boundary;
use std::collections::BTreeSet;

pub const TREE_OFFSET: u32 = 0x18;
pub const NODE_BYTES: u32 = 24;
pub const MAX_SIZE: u32 = 0x0aaa_aaa9;

#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Read(read::Error),
    Write(init::Error),
    Free(removal::Error),
    AddressOverflow,
    InvalidTree,
    AllocationFailed,
    CapacityExceeded,
}
impl From<read::Error> for Error {
    fn from(value: read::Error) -> Self { Self::Read(value) }
}
impl From<init::Error> for Error {
    fn from(value: init::Error) -> Self { Self::Write(value) }
}
impl From<removal::Error> for Error {
    fn from(value: removal::Error) -> Self { Self::Free(value) }
}
fn add(p: u32, offset: u32) -> Result<u32, Error> {
    p.checked_add(offset).ok_or(Error::AddressOverflow)
}
fn word(b: &mut impl Boundary, p: u32, offset: u32) -> Result<u32, Error> {
    Ok(b.word(add(p, offset)?)?)
}
fn put(b: &mut impl Boundary, p: u32, offset: u32, value: u32) -> Result<(), Error> {
    Ok(Storage::write_word(b, add(p, offset)?, value)?)
}
fn byte(b: &mut impl Boundary, p: u32, offset: u32) -> Result<u8, Error> {
    Ok(b.read_byte(add(p, offset)?)?)
}
fn set_byte(b: &mut impl Boundary, p: u32, offset: u32, value: u8) -> Result<(), Error> {
    Ok(b.write_byte(add(p, offset)?, value)?)
}
fn nil(b: &mut impl Boundary, p: u32) -> Result<bool, Error> { Ok(byte(b, p, 13)? != 0) }
fn color(b: &mut impl Boundary, p: u32, value: u8) -> Result<(), Error> {
    set_byte(b, p, 12, value)
}
fn free(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    let route = b.deallocator()?;
    Ok(b.free(p, route)?)
}
fn visit(seen: &mut BTreeSet<u32>, p: u32) -> Result<(), Error> {
    if seen.insert(p) { Ok(()) } else { Err(Error::InvalidTree) }
}
///64D040 lower_bound retains the first node whose unsigned key is >= input.
fn lower_bound(b: &mut impl Boundary, tree: u32, key: u32) -> Result<u32, Error> {
    let head = word(b, tree, 0)?;
    let mut found = head;
    let mut node = word(b, head, 4)?;
    let mut seen = BTreeSet::new();
    while !nil(b, node)? {
        visit(&mut seen, node)?;
        if word(b, node, 16)? >= key {
            found = node;
            node = word(b, node, 0)?;
        } else {
            node = word(b, node, 8)?;
        }
    }
    Ok(found)
}
///5CCFE0/5C23E0 iterator decrement/increment; the header is its own nil node.
fn adjacent(b: &mut impl Boundary, mut node: u32, next: bool) -> Result<u32, Error> {
    let side = if next { 8 } else { 0 };
    let opposite = 8 - side;
    if nil(b, node)? { return if next { Ok(node) } else { word(b, node, 8) }; }
    let child = word(b, node, side)?;
    let mut seen = BTreeSet::new();
    if !nil(b, child)? {
        node = child;
        loop {
            visit(&mut seen, node)?;
            let child = word(b, node, opposite)?;
            if nil(b, child)? { return Ok(node); }
            node = child;
        }
    }
    let mut parent = word(b, node, 4)?;
    while !nil(b, parent)? && node == word(b, parent, side)? {
        visit(&mut seen, parent)?;
        node = parent;
        parent = word(b, parent, 4)?;
    }
    Ok(parent)
}
///5C64E0/5C6540, also inlined twice in5DA5E0. Identical node/link contracts
///to the diagnostic registry tree, including header-root and extrema updates.
fn rotate(b: &mut impl Boundary, tree: u32, node: u32, left: bool) -> Result<(), Error> {
    let side = if left { 8 } else { 0 };
    let opposite = 8 - side;
    let pivot = word(b, node, side)?;
    let child = word(b, pivot, opposite)?;
    put(b, node, side, child)?;
    if !nil(b, child)? { put(b, child, 4, node)?; }
    let parent = word(b, node, 4)?;
    put(b, pivot, 4, parent)?;
    let head = word(b, tree, 0)?;
    if word(b, head, 4)? == node {
        put(b, head, 4, pivot)?;
    } else if word(b, parent, opposite)? == node {
        put(b, parent, opposite, pivot)?;
    } else {
        put(b, parent, side, pivot)?;
    }
    put(b, pivot, opposite, node)?;
    put(b, node, 4, pivot)
}
///5DA5E0 owns the pending node on the capacity failure path.
fn insert_at(b: &mut impl Boundary, tree: u32, node: u32, parent: u32, left: bool) -> Result<u32, Error> {
    let count = word(b, tree, 4)?;
    if count >= MAX_SIZE {
        free(b, node)?;
        return Err(Error::CapacityExceeded);
    }
    put(b, tree, 4, count + 1)?;
    put(b, node, 4, parent)?;
    let head = word(b, tree, 0)?;
    if parent == head {
        for offset in [4, 0, 8] { put(b, head, offset, node)?; }
    } else {
        let side = if left { 0 } else { 8 };
        put(b, parent, side, node)?;
        if word(b, head, side)? == parent { put(b, head, side, node)?; }
    }
    let mut current = node;
    loop {
        let parent = word(b, current, 4)?;
        if byte(b, parent, 12)? != 0 { break; }
        let grandparent = word(b, parent, 4)?;
        let is_left = parent == word(b, grandparent, 0)?;
        let uncle = word(b, grandparent, if is_left { 8 } else { 0 })?;
        if byte(b, uncle, 12)? == 0 {
            color(b, parent, 1)?;
            color(b, uncle, 1)?;
            color(b, grandparent, 0)?;
            current = grandparent;
        } else {
            if current == word(b, parent, if is_left { 8 } else { 0 })? {
                current = parent;
                rotate(b, tree, current, is_left)?;
            }
            let parent = word(b, current, 4)?;
            color(b, parent, 1)?;
            let grandparent = word(b, parent, 4)?;
            color(b, grandparent, 0)?;
            rotate(b, tree, grandparent, !is_left)?;
        }
    }
    let root = word(b, head, 4)?;
    color(b, root, 1)?;
    Ok(node)
}
///5DA8C0 fallback unique insertion frees its new node when the key exists.
fn insert_unhinted(b: &mut impl Boundary, tree: u32, node: u32) -> Result<u32, Error> {
    let head = word(b, tree, 0)?;
    let key = word(b, node, 16)?;
    let mut parent = head;
    let mut current = word(b, head, 4)?;
    let mut left = true;
    let mut seen = BTreeSet::new();
    while !nil(b, current)? {
        visit(&mut seen, current)?;
        parent = current;
        left = key < word(b, current, 16)?;
        current = word(b, current, if left { 0 } else { 8 })?;
    }
    let mut previous = parent;
    if left {
        if parent == word(b, head, 0)? { return insert_at(b, tree, node, parent, true); }
        previous = adjacent(b, previous, false)?;
    }
    if word(b, previous, 16)? < key { insert_at(b, tree, node, parent, left) }
    else { free(b, node)?; Ok(previous) }
}
///663240 accepts the lower_bound hint retained before allocation.
fn insert_hint(b: &mut impl Boundary, tree: u32, node: u32, hint: u32) -> Result<u32, Error> {
    let head = word(b, tree, 0)?;
    if word(b, tree, 4)? == 0 { return insert_at(b, tree, node, head, true); }
    let key = word(b, node, 16)?;
    if hint == word(b, head, 0)? {
        if key < word(b, hint, 16)? { return insert_at(b, tree, node, hint, true); }
    } else if hint == head {
        let maximum = word(b, head, 8)?;
        if word(b, maximum, 16)? < key { return insert_at(b, tree, node, maximum, false); }
    } else if key < word(b, hint, 16)? {
        let previous = adjacent(b, hint, false)?;
        if word(b, previous, 16)? < key {
            let right = word(b, previous, 8)?;
            return if nil(b, right)? {
                insert_at(b, tree, node, previous, false)
            } else { insert_at(b, tree, node, hint, true) };
        }
    } else if word(b, hint, 16)? < key {
        let next = adjacent(b, hint, true)?;
        if next == head || key < word(b, next, 16)? {
            let right = word(b, hint, 8)?;
            return if nil(b, right)? {
                insert_at(b, tree, node, hint, false)
            } else { insert_at(b, tree, node, next, true) };
        }
    }
    insert_unhinted(b, tree, node)
}
///661F80/5D54A0 initialize only the source fields; padding14..15 stays untouched.
fn allocate_node(b: &mut impl Boundary, tree: u32, key: u32) -> Result<u32, Error> {
    let node = b.allocate(NODE_BYTES)?;
    if node == 0 { return Err(Error::AllocationFailed); }
    for offset in [0, 4, 8] {
        let head = word(b, tree, 0)?;
        put(b, node, offset, head)?;
    }
    set_byte(b, node, 12, 0)?;
    set_byte(b, node, 13, 0)?;
    put(b, node, 16, key)?;
    put(b, node, 20, 0)?;
    Ok(node)
}
///64D040. `tree` is the8-byte map header at metadata+18. Existing values are
///preserved; a missing key receives a new zero-initialized value slot.
pub fn value_slot(b: &mut impl Boundary, tree: u32, key: u32) -> Result<u32, Error> {
    let head = word(b, tree, 0)?;
    let hint = lower_bound(b, tree, key)?;
    if hint != head && key >= word(b, hint, 16)? { return add(hint, 20); }
    let node = allocate_node(b, tree, key)?;
    add(insert_hint(b, tree, node, hint)?, 20)
}
///728A40 leaves EAX pointing to the slot after writing1, without locking.
pub fn mark1(b: &mut impl Boundary, metadata: u32, key: u32) -> Result<u32, Error> {
    let slot = value_slot(b, add(metadata, TREE_OFFSET)?, key)?;
    put(b, slot, 0, 1)?;
    Ok(slot)
}
///728A60 leaves EAX pointing to the slot after writing2, without locking.
pub fn mark2(b: &mut impl Boundary, metadata: u32, key: u32) -> Result<u32, Error> {
    let slot = value_slot(b, add(metadata, TREE_OFFSET)?, key)?;
    put(b, slot, 0, 2)?;
    Ok(slot)
}

#[cfg(test)]
#[path = "audio_replay_metadata_state_tests.rs"]
mod tests;
