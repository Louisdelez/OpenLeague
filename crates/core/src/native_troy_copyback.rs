//! Final940D19..940E83 state copyback and request reset.
use crate::native_troy_properties::{Emitter,Source};
#[derive(Debug,Copy,Clone,PartialEq,Eq)]
pub struct Output {
    pub config_flags:u32,pub flag_bytes:[u8;3],pub minimum:[u32;3],pub maximum:[u32;3],
}
fn x87_copy(value:u32)->u32 {
    if value&0x7f800000==0x7f800000 && value&0x007fffff!=0 {value|0x00400000} else {value}
}
fn product(left:u32,right:u32)->u32 {
    let a=f32::from_bits(left);let b=f32::from_bits(right);
    if a.is_nan() {return left|0x00400000;}
    if b.is_nan() {return right|0x00400000;}
    let v=a*b;if v.is_nan() {0xffc00000} else {v.to_bits()}
}
/// Invoke only after preceding frame phases; it clears every request bit.
pub fn refresh(source:&mut Source,emitter:&Emitter,config_flags:u32)->Output {
    source.flags=emitter.source_flags;
    source.channels=emitter.channels.map(x87_copy);
    source.field_80=x87_copy(emitter.field_80);
    source.position=emitter.bounds.position.map(x87_copy);
    source.params=[product(emitter.params[1],emitter.params[0]),x87_copy(emitter.params[1]),x87_copy(emitter.params[2])];
    source.color=emitter.color.map(x87_copy);
    source.visibility=(emitter.flags>>3)&1;
    let output=Output {config_flags,flag_bytes:[(emitter.flags>>1)&1,(emitter.flags>>4)&1,(emitter.flags>>2)&1],minimum:emitter.bounds.minimum.map(x87_copy),maximum:emitter.bounds.maximum.map(x87_copy)};
    source.requests=0;
    output
}
#[cfg(test)]
mod tests {
    use super::*;
    use crate::native_troy_position_bounds::Bounds;
    use serde_json::Value;
    fn bits(v:&Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn words<const N:usize>(v:&Value)->[u32;N] {std::array::from_fn(|i|bits(&v[i]))}
    #[test]
    fn copyback_and_request_reset_match512_native_cpu_cases() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_copyback_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),512);assert_eq!(proof["actual_cpu_sse_operations"],512);assert_eq!(proof["actual_cpu_x87_copies"],11776);assert_eq!(proof["emulator_cpu_case_disagreements"],480);
        for (index,row) in proof["cases"].as_array().unwrap().iter().enumerate() {
            let before=&row["before"];let expected=&row["cpu"];
            let mut source=Source {requests:row["requests"].as_u64().unwrap() as u32,flags:before["flags"].as_u64().unwrap() as u32,visibility:before["visibility"].as_u64().unwrap() as u8,params:words(&before["params"]),color:words(&before["color"]),matrix:[0;16],channels:words(&before["channels"]),field_80:bits(&before["field_80"]),position:words(&before["position"]),direction:[0;3]};
            let emitter=Emitter {flags:row["flags"].as_u64().unwrap() as u8,source_flags:row["source_flags"].as_u64().unwrap() as u32,channels:words(&row["channels"]),field_80:bits(&row["field_80"]),params:words(&row["params"]),color:words(&row["color"]),matrix:[0;16],bounds:Bounds {position:words(&row["position"]),minimum:words(&row["minimum"]),maximum:words(&row["maximum"])},direction:[0;3]};
            let out=refresh(&mut source,&emitter,row["config_flags"].as_u64().unwrap() as u32);
            assert_eq!(source.requests,expected["requests"].as_u64().unwrap() as u32,"case {index}");assert_eq!(source.flags,expected["flags"].as_u64().unwrap() as u32,"case {index}");
            assert_eq!(source.visibility,expected["visibility"].as_u64().unwrap() as u8,"case {index}");
            assert_eq!(source.channels,words::<3>(&expected["channels"]),"case {index}");assert_eq!(source.field_80,bits(&expected["field_80"]),"case {index}");
            assert_eq!(source.position,words::<3>(&expected["position"]),"case {index}");assert_eq!(source.params,words::<3>(&expected["params"]),"case {index}");assert_eq!(source.color,words::<8>(&expected["color"]),"case {index}");
            assert_eq!(out,Output {config_flags:expected["config_flags"].as_u64().unwrap() as u32,flag_bytes:std::array::from_fn(|i|expected["flag_bytes"][i].as_u64().unwrap() as u8),minimum:words(&expected["minimum"]),maximum:words(&expected["maximum"])},"case {index}");
        }
    }
}
