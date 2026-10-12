//! Pure selection/order candidate derived from 4.20 component and renderer code.
//!
//! Entries borrow opaque nonzero owner identities. This Vec does not port the
//! native RB tree, allocation/rotation trace, renderer, shaders or W activation.
//! Removal takes the owner's current priority, as native 739FB0 does; callers
//! must keep it unchanged while linked to avoid leaving an older node behind.
//! `submesh` is the String24 byte payload (length excludes the final terminator).
//! Case folding is the original default-C ASCII path, not Unicode case folding.

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Entry {
    pub owner: u32,
    pub priority: i32,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Properties<'a> {
    pub submesh: &'a [u8],
    pub flags: u32,
    pub shader44: u32,
    pub shader48: u32,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Error {
    Allocation,
    NullOwner,
    MissingOwner(u32),
}

#[derive(Default, Debug)]
pub struct Component {
    entries: Vec<Entry>,
}

impl Component {
    pub fn entries(&self) -> &[Entry] { &self.entries }

    /// 739F30: null is a no-op, pointer identity is deduplicated within the
    /// current priority's equal range. New equal-priority entries go first.
    /// `false` means no insertion. Host allocation error is a local adaptation,
    /// not a qualified native bad_alloc/exception path.
    pub fn insert(&mut self, owner: u32, priority: i32) -> Result<bool, Error> {
        if owner == 0 { return Ok(false); }
        if self.entries.iter().any(|e| e.owner == owner && e.priority == priority) {
            return Ok(false);
        }
        let index = self.entries.iter().position(|e| e.priority <= priority)
            .unwrap_or(self.entries.len());
        self.entries.try_reserve(1).map_err(|_| Error::Allocation)?;
        self.entries.insert(index, Entry { owner, priority });
        Ok(true)
    }

    /// 739FB0 removes one exact pointer from its current priority range.
    /// Native dereferences null; the candidate rejects it explicitly.
    pub fn remove(&mut self, owner: u32, current_priority: i32) -> Result<bool, Error> {
        if owner == 0 { return Err(Error::NullOwner); }
        if let Some(index) = self.entries.iter().position(|e|
            e.owner == owner && e.priority == current_priority) {
            self.entries.remove(index);
            return Ok(true);
        }
        Ok(false)
    }

    /// 73A050: priority >= signed floor, preserving the complete tie order.
    pub fn priority_range(&self, floor: i32) -> &[Entry] {
        let end = self.entries.iter().position(|e| e.priority < floor)
            .unwrap_or(self.entries.len());
        &self.entries[..end]
    }
}

fn c_string(bytes: &[u8]) -> &[u8] {
    &bytes[..bytes.iter().position(|b| *b == 0).unwrap_or(bytes.len())]
}

fn c_equal(a: &[u8], b: &[u8]) -> bool {
    c_string(a).iter().map(u8::to_ascii_lowercase)
        .eq(c_string(b).iter().map(u8::to_ascii_lowercase))
}

/// 9659D0. `output_index` is an index in the supplied range, the semantic
/// counterpart of its iterator; it changes on a hit only. A null range returns
/// no owner without consulting the lookup. Texture pointer validity is not
/// tested by this native selection operation.
pub fn select<'a>(
    range: Option<&[Entry]>,
    submesh: Option<&[u8]>,
    required_mask: u32,
    mut lookup: impl FnMut(u32) -> Option<Properties<'a>>,
    output_index: Option<&mut usize>,
) -> Result<Option<u32>, Error> {
    let Some(range) = range else { return Ok(None); };
    for (index, entry) in range.iter().enumerate() {
        let p = lookup(entry.owner).ok_or(Error::MissingOwner(entry.owner))?;
        if p.flags == 0 && p.shader44 == u32::MAX && p.shader48 == u32::MAX {
            continue;
        }
        if required_mask != 0 && required_mask & p.flags == 0 { continue; }
        if !p.submesh.is_empty() && submesh.is_some_and(|name| !c_equal(p.submesh, name)) {
            continue;
        }
        if let Some(output) = output_index { *output = index; }
        return Ok(Some(entry.owner));
    }
    Ok(None)
}

#[cfg(test)]
#[path = "material_selection_tests.rs"]
mod tests;
