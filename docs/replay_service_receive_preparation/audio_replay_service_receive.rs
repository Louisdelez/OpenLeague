//! Native738A3A/72B2D0/72B2F0 replay packet entry.
//! Accepted packets execute the existing72EC40/72EEC0 ports.588290 is an
//! explicit boundary: a filtered packet, a default opcode and a delivered
//! simulation action must not be conflated.
use crate::audio_announcer_metadata_callbacks::ConsumerBoundary;
use crate::audio_announcer_object_lookup::Memory;
use crate::audio_announcer_owner_metadata::Error;
use crate::audio_announcer_pending_service::PendingBoundary;
use crate::audio_announcer_registry_init::Storage;
use crate::audio_announcer_registry_remove::Backend as RemovalBackend;
use crate::audio_announcer_service_activation as registry;

pub const RECEIVE_WRAPPER:u32=0x72b2d0;
pub const LOCAL_OWNER:u32=0x2d62878;
pub const PACKET_CASE_INDICES:u32=0x58c39c;
pub const PACKET_JUMP_TABLE:u32=0x58c1ac;
pub const PACKET_DEFAULT:u32=0x58830a;
pub const SCRATCH_BYTES:u32=24;

pub trait Boundary:Storage+RemovalBackend+PendingBoundary+ConsumerBoundary {
 /// Execute the actual588290 packet handler, or return a precise unsupported
 /// error. Event is already decoded; packet is the original unshifted pointer.
 fn packet_fallback(&mut self,event:u16,packet:u32,context:u32)->Result<u8,Error>;
}
fn add(p:u32,n:u32)->Result<u32,Error>{p.checked_add(n).ok_or(Error::AddressOverflow)}
fn word<B:Memory>(b:&mut B,p:u32,n:u32)->Result<u32,Error>{Ok(b.word(add(p,n)?)?)}
fn put<B:Storage>(b:&mut B,p:u32,n:u32,value:u32)->Result<(),Error>{Ok(Storage::write_word(b,add(p,n)?,value)?)}
fn byte<B:ConsumerBoundary>(b:&mut B,p:u32,n:u32)->Result<u8,Error>{Ok(b.byte(add(p,n)?)?)}

/// Source588290 switch target. This classifies source bytes and performs no
/// consumer action. Only PACKET_DEFAULT is the original side-effect-free AL0.
/// Tables require exact PE regions58C39C(301) and58C1AC(496).
pub fn packet_target<B:Memory+ConsumerBoundary>(b:&mut B,event:u16)->Result<u32,Error>{
 let index=(event as u32).wrapping_sub(2);if index>0x12c{return Ok(PACKET_DEFAULT);}
 let case=byte(b,PACKET_CASE_INDICES,index)? as u32;word(b,PACKET_JUMP_TABLE,case*4)
}

///72B2F0. Context is an opaque32-bit value, not a length. The source wrapper
///does not validate packet extent; the caller must supply readable native data.
///Scratch is24 writable bytes, disjoint from packet/service/live allocations.
///Its descriptor and activation padding bytes remain caller-owned opaque input.
pub fn receive<B:Boundary>(b:&mut B,service:u32,context:u32,packet:u32,scratch:u32)->Result<u8,Error>{
 let first=byte(b,packet,0)?;let event=if first==0xfe{u16::from_le_bytes([byte(b,packet,5)?,byte(b,packet,6)?])}else{first as u16};
 if event==0xdd{return Ok(1);}
 if byte(b,service,0x184)?==0&&!matches!(event,0x88|0x92|0x54|0x95|0xc6){return Ok(1);}
 put(b,service,0x5c,context)?;let owner=word(b,packet,1)?;
 if owner!=b.word(LOCAL_OWNER)?{
  // Original descriptor writes precede pending activation, which can allocate
  // and invoke callbacks. Neither header nor owner is re-read afterward.
  put(b,scratch,4,0)?;put(b,scratch,0,owner)?;
  b.write_byte(add(scratch,8)?,event as u8)?;b.write_byte(add(scratch,9)?,(event>>8) as u8)?;
  registry::activate(b,service,add(scratch,12)?)?;
  let returned=registry::dispatch(b,service,scratch,packet)?;
  if returned!=0{return Ok(returned);}
 }
 b.packet_fallback(event,packet,context)
}

///738A3A virtual tailcall followed by72B2D0. Arbitrary overridden vtable
///targets remain explicit errors until their implementation is connected.
pub fn invoke_virtual<B:Boundary>(b:&mut B,service:u32,context:u32,packet:u32,scratch:u32)->Result<u8,Error>{
 let table=b.word(service)?;let target=word(b,table,0x34)?;
 if target!=RECEIVE_WRAPPER{return Err(Error::UnknownCallback(target));}
 receive(b,service,context,packet,scratch)
}

#[cfg(test)]
#[path="audio_replay_service_receive_tests.rs"]
mod tests;
