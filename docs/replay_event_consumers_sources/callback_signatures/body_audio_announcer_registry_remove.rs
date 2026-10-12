//! Normal-return 64DD60 removal of a valid live node from the native registry layout.
use crate::audio_announcer_object_lookup::{self as lookup,Memory};
#[derive(Debug,Clone,PartialEq,Eq)]
pub enum Error { Owned(crate::audio_announcer_registry_init::Error), Storage(lookup::Error), Backend(&'static str), InvalidNode, AddressOverflow }
impl From<lookup::Error> for Error {fn from(value:lookup::Error)->Self {Self::Storage(value)}}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Deallocator {Standard,Custom {callback:u32,context:u32}}
pub trait Backend:Memory {
    fn write_word(&mut self,address:u32,value:u32)->Result<(),Error>;
    /// Native deallocator globals are selected after unlink and count decrement.
    fn deallocator(&mut self)->Result<Deallocator,Error>;
    fn free(&mut self,node:u32,route:Deallocator)->Result<(),Error>;
}
fn add(base:u32,offset:u32)->Result<u32,Error> {base.checked_add(offset).ok_or(Error::AddressOverflow)}
/// Only valid, owned live nodes are qualified. Sentinel/null handles are rejected explicitly.
/// Free errors retain the already-unlinked topology, matching the native call order.
pub fn remove_node(memory:&mut impl Backend,manager:u32,node:u32)->Result<u32,Error> {remove_node_with_hash(memory,manager,node,lookup::Hash::Legacy)}
pub fn remove_node_with_hash(memory:&mut impl Backend,manager:u32,node:u32,hash:lookup::Hash)->Result<u32,Error> {
    if manager==0 || node==0 {return Err(Error::InvalidNode);}
    let head=memory.word(add(manager,4)?)?;
    if node==head {return Err(Error::InvalidNode);}
    let key=memory.word(add(node,8)?)?;
    let mask=memory.word(add(manager,24)?)?;let maximum=memory.word(add(manager,28)?)?;
    let index=lookup::bucket_index_with_hash(key,mask,maximum,hash)?;
    let buckets=memory.word(add(manager,12)?)?;let bucket=add(buckets,index.checked_mul(8).ok_or(Error::AddressOverflow)?)?;
    if memory.word(add(bucket,4)?)?==node {
        if memory.word(bucket)?==node {memory.write_word(bucket,head)?;memory.write_word(add(bucket,4)?,head)?;}
        else {let previous=memory.word(add(node,4)?)?;memory.write_word(add(bucket,4)?,previous)?;}
    } else if memory.word(bucket)?==node {let next=memory.word(node)?;memory.write_word(bucket,next)?;}
    let previous=memory.word(add(node,4)?)?;let next=memory.word(node)?;
    memory.write_word(previous,next)?;
    let current_next=memory.word(node)?;let current_previous=memory.word(add(node,4)?)?;
    memory.write_word(add(current_next,4)?,current_previous)?;
    let count=memory.word(add(manager,8)?)?;memory.write_word(add(manager,8)?,count.wrapping_sub(1))?;
    let route=memory.deallocator()?;memory.free(node,route)?;Ok(next)
}
impl Backend for crate::audio_announcer_registry_init::OwnedMemory {
 fn write_word(&mut self,a:u32,v:u32)->Result<(),Error> {crate::audio_announcer_registry_init::Storage::write_word(self,a,v).map_err(Error::Owned)}
 fn deallocator(&mut self)->Result<Deallocator,Error> {Ok(Deallocator::Standard)}
 fn free(&mut self,node:u32,route:Deallocator)->Result<(),Error> {match route {Deallocator::Standard=>self.release(node).map_err(Error::Owned),Deallocator::Custom {..}=>Err(Error::Backend("custom native deallocator unavailable in owned backend"))}}
}
