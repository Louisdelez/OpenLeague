// Native FogOfWar_VS.hls: clamp in vertex stage BEFORE perspective interpolation.
fn native_fow_vertex_height(world_y:f32,clear:vec4<f32>,below:vec4<f32>)->vec2<f32> {
 return vec2<f32>(clamp(world_y*clear.x+clear.y,0.0,1.0),clamp(world_y*below.z+below.w,0.0,1.0));
}
