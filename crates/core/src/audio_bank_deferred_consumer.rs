//! B06C60 type24 bank release via AF4290/B0F7A0 empty voice-owner scans and AFBFD0.
use crate::{audio_bus_bank::Error,audio_bank_memory_reader::{Manager,Services},audio_common_queue::{Context,RetryServices}};
/// Owned references used by the original pre-release voice-owner scans.
#[derive(Default)]pub struct VoiceOwners{pub pending:Vec<u32>,pub active:Vec<u32>,pub secondary:Vec<u32>}
impl VoiceOwners{
    fn ensure_empty(&self)->Result<(),Error>{if self.pending.is_empty()&&self.active.is_empty()&&self.secondary.is_empty(){Ok(())}else{Err(Error::Backend("bank unload nonempty voice owner scan not qualified"))}}
}
pub fn consume<S:Services+RetryServices>(common:&mut Context,manager:&mut Manager,owners:&VoiceOwners,processed:&mut u32,backend:&mut S)->Result<u32,Error>{
    common.consume_with_dispatch(processed,backend,|packet,s|{
        if u16::from_le_bytes(packet[2..4].try_into().unwrap())!=24{return Err(Error::Backend("common command body not qualified"));}
        if packet.len()!=12{return Err(Error::Truncated);}owners.ensure_empty()?;
        let reference=u32::from_le_bytes(packet[8..12].try_into().unwrap());manager.destroy_empty_holder(reference,false,s)?;Ok(())
    })
}

/// Concrete type24 consumer with owned primary/secondary plugin contexts.
/// Pending action traversal remains explicit until its native lifetime is qualified.
pub fn consume_with_voice_effects<S:crate::audio_plugin_context::Services+RetryServices>(common:&mut Context,manager:&mut Manager,pending:&[u32],owners:&mut crate::audio_bank_voice_effects::Owners,media:&mut crate::audio_bank_media_lookup::MediaRegistry,plugins:&mut crate::audio_meter_lifecycle::Runtime,pools:[u32;3],processed:&mut u32,backend:&mut S)->Result<u32,Error>{
 common.consume_with_dispatch(processed,backend,|packet,s|{
  if u16::from_le_bytes(packet[2..4].try_into().unwrap())!=24{return Err(Error::Backend("common command body not qualified"));}
  if packet.len()!=12{return Err(Error::Truncated);}if !pending.is_empty(){return Err(Error::Backend("bank unload pending action traversal not qualified"));}
  let reference=u32::from_le_bytes(packet[8..12].try_into().unwrap());owners.release_bank(reference,manager,media,plugins,0x121023c,pools[0],pools[1],pools[2],s)?;manager.destroy_empty_holder(reference,false,s)?;Ok(())
 })
}
