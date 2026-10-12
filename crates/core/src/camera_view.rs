//! Full original986250 view construction. Raw matrices use native row-major layout.
use crate::camera_parameters::Parameters;
fn identity()->[f32;16] {[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.]}
pub(crate) fn multiply(a:&[f32;16],b:&[f32;16])->[f32;16] {
    std::array::from_fn(|i| {
        let row=i/4;let col=i%4;
        ((a[row*4]*b[col]+a[row*4+1]*b[4+col])+a[row*4+2]*b[8+col])+a[row*4+3]*b[12+col]
    })
}
fn normalize(mut v:[f32;3])->Result<[f32;3],&'static str> {
    let length=(v[0]*v[0]+v[1]*v[1])+v[2]*v[2];
    if length>f32::from_bits(NORMALIZATION_THRESHOLD) {
        let factor=crate::audio_emitter_planes::reciprocal_sqrt(length)?;
        for component in &mut v {*component=(*component as f64*factor as f64) as f32;}
    }
    Ok(v)
}
fn cross(a:[f32;3],b:[f32;3])->[f32;3] {
    [a[1]*b[2]-a[2]*b[1],a[2]*b[0]-a[0]*b[2],a[0]*b[1]-a[1]*b[0]]
}
/// Original8DFFA0: degenerate vectors remain degenerate, without invented fallback axes.
pub fn look_at(position:[f32;3],target:[f32;3],up:[f32;3])->Result<[f32;16],&'static str> {
    let forward=normalize(std::array::from_fn(|i|target[i]-position[i]))?;
    let right=normalize(cross(up,forward))?;let vertical=cross(forward,right);
    let dot=|axis:[f32;3]|-((position[1]*axis[1]+position[0]*axis[0])+position[2]*axis[2]);
    Ok([right[0],vertical[0],forward[0],0.,right[1],vertical[1],forward[1],0.,right[2],vertical[2],forward[2],0.,dot(right),dot(vertical),dot(forward),1.])
}
/// Original986250 rawmode2 shear and negative-pi/2 rotation, other modes look-at.
pub fn from_parameters(camera:&Parameters)->Result<[f32;16],&'static str> {
    if camera.projection_raw!=2 {
        let target=std::array::from_fn(|i|camera.position[i]+camera.direction[i]);
        return look_at(camera.position,target,camera.up);
    }
    #[cfg(any(target_arch="x86",target_arch="x86_64"))]
    {
        let mut shear=identity();let mut translation=identity();let mut rotation=identity();
        for i in 0..3 {translation[12+i]=-camera.position[i];}
        let factor=1_f32/camera.direction[1];shear[4]=-(camera.direction[0]*factor);shear[6]=-(camera.direction[2]*factor);
        let angle=f32::from_bits(MODE2_ROTATION);let mut sin=0_f32;let mut cos=0_f32;
        unsafe {std::arch::asm!("fld dword ptr [{angle}]","fld st(0)","fsin","fstp dword ptr [{sin}]","fcos","fstp dword ptr [{cos}]",angle=in(reg) &angle,sin=in(reg) &mut sin,cos=in(reg) &mut cos,out("st(0)") _,out("st(1)") _,options(nostack));}
        rotation[5]=cos;rotation[6]=sin;rotation[9]=-sin;rotation[10]=cos;
        Ok(multiply(&multiply(&translation,&shear),&rotation))
    }
    #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
    {Err("native x87 camera view rotation unavailable")}
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_160_native_mode2_matrices_bit_exactly_except_nan_payloads() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/camera_view_contract.json")).unwrap();let mut count=0;
        for c in proof["cases"].as_array().unwrap().iter().filter(|c|c["mode"]==2) {
            count+=1;let mut camera=Parameters::original_initial(std::array::from_fn(|i|c["position"][i].as_f64().unwrap() as f32));camera.direction=std::array::from_fn(|i|c["direction"][i].as_f64().unwrap() as f32);camera.projection_raw=2;
            let matrix=from_parameters(&camera).unwrap();
            for i in 0..16 {let original=f32::from_bits(c["matrix_bits"][i].as_u64().unwrap() as u32);if original.is_nan() {assert!(matrix[i].is_nan());} else {assert_eq!(matrix[i].to_bits(),original.to_bits(),"{i}/{c}");}}
        }
        assert_eq!(count,160);
    }
    #[test]
    fn matches_800_full_native_view_constructions_with_explicit_rsqrt_tolerance() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/camera_view_contract.json")).unwrap();
        assert_eq!(proof["normalization_threshold_bits"].as_u64().unwrap() as u32,NORMALIZATION_THRESHOLD);assert_eq!(proof["mode2_rotation_angle_bits"].as_u64().unwrap() as u32,MODE2_ROTATION);
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),800);
        for c in cases {
            let read=|key:&str|std::array::from_fn(|i|c[key][i].as_f64().unwrap() as f32);
            let mut camera=Parameters::original_initial(read("position"));camera.direction=read("direction");camera.up=read("up");camera.projection_raw=c["mode"].as_u64().unwrap() as u32;
            let matrix=from_parameters(&camera).unwrap();
            for i in 0..16 {
                let original=f32::from_bits(c["matrix_bits"][i].as_u64().unwrap() as u32);
                if original.is_nan() {assert!(matrix[i].is_nan(),"{i}/{c}");}
                else if original.is_infinite() {assert_eq!(matrix[i].to_bits(),original.to_bits(),"{i}/{c}");}
                else {
                    let translation_tolerance=if (12..15).contains(&i) {camera.position.iter().map(|v|v.abs()).fold(0_f32,f32::max)*1e-6} else {0.};
                    let tolerance=1e-5_f32.max(original.abs()*1e-6).max(translation_tolerance);
                    assert!((matrix[i]-original).abs()<=tolerance,"index{i}: {} vs {original}, tolerance{tolerance}/{c}",matrix[i]);
                }
            }
        }
    }
}

const NORMALIZATION_THRESHOLD:u32=814313567;
const MODE2_ROTATION:u32=3217625051;
