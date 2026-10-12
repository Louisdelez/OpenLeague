from pathlib import Path
import shutil,json
r=Path('E:/OpenLeague')
p=r/'crates/client/src/terrain_material.rs';s=p.read_text()
assert 'terrain_transform: Vec4' not in s
s=s.replace('    #[uniform(26)] pub visibility_ready:u32,','    #[uniform(26)] pub visibility_ready:u32,\n    #[uniform(27)] terrain_transform: Vec4,')
s=s.replace('            scales,\n            half_blend:', '            scales,\n            terrain_transform: map10_terrain_transform(),\n            half_blend:')
s+='''
// Original 86FB74 SSE c233 producer; preserve reciprocal/multiply order.
fn terrain_transform_from_bounds(span: [f32; 3], center: [f32; 3]) -> Option<Vec4> {
    if !span[0].is_finite() || !span[2].is_finite() || span[0] <= 0. || span[2] <= 0.
        || !center[0].is_finite() || !center[2].is_finite() { return None; }
    let x = 1. / span[0]; let z = 1. / span[2];
    let value = Vec4::new(x, z, -((center[0] - span[0] * 0.5) * x), -((center[2] - span[2] * 0.5) * z));
    value.is_finite().then_some(value)
}
fn map10_terrain_transform() -> Vec4 {
    let proof: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/terrain_transform_contract.json")).expect("qualified native terrain transform");
    let first = &proof["cases"][0];
    let read = |name: &str| std::array::from_fn(|i| f32::from_bits(first[name][i].as_u64().expect("native f32 bits") as u32));
    terrain_transform_from_bounds(read("span_bits"), read("center_bits")).expect("valid Map10 native bounds")
}
#[cfg(test)]
mod native_terrain_transform_tests {
    use super::*;
    #[test]
    fn production_c233_matches_native_upload_bits_and_rejects_degenerate_bounds() {
        let proof: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/terrain_transform_contract.json")).unwrap();
        assert!(proof["passed"].as_bool().unwrap());
        for case in proof["cases"].as_array().unwrap() {
            let read = |name: &str| std::array::from_fn(|i| f32::from_bits(case[name][i].as_u64().unwrap() as u32));
            let span: [f32;3] = read("span_bits");
            if span[0] <= 0. || span[2] <= 0. {
                assert!(terrain_transform_from_bounds(span,read("center_bits")).is_none());
            } else {
                let got = terrain_transform_from_bounds(span,read("center_bits")).unwrap().to_array().map(f32::to_bits);
                for i in 0..4 { assert_eq!(got[i],case["uploaded_bits"][i].as_u64().unwrap() as u32); }
            }
        }
        let map = map10_terrain_transform();
        assert_ne!(map.x.to_bits(),(1f32/15360.).to_bits());
        // SCB max maps to UV1; GLB mirror origin stays15360 independently of SCB extent.
        let extent = 15398.671875f32;
        assert_eq!(extent * map.x + map.z,1.);
        let world_z = (15360. - extent) / 20.;
        assert_eq!((15360. - world_z * 20.) * map.y + map.w,1.);
    }
}
'''
p.write_text(s,encoding='utf-8')
p=r/'assets/shaders/terrain_fow_vertex.wgsl';s=p.read_text();s=s.replace('struct NativeFowVertexOutput {','@group(#{MATERIAL_BIND_GROUP}) @binding(27) var<uniform> terrain_transform:vec4<f32>;\nstruct NativeFowVertexOutput {');s=s.replace('    @location(8) native_height_fades:vec2<f32>,','    @location(8) native_height_fades:vec2<f32>,\n    @location(9) native_terrain_uv:vec2<f32>,');s=s.replace('    return out;','    // Inverse of retained GLB root scale(.05,.05,-.05)/translation Z768.\n    let native_xz=vec2<f32>(out.world_position.x*20.0,15360.0-out.world_position.z*20.0);\n    out.native_terrain_uv=native_xz*terrain_transform.xy+terrain_transform.zw;\n    return out;');p.write_text(s,encoding='utf-8')
p=r/'assets/shaders/terrain_height_blend.wgsl';s=p.read_text();s=s.replace('@location(8) height_fades:vec2<f32>)','@location(8) height_fades:vec2<f32>,@location(9) terrain_uv:vec2<f32>)');s=s.replace('textureSample(height_map,height_sampler,in.uv_b)','textureSample(height_map,height_sampler,terrain_uv)').replace('textureSample(colormap,color_sampler,in.uv_b)','textureSample(colormap,color_sampler,terrain_uv)');p.write_text(s,encoding='utf-8')
for name in ['integrate_native_terrain_transform.py','probe_native_terrain_transform.py','probe_native_environment_macros.py']:
    shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Native c233 integrated into terrain vertex interpolant and height/colormap sampling; fog lighting UV remains separately unqualified.')
