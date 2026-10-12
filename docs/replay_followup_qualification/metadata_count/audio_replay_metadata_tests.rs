use super::*;
use crate::audio_announcer_object_lookup::Memory;
use crate::audio_announcer_registry_init::OwnedMemory;
use serde_json::{json, Value};
use std::collections::{BTreeMap, VecDeque};
fn n(v: &Value) -> u32 {
    v.as_u64().unwrap() as u32
}
fn decode(s: &str) -> Vec<u8> {
    (0..s.len())
        .step_by(2)
        .map(|i| u8::from_str_radix(&s[i..i + 2], 16).unwrap())
        .collect()
}
struct Host {
    memory: OwnedMemory,
    queue: VecDeque<Value>,
    allocations: Vec<Value>,
    live: BTreeMap<u32, u32>,
    locks: BTreeSet<u32>,
    held: BTreeSet<u32>,
    events: Vec<Value>,
}
impl Memory for Host {
    fn word(&mut self, p: u32) -> Result<u32, read::Error> {
        self.memory.word(p)
    }
}
impl Storage for Host {
    fn allocate(&mut self, size: u32) -> Result<u32, init::Error> {
        let a = self.queue.pop_front().expect("native allocation");
        assert_eq!(n(&a["bytes"]), size);
        let pointer = n(&a["pointer"]);
        self.memory.reserve_at(pointer, size)?;
        self.allocations.push(a);
        self.live.insert(pointer, size);
        Ok(pointer)
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
impl Free for Host {
    fn write_word(&mut self, p: u32, v: u32) -> Result<(), removal::Error> {
        Free::write_word(&mut self.memory, p, v)
    }
    fn deallocator(&mut self) -> Result<Deallocator, removal::Error> {
        self.memory.deallocator()
    }
    fn free(&mut self, p: u32, r: Deallocator) -> Result<(), removal::Error> {
        self.live.remove(&p).expect("live metadata ownership");
        self.memory.free(p, r)
    }
}
impl Boundary for Host {
    fn read_byte(&mut self, p: u32) -> Result<u8, read::Error> {
        self.memory.read_byte(p)
    }
    fn initialize_lock(&mut self, p: u32) -> Result<(), &'static str> {
        assert!(self.locks.insert(p));
        for i in 8..32 {
            self.write_byte(p + i, 0).unwrap();
        }
        self.events.push(json!({"op":"initialize","object":p}));
        Ok(())
    }
    fn destroy_lock(&mut self, p: u32) -> Result<(), &'static str> {
        assert!(!self.held.contains(&p) && self.locks.remove(&p));
        self.events.push(json!({"op":"destroy","object":p}));
        Ok(())
    }
    fn enter_lock(&mut self, p: u32) -> Result<(), &'static str> {
        assert!(self.locks.contains(&p) && self.held.insert(p));
        self.events.push(json!({"op":"enter","object":p}));
        Ok(())
    }
    fn leave_lock(&mut self, p: u32) -> Result<(), &'static str> {
        assert!(self.held.remove(&p));
        self.events.push(json!({"op":"leave","object":p}));
        Ok(())
    }
}
fn seed(b: &mut Host, p: u32, data: &[u8]) {
    for (i, &v) in data.iter().enumerate() {
        b.write_byte(p + i as u32, v).unwrap();
    }
}
fn read_bytes(b: &Host, p: u32, len: u32) -> Vec<u8> {
    (0..len)
        .map(|i| b.memory.read_byte(p + i).unwrap())
        .collect()
}
fn reserve(b: &mut Host, p: u32, size: u32) {
    b.memory.reserve_at(p, size).unwrap();
    b.live.insert(p, size);
}
fn host(fill: u8) -> Host {
    let mut b = Host {
        memory: OwnedMemory::new(0x38000000, fill),
        queue: VecDeque::new(),
        allocations: vec![],
        live: BTreeMap::new(),
        locks: BTreeSet::new(),
        held: BTreeSet::new(),
        events: vec![],
    };
    for (p, v) in [(VTABLE, SCALAR_DELETE), (BASE_VTABLE, 0x727f00)] {
        b.memory.reserve_at(p, 4).unwrap();
        Storage::write_word(&mut b, p, v).unwrap();
    }
    b
}
fn compare(b: &mut Host, s: &Value) {
    assert!(b.held.is_empty());
    assert_eq!(json!(b.events), s["lock_events"]);
    b.events.clear();
    let expected: BTreeMap<u32, &Value> = s["blocks"]
        .as_array()
        .unwrap()
        .iter()
        .map(|a| (n(&a["pointer"]), a))
        .collect();
    for (&p, &size) in &b.live {
        let block = expected
            .get(&p)
            .unwrap_or_else(|| panic!("unexpected live block {p:08x}"));
        assert_eq!(size, n(&block["bytes"]));
        assert_eq!(
            read_bytes(b, p, size),
            decode(block["hex"].as_str().unwrap()),
            "block {p:08x}"
        );
    }
}
#[test]
fn audio_replay_metadata_matches24_native_empty_populated_clear_scalar_flags_and_shared_control_lifetimes(
) {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_metadata_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    assert_eq!(
        proof["native_sha256"],
        "402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862"
    );
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 24);
    for c in cases {
        let p = n(&c["metadata"]);
        let control = n(&c["control"]);
        let mut b = host(n(&c["fill"]) as u8);
        reserve(&mut b, p, BYTES);
        let initial = &c["initial"];
        let allocations = initial["allocations"].as_array().unwrap();
        let index = allocations
            .iter()
            .position(|a| n(&a["pointer"]) == p)
            .unwrap();
        assert_eq!(n(&allocations[index]["bytes"]), BYTES);
        b.queue = allocations[index + 1..index + 4].iter().cloned().collect();
        assert_eq!(construct(&mut b, p).unwrap(), p);
        assert!(b.queue.is_empty());
        assert_eq!(
            json!(b.allocations),
            json!(&allocations[index + 1..index + 4])
        );
        b.allocations.clear();
        compare(&mut b, initial);
        reserve(&mut b, control, 16);
        let native_control = initial["blocks"]
            .as_array()
            .unwrap()
            .iter()
            .find(|a| n(&a["pointer"]) == control)
            .unwrap();
        seed(
            &mut b,
            control,
            &decode(native_control["hex"].as_str().unwrap()),
        );
        assert_eq!(b.word(control).unwrap(), CONTROL_VTABLE);
        assert_eq!(b.word(control + 4).unwrap(), 1);
        assert_eq!(b.word(control + 8).unwrap(), 1);
        // These owned prepared trees and strings were built by the original native
        // setters. Loading their bytes supplies an independent teardown precondition;
        // it does not claim those setters are ported by this lifecycle module.
        let prepared = &c["prepared"];
        let new: BTreeSet<u32> = prepared["allocations"]
            .as_array()
            .unwrap()
            .iter()
            .map(|a| n(&a["pointer"]))
            .collect();
        for block in prepared["blocks"].as_array().unwrap() {
            let address = n(&block["pointer"]);
            if b.live.contains_key(&address) || new.contains(&address) {
                if !b.live.contains_key(&address) {
                    reserve(&mut b, address, n(&block["bytes"]));
                }
                seed(&mut b, address, &decode(block["hex"].as_str().unwrap()));
            }
        }
        if !c["cleared"].is_null() {
            clear(&mut b, p).unwrap();
            compare(&mut b, &c["cleared"]);
            assert_eq!(json!(b.memory.released_labels), c["cleared"]["freed"]);
            b.memory.released_labels.clear();
        }
        let action = c["action"].as_str().unwrap();
        if action == "dispose" {
            dispose_control(&mut b, control).unwrap();
        } else {
            let flags = if action == "clear_then_delete" {
                1
            } else {
                action[6..].parse().unwrap()
            };
            assert_eq!(scalar_delete(&mut b, p, flags).unwrap(), n(&c["result"]));
        }
        compare(&mut b, &c["destroyed"]);
        assert_eq!(
            json!(b.memory.released_labels),
            c["destroyed"]["freed"],
            "{action}, populated {}",
            c["populated"]
        );
        assert!(b.locks.is_empty());
        assert_eq!(b.word(control + 4).unwrap(), 1);
        assert_eq!(b.word(control + 8).unwrap(), 1);
    }
}
#[test]
fn audio_replay_metadata_constructor_matches_original_parent_initialization_and16_opening_lifetimes(
) {
    let fixtures = [
        ("data/4.20/replay_manager_initialization_probe.json", 2usize),
        ("data/4.20/replay_parent_open_lifetime_probe.json", 16usize),
    ];
    for (path, count) in fixtures {
        let proof: Value = serde_json::from_str(&crate::audio_test_fixture(path)).unwrap();
        assert_eq!(proof["passed"], true);
        let cases = proof["cases"].as_array().unwrap();
        assert_eq!(cases.len(), count);
        for c in cases {
            let state = if c["configured"].is_object() {
                &c["configured"]
            } else {
                &c["initial"]
            };
            let a = state["allocations"].as_array().unwrap();
            let index = a.iter().position(|a| n(&a["bytes"]) == BYTES).unwrap();
            let p = n(&a[index]["pointer"]);
            let mut b = host(n(&c["fill"]) as u8);
            reserve(&mut b, p, BYTES);
            b.queue = a[index + 1..index + 4].iter().cloned().collect();
            construct(&mut b, p).unwrap();
            assert!(b.queue.is_empty());
            for row in state["words"].as_array().unwrap() {
                let address = n(&row[0]);
                if b.live
                    .iter()
                    .any(|(&p, &size)| address >= p && address < p + size)
                {
                    assert_eq!(b.word(address).unwrap(), n(&row[1]), "{path} {address:08x}");
                }
            }
        }
    }
}

fn count_oracle() -> Value {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_metadata_count_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    assert_eq!(
        proof["native_sha256"],
        "402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862"
    );
    assert_eq!(
        proof["source_oracle_sha256"],
        "c261df7c77265c610f85c39546367a89dd2c6d959dafc50dd3f7a0f22c68aa73"
    );
    assert_eq!(proof["cases"].as_array().unwrap().len(), 2);
    proof
}
fn seed_count_words(b: &mut Host, p: u32, counts: &Value) {
    assert_eq!(counts.as_array().unwrap().len(), 4);
    for (index, count) in counts.as_array().unwrap().iter().enumerate() {
        Storage::write_word(b, p + 0x1a0 + 4 * index as u32, n(count)).unwrap();
    }
}
#[test]
fn audio_replay_metadata_set_count_matches72_native_limits_ids_al_and_lock_orders() {
    let proof = count_oracle();
    let mut calls = 0;
    for case in proof["cases"].as_array().unwrap() {
        let p = n(&case["metadata"]);
        let mut b = host(n(&case["fill"]) as u8);
        reserve(&mut b, p, BYTES);
        seed(&mut b, p, &decode(case["initial_metadata_hex"].as_str().unwrap()));
        seed_count_words(&mut b, p, &case["initial_scalar_counts"]);
        assert!(b.locks.insert(p + 0x1c8));
        let mut expected_bytes = read_bytes(&b, p, BYTES);
        for step in case["scalar_steps"].as_array().unwrap() {
            let id = n(&step["selector"]);
            let count = n(&step["value"]);
            assert_eq!(
                u32::from(set_count(&mut b, p, id, count).unwrap()),
                n(&step["returned_low_byte"]),
                "id={id}, count={count}, fill={}", case["fill"]
            );
            assert_eq!(json!(b.events), step["lock_events"]);
            assert!(b.held.is_empty());
            b.events.clear();
            for (index, value) in step["counts"].as_array().unwrap().iter().enumerate() {
                let offset = 0x1a0 + 4 * index;
                expected_bytes[offset..offset + 4].copy_from_slice(&n(value).to_le_bytes());
            }
            assert_eq!(read_bytes(&b, p, BYTES), expected_bytes);
            calls += 1;
        }
        assert!(b.queue.is_empty() && b.allocations.is_empty());
        assert!(b.memory.released_labels.is_empty());
        assert_eq!(b.live.len(), 1);
        // The source rejects these before it even addresses the object lock.
        for absent in [0, u32::MAX] {
            for excessive in [49, u32::MAX] {
                assert_eq!(set_count(&mut b, absent, 100, excessive).unwrap(), 0);
            }
        }
        assert!(b.events.is_empty());
    }
    assert_eq!(calls, 72);
}
#[test]
fn audio_replay_metadata_get_count_matches360_native_low_byte_selectors_without_locking() {
    let proof = count_oracle();
    let mut calls = 0;
    for case in proof["cases"].as_array().unwrap() {
        let p = n(&case["metadata"]);
        let mut b = host(n(&case["fill"]) as u8);
        reserve(&mut b, p, BYTES);
        seed(&mut b, p, &decode(case["initial_metadata_hex"].as_str().unwrap()));
        // Intentionally register no lock: any attempted getter lock is an error.
        for step in case["scalar_steps"].as_array().unwrap() {
            seed_count_words(&mut b, p, &step["counts"]);
            let bytes_before = read_bytes(&b, p, BYTES);
            for (selector, expected) in step["getters"].as_object().unwrap() {
                let selector = selector.parse::<u32>().unwrap();
                assert_eq!(
                    get_count(&mut b, p, n(&step["selector"]), selector).unwrap(),
                    n(expected),
                    "id={}, selector={selector}, fill={}", step["selector"], case["fill"]
                );
                assert!(b.events.is_empty() && b.held.is_empty());
                assert_eq!(read_bytes(&b, p, BYTES), bytes_before);
                calls += 1;
            }
        }
        assert!(b.queue.is_empty() && b.allocations.is_empty());
        assert!(b.memory.released_labels.is_empty());
        assert_eq!(b.live.len(), 1);
        // An unknown ID also avoids any metadata read, independently of selector.
        assert_eq!(get_count(&mut b, u32::MAX, 0, u32::MAX).unwrap(), 0);
    }
    assert_eq!(calls, 360);
}
