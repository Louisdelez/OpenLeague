//! Native loading metadata getters728410/728500 and service providers72AD90/72AE40.
//! Names come from the metadata tree after native identifier resolution. Cached
//! String24 capacity is retained; allocations and ownership are not host strings.
use crate::audio_announcer_registry_init::Storage;
use crate::audio_replay_metadata::{self as metadata, Error};
use crate::audio_replay_shared_pair as pair;
use std::collections::BTreeSet;

pub const NAME: u32 = 0x728410;
pub const EXTRA: u32 = 0x728500;
pub const RESOLVE: u32 = 0x729ec0;
pub const SERVICE_NAME: u32 = 0x72ad90;
pub const SERVICE_EXTRA: u32 = 0x72ae40;
pub const PARENT: u32 = 0x2d78520;
pub trait Boundary: metadata::Boundary + pair::Boundary {
    fn initialize_game_manager(&mut self) -> Result<(), &'static str>;
    /// Metadata virtual+18. Native729EC0 resolves the key through729730 and
    /// the replay object's dual index. Return is EDX:EAX, not the input key.
    fn resolve_key(&mut self, metadata: u32, target: u32, key: u32) -> Result<u64, &'static str>;
}
fn add(p: u32, o: u32) -> Result<u32, Error> {
    p.checked_add(o).ok_or(Error::AddressOverflow)
}
fn word(b: &mut impl Boundary, p: u32, o: u32) -> Result<u32, Error> {
    Ok(b.word(add(p, o)?)?)
}
fn put(b: &mut impl Boundary, p: u32, o: u32, v: u32) -> Result<(), Error> {
    Ok(Storage::write_word(b, add(p, o)?, v)?)
}
fn byte(b: &mut impl Boundary, p: u32, o: u32, v: u8) -> Result<(), Error> {
    Ok(b.write_byte(add(p, o)?, v)?)
}
fn chars(b: &mut impl Boundary, p: u32) -> Result<u32, Error> {
    if word(b, p, 20)? < 16 {
        Ok(p)
    } else {
        word(b, p, 0)
    }
}
fn empty(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    put(b, p, 20, 15)?;
    put(b, p, 16, 0)?;
    byte(b, p, 0, 0)
}
fn destroy_string(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    if word(b, p, 20)? >= 16 {
        let route = b.deallocator()?;
        let raw = word(b, p, 0)?;
        b.free(raw, route)?;
    }
    empty(b, p)
}
fn finish<T>(a: Result<T, Error>, c: Result<(), Error>) -> Result<T, Error> {
    match (a, c) {
        (Ok(v), Ok(())) => Ok(v),
        (Err(e), Ok(())) | (Ok(_), Err(e)) => Err(e),
        (Err(primary), Err(cleanup)) => Err(Error::Cleanup {
            primary: Box::new(primary),
            cleanup: Box::new(cleanup),
        }),
    }
}
fn pair_error(e: pair::Error) -> Error {
    match e {
        pair::Error::Read(e) => Error::Read(e),
        pair::Error::Write(e) => Error::Write(e),
        pair::Error::Boundary(e) => Error::Boundary(e),
        pair::Error::AddressOverflow => Error::AddressOverflow,
    }
}
fn copy_bytes(b: &mut impl Boundary, d: u32, s: u32, n: u32) -> Result<(), Error> {
    for i in 0..n {
        let v = b.read_byte(add(s, i)?)?;
        byte(b, d, i, v)?;
    }
    Ok(())
}
// Full-string non-alias assignment from728410 and standard57D71D.
// Destination may already own a buffer; capacity and old length are preserved.
// Native564F30 preserves old length while replacing the allocation, then
// 564AF0 copies the source and publishes its length. SEH/OOM retry is explicit.
pub(crate) fn assign_owned_non_alias(b: &mut impl Boundary, d: u32, s: u32) -> Result<(), Error> {
    let length = word(b, s, 16)?;
    if length == u32::MAX {
        return Err(Error::Boundary(
            "native string length exception is not connected",
        ));
    }
    let capacity = word(b, d, 20)?;
    if capacity < length {
        let rounded = length | 15;
        let mut new_capacity = if rounded > u32::MAX - 1 {
            length
        } else {
            rounded
        };
        if rounded <= u32::MAX - 1 && capacity / 2 > rounded / 3 {
            new_capacity = capacity.saturating_add(capacity / 2).min(u32::MAX - 1);
        }
        let old_length = word(b, d, 16)?;
        let raw = b.allocate(new_capacity + 1)?;
        if raw == 0 {
            return Err(Error::AllocationFailed(new_capacity + 1));
        }
        let mut adopted = false;
        let growth = (|| {
            if old_length != 0 {
                let old = chars(b, d)?;
                copy_bytes(b, raw, old, old_length)?;
            }
            if word(b, d, 20)? >= 16 {
                let route = b.deallocator()?;
                let old = word(b, d, 0)?;
                b.free(old, route)?;
            }
            byte(b, d, 0, 0)?;
            put(b, d, 0, raw)?;
            put(b, d, 20, new_capacity)?;
            adopted = true;
            put(b, d, 16, old_length)?;
            let to = if new_capacity >= 16 { raw } else { d };
            byte(b, to, old_length, 0)
        })();
        let cleanup = if growth.is_err() && !adopted {
            (|| {
                let route = b.deallocator()?;
                Ok(b.free(raw, route)?)
            })()
        } else {
            Ok(())
        };
        finish(growth, cleanup)?;
    }
    if length != 0 {
        let from = chars(b, s)?;
        let to = chars(b, d)?;
        copy_bytes(b, to, from, length)?;
    }
    put(b, d, 16, length)?;
    let to = chars(b, d)?;
    byte(b, to, length, 0)
}
fn find(b: &mut impl Boundary, tree: u32, key: u64) -> Result<u32, Error> {
    let head = word(b, tree, 0)?;
    let mut current = word(b, head, 4)?;
    let mut result = head;
    let query = ((key >> 32) as u32 as i32, key as u32);
    let mut visited = BTreeSet::new();
    while b.read_byte(add(current, 13)?)? == 0 {
        if !visited.insert(current) {
            return Err(Error::InvalidTree);
        }
        let index = word(b, current, 20)? as i32;
        let lower = if index == query.0 {
            word(b, current, 16)? < query.1
        } else {
            index < query.0
        };
        if lower {
            current = word(b, current, 8)?;
        } else {
            result = current;
            current = word(b, current, 0)?;
        }
    }
    if result != head {
        let index = word(b, result, 20)? as i32;
        if query.0 < index || (query.0 == index && query.1 < word(b, result, 16)?) {
            return Ok(head);
        }
    }
    Ok(result)
}
fn resolved(b: &mut impl Boundary, p: u32, key: u32) -> Result<u64, Error> {
    let vt = word(b, p, 0)?;
    let target = word(b, vt, 0x18)?;
    b.resolve_key(p, target, key).map_err(Error::Boundary)
}
///728410 constructs a fresh output String24; it must not own a previous buffer.
/// Cached source cannot alias output. Lock is released on host failures too.
pub fn name(b: &mut impl Boundary, p: u32, out: u32, key: u32) -> Result<u32, Error> {
    let lock = add(p, 0x1c8)?;
    b.enter_lock(lock).map_err(Error::Boundary)?;
    let mut output_initialized = false;
    let action = (|| {
        let cached = add(p, 0x1b0)?;
        let cap = word(b, cached, 20)?;
        put(b, cached, 16, 0)?;
        let raw = if cap < 16 {
            cached
        } else {
            word(b, cached, 0)?
        };
        byte(b, raw, 0, 0)?;
        let resolved = resolved(b, p, key)?;
        let node = find(b, add(p, 8)?, resolved)?;
        if node != word(b, p, 8)? {
            let source = add(node, 24)?;
            if source != cached {
                assign_owned_non_alias(b, cached, source)?;
            }
        }
        empty(b, out)?;
        output_initialized = true;
        assign_owned_non_alias(b, out, cached)?;
        Ok(out)
    })();
    let cleanup = b.leave_lock(lock).map_err(Error::Boundary);
    let result = finish(action, cleanup);
    if result.is_err() && output_initialized {
        let cleanup = destroy_string(b, out);
        finish(result, cleanup)
    } else {
        result
    }
}
pub fn extra(b: &mut impl Boundary, p: u32, key: u32) -> Result<u32, Error> {
    let lock = add(p, 0x1c8)?;
    b.enter_lock(lock).map_err(Error::Boundary)?;
    let action = (|| {
        let resolved = resolved(b, p, key)?;
        let node = find(b, add(p, 8)?, resolved)?;
        if node == word(b, p, 8)? {
            Ok(0)
        } else {
            word(b, node, 48)
        }
    })();
    let cleanup = b.leave_lock(lock).map_err(Error::Boundary);
    finish(action, cleanup)
}
fn acquire(b: &mut impl Boundary, scratch: u32) -> Result<(), Error> {
    let mut parent = b.word(PARENT)?;
    if parent == 0 {
        b.initialize_game_manager().map_err(Error::Boundary)?;
        parent = b.word(PARENT)?;
    }
    if parent == 0 {
        return Err(Error::Boundary(
            "native replay parent initialization returned null",
        ));
    }
    put(b, scratch, 0, 0)?;
    put(b, scratch, 4, 0)?;
    let control = word(b, parent, 0x38)?;
    let object = word(b, parent, 0x34)?;
    if control != 0 {
        b.increment_reference(add(control, 4)?)
            .map_err(Error::Boundary)?;
    }
    let result = (|| {
        let old = word(b, scratch, 4)?;
        pair::release_control(b, old).map_err(pair_error)?;
        put(b, scratch, 4, control)?;
        put(b, scratch, 0, object)
    })();
    if result.is_err() {
        let cleanup = pair::release_control(b, control).map_err(pair_error);
        finish(result, cleanup)
    } else {
        result
    }
}
///72AD90. Scratch8 is exclusive pair storage, disjoint from output24.
pub fn service_name(b: &mut impl Boundary, out: u32, key: u32, scratch: u32) -> Result<u32, Error> {
    acquire(b, scratch)?;
    let action = (|| {
        let p = b.word(scratch)?;
        let vt = word(b, p, 0)?;
        let target = word(b, vt, 0x20)?;
        if target != NAME {
            return Err(Error::Boundary("unknown loading metadata name method"));
        }
        name(b, p, out, key)
    })();
    let output_constructed = action.is_ok();
    let cleanup = pair::destroy(b, scratch).map_err(pair_error);
    let result = finish(action, cleanup);
    if result.is_err() && output_constructed {
        let cleanup = destroy_string(b, out);
        finish(result, cleanup)
    } else {
        result
    }
}
pub fn service_extra(b: &mut impl Boundary, key: u32, scratch: u32) -> Result<u32, Error> {
    acquire(b, scratch)?;
    let action = (|| {
        let p = b.word(scratch)?;
        let vt = word(b, p, 0)?;
        let target = word(b, vt, 0x24)?;
        if target != EXTRA {
            return Err(Error::Boundary("unknown loading metadata extra method"));
        }
        extra(b, p, key)
    })();
    let cleanup = pair::destroy(b, scratch).map_err(pair_error);
    finish(action, cleanup)
}

#[cfg(test)]
#[path = "audio_loading_metadata_tests.rs"]
mod tests;
