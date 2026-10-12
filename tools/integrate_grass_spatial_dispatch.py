from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_spatial_dispatch.rs';assert not p.exists()
p.write_text('''//! Native71A5B0 dispatch; downstream spatial-index algorithms supplied by caller.
pub struct Node {pub center:[f32;3],pub parent_present:bool}
#[derive(Clone,Copy,Debug)]
pub enum Event {Recenter([f32;3]),ReindexParent,Extents{lower:[f32;3],upper:[f32;3]}}
pub fn propagate(aabb:[f32;6],node:Option<&mut Node>,mut apply:impl FnMut(Event)) {
    let Some(node)=node else{return;};
    let center=[(aabb[0]+aabb[3])*0.5,(aabb[4]+aabb[1])*0.5,(aabb[5]+aabb[2])*0.5];
    if center!=node.center {
        node.center=center;apply(Event::Recenter(center));
        if node.parent_present {apply(Event::ReindexParent);}
    }
    let upper=std::array::from_fn(|i|(aabb[i+3]-aabb[i])*0.5);
    let lower=upper.map(|v|f32::from_bits(v.to_bits()^0x80000000));
    apply(Event::Extents{lower,upper});
}
/// Connects the qualified AABB result to optional registered-node dispatch.
pub fn propagate_state(state:&crate::grass_actor_aabb::State,node:Option<&mut Node>,apply:impl FnMut(Event)) {propagate(state.aabb,node,apply);}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn registered_node_dispatch_matches_original_center_writes_and_call_order() {
    let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_spatial_dispatch_contract.json")).unwrap();assert_eq!(p["passed"],true);
    for c in p["cases"].as_array().unwrap() {
        let decode=|v:&serde_json::Value|f32::from_bits(v.as_u64().unwrap() as u32);
        let aabb=std::array::from_fn(|i|decode(&c["aabb_bits"][i]));
        let mut node=Node{center:std::array::from_fn(|i|decode(&c["initial_center_bits"][i])),parent_present:c["parent_present"].as_bool().unwrap()};
        let mut events=Vec::new();propagate(aabb,c["node_present"].as_bool().unwrap().then_some(&mut node),|event|events.push(match event {
            Event::Recenter(center)=>serde_json::json!({"kind":"center","bits":center.map(f32::to_bits)}),
            Event::ReindexParent=>serde_json::json!({"kind":"parent"}),
            Event::Extents{lower,upper}=>serde_json::json!({"kind":"extents","lower_bits":lower.map(f32::to_bits),"upper_bits":upper.map(f32::to_bits)})
        }));
        assert_eq!(serde_json::json!(events),c["events"]);assert_eq!(node.center.map(f32::to_bits),std::array::from_fn(|i|c["final_center_bits"][i].as_u64().unwrap() as u32));
    }
 }
}
''',encoding='utf-8')
main=r/'crates/client/src/main.rs';s=main.read_text(encoding='utf-8');assert 'mod grass_spatial_dispatch;' not in s
main.write_text('#[allow(dead_code)]\nmod grass_spatial_dispatch;\n'+s,encoding='utf-8')
for name in ['probe_native_grass_spatial_dispatch.py','integrate_grass_spatial_dispatch.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Native registered spatial dispatch port installed; downstream index implementations remain explicit.')
