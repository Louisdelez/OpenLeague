//! Original93FA10 stop transition. It is separate from controller End marking.
#[derive(Debug,Clone,Copy,PartialEq)]
pub struct StopState { pub flags: u8, pub stop_time: f32, pub handles: [i32; 2] }
impl StopState {
    /// Caller supplies the original configuration byte1BC and current native clock.
    /// Pending must preserve the engine's unsigned sorted identity invariant.
    pub fn request(&mut self, clock: f32, config_flags: u8, identity: u32, pending: &mut Vec<u32>, mut release: impl FnMut(i32)) -> Result<bool, &'static str> {
        if self.flags & 0x40 != 0 { return Ok(false); }
        if pending.windows(2).any(|w| w[0] > w[1]) { return Err("unsorted emitter stop queue"); }
        self.flags = (self.flags & !1) | 0x50;
        self.stop_time = clock;
        if config_flags & 0x10 != 0 {
            for handle in &mut self.handles {
                if *handle != -1 { release(*handle); *handle = -1; }
            }
        }
        let position = pending.partition_point(|value| *value < identity);
        pending.insert(position, identity);
        Ok(true)
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_216_native_stop_cases_including_repeated_calls_and_zero_handles() {
        let proof: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/audio_emitter_stop_contract.json")).unwrap();
        let cases = proof["cases"].as_array().unwrap(); assert_eq!(cases.len(), 216);
        for c in cases {
            let handles = c["handles"].as_array().unwrap();
            let mut state = StopState { flags: c["flags"].as_u64().unwrap() as u8, stop_time: 999., handles: [handles[0].as_i64().unwrap() as i32, handles[1].as_i64().unwrap() as i32] };
            let mut pending = Vec::new(); let mut released = Vec::new();
            for _ in 0..2 { state.request(c["clock"].as_f64().unwrap() as f32, c["config_flags"].as_u64().unwrap() as u8, 0x30008000, &mut pending, |handle| released.push(handle)).unwrap(); }
            assert_eq!(state.flags, c["final_flags"].as_u64().unwrap() as u8);
            assert_eq!(state.stop_time, c["final_time"].as_f64().unwrap() as f32);
            let expected: Vec<i32> = c["final_handles"].as_array().unwrap().iter().map(|h| h.as_i64().unwrap() as i32).collect(); assert_eq!(state.handles.as_slice(), expected);
            let expected: Vec<i32> = c["released"].as_array().unwrap().iter().map(|h| h.as_i64().unwrap() as i32).collect(); assert_eq!(released, expected);
            let expected: Vec<u32> = c["queued"].as_array().unwrap().iter().map(|h| h.as_u64().unwrap() as u32).collect(); assert_eq!(pending, expected);
        }
    }
    #[test]
    fn rejected_unsorted_queue_keeps_owner_state_and_handles() {
        let mut state = StopState { flags: 1, stop_time: 7., handles: [0,42] }; let before = state;
        let mut queue = vec![2,1];
        assert!(state.request(8.,16,3,&mut queue, |_| panic!("must retain handles")).is_err());
        assert_eq!(state,before); assert_eq!(queue,[2,1]);
    }
}
