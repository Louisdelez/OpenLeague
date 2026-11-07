#import bevy_pbr::forward_io::VertexOutput
@group(#{MATERIAL_BIND_GROUP}) @binding(0) var<uniform> params: vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(1) var atlas: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(2) var atlas_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(3) var ramp: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(4) var ramp_sampler: sampler;
fn display_to_linear(c: vec3<f32>) -> vec3<f32> {
    return select(pow((c + vec3<f32>(0.055)) / 1.055, vec3<f32>(2.4)),
        c / 12.92, c <= vec3<f32>(0.04045));
}
@fragment fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let frame = clamp(floor(params.x), 0.0, 8.0);
    let cell = vec2<f32>(frame - floor(frame / 3.0) * 3.0, floor(frame / 3.0));
    // Local half-texel cell inset prevents filtering into a neighbouring frame.
    // Atlas row order, sampler, additive blend and colour conversion are explicit
    // reconstruction policies; no native mode0 or D3D9 equivalence is asserted.
    let local_uv = clamp(in.uv, vec2<f32>(0.5 / 128.0), vec2<f32>(127.5 / 128.0));
    let texel = textureSample(atlas, atlas_sampler, (local_uv + cell) / 3.0);
    let rgba = textureSample(ramp, ramp_sampler, clamp(params.yz, vec2<f32>(0.0), vec2<f32>(1.0)));
    return vec4<f32>(display_to_linear(texel.rgb * rgba.rgb), texel.a * rgba.a);
}
