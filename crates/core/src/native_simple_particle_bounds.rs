//! Whole944C80: active-particle scalar radius bounds.
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct Bounds {pub minimum:[u32;3],pub maximum:[u32;3]}
pub fn calculate(factor:u32,ages:&[u32],positions:&[[u32;3]],scales:&[u32])->Result<Bounds,&'static str> {
    if ages.len()!=positions.len() || ages.len()!=scales.len(){return Err("mismatched native particle bounds arrays");}
    let mut b=Bounds {minimum:[0x7f7fffff;3],maximum:[0xff7fffff;3]};
    for i in 0..ages.len() {
        if !(1.>f32::from_bits(ages[i])){continue;}
        if !positions[i].iter().copied().chain([factor,scales[i]]).all(|v|f32::from_bits(v).is_finite()){return Err("unqualified nonfinite particle bounds fields");}
        let extent=f32::from_bits(scales[i])*f32::from_bits(factor);
        for j in 0..3 {
            let p=f32::from_bits(positions[i][j]);let lower=p-extent;let upper=p+extent;
            if !lower.is_finite() || !upper.is_finite(){return Err("unqualified particle bounds overflow");}
            if f32::from_bits(b.minimum[j])>lower {b.minimum[j]=lower.to_bits();}
            if upper>f32::from_bits(b.maximum[j]) {b.maximum[j]=upper.to_bits();}
        }
    }
    Ok(b)
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::Value;
    fn words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()}
    #[test]
    fn bounds_match324_original_cases_with_negative_extents_and_empty_sets() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_particle_bounds_contract.json")).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),324);assert!(p["adapters"].as_array().unwrap().is_empty());
        for (i,r) in rows.iter().enumerate() {
            let positions=words(&r["positions"]).chunks_exact(3).map(|v|v.try_into().unwrap()).collect::<Vec<_>>();let actual=calculate(r["factor"].as_u64().unwrap() as u32,&words(&r["ages"]),&positions,&words(&r["scales"])).unwrap();
            assert_eq!(actual.minimum.as_slice(),words(&r["cpu"]["minimum"]),"minimum case{i}");assert_eq!(actual.maximum.as_slice(),words(&r["cpu"]["maximum"]),"maximum case{i}");
        }
        assert!(calculate(0,&[0],&[],&[]).is_err());
    }
}
