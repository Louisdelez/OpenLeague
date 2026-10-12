use super::*;
use crate::audio_announcer_object_lookup::Memory;
use crate::audio_announcer_owner_component_destructor::ControlBoundary;
use crate::audio_announcer_registry_remove::Backend as Removal;
use serde_json::{json, Value};
use std::collections::{BTreeMap, BTreeSet, VecDeque};
struct Engine {
    memory: init::OwnedMemory,
    queue: VecDeque<Value>,
    allocations: Vec<Value>,
    freed: Vec<u32>,
    live: BTreeMap<u32, u32>,
    labels: BTreeSet<u32>,
    handle: Handle,
    capsule: u32,
    named: Vec<Vec<u8>>,
    calls: Vec<(u32, u32)>,
    locks: BTreeSet<u32>,
    held: Vec<u32>,
    reject_crt: bool,
}
fn n(v: &Value) -> u32 {
    v.as_u64().unwrap().try_into().unwrap()
}
fn bytes(hex: &str) -> Vec<u8> {
    hex.as_bytes()
        .chunks_exact(2)
        .map(|s| u8::from_str_radix(std::str::from_utf8(s).unwrap(), 16).unwrap())
        .collect()
}
impl Engine {
    fn from_case(c: &Value) -> Self {
        let queue = c["created"]["allocations"]
            .as_array()
            .unwrap()
            .iter()
            .filter(|a| a["allocator"] != "windows_heap_alloc")
            .cloned()
            .collect::<VecDeque<_>>();
        let labels = queue.iter().map(|a| n(&a["pointer"])).collect();
        let call = c["thread_events"]
            .as_array()
            .unwrap()
            .iter()
            .find(|e| e["op"] == "create");
        Self {
            memory: init::OwnedMemory::new(0x39000000, n(&c["fill"]) as u8),
            queue,
            allocations: vec![],
            freed: vec![],
            live: BTreeMap::new(),
            labels,
            handle: call
                .map(|c| Handle {
                    handle: n(&c["handle"]),
                    id: n(&c["thread"]),
                })
                .unwrap_or(Handle { handle: 0, id: 0 }),
            capsule: 0,
            named: vec![],
            calls: vec![],
            locks: BTreeSet::new(),
            held: vec![],
            reject_crt: false,
        }
    }
    fn allocate_kind(&mut self, size: u32, engine: bool) -> Result<u32, init::Error> {
        let expected = self.queue.pop_front().expect("unexpected allocation");
        assert_eq!(n(&expected["bytes"]), size);
        assert_eq!(expected["allocator"] == "engine_operator_new", engine);
        let p = n(&expected["pointer"]);
        self.memory.reserve_at(p, size)?;
        self.live.insert(p, size);
        self.allocations.push(expected);
        Ok(p)
    }
    fn options(&mut self, name: &[u8]) -> u32 {
        let p = 0x3000e100;
        self.memory.reserve_at(p, 40).unwrap();
        for i in 0..40 {
            self.memory.write_byte(p + i, 0).unwrap();
        }
        for (i, v) in b"EnetSysInit\0".iter().enumerate() {
            self.memory.write_byte(p + i as u32, *v).unwrap();
        }
        let data = if name.len() >= 16 {
            let data = 0x3000f000;
            self.memory.reserve_at(data, name.len() as u32 + 1).unwrap();
            Storage::write_word(&mut self.memory, p + 16, data).unwrap();
            data
        } else {
            p + 16
        };
        for (i, v) in name.iter().chain(std::iter::once(&0)).enumerate() {
            self.memory.write_byte(data + i as u32, *v).unwrap();
        }
        Storage::write_word(&mut self.memory, p + 32, name.len() as u32).unwrap();
        Storage::write_word(
            &mut self.memory,
            p + 36,
            if name.len() < 16 {
                15
            } else {
                name.len() as u32 | 15
            },
        )
        .unwrap();
        p
    }
    fn compare(&mut self, snapshot: &Value) {
        let allocations = snapshot["allocations"]
            .as_array()
            .unwrap()
            .iter()
            .filter(|a| a["allocator"] != "windows_heap_alloc")
            .cloned()
            .collect::<Vec<_>>();
        assert_eq!(self.allocations, allocations);
        let freed = snapshot["freed"]
            .as_array()
            .unwrap()
            .iter()
            .map(n)
            .filter(|p| self.labels.contains(p))
            .collect::<Vec<_>>();
        assert_eq!(self.freed, freed);
        let expected = snapshot["words"]
            .as_array()
            .unwrap()
            .iter()
            .filter(|w| {
                let a = n(&w[0]);
                self.live
                    .iter()
                    .any(|(&p, &len)| p <= a && a + 4 <= p + len)
            })
            .map(|w| (n(&w[0]), n(&w[1])))
            .collect::<BTreeMap<_, _>>();
        for (&p, &len) in &self.live {
            for offset in (0..len - len % 4).step_by(4) {
                let a = p + offset;
                assert_eq!(self.memory.word(a).unwrap(), expected[&a], "word at{a:x}");
            }
        }
        self.allocations.clear();
        self.freed.clear();
    }
}
impl Memory for Engine {
    fn word(&mut self, a: u32) -> Result<u32, read::Error> {
        self.memory.word(a)
    }
}
impl Storage for Engine {
    fn allocate(&mut self, n: u32) -> Result<u32, init::Error> {
        self.allocate_kind(n, false)
    }
    fn write_word(&mut self, a: u32, v: u32) -> Result<(), init::Error> {
        Storage::write_word(&mut self.memory, a, v)
    }
    fn write_byte(&mut self, a: u32, v: u8) -> Result<(), init::Error> {
        self.memory.write_byte(a, v)
    }
    fn register_shutdown(&mut self, c: u32) -> Result<(), init::Error> {
        self.memory.register_shutdown(c)
    }
}
impl Removal for Engine {
    fn write_word(&mut self, a: u32, v: u32) -> Result<(), removal::Error> {
        Storage::write_word(&mut self.memory, a, v).map_err(removal::Error::Owned)
    }
    fn deallocator(&mut self) -> Result<removal::Deallocator, removal::Error> {
        Ok(removal::Deallocator::Standard)
    }
    fn free(&mut self, p: u32, _: removal::Deallocator) -> Result<(), removal::Error> {
        self.memory.release(p).map_err(removal::Error::Owned)?;
        assert!(self.live.remove(&p).is_some());
        self.freed.push(p);
        Ok(())
    }
}
impl ControlBoundary for Engine {
    fn decrement_reference(&mut self, _: u32) -> Result<u32, &'static str> {
        Err("no control in direct factory fixture")
    }
    fn dispose(&mut self, _: u32, _: u32) -> Result<(), &'static str> {
        Err("no control in direct factory fixture")
    }
    fn release_control(&mut self, _: u32, _: u32) -> Result<(), &'static str> {
        Err("no control in direct factory fixture")
    }
}
impl thread::Boundary for Engine {
    fn current_thread_id(&mut self) -> Result<u32, &'static str> {
        Ok(1)
    }
    fn wait_handle(&mut self, _: u32, _: u32) -> Result<u32, &'static str> {
        Err("no wait in direct factory fixture")
    }
    fn close_handle(&mut self, h: u32) -> Result<u32, &'static str> {
        assert_eq!(h, self.handle.handle);
        Ok(1)
    }
    fn last_error(&mut self) -> Result<u32, &'static str> {
        Err("no error in direct close")
    }
    fn mutex(&mut self, a: u32, enter: bool) -> Result<(), &'static str> {
        assert!(self.locks.contains(&(a + 8)));
        if enter {
            self.held.push(a);
        } else {
            assert_eq!(self.held.pop(), Some(a));
        }
        Ok(())
    }
    fn delete_critical_section(&mut self, a: u32) -> Result<(), &'static str> {
        assert!(self.held.is_empty());
        assert!(self.locks.remove(&a));
        Ok(())
    }
    fn create_worker(&mut self, _: &thread::Launch) -> Result<u32, &'static str> {
        Err("use direct engine factory")
    }
    fn exchange_status(&mut self, _: u32) -> Result<u32, &'static str> {
        Err("no global status in direct fixture")
    }
}
impl Boundary for Engine {
    fn allocate_engine(&mut self, n: u32) -> Result<u32, &'static str> {
        self.allocate_kind(n, true)
            .map_err(|_| "engine allocation failed")
    }
    fn byte(&mut self, a: u32) -> Result<u8, &'static str> {
        self.memory.read_byte(a).map_err(|_| "byte unavailable")
    }
    fn initialize_critical_section(&mut self, a: u32) -> Result<(), &'static str> {
        assert!(self.locks.insert(a));
        for i in 0..24 {
            self.memory.write_byte(a + i, 0).unwrap();
        }
        Ok(())
    }
    fn create_crt_worker(&mut self, callback: u32, capsule: u32) -> Result<Handle, &'static str> {
        assert_eq!(callback, CAPSULE_CALLBACK);
        self.capsule = capsule;
        if self.reject_crt {
            Err("CRT unavailable")
        } else {
            Ok(self.handle)
        }
    }
    fn name_current_thread(&mut self, p: u32) -> Result<(), &'static str> {
        let mut value = vec![];
        for i in 0..128 {
            let b = self.byte(p + i)?;
            if b == 0 {
                self.named.push(value);
                return Ok(());
            }
            value.push(b);
        }
        Err("unbounded name")
    }
    fn invoke(&mut self, f: u32, a: u32) -> Result<(), &'static str> {
        self.calls.push((f, a));
        Ok(())
    }
}
#[test]
fn audio_replay_engine_thread_factory_matches32_native_capsule_names_allocators_thread_fields_creation_failures_and_full_cleanup(
) {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_engine_thread_probe.json",
    ))
    .unwrap();
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 32);
    for c in cases {
        let mut b = Engine::from_case(c);
        let name = bytes(c["name_hex"].as_str().unwrap());
        let options = b.options(&name);
        let object = create(&mut b, 0x8fc100, 0, options).unwrap();
        assert_eq!(object, n(&c["thread"]));
        b.compare(&c["created"]);
        assert!(b.queue.is_empty());
        if object != 0 {
            let actual = (0..20)
                .map(|i| b.word(object + i * 4).unwrap())
                .collect::<Vec<_>>();
            assert_eq!(json!(actual), c["thread_words"]);
            let capsule = b.capsule;
            let actual = (0..12)
                .map(|i| b.word(capsule + i * 4).unwrap())
                .collect::<Vec<_>>();
            assert_eq!(json!(actual), c["capsule_words"]);
            assert_eq!(run_capsule(&mut b, capsule).unwrap(), 0);
            b.compare(&c["after_worker"]);
            assert_eq!(b.calls, vec![(0x8fc100, 0)]);
            let native_name = c["thread_events"]
                .as_array()
                .unwrap()
                .iter()
                .find(|e| e["op"] == "thread_name_exception")
                .unwrap()["name"]
                .as_str()
                .unwrap();
            assert_eq!(b.named, vec![native_name.as_bytes().to_vec()]);
            assert_eq!(thread::destroy(&mut b, object).unwrap(), object);
            b.compare(&c["destroyed"]);
        }
        assert!(b.live.is_empty() && b.locks.is_empty() && b.held.is_empty());
    }
}
#[test]
fn audio_replay_engine_thread_missing_crt_adapter_releases_owned_capsule_and_heap_name() {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_engine_thread_probe.json",
    ))
    .unwrap();
    let c = &proof["cases"][7];
    let mut b = Engine::from_case(c);
    b.reject_crt = true;
    let options = b.options(&bytes(c["name_hex"].as_str().unwrap()));
    assert_eq!(
        create(&mut b, 0x8fc100, 0, options),
        Err(Error::Boundary("CRT unavailable"))
    );
    assert!(b.live.is_empty() && b.queue.is_empty());
    assert_eq!(b.freed.len(), 2);
}
