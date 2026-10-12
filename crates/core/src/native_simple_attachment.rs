//! Native944600 bind and944760 local-orient consumers. Owner poses are explicit.
pub fn bind(begin:u32,end:u32,sticky:u8,previous:[u32;3],current:[u32;3],ages:&[u32],positions:&mut [[u32;3]])->Result<(),&'static str> {
    let begin=f32::from_bits(begin);let end=f32::from_bits(end);
    if !(begin>0. || end>0. || sticky!=0){return Ok(());}
    if ages.len()!=positions.len(){return Err("mismatched native attachment arrays");}
    if !begin.is_finite() || !end.is_finite() || !previous.iter().chain(&current).all(|v|f32::from_bits(*v).is_finite()){return Err("unqualified native attachment pose/range");}
    let difference=end as f64-begin as f64;let inverse=if difference.abs()>0.001 {1./difference as f32}else{0.};
    let delta:[f32;3]=std::array::from_fn(|j|f32::from_bits(current[j])-f32::from_bits(previous[j]));let mut next=positions.to_vec();
    for (age,p) in ages.iter().zip(&mut next) {
        let age=f32::from_bits(*age);if !(1.>age){continue;}
        if sticky!=0{*p=current;continue;}
        if !(age>f32::from_bits(981668463)){continue;}
        if !p.iter().all(|v|f32::from_bits(*v).is_finite()){return Err("unqualified native attachment position");}
        let raw=age*inverse+begin;let weight=if 0.>raw{0.}else if raw>1.{1.}else{raw};
        for j in 0..3 {p[j]=(delta[j]*weight+f32::from_bits(p[j])).to_bits();}
    }
    positions.copy_from_slice(&next);Ok(())
}
pub fn local(enabled:u8,initial_inverse:&[u32;16],current:&[u32;16],ages:&[u32],positions:&mut [[u32;3]])->Result<(),&'static str> {
    if enabled==0{return Ok(());}
    if ages.len()!=positions.len(){return Err("mismatched native local orientation arrays");}
    if !initial_inverse.iter().chain(current).all(|v|f32::from_bits(*v).is_finite()){return Err("unqualified native local orientation matrix");}
    //8DF790 multiplies raw native rows: initial inverse followed by current.
    let matrix=crate::camera_view::multiply(&initial_inverse.map(f32::from_bits),&current.map(f32::from_bits));let mut next=positions.to_vec();
    for (age,p) in ages.iter().zip(&mut next) {
        if !(1.>f32::from_bits(*age)){continue;}
        let [x,y,z]=p.map(f32::from_bits);
        if ![x,y,z].iter().all(|v|v.is_finite()){return Err("unqualified native local position");}
        let w=((matrix[7]*y+matrix[3]*x)+matrix[11]*z)+matrix[15];
        if w==0. || !w.is_finite(){return Err("unqualified native homogeneous denominator");}
        let inverse=1./w;
        for j in 0..3 {p[j]=((((y*matrix[4+j]+x*matrix[j])+z*matrix[8+j])+matrix[12+j])*inverse).to_bits();}
    }
    positions.copy_from_slice(&next);Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::Value;
    fn words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|v|(v.as_f64().unwrap() as f32).to_bits()).collect()}
    fn triples(v:&Value)->Vec<[u32;3]>{words(v).chunks_exact(3).map(|v|v.try_into().unwrap()).collect()}
    fn fixture()->Value{serde_json::from_str(include_str!("../../../data/4.20/simple_attachment_cpu_contract.json")).unwrap()}
    #[test]
    fn bind_matches112_original_cpu_cases() {
        let p=fixture();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),112);assert!(p["adapters"].as_array().unwrap().is_empty());
        for (i,row) in rows.iter().enumerate() {
            let r=&row["cpu"];let pair=words(&r["pair"]);let mut positions=triples(&r["before"]);
            bind(pair[0],pair[1],r["stick"].as_u64().unwrap() as u8,[100f32.to_bits(),200f32.to_bits(),300f32.to_bits()],words(&r["current_position"]).try_into().unwrap(),&words(&r["ages"]),&mut positions).unwrap();assert_eq!(positions,triples(&r["after_bind"]),"case{i}");
        }
    }
    #[test]
    fn local_orientation_matches112_original_cpu_cases() {
        let p=fixture();for (i,row) in p["cases"].as_array().unwrap().iter().enumerate() {
            let r=&row["cpu"];let mut positions=triples(&r["after_bind"]);
            local(r["particle_local"].as_u64().unwrap() as u8,&words(&r["inverse"]).try_into().unwrap(),&words(&r["current"]).try_into().unwrap(),&words(&r["ages"]),&mut positions).unwrap();assert_eq!(positions,triples(&r["after_local"]),"case{i}");
        }
    }
}
