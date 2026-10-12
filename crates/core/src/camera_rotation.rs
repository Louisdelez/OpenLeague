//! Original866E00 pitch rotation using the executable's quantized sine table.
fn sine_table()->&'static [f32] {
    static TABLE:std::sync::OnceLock<Vec<f32>>=std::sync::OnceLock::new();
    TABLE.get_or_init(|| {
        #[derive(serde::Deserialize)] struct Contract {sin_table_bits:Vec<u32>}
        let proof:Contract=serde_json::from_str(include_str!("../../../data/4.20/camera_rotation_contract.json")).expect("native camera sine table");assert_eq!(proof.sin_table_bits.len(),3600);proof.sin_table_bits.into_iter().map(f32::from_bits).collect()
    })
}
fn index(scaled:f32)->usize {
    // CVTTSS2SI returns INT_MIN for nonfinite or unrepresentable inputs.
    let integer=if !scaled.is_finite() || scaled>=2147483648. || scaled< -2147483648. {i32::MIN} else {scaled.trunc() as i32};
    integer.rem_euclid(3600) as usize
}
pub(crate) fn lookup_scaled(scaled:f32)->f32 {sine_table()[index(scaled)]}
/// Original8E24F0/8E2550: separate f32 angle*10 and (90-angle)*10 indices.
pub fn coefficients(angle:f32)->[f32;2] {
    let table=sine_table();[table[index(angle*10.)],table[index((90_f32-angle)*10.)]]
}
pub fn rotate(mut point:[f32;3],origin:[f32;3],angle:f32)->Result<[f32;3],&'static str> {
    if angle==0. {return Ok(point);}
    let relative=[point[1]-origin[1],point[2]-origin[2]];
    if relative[0]==0. && relative[1]==0. {return Ok(point);}
    #[cfg(any(target_arch="x86",target_arch="x86_64"))]
    {
        let coefficients=coefficients(angle);let mut result=[0_f32;2];
        // Keep both products and sums extended until original f32 stores.
        unsafe {std::arch::asm!(
            "fld dword ptr [{relative}]","fmul dword ptr [{coefficients}+4]",
            "fld dword ptr [{relative}+4]","fmul dword ptr [{coefficients}]",
            "fsubp st(1), st(0)","fadd dword ptr [{origin}+4]","fstp dword ptr [{result}]",
            "fld dword ptr [{relative}]","fmul dword ptr [{coefficients}]",
            "fld dword ptr [{relative}+4]","fmul dword ptr [{coefficients}+4]",
            "faddp st(1), st(0)","fadd dword ptr [{origin}+8]","fstp dword ptr [{result}+4]",
            relative=in(reg) &relative,coefficients=in(reg) &coefficients,origin=in(reg) &origin,result=in(reg) &mut result,out("st(0)") _,out("st(1)") _,options(nostack));}
        point[1]=result[0];point[2]=result[1];Ok(point)
    }
    #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
    {let _=origin;Err("native x87 camera rotation unavailable")}
}
#[cfg(test)]
mod tests {
    use super::*;
    fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/camera_rotation_contract.json")).unwrap()}
    #[test]
    fn matches_14_native_dual_trig_lookups_including_indefinite_integer_inputs() {
        let proof=proof();let cases=proof["lookups"].as_array().unwrap();assert_eq!(cases.len(),14);
        for c in cases {let result=coefficients(f32::from_bits(c["angle_bits"].as_u64().unwrap() as u32));assert_eq!(result[0].to_bits(),c["sin_bits"].as_u64().unwrap() as u32);assert_eq!(result[1].to_bits(),c["cos_bits"].as_u64().unwrap() as u32);}
    }
    #[test]
    fn matches_168_original_camera_pitch_rotations_bit_exactly() {
        let proof=proof();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),168);
        for c in cases {
            let read=|key:&str|std::array::from_fn(|i|f32::from_bits(c[key][i].as_u64().unwrap() as u32));
            let result=rotate(read("point_bits"),read("origin_bits"),f32::from_bits(c["angle_bits"].as_u64().unwrap() as u32)).unwrap();
            for i in 0..3 {assert_eq!(result[i].to_bits(),c["output_bits"][i].as_u64().unwrap() as u32,"{i}/{c}");}
        }
    }
}
