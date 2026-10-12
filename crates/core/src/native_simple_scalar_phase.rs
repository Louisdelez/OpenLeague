//! Original945120..94520B scalar phase with real baked lookup and probability RNG.
use crate::{native_probability_curve::{ProbabilityCurve,apply_probability},native_random::Rng55,native_scalar_parameter::baked_scalar_index};
/// Definition1C8 enables writes to container5C; ages are container20. Disabled
/// and unordered/expired ages preserve output and consume no random draws.
pub fn update(enabled:u8,table:&[f32],probability:Option<&ProbabilityCurve>,ages:&[u32],output:&mut [u32],rng:&mut Rng55)->Result<(),&'static str> {
    if enabled==0{return Ok(());}
    if ages.len()!=output.len(){return Err("mismatched native scalar arrays");}
    if !ages.iter().any(|age|1.>f32::from_bits(*age)){return Ok(());}
    if table.is_empty() || table.len()>i32::MAX as usize{return Err("invalid native scalar table length");}
    if !table.iter().all(|v|v.is_finite()){return Err("unqualified nonfinite scalar table");}
    if let Some(p)=probability {
        let valid=if p.constant {p.constant_value.is_finite()} else if p.fast {p.begin.is_finite() && p.difference.is_finite()} else {!p.times.is_empty() && p.times.len()==p.values.len() && p.times.iter().chain(&p.values).all(|v|v.is_finite())};
        if !valid{return Err("invalid or unqualified native probability curve");}
    }
    for (age,out) in ages.iter().zip(output) {
        let age=f32::from_bits(*age);
        if !(1.>age){continue;}
        let index=baked_scalar_index(table.len(),age).map_err(|_|"invalid native scalar lookup")?;
        *out=apply_probability(probability,table[index],rng).to_bits();
    }
    Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::Value;
    fn words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()}
    #[test]
    fn scalar_phase_matches648_original_cpu_cases_and_random_state() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_scalar_phase_contract.json")).unwrap();
        let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),648);assert!(p["adapters"].as_array().unwrap().is_empty());
        for (i,r) in rows.iter().enumerate() {
            let mode=r["mode"].as_u64().unwrap();
            let curve=ProbabilityCurve {present:true,constant:mode==1,constant_value:0.5,fast:mode==2,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
            let table=words(&r["table"]).into_iter().map(f32::from_bits).collect::<Vec<_>>();
            let mut rng=Rng55 {words:words(&r["rng"]).try_into().unwrap(),first:0,second:0};let mut output=words(&r["initial"]);
            update(u8::from(r["active"].as_bool().unwrap()),&table,if mode==0 {None}else{Some(&curve)},&words(&r["ages"]),&mut output,&mut rng).unwrap();
            assert_eq!(output,words(&r["cpu"]["output"]),"output case{i}");assert_eq!(rng.words.as_slice(),words(&r["cpu"]["rng"]),"rng case{i}");
            assert_eq!(rng.first as u64,r["cpu"]["first"].as_u64().unwrap(),"first case{i}");assert_eq!(rng.second as u64,r["cpu"]["second"].as_u64().unwrap(),"second case{i}");
        }
        let mut rng=Rng55::seeded(17);let before=rng.words;let mut output=[123];
        assert!(update(1,&[],None,&[0],&mut output,&mut rng).is_err());assert_eq!(output,[123]);assert_eq!(rng.words,before);
        update(1,&[],None,&[1f32.to_bits()],&mut output,&mut rng).unwrap();assert_eq!(output,[123]);
    }
}
