//! Native9861D0 projection matrices before GPU convention conversion.
use crate::camera_parameters::{Parameters,Request,Kind};
/// Retains native left-handed, zero-to-one depth and row-major storage.
pub fn from_request(request:&Request)->Result<[f32;16],&'static str> {
    let [a,b,near,far]=request.parameters;
    let mut matrix=[0_f32;16];
    if request.kind==Kind::Orthographic {
        matrix[0]=2_f32/a;matrix[5]=2_f32/b;matrix[10]=1_f32/(far-near);matrix[14]=near/(near-far);matrix[15]=1.;
        return Ok(matrix);
    }
    // Outside FPTAN's range it sets C2 and does not push its usual result.
    if !a.is_finite() || (a as f64*0.5).abs()>=9223372036854775808. {return Err("native camera FPTAN angle unsupported");}
    #[cfg(any(target_arch="x86",target_arch="x86_64"))]
    {
        let half=0.5_f32;let mut horizontal=0_f32;let mut vertical=0_f32;
        // Keep reciprocal tangent extended until both stores, as original8E0320.
        unsafe {std::arch::asm!("fld dword ptr [{angle}]","fmul dword ptr [{half}]","fptan","fstp st(0)","fld1","fdivrp st(1), st(0)","fld dword ptr [{aspect}]","fdivr st(0), st(1)","fstp dword ptr [{horizontal}]","fstp dword ptr [{vertical}]",angle=in(reg) &a,half=in(reg) &half,aspect=in(reg) &b,horizontal=in(reg) &mut horizontal,vertical=in(reg) &mut vertical,out("st(0)") _,out("st(1)") _,options(nostack));}
        let reciprocal_depth=1_f32/(far-near);
        matrix[0]=horizontal;matrix[5]=vertical;matrix[10]=reciprocal_depth*far;matrix[11]=1.;matrix[14]=-((near*far)*reciprocal_depth);
        Ok(matrix)
    }
    #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
    {Err("native x87 camera projection unavailable")}
}
pub fn from_parameters(camera:&Parameters,aspect:f32)->Result<[f32;16],&'static str> {from_request(&camera.render_request(aspect))}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_336_full_native_projection_builds() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/camera_projection_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),336);
        for c in cases {
            let mut camera=Parameters::original_initial([0.;3]);camera.projection_raw=c["mode"].as_u64().unwrap() as u32;camera.fov_degrees=c["fov_degrees"].as_f64().unwrap() as f32;camera.near=c["near"].as_f64().unwrap() as f32;camera.far=c["far"].as_f64().unwrap() as f32;camera.width=c["width"].as_f64().unwrap() as f32;camera.height=c["height"].as_f64().unwrap() as f32;
            let matrix=from_parameters(&camera,f32::from_bits(c["aspect_bits"].as_u64().unwrap() as u32)).unwrap();
            for i in 0..16 {
                let original=f32::from_bits(c["matrix_bits"][i].as_u64().unwrap() as u32);
                if original.is_nan() {assert!(matrix[i].is_nan(),"{i}/{c}");}
                else if !matches!(camera.projection_raw,1|2) && matches!(i,0|5) && original.is_finite() {
                    assert!((matrix[i]-original).abs()<=1e-5_f32.max(original.abs()*1e-6),"{i}: {} vs {original}/{c}",matrix[i]);
                } else {assert_eq!(matrix[i].to_bits(),original.to_bits(),"{i}/{c}");}
            }
        }
    }
    #[test]
    fn rejects_angles_without_a_native_fptan_stack_result() {
        for angle in [f32::INFINITY,f32::NAN,f32::MAX] {assert!(from_request(&Request{kind:Kind::Perspective,parameters:[angle,1.,50.,65000.]}).is_err());}
    }
}
