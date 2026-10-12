//! Original8DEC10 row-major inverse and ordered determinant fallback.
#[derive(Debug,Clone,Copy)]
pub struct Inverse {pub matrix:[f32;16],pub used_fallback:bool}
/// The original copies global2D77410 on singular/indeterminate determinants.
/// Its contents are explicit until native runtime initialization is qualified.
pub fn inverse(a:&[f32;16],fallback:&[f32;16])->Inverse {
    let s0=a[0]*a[5]-a[1]*a[4];let s1=a[0]*a[6]-a[2]*a[4];let s2=a[0]*a[7]-a[3]*a[4];
    let s3=a[1]*a[6]-a[2]*a[5];let s4=a[1]*a[7]-a[3]*a[5];let s5=a[2]*a[7]-a[3]*a[6];
    let c0=a[8]*a[13]-a[9]*a[12];let c1=a[8]*a[14]-a[10]*a[12];let c2=a[8]*a[15]-a[11]*a[12];
    let c3=a[9]*a[14]-a[10]*a[13];let c4=a[9]*a[15]-a[11]*a[13];let c5=a[10]*a[15]-a[11]*a[14];
    let det=((((s0*c5-s1*c4)+s2*c3)+s3*c2)-s4*c1)+s5*c0;
    if !(det.abs()>f32::from_bits(DETERMINANT_THRESHOLD)) {return Inverse{matrix:*fallback,used_fallback:true};}
    let reciprocal=1_f32/det;
    let cofactors=[
        (a[5]*c5-a[6]*c4)+a[7]*c3,
        (a[2]*c4-a[1]*c5)-a[3]*c3,
        (a[13]*s5-a[14]*s4)+a[15]*s3,
        (a[10]*s4-a[9]*s5)-a[11]*s3,
        (a[6]*c2-a[4]*c5)-a[7]*c1,
        (a[0]*c5-a[2]*c2)+a[3]*c1,
        (a[14]*s2-a[12]*s5)-a[15]*s1,
        (a[8]*s5-a[10]*s2)+a[11]*s1,
        (a[4]*c4-a[5]*c2)+a[7]*c0,
        (a[1]*c2-a[0]*c4)-a[3]*c0,
        (a[12]*s4-a[13]*s2)+a[15]*s0,
        (a[9]*s2-a[8]*s4)-a[11]*s0,
        (a[5]*c1-a[4]*c3)-a[6]*c0,
        (a[0]*c3-a[1]*c1)+a[2]*c0,
        (a[13]*s1-a[12]*s3)-a[14]*s0,
        (a[8]*s3-a[9]*s1)+a[10]*s0,
    ];
    Inverse{matrix:cofactors.map(|value|value*reciprocal),used_fallback:false}
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_807_native_inverse_cases_and_309_fallback_branches_bit_exactly_except_nan_payloads() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/matrix_inverse_contract.json")).unwrap();assert_eq!(proof["determinant_threshold_bits"].as_u64().unwrap() as u32,DETERMINANT_THRESHOLD);
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),807);let mut fallbacks=0;
        for c in cases {
            let read=|key:&str|std::array::from_fn(|i|f32::from_bits(c[key][i].as_u64().unwrap() as u32));
            let result=inverse(&read("input_bits"),&read("fallback_bits"));assert_eq!(result.used_fallback,c["used_fallback"].as_bool().unwrap(),"{c}");if result.used_fallback {fallbacks+=1;}
            for i in 0..16 {let original=f32::from_bits(c["output_bits"][i].as_u64().unwrap() as u32);if original.is_nan() {assert!(result.matrix[i].is_nan(),"{i}/{c}");} else {assert_eq!(result.matrix[i].to_bits(),original.to_bits(),"{i}/{c}");}}
        }
        assert_eq!(fallbacks,309);
    }
}

const DETERMINANT_THRESHOLD:u32=925353388;
