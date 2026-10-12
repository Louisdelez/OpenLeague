use super::*;

#[test]
fn audio_replay_move_matches576_native_cases_including_self_move_and_callback_mutations() {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_stream_ownership_contract.json",
    ))
    .unwrap();
    let cases = proof["moves"].as_array().unwrap();
    assert_eq!(cases.len(), 576);
    for c in cases {
        let mut b = backend(n(&c["strong"]), n(&c["weak"]), false);
        b.observing_move = Some(n(&c["mutation"]) as u8);
        for w in c["before"].as_array().unwrap() {
            b.write_word(n(&w[0]), n(&w[1])).unwrap();
        }
        assert_eq!(
            move_assign(&mut b, DEST, n(&c["source"])).unwrap(),
            n(&c["result"])
        );
        compare(&mut b, &c["after"]);
        assert_eq!(json!(b.events), c["events"], "{c}");
    }
}

#[test]
fn audio_replay_manager_control_factory_matches104_native_replacements_including_null_allocation() {
    let proof: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_stream_ownership_contract.json",
    ))
    .unwrap();
    let cases = proof["factories"].as_array().unwrap();
    assert_eq!(cases.len(), 104);
    for c in cases {
        let mut b = backend(n(&c["strong"]), n(&c["weak"]), false);
        b.observing_move = Some(0);
        b.fail_allocation = c["fail_allocation"].as_bool().unwrap();
        for w in c["before"].as_array().unwrap() {
            b.write_word(n(&w[0]), n(&w[1])).unwrap();
        }
        crate::audio_replay_manager_control::replace_pair(&mut b, DEST, n(&c["object"])).unwrap();
        compare(&mut b, &c["after"]);
        compare(&mut b, &c["new_words"]);
        assert_eq!(json!(b.events), c["events"]);
        let allocations: Vec<_> = b
            .memory
            .allocations
            .iter()
            .map(|&(bytes, pointer)| json!({"bytes":bytes,"pointer":pointer}))
            .collect();
        assert_eq!(json!(allocations), c["allocations"]);
    }
}

#[test]
fn audio_replay_copy_assignment_matches576_native_publication_reference_and_mutating_disposal_cases(
) {
    let p: Value = serde_json::from_str(&crate::audio_test_fixture(
        "data/4.20/replay_pair_copy_assignment_probe.json",
    ))
    .unwrap();
    assert_eq!(p["passed"], true);
    let cases = p["cases"].as_array().unwrap();
    assert_eq!(cases.len(), 576);
    for c in cases {
        let mut b = backend(n(&c["strong"]), n(&c["weak"]), false);
        b.observing_move = Some(n(&c["mutation"]) as u8);
        for w in c["before"].as_array().unwrap() {
            b.write_word(n(&w[0]), n(&w[1])).unwrap();
        }
        assert_eq!(
            copy_assign(&mut b, DEST, n(&c["source"])).unwrap(),
            n(&c["result"])
        );
        compare(&mut b, &c["after"]);
        assert_eq!(json!(b.events), c["events"]);
    }
}
