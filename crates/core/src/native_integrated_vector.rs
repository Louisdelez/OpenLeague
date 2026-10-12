//! Original94D6B0 integration flags1/2. Native field units/call sites are separate.
use crate::native_vector_curve::{Error,VectorKnots};
#[derive(Debug,Copy,Clone)]
pub enum IntegrationMode {Once,Twice}
fn quadratic(q:f32,l:f32,c:f32,t:f32)->f32 {
    let first=q*t;let second=first+l;let third=second*t;third+c
}
fn cubic(a:f32,b:f32,c:f32,d:f32,t:f32)->f32 {
    let first=a*t;let second=first+b;let third=second*t;let fourth=third+c;let fifth=fourth*t;fifth+d
}
pub fn bake(times:&[f32],values:&[[f32;3]],count:u32,mode:IntegrationMode)->Result<Vec<[f32;3]>,Error> {
    // Validate the qualified finite/sorted domain; never silently reorder keys.
    VectorKnots::new(times.to_vec(),values.to_vec())?;
    let (times,values)=if times.len()==1 {(vec![0.,1.],vec![values[0];2])} else {(times.to_vec(),values.to_vec())};
    let mut first:Vec<[[f32;3];3]>=Vec::with_capacity(times.len());
    let mut second:Vec<[[f32;4];3]>=Vec::with_capacity(times.len());
    let mut running=[0.;3];let mut running_twice=[0.;3];
    for index in 0..times.len() {
        let t0=times[index];let t1=times.get(index+1).copied().unwrap_or_else(||times[index]+1.);
        let v0=values[index];let v1=values.get(index+1).copied().unwrap_or(v0);
        let width=t1-t0;let padded=width+f32::from_bits(0x3727c5ac);let inverse=1./padded;
        let mut segment=[[0.;3];3];let mut segment_twice=[[0.;4];3];
        for axis in 0..3 {
            let span=v1[axis]-v0[axis];let slope=span*inverse;let q=slope*0.5;
            let lower=v0[axis]*t1;let upper=v1[axis]*t0;let intercept=lower-upper;let l=intercept*inverse;
            let start=(q*t0+l)*t0;let c=running[axis]-start;
            running[axis]=quadratic(q,l,c,t1);segment[axis]=[q,l,c];
            let a=q*f32::from_bits(0x3eaaaaab);let b=l*0.5;
            let start_twice=((a*t0+b)*t0+c)*t0;let d=running_twice[axis]-start_twice;
            running_twice[axis]=cubic(a,b,c,d,t1);segment_twice[axis]=[a,b,c,d];
        }
        first.push(segment);second.push(segment_twice);
    }
    Ok((0..count).map(|index| {
        // Original integrated branch retains x87 reciprocal until f32 time store.
        // f64 ratio matches captured count0/1/3/7/16/256/513 fixtures.
        let t=(index as f64/count as f64) as f32;
        let segment=times.partition_point(|v|*v<t).saturating_sub(1);
        std::array::from_fn(|axis|match mode {
            IntegrationMode::Once=>{let [q,l,c]=first[segment][axis];quadratic(q,l,c,t)},
            IntegrationMode::Twice=>{let [a,b,c,d]=second[segment][axis];cubic(a,b,c,d,t)},
        })
    }).collect())
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn first_and_second_integral_tables_match_original_sse_bits() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/vector_rotation_bake_contract.json")).unwrap();
        for row in data["cases"].as_array().unwrap() {
            let times:Vec<f32>=row["times"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32).collect();
            let values:Vec<[f32;3]>=row["values"].as_array().unwrap().iter().map(|v|std::array::from_fn(|axis|v[axis].as_f64().unwrap() as f32)).collect();
            let mode=if row["mode"].as_u64().unwrap()==1 {IntegrationMode::Once} else {IntegrationMode::Twice};
            let actual=bake(&times,&values,row["requested_count"].as_u64().unwrap() as u32,mode).unwrap();
            let expected:Vec<u32>=row["output_bits"].as_array().unwrap().iter().map(|v|u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()).collect();
            assert_eq!(actual.len(),row["actual_count"].as_u64().unwrap() as usize);
            assert_eq!(actual.iter().flatten().map(|v|v.to_bits()).collect::<Vec<_>>(),expected,"{} mode{} count{}",row["name"],row["mode"],row["requested_count"]);
        }
    }
}
