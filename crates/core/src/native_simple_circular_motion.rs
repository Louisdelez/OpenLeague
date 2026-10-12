//! Whole9448C0 planar radius preservation with native approximate norms.
fn norm(squared:f32)->Result<f32,&'static str> {
    let q=crate::native_particle_force_body::inverse_estimate(squared)?;
    Ok(if squared==0. {0.}else{((3.-((q*squared)*q))*(q*0.5))*squared})
}
fn multiply(a:f32,b:f32)->f32 {let v=a*b;if v.is_nan(){f32::from_bits(0xffc00000)}else{v}}
fn add(a:f32,b:f32)->f32 {if a.is_nan(){return f32::from_bits(a.to_bits()|0x00400000);}if b.is_nan(){return f32::from_bits(b.to_bits()|0x00400000);}let v=a+b;if v.is_nan(){f32::from_bits(0xffc00000)}else{v}}
pub fn update(position:&mut [u32;3],velocity:[u32;3],center:[u32;3],delta:u32,axis_a:usize,axis_b:usize)->Result<(),&'static str> {
    if axis_a>=3 || axis_b>=3{return Err("unsupported native circular axis index");}
    if !position.iter().copied().chain(velocity).chain(center).chain([delta]).all(|v|f32::from_bits(v).is_finite()){return Err("unqualified nonfinite circular motion input");}
    let mut p=position.map(f32::from_bits);let c=center.map(f32::from_bits);let v=velocity.map(f32::from_bits);let dt=f32::from_bits(delta);
    let da=p[axis_a]-c[axis_a];let db=p[axis_b]-c[axis_b];let radius=norm(da*da+db*db)?;
    for j in 0..3 {p[j]=add(multiply(v[j],dt),p[j]);}
    let da=p[axis_a]-c[axis_a];let db=p[axis_b]-c[axis_b];let length=norm(db*db+da*da)?;let inverse=1./length;
    let a=add(multiply(radius,multiply(inverse,da)),c[axis_a]);let b=add(multiply(radius,multiply(inverse,db)),c[axis_b]);
    p[axis_a]=a;p[axis_b]=b;*position=p.map(f32::to_bits);Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::Value;
    fn words(v:&Value)->[u32;3]{std::array::from_fn(|j|v[j].as_u64().unwrap() as u32)}
    #[test]
    fn circular_positions_match3528_native_cpu_cases_including_zero_radius() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_circular_motion_contract.json")).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),3528);
        for (i,r) in rows.iter().enumerate() {
            let mut position=words(&r["position"]);update(&mut position,words(&r["velocity"]),words(&r["center"]),r["delta"].as_u64().unwrap() as u32,r["axis_a"].as_u64().unwrap() as usize,r["axis_b"].as_u64().unwrap() as usize).unwrap();
            assert_eq!(position,words(&r["cpu"]["position"]),"position case{i}");assert_eq!(words(&r["velocity"]),words(&r["cpu"]["velocity"]));assert_eq!(words(&r["center"]),words(&r["cpu"]["center"]));
        }
    }
}
