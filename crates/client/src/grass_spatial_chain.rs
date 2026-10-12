//! Connected native71A5B0 ->95F060/95F2C0/95F370 finite spatial chain.
use crate::{grass_spatial_dispatch::{IndexedNode,Node},grass_spatial_bounds,grass_spatial_extents};
#[derive(Clone,Copy)] pub enum Event {Bounds,Parent,Extents}
#[derive(Clone,Copy)] pub struct Snapshot {pub center:[f32;3],pub local:[f32;6],pub radius:f32,pub integer_bounds:[i32;4]}
fn snapshot(node:&IndexedNode,radius:f32)->Snapshot {Snapshot{center:node.node.center,local:node.local_bounds,radius,integer_bounds:node.integer_bounds}}
/// Parent callback is an explicit unresolved boundary, not an index implementation.
pub fn propagate(aabb:[f32;6],node:Option<&mut IndexedNode>,radius:&mut f32,mut apply:impl FnMut(Event,Snapshot))->Result<(),&'static str> {
    propagate_try(aabb,node,radius,|event,snapshot|{apply(event,snapshot);Ok(())})
}
/// Fallible observers allow real parent reindexing to stop on unsupported state.
pub fn propagate_try(aabb:[f32;6],node:Option<&mut IndexedNode>,radius:&mut f32,mut apply:impl FnMut(Event,Snapshot)->Result<(),&'static str>)->Result<(),&'static str> {
    let Some(node)=node else{return Ok(());};
    let center=[(aabb[0]+aabb[3])*0.5,(aabb[4]+aabb[1])*0.5,(aabb[5]+aabb[2])*0.5];
    let upper=std::array::from_fn::<_,3,_>(|i|(aabb[i+3]-aabb[i])*0.5);
    let lower=upper.map(|v|f32::from_bits(v.to_bits()^0x80000000));
    let local=[lower[0],lower[1],lower[2],upper[0],upper[1],upper[2]];
    let prepared=if center!=node.node.center {Some(grass_spatial_bounds::recalculate(center,node.local_bounds,node.profile)?)}else{None};
    // Preflight on a copy: unsupported arithmetic must not leave a partly updated node.
    let mut checked=IndexedNode{node:Node{center,parent_present:node.node.parent_present},local_bounds:node.local_bounds,integer_bounds:prepared.unwrap_or(node.integer_bounds),profile:node.profile};
    let mut checked_radius=*radius;grass_spatial_extents::update(&mut checked,&mut checked_radius,local,|_,_,_,_|{})?;
    if let Some(bounds)=prepared {
        node.node.center=center;apply(Event::Bounds,snapshot(node,*radius))?;node.integer_bounds=bounds;
        if node.node.parent_present {apply(Event::Parent,snapshot(node,*radius))?;}
    }
    apply(Event::Extents,snapshot(node,*radius))?;
    let center=node.node.center;
    grass_spatial_extents::update_try(node,radius,local,|event,local,radius,integer_bounds|apply(match event {grass_spatial_extents::Event::Bounds=>Event::Bounds,grass_spatial_extents::Event::Parent=>Event::Parent},Snapshot{center,local,radius,integer_bounds}))
}
pub fn propagate_state(state:&crate::grass_actor_aabb::State,node:Option<&mut IndexedNode>,radius:&mut f32,apply:impl FnMut(Event,Snapshot))->Result<(),&'static str> {propagate(state.aabb,node,radius,apply)}
#[cfg(test)] mod tests {
 use super::*;
 fn serialize(kind:&str,s:Snapshot)->serde_json::Value {serde_json::json!({"kind":kind,"center_bits":s.center.map(f32::to_bits),"local_bits":s.local.map(f32::to_bits),"radius_bits":s.radius.to_bits(),"integer_bounds":s.integer_bounds})}
 #[test] fn connected_spatial_chain_matches_original_first_and_repeated_updates() {
    let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_spatial_chain_contract.json")).unwrap();assert_eq!(p["passed"],true);
    for input in p["rsqrt_estimates"].as_array().unwrap(){let value=f32::from_bits(input["input_bits"].as_u64().unwrap() as u32);let bits=unsafe{std::arch::x86_64::_mm_cvtss_f32(std::arch::x86_64::_mm_rsqrt_ss(std::arch::x86_64::_mm_set_ss(value)))}.to_bits();assert_eq!(bits,input["estimate_bits"].as_u64().unwrap() as u32,"same CPU estimate profile");}
    for (i,c) in p["cases"].as_array().unwrap().iter().enumerate() {
        let decode=|v:&serde_json::Value|f32::from_bits(v.as_u64().unwrap() as u32);
        let aabb=std::array::from_fn(|i|decode(&c["aabb_bits"][i]));
        let mut node=IndexedNode{node:Node{center:std::array::from_fn(|i|decode(&c["initial_center_bits"][i])),parent_present:c["parent_present"].as_bool().unwrap()},local_bounds:std::array::from_fn(|i|c["local_bounds"][i].as_f64().unwrap() as f32),integer_bounds:std::array::from_fn(|i|c["initial_integer_bounds"][i].as_i64().unwrap() as i32),profile:if c["integer_sse"].as_bool().unwrap(){grass_spatial_bounds::IntegerProfile::Sse}else{grass_spatial_bounds::IntegerProfile::LegacyCrt}};
        let mut radius=decode(&c["initial_radius_bits"]);
        for expected in [c,&c["repeat"]] {
            let mut events=Vec::new();propagate(aabb,c["node_present"].as_bool().unwrap().then_some(&mut node),&mut radius,|event,s|events.push(serialize(match event {Event::Bounds=>"bounds",Event::Parent=>"parent",Event::Extents=>"extents"},s))).unwrap();
            assert_eq!(serde_json::json!(events),expected["events"],"native event order case {i}");assert_eq!(serialize("final",snapshot(&node,radius)),expected["final"],"native final state case {i}");
        }
    }
 }
}
