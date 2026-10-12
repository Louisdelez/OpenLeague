#import bevy_ui::ui_vertex_output::UiVertexOutput
struct Parameters {uv:vec4<f32>,vertex_color:vec4<f32>,tint:vec4<f32>,mode:vec4<f32>};
@group(1) @binding(0) var<uniform> parameters:Parameters;
@group(1) @binding(1) var atlas:texture_2d<f32>;
@group(1) @binding(2) var atlas_sampler:sampler;
@fragment fn fragment(in:UiVertexOutput)->@location(0) vec4<f32> {
 let uv=mix(parameters.uv.xy,parameters.uv.zw,in.uv);
 let col=textureSample(atlas,atlas_sampler,uv)*parameters.vertex_color;
 if parameters.mode.x==1.0 {return vec4<f32>(col.rgb*parameters.tint.rgb,1.0);}
 if parameters.mode.x==2.0 {return vec4<f32>(0.0);}
 if parameters.mode.x==3.0 {return vec4<f32>(col.rgb*parameters.tint.rgb*parameters.tint.a,col.a*parameters.tint.a);}
 return vec4<f32>(col.rgb*col.a*parameters.tint.rgb*parameters.tint.a,col.a*parameters.tint.a);
}
