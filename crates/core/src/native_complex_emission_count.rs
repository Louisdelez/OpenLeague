//! Original934763..93485D: count after the effective emission rate is sampled.
use crate::native_complex_age::sse_result;
#[derive(Debug,Copy,Clone)]
pub struct Inputs {
    pub time:f32,pub elapsed:f32,pub period:f32,pub owner_start:f32,
    pub last_emission:f32,pub rate:f32,pub owner_scale:f32,
    pub limit:i32,pub emitted:i32,pub flag74:u8,pub flag334:u32,
}
fn cvtt(value:f32)->i32 {
    if !value.is_finite() || !(-2147483648.0..2147483648.0).contains(&value) {i32::MIN} else {value.trunc() as i32}
}
/// Caller supplies the sampled rate and owner multiplier. This does not produce
/// the rate or mutate live particle counters; negative native results are retained.
pub fn evaluate(i:Inputs)->i32 {
    let cycle=cvtt(sse_result(i.elapsed,i.period,|a,b|a/b));
    let cycle_start=sse_result(sse_result(cycle as f32,i.period,|a,b|a*b),i.owner_start,|a,b|a+b);
    let anchor=if cycle_start>i.last_emission {cycle_start} else {i.last_emission};
    let scaled=sse_result(i.owner_scale,i.rate,|a,b|a*b);
    let mut count=cvtt(sse_result(sse_result(i.time,anchor,|a,b|a-b),scaled,|a,b|a*b));
    let cap=1i32.wrapping_sub(cvtt(sse_result(scaled,f32::from_bits(0xbea8f5c3),|a,b|a*b)));
    count=count.min(cap);
    if i.flag74==0 {
        if count==0 {count=1;}
        if i.flag334!=0 {count=cvtt(scaled).max(1);}
    }
    let limit=cvtt(sse_result(i.limit as f32,i.owner_scale,|a,b|a*b));
    if limit>0 {
        let remaining=limit.wrapping_sub(i.emitted);
        if count>remaining || i.rate<0. {return remaining.max(0);}
    }
    count
}
#[derive(Debug,Copy,Clone)]
pub struct RateTiming {pub active:f32,pub offset:f32,pub duration:f32}
#[derive(Debug,Copy,Clone)]
pub struct SampledCount {pub normalized_age:f32,pub effective_rate:f32,pub count:i32}
#[derive(Debug,PartialEq,Eq)]
pub enum SampleError {UnsupportedTiming,Parameter(crate::native_scalar_parameter::Error)}
/// Complete captured9345F0 path with zero ratebyvel and no attribute-rate source.
/// Its age producer subtracts/divides on x87 after the elapsed SSE store. Birth
/// age uses separate SSE operations and must not be substituted here.
pub fn evaluate_stationary(
    mut input:Inputs,timing:RateTiming,
    parameter:&crate::native_scalar_parameter::ScalarParameter,
    rng:&mut crate::native_random::Rng55,
)->Result<SampledCount,SampleError> {
    if [input.time,input.owner_start,input.period,timing.active,timing.offset,timing.duration].iter().any(|v|!v.is_finite()) || input.period<=0. || timing.active<=0. || timing.duration<=0. {return Err(SampleError::UnsupportedTiming);}
    let duration=input.period.min(timing.active).min(timing.duration);
    input.elapsed=sse_result(input.time,input.owner_start,|a,b|a-b);
    let normalized_age=((f64::from(input.elapsed)-f64::from(timing.offset))/f64::from(duration)) as f32;
    let effective_rate=parameter.sample_age(normalized_age,rng).map_err(SampleError::Parameter)?;
    input.rate=effective_rate;
    Ok(SampledCount {normalized_age,effective_rate,count:evaluate(input)})
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn native_timing_caps_flags_and_limits_match_original() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/complex_emission_count_contract.json")).unwrap();
        for row in proof["cases"].as_array().unwrap() {
            let values=&row["inputs"];
            let f=|key:&str|f32::from_bits(u32::from_str_radix(values[key].as_str().unwrap().trim_start_matches("0x"),16).unwrap());
            let n=|key:&str|values[key].as_i64().unwrap() as i32;
            let i=Inputs {time:f("time"),elapsed:f("elapsed"),period:f("period"),owner_start:f("owner_start"),last_emission:f("last_emission"),rate:f("rate"),owner_scale:f("owner_scale"),limit:n("limit"),emitted:n("emitted"),flag74:n("flag74") as u8,flag334:n("flag334") as u32};
            assert_eq!(evaluate(i),row["count"].as_i64().unwrap() as i32,"{row}");
        }
        assert_eq!(proof["cases"].as_array().unwrap().len(),2142);
    }
    #[test]
    fn full_stationary_map_count_matches_age_rate_and_entire_native_rng() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/complex_full_count_contract.json")).unwrap();
        assert_eq!(proof["profiles"],27);
        assert_eq!(proof["cases"].as_array().unwrap().len(),648);
        let from_bits=|v:&serde_json::Value|f32::from_bits(u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap());
        for row in proof["cases"].as_array().unwrap() {
            let parameter=crate::native_scalar_parameter::ScalarParameter::read_numeric("e-rate",0.,|key|row["fields"][key].as_array().map(|v|v.iter().map(|n|n.as_f64().unwrap() as f32).collect())).unwrap().unwrap();
            let t=&row["timing"];
            let input=Inputs {time:from_bits(&row["time_bits"]),elapsed:0.,period:from_bits(&t["period_bits"]),owner_start:0.,last_emission:0.,rate:0.,owner_scale:1.,limit:10,emitted:3,flag74:1,flag334:0};
            let mut rng=crate::native_random::Rng55::seeded(row["seed"].as_u64().unwrap() as u32);
            let result=evaluate_stationary(input,RateTiming {active:from_bits(&t["active_bits"]),offset:from_bits(&t["time_offset_bits"]),duration:from_bits(&t["life_bits"])},&parameter,&mut rng).unwrap();
            assert_eq!(result.normalized_age.to_bits(),from_bits(&row["age_bits"]).to_bits(),"{}",row["name"]);
            assert_eq!(result.effective_rate.to_bits(),from_bits(&row["rate_bits"]).to_bits(),"{}",row["name"]);
            assert_eq!(result.count,row["count"].as_i64().unwrap() as i32,"{row}");
            assert_eq!(rng.first,row["rng"]["first"].as_u64().unwrap() as u32);
            assert_eq!(rng.second,row["rng"]["second"].as_u64().unwrap() as u32);
            for j in 0..55 {assert_eq!(rng.words[j],row["rng"]["words"][j].as_u64().unwrap() as u32,"{}",row["name"]);}
        }
    }
}
