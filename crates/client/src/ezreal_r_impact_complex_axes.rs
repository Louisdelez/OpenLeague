//! 937120 vector preparation then923450/DL=true. Static instruction-derived
//! contract; projected inverse square-root uses an explicitly LOCAL scalar sqrt.
//! No claim of RSQRTSS/x87 bit parity. Camera/source/factory remain caller inputs.
pub(crate) fn packet_vector(raw:[f32;3])->Result<[f32;3],&'static str>{
 if raw.iter().any(|v|!v.is_finite()){return Err("Complex vector nonfinite");}
 let squared=(raw[0]*raw[0]+raw[1]*raw[1])+raw[2]*raw[2];
 if !squared.is_finite(){return Err("Complex vector squared overflow");}
 let seed=0x5f3759dfi32.wrapping_sub((squared.to_bits() as i32)>>1);
 let q=f32::from_bits(seed as u32);
 let inverse=(1.5-((squared*0.5)*q)*q)*q;
 let length=1./inverse;
 if !inverse.is_finite() || !length.is_finite(){return Err("Complex vector normalization overflow");}
 let out=if length>f32::from_bits(0x3089705f){raw.map(|v|v*inverse)}else{raw};
 if out.iter().any(|v|!v.is_finite()){return Err("Complex packet vector overflow");}Ok(out)
}
pub(crate) fn aligned(view:[f32;16],raw:[f32;3])->Result<([f32;3],[f32;3]),&'static str>{
 if view.iter().any(|v|!v.is_finite()){return Err("Complex camera nonfinite");}
 let vector=packet_vector(raw)?;let normal=[view[2],view[6],view[10]];
 let dot=(normal[0]*vector[0]+normal[1]*vector[1])+normal[2]*vector[2];
 let mut a=std::array::from_fn::<_,3,_>(|i|vector[i]-normal[i]*dot);
 let squared=(a[0]*a[0]+a[1]*a[1])+a[2]*a[2];
 if !squared.is_finite(){return Err("Complex projected vector overflow");}
 if squared>f32::from_bits(0x3089705f){
  let inverse=1./squared.sqrt();
  // Original returns storedf32 inverse then x87 multiplication of twof32s.
  for value in &mut a{*value=(f64::from(*value)*f64::from(inverse)) as f32;}
 }
 let b=[normal[2]*a[1]-normal[1]*a[2],normal[0]*a[2]-normal[2]*a[0],normal[1]*a[0]-normal[0]*a[1]];
 if a.iter().chain(&b).any(|v|!v.is_finite()){return Err("Complex aligned axes overflow");}Ok((a,b))
}
#[cfg(test)]
mod tests {
 use super::*;
 fn view()->[f32;16]{std::array::from_fn(|i|if [0,5,10,15].contains(&i){1.}else{0.})}
 #[test] fn packet_preparation_precedes_projection_for_tiny_motion(){
  let raw=[0.000001,0.,0.];assert!(raw[0]*raw[0]<f32::from_bits(0x3089705f));
  let packet=packet_vector(raw).unwrap();assert!(packet[0]>0.99);
  let (a,b)=aligned(view(),raw).unwrap();assert!((a[0]-1.).abs()<0.00001);assert_eq!(a[1..],[0.,0.]);
  assert!((b[1]+1.).abs()<0.00001);
 }
 #[test] fn projected_axes_keep_cross_orientation_and_ignore_parallel_component(){
  let (a,b)=aligned(view(),[3.,4.,12.]).unwrap();
  for (x,y) in a.into_iter().zip([0.6,0.8,0.]){assert!((x-y).abs()<0.00001);}
  for (x,y) in b.into_iter().zip([0.8,-0.6,0.]){assert!((x-y).abs()<0.00001);}
 }
 #[test] fn degenerate_motion_keeps_zero_without_substitute_axis(){
  for v in [[0.;3],[0.,0.,10.]] {let (a,b)=aligned(view(),v).unwrap();assert_eq!(a,[0.;3]);assert_eq!(b,[0.;3]);}
  let mut v=view();v[2]=0.;v[6]=1.;v[10]=0.;let (a,b)=aligned(v,[0.,0.,2.]).unwrap();
  assert!((a[2]-1.).abs()<0.00001);assert!((b[0]+1.).abs()<0.00001);
 }
 #[test] fn invalid_and_overflowing_vectors_do_not_create_geometry(){
  for v in [[f32::NAN,0.,0.],[f32::INFINITY,0.,0.],[f32::MAX,0.,0.]]{assert!(aligned(view(),v).is_err());}
  let mut v=view();v[0]=f32::NAN;assert!(aligned(v,[1.,0.,0.]).is_err());
 }
}
