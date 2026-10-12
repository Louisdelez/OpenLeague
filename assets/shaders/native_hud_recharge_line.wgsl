struct Parameters {projection:mat4x4<f32>,direction:vec4<f32>};
@group(2) @binding(0) var<uniform> parameters:Parameters;
struct Vertex { @location(0) position:vec3<f32>, @location(1) uv:vec2<f32>, @location(2) color:vec4<f32> };
struct Output { @builtin(position) position:vec4<f32>, @location(0) color:vec4<f32> };
@vertex fn vertex(in:Vertex)->Output {
 var out:Output;
 let position=in.position.xy+parameters.direction.xy*in.uv*parameters.direction.z;
 out.position=parameters.projection*vec4<f32>(position,0.0,1.0);
 out.color=in.color;
 return out;
}
@fragment fn fragment(in:Output)->@location(0) vec4<f32> {return vec4<f32>(in.color.rgb*in.color.a,in.color.a);}
