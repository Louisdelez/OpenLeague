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
    fn member_two(&mut self, _owner: u32, _member: u32, _first: u32, _second: u32)
        -> Result<u32, &'static str>
    {
        Err("two-argument replay member is not connected")
    }
    fn member_six(&mut self, _owner: u32, _member: u32, _args: SixValues)
        -> Result<u32, &'static str>
    {
        Err("six-argument replay member is not connected")
    }
    fn member_zero(&mut self, _owner: u32, _member: u32) -> Result<u32, &'static str> {
        Err("zero-argument replay member is not connected")
    }
}
/// Source65E9E0 forwards value arguments unchanged. Its tailcall is generic;
/// this API exposes the two-word signature used by source658F70/738A3A.
pub fn invoke65e9e0(
    b: &mut impl InvocationBoundary, p: u32, first: u32, second: u32,
) -> Result<u32, Error> {
    if p == 0 { return Err(Error::NullCallback); }
    let adjustment = b.word(add(p, 12)?)?;
    let owner = b.word(add(p, 4)?)?;
    let member = b.word(add(p, 8)?)?;
    b.member_two(owner.wrapping_add(adjustment), member, first, second)
        .map_err(Error::Boundary)
}
/// Source7341D0 dereferences the second argument before reading callback fields.
pub fn invoke7341d0(
    b: &mut impl InvocationBoundary, p: u32, first: u32, second_ref: u32,
) -> Result<u32, Error> {
    if p == 0 { return Err(Error::NullCallback); }
    let second = b.word(second_ref)?;
    let adjustment = b.word(add(p, 12)?)?;
    let owner = b.word(add(p, 4)?)?;
    let member = b.word(add(p, 8)?)?;
    b.member_two(owner.wrapping_add(adjustment), member, first, second)
        .map_err(Error::Boundary)
}
/// Real leaf586230 writes AL only. Higher EAX bits are deliberately preserved.
pub fn leaf_false586230(incoming_eax: u32) -> u32 { incoming_eax & 0xffff_ff00 }
/// Real leaf71EC30 has the same AL write and native callee cleanup of six words.
pub fn leaf_false71ec30(incoming_eax: u32) -> u32 { incoming_eax & 0xffff_ff00 }
/// Source734080: six arguments, second reference read before the first. The
/// object occupies12 bytes; it has no this adjustment. Only the proven native
/// false leaf71EC30 is handled here; all other members need an explicit boundary.
pub fn invoke734080(
    b: &mut impl InvocationBoundary, p: u32, args: SixArguments,
) -> Result<u32, Error> {
    if p == 0 { return Err(Error::NullCallback); }
    let second = b.word(args.second_ref)?;
    let first = b.word(args.first_ref)?;
    let owner = b.word(add(p, 4)?)?;
    let member = b.word(add(p, 8)?)?;
    if member == 0x71ec30 { return Ok(leaf_false71ec30(member)); }
    b.member_six(owner, member, SixValues {
        first, second, third: args.third, fourth: args.fourth,
        fifth: args.fifth, sixth: args.sixth,
    }).map_err(Error::Boundary)
}
/// Source733F70 is the zero-argument wrapper, not itself a false-return leaf.
pub fn invoke733f70(b: &mut impl InvocationBoundary, p: u32) -> Result<u32, Error> {
    if p == 0 { return Err(Error::NullCallback); }
    let owner = b.word(add(p, 4)?)?;
    let member = b.word(add(p, 8)?)?;
    if member == 0x586230 { return Ok(leaf_false586230(member)); }
    b.member_zero(owner, member).map_err(Error::Boundary)
}
