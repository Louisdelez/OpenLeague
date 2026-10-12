//! Native72C610/72C620 and72D420/72D510 pending listener ownership.
use crate::audio_announcer_owner_metadata::{self as metadata,Error,Boundaries};
use crate::audio_announcer_registry_init::Storage;
use crate::audio_announcer_registry_remove::Backend as RemovalBackend;
fn add(a:u32,b:u32)->Result<u32,Error> {a.checked_add(b).ok_or(Error::AddressOverflow)}
pub trait PendingBoundary {
 fn allocate_engine(&mut self,bytes:u32)->Result<u32,&'static str>;
 fn allocate_pointer_array(&mut self,words:u32)->Result<u32,&'static str>;
 /// Actual72EE20 is the fallback when no pending pair matches the storage identity.
 fn remove_active_listener(&mut self,registry:u32,handler_storage:u32)->Result<(),&'static str>;
}
pub fn register_virtual<B:Storage+RemovalBackend+Boundaries+PendingBoundary>(b:&mut B,service:u32,callback:u32,field:u32,temporary:u32)->Result<(),Error> {
 if callback!=0x72c610 {return Err(Error::UnknownCallback(callback));}register(b,service,field,temporary)
}
pub fn unregister_virtual<B:Storage+RemovalBackend+PendingBoundary>(b:&mut B,service:u32,callback:u32,field:u32)->Result<(),Error> {
 if callback!=0x72c620 {return Err(Error::UnknownCallback(callback));}unregister(b,service,field)
}
fn clone<B:Storage+Boundaries>(b:&mut B,p:u32)->Result<u32,Error> {
 if p==0 {return Ok(0);}let vt=b.word(p)?;let target=b.word(add(vt,4)?)?;if target!=metadata::HANDLER_CLONE {return Err(Error::UnknownCallback(target));}metadata::clone_callback(b,p)
}
fn delete<B:Storage+RemovalBackend>(b:&mut B,p:u32)->Result<(),Error> {
 if p!=0 {let vt=b.word(p)?;let target=b.word(vt)?;if target!=metadata::HANDLER_DELETE {return Err(Error::UnknownCallback(target));}metadata::scalar_delete_callback(b,p,1)?;}Ok(())
}
/// Nonaliasing append used by72D420's stack-local pair pointer.
pub(crate) fn append_value<B:Storage+RemovalBackend+PendingBoundary>(b:&mut B,vector:u32,pair:u32)->Result<(),Error> {
 let end=b.word(add(vector,4)?)?;let capacity=b.word(add(vector,8)?)?;
 if end==capacity {
  let begin=b.word(vector)?;let length=end.wrapping_sub(begin)>>2;let old_capacity=capacity.wrapping_sub(begin)>>2;
  if length>=0x3fffffff {return Err(Error::Boundary("native pointer vector length error"));}
  let grown=if old_capacity>0x3fffffff-(old_capacity>>1) {0} else {old_capacity+(old_capacity>>1)};let words=grown.max(length+1);
  let new=b.allocate_pointer_array(words).map_err(Error::Boundary)?;
  // Original5C30E0 copies first, caches length, frees old bytes, publishes three fields.
  for i in 0..length {let value=b.word(add(begin,i*4)?)?;Storage::write_word(b,add(new,i*4)?,value)?;}
  let old=b.word(vector)?;let count=b.word(add(vector,4)?)?.wrapping_sub(old)>>2;
  if old!=0 {let route=b.deallocator()?;b.free(old,route)?;}
  Storage::write_word(b,vector,new)?;Storage::write_word(b,add(vector,8)?,new.wrapping_add(words*4))?;Storage::write_word(b,add(vector,4)?,new.wrapping_add(count*4))?;
 }
 let end=b.word(add(vector,4)?)?;if end!=0 {Storage::write_word(b,end,pair)?;}Storage::write_word(b,add(vector,4)?,end.wrapping_add(4))?;Ok(())
}
pub fn register<B:Storage+RemovalBackend+Boundaries+PendingBoundary>(b:&mut B,service:u32,handler_storage:u32,temporary:u32)->Result<(),Error> {
 let vector=add(service,12)?;let pair=b.allocate_engine(8).map_err(Error::Boundary)?;
 if pair!=0 {let intermediate=clone(b,temporary)?;let descriptor=clone(b,intermediate)?;Storage::write_word(b,pair,descriptor)?;Storage::write_word(b,add(pair,4)?,handler_storage)?;delete(b,intermediate)?;}
 append_value(b,vector,pair)
}
pub fn unregister<B:Storage+RemovalBackend+PendingBoundary>(b:&mut B,service:u32,handler_storage:u32)->Result<(),Error> {
 let vector=add(service,12)?;let mut cursor=b.word(vector)?;let end=b.word(add(vector,4)?)?;
 while cursor!=end {
  let pair=b.word(cursor)?;
  if b.word(add(pair,4)?)?==handler_storage {
   let mut source=cursor.wrapping_add(4);let mut destination=cursor;
   while source!=end {let value=b.word(source)?;Storage::write_word(b,destination,value)?;source=source.wrapping_add(4);destination=destination.wrapping_add(4);}
   let fresh_end=b.word(add(vector,4)?)?;Storage::write_word(b,add(vector,4)?,fresh_end.wrapping_sub(4))?;
   let descriptor=b.word(pair)?;delete(b,descriptor)?;let route=b.deallocator()?;b.free(pair,route)?;return Ok(());
  }
  cursor=cursor.wrapping_add(4);
 }
 b.remove_active_listener(add(vector,12)?,handler_storage).map_err(Error::Boundary)
}
