//! Original renderer aspect writers: unsigned x87 initialization and signed SSE device setup.
/// Preserve native exceptional arithmetic, including zero height, rather than clamp dimensions.
pub fn unsigned_initialization(width:u32,height:u32)->Result<f32,&'static str> {
    #[cfg(any(target_arch="x86",target_arch="x86_64"))]
    {
        let width=i64::from(width);let height=i64::from(height);let mut result=0_f32;
        // Native FILD i32 plus 2^32 for high-bit values is exactly FILD of these i64 values.
        unsafe {std::arch::asm!("fild qword ptr [{width}]","fild qword ptr [{height}]","fdivp st(1), st(0)","fstp dword ptr [{result}]",width=in(reg) &width,height=in(reg) &height,result=in(reg) &mut result,out("st(0)") _,out("st(1)") _,options(nostack));}
        Ok(result)
    }
    #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
    {let _=(width,height);Err("native x87 camera aspect unavailable")}
}
pub fn signed_device_setup(width:u32,height:u32)->Result<f32,&'static str> {
    #[cfg(target_arch="x86_64")]
    use std::arch::x86_64::{_mm_setzero_ps,_mm_cvtsi32_ss,_mm_div_ss,_mm_cvtss_f32};
    #[cfg(target_arch="x86")]
    use std::arch::x86::{_mm_setzero_ps,_mm_cvtsi32_ss,_mm_div_ss,_mm_cvtss_f32};
    #[cfg(any(target_arch="x86",target_arch="x86_64"))]
    {unsafe {Ok(_mm_cvtss_f32(_mm_div_ss(_mm_cvtsi32_ss(_mm_setzero_ps(),width as i32),_mm_cvtsi32_ss(_mm_setzero_ps(),height as i32))))}}
    #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
    {let _=(width,height);Err("native SSE camera aspect unavailable")}
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_162_native_aspect_writes_bit_exactly_including_exceptional_dimensions() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/camera_aspect_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),162);
        for c in cases {
            let width=c["width"].as_u64().unwrap() as u32;let height=c["height"].as_u64().unwrap() as u32;
            let actual=if c["path"]=="unsigned_initialization" {unsigned_initialization(width,height)} else {signed_device_setup(width,height)}.unwrap();
            assert_eq!(actual.to_bits(),c["aspect_bits"].as_u64().unwrap() as u32,"{c}");
        }
    }
}
