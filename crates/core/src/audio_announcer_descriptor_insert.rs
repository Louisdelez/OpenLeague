//! Native733BF0/735490 compound descriptor insertion and default load-factor growth.
use crate::audio_announcer_object_lookup::{self as lookup,Memory};
use crate::audio_announcer_registry_init::{self as init,Storage};
use crate::audio_announcer_registry_remove::{self as remove,Backend as RemovalBackend};
#[derive(Debug,PartialEq,Eq)]
pub enum Error {Storage(lookup::Error),Allocation(init::Error),Release(remove::Error),InvalidLayout,CountLimit,UnsupportedLoadFactor(u32),NullAllocation(u32),AddressOverflow}
impl From<lookup::Error> for Error {fn from(e:lookup::Error)->Self {Self::Storage(e)}}
impl From<init::Error> for Error {fn from(e:init::Error)->Self {Self::Allocation(e)}}
impl From<remove::Error> for Error {fn from(e:remove::Error)->Self {Self::Release(e)}}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct Inserted {pub node:u32,pub inserted:bool}
fn add(a:u32,b:u32)->Result<u32,Error> {a.checked_add(b).ok_or(Error::AddressOverflow)}
fn write<B:Storage>(b:&mut B,a:u32,v:u32)->Result<(),Error> {Storage::write_word(b,a,v)?;Ok(())}
fn free<B:RemovalBackend>(b:&mut B,a:u32)->Result<(),Error> {let route=b.deallocator()?;b.free(a,route)?;Ok(())}
fn sort_node<B:Storage+RemovalBackend>(b:&mut B,manager:u32,node:u32,depth:u32,hash:lookup::Hash)->Result<Inserted,Error> {
 if depth>32 {return Err(Error::InvalidLayout);}
 let key=b.word(add(node,8)?)?;let event=b.word(add(node,16)?)? as u16;let pair=(key,event);let mask=b.word(add(manager,20)?)?;let maximum=b.word(add(manager,24)?)?;
 let index=lookup::bucket_index_with_hash(key|((event as u32)<<16),mask,maximum,lookup::Hash::Identity)?;let buckets=b.word(add(manager,8)?)?;let bucket=add(buckets,index.checked_mul(8).ok_or(Error::AddressOverflow)?)?;
 let head=b.word(manager)?;let first=b.word(bucket)?;let mut position=head;
 if first!=head {
  let last=b.word(add(bucket,4)?)?;position=b.word(last)?;
  if position!=first {
   loop {
    position=b.word(add(position,4)?)?;let current_key=(b.word(add(position,8)?)?,b.word(add(position,16)?)? as u16);
    if current_key<=pair {
     if current_key==pair {
      let previous=b.word(add(node,4)?)?;let next=b.word(node)?;write(b,previous,next)?;write(b,add(next,4)?,previous)?;
      let count=b.word(add(manager,4)?)?;write(b,add(manager,4)?,count.wrapping_sub(1))?;crate::audio_announcer_active_service::free_descriptor_payload(b,node).map_err(|_|Error::InvalidLayout)?;
      return Ok(Inserted {node:position,inserted:false});
     }
     position=b.word(position)?;break;
    }
    if position==first {break;}
   }
  }
 }
 let last=b.word(node)?;
 if position!=last {
  let previous=b.word(add(node,4)?)?;write(b,previous,last)?;
  let previous_last=b.word(add(last,4)?)?;write(b,previous_last,position)?;
  let previous_position=b.word(add(position,4)?)?;write(b,previous_position,node)?;
  let previous_last=b.word(add(last,4)?)?;let previous_position=b.word(add(position,4)?)?;write(b,add(position,4)?,previous_last)?;
  let previous=b.word(add(node,4)?)?;write(b,add(last,4)?,previous)?;write(b,add(node,4)?,previous_position)?;
 }
 let first=b.word(bucket)?;
 if first==head {write(b,bucket,node)?;write(b,add(bucket,4)?,node)?;}
 else if first==position {write(b,bucket,node)?;}
 else {let previous_last=b.word(add(bucket,4)?)?;let mut next=b.word(previous_last)?;write(b,add(bucket,4)?,next)?;if next!=node {next=b.word(add(next,4)?)?;write(b,add(bucket,4)?,next)?;}}
 grow(b,manager,depth,hash)?;Ok(Inserted {node,inserted:true})
}
fn grow<B:Storage+RemovalBackend>(b:&mut B,manager:u32,depth:u32,hash:lookup::Hash)->Result<(),Error> {
 let count=b.word(add(manager,4)?)?;let maximum=b.word(add(manager,24)?)?;let load=b.word(add(manager,28)?)?;
 if load!=0x40800000 {return Err(Error::UnsupportedLoadFactor(load));}
 if u64::from(count)<=u64::from(maximum)*4 {return Ok(());}
 let target=if maximum<512 {maximum.checked_mul(8).ok_or(Error::AddressOverflow)?} else if maximum<0x1fffffff {maximum.checked_mul(2).ok_or(Error::AddressOverflow)?} else {maximum};
 if target==0 {return Err(Error::InvalidLayout);}
 let old=b.word(add(manager,8)?)?;let capacity_end=b.word(add(manager,16)?)?;let capacity=capacity_end.checked_sub(old).ok_or(Error::InvalidLayout)?/4;
 let requested=target.checked_mul(2).ok_or(Error::AddressOverflow)?;write(b,add(manager,12)?,old)?;let head=b.word(manager)?;
 if requested>capacity {
  let half=capacity>>1;let increased=if capacity>0x3fffffff-half {0} else {capacity+half};let allocation_words=increased.max(requested);let bytes=allocation_words.checked_mul(4).ok_or(Error::AddressOverflow)?;
  let new=b.allocate(bytes)?;if new==0 {return Err(Error::NullAllocation(bytes));}
  for i in 0..requested {write(b,add(new,i.checked_mul(4).ok_or(Error::AddressOverflow)?)?,head)?;}
  if old!=0 {free(b,old)?;}
  write(b,add(manager,8)?,new)?;write(b,add(manager,16)?,add(new,bytes)?)?;write(b,add(manager,12)?,add(new,requested*4)?)?;
 } else {for i in 0..requested {write(b,add(old,i*4)?,head)?;}write(b,add(manager,12)?,add(old,requested*4)?)?;}
 write(b,add(manager,20)?,target-1)?;write(b,add(manager,24)?,target)?;
 if b.word(head)?!=head {
  let last=b.word(add(head,4)?)?;
  loop {let node=b.word(head)?;sort_node(b,manager,node,depth+1,hash)?;if node==last {break;}}
 }
 Ok(())
}

pub fn find_or_insert<B:Storage+RemovalBackend>(b:&mut B,manager:u32,owner:u32,extra:u32,event:u16)->Result<u32,Error> {
 if let Some(node)=crate::audio_announcer_active_service::descriptor_lookup(b,manager,owner,event).map_err(|_|Error::InvalidLayout)? {return Ok(node);}
 let head=b.word(manager)?;let first=b.word(head)?;let previous=b.word(add(first,4)?)?;let node=b.allocate(32)?;if node==0 {return Err(Error::NullAllocation(32));}
 for (offset,value) in [(0,first),(4,previous),(8,owner),(12,extra),(20,0),(24,0),(28,0)] {write(b,add(node,offset)?,value)?;}
 b.write_byte(add(node,16)?,event as u8)?;b.write_byte(add(node,17)?,(event>>8) as u8)?;
 let count=b.word(add(manager,4)?)?;if count>=0x7fffffe {return Err(Error::CountLimit);}write(b,add(manager,4)?,count+1)?;write(b,add(first,4)?,node)?;let previous=b.word(add(node,4)?)?;write(b,previous,node)?;let current=b.word(head)?;
 Ok(sort_node(b,manager,current,0,lookup::Hash::Identity)?.node)
}
