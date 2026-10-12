#import bevy_ui::ui_vertex_output::UiVertexOutput
struct Parameters {params:vec4<f32>,color0:vec4<f32>,color1:vec4<f32>};
@group(1) @binding(0) var<uniform> parameters:Parameters;
@fragment fn fragment(in:UiVertexOutput)->@location(0) vec4<f32> {
 let direction=normalize(in.uv*2.0-vec2<f32>(1.0));
 let angle=3.141592653+atan2(direction.x,direction.y);
 if angle<parameters.params.x {return parameters.color1;}
 return vec4<f32>(0.5-(angle-parameters.params.x))+parameters.color0;
}
