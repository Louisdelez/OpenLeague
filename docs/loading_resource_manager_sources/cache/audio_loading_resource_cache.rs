//! Bounded90AD00 cache lookup: real String24 normalization and native key order.
//! Providers returned on hits are borrowed opaque values. MissFactory stops
//! before90B520; it is not a successful provider creation. The caller owns both
//! its input name and the separate normalized key, and retires the key first.
use crate::audio_announcer_registry_init::Storage;
use crate::audio_loading_owned_string::{self as owned, Temporary};
pub use owned::Error;
use std::collections::BTreeSet;

pub const KEY_BYTES: u32 = 28;
pub const FACTORY: u32 = 0x90b520;
pub trait Boundary: owned::Boundary {
    /// C98719 reads the canonical CRT14AE870 flag for each converted byte.
    /// False is an explicit boundary: non-C localeC985D6 is not ported here.
    fn locale_is_default(&mut self) -> Result<bool, Error>;
}
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Outcome {
    HitBorrowed { provider: u32 },
    MissFactory { manager: u32, original_name: u32, skin: u32 },
}
fn add(p:u32,n:u32)->Result<u32,Error> {p.checked_add(n).ok_or(Error::AddressOverflow)}
fn word(b:&mut impl Boundary,p:u32,n:u32)->Result<u32,Error> {Ok(b.word(add(p,n)?)?)}
fn put(b:&mut impl Boundary,p:u32,n:u32,v:u32)->Result<(),Error> {Ok(Storage::write_word(b,add(p,n)?,v)?)}
fn byte(b:&mut impl Boundary,p:u32,n:u32,v:u8)->Result<(),Error> {Ok(b.write_byte(add(p,n)?,v)?)}

/// First three writes of99A310. The address denotes fresh exclusive scratch,
/// not an existing owned String24. No heap is acquired by this function; after
/// success adopt Temporary::new_reset(address), then call resolve.
pub fn initialize_key(b:&mut impl Boundary,address:u32)->Result<(),Error> {
    put(b,address,20,15)?;
    put(b,address,16,0)?;
    byte(b,address,0,0)
}

///5FA6B0: word comparisons followed by byte comparisons on the differing word
/// or final partial word. Unsigned bytes determine the sign, including >=128.
fn compare_bytes(b:&mut impl Boundary,mut left:u32,mut right:u32,mut length:u32)->Result<i32,Error> {
    while length>=4 {
        let a=b.word(left)?;
        let c=b.word(right)?;
        if a!=c {break;}
        left=add(left,4)?;right=add(right,4)?;length-=4;
    }
    for i in 0..length.min(4) {
        let a=b.read_byte(add(left,i)?)?;
        let c=b.read_byte(add(right,i)?)?;
        if a!=c {return Ok(if a<c {-1}else{1});}
    }
    Ok(0)
}
fn length_order(a:u32,c:u32)->i32 {if a<c {-1}else if a>c {1}else{0}}

///5FA720 offset0/count, only the valid complete-string range used by901F00.
fn compare_range(b:&mut impl Boundary,left:u32,count:u32,right_data:u32,right_length:u32)->Result<i32,Error> {
    let length=word(b,left,16)?.min(count);
    let data=if word(b,left,20)?<16 {left}else{b.word(left)?};
    let result=compare_bytes(b,data,right_data,length.min(right_length))?;
    Ok(if result==0 {length_order(length,right_length)}else{result})
}

///901F00 repeats the string comparison on its unequal branch; do not collapse
/// its descriptor rereads, even though stable inputs usually make them equal.
fn key_less(b:&mut impl Boundary,left:u32,right:u32)->Result<bool,Error> {
    let right_capacity=word(b,right,20)?;
    let right_data=if right_capacity<16 {right}else{b.word(right)?};
    let right_length=word(b,right,16)?;
    let left_count=word(b,left,16)?;
    if compare_range(b,left,left_count,right_data,right_length)?==0 {
        let left_skin=word(b,left,24)?;
        let right_skin=word(b,right,24)?;
        return Ok(left_skin<right_skin);
    }
    let right_capacity=word(b,right,20)?;
    let right_length=word(b,right,16)?;
    let right_data=if right_capacity<16 {right}else{b.word(right)?};
    let left_count=word(b,left,16)?;
    Ok(compare_range(b,left,left_count,right_data,right_length)?<0)
}

///90D220 lower_bound. The key length is cached, capacity is reloaded after each
/// child nil test, and the unequal-name branch repeats its byte comparison.
fn lower_bound(b:&mut impl Boundary,tree:u32,key:u32)->Result<u32,Error> {
    let mut candidate=b.word(tree)?;
    let mut node=word(b,candidate,4)?;
    if b.read_byte(add(node,13)?)?!=0 {return Ok(candidate);}
    let key_length=word(b,key,16)?;
    let initial_key_capacity=word(b,key,20)?;
    let mut key_capacity=initial_key_capacity;
    let mut seen=BTreeSet::new();
    loop {
        // Host malformed-tree boundary, not an extra native memory read.
        if !seen.insert(node) {return Err(Error::InvalidTree);}
        let node_key=add(node,16)?;
        let key_data=if key_capacity<16 {key}else{b.word(key)?};
        let node_capacity=word(b,node_key,20)?;
        let node_length=word(b,node_key,16)?;
        let node_data=if node_capacity<16 {node_key}else{b.word(node_key)?};
        let common=node_length.min(key_length);
        let comparison=compare_bytes(b,node_data,key_data,common)?;
        let less=if comparison==0 && node_length==key_length {
            let node_skin=word(b,node_key,24)?;
            let key_skin=word(b,key,24)?;
            node_skin<key_skin
        } else {
            let key_data=if initial_key_capacity<16 {key}else{b.word(key)?};
            let node_data=if word(b,node_key,20)?<16 {node_key}else{b.word(node_key)?};
            let comparison=compare_bytes(b,node_data,key_data,common)?;
            (if comparison==0 {length_order(node_length,key_length)}else{comparison})<0
        };
        if less {node=word(b,node,8)?;}else{candidate=node;node=b.word(node)?;}
        let is_nil=b.read_byte(add(node,13)?)?!=0;
        key_capacity=word(b,key,20)?;
        if is_nil {return Ok(candidate);}
    }
}

///Continue99A310 after its fresh descriptor initialization. Its three heap
///pointer reads and length read keep their source order. Lowercase spans the
///full length, not a C string; embedded NUL and high bytes are preserved.
fn normalize(b:&mut impl Boundary,original_name:u32,key:&mut Temporary)->Result<(),Error> {
    owned::assign_owned_non_alias(b,key,original_name)?;
    let p=key.address();
    let capacity=word(b,p,20)?;
    let output=if capacity<16 {p}else{b.word(p)?};
    let beginning=if capacity<16 {p}else{b.word(p)?};
    let length=word(b,p,16)?;
    let end=add(beginning,length)?;
    let input=if capacity<16 {p}else{b.word(p)?};
    let count=end.saturating_sub(input); //5FA650 uses zero if begin>end.
    for i in 0..count {
        let value=b.read_byte(add(input,i)?)?;
        if !b.locale_is_default()? {return Err(Error::Boundary("non-C locale C985D6 is unavailable"));}
        let lowered=if value.is_ascii_uppercase() {value+32}else{value};
        byte(b,output,i,lowered)?;
    }
    Ok(())
}

///The caller supplies a fresh initialized key guard and at least KEY_BYTES of
///exclusive scratch. On every Result, that same guard still owns the copied
///key. No cleanup or factory call occurs here. Retire with564900 reset (via
///Temporary::new_reset) before discarding its lease. The input name is borrowed.
pub fn resolve(b:&mut impl Boundary,manager:u32,original_name:u32,skin:u32,key:&mut Temporary)->Result<Outcome,Error> {
    normalize(b,original_name,key)?;
    put(b,key.address(),24,skin)?;
    let tree=add(manager,12)?;
    let mut candidate=lower_bound(b,tree,key.address())?;
    if candidate==b.word(tree)? || key_less(b,key.address(),add(candidate,16)?)? {
        candidate=b.word(tree)?;
    }
    if candidate==b.word(tree)? {
        Ok(Outcome::MissFactory{manager,original_name,skin})
    } else {
        Ok(Outcome::HitBorrowed{provider:word(b,candidate,44)?})
    }
}

#[cfg(test)]
#[path="audio_loading_resource_cache_tests.rs"]
mod tests;
