//! Proposed child of audio_replay_windows_transport. No Windows/once substitute.
//! Requires root's qualified clock::Boundary implementation for Backend<N>.
use super::*;
use crate::audio_native_process_clock as clock;

/// A reference to the already-owned canonical runtime, never a second clock.
/// Arc keeps physical owners alive; launch/closed rejects samples after shutdown.
pub struct ClockHandle<N: startup::Network + Send + 'static> {
    pub(super) shared: Arc<Shared<N>>,
}
impl<N: startup::Network + Send + 'static> Clone for ClockHandle<N> {
    fn clone(&self) -> Self {
        Self {
            shared: self.shared.clone(),
        }
    }
}
impl<N: startup::Network + Send + 'static> ClockHandle<N> {
    /// One original993CE0 sample: one QPC after ensure_initialized, followed by
    /// reads of origin/frequency from this handle's canonical bank.
    pub fn raw_clock_sample(&self) -> Result<clock::RawSample, String> {
        let closed = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if *closed {
            return Err("process clock runtime is shut down".into());
        }
        let mut backend = Backend::new(self.shared.clone());
        backend.raw_clock_sample().map_err(str::to_string)
    }
    /// Pure arithmetic on that same raw sample: never a second QPC or epoch.
    pub fn wall_clock_f32_bits(&self) -> Result<u32, String> {
        let sample = self.raw_clock_sample()?;
        clock::divide_to_f32_bits(sample.counter.wrapping_sub(sample.origin), sample.frequency)
            .map_err(|e| format!("native process clock arithmetic: {e:?}"))
    }
}
impl<N: startup::Network + Send + 'static> Runtime<N> {
    /// Construction is lazy: publishing a handle does not initialize the clock.
    pub fn clock_handle(&self) -> Result<ClockHandle<N>, String> {
        let closed = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if *closed {
            return Err("process clock runtime is shut down".into());
        }
        Ok(ClockHandle {
            shared: self.shared.clone(),
        })
    }
    pub fn raw_clock_sample(&self) -> Result<clock::RawSample, String> {
        // No nested launch acquisition: the temporary guard in clock_handle
        // ends before the handle acquires its own guard for the whole sample.
        self.clock_handle()?.raw_clock_sample()
    }
}
impl<N: startup::Network + Send + 'static> Backend<N> {
    /// Internal call: caller already owns launch or another documented lifetime
    /// gate. Never reacquire launch here: loading dispatch already holds it.
    pub(super) fn raw_clock_sample(&mut self) -> Result<clock::RawSample, &'static str> {
        self.clock_preflight()?;
        clock::sample_raw(self).map_err(|e| self.clock_failed(e))
    }
    pub(super) fn native_clock_f32_bits(&mut self) -> Result<u32, &'static str> {
        let sample = self.raw_clock_sample()?;
        clock::divide_to_f32_bits(sample.counter.wrapping_sub(sample.origin), sample.frequency)
            .map_err(|e| self.failure(e, "native process clock arithmetic failed"))
    }
}

#[cfg(test)]
#[path = "audio_replay_windows_clock_tests.rs"]
mod tests;
