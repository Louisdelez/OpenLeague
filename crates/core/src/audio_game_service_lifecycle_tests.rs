use super::*;
use crate::audio_announcer_object_lookup::{self as lookup, Memory};
use crate::audio_announcer_registry_init::{self as init, OwnedMemory};
use crate::audio_announcer_registry_remove::{self as remove, Deallocator};
use crate::audio_announcer_owner_control as control;
use serde_json::{json, Value};
use std::collections::{BTreeMap, VecDeque};

struct Owned {
    memory: OwnedMemory,
    allocations: Vec<Value>,
    settings: VecDeque<Value>,
    counts: BTreeMap<u32, control::Counts>,
}
impl Memory for Owned {
    fn word(&mut self, a: u32) -> Result<u32, lookup::Error> { self.memory.word(a) }
}
impl Storage for Owned {
    fn allocate(&mut self, n: u32) -> Result<u32, init::Error> {
        let pointer = self.memory.allocate(n)?;
        self.allocations.push(json!({"bytes": n, "pointer": pointer}));
        Ok(pointer)
    }
    fn write_word(&mut self, a: u32, v: u32) -> Result<(), init::Error> { Storage::write_word(&mut self.memory, a, v) }
    fn write_byte(&mut self, a: u32, v: u8) -> Result<(), init::Error> { self.memory.write_byte(a, v) }
    fn register_shutdown(&mut self, c: u32) -> Result<(), init::Error> { self.memory.register_shutdown(c) }
}
impl Backend for Owned {
    fn write_word(&mut self, a: u32, v: u32) -> Result<(), remove::Error> {
        Storage::write_word(&mut self.memory, a, v).map_err(remove::Error::Owned)
    }
    fn deallocator(&mut self) -> Result<Deallocator, remove::Error> { Ok(Deallocator::Standard) }
    fn free(&mut self, p: u32, _: Deallocator) -> Result<(), remove::Error> {
        self.memory.release(p).map_err(remove::Error::Owned)?;
        self.counts.remove(&p);
        Ok(())
    }
}
impl Boundaries for Owned {
    fn allocate_callback_clone(&mut self, n: u32) -> Result<u32, &'static str> {
        let pointer = self.memory.allocate(n).map_err(|_| "callback allocation failed")?;
        self.allocations.push(json!({"bytes": n, "pointer": pointer, "allocator": "engine_operator_new"}));
        Ok(pointer)
    }
    fn register_listener(&mut self, _: u32, _: u32, _: u32, _: &mut u32) -> Result<(), &'static str> { Err("unexpected listener registration") }
    fn unregister_listener(&mut self, _: u32, _: u32, _: u32) -> Result<(), &'static str> { Err("unexpected listener removal") }
}
impl Owned {
    fn setting(&mut self, kind: &str, section: &str, key: &str, default: u32) -> Result<u32, &'static str> {
        let call = self.settings.pop_front().ok_or("no native setting observation")?;
        assert_eq!(call["kind"], kind);
        assert_eq!(call["section"], section);
        assert_eq!(call["key"], key);
        assert_eq!(call["default"], default);
        // Explicit external settings boundary: replay measured temporary allocations
        // and frees. This does not claim that the typed getter itself is ported.
        for allocation in call["allocations"].as_array().unwrap() {
            assert!(allocation.get("allocator").is_none());
            let pointer = self.allocate(number(&allocation["bytes"])).map_err(|_| "setting storage failed")?;
            assert_eq!(pointer, number(&allocation["pointer"]));
        }
        for pointer in call["freed"].as_array().unwrap() {
            self.free(number(pointer), Deallocator::Standard).map_err(|_| "setting storage release failed")?;
        }
        Ok(number(&call["result"]))
    }
}
impl Settings for Owned {
    fn float_bits(&mut self, s: &str, k: &str, d: u32) -> Result<u32, &'static str> { self.setting("float", s, k, d) }
    fn bool_value(&mut self, s: &str, k: &str, d: u8) -> Result<u8, &'static str> { self.setting("bool", s, k, u32::from(d)).map(|v| v as u8) }
    fn integer(&mut self, s: &str, k: &str, d: u32) -> Result<u32, &'static str> { self.setting("integer", s, k, d) }
}
impl ControlBoundary for Owned {
    fn decrement_reference(&mut self, address: u32) -> Result<u32, &'static str> {
        let (base, offset) = if self.counts.contains_key(&(address - 4)) { (address - 4, 4) }
            else if self.counts.contains_key(&(address - 8)) { (address - 8, 8) }
            else {
                let base = address - 4;
                let strong = self.word(base + 4).map_err(|_| "missing strong count")?;
                let weak = self.word(base + 8).map_err(|_| "missing weak count")?;
                self.counts.insert(base, control::Counts::new(strong, weak));
                (base, 4)
            };
        let counts = self.counts.get(&base).unwrap();
        let old = counts.decrement(offset)?;
        Storage::write_word(&mut self.memory, address, counts.read(offset)?).map_err(|_| "count write failed")?;
        Ok(old)
    }
    fn dispose(&mut self, pointer: u32, callback: u32) -> Result<(), &'static str> {
        if callback != control::DISPOSE { return Err("unknown control dispose"); }
        control::dispose(self, pointer).map_err(|_| "control dispose failed")
    }
    fn release_control(&mut self, pointer: u32, callback: u32) -> Result<(), &'static str> {
        if callback != control::RELEASE { return Err("unknown control release"); }
        control::release(self, pointer).map_err(|_| "control release failed")
    }
}
impl ObjectBoundary for Owned {
    fn scalar_delete_object(&mut self, pointer: u32, callback: u32, flags: u32) -> Result<(), &'static str> {
        if callback != metadata::HANDLER_DELETE { return Err("unknown object scalar delete"); }
        metadata::scalar_delete_callback(self, pointer, flags).map(|_| ()).map_err(|_| "object scalar delete failed")
    }
}
fn number(v: &Value) -> u32 { v.as_u64().unwrap().try_into().unwrap() }
fn proof(path: &str) -> Value { serde_json::from_str(&crate::audio_test_fixture(path)).unwrap() }
fn owned(arena: u32, poison: u8, settings: &[Value]) -> Owned {
    let mut b = Owned { memory: OwnedMemory::new(arena, poison), allocations: vec![], settings: settings.iter().cloned().collect(), counts: BTreeMap::new() };
    for (a, n) in [(CALLBACK_VTABLE, 12), (control::VTABLE, 12)] { b.memory.reserve_at(a, n).unwrap(); }
    for (a, v) in [(CALLBACK_VTABLE, metadata::HANDLER_DELETE), (CALLBACK_VTABLE + 4, CALLBACK_CLONE), (CALLBACK_VTABLE + 8, 0x734130),
        (control::VTABLE, control::DISPOSE), (control::VTABLE + 4, control::RELEASE), (control::VTABLE + 8, control::SCALAR_DELETE)] {
        Storage::write_word(&mut b, a, v).unwrap();
    }
    b
}
fn state(b: &mut Owned, native: &Value) {
    assert_eq!(json!(b.allocations), native["allocations"]);
    assert_eq!(json!(b.memory.released_labels), native["freed"]);
    for word in native["words"].as_array().unwrap() {
        assert_eq!(b.word(number(&word[0])).unwrap(), number(&word[1]), "word {word}");
    }
    for pointer in &b.memory.released_labels {
        assert!(matches!(b.memory.read_byte(*pointer), Err(lookup::Error::MissingWord(_))));
    }
    b.allocations.clear();
    b.memory.allocations.clear();
    b.memory.released_labels.clear();
}
fn callback_at(b: &mut Owned, p: u32, owner: u32, method: u32, extra: u32) {
    for (offset, value) in [(0, CALLBACK_VTABLE), (4, owner), (8, method), (12, extra)] {
        Storage::write_word(b, p + offset, value).unwrap();
    }
}
#[test]
fn audio_service_callback16_clone_and_delete_match64_native_lifetimes() {
    let p = proof("data/4.20/audio_game_service_callback16_contract.json");
    let cases = p["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 64);
    for c in cases {
        let mut b = owned(0x34000000, number(&c["poison"]) as u8, &[]);
        let source = 0x30009800;
        b.memory.reserve_at(source, 16).unwrap();
        callback_at(&mut b, source, number(&c["owner"]), number(&c["method"]), number(&c["extra"]));
        let cloned = clone_callback(&mut b, source).unwrap();
        assert_eq!(cloned, number(&c["clone_result"]));
        state(&mut b, &c["clone"]);
        assert_eq!(metadata::scalar_delete_callback(&mut b, cloned, number(&c["flags"])).unwrap(), number(&c["delete_result"]));
        state(&mut b, &c["disposed"]);
    }
}
#[test]
fn audio_replay_member_matches28_native_constructions_and_populated_destructions() {
    let p = proof("data/4.20/audio_game_service_lifecycle_contract.json");
    let cases = p["member_cases"].as_array().unwrap();
    assert_eq!(cases.len(), 28);
    for c in cases {
        let mut b = owned(number(&p["arena"]), number(&c["poison"]) as u8, c["settings"].as_array().unwrap());
        let object = number(&c["object"]);
        for (a, n) in [(object, 0xd4), (0x30009800, 4), (0x30009900, 16)] { b.memory.reserve_at(a, n).unwrap(); }
        callback_at(&mut b, 0x30009900, 0x30006000, 0x72c780, u32::MAX);
        Storage::write_word(&mut b, 0x30009800, if c["has_callback"].as_bool().unwrap() { 0x30009900 } else { 0 }).unwrap();
        assert_eq!(construct_replay(&mut b, object, 0x30009800).unwrap(), object);
        assert!(b.settings.is_empty());
        state(&mut b, &c["constructed"]);
        let profile = c["profile"].as_str().unwrap();
        if profile == "buffer" {
            let buffer = b.allocate(32).unwrap();
            for (offset, value) in [(0x50, buffer), (0x54, buffer + 12), (0x58, buffer + 32)] { Storage::write_word(&mut b, object + offset, value).unwrap(); }
        } else if profile == "stream" {
            let callback = b.allocate(16).unwrap();
            callback_at(&mut b, callback, 0, 0, 0);
            Storage::write_word(&mut b, object + 0x18, callback).unwrap();
        } else if profile.starts_with("control_") {
            let callback = b.allocate(16).unwrap();
            callback_at(&mut b, callback, 0, 0, 0);
            control::replace_pair(&mut b, object + 0x6c, callback).unwrap();
            let pointer = b.word(object + 0x70).unwrap();
            let (strong, weak) = match profile { "control_last" => (1, 1), "control_shared" => (2, 1), "control_weak" => (1, 2), "control_zero" => (0, 0), _ => panic!("unknown native profile") };
            Storage::write_word(&mut b, pointer + 4, strong).unwrap();
            Storage::write_word(&mut b, pointer + 8, weak).unwrap();
        }
        state(&mut b, &c["prepared"]);
        destroy_replay(&mut b, object).unwrap();
        state(&mut b, &c["destroyed"]);
    }
}
#[test]
fn audio_whole_service_matches8_native_construction_and_scalar_teardown_lifetimes() {
    let p = proof("data/4.20/audio_game_service_lifecycle_contract.json");
    let cases = p["whole_cases"].as_array().unwrap();
    assert_eq!(cases.len(), 8);
    for c in cases {
        let mut b = owned(number(&p["arena"]), number(&c["poison"]) as u8, c["settings"].as_array().unwrap());
        b.memory.reserve_at(CURVE_CONTROLS, 32).unwrap();
        b.memory.reserve_at(0x30009800, 4).unwrap();
        let hex = p["curve_controls_hex"].as_str().unwrap();
        for i in 0..32 { b.write_byte(CURVE_CONTROLS + i as u32, u8::from_str_radix(&hex[i * 2..i * 2 + 2], 16).unwrap()).unwrap(); }
        let service = b.allocate(0x188).unwrap();
        assert_eq!(service, number(&c["service"]));
        assert_eq!(construct(&mut b, service, 0x30009800, number(&c["opaque_byte"]) as u8).unwrap(), service);
        assert!(b.settings.is_empty());
        state(&mut b, &c["constructed"]);
        assert_eq!(scalar_delete(&mut b, service, number(&c["flags"])).unwrap(), service);
        state(&mut b, &c["destroyed"]);
    }
}
