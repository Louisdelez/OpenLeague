//! Native 4.20 Rect property arithmetic (9A2180), after the formatted scanner.
//! Scanner grammar, widget layout and drawing are separate contracts.
pub fn apply(scanned: &[f32], assignment_count: i32, origin: [f32; 2], output: &mut [f32; 4]) -> u32 {
    if assignment_count != 4 && assignment_count != 6 { return 0; }
    assert!(scanned.len() >= assignment_count as usize);
    let mut coordinates = [scanned[0], scanned[1], scanned[2], scanned[3]];
    if assignment_count == 6 {
        let inverse_width = 1.0 / scanned[4];
        let inverse_height = 1.0 / scanned[5];
        coordinates = [inverse_width * coordinates[0], inverse_height * coordinates[1], inverse_width * coordinates[2], inverse_height * coordinates[3]];
    }
    *output = [origin[0] + coordinates[0], origin[1] + coordinates[1], origin[0] + coordinates[2], origin[1] + coordinates[3]];
    16
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn matches_original_rect_arithmetic_and_failure_branches() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_rect_math_contract.json")).unwrap();
        assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],144);
        let floats=|v:&serde_json::Value|v.as_array().unwrap().iter().map(|v|f32::from_bits(v.as_u64().unwrap() as u32)).collect::<Vec<_>>();
        for c in proof["cases"].as_array().unwrap() {
            let mut scanned=floats(&c["coordinates_bits"]);scanned.extend(floats(&c["dimensions_bits"]));let origin=floats(&c["origin_bits"]);
            let mut output=[f32::from_bits(0xa5a5a5a5);4];let result=apply(&scanned,c["scan_count"].as_i64().unwrap() as i32,[origin[0],origin[1]],&mut output);
            assert_eq!(result,c["result"].as_u64().unwrap() as u32);
            assert_eq!(output.map(f32::to_bits).to_vec(),c["output_bits"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());
        }
    }
}
