use super::*;
use crate::audio_announcer_object_lookup::{self as read, Memory};
use crate::audio_announcer_registry_init::{self as init, OwnedMemory};
use crate::audio_announcer_registry_remove::{self as remove, Backend, Deallocator};
use serde_json::{json, Value};
const H: u32 = 0x30000000;
const RECIP: u32 = H + 0x100;
const HEAD: u32 = H + 0x1000;
const PAYLOAD: u32 = H + 0x3000;
const SCR: u32 = H + 0x3400;
const SERVICE: u32 = H + 0x3500;
const TABLE: u32 = H + 0x3600;
const DATA: u32 = H + 0x3900;
const KEYS: [u32; 9] = [
    0, 1, 0x7ffffffe, 0x7fffffff, 0x80000000, 0x80000001, 0xdeadbeef, 0xfffffffe, 0xffffffff,
];
fn n(v: &Value) -> u32 {
    v.as_u64().unwrap() as u32
}
fn bytes(s: &str) -> Vec<u8> {
    s.as_bytes()
        .chunks_exact(2)
        .map(|s| u8::from_str_radix(std::str::from_utf8(s).unwrap(), 16).unwrap())
        .collect()
}
fn fixture(name: &str) -> Value {
    serde_json::from_str(&crate::audio_test_fixture(name)).unwrap()
}
struct Host {
    memory: OwnedMemory,
    target: u32,
    fill: u8,
    events: Vec<Value>,
    name: Vec<u8>,
    provider_output: Option<Vec<u8>>,
    mutate: bool,
    detailed: bool,
    fail_name: bool,
    fail_clock: bool,
    fail_free: bool,
    freed: Vec<u32>,
    clock_calls: u32,
    standard_calls: u32,
}
impl Host {
    fn raw(&mut self, p: u32) -> u32 {
        self.memory.word(p).unwrap()
    }
    fn put(&mut self, p: u32, v: u32) {
        Storage::write_word(&mut self.memory, p, v).unwrap();
    }
    fn byte(&mut self, p: u32, v: u8) {
        self.memory.write_byte(p, v).unwrap();
    }
    fn set(&mut self, p: u32, v: &[u8]) {
        for (i, &v) in v.iter().enumerate() {
            self.byte(p + i as u32, v);
        }
    }
    fn snapshot(&self, p: u32, len: u32) -> Vec<u8> {
        (p..p + len)
            .map(|a| self.memory.read_byte(a).unwrap())
            .collect()
    }
    fn watched(&self, p: u32) -> bool {
        self.target <= p && p < self.target + 120
            || SCR <= p && p < SCR + 24
            || [SERVICE_GLOBAL, SERVICE, TABLE + 0x48, PAYLOAD].contains(&p)
    }
    fn event(&mut self, op: &str, p: u32, size: u32, v: u32) {
        if self.detailed && self.watched(p) {
            self.events
                .push(json!({"op":op,"address":p,"bytes":size,"value":v}));
        }
    }
}
impl Memory for Host {
    fn word(&mut self, p: u32) -> Result<u32, read::Error> {
        let v = self.memory.word(p)?;
        if self.detailed && p == SCR + 20 {
            self.events
                .push(json!({"op":"destroy_string","pointer":SCR}));
        }
        self.event("read", p, 4, v);
        Ok(v)
    }
}
impl Storage for Host {
    fn allocate(&mut self, size: u32) -> Result<u32, init::Error> {
        self.memory.allocate(size)
    }
    fn write_word(&mut self, p: u32, v: u32) -> Result<(), init::Error> {
        Storage::write_word(&mut self.memory, p, v)?;
        self.event("write", p, 4, v);
        Ok(())
    }
    fn write_byte(&mut self, p: u32, v: u8) -> Result<(), init::Error> {
        self.memory.write_byte(p, v)?;
        self.event("write", p, 1, v as u32);
        Ok(())
    }
    fn register_shutdown(&mut self, p: u32) -> Result<(), init::Error> {
        self.memory.register_shutdown(p)
    }
}
impl Backend for Host {
    fn write_word(&mut self, p: u32, v: u32) -> Result<(), remove::Error> {
        Storage::write_word(self, p, v).map_err(remove::Error::Owned)
    }
    fn deallocator(&mut self) -> Result<Deallocator, remove::Error> {
        Ok(Deallocator::Standard)
    }
    fn free(&mut self, p: u32, _: Deallocator) -> Result<(), remove::Error> {
        if self.fail_free {
            return Err(remove::Error::Backend("injected free failure"));
        }
        self.freed.push(p);
        self.events.push(json!({"op":"free","pointer":p}));
        //DATA is an explicitly seeded provider-owned result for this boundary
        //oracle, so observe its release as the native CRT adapter does.
        if p != DATA {
            self.memory.release(p).map_err(remove::Error::Owned)?;
        }
        Ok(())
    }
}
impl tree::Boundary for Host {
    fn read_byte(&mut self, p: u32) -> Result<u8, read::Error> {
        let v = self.memory.read_byte(p)?;
        self.event("read", p, 1, v as u32);
        Ok(v)
    }
    fn initialize_lock(&mut self, _: u32) -> Result<(), &'static str> {
        Err("unexpected lock")
    }
    fn destroy_lock(&mut self, _: u32) -> Result<(), &'static str> {
        Err("unexpected lock")
    }
    fn enter_lock(&mut self, _: u32) -> Result<(), &'static str> {
        Err("unexpected lock")
    }
    fn leave_lock(&mut self, _: u32) -> Result<(), &'static str> {
        Err("unexpected lock")
    }
}
impl Boundary for Host {
    fn service_name(
        &mut self,
        service: u32,
        target: u32,
        out: u32,
        key: u32,
    ) -> Result<(), &'static str> {
        assert_eq!((service, target, out), (SERVICE, 0x32000100, SCR));
        if self.fail_name {
            return Err("service unavailable");
        }
        self.events
            .push(json!({"op":"name","service":service,"target":target,"output":out,"key":key}));
        // This boundary-only test replays the exact output of the separately
        // executed native provider. The Windows tests exercise that provider.
        if let Some(output) = self.provider_output.clone() {
            self.set(out, &output);
            return Ok(());
        }
        self.set(out, &[self.fill; 24]);
        let name = self.name.clone();
        if name.len() < 16 {
            self.set(out, &name);
            self.byte(out + name.len() as u32, 0);
            self.put(out + 20, 15);
        } else {
            self.put(out, DATA);
            self.set(DATA, &name);
            self.byte(DATA + name.len() as u32, 0);
            self.put(out + 20, 47);
        }
        self.put(out + 16, name.len() as u32);
        if self.mutate {
            self.put(self.target + 16, 0x7fc00001);
            self.put(self.target + 12, 0x80000001);
        }
        Ok(())
    }
    fn clock_f32_bits(&mut self) -> Result<u32, &'static str> {
        self.clock_calls += 1;
        if self.fail_clock {
            return Err("clock unavailable");
        }
        self.events.push(json!({"op":"clock","bits":0x42f6e979u32}));
        Ok(0x42f6e979)
    }
    fn initialize_standard_record(
        &mut self,
        recipient: u32,
        retained_service: u32,
        record: u32,
        payload: u32,
        scratch: u32,
    ) -> Result<(), &'static str> {
        assert_eq!(retained_service, SERVICE);
        assert_eq!(
            (recipient, record, payload, scratch),
            (RECIP, self.target, PAYLOAD, SCR)
        );
        assert_ne!(self.raw(SCR + 16), 0);
        self.standard_calls += 1;
        Err("native loading-screen UI continuation57D6FE is not connected")
    }
}
fn node(i: usize) -> u32 {
    H + 0x1200 + i as u32 * 0x100
}
fn branch(b: &mut Host, indices: &[usize], parent: u32, depth: u32) -> u32 {
    if indices.is_empty() {
        return HEAD;
    }
    let m = indices.len() / 2;
    let p = node(indices[m]);
    b.put(p + 4, parent);
    b.byte(p + 12, if depth == 3 { 0 } else { 1 });
    let l = branch(b, &indices[..m], p, depth + 1);
    let r = branch(b, &indices[m + 1..], p, depth + 1);
    b.put(p, l);
    b.put(p + 8, r);
    p
}
fn host(kind: Kind, fill: u8, key_index: usize) -> Host {
    let mut b = Host {
        memory: OwnedMemory::new(0x34000000, fill),
        target: node(key_index) + 20,
        fill,
        events: vec![],
        name: vec![],
        provider_output: None,
        mutate: false,
        detailed: false,
        fail_name: false,
        fail_clock: false,
        fail_free: false,
        freed: vec![],
        clock_calls: 0,
        standard_calls: 0,
    };
    b.memory.reserve_at(H, 0x4000).unwrap();
    b.memory.reserve_at(SERVICE_GLOBAL, 4).unwrap();
    let offset = match kind {
        Kind::Standard => 0x1c,
        Kind::Tutorial => 4,
    };
    b.put(
        RECIP,
        match kind {
            Kind::Standard => 0x1084ea4,
            Kind::Tutorial => 0x10863fc,
        },
    );
    b.put(RECIP + offset, HEAD);
    b.put(RECIP + offset + 4, 9);
    b.put(HEAD, node(0));
    b.put(HEAD + 8, node(8));
    b.byte(HEAD + 12, 1);
    b.byte(HEAD + 13, 1);
    for (i, key) in KEYS.iter().enumerate() {
        let p = node(i);
        b.put(p + 16, *key);
        b.byte(p + 12, 1);
        b.byte(p + 13, 0);
        let record = p + 20;
        let s = record
            + match kind {
                Kind::Standard => 0x30,
                Kind::Tutorial => 0x28,
            };
        b.set(s, b"present\0");
        b.put(s + 16, 7);
        b.put(s + 20, 15);
        if matches!(kind, Kind::Standard) {
            b.byte(record + 0x60, 0);
            b.put(record + 0x70, 0);
            b.put(record + 0x74, 15);
        }
    }
    let root = branch(&mut b, &(0..9).collect::<Vec<_>>(), HEAD, 0);
    b.put(HEAD + 4, root);
    b.put(SERVICE_GLOBAL, SERVICE);
    b.put(SERVICE, TABLE);
    b.put(TABLE + 0x48, 0x32000100);
    b
}
#[test]
fn audio_loading_screen_packet_matches1600_existing_native_records_all_flags() {
    let p = fixture("data/4.20/replay_loading_existing_record_probe.json");
    let cases = p["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 1600);
    for c in cases {
        let kind = if c["kind"] == "standard" {
            Kind::Standard
        } else {
            Kind::Tutorial
        };
        let mut b = host(kind, n(&c["fill"]) as u8, n(&c["key_index"]) as usize);
        let record = b.target;
        assert_eq!(
            b.snapshot(
                record,
                if matches!(kind, Kind::Standard) {
                    120
                } else {
                    76
                }
            ),
            bytes(c["record_before_hex"].as_str().unwrap())
        );
        b.set(PAYLOAD, &bytes(c["payload_hex"].as_str().unwrap()));
        let mut expected = b.snapshot(H, 0x4000);
        let after = bytes(c["record_after_hex"].as_str().unwrap());
        let off = (record - H) as usize;
        expected[off..off + after.len()].copy_from_slice(&after);
        receive(&mut b, kind, RECIP, PAYLOAD, SCR).unwrap();
        assert_eq!(
            b.snapshot(H, 0x4000),
            expected,
            "{kind:?} flag{}",
            c["flag"]
        );
        assert!(b.freed.is_empty());
        assert_eq!(b.clock_calls, 0);
        assert!(b.memory.allocations.is_empty());
    }
}
#[test]
fn audio_loading_screen_packet_tutorial_matches256_first_name_native_contracts() {
    let p = fixture("data/4.20/tutorial_first_name_probe.json");
    let cases = p["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 256);
    for c in cases {
        let mut b = host(Kind::Tutorial, n(&c["fill"]) as u8, 4);
        let record = b.target;
        b.set(record, &bytes(c["record_before_hex"].as_str().unwrap()));
        b.set(PAYLOAD, &bytes(c["payload_hex"].as_str().unwrap()));
        b.name = bytes(c["name_hex"].as_str().unwrap());
        b.mutate = c["mutate_record"].as_bool().unwrap();
        b.detailed = true;
        receive(&mut b, Kind::Tutorial, RECIP, PAYLOAD, SCR).unwrap();
        assert_eq!(
            b.snapshot(record, 76),
            bytes(c["record_after_hex"].as_str().unwrap())
        );
        assert_eq!(
            b.snapshot(SCR, 24),
            bytes(c["scratch_after_hex"].as_str().unwrap())
        );
        assert_eq!(
            json!(b.events),
            c["events"],
            "flags{} name{} mutate{}",
            c["flags"],
            c["name_hex"],
            c["mutate_record"]
        );
        assert_eq!(json!(b.freed), c["freed"]);
    }
}
#[test]
fn audio_loading_screen_packet_x87_bits_match26_physical_load_store_cases() {
    let p = fixture("data/4.20/x87_copy_hardware.json");
    let cases = p["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 26);
    for c in cases {
        assert_eq!(x87_f32_roundtrip(n(&c["input_bits"])), n(&c["output_bits"]));
    }
}
#[test]
fn audio_loading_screen_packet_reports_absent_ui_and_cleans_tutorial_name_on_clock_error() {
    let mut b = host(Kind::Standard, 165, 4);
    let record = b.target;
    b.put(record + 0x40, 0);
    b.put(PAYLOAD, KEYS[4]);
    b.name = b"nonempty".to_vec();
    assert_eq!(
        receive(&mut b, Kind::Standard, RECIP, PAYLOAD, SCR),
        Err(Error::Boundary(
            "native loading-screen UI continuation57D6FE is not connected"
        ))
    );
    assert_eq!(b.raw(record), KEYS[4]);
    assert_eq!(b.clock_calls, 0);
    for fail_free in [false, true] {
        let mut b = host(Kind::Tutorial, 165, 4);
        let record = b.target;
        b.put(record + 0x38, 0);
        b.put(PAYLOAD, KEYS[4]);
        b.name = b"LoadingRecipientNameLongerThan15".to_vec();
        b.fail_clock = true;
        b.fail_free = fail_free;
        let result = receive(&mut b, Kind::Tutorial, RECIP, PAYLOAD, SCR);
        if fail_free {
            assert!(matches!(result, Err(Error::Cleanup { .. })));
        } else {
            assert_eq!(result, Err(Error::Boundary("clock unavailable")));
            assert_eq!(b.freed, [DATA]);
            assert_eq!(b.raw(SCR + 16), 0);
            assert_eq!(b.raw(SCR + 20), 15);
        }
    }
}

// The native fixture records the complete provider chain as well as its caller.
// Keep the caller's record operations and post-provider String24 operations;
// provider internals have their own native composition and Windows tests.
fn native_empty_caller_events(step: &Value, record: u32) -> Vec<Value> {
    let native_record = n(&step["record"]);
    let native_scratch = n(&step["temporary_string"]);
    let mut caller = false;
    let mut events = vec![];
    for e in step["events"].as_array().unwrap() {
        if e["op"] == "record_ready" || e["op"] == "provider_return" {
            caller = true;
        } else if e["op"] == "call" && n(&e["method"]) == 0x72ad90 {
            caller = false;
        }
        if !caller || !(e["op"] == "read" || e["op"] == "write") {
            continue;
        }
        let p = n(&e["pointer"]);
        let address = if (native_record..native_record + 120).contains(&p) {
            record + p - native_record
        } else if (native_scratch..native_scratch + 24).contains(&p) {
            SCR + p - native_scratch
        } else {
            continue;
        };
        events.push(json!({"op":e["op"],"address":address,"bytes":e["bytes"],"value":e["value"]}));
    }
    events
}

#[test]
fn audio_loading_screen_packet_standard_matches64_native_empty_name_calls() {
    let oracle = fixture("data/4.20/loading_standard_empty_name_probe.json");
    assert_eq!(oracle["passed"], true);
    let cases = oracle["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 16);
    let mut calls = 0;
    for c in cases {
        let id = n(&c["identifier"]);
        let index = match id {
            73 | 9000 => 1,
            0x80000000 => 4,
            0xffffffff => 8,
            _ => panic!("unknown native profile"),
        };
        let mut b = host(Kind::Standard, n(&c["fill"]) as u8, index);
        b.put(node(index) + 16, id);
        let record = b.target;
        for step in c["steps"].as_array().unwrap() {
            b.detailed = false;
            b.set(record, &bytes(step["record_before_hex"].as_str().unwrap()));
            b.set(PAYLOAD, &bytes(step["payload_hex"].as_str().unwrap()));
            b.set(SCR, &[0xcc; 24]);
            let returned = step["events"]
                .as_array()
                .unwrap()
                .iter()
                .find(|e| e["op"] == "provider_return")
                .unwrap();
            b.provider_output = Some(bytes(returned["hex"].as_str().unwrap()));
            let mut expected = b.snapshot(H, 0x4000);
            let after = bytes(step["record_after_hex"].as_str().unwrap());
            expected[(record - H) as usize..(record - H) as usize + 120].copy_from_slice(&after);
            let scratch = bytes(step["temporary_string_hex"].as_str().unwrap());
            expected[(SCR - H) as usize..(SCR - H) as usize + 24].copy_from_slice(&scratch);
            b.events.clear();
            b.detailed = true;
            receive(&mut b, Kind::Standard, RECIP, PAYLOAD, SCR).unwrap();
            assert_eq!(
                b.snapshot(H, 0x4000),
                expected,
                "{} flag{}",
                c["profile"],
                step["flags"]
            );
            let actual: Vec<_> = b
                .events
                .iter()
                .filter(|e| {
                    if !(e["op"] == "read" || e["op"] == "write") {
                        return false;
                    }
                    let p = n(&e["address"]);
                    (record..record + 120).contains(&p) || (SCR..SCR + 24).contains(&p)
                })
                .cloned()
                .collect();
            assert_eq!(actual, native_empty_caller_events(step, record));
            let name = b.events.iter().position(|e| e["op"] == "name").unwrap();
            let reads: Vec<_> = b.events[..name]
                .iter()
                .filter(|e| {
                    e["op"] == "read"
                        && [SERVICE_GLOBAL, PAYLOAD, SERVICE, TABLE + 0x48]
                            .contains(&n(&e["address"]))
                })
                .map(|e| n(&e["address"]))
                .collect();
            assert_eq!(
                &reads[reads.len() - 4..],
                &[SERVICE_GLOBAL, PAYLOAD, SERVICE, TABLE + 0x48]
            );
            assert_eq!(b.events[name]["key"], id);
            assert_eq!(b.clock_calls, 0);
            assert_eq!(b.standard_calls, 0);
            assert!(b.freed.is_empty());
            assert!(b.memory.allocations.is_empty());
            calls += 1;
        }
    }
    assert_eq!(calls, 64);
}

#[test]
fn audio_loading_screen_packet_standard_drops_name_after_unsupported_ui_without_reset() {
    for (name, fail_free) in [
        (b"short".as_slice(), false),
        (b"LoadingRecipientNameLongerThan15".as_slice(), false),
        (b"LoadingRecipientNameLongerThan15".as_slice(), true),
    ] {
        let mut b = host(Kind::Standard, 165, 4);
        let record = b.target;
        b.put(record + 0x40, 0);
        b.put(PAYLOAD, KEYS[4]);
        b.name = name.to_vec();
        b.fail_free = fail_free;
        let result = receive(&mut b, Kind::Standard, RECIP, PAYLOAD, SCR);
        if fail_free {
            assert!(matches!(result, Err(Error::Cleanup { primary, cleanup })
                if *primary == Error::Boundary("native loading-screen UI continuation57D6FE is not connected")
                && matches!(*cleanup, Error::Free(_))));
        } else {
            assert_eq!(
                result,
                Err(Error::Boundary(
                    "native loading-screen UI continuation57D6FE is not connected"
                ))
            );
        }
        assert_eq!(b.standard_calls, 1);
        assert_eq!(b.clock_calls, 0);
        assert_eq!(b.raw(SCR + 16), name.len() as u32);
        assert_eq!(b.raw(SCR + 20), if name.len() < 16 { 15 } else { 47 });
        assert_eq!(
            b.freed,
            if name.len() >= 16 && !fail_free {
                vec![DATA]
            } else {
                vec![]
            }
        );
    }
    // A provider error owns its rollback. The uninitialized output must not
    // be inspected or destroyed by this caller.
    let mut b = host(Kind::Standard, 165, 4);
    let record = b.target;
    b.put(record + 0x40, 0);
    b.put(PAYLOAD, KEYS[4]);
    b.fail_name = true;
    b.detailed = true;
    assert_eq!(
        receive(&mut b, Kind::Standard, RECIP, PAYLOAD, SCR),
        Err(Error::Boundary("service unavailable"))
    );
    assert!(!b.events.iter().any(|e| e["op"] == "destroy_string"));
    assert_eq!(b.standard_calls, 0);
    assert_eq!(b.clock_calls, 0);
}
