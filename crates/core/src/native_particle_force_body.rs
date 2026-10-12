//! Whole93BDD0 arithmetic and order; child93C450/93C900 remain backend obligations.
#[derive(Clone,Copy)]
pub struct Sphere {pub position:[u32;3],pub radius:u32,pub strength:u32}
pub struct Input<'a> {pub acceleration:Option<[u32;3]>,pub points:&'a [Sphere],pub dampings:&'a [Sphere],pub children:&'a [u32],pub final_children:&'a [u32],pub delta:u32}
pub trait Backend {
    fn child450(&mut self,resource:u32,position:&mut [u32;3],velocity:&mut [u32;3]);
    fn child900(&mut self,resource:u32,position:&mut [u32;3],velocity:&mut [u32;3],parameters:&mut [u32;3]);
}
pub(crate) fn inverse_estimate(v:f32)->Result<f32,&'static str> {
    #[cfg(target_arch="x86_64")]
    {use std::arch::x86_64::*;Ok(unsafe{_mm_cvtss_f32(_mm_rsqrt_ss(_mm_set_ss(v)))})}
    #[cfg(target_arch="x86")]
    {use std::arch::x86::*;Ok(unsafe{_mm_cvtss_f32(_mm_rsqrt_ss(_mm_set_ss(v)))})}
    #[cfg(not(any(target_arch="x86_64",target_arch="x86")))]
    {let _=v;Err("native force RSQRTSS requires qualified x86 CPU")}
}
pub fn update(input:&Input,position:&mut [u32;3],velocity:&mut [u32;3],parameters:&mut [u32;3],backend:&mut impl Backend)->Result<(),&'static str> {
    // Exceptional field profiles require independent qualification before use.
    let finite=|v:u32|f32::from_bits(v).is_finite();
    if !finite(input.delta) || !position.iter().copied().all(finite) || !velocity.iter().copied().all(finite) || input.acceleration.is_some_and(|v|!v.into_iter().all(finite)) || input.points.iter().chain(input.dampings.iter()).any(|s|!s.position.into_iter().all(finite)||!finite(s.radius)||!finite(s.strength)) {return Err("unqualified nonfinite particle force input");}
    let dt=f32::from_bits(input.delta);
    if let Some(acc)=input.acceleration {
        for j in 0..3 {let product=if j==0 {dt*f32::from_bits(acc[j])}else{f32::from_bits(acc[j])*dt};velocity[j]=(f32::from_bits(velocity[j])+product).to_bits();}
    }
    for point in input.points {
        let d: [f32;3]=std::array::from_fn(|j|f32::from_bits(point.position[j])-f32::from_bits(position[j]));
        let squared=(d[1]*d[1]+d[0]*d[0])+d[2]*d[2];let denominator=if squared>1. {squared}else{1.};
        if !(f32::from_bits(point.radius)*f32::from_bits(point.radius)>=denominator){continue;}
        let estimate=inverse_estimate(denominator)?;
        let correction=3.0-((estimate*denominator)*estimate);
        let factor=(correction*(estimate*0.5))*f32::from_bits(point.strength);
        for j in 0..3 {velocity[j]=(((d[j]*factor)*dt)+f32::from_bits(velocity[j])).to_bits();}
    }
    for resource in input.children {backend.child450(*resource,position,velocity);}
    for damping in input.dampings {
        let d:[f32;3]=std::array::from_fn(|j|f32::from_bits(damping.position[j])-f32::from_bits(position[j]));let radius=f32::from_bits(damping.radius);let r2=radius*radius;let x2=d[0]*d[0];
        if !(r2>x2){continue;}let xy=d[1]*d[1]+x2;if !(r2>xy){continue;}if !(r2>=d[2]*d[2]+xy){continue;}
        let v=velocity.map(f32::from_bits);let squared=(v[1]*v[1]+v[0]*v[0])+v[2]*v[2];let estimate=inverse_estimate(squared)?;
        //5FA7C0 uses an approximate sqrt with the same RSQRTSS correction,
        // multiplied by the original squared value, and masks exact zero.
        let speed=if squared==0. {0.}else{((3.0-((estimate*squared)*estimate))*(estimate*0.5))*squared};
        if !(speed>f32::from_bits(953267991)){continue;}
        let amount=(f32::from_bits(damping.strength)*speed)*dt;let remaining=if amount>speed{0.}else{speed-amount};let factor=remaining/speed;
        for j in 0..3 {velocity[j]=(f32::from_bits(velocity[j])*factor).to_bits();}
    }
    for resource in input.final_children {backend.child900(*resource,position,velocity,parameters);}
    Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::{Value,json};
    fn words(v:&Value)->[u32;3]{std::array::from_fn(|i|v[i].as_u64().unwrap() as u32)}
    fn spheres(v:&Value)->Vec<Sphere>{v.as_array().unwrap().iter().map(|v|Sphere {position:words(&v["position"]),radius:v["radius"].as_u64().unwrap() as u32,strength:v["strength"].as_u64().unwrap() as u32}).collect()}
    struct Adapter {events:Vec<Value>}
    impl Backend for Adapter {
        fn child450(&mut self,r:u32,p:&mut [u32;3],v:&mut [u32;3]){self.events.push(json!({"kind":"0x93c450","resource":r,"position":*p,"velocity":*v,"parameters":null}));v[0]=0x3f000000+self.events.len() as u32;}
        fn child900(&mut self,r:u32,p:&mut [u32;3],v:&mut [u32;3],parameters:&mut [u32;3]){self.events.push(json!({"kind":"0x93c900","resource":r,"position":*p,"velocity":*v,"parameters":*parameters}));v[0]=0x3f000000+self.events.len() as u32;}
    }
    #[test]
    fn force_body_matches2592_native_cpu_captures() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/particle_force_body_contract.json")).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),2592);
        for (i,r) in rows.iter().enumerate() {
            let points=spheres(&r["points"]);let dampings=spheres(&r["dampings"]);let children=if r["children"].as_bool().unwrap(){vec![0x38000,0x38100]}else{vec![]};let final_children=if children.is_empty(){vec![]}else{vec![0x39000,0x39100]};
            let mut position=words(&r["position"]);let mut velocity=words(&r["velocity"]);let mut parameters=words(&r["parameters"]);let mut backend=Adapter {events:vec![]};
            update(&Input {acceleration:r["uniform"].as_bool().unwrap().then_some(words(&r["acceleration"])),points:&points,dampings:&dampings,children:&children,final_children:&final_children,delta:r["delta"].as_u64().unwrap() as u32},&mut position,&mut velocity,&mut parameters,&mut backend).unwrap();
            assert_eq!(position,words(&r["cpu"]["position"]),"position case{i}");assert_eq!(velocity,words(&r["cpu"]["velocity"]),"velocity case{i}");assert_eq!(parameters,words(&r["cpu"]["parameters"]),"parameters case{i}");assert_eq!(backend.events,r["cpu"]["events"].as_array().unwrap().clone(),"events case{i}");
        }
    }
}
