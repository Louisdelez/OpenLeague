//!941F00 rotation-list sampling, gates, matrices and local vector transforms.
use crate::{native_probability_curve::{ProbabilityCurve,apply_probability},native_random::Rng55};
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub struct Angle {pub bits:u32,pub matrix_needed:bool}
/// Native inclusive gates run both before and after probability. Near-zero raw
/// angles must not consume a probability draw. Selected finite inputs qualified.
pub fn evaluate_angle(raw:u32,curve:Option<&ProbabilityCurve>,rng:&mut Rng55)->Result<Angle,&'static str> {
    let value=f32::from_bits(raw);
    if !value.is_finite(){return Err("unqualified nonfinite rotation-list angle");}
    let epsilon=f32::from_bits(0x358637bd);
    if (-epsilon..=epsilon).contains(&value){return Ok(Angle {bits:raw,matrix_needed:false});}
    let mut next=rng.clone();
    let weighted=apply_probability(curve,value,&mut next);
    if !weighted.is_finite(){return Err("unqualified nonfinite weighted rotation-list angle");}
    *rng=next;
    Ok(Angle {bits:weighted.to_bits(),matrix_needed:!(-epsilon..=epsilon).contains(&weighted)})
}
/// Whole8E03F0 finite axis-angle branch. Preserve negative angle, native CRT
/// remainder and asymmetric pi boundaries before the original polynomial trig.
/// Authored axes are used directly; the native routine does not normalize them.
pub fn axis_angle(angle:u32,axis:[u32;3])->Result<[u32;16],&'static str> {
    let angle=f32::from_bits(angle);let [x,y,z]=axis.map(f32::from_bits);
    if !angle.is_finite() || ![x,y,z].iter().all(|v|v.is_finite()){return Err("unqualified nonfinite rotation matrix source");}
    let tau=f32::from_bits(0x40c90fdb);let pi=f32::from_bits(0x40490fdb);
    let extended=-(angle as f64) % (tau as f64);
    let mut reduced=extended as f32;
    if extended>pi as f64 {reduced-=tau;} else if reduced<=-pi {reduced+=tau;}
    let c=crate::camera_angles::cosine(reduced);let s=crate::camera_angles::sine(reduced);
    let t=1.-c;let xy=(y*x)*t;let zx=(z*x)*t;let yz=(z*y)*t;
    let zs=z*s;let ys=y*s;let xs=x*s;
    let matrix=[(x*x)*t+c,xy-zs,ys+zx,0.,zs+xy,(y*y)*t+c,yz-xs,0.,zx-ys,xs+yz,(z*z)*t+c,0.,0.,0.,0.,1.];
    if !matrix.iter().all(|v|v.is_finite()){return Err("unqualified nonfinite rotation matrix output");}
    Ok(matrix.map(f32::to_bits))
}
pub struct Element<'a> {pub angle:u32,pub axis:[u32;3],pub probability:Option<&'a ProbabilityCurve>}
pub struct Source<'a> {pub table:&'a [f32],pub axis:[u32;3],pub probability:Option<&'a ProbabilityCurve>}
///942320..942370 raw list sampling consumes no probability draw. Host Vec owns
/// logical storage; the original allocator/free backend is not substituted here.
pub fn sample<'a>(sources:&[Source<'a>],progress:f32)->Result<Vec<Element<'a>>,&'static str> {
    sources.iter().map(|s|Ok(Element {angle:crate::native_simple_birth_parameters::sample(s.table,progress)?,axis:s.axis,probability:s.probability})).collect()
}
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub struct Rotation {pub matrix:[u32;16],pub unchanged:bool}
impl Rotation {
    ///942E29..943031: projective position transform and linear velocity transform.
    /// The native unchanged flag skips arithmetic, preserving original raw words.
    pub fn apply(&self,position:[u32;3],velocity:[u32;3])->Result<([u32;3],[u32;3]),&'static str> {
        if !position.iter().chain(&velocity).chain(&self.matrix).all(|v|f32::from_bits(*v).is_finite()){return Err("unqualified nonfinite rotation transform input");}
        if self.unchanged{return Ok((position,velocity));}
        let matrix=self.matrix.map(f32::from_bits);let p=position.map(f32::from_bits);let v=velocity.map(f32::from_bits);
        let w=((p[1]*matrix[7]+p[0]*matrix[3])+p[2]*matrix[11])+matrix[15];let inverse=1./w;
        let position=std::array::from_fn::<_,3,_>(|j|((((p[0]*matrix[j]+p[1]*matrix[4+j])+p[2]*matrix[8+j])+matrix[12+j])*inverse).to_bits());
        let velocity=std::array::from_fn::<_,3,_>(|j|((v[0]*matrix[j]+v[1]*matrix[4+j])+v[2]*matrix[8+j]).to_bits());
        if !position.iter().chain(&velocity).all(|v|f32::from_bits(*v).is_finite()){return Err("unqualified nonfinite rotation transform output");}
        Ok((position,velocity))
    }
}
///8DF790 row-major multiplication; each multiply/add is a separate f32 step.
fn multiply(left:[u32;16],right:[u32;16])->[u32;16] {
    let left=left.map(f32::from_bits);let right=right.map(f32::from_bits);
    std::array::from_fn(|i| {
        let row=(i/4)*4;let col=i%4;
        let mut v=right[col]*left[row];v+=right[4+col]*left[row+1];v+=right[8+col]*left[row+2];v+=right[12+col]*left[row+3];v.to_bits()
    })
}
///942C5D..942E21: evaluate pre-sampled lists in authored order using shared RNG.
/// Raw list resource sampling and position/velocity transforms are separate stages.
pub fn evaluate(elements:&[Element<'_>],rng:&mut Rng55)->Result<Rotation,&'static str> {
    let mut result=Rotation {matrix:std::array::from_fn(|i|if [0,5,10,15].contains(&i){1f32.to_bits()}else{0}),unchanged:true};
    let mut next=rng.clone();
    for element in elements {
        let angle=evaluate_angle(element.angle,element.probability,&mut next)?;
        if angle.matrix_needed {
            let radians=f32::from_bits(angle.bits)*f32::from_bits(0x3c8efa35);
            result.matrix=multiply(result.matrix,axis_angle(radians.to_bits(),element.axis)?);
            result.unchanged=false;
        }
    }
    if !result.matrix.iter().all(|v|f32::from_bits(*v).is_finite()){return Err("unqualified nonfinite composed rotation");}
    *rng=next;Ok(result)
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn native_angle_gates_probability_and_full_rng_match_180_cases() {
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_rotation_gate_contract.json")).unwrap();
  let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),180);assert_eq!(p["adapters"],serde_json::json!([]));
  for row in rows {
   let mode=row["mode"].as_u64().unwrap();
   let curve=ProbabilityCurve {present:mode!=0,constant:mode==1||mode==2,constant_value:if mode==1 {0.5}else{0.},fast:mode==3,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
   let mut rng=Rng55 {words:std::array::from_fn(|i|row["rng"][i].as_u64().unwrap() as u32),first:0,second:0};
   let result=evaluate_angle(row["angle"].as_u64().unwrap() as u32,if mode==0 {None}else{Some(&curve)},&mut rng).unwrap();
   let expected=&row["cpu"];
   assert_eq!(result.bits,expected["angle"].as_u64().unwrap() as u32,"{row}");
   assert_eq!(result.matrix_needed,expected["matrix_needed"].as_bool().unwrap(),"{row}");
   assert_eq!(rng.first,expected["first"].as_u64().unwrap() as u32);assert_eq!(rng.second,expected["second"].as_u64().unwrap() as u32);
   for i in 0..55 {assert_eq!(rng.words[i],expected["rng"][i].as_u64().unwrap() as u32,"word {i}, {row}");}
  }
 }
 #[test]
 fn native_axis_angle_matrix_matches_105_whole_original_cases() {
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_rotation_matrix_contract.json")).unwrap();
  let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),105);assert_eq!(p["adapters"],serde_json::json!([]));
  for row in rows {
   let axis=std::array::from_fn(|i|row["axis"][i].as_u64().unwrap() as u32);
   let matrix=axis_angle(row["angle"].as_u64().unwrap() as u32,axis).unwrap();
   for i in 0..16 {assert_eq!(matrix[i],row["cpu"]["matrix"][i].as_u64().unwrap() as u32,"matrix word {i}, {row}");}
  }
 }
 #[test]
 fn native_rotation_list_composition_and_rng_match_100_sequences() {
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_rotation_composition_contract.json")).unwrap();
  let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),100);assert_eq!(p["adapters"],serde_json::json!([]));
  for row in rows {
   let mode=row["mode"].as_u64().unwrap();
   let curve=ProbabilityCurve {present:mode!=0,constant:mode==1||mode==2,constant_value:if mode==1 {0.5}else{0.},fast:mode==3,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
   let elements:Vec<_>=row["angles"].as_array().unwrap().iter().enumerate().map(|(i,a)|Element {angle:a.as_u64().unwrap() as u32,axis:std::array::from_fn(|j|row["axes"][i][j].as_u64().unwrap() as u32),probability:if mode==0 {None}else{Some(&curve)}}).collect();
   let mut rng=Rng55 {words:std::array::from_fn(|i|row["rng"][i].as_u64().unwrap() as u32),first:0,second:0};
   let result=evaluate(&elements,&mut rng).unwrap();let expected=&row["cpu"];
   assert_eq!(result.unchanged,expected["unchanged"].as_bool().unwrap(),"{row}");
   for i in 0..16 {assert_eq!(result.matrix[i],expected["matrix"][i].as_u64().unwrap() as u32,"matrix word {i}, {row}");}
   assert_eq!(rng.first,expected["first"].as_u64().unwrap() as u32);assert_eq!(rng.second,expected["second"].as_u64().unwrap() as u32);
   for i in 0..55 {assert_eq!(rng.words[i],expected["rng"][i].as_u64().unwrap() as u32,"rng word {i}, {row}");}
  }
 }
 #[test]
 fn native_rotation_transforms_match_100_complete_list_sequences() {
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/simple_rotation_transform_contract.json")).unwrap();
  let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),100);
  for row in rows {
   let mode=row["mode"].as_u64().unwrap();let curve=ProbabilityCurve {present:mode!=0,constant:mode==1||mode==2,constant_value:if mode==1 {0.5}else{0.},fast:mode==3,begin:0.25,difference:1.5,times:vec![0.,0.5,1.],values:vec![1.,0.5,2.]};
   let elements:Vec<_>=row["angles"].as_array().unwrap().iter().enumerate().map(|(i,a)|Element {angle:a.as_u64().unwrap() as u32,axis:std::array::from_fn(|j|row["axes"][i][j].as_u64().unwrap() as u32),probability:if mode==0 {None}else{Some(&curve)}}).collect();
   let mut rng=Rng55 {words:std::array::from_fn(|i|row["rng"][i].as_u64().unwrap() as u32),first:0,second:0};
   let rotation=evaluate(&elements,&mut rng).unwrap();let input=|key:&str|std::array::from_fn(|i|row[key][i].as_u64().unwrap() as u32);
   let (position,velocity)=rotation.apply(input("position"),input("velocity")).unwrap();
   for (actual,key) in [(position,"position"),(velocity,"velocity")] {for i in 0..3 {assert_eq!(actual[i],row["cpu"][key][i].as_u64().unwrap() as u32,"{key} word {i}, {row}");}}
  }
 }
}
