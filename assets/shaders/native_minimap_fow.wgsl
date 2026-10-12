// Original HUD/MinimapFoW.ps_2_0: no terrain density/height/edge substitution.
#import bevy_ui::ui_vertex_output::UiVertexOutput
@group(1) @binding(0) var fow_texture:texture_2d<f32>;
@group(1) @binding(1) var fow_sampler:sampler;
@fragment fn fragment(in:UiVertexOutput)->@location(0) vec4<f32> {
    let factor=textureSample(fow_texture,fow_sampler,in.uv).r;
    return vec4<f32>(0.0,0.0,0.0,(1.0-factor)*0.64);
}
