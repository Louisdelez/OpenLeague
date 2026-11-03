//! Decoded service packets through the native receive and listener registries.
use super::*;
use crate::{
    audio_announcer_active_service as active, audio_announcer_metadata_callbacks as consumers,
    audio_announcer_pending_service as pending, audio_replay_packet95 as packet95,
    audio_replay_service_receive as receive,
};

impl<N: startup::Network + Send + 'static> pending::PendingBoundary for Backend<N> {
    fn allocate_engine(&mut self, bytes: u32) -> Result<u32, &'static str> {
        engine::Boundary::allocate_engine(self, bytes)
    }
    fn allocate_pointer_array(&mut self, words: u32) -> Result<u32, &'static str> {
        let bytes = words.checked_mul(4).ok_or("listener array overflow")?;
        engine::Boundary::allocate_engine(self, bytes)
    }
    fn remove_active_listener(&mut self, registry: u32, field: u32) -> Result<(), &'static str> {
        active::remove_active(self, registry, field)
            .map_err(|e| self.failure(e, "active listener removal failed"))
    }
}
impl<N: startup::Network + Send + 'static> consumers::ConsumerBoundary for Backend<N> {
    fn byte(&mut self, p: u32) -> Result<u8, read::Error> {
        self.shared
            .bank
            .lock()
            .map_err(|_| read::Error::InvalidLayout)?
            .memory
            .read_byte(p)
    }
    fn service_gate(&mut self, service: u32, target: u32) -> Result<u32, &'static str> {
        if target != 0x718ad0 {
            return Err("unknown native service gate");
        }
        let p = service.checked_add(0x122).ok_or("service gate overflow")?;
        consumers::ConsumerBoundary::byte(self, p)
            .map(u32::from)
            .map_err(|e| self.failure(e, "missing service gate"))
    }
    fn actor_call(&mut self, actor: u32, target: u32) -> Result<(), &'static str> {
        Err(self.failure(
            (actor, target),
            "native metadata actor method is not connected",
        ))
    }
    fn diagnostic(&mut self, args: [u32; 5]) -> Result<(), &'static str> {
        Err(self.failure(args, "native metadata diagnostic is not connected"))
    }
}
impl<N: startup::Network + Send + 'static> receive::Boundary for Backend<N> {
    fn packet_fallback(
        &mut self,
        event: u16,
        packet: u32,
        _context: u32,
    ) -> Result<u8, callbacks::Error> {
        let target = receive::packet_target(self, event)?;
        match target {
            receive::PACKET_DEFAULT => Ok(0),
            // Original588290's event0x5F fallback calls5F9FF0, discards the
            // service+B0 getter result, then returnsAL1. No payload is read.
            // Earlier72B2F0 listener interception retains its existing priority.
            0x58bb2e => {
                let service = self.word(callbacks::SERVICE_GLOBAL)?;
                let table = self.word(service)?;
                let slot = table.checked_add(0xb0).ok_or(callbacks::Error::AddressOverflow)?;
                let method = self.word(slot)?;
                let _ignored = consumers::ConsumerBoundary::service_gate(self, service, method)
                    .map_err(callbacks::Error::Boundary)?;
                Ok(1)
            },
            0x58a6f2 => self
                .event_temporary(8, |b, s| {
                    packet95::consume_packet(b, packet, s)
                        .map_err(|e| b.failure(e, "packet95 delivery failed"))
                })
                .map_err(callbacks::Error::Boundary),
            _ => Err(callbacks::Error::UnknownCallback(target)),
        }
    }
}
impl<N: startup::Network + Send + 'static> packet95::Boundary for Backend<N> {
    fn receive_payload(
        &mut self,
        recipient: u32,
        target: u32,
        payload: u32,
    ) -> Result<(), &'static str> {
        self.receive_loading_payload(recipient, target, payload)
    }
}

impl<N: startup::Network + Send + 'static> Backend<N> {
    /// Host extent check, before source72B2F0 can publish context or allocate.
    /// The source port itself retains its original unchecked pointer contract.
    pub(super) fn preflight_service_packet(
        &mut self,
        service: u32,
        packet: &[u8],
    ) -> Result<(), String> {
        let first = *packet.first().ok_or("empty service packet")?;
        let event = if first == 0xfe {
            let bytes = packet
                .get(5..7)
                .ok_or("truncated extended service header")?;
            u16::from_le_bytes(bytes.try_into().unwrap())
        } else {
            first as u16
        };
        if event == 0xdd {
            return Ok(());
        }
        let enabled = consumers::ConsumerBoundary::byte(self, service + 0x184)
            .map_err(|e| format!("service state:{e:?}"))?;
        if enabled == 0 && !matches!(event, 0x88 | 0x92 | 0x54 | 0x95 | 0xc6) {
            return Ok(());
        }
        if packet.len() < 5 {
            return Err("truncated service packet owner".into());
        }
        if event == 0x95 {
            self.preflight_loading_packet(packet)?;
        }
        // These connected owner-listener consumers read payload.
        if matches!(event, 0xe0 | 0xe1) && packet.len() < 6 {
            return Err("truncated owner metadata bit packet".into());
        }
        Ok(())
    }
}

impl<N: startup::Network + Send + 'static> Runtime<N> {
    /// Fresh configured-service contract, called by the final client probe.
    /// Filtered packets and DD acknowledgements are not simulation actions.
    pub(super) fn probe_service_packet_ingress(&self) -> Result<serde_json::Value, String> {
        let service = self
            .shared
            .service
            .lock()
            .unwrap()
            .as_ref()
            .ok_or("service is not initialized")?
            .pointer;
        let mut b = Backend::new(self.shared.clone());
        if consumers::ConsumerBoundary::byte(&mut b, service + 0x184)
            .map_err(|e| format!("service mode:{e:?}"))?
            != 0
        {
            return Err("fresh-service packet probe requires initial mode".into());
        }
        let context = b
            .word(service + 0x5c)
            .map_err(|e| format!("service context:{e:?}"))?;
        let mut accepted = 0;
        for subtype in [2, 3, 4] {
            for packet in [
                vec![0xdd],
                vec![0x51],
                vec![0xfe, 0, 0, 0, 0, 0xdd, 0],
                vec![0xfe, 0, 0, 0, 0, 0x51, 0],
            ] {
                if self.receive_game_event(0, 3, subtype, 0xdeadbeef, &packet)? != 1 {
                    return Err("parent packet result differs".into());
                }
                accepted += 1;
            }
        }
        let mut rejected = 0;
        for packet in [
            vec![],
            vec![0xfe],
            vec![0xfe, 0, 0, 0, 0, 0xdd],
            vec![0x95],
            vec![0x88, 0, 0, 0],
        ] {
            if self.receive_game_event(0, 3, 2, 77, &packet).is_ok() {
                return Err("truncated service packet accepted".into());
            }
            rejected += 1;
        }
        if b.word(service + 0x5c)
            .map_err(|e| format!("service context:{e:?}"))?
            != context
        {
            return Err("filtered packet changed service context".into());
        }
        if b.word(packet95::GLOBAL_PAIR)
            .map_err(|e| format!("packet95 owner:{e:?}"))?
            != 0
        {
            return Err("fresh-service packet probe requires empty packet95 receiver".into());
        }
        let local = b
            .word(receive::LOCAL_OWNER)
            .map_err(|e| format!("local owner:{e:?}"))?;
        let mut packet95_count = 0;
        for extended in [false, true] {
            for owner in [local, local.wrapping_add(1)] {
                let mut packet = vec![if extended { 0xfe } else { 0x95 }];
                packet.extend(owner.to_le_bytes());
                if extended {
                    packet.extend([0x95, 0]);
                }
                if self.receive_game_event(0, 3, 2, 123, &packet)? != 1 {
                    return Err("packet95 parent return differs".into());
                }
                packet95_count += 1;
            }
        }
        if b.word(service + 0x5c)
            .map_err(|e| format!("service context:{e:?}"))?
            != 123
        {
            return Err("packet95 context differs".into());
        }
        Ok(
            serde_json::json!({"passed":true,"parent_callback_connected":true,"filtered_or_dd_packets":accepted,"truncated_packets_rejected":rejected,"filtered_context_unchanged":true,"packet95_empty_receiver_packets":packet95_count,"gameplay_actions":0,"network_decoder_connected":false,"complete":false}),
        )
    }
}

#[cfg(test)]
#[path = "audio_replay_windows_receive_tests.rs"]
mod tests;
