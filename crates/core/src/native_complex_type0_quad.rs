//! Original type-0 vertex packet at 9223E0, including 8E18E0 and 922160.
//! This helper does not compute camera axes or interpret shader/atlas channels.
//! Candidate only: Rust compilation and target-platform equivalence remain to run.

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Input {
    pub center: [f32; 3],
    /// Already scaled vectors supplied by the original caller's basis policy.
    pub axis_a: [f32; 3],
    pub axis_b: [f32; 3],
    /// Already prepared RGBA (including any caller premultiplication).
    pub rgba: [f32; 4],
    pub channel0_origin: [f32; 2],
    pub channel0_z: f32,
    pub channel1_origin: [f32; 2],
    pub channel1_corners: bool,
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum Error { NonFinite, ColorOutsideQualifiedDomain, ArithmeticOverflow }

/// Exact native layout per vertex: position.xyz, ARGB8, channel0.xyzw,
/// channel1.xy, channel2.xy. Each row is 48 bytes when serialized little-endian.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct Quad { pub words: [[u32; 12]; 4] }

impl Quad {
    pub fn bytes(self) -> [u8; 192] {
        let mut bytes = [0; 192];
        for (i, word) in self.words.into_iter().flatten().enumerate() {
            bytes[i * 4..i * 4 + 4].copy_from_slice(&word.to_le_bytes());
        }
        bytes
    }
}

pub fn pack(input: Input) -> Result<Quad, Error> {
    if input.center.into_iter().chain(input.axis_a).chain(input.axis_b)
        .chain(input.rgba).chain(input.channel0_origin).chain([input.channel0_z])
        .chain(input.channel1_origin).any(|v| !v.is_finite()) { return Err(Error::NonFinite); }
    if input.rgba.iter().any(|v| !(0.0..=1.0).contains(v)) { return Err(Error::ColorOutsideQualifiedDomain); }
    // 8E18E0 multiplies f32 inputs by exact 255 in x87, then truncates. A f32
    // multiplication here would incorrectly round near an integer boundary.
    let c = input.rgba.map(|v| (f64::from(v) * 255.0).trunc() as u32);
    let argb = (c[3] << 24) | (c[0] << 16) | (c[1] << 8) | c[2];
    let p = input.center; let a = input.axis_a; let b = input.axis_b;
    let positions = [
        std::array::from_fn::<_, 3, _>(|i| (p[i] + a[i]) - b[i]),
        std::array::from_fn(|i| b[i] + (a[i] + p[i])),
        std::array::from_fn(|i| b[i] + (p[i] - a[i])),
        std::array::from_fn(|i| (p[i] - a[i]) - b[i]),
    ];
    let flag = if input.channel1_corners { 1.0 } else { 0.0 };
    let corners = [[0.0, 0.0], [1.0, 0.0], [1.0, 1.0], [0.0, 1.0]];
    let mut quad = Quad { words: [[0; 12]; 4] };
    for i in 0..4 {
        let [x, y] = corners[i];
        // The original uses load/store at zero corners, not add(+0). Preserve
        // signed zero and exact input bits on those edges.
        let u = if x == 0.0 { input.channel0_origin[0] } else { input.channel0_origin[0] + x };
        let v = if y == 0.0 { input.channel0_origin[1] } else { y + input.channel0_origin[1] };
        let s = if x == 0.0 { input.channel1_origin[0] } else { input.channel1_origin[0] + flag };
        let t = if y == 0.0 { input.channel1_origin[1] } else { flag + input.channel1_origin[1] };
        let fields = [positions[i][0], positions[i][1], positions[i][2], u, v,
            input.channel0_z, 0.0, s, t, x, y];
        if fields.iter().any(|v| !v.is_finite()) { return Err(Error::ArithmeticOverflow); }
        quad.words[i] = [fields[0].to_bits(), fields[1].to_bits(), fields[2].to_bits(), argb,
            fields[3].to_bits(), fields[4].to_bits(), fields[5].to_bits(), fields[6].to_bits(),
            fields[7].to_bits(), fields[8].to_bits(), fields[9].to_bits(), fields[10].to_bits()];
    }
    Ok(quad)
}

#[cfg(test)]
mod tests {
    use super::*;
    fn input(v: &serde_json::Value) -> Input {
        fn arr<const N: usize>(v: &serde_json::Value, key: &str) -> [f32; N] {
            std::array::from_fn(|i| v[key][i].as_f64().unwrap() as f32)
        }
        Input { center: arr(v,"center"), axis_a: arr(v,"axis_a"), axis_b: arr(v,"axis_b"),
            rgba: arr(v,"rgba"), channel0_origin: arr(v,"channel0_origin"), channel0_z: v["channel0_z"].as_f64().unwrap() as f32,
            channel1_origin: arr(v,"channel1_origin"), channel1_corners: v["channel1_corners"].as_bool().unwrap() }
    }
    fn vectors() -> serde_json::Value {
        serde_json::from_str(include_str!("../../../data/4.20/complex_type0_quad_vectors.json")).unwrap()
    }
    #[test]
    fn original_type0_quad_all_192_bytes_match_recorded_native_returns() {
        let v = vectors(); let cases = v["cases"].as_array().unwrap();
        assert_eq!(cases.len(), 40);
        for c in cases {
            let out = pack(input(&c["input"])).unwrap();
            let got: Vec<u32> = out.words.into_iter().flatten().collect();
            let expected: Vec<u32> = c["output_words"].as_array().unwrap().iter().map(|x|x.as_u64().unwrap() as u32).collect();
            assert_eq!(got, expected);
            assert_eq!(out.bytes().len(), 192);
        }
    }
    #[test]
    fn unsafe_float_domain_is_rejected_without_partial_publication() {
        let v = vectors(); let base = input(&v["cases"][0]["input"]);
        let mut bad = base; bad.center[0] = f32::NAN;
        assert_eq!(pack(bad), Err(Error::NonFinite));
        bad = base; bad.rgba[0] = 1.01;
        assert_eq!(pack(bad), Err(Error::ColorOutsideQualifiedDomain));
        bad = base; bad.center[0] = f32::MAX; bad.axis_a[0] = f32::MAX;
        assert_eq!(pack(bad), Err(Error::ArithmeticOverflow));
    }
}
