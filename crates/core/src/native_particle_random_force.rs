//! Whole93C450. RNG state shared explicitly; x8764 rounding reproduced for norm.
use crate::native_random::Rng55;
pub struct Input {pub count:u32,pub center:[u32;3],pub radius:u32,pub strength:u32,pub scales:[u32;3]}
fn round_integer(n:u128,precision:u32)->u128 {
    let shift=(128-n.leading_zeros()).saturating_sub(precision);if shift==0{return n;}
    let high=n>>shift;let remainder=n&((1u128<<shift)-1);let halfway=1u128<<(shift-1);
    (high+u128::from(remainder>halfway || (remainder==halfway && high&1!=0)))<<shift
}
pub fn update(input:&Input,position:[u32;3],velocity:&mut [u32;3],rng:&mut Rng55)->Result<(),&'static str> {
    if input.count==0 {return Ok(());}
    if input.count>100000 {return Err("unqualified excessive random force iterations");}
    let finite=|x:u32|f32::from_bits(x).is_finite();
    if !input.center.into_iter().chain(position).chain(*velocity).chain(input.scales).chain([input.radius,input.strength]).all(finite){return Err("unqualified nonfinite random force fields");}
    let d:[f32;3]=std::array::from_fn(|j|f32::from_bits(input.center[j])-f32::from_bits(position[j]));let radius=f32::from_bits(input.radius);
    if !(radius*radius>=(d[0]*d[0]+d[1]*d[1])+d[2]*d[2]){return Ok(());}
    for _ in 0..input.count {
        let raw=[rng.bounded(u32::MAX),rng.bounded(u32::MAX),rng.bounded(u32::MAX)];
        let n:[i64;3]=std::array::from_fn(|j|2*i64::from(raw[2-j])-(1i64<<32));
        let squared=n.map(|x|u128::from(x.unsigned_abs()).pow(2));
        // Original extended stack sums X²+Y² first, then Z², each rounded
        // to its64bit significand before the final binary32 FSTP.
        let total=round_integer(round_integer(squared[0]+squared[1],64)+squared[2],64);
        let sum=(round_integer(total,24) as f64/18446744073709551616.0) as f32;
        let estimate=crate::native_particle_force_body::inverse_estimate(sum)?;
        let length=if sum==0. {0.}else{((3.-((estimate*sum)*estimate))*(estimate*0.5))*sum};
        let mut direction=n.map(|x|(x as f64/4294967296.0) as f32);
        if length!=0. {let inverse=1./length;for component in &mut direction {*component*=inverse;}}
        for j in 0..3 {
            let scaled=direction[j]*f32::from_bits(input.strength);let impulse=if j==0 {scaled*f32::from_bits(input.scales[j])}else{f32::from_bits(input.scales[j])*scaled};
            velocity[j]=(f32::from_bits(velocity[j])+impulse).to_bits();
        }
    }
    Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::Value;
    fn words<const N:usize>(v:&Value)->[u32;N]{std::array::from_fn(|j|v[j].as_u64().unwrap() as u32)}
    #[test]
    fn random_force_matches864_native_cpu_cases_and_shared_rng_state() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/particle_random_force_contract.json")).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),864);
        for (i,r) in rows.iter().enumerate() {
            let n=|k:&str|r[k].as_u64().unwrap() as u32;let mut rng=Rng55 {words:words(&r["rng"]),first:0,second:0};let mut velocity=words(&r["velocity"]);
            update(&Input {count:n("count"),center:words(&r["center"]),radius:n("radius"),strength:n("strength"),scales:words(&r["scales"])},words(&r["position"]),&mut velocity,&mut rng).unwrap();let e=&r["cpu"];
            assert_eq!(velocity,words(&e["velocity"]),"velocity case{i}");assert_eq!(rng.words,words(&e["rng"]),"rng case{i}");assert_eq!(rng.first,e["first"].as_u64().unwrap() as u32);assert_eq!(rng.second,e["second"].as_u64().unwrap() as u32);assert_eq!(words::<3>(&r["position"]),words(&e["position"]));
        }
    }
}
