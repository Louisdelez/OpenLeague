//! Native2Dtarget viewport effects from988870/9889D0; surface handles remain external.
use crate::grass_screen_matrix;
pub struct State { pub dimensions: [u32;2], pub matrix: [f32;16] }
impl State {
    pub fn apply(&mut self, texture_present: bool, slot: u32, dimensions: [u32;2], api_flag: u32) -> Option<[f32;6]> {
        if !texture_present || slot != 0 { return None; }
        self.dimensions = dimensions;
        grass_screen_matrix::update(&mut self.matrix,dimensions,api_flag);
        Some([0.,0.,dimensions[0] as f32,dimensions[1] as f32,0.,1.])
    }
    /// Original restore obtains backbuffer dimensions, rather than a saved arbitrary target.
    pub fn restore(&mut self, texture_present: bool, saved_slot: u32, backbuffer: [u32;2], api_flag: u32) -> Option<[f32;6]> {
        self.apply(texture_present,saved_slot,backbuffer,api_flag)
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn viewport_state_matches_original_push_and_backbuffer_restore() {
        for (source,restore,count) in [(include_str!("../../../data/4.20/grass_target_viewport_contract.json"),false,180),(include_str!("../../../data/4.20/grass_restore_viewport_contract.json"),true,60)] {
            let p:serde_json::Value=serde_json::from_str(source).unwrap();assert_eq!(p["passed"],true);
            let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),count);
            for c in cases {
                let mut state=State { dimensions:[2000,1000],matrix:std::array::from_fn(|i|f32::from_bits(0x3e800000+i as u32)) };
                let sizes=&c[if restore {"backbuffer_size"} else {"size"}];let size=[sizes[0].as_u64().unwrap() as u32,sizes[1].as_u64().unwrap() as u32];
                let present=c["texture_present"].as_bool().unwrap();let slot=c[if restore {"saved_slot"} else {"slot"}].as_u64().unwrap() as u32;let flag=c["api_flag"].as_u64().unwrap() as u32;
                let viewport=if restore {state.restore(present,slot,size,flag)} else {state.apply(present,slot,size,flag)};
                let expected:[u32;16]=std::array::from_fn(|i|c["matrix_bits"][i].as_u64().unwrap() as u32);assert_eq!(state.matrix.map(f32::to_bits),expected);
                let dimensions:[u32;2]=std::array::from_fn(|i|c["renderer_dimensions"][i].as_u64().unwrap() as u32);assert_eq!(state.dimensions,dimensions);
                let api=c["events"].as_array().unwrap().iter().find_map(|event|event.get("device_viewport_bits"));
                assert_eq!(viewport.is_some(),api.is_some());
                if let (Some(actual),Some(api))=(viewport,api) {assert_eq!(actual,[api[0].as_u64().unwrap() as f32,api[1].as_u64().unwrap() as f32,api[2].as_u64().unwrap() as f32,api[3].as_u64().unwrap() as f32,f32::from_bits(api[4].as_u64().unwrap() as u32),f32::from_bits(api[5].as_u64().unwrap() as u32)]);}
            }
        }
    }
}
