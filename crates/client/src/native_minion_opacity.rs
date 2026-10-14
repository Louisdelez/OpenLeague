//! Candidate arithmetic only. Original 4.20 PE 61B160 / 99C730 goldens.
//! The ordinary actor registry, clock adapter and alpha draw route are separate requirements.
//! Inputs are float32 because the qualified oracle clock getter is explicitly float32.

#[derive(Clone, Copy, Debug)]
pub struct OpacityState {
    pub deadline: f32,
    pub current: f32,
    pub target: f32,
    pub rate: f32,
}

impl OpacityState {
    /// Preserve original arithmetic order, including the zero/negative-duration behavior.
    /// Native production API admissible domains have not been established by this oracle.
    pub fn begin(current: f32, target: f32, duration: f32, clock: f32) -> Self {
        let delta = target - current;
        Self { deadline: clock + duration, current, target, rate: delta / duration }
    }

    pub fn sample(&mut self, clock: f32) -> f32 {
        let remaining = self.deadline - clock;
        let value = if remaining > 0.0 {
            let offset = self.rate * remaining;
            self.target - offset
        } else {
            self.target
        };
        self.current = value;
        value
    }
}

/// The future host must supply a complete actor entity/model/session ownership key.
/// This guard has no renderer, entity discovery or material mutation authority.
#[derive(Clone, Debug)]
pub struct OwnedState<Owner> {
    owner: Owner,
    state: OpacityState,
}

impl<Owner: Eq> OwnedState<Owner> {
    pub fn begin(owner: Owner, current: f32, target: f32, duration: f32, clock: f32) -> Self {
        Self { owner, state: OpacityState::begin(current, target, duration, clock) }
    }

    pub fn sample_for(&mut self, owner: &Owner, clock: f32) -> Option<f32> {
        if &self.owner != owner { return None; }
        Some(self.state.sample(clock))
    }

    /// Retarget from the opacity actually sampled for this owner, as in the native setter.
    pub fn retarget_for(&mut self, owner: &Owner, target: f32, duration: f32, clock: f32) -> bool {
        if &self.owner != owner { return false; }
        self.state = OpacityState::begin(self.state.current, target, duration, clock);
        true
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    include!("native_minion_opacity_goldens.rs");

    #[test]
    fn replacement_session_model_or_actor_cannot_update_or_retarget_previous_owner() {
        let first = (9_u64, 20_u64, 30_u64);
        let mut state = OwnedState::begin(first, 1., 0., 2., 3.5);
        for foreign in [(10,20,30),(9,21,30),(9,20,31)] {
            assert_eq!(state.sample_for(&foreign, 4.), None);
            assert!(!state.retarget_for(&foreign, 1., 0.5, 4.));
        }
        assert_eq!(state.sample_for(&first, 4.), Some(0.75));
        assert!(state.retarget_for(&first, 1., 0.5, 4.));
        assert_eq!(state.sample_for(&first, 4.25), Some(0.875));
    }
}
