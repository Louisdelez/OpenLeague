//! Original8E36B0 indexed six-plane test. Camera plane generation is external.
#[derive(Debug,Clone,Copy)]
pub struct Plane {pub coefficients:[f32;4],pub indices:[usize;3]}
/// Keep original scalar f32 operation order. Boundaries and unordered NaN pass.
/// Bounds are the raw six values copied by native93F314, without normalization.
pub fn intersects(planes:&[Plane;6],bounds:&[f32;6])->Result<bool,&'static str> {
    if planes.iter().any(|plane|plane.indices.iter().any(|index|*index>=6)) {return Err("bounds selection index outside six native values");}
    for plane in planes {
        let [x,y,z]=plane.indices;let c=plane.coefficients;
        let a=bounds[x]*c[0];let b=bounds[y]*c[1];let d=bounds[z]*c[2];
        let distance=((a+b)+d)+c[3];
        if 0.>distance {return Ok(false);}
    }
    Ok(true)
}
pub fn finish_gate(planes:&[Plane;6],bounds:&[f32;6],flags:u8,property_flags:u8,source_flags:u8,clock:f32,birth:f32,lifetime:f32)->Result<crate::audio_emitter_finish::Gate,&'static str> {
    let predicate=intersects(planes,bounds)? as u8;
    Ok(crate::audio_emitter_finish::lifetime_gate(flags,predicate,property_flags,source_flags,clock,birth,lifetime))
}
#[cfg(test)]
mod tests {
    use super::*;
    fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/audio_emitter_bounds_contract.json")).unwrap()}
    fn planes(proof:&serde_json::Value)->[Plane;6] {
        proof["planes"].as_array().unwrap().iter().map(|p|Plane {
            coefficients:std::array::from_fn(|i|p["coefficients"][i].as_f64().unwrap() as f32),
            indices:std::array::from_fn(|i|p["indices"][i].as_u64().unwrap() as usize),
        }).collect::<Vec<_>>().try_into().unwrap()
    }
    fn bounds(c:&serde_json::Value)->[f32;6] {std::array::from_fn(|i|f32::from_bits(c["bounds_bits"][i].as_u64().unwrap() as u32))}
    #[test]
    fn matches_399_original_six_plane_cases_with_boundaries_nan_and_infinity() {
        let proof=proof();let planes=planes(&proof);let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),399);
        for c in cases {assert_eq!(intersects(&planes,&bounds(c)).unwrap(),c["intersects_raw"].as_u64().unwrap()!=0,"{c}");}
        let mut invalid=planes;invalid[5].indices[0]=6;assert!(intersects(&invalid,&[0.;6]).is_err());
    }
    #[test]
    fn matches_1596_original_joined_bounds_and_lifetime_gate_cases() {
        let proof=proof();let planes=planes(&proof);let cases=proof["joined_cases"].as_array().unwrap();assert_eq!(cases.len(),1596);
        for c in cases {
            let result=finish_gate(&planes,&bounds(c),c["flags"].as_u64().unwrap() as u8,0,0,2.,0.,1.).unwrap();
            assert_eq!(result.flags,c["gate_flags"].as_u64().unwrap() as u8,"{c}");assert_eq!(result.suppressed,c["suppressed_raw"].as_u64().unwrap()!=0,"{c}");
        }
    }
}
