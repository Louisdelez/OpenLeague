//! Native vertex constant register order: matrix c0..3, destination c4, UV c5, color c6.
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
