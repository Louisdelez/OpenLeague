//! Loading-wrapper ownership uses the same Windows bank and real critical sections.
//! This adapter installs no screen, factory, language provider or global owner.
use super::*;
use crate::audio_replay_loading_owner as loading;
impl<N: startup::Network + Send + 'static> loading::Boundary for Backend<N> {
    fn read_byte(&mut self, p: u32) -> Result<u8, read::Error> {
        self.shared
            .bank
            .lock()
            .map_err(|_| read::Error::InvalidLayout)?
            .memory
            .read_byte(p)
    }
    fn initialize_lock(&mut self, p: u32) -> Result<(), &'static str> {
        engine::Boundary::initialize_critical_section(self, p)
    }
    fn destroy_lock(&mut self, p: u32) -> Result<(), &'static str> {
        thread::Boundary::delete_critical_section(self, p)
    }
    fn locale_is_default(&mut self) -> Result<bool, &'static str> {
        self.shared
            .bridge
            .loading_c_locale_is_default()
            .map_err(|e| self.failure(e, "loading CRT locale lookup failed"))
    }
    fn recipient_virtual(
        &mut self,
        p: u32,
        target: u32,
        slot: u32,
        flags: Option<u32>,
    ) -> Result<(), &'static str> {
        Err(self.failure(
            (p, target, slot, flags),
            "loading UI recipient close/delete is not connected",
        ))
    }
}
#[cfg(test)]
#[path = "audio_replay_windows_loading_tests.rs"]
mod tests;
