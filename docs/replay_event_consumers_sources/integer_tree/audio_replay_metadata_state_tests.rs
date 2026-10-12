use super::*;
use crate::audio_announcer_object_lookup::Memory;
use crate::audio_announcer_registry_init::OwnedMemory;
use crate::audio_announcer_registry_remove::{Backend as Free, Deallocator};
use crate::audio_replay_metadata as metadata;
use serde_json::{json, Value};
use std::collections::{BTreeMap, VecDeque};

fn n(value: &Value) -> u32 { value.as_u64().unwrap() as u32 }
fn decode(text: &str) -> Vec<u8> {
    (0..text.len()).step_by(2).map(|i| u8::from_str_radix(&text[i..i + 2], 16).unwrap()).collect()
}
struct Host {
    memory: OwnedMemory,
    queue: VecDeque<Value>,
    allocations: Vec<Value>,
    live: BTreeMap<u32, u32>,
    locks: BTreeSet<u32>,
    held: BTreeSet<u32>,
    events: Vec<Value>,
    primitives: Vec<Value>,
    null_next: bool,
    route: Deallocator,
}
impl Memory for Host {
    fn word(&mut self, p: u32) -> Result<u32, read::Error> { self.memory.word(p) }
}
impl Storage for Host {
    fn allocate(&mut self, bytes: u32) -> Result<u32, init::Error> {
        if self.null_next {
            self.null_next = false;
            self.primitives.push(json!({"op":"null_allocate","bytes":bytes}));
            return Ok(0);
        }
        let entry = self.queue.pop_front().expect("native allocation");
        assert_eq!(n(&entry["bytes"]), bytes);
        let p = n(&entry["pointer"]);
        self.memory.reserve_at(p, bytes)?;
        self.live.insert(p, bytes);
        self.allocations.push(entry);
        Ok(p)
    }
    fn write_word(&mut self, p: u32, value: u32) -> Result<(), init::Error> {
        Storage::write_word(&mut self.memory, p, value)
    }
    fn write_byte(&mut self, p: u32, value: u8) -> Result<(), init::Error> { self.memory.write_byte(p, value) }
    fn register_shutdown(&mut self, p: u32) -> Result<(), init::Error> { self.memory.register_shutdown(p) }
}
impl Free for Host {
    fn write_word(&mut self, p: u32, value: u32) -> Result<(), removal::Error> {
        Free::write_word(&mut self.memory, p, value)
    }
    fn deallocator(&mut self) -> Result<Deallocator, removal::Error> { Ok(self.route) }
    fn free(&mut self, p: u32, route: Deallocator) -> Result<(), removal::Error> {
        assert_eq!(route, self.route);
        if let Deallocator::Custom { callback, context } = route {
            self.primitives.push(json!({"op":"custom_free","callback":callback,"pointer":p,"context":context}));
        }
        self.live.remove(&p).expect("owned live block");
        self.memory.release(p).map_err(removal::Error::Owned)
    }
}
impl Boundary for Host {
    fn read_byte(&mut self, p: u32) -> Result<u8, read::Error> { self.memory.read_byte(p) }
    fn initialize_lock(&mut self, p: u32) -> Result<(), &'static str> {
        assert!(self.locks.insert(p));
        for i in 8..32 { self.write_byte(p + i, 0).unwrap(); }
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
fn host(fill: u8, p: u32) -> Host {
    let mut host = Host {
        memory: OwnedMemory::new(0x38000000, fill), queue: VecDeque::new(), allocations: vec![],
        live: BTreeMap::new(), locks: BTreeSet::new(), held: BTreeSet::new(), events: vec![],
        primitives: vec![], null_next: false, route: Deallocator::Standard,
    };
    host.memory.reserve_at(p, metadata::BYTES).unwrap();
    host.live.insert(p, metadata::BYTES);
    host
}
fn compare(host: &mut Host, snapshot: &Value) {
    assert!(host.queue.is_empty());
    assert!(host.held.is_empty());
    assert_eq!(json!(host.events), snapshot["lock_events"]);
    assert_eq!(json!(host.primitives), snapshot["primitives"]);
    assert_eq!(json!(host.memory.released_labels), snapshot["freed"]);
    for (&p, &bytes) in &host.live {
        let expected = snapshot["blocks"].as_array().unwrap().iter().find(|row| n(&row["pointer"]) == p).unwrap();
        assert_eq!(n(&expected["bytes"]), bytes);
        let actual: Vec<u8> = (0..bytes).map(|i| host.memory.read_byte(p + i).unwrap()).collect();
        assert_eq!(actual, decode(expected["hex"].as_str().unwrap()), "block {p:08x}");
    }
    host.events.clear(); host.primitives.clear(); host.memory.released_labels.clear();
}
fn oracle() -> Value {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture("data/4.20/replay_metadata_state_probe.json")).unwrap();
    assert_eq!(proof["passed"], true);
    assert_eq!(proof["native_sha256"], "402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862");
    assert_eq!(proof["cases"].as_array().unwrap().len(), 20);
    for address in [0x5c64e0, 0x5c6540, 0x5da695, 0x5da71f, 0x5ccfe0, 0x5da8c0, 0x5c23e0] {
        assert!(proof["helper_addresses_executed"].as_array().unwrap().iter().any(|v| n(v) == address));
    }
    proof
}
fn qualify(case: &Value) -> usize {
    let p = n(&case["metadata"]);
    let mut host = host(n(&case["fill"]) as u8, p);
    let initial = &case["initial"];
    let allocations = initial["allocations"].as_array().unwrap();
    let metadata_index = allocations.iter().position(|row| n(&row["pointer"]) == p).unwrap();
    host.queue = allocations[metadata_index + 1..metadata_index + 4].iter().cloned().collect();
    metadata::construct(&mut host, p).unwrap();
    assert_eq!(json!(host.allocations), json!(&allocations[metadata_index + 1..metadata_index + 4]));
    host.allocations.clear();
    // Parent initialization frees temporary callback clones outside this module.
    // Metadata construction itself only owns the object and three sentinels.
    for released in initial["freed"].as_array().unwrap() {
        assert!(!host.live.contains_key(&n(released)));
    }
    let mut initial_metadata = initial.clone();
    initial_metadata["freed"] = json!([]);
    compare(&mut host, &initial_metadata);
    for step in case["steps"].as_array().unwrap() {
        if let Some(count) = step["seed_count"].as_u64() { Storage::write_word(&mut host, p + 0x1c, count as u32).unwrap(); }
        host.route = if step["custom_free"] == true {
            Deallocator::Custom { callback: n(&step["custom_free_address"]), context: 0x12344321 }
        } else { Deallocator::Standard };
        host.null_next = step["error"] == "bad_alloc";
        host.queue = step["snapshot"]["allocations"].as_array().unwrap().iter().cloned().collect();
        let key = n(&step["key"]);
        let result = match n(&step["function"]) {
            0x64d040 => value_slot(&mut host, p + TREE_OFFSET, key),
            0x728a40 => mark1(&mut host, p, key),
            0x728a60 => mark2(&mut host, p, key),
            0x663240 => {
                let node = allocate_node(&mut host, p + TREE_OFFSET, key).unwrap();
                insert_hint(&mut host, p + TREE_OFFSET, node, n(&step["hint"])).map(|p| p + 20)
            }
            _ => panic!("unexpected native operation"),
        };
        if step["error"] == "length_error" { assert_eq!(result, Err(Error::CapacityExceeded)); }
        else if step["error"] == "bad_alloc" { assert_eq!(result, Err(Error::AllocationFailed)); }
        else {
            let slot = result.unwrap();
            assert_eq!(slot, n(&step["slot"]));
            assert_eq!(host.word(slot).unwrap(), n(&step["value"]));
        }
        assert_eq!(json!(host.allocations), step["snapshot"]["allocations"]);
        host.allocations.clear();
        compare(&mut host, &step["snapshot"]);
    }
    host.route = Deallocator::Standard;
    for step in case["iterators"].as_array().unwrap() {
        assert_eq!(adjacent(&mut host, n(&step["node"]), step["forward"].as_bool().unwrap()).unwrap(), n(&step["returned"]));
    }
    compare(&mut host, &case["iterators_snapshot"]);
    metadata::scalar_delete(&mut host, p, 1).unwrap();
    compare(&mut host, &case["destroyed"]);
    assert!(host.live.is_empty() && host.locks.is_empty());
    assert!(case["shutdown"]["blocks"].as_array().unwrap().is_empty());
    case["steps"].as_array().unwrap().len()
}
#[test]
fn audio_replay_metadata_state_matches12_native_tree_rotation_unsigned_key_and_repeated_slot_lifetimes() {
    let proof = oracle();
    let mut count = 0;
    for case in proof["cases"].as_array().unwrap() {
        let profile = case["profile"].as_str().unwrap();
        if !profile.starts_with("capacity") && profile != "null_allocation" && profile != "hint_dependencies" { qualify(case); count += 1; }
    }
    assert_eq!(count, 12);
}
#[test]
fn audio_replay_metadata_state_matches6_native_capacity_default_custom_free_and_null_allocation_lifetimes() {
    let proof = oracle();
    let mut count = 0;
    for case in proof["cases"].as_array().unwrap() {
        let profile = case["profile"].as_str().unwrap();
        if profile.starts_with("capacity") || profile == "null_allocation" { qualify(case); count += 1; }
    }
    assert_eq!(count, 6);
}
#[test]
fn audio_replay_metadata_state_hint_dependencies_match2_native_neighbor_fallback_duplicate_lifetimes() {
    let proof = oracle();
    let mut count = 0;
    for case in proof["cases"].as_array().unwrap() {
        if case["profile"] == "hint_dependencies" { qualify(case); count += 1; }
    }
    assert_eq!(count, 2);
}
