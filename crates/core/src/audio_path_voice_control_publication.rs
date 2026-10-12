//! Native AECEE0 immediate action and AF36B0 publication through AF34D0.
//! The AF3AA0 consumer is mandatory; no silent replacement of voice callbacks.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_path_voice_notification::{Runtime,Services as NotificationServices}};
pub trait Services {
 fn allocate_control(&mut self,pool:u32,bytes:u32)->Result<Option<Memory>,Error>;
 fn drain_controls(&mut self,queue:&mut Runtime)->Result<(),Error>;
}
struct Allocator<'a,T>(&'a mut T);
impl<T:Services> NotificationServices for Allocator<'_,T>{
 fn allocate_notification(&mut self,pool:u32,bytes:u32)->Result<Option<Memory>,Error>{self.0.allocate_control(pool,bytes)}
 fn free_notification(&mut self,_:u32,_:&Memory)->Result<(),Error>{Err(Error::Backend("control append unexpectedly requested removal"))}
 fn voice_action(&mut self,_:&mut Memory,_:u32,_:&mut Runtime)->Result<(),Error>{Err(Error::Backend("control append unexpectedly requested voice action"))}
}
/// Enqueue the four native words. Exhaustion triggers the mandatory consumer
/// before one retry; a still-null native payload would fault, so return an error.
pub fn publish(queue:&mut Runtime,voice:u32,selector:u32,argument:u32,value_bits:u32,services:&mut impl Services)->Result<(),Error>{
 let mut payload=queue.append(&mut Allocator(services))?;
 if payload==0{services.drain_controls(queue)?;payload=queue.append(&mut Allocator(services))?;}
 if payload==0{return Err(Error::InvalidAllocation);}
 for(i,value)in [voice,selector,argument,value_bits].into_iter().enumerate(){queue.store(payload.wrapping_add(i as u32*4),value)?;}
 Ok(())
}
/// Actual AECEE0 clears word108 before attempting to publish control4.
pub fn immediate_action(queue:&mut Runtime,voice:&mut Memory,argument:u32,services:&mut impl Services)->Result<(),Error>{
 if voice.reference==0||voice.raw.len()<112{return Err(Error::InvalidAllocation);}
 voice.raw[108..112].copy_from_slice(&0u32.to_le_bytes());
 publish(queue,voice.reference,4,argument,0,services)
}

/// Physical allocation plus the actual consumer's required cleanup services.
pub trait Transports:crate::audio_path_voice_control_drain::Services{
 fn allocate_control(&mut self,pool:u32,bytes:u32)->Result<Option<Memory>,Error>;
}
struct Consumer<'a,T>{voices:&'a mut crate::audio_path_voice_control_drain::Runtime,notification:&'a mut Runtime,services:&'a mut T}
impl<T:Transports> Services for Consumer<'_,T>{
 fn allocate_control(&mut self,p:u32,n:u32)->Result<Option<Memory>,Error>{self.services.allocate_control(p,n)}
 fn drain_controls(&mut self,q:&mut Runtime)->Result<(),Error>{self.voices.drain(q,self.notification,self.services)}
}
pub fn publish_draining(control:&mut Runtime,voices:&mut crate::audio_path_voice_control_drain::Runtime,notification:&mut Runtime,voice:u32,selector:u32,argument:u32,value_bits:u32,services:&mut impl Transports)->Result<(),Error>{publish(control,voice,selector,argument,value_bits,&mut Consumer{voices,notification,services})}
