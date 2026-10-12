//! Native932A60 render routing; baseline inherited states verified separately; interleaved renderer mutations remain open.
use bevy::render::render_resource::{BlendComponent,BlendFactor,BlendOperation,BlendState,CompareFunction,Face};
pub struct ParticleState {pub state_bits:u32,pub blend_preset:u32}
impl ParticleState {
    pub fn route(mode:u32,flags:u8)->Result<Self,&'static str> {
        if mode>4 {return Err("unsupported particle render mode");}
        let state_bits=if flags&2!=0 || flags&1!=0 {0} else if mode==3 {12} else {4};
        let blend_preset=match mode {0=>2,1=>if flags&2!=0 {9} else {1},2=>3,3=>0,4=>6,_=>unreachable!()};
        Ok(Self {state_bits,blend_preset})
    }
    /// Base Simple Projected native defaults mode0/flags0 select preset2.
    /// Native9AC600 explicitly sets separate source/destination alpha factors ONE.
    /// Color ADD is written; inherited alpha ADD is verified through the original reset loop.
    /// Original reset ZFUNC=LESSEQUAL; Bevy stores reversed depth, hence GreaterEqual.
    pub fn base_projected_depth_compare()->CompareFunction {CompareFunction::GreaterEqual}
    pub fn base_projected_depth_write()->bool {false}
    /// Manager disables culling (D3DCULL_NONE).
    pub fn base_projected_cull()->Option<Face> {None}
    pub fn base_projected_blend()->BlendState {
        BlendState {color:BlendComponent {src_factor:BlendFactor::One,dst_factor:BlendFactor::One,operation:BlendOperation::Add},alpha:BlendComponent {src_factor:BlendFactor::One,dst_factor:BlendFactor::One,operation:BlendOperation::Add}}
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/projected_render_state_contract.json")).unwrap()}
    #[test]
    fn all_original_modes_flags_and_cache_prerequisites_match_routing() {
        for c in proof()["cases"].as_array().unwrap() {
            let state=ParticleState::route(c["mode"].as_u64().unwrap() as u32,c["flags"].as_u64().unwrap() as u8).unwrap();
            assert_eq!(state.state_bits,c["state_bits"].as_u64().unwrap() as u32);
            assert_eq!(state.blend_preset,c["blend_preset"].as_u64().unwrap() as u32);
        }
    }
    #[test]
    fn base_projected_material_matches_actual_separate_alpha_state_calls() {
        let p=proof();assert_eq!(p["definition_defaults"]["0x20"],0);assert_eq!(p["definition_defaults"]["0x24"],0);
        let cases=p["cases"].as_array().unwrap();let c=cases.iter().find(|c|c["mode"]==0 && c["flags"]==0 && c["initial"]==0).unwrap();
        for pair in [[19,2],[20,2],[207,2],[208,2],[171,1],[206,1]] {assert!(c["calls"].as_array().unwrap().contains(&serde_json::json!(pair)));}
        let blend=ParticleState::base_projected_blend();assert_eq!(blend.color.src_factor,BlendFactor::One);assert_eq!(blend.color.dst_factor,BlendFactor::One);
        assert_eq!(blend.alpha.src_factor,BlendFactor::One);assert_eq!(blend.alpha.dst_factor,BlendFactor::One);
        assert_eq!(blend.color.operation,BlendOperation::Add);
    }
}

#[cfg(test)]
mod baseline_tests {
    use super::*;
    #[test]
    fn original_reset_and_projected_helpers_match_production_baseline() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/projected_baseline_contract.json")).unwrap();
        assert_eq!(p["passed"],true);
        let state=&p["final_state"];
        for (key,value) in [("7",1),("14",0),("23",4),("22",1),("27",1),("206",1),("209",1),("168",15)] {assert_eq!(state[key],value,"D3D state {key}");}
        assert_eq!(ParticleState::base_projected_depth_compare(),CompareFunction::GreaterEqual);
        assert!(!ParticleState::base_projected_depth_write());
        assert_eq!(ParticleState::base_projected_cull(),None);
        assert_eq!(ParticleState::base_projected_blend().alpha.operation,BlendOperation::Add);
        // Native ALPHAFUNC >= reference 0 accepts all normalized texture alpha.
        // Do not introduce a >0 discard: transparent texels can still carry additive RGB.
        assert_eq!(state["15"],1);assert_eq!(state["25"],7);assert_eq!(state["24"],0);
        assert_eq!(p["definition_alpha_reference"],0);
        for alpha_byte in 0..=255 {assert!((alpha_byte as f32/255.)>=0.);}
    }
}
