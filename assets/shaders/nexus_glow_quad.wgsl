// Default original QUAD_VS/PS. Atlas coordinates are calculated before upload;
// UV1 is the original lookup channel. COLOR carries packed native ARGB->RGBA.
// Color/death/palette/multipass/soft/vertex-fog/debug variants are not admitted.
#import bevy_pbr::forward_io::VertexOutput
@group(#{MATERIAL_BIND_GROUP}) @binding(0) var image: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(1) var image_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(2) var color_image: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(3) var color_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(4) var visibility_image: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(5) var visibility_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(6) var overlay_image: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(7) var overlay_sampler: sampler;
struct Params { fog: vec4<f32>, control: vec4<u32> }
@group(#{MATERIAL_BIND_GROUP}) @binding(8) var<uniform> params: Params;
fn display_to_linear(c:vec3<f32>)->vec3<f32> {
    return select(pow((c+vec3<f32>(0.055))/1.055,vec3<f32>(2.4)),c/12.92,c<=vec3<f32>(0.04045));
}
@fragment fn fragment(in:VertexOutput)->@location(0) vec4<f32> {
    if params.control.x!=1u { discard; }
    let texel=textureSample(image,image_sampler,in.uv);
    let color=textureSample(color_image,color_sampler,in.uv_b);
    var result=(in.color*texel)*color;
    let fow_uv=in.world_position.xz*params.fog.xy+params.fog.zw;
    let visibility=textureSample(visibility_image,visibility_sampler,fow_uv).r;
    let overlay=textureSample(overlay_image,overlay_sampler,fow_uv).a;
    result=vec4<f32>(result.rgb*(overlay+(1.0-overlay)*visibility),result.a);
    if params.control.y==1u {result=vec4<f32>(display_to_linear(result.rgb),result.a);}
    return result;
}
