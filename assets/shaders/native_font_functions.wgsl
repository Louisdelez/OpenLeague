// Literal RenderGlyph pixel arithmetic from original 4.20 HLSL.
// Vertex color swizzle, sampling, render state and text layout are caller contracts.
fn native_font_fill_outline(font:vec4<f32>,fill:vec4<f32>,color0:vec4<f32>,color1:vec4<f32>)->vec4<f32> {
    let alpha_fill=color0.a*font.r*fill.a;
    let alpha_outline=color1.a*font.b;
    let color_fill=color0.rgb*fill.rgb;
    return vec4<f32>(alpha_fill*color_fill+alpha_outline*color1.rgb,1.0-(alpha_fill+alpha_outline));
}
fn native_font_glow(font:vec4<f32>,color0:vec4<f32>)->vec4<f32> {
    return vec4<f32>(color0.rgb,color0.a*font.x);
}
