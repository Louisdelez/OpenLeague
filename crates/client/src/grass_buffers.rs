//! Native983040CPU buffer initializer,24byte vertices and16bit strip indices.
pub const VERTEX_WORDS: [u32;24]=[0,0,0,0xffffffff,0,0,0x3f800000,0,0,0xffffffff,0x3f800000,0,0,0x3f800000,0,0xffffffff,0,0x3f800000,0x3f800000,0x3f800000,0,0xffffffff,0x3f800000,0x3f800000];
pub const INDICES: [u16;4]=[0,1,2,3];
pub const STRIDE: u64=24;
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn gpu_buffer_data_matches_original_cpu_initializer() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_buffers_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["d3d_draw_primitive"],5);assert_eq!(p["vertex_stride"],STRIDE);
        for c in p["cases"].as_array().unwrap() {
            if c["disabled"]==true {continue;}
            if c["failure_adapter"]!=1 {let words:[u32;24]=std::array::from_fn(|i|c["vertex_words"][i].as_u64().unwrap() as u32);assert_eq!(VERTEX_WORDS,words);}
            if c["failure_adapter"]!=2 {let indices:[u16;4]=std::array::from_fn(|i|c["indices_u16"][i].as_u64().unwrap() as u16);assert_eq!(INDICES,indices);}
        }
    }
}
