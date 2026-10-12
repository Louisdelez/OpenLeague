//! Native projectile provider10B0D20, orientation719D20..71A0D4.
use crate::native_particle_force_body::inverse_estimate;
fn identity()->[f32;16] {[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.]}
fn squared(v:[f32;3])->f32 {(v[0]*v[0]+v[1]*v[1])+v[2]*v[2]}
fn normalize(v:[f32;3])->Result<[f32;3],&'static str> {
    let s=squared(v);let e=inverse_estimate(s)?;
    let length=if s==0. {0.}else{((3.-((e*s)*e))*(e*0.5))*s};
    Ok(if length!=0. {let k=1./length;v.map(|x|x*k)}else{v})
}
/// Absent owner returns false and an identity matrix, as the original callback.
pub fn orientation(direction:Option<[f32;3]>)->Result<(bool,[f32;16]),&'static str> {
    let Some(mut d)=direction else{return Ok((false,identity()))};
    if !d.iter().all(|x|x.is_finite()) || !squared(d).is_finite() {return Err("unqualified native missile direction");}
    let s=squared(d);
    if s>1e-9 {
        let e=inverse_estimate(s)?;let inverse=(3.-((e*s)*e))*(e*0.5);
        d=d.map(|x|x*inverse);
    }
    let dot=(d[0]*0.+d[1])+d[2]*0.;
    if dot.abs()>0.98 {
        let mut m=identity();if dot<0. {m[10]=-1.;}return Ok((true,m));
    }
    let f=normalize(d)?;
    let right=normalize([f[1]*0.-f[2],f[2]*0.-f[0]*0.,f[0]-f[1]*0.])?;
    let up=normalize([f[2]*right[1]-f[1]*right[2],f[0]*right[2]-f[2]*right[0],f[1]*right[0]-f[0]*right[1]])?;
    let mut m=identity();m[..3].copy_from_slice(&right);m[4..7].copy_from_slice(&f);m[8..11].copy_from_slice(&up);
    Ok((true,m))
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn projectile_orientation_matches24_native_cases_with37_cpu_rsqrt_operations() {
    let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/missile_effect_owner_orientation_contract.json")).unwrap();
    assert_eq!(p["cases"].as_array().unwrap().len(),24);assert_eq!(p["actual_cpu_rsqrt_operations"],37);
    for (n,c) in p["cases"].as_array().unwrap().iter().enumerate() {
        let d=std::array::from_fn(|i|c["direction"][i].as_f64().unwrap() as f32);
        let (ok,m)=orientation(c["live"].as_bool().unwrap().then_some(d)).unwrap();assert_eq!(ok,c["ok"]==1);
        for (i,v) in m.iter().enumerate(){assert_eq!(v.to_bits(),c["result_words"][i].as_u64().unwrap() as u32,"case{n} component{i}");}
    }
 }
}
