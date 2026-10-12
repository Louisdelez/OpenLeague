from pathlib import Path
r=Path('E:/OpenLeague')
source='''//! Native vertex constant register order: matrix c0..3, destination c4, UV c5, color c6.
pub fn encode(matrix: [f32;16], destination: [f32;4], uv: [f32;4], color: [f32;4]) -> Vec<u8> {
    matrix.into_iter().chain(destination).chain(uv).chain(color).flat_map(f32::to_le_bytes).collect()
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn uniform_words_match_actual_native_vertex_constant_submissions() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_constant_upload_contract.json")).unwrap();assert_eq!(p["passed"],true);
        let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),288);
        for c in cases {
            let calls=c["uploads"].as_array().unwrap();assert_eq!(calls.len(),4);
            for (call,(start,count)) in calls.iter().zip([(0,4),(4,1),(5,1),(6,1)]) {assert_eq!(call["start"],start);assert_eq!(call["count"],count);}
            let floats=|call:usize,index:usize|f32::from_bits(calls[call]["words"][index].as_u64().unwrap() as u32);
            let bytes=encode(std::array::from_fn(|i|floats(0,i)),std::array::from_fn(|i|floats(1,i)),std::array::from_fn(|i|floats(2,i)),std::array::from_fn(|i|floats(3,i)));
            let expected:Vec<u8>=calls.iter().flat_map(|call|call["words"].as_array().unwrap().iter()).flat_map(|word|(word.as_u64().unwrap() as u32).to_le_bytes()).collect();assert_eq!(bytes,expected);assert_eq!(bytes.len(),112);
            assert_eq!(c["inherited_filter_cache"],c["final_filter_cache"]);
        }
    }
}
'''
p=r/'crates/client/src/grass_constants.rs';assert not p.exists();p.write_text(source,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8').replace('mod grass_buffers;','mod grass_buffers;\n#[allow(dead_code)]\nmod grass_constants;');p.write_text(s,encoding='utf-8')
p=r/'crates/client/examples/grass_mask_gpu_probe.rs';s=p.read_text(encoding='utf-8');s='#[path="../src/grass_constants.rs"] mod grass_constants;\n'+s
old='''        let mut values = matrix.to_vec();
        values.extend(quad.destination_xywh); values.extend(quad.source_uv_origin_span);
        let bytes:Vec<_> = values.iter().flat_map(|value| value.to_le_bytes()).collect();'''
new='''        let bytes = grass_constants::encode(matrix,quad.destination_xywh,quad.source_uv_origin_span,[1.;4]);'''
assert old in s;s=s.replace(old,new).replace('"native_viewport_applied":true,','"native_viewport_applied":true,"native_constant_bytes":112,')
s=s.replace('Later scene filter inheritance, API selection/clip bridge and declaration translation remain qualification adapters.','Native constant register encoding c0..c6 shared. Later scene filter inheritance, API selection/clip bridge and declaration API creation remain qualification adapters.')
p.write_text(s,encoding='utf-8')
p=r/'assets/shaders/native_grass_mask.wgsl';s=p.read_text(encoding='utf-8').replace('source_uv: vec4<f32> }','source_uv: vec4<f32>, color: vec4<f32> }');p.write_text(s,encoding='utf-8')
print('Native constant encoder shared by GPU; inherited filtering scope preserved.')
