//! Original934860..9348E1 normalized emitter age at the Complex birth caller.
//! Raw field offsets retained: source/update semantics are not yet qualified.
#[derive(Debug,Copy,Clone)]
pub struct EmitterAgeInput {
    pub config_308:f32,
    pub config_30c:f32,
    pub instance_7c:f32,
    pub time:f32,
    pub owner_a8:f32,
    pub offset_2ec:f32,
}
#[derive(Debug,Copy,Clone)]
pub struct EmitterAge {pub selected_duration:f32,pub normalized:f32}
// Rust leaves NaN payload selection unspecified. Original SSE selects a NaN
// source operand first, quieting it; invalid arithmetic creates negative QNaN.
pub(crate) fn sse_result(left:f32,right:f32,operation:impl FnOnce(f32,f32)->f32)->f32 {
    if right.is_nan() {return f32::from_bits(right.to_bits()|0x00400000);}
    if left.is_nan() {return f32::from_bits(left.to_bits()|0x00400000);}
    let value=operation(left,right);
    if value.is_nan() {f32::from_bits(0xffc00000)} else {value}
}
impl EmitterAgeInput {
    pub fn evaluate(self)->EmitterAge {
        // COMISS/JA chooses30C only for ordered308>30C. Unordered uses308.
        let selected=if self.config_308>self.config_30c {self.config_30c} else {self.config_308};
        // COMISS/CMOVBE also selects instance7C for an unordered comparison.
        let selected_duration=if self.instance_7c<=selected || self.instance_7c.is_nan() || selected.is_nan() {self.instance_7c} else {selected};
        let elapsed=sse_result(self.time,self.owner_a8,|a,b|a-b);
        let delayed=sse_result(elapsed,self.offset_2ec,|a,b|a-b);
        let normalized=sse_result(delayed,selected_duration,|a,b|a/b);
        EmitterAge {selected_duration,normalized}
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn bits(row:&serde_json::Value,key:&str)->u32 {u32::from_str_radix(row[key].as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    #[test]
    fn emitter_age_matches_original_selection_and_sse_bits() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/complex_emitter_age_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),3064);
        for row in proof["cases"].as_array().unwrap() {
            let get=|key|f32::from_bits(bits(row,key));
            let actual=EmitterAgeInput {config_308:get("config_308_bits"),config_30c:get("config_30c_bits"),instance_7c:get("instance_7c_bits"),time:get("time_bits"),owner_a8:get("owner_a8_bits"),offset_2ec:get("offset_bits")}.evaluate();
            assert_eq!(actual.selected_duration.to_bits(),bits(row,"selected_duration_bits"),"{row}");
            assert_eq!(actual.normalized.to_bits(),bits(row,"normalized_age_bits"),"{row}");
        }
    }
}
