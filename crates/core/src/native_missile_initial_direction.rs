//! Native75FB00 initial direction, fixed travel and zero-acceleration1400 profile.
use crate::native_particle_force_body::inverse_estimate;
#[derive(Debug)]
pub struct Initial {pub direction:[f32;3],pub travel_time:f32}
fn inverse(v:f32)->Result<f32,&'static str> {let e=inverse_estimate(v)?;Ok((3.-((e*v)*e))*(e*0.5))}
fn square_root(v:f32)->Result<f32,&'static str> {Ok(if v==0. {0.}else{inverse(v)?*v})}
fn bit_root(v:f32)->f32 {f32::from_bits(((v.to_bits() as i32>>1).wrapping_add(0x1fc00000)) as u32)}
/// Profile matches speed/min/max1400 and acceleration0; other profiles need qualification.
/// The sampled current position equals launch origin, used by native75FF20.
pub fn speed1400(origin:[f32;3],target:[f32;3],height:f32,fixed_time:f32,min_time:f32,previous_time:f32)->Result<Initial,&'static str> {
 if !origin.into_iter().chain(target).chain([height,fixed_time,min_time,previous_time]).all(f32::is_finite) || fixed_time<0. || min_time<0. {return Err("unqualified missile initial profile");}
 let delta=std::array::from_fn::<_,3,_>(|i|target[i]-origin[i]);
 let horizontal=delta[0]*delta[0]+delta[2]*delta[2];
 let mut direction=[delta[0],delta[1]+height,delta[2]];
 let squared=(direction[0]*direction[0]+direction[1]*direction[1])+direction[2]*direction[2];
 if !squared.is_finite() || !horizontal.is_finite() {return Err("missile initial arithmetic overflow");}
 if squared>1e-9 {let scale=inverse(squared)?;direction=direction.map(|v|v*scale);}
 if fixed_time<=0. {
    // Whole75FF20 uses integer-bit square-root estimates, not5FA7C0.
    let negative_distance=f32::from_bits(bit_root(horizontal).to_bits()^0x80000000);
    let speed=1400f32;
    let discriminant=speed*speed-((0f32*4.)*negative_distance);
    let root=((speed/speed.abs())*bit_root(discriminant)+speed)*-0.5;
    let time=if root!=0. {(negative_distance/root).max(0.)}else{0.};
    if min_time<=time {
        let factor=if direction[1]==0. {speed}else {
            let xz=direction[0]*direction[0]+direction[2]*direction[2];
            if xz!=0. {inverse(xz)?*speed}else{speed}
        };
        return Ok(Initial {direction:direction.map(|v|v*factor),travel_time:previous_time});
    }
 }
 let travel_time=if fixed_time>min_time {fixed_time}else{min_time};
 let factor=square_root(horizontal)?/travel_time;
 Ok(Initial {direction:direction.map(|v|v*factor),travel_time})
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn initial_fixed_and_speed_branches_match144_original_executions() {
  let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/missile_initial_direction_speed_contract.json")).unwrap();
  assert_eq!(p["cases"].as_array().unwrap().len(),144);assert_eq!(p["actual_cpu_rsqrt_operations"],278);
  for (n,c) in p["cases"].as_array().unwrap().iter().enumerate() {
    let v=|key:&str|std::array::from_fn(|i|c[key][i].as_f64().unwrap() as f32);let f=|key:&str|c[key].as_f64().unwrap() as f32;
    let a=speed1400(v("origin"),v("target"),f("height"),f("first_time"),f("second_time"),f("previous_travel_time")).unwrap();
    for (i,d) in a.direction.iter().enumerate(){assert_eq!(d.to_bits(),c["direction_words"][i].as_u64().unwrap() as u32,"case{n} axis{i}");}
    assert_eq!(a.travel_time.to_bits(),c["travel_time_word"].as_u64().unwrap() as u32,"case{n} time");
  }
 }
}

