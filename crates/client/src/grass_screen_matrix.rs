//! Native980DA0screen-matrix producer. Caller supplies native API flag and dimensions.
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
