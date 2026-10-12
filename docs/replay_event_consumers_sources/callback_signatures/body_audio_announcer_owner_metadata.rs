//! Native6B26F0 metadata and6B2900/6B28C0 normal-return destruction.
//! Service virtual calls and allocator startup remain explicit runtime boundaries.
use crate::audio_announcer_object_lookup::{self as lookup,Memory};
use crate::audio_announcer_registry_init::{self as init,Storage};
use crate::audio_announcer_registry_remove::{self as remove,Backend as RemovalBackend};
#[derive(Debug,PartialEq,Eq)]
pub enum Error {Context(lookup::Error),Storage(init::Error),Release(remove::Error),Boundary(&'static str),UnknownCallback(u32),AddressOverflow}
impl From<lookup::Error> for Error {fn from(e:lookup::Error)->Self {Self::Context(e)}}
impl From<init::Error> for Error {fn from(e:init::Error)->Self {Self::Storage(e)}}
impl From<remove::Error> for Error {fn from(e:remove::Error)->Self {Self::Release(e)}}
fn add(a:u32,b:u32)->Result<u32,Error> {a.checked_add(b).ok_or(Error::AddressOverflow)}
pub const VTABLE:u32=0x10a0384;
pub const SCALAR_DELETE:u32=0x6b28c0;
pub const HANDLER_VTABLE:u32=0x1086078;
pub const HANDLER_DELETE:u32=0x578010;
pub const HANDLER_CLONE:u32=0x5ccdc0;
pub const SERVICE_GLOBAL:u32=0x2d787b8;
pub trait Boundaries {
 /// Execute allocator startup/route selection; returned allocation is real storage.
 fn allocate_callback_clone(&mut self,bytes:u32)->Result<u32,&'static str>;
 /// Original service slot0x84 receives handler storage and a mutable temporary callback.
 fn register_listener(&mut self,service:u32,callback:u32,handler_storage:u32,temporary:&mut u32)->Result<(),&'static str>;
 /// Original service slot0x88 receives handler storage.
 fn unregister_listener(&mut self,service:u32,callback:u32,handler_storage:u32)->Result<(),&'static str>;
}
fn callback_new<B:Storage>(b:&mut B,owner:u32,method:u32)->Result<u32,Error> {
 let p=b.allocate(12)?;if p!=0 {for (o,v) in [(0,HANDLER_VTABLE),(4,owner),(8,method)] {Storage::write_word(b,add(p,o)?,v)?;}}Ok(p)
}
pub fn clone_callback<B:Storage+Boundaries>(b:&mut B,source:u32)->Result<u32,Error> {
 let p=b.allocate_callback_clone(12).map_err(Error::Boundary)?;
 if p!=0 {Storage::write_word(b,p,HANDLER_VTABLE)?;let owner=b.word(add(source,4)?)?;Storage::write_word(b,add(p,4)?,owner)?;let method=b.word(add(source,8)?)?;Storage::write_word(b,add(p,8)?,method)?;}Ok(p)
}
pub fn scalar_delete_callback<B:Storage+RemovalBackend>(b:&mut B,p:u32,flags:u32)->Result<u32,Error> {
 Storage::write_word(b,p,0x1084ed4)?;if flags&1!=0 {let route=b.deallocator()?;b.free(p,route)?;}Ok(p)
}
fn dispatch_delete<B:Storage+RemovalBackend>(b:&mut B,p:u32)->Result<(),Error> {
 if p!=0 {let vt=b.word(p)?;let callback=b.word(vt)?;if callback!=HANDLER_DELETE {return Err(Error::UnknownCallback(callback));}scalar_delete_callback(b,p,1)?;}Ok(())
}
fn listener_construct<B:Storage+RemovalBackend+Boundaries>(b:&mut B,base:u32,method:u32)->Result<(),Error> {
 Storage::write_word(b,base,0x109b308)?;let field=add(base,4)?;Storage::write_word(b,field,0)?;
 let temp=callback_new(b,base,0x65ee40)?;
 let cloned=if temp==0 {0} else {let vt=b.word(temp)?;let callback=b.word(add(vt,4)?)?;if callback!=HANDLER_CLONE {return Err(Error::UnknownCallback(callback));}clone_callback(b,temp)?};
 let old=b.word(field)?;Storage::write_word(b,field,0)?;Storage::write_word(b,field,cloned)?;dispatch_delete(b,old)?;dispatch_delete(b,temp)?;
 let service=b.word(SERVICE_GLOBAL)?;
 if service!=0 {let mut temp=callback_new(b,base,method)?;let vt=b.word(service)?;let callback=b.word(add(vt,0x84)?)?;b.register_listener(service,callback,field,&mut temp).map_err(Error::Boundary)?;dispatch_delete(b,temp)?;}Ok(())
}
pub fn construct<B:Storage+RemovalBackend+Boundaries>(b:&mut B,metadata:u32,actor:u32,owner_storage:u32)->Result<u32,Error> {
 for (offset,method) in [(0,0x6b9680),(8,0x6b96c0),(16,0x6b9700),(24,0x6b9740)] {listener_construct(b,add(metadata,offset)?,method)?;}
 for (offset,value) in [(8,0x10a036c),(16,0x10a0378),(24,0x10a0360),(32,actor),(48,owner_storage),(0,VTABLE)] {Storage::write_word(b,add(metadata,offset)?,value)?;}
 b.write_byte(add(metadata,36)?,0)?;b.write_byte(add(metadata,37)?,0)?;Storage::write_word(b,add(metadata,40)?,0)?;b.write_byte(add(metadata,44)?,0)?;
 let default=b.word(0x123b12c)?;Storage::write_word(b,add(metadata,52)?,default)?;Ok(metadata)
}
pub fn destroy<B:Storage+RemovalBackend+Boundaries>(b:&mut B,metadata:u32)->Result<(),Error> {
 let mut service=0;
 for offset in [24,16,8,0] {
  let base=add(metadata,offset)?;Storage::write_word(b,base,0x109b308)?;let field=add(base,4)?;
  if offset==24 {service=b.word(SERVICE_GLOBAL)?;}
  if service!=0 {let vt=b.word(service)?;let callback=b.word(add(vt,0x88)?)?;b.unregister_listener(service,callback,field).map_err(Error::Boundary)?;if offset!=0 {service=b.word(SERVICE_GLOBAL)?;}}
  let handler=b.word(field)?;dispatch_delete(b,handler)?;if handler!=0 && offset!=0 {service=b.word(SERVICE_GLOBAL)?;}
 }Ok(())
}
pub fn scalar_delete<B:Storage+RemovalBackend+Boundaries>(b:&mut B,metadata:u32,flags:u32)->Result<u32,Error> {
 destroy(b,metadata)?;if flags&1!=0 {let route=b.deallocator()?;b.free(metadata,route)?;}Ok(metadata)
}
