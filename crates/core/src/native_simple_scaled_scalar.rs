//! Original9452F1..945466: baked probability scalar times container50 into44.
use crate::{native_probability_curve::ProbabilityCurve,native_random::Rng55};
/// Native one-element tables skip the entire phase, preserving outputs and RNG.
/// Other table lengths use ordered age filtering and the original lookup/RNG.
pub fn update(table:&[f32],probability:Option<&ProbabilityCurve>,ages:&[u32],factors:&[u32],output:&mut [u32],rng:&mut Rng55)->Result<(),&'static str> {
    if table.len()==1{return Ok(());}
    if ages.len()!=factors.len() || ages.len()!=output.len(){return Err("mismatched native scaled scalar arrays");}
    for (age,factor) in ages.iter().zip(factors) {
        if 1.>f32::from_bits(*age) && !f32::from_bits(*factor).is_finite(){return Err("unqualified nonfinite native scalar factor");}
    }
    let mut values=output.to_vec();let mut random=rng.clone();
    crate::native_simple_scalar_phase::update(1,table,probability,ages,&mut values,&mut random)?;
    for i in 0..ages.len() {
        if 1.>f32::from_bits(ages[i]){values[i]=(f32::from_bits(values[i])*f32::from_bits(factors[i])).to_bits();}
    }
    output.copy_from_slice(&values);*rng=random;Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::Value;
    fn words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()}
    #[test]
    fn scaled_scalar_matches324_original_outputs_and_complete_rng_state() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_scaled_scalar_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),324);assert!(proof["adapters"].as_array().unwrap().is_empty());
        for (i,r) in rows.iter().enumerate() {
            let mode=r["mode"].as_u64().unwrap();
            let curve=ProbabilityCurve {present:true,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let table=words(&r["table"]).into_iter().map(f32::from_bits).collect::<Vec<_>>();let mut output=words(&r["initial"]);let mut rng=Rng55 {words:words(&r["rng"]).try_into().unwrap(),first:0,second:0};
            update(&table,if mode==0 {None}else{Some(&curve)},&words(&r["ages"]),&words(&r["factors"]),&mut output,&mut rng).unwrap();
            assert_eq!(output,words(&r["cpu"]["output"]),"output case{i}");assert_eq!(rng.words.as_slice(),words(&r["cpu"]["rng"]),"rng case{i}");assert_eq!(rng.first as u64,r["cpu"]["first"].as_u64().unwrap(),"first case{i}");assert_eq!(rng.second as u64,r["cpu"]["second"].as_u64().unwrap(),"second case{i}");
        }
        let mut rng=Rng55::seeded(17);let before=rng.words;let mut output=[123];
        update(&[1.],None,&[0],&[],&mut output,&mut rng).unwrap();assert_eq!(output,[123]);assert_eq!(rng.words,before);
        assert!(update(&[1.,2.],None,&[0],&[0x7f800000],&mut output,&mut rng).is_err());assert_eq!(output,[123]);assert_eq!(rng.words,before);
    }
}
