#import bevy_pbr::forward_io::VertexOutput
@group(#{MATERIAL_BIND_GROUP}) @binding(0) var<uniform> color: vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(1) var<uniform> uv_scroll: vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(2) var image: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(3) var image_sampler: sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(4) var<uniform> atlas: vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(5) var<uniform> lookup: vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(6) var color_image: texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(7) var color_sampler: sampler;
fn display_to_linear(c:vec3<f32>)->vec3<f32> {
 return select(pow((c+vec3<f32>(0.055))/1.055,vec3<f32>(2.4)),c/12.92,c<=vec3<f32>(0.04045));
}
@fragment fn fragment(in:VertexOutput)->@location(0) vec4<f32> {
 // Native common.hls CalculateTexDivUV, then QUAD_PS texture * color * lookup.
 let grid=max(atlas.xy,vec2<f32>(1.0));let frame=floor(atlas.z);
 let cell=vec2<f32>(frame-floor(frame/grid.x)*grid.x,floor(frame/grid.x));
 let uv=(in.uv+cell)/grid;
 let moving=textureSample(image,image_sampler,uv+uv_scroll.xy);
 let fixed=textureSample(image,image_sampler,uv);
 var ramp=vec4<f32>(1.0);
 if lookup.z>0.5 {ramp=textureSample(color_image,color_sampler,lookup.xy);}
 let alpha=select(moving.a,fixed.a,atlas.w>0.5)*color.a*ramp.a;
 var rgb=moving.rgb*color.rgb*ramp.rgb;
 var out_alpha=alpha;
 if lookup.w<0.5 {
  // Mode0 ADD: premultiply vertex color alpha; texture alpha does not attenuate RGB.
  // Our SrcAlpha/One color binding is equivalent with output alpha1.
  rgb*=color.a;out_alpha=1.0;
 }
 return vec4<f32>(display_to_linear(rgb),out_alpha);
}
