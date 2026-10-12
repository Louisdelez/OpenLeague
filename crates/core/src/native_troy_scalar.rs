//! Whole93FB60: scalar remap and both child coefficient loops.
//! Coefficients and owner factors must come from the native resource/engine.
#[derive(Debug, Copy, Clone, PartialEq, Eq)]
pub struct Child {
    /// Native positive gate / scalar weight, owner E0 weight, owner E4 weight.
    pub coefficients: [u32; 3],
    pub owner: [u32; 2],
    pub value: u32,
}
fn arithmetic(left:u32,right:u32,operation:impl FnOnce(f32,f32)->f32)->u32 {
    let a=f32::from_bits(left);let b=f32::from_bits(right);
    if a.is_nan() {return left|0x00400000;}
    if b.is_nan() {return right|0x00400000;}
    let v=operation(a,b);if v.is_nan() {0xffc00000} else {v.to_bits()}
}
/// Raw bits preserve skipped gates and nonfinite source values.
pub fn apply(input:u32,lower:u32,upper:u32,target:u32,first:&mut [Child],second:&mut [Child])->u32 {
    let mut scalar=input;
    if f32::from_bits(input)>f32::from_bits(lower) && f32::from_bits(target)>0. {
        if f32::from_bits(input)>=f32::from_bits(upper) {scalar=target;}
        else {
            let numerator=arithmetic(input,lower,|a,b|a-b);
            let denominator=arithmetic(upper,lower,|a,b|a-b);
            let span=arithmetic(target,lower,|a,b|a-b);
            let fraction=arithmetic(numerator,denominator,|a,b|a/b);
            let scaled=arithmetic(fraction,span,|a,b|a*b);
            scalar=arithmetic(scaled,lower,|a,b|a+b);
        }
    }
    for child in first.iter_mut().chain(second.iter_mut()) {
        let [weight,owner0_weight,owner1_weight]=child.coefficients;
        if f32::from_bits(weight)>0. {
            let scaled=arithmetic(weight,scalar,|a,b|a*b);
            let owner0=arithmetic(owner0_weight,child.owner[0],|a,b|a*b);
            let partial=arithmetic(owner0,scaled,|a,b|a+b);
            let owner1=arithmetic(owner1_weight,child.owner[1],|a,b|a*b);
            let value=arithmetic(partial,owner1,|a,b|a+b);
            child.value=if f32::from_bits(value)>0. {value} else {0x3f800000};
        }
    }
    scalar
}
#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::Value;
    fn bits(v:&Value)->u32 {u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn children(v:&Value)->Vec<Child> {
        v.as_array().unwrap().iter().map(|c|Child {
            coefficients:std::array::from_fn(|i|bits(&c["coefficients"][i])),
            owner:std::array::from_fn(|i|bits(&c["owner"][i])),value:bits(&c["previous"]),
        }).collect()
    }
    #[test]
    fn remap_and_both_child_loops_match400_original_function_cases() {
        let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_scalar_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),400);
        assert_eq!(bits(&proof["fallback_bits"]),0x3f800000);
        assert_eq!(proof["actual_cpu_sse_operations"],3917);
        for (index,row) in proof["cases"].as_array().unwrap().iter().enumerate() {
            let mut first=children(&row["children"][0]);let mut second=children(&row["children"][1]);
            let scalar=apply(bits(&row["input"]),bits(&row["lower"]),bits(&row["upper"]),bits(&row["target"]),&mut first,&mut second);
            assert_eq!(scalar,bits(&row["cpu"]["scalar"]),"case {index}");
            for (kind,group) in [first,second].iter().enumerate() {
                for (child,value) in group.iter().zip(row["cpu"]["children"][kind].as_array().unwrap()) {
                    assert_eq!(child.value,bits(value),"case {index} child family {kind}");
                }
            }
        }
    }
}
