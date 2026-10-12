//! Native94520B..9452F1 integrates container68 rates into container5C values.
/// Ordered1>age selects live slots. Preserve inactive words, including NaN ages.
/// Separate multiplication and addition reproduce the original SSE instructions.
pub fn update(delta:u32,ages:&[u32],rates:&[u32],output:&mut [u32])->Result<(),&'static str> {
    if ages.len()!=rates.len() || ages.len()!=output.len(){return Err("mismatched native scalar integration arrays");}
    let delta=f32::from_bits(delta);let mut next=output.to_vec();
    for i in 0..ages.len() {
        if !(1.>f32::from_bits(ages[i])){continue;}
        let rate=f32::from_bits(rates[i]);let value=f32::from_bits(output[i]);
        if !delta.is_finite() || !rate.is_finite() || !value.is_finite(){return Err("unqualified nonfinite scalar integration input");}
        let scaled=rate*delta;next[i]=(scaled+value).to_bits();
    }
    output.copy_from_slice(&next);Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::Value;
    fn words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()}
    #[test]
    fn integration_matches324_original_cases_including_unrolled_remainders() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_scalar_integration_contract.json")).unwrap();
        let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),324);assert!(p["adapters"].as_array().unwrap().is_empty());
        for (i,r) in rows.iter().enumerate() {
            let ages=words(&r["ages"]);let rates=words(&r["rates"]);let mut output=words(&r["initial"]);
            update(r["delta"].as_u64().unwrap() as u32,&ages,&rates,&mut output).unwrap();
            assert_eq!(output,words(&r["cpu"]["output"]),"output case{i}");assert_eq!(ages,words(&r["cpu"]["ages"]),"ages case{i}");assert_eq!(rates,words(&r["cpu"]["rates"]),"rates case{i}");
        }
        let mut output=[7,8];assert!(update(0,&[0],&[0],&mut output).is_err());assert_eq!(output,[7,8]);
        assert!(update(0,&[0,0],&[0,0x7f800000],&mut output).is_err());assert_eq!(output,[7,8]);
        update(0,&[1f32.to_bits(),0x7fa01234],&[0x7f800000;2],&mut output).unwrap();assert_eq!(output,[7,8]);
    }
}
