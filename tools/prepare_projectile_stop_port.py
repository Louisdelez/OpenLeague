from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
code='''//! Native projectile763240/763CF0 -> wrapper124 ->6C9360 -> Troy9289B0.
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
}
'''
(r/'crates/core/src/native_projectile_stop_dispatch.rs').write_text(code,encoding='utf-8')
p=r/'crates/core/src/lib.rs';s=p.read_text(encoding='utf-8')
if 'pub mod native_projectile_stop_dispatch;' not in s:p.write_text(s+'\npub mod native_projectile_stop_dispatch;\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
