//! Native985680 matrix projection and9854F0 target remapping.
//! Inputs are supplied explicitly; historical camera/viewport producers remain open.
#[derive(Clone, Copy)]
pub struct Viewport { pub origin: [u32; 2], pub size: [u32; 2], pub min_depth: f32 }
#[derive(Clone, Copy, Debug)]
pub struct ScreenPoint { pub screen: [f32; 3], pub accepted: bool }

fn transform(point: [f32; 4], matrix: [f32; 16], implicit_one: bool) -> [f32; 4] {
    std::array::from_fn(|axis| {
        // Native SSE order starts with Y, then X, then Z, then translation/W.
        let y = matrix[4 + axis] * point[1];
        let x = matrix[axis] * point[0];
        let xy = y + x;
        let z = matrix[8 + axis] * point[2];
        let xyz = xy + z;
        let w = if implicit_one { matrix[12 + axis] } else { matrix[12 + axis] * point[3] };
        xyz + w
    })
}

pub fn project(point: [f32; 3], world: [f32; 16], view: [f32; 16], projection: [f32; 16], viewport: Viewport) -> Result<[f32; 3], &'static str> {
    let world_point = transform([point[0], point[1], point[2], 1.], world, true);
    let view_point = transform(world_point, view, false);
    let clip = transform(view_point, projection, false);
    if clip[3] == 0. { return Err("native zero-W projection leaves output undefined"); }
    let reciprocal = 1. / clip[3];
    let ndc = [reciprocal * clip[0], reciprocal * clip[1], reciprocal * clip[2]];
    // x87 preserves wider intermediates; f64 adapter qualified only by recorded fixtures.
    let x = ((ndc[0] as f64 + 1.) * viewport.size[0] as f64 * 0.5 + viewport.origin[0] as f64) as f32;
    let y = ((1. - ndc[1] as f64) * viewport.size[1] as f64 * 0.5 + viewport.origin[1] as f64) as f32;
    let depth_plus_one = ndc[2] + 1.;
    let depth_half = depth_plus_one * 0.5;
    let depth = depth_half + viewport.min_depth;
    Ok([x, y, depth])
}

pub fn remap(projected: [f32; 3], render_size: [u32; 2], window: [i32; 4]) -> Result<ScreenPoint, &'static str> {
    let widths = [window[2].wrapping_sub(window[0]), window[3].wrapping_sub(window[1])];
    if widths.contains(&0) { return Err("zero native viewport remapping span is unqualified"); }
    let x = (projected[0] as f64 - window[0] as f64) / widths[0] as f64 * render_size[0] as f64;
    let y = (projected[1] as f64 - window[1] as f64) / widths[1] as f64 * render_size[1] as f64;
    let screen = [x as f32, y as f32, projected[2]];
    let accepted = screen[2] >= 0. && screen[2] < 1. && screen[0] >= 0. && x <= render_size[0] as f64 && screen[1] >= 0. && y <= render_size[1] as f64;
    Ok(ScreenPoint {screen, accepted})
}

#[cfg(test)] mod tests {
    use super::*;
    fn proof() -> serde_json::Value { serde_json::from_str(include_str!("../../../data/4.20/grass_projection_contract.json")).unwrap() }
    fn input(c: &serde_json::Value) -> Result<[f32; 3], &'static str> {
        let floats = |key: &str| std::array::from_fn(|i| f32::from_bits(c[key][i].as_u64().unwrap() as u32));
        let matrices = |key: &str| std::array::from_fn(|i| f32::from_bits(c[key][i].as_u64().unwrap() as u32));
        let v = &c["viewport"];
        let viewport = Viewport {origin: [v[0].as_u64().unwrap() as u32, v[1].as_u64().unwrap() as u32], size: [v[2].as_u64().unwrap() as u32, v[3].as_u64().unwrap() as u32], min_depth: v[4].as_f64().unwrap() as f32};
        project(floats("point_bits"), matrices("world_bits"), matrices("view_bits"), matrices("projection_bits"), viewport)
    }
    #[test] fn matrix_projection_matches_all_original_scalar_and_viewport_fixtures() {
        let p = proof(); assert_eq!(p["passed"], true);
        let cases = p["cases"].as_array().unwrap(); assert_eq!(cases.len(), 168);
        for (i, c) in cases.iter().enumerate() {
            let result = input(c);
            if c["w_nonzero"] == false { assert!(result.is_err()); continue; }
            let expected: [u32; 3] = std::array::from_fn(|axis| c["screen_bits"][axis].as_u64().unwrap() as u32);
            assert_eq!(result.unwrap().map(f32::to_bits), expected, "projection case {i}");
        }
    }
    #[test] fn target_remapping_and_acceptance_match_original_compound_execution() {
        let p = proof(); let cases = p["compound_cases"].as_array().unwrap(); assert_eq!(cases.len(), 396);
        for (i, c) in cases.iter().enumerate() {
            let source = &p["cases"][c["projection_case"].as_u64().unwrap() as usize];
            let point = input(source).unwrap();
            let render_size = std::array::from_fn(|axis| c["render_size"][axis].as_u64().unwrap() as u32);
            let window = std::array::from_fn(|axis| c["window"][axis].as_i64().unwrap() as i32);
            let actual = remap(point, render_size, window).unwrap();
            let expected: [u32; 3] = std::array::from_fn(|axis| c["screen_bits"][axis].as_u64().unwrap() as u32);
            assert_eq!(actual.screen.map(f32::to_bits), expected, "compound case {i}");
            assert_eq!(actual.accepted, c["accepted"].as_bool().unwrap(), "compound gate {i}");
        }
    }
}
