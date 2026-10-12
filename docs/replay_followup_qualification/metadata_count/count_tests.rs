fn count_oracle() -> Value {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_metadata_count_probe.json",
    ))
    .unwrap();
    assert_eq!(proof["passed"], true);
    assert_eq!(
        proof["native_sha256"],
        "402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862"
    );
    assert_eq!(
        proof["source_oracle_sha256"],
        "c261df7c77265c610f85c39546367a89dd2c6d959dafc50dd3f7a0f22c68aa73"
    );
    assert_eq!(proof["cases"].as_array().unwrap().len(), 2);
    proof
}
fn seed_count_words(b: &mut Host, p: u32, counts: &Value) {
    assert_eq!(counts.as_array().unwrap().len(), 4);
    for (index, count) in counts.as_array().unwrap().iter().enumerate() {
        Storage::write_word(b, p + 0x1a0 + 4 * index as u32, n(count)).unwrap();
    }
}
#[test]
fn audio_replay_metadata_set_count_matches72_native_limits_ids_al_and_lock_orders() {
    let proof = count_oracle();
    let mut calls = 0;
    for case in proof["cases"].as_array().unwrap() {
        let p = n(&case["metadata"]);
        let mut b = host(n(&case["fill"]) as u8);
        reserve(&mut b, p, BYTES);
        seed(&mut b, p, &decode(case["initial_metadata_hex"].as_str().unwrap()));
        seed_count_words(&mut b, p, &case["initial_scalar_counts"]);
        assert!(b.locks.insert(p + 0x1c8));
        let mut expected_bytes = read_bytes(&b, p, BYTES);
        for step in case["scalar_steps"].as_array().unwrap() {
            let id = n(&step["selector"]);
            let count = n(&step["value"]);
            assert_eq!(
                u32::from(set_count(&mut b, p, id, count).unwrap()),
                n(&step["returned_low_byte"]),
                "id={id}, count={count}, fill={}", case["fill"]
            );
            assert_eq!(json!(b.events), step["lock_events"]);
            assert!(b.held.is_empty());
            b.events.clear();
            for (index, value) in step["counts"].as_array().unwrap().iter().enumerate() {
                let offset = 0x1a0 + 4 * index;
                expected_bytes[offset..offset + 4].copy_from_slice(&n(value).to_le_bytes());
            }
            assert_eq!(read_bytes(&b, p, BYTES), expected_bytes);
            calls += 1;
        }
        assert!(b.queue.is_empty() && b.allocations.is_empty());
        assert!(b.memory.released_labels.is_empty());
        assert_eq!(b.live.len(), 1);
        // The source rejects these before it even addresses the object lock.
        for absent in [0, u32::MAX] {
            for excessive in [49, u32::MAX] {
                assert_eq!(set_count(&mut b, absent, 100, excessive).unwrap(), 0);
            }
        }
        assert!(b.events.is_empty());
    }
    assert_eq!(calls, 72);
}
#[test]
fn audio_replay_metadata_get_count_matches360_native_low_byte_selectors_without_locking() {
    let proof = count_oracle();
    let mut calls = 0;
    for case in proof["cases"].as_array().unwrap() {
        let p = n(&case["metadata"]);
        let mut b = host(n(&case["fill"]) as u8);
        reserve(&mut b, p, BYTES);
        seed(&mut b, p, &decode(case["initial_metadata_hex"].as_str().unwrap()));
        // Intentionally register no lock: any attempted getter lock is an error.
        for step in case["scalar_steps"].as_array().unwrap() {
            seed_count_words(&mut b, p, &step["counts"]);
            let bytes_before = read_bytes(&b, p, BYTES);
            for (selector, expected) in step["getters"].as_object().unwrap() {
                let selector = selector.parse::<u32>().unwrap();
                assert_eq!(
                    get_count(&mut b, p, n(&step["selector"]), selector).unwrap(),
                    n(expected),
                    "id={}, selector={selector}, fill={}", step["selector"], case["fill"]
                );
                assert!(b.events.is_empty() && b.held.is_empty());
                assert_eq!(read_bytes(&b, p, BYTES), bytes_before);
                calls += 1;
            }
        }
        assert!(b.queue.is_empty() && b.allocations.is_empty());
        assert!(b.memory.released_labels.is_empty());
        assert_eq!(b.live.len(), 1);
        // An unknown ID also avoids any metadata read, independently of selector.
        assert_eq!(get_count(&mut b, u32::MAX, 0, u32::MAX).unwrap(), 0);
    }
    assert_eq!(calls, 360);
}
