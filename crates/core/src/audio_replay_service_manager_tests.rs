use crate::audio_replay_service_manager as service_manager;
fn service_host(c: &Value) -> Host {
    let mut b = parent_host(n(&c["fill"]) as u8);
    let service = n(&c["service"]);
    b.memory.reserve_at(service, 392).unwrap();
    for (i, v) in bytes(c["service_hex"].as_str().unwrap())
        .into_iter()
        .enumerate()
    {
        b.write_byte(service + i as u32, v).unwrap();
    }
    for (p, v) in [
        (0x10afea8, service_manager::INITIALIZE),
        (service_manager::EXTRA, n(&c["extra"])),
    ] {
        b.memory.reserve_at(p, 4).unwrap();
        Storage::write_word(&mut b, p, v).unwrap();
    }
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_callbacks_probe.json",
    ))
    .unwrap();
    for row in proof["vtables"].as_array().unwrap() {
        let p = n(&row[0]);
        for (i, v) in row[1].as_array().unwrap().iter().enumerate() {
            let a = p + i as u32 * 4;
            if b.memory.read_byte(a).is_err() {
                b.memory.reserve_at(a, 4).unwrap();
            }
            Storage::write_word(&mut b, a, n(v)).unwrap();
        }
    }
    Storage::write_word(&mut b, game_manager::POINTER, 0).unwrap();
    b.write_byte(game_manager::REINITIALIZE, 0).unwrap();
    b.write_byte(game_manager::REGISTERED, 0).unwrap();
    b
}
fn compare_service_globals(b: &mut Host, s: &Value) {
    assert_eq!(b.word(game_manager::POINTER).unwrap(), n(&s["pointer"]));
    for (i, v) in s["words"].as_array().unwrap().iter().enumerate() {
        assert_eq!(
            b.word(game_manager::OBJECT + i as u32 * 4).unwrap(),
            n(v),
            "parent word{i}"
        );
    }
    assert_eq!(
        b.memory.read_byte(game_manager::REINITIALIZE).unwrap() as u32,
        n(&s["reinitialize"])
    );
    assert_eq!(
        b.memory.read_byte(game_manager::REGISTERED).unwrap() as u32,
        n(&s["registered"])
    );
}
#[test]
fn audio_replay_service_manager_initialization_matches72_full_native_callback_publication_prefixes()
{
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_service_manager_native_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 72);
    for c in cases {
        let mut b = service_host(c);
        b.queue = c["initialized"]["allocations"]
            .as_array()
            .unwrap()
            .iter()
            .cloned()
            .collect();
        service_manager::initialize(&mut b, n(&c["service"]), 0x3000f900).unwrap();
        b.compare(&c["initialized"]);
        compare_service_globals(&mut b, &c["initialized_globals"]);
        assert_eq!(b.memory.shutdown_callbacks, vec![game_manager::SHUTDOWN]);
        assert_eq!(
            b.raw(n(&c["service"]), 392),
            bytes(c["service_hex"].as_str().unwrap())
        );
        assert!(b.queue.is_empty());
        game_manager::shutdown(&mut b).unwrap();
        assert!(b.locks.is_empty());
    }
}
#[test]
fn audio_replay_service_manager_open_matches72_native_modes_configuration_errors_recording_and_ordered_teardown(
) {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_service_manager_contract.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    assert_eq!(proof["stream_worker_creation_supplied_failure"], true);
    let cases = proof["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 72);
    for c in cases {
        let mut b = service_host(c);
        let mut opened = parent_open_snapshot(c, "opened");
        let allocations: Vec<Value> = c["initialized"]["allocations"]
            .as_array()
            .unwrap()
            .iter()
            .chain(opened["allocations"].as_array().unwrap())
            .cloned()
            .collect();
        let freed: Vec<Value> = c["initialized"]["freed"]
            .as_array()
            .unwrap()
            .iter()
            .chain(opened["freed"].as_array().unwrap())
            .cloned()
            .collect();
        opened["allocations"] = json!(allocations);
        opened["freed"] = json!(freed);
        let stages = [opened, c["destroyed"].clone(), c["shutdown"].clone()];
        b.queue = stages
            .iter()
            .flat_map(|s| s["allocations"].as_array().unwrap().iter().cloned())
            .collect();
        let key = std::array::from_fn(|i| i as u8);
        let code = service_manager::open(
            &mut b,
            n(&c["service"]),
            service_manager::Request {
                arguments: [1, 0],
                key: &key,
                host: if c["host_kind"] == "numeric" {
                    Some(b"127.0.0.1")
                } else {
                    None
                },
                start: [1, 2, 3, 0x11223344, 0x55667788, 0x87654321],
                flag: n(&c["flag"]),
                recording_path: 0,
                recording: n(&c["recording"]),
            },
            0x3000f900,
        )
        .unwrap();
        assert_eq!(
            code,
            n(&c["return_code"]),
            "flags {} {}",
            c["enabled"],
            c["secondary"]
        );
        b.compare(&stages[0]);
        compare_service_globals(&mut b, &c["opened_globals"]);
        assert_eq!(
            b.raw(n(&c["service"]), 392),
            bytes(c["service_hex"].as_str().unwrap())
        );
        game_manager::shutdown(&mut b).unwrap();
        b.compare(&stages[1]);
        compare_service_globals(&mut b, &c["destroyed_globals"]);
        if b.word(logger::POINTER).unwrap() != 0 {
            logger::shutdown(&mut b).unwrap();
        }
        b.compare(&stages[2]);
        assert!(b.queue.is_empty() && b.locks.is_empty());
        assert!(c["retired_reads"].as_array().unwrap().is_empty());
    }
}
