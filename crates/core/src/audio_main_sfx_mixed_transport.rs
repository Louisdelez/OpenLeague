//! Composition of actual native20-byte producer/owned queue with mixed receiver.
//! Manager/Values/Meters/Graph/Store are mandatory existing owner inputs.
//! No allocation, registration, empty replacement graph or PCM is supplied here.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,
 audio_rtpc_subscriber_release::Manager,audio_meter_lifecycle::Runtime as Meters,
 audio_bus_effects_changed::Graph,audio_bus_control_application::Store};
use std::collections::BTreeMap;
use crate::{audio_mixed_rtpc_notification as mixed,audio_bus_rtpc_delta as bus};
#[cfg(test)]use self::test_producer::{packet,enqueue};
fn word(raw:&[u8],offset:usize)->u32{u32::from_le_bytes(raw[offset..offset+4].try_into().unwrap())}

/// Selected B07289 consumer, invoked by actual Context::consume_with_dispatch.
/// FFFFFFFF normalizes to owner0/immediate[0,4]/mode1 as proven by native21.
/// Unsupported commands/object lookup leave the required owned state untouched.
pub fn dispatch_global(packet:&[u8],manager:&mut Manager,values:&mut BTreeMap<u32,Memory>,meters:&mut Meters,graph:&mut Graph,targets:&mut Store,context:bus::Context)->Result<mixed::Outcome,Error>{
 if packet.len()!=20||u16::from_le_bytes(packet[..2].try_into().unwrap())!=20||u16::from_le_bytes(packet[2..4].try_into().unwrap())!=2{return Err(Error::Backend("other common-audio command requires its native body"));}
 if word(packet,16)!=u32::MAX{return Err(Error::Backend("bound game-object RTPC lookup/release required"));}
 let key=word(packet,8);if key!=3273357900{return Err(Error::Backend("other RTPC key outside selected main-SFX profile"));}
 mixed::set_global(manager,values,meters,graph,targets,mixed::Request{key,new_bits:word(packet,12),owner:0,transition:[0,4],mode:1},context)
}
#[cfg(test)]#[path="audio_main_sfx_mixed_transport_tests.rs"]mod tests;
#[cfg(test)]#[path="audio_main_sfx_test_producer.rs"]mod test_producer;
#[cfg(test)]#[path="audio_main_sfx_test_request.rs"]mod test_request;
#[cfg(test)]#[path="audio_main_sfx_bus_owner_fixture.rs"]mod test_bus_owner;
