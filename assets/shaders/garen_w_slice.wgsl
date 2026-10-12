// Concrete inactive Slice material; Bevy's default vertex stage supplies current skinning.
#import bevy_pbr::forward_io::VertexOutput
@group(#{MATERIAL_BIND_GROUP}) @binding(0) var scroll_image: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(1) var scroll_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(2) var lookup_image: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(3) var lookup_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(4) var visibility_image: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(5) var visibility_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(6) var overlay_image: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(7) var overlay_sampler: sampler;
struct SliceUniform {
    uv_scale_offset: vec4<f32>,
    color_lookup: vec4<f32>,
    color_factor: vec4<f32>,
    slice_range: vec4<f32>,
    fog_scale_offset: vec4<f32>,
    control: vec4<u32>,
}
@group(#{MATERIAL_BIND_GROUP}) @binding(8) var<uniform> params: SliceUniform;

// Arithmetic port of original 4.20 MESH_PS_Slice.ps_2_0, base descriptor variant.
// Inputs are native sample/color values before framebuffer color-space handling.
// Sampling, palette/death variants and the mesh vertex stage are separate.
fn native_particle_slice(
    scroll: vec4<f32>,
    lookup: vec4<f32>,
    vertex: vec4<f32>,
    fog: vec4<f32>,
    range: vec2<f32>,
) -> vec4<f32> {
    let delta = scroll.r - lookup.a;
    let band = ((delta + range.x) * (range.x - delta)) * range.y;
    let alpha = clamp(scroll.a * band, 0.0, 1.0);
    let rgb = (lookup.rgb * vertex.rgb) * fog.a;
    return vec4<f32>(rgb, alpha);
}

// Explicit renderer boundary after the native arithmetic; never linearize Scroll.r.
fn display_to_linear(c: vec3<f32>) -> vec3<f32> {
    return select(pow((c + vec3<f32>(0.055)) / 1.055, vec3<f32>(2.4)),
                  c / 12.92, c <= vec3<f32>(0.04045));
}

@fragment fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    if params.control.x != 1u { discard; }
    let uv = in.uv * params.uv_scale_offset.xy + params.uv_scale_offset.zw;
    let scroll = textureSample(scroll_image, scroll_sampler, uv);
    let lookup = textureSample(lookup_image, lookup_sampler, params.color_lookup.xy);
    let fog_uv = in.world_position.xz * params.fog_scale_offset.xy + params.fog_scale_offset.zw;
    // fow_gpu output alpha is always 1; its red channel is the current visibility mask.
    // Same normal-alpha composition as projected_terrain/native_fow, not native s6 storage.
    let vis = textureSample(visibility_image, visibility_sampler, fog_uv).r;
    let overlay_alpha = textureSample(overlay_image, overlay_sampler, fog_uv).a;
    let fog_alpha = mix(overlay_alpha, 1.0, vis);
    let result = native_particle_slice(scroll, lookup, params.color_factor,
                                      vec4<f32>(0.0, 0.0, 0.0, fog_alpha), params.slice_range.xy);
    if params.control.y == 1u {
        return vec4<f32>(display_to_linear(result.rgb), result.a);
    }
    return result;
}
