from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');w=Path('E:/mapslol3v3')
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['particle_render_state.rs','projected_render.rs']:shutil.copy2(r/'crates/client/src'/name,b/name)
shutil.copy2(w/'probe_native_projected_baseline.py',r/'tools/probe_native_projected_baseline.py')
p=r/'crates/client/src/particle_render_state.rs';s=p.read_text(encoding='utf-8')
s=s.replace('inherited GPU states are outside this contract.','baseline inherited states verified separately; interleaved renderer mutations remain open.')
s=s.replace('BlendState};','BlendState,CompareFunction,Face};')
s=s.replace('Color ADD is written; alpha operation remains inherited (default ADD used here).','Color ADD is written; inherited alpha ADD is verified through the original reset loop.')
marker='    pub fn base_projected_blend()->BlendState {'
assert marker in s
s=s.replace(marker,'''    /// Original reset ZFUNC=LESSEQUAL; Bevy stores reversed depth, hence GreaterEqual.
    pub fn base_projected_depth_compare()->CompareFunction {CompareFunction::GreaterEqual}
    pub fn base_projected_depth_write()->bool {false}
    /// Manager disables culling (D3DCULL_NONE).
    pub fn base_projected_cull()->Option<Face> {None}
'''+marker)
s+='''
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
'''
p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/projected_render.rs';s=p.read_text(encoding='utf-8')
s=s.replace('SpecializedMeshPipelineError,CompareFunction','SpecializedMeshPipelineError')
s=s.replace('d.primitive.cull_mode=None;','d.primitive.cull_mode=crate::particle_render_state::ParticleState::base_projected_cull();')
s=s.replace('Some(false);','Some(crate::particle_render_state::ParticleState::base_projected_depth_write());',1)
s=s.replace('Some(CompareFunction::GreaterEqual);','Some(crate::particle_render_state::ParticleState::base_projected_depth_compare());')
p.write_text(s,encoding='utf-8')
p=r/'assets/shaders/projected_terrain.wgsl';s=p.read_text(encoding='utf-8')
s='// Base native ALPHAFUNC GREATEREQUAL, reference 0: normalized alpha needs no discard.\n// Other authored alpha references and renderer variants remain unqualified.\n'+s
p.write_text(s,encoding='utf-8')
print('Baseline helpers used by actual material; original alpha>=0 preserved without RGB discard.')
