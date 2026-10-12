//! Native95EBA0 finite grid conversion under the qualified SSE floating-point mode.
/// x/z minimums round down and maximums round up. Invalid signed conversion
/// produces the x86 indefinite integer, rather than Rust's saturating cast.
pub fn rectangle(bounds: [f32; 6]) -> Result<[i32; 4], &'static str> {
    let values = [bounds[0], bounds[2], bounds[3], bounds[5]];
    if values.iter().any(|v| !v.is_finite()) {
        return Err("nonfinite spatial grid coordinates are not qualified");
    }
    Ok(std::array::from_fn(|i| {
        let rounded = if i < 2 { values[i].floor() } else { values[i].ceil() } as f64;
        if rounded < i32::MIN as f64 || rounded > i32::MAX as f64 {
            i32::MIN
        } else {
            rounded as i32
        }
    }))
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn spatial_grid_matches324_native_conversions() {
        let proof: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/spatial_visibility_grid_contract.json")).unwrap();
        let cases = proof["cases"].as_array().unwrap();
        assert_eq!(cases.len(), 324);
        for c in cases {
            let v: [f32; 4] = std::array::from_fn(|i| c["bounds_xz"][i].as_f64().unwrap() as f32);
            let expected = std::array::from_fn(|i| c["rectangle"][i].as_i64().unwrap() as i32);
            assert_eq!(rectangle([v[0], 0., v[1], v[2], 0., v[3]]).unwrap(), expected, "{c}");
        }
        assert!(rectangle([f32::NAN; 6]).is_err());
        assert!(rectangle([f32::INFINITY; 6]).is_err());
    }
}
