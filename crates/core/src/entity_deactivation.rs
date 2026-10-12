//! Original 6C8620 queued deactivation. Registry slots and full IDs are distinct.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Object {
    pub identity: u32,
    pub id: u32,
    pub active_raw: u8,
    pub manager: Option<u32>,
}
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Notification {
    InvalidSentinelDiagnostic,
    ManagerDeactivate { manager: u32, identity: u32 },
    ClearCommands,
}
/// Non-owning: this changes activity and notifies managers; it never disposes objects.
pub fn process(pending: &mut Vec<u32>, registry: &mut [Option<Object>], mut notify: impl FnMut(Notification)) {
    for &id in pending.iter() {
        if id == 0 { continue; }
        if id == u32::MAX { notify(Notification::InvalidSentinelDiagnostic); }
        let Some(Some(object)) = registry.get_mut((id & 0xffff) as usize) else { continue; };
        if object.id != id { continue; }
        object.active_raw = 0;
        if let Some(manager) = object.manager {
            notify(Notification::ManagerDeactivate { manager, identity: object.identity });
        }
    }
    pending.clear();
    notify(Notification::ClearCommands);
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_144_native_deactivation_cases_and_repeated_commands() {
        let proof: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/entity_deactivation_contract.json")).unwrap();
        let cases = proof["cases"].as_array().unwrap();
        assert_eq!(cases.len(), 144);
        for c in cases {
            let id = c["id"].as_u64().unwrap() as u32;
            let mut registry = vec![None; c["registry_length"].as_u64().unwrap() as usize];
            let slot = (id & 0xffff) as usize;
            if c["object_present"].as_bool().unwrap() && slot < registry.len() {
                registry[slot] = Some(Object { identity: 0x30008000, id: c["object_id"].as_u64().unwrap() as u32,
                    active_raw: 255, manager: c["manager_present"].as_bool().unwrap().then_some(0x30001000) });
            }
            let mut pending = vec![id, id];
            let mut queue = crate::audio_inactive_queue::InactiveQueue::default();
            let mut notifications = Vec::new();
            process(&mut pending, &mut registry, |notification| match notification {
                Notification::InvalidSentinelDiagnostic => notifications.push("invalid_sentinel_diagnostic"),
                Notification::ManagerDeactivate { manager, identity } => {
                    assert_eq!(manager, 0x30001000);
                    queue.update(identity, 0);
                    notifications.push("manager_deactivate");
                }
                Notification::ClearCommands => notifications.push("clear_commands"),
            });
            assert!(pending.is_empty());
            let active = registry.get(slot).and_then(|o| o.as_ref()).map_or(255, |o| o.active_raw);
            assert_eq!(active, c["active_raw"].as_u64().unwrap() as u8, "{c}");
            let expected: Vec<u32> = c["manager_queue"].as_array().unwrap().iter().map(|id| id.as_u64().unwrap() as u32).collect();
            assert_eq!(queue.identities(), expected, "{c}");
            let expected: Vec<&str> = c["notifications"].as_array().unwrap().iter().map(|s| s.as_str().unwrap()).collect();
            assert_eq!(notifications, expected, "{c}");
        }
    }
    #[test]
    fn stale_generation_cannot_deactivate_reused_slot() {
        let object = Object { identity: 9, id: 0x20001, active_raw: 1, manager: Some(7) };
        let mut registry = vec![None, Some(object)];
        let mut pending = vec![0x10001, 0, 0x20001];
        let mut seen = Vec::new();
        process(&mut pending, &mut registry, |n| seen.push(n));
        assert_eq!(seen, vec![Notification::ManagerDeactivate {manager: 7, identity: 9}, Notification::ClearCommands]);
        assert_eq!(registry[1].unwrap().active_raw, 0);
        assert_eq!(registry[1].unwrap().id, 0x20001);
    }
}
