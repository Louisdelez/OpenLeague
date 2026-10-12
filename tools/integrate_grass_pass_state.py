from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_pass_state.rs';assert not p.exists()
p.write_text('''//! Native grass pass prefix95C110..95C168 and clear980290/9C2510.
//! Later material/draw state and winding bridge remain separate producers.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Prefix { pub depth_test: bool, pub depth_write: bool, pub blend: bool, pub d3d_cull_mode: u32 }
pub fn prefix(selector: u32) -> Result<Prefix, &'static str> {
    match selector { 3 | 4 => Ok(Prefix {depth_test:true,depth_write:true,blend:false,d3d_cull_mode:3}), _ => Err("unqualified grass selector") }
}
pub const MASK_CLEAR_ARGB: u32 = 0xffffffff;
pub const MASK_CLEAR_FLAGS: u32 = 1;
pub fn mask_clear_rgba() -> [f64; 4] {
    let color = MASK_CLEAR_ARGB;
    [(color >> 16 & 255) as f64 / 255., (color >> 8 & 255) as f64 / 255., (color & 255) as f64 / 255., (color >> 24) as f64 / 255.]
}
#[cfg(test)] mod tests {
    use super::*;
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
    #[test] fn gpu_clear_matches_original_d3d_boundary_and_full_flags() {
        let p: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/grass_clear_contract.json")).unwrap();assert_eq!(p["passed"],true);
        assert_eq!(p["grass_mask_api_arguments"],serde_json::json!([0,0,MASK_CLEAR_FLAGS,MASK_CLEAR_ARGB,0x3f800000u32,0]));
        for c in p["cases"].as_array().unwrap() {
            for call in c["api_calls"].as_array().unwrap() {assert_eq!(call[3],c["flags"]);assert_eq!(call[4],c["argb_color"]);assert_eq!(call[5],0x3f800000u32);assert_eq!(call[6],0);}
        }
        assert_eq!(mask_clear_rgba(),[1.,1.,1.,1.]);
    }
}
''',encoding='utf-8')
main=r/'crates/client/src/main.rs';s=main.read_text(encoding='utf-8');assert 'mod grass_pass_state;' not in s;main.write_text('#[allow(dead_code)] // Native grass prefix; full material state/order and winding bridge pending.\nmod grass_pass_state;\n'+s,encoding='utf-8')
p=r/'crates/client/examples/grass_mask_gpu_probe.rs';s=p.read_text(encoding='utf-8');s='#[path="../src/grass_pass_state.rs"] mod grass_pass_state;\n'+s
s=s.replace('LoadOp::Clear(Color::WHITE)','LoadOp::Clear({let c=grass_pass_state::mask_clear_rgba();Color {r:c[0],g:c[1],b:c[2],a:c[3]}})')
s=s.replace('original driver target/clear/filter/buffers remain open.','original driver target format/filter/buffers and viewport producer remain open; clear color verified through native D3D API boundary.')
p.write_text(s,encoding='utf-8');print('Installed verified pass prefix/clear values; GPU probe now shares native clear helper.')
