//! Native grass pass prefix95C110..95C168 and clear980290/9C2510.
//! Later material/draw state and winding bridge remain separate producers.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Prefix { pub depth_test: bool, pub depth_write: bool, pub blend: bool, pub d3d_cull_mode: u32 }
pub fn prefix(selector: u32) -> Result<Prefix, &'static str> {
    match selector { 3 | 4 => Ok(Prefix {depth_test:true,depth_write:true,blend:false,d3d_cull_mode:3}), _ => Err("unqualified grass selector") }
}
pub const MASK_CLEAR_ARGB: u32 = 0xffffffff;
pub const MASK_CLEAR_FLAGS: u32 = 1;
pub const MASK_D3D_FORMAT: u32 = 21;
pub fn mask_target_format() -> bevy::render::render_resource::TextureFormat {
    bevy::render::render_resource::TextureFormat::Bgra8Unorm
}
pub fn mask_clear_rgba() -> [f64; 4] {
    let color = MASK_CLEAR_ARGB;
    [(color >> 16 & 255) as f64 / 255., (color >> 8 & 255) as f64 / 255., (color & 255) as f64 / 255., (color >> 24) as f64 / 255.]
}
/// The quad changes U/V addressing, but inherits filtering. Reject unqualified states.
pub const RESET_D3D_FILTERS: [u32; 3] = [1, 1, 0]; // MAG, MIN, MIP
pub fn mask_sampler(inherited_filters: [u32; 3]) -> Result<bevy::image::ImageSamplerDescriptor, &'static str> {
    let [mag,min,mip]=inherited_filters;
    if !matches!(mag,1|2) || !matches!(min,1|2) || !matches!(mip,0..=2) { return Err("unqualified inherited grass filtering"); }
    let filter=|value| if value==2 {bevy::image::ImageFilterMode::Linear} else {bevy::image::ImageFilterMode::Nearest};
    Ok(bevy::image::ImageSamplerDescriptor {
        address_mode_u: bevy::image::ImageAddressMode::ClampToEdge,
        address_mode_v: bevy::image::ImageAddressMode::ClampToEdge,
        mag_filter: filter(mag),
        min_filter: filter(min),
        mipmap_filter: filter(mip),
        lod_min_clamp: 0., lod_max_clamp: if mip==0 {0.} else {32.}, // NONE disables mip selection.
        ..Default::default()
    })
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn inherited_filters_match_original_bind_paths_and_driver_translation() {
        let bindings:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_bind_filter_contract.json")).unwrap();assert_eq!(bindings["passed"],true);assert_eq!(bindings["cases"].as_array().unwrap().len(),1728);
        for c in bindings["cases"].as_array().unwrap() {
            assert_eq!(c["inherited_filter_cache"],c["final_filter_cache"]);
            let filters:[u32;3]=std::array::from_fn(|i|c["final_filter_cache"][i].as_u64().unwrap() as u32);let config=mask_sampler(filters).unwrap();
            assert_eq!(config.mag_filter,if filters[0]==2 {bevy::image::ImageFilterMode::Linear} else {bevy::image::ImageFilterMode::Nearest});
            assert_eq!(config.min_filter,if filters[1]==2 {bevy::image::ImageFilterMode::Linear} else {bevy::image::ImageFilterMode::Nearest});
            assert_eq!(config.lod_max_clamp,if filters[2]==0 {0.} else {32.});
        }
        let translation:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_filter_translation_contract.json")).unwrap();assert_eq!(translation["passed"],true);
        for c in translation["cases"].as_array().unwrap() {
            let value=c["abstract_value"].as_u64().unwrap();let actual=c["device_calls"][0][2].as_u64().unwrap();
            assert_eq!(actual,if value==3 {4} else {value}); // Do not assume abstract3 means D3D anisotropic3.
        }
    }
    #[test] fn sampler_matches_native_reset_and_quad_addressing() {
        let p: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/sampler_defaults_contract.json")).unwrap();
        assert_eq!(p["passed"], true);
        for case in p["cases"].as_array().unwrap() {
            let calls = case["calls"].as_array().unwrap(); assert_eq!(calls.len(), 128);
            for stage in 0..16 {
                let filters = [calls[stage*8+4][2].as_u64().unwrap() as u32, calls[stage*8+5][2].as_u64().unwrap() as u32, calls[stage*8+6][2].as_u64().unwrap() as u32];
                assert_eq!(filters, RESET_D3D_FILTERS);
                let config = mask_sampler(filters).unwrap(); let sampler = config.as_wgpu();
                assert_eq!(format!("{:?}", sampler.mag_filter), "Nearest");
                assert_eq!(format!("{:?}", sampler.min_filter), "Nearest");
                assert_eq!(format!("{:?}", sampler.address_mode_u), "ClampToEdge");
                assert_eq!(format!("{:?}", sampler.address_mode_v), "ClampToEdge");
                assert_eq!(sampler.lod_max_clamp, 0.);
            }
        }
        for filters in [[0,1,0],[1,0,0],[1,1,3],[3,3,2]] { assert!(mask_sampler(filters).is_err()); }
    }

    #[test] fn prefix_matches_native_state_bank_and_cached_cull_requests() {
        let p: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/grass_culling_contract.json")).unwrap(); assert_eq!(p["passed"], true);
        let cases = p["pass_cases"].as_array().unwrap(); assert_eq!(cases.len(), 128);
        for c in cases {
            let actual = prefix(c["selector"].as_u64().unwrap() as u32).unwrap();
            let main = c["main_state"].as_u64().unwrap() as u32; let secondary = c["secondary_state"].as_u64().unwrap() as u32;
            assert_eq!(actual.depth_test, main & 0x1000000 != 0);
            assert_eq!(actual.depth_write, secondary & 0x10000000 != 0);
            assert_eq!(actual.blend, main & 0x8000000 != 0);
            assert!(main & 0x10000000 != 0);
            for call in c["device_calls"].as_array().unwrap() {if call[0] == 22 {assert_eq!(call[1],actual.d3d_cull_mode);}}
        }
        for selector in [0,1,2,5,7,15] {assert!(prefix(selector).is_err());}
    }
    #[test] fn target_format_matches_native_driver_texture_requests() {
        let p: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/grass_target_format_contract.json")).unwrap();assert_eq!(p["passed"],true);
        let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),36);
        for c in cases {assert_eq!(c["abstract_format"],2);assert_eq!(c["device_format"],MASK_D3D_FORMAT);assert_eq!(c["device_pool"],0);if c["abstract_usage"]==1 {assert_eq!(c["device_usage"],1);}}
        assert_eq!(mask_target_format(),bevy::render::render_resource::TextureFormat::Bgra8Unorm);
    }
    #[test] fn gpu_clear_matches_original_d3d_boundary_and_full_flags() {
        let p: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/grass_clear_contract.json")).unwrap();assert_eq!(p["passed"],true);
        assert_eq!(p["grass_mask_api_arguments"],serde_json::json!([0,0,MASK_CLEAR_FLAGS,MASK_CLEAR_ARGB,0x3f800000u32,0]));
        for c in p["cases"].as_array().unwrap() {
            for call in c["api_calls"].as_array().unwrap() {assert_eq!(call[3],c["flags"]);assert_eq!(call[4],c["argb_color"]);assert_eq!(call[5],0x3f800000u32);assert_eq!(call[6],0);}
        }
        assert_eq!(mask_clear_rgba(),[1.,1.,1.,1.]);
    }
}
