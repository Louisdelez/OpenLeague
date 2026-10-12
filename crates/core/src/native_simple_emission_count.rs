//!941F00..9420B9 gate/count after explicit effective rate sampling.
#[derive(Clone,Copy)]
pub struct Input {pub time:f32,pub start:f32,pub previous:f32,pub life:f32,pub delay:f32,pub period:f32,pub window:f32,pub rate:f32,pub single:u32,pub emitted:u8}
fn cvtt(value:f32)->i32 {if !value.is_finite()||!(-2147483648.0..2147483648.0).contains(&value){i32::MIN}else{value.trunc() as i32}}
/// Signed count is preserved, including negative counts and CVTT overflow.
/// Native caller skips the birth loop when count<=0. No artificial rate cap.
///941F00 early gates run before reading rate tables or consuming rate RNG.
pub fn eligible(i:Input)->Result<bool,&'static str> {
    if ![i.time,i.start,i.previous,i.life,i.delay,i.period,i.window].iter().all(|v|v.is_finite())||i.period<=0. {return Err("unqualified native emission timing");}
    let elapsed=i.time-i.start;
    Ok(!(i.single!=0&&i.emitted!=0||elapsed<i.delay||i.life<=elapsed||i.window<=elapsed%i.period))
}
pub fn evaluate(i:Input)->Result<i32,&'static str> {
    if ![i.time,i.start,i.previous,i.life,i.delay,i.period,i.window,i.rate].iter().all(|v|v.is_finite())||i.period<=0. {return Err("unqualified native emission timing");}
    if !eligible(i)?{return Ok(0);}
    let elapsed=i.time-i.start;
    let cycle=cvtt(elapsed/i.period);let cycle_start=i.start+(cycle as f32)*i.period;
    let anchor=if cycle_start>i.previous{cycle_start}else{i.previous};
    let mut count=cvtt((i.time-anchor)*i.rate);
    let cap=1i32.wrapping_sub(cvtt(i.rate*f32::from_bits(0xbea8f5c3)));count=count.min(cap);
    if i.emitted==0 {if count==0{count=1;}if i.single!=0{count=cvtt(i.rate).max(1);}}
    Ok(count)
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn gate_count_matches160_native_cpu_cases_including_negative_counts() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_emission_cpu_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),160);
        for (index,row) in rows.iter().enumerate(){let r=&row["cpu"];let f=|key:&str|r[key].as_f64().unwrap() as f32;
            let result=evaluate(Input {time:10.+f("age"),start:10.,previous:f("previous"),life:f("life"),delay:f("delay"),period:f("period"),window:f("window"),rate:f("rate"),single:r["single"].as_u64().unwrap() as u32,emitted:r["latch"].as_u64().unwrap() as u8}).unwrap();
            assert_eq!(result as u32,r["count"].as_u64().unwrap() as u32,"case{index}");
        }
    }
}
