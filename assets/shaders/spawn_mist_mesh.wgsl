// Dedicated bounded original MESH_PS/MESH_VS SEPARATE_ALPHA_UV adaptation.
// color.a carries actual per-vertex FoW height fade, not the native source RGBA.
// Shadow, reflection, fresnel, soft/screen/mult, palettes/death/debug variants
// must remain outside the explicitly admitted numeric source/context subset.
#import bevy_pbr::forward_io::VertexOutput
@group(#{MATERIAL_BIND_GROUP}) @binding(0) var diffuse: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(1) var diffuse_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(2) var palette: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(3) var palette_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(4) var visibility_image: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(5) var visibility_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(6) var overlay_image: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(7) var overlay_sampler: sampler;
struct Params {uv:vec4<f32>,lookup:vec4<f32>,color:vec4<f32>,fog:vec4<f32>,control:vec4<u32>}
@group(#{MATERIAL_BIND_GROUP}) @binding(8) var<uniform> params:Params;
fn display_to_linear(value:vec3<f32>)->vec3<f32>{
    return select(pow((value+vec3<f32>(0.055))/1.055,vec3<f32>(2.4)),value/12.92,value<=vec3<f32>(0.04045));
}
@fragment fn fragment(input:VertexOutput)->@location(0) vec4<f32>{
    if params.control.x!=1u {discard;}
    let rgb_uv=input.uv*params.uv.xy+params.uv.zw;
    let alpha_uv=input.uv*params.uv.xy;
    var texel=textureSample(diffuse,diffuse_sampler,rgb_uv);
    texel.a=textureSample(diffuse,diffuse_sampler,alpha_uv).a;
    let table=textureSample(palette,palette_sampler,params.lookup.xy);
    var color=(params.color*texel)*table;
    let fow_uv=input.world_position.xz*params.fog.xy+params.fog.zw;
    let visible=textureSample(visibility_image,visibility_sampler,fow_uv).r;
    let overlay=textureSample(overlay_image,overlay_sampler,fow_uv).a;
    let fow=overlay+(1.0-overlay)*(visible*input.color.a);
    color=vec4<f32>(clamp(color.rgb*fow,vec3<f32>(0.0),vec3<f32>(1.0)),color.a);
    if params.control.y==1u {color=vec4<f32>(display_to_linear(color.rgb),color.a);}
    return color;
}
