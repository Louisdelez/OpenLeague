// Source-derived default MESH_PS subset, bounded by Inputs::validate.
// POSITION/UV are exact SCB corners transformed to D. COLOR.a is only a transport
// varying for per-vertex native c250 height fade, never the native corner RGB.
#import bevy_pbr::forward_io::VertexOutput
@group(#{MATERIAL_BIND_GROUP}) @binding(0) var image: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(1) var image_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(2) var lookup_image: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(3) var lookup_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(4) var visibility_image: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(5) var visibility_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(6) var overlay_image: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(7) var overlay_sampler: sampler;
struct Params { uv: vec4<f32>, lookup: vec4<f32>, color: vec4<f32>, fog: vec4<f32>, control: vec4<u32> }
@group(#{MATERIAL_BIND_GROUP}) @binding(8) var<uniform> params: Params;

fn display_to_linear(c: vec3<f32>) -> vec3<f32> {
    return select(pow((c+vec3<f32>(0.055))/1.055, vec3<f32>(2.4)), c/12.92, c<=vec3<f32>(0.04045));
}
@fragment fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    if params.control.x != 1u { discard; }
    let uv = in.uv * params.uv.xy + params.uv.zw;
    let texel = textureSample(image, image_sampler, uv);
    let table = textureSample(lookup_image, lookup_sampler, params.lookup.xy);
    var result = (params.color * texel) * table;
    let fow_uv = in.world_position.xz * params.fog.xy + params.fog.zw;
    let visibility = textureSample(visibility_image, visibility_sampler, fow_uv).r;
    let overlay = textureSample(overlay_image, overlay_sampler, fow_uv).a;
    let fog_alpha = overlay + (1.0-overlay) * (visibility * in.color.a);
    result = vec4<f32>(clamp(result.rgb * fog_alpha, vec3<f32>(0.0), vec3<f32>(1.0)), result.a);
    if params.control.y == 1u { result = vec4<f32>(display_to_linear(result.rgb), result.a); }
    return result;
}
