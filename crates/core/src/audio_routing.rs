//! Original 4.20 backend listener routing (6ce270 -> 706e60 -> aeb0a0).
//! A routing mask is separate from voice pause, resume or release.
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy)]
pub struct VoiceRoute {
    pub object_id: i32,
    pub actor_id: u32,
}
#[derive(Debug, Clone, Copy, PartialEq, Serialize, Deserialize)]
pub struct ListenerMaskCommand {
    pub object_id: u32,
    pub listener_mask: u32,
}

/// The original callback tests the low input byte. Zero attaches listener 0;
/// any nonzero value detaches it. Actor-bound records use a different path.
pub fn listener_update(route: Option<VoiceRoute>, engine_available: bool, disable_raw: u8)
    -> Option<ListenerMaskCommand> {
    let route = route?;
    if route.actor_id != 0 || route.object_id == -1 || !engine_available { return None; }
    Some(ListenerMaskCommand {
        object_id: route.object_id as u32,
        listener_mask: u32::from(disable_raw == 0),
    })
}

/// Native registered object mask storage at +0xa and dirty bit at +0x60.
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct RegisteredRouting {
    pub listener_mask: u8,
    pub dirty_flags: u32,
}
impl RegisteredRouting {
    pub fn set_listener_mask(&mut self, mask: u8) {
        self.listener_mask = mask;
        self.dirty_flags |= 0x4000_0000;
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_original_routing_and_registered_mask_execution() {
        #[derive(Deserialize)] struct Case { disable_raw:u8,found:bool,actor_id:u32,object_id:i32,engine_available:bool,calls:Vec<ListenerMaskCommand> }
        #[derive(Deserialize)] struct MaskCase { input_mask:u8,prior_dirty:u32,native_mask:u8,native_dirty:u32 }
        #[derive(Deserialize)] struct Contract { cases:Vec<Case>,mask_cases:Vec<MaskCase> }
        let contract:Contract=serde_json::from_str(include_str!("../../../data/4.20/audio_routing_contract.json")).unwrap();
        assert_eq!(contract.cases.len(),64);
        assert_eq!(contract.mask_cases.len(),12);
        for c in contract.cases {
            let actual=listener_update(c.found.then_some(VoiceRoute {object_id:c.object_id,actor_id:c.actor_id}),c.engine_available,c.disable_raw);
            assert_eq!(actual.into_iter().collect::<Vec<_>>(),c.calls);
        }
        for c in contract.mask_cases {
            let mut state=RegisteredRouting {listener_mask:17,dirty_flags:c.prior_dirty};
            state.set_listener_mask(c.input_mask);
            assert_eq!(state.listener_mask,c.native_mask);
            assert_eq!(state.dirty_flags,c.native_dirty);
        }
    }

    #[test]
    fn detaching_listener_does_not_release_or_change_voice_identity() {
        let voice=VoiceRoute {object_id:123,actor_id:0};
        assert_eq!(listener_update(Some(voice),true,1),Some(ListenerMaskCommand {object_id:123,listener_mask:0}));
        assert_eq!(listener_update(Some(voice),true,0),Some(ListenerMaskCommand {object_id:123,listener_mask:1}));
        assert_eq!(voice.object_id,123);
    }

    #[test]
    fn actor_bound_and_invalid_voice_routes_do_not_issue_commands() {
        assert!(listener_update(None,true,0).is_none());
        assert!(listener_update(Some(VoiceRoute {object_id:123,actor_id:9}),true,0).is_none());
        assert!(listener_update(Some(VoiceRoute {object_id:-1,actor_id:0}),true,0).is_none());
        assert!(listener_update(Some(VoiceRoute {object_id:123,actor_id:0}),false,0).is_none());
    }
}
