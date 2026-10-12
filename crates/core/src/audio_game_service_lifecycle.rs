//! Native service72A3B0/72A530 and replay member59CC60/59CF40.
//! Configuration, allocator startup and virtual object calls are explicit runtime boundaries.
use crate::audio_announcer_owner_metadata::{self as metadata, Boundaries, Error};
use crate::audio_announcer_registry_init::Storage;
use crate::audio_announcer_registry_remove::Backend;
use crate::audio_announcer_owner_component_destructor::ControlBoundary;
use crate::audio_announcer_owner_control::ObjectBoundary;

pub const CALLBACK_VTABLE: u32 = 0x10afd08;
pub const CALLBACK_CLONE: u32 = 0x7340c0;
pub const CURVE_CONTROLS: u32 = 0x1224d84;

/// Returns actual configured values, including a provider's native fallback policy.
/// Float values are IEEE754 single-precision bits; a failed provider must return Err.
/// The constructor does not silently turn a provider error into a default value.
pub trait Settings {
    fn float_bits(&mut self, section: &str, key: &str, default: u32) -> Result<u32, &'static str>;
    fn bool_value(&mut self, section: &str, key: &str, default: u8) -> Result<u8, &'static str>;
    fn integer(&mut self, section: &str, key: &str, default: u32) -> Result<u32, &'static str>;
}
fn add(base: u32, offset: u32) -> Result<u32, Error> {
    base.checked_add(offset).ok_or(Error::AddressOverflow)
}
fn write<B: Storage>(b: &mut B, base: u32, offset: u32, value: u32) -> Result<(), Error> {
    Storage::write_word(b, add(base, offset)?, value)?;
    Ok(())
}
/// Actual7340C0: allocation precedes each fresh source read; null allocation returns0.
pub fn clone_callback<B: Storage + Boundaries>(b: &mut B, source: u32) -> Result<u32, Error> {
    let callback = b.allocate_callback_clone(16).map_err(Error::Boundary)?;
    if callback != 0 {
        write(b, callback, 0, CALLBACK_VTABLE)?;
        for offset in [4, 8, 12] {
            let value = b.word(add(source, offset)?)?;
            write(b, callback, offset, value)?;
        }
    }
    Ok(callback)
}
fn delete_callback<B: Storage + Backend>(b: &mut B, callback: u32) -> Result<(), Error> {
    if callback != 0 {
        let vtable = b.word(callback)?;
        let method = b.word(vtable)?;
        if method != metadata::HANDLER_DELETE { return Err(Error::UnknownCallback(method)); }
        metadata::scalar_delete_callback(b, callback, 1)?;
    }
    Ok(())
}
/// Borrows the callback slot. It is read after the six float setting queries.
/// Only the copied callback is owned by the replay member. Padding remains untouched.
pub fn construct_replay<B: Storage + Boundaries + Settings>(
    b: &mut B, object: u32, callback_slot: u32,
) -> Result<u32, Error> {
    for (offset, section, key, default) in [
        (0, "Replay", "FastForwardSpeed", 0x42c80000),
        (4, "Replay", "LagUpdateFreq", 0x3f800000),
        (8, "Replay", "MaxLiveTimeBehind", 0x3dcccccd),
        (12, "TournamentPause", "HeartbeatDelay", 0x3dcccccd),
        (16, "Replay", "SlowFastForwardSpeed", 0x40800000),
        (20, "Replay", "SpeedupSpeed", 0x3fa66666),
    ] {
        let value = b.float_bits(section, key, default).map_err(Error::Boundary)?;
        write(b, object, offset, value)?;
    }
    write(b, object, 0x18, 0)?;
    b.write_byte(add(object, 0x20)?, 0)?;
    let source = b.word(callback_slot)?;
    let cloned = if source == 0 { 0 } else {
        let vtable = b.word(source)?;
        let method = b.word(add(vtable, 4)?)?;
        if method != CALLBACK_CLONE { return Err(Error::UnknownCallback(method)); }
        clone_callback(b, source)?
    };
    write(b, object, 0x24, cloned)?;
    for offset in [0x28, 0x2c, 0x30, 0x38, 0x3c, 0x40, 0x44, 0x50, 0x54, 0x58] {
        write(b, object, offset, 0)?;
    }
    b.write_byte(add(object, 0x60)?, 0)?;
    for offset in [0x64, 0x68, 0x6c, 0x70, 0x74, 0x7c, 0x80, 0x84, 0x88, 0x8c, 0x90, 0x94, 0x98, 0x9c] {
        write(b, object, offset, 0)?;
    }
    let disable = b.bool_value("Replay", "DisableCatchup", 1).map_err(Error::Boundary)?;
    b.write_byte(add(object, 0xa0)?, disable)?;
    for (offset, value) in [
        (0xa4, 0), (0xa8, 0), (0xac, 0xbf800000), (0xb0, u32::MAX), (0xb4, u32::MAX),
        (0xb8, 0), (0xbc, 0), (0xc0, 0), (0xc5, 0), (0xc9, 0),
    ] { write(b, object, offset, value)?; }
    // The native word at+CD and byte at+CF preserve the adjacent byte+D0.
    for offset in [0xcd, 0xce, 0xcf] { b.write_byte(add(object, offset)?, 0)?; }
    let look_ahead = b.bool_value("Replay", "UseLookAhead", 1).map_err(Error::Boundary)?;
    b.write_byte(add(object, 0xd1)?, look_ahead)?;
    b.write_byte(add(object, 0xd2)?, 0)?;
    Ok(object)
}
/// Actual59CF40: shared owner, buffer, cloned callback, then stream object.
/// Virtual methods and the free route are re-read at their native call sites.
pub fn destroy_replay<B: Storage + Backend + ControlBoundary + ObjectBoundary>(
    b: &mut B, object: u32,
) -> Result<(), Error> {
    let control = b.word(add(object, 0x70)?)?;
    if control != 0 && b.decrement_reference(add(control, 4)?).map_err(Error::Boundary)? == 1 {
        let vtable = b.word(control)?;
        let callback = b.word(vtable)?;
        b.dispose(control, callback).map_err(Error::Boundary)?;
        if b.decrement_reference(add(control, 8)?).map_err(Error::Boundary)? == 1 {
            let vtable = b.word(control)?;
            let callback = b.word(add(vtable, 4)?)?;
            b.release_control(control, callback).map_err(Error::Boundary)?;
        }
    }
    let buffer = b.word(add(object, 0x50)?)?;
    if buffer != 0 {
        let route = b.deallocator()?;
        b.free(buffer, route)?;
        for offset in [0x50, 0x54, 0x58] { write(b, object, offset, 0)?; }
    }
    for offset in [0x24, 0x18] {
        let pointer = b.word(add(object, offset)?)?;
        if pointer != 0 {
            let vtable = b.word(pointer)?;
            let callback = b.word(vtable)?;
            b.scalar_delete_object(pointer, callback, 1).map_err(Error::Boundary)?;
            if offset == 0x18 { write(b, object, offset, 0)?; }
        }
    }
    Ok(())
}
/// Full normal-return72A3B0 composition. Caller supplies four scratch bytes and
/// the native stack's opaque registry byte; neither is assigned gameplay meaning.
pub fn construct<B: Storage + Boundaries + Settings + Backend>(
    b: &mut B, service: u32, callback_slot: u32, opaque_byte: u8,
) -> Result<u32, Error> {
    for (offset, value) in [(4, 0x10afe80), (8, 0x1093b5c), (0, 0x10afe8c), (4, 0x10affa4), (8, 0x10afe88), (12, 0), (16, 0), (20, 0)] {
        write(b, service, offset, value)?;
    }
    crate::audio_announcer_active_service::construct(b, service, opaque_byte)?;
    write(b, service, 0x5c, 0)?;
    let temporary = b.allocate(16)?;
    if temporary != 0 {
        for (offset, value) in [(0, CALLBACK_VTABLE), (4, service), (8, 0x72c780), (12, 0)] {
            write(b, temporary, offset, value)?;
        }
    }
    write(b, callback_slot, 0, temporary)?;
    construct_replay(b, add(service, 0x60)?, callback_slot)?;
    delete_callback(b, temporary)?;
    let disable = b.bool_value("Hacks", "DisableFM", 0).map_err(Error::Boundary)?;
    crate::audio_game_service_buffers::construct_history(b, add(service, 0x134)?, if disable == 0 { 0 } else { u32::MAX })?;
    crate::audio_game_service_buffers::construct_curve(b, add(service, 0x150)?, CURVE_CONTROLS)?;
    let ping = b.integer("Reconnect", "PingTimeForReconnectMessage", 5000).map_err(Error::Boundary)?;
    write(b, service, 0x17c, ping)?;
    write(b, service, 0x180, 15000)?;
    b.write_byte(add(service, 0x184)?, 0)?;
    Ok(service)
}
pub fn scalar_delete<B: Storage + Backend + ControlBoundary + ObjectBoundary>(
    b: &mut B, service: u32, flags: u32,
) -> Result<u32, Error> {
    for (offset, value) in [(0, 0x10afe8c), (4, 0x10affa4), (8, 0x10afe88)] {
        write(b, service, offset, value)?;
    }
    crate::audio_game_service_buffers::destroy_curve(b, add(service, 0x150)?)?;
    crate::audio_game_service_buffers::destroy_history(b, add(service, 0x134)?)?;
    destroy_replay(b, add(service, 0x60)?)?;
    crate::audio_announcer_service_teardown::destroy_members(b, service)?;
    write(b, service, 0, 0x10affac)?;
    if flags & 1 != 0 {
        let route = b.deallocator()?;
        b.free(service, route)?;
    }
    Ok(service)
}

#[cfg(test)]
#[path = "audio_game_service_lifecycle_tests.rs"]
mod tests;
