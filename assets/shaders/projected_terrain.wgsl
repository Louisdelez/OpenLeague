// Base native alpha reference 0, native projected material blend/depth specialization.
#import bevy_pbr::forward_io::VertexOutput
@group(#{MATERIAL_BIND_GROUP}) @binding(0) var image:texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(1) var image_sampler:sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(2) var<uniform> visibility_params:vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(3) var visibility_map:texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(4) var visibility_sampler:sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(5) var visibility_overlay:texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(6) var overlay_sampler:sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(7) var<uniform> visibility_edge:vec4<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(8) var<uniform> visibility_ready:u32;
@group(#{MATERIAL_BIND_GROUP}) @binding(9) var color_image:texture_2d<f32>;
@group(#{MATERIAL_BIND_GROUP}) @binding(10) var color_sampler:sampler;
@group(#{MATERIAL_BIND_GROUP}) @binding(11) var<uniform> color_lookup:vec4<f32>;
fn display_to_linear(c:vec3<f32>)->vec3<f32> {
 return select(pow((c+vec3<f32>(0.055))/1.055,vec3<f32>(2.4)),c/12.92,c<=vec3<f32>(0.04045));
}
@fragment fn fragment(in:VertexOutput)->@location(0) vec4<f32> {
 var texel=textureSample(image,image_sampler,in.uv);
 // Legacy Environment_UNLIT_DECAL_PS multiplies diffuse by the color LUT.
 if color_lookup.z==1.0 {texel*=textureSample(color_image,color_sampler,color_lookup.xy);}
 var density=1.0;
 if visibility_ready==1u {
  let uv=in.world_position.xz*visibility_params.xy+visibility_params.zw;
  let vis=textureSample(visibility_map,visibility_sampler,uv).r;
  let overlay=textureSample(visibility_overlay,overlay_sampler,uv);
  density=native_fow_factors(overlay,vis,0.0,0u,visibility_edge).a;
 }
#ifdef VERTEX_COLORS
 // Interpolated original-vertex height fade, matching Environment_UNLIT_DECAL_PS.
 texel.a*=max(in.color.a,0.0);
#endif
 // Native FOW factor alpha modulates RGB.
 // Palette, death and mip visualization variants remain separate unfinished contracts.
 return vec4<f32>(display_to_linear(texel.rgb*density),texel.a);
}

// Literal port of FogOfWar_PS.hls, normal overlay UV and visibility branches.
// Edge sharpener is #if0 in the original; tint uses original visibility, not height-adjusted t.
fn native_fow_factors(overlay:vec4<f32>,vis:f32,height:f32,mode:u32,edge:vec4<f32>)->vec4<f32> {
 var t=vis;
 if mode==1u {t=vis*height;}
 if mode==2u {t=mix(vis,1.0,height);}
 let color=mix(overlay.rgb,vec3<f32>(0.2,0.07,0.06),clamp(vis*edge.z,0.0,1.0));
 return vec4<f32>(color,mix(overlay.a,1.0,t));
}
