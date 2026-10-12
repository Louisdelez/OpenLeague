use super::*;
use crate::audio_replay_windows_application::Application;
use serde_json::Value;
struct Defaults;
impl crate::audio_game_service_lifecycle::Settings for Defaults {
    fn float_bits(&mut self, _: &str, _: &str, v: u32) -> Result<u32, &'static str> {
        Ok(v)
    }
    fn bool_value(&mut self, _: &str, _: &str, v: u8) -> Result<u8, &'static str> {
        Ok(v)
    }
    fn integer(&mut self, _: &str, _: &str, v: u32) -> Result<u32, &'static str> {
        Ok(v)
    }
}
fn decode(s: &str) -> Vec<u8> {
    s.as_bytes()
        .chunks_exact(2)
        .map(|b| u8::from_str_radix(std::str::from_utf8(b).unwrap(), 16).unwrap())
        .collect()
}
fn n(v: &Value) -> u32 {
    v.as_u64().unwrap() as u32
}
fn proof() -> Value {
    let p: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_event_consumers_probe.json",
    ))
    .unwrap();
    assert_eq!(p["passed"], true);
    assert_eq!(
        p["native_sha256"],
        crate::audio_replay_runtime_image::SOURCE_SHA256
    );
    p
}
fn text_rows<N: startup::Network + Send + 'static>(
    b: &mut Backend<N>,
    metadata: u32,
    offset: u32,
) -> Value {
    fn walk<N: startup::Network + Send + 'static>(
        b: &mut Backend<N>,
        node: u32,
        extra: bool,
        rows: &mut Vec<Value>,
    ) {
        if metadata::Boundary::read_byte(b, node + 13).unwrap() != 0 {
            return;
        }
        let left = b.word(node).unwrap();
        walk(b, left, extra, rows);
        let len = b.word(node + 40).unwrap();
        let cap = b.word(node + 44).unwrap();
        let raw = if cap >= 16 {
            b.word(node + 24).unwrap()
        } else {
            node + 24
        };
        let hex: String = (0..len)
            .map(|i| format!("{:02x}", metadata::Boundary::read_byte(b, raw + i).unwrap()))
            .collect();
        let mut row = serde_json::json!({"key":b.word(node+16).unwrap(),"index":b.word(node+20).unwrap(),"hex":hex});
        if extra {
            row["extra"] = serde_json::json!(b.word(node + 48).unwrap());
        }
        rows.push(row);
        let right = b.word(node + 8).unwrap();
        walk(b, right, extra, rows);
    }
    let head = b.word(metadata + offset).unwrap();
    let root = b.word(head + 4).unwrap();
    let mut rows = Vec::new();
    walk(b, root, offset == 8, &mut rows);
    serde_json::json!(rows)
}
#[test]
fn audio_replay_windows_events_service_notification_matches16_native_events_and_releases_temporary_metadata(
) {
    let p = proof();
    for case in p["cases"].as_array().unwrap() {
        let mut app = Application::new().unwrap();
        let r = app.transport().unwrap();
        let service = r.configure_service(Defaults).unwrap();
        r.initialize_game_manager().unwrap();
        let parent = r.game_manager_snapshot().unwrap().unwrap();
        let mut b = Backend::new(r.shared.clone());
        let owner = n(&service.diagnostic().unwrap()["pointer"]);
        for step in case["events"].as_array().unwrap() {
            let result = b
                .event_temporary(8, |b, s| {
                    service_events::notify(b, owner, n(&step["event"]), n(&step["key"]), s)
                        .map_err(|e| b.failure(e, "notification failed"))
                })
                .unwrap();
            assert_eq!(result as u32, n(&step["result"]));
            assert_eq!(b.word(parent.metadata[1] + 4).unwrap(), 1);
        }
        // Exercise the installed16-byte wrapper through the real parent dispatcher.
        for key in [7, 0x80000000, 7] {
            assert_eq!(r.receive_game_event(0, 5, 0, key, &[]).unwrap(), 1);
        }
        let mut found = std::collections::BTreeMap::new();
        let head = b.word(parent.metadata[0] + 24).unwrap();
        fn visit<N: startup::Network + Send + 'static>(
            b: &mut Backend<N>,
            node: u32,
            found: &mut std::collections::BTreeMap<u32, u32>,
        ) {
            if metadata::Boundary::read_byte(b, node + 13).unwrap() != 0 {
                return;
            }
            let left = b.word(node).unwrap();
            visit(b, left, found);
            let key = b.word(node + 16).unwrap();
            let value = b.word(node + 20).unwrap();
            assert!(found.insert(key, value).is_none());
            let right = b.word(node + 8).unwrap();
            visit(b, right, found);
        }
        let root = b.word(head + 4).unwrap();
        visit(&mut b, root, &mut found);
        assert_eq!(
            found,
            [(0, 2), (5, 2), (7, 2), (0x80000000, 2), (u32::MAX, 2)]
                .into_iter()
                .collect()
        );
        r.close_game_manager().unwrap();
        service.close().unwrap();
        assert_eq!(r.snapshot().unwrap().engine_allocations, 0);
        app.close().unwrap();
    }
}
#[test]
fn audio_replay_windows_events_metadata_frames_match10_native_full_arrays_and_counter_snapshots() {
    let p = proof();
    for case in p["cases"].as_array().unwrap() {
        let mut app = Application::new().unwrap();
        let r = app.transport().unwrap();
        let service = r.configure_service(Defaults).unwrap();
        r.initialize_game_manager().unwrap();
        let parent = r.game_manager_snapshot().unwrap().unwrap();
        let mut b = Backend::new(r.shared.clone());
        for step in case["frames"].as_array().unwrap() {
            let packet = decode(step["packet_hex"].as_str().unwrap());
            assert_eq!(
                r.receive_game_event(0, 3, 7, 0, &packet).unwrap() as u32,
                n(&step["result"])
            );
            let block = step["state"]["blocks"]
                .as_array()
                .unwrap()
                .iter()
                .find(|x| x["pointer"] == case["metadata"])
                .unwrap();
            let expected = decode(block["hex"].as_str().unwrap());
            let actual: Vec<u8> = (0x20..0x1b0)
                .map(|o| metadata::Boundary::read_byte(&mut b, parent.metadata[0] + o).unwrap())
                .collect();
            assert_eq!(actual, &expected[0x20..0x1b0]);
            assert_eq!(b.word(parent.metadata[1] + 4).unwrap(), 1);
        }
        for step in case["text_frames"].as_array().unwrap() {
            let packet = decode(step["packet_hex"].as_str().unwrap());
            assert_eq!(r.receive_game_event(0, 3, 7, 0, &packet).unwrap(), 1);
            assert_eq!(text_rows(&mut b, parent.metadata[0], 8), step["map56"]);
            assert_eq!(text_rows(&mut b, parent.metadata[0], 16), step["map48"]);
        }
        assert_eq!(r.receive_game_event(0, 3, 5, 0, &[0; 0x56]).unwrap(), 1); // native six-word false leaf, caller returns1
        r.close_game_manager().unwrap();
        service.close().unwrap();
        assert_eq!(r.snapshot().unwrap().engine_allocations, 0);
        app.close().unwrap();
    }
}
#[test]
fn audio_replay_windows_events_reuses_scratch_for4096_notifications_without_retaining_release_records(
) {
    let mut app = Application::new().unwrap();
    let r = app.transport().unwrap();
    let service = r.configure_service(Defaults).unwrap();
    r.initialize_game_manager().unwrap();
    r.receive_game_event(0, 5, 0, 7, &[]).unwrap();
    let before = {
        let bank = r.shared.bank.lock().unwrap();
        (
            bank.next_scratch,
            bank.memory.released_labels.len(),
            bank.owned.len(),
            bank.event_scratch.clone(),
        )
    };
    for _ in 0..4096 {
        assert_eq!(r.receive_game_event(0, 5, 0, 7, &[]).unwrap(), 1);
    }
    let after = {
        let bank = r.shared.bank.lock().unwrap();
        (
            bank.next_scratch,
            bank.memory.released_labels.len(),
            bank.owned.len(),
            bank.event_scratch.clone(),
        )
    };
    assert_eq!(before, after);
    r.close_game_manager().unwrap();
    service.close().unwrap();
    assert_eq!(r.snapshot().unwrap().engine_allocations, 0);
    app.close().unwrap();
}
#[test]
fn audio_replay_windows_events_failed_temporary_reservation_preserves_fresh_and_pooled_addresses() {
    let mut app = Application::new().unwrap();
    let r = app.transport().unwrap();
    let service = r.configure_service(Defaults).unwrap();
    r.initialize_game_manager().unwrap();
    let mut b = Backend::new(r.shared.clone());
    let next = r.shared.bank.lock().unwrap().next_scratch;
    r.shared
        .bank
        .lock()
        .unwrap()
        .memory
        .reserve_at(next, 1)
        .unwrap();
    assert_eq!(
        b.event_temporary(4, |_, _| Ok(())),
        Err("event scratch reservation failed")
    );
    {
        let mut bank = r.shared.bank.lock().unwrap();
        assert_eq!(bank.next_scratch, next);
        bank.memory.release(next).unwrap();
        assert_eq!(bank.memory.released_labels.pop(), Some(next));
    }
    b.event_temporary(4, |_, _| Ok(())).unwrap();
    let pooled = {
        let mut bank = r.shared.bank.lock().unwrap();
        let p = bank.event_scratch[&4][0];
        bank.memory.reserve_at(p, 1).unwrap();
        p
    };
    assert_eq!(
        b.event_temporary(4, |_, _| Ok(())),
        Err("event scratch reservation failed")
    );
    {
        let mut bank = r.shared.bank.lock().unwrap();
        assert_eq!(bank.event_scratch[&4], vec![pooled]);
        bank.memory.release(pooled).unwrap();
        assert_eq!(bank.memory.released_labels.pop(), Some(pooled));
    }
    assert_eq!(b.event_temporary(4, |_, p| Ok(p)).unwrap(), pooled);
    r.close_game_manager().unwrap();
    service.close().unwrap();
    assert_eq!(r.snapshot().unwrap().engine_allocations, 0);
    app.close().unwrap();
}
#[test]
fn audio_replay_windows_events_twelve_byte_callback_reaches_parent_and_invalid_packets_preserve_metadata(
) {
    let mut app = Application::new().unwrap();
    let r = app.transport().unwrap();
    let service = r.configure_service(Defaults).unwrap();
    r.initialize_game_manager().unwrap();
    let parent = r.game_manager_snapshot().unwrap().unwrap();
    let mut b = Backend::new(r.shared.clone());
    let callback = cb::factory(&mut b, 0x7337c0, parent.pointer).unwrap();
    assert_eq!(
        events::Boundary::virtual_call(
            &mut b,
            callback,
            0x5cceb0,
            8,
            &[
                events::Argument::WordRef(0x12345678),
                events::Argument::Word(5),
                events::Argument::Word(0),
                events::Argument::Word(44),
                events::Argument::Word(0)
            ]
        )
        .unwrap(),
        1
    );
    cb::delete(&mut b, callback).unwrap();
    let before: Vec<u8> = (0..metadata::BYTES)
        .map(|o| metadata::Boundary::read_byte(&mut b, parent.metadata[0] + o).unwrap())
        .collect();
    for count in [25u32, 48, 49, u32::MAX] {
        let mut packet = vec![0; 0x191];
        packet[0] = 103;
        packet[1..5].copy_from_slice(&count.to_le_bytes());
        assert!(r
            .receive_game_event(0, 3, 7, 0, &packet)
            .unwrap_err()
            .contains("qualified24-entry"));
    }
    assert!(r
        .receive_game_event(0, 3, 7, 0, &[103])
        .unwrap_err()
        .contains("truncated"));
    for (subtype, packet) in [
        (5, vec![0; 13]),
        (6, vec![0; 6]),
        (7, vec![]),
        (7, {
            let mut p = vec![0; 18];
            p[0] = 101;
            p[17] = b'A';
            p
        }),
        (7, {
            let mut p = vec![0; 18];
            p[0] = 102;
            p[17] = b'A';
            p
        }),
    ] {
        assert!(r
            .receive_game_event(0, 3, subtype, 0, &packet)
            .unwrap_err()
            .contains("truncated"));
    }
    let after: Vec<u8> = (0..metadata::BYTES)
        .map(|o| metadata::Boundary::read_byte(&mut b, parent.metadata[0] + o).unwrap())
        .collect();
    assert_eq!(before, after);
    assert!(r
        .receive_game_event(0, 2, 0, 0, &[])
        .unwrap_err()
        .contains("delivery failed")); // real event2 consumer remains unavailable
    assert_eq!(b.word(parent.metadata[1] + 4).unwrap(), 1);
    r.close_game_manager().unwrap();
    service.close().unwrap();
    assert_eq!(r.snapshot().unwrap().engine_allocations, 0);
    app.close().unwrap();
}
