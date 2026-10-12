//! Native95F060/95F2C0 finite local bounds/radius; parent operation remains explicit.
use crate::{grass_spatial_dispatch::IndexedNode,grass_spatial_bounds};
pub fn approximate_sqrt(value:f32)->Result<f32,&'static str> {
    if !value.is_finite() || value<0. {return Err("unqualified native spatial sqrt input");}
    #[cfg(target_arch="x86_64")]
    {
        let inverse=unsafe{std::arch::x86_64::_mm_cvtss_f32(std::arch::x86_64::_mm_rsqrt_ss(std::arch::x86_64::_mm_set_ss(value)))};
        let first=inverse*value;let second=first*inverse;let correction=3.-second;
        let half=inverse*0.5;let corrected=correction*half;let result=corrected*value;
        Ok(if value==0. {0.}else{result})
    }
    #[cfg(not(target_arch="x86_64"))]
    {Err("native RSQRTSS profile unsupported on this architecture")}
}
#[derive(Clone,Copy)] pub enum Event {Bounds,Parent}
pub fn update(node:&mut IndexedNode,radius:&mut f32,local:[f32;6],mut apply:impl FnMut(Event,[f32;6],f32,[i32;4]))->Result<(),&'static str> {
    update_try(node,radius,local,|event,local,radius,bounds|{apply(event,local,radius,bounds);Ok(())})
}
pub fn update_try(node:&mut IndexedNode,radius:&mut f32,local:[f32;6],mut apply:impl FnMut(Event,[f32;6],f32,[i32;4])->Result<(),&'static str>)->Result<(),&'static str> {
    if local.iter().chain(node.local_bounds.iter()).any(|v|!v.is_finite()) || !radius.is_finite(){return Err("nonfinite native spatial extent state unqualified");}
    let span=std::array::from_fn::<_,3,_>(|i|local[i+3]-local[i]);
    let sum=(span[0]*span[0]+span[1]*span[1])+span[2]*span[2];
    let half_diagonal=(approximate_sqrt(sum)? as f64*0.5) as f32;
    let center=std::array::from_fn::<_,3,_>(|i|(local[i]+local[i+3])*0.5);
    let sum=(center[0]*center[0]+center[1]*center[1])+center[2]*center[2];
    let unrounded=approximate_sqrt(sum)? as f64+half_diagonal as f64;
    let integer_bounds=grass_spatial_bounds::recalculate(node.node.center,local,node.profile)?;
    if node.local_bounds!=local {
        node.local_bounds=local;apply(Event::Bounds,node.local_bounds,*radius,node.integer_bounds)?;
        node.integer_bounds=integer_bounds;
        if node.node.parent_present {apply(Event::Parent,node.local_bounds,*radius,node.integer_bounds)?;}
    }
    // Native x87 compares oldf32 radius with unrounded sum before storing f32.
    if *radius as f64!=unrounded {
        *radius=unrounded as f32;apply(Event::Bounds,node.local_bounds,*radius,node.integer_bounds)?;
        node.integer_bounds=integer_bounds;
        if node.node.parent_present {apply(Event::Parent,node.local_bounds,*radius,node.integer_bounds)?;}
    }
    Ok(())
}
#[cfg(test)] mod tests {
 use super::*;use crate::grass_spatial_dispatch::Node;
 #[test] fn actual_cpu_rsqrt_refinement_and_repeated_extents_match_original_hardware_bridge() {
    let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/grass_spatial_extents_hardware_contract.json")).unwrap();assert_eq!(p["passed"],true);
    for input in p["rsqrt_estimates"].as_array().unwrap(){let value=f32::from_bits(input["input_bits"].as_u64().unwrap() as u32);let bits=unsafe{std::arch::x86_64::_mm_cvtss_f32(std::arch::x86_64::_mm_rsqrt_ss(std::arch::x86_64::_mm_set_ss(value)))}.to_bits();assert_eq!(bits,input["estimate_bits"].as_u64().unwrap() as u32,"sameCPU RSQRTSS profile");}
    for c in p["cases"].as_array().unwrap() {
        let mut node=IndexedNode{node:Node{center:std::array::from_fn(|i|c["center"][i].as_f64().unwrap() as f32),parent_present:c["parent_present"].as_bool().unwrap()},local_bounds:std::array::from_fn(|i|c["initial_local_bounds"][i].as_f64().unwrap() as f32),integer_bounds:[101,202,303,404],profile:if c["integer_sse"].as_bool().unwrap(){grass_spatial_bounds::IntegerProfile::Sse}else{grass_spatial_bounds::IntegerProfile::LegacyCrt}};
        let local=std::array::from_fn(|i|c["local_bounds"][i].as_f64().unwrap() as f32);let mut radius=c["initial_radius"].as_f64().unwrap() as f32;
        for expected in [c,&c["repeat"]] {
            let mut events=Vec::new();update(&mut node,&mut radius,local,|event,local,radius,bounds|events.push(match event {Event::Bounds=>serde_json::json!({"kind":"bounds","local_bits":local.map(f32::to_bits),"radius_bits":radius.to_bits()}),Event::Parent=>serde_json::json!({"kind":"parent","integer_bounds":bounds,"radius_bits":radius.to_bits()})})).unwrap();
            assert_eq!(serde_json::json!(events),expected["events"],"native events {c}");assert_eq!(radius.to_bits(),expected["final_radius_bits"].as_u64().unwrap() as u32);assert_eq!(node.local_bounds.map(f32::to_bits),std::array::from_fn(|i|expected["final_local_bits"][i].as_u64().unwrap() as u32));assert_eq!(node.integer_bounds,std::array::from_fn(|i|expected["final_integer_bounds"][i].as_i64().unwrap() as i32));
        }
    }
 }
}
