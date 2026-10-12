//! Native Simple emitter matrix and particle attachment consumers.
//! Upstream bone/system pose and update ordering must be qualified before activation.
use bevy::prelude::*;
pub fn emitter_matrix(local:bool, system:Mat4, position:Vec3)->Result<Mat4,&'static str> {
    if !system.is_finite() || !position.is_finite() {return Err("nonfinite emitter pose");}
    let mut values=if local {system.to_cols_array()} else {Mat4::IDENTITY.to_cols_array()};
    values[12]=position.x;values[13]=position.y;values[14]=position.z;
    Ok(Mat4::from_cols_array(&values))
}
pub fn bind_position(position:Vec3, normalized_age:f32, pair:Vec2, sticky:bool, previous:Vec3, current:Vec3)->Result<Vec3,&'static str> {
    if !position.is_finite() || !normalized_age.is_finite() || !pair.is_finite() || !previous.is_finite() || !current.is_finite() {return Err("nonfinite particle attachment");}
    if normalized_age>=1. || (pair.x<=0. && pair.y<=0. && !sticky) {return Ok(position);}
    if sticky {return Ok(current);}
    // Original thresholds at1138A10 (f32) and1138C08 (f64).
    if normalized_age<=0.001_f32 {return Ok(position);}
    let difference=pair.y-pair.x;
    let inverse=if (difference as f64).abs()>0.001_f64 {1./difference} else {0.};
    let weight=(normalized_age*inverse+pair.x).clamp(0.,1.);
    Ok(position+(current-previous)*weight)
}
pub fn local_position(position:Vec3,normalized_age:f32,enabled:bool,initial_inverse:Mat4,current:Mat4)->Result<Vec3,&'static str> {
    if !position.is_finite() || !normalized_age.is_finite() || !initial_inverse.is_finite() || !current.is_finite() {return Err("nonfinite local orientation");}
    if !enabled || normalized_age>=1. {return Ok(position);}
    let value=(current*initial_inverse)*position.extend(1.);
    if !value.is_finite() || value.w==0. {return Err("invalid native homogeneous position");}
    Ok(value.truncate()*(1./value.w))
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matrices_bind_and_local_positions_match_original_consumers() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_attachment_contract.json")).unwrap();
        assert_eq!(proof["cases"].as_array().unwrap().len(),112);
        for c in proof["cases"].as_array().unwrap() {
            let values=|key:&str|c[key].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect::<Vec<_>>();
            let matrix=|key:&str|Mat4::from_cols_array(&values(key).try_into().unwrap());
            let current=emitter_matrix(c["emitter_local"]==1,matrix("system_matrix"),Vec3::new(110.,220.,330.)).unwrap();
            assert_eq!(current,matrix("current"));
            let pair=Vec2::from_slice(&values("pair"));
            let before=values("before");let bound=values("after_bind");let oriented=values("after_local");
            for (i,age) in values("ages").iter().enumerate() {
                let p=Vec3::from_slice(&before[i*3..i*3+3]);
                let got=bind_position(p,*age,pair,c["stick"]==1,Vec3::new(100.,200.,300.),Vec3::new(110.,220.,330.)).unwrap();
                assert_eq!(got,Vec3::from_slice(&bound[i*3..i*3+3]),"bind {c} age {age}");
                let got=local_position(got,*age,c["particle_local"]==1,matrix("inverse"),current).unwrap();
                assert_eq!(got,Vec3::from_slice(&oriented[i*3..i*3+3]),"local {c} age {age}");
            }
        }
    }
}
