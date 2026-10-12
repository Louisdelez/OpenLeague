//! Native5CCE30/65EE40 callback dispatch, four descriptors and metadata consumers.
use crate::audio_announcer_owner_metadata::{Error,SERVICE_GLOBAL};
use crate::audio_announcer_object_lookup::{self as lookup,Memory};
use crate::audio_announcer_registry_init::Storage;
fn add(a:u32,b:u32)->Result<u32,Error> {a.checked_add(b).ok_or(Error::AddressOverflow)}
pub trait ConsumerBoundary {
 fn byte(&mut self,address:u32)->Result<u8,lookup::Error>;
 fn service_gate(&mut self,service:u32,callback:u32)->Result<u32,&'static str>;
 fn actor_call(&mut self,actor:u32,callback:u32)->Result<(),&'static str>;
 fn diagnostic(&mut self,arguments:[u32;5])->Result<(),&'static str>;
}
/// Current vtable slot4 selects the native getter or its three adjusting thunks.
pub fn owner_id<B:Memory>(b:&mut B,owner:u32)->Result<u32,Error> {
 let vt=b.word(owner)?;let target=b.word(add(vt,4)?)?;
 let adjustment=match target {0x6b28a0=>0,0x6bd80d=>8,0x6bd7ed=>16,0x6bd7fd=>24,_=>return Err(Error::UnknownCallback(target))};
 let metadata=owner.checked_sub(adjustment).ok_or(Error::AddressOverflow)?;let storage=b.word(add(metadata,48)?)?;Ok(b.word(storage)?)
}
fn descriptor<B:Storage>(b:&mut B,owner:u32,packet:u32,code:u16)->Result<u8,Error> {
 let id=owner_id(b,owner)?;let sentinel=b.word(0x2d5f448)?;if id==sentinel {return Ok(0);}
 Storage::write_word(b,packet,id)?;b.write_byte(add(packet,8)?,code as u8)?;b.write_byte(add(packet,9)?,(code>>8) as u8)?;Ok(1)
}
pub fn invoke<B:Storage+ConsumerBoundary>(b:&mut B,handler:u32,packet:u32)->Result<u8,Error> {
 let owner=b.word(add(handler,4)?)?;let method=b.word(add(handler,8)?)?;
 match method {0x6b9680=>descriptor(b,owner,packet,0x51),0x6b96c0=>descriptor(b,owner,packet,0x35),0x6b9700=>descriptor(b,owner,packet,0xe0),0x6b9740=>descriptor(b,owner,packet,0xe1),0x65ee40=>consume(b,owner,packet),_=>Err(Error::UnknownCallback(method))}
}
/// Native65EE40 forwards the original packet to current owner vtable slot8.
pub fn consume<B:Storage+ConsumerBoundary>(b:&mut B,owner:u32,packet:u32)->Result<u8,Error> {
 let vt=b.word(owner)?;let method=b.word(add(vt,8)?)?;
 match method {
  0x6b27a0|0x6b27d0=>{
   let service=b.word(SERVICE_GLOBAL)?;let table=b.word(service)?;let callback=b.word(add(table,0xb0)?)?;let gate=b.service_gate(service,callback).map_err(Error::Boundary)? as u8;
   if gate==0 {let (actor_offset,flag_offset,slot)=if method==0x6b27a0 {(32,36,0x24)} else {(24,29,0x2c)};let actor=b.word(add(owner,actor_offset)?)?;b.write_byte(add(owner,flag_offset)?,gate)?;let table=b.word(actor)?;let callback=b.word(add(table,slot)?)?;b.actor_call(actor,callback).map_err(Error::Boundary)?;}
  }
  0x6b2800|0x6b2850=>{
   if b.byte(add(packet,5)?)?>=4 {b.diagnostic([0x10a2878,0x1085b2d,0,0x1085b2d,0x1085b2d]).map_err(Error::Boundary)?;}
   // Original reload after diagnostic, then x86 masks the shift count to five bits.
   let index=b.byte(add(packet,5)?)?;let bit=1u32<<(index&31);let field=add(owner,if method==0x6b2800 {24} else {16})?;let old=b.word(field)?;Storage::write_word(b,field,if method==0x6b2800 {old|bit} else {old&!bit})?;
  }
  _=>return Err(Error::UnknownCallback(method)),
 }Ok(1)
}
