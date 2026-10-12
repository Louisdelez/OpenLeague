//! Native loading record maps:5BE170 (standard140) and5BE1F0 (tutorial96).
//! Source field writes, unsigned keys, hinted insertion and native RB rotations.
use crate::audio_announcer_registry_init::Storage;
use crate::audio_announcer_registry_remove::Deallocator;
pub use crate::audio_replay_metadata::{Boundary, Error};
use std::collections::BTreeSet;
pub const STANDARD_NODE_BYTES: u32 = 140;
pub const TUTORIAL_NODE_BYTES: u32 = 96;
pub const TUTORIAL_CONSTRUCTION_BYTE: u32 = 0x14c758b;
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Kind {
    Standard,
    Tutorial,
}
impl Kind {
    pub fn node_bytes(self) -> u32 {
        match self {
            Self::Standard => 140,
            Self::Tutorial => 96,
        }
    }
    pub fn max_size(self) -> u32 {
        match self {
            Self::Standard => 0x1d41d40,
            Self::Tutorial => 0x2aaaaa9,
        }
    }
    fn strings(self) -> &'static [u32] {
        match self {
            Self::Standard => &[0x74, 0x44],
            Self::Tutorial => &[0x3c],
        }
    }
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
fn nil(b: &mut impl Boundary, p: u32) -> Result<bool, Error> {
    Ok(byte(b, p, 13)? != 0)
}
fn color(b: &mut impl Boundary, p: u32, value: u8) -> Result<(), Error> {
    set_byte(b, p, 12, value)
}
fn free(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    let route = b.deallocator()?;
    Ok(b.free(p, route)?)
}
fn visit(seen: &mut BTreeSet<u32>, p: u32) -> Result<(), Error> {
    if seen.insert(p) {
        Ok(())
    } else {
        Err(Error::InvalidTree)
    }
}
///5CCFE0/5C23E0 iterator decrement/increment; the header is its own nil node.
fn adjacent(b: &mut impl Boundary, mut node: u32, next: bool) -> Result<u32, Error> {
    let side = if next { 8 } else { 0 };
    let opposite = 8 - side;
    if nil(b, node)? {
        return if next { Ok(node) } else { word(b, node, 8) };
    }
    let child = word(b, node, side)?;
    let mut seen = BTreeSet::new();
    if !nil(b, child)? {
        node = child;
        loop {
            visit(&mut seen, node)?;
            let child = word(b, node, opposite)?;
            if nil(b, child)? {
                return Ok(node);
            }
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
///5C64E0/5C6540, also inlined twice in5DB270/5DB550. Identical node/link contracts
///to the diagnostic registry tree, including header-root and extrema updates.
fn rotate(b: &mut impl Boundary, tree: u32, node: u32, left: bool) -> Result<(), Error> {
    let side = if left { 8 } else { 0 };
    let opposite = 8 - side;
    let pivot = word(b, node, side)?;
    let child = word(b, pivot, opposite)?;
    put(b, node, side, child)?;
    if !nil(b, child)? {
        put(b, child, 4, node)?;
    }
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
///5DB270/5DB550 own the pending node on the capacity failure path.
fn insert_at(
    b: &mut impl Boundary,
    kind: Kind,
    tree: u32,
    node: u32,
    parent: u32,
    left: bool,
) -> Result<u32, Error> {
    let count = word(b, tree, 4)?;
    if count >= kind.max_size() {
        delete_pending_node(b, kind, node)?;
        return Err(Error::Boundary(
            "native loading record tree capacity exceeded",
        ));
    }
    put(b, tree, 4, count + 1)?;
    put(b, node, 4, parent)?;
    let head = word(b, tree, 0)?;
    if parent == head {
        for offset in [4, 0, 8] {
            put(b, head, offset, node)?;
        }
    } else {
        let side = if left { 0 } else { 8 };
        put(b, parent, side, node)?;
        if word(b, head, side)? == parent {
            put(b, head, side, node)?;
        }
    }
    let mut current = node;
    loop {
        let parent = word(b, current, 4)?;
        if byte(b, parent, 12)? != 0 {
            break;
        }
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
///5DB440/5DB710 fallback unique insertion frees its new node when the key exists.
fn insert_unhinted(b: &mut impl Boundary, kind: Kind, tree: u32, node: u32) -> Result<u32, Error> {
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
        if parent == word(b, head, 0)? {
            return insert_at(b, kind, tree, node, parent, true);
        }
        previous = adjacent(b, previous, false)?;
    }
    if word(b, previous, 16)? < key {
        insert_at(b, kind, tree, node, parent, left)
    } else {
        delete_pending_node(b, kind, node)?;
        Ok(previous)
    }
}
///5D32E0/5D3530 accept the lower_bound hint retained before allocation.
fn insert_hint(
    b: &mut impl Boundary,
    kind: Kind,
    tree: u32,
    node: u32,
    hint: u32,
) -> Result<u32, Error> {
    let head = word(b, tree, 0)?;
    if word(b, tree, 4)? == 0 {
        return insert_at(b, kind, tree, node, head, true);
    }
    let key = word(b, node, 16)?;
    if hint == word(b, head, 0)? {
        if key < word(b, hint, 16)? {
            return insert_at(b, kind, tree, node, hint, true);
        }
    } else if hint == head {
        let maximum = word(b, head, 8)?;
        if word(b, maximum, 16)? < key {
            return insert_at(b, kind, tree, node, maximum, false);
        }
    } else if key < word(b, hint, 16)? {
        let previous = adjacent(b, hint, false)?;
        if word(b, previous, 16)? < key {
            let right = word(b, previous, 8)?;
            return if nil(b, right)? {
                insert_at(b, kind, tree, node, previous, false)
            } else {
                insert_at(b, kind, tree, node, hint, true)
            };
        }
    } else if word(b, hint, 16)? < key {
        let next = adjacent(b, hint, true)?;
        if next == head || key < word(b, next, 16)? {
            let right = word(b, hint, 8)?;
            return if nil(b, right)? {
                insert_at(b, kind, tree, node, hint, false)
            } else {
                insert_at(b, kind, tree, node, next, true)
            };
        }
    }
    insert_unhinted(b, kind, tree, node)
}

fn reset_string(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    put(b, p, 20, 15)?;
    put(b, p, 16, 0)?;
    set_byte(b, p, 0, 0)
}
///564900, called separately for each string by pending-node deletion.
fn destroy_string(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    if word(b, p, 20)? >= 16 {
        let route = b.deallocator()?;
        let raw = word(b, p, 0)?;
        b.free(raw, route)?;
    }
    reset_string(b, p)
}
///5D56F0/5D5770, also capacity failure5DB270/5DB550.
fn delete_pending_node(b: &mut impl Boundary, kind: Kind, node: u32) -> Result<(), Error> {
    for &offset in kind.strings() {
        destroy_string(b, add(node, offset)?)?;
    }
    free(b, node)
}
///Constructor snippets57CE5C..57CE72 /5B2BF5..5B2C0B and native
///sentinels5C75C0/5C75F0. Caller owns the8-byte header storage.
pub fn construct(b: &mut impl Boundary, kind: Kind, tree: u32) -> Result<(), Error> {
    put(b, tree, 0, 0)?;
    put(b, tree, 4, 0)?;
    let node = b.allocate(kind.node_bytes())?;
    if node == 0 {
        return Err(Error::AllocationFailed(kind.node_bytes()));
    }
    for offset in [0, 4, 8] {
        put(b, node, offset, node)?;
    }
    set_byte(b, node, 12, 1)?;
    set_byte(b, node, 13, 1)?;
    put(b, tree, 0, node)
}
fn standard_value(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    put(b, p, 0, 0)?;
    let flags = byte(b, p, 0x18)?;
    set_byte(b, p, 0x18, flags & 0xfe)?;
    for offset in [0x14, 4, 8, 0xc, 0x10, 0x1c, 0x20, 0x24, 0x28, 0x2c, 0x40] {
        put(b, p, offset, 0)?;
    }
    put(b, p, 0x44, 15)?;
    set_byte(b, p, 0x30, 0)?;
    for offset in [0x48, 0x4c, 0x54, 0x58, 0x5c] {
        put(b, p, offset, 0)?;
    }
    put(b, p, 0x50, 0x40a00000)?;
    put(b, p, 0x70, 0)?;
    put(b, p, 0x74, 15)?;
    set_byte(b, p, 0x60, 0)
}
fn tutorial_pair(b: &mut impl Boundary, p: u32, key_ref: u32) -> Result<(), Error> {
    let key = b.word(key_ref)?;
    put(b, p, 0, key)?;
    put(b, p, 4, 0)?;
    let flags = byte(b, p, 0x1c)?;
    set_byte(b, p, 0x1c, flags & 0xfe)?;
    for offset in [0x18, 8, 0xc, 0x10, 0x14, 0x20, 0x24, 0x28, 0x3c] {
        put(b, p, offset, 0)?;
    }
    put(b, p, 0x40, 15)?;
    set_byte(b, p, 0x2c, 0)?;
    put(b, p, 0x44, 0)?;
    put(b, p, 0x4c, 0)?;
    put(b, p, 0x48, 0x40a00000)
}
fn allocate_node(b: &mut impl Boundary, kind: Kind, tree: u32, key_ref: u32) -> Result<u32, Error> {
    let node = b.allocate(kind.node_bytes())?;
    if node == 0 {
        return Err(Error::AllocationFailed(kind.node_bytes()));
    }
    for offset in [0, 4, 8] {
        let head = word(b, tree, 0)?;
        put(b, node, offset, head)?;
    }
    set_byte(b, node, 12, 0)?;
    set_byte(b, node, 13, 0)?;
    match kind {
        Kind::Standard => {
            let key = b.word(key_ref)?;
            put(b, node, 16, key)?;
            standard_value(b, add(node, 20)?)?;
        }
        Kind::Tutorial => {
            let _opaque = b.read_byte(TUTORIAL_CONSTRUCTION_BYTE)?;
            tutorial_pair(b, add(node, 16)?, key_ref)?;
        }
    }
    Ok(node)
}
///5BE170/5BE1F0: preserve key reads before search, after search and after
///allocation. A custom allocator may change the referenced key before ctor.
pub fn record_slot(
    b: &mut impl Boundary,
    kind: Kind,
    tree: u32,
    key_ref: u32,
) -> Result<u32, Error> {
    let head = word(b, tree, 0)?;
    let mut hint = head;
    let mut current = word(b, head, 4)?;
    if !nil(b, current)? {
        let key = b.word(key_ref)?;
        let mut seen = BTreeSet::new();
        loop {
            visit(&mut seen, current)?;
            if word(b, current, 16)? < key {
                current = word(b, current, 8)?;
            } else {
                hint = current;
                current = word(b, current, 0)?;
            }
            if nil(b, current)? {
                break;
            }
        }
    }
    if hint != head {
        let key = b.word(key_ref)?;
        if key >= word(b, hint, 16)? {
            return add(hint, 20);
        }
    }
    let node = allocate_node(b, kind, tree, key_ref)?;
    add(insert_hint(b, kind, tree, node, hint)?, 20)
}
///5C6C10/5C6D00 traverse right,current,left. Native caches the free callback
///per node and reloads it only after a custom string free.
fn clear_nodes(
    b: &mut impl Boundary,
    kind: Kind,
    mut node: u32,
    seen: &mut BTreeSet<u32>,
) -> Result<(), Error> {
    while !nil(b, node)? {
        visit(seen, node)?;
        let right = word(b, node, 8)?;
        clear_nodes(b, kind, right, seen)?;
        let first = kind.strings()[0];
        let first_long = word(b, node, first + 20)? >= 16;
        let left = word(b, node, 0)?;
        let mut route = b.deallocator()?;
        for (i, &offset) in kind.strings().iter().enumerate() {
            let long = if i == 0 {
                first_long
            } else {
                word(b, node, offset + 20)? >= 16
            };
            if long {
                let raw = word(b, node, offset)?;
                b.free(raw, route)?;
                if matches!(route, Deallocator::Custom { .. }) {
                    route = b.deallocator()?;
                }
            }
            reset_string(b, add(node, offset)?)?;
        }
        b.free(node, route)?;
        node = left;
    }
    Ok(())
}
///Whole-range5C36B0/5C3770 branch; preserves the allocated sentinel.
pub fn clear(b: &mut impl Boundary, kind: Kind, tree: u32) -> Result<(), Error> {
    let head = word(b, tree, 0)?;
    let root = word(b, head, 4)?;
    clear_nodes(b, kind, root, &mut BTreeSet::new())?;
    for offset in [4, 0, 8] {
        let head = word(b, tree, 0)?;
        put(b, head, offset, head)?;
    }
    put(b, tree, 4, 0)
}
///Tree-only native destructors57D1E0/5B3090, also inlined by owners.
///The caller-owned header retains its now-retired pointer, exactly as native.
pub fn destroy(b: &mut impl Boundary, kind: Kind, tree: u32) -> Result<(), Error> {
    clear(b, kind, tree)?;
    let route = b.deallocator()?;
    let head = word(b, tree, 0)?;
    b.free(head, route)?;
    Ok(())
}
#[cfg(test)]
#[path = "audio_loading_record_tree_tests.rs"]
mod tests;
