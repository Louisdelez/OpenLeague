//! Native FXAA caller gate and per-pass constants, from 4.20 instruction receipts.
//! This describes the pass; shader execution and backend allocation remain separate.
#[derive(Debug,Clone,Copy,PartialEq)]
pub struct Pass {
    pub reciprocal_frame:[f32;4],
    pub quality_options:[f32;4],
    pub width:u32,
    pub height:u32,
}
pub const OPTION_ID:i32=23;
pub const DEFAULT_OPTION:i32=0;
pub fn enabled(option:i32,shader_capability:u32)->bool {
    option>0 && shader_capability>=0xffff0300
}
impl Pass {
    pub fn new(width:u32,height:u32,option:i32)->Self {
        // Original x87 computes reciprocal from the integer dimensions before
        // storing f32 constants. Keep integer conversion out of f32 arithmetic.
        let reciprocal_frame=[(1.0/f64::from(width)) as f32,(1.0/f64::from(height)) as f32,0.0,0.0];
        let bits=if option<=1 {
            [0x3f400000,0x3f000000,0x3daa9931,0]
        } else {
            [0x3f000000,0x3e29fbe7,0x3daa9931,0]
        };
        Self {reciprocal_frame,quality_options:bits.map(f32::from_bits),width,height}
    }
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn caller_gate_matches_original_instruction_cases() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_fxaa_option_contract.json")).unwrap();
        assert_eq!(proof["passed"],true);
        assert_eq!(proof["option"]["id"],OPTION_ID);
        assert_eq!(proof["option"]["default"],DEFAULT_OPTION);
        for row in proof["consumer_cases"].as_array().unwrap() {
            let capability=u32::from_str_radix(row["shader_cap"].as_str().unwrap().trim_start_matches("0x"),16).unwrap();
            assert_eq!(enabled(row["value"].as_i64().unwrap() as i32,capability),row["invokes_fxaa"].as_bool().unwrap());
        }
    }
    #[test] fn constants_match_original_pass_instructions() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_fxaa_pass_contract.json")).unwrap();
        assert_eq!(proof["passed"],true);
        assert_eq!(proof["case_count"],126);
        for row in proof["cases"].as_array().unwrap() {
            let actual=Pass::new(row["width"].as_u64().unwrap() as u32,row["height"].as_u64().unwrap() as u32,row["option"].as_i64().unwrap() as i32);
            let constants:Vec<_>=row["events"].as_array().unwrap().iter().filter(|e|e["kind"]=="constants").collect();
            for (values,event) in [(actual.reciprocal_frame,constants[0]),(actual.quality_options,constants[1])] {
                for (value,native) in values.into_iter().zip(event["values"].as_array().unwrap()) {
                    assert_eq!(value.to_bits(),(native.as_f64().unwrap() as f32).to_bits());
                }
            }
        }
    }
}
