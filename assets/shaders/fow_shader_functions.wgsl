// Direct arithmetic port of FogOfWar_VS.hls. World positions use native units.
fn native_fow_coordinates(world:vec3<f32>,coordinates:vec4<f32>,height:vec4<f32>)->vec3<f32> {
    let uv=world.xz*coordinates.xy+coordinates.zw;
    let fade=clamp(world.y*height.x+height.y,0.0,1.0);
    return vec3<f32>(uv,fade);
}
