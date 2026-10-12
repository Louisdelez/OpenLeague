//! Native93F45B..93F5C0 frame stepping; engine rate/status producers separate.
#[derive(Debug,Copy,Clone)]
pub struct Input {pub time:u32,pub last:u32,pub offset:u32,pub cap:u32,pub rate:u32,pub flags:u32,pub source_flags:u32}
#[derive(Debug,Copy,Clone,PartialEq,Eq)]
pub struct Output {pub effective_time:u32,pub offset:u32,pub iterations:i32,pub step:u32}
fn arithmetic(a:u32,b:u32,op:u8)->u32 {
    let x=f32::from_bits(a);let y=f32::from_bits(b);if x.is_nan(){return a|0x00400000;}if y.is_nan(){return b|0x00400000;}
    let v=match op {0=>x+y,1=>x-y,2=>x*y,_=>x/y};if v.is_nan(){0xffc00000}else{v.to_bits()}
}
fn truncate(v:u32)->i32 {
    let x=f32::from_bits(v);if !x.is_finite() || x>=2147483648.0 || x< -2147483648.0 {i32::MIN}else{x.trunc() as i32}
}
pub fn calculate(input:Input,mut engine_status:impl FnMut()->u8)->Output {
    let mut effective=arithmetic(input.offset,input.time,0);let mut offset=input.offset;
    let cap=if f32::from_bits(input.cap)>0.5 {input.cap}else{0x3f000000};
    if f32::from_bits(arithmetic(effective,input.last,1))>f32::from_bits(cap) {
        effective=arithmetic(input.last,cap,0);offset=arithmetic(effective,input.time,1);
    }
    let mut iterations=truncate(arithmetic(arithmetic(effective,input.last,1),input.rate,2));let mut step=arithmetic(0x3f800000,input.rate,3);
    if input.flags&8!=0 || engine_status()&1!=0 || input.source_flags&4!=0 {
        iterations=1;step=arithmetic(effective,input.last,1);
    } else if iterations==0 {
        if input.flags&0x40!=0 {iterations=1;step=arithmetic(effective,input.last,1);}
    } else if iterations>20 {
        let mut count=(iterations as f32).to_bits();
        while f32::from_bits(count)>20.0 {count=arithmetic(count,0x3f000000,2);step=arithmetic(step,0x40000000,2);}
        iterations=truncate(count);
    }
    Output {effective_time:effective,offset,iterations,step}
}
#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::Value;
    fn bits(v:&Value)->u32{u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    #[test]
    fn frame_timing_matches1040_native_cpu_cases_and_status_calls() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_frame_timing_contract.json")).unwrap();assert_eq!(proof["cases"].as_array().unwrap().len(),1040);assert_eq!(proof["actual_cpu_sse_operations"],7183);assert_eq!(proof["actual_cpu_conversions"],1100);
        for (i,row) in proof["cases"].as_array().unwrap().iter().enumerate() {
            let input=Input {time:bits(&row["time"]),last:bits(&row["last"]),offset:bits(&row["offset"]),cap:bits(&row["cap"]),rate:bits(&row["rate"]),flags:row["flags"].as_u64().unwrap() as u32,source_flags:row["source_flags"].as_u64().unwrap() as u32};let mut calls=0;
            let actual=calculate(input,||{calls+=1;row["status"].as_u64().unwrap() as u8});let e=&row["cpu"];
            assert_eq!(actual,Output {effective_time:bits(&e["effective_time"]),offset:bits(&e["offset"]),iterations:bits(&e["iterations"]) as i32,step:bits(&e["step"])},"case{i}");assert_eq!(calls,e["events"].as_array().unwrap().len(),"case{i}");
        }
    }
}
