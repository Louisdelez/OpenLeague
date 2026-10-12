#import bevy_core_pipeline::fullscreen_vertex_shader::FullscreenVertexOutput
@group(0) @binding(0) var scene: texture_2d<f32>;
@group(0) @binding(1) var scene_sampler: sampler;
struct Settings { state: vec4<f32>, };
@group(0) @binding(2) var<uniform> settings: Settings;
// Original Map10 gamma upload bytes; original point sampler, U/V clamp.
const TABLE = array<u32, 256>(
// BEGIN NATIVE TABLE
0u,0u,0u,0u,0u,1u,2u,2u,3u,4u,5u,6u,7u,8u,9u,10u,11u,12u,13u,14u,15u,16u,17u,18u,19u,20u,21u,23u,24u,25u,26u,27u,28u,29u,30u,31u,32u,33u,34u,36u,37u,38u,39u,40u,41u,42u,43u,44u,46u,47u,48u,49u,50u,51u,52u,54u,55u,56u,57u,58u,59u,61u,62u,63u,64u,65u,66u,68u,69u,70u,71u,72u,73u,75u,76u,77u,78u,79u,81u,82u,83u,84u,85u,87u,88u,89u,90u,91u,93u,94u,95u,96u,97u,99u,100u,101u,102u,104u,105u,106u,107u,108u,110u,111u,112u,113u,115u,116u,117u,118u,120u,121u,122u,123u,125u,126u,127u,128u,130u,131u,132u,133u,135u,136u,137u,138u,140u,141u,142u,143u,145u,146u,147u,148u,150u,151u,152u,154u,155u,156u,157u,159u,160u,161u,162u,164u,165u,166u,168u,169u,170u,171u,173u,174u,175u,177u,178u,179u,180u,182u,183u,184u,186u,187u,188u,190u,191u,192u,193u,195u,196u,197u,199u,200u,201u,203u,204u,205u,206u,208u,209u,210u,212u,213u,214u,216u,217u,218u,220u,221u,222u,224u,225u,226u,228u,229u,230u,232u,233u,234u,235u,237u,238u,239u,241u,242u,243u,245u,246u,247u,249u,250u,251u,253u,254u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,255u,
// END NATIVE TABLE
);
fn to_display(c: vec3<f32>) -> vec3<f32> {
    return select(1.055 * pow(max(c, vec3<f32>(0.0)), vec3<f32>(1.0 / 2.4)) - vec3<f32>(0.055), c * 12.92, c <= vec3<f32>(0.0031308));
}
fn to_linear(c: vec3<f32>) -> vec3<f32> {
    return select(pow((c + vec3<f32>(0.055)) / 1.055, vec3<f32>(2.4)), c / 12.92, c <= vec3<f32>(0.04045));
}
fn lookup(channel: f32) -> f32 {
    let index = min(255u, u32(floor(clamp(channel, 0.0, 1.0) * 256.0)));
    return f32(TABLE[index]) / 255.0;
}
@fragment fn fragment(in: FullscreenVertexOutput) -> @location(0) vec4<f32> {
    let source = textureSample(scene, scene_sampler, in.uv);
    if settings.state.x == 0.0 { return source; }
    // Bevy attachment is sRGB; native DX9 shader consumes display-channel values.
    let display = to_display(source.rgb);
    let mapped = vec3<f32>(lookup(display.r), lookup(display.g), lookup(display.b));
    return vec4<f32>(to_linear(mapped), 1.0);
}
