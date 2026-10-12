//! Native Anchor property storage (9A2000), formatted scanner boundary.
//! Pixel positioning and anchor interpretation remain separate.
pub fn apply(values:&[f32],assignment_count:i32,current:&mut [f32;2],cached:&mut [f32;2])->u32 {
    let written=assignment_count.max(0).min(2) as usize;
    assert!(values.len()>=written);
    current[..written].copy_from_slice(&values[..written]);
    if assignment_count!=2 {return 0;}
    *cached=*current;8
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn original_anchor_partial_reads_and_successful_copy_match() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_anchor_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],96);
        for c in p["cases"].as_array().unwrap() {
            // Legacy boundary fixtures supplied raw32-bit storage words, not parsed integers.
            let pair=|key:&str|{let v=c[key].as_array().unwrap();[f32::from_bits(v[0].as_i64().unwrap() as u32),f32::from_bits(v[1].as_i64().unwrap() as u32)]};
            let mut current=pair("initial");let mut cached=pair("cached");assert_eq!(apply(&pair("values"),c["assignment_count"].as_i64().unwrap() as i32,&mut current,&mut cached),c["result"].as_u64().unwrap() as u32);
            assert_eq!([current[0],current[1],cached[0],cached[1]].map(f32::to_bits).to_vec(),c["output"].as_array().unwrap().iter().map(|v|v.as_i64().unwrap() as u32).collect::<Vec<_>>());
        }
    }
}
