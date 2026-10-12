//! Original92CB07 stopped-emitter retirement. Stop and finished are distinct.
pub trait Backend {
    fn flags(&mut self, identity: u32) -> u8;
    fn cleanup(&mut self, identity: u32);
    fn free(&mut self, identity: u32);
}
/// Only finished bit2 allows disposal. Null and unfinished entries stay queued.
/// Cleanup and free precede removal from pending and all active references.
pub fn drain(pending: &mut Vec<u32>, active: &mut Vec<u32>, backend: &mut impl Backend) -> Result<(), &'static str> {
    if pending.windows(2).any(|w| w[0] > w[1]) || active.windows(2).any(|w| w[0] > w[1]) {
        return Err("unsorted emitter identity registry");
    }
    let mut index = 0;
    while index < pending.len() {
        let identity = pending[index];
        if identity == 0 || backend.flags(identity) & 2 == 0 { index += 1; continue; }
        backend.cleanup(identity);
        backend.free(identity);
        pending.remove(index);
        active.retain(|value| *value != identity);
    }
    Ok(())
}
/// Original93E4C0 cleanup of the two audio handles, independent of stop flags.
pub fn release_handles(handles: &mut [i32; 2], mut release: impl FnMut(i32)) {
    for handle in handles {
        if *handle != -1 { release(*handle); *handle = -1; }
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    use std::collections::BTreeMap;
    struct Probe {objects: BTreeMap<u32,(u8,[i32;2])>, events: Vec<serde_json::Value>}
    impl Backend for Probe {
        fn flags(&mut self, id:u32)->u8 {self.objects[&id].0}
        fn cleanup(&mut self,id:u32) {
            self.events.push(serde_json::json!({"destroy":id}));
            let handles = &mut self.objects.get_mut(&id).unwrap().1;
            let events = &mut self.events;
            release_handles(handles, |h| events.push(serde_json::json!({"release":h,"owner":id})));
        }
        fn free(&mut self,id:u32) {self.events.push(serde_json::json!({"free":id}));self.objects.remove(&id);}
    }
    #[test]
    fn matches_128_native_retirement_cases_and_audio_cleanup_order() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_emitter_drain_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),128);
        let ids=|value:&serde_json::Value|->Vec<u32>{value.as_array().unwrap().iter().map(|id|id.as_u64().unwrap() as u32).collect()};
        for c in cases {
            let mut pending=ids(&c["pending"]);let mut active=ids(&c["active"]);
            let objects=c["objects"].as_array().unwrap().iter().map(|o|(o["identity"].as_u64().unwrap() as u32,(o["flags"].as_u64().unwrap() as u8,[o["handles"][0].as_i64().unwrap() as i32,o["handles"][1].as_i64().unwrap() as i32]))).collect();
            let mut probe=Probe{objects,events:Vec::new()};drain(&mut pending,&mut active,&mut probe).unwrap();
            assert_eq!(pending,ids(&c["pending_after"]));assert_eq!(active,ids(&c["active_after"]));assert_eq!(probe.events,c["notifications"].as_array().unwrap().clone());
        }
    }
    #[test]
    fn repeated_cleanup_releases_valid_zero_handle_only_once() {
        let mut handles=[0,42];let mut released=Vec::new();
        release_handles(&mut handles,|h|released.push(h));release_handles(&mut handles,|h|released.push(h));
        assert_eq!(handles,[-1,-1]);assert_eq!(released,[0,42]);
    }
}
