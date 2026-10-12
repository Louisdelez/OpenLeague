//! Native72C780 replay command target and10D6048 packet-object virtual methods.
use crate::audio_announcer_object_lookup::{self as read,Memory};
use crate::audio_announcer_registry_init::{self as init,Storage};
use crate::audio_announcer_registry_remove::{self as removal,Backend as Free};
use crate::audio_announcer_owner_control as control;
use crate::audio_replay_shared_pair as pair;
use crate::audio_replay_object_manager as objects;
use crate::audio_replay_events as events;
#[derive(Debug,PartialEq,Eq)]
pub enum Error{Read(read::Error),Write(init::Error),Free(removal::Error),Control(control::Error),Pair(pair::Error),Objects(objects::Error),Events(events::Error),Boundary(&'static str),AddressOverflow}
impl From<read::Error> for Error{fn from(e:read::Error)->Self{Self::Read(e)}}
impl From<init::Error> for Error{fn from(e:init::Error)->Self{Self::Write(e)}}
impl From<removal::Error> for Error{fn from(e:removal::Error)->Self{Self::Free(e)}}
impl From<control::Error> for Error{fn from(e:control::Error)->Self{Self::Control(e)}}
impl From<pair::Error> for Error{fn from(e:pair::Error)->Self{Self::Pair(e)}}
impl From<objects::Error> for Error{fn from(e:objects::Error)->Self{Self::Objects(e)}}
impl From<events::Error> for Error{fn from(e:events::Error)->Self{Self::Events(e)}}
pub const PACKET_VTABLE:u32=0x10d6048;
pub const PACKET_DELETE:u32=0x5740d0;
pub const PACKET_ID:u32=0x8fd680;
pub const PACKET_VALUE:u32=0x8fd690;
pub trait Boundary:objects::Boundary+events::Boundary{
 /// Actual stream/global startup must be provided, never a fabricated manager.
 fn initialize_game_manager(&mut self)->Result<(),&'static str>;
}
fn add(a:u32,b:u32)->Result<u32,Error>{a.checked_add(b).ok_or(Error::AddressOverflow)}
fn game_manager(b:&mut impl Boundary)->Result<u32,Error>{
 let mut pointer=b.word(0x2d78520)?;
 if pointer==0{b.initialize_game_manager().map_err(Error::Boundary)?;pointer=b.word(0x2d78520)?;}
 if pointer==0{return Err(Error::Boundary("replay manager initialization returned no manager"));}Ok(pointer)
}
pub fn packet_id(b:&mut impl Memory,object:u32)->Result<u32,Error>{Ok(b.word(add(object,4)?)?)}
pub fn packet_value(b:&mut impl Memory,object:u32)->Result<u64,Error>{let low=b.word(add(object,8)?)?;let high=b.word(add(object,12)?)?;Ok(low as u64 | ((high as u64)<<32))}
pub fn delete_packet<B:Storage+Free>(b:&mut B,object:u32,flags:u32)->Result<u32,Error>{
 Storage::write_word(b,object,0x10854d0)?;if flags&1!=0{let route=b.deallocator()?;b.free(object,route)?;}Ok(object)
}
fn acquire(b:&mut impl Boundary,output:u32)->Result<u32,Error>{let manager=game_manager(b)?;pair::from_manager(b,manager,output)?;Ok(b.word(output)?)}
fn release<T>(b:&mut impl Boundary,reference:u32,result:Result<T,Error>)->Result<T,Error>{
 let dropped=pair::destroy(b,reference).map_err(Error::Pair);match result{Err(e)=>Err(e),Ok(value)=>{dropped?;Ok(value)}}
}
/// The caller owns at least32 exclusive scratch bytes, disjoint from packet and
/// all persistent storage. This is a per-invocation frame, not a shared global.
/// Native target ignores its this argument. Normal success always returns AL1.
pub fn dispatch(b:&mut impl Boundary,args:[u32;5],scratch:u32)->Result<u8,Error>{
 let packet=args[4];
 if packet==0 || args[2] as u8!=0{let manager=game_manager(b)?;events::dispatch(b,manager,args)?;return Ok(1);}
 let opcode=objects::Boundary::read_byte(b,packet)?;
 if opcode>1{return Ok(1);}
 let manager=acquire(b,scratch)?;let id=b.word(add(packet,4)?)?;
 let result=objects::lookup(b,manager,id,add(scratch,24)?).map_err(Error::Objects);
 let value=release(b,scratch,result)?;
 if opcode==0 && value==0{
  let object=b.allocate(16)?;
  if object!=0{
   let id=b.word(add(packet,4)?)?;let low=b.word(add(packet,8)?)?;let high=b.word(add(packet,12)?)?;
   for (off,value) in [(0,PACKET_VTABLE),(4,id),(8,low),(12,high)]{Storage::write_word(b,add(object,off)?,value)?;}
  }
  let incoming=add(scratch,16)?;Storage::write_word(b,incoming,0)?;Storage::write_word(b,add(incoming,4)?,0)?;control::replace_pair(b,incoming,object)?;
  let manager=match acquire(b,scratch){Ok(p)=>p,Err(e)=>{let _=pair::destroy(b,incoming);return Err(e);}};
  let result=objects::insert(b,manager,incoming,add(scratch,24)?).map_err(Error::Objects);
  release(b,scratch,result)?;
 }else if opcode==1 && value!=0{
  let reference=add(scratch,8)?;let manager=acquire(b,reference)?;let id=b.word(add(packet,4)?)?;
  let result=objects::remove(b,manager,id,add(scratch,24)?).map_err(Error::Objects);release(b,reference,result)?;
 }
 Ok(1)
}
