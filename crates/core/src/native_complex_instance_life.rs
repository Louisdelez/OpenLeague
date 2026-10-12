//! Original9331D0 instance duration and934469 elapsed/end-flag fragments.
//! A past-end flag is not whole emitter completion or particle removal.
use crate::native_complex_age::sse_result;
pub fn initial_duration(life:f32,scale_enabled:bool,owner_scale:f32)->f32 {
    if scale_enabled {sse_result(life,owner_scale,|a,b|a*b)} else {life}
}
#[derive(Debug,Copy,Clone)]
pub struct EndFlag {pub elapsed:f32,pub past_end:bool}
/// Raw flag10 selects config33C instead of instance7C as the comparison bound.
/// Later emission/period/linger/live-particle decisions are separate consumers.
pub fn evaluate_end_flag(time:f32,owner_start:f32,instance_duration:f32,owner_flags:u32,config_33c:f32)->EndFlag {
    let elapsed=sse_result(time,owner_start,|a,b|a-b);
    let bound=if owner_flags&0x10!=0 {config_33c} else {instance_duration};
    EndFlag {elapsed,past_end:elapsed>bound}
}
impl crate::native_complex_timing::Timing {
    pub fn initial_instance_duration(&self,scale_enabled:bool,owner_scale:f32)->f32 {
        initial_duration(self.life,scale_enabled,owner_scale)
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::Value;
    fn proof()->Value {serde_json::from_str(include_str!("../../../data/4.20/complex_instance_life_contract.json")).unwrap()}
    fn bits(v:&Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    #[test]
    fn initial_duration_matches_native_copy_or_scaled_bits() {
        let proof=proof();assert_eq!(proof["initial_cases"].as_array().unwrap().len(),200);
        for row in proof["initial_cases"].as_array().unwrap() {
            let actual=initial_duration(f32::from_bits(bits(&row["life_bits"])),row["enabled"].as_bool().unwrap(),f32::from_bits(bits(&row["scale_bits"])));
            assert_eq!(actual.to_bits(),bits(&row["instance_duration_bits"]),"{row}");
        }
    }
    #[test]
    fn elapsed_and_end_flag_match_native_bound_selection_and_unordered_cases() {
        let proof=proof();assert_eq!(proof["end_cases"].as_array().unwrap().len(),3600);
        for row in proof["end_cases"].as_array().unwrap() {
            let get=|key:&str|f32::from_bits(bits(&row[key]));
            let actual=evaluate_end_flag(get("time_bits"),get("owner_start_bits"),get("instance_duration_bits"),row["owner_flags"].as_u64().unwrap() as u32,get("override_33c_bits"));
            assert_eq!(actual.elapsed.to_bits(),bits(&row["elapsed_bits"]),"{row}");
            assert_eq!(actual.past_end,row["past_end"].as_bool().unwrap(),"{row}");
            assert_eq!(actual.past_end,row["local_end_flag"].as_bool().unwrap(),"{row}");
        }
    }
}
