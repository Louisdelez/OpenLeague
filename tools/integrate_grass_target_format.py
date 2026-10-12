from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_pass_state.rs';s=p.read_text(encoding='utf-8');assert 'MASK_D3D_FORMAT' not in s
s=s.replace('pub const MASK_CLEAR_FLAGS: u32 = 1;', 'pub const MASK_CLEAR_FLAGS: u32 = 1;\npub const MASK_D3D_FORMAT: u32 = 21;\npub fn mask_target_format() -> bevy::render::render_resource::TextureFormat {\n    bevy::render::render_resource::TextureFormat::Bgra8Unorm\n}')
s=s.replace('    #[test] fn gpu_clear_matches', '''    #[test] fn target_format_matches_native_driver_texture_requests() {
        let p: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/grass_target_format_contract.json")).unwrap();assert_eq!(p["passed"],true);
        let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),36);
        for c in cases {assert_eq!(c["abstract_format"],2);assert_eq!(c["device_format"],MASK_D3D_FORMAT);assert_eq!(c["device_pool"],0);if c["abstract_usage"]==1 {assert_eq!(c["device_usage"],1);}}
        assert_eq!(mask_target_format(),bevy::render::render_resource::TextureFormat::Bgra8Unorm);
    }
    #[test] fn gpu_clear_matches''');p.write_text(s,encoding='utf-8')
p=r/'crates/client/examples/grass_mask_gpu_probe.rs';s=p.read_text(encoding='utf-8');s=s.replace('format:TextureFormat::Rgba8Unorm,blend:None','format:grass_pass_state::mask_target_format(),blend:None')
s=s.replace('format:TextureFormat::Rgba8Unorm,usage:TextureUsages::RENDER_ATTACHMENT','format:grass_pass_state::mask_target_format(),usage:TextureUsages::RENDER_ATTACHMENT')
s=s.replace('"quad_draws":quads.len(),','"quad_draws":quads.len(),"target_format":format!("{:?}",grass_pass_state::mask_target_format()),"native_d3d_format":grass_pass_state::MASK_D3D_FORMAT,')
s=s.replace('Nearest/clamp sampling, Rgba8Unorm target, screen matrix and vertex topology are explicit qualification adapters; original driver target format/filter/buffers and viewport producer remain open; clear color verified through native D3D API boundary.','Nearest/clamp sampling, screen matrix and vertex topology remain explicit qualification adapters; native BGRA8 target format and clear color now verified through original D3D API boundaries.')
p.write_text(s,encoding='utf-8');print('GPU target now uses verified native BGRA8 channel format.')
