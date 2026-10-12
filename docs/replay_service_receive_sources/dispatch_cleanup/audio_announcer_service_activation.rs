//! Native72EC40 activation and72EEC0 event dispatch with owned callback snapshots.
use crate::audio_announcer_owner_metadata::{self as metadata,Error};
use crate::audio_announcer_metadata_callbacks::{self as callbacks,ConsumerBoundary};
use crate::audio_announcer_active_service as active;
use crate::audio_announcer_object_lookup as lookup;
use crate::audio_announcer_registry_init::Storage;
use crate::audio_announcer_registry_remove::Backend as RemovalBackend;
use crate::audio_announcer_pending_service::{self as pending,PendingBoundary};
fn add(a:u32,b:u32)->Result<u32,Error> {a.checked_add(b).ok_or(Error::AddressOverflow)}
fn invoke<B:Storage+ConsumerBoundary>(b:&mut B,handler:u32,packet:u32)->Result<u8,Error> {
 let table=b.word(handler)?;let target=b.word(add(table,8)?)?;if target!=0x5cce30 {return Err(Error::UnknownCallback(target));}callbacks::invoke(b,handler,packet)
}
fn delete<B:Storage+RemovalBackend>(b:&mut B,handler:u32)->Result<(),Error> {
 if handler!=0 {let table=b.word(handler)?;let target=b.word(table)?;if target!=metadata::HANDLER_DELETE {return Err(Error::UnknownCallback(target));}metadata::scalar_delete_callback(b,handler,1)?;}Ok(())
}
fn owner_insert<B:Storage+RemovalBackend>(b:&mut B,registry:u32,field:u32,id:u32,extra:u32,event:u16)->Result<u32,Error> {
 if let Some(node)=lookup::lookup_node_initialized(b,registry,field)? {return Ok(node);}
 let head=b.word(add(registry,4)?)?;let first=b.word(head)?;let previous=b.word(add(first,4)?)?;let node=b.allocate(24)?;if node==0 {return Err(Error::Boundary("native owner-node allocation failure"));}
 for (offset,value) in [(0,first),(4,previous),(8,field),(12,id),(16,extra)] {Storage::write_word(b,add(node,offset)?,value)?;}b.write_byte(add(node,20)?,event as u8)?;b.write_byte(add(node,21)?,(event>>8) as u8)?;
 let count=b.word(add(registry,8)?)?;if count>=0xaaaaaa9 {return Err(Error::Boundary("native owner registry count limit"));}Storage::write_word(b,add(registry,8)?,count+1)?;Storage::write_word(b,add(first,4)?,node)?;let previous=b.word(add(node,4)?)?;Storage::write_word(b,previous,node)?;
 let current=b.word(head)?;Ok(crate::audio_announcer_registry_insert::sort_existing_node(b,registry,current).map_err(|_|Error::Boundary("owner registry insertion failed"))?.node)
}
/// Scratch is caller-owned12-byte storage. Its final two padding bytes are explicit
/// opaque input, not invented semantics for the original uninitialized stack bytes.
pub fn activate<B:Storage+RemovalBackend+PendingBoundary+ConsumerBoundary>(b:&mut B,service:u32,scratch:u32)->Result<(),Error> {
 let vector=add(service,12)?;let begin=b.word(vector)?;let end=b.word(add(vector,4)?)?;let count=end.wrapping_sub(begin)>>2;
 for index in (0..count).rev() {
  let begin=b.word(vector)?;let entry=add(begin,index*4)?;let pair=b.word(entry)?;Storage::write_word(b,scratch,0)?;Storage::write_word(b,add(scratch,4)?,0)?;let descriptor=b.word(pair)?;
  if invoke(b,descriptor,scratch)?==0 {continue;}
  let field=b.word(add(pair,4)?)?;let id=b.word(scratch)?;let extra=b.word(add(scratch,4)?)?;let event=b.word(add(scratch,8)?)? as u16;let registry=add(vector,12)?;
  let node=crate::audio_announcer_descriptor_insert::find_or_insert(b,registry,id,extra,event).map_err(|_|Error::Boundary("descriptor registry insertion failed"))?;
  pending::append_value(b,add(node,20)?,field)?;
  let owner_registry=add(registry,32)?;let owner=owner_insert(b,owner_registry,field,id,0,event)?;
  // Native72ED93 publishes the complete third word, including opaque stack padding.
  for (offset,value) in [(12,b.word(scratch)?),(16,b.word(add(scratch,4)?)?),(20,b.word(add(scratch,8)?)?)] {Storage::write_word(b,add(owner,offset)?,value)?;}
  let begin=b.word(vector)?;let entry=add(begin,index*4)?;let end=b.word(add(vector,4)?)?;let mut source=add(entry,4)?;let mut destination=entry;
  while source!=end {let value=b.word(source)?;Storage::write_word(b,destination,value)?;source=source.wrapping_add(4);destination=destination.wrapping_add(4);}
  let end=b.word(add(vector,4)?)?;Storage::write_word(b,add(vector,4)?,end.wrapping_sub(4))?;let descriptor=b.word(pair)?;delete(b,descriptor)?;let route=b.deallocator()?;b.free(pair,route)?;
 }Ok(())
}
pub fn dispatch<B:Storage+RemovalBackend+PendingBoundary+ConsumerBoundary>(b:&mut B,service:u32,descriptor:u32,packet:u32)->Result<u8,Error> {
 let id=b.word(descriptor)?;let event=b.word(add(descriptor,8)?)? as u16;let Some(node)=active::descriptor_lookup(b,add(service,24)?,id,event)? else {return Ok(0);};
 let begin=b.word(add(node,20)?)?;let end=b.word(add(node,24)?)?;let requested=end.wrapping_sub(begin)>>2;let snapshot=if requested==0 {0} else {b.allocate_pointer_array(requested).map_err(Error::Boundary)?};
 if snapshot==0 {return Ok(0);}
 // The native success path owns this snapshot until all callbacks finish.
 // A host Boundary error is not native C++ unwinding: retire that ownership
 // explicitly, including failures while reloading or copying the source vector.
 let result=(|| {
  // Native6B5CB0 reloads source vector after allocation, before callback dispatch.
  let begin=b.word(add(node,20)?)?;let end=b.word(add(node,24)?)?;let count=end.wrapping_sub(begin)>>2;
  for i in 0..count {let value=b.word(add(begin,i*4)?)?;Storage::write_word(b,add(snapshot,i*4)?,value)?;}
  let mut result=0u8;for i in 0..count {let field=b.word(add(snapshot,i*4)?)?;let handler=b.word(field)?;result|=invoke(b,handler,packet)?;}
  Ok(result)
 })();
 // Re-read the current deallocator after the consumer: it may have changed.
 let cleanup=(|| {let route=b.deallocator()?;b.free(snapshot,route)?;Ok(())})();
 match (result,cleanup) {
  (Ok(value),Ok(()))=>Ok(value),
  (Err(error),Ok(()))|(Ok(_),Err(error))=>Err(error),
  (Err(primary),Err(cleanup))=>Err(Error::Cleanup {primary:Box::new(primary),cleanup:Box::new(cleanup)}),
 }
}
#[cfg(test)]
#[path="audio_announcer_service_activation_cleanup_tests.rs"]
mod cleanup_tests;
