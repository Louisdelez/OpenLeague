#import bevy_ui::ui_vertex_output::UiVertexOutput
#import "shaders/native_font_functions.wgsl"::{native_font_fill_outline,native_font_glow}
struct Parameters {uv:vec4<f32>,fill_uv:vec4<f32>,color0:vec4<f32>,color1:vec4<f32>};
@group(1) @binding(0) var<uniform> parameters:Parameters;
@group(1) @binding(1) var font:texture_2d<f32>;
@group(1) @binding(2) var font_sampler:sampler;
@group(1) @binding(3) var fill:texture_2d<f32>;
@group(1) @binding(4) var fill_sampler:sampler;
@fragment fn fragment(in:UiVertexOutput)->@location(0) vec4<f32> {
    let uv=mix(parameters.uv.xy,parameters.uv.zw,in.uv);
    let fill_uv=mix(parameters.fill_uv.xy,parameters.fill_uv.zw,in.uv);
    let font_texel=textureSample(font,font_sampler,uv);
#ifdef NATIVE_FONT_GLOW
    return native_font_glow(font_texel,parameters.color0);
#else
    return native_font_fill_outline(font_texel,textureSample(fill,fill_sampler,fill_uv),parameters.color0,parameters.color1);
#endif
}
