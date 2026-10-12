use super::*;
use crate::{audio_announcer_object_lookup::Memory, audio_replay_logger as logger};
use serde_json::{json, Value};
use std::collections::{BTreeSet, VecDeque};
fn n(v: &Value) -> u32 {
    v.as_u64().unwrap().try_into().unwrap()
}
fn bytes(s: &str) -> Vec<u8> {
    s.as_bytes()
        .chunks_exact(2)
        .map(|v| u8::from_str_radix(std::str::from_utf8(v).unwrap(), 16).unwrap())
        .collect()
}
fn selected(v: &Value) -> bool {
    matches!(n(&v["bytes"]), 8 | 12 | 224 | 0x918 | 0x1058)
}
struct Host {
    memory: init::OwnedMemory,
    queue: VecDeque<Value>,
    allocations: Vec<Value>,
    labels: BTreeSet<u32>,
    locks: BTreeSet<u32>,
    held: Vec<u32>,
    startup_error: u32,
    network: Vec<Value>,
    logs: Vec<Value>,
    lifecycle: Vec<&'static str>,
    clock: u32,
    fail_log: bool,
    all_allocations: bool,
    cleanup: Option<Value>,
    cleanup_events: Vec<Value>,
}
impl Host {
    fn new(fill: u8) -> Self {
        let mut b = Self {
            memory: init::OwnedMemory::new(0x39000000, fill),
            queue: VecDeque::new(),
            allocations: vec![],
            labels: BTreeSet::new(),
            locks: BTreeSet::new(),
            held: vec![],
            startup_error: 0,
            network: vec![],
            logs: vec![],
            lifecycle: vec![],
            clock: 123456,
            fail_log: false,
            all_allocations: false,
            cleanup: None,
            cleanup_events: vec![],
        };
        for (p, len) in [
            (startup::MUTEX, 32),
            (0x2d78ec0, 0x5c),
            (startup::ALLOCATOR, 8),
            (VTABLE, 8),
            (callback::HANDLER_VTABLE, 12),
            (logger::BUFFER, 2560),
            (UID_SCRATCH, 144),
            (0x14bef40, 8),
        ] {
            b.memory.reserve_at(p, len).unwrap();
        }
        for (p, v) in [
            (startup::STATUS, 0),
            (startup::REFERENCES, 0),
            (logger::POINTER, 0),
            (CLOCK_BASE, 0xdeadbeef),
            (VTABLE, CLOSE),
            (VTABLE + 4, SCALAR_DELETE),
            (callback::HANDLER_VTABLE, callback::HANDLER_DELETE),
            (callback::HANDLER_VTABLE + 4, callback::HANDLER_CLONE),
            (callback::HANDLER_VTABLE + 8, logger::INVOKE),
            (0x14bef40, 0),
            (0x14bef44, 0),
        ] {
            Storage::write_word(&mut b, p, v).unwrap();
        }
        b.write_byte(logger::REINITIALIZE, 0).unwrap();
        b.write_byte(logger::REGISTERED, 0).unwrap();
        b
    }
    fn alloc(&mut self, len: u32, engine: bool) -> Result<u32, init::Error> {
        let v = if let Some(v) = self.queue.pop_front() {
            assert_eq!(n(&v["bytes"]), len, "allocator next {v}");
            assert_eq!(v["allocator"] == "engine_operator_new", engine);
            self.memory.reserve_at(n(&v["pointer"]), len)?;
            v
        } else {
            let p = self.memory.allocate(len)?;
            if engine {
                json!({"bytes":len,"pointer":p,"allocator":"engine_operator_new"})
            } else {
                json!({"bytes":len,"pointer":p})
            }
        };
        let p = n(&v["pointer"]);
        self.labels.extend((0..len).step_by(4).map(|o| p + o));
        self.allocations.push(v);
        Ok(p)
    }
    fn callback(&mut self, owner: u32, method: u32) -> u32 {
        let p = self.alloc(12, false).unwrap();
        for (o, v) in [(0, callback::HANDLER_VTABLE), (4, owner), (8, method)] {
            Storage::write_word(self, p + o, v).unwrap();
        }
        p
    }
    fn raw(&self, p: u32, len: u32) -> Vec<u8> {
        (0..len)
            .map(|i| self.memory.read_byte(p + i).unwrap())
            .collect()
    }
    fn compare(&mut self, s: &Value) {
        assert_eq!(
            json!(self.allocations),
            json!(s["allocations"]
                .as_array()
                .unwrap()
                .iter()
                .filter(|v| self.all_allocations || selected(v))
                .collect::<Vec<_>>())
        );
        self.allocations.clear();
        let free: Vec<u32> = s["freed"]
            .as_array()
            .unwrap()
            .iter()
            .map(n)
            .filter(|p| self.labels.contains(p))
            .collect();
        assert_eq!(self.memory.released_labels, free);
        self.memory.released_labels.clear();
        for w in s["words"].as_array().unwrap() {
            let p = n(&w[0]);
            if self.labels.contains(&p) {
                assert_eq!(self.word(p).unwrap(), n(&w[1]), "word {p:08x}");
            }
        }
        assert!(self.held.is_empty());
    }
    fn extended(&mut self, s: &Value) {
        self.compare(&s["snapshot"]);
        assert_eq!(
            self.raw(UID_SCRATCH, 128),
            bytes(s["uid_scratch_hex"].as_str().unwrap())
        );
        assert_eq!(
            self.raw(UID_SCRATCH + 128, 16),
            bytes(s["validation_scratch_hex"].as_str().unwrap())
        );
        assert_eq!(self.word(CLOCK_BASE).unwrap(), n(&s["clock"]));
        assert_eq!(json!(self.logs), s["logs"]);
        self.logs.clear();
        self.globals(&s["global_state"]);
    }
    fn globals(&mut self, s: &Value) {
        for (p, v) in s.as_object().unwrap() {
            assert_eq!(
                self.word(u32::from_str_radix(p.trim_start_matches("0x"), 16).unwrap())
                    .unwrap(),
                n(v),
                "{p}"
            );
        }
    }
}
impl Memory for Host {
    fn word(&mut self, p: u32) -> Result<u32, read::Error> {
        self.memory.word(p)
    }
}
impl Storage for Host {
    fn allocate(&mut self, n: u32) -> Result<u32, init::Error> {
        self.alloc(n, false)
    }
    fn write_word(&mut self, p: u32, v: u32) -> Result<(), init::Error> {
        Storage::write_word(&mut self.memory, p, v)
    }
    fn write_byte(&mut self, p: u32, v: u8) -> Result<(), init::Error> {
        self.memory.write_byte(p, v)
    }
    fn register_shutdown(&mut self, p: u32) -> Result<(), init::Error> {
        self.memory.register_shutdown(p)
    }
}
impl remove::Backend for Host {
    fn write_word(&mut self, p: u32, v: u32) -> Result<(), remove::Error> {
        Storage::write_word(self, p, v).map_err(remove::Error::Owned)
    }
    fn deallocator(&mut self) -> Result<remove::Deallocator, remove::Error> {
        Ok(remove::Deallocator::Standard)
    }
    fn free(&mut self, p: u32, _: remove::Deallocator) -> Result<(), remove::Error> {
        self.memory.release(p).map_err(remove::Error::Owned)
    }
}
impl callback::Boundaries for Host {
    fn allocate_callback_clone(&mut self, n: u32) -> Result<u32, &'static str> {
        self.alloc(n, true).map_err(|_| "clone allocation")
    }
    fn register_listener(
        &mut self,
        _: u32,
        _: u32,
        _: u32,
        _: &mut u32,
    ) -> Result<(), &'static str> {
        Err("no listener boundary")
    }
    fn unregister_listener(&mut self, _: u32, _: u32, _: u32) -> Result<(), &'static str> {
        Err("no listener boundary")
    }
}
impl logger::Boundary for Host {
    fn byte(&mut self, p: u32) -> Result<u8, &'static str> {
        Boundary::byte(self, p)
    }
    fn initialize_critical_section(&mut self, p: u32) -> Result<(), &'static str> {
        Boundary::initialize_critical_section(self, p)
    }
    fn delete_critical_section(&mut self, p: u32) -> Result<(), &'static str> {
        Boundary::delete_critical_section(self, p)
    }
}
impl logger::Output for Host {
    fn local_time(&mut self) -> Result<[u16; 8], &'static str> {
        Ok([2014, 11, 4, 20, 23, 59, 58, 999])
    }
    fn invoke_member(&mut self, owner: u32, member: u32, message: u32) -> Result<u8, &'static str> {
        if member == crate::audio_replay_recording_resource::MEMBER {
            return crate::audio_replay_recording_resource::message(self, owner, message)
                .map_err(|_| "resource message");
        }
        Err("unknown logger callback")
    }
}
impl startup::Network for Host {
    fn winsock_startup(&mut self, version: u16) -> Result<startup::Negotiation, startup::Error> {
        self.network
            .push(json!({"op":"WSAStartup","version":version}));
        Ok(startup::Negotiation {
            code: self.startup_error,
            version: 0x202,
        })
    }
    fn winsock_cleanup(&mut self) -> Result<u32, startup::Error> {
        self.network.push(json!({"op":"WSACleanup"}));
        Ok(0)
    }
    fn timer_begin(&mut self, period: u32) -> Result<u32, startup::Error> {
        self.network
            .push(json!({"op":"timeBeginPeriod","period":period}));
        Ok(0)
    }
    fn timer_end(&mut self, period: u32) -> Result<u32, startup::Error> {
        self.network
            .push(json!({"op":"timeEndPeriod","period":period}));
        Ok(0)
    }
}
impl startup::Backend for Host {
    fn read(&self, p: u32) -> Result<u32, startup::Error> {
        let mut word = [0; 4];
        for (i, b) in word.iter_mut().enumerate() {
            *b = self
                .memory
                .read_byte(p + i as u32)
                .map_err(|_| startup::Error::Boundary("missing word"))?;
        }
        Ok(u32::from_le_bytes(word))
    }
    fn write(&mut self, p: u32, v: u32) -> Result<(), startup::Error> {
        Storage::write_word(self, p, v).map_err(|_| startup::Error::Boundary("write"))
    }
    fn exchange(&mut self, p: u32, v: u32) -> Result<u32, startup::Error> {
        let old = self.read(p)?;
        self.write(p, v)?;
        Ok(old)
    }
    fn mutex(&mut self, p: u32, enter: bool) -> Result<(), startup::Error> {
        Boundary::mutex(self, p, enter).map_err(startup::Error::Boundary)
    }
    fn logger(&mut self) -> Result<u32, startup::Error> {
        Boundary::logger(self).map_err(startup::Error::Boundary)
    }
    fn log(&mut self, p: u32, message: &str) -> Result<(), startup::Error> {
        assert_eq!(p, logger::LOGGER);
        Boundary::log(self, message, None, 0).map_err(startup::Error::Boundary)
    }
}
impl address::Boundary for Host {
    fn validation_byte(&mut self, i: usize, v: u8) -> Result<(), &'static str> {
        self.write_byte(UID_SCRATCH + 128 + i as u32, v)
            .map_err(|_| "validation scratch")
    }
    fn inet_addr(&mut self, text: &[u8]) -> Result<u32, &'static str> {
        let ip = std::str::from_utf8(text)
            .map_err(|_| "non-ascii numeric profile")?
            .parse::<std::net::Ipv4Addr>()
            .map_err(|_| "unsupported numeric profile")?;
        Ok(u32::from_le_bytes(ip.octets()))
    }
    fn localhost(&mut self) -> Result<u32, &'static str> {
        Err("no localhost profile")
    }
    fn passive_lookup(&mut self, _: &[u8]) -> Result<address::Lookup, &'static str> {
        Ok(address::Lookup {
            code: 11001,
            records: vec![],
        })
    }
    fn address_to_string(
        &mut self,
        s: &[u8; 16],
        out: &mut [u8],
        capacity: &mut u32,
    ) -> Result<u32, &'static str> {
        assert_eq!(&s[..4], &[2, 0, 0, 0]);
        let text = std::net::Ipv4Addr::new(s[4], s[5], s[6], s[7]).to_string();
        assert!(text.len() + 1 <= *capacity as usize);
        out[..text.len()].copy_from_slice(text.as_bytes());
        out[text.len()] = 0;
        *capacity = text.len() as u32 + 1;
        Ok(0)
    }
}
impl Boundary for Host {
    fn close_derived_transport(&mut self, p: u32) -> Result<(), &'static str> {
        crate::audio_replay_stream_transport::close(self, p).map_err(|_| "derived close failed")
    }
    fn byte(&mut self, p: u32) -> Result<u8, &'static str> {
        self.memory.read_byte(p).map_err(|_| "missing byte")
    }
    fn initialize_critical_section(&mut self, p: u32) -> Result<(), &'static str> {
        assert!(self.locks.insert(p));
        for i in 0..24 {
            self.write_byte(p + i, 0).unwrap();
        }
        Ok(())
    }
    fn delete_critical_section(&mut self, p: u32) -> Result<(), &'static str> {
        assert!(self.locks.remove(&p));
        Ok(())
    }
    fn mutex(&mut self, p: u32, enter: bool) -> Result<(), &'static str> {
        if enter {
            self.held.push(p);
        } else {
            assert_eq!(self.held.pop(), Some(p));
        }
        Ok(())
    }
    // Deliberately synchronous worker boundary; native thread/CRT allocation scope
    // is qualified independently by the Windows runtime, not replayed here.
    fn initialize_transport(&mut self) -> Result<u8, &'static str> {
        self.lifecycle.push("initialize");
        startup::worker(self).map_err(|_| "worker failed")?;
        Ok(1)
    }
    fn drain_transport(&mut self) -> Result<(), &'static str> {
        self.lifecycle.push("drain");
        Ok(())
    }
    fn release_transport(&mut self) -> Result<(), &'static str> {
        self.lifecycle.push("release");
        startup::release(self).map_err(|_| "release failed")
    }
    fn milliseconds(&mut self) -> Result<u32, &'static str> {
        Ok(self.clock)
    }
    fn logger(&mut self) -> Result<u32, &'static str> {
        logger::initialize(self).map_err(|_| "logger initialization")
    }
    fn log(&mut self, message: &str, source: Option<&str>, line: u32) -> Result<(), &'static str> {
        assert_eq!(self.held.last(), Some(&logger::LOGGER));
        if self.fail_log {
            return Err("supplied logger failure");
        }
        self.logs
            .push(json!({"message":message,"source":source,"line":line}));
        logger::write_message(
            self,
            logger::LOGGER,
            message.as_bytes(),
            source.map(str::as_bytes),
            line,
        )
        .map_err(|_| "logger write")
    }
    fn address_frame(&mut self) -> Result<[u8; 16], &'static str> {
        Ok([0; 16])
    }
    fn packet_callback(&mut self, p: u32, method: u32) -> Result<(), &'static str> {
        let c = self.cleanup.clone().ok_or("no packet callback profile")?;
        assert_eq!(method, n(&c["callback"]));
        self.cleanup_events
            .push(json!({"op":"callback","packet":p,"method":method}));
        let flags = self.word(p + 4).unwrap();
        Storage::write_word(self, p + 4, flags ^ 4).unwrap();
        Storage::write_word(self, startup::DEALLOCATOR, n(&c["free_b"])).unwrap();
        Ok(())
    }
    fn packet_free(&mut self, p: u32, method: u32) -> Result<(), &'static str> {
        let c = self.cleanup.clone().ok_or("no packet pool profile")?;
        assert!(method == n(&c["free_a"]) || method == n(&c["free_b"]));
        self.cleanup_events
            .push(json!({"op":"free","pointer":p,"method":method}));
        Storage::write_word(
            self,
            startup::DEALLOCATOR,
            if method == n(&c["free_a"]) {
                n(&c["free_b"])
            } else {
                n(&c["free_a"])
            },
        )
        .unwrap();
        Ok(())
    }
    fn flush_host(&mut self, p: u32, output: u32, flags: u32) -> Result<(), &'static str> {
        let c = self.cleanup.clone().ok_or("no host flush profile")?;
        let time = self.word(p + 0x28).unwrap();
        self.cleanup_events
            .push(json!({"op":"flush","host":p,"output":output,"flags":flags,"time":time}));
        if c["mode"] != 0 {
            Storage::write_word(self, p + 0x20, n(&c["flush_peers"])).unwrap();
            Storage::write_word(self, p + 0x24, 2).unwrap();
        }
        Ok(())
    }
    fn reset_peer(&mut self, p: u32, reason: u32) -> Result<(), &'static str> {
        let c = self.cleanup.clone().ok_or("no peer reset profile")?;
        self.cleanup_events
            .push(json!({"op":"reset","peer":p,"reason":reason}));
        if c["mode"] != 0 {
            Storage::write_word(self, n(&c["host"]) + 0x20, n(&c["reset_peers"])).unwrap();
        }
        Ok(())
    }
    fn destroy_host(&mut self, _: u32) -> Result<(), &'static str> {
        Err("no host destruction profile")
    }
}
#[test]
fn audio_replay_configuration_matches60_native_null_callback_lifetimes_and_owned_words() {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_transport_configuration_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 60);
    for c in cases {
        let mut b = Host::new(n(&c["fill"]) as u8);
        b.startup_error = n(&c["supplied_wsa_startup_error"]);
        b.queue = ["constructed", "configured", "destroyed", "logger_shutdown"]
            .into_iter()
            .flat_map(|s| {
                c[s]["allocations"]
                    .as_array()
                    .unwrap()
                    .iter()
                    .filter(|v| selected(v))
                    .cloned()
            })
            .collect();
        let p = b.allocate(224).unwrap();
        assert_eq!(p, n(&c["object"]));
        construct(&mut b, p).unwrap();
        b.compare(&c["constructed"]);
        let host = c["host_hex"].as_str().map(bytes);
        assert_eq!(
            configure(
                &mut b,
                p,
                0,
                0x11223344,
                0x55667788,
                host.as_deref(),
                n(&c["port"])
            )
            .unwrap(),
            n(&c["return_code"])
        );
        b.compare(&c["configured"]);
        b.globals(&c["global_state_after_configuration"]);
        if b.word(startup::REFERENCES).unwrap() != 0 {
            close(&mut b, p).unwrap();
        }
        scalar_delete(&mut b, p, 1).unwrap();
        b.compare(&c["destroyed"]);
        logger::shutdown(&mut b).unwrap();
        b.compare(&c["logger_shutdown"]);
        assert_eq!(json!(b.network), c["network_events"]);
        assert!(b.queue.is_empty() && b.locks.is_empty());
    }
}
#[test]
fn audio_replay_configuration_matches32_native_callback_replacements_crc_collision_logs_and_cleanup(
) {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_configuration_ownership_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 32);
    for c in cases {
        let mut b = Host::new(n(&c["fill"]) as u8);
        b.startup_error = n(&c["startup_error"]);
        b.queue = ["prepared", "configured", "destroyed", "shutdown"]
            .into_iter()
            .flat_map(|s| {
                c[s]["snapshot"]["allocations"]
                    .as_array()
                    .unwrap()
                    .iter()
                    .filter(|v| selected(v))
                    .cloned()
            })
            .collect();
        let p = b.allocate(224).unwrap();
        assert_eq!(p, n(&c["object"]));
        construct(&mut b, p).unwrap();
        let old = if c["has_old"] == true {
            b.callback(0x41000000, 0x728e20)
        } else {
            0
        };
        assert_eq!(old, n(&c["old"]));
        Storage::write_word(&mut b, p + 0xdc, old).unwrap();
        let incoming = b.callback(0x42000000, 0x728fd0);
        assert_eq!(incoming, n(&c["incoming"]));
        b.extended(&c["prepared"]);
        let host = c["host_hex"].as_str().map(bytes);
        assert_eq!(
            configure(
                &mut b,
                p,
                incoming,
                0x11223344,
                0x55667788,
                host.as_deref(),
                n(&c["port"])
            )
            .unwrap(),
            n(&c["return_code"])
        );
        b.extended(&c["configured"]);
        if b.word(startup::REFERENCES).unwrap() != 0 {
            close(&mut b, p).unwrap();
        }
        scalar_delete(&mut b, p, 1).unwrap();
        b.extended(&c["destroyed"]);
        logger::shutdown(&mut b).unwrap();
        b.extended(&c["shutdown"]);
        assert_eq!(json!(b.network), c["network_events"]);
        assert!(b.queue.is_empty() && b.locks.is_empty());
    }
}
#[test]
fn audio_replay_configuration_explicit_log_failure_unlocks_and_consumes_incoming_callback() {
    let mut b = Host::new(165);
    let p = b.allocate(224).unwrap();
    construct(&mut b, p).unwrap();
    let incoming = b.callback(0x42000000, 0x728fd0);
    b.fail_log = true;
    assert_eq!(
        configure(&mut b, p, incoming, 1, 2, None, 12345),
        Err(Error::Boundary("supplied logger failure"))
    );
    assert!(b.held.is_empty());
    assert!(b.word(incoming).is_err());
    // Error propagation leaves the successful network reference owned for cleanup.
    assert_eq!(b.word(startup::REFERENCES).unwrap(), 1);
    b.fail_log = false;
    close(&mut b, p).unwrap();
    scalar_delete(&mut b, p, 1).unwrap();
    logger::shutdown(&mut b).unwrap();
    assert!(b.locks.is_empty());
}
#[test]
fn audio_replay_configuration_queue_matches24_native_wraparound_callback_and_deallocator_mutation_profiles(
) {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_transport_cleanup_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    let cases = proof["queues"].as_array().unwrap();
    assert_eq!(cases.len(), 24);
    for c in cases {
        let mut b = Host::new(n(&c["fill"]) as u8);
        b.all_allocations = true;
        b.cleanup = Some(c.clone());
        b.queue = c["prepared"]["allocations"]
            .as_array()
            .unwrap()
            .iter()
            .cloned()
            .collect();
        let p = b.allocate(224).unwrap();
        assert_eq!(p, n(&c["object"]));
        construct(&mut b, p).unwrap();
        let slots = b.allocate(16).unwrap();
        assert_eq!(slots, n(&c["slots"]));
        let blocks: Vec<u32> = (0..4).map(|_| b.allocate(20).unwrap()).collect();
        assert_eq!(json!(blocks), c["blocks"]);
        for (o, v) in [(0xac, slots), (0xb0, 4), (0xb4, n(&c["head"])), (0xb8, 3)] {
            Storage::write_word(&mut b, p + o, v).unwrap();
        }
        for (i, block) in blocks.iter().enumerate() {
            Storage::write_word(&mut b, slots + 4 * i as u32, *block).unwrap();
            for j in 0..5 {
                Storage::write_word(&mut b, *block + j * 4, 0).unwrap();
            }
        }
        for (i, input) in c["packets"].as_array().unwrap().iter().enumerate() {
            let packet = n(&input["pointer"]);
            b.memory.reserve_at(packet, 20).unwrap();
            for (j, v) in input["words"].as_array().unwrap().iter().enumerate() {
                Storage::write_word(&mut b, packet + j as u32 * 4, n(v)).unwrap();
            }
            let block = blocks[(n(&c["head"]).wrapping_add(i as u32) & 3) as usize];
            for (j, v) in [
                0x100 + i as u32,
                0x200 + i as u32,
                0x300 + i as u32,
                0x400 + i as u32,
                if c["mode"] == 0 { 0 } else { packet },
            ]
            .into_iter()
            .enumerate()
            {
                Storage::write_word(&mut b, block + j as u32 * 4, v).unwrap();
            }
        }
        Storage::write_word(&mut b, startup::DEALLOCATOR, n(&c["free_a"])).unwrap();
        b.compare(&c["prepared"]);
        reset_queue(&mut b, p).unwrap();
        b.compare(&c["reset"]);
        assert_eq!(json!(b.cleanup_events), c["packet_events"]);
        assert_eq!(
            b.word(startup::DEALLOCATOR).unwrap(),
            n(&c["final_deallocator"])
        );
        for (input, after) in c["packets"]
            .as_array()
            .unwrap()
            .iter()
            .zip(c["packet_bytes_after"].as_array().unwrap())
        {
            assert_eq!(
                b.raw(n(&input["pointer"]), 20),
                bytes(after.as_str().unwrap())
            );
        }
        scalar_delete(&mut b, p, 1).unwrap();
        b.compare(&c["destroyed"]);
        assert!(b.locks.is_empty() && b.queue.is_empty());
    }
}
#[test]
fn audio_replay_configuration_flush_matches8_native_elapsed_clock_and_peer_array_reread_profiles() {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_transport_cleanup_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    let cases = proof["hosts"].as_array().unwrap();
    assert_eq!(cases.len(), 8);
    for c in cases {
        let mut b = Host::new(n(&c["fill"]) as u8);
        b.all_allocations = true;
        b.cleanup = Some(c.clone());
        b.queue = c["prepared"]["allocations"]
            .as_array()
            .unwrap()
            .iter()
            .cloned()
            .collect();
        let p = b.allocate(224).unwrap();
        assert_eq!(p, n(&c["object"]));
        construct(&mut b, p).unwrap();
        let host = n(&c["host"]);
        b.memory.reserve_at(host, 48).unwrap();
        for (a, v) in [
            (p + 8, host),
            (host + 0x20, n(&c["initial_peers"])),
            (host + 0x24, 3),
            (CLOCK_BASE, n(&c["clock_base"])),
        ] {
            Storage::write_word(&mut b, a, v).unwrap();
        }
        b.compare(&c["prepared"]);
        flush(&mut b, p).unwrap();
        b.compare(&c["flushed"]);
        assert_eq!(json!(b.cleanup_events), c["events"]);
        assert_eq!(
            b.raw(host, 48),
            bytes(c["host_bytes_after"].as_str().unwrap())
        );
        scalar_delete(&mut b, p, 1).unwrap();
        b.compare(&c["destroyed"]);
        assert!(b.locks.is_empty() && b.queue.is_empty());
    }
}

include!("audio_replay_stream_transport_tests.rs");

include!("audio_replay_opening_tests.rs");

include!("audio_replay_game_manager_tests.rs");

include!("audio_replay_service_manager_tests.rs");
