//! Native projectile763240/763CF0 -> wrapper124 ->6C9360 -> Troy9289B0.
//! Weak-reference resolution and the registry scheduler remain caller responsibilities.
#[derive(Debug, Clone, Copy)]
pub struct Wrapper { pub ended: u32, pub linked: bool }
impl Wrapper {
    /// The native helper marks its effect only after a successful nonnull weak lock.
    pub fn projectile_end(&mut self, helper_lock_nonnull: bool) {
        if helper_lock_nonnull { self.ended = 1; }
    }
    /// Native6C97B0 prefix; true means continue to the remaining pose update.
    pub fn update_can_continue(self, resource_lock_nonnull: bool, resource_finished: bool) -> bool {
        resource_lock_nonnull && !resource_finished && self.ended == 0
    }
    /// Native6C97B0 acquisition branch: loss marks ended, but this update still succeeds.
    /// No provider is distinct from a provider whose owner weak lock has expired.
    /// The remaining pose/property callbacks and registry scheduling are caller work.
    pub fn update_owner_gate(&mut self, resource_lock_nonnull: bool, resource_finished: bool,
                             provider_present: bool, owner_lock_nonnull: bool) -> bool {
        if !self.update_can_continue(resource_lock_nonnull, resource_finished) { return false; }
        if provider_present && !owner_lock_nonnull { self.ended = 1; }
        true
    }
    /// Native6C9360: request stop and detach only when the resource weak lock succeeds.
    /// A failed lock retains the original link; destruction handles its eventual release.
    pub fn cleanup(&mut self, resource_lock_nonnull: bool, requests: &mut u32) -> bool {
        if self.linked && resource_lock_nonnull {
            *requests |= 0x400;
            self.linked = false;
            true
        } else { false }
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn original_projectile_marker_update_gate_and_repeated_cleanup_match120_profiles() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projectile_stop_dispatch_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),120);
        for c in cases {
            let mut state=Wrapper{ended:c["initial_ended"].as_u64().unwrap() as u32,linked:true};
            let mut requests=c["initial_requests"].as_u64().unwrap() as u32;
            for row in c["stages"].as_array().unwrap().iter().take(2) {
                state.projectile_end(c["helper_state"]=="alive");
                assert_eq!(state.ended,row["ended"].as_u64().unwrap() as u32,"{c}");
                assert_eq!(requests,row["requests"].as_u64().unwrap() as u32);
            }
            assert_eq!(state.update_can_continue(c["troy_state"]=="alive",false),c["update"]["continues"].as_bool().unwrap(),"{c}");
            for row in c["stages"].as_array().unwrap().iter().skip(2) {
                state.cleanup(c["troy_state"]=="alive",&mut requests);
                assert_eq!(state.linked,row["wrapper_link"].as_bool().unwrap(),"{c}");
                assert_eq!(requests,row["requests"].as_u64().unwrap() as u32,"{c}");
            }
        }
    }

    #[test]
    fn owner_acquisition_loss_and_reacquisition_match120_original_frames() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projectile_owner_acquisition_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),40);
        let mut count=0;
        for c in cases {
            let mut state=Wrapper{ended:c["initial_ended"].as_u64().unwrap() as u32,linked:true};
            let mut position=[500f32,600.,700.].map(f32::to_bits);
            for f in c["stages"].as_array().unwrap() {
                let live=c["resource_live"].as_bool().unwrap();
                let provider=c["provider_present"].as_bool().unwrap();
                let owner=f["owner_live"].as_bool().unwrap();
                let result=state.update_owner_gate(live,false,provider,owner);
                assert_eq!(result,f["continues"].as_bool().unwrap(),"{c}");
                assert_eq!(state.ended,f["after"]["ended"].as_u64().unwrap() as u32,"{c}");
                // Position callbacks run only when the initial gate and concrete provider acquire.
                if result && provider && owner {position=std::array::from_fn(|i|(f["owner_position"][i].as_f64().unwrap() as f32).to_bits());}
                let expected:Vec<u32>=f["after"]["wrapper_position"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect();
                assert_eq!(position.to_vec(),expected,"{c}");count+=1;
            }
        }
        assert_eq!(count,120);
    }
}
