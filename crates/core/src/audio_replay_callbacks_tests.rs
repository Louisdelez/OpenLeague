use super::*;
use read::Memory;
use serde_json::{json, Value};
use std::collections::BTreeMap;
struct Host {
    memory: init::OwnedMemory,
    live: BTreeMap<u32, u32>,
    allocations: Vec<Value>,
    freed: Vec<u32>,
    null_next: bool,
}
impl Memory for Host {
    fn word(&mut self, p: u32) -> Result<u32, read::Error> {
        self.memory.word(p)
    }
}
impl Storage for Host {
    fn allocate(&mut self, n: u32) -> Result<u32, init::Error> {
        let p = self.memory.allocate(n)?;
        self.live.insert(p, n);
        self.allocations.push(json!({"bytes":n,"pointer":p}));
        Ok(p)
    }
    fn write_word(&mut self, p: u32, v: u32) -> Result<(), init::Error> {
        Storage::write_word(&mut self.memory, p, v)
    }
    fn write_byte(&mut self, p: u32, v: u8) -> Result<(), init::Error> {
        self.memory.write_byte(p, v)
    }
    fn register_shutdown(&mut self, _: u32) -> Result<(), init::Error> {
        Err(init::Error::Backend("unexpected shutdown registration"))
    }
}
impl remove::Backend for Host {
    fn write_word(&mut self, p: u32, v: u32) -> Result<(), remove::Error> {
        Storage::write_word(self, p, v).map_err(remove::Error::Owned)
    }
    fn deallocator(&mut self) -> Result<remove::Deallocator, remove::Error> {
        Ok(remove::Deallocator::Standard)
    }
    fn free(&mut self, p: u32, route: remove::Deallocator) -> Result<(), remove::Error> {
        assert_eq!(route, remove::Deallocator::Standard);
        assert!(self.live.remove(&p).is_some(), "free unknown {p:x}");
        self.memory.release(p).map_err(remove::Error::Owned)?;
        self.freed.push(p);
        Ok(())
    }
}
impl callback::Boundaries for Host {
    fn allocate_callback_clone(&mut self, n: u32) -> Result<u32, &'static str> {
        if self.null_next {
            self.null_next = false;
            self.allocations.push(json!({"bytes":n,"pointer":0}));
            return Ok(0);
        }
        let p = self.memory.allocate(n).map_err(|_| "allocation failed")?;
        self.live.insert(p, n);
        self.allocations
            .push(json!({"bytes":n,"pointer":p,"allocator":"engine_operator_new"}));
        Ok(p)
    }
    fn register_listener(
        &mut self,
        _: u32,
        _: u32,
        _: u32,
        _: &mut u32,
    ) -> Result<(), &'static str> {
        Err("unexpected registration")
    }
    fn unregister_listener(&mut self, _: u32, _: u32, _: u32) -> Result<(), &'static str> {
        Err("unexpected removal")
    }
}
fn fixture() -> Value {
    serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_callbacks_probe.json",
    ))
    .unwrap()
}
fn u(v: &Value) -> u32 {
    v.as_u64().unwrap() as u32
}
fn host(proof: &Value, start: u32, fill: u8) -> Host {
    let mut b = Host {
        memory: init::OwnedMemory::new(start, fill),
        live: BTreeMap::new(),
        allocations: vec![],
        freed: vec![],
        null_next: false,
    };
    for row in proof["vtables"].as_array().unwrap() {
        let p = u(&row[0]);
        b.memory.reserve_at(p, 12).unwrap();
        for (i, v) in row[1].as_array().unwrap().iter().enumerate() {
            Storage::write_word(&mut b.memory, p + i as u32 * 4, u(v)).unwrap();
        }
    }
    b.memory.reserve_at(BUNDLE_VTABLE, 4).unwrap();
    Storage::write_word(
        &mut b.memory,
        BUNDLE_VTABLE,
        u(&proof["bundle_vtable"][1][0]),
    )
    .unwrap();
    b
}
fn compare(b: &mut Host, expected: &Value) {
    assert_eq!(
        json!(b.allocations),
        expected["allocations"],
        "allocation order/routes"
    );
    assert_eq!(json!(b.freed), expected["freed"], "free order");
    let mut words = Vec::new();
    for (&p, &n) in &b.live {
        for i in (0..n).step_by(4) {
            words.push([p + i, b.memory.word(p + i).unwrap()]);
        }
    }
    assert_eq!(json!(words), expected["words"], "every live word");
    b.allocations.clear();
    b.freed.clear();
}
fn make(b: &mut Host, fid: u32, owner: u32, member: u32, extra: u32) -> u32 {
    if [0x658f70, 0x7338c0].contains(&fid) {
        factory_member(b, fid, owner, member, extra).unwrap()
    } else {
        factory(b, fid, owner).unwrap()
    }
}
#[test]
fn audio_replay_callback_families_match216_native_factory_clone_scalar_delete_lifetimes() {
    let proof = fixture();
    let rows = proof["factory_cases"].as_array().unwrap();
    assert_eq!(rows.len(), 216);
    for c in rows {
        let mut b = host(&proof, u(&c["pointer"]), u(&c["fill"]) as u8);
        let p = make(
            &mut b,
            u(&c["factory"]),
            u(&c["owner"]),
            u(&c["member"]),
            u(&c["extra"]),
        );
        assert_eq!(p, u(&c["pointer"]));
        compare(&mut b, &c["created"]);
        let q = clone(&mut b, p).unwrap();
        assert_eq!(q, u(&c["clone_pointer"]));
        compare(&mut b, &c["cloned"]);
        scalar_delete(&mut b, q, u(&c["flags"])).unwrap();
        compare(&mut b, &c["deleted"]);
        if u(&c["flags"]) & 1 == 0 {
            free(&mut b, q).unwrap();
        }
        delete(&mut b, p).unwrap();
        compare(&mut b, &c["finished"]);
        assert!(b.live.is_empty());
    }
}
#[test]
fn audio_replay_callback_factories_and_clones_match36_explicit_native_null_allocations() {
    let proof = fixture();
    let rows = proof["null_cases"].as_array().unwrap();
    assert_eq!(rows.len(), 36);
    for c in rows {
        let failed_factory = c["failure"] == "factory";
        let mut b = host(
            &proof,
            if failed_factory {
                0x38000000
            } else {
                u(&c["pointer"])
            },
            u(&c["fill"]) as u8,
        );
        b.null_next = failed_factory;
        let p = make(&mut b, u(&c["factory"]), 0x30008500, 0x738a3a, 0x13579bdf);
        assert_eq!(p, u(&c["pointer"]));
        compare(&mut b, &c["created"]);
        if !failed_factory {
            b.null_next = true;
            assert_eq!(clone(&mut b, p).unwrap(), 0);
            compare(&mut b, &c["cloned"]);
            delete(&mut b, p).unwrap();
        }
        compare(&mut b, &c["finished"]);
        assert!(b.live.is_empty());
    }
}
#[test]
fn audio_replay_callback_service_vtable10afd08_matches12_native_clone_lifetimes() {
    let proof = fixture();
    let rows = proof["extra_clone_cases"].as_array().unwrap();
    assert_eq!(rows.len(), 12);
    for c in rows {
        let mut b = host(&proof, u(&c["pointer"]), u(&c["fill"]) as u8);
        let p = b.allocate(16).unwrap();
        for (off, v) in [
            (0, 0x10afd08),
            (4, 0x30008500),
            (8, 0x72b950),
            (12, u(&c["extra"])),
        ] {
            put(&mut b, p, off, v).unwrap();
        }
        compare(&mut b, &c["created"]);
        b.null_next = c["null_clone"].as_bool().unwrap();
        let q = clone(&mut b, p).unwrap();
        assert_eq!(q, u(&c["clone_pointer"]));
        compare(&mut b, &c["cloned"]);
        delete(&mut b, q).unwrap();
        delete(&mut b, p).unwrap();
        compare(&mut b, &c["finished"]);
        assert!(b.live.is_empty());
    }
}
#[test]
fn audio_replay_callback_bundle_replacement_and_parent_wrappers_match48_native_lifetimes() {
    let proof = fixture();
    let rows = proof["replace_cases"].as_array().unwrap();
    assert_eq!(rows.len(), 48);
    for c in rows {
        let mut b = host(&proof, u(&c["bundle"]), u(&c["fill"]) as u8);
        let output = u(&c["output"]);
        let parent = u(&c["parent"]);
        b.memory.reserve_at(output, 4).unwrap();
        b.memory.reserve_at(parent, 68).unwrap();
        let p = b.allocate(20).unwrap();
        construct_bundle(&mut b, p).unwrap();
        put(&mut b, parent, 0x28, p).unwrap();
        let offset = u(&c["offset"]);
        let old = if c["old_present"].as_bool().unwrap() {
            make(
                &mut b,
                u(&c["old_factory"]),
                0x30008500,
                0x738a3a,
                0x13579bdf,
            )
        } else {
            0
        };
        put(&mut b, p, offset, old).unwrap();
        let incoming = if c["new_present"].as_bool().unwrap() {
            make(
                &mut b,
                u(&c["new_factory"]),
                0x30008600,
                0x738a3a,
                0x13579bdf,
            )
        } else {
            0
        };
        assert_eq!(incoming, u(&c["incoming"]));
        compare(&mut b, &c["created"]);
        let result = if c["wrapper"].as_bool().unwrap() {
            parent_replace(&mut b, parent, offset, output, incoming)
        } else {
            replace(&mut b, p, offset, output, incoming)
        }
        .unwrap();
        assert_eq!(result, output);
        let returned = b.word(output).unwrap();
        assert_eq!(returned, u(&c["returned"]));
        compare(&mut b, &c["replaced"]);
        delete(&mut b, returned).unwrap();
        delete_bundle(&mut b, p, 1).unwrap();
        compare(&mut b, &c["finished"]);
        assert!(b.live.is_empty());
    }
}
#[test]
fn audio_replay_callback_bundle_matches8_native_reverse_order_destructors_and_flags() {
    let proof = fixture();
    let rows = proof["bundle_cases"].as_array().unwrap();
    assert_eq!(rows.len(), 8);
    for c in rows {
        let mut b = host(&proof, u(&c["bundle"]), u(&c["fill"]) as u8);
        let p = b.allocate(20).unwrap();
        construct_bundle(&mut b, p).unwrap();
        for (offset, fid) in [4, 8, 12, 16]
            .into_iter()
            .zip([0x733540, 0x7337c0, 0x658f70, 0x7338c0])
        {
            let q = make(&mut b, fid, 0x30008500 + offset, 0x738a3a, 0x13579bdf);
            put(&mut b, p, offset, q).unwrap();
        }
        compare(&mut b, &c["created"]);
        delete_bundle(&mut b, p, u(&c["flags"])).unwrap();
        compare(&mut b, &c["deleted"]);
        if u(&c["flags"]) & 1 == 0 {
            free(&mut b, p).unwrap();
        }
        compare(&mut b, &c["finished"]);
        assert!(b.live.is_empty());
    }
}
#[test]
fn audio_replay_callback_member_dispatch_is_an_explicit_boundary_without_allocations() {
    let proof = fixture();
    let mut b = host(&proof, 0x38000000, 165);
    assert_eq!(clone(&mut b, 0), Ok(0));
    assert_eq!(delete(&mut b, 0), Ok(()));
    assert_eq!(invoke(&mut b, 0), Err(Error::NullCallback));
    for fid in FACTORIES {
        let p = factory(&mut b, fid, 0x30008500).unwrap();
        let owner = b.word(p + 4).unwrap();
        let member = b.word(p + 8).unwrap();
        let vt = b.word(p).unwrap();
        let dispatcher = b.word(vt + 8).unwrap();
        let n = b.allocations.len();
        assert_eq!(
            invoke(&mut b, p),
            Err(Error::UnconnectedMember {
                dispatcher,
                owner,
                member
            })
        );
        assert_eq!(b.allocations.len(), n);
        delete(&mut b, p).unwrap();
    }
    assert_eq!(factory(&mut b, 0, 0), Err(Error::UnknownFactory(0)));
    assert!(b.live.is_empty());
}
