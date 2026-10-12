#import bevy_pbr::forward_io::VertexOutput
@group(#{MATERIAL_BIND_GROUP}) @binding(0) var<uniform> color: vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(1) var<uniform> uv_scroll: vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(2) var image: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(3) var image_sampler: sampler;
fn display_to_linear(c:vec3<f32>)->vec3<f32> {
 return select(pow((c+vec3<f32>(0.055))/1.055,vec3<f32>(2.4)),c/12.92,c<=vec3<f32>(0.04045));
}
@fragment fn fragment(in:VertexOutput)->@location(0) vec4<f32> {
 // Native QUAD_PS_FixedAlphaUV uses moving RGB and a separate fixed alpha sample.
 // No color lookup texture is configured for the base ready1 group: neutral white.
 let rgb_texel=textureSample(image,image_sampler,in.uv+uv_scroll.xy);
 let alpha_texel=textureSample(image,image_sampler,in.uv);
 return vec4<f32>(display_to_linear(rgb_texel.rgb*color.rgb),alpha_texel.a*color.a);
}
