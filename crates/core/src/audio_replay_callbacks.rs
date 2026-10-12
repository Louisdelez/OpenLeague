//! Replay parent callback families and bundle ownership recovered from the4.20 PE.
//! Members remain explicit boundaries; wrappers preserve their native signatures.
use crate::{
    audio_announcer_object_lookup as read, audio_announcer_owner_metadata as callback,
    audio_announcer_registry_init::{self as init, Storage},
    audio_announcer_registry_remove as remove,
};
pub const BUNDLE_VTABLE: u32 = 0x10b0128;
pub const BUNDLE_DELETE: u32 = 0x728ae0;
pub const VTABLES: [u32; 8] = [
    0x108606c, 0x1086078, 0x10afd14, 0x10afd20, 0x10afd34, 0x109b2d4, 0x10afcfc, 0x10afd08,
];
pub const CLONES: [u32; 8] = [
    0x5cce40, 0x5ccdc0, 0x734010, 0x733f80, 0x733f00, 0x65e970, 0x734160, 0x7340c0,
];
pub const INVOKES: [u32; 8] = [
    0x5cceb0, 0x5cce30, 0x734080, 0x733ff0, 0x733f70, 0x65e9e0, 0x7341d0, 0x734130,
];
pub const FACTORIES: [u32; 7] = [
    0x733540, 0x7335c0, 0x733640, 0x7336c0, 0x733740, 0x7337c0, 0x733840,
];
#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    Read(read::Error),
    Write(init::Error),
    Free(remove::Error),
    Boundary(&'static str),
    Overflow,
    UnknownFactory(u32),
    UnknownClone(u32),
    UnknownDelete(u32),
    UnknownInvoke(u32),
    InvalidOffset(u32),
    NullCallback,
    UnconnectedMember {
        dispatcher: u32,
        owner: u32,
        member: u32,
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
impl From<remove::Error> for Error {
    fn from(e: remove::Error) -> Self {
        Self::Free(e)
    }
}
/// Factories and clones use the same explicit C9F39B/custom engine-new route.
pub trait Boundary: Storage + remove::Backend + callback::Boundaries {}
impl<T: Storage + remove::Backend + callback::Boundaries> Boundary for T {}
fn add(p: u32, n: u32) -> Result<u32, Error> {
    p.checked_add(n).ok_or(Error::Overflow)
}
fn w(b: &mut impl Boundary, p: u32, n: u32) -> Result<u32, Error> {
    Ok(b.word(add(p, n)?)?)
}
fn put(b: &mut impl Boundary, p: u32, n: u32, v: u32) -> Result<(), Error> {
    Ok(Storage::write_word(b, add(p, n)?, v)?)
}
fn free(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    let route = b.deallocator()?;
    Ok(b.free(p, route)?)
}
/// Factory output is returned directly; native's caller-owned output wrapper is
/// omitted. Owner is the already-read by-reference owner argument. No invocation.
pub fn factory(b: &mut impl Boundary, id: u32, owner: u32) -> Result<u32, Error> {
    let (vt, member) = match id {
        0x733540 => (0x10afd34, 0x586230),
        0x7335c0 => (0x1086078, 0x5bfa90),
        0x733640 => (0x10afd20, 0x5bfa90),
        0x7336c0 => (0x1086078, 0x729b70),
        0x733740 => (0x1086078, 0x729c50),
        0x7337c0 => (0x108606c, 0x729370),
        0x733840 => (0x10afd14, 0x71ec30),
        _ => return Err(Error::UnknownFactory(id)),
    };
    let p = b.allocate_callback_clone(12).map_err(Error::Boundary)?;
    if p != 0 {
        for (o, v) in [(0, vt), (4, owner), (8, member)] {
            put(b, p, o, v)?;
        }
    }
    Ok(p)
}
///658F70/7338C0 carry the caller-supplied method and this-pointer adjustment.
pub fn factory_member(
    b: &mut impl Boundary,
    id: u32,
    owner: u32,
    member: u32,
    extra: u32,
) -> Result<u32, Error> {
    let vt = match id {
        0x658f70 => 0x109b2d4,
        0x7338c0 => 0x10afcfc,
        _ => return Err(Error::UnknownFactory(id)),
    };
    let p = b.allocate_callback_clone(16).map_err(Error::Boundary)?;
    if p != 0 {
        for (o, v) in [(0, vt), (4, owner), (8, member), (12, extra)] {
            put(b, p, o, v)?;
        }
    }
    Ok(p)
}
/// Virtual clone selects its concrete resulting vtable from the clone method;
/// it rereads payload words after allocation, matching all eight source bodies.
pub fn clone(b: &mut impl Boundary, p: u32) -> Result<u32, Error> {
    if p == 0 {
        return Ok(0);
    }
    let vt = b.word(p)?;
    let method = w(b, vt, 4)?;
    let index = CLONES
        .iter()
        .position(|v| *v == method)
        .ok_or(Error::UnknownClone(method))?;
    let size = if index >= 5 { 16 } else { 12 };
    let q = b.allocate_callback_clone(size).map_err(Error::Boundary)?;
    if q != 0 {
        put(b, q, 0, VTABLES[index])?;
        for off in (4..size).step_by(4) {
            let value = w(b, p, off)?;
            put(b, q, off, value)?;
        }
    }
    Ok(q)
}
///578010 for each callback family. It changes the header even when flags&1==0.
pub fn scalar_delete(b: &mut impl Boundary, p: u32, flags: u32) -> Result<u32, Error> {
    put(b, p, 0, 0x1084ed4)?;
    if flags & 1 != 0 {
        free(b, p)?;
    }
    Ok(p)
}
pub fn delete(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    if p != 0 {
        let vt = b.word(p)?;
        let method = b.word(vt)?;
        if method != callback::HANDLER_DELETE {
            return Err(Error::UnknownDelete(method));
        }
        scalar_delete(b, p, 1)?;
    }
    Ok(())
}
/// Inlined bundle initialization at72914D..729168 (20 bytes).
pub fn construct_bundle(b: &mut impl Boundary, p: u32) -> Result<u32, Error> {
    put(b, p, 0, BUNDLE_VTABLE)?;
    for off in [4, 8, 12, 16] {
        put(b, p, off, 0)?;
    }
    Ok(p)
}
///728AE0 rereads each field after deleting the preceding child, in reverse order.
pub fn delete_bundle(b: &mut impl Boundary, p: u32, flags: u32) -> Result<u32, Error> {
    put(b, p, 0, BUNDLE_VTABLE)?;
    for off in [16, 12, 8, 4] {
        let child = w(b, p, off)?;
        delete(b, child)?;
    }
    if flags & 1 != 0 {
        free(b, p)?;
    }
    Ok(p)
}
///728B60/728C10/728CC0/728D70 return a clone of the old callback through a fresh
/// 4-byte output wrapper. The by-value incoming callback is consumed. Output,
/// incoming and bundle are distinct owning storage; exception rollback unqualified.
pub fn replace(
    b: &mut impl Boundary,
    bundle: u32,
    offset: u32,
    output: u32,
    incoming: u32,
) -> Result<u32, Error> {
    if ![4, 8, 12, 16].contains(&offset) {
        return Err(Error::InvalidOffset(offset));
    }
    let old = w(b, bundle, offset)?;
    let returned = clone(b, old)?;
    put(b, output, 0, returned)?;
    let installed = clone(b, incoming)?;
    let old = w(b, bundle, offset)?;
    put(b, bundle, offset, 0)?;
    put(b, bundle, offset, installed)?;
    delete(b, old)?;
    delete(b, incoming)?;
    Ok(output)
}
///729A50 (offset12) and729AE0 (offset16) add another clone/consume layer.
pub fn parent_replace(
    b: &mut impl Boundary,
    parent: u32,
    offset: u32,
    output: u32,
    incoming: u32,
) -> Result<u32, Error> {
    if ![12, 16].contains(&offset) {
        return Err(Error::InvalidOffset(offset));
    }
    let forwarded = clone(b, incoming)?;
    let bundle = w(b, parent, 0x28)?;
    let result = replace(b, bundle, offset, output, forwarded)?;
    delete(b, incoming)?;
    Ok(result)
}
/// Ownership support alone does not implement729370/729B70/729C50/71EC30.
/// Do not call an unconnected member or confuse its address with success.
pub fn invoke(b: &mut impl Boundary, p: u32) -> Result<(), Error> {
    if p == 0 {
        return Err(Error::NullCallback);
    }
    let vt = b.word(p)?;
    let dispatcher = w(b, vt, 8)?;
    if !INVOKES.contains(&dispatcher) {
        return Err(Error::UnknownInvoke(dispatcher));
    }
    Err(Error::UnconnectedMember {
        dispatcher,
        owner: w(b, p, 4)?,
        member: w(b, p, 8)?,
    })
}
/// Native5CCEB0, selected explicitly by a caller that knows the callback family.
/// The first argument is a referenced32-bit word; the four remaining arguments
/// are forwarded as values. This12-byte family has no this-pointer adjustment.
/// Reads and member return preserve native order and all32 result bits. The
/// member boundary must reject an unconnected target; no consumer is invented.
pub fn invoke12(
    b: &mut impl crate::audio_replay_events::Boundary,
    p: u32,
    args: [u32; 5],
) -> Result<u32, Error> {
    if p == 0 {
        return Err(Error::NullCallback);
    }
    let first = b.word(args[0])?;
    let owner = b.word(add(p, 4)?)?;
    let member = b.word(add(p, 8)?)?;
    b.member_call(owner, member, [first, args[1], args[2], args[3], args[4]])
        .map_err(Error::Boundary)
}
/// Fully materialized arguments delivered by source734080. The source wrapper
/// takes references for its first two words, but the member receives values.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct SixValues {
    pub first: u32,
    pub second: u32,
    pub third: u32,
    pub fourth: u32,
    pub fifth: u32,
    pub sixth: u32,
}
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct SixArguments {
    pub first_ref: u32,
    pub second_ref: u32,
    pub third: u32,
    pub fourth: u32,
    pub fifth: u32,
    pub sixth: u32,
}
/// Explicit signatures: unconnected members fail by default. These methods
/// return all EAX bits, not a Rust boolean. No arbitrary member address executes.
pub trait InvocationBoundary: read::Memory {
    fn member_two(
        &mut self,
        _owner: u32,
        _member: u32,
        _first: u32,
        _second: u32,
    ) -> Result<u32, &'static str> {
        Err("two-argument replay member is not connected")
    }
    fn member_six(
        &mut self,
        _owner: u32,
        _member: u32,
        _args: SixValues,
    ) -> Result<u32, &'static str> {
        Err("six-argument replay member is not connected")
    }
    fn member_zero(&mut self, _owner: u32, _member: u32) -> Result<u32, &'static str> {
        Err("zero-argument replay member is not connected")
    }
}
/// Source65E9E0 forwards value arguments unchanged. Its tailcall is generic;
/// this API exposes the two-word signature used by source658F70/738A3A.
pub fn invoke65e9e0(
    b: &mut impl InvocationBoundary,
    p: u32,
    first: u32,
    second: u32,
) -> Result<u32, Error> {
    if p == 0 {
        return Err(Error::NullCallback);
    }
    let adjustment = b.word(add(p, 12)?)?;
    let owner = b.word(add(p, 4)?)?;
    let member = b.word(add(p, 8)?)?;
    b.member_two(owner.wrapping_add(adjustment), member, first, second)
        .map_err(Error::Boundary)
}
/// Source7341D0 dereferences the second argument before reading callback fields.
pub fn invoke7341d0(
    b: &mut impl InvocationBoundary,
    p: u32,
    first: u32,
    second_ref: u32,
) -> Result<u32, Error> {
    if p == 0 {
        return Err(Error::NullCallback);
    }
    let second = b.word(second_ref)?;
    let adjustment = b.word(add(p, 12)?)?;
    let owner = b.word(add(p, 4)?)?;
    let member = b.word(add(p, 8)?)?;
    b.member_two(owner.wrapping_add(adjustment), member, first, second)
        .map_err(Error::Boundary)
}
/// Real leaf586230 writes AL only. Higher EAX bits are deliberately preserved.
pub fn leaf_false586230(incoming_eax: u32) -> u32 {
    incoming_eax & 0xffff_ff00
}
/// Real leaf71EC30 has the same AL write and native callee cleanup of six words.
pub fn leaf_false71ec30(incoming_eax: u32) -> u32 {
    incoming_eax & 0xffff_ff00
}
/// Source734080: six arguments, second reference read before the first. The
/// object occupies12 bytes; it has no this adjustment. Only the proven native
/// false leaf71EC30 is handled here; all other members need an explicit boundary.
pub fn invoke734080(
    b: &mut impl InvocationBoundary,
    p: u32,
    args: SixArguments,
) -> Result<u32, Error> {
    if p == 0 {
        return Err(Error::NullCallback);
    }
    let second = b.word(args.second_ref)?;
    let first = b.word(args.first_ref)?;
    let owner = b.word(add(p, 4)?)?;
    let member = b.word(add(p, 8)?)?;
    if member == 0x71ec30 {
        return Ok(leaf_false71ec30(member));
    }
    b.member_six(
        owner,
        member,
        SixValues {
            first,
            second,
            third: args.third,
            fourth: args.fourth,
            fifth: args.fifth,
            sixth: args.sixth,
        },
    )
    .map_err(Error::Boundary)
}
/// Source733F70 is the zero-argument wrapper, not itself a false-return leaf.
pub fn invoke733f70(b: &mut impl InvocationBoundary, p: u32) -> Result<u32, Error> {
    if p == 0 {
        return Err(Error::NullCallback);
    }
    let owner = b.word(add(p, 4)?)?;
    let member = b.word(add(p, 8)?)?;
    if member == 0x586230 {
        return Ok(leaf_false586230(member));
    }
    b.member_zero(owner, member).map_err(Error::Boundary)
}

#[cfg(test)]
#[path = "audio_replay_callbacks_tests.rs"]
mod tests;

#[cfg(test)]
#[path = "audio_replay_callback12_tests.rs"]
mod invoke12_tests;
#[cfg(test)]
#[path = "audio_replay_callback_signatures_tests.rs"]
mod signature_tests;
