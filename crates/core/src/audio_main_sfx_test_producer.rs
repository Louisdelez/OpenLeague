//! Selected native AEB240 command2/20-byte producer and B07289 global consumer.
//! Caller owns the live common queue, RTPC graph, pool and physical services.
//! This closes a command/storage route; it does not create a voice or mixer.
use crate::{audio_bus_bank::Error,audio_common_queue::{Context,RetryServices},
    audio_plugin_factory::Memory,audio_rtpc_subscriber_release::Manager,
    audio_rtpc_output_setter as setter,audio_meter_lifecycle::Runtime as MeterRuntime};
use std::collections::BTreeMap;
use crate::audio_main_sfx_mixed_transport::test_request::RtpcRequest;

fn word(raw:&[u8],offset:usize)->u32 {u32::from_le_bytes(raw[offset..offset+4].try_into().unwrap())}

/// The unused native stack word+4 is deliberately supplied, not described as a
/// canonical zero/default. The common queue publishes u16 length before copying.
pub fn packet(request:RtpcRequest,stack_word:[u8;4])->Result<[u8;20],Error> {
    if request.id!=3273357900 || request.owner!=u32::MAX || request.duration!=0 || request.curve!=4 {
        return Err(Error::Backend("request outside qualified main-SFX API profile"));
    }
    if !f32::from_bits(request.value_bits).is_finite(){return Err(Error::Backend("nonfinite main-SFX RTPC input"));}
    let mut out=[0_u8;20];out[2..4].copy_from_slice(&2_u16.to_le_bytes());
    out[4..8].copy_from_slice(&stack_word);out[8..12].copy_from_slice(&request.id.to_le_bytes());
    out[12..16].copy_from_slice(&request.value_bits.to_le_bytes());out[16..20].copy_from_slice(&request.owner.to_le_bytes());
    Ok(out)
}

pub fn enqueue(request:RtpcRequest,stack_word:[u8;4],queue:&mut Context,
    processed:&mut u32,services:&mut impl RetryServices)->Result<u32,Error> {
    let mut packet=packet(request,stack_word)?;
    queue.enqueue_with_wait(&mut packet,20,processed,services)
}
