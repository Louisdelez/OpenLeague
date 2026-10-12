//! Native 93F9BD..93FA0B tail, with 93EE30 qualified for disabled descriptors.
//! Enabled one-shot audio requires the real producer; it is rejected explicitly.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct State {
    pub last_input_time: u32,
    pub flags: u8,
    pub counter: u32,
}
pub struct Input {
    pub time: u32,
    pub visible: u8,
    pub emit: bool,
    pub stopped: bool,
    pub one_shot_descriptors_enabled: [bool; 2],
}
/// Returns whether 93EE30 was called, including its already-emitted early return.
/// Input time is copied as raw bits; stopped tails preserve time and visibility.
pub fn finish(state: &mut State, input: &Input) -> Result<bool, &'static str> {
    let one_shot_called = !input.stopped && input.emit;
    if one_shot_called && input.one_shot_descriptors_enabled.iter().any(|v| *v) {
        return Err("enabled one-shot audio producer is not qualified");
    }
    Ok(finish_with(state, input, |state| state.flags |= 0x20))
}
/// Composes the tail with a supplied qualified one-shot producer.
pub fn finish_with(state: &mut State, input: &Input, emit: impl FnOnce(&mut State)) -> bool {
    let one_shot_called = !input.stopped && input.emit;
    if !input.stopped {
        if one_shot_called {
            // With disabled descriptors, the native helper sets this bit even
            // when elapsed time is unordered or >= 1; bit 0x20 skips the helper body.
            emit(state);
        }
        state.flags = (state.flags & !4) | ((input.visible << 2) & 4);
        state.last_input_time = input.time;
    }
    if state.flags & 1 != 0 && state.flags & 0x10 == 0 {
        state.flags &= !2;
    }
    state.counter = state.counter.wrapping_add(1);
    one_shot_called
}
#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::Value;
    fn bits(v: &Value) -> u32 {
        u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"), 16).unwrap()
    }
    #[test]
    fn tail_matches_2048_native_cases_including_raw_times_and_counter_wrap() {
        let p: Value = serde_json::from_str(include_str!("../../../data/4.20/troy_frame_finish_contract.json")).unwrap();
        let cases = p["cases"].as_array().unwrap();
        assert_eq!(cases.len(), 2048);
        for (i, row) in cases.iter().enumerate() {
            let mut state = State { last_input_time: bits(&row["old_time"]), flags: row["flags"].as_u64().unwrap() as u8, counter: row["counter"].as_u64().unwrap() as u32 };
            let called = finish(&mut state, &Input { time: bits(&row["time"]), visible: row["visible"].as_u64().unwrap() as u8, emit: row["emit"].as_bool().unwrap(), stopped: row["stopped"].as_bool().unwrap(), one_shot_descriptors_enabled: [false; 2] }).unwrap();
            let expected = &row["cpu"];
            assert_eq!(state, State { last_input_time: bits(&expected["last_input_time"]), flags: expected["flags"].as_u64().unwrap() as u8, counter: expected["counter"].as_u64().unwrap() as u32 }, "case {i}");
            assert_eq!(expected["events"], if called { serde_json::json!(["oneshot"]) } else { serde_json::json!([]) }, "case {i}");
        }
    }
    #[test]
    fn enabled_audio_is_rejected_before_mutation_but_stopped_tail_skips_it() {
        let initial = State { last_input_time: 0x7fa01234, flags: 3, counter: u32::MAX };
        for descriptors in [[true, false], [false, true], [true, true]] {
            let mut state = initial;
            let mut input = Input { time: 0, visible: 1, emit: true, stopped: false, one_shot_descriptors_enabled: descriptors };
            assert!(finish(&mut state, &input).is_err());
            assert_eq!(state, initial);
            input.stopped = true;
            assert_eq!(finish(&mut state, &input), Ok(false));
            assert_eq!(state, State { last_input_time: initial.last_input_time, flags: 1, counter: 0 });
        }
    }
}
