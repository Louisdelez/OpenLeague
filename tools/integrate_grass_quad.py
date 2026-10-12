from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_quad.rs';assert not p.exists()
p.write_text('''//! Original986760/986AD0 rectangle-to-quad parameters.
//! Source texture/renderer producers and full GPU binding remain open.
#[derive(Clone, Copy, Debug, Default)]
pub struct OffsetCache(pub Option<f32>);
#[derive(Clone, Copy, Debug)]
pub struct Quad { pub destination_xywh: [f32; 4], pub source_uv_origin_span: [f32; 4] }
impl OffsetCache {
    pub fn prepare(&mut self, destination: [i32; 4], source: [i32; 4], source_size: Option<[i32; 2]>, api_flag: i32) -> Result<Quad, &'static str> {
        let inverse = match source_size {
            Some(size) if size.contains(&0) => return Err("zero native source dimension is unqualified"),
            Some(size) => [1. / size[0] as f32, 1. / size[1] as f32],
            None => [0., 0.],
        };
        let mut uv = [source[0] as f32 * inverse[0], source[1] as f32 * inverse[1], source[2] as f32 * inverse[0], source[3] as f32 * inverse[1]];
        if api_flag == 1 {
            uv[0] -= inverse[0]; uv[2] -= inverse[0];
            uv[1] = 1. - (uv[1] - inverse[1]); uv[3] = 1. - (uv[3] - inverse[1]);
        }
        let cached = *self.0.get_or_insert(if api_flag == 0 {0.} else {-0.5});
        let low_level_offset = if api_flag == 0 {-0.5} else {0.5};
        let origin_x = destination[0] as f32 + cached;
        let origin_y = destination[1] as f32 + cached;
        Ok(Quad {
            destination_xywh: [origin_x + low_level_offset, origin_y + low_level_offset, destination[2].wrapping_sub(destination[0]) as f32, destination[3].wrapping_sub(destination[1]) as f32],
            source_uv_origin_span: [uv[0], uv[1], uv[2] - uv[0], uv[3] - uv[1]],
        })
    }
}

#[cfg(test)] mod tests {
    use super::*;
    #[test] fn quad_constants_and_offset_cache_match_original_draw_executions() {
        let proof: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/grass_quad_contract.json")).unwrap();
        assert_eq!(proof["passed"], true); let cases = proof["cases"].as_array().unwrap(); assert_eq!(cases.len(), 144);
        for (index, c) in cases.iter().enumerate() {
            let integers = |name: &str| std::array::from_fn(|i| c[name][i].as_i64().unwrap() as i32);
            let bits = |name: &str| std::array::from_fn(|i| c[name][i].as_u64().unwrap() as u32);
            let size = if c["source_size"].is_null() {None} else {Some(std::array::from_fn(|i| c["source_size"][i].as_i64().unwrap() as i32))};
            let mut cache = OffsetCache(if c["offset_cache_warm"].as_bool().unwrap() {Some(f32::from_bits(c["initial_cached_offset_bits"].as_u64().unwrap() as u32))} else {None});
            let actual = cache.prepare(integers("destination_rectangle"), integers("source_rectangle"), size, c["api_flag"].as_i64().unwrap() as i32).unwrap();
            assert_eq!(actual.destination_xywh.map(f32::to_bits), bits("destination_xywh_bits"), "destination case {index}");
            assert_eq!(actual.source_uv_origin_span.map(f32::to_bits), bits("source_uv_origin_span_bits"), "UV case {index}");
            assert_eq!(cache.0.unwrap().to_bits(), c["final_cached_offset_bits"].as_u64().unwrap() as u32);
        }
    }
}
''',encoding='utf-8')
main=r/'crates/client/src/main.rs';s=main.read_text(encoding='utf-8');assert 'mod grass_quad;' not in s
main.write_text('#[allow(dead_code)] // Native grass quad constants; texture/driver producers and GPU binding pending.\nmod grass_quad;\n'+s,encoding='utf-8');print('Installed native grass quad parameters.')
