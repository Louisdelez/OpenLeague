from pathlib import Path
r=Path('E:/OpenLeague')
source='''//! Native980DA0screen-matrix producer. Caller supplies native API flag and dimensions.
//! x87 reciprocals use f64 intermediates; qualified against recorded bit fixtures.
pub fn update(matrix: &mut [f32;16], size: [u32;2], api_flag: u32) {
    let inverse_width = (1. / size[0] as f64) as f32;
    let inverse_height = (1. / size[1] as f64) as f32;
    if api_flag > 2 { return; } // Original leaves existing matrix untouched.
    *matrix = [0.;16];
    matrix[0] = inverse_width * 2.; matrix[5] = inverse_height * -2.;
    matrix[12] = -1.; matrix[13] = 1.; matrix[15] = 1.;
    if api_flag == 0 { matrix[10] = 1.; }
    else {
        matrix[10] = 2.; matrix[14] = -1.;
        matrix[12] = -1. - inverse_height;
        matrix[13] = inverse_height + 1.;
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn screen_matrix_matches_original_including_unsigned_zero_and_unsupported_api() {
        let p: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/grass_screen_matrix_contract.json")).unwrap();
        assert_eq!(p["passed"], true);
        let cases=p["cases"].as_array().unwrap(); assert_eq!(cases.len(),196);
        for (i,c) in cases.iter().enumerate() {
            let mut actual = std::array::from_fn(|j|f32::from_bits(c["initial_bits"][j].as_u64().unwrap() as u32));
            update(&mut actual,[c["width"].as_u64().unwrap() as u32,c["height"].as_u64().unwrap() as u32],c["api_flag"].as_u64().unwrap() as u32);
            let expected: [u32;16]=std::array::from_fn(|j|c["matrix_bits"][j].as_u64().unwrap() as u32);
            assert_eq!(actual.map(f32::to_bits),expected,"case{i}");
        }
    }
}
'''
p=r/'crates/client/src/grass_screen_matrix.rs';assert not p.exists();p.write_text(source,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');assert 'mod grass_screen_matrix;' not in s;s=s.replace('mod grass_pass_state;','mod grass_pass_state;\n#[allow(dead_code)] // Native target/camera integration remains pending.\nmod grass_screen_matrix;');p.write_text(s,encoding='utf-8')
p=r/'crates/client/examples/grass_mask_gpu_probe.rs';s=p.read_text(encoding='utf-8');s='#[path="../src/grass_screen_matrix.rs"] mod grass_screen_matrix;\n'+s
old='''        // Explicit screen-matrix adapter maps pixels to Vulkan clip space.
        let mut values = vec![2./width as f32,0.,0.,0.,0.,-2./height as f32,0.,0.,0.,0.,1.,0.,-1.,1.,0.,1.];'''
new='''        // Native API0 matrix; API0 clip convention selected explicitly for this Vulkan probe.
        let mut matrix = [0.;16]; grass_screen_matrix::update(&mut matrix,[width,height],0);
        let mut values = matrix.to_vec();'''
assert old in s;s=s.replace(old,new)
s=s.replace('"native_reset_d3d_filters":grass_pass_state::RESET_D3D_FILTERS,','"native_reset_d3d_filters":grass_pass_state::RESET_D3D_FILTERS,"native_screen_matrix_api":0,')
s=s.replace('Later scene filter inheritance, screen matrix and vertex topology remain qualification adapters.','Native API0 screen-matrix arithmetic shared. Later scene filter inheritance, API selection/clip bridge and vertex topology remain qualification adapters.')
p.write_text(s,encoding='utf-8')
p=r/'assets/shaders/native_grass_mask.wgsl';s=p.read_text(encoding='utf-8').replace('SCREEN_MATRIX is supplied by the renderer; native producer remains to qualify.','SCREEN_MATRIX producer980DA0 is ported; live viewport/API binding remains pending.');p.write_text(s,encoding='utf-8')
print('Native screen matrix port and GPU shared producer installed.')
