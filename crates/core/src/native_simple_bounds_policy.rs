//! Original9454BF..9455EF: refresh particle bounds or translate owner movement.
use crate::native_simple_particle_bounds::{self,Bounds};
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct State {pub bounds:Bounds,pub center:[u32;3],pub last:u32}
pub fn update(flag:u8,time:u32,owner_center:[u32;3],factor:u32,ages:&[u32],positions:&[[u32;3]],scales:&[u32],state:&mut State,observe:&mut impl FnMut(u32))->Result<(),&'static str> {
    let mut next=*state;
    if flag!=0 && f32::from_bits(time)-f32::from_bits(state.last)>f32::from_bits(1036831949) {
        next.last=time;observe(time);next.bounds=native_simple_particle_bounds::calculate(factor,ages,positions,scales)?;
    }else{
        if !state.center.iter().chain(&owner_center).chain(&state.bounds.minimum).chain(&state.bounds.maximum).all(|v|f32::from_bits(*v).is_finite()){return Err("unqualified nonfinite bounds translation fields");}
        for j in 0..3 {
            let delta=f32::from_bits(owner_center[j])-f32::from_bits(state.center[j]);
            next.bounds.maximum[j]=(f32::from_bits(state.bounds.maximum[j])+delta).to_bits();
            next.bounds.minimum[j]=(f32::from_bits(state.bounds.minimum[j])+delta).to_bits();
        }
    }
    next.center=owner_center;*state=next;Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::{Value,json};
    fn words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()}
    #[test]
    fn composed_policy_matches864_original_cases_and_actual_bounds_calls() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_bounds_policy_contract.json")).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),864);assert_eq!(p["threshold"].as_u64(),Some(1036831949));assert!(p["adapters"].as_array().unwrap().is_empty());
        for (i,r) in rows.iter().enumerate() {
            let positions=words(&r["positions"]).chunks_exact(3).map(|v|v.try_into().unwrap()).collect::<Vec<_>>();let mut state=State {bounds:Bounds {minimum:words(&r["minimum"]).try_into().unwrap(),maximum:words(&r["maximum"]).try_into().unwrap()},center:words(&r["center"]).try_into().unwrap(),last:r["last"].as_u64().unwrap() as u32};let mut events=vec![];
            update(r["flag"].as_u64().unwrap() as u8,r["time"].as_u64().unwrap() as u32,words(&r["owner_center"]).try_into().unwrap(),r["factor"].as_u64().unwrap() as u32,&words(&r["ages"]),&positions,&words(&r["scales"]),&mut state,&mut |last|events.push(json!({"kind":"bounds","last":last}))).unwrap();
            assert_eq!(state.bounds.minimum.as_slice(),words(&r["cpu"]["minimum"]),"minimum case{i}");assert_eq!(state.bounds.maximum.as_slice(),words(&r["cpu"]["maximum"]),"maximum case{i}");assert_eq!(state.center.as_slice(),words(&r["cpu"]["center"]),"center case{i}");assert_eq!(state.last as u64,r["cpu"]["last"].as_u64().unwrap(),"last case{i}");assert_eq!(events,r["cpu"]["events"].as_array().unwrap().clone(),"events case{i}");
        }
    }
}
