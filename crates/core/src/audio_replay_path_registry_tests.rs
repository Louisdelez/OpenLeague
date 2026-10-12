use super::*;
use crate::audio_announcer_object_lookup::Memory;
use crate::audio_announcer_registry_init::OwnedMemory;
use serde_json::{json, Value};
use std::collections::VecDeque;
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
    labels: BTreeSet<u32>,
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
        self.memory.free(p, r)
    }
}
impl Boundary for Host {
    fn read_byte(&mut self, p: u32) -> Result<u8, read::Error> {
        self.memory.read_byte(p)
    }
}
fn set_bytes(b: &mut Host, p: u32, data: &[u8]) {
    for (i, &v) in data.iter().enumerate() {
        b.write_byte(p + i as u32, v).unwrap();
    }
}
fn read_bytes(b: &Host, p: u32, size: usize) -> Vec<u8> {
    (0..size)
        .map(|i| b.memory.read_byte(p + i as u32).unwrap())
        .collect()
}
fn make(fill: u8, stages: &[&Value], global: &[u8], flag: &[u8]) -> Host {
    let queue: VecDeque<Value> = stages
        .iter()
        .flat_map(|s| s["allocations"].as_array().unwrap().iter().cloned())
        .collect();
    let labels = queue
        .iter()
        .flat_map(|a| (0..n(&a["bytes"])).step_by(4).map(|i| n(&a["pointer"]) + i))
        .collect();
    let mut b = Host {
        memory: OwnedMemory::new(0x38000000, fill),
        queue,
        labels,
        allocations: vec![],
    };
    for (p, size) in [
        (FLAG, 4),
        (OBJECT, SIZE),
        (0x37000000, 0x80000),
        (0x3000c000, 2048),
    ] {
        b.memory.reserve_at(p, size).unwrap();
    }
    set_bytes(&mut b, OBJECT, global);
    set_bytes(&mut b, FLAG, flag);
    b
}
fn compare(b: &mut Host, s: &Value) {
    assert_eq!(json!(b.allocations), s["allocations"]);
    b.allocations.clear();
    assert_eq!(json!(b.memory.released_labels), s["freed"]);
    b.memory.released_labels.clear();
    assert_eq!(json!(b.memory.shutdown_callbacks), s["registrations"]);
    b.memory.shutdown_callbacks.clear();
    for row in s["words"].as_array().unwrap() {
        let p = n(&row[0]);
        if b.labels.contains(&p) {
            assert_eq!(b.word(p).unwrap(), n(&row[1]), "{p:08x}");
        }
    }
    assert_eq!(
        read_bytes(b, OBJECT, SIZE as usize),
        decode(s["global_hex"].as_str().unwrap())
    );
    assert_eq!(b.word(FLAG).unwrap(), n(&s["flag"]));
}
#[test]
fn audio_replay_path_registry_matches20_native_active_registration_lifetimes() {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_path_registry_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    assert_eq!(
        proof["native_sha256"],
        "402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862"
    );
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 20);
    for c in cases {
        let mut stages = vec![&c["initial"]];
        stages.extend(c["steps"].as_array().unwrap().iter().map(|s| &s["state"]));
        stages.push(&c["shutdown"]);
        let mut b = make(
            n(&c["fill"]) as u8,
            &stages,
            &decode(proof["initial_global_hex"].as_str().unwrap()),
            &decode(proof["initial_flag_hex"].as_str().unwrap()),
        );
        assert_eq!(initialize(&mut b).unwrap(), OBJECT);
        compare(&mut b, &c["initial"]);
        setbyte(&mut b, OBJECT, 0x10a0, 1).unwrap();
        put(&mut b, OBJECT, 0x10a4, 1).unwrap();
        put(&mut b, OBJECT, 0x68, 0x37000000).unwrap();
        put(&mut b, OBJECT, 0x1098, n(&c["counter"])).unwrap();
        let path = n(&c["path_pointer"]);
        let mut text = decode(c["path_hex"].as_str().unwrap());
        text.push(0);
        set_bytes(&mut b, path, &text);
        for (i, s) in c["steps"].as_array().unwrap().iter().enumerate() {
            assert_eq!(
                register_path(&mut b, OBJECT, path).unwrap() as u32,
                n(&s["return_byte"])
            );
            compare(&mut b, &s["state"]);
            let expected = decode(s["buffer_hex"].as_str().unwrap());
            assert_eq!(
                read_bytes(&b, 0x37000000, expected.len()),
                expected,
                "case {} counter {} step {i}",
                text.len(),
                c["counter"]
            );
        }
        shutdown(&mut b).unwrap();
        compare(&mut b, &c["shutdown"]);
        assert!(b.queue.is_empty());
    }
}
#[test]
fn audio_replay_path_registry_default_constructor_matches4_full_native_opening_lifetimes() {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_recording_path_registration_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 4);
    for c in cases {
        let bytes = decode(c["singleton_hex"].as_str().unwrap());
        let head = u32::from_le_bytes(bytes[0x1090..0x1094].try_into().unwrap());
        let allocations = json!([{"bytes":24,"pointer":head}]);
        let stage = json!({"allocations":allocations});
        let mut b = make(
            n(&c["fill"]) as u8,
            &[&stage],
            &vec![0; SIZE as usize],
            &[0; 4],
        );
        assert_eq!(initialize(&mut b).unwrap(), OBJECT);
        assert_eq!(read_bytes(&b, OBJECT, SIZE as usize), bytes);
        assert!(!register_path(&mut b, OBJECT, 0).unwrap());
        assert_eq!(initialize(&mut b).unwrap(), OBJECT);
        assert_eq!(b.memory.shutdown_callbacks, vec![SHUTDOWN]);
        shutdown(&mut b).unwrap();
        assert_eq!(b.memory.released_labels, vec![head]);
        assert!(b.queue.is_empty());
    }
}
#[test]
fn audio_replay_path_registry_matches34_native_gate_capacity_rotation_casefold_and_sparse_constructor_lifetimes(
) {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_path_registry_edges_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 34);
    for c in cases {
        let profile = &c["profile"];
        let mut stages = vec![&c["initial"], &c["cached"]];
        stages.extend(c["steps"].as_array().unwrap().iter().map(|s| &s["state"]));
        stages.push(&c["shutdown"]);
        let mut b = make(
            n(&profile["fill"]) as u8,
            &stages,
            &vec![n(&profile["global_fill"]) as u8; SIZE as usize],
            &n(&profile["flag"]).to_le_bytes(),
        );
        assert_eq!(initialize(&mut b).unwrap(), OBJECT);
        compare(&mut b, &c["initial"]);
        assert_eq!(initialize(&mut b).unwrap(), OBJECT);
        compare(&mut b, &c["cached"]);
        setbyte(&mut b, OBJECT, 0x10a0, n(&profile["enabled"]) as u8).unwrap();
        put(&mut b, OBJECT, 0x10a4, n(&profile["mask"])).unwrap();
        put(&mut b, OBJECT, 0x68, 0x37000000).unwrap();
        put(&mut b, OBJECT, 0x109c, n(&profile["used"])).unwrap();
        for (i, s) in c["steps"].as_array().unwrap().iter().enumerate() {
            let request = &s["request"];
            let path = if let Some(hex) = request["path_hex"].as_str() {
                let mut data = decode(hex);
                data.push(0);
                let path = n(&c["path_pointer"]);
                set_bytes(&mut b, path, &data);
                path
            } else {
                0
            };
            let output = if let Some(hex) = request["name_hex"].as_str() {
                register_named(&mut b, OBJECT, &decode(hex), path)
            } else {
                register_path(&mut b, OBJECT, path)
            };
            assert_eq!(
                output.unwrap() as u32,
                n(&s["return_byte"]),
                "{profile} step{i}"
            );
            compare(&mut b, &s["state"]);
            let expected = decode(s["buffer_hex"].as_str().unwrap());
            assert_eq!(
                read_bytes(&b, 0x37000000 + n(&s["buffer_offset"]), expected.len()),
                expected,
                "{profile} step{i}"
            );
        }
        shutdown(&mut b).unwrap();
        compare(&mut b, &c["shutdown"]);
        assert!(b.queue.is_empty());
    }
}
