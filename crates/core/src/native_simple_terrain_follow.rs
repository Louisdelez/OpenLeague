//! Original9456E0 terrain-height following; virtual58 height source is explicit.
pub fn update(owner_present:bool,enabled:u8,locked:u8,begin:u32,end:u32,ages:&[u32],positions:&mut [[u32;3]],previous_heights:&mut [u32],height:&mut impl FnMut([u32;3])->Result<u32,&'static str>)->Result<(),&'static str> {
    if !owner_present || enabled==0 || locked!=0{return Ok(());}
    if ages.len()!=positions.len() || ages.len()>previous_heights.len(){return Err("mismatched native terrain arrays");}
    let begin=f32::from_bits(begin);let end=f32::from_bits(end);
    if !begin.is_finite() || !end.is_finite(){return Err("unqualified native terrain interval");}
    let difference=end as f64-begin as f64;
    let inverse=if difference.abs()>0.001 {1./difference as f32}else{0.};
    let mut p=positions.to_vec();let mut previous=previous_heights.to_vec();
    for i in 0..ages.len() {
        let age=f32::from_bits(ages[i]);if !(1.>age){continue;}
        if !p[i].iter().chain([&previous[i]]).all(|v|f32::from_bits(*v).is_finite()){return Err("unqualified native terrain position/height");}
        let raw=age*inverse+begin;let blend=if raw>1. {1.}else if 0.>raw {0.}else{raw};
        // Actual virtual58 passes X/Z/Y, returning binary32 through x87.
        let h=height([p[i][0],p[i][2],p[i][1]])?;
        if !f32::from_bits(h).is_finite(){return Err("unqualified native height provider result");}
        let delta=f32::from_bits(h)-f32::from_bits(previous[i]);let correction=delta*(1.-blend);
        p[i][1]=(correction+f32::from_bits(p[i][1])).to_bits();previous[i]=h;
    }
    positions.copy_from_slice(&p);previous_heights.copy_from_slice(&previous);Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::{Value,json};
    fn words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()}
    fn triples(v:&Value)->Vec<[u32;3]>{words(v).chunks_exact(3).map(|v|v.try_into().unwrap()).collect()}
    #[test]
    fn terrain_follow_matches720_original_cpu_cases_and_provider_arguments() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_terrain_follow_contract.json")).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),720);assert_eq!(p["epsilon"].as_f64(),Some(0.001));assert_eq!(p["adapters"].as_array().unwrap().len(),1);
        for (i,r) in rows.iter().enumerate() {
            let mut positions=triples(&r["positions"]);let mut previous=words(&r["previous"]);let heights=words(&r["heights"]);let mut events=vec![];
            update(r["present"].as_bool().unwrap(),r["enabled"].as_u64().unwrap() as u8,r["locked"].as_u64().unwrap() as u8,r["begin"].as_u64().unwrap() as u32,r["last"].as_u64().unwrap() as u32,&words(&r["ages"]),&mut positions,&mut previous,&mut |arguments|{let height=heights[events.len()];events.push(json!({"arguments":arguments,"height":height}));Ok(height)}).unwrap();
            assert_eq!(positions,triples(&r["cpu"]["positions"]),"positions case{i}");assert_eq!(previous,words(&r["cpu"]["previous"]),"previous case{i}");assert_eq!(events,r["cpu"]["events"].as_array().unwrap().clone(),"events case{i}");assert_eq!(words(&r["ages"]),words(&r["cpu"]["ages"]));
        }
        let mut positions=[[0,0,0]];let mut previous=[0];assert!(update(true,1,0,0,1f32.to_bits(),&[0],&mut positions,&mut previous,&mut |_|Err("missing provider")).is_err());assert_eq!(positions,[[0,0,0]]);assert_eq!(previous,[0]);
    }
}
