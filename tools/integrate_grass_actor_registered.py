from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_actor_aabb.rs';s=p.read_text(encoding='utf-8')
marker='    // Original COMISS zero,raw followed by JB skips replacement for positive or unordered.'
assert marker in s and 'pub fn refresh_registered(' not in s
s=s.replace(marker,'''    derive(aabb,raw_shape,raw_radius,initial_height,initial_radius)
}
/// Runs the registered spatial chain before committing native derived actor metrics.
pub fn refresh_registered(position:[f32;3],model_scales:Option<[f32;2]>,bounds:impl FnMut()->[f32;6],raw_shape:f32,raw_radius:f32,initial_height:f32,initial_radius:f32,node:Option<&mut crate::grass_spatial_dispatch::IndexedNode>,spatial_radius:&mut f32,apply:impl FnMut(crate::grass_spatial_chain::Event,crate::grass_spatial_chain::Snapshot))->Result<State,&'static str> {
    let aabb=calculate(position,model_scales,bounds);
    crate::grass_spatial_chain::propagate(aabb,node,spatial_radius,apply)?;
    Ok(derive(aabb,raw_shape,raw_radius,initial_height,initial_radius))
}
fn derive(aabb:[f32;6],raw_shape:f32,raw_radius:f32,initial_height:f32,initial_radius:f32)->State {
'''+marker,1)
test='''
    #[test] fn full_actor_refresh_with_registered_spatial_node_matches_original_method() {
        use crate::{grass_spatial_dispatch::{IndexedNode,Node},grass_spatial_bounds::IntegerProfile,grass_spatial_chain::{Event,Snapshot}};
        let inputs:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_actor_aabb_contract.json")).unwrap();
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_actor_registered_contract.json")).unwrap();assert_eq!(proof["passed"],true);
        let serialize=|kind:&str,s:Snapshot|serde_json::json!({"kind":kind,"center_bits":s.center.map(f32::to_bits),"local_bits":s.local.map(f32::to_bits),"radius_bits":s.radius.to_bits(),"integer_bounds":s.integer_bounds});
        for (index,c) in proof["cases"].as_array().unwrap().iter().enumerate() {
            let input=&inputs["cases"][c["input_index"].as_u64().unwrap() as usize];
            let position=std::array::from_fn(|i|input["position"][i].as_f64().unwrap() as f32);
            let scales=(input["profile"].as_u64().unwrap()!=0).then(||[input["model_scale"].as_f64().unwrap() as f32,input["actor_scale"].as_f64().unwrap() as f32]);
            let mut node=IndexedNode{node:Node{center:[0.;3],parent_present:c["parent_present"].as_bool().unwrap()},local_bounds:std::array::from_fn(|i|c["initial_local"][i].as_f64().unwrap() as f32),integer_bounds:[101,202,303,404],profile:if c["integer_sse"].as_bool().unwrap(){IntegerProfile::Sse}else{IntegerProfile::LegacyCrt}};
            let mut radius=99.;let mut height=71.;let mut actor_radius=19.;
            for expected in [c,&c["repeat"]] {
                let mut calls=Vec::new();let mut events=Vec::new();
                let state=refresh_registered(position,scales,||{let seq=input["bounds_calls"].as_array().unwrap();let value=std::array::from_fn(|i|seq[calls.len().min(seq.len()-1)][i].as_f64().unwrap() as f32);calls.push(value);value},c["raw_shape"].as_f64().unwrap() as f32,c["raw_radius"].as_f64().unwrap() as f32,height,actor_radius,c["node_present"].as_bool().unwrap().then_some(&mut node),&mut radius,|event,s|events.push(serialize(match event{Event::Bounds=>"bounds",Event::Parent=>"parent",Event::Extents=>"extents"},s))).unwrap();
                assert_eq!(serde_json::json!(events),expected["events"],"registered actor event order {index}");
                assert_eq!(serialize("final",Snapshot{center:node.node.center,local:node.local_bounds,radius,integer_bounds:node.integer_bounds}),expected["final"],"registered spatial state {index}");
                let actual=[state.height,state.radius,state.derived[0],state.derived[1],state.derived[2],state.derived[3],state.derived[4],state.derived[5]].map(f32::to_bits);
                assert_eq!(actual,std::array::from_fn(|i|expected["state_bits"][i].as_u64().unwrap() as u32));assert_eq!(state.sentinel,expected["sentinel"].as_u64().unwrap() as u32);
                assert_eq!(state.aabb.map(f32::to_bits),std::array::from_fn(|i|input["aabb_bits"][i].as_u64().unwrap() as u32));assert_eq!(serde_json::json!(calls),expected["bounds_calls"]);
                height=state.height;actor_radius=state.radius;
            }
        }
    }
'''
marker='#[cfg(test)] mod tests {\n    use super::*;';assert marker in s;s=s.replace(marker,marker+test,1);p.write_text(s,encoding='utf-8')
for name in ['probe_native_grass_actor_registered.py','integrate_grass_actor_registered.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Registered actor refresh integrated')
