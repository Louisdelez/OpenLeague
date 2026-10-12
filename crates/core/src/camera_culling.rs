//! Full native9863A0 camera-to-world culling volume, with explicit inverse fallback.
use crate::{camera_parameters::{Parameters,Kind},audio_emitter_camera_volume::{self,Volume}};
#[derive(Debug,Clone)]
pub struct Culling {pub world_matrix:[f32;16],pub used_inverse_fallback:bool,pub volume:Volume}
pub fn from_parameters(camera:&Parameters,aspect:f32,inverse_fallback:&[f32;16])->Result<Culling,&'static str> {
    let mut view=crate::camera_view::from_parameters(camera)?;
    // Original XOR sign flips of columns0 and2, including their translation entries.
    for i in [0,4,8,12,2,6,10,14] {view[i]=f32::from_bits(view[i].to_bits()^0x80000000);}
    let inverse=crate::matrix_inverse::inverse(&view,inverse_fallback);
    let request=camera.culling_request()?;let [a,b,near,far]=request.parameters;
    let volume=match request.kind {
        Kind::Perspective=>audio_emitter_camera_volume::perspective(a,b,near,far,aspect,&inverse.matrix)?,
        Kind::Orthographic=>audio_emitter_camera_volume::orthographic(a,b,near,far,&inverse.matrix)?,
    };
    Ok(Culling{world_matrix:inverse.matrix,used_inverse_fallback:inverse.used_fallback,volume})
}
#[cfg(test)]
mod tests {
    use super::*;
    fn equal(actual:f32,original:f32,tolerance:f32,context:&str) {
        if original.is_nan() {assert!(actual.is_nan(),"{context}");}
        else if original.is_infinite() {assert_eq!(actual.to_bits(),original.to_bits(),"{context}");}
        else {assert!((actual-original).abs()<=tolerance,"{context}: {actual} vs {original}, tolerance{tolerance}");}
    }
    #[test]
    fn matches_480_full_native_camera_to_culling_volumes() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/camera_culling_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),480);
        for (case_index,c) in cases.iter().enumerate() {
            let mut camera=Parameters::original_initial(std::array::from_fn(|i|c["position"][i].as_f64().unwrap() as f32));camera.projection_raw=c["mode"].as_u64().unwrap() as u32;camera.direction=std::array::from_fn(|i|c["direction"][i].as_f64().unwrap() as f32);camera.up=std::array::from_fn(|i|c["up"][i].as_f64().unwrap() as f32);
            let read=|key:&str,i:usize|f32::from_bits(c[key][i].as_u64().unwrap() as u32);
            let fallback=std::array::from_fn(|i|read("fallback_bits",i));let result=from_parameters(&camera,f32::from_bits(c["aspect_bits"].as_u64().unwrap() as u32),&fallback).unwrap();
            assert_eq!(result.used_inverse_fallback,c["used_inverse_fallback"].as_bool().unwrap(),"case{case_index}inverse fallback");
            let position_scale=camera.position.iter().map(|v|v.abs()).fold(0_f32,f32::max);let spatial_tolerance=(position_scale+camera.far.abs()+camera.width.abs()+camera.height.abs())*2e-6;
            for i in 0..16 {let original=read("world_matrix_bits",i);let tolerance=1e-5_f32.max(original.abs()*2e-6).max(if (12..15).contains(&i) {position_scale*2e-6} else {0.});equal(result.world_matrix[i],original,tolerance,&format!("case{case_index}world{i}"));}
            for i in 0..9 {for j in 0..3 {let original=read("corners_bits",i*3+j);equal(result.volume.corners[i][j],original,1e-5_f32.max(original.abs()*2e-6).max(spatial_tolerance),&format!("case{case_index}corner{i}/{j}"));}}
            for i in 0..6 {
                let original=read("bounds_bits",i);equal(result.volume.bounds[i],original,1e-5_f32.max(original.abs()*2e-6).max(spatial_tolerance),&format!("case{case_index}bound{i}"));
                for j in 0..4 {let original=read("coefficients_bits",i*4+j);equal(result.volume.planes[i].coefficients[j],original,1e-5_f32.max(original.abs()*2e-6).max(if j==3 {spatial_tolerance} else {0.}),&format!("case{case_index}plane{i}/{j}"));}
                for j in 0..3 {assert_eq!(result.volume.planes[i].indices[j],c["indices"][i*3+j].as_u64().unwrap() as usize,"case{case_index}plane{i}index{j}");}
            }
        }
    }
}
