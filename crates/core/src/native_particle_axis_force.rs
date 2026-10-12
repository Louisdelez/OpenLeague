//! Whole93C900. Raw axis is used directly, including nonunit/zero input axes.
fn norm(squared:f32)->Result<f32,&'static str> {
    let q=crate::native_particle_force_body::inverse_estimate(squared)?;
    Ok(if squared==0. {0.}else{((3.-((q*squared)*q))*(q*0.5))*squared})
}
pub fn update(axis:[u32;3],position:[u32;3],velocity:&mut [u32;3],parameters:[u32;3])->Result<(),&'static str> {
    reorient(axis,position,velocity,parameters,953267991,true)
}
pub(crate) fn reorient(axis:[u32;3],position:[u32;3],velocity:&mut [u32;3],parameters:[u32;3],alignment_threshold:u32,choose_sign:bool)->Result<(),&'static str> {
    if !axis.into_iter().chain(position).chain(*velocity).chain(parameters).all(|v|f32::from_bits(v).is_finite()){return Err("unqualified nonfinite axis force fields");}
    let a=axis.map(f32::from_bits);let v=velocity.map(f32::from_bits);
    let dot=(v[1]*a[1]+v[0]*a[0])+v[2]*a[2];let along=a.map(|x|x*dot);let perpendicular:[f32;3]=std::array::from_fn(|j|v[j]-along[j]);
    let speed=norm((perpendicular[0]*perpendicular[0]+perpendicular[1]*perpendicular[1])+perpendicular[2]*perpendicular[2])?;
    if !(speed>f32::from_bits(981668463)){return Ok(());}
    let mut radial:[f32;3]=std::array::from_fn(|j|f32::from_bits(position[j])-f32::from_bits(parameters[j]));
    let length=norm((radial[1]*radial[1]+radial[0]*radial[0])+radial[2]*radial[2])?;
    if length!=0. {let inverse=1./length;for x in &mut radial{*x*=inverse;}}
    let alignment=(a[0]*radial[0]+a[1]*radial[1])+a[2]*radial[2];
    if !((1.-alignment).abs()>f32::from_bits(alignment_threshold)){return Ok(());}
    let mut tangent=[a[2]*radial[1]-a[1]*radial[2],a[0]*radial[2]-a[2]*radial[0],a[1]*radial[0]-a[0]*radial[1]];
    let length=norm((tangent[0]*tangent[0]+tangent[1]*tangent[1])+tangent[2]*tangent[2])?;
    if length!=0. {let inverse=1./length;for x in &mut tangent{*x*=inverse;}}
    for x in &mut tangent{*x*=speed;}
    let agreement=(tangent[1]*perpendicular[1]+perpendicular[0]*tangent[0])+perpendicular[2]*tangent[2];
    if choose_sign && 0.>agreement {for x in &mut tangent{*x*=-1.;}}
    velocity[0]=(tangent[0]+along[0]).to_bits();velocity[1]=(tangent[1]+along[1]).to_bits();velocity[2]=(along[2]+tangent[2]).to_bits();
    Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::Value;
    fn words(v:&Value)->[u32;3]{std::array::from_fn(|j|v[j].as_u64().unwrap() as u32)}
    #[test]
    fn axis_force_matches784_native_cpu_cases_bit_exactly() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/particle_axis_force_contract.json")).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),784);
        for (i,r) in rows.iter().enumerate() {
            let mut velocity=words(&r["velocity"]);update(words(&r["axis"]),words(&r["position"]),&mut velocity,words(&r["parameters"])).unwrap();
            assert_eq!(velocity,words(&r["cpu"]["velocity"]),"velocity case{i}");assert_eq!(words(&r["position"]),words(&r["cpu"]["position"]));assert_eq!(words(&r["parameters"]),words(&r["cpu"]["parameters"]));
        }
    }
}
