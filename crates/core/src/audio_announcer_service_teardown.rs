//! Native72A600 service-member destruction after listener owners have been disposed.
use crate::audio_announcer_owner_metadata::Error;
use crate::audio_announcer_object_lookup as lookup;
use crate::audio_announcer_registry_init::Storage;
use crate::audio_announcer_registry_remove::{Backend,Deallocator};
fn add(a:u32,b:u32)->Result<u32,Error>{a.checked_add(b).ok_or(Error::AddressOverflow)}
fn free<B:Backend>(b:&mut B,p:u32)->Result<(),Error>{let route=b.deallocator()?;b.free(p,route)?;Ok(())}
fn destroy_compound<B:Storage+Backend>(b:&mut B,registry:u32)->Result<(),Error>{
 let buckets=b.word(add(registry,8)?)?;
 if buckets!=0 {free(b,buckets)?;for offset in [8,12,16]{Storage::write_word(b,add(registry,offset)?,0)?;}}
 let head=b.word(registry)?;let mut node=b.word(head)?;Storage::write_word(b,head,head)?;
 let fresh=b.word(registry)?;Storage::write_word(b,add(fresh,4)?,fresh)?;Storage::write_word(b,add(registry,4)?,0)?;
 if node!=b.word(registry)? {
  let mut route=b.deallocator()?;let mut seen=std::collections::BTreeSet::new();
  loop {
   if node==0 || !seen.insert(node){return Err(Error::Context(lookup::Error::InvalidChain));}
   let array=b.word(add(node,20)?)?;let next=b.word(node)?;
   if array!=0 {b.free(array,route)?;if matches!(route,Deallocator::Custom{..}){route=b.deallocator()?;}for offset in [20,24,28]{Storage::write_word(b,add(node,offset)?,0)?;}}
   b.free(node,route)?;if matches!(route,Deallocator::Custom{..}){route=b.deallocator()?;}
   node=next;if node==b.word(registry)?{break;}
  }
 }
 let head=b.word(registry)?;free(b,head)
}
/// The native destructor assumes owners were unregistered beforehand. It releases
/// vector storage, not any pending pair objects; callers must preserve that lifetime order.
/// Registry sentinel addresses become dangling native labels after successful destruction.
/// This storage must not be reused as an initialized service.
pub fn destroy_members<B:Storage+Backend>(b:&mut B,service:u32)->Result<(),Error>{
 crate::audio_announcer_registry_shutdown::destroy_table(b,add(service,56)?).map_err(|_|Error::Boundary("owner registry destruction failed"))?;
 destroy_compound(b,add(service,24)?)?;
 let pending=add(service,12)?;let array=b.word(pending)?;
 if array!=0 {free(b,array)?;for offset in [0,4,8]{Storage::write_word(b,add(pending,offset)?,0)?;}}
 Ok(())
}
