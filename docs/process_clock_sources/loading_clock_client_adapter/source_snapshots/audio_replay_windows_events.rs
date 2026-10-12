//! Real replay event consumers in the application's canonical Windows bank.
use super::*;
use crate::{
    audio_replay_callbacks as cb, audio_replay_events as events, audio_replay_metadata as metadata,
    audio_replay_metadata_state as state, audio_replay_metadata_text as text,
    audio_replay_service_events as service_events,
};

impl<N: startup::Network + Send + 'static> Backend<N> {
    pub(super) fn event_temporary<T>(
        &mut self,
        bytes: u32,
        f: impl FnOnce(&mut Self, u32) -> Result<T, &'static str>,
    ) -> Result<T, &'static str> {
        let size = bytes
            .checked_next_power_of_two()
            .ok_or("event scratch size overflow")?;
        let p = {
            let mut bank = self.shared.bank.lock().map_err(|_| "event bank poisoned")?;
            let reused = bank.event_scratch.get_mut(&size).and_then(Vec::pop);
            let p = reused.unwrap_or(bank.next_scratch);
            let next = if reused.is_none() {
                Some(
                    p.checked_add(size)
                        .and_then(|v| v.checked_add(63))
                        .map(|v| v & !63)
                        .ok_or("event scratch address exhausted")?,
                )
            } else {
                None
            };
            if bank.memory.reserve_at(p, size).is_err() {
                if reused.is_some() {
                    bank.event_scratch.entry(size).or_default().push(p);
                }
                return Err("event scratch reservation failed");
            }
            if let Some(next) = next {
                bank.next_scratch = next;
            }
            p
        };
        let result = f(self, p);
        let cleanup = {
            let mut bank = self.shared.bank.lock().unwrap();
            let result = bank.memory.release(p);
            if result.is_ok() {
                // Ephemeral borrowed argument storage is not an engine allocation.
                // Discard only its release record, atomically with release itself.
                assert_eq!(bank.memory.released_labels.pop(), Some(p));
                bank.event_scratch.entry(size).or_default().push(p);
            }
            result
        };
        match (result, cleanup) {
            (Ok(v), Ok(())) => Ok(v),
            (Err(e), Ok(())) => Err(e),
            (_, Err(e)) => Err(self.failure(e, "event scratch cleanup failed")),
        }
    }
    pub(super) fn event_reference(&mut self, p: u32, value: u32) -> Result<(), &'static str> {
        Storage::write_word(self, p, value)
            .map_err(|e| self.failure(e, "event reference write failed"))
    }
    fn event_text(
        &mut self,
        p: u32,
        key: u32,
        index: u32,
        value: &[u8],
        extra: Option<u32>,
    ) -> Result<u32, &'static str> {
        let len = u32::try_from(value.len()).map_err(|_| "replay text too long")?;
        let capacity = if len < 16 { 15 } else { len | 15 };
        let bytes = capacity
            .checked_add(1)
            .and_then(|v| v.checked_add(88))
            .ok_or("replay text temporary overflow")?;
        self.event_temporary(bytes, |b, s| {
            let chars = if len < 16 { s } else { s + 88 };
            if len >= 16 {
                b.event_reference(s, chars)?;
            }
            b.event_reference(s + 16, len)?;
            b.event_reference(s + 20, capacity)?;
            for (i, v) in value.iter().copied().chain(std::iter::once(0)).enumerate() {
                Storage::write_byte(b, chars + i as u32, v)
                    .map_err(|e| b.failure(e, "event text write failed"))?;
            }
            let result = if let Some(extra) = extra {
                text::put_string_extra(b, p, key, index, s, extra, s + 24)
            } else {
                text::put_string(b, p, key, index, s, s + 24)
            };
            result
                .map(|()| 0)
                .map_err(|e| b.failure(e, "replay text setter failed"))
        })
    }
}
impl<N: startup::Network + Send + 'static> cb::InvocationBoundary for Backend<N> {
    fn member_two(
        &mut self,
        owner: u32,
        member: u32,
        first: u32,
        second: u32,
    ) -> Result<u32, &'static str> {
        if member == 0x738a3a {
            return self.event_temporary(24, |b, s| {
                crate::audio_replay_service_receive::invoke_virtual(b, owner, first, second, s)
                    .map(u32::from)
                    .map_err(|e| b.failure(e, "service packet consumer failed"))
            });
        }
        if member != 0x72b950 {
            return Err("replay two-word member consumer is not connected");
        }
        // This concrete consumer's C++ return type is bool: only AL is defined.
        self.event_temporary(8, |b, p| {
            service_events::notify(b, owner, first, second, p)
                .map(u32::from)
                .map_err(|e| b.failure(e, "service replay notification failed"))
        })
    }
}
impl<N: startup::Network + Send + 'static> events::Boundary for Backend<N> {
    fn byte(&mut self, p: u32) -> Result<u8, read::Error> {
        metadata::Boundary::read_byte(self, p)
    }
    fn member_call(
        &mut self,
        owner: u32,
        member: u32,
        args: [u32; 5],
    ) -> Result<u32, &'static str> {
        match member {
            0x729370 => events::dispatch(self, owner, args)
                .map(u32::from)
                .map_err(|e| self.failure(e, "parent replay event failed")),
            _ => Err("replay five-word member consumer is not connected"),
        }
    }
    fn virtual_call(
        &mut self,
        p: u32,
        member: u32,
        slot: u32,
        args: &[events::Argument],
    ) -> Result<u32, &'static str> {
        use events::Argument::{String as S, Word as W, WordRef as R};
        match (slot, member, args) {
            (8, 0x7341d0, [W(first), R(second)]) => self.event_temporary(4, |b, s| {
                b.event_reference(s, *second)?;
                cb::invoke7341d0(b, p, *first, s)
                    .map_err(|e| b.failure(e, "replay two-word wrapper failed"))
            }),
            (8, 0x65e9e0, [W(first), W(second)]) => cb::invoke65e9e0(self, p, *first, *second)
                .map_err(|e| self.failure(e, "replay value wrapper failed")),
            (8, 0x733f70, []) => cb::invoke733f70(self, p)
                .map_err(|e| self.failure(e, "replay empty wrapper failed")),
            (8, 0x734080, [R(first), R(second), W(third), W(fourth), W(fifth), W(sixth)]) => self
                .event_temporary(8, |b, s| {
                    b.event_reference(s, *first)?;
                    b.event_reference(s + 4, *second)?;
                    cb::invoke734080(
                        b,
                        p,
                        cb::SixArguments {
                            first_ref: s,
                            second_ref: s + 4,
                            third: *third,
                            fourth: *fourth,
                            fifth: *fifth,
                            sixth: *sixth,
                        },
                    )
                    .map_err(|e| b.failure(e, "replay six-word wrapper failed"))
                }),
            (8, 0x5cceb0 | 0x734130, [R(first), W(a), W(c), W(d), W(e)]) => {
                self.event_temporary(4, |b, s| {
                    b.event_reference(s, *first)?;
                    let args = [s, *a, *c, *d, *e];
                    if member == 0x5cceb0 {
                        cb::invoke12(b, p, args)
                            .map_err(|e| b.failure(e, "replay twelve-byte wrapper failed"))
                    } else {
                        events::invoke(b, p, args)
                            .map_err(|e| b.failure(e, "replay sixteen-byte wrapper failed"))
                    }
                })
            }
            (8, 0x728150, [W(id), W(count)]) => metadata::set_count(self, p, *id, *count)
                .map(u32::from)
                .map_err(|e| self.failure(e, "replay count setter failed")),
            (12, 0x7281c0, [W(id), W(selector)]) => metadata::get_count(self, p, *id, *selector)
                .map_err(|e| self.failure(e, "replay count getter failed")),
            (0x5c, 0x728a60, [W(key)]) => state::mark2(self, p, *key)
                .map_err(|e| self.failure(e, "replay state update failed")),
            (0x28, 0x7285b0, [W(key), W(index), S(value), W(extra)]) => {
                self.event_text(p, *key, *index, value, Some(*extra))
            }
            (0x3c, 0x728830, [W(key), W(index), S(value)]) => {
                self.event_text(p, *key, *index, value, None)
            }
            _ => Err("replay virtual method or argument signature is not connected"),
        }
    }
}
#[cfg(test)]
#[path = "audio_replay_windows_events_tests.rs"]
mod tests;

impl<N: startup::Network + Send + 'static> Runtime<N> {
    /// Diagnostic uses the same ingress and consumers as a decoded stream event.
    /// It verifies application-owned state, without fixture-driven consumers.
    pub fn probe_game_event_consumers(&self) -> Result<serde_json::Value, String> {
        self.initialize_game_manager()?;
        for key in [0, 7, u32::MAX, 7] {
            self.receive_game_event(0, 5, 0, key, &[])?;
        }
        let before = {
            let bank = self.shared.bank.lock().unwrap();
            (
                bank.next_scratch,
                bank.memory.released_labels.len(),
                bank.owned.len(),
            )
        };
        for _ in 0..4096 {
            self.receive_game_event(0, 5, 0, 7, &[])?;
        }
        let after = {
            let bank = self.shared.bank.lock().unwrap();
            (
                bank.next_scratch,
                bank.memory.released_labels.len(),
                bank.owned.len(),
            )
        };
        if before != after {
            return Err("replay event scratch grew during fixed notification stream".into());
        }
        let mut packet = vec![0u8; 0x191];
        packet[0] = 103;
        for (o, v) in [
            (1, 2u32),
            (5, 1),
            (9, 17),
            (13, 19),
            (17, 23),
            (21, 29),
            (0xc9, 31),
            (0xcd, 37),
            (0x189, 41),
            (0x18d, 43),
        ] {
            packet[o..o + 4].copy_from_slice(&v.to_le_bytes());
        }
        self.receive_game_event(0, 3, 7, 0, &packet)?;
        let value = b"restored-native-replay-metadata";
        for opcode in [101, 102] {
            let mut packet = vec![0; 0x11 + value.len() + 1];
            packet[0] = opcode;
            packet[1..5].copy_from_slice(&7u32.to_le_bytes());
            packet[5..9].copy_from_slice(&u32::MAX.to_le_bytes());
            packet[9..13].copy_from_slice(&123u32.to_le_bytes());
            packet[0x11..0x11 + value.len()].copy_from_slice(value);
            self.receive_game_event(0, 3, 7, 0, &packet)?;
        }
        self.receive_game_event(0, 3, 5, 0, &[0; 0x56])?;
        let s = self
            .game_manager_snapshot()?
            .ok_or("missing game manager")?;
        let mut b = Backend::new(self.shared.clone());
        let mut word = |o| {
            b.word(s.metadata[0] + o)
                .map_err(|e| format!("metadata snapshot: {e:?}"))
        };
        let counts = [word(0x1a0)?, word(0x1a4)?, word(0x1a8)?, word(0x1ac)?];
        let samples = [
            word(0x20)?,
            word(0x24)?,
            word(0x28)?,
            word(0x2c)?,
            word(0xe0)?,
            word(0xe4)?,
        ];
        if counts != [2, 1, 41, 43]
            || samples != [17, 19, 23, 29, 31, 37]
            || s.metadata_references != 1
        {
            return Err("metadata counters, arrays or references differ".into());
        }
        let mut texts = Vec::new();
        for offset in [8, 16] {
            let head = b
                .word(s.metadata[0] + offset)
                .map_err(|e| format!("text tree:{e:?}"))?;
            let node = b.word(head + 4).map_err(|e| format!("text root:{e:?}"))?;
            let raw = b
                .word(node + 24)
                .map_err(|e| format!("text pointer:{e:?}"))?;
            let len = b
                .word(node + 40)
                .map_err(|e| format!("text length:{e:?}"))?;
            let actual = (0..len)
                .map(|i| metadata::Boundary::read_byte(&mut b, raw + i))
                .collect::<Result<Vec<_>, _>>()
                .map_err(|e| format!("text bytes:{e:?}"))?;
            if actual != value {
                return Err("metadata text differs".into());
            }
            texts.push(String::from_utf8(actual).map_err(|e| e.to_string())?);
        }
        let mut states = BTreeMap::new();
        let head = b
            .word(s.metadata[0] + 24)
            .map_err(|e| format!("state tree:{e:?}"))?;
        let mut pending = vec![b.word(head + 4).map_err(|e| format!("state root:{e:?}"))?];
        let mut visited = BTreeSet::new();
        while let Some(node) = pending.pop() {
            if metadata::Boundary::read_byte(&mut b, node + 13)
                .map_err(|e| format!("state sentinel:{e:?}"))?
                != 0
            {
                continue;
            }
            if !visited.insert(node) {
                return Err("cycle in replay state tree".into());
            }
            let key = b.word(node + 16).map_err(|e| format!("state key:{e:?}"))?;
            let value = b
                .word(node + 20)
                .map_err(|e| format!("state value:{e:?}"))?;
            if states.insert(key, value).is_some() {
                return Err("duplicate state key".into());
            }
            for offset in [0, 8] {
                pending.push(
                    b.word(node + offset)
                        .map_err(|e| format!("state child:{e:?}"))?,
                );
            }
        }
        if states != [(0, 2), (7, 2), (u32::MAX, 2)].into_iter().collect()
            || b.word(s.metadata[0] + 28)
                .map_err(|e| format!("state count:{e:?}"))?
                != 3
        {
            return Err("notification states differ".into());
        }
        let service_packets = self.probe_service_packet_ingress()?;
        self.close_game_manager()?;
        Ok(
            serde_json::json!({"service_packets":service_packets,"passed":true,"notifications":4100,"array_frames":1,"text_frames":2,"six_argument_callbacks":1,"counts":counts,"samples":samples,"texts":texts,"states":states,"metadata_references":s.metadata_references,"scratch_bounded":true,"decoded_event_ingress":true,"network_decoder_connected":false,"complete":false}),
        )
    }
    /// Delivers a decoded event to native729370. The packet decoder/network
    /// producer must provide the native five-word event contract. Unknown
    /// consumers fail explicitly; this API does not establish a network session.
    pub fn receive_game_event(
        &self,
        first: u32,
        selector: u32,
        subtype: u32,
        context: u32,
        packet: &[u8],
    ) -> Result<u8, String> {
        let closed = self
            .shared
            .launch
            .lock()
            .map_err(|_| "launch lock poisoned")?;
        if *closed {
            return Err("transport runtime is shut down".into());
        }
        let parent = self
            .shared
            .game_manager
            .lock()
            .unwrap()
            .as_ref()
            .ok_or("game manager is not initialized")?
            .pointer;
        if selector as u8 == 3 {
            let required = match subtype as u8 {
                5 => 14,
                6 => 7,
                7 => 1,
                _ => 0,
            };
            if packet.len() < required {
                return Err("truncated replay event packet".into());
            }
            if subtype as u8 == 7 && matches!(packet.first(), Some(101 | 102)) {
                if packet.len() < 18 || !packet[17..].contains(&0) {
                    return Err("truncated or unterminated replay text packet".into());
                }
            }
        }
        // The100-profile native audit proves that source729D70 can overwrite
        // its own loop bounds with counts25..48 and then cross allocation512.
        // The low-level port preserves native semantics; ingress rejects these
        // malformed array lengths before any metadata state is changed.
        if selector as u8 == 3 && subtype as u8 == 7 && packet.first() == Some(&103) {
            if packet.len() < 0x191 {
                return Err("truncated replay metadata packet".into());
            }
            for o in [1, 5] {
                if u32::from_le_bytes(packet[o..o + 4].try_into().unwrap()) > 24 {
                    return Err(
                        "replay metadata packet exceeds the qualified24-entry arrays".into(),
                    );
                }
            }
        }
        let mut b = Backend::new(self.shared.clone());
        if selector as u8 == 3 && matches!(subtype as u8, 2..=4) {
            let service = self
                .shared
                .service
                .lock()
                .unwrap()
                .as_ref()
                .ok_or("service is not initialized")?
                .pointer;
            b.preflight_service_packet(service, packet)?;
        }
        let bytes = u32::try_from(packet.len())
            .ok()
            .and_then(|n| n.checked_add(4))
            .ok_or("replay event too large")?;
        b.event_temporary(bytes, |b, p| {
            b.event_reference(p, first)?;
            for (i, v) in packet.iter().enumerate() {
                Storage::write_byte(b, p + 4 + i as u32, *v)
                    .map_err(|e| b.failure(e, "event packet write failed"))?;
            }
            events::dispatch(b, parent, [first, selector, subtype, context, p + 4])
                .map_err(|e| b.failure(e, "game event delivery failed"))
        })
        .map_err(str::to_string)
    }
}
