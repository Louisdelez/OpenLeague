//! Original 8DFB00 finite Euler matrix, preserving its x87 cross product.
//! Arguments follow the original stack order; do not substitute a quaternion API.
#[cfg(any(target_arch="x86",target_arch="x86_64"))]
pub fn compose(angles:[f32;3])->Result<[f32;16],&'static str> {
    if angles.iter().any(|v|!v.is_finite()) {return Err("unqualified nonfinite native Euler angles");}
    // cos3/sin3/cos2/sin2/cos1/sin1 and native extended sin3*cos2.
    let mut values=[0f32;7];let cw=0x037fu16;let mut saved=0u16;
    unsafe {std::arch::asm!(
        "fnstcw word ptr [{saved}]","fldcw word ptr [{cw}]",
        "fld dword ptr [{angles}+8]","fld st(0)","fcos","fstp dword ptr [{values}]",
        "fsin","fst dword ptr [{values}+4]",
        "fld dword ptr [{angles}+4]","fld st(0)","fcos","fst dword ptr [{values}+8]",
        "fxch st(1)","fsin","fstp dword ptr [{values}+12]",
        "fld dword ptr [{angles}]","fld st(0)","fcos","fstp dword ptr [{values}+16]",
        "fsin","fstp dword ptr [{values}+20]","fmulp st(1)","fstp dword ptr [{values}+24]",
        "fldcw word ptr [{saved}]",saved=in(reg)&mut saved,cw=in(reg)&cw,
        angles=in(reg)angles.as_ptr(),values=in(reg)values.as_mut_ptr(),
        out("st(0)") _,out("st(1)") _,out("st(2)") _,out("st(3)") _,options(nostack,preserves_flags));}
    let [c3,s3,c2,s2,c1,s1,extended]=values;
    let neg=|v:f32|f32::from_bits(v.to_bits()^0x80000000);
    let c1s3=c1*s3;let s1s3=s1*s3;let c1c3=c1*c3;let s1c3=s1*c3;
    Ok([s1s3*s2+c1c3,extended,c1s3*s2+neg(s1c3),0.,
        s1c3*s2+neg(c1s3),c2*c3,c1c3*s2+s1s3,0.,
        s1*c2,neg(s2),c1*c2,0.,0.,0.,0.,1.])
}
#[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
pub fn compose(_: [f32;3])->Result<[f32;16],&'static str> {Err("native Euler x87 unavailable")}
