//! Original9455F6..945616 raw timestamp and wrapping resource particle counter.
pub fn finish(time:u32,active:u32,last_time:&mut u32,counter:&mut u32) {
    *last_time=time;*counter=counter.wrapping_add(active);
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn epilogue_matches144_original_cases_including_signaling_nan_and_wrap() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_particle_tail_contract.json")).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),144);
        for r in rows {let word=|key:&str|r[key].as_u64().unwrap() as u32;let mut time=0xdeadbeef;let mut counter=word("counter");finish(word("time"),word("active"),&mut time,&mut counter);assert_eq!(time,word("output_time"));assert_eq!(counter,word("output_counter"));}
    }
}
