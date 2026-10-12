use crate::audio_announcer_object_lookup::{self as read, Memory};
use crate::audio_announcer_registry_init::{self as init, OwnedMemory, Storage};
use crate::audio_replay_callbacks::{invoke12, Error};
use crate::audio_replay_events::{self as events, Argument};
use serde_json::{json, Value};
const CALLBACK: u32 = 0x30000ff4;
const REFERENCE: u32 = 0x31000000;

struct Backend {
    memory: OwnedMemory,
    reads: Vec<[u32; 2]>,
    calls: Vec<Value>,
    result: u32,
    connected: bool,
}
impl Memory for Backend {
    fn word(&mut self, address: u32) -> Result<u32, read::Error> {
        self.reads.push([address, 4]);
        self.memory.word(address)
    }
}
impl Storage for Backend {
    fn allocate(&mut self, n: u32) -> Result<u32, init::Error> {
        self.memory.allocate(n)
    }
    fn write_word(&mut self, p: u32, v: u32) -> Result<(), init::Error> {
        self.memory.write_word(p, v)
    }
    fn write_byte(&mut self, p: u32, v: u8) -> Result<(), init::Error> {
        self.memory.write_byte(p, v)
    }
    fn register_shutdown(&mut self, f: u32) -> Result<(), init::Error> {
        self.memory.register_shutdown(f)
    }
}
impl events::Boundary for Backend {
    fn byte(&mut self, p: u32) -> Result<u8, read::Error> {
        self.memory.read_byte(p)
    }
    fn virtual_call(
        &mut self,
        _: u32,
        _: u32,
        _: u32,
        _: &[Argument],
    ) -> Result<u32, &'static str> {
        Err("no virtual consumer connected")
    }
    fn member_call(
        &mut self,
        owner: u32,
        member: u32,
        args: [u32; 5],
    ) -> Result<u32, &'static str> {
        self.calls
            .push(json!({"owner":owner,"member":member,"args":args}));
        // This terminal observes the wrapper contract only, never gameplay.
        if !self.connected {
            return Err("member consumer is not connected");
        }
        Ok(self.result)
    }
}
fn n(v: &Value) -> u32 {
    v.as_u64().unwrap().try_into().unwrap()
}
fn hex(b: &Backend, p: u32, len: u32) -> String {
    (0..len)
        .map(|i| format!("{:02x}", b.memory.read_byte(p + i).unwrap()))
        .collect()
}
fn backend(owner: u32, member: u32, result: u32) -> Backend {
    let mut b = Backend {
        memory: OwnedMemory::new(0x34000000, 0xa5),
        reads: vec![],
        calls: vec![],
        result,
        connected: true,
    };
    b.memory.reserve_at(CALLBACK, 12).unwrap();
    b.memory.reserve_at(REFERENCE, 4).unwrap();
    for (o, v) in [(0, 0x108606c), (4, owner), (8, member)] {
        b.write_word(CALLBACK + o, v).unwrap();
    }
    b.write_word(REFERENCE, 0xa5c37129).unwrap();
    b
}
fn proof() -> Value {
    serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/callback12_native_probe.json",
    ))
    .unwrap()
}

#[test]
fn callback12_matches96_native_argument_read_order_aliases_owner_and_full_return_cases() {
    let proof = proof();
    assert_eq!(proof["passed"], true);
    assert_eq!(
        proof["native_sha256"],
        "402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862"
    );
    assert_eq!(n(&proof["wrapper"]), 0x5cceb0);
    assert_eq!(n(&proof["callback"]), CALLBACK);
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 96);
    for (index, c) in cases.iter().enumerate() {
        let mut b = backend(n(&c["owner"]), n(&c["member"]), n(&c["supplied_return"]));
        assert_eq!(hex(&b, CALLBACK, 12), c["before"]);
        let args: [u32; 5] = c["args"]
            .as_array()
            .unwrap()
            .iter()
            .map(n)
            .collect::<Vec<_>>()
            .try_into()
            .unwrap();
        let result = invoke12(&mut b, CALLBACK, args).unwrap();
        assert_eq!(result, n(&c["return"]), "case{index}");
        assert_eq!(json!(b.reads), c["reads"], "read order case{index}");
        assert_eq!(json!(b.calls), c["trace"], "member forwarding case{index}");
        assert_eq!(hex(&b, CALLBACK, 12), c["after"]);
        assert!(b.memory.read_byte(CALLBACK + 12).is_err());
        assert!(c["tail_reads"].as_array().unwrap().is_empty());
        assert_eq!(c["final_stack_delta"], 24);
    }
}

#[test]
fn callback12_has_no_adjustment_read_and_existing16_byte_wrapper_rejects_its_tail() {
    let native = proof();
    let negative = &native["negative_control"];
    assert_eq!(negative["wrapper"], 0x734130);
    assert_eq!(negative["faults"], json!([[CALLBACK + 12, 4]]));
    assert_eq!(negative["terminal_calls"], 0);
    let mut b = backend(0xffffffff, 0x729370, 0xf1234501);
    let args = [REFERENCE, 0xaabbccdd, 0x11223344, 0xfffffffe, 0x12345678];
    assert!(matches!(
        events::invoke(&mut b, CALLBACK, args),
        Err(events::Error::Read(_))
    ));
    assert_eq!(b.reads, vec![[REFERENCE, 4], [CALLBACK + 12, 4]]);
    assert!(b.calls.is_empty());
    b.reads.clear();
    assert_eq!(invoke12(&mut b, CALLBACK, args), Ok(0xf1234501));
    assert_eq!(
        b.reads,
        vec![[REFERENCE, 4], [CALLBACK + 4, 4], [CALLBACK + 8, 4]]
    );
    assert_eq!(b.calls[0]["owner"], u32::MAX);
}

#[test]
fn callback12_reports_disconnected_terminal_and_missing_reference_without_fabricated_success() {
    let mut b = backend(0x12345678, 0x729370, 1);
    b.connected = false;
    assert_eq!(
        invoke12(&mut b, CALLBACK, [REFERENCE, 2, 3, 4, 5]),
        Err(Error::Boundary("member consumer is not connected"))
    );
    assert_eq!(b.calls.len(), 1);
    b.calls.clear();
    b.reads.clear();
    assert!(matches!(
        invoke12(&mut b, CALLBACK, [0xdead0000, 2, 3, 4, 5]),
        Err(Error::Read(_))
    ));
    assert_eq!(b.reads, vec![[0xdead0000, 4]]);
    assert!(b.calls.is_empty());
    b.reads.clear();
    assert_eq!(
        invoke12(&mut b, 0, [REFERENCE, 2, 3, 4, 5]),
        Err(Error::NullCallback)
    );
    assert!(b.reads.is_empty());
}
