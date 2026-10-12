//! Original6C9360 weak-target removal branch; membership removal is external.
use std::sync::{Arc, Weak};
pub struct TargetLink<T> { association: Option<Weak<T>> }
impl<T> TargetLink<T> {
    pub fn new(target: &Arc<T>) -> Self { Self { association: Some(Arc::downgrade(target)) } }
    pub fn association_retained(&self) -> bool { self.association.is_some() }
    /// A live target is kept alive through its callback and weak detachment.
    /// An expired target keeps the stored weak association for owner destruction.
    pub fn remove(&mut self, mut target_remove: impl FnMut(&T)) {
        if let Some(target) = self.association.as_ref().and_then(Weak::upgrade) {
            target_remove(&target);
            self.association = None;
        }
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_18_native_alive_expired_and_reference_count_cases() {
        let proof: serde_json::Value = serde_json::from_str(include_str!("../../../data/4.20/entity_target_removal_contract.json")).unwrap();
        let cases = proof["cases"].as_array().unwrap(); assert_eq!(cases.len(), 18);
        for c in cases {
            let alive = c["alive"].as_bool().unwrap();
            let target = Arc::new(42);
            let mut link = TargetLink::new(&target);
            let extra: Vec<_> = (0..c["extra_weak"].as_u64().unwrap()).map(|_| Arc::downgrade(&target)).collect();
            let count = c["strong_owners"].as_u64().unwrap() as usize;
            let owners: Vec<_> = (1..count).map(|_| target.clone()).collect();
            let target = if alive { Some(target) } else { drop(target); None };
            let mut events = Vec::new();
            link.remove(|value| { assert_eq!(*value, 42); events.push("target_remove"); });
            let expected: Vec<_> = c["events"].as_array().unwrap().iter().map(|v| v.as_str().unwrap()).collect();
            assert_eq!(events, expected);
            assert_eq!(link.association_retained(), c["association_retained"].as_bool().unwrap());
            if let Some(target) = &target {
                assert_eq!(Arc::strong_count(target), c["strong_after"].as_u64().unwrap() as usize);
                // Native weak includes the implicit weak held while strong > 0.
                assert_eq!(Arc::weak_count(target) + 1, c["weak_after"].as_u64().unwrap() as usize);
            }
            drop((owners, extra));
        }
    }
}
