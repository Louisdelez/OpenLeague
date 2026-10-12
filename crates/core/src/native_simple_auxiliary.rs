//! Native943924..9439DF baseline and raw helper writes; producer semantics separate.
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct Helper {pub delta:[u32;3],pub flag:u8,pub accumulator:u32}
pub struct Input {pub time:u32,pub previous_time:u32,pub position:[u32;3],pub previous_position:[u32;3],pub reset_value:u32,pub manager_flag:Option<u8>}
fn arithmetic(a:u32,b:u32,add:bool)->u32 {
    let x=f32::from_bits(a);let y=f32::from_bits(b);if x.is_nan(){return a|0x00400000;}if y.is_nan(){return b|0x00400000;}
    let result=if add{x+y}else{x-y};if result.is_nan(){0xffc00000}else{result.to_bits()}
}
/// Returns the native local baseline. Does not write the emitter's last-time field.
/// Lazy initialization observes the helper AFTER displacement writes, as native.
pub fn update(input:&Input,helper:Option<&mut Helper>,mut initialize_manager:impl FnMut(&mut Helper)->u8)->u32 {
    let baseline=if input.previous_time==0xff7fffff {input.time}else{input.previous_time};
    if let Some(helper)=helper {
        helper.delta=std::array::from_fn(|i|arithmetic(input.position[i],input.previous_position[i],false));
        let manager_flag=match input.manager_flag {Some(flag)=>flag,None=>initialize_manager(helper)};
        if manager_flag!=0 {helper.flag=0;}
        helper.accumulator=if helper.flag==0 {input.reset_value}else{arithmetic(arithmetic(input.time,baseline,false),helper.accumulator,true)};
    }
    baseline
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::{Value,json};
    fn bits(v:&Value)->u32{u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn words<const N:usize>(v:&Value)->[u32;N]{std::array::from_fn(|i|bits(&v[i]))}
    #[test]
    fn baseline_and_helper_writes_match432_native_cpu_cases() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_auxiliary_contract.json")).unwrap();let rows=proof["cases"].as_array().unwrap();assert_eq!(rows.len(),432);
        for (i,row) in rows.iter().enumerate() {
            let mut helper=Helper {delta:[0xcccccccc;3],flag:row["helper_flag"].as_u64().unwrap() as u8,accumulator:bits(&row["old_accumulator"])};
            let mut events=vec![];let manager_flag=row["manager_flag"].as_u64().unwrap() as u8;
            let baseline=update(&Input {time:bits(&row["time"]),previous_time:bits(&row["previous_time"]),position:words(&row["position"]),previous_position:words(&row["previous_position"]),reset_value:bits(&row["reset_value"]),manager_flag:row["manager_present"].as_bool().unwrap().then_some(manager_flag)},if row["present"].as_bool().unwrap(){Some(&mut helper)}else{None},|h|{events.push(json!({"event":"manager_init","delta":h.delta.map(|v|format!("0x{v:x}"))}));manager_flag});
            let e=&row["cpu"];assert_eq!(baseline,bits(&e["baseline"]),"baseline case{i}");assert_eq!(helper,Helper {delta:words(&e["delta"]),flag:e["helper_flag"].as_u64().unwrap() as u8,accumulator:bits(&e["accumulator"])},"helper case{i}");assert_eq!(events,e["events"].as_array().unwrap().clone(),"initialization case{i}");
        }
    }
}
