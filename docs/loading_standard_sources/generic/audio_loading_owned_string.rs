//! Candidate ownership adaptation for a caller-owned temporary String24.
//! Normal writes follow564AF0/564F30; failed host writes never make a partial
//! descriptor authoritative for cleanup. This is not a metadata-cache reset.
use crate::audio_announcer_registry_init::Storage;
use crate::audio_announcer_registry_remove::{self as removal, Deallocator};
pub use crate::audio_replay_metadata::Error;
use crate::audio_replay_metadata as metadata;

/// Explicit opt-in: on Err, release_owned must leave the allocation alive and
/// owned; on Ok it must retire it exactly once. No blanket impl for arbitrary
/// Free backends. Windows Standard satisfies this contract on returned Results;
/// panic/abort and side-effecting custom deallocators are outside this adapter.
/// Allocation Err must publish no allocation; successful nonzero allocations
/// must be fresh, disjoint and owned. Writes may fail, but must not corrupt
/// bytes outside their requested range. The descriptor remains exclusive.
pub trait Boundary: metadata::Boundary {
    fn release_owned(&mut self, pointer: u32, route: Deallocator) -> Result<(), removal::Error>;
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Phase {
    Original,
    NewAllocated,
    OldCopied,
    OldRetired,
    DescriptorZeroed,
    PointerPublished,
    CapacityPublished,
    OldLengthPublished,
    OldTerminated,
    SourceCopied,
    LengthPublished,
    Complete,
    Retired,
}
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Authority {
    /// Descriptor is valid and remains its own cleanup authority.
    Descriptor,
    /// Old heap is retired. This pointer owns the replacement even when
    /// descriptor fields still contain the old pointer or mixed capacities.
    Detached(u32),
    None,
}
#[derive(Debug, PartialEq, Eq)]
#[must_use = "The caller must finish or retain this temporary's ownership"]
pub struct Temporary {
    address: u32,
    authority: Authority,
    pending: Option<u32>,
    phase: Phase,
}
impl Temporary {
    /// Transfer a valid caller-owned descriptor after successful service_name.
    /// No allocation/read/write is performed. Never use this for shared cache
    /// state; the descriptor is private and discarded after its caller returns.
    pub fn new(address: u32) -> Self {
        Self { address, authority: Authority::Descriptor, pending: None, phase: Phase::Original }
    }
    pub fn address(&self) -> u32 { self.address }
    pub fn authority(&self) -> Authority { self.authority }
    pub fn pending(&self) -> Option<u32> { self.pending }
    pub fn phase(&self) -> Phase { self.phase }
    pub fn is_retired(&self) -> bool { self.authority == Authority::None && self.pending.is_none() }

    /// No descriptor reset. On failure, retained ownership stays in this guard
    /// and may be retried only through the explicit atomic-release contract.
    pub fn retire(&mut self, b: &mut impl Boundary) -> Result<(), Error> {
        let mut result = Ok(());
        if let Some(pointer) = self.pending {
            let attempt = release(b, pointer);
            if attempt.is_ok() { self.pending = None; }
            result = combine(result, attempt);
        }
        let attempt = match self.authority {
            Authority::Descriptor => (|| {
                // Same standard cleanup order: capacity, deallocator, pointer.
                if b.word(add(self.address,20)?)? >= 16 {
                    let route=b.deallocator()?;
                    let pointer=b.word(self.address)?;
                    b.release_owned(pointer,route)?;
                }
                Ok(())
            })(),
            Authority::Detached(pointer) => release(b,pointer),
            Authority::None => Ok(()),
        };
        if attempt.is_ok() { self.authority=Authority::None; }
        result=combine(result,attempt);
        if self.is_retired() { self.phase=Phase::Retired; }
        result
    }
}

/// The caller must retain `remaining` on cleanup failure. Dropping or formatting
/// this error is not a recovery strategy. It transfers explicit ownership so a
/// containing runtime can retry or retain it in its teardown ledger.
#[derive(Debug, PartialEq, Eq)]
#[must_use = "A failed cleanup may carry live ownership in remaining"]
pub struct Failure {
    pub primary: Option<Error>,
    pub cleanup: Option<Error>,
    pub remaining: Option<Temporary>,
}
/// Consume the caller guard, preserving independent primary/cleanup errors and
/// returning every still-owned allocation via `remaining` when cleanup fails.
pub fn finish<T>(b:&mut impl Boundary, mut owner:Temporary, primary:Result<T,Error>) -> Result<T,Failure> {
    let cleanup=owner.retire(b);
    match (primary,cleanup) {
        (Ok(value),Ok(()))=>Ok(value),
        (primary,cleanup)=>Err(Failure {
            primary:primary.err(), cleanup:cleanup.err(),
            remaining:(!owner.is_retired()).then_some(owner),
        }),
    }
}
fn combine(a:Result<(),Error>,c:Result<(),Error>)->Result<(),Error> {
    match (a,c) {
        (Ok(()),Ok(()))=>Ok(()),
        (Err(e),Ok(()))|(Ok(()),Err(e))=>Err(e),
        (Err(primary),Err(cleanup))=>Err(Error::Cleanup { primary:Box::new(primary),cleanup:Box::new(cleanup) }),
    }
}
fn release(b:&mut impl Boundary,p:u32)->Result<(),Error> {
    let route=b.deallocator()?;Ok(b.release_owned(p,route)?)
}
fn add(p:u32,o:u32)->Result<u32,Error> {p.checked_add(o).ok_or(Error::AddressOverflow)}
fn put(b:&mut impl Boundary,p:u32,o:u32,v:u32)->Result<(),Error> {Ok(Storage::write_word(b,add(p,o)?,v)?)}
fn byte(b:&mut impl Boundary,p:u32,o:u32,v:u8)->Result<(),Error> {Ok(b.write_byte(add(p,o)?,v)?)}
fn chars(b:&mut impl Boundary,p:u32)->Result<u32,Error> {
    if b.word(add(p,20)?)?<16 {Ok(p)}else{Ok(b.word(p)?)}
}
fn copy(b:&mut impl Boundary,d:u32,s:u32,n:u32)->Result<(),Error> {
    for i in 0..n {let value=b.read_byte(add(s,i)?)?;byte(b,d,i,value)?;}Ok(())
}

///564AF0 offset0/countMAX, valid non-alias source/destination, caller temporary
///only. An error abandons this assignment; the caller must finish its guard.
/// Descriptor authority is never restored from a partially written descriptor.
pub fn assign_owned_non_alias(b:&mut impl Boundary, owner:&mut Temporary, source:u32)->Result<(),Error> {
    if owner.authority!=Authority::Descriptor || owner.pending.is_some() {
        return Err(Error::Boundary("temporary is not in assignable descriptor state"));
    }
    let d=owner.address;
    if d==source { return Err(Error::Boundary("caller must skip identical String24 addresses")); }
    let length=b.word(add(source,16)?)?;
    if length==u32::MAX {return Err(Error::Boundary("native string length exception is not connected"));}
    let capacity=b.word(add(d,20)?)?; //564B66
    if capacity<length {
        let old_length=b.word(add(d,16)?)?; //caller564B6D, before564F30
        let rounded=length|15;
        let mut new_capacity=if rounded>u32::MAX-1 {length}else{rounded};
        if rounded<=u32::MAX-1 {
            let growth_capacity=b.word(add(d,20)?)?; //564F71 reload
            if growth_capacity/2>rounded/3 {
                new_capacity=growth_capacity.saturating_add(growth_capacity/2).min(u32::MAX-1);
            }
        }
        let raw=b.allocate(new_capacity+1)?;
        if raw==0 {return Err(Error::AllocationFailed(new_capacity+1));}
        owner.pending=Some(raw); owner.phase=Phase::NewAllocated;
        if old_length!=0 {let old=chars(b,d)?;copy(b,raw,old,old_length)?;}
        owner.phase=Phase::OldCopied;
        if b.word(add(d,20)?)?>=16 {
            let route=b.deallocator()?;let old=b.word(d)?;
            //Err guarantees old still belongs to the descriptor. pending new
            //buffer remains independently owned and is retired by the caller.
            b.release_owned(old,route)?;
        }
        // Ownership transfer happens before ANY fallible descriptor publication.
        // This state also covers SSO->heap growth, which has no old heap to free.
        owner.authority=Authority::Detached(raw);owner.pending=None;owner.phase=Phase::OldRetired;
        byte(b,d,0,0)?;owner.phase=Phase::DescriptorZeroed;
        put(b,d,0,raw)?;owner.phase=Phase::PointerPublished;
        put(b,d,20,new_capacity)?;owner.phase=Phase::CapacityPublished;
        put(b,d,16,old_length)?;owner.phase=Phase::OldLengthPublished;
        byte(b,if new_capacity>=16 {raw}else{d},old_length,0)?;
        owner.phase=Phase::OldTerminated;
    }
    if length==0 {
        //564B95 uses capacity already read at564B66 (no reread).
        put(b,d,16,0)?;owner.phase=Phase::LengthPublished;
        let end=if capacity>=16 {b.word(d)?}else{d};byte(b,end,0,0)?;
    } else {
        let from=chars(b,source)?;let to=chars(b,d)?;
        copy(b,to,from,length)?;owner.phase=Phase::SourceCopied;
        //564BCB reads capacity BEFORE publishing length; pointer follows it.
        let final_capacity=b.word(add(d,20)?)?;
        put(b,d,16,length)?;owner.phase=Phase::LengthPublished;
        let end=if final_capacity>=16 {b.word(d)?}else{d};byte(b,end,length,0)?;
    }
    owner.authority=Authority::Descriptor;owner.phase=Phase::Complete;
    Ok(())
}

#[cfg(test)]
#[path="audio_loading_owned_string_tests.rs"]
mod tests;
