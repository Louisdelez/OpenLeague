from pathlib import Path
r=Path('E:/OpenLeague')
p=r/'crates/client/src/grass_pass_state.rs'
s=p.read_text(encoding='utf-8');needle='#[cfg(test)] mod tests {'
addition='''/// The quad changes U/V addressing, but inherits filtering. Reject unqualified states.
pub const RESET_D3D_FILTERS: [u32; 3] = [1, 1, 0]; // MAG, MIN, MIP
pub fn mask_sampler(inherited_filters: [u32; 3]) -> Result<bevy::image::ImageSamplerDescriptor, &'static str> {
    if inherited_filters != RESET_D3D_FILTERS { return Err("unqualified inherited grass filtering"); }
    Ok(bevy::image::ImageSamplerDescriptor {
        address_mode_u: bevy::image::ImageAddressMode::ClampToEdge,
        address_mode_v: bevy::image::ImageAddressMode::ClampToEdge,
        mag_filter: bevy::image::ImageFilterMode::Nearest,
        min_filter: bevy::image::ImageFilterMode::Nearest,
        mipmap_filter: bevy::image::ImageFilterMode::Nearest,
        lod_min_clamp: 0., lod_max_clamp: 0., // D3DTEXF_NONE: use base level only.
        ..Default::default()
    })
}
'''
assert 'pub fn mask_sampler' not in s
s=s.replace(needle,addition+needle)
s=s.replace('    use super::*;','''    use super::*;
    #[test] fn sampler_matches_native_reset_and_quad_addressing() {
        let p: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/sampler_defaults_contract.json")).unwrap();
        assert_eq!(p["passed"], true);
        for case in p["cases"].as_array().unwrap() {
            let calls = case["calls"].as_array().unwrap(); assert_eq!(calls.len(), 128);
            for stage in 0..16 {
                let filters = [calls[stage*8+4][2].as_u64().unwrap() as u32, calls[stage*8+5][2].as_u64().unwrap() as u32, calls[stage*8+6][2].as_u64().unwrap() as u32];
                assert_eq!(filters, RESET_D3D_FILTERS);
                let sampler = mask_sampler(filters).unwrap().as_wgpu();
                assert_eq!(format!("{:?}", sampler.mag_filter), "Nearest");
                assert_eq!(format!("{:?}", sampler.min_filter), "Nearest");
                assert_eq!(format!("{:?}", sampler.address_mode_u), "ClampToEdge");
                assert_eq!(format!("{:?}", sampler.address_mode_v), "ClampToEdge");
                assert_eq!(sampler.lod_max_clamp, 0.);
            }
        }
        for filters in [[2,1,0],[1,2,0],[1,1,1],[3,3,2]] { assert!(mask_sampler(filters).is_err()); }
    }
''')
p.write_text(s,encoding='utf-8')
p=r/'crates/client/examples/grass_mask_gpu_probe.rs';s=p.read_text(encoding='utf-8')
old='''    // Explicit qualification adapter: nearest filtering and clamp-to-edge, not native sampler acceptance.
    let sampler = device.create_sampler(&SamplerDescriptor {address_mode_u:AddressMode::ClampToEdge,address_mode_v:AddressMode::ClampToEdge,mag_filter:FilterMode::Nearest,min_filter:FilterMode::Nearest,..Default::default()});'''
new='''    // Native reset filtering + quad U/V clamp; later scene inheritance remains unqualified.
    let sampler_config = grass_pass_state::mask_sampler(grass_pass_state::RESET_D3D_FILTERS).unwrap();
    let sampler = device.create_sampler(&sampler_config.as_wgpu());'''
assert old in s;s=s.replace(old,new)
s=s.replace('"native_d3d_format":grass_pass_state::MASK_D3D_FORMAT,','"native_d3d_format":grass_pass_state::MASK_D3D_FORMAT,"native_reset_d3d_filters":grass_pass_state::RESET_D3D_FILTERS,')
s=s.replace('Nearest/clamp sampling, screen matrix and vertex topology remain explicit qualification adapters; native BGRA8 target format and clear color now verified through original D3D API boundaries.','Reset point/no-mip filters, quad clamp addressing, BGRA8 target and clear color have native API evidence. Later scene filter inheritance, screen matrix and vertex topology remain qualification adapters.')
p.write_text(s,encoding='utf-8')
print('Shared native sampler helper installed; inherited non-reset filters explicitly rejected.')
