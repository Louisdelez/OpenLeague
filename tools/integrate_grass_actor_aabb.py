from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_actor_aabb.rs';assert not p.exists()
p.write_text('''//! Native6151A0 AABB calculation prefix; model providers remain explicit.
pub fn calculate(position:[f32;3],model_scales:Option<[f32;2]>,mut bounds:impl FnMut()->[f32;6])->[f32;6] {
    let (width,height,min_y)=if let Some([model_scale,actor_scale])=model_scales {
        let first=bounds();let z_span=first[5]-first[2];
        let second=bounds();let x_span=second[3]-second[0];
        let mean=(x_span+z_span)*0.5;
        let third=bounds();let scale=model_scale*actor_scale;
        let height=(third[4]-third[1])*scale;let width=scale*mean;
        let fourth=bounds();(width,height,fourth[1])
    } else {(25.,85.,0.)};
    let min_x=position[0]-width*0.5;let min_y=position[1]+min_y;let min_z=position[2]-width*0.5;
    [min_x,min_y,min_z,min_x+width,min_y+height,min_z+width]
}
pub fn source(eligibility:crate::grass_sources::Eligibility,position:[f32;3],model_scales:Option<[f32;2]>,bounds:impl FnMut()->[f32;6])->crate::grass_sources::Actor {
    crate::grass_sources::Actor{eligibility,aabb:calculate(position,model_scales,bounds)}
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn calculated_collector_source_matches_original_aabb_writes_and_getter_calls() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_actor_aabb_contract.json")).unwrap();assert_eq!(p["passed"],true);
        for c in p["cases"].as_array().unwrap() {
            let profile=c["profile"].as_u64().unwrap() as usize;let position=std::array::from_fn(|i|c["position"][i].as_f64().unwrap() as f32);
            let scales=(profile!=0).then(||[c["model_scale"].as_f64().unwrap() as f32,c["actor_scale"].as_f64().unwrap() as f32]);
            let mut calls=Vec::new();let actor=source(crate::grass_sources::Eligibility{enabled:1,flags_b0:0,flags_e0:0x40,virtual74:1,virtual1e0:true,virtual90:true},position,scales,||{let samples=p["profiles"][profile].as_array().expect("native model present");let value=std::array::from_fn(|i|samples[calls.len().min(samples.len()-1)][i].as_f64().unwrap() as f32);calls.push(value);value});
            assert_eq!(actor.aabb.map(f32::to_bits),std::array::from_fn(|i|c["aabb_bits"][i].as_u64().unwrap() as u32),"native AABB {c}");
            let expected:Vec<[f32;6]>=c["bounds_calls"].as_array().unwrap().iter().map(|row|std::array::from_fn(|i|row[i].as_f64().unwrap() as f32)).collect();assert_eq!(calls,expected);
        }
    }
}
''',encoding='utf-8')
main=r/'crates/client/src/main.rs';s=main.read_text(encoding='utf-8');assert 'mod grass_actor_aabb;' not in s
main.write_text('#[allow(dead_code)]\nmod grass_actor_aabb;\n'+s,encoding='utf-8')
for name in ['probe_native_grass_actor_aabb.py','integrate_grass_actor_aabb.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Native AABB calculation and explicit collector-source adapter installed.')
