//! Original initialized object-registry lookup62B380/5C6830 and signed CRT hash.
//! Canonical32-bit resource labels, never host pointer casts. Live mutation/locking is separate.
use std::collections::BTreeSet;
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Error {UninitializedRegistry,InvalidLayout,MissingWord(u32),InvalidChain}
pub trait Memory {fn word(&mut self,address:u32)->Result<u32,Error>;}
fn add(base:u32,offset:u32)->Result<u32,Error>{base.checked_add(offset).ok_or(Error::InvalidLayout)}
pub fn key_hash(key:u32)->u32 {
    let value=(key^0xdeadbeef) as i32;
    let quotient=value/127773;let remainder=value%127773;
    let result=remainder.wrapping_mul(16807).wrapping_sub(quotient.wrapping_mul(2836));
    if result<0 {result.wrapping_add(i32::MAX) as u32} else {result as u32}
}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Hash {Legacy,Identity}
pub fn bucket_index(key:u32,mask:u32,maximum:u32)->Result<u32,Error> {bucket_index_with_hash(key,mask,maximum,Hash::Legacy)}
pub fn bucket_index_with_hash(key:u32,mask:u32,maximum:u32,hash:Hash)->Result<u32,Error> {
    let size=mask.checked_add(1).ok_or(Error::InvalidLayout)?;
    if !size.is_power_of_two() || maximum<(mask>>1)+1 || maximum>size {return Err(Error::InvalidLayout);}
    let index=(match hash {Hash::Legacy=>key_hash(key),Hash::Identity=>key})&mask;
    Ok(if index<maximum {index} else {index.wrapping_sub(1).wrapping_sub(mask>>1)})
}
/// Qualified valid, initialized, unique-key registry snapshot only. Missing ID returns native0.
/// Missing/unreadable registry is an error, never a fabricated missing-object result.
pub fn lookup_node_initialized(memory:&mut impl Memory,manager:u32,key:u32)->Result<Option<u32>,Error> {lookup_node_with_hash(memory,manager,key,Hash::Legacy)}
pub fn lookup_node_with_hash(memory:&mut impl Memory,manager:u32,key:u32,hash:Hash)->Result<Option<u32>,Error> {
    if manager==0 {return Err(Error::UninitializedRegistry);}
    let mask=memory.word(add(manager,24)?)?;let maximum=memory.word(add(manager,28)?)?;
    let index=bucket_index_with_hash(key,mask,maximum,hash)?;
    let head=memory.word(add(manager,4)?)?;let array=memory.word(add(manager,12)?)?;
    if head==0 || array==0 {return Err(Error::InvalidLayout);}
    let bucket=add(array,index.checked_mul(8).ok_or(Error::InvalidLayout)?)?;
    let mut current=memory.word(bucket)?;
    let end=if current==head {head} else {let last=memory.word(add(bucket,4)?)?;memory.word(last)?};
    let mut seen=BTreeSet::new();
    while current!=end {
        if current==0 || current==head || !seen.insert(current) {return Err(Error::InvalidChain);}
        let id=memory.word(add(current,8)?)?;
        if id>=key {return Ok((id==key).then_some(current));}
        current=memory.word(current)?;
    }
    Ok(None)
}
pub fn lookup_initialized(memory:&mut impl Memory,manager:u32,key:u32)->Result<u32,Error> {match lookup_node_initialized(memory,manager,key)? {Some(node)=>memory.word(add(node,12)?),None=>Ok(0)}}
