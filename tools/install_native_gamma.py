from pathlib import Path
import json,shutil,datetime
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
contract=json.loads((r/'data/4.20/native_map10_gamma_contract.json').read_text())
sampler=json.loads((r/'data/4.20/native_gamma_sampler_contract.json').read_text())
assert contract['passed'] and sampler['filter']=='point' and sampler['address_u']=='clamp'
shader='''#import bevy_core_pipeline::fullscreen_vertex_shader::FullscreenVertexOutput
@group(0) @binding(0) var scene: texture_2d<f32>;
@group(0) @binding(1) var scene_sampler: sampler;
struct Settings { state: vec4<f32>, };
@group(0) @binding(2) var<uniform> settings: Settings;
// Original Map10 gamma upload bytes; original point sampler, U/V clamp.
const TABLE = array<u32, 256>(
// BEGIN NATIVE TABLE
'''+','.join(str(x)+'u' for x in contract['lut_u8'])+''',
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
'''
archive=r/'docs/plan_history'/('native-gamma-integration-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');shutil.copy2(p,archive/'main.rs')
assert 'mod native_gamma;' not in s
s='mod native_gamma;\n'+s
needle='.add_plugins(fow_gpu::Plugin)';assert s.count(needle)==1
s=s.replace(needle,needle+'\n        .add_plugins(bevy::core_pipeline::fullscreen_material::FullscreenMaterialPlugin::<native_gamma::Map10Gamma>::default())')
needle='        Tonemapping::None,\n';assert s.count(needle)==1
s=s.replace(needle,needle+'        native_gamma::Map10Gamma::native_map10(),\n')
p.write_text(s,encoding='utf-8')
shutil.copy2(stage/'native_gamma.rs',r/'crates/client/src/native_gamma.rs')
(r/'assets/shaders/native_map10_gamma.wgsl').write_text(shader,encoding='utf-8')
for name in ['qualify_native_gamma_sampler.py','inspect_gamma_sampler.py','install_native_gamma.py']:shutil.copy2(stage/name,r/'tools'/name)
print(json.dumps(dict(installed=True,native_table_entries=256,shader='assets/shaders/native_map10_gamma.wgsl',archive=str(archive))))
