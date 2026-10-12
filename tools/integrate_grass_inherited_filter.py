from pathlib import Path
r=Path('E:/OpenLeague')
p=r/'crates/client/src/grass_pass_state.rs';s=p.read_text(encoding='utf-8')
s=s.replace('if inherited_filters != RESET_D3D_FILTERS { return Err("unqualified inherited grass filtering"); }','''let [mag,min,mip]=inherited_filters;
    if !matches!(mag,1|2) || !matches!(min,1|2) || !matches!(mip,0..=2) { return Err("unqualified inherited grass filtering"); }
    let filter=|value| if value==2 {bevy::image::ImageFilterMode::Linear} else {bevy::image::ImageFilterMode::Nearest};''')
s=s.replace('mag_filter: bevy::image::ImageFilterMode::Nearest,\n        min_filter: bevy::image::ImageFilterMode::Nearest,\n        mipmap_filter: bevy::image::ImageFilterMode::Nearest,\n        lod_min_clamp: 0., lod_max_clamp: 0., // D3DTEXF_NONE: use base level only.', 'mag_filter: filter(mag),\n        min_filter: filter(min),\n        mipmap_filter: filter(mip),\n        lod_min_clamp: 0., lod_max_clamp: if mip==0 {0.} else {32.}, // NONE disables mip selection.')
s=s.replace('for filters in [[2,1,0],[1,2,0],[1,1,1],[3,3,2]]','for filters in [[0,1,0],[1,0,0],[1,1,3],[3,3,2]]')
needle='    #[test] fn sampler_matches_native_reset_and_quad_addressing() {'
assert needle in s
s=s.replace(needle,'''    #[test] fn inherited_filters_match_original_bind_paths_and_driver_translation() {
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
'''+needle)
p.write_text(s,encoding='utf-8')
print('Inherited point/linear filtering supported explicitly; unknown abstract3 rejected.')
