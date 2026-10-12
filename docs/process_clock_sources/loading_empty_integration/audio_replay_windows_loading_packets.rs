//! Loading-screen packet95 consumers in the canonical Windows bank.
//! Recipient construction/publication remains owned by its separate lifecycle.
use super::*;
use crate::{
    audio_loading_metadata as names, audio_loading_record_tree::Kind,
    audio_loading_screen_packet as loading, audio_replay_packet95 as packet95,
};

impl<N: startup::Network + Send + 'static> loading::Boundary for Backend<N> {
    fn service_name(
        &mut self,
        _service: u32,
        target: u32,
        output: u32,
        key: u32,
    ) -> Result<(), &'static str> {
        if target != names::SERVICE_NAME {
            return Err(self.failure(target, "unknown loading service name method"));
        }
        //72AD90 uses global parent metadata; its ECX service value is unused.
        self.event_temporary(8, |b, scratch| {
            names::service_name(b, output, key, scratch)
                .map(|_| ())
                .map_err(|e| b.failure(e, "loading metadata name provider failed"))
        })
    }
    fn clock_f32_bits(&mut self) -> Result<u32, &'static str> {
        self.loading_clock_f32_bits()
    }
    // A real empty metadata name completes without UI. The nonempty standard
    // UI continuation remains an explicit default error.
}

impl<N: startup::Network + Send + 'static> Backend<N> {
    pub(super) fn receive_loading_payload(
        &mut self,
        recipient: u32,
        target: u32,
        payload: u32,
    ) -> Result<(), &'static str> {
        let kind = match target {
            0x57d650 => Kind::Standard,
            0x5b3230 => Kind::Tutorial,
            _ => return Err(self.failure((recipient, target), "unknown native packet95 recipient")),
        };
        self.event_temporary(loading::NAME_SCRATCH_BYTES, |b, scratch| {
            loading::receive(b, kind, recipient, payload, scratch)
                .map_err(|e| b.failure(e, "native loading-screen packet consumer failed"))
        })
    }

    /// Called for decoded event95 under the existing runtime launch lock,
    /// before service context writes, dispatch activation or scratch allocation.
    /// Native58A6F2 always passes packet+5, including extended FE headers.
    pub(super) fn preflight_loading_packet(&mut self, packet: &[u8]) -> Result<(), String> {
        let object = self
            .word(packet95::GLOBAL_PAIR)
            .map_err(|e| format!("packet95 global receiver:{e:?}"))?;
        if object == 0 {
            //577E90 returns without reading any payload on this real source path.
            return Ok(());
        }
        let recipient = self
            .word(object)
            .map_err(|e| format!("packet95 recipient:{e:?}"))?;
        let table = self
            .word(recipient)
            .map_err(|e| format!("packet95 recipient vtable:{e:?}"))?;
        let target = self
            .word(table)
            .map_err(|e| format!("packet95 recipient method:{e:?}"))?;
        if matches!(target, 0x57d650 | 0x5b3230) && packet.len() < 30 {
            return Err("truncated loading-screen packet95 payload".into());
        }
        // Other methods reach receive_loading_payload's explicit unsupported
        // error. Their payload contract has not been invented here.
        Ok(())
    }
}

#[cfg(test)]
#[path = "audio_replay_windows_loading_packets_tests.rs"]
mod tests;
