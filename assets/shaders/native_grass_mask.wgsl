// Port of Renderer/VS_SCREENVERTEX_SCALE_AND_BIAS and FILTERS/PS_COPY_FILTER.
// SCREEN_MATRIX producer980DA0 is ported; live viewport/API binding remains pending.
struct Parameters { screen_matrix: mat4x4<f32>, destination: vec4<f32>, source_uv: vec4<f32>, color: vec4<f32> }
@group(0) @binding(0) var image: texture_2d<f32>;
@group(0) @binding(1) var image_sampler: sampler;
@group(0) @binding(2) var<uniform> parameters: Parameters;
struct VertexOutput { @builtin(position) position: vec4<f32>, @location(0) uv: vec2<f32> }
struct VertexInput { @location(0) position: vec3<f32>, @location(1) color: vec4<f32>, @location(2) uv: vec2<f32> }
@vertex fn vertex(input: VertexInput) -> VertexOutput {
    let position = input.position.xy * parameters.destination.zw + parameters.destination.xy;
    var result: VertexOutput;
    result.position = parameters.screen_matrix * vec4<f32>(position, input.position.z, 1.);
    result.uv = input.uv * parameters.source_uv.zw + parameters.source_uv.xy;
    return result;
}
@fragment fn fragment(input: VertexOutput) -> @location(0) vec4<f32> {
    return textureSample(image, image_sampler, input.uv);
}
