use super::*;
use crate::audio_announcer_object_lookup as read;
use crate::audio_announcer_object_lookup::Memory;
use crate::audio_announcer_registry_init as init;
use crate::audio_announcer_registry_init::OwnedMemory;
use crate::audio_announcer_registry_remove::{self as removal, Backend as Free};
use crate::audio_replay_metadata::{self as metadata, BASE_VTABLE, BYTES, SCALAR_DELETE, VTABLE};
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
    route: Deallocator,
    after_route: Deallocator,
    custom_events: Vec<Value>,
    watched_tree: u32,
    watched_node: u32,
    retired_capacity: Option<u32>,
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
        Ok(self.route)
    }
    fn free(&mut self, p: u32, r: Deallocator) -> Result<(), removal::Error> {
        if p == self.watched_node {
            self.retired_capacity = Some(self.word(p + 44).unwrap());
        }
        if let Deallocator::Custom { callback, context } = r {
            let count = self.word(self.watched_tree + 4).unwrap();
            let cap = if self.live.contains_key(&self.watched_node) {
                self.word(self.watched_node + 44).unwrap()
            } else {
                self.retired_capacity
                    .expect("capacity saved before native node retirement")
            };
            self.custom_events.push(json!({"callback":callback,"context":context,"pointer":p,"count":count,"node_capacity":cap}));
            if context == 0x11111111 {
                self.route = self.after_route;
            }
        }
        self.live.remove(&p).expect("live metadata ownership");
        self.memory.free(p, Deallocator::Standard)
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
        route: Deallocator::Standard,
        after_route: Deallocator::Standard,
        custom_events: vec![],
        watched_tree: 0,
        watched_node: 0,
        retired_capacity: None,
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

fn proof() -> Value {
    let p: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_metadata_text_probe.json",
    ))
    .unwrap();
    assert_eq!(p["passed"], true);
    assert_eq!(
        p["native_sha256"],
        "402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862"
    );
    p
}
fn initialize(c: &Value) -> Host {
    let mut b = host(n(&c["fill"]) as u8);
    let p = n(&c["metadata"]);
    reserve(&mut b, p, BYTES);
    let allocations = c["initial"]["allocations"].as_array().unwrap();
    let index = allocations
        .iter()
        .position(|a| n(&a["pointer"]) == p)
        .unwrap();
    b.queue = allocations[index + 1..index + 4].iter().cloned().collect();
    metadata::construct(&mut b, p).unwrap();
    assert!(b.queue.is_empty());
    b.allocations.clear();
    compare(&mut b, &c["initial"]);
    for (ptr, size) in [
        (0x3000c000, 24),
        (0x3000d000, 1024),
        (0x38010000, SCRATCH_BYTES),
    ] {
        b.memory.reserve_at(ptr, size).unwrap();
    }
    b
}
fn run(b: &mut Host, p: u32, s: &Value) {
    let source = n(&s["source"]);
    seed(b, source, &decode(s["source_hex"].as_str().unwrap()));
    if !s["raw_hex"].as_str().unwrap().is_empty() {
        seed(b, n(&s["raw"]), &decode(s["raw_hex"].as_str().unwrap()));
    }
    let snap = &s["snapshot"];
    b.queue = snap["allocations"]
        .as_array()
        .unwrap()
        .iter()
        .cloned()
        .collect();
    if n(&s["function"]) == 0x7285b0 {
        put_string_extra(
            b,
            p,
            n(&s["key"]),
            n(&s["index"]),
            source,
            n(&s["extra"]),
            0x38010000,
        )
        .unwrap();
    } else {
        put_string(b, p, n(&s["key"]), n(&s["index"]), source, 0x38010000).unwrap();
    }
    assert!(b.queue.is_empty());
    assert_eq!(json!(b.allocations), snap["allocations"]);
    b.allocations.clear();
    assert_eq!(json!(b.memory.released_labels), snap["freed"]);
    b.memory.released_labels.clear();
    compare(b, snap);
}
#[test]
fn audio_replay_metadata_text_setters_match408_native_insert_replace_nul_and_signed_key_operations()
{
    let proof = proof();
    assert_eq!(proof["cases"].as_array().unwrap().len(), 2);
    let mut operations = 0;
    for c in proof["cases"].as_array().unwrap() {
        let p = n(&c["metadata"]);
        let mut b = initialize(c);
        for s in c["steps"].as_array().unwrap() {
            run(&mut b, p, s);
            operations += 1;
        }
        metadata::clear(&mut b, p).unwrap();
        compare(&mut b, &c["cleared"]);
        assert_eq!(json!(b.memory.released_labels), c["cleared"]["freed"]);
        assert_eq!(b.live.len(), 4);
    }
    assert_eq!(operations, 408);
}
#[test]
fn audio_replay_metadata_text_erases_before_reading_an_aliased_input_and_unlocks_on_error() {
    let proof = proof();
    let c = &proof["cases"][0];
    let p = n(&c["metadata"]);
    let mut b = initialize(c);
    let s = &c["steps"][0];
    run(&mut b, p, s);
    let head = b.word(p + 8).unwrap();
    let node = b.word(head + 4).unwrap();
    let result = put_string_extra(
        &mut b,
        p,
        n(&s["key"]),
        n(&s["index"]),
        node + 24,
        3,
        0x38010000,
    );
    assert!(matches!(result, Err(Error::Read(_))));
    assert!(b.held.is_empty());
    assert_eq!(b.word(p + 12).unwrap(), 0);
    assert!(!b.live.contains_key(&node));
}

#[test]
fn audio_replay_metadata_text_native_custom_callback_route_reload_and_count_order() {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_metadata_text_custom_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    assert_eq!(
        proof["native_sha256"],
        "402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862"
    );
    assert_eq!(proof["cases"].as_array().unwrap().len(), 16);
    for c in proof["cases"].as_array().unwrap() {
        let p = n(&c["metadata"]);
        let mut b = initialize(c);
        run(&mut b, p, &c["steps"][0]);
        b.watched_tree = n(&c["watched_tree"]);
        b.watched_node = n(&c["watched_node"]);
        b.route = Deallocator::Custom {
            callback: n(&c["callback_a"]),
            context: 0x11111111,
        };
        b.after_route = if n(&c["next_callback"]) == 0 {
            Deallocator::Standard
        } else {
            Deallocator::Custom {
                callback: n(&c["next_callback"]),
                context: 0x22222222,
            }
        };
        run(&mut b, p, &c["steps"][1]);
        assert_eq!(json!(b.custom_events), c["steps"][1]["custom_events"]);
        b.route = Deallocator::Standard;
        metadata::clear(&mut b, p).unwrap();
        compare(&mut b, &c["cleared"]);
        assert_eq!(json!(b.memory.released_labels), c["cleared"]["freed"]);
    }
}
