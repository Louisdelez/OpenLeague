//! Concrete native type2 transport with a PreparedRGBA producer token.
//! Camera, scaled XYZ and native primary modulation remain explicit inputs.
#[path="relic_pickup_complex_type2_quad.rs"] mod native;
pub use native::Packet;
pub fn packet(record:&openleague_core::native_complex_particle_storage::Record,camera:[f32;3],prepared_scale:[f32;3],
    prepared_rgba:crate::relic_pickup_complex_rgba::Prepared,channel_corners:bool)->Result<Packet,&'static str> {
    let world:[f32;16]=std::array::from_fn(|i|f32::from_bits(record.surface[16+i]));
    let center:[f32;3]=world[12..15].try_into().unwrap();let direction:[f32;3]=world[8..11].try_into().unwrap();
    native::packet(native::Input {camera,center,motion_point:std::array::from_fn(|a|center[a]-direction[a]),
        scales:prepared_scale,rgba:prepared_rgba.value(),frame:f32::from_bits(record.atlas[1]),
        uv:[f32::from_bits(record.uv[10]),f32::from_bits(record.uv[11])],lookup:record.field_64.map(f32::from_bits),channel_corners})
}
