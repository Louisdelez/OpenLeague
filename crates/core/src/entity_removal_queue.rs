//! Original7185D0 non-owning removal work queue. Destruction is supplied by its owner.
/// Process each snapshot in order, clearing pending before invoking removal.
/// Newly enqueued objects are processed in the next batch, within this call.
/// The original ignores removal's return value. An endlessly enqueueing callback
/// also prevents the original from terminating; no invented timeout is applied.
pub fn drain(pending: &mut Vec<u32>, mut remove: impl FnMut(u32, &mut Vec<u32>) -> bool) {
    while !pending.is_empty() {
        let batch: Vec<_> = pending.drain(..).collect();
        for identity in batch {
            let _ = remove(identity, pending);
        }
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_64_native_batches_including_new_work_and_ignored_return() {
        let proof: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/entity_removal_queue_contract.json")).unwrap();
        let cases = proof["cases"].as_array().unwrap();
        assert_eq!(cases.len(), 64);
        for c in cases {
            let mut pending: Vec<u32> = c["initial"].as_array().unwrap().iter().map(|id| id.as_u64().unwrap() as u32).collect();
            let mut remaining = c["added"].as_u64().unwrap();
            let mut child = 0x30009000;
            let mut removed = Vec::new();
            drain(&mut pending, |identity, pending| {
                removed.push(identity);
                if remaining != 0 { pending.push(child); child += 4; remaining -= 1; }
                c["remove_return"].as_u64().unwrap() != 0
            });
            assert!(pending.is_empty());
            let expected: Vec<u32> = c["calls"].as_array().unwrap().iter().filter_map(|call| call["remove"].as_u64().map(|id| id as u32)).collect();
            assert_eq!(removed, expected, "{c}");
        }
    }
    #[test]
    fn clears_snapshot_before_callbacks_and_retains_duplicate_commands() {
        let mut pending = vec![7, 7, 9];
        let mut calls = Vec::new();
        drain(&mut pending, |identity, queue| {
            calls.push((identity, queue.clone()));
            if calls.len() == 1 { queue.push(11); }
            false
        });
        assert_eq!(calls, vec![(7, vec![]), (7, vec![11]), (9, vec![11]), (11, vec![])]);
        assert!(pending.is_empty());
    }
}
