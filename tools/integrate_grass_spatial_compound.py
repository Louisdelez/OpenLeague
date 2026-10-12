from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/grass_spatial_dispatch.rs';s=p.read_text(encoding='utf-8')
marker='#[cfg(test)] mod tests {';assert marker in s
s=s.replace(marker,'''/// Original dispatcher plus qualified finite center-bound calculation.
pub struct IndexedNode {pub node:Node,pub local_bounds:[f32;6],pub integer_bounds:[i32;4],pub profile:crate::grass_spatial_bounds::IntegerProfile}
pub fn propagate_indexed(aabb:[f32;6],node:Option<&mut IndexedNode>,mut apply:impl FnMut(Event,[i32;4]))->Result<(),&'static str> {
    let Some(node)=node else{return Ok(());};
    let center=[(aabb[0]+aabb[3])*0.5,(aabb[4]+aabb[1])*0.5,(aabb[5]+aabb[2])*0.5];
    let prepared=if center!=node.node.center {Some(crate::grass_spatial_bounds::recalculate(center,node.local_bounds,node.profile)?)}else{None};
    let current=&mut node.integer_bounds;
    propagate(aabb,Some(&mut node.node),|event| {
        apply(event,*current);
        if matches!(event,Event::Recenter(_)) {*current=prepared.expect("qualified recenter bounds");}
    });
    Ok(())
}
pub fn propagate_indexed_state(state:&crate::grass_actor_aabb::State,node:Option<&mut IndexedNode>,apply:impl FnMut(Event,[i32;4]))->Result<(),&'static str> {propagate_indexed(state.aabb,node,apply)}
'''+marker)
s=s.replace(' use super::*;',''' use super::*;
 #[test] fn compound_dispatch_and_real_bound_recalculation_match_original_observer_states() {
    let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_spatial_compound_contract.json")).unwrap();assert_eq!(p["passed"],true);
    for c in p["cases"].as_array().unwrap() {
        let decode=|v:&serde_json::Value|f32::from_bits(v.as_u64().unwrap() as u32);
        let aabb=std::array::from_fn(|i|decode(&c["aabb_bits"][i]));
        let mut node=IndexedNode{node:Node{center:std::array::from_fn(|i|decode(&c["initial_center_bits"][i])),parent_present:c["parent_present"].as_bool().unwrap()},local_bounds:std::array::from_fn(|i|c["local_bounds"][i].as_f64().unwrap() as f32),integer_bounds:std::array::from_fn(|i|c["initial_integer_bounds"][i].as_i64().unwrap() as i32),profile:if c["integer_sse"].as_bool().unwrap(){crate::grass_spatial_bounds::IntegerProfile::Sse}else{crate::grass_spatial_bounds::IntegerProfile::LegacyCrt}};
        let mut events=Vec::new();propagate_indexed(aabb,c["node_present"].as_bool().unwrap().then_some(&mut node),|event,bounds|events.push(match event {
            Event::Recenter(center)=>serde_json::json!({"kind":"center","bits":center.map(f32::to_bits)}),
            Event::ReindexParent=>serde_json::json!({"kind":"parent","integer_bounds":bounds}),
            Event::Extents{lower,upper}=>serde_json::json!({"kind":"extents","lower_bits":lower.map(f32::to_bits),"upper_bits":upper.map(f32::to_bits),"integer_bounds":bounds})
        })).unwrap();
        assert_eq!(serde_json::json!(events),c["events"]);assert_eq!(node.node.center.map(f32::to_bits),std::array::from_fn(|i|c["final_center_bits"][i].as_u64().unwrap() as u32));assert_eq!(node.integer_bounds,std::array::from_fn(|i|c["final_integer_bounds"][i].as_i64().unwrap() as i32));
    }
 }
''',1)
p.write_text(s,encoding='utf-8')
for name in ['probe_native_grass_spatial_compound.py','integrate_grass_spatial_compound.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print('Qualified finite bound recalculation connected to indexed spatial dispatch.')
