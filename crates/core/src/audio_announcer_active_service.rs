//! Native active registry construction7306C0/7307F0 and removal72EE20.
use crate::audio_announcer_owner_metadata::Error;
use crate::audio_announcer_object_lookup::{self as lookup,Memory};
use crate::audio_announcer_registry_init::Storage;
use crate::audio_announcer_registry_remove::{self as remove,Backend as RemovalBackend,Deallocator};
fn add(a:u32,b:u32)->Result<u32,Error> {a.checked_add(b).ok_or(Error::AddressOverflow)}
fn construct_registry<B:Storage>(b:&mut B,base:u32,shift:u32,head_bytes:u32)->Result<(),Error> {
 Storage::write_word(b,add(base,shift)?,0)?;Storage::write_word(b,add(base,shift+4)?,0)?;
 let head=b.allocate(head_bytes)?;if head==0 {return Err(Error::Boundary("native sentinel allocation failure"));}
 Storage::write_word(b,head,head)?;Storage::write_word(b,add(head,4)?,head)?;Storage::write_word(b,add(base,shift)?,head)?;
 for offset in [8,12,16] {Storage::write_word(b,add(base,shift+offset)?,0)?;}
 Storage::write_word(b,add(base,shift+28)?,0x40800000)?;
 let buckets=b.allocate(64)?;if buckets==0 {return Err(Error::Boundary("native bucket allocation failure"));}
 for offset in (0..64).step_by(4) {Storage::write_word(b,add(buckets,offset)?,head)?;}
 Storage::write_word(b,add(base,shift+8)?,buckets)?;Storage::write_word(b,add(base,shift+16)?,add(buckets,64)?)?;Storage::write_word(b,add(base,shift+12)?,add(buckets,64)?)?;
 Storage::write_word(b,add(base,shift+20)?,7)?;Storage::write_word(b,add(base,shift+24)?,8)?;Ok(())
}
pub fn construct<B:Storage>(b:&mut B,service:u32,opaque_byte:u8)->Result<(),Error> {
 construct_registry(b,add(service,24)?,0,32)?;let owner=add(service,56)?;b.write_byte(owner,opaque_byte)?;construct_registry(b,owner,4,24)
}
pub fn descriptor_lookup<B:Memory>(b:&mut B,registry:u32,owner:u32,event:u16)->Result<Option<u32>,Error> {
 let mask=b.word(add(registry,20)?)?;let maximum=b.word(add(registry,24)?)?;let key=owner|((event as u32)<<16);
 let index=lookup::bucket_index_with_hash(key,mask,maximum,lookup::Hash::Identity)?;let head=b.word(registry)?;let array=b.word(add(registry,8)?)?;let bucket=add(array,index*8)?;
 let mut node=b.word(bucket)?;let last=b.word(add(bucket,4)?)?;let end=if last==head {head} else {b.word(last)?};let mut seen=std::collections::BTreeSet::new();
 while node!=end {if node==0 || node==head || !seen.insert(node) {return Err(Error::Context(lookup::Error::InvalidChain));}let id=b.word(add(node,8)?)?;let code=b.word(add(node,16)?)? as u16;
  if id>owner || (id==owner && code>=event) {return Ok((id==owner && code==event).then_some(node));}node=b.word(node)?;
 }Ok(None)
}
fn remove_descriptor<B:Storage+RemovalBackend>(b:&mut B,registry:u32,node:u32)->Result<(),Error> {
 let owner=b.word(add(node,8)?)?;let event=b.word(add(node,16)?)? as u16;let mask=b.word(add(registry,20)?)?;let maximum=b.word(add(registry,24)?)?;let index=lookup::bucket_index_with_hash(owner|((event as u32)<<16),mask,maximum,lookup::Hash::Identity)?;let buckets=b.word(add(registry,8)?)?;let bucket=add(buckets,index*8)?;let head=b.word(registry)?;
 if b.word(add(bucket,4)?)?==node {if b.word(bucket)?==node {Storage::write_word(b,bucket,head)?;Storage::write_word(b,add(bucket,4)?,head)?;} else {let previous=b.word(add(node,4)?)?;Storage::write_word(b,add(bucket,4)?,previous)?;}}
 else if b.word(bucket)?==node {let next=b.word(node)?;Storage::write_word(b,bucket,next)?;}
 let previous=b.word(add(node,4)?)?;let next=b.word(node)?;Storage::write_word(b,previous,next)?;let fresh_next=b.word(node)?;let fresh_previous=b.word(add(node,4)?)?;Storage::write_word(b,add(fresh_next,4)?,fresh_previous)?;let count=b.word(add(registry,4)?)?;Storage::write_word(b,add(registry,4)?,count.wrapping_sub(1))?;
 free_descriptor_payload(b,node)
}
pub(crate) fn free_descriptor_payload<B:Storage+RemovalBackend>(b:&mut B,node:u32)->Result<(),Error> {
 //6F17B0 caches a standard route across array free; custom route reloads after it.
 let mut route=b.deallocator()?;let array=b.word(add(node,20)?)?;
 if array!=0 {b.free(array,route)?;if matches!(route,Deallocator::Custom{..}) {route=b.deallocator()?;}for offset in [20,24,28] {Storage::write_word(b,add(node,offset)?,0)?;}}
 b.free(node,route)?;Ok(())
}
/// Actual72EE20: storage identity lookup, descriptor match, first vector identity erase,
/// empty descriptor removal, then unconditional owner-node erase when owner key exists.
pub fn remove_active<B:Storage+RemovalBackend>(b:&mut B,registry:u32,field:u32)->Result<(),Error> {
 let owners=add(registry,32)?;let Some(owner_node)=lookup::lookup_node_initialized(b,owners,field)? else {return Ok(());};let id=b.word(add(owner_node,12)?)?;let event=b.word(add(owner_node,20)?)? as u16;
 if let Some(node)=descriptor_lookup(b,registry,id,event)? {
  let begin=b.word(add(node,20)?)?;let end=b.word(add(node,24)?)?;let mut cursor=begin;
  while cursor!=end {if b.word(cursor)?==field {let mut source=cursor.wrapping_add(4);let mut destination=cursor;while source!=end {let value=b.word(source)?;Storage::write_word(b,destination,value)?;source=source.wrapping_add(4);destination=destination.wrapping_add(4);}let end=b.word(add(node,24)?)?;Storage::write_word(b,add(node,24)?,end.wrapping_sub(4))?;if b.word(add(node,20)?)?==b.word(add(node,24)?)? {remove_descriptor(b,registry,node)?;}break;}cursor=cursor.wrapping_add(4);}
 }
 remove::remove_node(b,owners,owner_node)?;Ok(())
}
