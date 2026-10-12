//! Native event state transitions extracted from LoL 4.20 EventController.
//! Frame arguments use animation frames, never simulation ticks or seconds.
//! Consumers still must qualify blend binding, particle/audio callbacks and seeks.

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Cue {
    Start,
    Update,
    Stop,
}
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum State {
    Dormant,
    Active,
    Ended,
}
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum InvalidTime {
    NonFinite,
    NegativeStart,
    NegativeFrame,
}
#[derive(Debug, Clone)]
pub struct Event {
    start: f32,
    end: f32,
    flags: u32,
    state: State,
    wrapped: bool,
    continuation: bool,
    emitter_started: bool,
}
impl Event {
    pub fn new(start: f32, end: f32, flags: u32) -> Result<Self, InvalidTime> {
        if !start.is_finite() || !end.is_finite() {
            return Err(InvalidTime::NonFinite);
        }
        if start < 0.0 {
            return Err(InvalidTime::NegativeStart);
        }
        Ok(Self {
            start,
            end,
            flags,
            state: State::Dormant,
            wrapped: end >= 0.0 && start > end,
            continuation: false,
            emitter_started: false,
        })
    }
    pub fn state(&self) -> State {
        self.state
    }
    /// Native virtual +0x08 reads bit 1. Its emitter-backend meaning remains open.
    pub fn native_resource_flag_bit1(&self) -> bool {
        self.flags & 2 != 0
    }
    /// Mirrors 0x88a360: start and end can both occur within the same update.
    /// Explicit native frames permit reverse/seek handling to be added separately.
    pub fn evaluate(&mut self, frame: f32) -> Result<Vec<Cue>, InvalidTime> {
        if !frame.is_finite() {
            return Err(InvalidTime::NonFinite);
        }
        if frame < 0.0 {
            return Err(InvalidTime::NegativeFrame);
        }
        let mut cues = Vec::new();
        if self.state == State::Dormant {
            if frame < self.start {
                return Ok(cues);
            }
            self.continuation = self.wrapped;
            self.state = State::Active;
            if !self.emitter_started {
                cues.push(Cue::Start);
                self.emitter_started = true;
            }
        }
        if self.state == State::Active {
            if self.end >= 0.0 && frame >= self.end && !(self.wrapped && self.continuation) {
                self.state = State::Ended;
                self.stop(&mut cues);
            } else {
                cues.push(Cue::Update);
            }
        } else if self.state == State::Ended {
            self.stop(&mut cues);
        }
        Ok(cues)
    }
    /// Call at the original controller's loop-reset point, after frame evaluation.
    /// Flag-zero events retain their state and cannot silently become repeating.
    pub fn reset_loop(&mut self) -> Vec<Cue> {
        let mut cues = Vec::new();
        if self.flags & 1 == 0 {
            return cues;
        }
        self.state = State::Dormant;
        if self.continuation {
            self.continuation = false;
        } else {
            self.stop(&mut cues);
        }
        cues
    }
    fn stop(&mut self, cues: &mut Vec<Cue>) {
        if self.emitter_started {
            cues.push(Cue::Stop);
            self.emitter_started = false;
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn native_thresholds_are_inclusive_and_do_not_duplicate_start_or_stop() {
        let mut event = Event::new(25.0, 30.0, 3).unwrap();
        assert!(event.evaluate(24.999).unwrap().is_empty());
        assert_eq!(event.evaluate(25.0).unwrap(), [Cue::Start, Cue::Update]);
        assert_eq!(event.evaluate(25.0).unwrap(), [Cue::Update]);
        assert_eq!(event.evaluate(29.999).unwrap(), [Cue::Update]);
        assert_eq!(event.evaluate(30.0).unwrap(), [Cue::Stop]);
        assert!(event.evaluate(31.0).unwrap().is_empty());
    }
    #[test]
    fn skipped_whole_window_starts_and_stops_in_native_order() {
        let mut event = Event::new(18.0, 23.0, 1).unwrap();
        assert_eq!(event.evaluate(24.0).unwrap(), [Cue::Start, Cue::Stop]);
        assert_eq!(event.state(), State::Ended);
    }
    #[test]
    fn negative_end_persists_until_reset_and_restarts_only_at_next_start_frame() {
        let mut event = Event::new(25.0, -1.0, 3).unwrap();
        assert_eq!(event.evaluate(25.0).unwrap(), [Cue::Start, Cue::Update]);
        assert_eq!(event.evaluate(450.0).unwrap(), [Cue::Update]);
        assert_eq!(event.reset_loop(), [Cue::Stop]);
        assert!(event.evaluate(24.0).unwrap().is_empty());
        assert_eq!(event.evaluate(25.0).unwrap(), [Cue::Start, Cue::Update]);
    }
    #[test]
    fn zero_flags_do_not_repeat_and_bit1_alone_does_not_enable_repeat() {
        for flags in [0, 2] {
            let mut event = Event::new(43.0, 48.0, flags).unwrap();
            assert_eq!(event.native_resource_flag_bit1(), flags == 2);
            assert_eq!(event.evaluate(70.0).unwrap(), [Cue::Start, Cue::Stop]);
            assert!(event.reset_loop().is_empty());
            assert!(event.evaluate(70.0).unwrap().is_empty());
        }
    }
    #[test]
    fn loop_stop_is_not_duplicated_for_finished_or_not_yet_started_events() {
        let mut event = Event::new(60.0, 65.0, 1).unwrap();
        assert!(event.reset_loop().is_empty());
        assert_eq!(event.evaluate(66.0).unwrap(), [Cue::Start, Cue::Stop]);
        assert!(event.reset_loop().is_empty());
        assert_eq!(event.evaluate(60.0).unwrap(), [Cue::Start, Cue::Update]);
    }
    #[test]
    fn invalid_frames_leave_running_state_intact() {
        let mut event = Event::new(0.0, 5.0, 1).unwrap();
        event.evaluate(0.0).unwrap();
        for frame in [f32::NAN, f32::INFINITY, -1.0] {
            assert!(event.evaluate(frame).is_err());
            assert_eq!(event.state(), State::Active);
        }
        assert_eq!(event.evaluate(5.0).unwrap(), [Cue::Stop]);
        assert!(Event::new(-1.0, 5.0, 1).is_err());
        assert!(Event::new(0.0, f32::NAN, 1).is_err());
    }
    #[test]
    fn all_eighteen_recovered_native_records_respect_their_source_lifetimes() {
        let data: serde_json::Value =
            serde_json::from_str(include_str!("../../../docs/map_ambient_blend_records.json"))
                .unwrap();
        let records = data["records"].as_array().unwrap();
        assert_eq!(records.len(), 18);
        for record in records {
            let start = record["start_value_raw"].as_f64().unwrap() as f32;
            let end = record["end_value_raw"].as_f64().unwrap() as f32;
            let flags = record["flags_raw"].as_u64().unwrap() as u32;
            assert!(end < 0.0 || start <= end);
            let mut event = Event::new(start, end, flags).unwrap();
            assert_eq!(event.evaluate(start).unwrap(), [Cue::Start, Cue::Update]);
            if end >= 0.0 {
                assert_eq!(event.evaluate(end).unwrap(), [Cue::Stop]);
            } else {
                assert_eq!(event.evaluate(10000.0).unwrap(), [Cue::Update]);
            }
            event.reset_loop();
            let after = event.evaluate(start).unwrap();
            if flags & 1 != 0 {
                assert_eq!(after, [Cue::Start, Cue::Update]);
            } else {
                assert!(after.is_empty());
            }
        }
    }
}
