use super::*;
use crate::audio_announcer_object_lookup::Memory;
use serde_json::{json, Value};
use std::collections::{BTreeSet, VecDeque};
struct Host {
    memory: init::OwnedMemory,
    queue: Option<VecDeque<Value>>,
    allocations: Vec<Value>,
    locks: BTreeSet<u32>,
    clock: [u16; 8],
    calls: Vec<(u32, u32, u32)>,
    output: Result<u8, &'static str>,
    file_events: Vec<Value>,
    file_profile: u32,
    write_result: i32,
    close_result: i32,
    held: BTreeSet<u32>,
}
fn n(v: &Value) -> u32 {
    v.as_u64().unwrap().try_into().unwrap()
}
fn bytes(s: &str) -> Vec<u8> {
    s.as_bytes()
        .chunks_exact(2)
        .map(|v| u8::from_str_radix(std::str::from_utf8(v).unwrap(), 16).unwrap())
        .collect()
}
impl Host {
    fn new(fill: u8) -> Self {
        let mut b = Self {
            memory: init::OwnedMemory::new(0x39000000, fill),
            queue: None,
            allocations: vec![],
            locks: BTreeSet::new(),
            clock: [2014, 11, 4, 20, 23, 59, 58, 999],
            calls: vec![],
            output: Ok(0),
            file_events: vec![], file_profile: 0, write_result: 0, close_result: 0, held: BTreeSet::new(),
        };
        for (p, len) in [
            (REINITIALIZE - 1, 8),
            (LOGGER, 36),
            (BUFFER, CAPACITY as u32),
            (callback::HANDLER_VTABLE, 12),
        ] {
            b.memory.reserve_at(p, len).unwrap();
        }
        for (p, v) in [
            (POINTER, 0),
            (callback::HANDLER_VTABLE, callback::HANDLER_DELETE),
            (callback::HANDLER_VTABLE + 4, callback::HANDLER_CLONE),
            (callback::HANDLER_VTABLE + 8, INVOKE),
        ] {
            Storage::write_word(&mut b, p, v).unwrap();
        }
        b.write_byte(REINITIALIZE, 0).unwrap();
        b.write_byte(REGISTERED, 0).unwrap();
        b
    }
    fn alloc(&mut self, len: u32, engine: bool) -> Result<u32, init::Error> {
        let allocation = if let Some(q) = self.queue.as_mut() {
            let v = q.pop_front().expect("unexpected logger allocation");
            assert_eq!(n(&v["bytes"]), len);
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
        let p = n(&allocation["pointer"]);
        self.allocations.push(allocation);
        Ok(p)
    }
    fn text(&self) -> Vec<u8> {
        (0..CAPACITY)
            .map(|i| self.memory.read_byte(BUFFER + i as u32).unwrap())
            .take_while(|b| *b != 0)
            .collect()
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
        self.alloc(n, true).map_err(|_| "clone allocation failed")
    }
    fn register_listener(
        &mut self,
        _: u32,
        _: u32,
        _: u32,
        _: &mut u32,
    ) -> Result<(), &'static str> {
        Err("logger has no listener")
    }
    fn unregister_listener(&mut self, _: u32, _: u32, _: u32) -> Result<(), &'static str> {
        Err("logger has no listener")
    }
}
impl Boundary for Host {
    fn byte(&mut self, p: u32) -> Result<u8, &'static str> {
        self.memory.read_byte(p).map_err(|_| "missing byte")
    }
    fn initialize_critical_section(&mut self, p: u32) -> Result<(), &'static str> {
        assert!(self.locks.insert(p));
        for i in 0..24 {
            self.memory.write_byte(p + i, 0).unwrap();
        }
        Ok(())
    }
    fn delete_critical_section(&mut self, p: u32) -> Result<(), &'static str> {
        assert!(self.locks.remove(&p));
        Ok(())
    }
}
impl Output for Host {
    fn local_time(&mut self) -> Result<[u16; 8], &'static str> {
        Ok(self.clock)
    }
    fn invoke_member(&mut self, owner: u32, member: u32, p: u32) -> Result<u8, &'static str> {
        if member == crate::audio_replay_recording_resource::MEMBER {
            return crate::audio_replay_recording_resource::message(self,owner,p).map_err(|_|"resource message failed");
        }
        self.calls.push((owner, member, p));
        if member==0x32008a00 {return self.word(owner).map(|v|v as u8).map_err(|_|"missing supplied callback return");}
        self.output
    }
}
#[test]
fn audio_replay_logger_matches16_native_lazy_replace_shutdown_reinitialize_lifetimes() {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_logger_lifetime_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    assert_eq!(proof["default_callback"]["bytes"], "b001c20400");
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 16);
    for c in cases {
        let mut b = Host::new(n(&c["fill"]) as u8);
        let steps = c["steps"].as_array().unwrap();
        let queue: VecDeque<Value> = steps
            .iter()
            .flat_map(|s| {
                s["state"]["allocations"]
                    .as_array()
                    .unwrap()
                    .iter()
                    .cloned()
            })
            .collect();
        let labels: BTreeSet<u32> = queue
            .iter()
            .flat_map(|a| [n(&a["pointer"]), n(&a["pointer"]) + 4, n(&a["pointer"]) + 8])
            .collect();
        b.queue = Some(queue);
        b.write_byte(REINITIALIZE, n(&c["initial_flags"][0]) as u8)
            .unwrap();
        b.write_byte(REGISTERED, n(&c["initial_flags"][1]) as u8)
            .unwrap();
        for s in steps {
            match s["action"].as_str().unwrap() {
                "initialize" | "initialize_again" | "reinitialize" => {
                    assert_eq!(initialize(&mut b).unwrap(), LOGGER);
                }
                "replace_callback" => replace_default(&mut b, LOGGER).unwrap(),
                "shutdown" | "shutdown_again" => shutdown(&mut b).unwrap(),
                _ => panic!("unknown action"),
            }
            assert_eq!(json!(b.allocations), s["state"]["allocations"]);
            b.allocations.clear();
            assert_eq!(json!(b.memory.released_labels), s["state"]["freed"]);
            b.memory.released_labels.clear();
            assert_eq!(b.word(POINTER).unwrap(), n(&s["logger_pointer"]));
            assert_eq!(
                json!([b.byte(REINITIALIZE).unwrap(), b.byte(REGISTERED).unwrap()]),
                s["flags"]
            );
            assert_eq!(
                json!(b.memory.shutdown_callbacks),
                s["shutdown_registrations"]
            );
            for (i, v) in s["logger_words"].as_array().unwrap().iter().enumerate() {
                assert_eq!(
                    b.word(LOGGER + i as u32 * 4).unwrap(),
                    n(v),
                    "{} word{i}",
                    s["action"]
                );
            }
            for v in s["state"]["words"]
                .as_array()
                .unwrap()
                .iter()
                .filter(|v| labels.contains(&n(&v[0])))
            {
                assert_eq!(b.word(n(&v[0])).unwrap(), n(&v[1]));
            }
            assert_eq!(b.locks.len(), usize::from(n(&s["logger_pointer"]) != 0));
        }
        assert!(b.queue.unwrap().is_empty());
        for p in labels {
            assert!(b.memory.word(p).is_err());
        }
    }
}
#[test]
fn audio_replay_logger_matches84_original_crt_raw_byte_timestamp_suffix_truncation_and_default_callback_buffers(
) {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_logger_format_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 84);
    for c in cases {
        let mut b = Host::new(n(&c["fill"]) as u8);
        initialize(&mut b).unwrap();
        for (i, v) in c["clock"].as_array().unwrap().iter().enumerate() {
            b.clock[i] = n(v) as u16;
        }
        let source = c["source_hex"].as_str().map(bytes);
        write_message(
            &mut b,
            LOGGER,
            &bytes(c["message_hex"].as_str().unwrap()),
            source.as_deref(),
            n(&c["number"]),
        )
        .unwrap();
        let expected = bytes(c["buffer_hex"].as_str().unwrap());
        let actual: Vec<_> = (0..CAPACITY)
            .map(|i| b.memory.read_byte(BUFFER + i as u32).unwrap())
            .collect();
        assert_eq!(actual, expected);
        assert!(
            b.calls.is_empty(),
            "default callback must not invent output"
        );
        assert_eq!(
            c["calls"]
                .as_array()
                .unwrap()
                .iter()
                .map(|v| v["entry"].as_str().unwrap())
                .collect::<Vec<_>>(),
            ["0x993860", "0xc9b551", "0x993860", "0xc9b551", "0x5cce30", "0x573fa0"]
        );
        shutdown(&mut b).unwrap();
    }
}
#[test]
fn audio_replay_logger_configured_member_receives_native_owner_buffer_and_ignores_return_byte_but_reports_boundary_failure(
) {
    let mut b = Host::new(165);
    initialize(&mut b).unwrap();
    let p = b.word(LOGGER + 32).unwrap();
    Storage::write_word(&mut b, p + 4, 0x31415926).unwrap();
    Storage::write_word(&mut b, p + 8, 0x31000000).unwrap();
    for result in [0, 1, 255] {
        b.output = Ok(result);
        write_message(&mut b, LOGGER, b"message", Some(b"file.cpp"), u32::MAX).unwrap();
        assert_eq!(b.calls.last(), Some(&(0x31415926, 0x31000000, BUFFER)));
        assert_eq!(
            b.text(),
            b"2014-11-20T23-59-58: message. Line: -1, file: file.cpp\n"
        );
    }
    b.output = Err("callback unavailable");
    assert_eq!(
        write_message(&mut b, LOGGER, b"message", None, 0),
        Err(Error::Boundary("callback unavailable"))
    );
    Storage::write_word(&mut b, callback::HANDLER_VTABLE + 8, 0xdeadbeef).unwrap();
    assert_eq!(
        write_message(&mut b, LOGGER, b"message", None, 0),
        Err(Error::UnknownCallback(0xdeadbeef))
    );
    shutdown(&mut b).unwrap();
    assert!(b.locks.is_empty());
}

#[path="audio_replay_recording_resource_tests.rs"]
mod recording_tests;
