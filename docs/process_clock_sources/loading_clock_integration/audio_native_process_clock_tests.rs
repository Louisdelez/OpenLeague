use super::*;
use serde_json::{json, Value};
use std::collections::{BTreeMap, VecDeque};

fn bytes(s: &str) -> Vec<u8> {
    (0..s.len()).step_by(2).map(|i| u8::from_str_radix(&s[i..i + 2], 16).unwrap()).collect()
}
fn hex(b: &[u8]) -> String { b.iter().map(|v| format!("{v:02x}")).collect() }
fn num(v: &Value) -> u32 { v.as_u64().unwrap() as u32 }
fn fixtures() -> Value { serde_json::from_str(include_str!("native_clock_results.json")).unwrap() }

struct Host {
    memory: BTreeMap<u32, u8>,
    events: Vec<Value>,
    queries: VecDeque<Value>,
    qpf_prior: VecDeque<Vec<u8>>,
    fail_read: Option<u32>,
    fail_write: Option<u32>,
    fail_frequency: bool,
    fail_enter: bool,
    fail_leave: bool,
}
impl Host {
    fn new(row: &Value) -> Self {
        let mut memory = BTreeMap::new();
        for region in row["before"].as_array().unwrap() {
            let address = num(&region["address"]);
            for (offset, value) in bytes(region["hex"].as_str().unwrap()).into_iter().enumerate() {
                memory.insert(address + offset as u32, value);
            }
        }
        let qpf_prior = row["events"].as_array().unwrap().iter().filter(|v| v["op"] == "qpf")
            .map(|v| bytes(v["initial_hex"].as_str().unwrap())).collect();
        Self { memory, events: vec![], queries: row["queries"].as_array().unwrap().iter().cloned().collect(), qpf_prior,
               fail_read: None, fail_write: None, fail_frequency: false, fail_enter: false, fail_leave: false }
    }
    fn get(&self, address: u32, size: usize) -> Vec<u8> {
        (0..size).map(|i| *self.memory.get(&(address + i as u32)).unwrap()).collect()
    }
    fn put(&mut self, address: u32, data: &[u8]) {
        for (i, value) in data.iter().enumerate() { self.memory.insert(address + i as u32, *value); }
    }
    fn peek(&self, address: u32) -> u32 { u32::from_le_bytes(self.get(address, 4).try_into().unwrap()) }
    fn query(&mut self, op: &str, prior: Vec<u8>) -> Result<Query, &'static str> {
        let specification = self.queries.pop_front().expect("unexpected API call");
        assert_eq!(specification["op"], op);
        let value = bytes(specification["value_hex"].as_str().unwrap());
        let mask = num(&specification["mask"]);
        let mut output = prior.clone();
        for i in 0..8 { if mask & (1 << i) != 0 { output[i] = value[i]; } }
        let return_value = num(&specification["return_value"]);
        self.events.push(json!({"op":op,"initial_hex":hex(&prior),"output_hex":hex(&output),"return_value":return_value,"mask":mask}));
        if let Some(mutations) = specification["mutations"].as_array() {
            for change in mutations {
                let address = num(&change[0]);
                let size = num(&change[1]) as usize;
                let value = change[2].as_u64().unwrap();
                self.put(address, &value.to_le_bytes()[..size]);
                self.events.push(json!({"op":"api_write","address":address,"bytes":size,"value":value}));
            }
        }
        Ok(Query { return_value, words: [u32::from_le_bytes(output[..4].try_into().unwrap()), u32::from_le_bytes(output[4..].try_into().unwrap())] })
    }
}
impl Boundary for Host {
    fn word(&mut self, address: u32) -> Result<u32, &'static str> {
        if self.fail_read == Some(address) { return Err("read rejected"); }
        let value = self.peek(address);
        self.events.push(json!({"op":"read","address":address,"bytes":4,"value":value})); Ok(value)
    }
    fn byte(&mut self, address: u32) -> Result<u8, &'static str> {
        if self.fail_read == Some(address) { return Err("read rejected"); }
        let value = self.get(address, 1)[0];
        self.events.push(json!({"op":"read","address":address,"bytes":1,"value":value})); Ok(value)
    }
    fn write_word(&mut self, address: u32, value: u32) -> Result<(), &'static str> {
        if self.fail_write == Some(address) { return Err("write rejected"); }
        self.put(address, &value.to_le_bytes());
        self.events.push(json!({"op":"write","address":address,"bytes":4,"value":value})); Ok(())
    }
    fn write_byte(&mut self, address: u32, value: u8) -> Result<(), &'static str> {
        if self.fail_write == Some(address) { return Err("write rejected"); }
        self.put(address, &[value]);
        self.events.push(json!({"op":"write","address":address,"bytes":1,"value":value})); Ok(())
    }
    fn query_frequency(&mut self) -> Result<Query, &'static str> {
        if self.fail_frequency { return Err("QPF output unknown"); }
        let prior = self.qpf_prior.pop_front().expect("QPF untouched bytes must be explicit");
        self.query("qpf", prior)
    }
    fn query_counter(&mut self, initial_words: [u32; 2]) -> Result<Query, &'static str> {
        assert_eq!(initial_words, [0, 0], "source must initialize QPC stack bytes");
        let prior = initial_words.into_iter().flat_map(u32::to_le_bytes).collect();
        self.query("qpc", prior)
    }
    fn enter_once(&mut self) -> Result<(), &'static str> {
        if self.fail_enter { return Err("once setup rejected"); }
        self.events.extend([json!({"op":"once_prepare"}), json!({"op":"once_enter"})]); Ok(())
    }
    fn leave_once(&mut self) -> Result<(), &'static str> {
        self.events.push(json!({"op":"once_leave"}));
        if self.fail_leave { Err("unlock rejected") } else { Ok(()) }
    }
}

#[test]
fn clock_source_matches253_native_sequences349_calls_all_global_bytes_and3387_ordered_events() {
    let proof = fixtures(); assert_eq!(proof["passed"], true); assert_eq!(proof["case_count"], 253);
    assert_eq!(proof["native_sha256"], "402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862");
    let mut event_count = 0; let mut call_count = 0;
    for (index, row) in proof["cases"].as_array().unwrap().iter().enumerate() {
        let mut host = Host::new(row);
        for sample in row["samples"].as_array().unwrap() {
            if row["entry"] == "initialize" { initialize(&mut host).unwrap(); }
            else { assert_eq!(sample_f32_bits(&mut host).unwrap(), num(&sample["bits"]), "case{index}"); }
            call_count += 1;
        }
        assert!(host.queries.is_empty(), "unconsumed API case{index}");
        assert_eq!(json!(host.events), row["events"], "exact global access/API/once event order case{index}");
        event_count += host.events.len();
        for region in row["after"].as_array().unwrap() {
            let expected = bytes(region["hex"].as_str().unwrap());
            assert_eq!(host.get(num(&region["address"]), expected.len()), expected, "full canonical bytes case{index}");
        }
    }
    assert_eq!((call_count, event_count), (349, 3387));
}

#[test]
fn clock_division_matches277_physical_x87_results_including_zero_frequency() {
    let proof: Value = serde_json::from_str(include_str!("clock_x87_hardware.json")).unwrap();
    assert_eq!(proof["passed"], true); assert_eq!(proof["control_word"], 0x37f);
    let rows = proof["cases"].as_array().unwrap(); assert_eq!(rows.len(), 277);
    for (index, row) in rows.iter().enumerate() {
        assert_eq!(divide_to_f32_bits(row["elapsed"].as_u64().unwrap(), row["frequency"].as_u64().unwrap()).unwrap(), num(&row["hardware_bits"]), "physical case{index}");
    }
}

fn fresh() -> Host {
    let proof = fixtures();
    Host::new(proof["cases"].as_array().unwrap().iter().find(|r| r["label"] == "once_repeated" &&
        r["queries"].as_array().unwrap().len() == 4 && r["queries"][0]["mask"] == 255 && r["queries"][0]["return_value"] == 1).unwrap())
}

#[test]
fn clock_host_errors_do_not_publish_ready_and_cleanup_errors_remain_visible() {
    let mut host = fresh(); let before = host.memory.clone();
    host.fail_frequency = true; host.fail_leave = true;
    assert_eq!(sample_f32_bits(&mut host), Err(Error::Cleanup {
        primary: Box::new(Error::Boundary("QPF output unknown")), cleanup: Box::new(Error::Boundary("unlock rejected")),
    }));
    assert_eq!(host.memory, before); assert_eq!(host.events.last().unwrap()["op"], "once_leave");
    assert!(!host.events.iter().any(|e| e["op"] == "qpc"));

    // A write failure after the low cache word preserves source partial state;
    // cache-ready and once-ready stay0, and the acquired lock is released once.
    let mut host = fresh(); host.fail_write = Some(CACHE + 4);
    assert_eq!(sample_f32_bits(&mut host), Err(Error::Boundary("write rejected")));
    assert_eq!(host.peek(CACHE), 10000003); assert_eq!(host.get(CACHE_READY, 1), [0]);
    assert_eq!(host.peek(ONCE_READY), 0);
    assert_eq!(host.events.iter().filter(|e| e["op"] == "once_leave").count(), 1);

    // Publication failure is distinct from initialization failure: the native
    // origin already exists, but the guard must never report initialized.
    let mut host = fresh(); host.fail_write = Some(ONCE_READY);
    assert_eq!(sample_f32_bits(&mut host), Err(Error::Boundary("write rejected")));
    assert_eq!(host.peek(ORIGIN), 123456); assert_eq!(host.peek(ONCE_READY), 0);
    assert_eq!(host.events.last().unwrap()["op"], "once_leave");
}

#[test]
fn clock_guard_read_unknown_callback_and_post_unlock_read_failures_have_correct_lifetimes() {
    let mut host = fresh(); host.fail_enter = true;
    assert_eq!(sample_f32_bits(&mut host), Err(Error::Boundary("once setup rejected")));
    assert!(host.events.is_empty(), "failed acquisition must not be released by caller");

    let mut host = fresh(); host.fail_read = Some(ONCE_READY);
    assert_eq!(sample_f32_bits(&mut host), Err(Error::Boundary("read rejected")));
    assert_eq!(host.events, [json!({"op":"once_prepare"}), json!({"op":"once_enter"}), json!({"op":"once_leave"})]);

    let mut host = fresh(); host.put(CALLBACK_VTABLE, &0x12345678u32.to_le_bytes());
    assert_eq!(sample_f32_bits(&mut host), Err(Error::UnknownCallback(0x12345678)));
    assert_eq!(host.peek(ONCE_READY), 0); assert_eq!(host.events.last().unwrap()["op"], "once_leave");
    assert!(!host.events.iter().any(|e| e["op"] == "qpf"));

    let proof = fixtures();
    let row = proof["cases"].as_array().unwrap().iter().find(|r| r["label"] == "unsigned_arithmetic").unwrap();
    let mut host = Host::new(row); host.fail_read = Some(ORIGIN);
    assert_eq!(sample_f32_bits(&mut host), Err(Error::Boundary("read rejected")));
    let ops: Vec<_> = host.events.iter().map(|v| v["op"].as_str().unwrap()).collect();
    assert_eq!(ops, ["once_prepare", "once_enter", "read", "once_leave", "qpc"]);
}
