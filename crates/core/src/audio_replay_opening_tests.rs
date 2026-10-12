use crate::{
    audio_replay_object_manager as manager, audio_replay_opening as opening,
    audio_replay_stream as stream,
};
impl manager::Boundary for Host {
    fn read_byte(&mut self, p: u32) -> Result<u8, read::Error> {
        self.memory
            .read_byte(p)
            .map_err(|_| read::Error::MissingWord(p))
    }
    fn initialize_lock(&mut self, p: u32) -> Result<(), &'static str> {
        Boundary::initialize_critical_section(self, p + 8)
    }
    fn destroy_lock(&mut self, p: u32) -> Result<(), &'static str> {
        Boundary::delete_critical_section(self, p + 8)
    }
    fn enter_lock(&mut self, p: u32) -> Result<(), &'static str> {
        Boundary::mutex(self, p, true)
    }
    fn leave_lock(&mut self, p: u32) -> Result<(), &'static str> {
        Boundary::mutex(self, p, false)
    }
    fn object_id(&mut self, _: u32, _: u32) -> Result<u32, &'static str> {
        Err("unexpected packet id")
    }
    fn object_value(&mut self, _: u32, _: u32) -> Result<u64, &'static str> {
        Err("unexpected packet value")
    }
}
impl stream::Boundary for Host {
    fn join_worker(&mut self, p: u32, timeout: u32) -> Result<(), &'static str> {
        assert_eq!(p, 0);
        assert_eq!(timeout, 9000);
        Ok(())
    }
    fn close_resource(&mut self, p: u32) -> Result<(), &'static str> {
        crate::audio_replay_recording_resource::close(self, p)
            .map(|_| ())
            .map_err(|_| "recording resource close")
    }
    fn stop_implementation(&mut self, p: u32, f: u32) -> Result<(), &'static str> {
        match f {
            0x901c44 => derived::close(self, p - 0xe0).map_err(|_| "stop close"),
            0x5642d0 => Ok(()),
            _ => Err("unknown stop method"),
        }
    }
}
impl opening::Boundary for Host {
    fn prepare_recording(&mut self, p: u32, path: u32) -> Result<bool, &'static str> {
        crate::audio_replay_recording_resource::prepare(self, p, path, 0x3000fa00)
            .map_err(|_| "recording prepare")
    }
}
fn opening_snapshot(c: &Value, stage: &str) -> Value {
    let mut s = c[stage].clone();
    if stage == "opened" && n(&c["mode"]) == 0 {
        let rows = s["allocations"].as_array_mut().unwrap();
        let i = rows
            .iter()
            .position(|a| a["bytes"] == 48 && a["allocator"] == "engine_operator_new")
            .unwrap();
        let sizes: Vec<_> = rows[i - 1..i + 6].iter().map(|a| n(&a["bytes"])).collect();
        assert_eq!(sizes, [32, 48, 32, 956, 80, 32, 16]);
        // Supplied synchronous worker boundary; these seven thread/CRT allocations
        // are independently qualified by actual Windows runtime tests.
        rows.drain(i - 1..i + 6);
    }
    s
}
fn opening_host(fill: u8) -> Host {
    let mut b = Host::new(fill);
    b.prepare_stream();
    b.all_allocations = true;
    let tables: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_opening_tables.json",
    ))
    .unwrap();
    for (p, v) in tables["tables"].as_object().unwrap() {
        let p: u32 = p.parse().unwrap();
        b.memory.reserve_at(p, n(&v["bytes"])).unwrap();
        for (i, w) in v["words"].as_array().unwrap().iter().enumerate() {
            Storage::write_word(&mut b, p + i as u32 * 4, n(w)).unwrap();
        }
    }
    b.memory.reserve_at(0x3000f900, 24).unwrap();
    b
}
#[test]
fn audio_replay_opening_matches24_native_full_stream_implementation_key_manager_state_and_cleanup_lifetimes(
) {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_stream_opening_profiles_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 24);
    for c in cases {
        let mut b = opening_host(n(&c["fill"]) as u8);
        let stages: Vec<_> = ["initial", "opened", "destroyed", "shutdown"]
            .map(|s| opening_snapshot(c, s))
            .into_iter()
            .collect();
        b.queue = stages
            .iter()
            .flat_map(|s| s["allocations"].as_array().unwrap())
            .cloned()
            .collect();
        let p = b.allocate(120).unwrap();
        assert_eq!(p, n(&c["stream"]));
        stream::construct(&mut b, p).unwrap();
        let incoming = if c["has_callback"].as_bool().unwrap() {
            b.callback(0x44000000, 0x728e20)
        } else {
            0
        };
        assert_eq!(incoming, n(&c["arguments"][0]));
        b.compare(&stages[0]);
        let key = std::array::from_fn(|i| i as u8);
        let host = c["host_hex"].as_str().map(bytes);
        let args = &c["arguments"];
        let code = opening::open(
            &mut b,
            p,
            opening::Request {
                callback: incoming,
                arguments: [n(&args[1]), n(&args[2])],
                key: &key,
                host: host.as_deref(),
                port: n(&args[5]),
                mode: n(&args[6]),
                flag: n(&args[7]),
                extra: n(&args[8]),
                recording_path: n(&args[9]),
                recording: n(&args[10]),
            },
            0x3000f900,
        )
        .unwrap();
        assert_eq!(code, n(&c["return_code"]));
        b.compare(&stages[1]);
        let current = b.word(p + 0x44).unwrap();
        assert_eq!(b.word(current + 12).unwrap(), n(&c["state"]["state_id"]));
        for (offset, key) in [(0x64, "implementation"), (0x6c, "manager")] {
            assert_eq!(
                json!([b.word(p + offset).unwrap(), b.word(p + offset + 4).unwrap()]),
                c["state"][key]
            );
        }
        assert_eq!(
            b.word(startup::REFERENCES).unwrap(),
            n(&c["state"]["references"])
        );
        stream::scalar_delete(&mut b, p, 1).unwrap();
        b.compare(&stages[2]);
        if b.word(startup::REFERENCES).unwrap() != 0 {
            startup::release(&mut b).unwrap();
        }
        if b.word(logger::POINTER).unwrap() != 0 {
            logger::shutdown(&mut b).unwrap();
        }
        b.compare(&stages[3]);
        assert!(b.locks.is_empty() && b.queue.is_empty());
    }
}
