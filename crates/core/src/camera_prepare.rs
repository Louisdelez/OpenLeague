//! Full original9820F0 render camera preparation, retaining native matrix/depth conventions.
use crate::camera_parameters::Parameters;
#[derive(Debug,Clone)]
pub struct Prepared {
    pub position:[f32;3],pub far:f32,pub view:[f32;16],pub projection:[f32;16],
    pub view_projection:[f32;16],pub inverse_view_projection:[f32;16],pub used_inverse_fallback:bool,
    pub corners:[[f32;3];8],pub plane_coefficients:[[f32;4];6],
}
pub fn from_parameters(camera:&Parameters,aspect:f32,inverse_fallback:&[f32;16])->Result<Prepared,&'static str> {
    let view=crate::camera_view::from_parameters(camera)?;let projection=crate::camera_projection::from_parameters(camera,aspect)?;
    from_matrices(camera.position,camera.far,view,projection,inverse_fallback)
}
/// Original scalar SSE product, inverse and clip corner construction from native view/projection.
pub fn from_matrices(position:[f32;3],far:f32,view:[f32;16],projection:[f32;16],inverse_fallback:&[f32;16])->Result<Prepared,&'static str> {
    let view_projection=crate::camera_view::multiply(&view,&projection);
    let inverse=crate::matrix_inverse::inverse(&view_projection,inverse_fallback);
    let clip=[[-1.,-1.,0.],[1.,-1.,0.],[-1.,1.,0.],[1.,1.,0.],[-1.,-1.,1.],[1.,-1.,1.],[-1.,1.,1.],[1.,1.,1.]];
    let corners=clip.map(|p|crate::audio_emitter_camera_volume::transform(p,&inverse.matrix));
    let triples=[[0,1,2],[6,7,5],[2,6,4],[7,3,5],[2,3,6],[1,0,4]];
    let mut plane_coefficients=[[0_f32;4];6];
    for (out,[a,b,c]) in plane_coefficients.iter_mut().zip(triples) {*out=crate::audio_emitter_planes::from_triangle(corners[a],corners[b],corners[c])?.coefficients;}
    Ok(Prepared{position,far,view,projection,view_projection,inverse_view_projection:inverse.matrix,used_inverse_fallback:inverse.used_fallback,corners,plane_coefficients})
}
#[cfg(test)]
mod tests {
    use super::*;
    fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/camera_prepare_contract.json")).unwrap()}
    fn exact(actual:f32,original:f32,context:&str) {if original.is_nan() {assert!(actual.is_nan(),"{context}");} else {assert_eq!(actual.to_bits(),original.to_bits(),"{context}");}}
    fn approximate(actual:f32,original:f32,context:&str) {
        if !original.is_finite() {exact(actual,original,context);} else {assert!((actual-original).abs()<=1e-5_f32.max(original.abs()*2e-6),"{context}: {actual} vs {original}");}
    }
    #[test]
    fn matches_960_native_preparations_from_original_view_projection_matrices() {
        let proof=proof();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),960);let mut fallbacks=0;
        for (case_index,c) in cases.iter().enumerate() {
            let read=|key:&str,i:usize|f32::from_bits(c[key][i].as_u64().unwrap() as u32);
            let position=std::array::from_fn(|i|c["position"][i].as_f64().unwrap() as f32);let far=c["far"].as_f64().unwrap() as f32;
            let result=from_matrices(position,far,std::array::from_fn(|i|read("view_bits",i)),std::array::from_fn(|i|read("projection_bits",i)),&std::array::from_fn(|i|read("fallback_bits",i))).unwrap();
            assert_eq!(result.position,position);assert_eq!(result.far.to_bits(),far.to_bits());assert_eq!(result.used_inverse_fallback,c["used_fallback"].as_bool().unwrap(),"case{case_index}");if result.used_inverse_fallback {fallbacks+=1;}
            for i in 0..16 {exact(result.view_projection[i],read("product_bits",i),&format!("case{case_index}product{i}"));exact(result.inverse_view_projection[i],read("inverse_bits",i),&format!("case{case_index}inverse{i}"));}
            for i in 0..8 {for j in 0..3 {exact(result.corners[i][j],read("corners_bits",3*i+j),&format!("case{case_index}corner{i}/{j}"));}}
            for i in 0..6 {for j in 0..4 {approximate(result.plane_coefficients[i][j],read("plane_bits",4*i+j),&format!("case{case_index}plane{i}/{j}"));}}
        }
        assert_eq!(fallbacks,704);
    }
    #[test]
    fn parameter_api_preserves_960_native_view_projection_inputs_with_explicit_sse_tolerance() {
        let proof=proof();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),960);
        for (case_index,c) in cases.iter().enumerate() {
            let mut camera=Parameters::original_initial(std::array::from_fn(|i|c["position"][i].as_f64().unwrap() as f32));camera.direction=std::array::from_fn(|i|c["direction"][i].as_f64().unwrap() as f32);camera.up=std::array::from_fn(|i|c["up"][i].as_f64().unwrap() as f32);camera.projection_raw=c["mode"].as_u64().unwrap() as u32;camera.near=c["near"].as_f64().unwrap() as f32;camera.far=c["far"].as_f64().unwrap() as f32;camera.width=c["width"].as_f64().unwrap() as f32;camera.height=c["height"].as_f64().unwrap() as f32;
            let read=|key:&str,i:usize|f32::from_bits(c[key][i].as_u64().unwrap() as u32);
            let result=from_parameters(&camera,f32::from_bits(c["aspect_bits"].as_u64().unwrap() as u32),&std::array::from_fn(|i|read("fallback_bits",i))).unwrap();
            for i in 0..16 {approximate(result.view[i],read("view_bits",i),&format!("case{case_index}view{i}"));approximate(result.projection[i],read("projection_bits",i),&format!("case{case_index}projection{i}"));}
        }
    }
}
