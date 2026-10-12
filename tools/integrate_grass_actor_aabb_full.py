from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_actor_aabb.rs';s=p.read_text(encoding='utf-8')
marker='#[cfg(test)] mod tests {';assert marker in s
s=s.replace(marker,'''/// Derived fields of complete6151A0; registered spatial propagation is separate.
pub struct State {pub aabb:[f32;6],pub height:f32,pub radius:f32,pub derived:[f32;6],pub sentinel:u32}
pub fn refresh(position:[f32;3],model_scales:Option<[f32;2]>,bounds:impl FnMut()->[f32;6],raw_shape:f32,raw_radius:f32,initial_height:f32,initial_radius:f32)->State {
    let aabb=calculate(position,model_scales,bounds);
    // Original COMISS zero,raw followed by JB skips replacement for positive or unordered.
    let height=if raw_shape>0. || raw_shape.is_nan(){initial_height}else{aabb[4]-aabb[1]};
    let radius=if raw_radius>0. || raw_radius.is_nan(){initial_radius}else{100.};
    let factor=f32::from_bits(0x3f051eb8);let first=radius*factor;let second=first*factor;
    State{aabb,height,radius,derived:[height,height,height,radius,first,second],sentinel:u32::MAX}
}
'''+marker)
s=s.replace('    use super::*;','''    use super::*;
    #[test] fn full_method_metrics_match_original_no_spatial_node_path() {
        let inputs:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_actor_aabb_contract.json")).unwrap();
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_actor_aabb_full_contract.json")).unwrap();assert_eq!(p["passed"],true);
        for c in p["cases"].as_array().unwrap() {
            let input=&inputs["cases"][c["input_index"].as_u64().unwrap() as usize];let profile=input["profile"].as_u64().unwrap() as usize;
            let position=std::array::from_fn(|i|input["position"][i].as_f64().unwrap() as f32);
            let scales=(profile!=0).then(||[input["model_scale"].as_f64().unwrap() as f32,input["actor_scale"].as_f64().unwrap() as f32]);
            let mut calls=0;let state=refresh(position,scales,||{let seq=input["bounds_calls"].as_array().unwrap();let v=std::array::from_fn(|i|seq[calls.min(seq.len()-1)][i].as_f64().unwrap() as f32);calls+=1;v},f32::from_bits(c["raw_shape_bits"].as_u64().unwrap() as u32),f32::from_bits(c["raw_radius_bits"].as_u64().unwrap() as u32),c["initial_height"].as_f64().unwrap() as f32,c["initial_radius"].as_f64().unwrap() as f32);
            assert_eq!(state.aabb.map(f32::to_bits),std::array::from_fn(|i|input["aabb_bits"][i].as_u64().unwrap() as u32));
            let actual=[state.height,state.radius,state.derived[0],state.derived[1],state.derived[2],state.derived[3],state.derived[4],state.derived[5]].map(f32::to_bits);
            assert_eq!(actual,std::array::from_fn(|i|c["state_bits"][i].as_u64().unwrap() as u32));assert_eq!(state.sentinel,c["sentinel"].as_u64().unwrap() as u32);assert_eq!(calls,input["bounds_calls"].as_array().unwrap().len());
        }
    }
''',1)
p.write_text(s,encoding='utf-8')
for name in ['probe_native_grass_actor_aabb_full.py','integrate_grass_actor_aabb_full.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Complete AABB derived-field port installed; registered spatial propagation remains separate.')
