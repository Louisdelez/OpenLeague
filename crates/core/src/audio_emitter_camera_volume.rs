//! Original8E3480 orthographic volume,8E1220 transforms and8E2C00 bounds.
use crate::audio_emitter_bounds::Plane;
#[derive(Debug,Clone)]
pub struct Volume {pub corners:[[f32;3];9],pub planes:[Plane;6],pub bounds:[f32;6]}
/// Original raw matrix layout. Keep scalar SSE addition order and homogeneous W.
pub fn transform(point:[f32;3],matrix:&[f32;16])->[f32;3] {
    let [x,y,z]=point;
    let w=((y*matrix[7]+x*matrix[3])+z*matrix[11])+matrix[15];
    let inverse=1./w;
    let a=((y*matrix[4]+x*matrix[0])+z*matrix[8])+matrix[12];
    let b=((y*matrix[5]+x*matrix[1])+z*matrix[9])+matrix[13];
    let c=((x*matrix[2]+y*matrix[6])+z*matrix[10])+matrix[14];
    [a*inverse,b*inverse,c*inverse]
}
/// Use ordered comparisons, preserving original NaN/signed-zero behavior.
pub fn bounds(corners:&[[f32;3];9])->[f32;6] {
    let mut out=[f32::MAX,f32::MAX,f32::MAX,-f32::MAX,-f32::MAX,-f32::MAX];
    for point in corners {
        for i in 0..3 {if out[i]>point[i] {out[i]=point[i];}if point[i]>out[i+3] {out[i+3]=point[i];}}
    }
    out
}
/// Parameters and world transform supplied by caller; no invented clamping.
pub fn orthographic(width:f32,height:f32,near:f32,far:f32,matrix:&[f32;16])->Result<Volume,&'static str> {
    let right=width*0.5;let left=width*-0.5;let top=height*0.5;let bottom=height*-0.5;
    let local=[[0.,0.,0.],[right,bottom,-far],[right,top,-far],[left,top,-far],[left,bottom,-far],[right,bottom,-near],[right,top,-near],[left,top,-near],[left,bottom,-near]];
    let corners=local.map(|point|transform(point,matrix));
    let planes=crate::audio_emitter_planes::from_corners(&corners,crate::audio_emitter_planes::Projection::Orthographic)?;
    Ok(Volume{bounds:bounds(&corners),corners,planes})
}
#[cfg(test)]
mod tests {
    use super::*;
    fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/audio_emitter_orthographic_contract.json")).unwrap()}
    fn volume(c:&serde_json::Value)->Volume {
        let matrix=std::array::from_fn(|i|f32::from_bits(c["matrix_bits"][i].as_u64().unwrap() as u32));
        orthographic(c["width"].as_f64().unwrap() as f32,c["height"].as_f64().unwrap() as f32,c["near"].as_f64().unwrap() as f32,c["far"].as_f64().unwrap() as f32,&matrix).unwrap()
    }
    #[test]
    fn matches_108_complete_native_orthographic_corners_and_bounds_bit_exactly() {
        let proof=proof();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),108);
        for c in cases {
            let volume=volume(c);
            for i in 0..9 {for j in 0..3 {assert_eq!(volume.corners[i][j].to_bits(),c["corners_bits"][i*3+j].as_u64().unwrap() as u32,"{c}");}}
            for i in 0..6 {assert_eq!(volume.bounds[i].to_bits(),c["bounds_bits"][i].as_u64().unwrap() as u32,"{c}");}
        }
    }
    #[test]
    fn matches_108_complete_native_plane_indices_and_normalized_coefficients() {
        let proof=proof();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),108);
        for c in cases {
            let volume=volume(c);
            for (i,p) in volume.planes.iter().enumerate() {
                for j in 0..3 {assert_eq!(p.indices[j],c["indices"][i*3+j].as_u64().unwrap() as usize);}
                for j in 0..4 {let native=f32::from_bits(c["coefficients_bits"][i*4+j].as_u64().unwrap() as u32);assert!((p.coefficients[j]-native).abs()<=1e-5_f32.max(native.abs()*1e-6),"plane{i}component{j}: {} vs{native}",p.coefficients[j]);}
            }
        }
    }
}

/// Use the original x87 tangent/product sequence, rather than a generic FOV formula.
fn tangent_depth(angle:f32,scale:f32,depth:f32)->Result<f32,&'static str> {
    if !angle.is_finite() || (angle as f64*scale as f64).abs()>=9223372036854775808. {
        return Err("angle outside qualified x87 FPTAN range");
    }
    #[cfg(any(target_arch="x86",target_arch="x86_64"))]
    {
        let mut output=0_f32;
        unsafe {std::arch::asm!(
            "fld dword ptr [{angle}]", "fmul dword ptr [{scale}]", "fptan", "fstp st(0)",
            "fmul dword ptr [{depth}]", "fstp dword ptr [{output}]",
            angle=in(reg) &angle,scale=in(reg) &scale,depth=in(reg) &depth,output=in(reg) &mut output,
            out("st(0)") _,out("st(1)") _,options(nostack),
        );}
        Ok(output)
    }
    #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
    {let _=depth;Err("native x87 tangent unavailable")}
}
/// Original8E2F30 raw angles and global14BEEA0 factor; runtime parameter source is external.
pub fn perspective(angle_a:f32,angle_b:f32,near:f32,far:f32,factor:f32,matrix:&[f32;16])->Result<Volume,&'static str> {
    let near_a=tangent_depth(angle_a,0.5,near)?;
    let near_b=tangent_depth(angle_b,0.5,near)?;
    let far_a=tangent_depth(angle_a,1.,far)?;
    let far_b=tangent_depth(angle_b,1.,far)?;
    let near_mid=((near_b+near_a)*0.5)*factor;
    let far_mid=((far_b+far_a)*0.5)*factor;
    let local=[[0.,0.,0.],[near_mid,-near_b,-near],[near_mid,near_a,-near],[-near_mid,near_a,-near],[-near_mid,-near_b,-near],[far_mid,-far_b,-far],[far_mid,far_a,-far],[-far_mid,far_a,-far],[-far_mid,-far_b,-far]];
    let corners=local.map(|p|transform(p,matrix));
    let planes=crate::audio_emitter_planes::from_corners(&corners,crate::audio_emitter_planes::Projection::Perspective)?;
    Ok(Volume{bounds:bounds(&corners),corners,planes})
}
#[cfg(test)]
mod perspective_tests {
    use super::*;
    #[test]
    fn matches_108_native_perspective_volumes_with_original_asymmetry_and_x87() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_emitter_perspective_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),108);
        for c in cases {
            let matrix=std::array::from_fn(|i|f32::from_bits(c["matrix_bits"][i].as_u64().unwrap() as u32));
            let input=|k:&str|c[k].as_f64().unwrap() as f32;
            let v=perspective(input("angle_a"),input("angle_b"),input("near"),input("far"),input("factor"),&matrix).unwrap();
            let close=|actual:f32,bits:&serde_json::Value| {let native=f32::from_bits(bits.as_u64().unwrap() as u32);assert!((actual-native).abs()<=1e-5_f32.max(native.abs()*1e-6),"{actual} vs {native}, {c}");};
            for i in 0..9 {for j in 0..3 {close(v.corners[i][j],&c["corners_bits"][i*3+j]);}}
            for i in 0..6 {close(v.bounds[i],&c["bounds_bits"][i]);for j in 0..4 {close(v.planes[i].coefficients[j],&c["coefficients_bits"][i*4+j]);}for j in 0..3 {assert_eq!(v.planes[i].indices[j],c["indices"][i*3+j].as_u64().unwrap() as usize);}}
        }
    }
}
