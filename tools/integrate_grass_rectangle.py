from pathlib import Path
r=Path('E:/OpenLeague')
source='''//! Original986510 AABB-to-screen-rectangle aggregation.
//! Camera projection and native actor eligibility are separate, still-open producers.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Rectangle(pub [i32; 4]);
#[derive(Debug, Clone, Copy)]
pub struct Projection { pub screen: [f32; 3], pub accepted: bool }

pub fn expanded_corners(aabb: [f32; 6], margin: f32) -> [[f32; 3]; 8] {
    let mut edges = [[0.; 2]; 3];
    for axis in 0..3 {
        let span = aabb[axis + 3] - aabb[axis];
        let half = span * 0.5;
        let expansion = half * margin;
        edges[axis] = [aabb[axis] - expansion, aabb[axis + 3] + expansion];
    }
    std::array::from_fn(|i| [edges[0][i / 4], edges[1][(i / 2) % 2], edges[2][i % 2]])
}

// Rust float-to-int casts saturate; native CVTTSS2SI returns INT_MIN on invalid input.
pub fn truncate_screen(value: f32) -> i32 {
    if !value.is_finite() || value < -2147483648. || value >= 2147483648. {
        i32::MIN
    } else { value.trunc() as i32 }
}

pub fn project_rectangle(
    aabb: [f32; 6], margin: f32, viewport: [i32; 2],
    mut project: impl FnMut([f32; 3]) -> Projection,
) -> Rectangle {
    let mut bounds = [i32::MAX, i32::MAX, i32::MIN, i32::MIN];
    let mut accepted = false;
    for corner in expanded_corners(aabb, margin) {
        let point = project(corner);
        accepted |= point.accepted;
        let x = truncate_screen(point.screen[0]);
        let y = truncate_screen(point.screen[1]);
        bounds[0] = bounds[0].min(x); bounds[1] = bounds[1].min(y);
        bounds[2] = bounds[2].max(x); bounds[3] = bounds[3].max(y);
    }
    if !accepted { return Rectangle([-1, -1, 0, 0]); }
    bounds[0] = bounds[0].max(0); bounds[1] = bounds[1].max(0);
    bounds[2] = bounds[2].min(viewport[0]); bounds[3] = bounds[3].min(viewport[1]);
    Rectangle(bounds)
}

#[cfg(test)] mod tests {
    use super::*;
    #[test] fn matches_original_instruction_results_for_all_rectangle_fixtures() {
        let proof: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/grass_rectangle_contract.json")).unwrap();
        assert_eq!(proof["passed"], true);
        let cases = proof["cases"].as_array().unwrap(); assert_eq!(cases.len(), 432);
        for c in cases {
            let aabb = std::array::from_fn(|i| c["aabb"][i].as_f64().unwrap() as f32);
            let margin = f32::from_bits(c["margin_bits"].as_u64().unwrap() as u32);
            let viewport = std::array::from_fn(|i| c["viewport"][i].as_i64().unwrap() as i32);
            let expected_corners: [[u32; 3]; 8] = std::array::from_fn(|i| std::array::from_fn(|axis| c["expanded_corner_bits"][i][axis].as_u64().unwrap() as u32));
            assert_eq!(expanded_corners(aabb, margin).map(|v| v.map(f32::to_bits)), expected_corners);
            let mut next = 0;
            let mask = c["projection_success_mask"].as_u64().unwrap();
            let actual = project_rectangle(aabb, margin, viewport, |corner| {
                assert_eq!(corner.map(f32::to_bits), expected_corners[next]);
                let i = next; next += 1;
                Projection { screen: std::array::from_fn(|axis| f32::from_bits(c["projection_output_bits"][i][axis].as_u64().unwrap() as u32)), accepted: mask & (1 << i) != 0 }
            });
            assert_eq!(next, 8);
            let expected = std::array::from_fn(|i| c["screen_rectangle"][i].as_i64().unwrap() as i32);
            assert_eq!(actual, Rectangle(expected));
        }
    }
    #[test] fn cvtt_indefinite_and_signed_truncation_do_not_saturate() {
        for value in [f32::NAN, f32::INFINITY, f32::NEG_INFINITY, 2147483648.] { assert_eq!(truncate_screen(value), i32::MIN); }
        assert_eq!(truncate_screen(-0.9), 0); assert_eq!(truncate_screen(-12.9), -12);
        assert_eq!(truncate_screen(2147483520.), 2147483520);
    }
}
'''
path=r/'crates/client/src/grass_rectangle.rs'
assert not path.exists(), 'one-shot installer: grass rectangle module already exists'
path.write_text(source,encoding='utf-8')
main=r/'crates/client/src/main.rs';s=main.read_text(encoding='utf-8')
assert 'mod grass_rectangle;' not in s
main.write_text('#[allow(dead_code)] // Native rectangle consumer qualified; camera, mask producer and live actor gates pending.\nmod grass_rectangle;\n'+s,encoding='utf-8')
print('Installed native grass rectangle consumer; live mask route remains open.')
