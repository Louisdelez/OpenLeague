use crate::{
    audio_replay_game_manager as game_manager, audio_replay_metadata as game_metadata,
    audio_replay_recording_resource as recording, audio_replay_stream_running as running,
};
impl game_metadata::Boundary for Host {
    fn read_byte(&mut self, p: u32) -> Result<u8, read::Error> {
        manager::Boundary::read_byte(self, p)
    }
    fn initialize_lock(&mut self, p: u32) -> Result<(), &'static str> {
        manager::Boundary::initialize_lock(self, p)
    }
    fn destroy_lock(&mut self, p: u32) -> Result<(), &'static str> {
        manager::Boundary::destroy_lock(self, p)
    }
    fn enter_lock(&mut self, p: u32) -> Result<(), &'static str> {
        manager::Boundary::enter_lock(self, p)
    }
    fn leave_lock(&mut self, p: u32) -> Result<(), &'static str> {
        manager::Boundary::leave_lock(self, p)
    }
}
impl running::Boundary for Host {
    fn launch_stream_worker(
        &mut self,
        l: &crate::audio_replay_transport_thread::Launch,
    ) -> Result<u32, &'static str> {
        assert_eq!(l.callback, running::WORKER);
        Ok(0)
    }
    fn start_implementation(&mut self, _p: u32, f: u32, args: &[u32]) -> Result<u8, &'static str> {
        match (f, args.len()) {
            (0x8f7060, 2) => Ok(0),
            (0x573fb0, 2) | (0x6fa510, 4) => Ok(1),
            _ => Err("unexpected implementation method"),
        }
    }
    fn sleep(&mut self, _: u32) -> Result<(), &'static str> {
        Err("no stream worker scheduled in parent contract")
    }
}
impl recording::Boundary for Host {
    fn lock(&mut self, p: u32, enter: bool) -> Result<(), &'static str> {
        Boundary::mutex(self, p, enter)
    }
    fn file_open(&mut self, _: u32, _: &[u8]) -> Result<u32, &'static str> {
        Err("null filename profiles only")
    }
    fn file_close(&mut self, _: u32) -> Result<i32, &'static str> {
        Err("null filename profiles only")
    }
    fn file_message(&mut self, _: u32, _: u32) -> Result<i32, &'static str> {
        Err("null filename profiles only")
    }
}
impl recording::Preparation for Host {
    fn register_path(&mut self, _: u32) -> Result<(), &'static str> {
        Err("null filename profiles only")
    }
}
impl game_manager::Boundary for Host {}
fn parent_host(fill: u8) -> Host {
    let mut b = opening_host(fill);
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_game_manager_singleton_probe.json",
    ))
    .unwrap();
    for (p, values) in proof["tables"].as_object().unwrap() {
        let p: u32 = p.parse().unwrap();
        for (i, v) in values.as_array().unwrap().iter().enumerate() {
            let a = p + i as u32 * 4;
            if b.memory.read_byte(a).is_err() {
                b.memory.reserve_at(a, 4).unwrap();
            }
            Storage::write_word(&mut b, a, n(v)).unwrap();
        }
    }
    for (p, size) in [
        (game_manager::CURRENT_ID, 4),
        (game_manager::OBJECT, 68),
        (game_manager::POINTER, 4),
        (game_manager::REINITIALIZE, 1),
        (game_manager::REGISTERED, 1),
        (0x3000fa00, 16),
        (logger::COMPOSITE_VTABLE, 12),
        (recording::CONTROL_VTABLE, 12),
    ] {
        b.memory.reserve_at(p, size).unwrap();
    }
    for (p, v) in [
        (game_manager::CURRENT_ID, n(&proof["current_id"])),
        (logger::COMPOSITE_VTABLE, logger::COMPOSITE_DELETE),
        (logger::COMPOSITE_VTABLE + 4, logger::COMPOSITE_CLONE),
        (logger::COMPOSITE_VTABLE + 8, logger::COMPOSITE_INVOKE),
        (recording::CONTROL_VTABLE, recording::CONTROL_DISPOSE),
        (recording::CONTROL_VTABLE + 4, control::RELEASE),
        (recording::CONTROL_VTABLE + 8, control::SCALAR_DELETE),
    ] {
        Storage::write_word(&mut b, p, v).unwrap();
    }
    b
}
#[test]
fn audio_replay_game_manager_matches2_native_full_initialization_32_owned_blocks_and_destruction_lifetimes(
) {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_manager_initialization_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 2);
    for c in cases {
        let mut b = parent_host(n(&c["fill"]) as u8);
        b.queue = ["initial", "configured", "destroyed"]
            .iter()
            .flat_map(|s| c[s]["allocations"].as_array().unwrap().iter().cloned())
            .collect();
        let p = b.allocate(68).unwrap();
        assert_eq!(p, n(&c["manager"]));
        game_manager::construct(&mut b, p).unwrap();
        b.compare(&c["initial"]);
        assert!(game_manager::initialize(&mut b, p, 0x3000f900).unwrap());
        b.compare(&c["configured"]);
        game_manager::scalar_delete(&mut b, p, 1).unwrap();
        b.compare(&c["destroyed"]);
        assert!(b.queue.is_empty() && b.locks.is_empty());
    }
}
#[test]
fn audio_replay_game_manager_matches8_native_global_get_repeat_shutdown_reinitialization_flag_lifetimes(
) {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_game_manager_singleton_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 8);
    for c in cases {
        let mut b = parent_host(n(&c["fill"]) as u8);
        Storage::write_word(&mut b, game_manager::POINTER, 0).unwrap();
        b.write_byte(game_manager::REINITIALIZE, n(&c["initial_flags"][0]) as u8)
            .unwrap();
        b.write_byte(game_manager::REGISTERED, n(&c["initial_flags"][1]) as u8)
            .unwrap();
        for s in c["steps"].as_array().unwrap() {
            if s["action"].as_str().unwrap().starts_with("shutdown") {
                game_manager::shutdown(&mut b).unwrap();
            } else {
                assert_eq!(game_manager::get(&mut b).unwrap(), game_manager::OBJECT);
            }
            b.compare(&s["snapshot"]);
            for (i, v) in s["words"].as_array().unwrap().iter().enumerate() {
                assert_eq!(b.word(game_manager::OBJECT + i as u32 * 4).unwrap(), n(v));
            }
            assert_eq!(b.word(game_manager::POINTER).unwrap(), n(&s["pointer"]));
            assert_eq!(
                json!([
                    b.memory.read_byte(game_manager::REINITIALIZE).unwrap(),
                    b.memory.read_byte(game_manager::REGISTERED).unwrap()
                ]),
                s["flags"]
            );
            assert_eq!(json!(b.memory.shutdown_callbacks), s["registrations"]);
        }
    }
}
fn parent_open_snapshot(c: &Value, stage: &str) -> Value {
    let mut s = c[stage].clone();
    if stage == "opened" {
        let rows = s["allocations"].as_array_mut().unwrap();
        if n(&c["mode"]) == 0 {
            let i = rows
                .iter()
                .position(|a| a["bytes"] == 48 && a["allocator"] == "engine_operator_new")
                .unwrap();
            assert_eq!(
                rows[i - 1..i + 6]
                    .iter()
                    .map(|a| n(&a["bytes"]))
                    .collect::<Vec<_>>(),
                [32, 48, 32, 956, 80, 32, 16]
            );
            // Synchronous transport-start boundary; real CRT worker lifetimes are qualified separately.
            rows.drain(i - 1..i + 6);
        }
        if n(&c["state_after_parent_open"]) == 4 {
            // Source8FB580 caller creates a temporary long option-name before the supplied
            // failed8A8B80 boundary. Rust's Launch descriptor borrows these known bytes.
            let i = rows.iter().rposition(|a| a["bytes"] == 32).unwrap();
            rows.remove(i);
        }
    }
    s
}
#[test]
fn audio_replay_game_manager_matches16_native_open_start_errors_recording_state_and_parent_teardown_contracts(
) {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_game_manager_open_contract.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 16);
    for c in cases {
        let mut b = parent_host(n(&c["fill"]) as u8);
        let stages: Vec<_> = ["initial", "opened", "destroyed", "shutdown"]
            .iter()
            .map(|s| parent_open_snapshot(c, s))
            .collect();
        b.queue = stages
            .iter()
            .flat_map(|s| s["allocations"].as_array().unwrap().iter().cloned())
            .collect();
        let p = b.allocate(68).unwrap();
        assert_eq!(p, n(&c["manager"]));
        game_manager::construct(&mut b, p).unwrap();
        game_manager::initialize(&mut b, p, 0x3000f900).unwrap();
        b.compare(&stages[0]);
        let key = std::array::from_fn(|i| i as u8);
        let code = game_manager::open(
            &mut b,
            p,
            game_manager::Request {
                arguments: [1, 0],
                key: &key,
                host: if c["host_kind"] == "numeric" {
                    Some(b"127.0.0.1")
                } else {
                    None
                },
                start: [1, 2, 3, 0x11223344, 0x55667788, 0x87654321],
                mode: n(&c["mode"]),
                flag: 0,
                extra: 0,
                recording_path: 0,
                recording: n(&c["recording"]),
            },
            0x3000f900,
        )
        .unwrap();
        assert_eq!(code, n(&c["return_code"]));
        b.compare(&stages[1]);
        game_manager::scalar_delete(&mut b, p, 1).unwrap();
        b.compare(&stages[2]);
        if b.word(logger::POINTER).unwrap() != 0 {
            logger::shutdown(&mut b).unwrap();
        }
        b.compare(&stages[3]);
        assert!(b.queue.is_empty() && b.locks.is_empty());
    }
}
