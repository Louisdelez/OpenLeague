//! Original5B5440 marks an alive particle; it does not release its audio handles.
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct Marks {pub ending_raw:u32,pub remaining_raw:u32}
impl Marks {
    pub fn mark(&mut self,weak_alive:bool) {if weak_alive {self.ending_raw=1;self.remaining_raw=0;}}
    /// Original6C97B0 gate order. False prevents its updates; it is not cleanup.
    /// The target's virtual14 predicate is queried before our ending marker.
    pub fn update_allowed(&self,weak_alive:bool,mut native_ended:impl FnMut()->u8)->bool {
        weak_alive && native_ended()==0 && self.ending_raw==0
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_96_original_end_marks_without_releasing_persistent_handles() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_emitter_end_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),96);
        for c in cases {
            let mut marks=Marks {ending_raw:c["ending_raw"].as_u64().unwrap() as u32,remaining_raw:c["remaining_raw"].as_u64().unwrap() as u32};
            let mut emitter=crate::audio_requests::Emitter::new(String::new(),"persistent".into());let handle=c["handle"].as_i64().unwrap() as i32;
            emitter.ensure_persistent(crate::audio_requests::Context {clock:0.,birth:0.,position:[1.,2.,3.]},|_|handle).unwrap();
            for _ in 0..2 {marks.mark(c["weak_alive"].as_bool().unwrap());}
            assert_eq!(marks.ending_raw,c["final_ending_raw"].as_u64().unwrap() as u32);assert_eq!(marks.remaining_raw,c["final_remaining_raw"].as_u64().unwrap() as u32);assert_eq!(emitter.logical_handle(),c["final_handle"].as_i64().unwrap() as i32);
        }
    }
    #[test]
    fn matches_24_native_update_gates_and_predicate_query_order() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_emitter_update_gate_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),24);
        for c in cases {
            let marks=Marks {ending_raw:c["ending_raw"].as_u64().unwrap() as u32,remaining_raw:0};let mut queries=0;
            let allowed=marks.update_allowed(c["weak_alive"].as_bool().unwrap(),||{queries+=1;c["native_ended_byte"].as_u64().unwrap() as u8});
            assert_eq!(allowed,c["proceed"].as_bool().unwrap());assert_eq!(queries,c["predicate_queries"].as_u64().unwrap());
        }
    }

}
