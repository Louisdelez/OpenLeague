//! Native75F130 unobstructed zero-gravity/zero-acceleration1400 motion profile.
use crate::native_particle_force_body::inverse_estimate;
#[derive(Debug)]
pub struct Motion {pub direction:[f32;3],pub moving_position:[f32;3],pub target:[f32;3]}
fn inverse(v:f32)->Result<f32,&'static str>{let e=inverse_estimate(v)?;Ok((3.-((e*v)*e))*(e*0.5))}
/// Corresponds to zero travel time, speed/min/max1400, height100 and unobstructed terrain.
/// Target lifecycle, obstruction and end crossing remain caller obligations.
pub fn unobstructed1400(origin:[f32;3],fallback:[f32;3],target:Option<[f32;3]>,dt:f32)->Result<Motion,&'static str>{
 let target=target.unwrap_or(fallback);
 if !origin.into_iter().chain(target).chain([dt]).all(f32::is_finite) || dt<0. {return Err("unqualified missile motion input");}
 let mut direction=[target[0]-origin[0],(target[1]-origin[1])+100.,target[2]-origin[2]];
 let squared=(direction[1]*direction[1]+direction[0]*direction[0])+direction[2]*direction[2];
 if !squared.is_finite(){return Err("missile motion overflow");}
 if squared>1e-9 {let scale=inverse(squared)?;direction=direction.map(|v|v*scale);}
 let factor=if direction[1]==0. {1400.}else{let h=direction[0]*direction[0]+direction[2]*direction[2];if h!=0.{inverse(h)?*1400.}else{1400.}};
 direction=direction.map(|v|v*factor);
 let moving_position=std::array::from_fn(|i|origin[i]+direction[i]*dt);
 Ok(Motion {direction,moving_position,target})
}
/// Native75F840 horizontal crossing plane; does not execute the impact callback.
pub fn crossed(direction:[f32;3],next:[f32;3],target:[f32;3],radius:f32)->Result<bool,&'static str>{
 if !direction.into_iter().chain(next).chain(target).chain([radius]).all(f32::is_finite){return Err("unqualified crossing input");}
 let squared=direction[2]*direction[2]+direction[0]*direction[0];
 if !squared.is_finite(){return Err("crossing arithmetic overflow");}
 let (x,z)=if squared>1e-9 {let scale=inverse(squared)?;(direction[0]*scale,direction[2]*scale)}else{(direction[0],direction[2])};
 let target_dot=(target[1]*0.+target[0]*x)+target[2]*z;
 let next_dot=(next[1]*0.+next[0]*x)+next[2]*z;
 let negative=f32::from_bits(target_dot.to_bits()^0x80000000);
 Ok((next_dot+negative)+radius>=0.)
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn matches72_original_motion_executions(){
 let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/missile_motion_contract.json")).unwrap();
 assert_eq!(p["cases"].as_array().unwrap().len(),72);
 for(n,c) in p["cases"].as_array().unwrap().iter().enumerate(){
 let v=|k:&str|std::array::from_fn(|i|c[k][i].as_f64().unwrap() as f32);
 let a=unobstructed1400(v("origin"),v("destination"),c["live_target"].as_bool().unwrap().then(||v("target_position")),c["dt"].as_f64().unwrap() as f32).unwrap();
 for(k,values) in [("direction_words",a.direction),("moving_position_words",a.moving_position),("target_words",a.target)]{for i in 0..3{assert_eq!(values[i].to_bits(),c[k][i].as_u64().unwrap() as u32,"case{n} {k} axis{i}");}}
 }
 }
 #[test]
 fn matches48_original_moving_target_sequences(){
 let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/missile_motion_sequences_contract.json")).unwrap();
 assert_eq!(p["sequences"].as_array().unwrap().len(),48);
 for(n,c) in p["sequences"].as_array().unwrap().iter().enumerate(){
 let v=|c:&serde_json::Value,k:&str|std::array::from_fn(|i|c[k][i].as_f64().unwrap() as f32);
 let mut origin=v(c,"origin");let mut fallback=v(c,"destination");
 for(j,f) in c["frames"].as_array().unwrap().iter().enumerate(){
 let a=unobstructed1400(origin,fallback,f["live_target"].as_bool().unwrap().then(||v(f,"target_position")),c["dt"].as_f64().unwrap() as f32).unwrap();
 for(k,values) in [("direction_words",a.direction),("moving_position_words",a.moving_position),("target_words",a.target)]{for i in 0..3{assert_eq!(values[i].to_bits(),f[k][i].as_u64().unwrap() as u32,"sequence{n} frame{j} {k} axis{i}");}}
 origin=a.moving_position;fallback=a.target;
 }
 }
 }
 #[test]
 fn matches144_original_crossing_planes(){
 let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/missile_end_crossing_contract.json")).unwrap();
 assert_eq!(p["cases"].as_array().unwrap().len(),144);
 for(n,c) in p["cases"].as_array().unwrap().iter().enumerate(){let v=|k:&str|std::array::from_fn(|i|c[k][i].as_f64().unwrap() as f32);
 assert_eq!(crossed(v("direction"),v("next_position"),v("target_position"),c["radius"].as_f64().unwrap() as f32).unwrap(),c["crossed"].as_bool().unwrap(),"case{n}");}
 }

}
