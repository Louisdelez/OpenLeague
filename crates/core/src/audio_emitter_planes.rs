//! Original8E3350/8E33E0 corner-to-plane construction and8E30D0 indices.
use crate::audio_emitter_bounds::Plane;
#[derive(Debug,Clone,Copy)]
pub enum Projection {Perspective,Orthographic}
pub fn selection(normal:[f32;3])->[usize;3] {std::array::from_fn(|i|if normal[i]<0. {i} else {i+3})}
pub(crate) fn reciprocal_sqrt(value:f32)->Result<f32,&'static str> {
    #[cfg(target_arch="x86_64")]
    let estimate=unsafe {use std::arch::x86_64::*;_mm_cvtss_f32(_mm_rsqrt_ss(_mm_set_ss(value)))};
    #[cfg(target_arch="x86")]
    let estimate={
        if !std::is_x86_feature_detected!("sse") {return Err("native SSE reciprocal square root unavailable");}
        unsafe {use std::arch::x86::*;_mm_cvtss_f32(_mm_rsqrt_ss(_mm_set_ss(value)))}
    };
    #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
    return Err("native SSE reciprocal square root unavailable");
    #[cfg(any(target_arch="x86",target_arch="x86_64"))]
    {let product=(estimate*value)*estimate;Ok((3.-product)*(estimate*0.5))}
}
pub(crate) fn from_triangle(a:[f32;3],b:[f32;3],c:[f32;3])->Result<Plane,&'static str> {
    let u=std::array::from_fn::<_,3,_>(|i|b[i]-a[i]);let v=std::array::from_fn::<_,3,_>(|i|c[i]-b[i]);
    let mut n=[v[2]*u[1]-u[2]*v[1],u[2]*v[0]-u[0]*v[2],u[0]*v[1]-u[1]*v[0]];
    if n.iter().all(|x|*x==0.) {return Ok(Plane{coefficients:[0.;4],indices:[3,4,5]});}
    let length=(n[1]*n[1]+n[0]*n[0])+n[2]*n[2];
    if length>f32::from_bits(0x3089705f) {
        let factor=reciprocal_sqrt(length)?;
        for value in &mut n {*value=(*value as f64*factor as f64) as f32;}
    }
    let offset=-((a[1]*n[1]+a[0]*n[0])+a[2]*n[2]);
    Ok(Plane{coefficients:[n[0],n[1],n[2],offset],indices:selection(n)})
}
/// Supply the original nine world-space corners; projection/world transform is external.
pub fn from_corners(corners:&[[f32;3];9],projection:Projection)->Result<[Plane;6],&'static str> {
    let triples=match projection {
        Projection::Perspective=>[[1,0,2],[3,0,4],[2,0,3],[4,0,1],[4,2,3],[8,7,6]],
        Projection::Orthographic=>[[1,5,2],[3,7,4],[2,6,3],[4,8,1],[4,2,3],[8,7,6]],
    };
    let mut planes=[Plane{coefficients:[0.;4],indices:[3,4,5]};6];
    for (out,[a,b,c]) in planes.iter_mut().zip(triples) {*out=from_triangle(corners[a],corners[b],corners[c])?;}
    Ok(planes)
}
#[cfg(test)]
mod tests {
    use super::*;
    fn proof()->serde_json::Value {serde_json::from_str(include_str!("../../../data/4.20/audio_emitter_planes_contract.json")).unwrap()}
    #[test]
    fn matches_50_native_plane_builds_with_explicit_sse_estimate_tolerance() {
        let proof=proof();assert_eq!(proof["normalization_threshold_bits"].as_u64().unwrap(),0x3089705f);let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),50);
        for c in cases {
            let corners=std::array::from_fn(|i|std::array::from_fn(|j|f32::from_bits(c["points_bits"][3*i+j].as_u64().unwrap() as u32)));
            let mode=if c["mode"]=="perspective" {Projection::Perspective} else {Projection::Orthographic};let planes=from_corners(&corners,mode).unwrap();
            for (i,p) in planes.iter().enumerate() {
                for j in 0..4 {
                    let original=f32::from_bits(c["coefficients_bits"][4*i+j].as_u64().unwrap() as u32);
                    let tolerance=1e-5_f32.max(original.abs()*1e-6);
                    assert!((p.coefficients[j]-original).abs()<=tolerance,"mode {mode:?}, plane{i} component{j}: {} vs {original}",p.coefficients[j]);
                }
                for j in 0..3 {assert_eq!(p.indices[j],c["indices"][3*i+j].as_u64().unwrap() as usize);}
            }
        }
    }
    #[test]
    fn matches_343_native_sign_selections_with_negative_zero_nan_and_infinity() {
        let proof=proof();let cases=proof["index_cases"].as_array().unwrap();assert_eq!(cases.len(),343);
        for c in cases {
            let normal=std::array::from_fn(|i|f32::from_bits(c["normal_bits"][i].as_u64().unwrap() as u32));
            assert_eq!(selection(normal),std::array::from_fn(|i|c["indices"][i].as_u64().unwrap() as usize));
        }
    }
}
