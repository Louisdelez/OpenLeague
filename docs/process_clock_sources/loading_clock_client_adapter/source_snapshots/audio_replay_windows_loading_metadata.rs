//! Loading providers use the canonical replay parent, stream index and metadata.
use super::*;
use crate::{
    audio_loading_metadata as loading, audio_replay_game_manager as manager,
    audio_replay_object_manager as objects, audio_replay_shared_pair as pair,
};
impl<N: startup::Network + Send + 'static> crate::audio_replay_object_commands::Boundary
    for Backend<N>
{
    fn initialize_game_manager(&mut self) -> Result<(), &'static str> {
        manager::get(self)
            .map(|_| ())
            .map_err(|e| self.failure(e, "packet replay parent initialization failed"))
    }
}

impl<N: startup::Network + Send + 'static> loading::Boundary for Backend<N> {
    fn initialize_game_manager(&mut self) -> Result<(), &'static str> {
        manager::get(self)
            .map(|_| ())
            .map_err(|e| self.failure(e, "loading replay parent initialization failed"))
    }
    fn resolve_key(&mut self, _metadata: u32, target: u32, key: u32) -> Result<u64, &'static str> {
        if target != loading::RESOLVE {
            return Err("unknown loading metadata resolver");
        }
        //729EC0→729730 acquires from [parent+30] without729CF0's null shortcut.
        let parent = manager::get(self)
            .map_err(|e| self.failure(e, "loading replay parent lookup failed"))?;
        let nested = self
            .word(parent + 0x30)
            .map_err(|e| self.failure(e, "loading replay stream missing"))?;
        self.event_temporary(16, |b, s| {
            pair::from_nested(b, nested, s)
                .map_err(|e| b.failure(e, "loading object index acquisition failed"))?;
            let action = (|| {
                let index = b
                    .word(s)
                    .map_err(|e| b.failure(e, "loading object index missing"))?;
                objects::lookup(b, index, key, s + 8)
                    .map_err(|e| b.failure(e, "loading identifier resolution failed"))
            })();
            let cleanup = pair::destroy(b, s)
                .map_err(|e| b.failure(e, "loading object index release failed"));
            match (action, cleanup) {
                (Ok(v), Ok(())) => Ok(v),
                (Err(e), Ok(())) | (Ok(_), Err(e)) => Err(e),
                (Err(a), Err(c)) => {
                    Err(b.failure((a, c), "loading identifier resolution and cleanup failed"))
                }
            }
        })
    }
}
impl<N: startup::Network + Send + 'static> Backend<N> {
    pub(super) fn loading_clock_f32_bits(&mut self) -> Result<u32, &'static str> {
        Err("native process clock993CE0 producer is not connected to the loading screen")
    }
}

#[cfg(test)]
#[path = "audio_replay_windows_loading_metadata_tests.rs"]
mod tests;
