//! Whole945620 force dispatcher. Concrete93BDD0 body is a backend obligation.
pub trait Backend {
    fn force(&mut self,resource:u32,index:usize,delta:u32,position:&mut [u32;3],velocity:&mut [u32;3],parameters:&mut [u32;3]);
}
fn delta(time:u32,last:u32)->u32 {
    let a=f32::from_bits(time);let b=f32::from_bits(last);
    if a.is_nan(){return time|0x00400000;}if b.is_nan(){return last|0x00400000;}
    let v=a-b;if v.is_nan(){0xffc00000}else{v.to_bits()}
}
/// Copies raw owner C4/C8/CC words once, before traversing particles. Callbacks
/// share that local copy; their writes never modify the supplied owner fields.
pub fn update(resource:u32,time:u32,last:u32,ages:&[u32],positions:&mut [[u32;3]],velocities:&mut [[u32;3]],owner_parameters:[u32;3],backend:&mut impl Backend)->Result<(),&'static str> {
    if resource==0 {return Ok(());}
    if ages.len()!=positions.len() || ages.len()!=velocities.len(){return Err("mismatched native Simple force arrays");}
    let elapsed=delta(time,last);let mut parameters=owner_parameters;
    for (index,age) in ages.iter().enumerate() {
        if 1.0>f32::from_bits(*age) {backend.force(resource,index,elapsed,&mut positions[index],&mut velocities[index],&mut parameters);}
    }
    Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::{Value,json};
    struct Adapter {events:Vec<Value>}
    impl Backend for Adapter {
        fn force(&mut self,_:u32,index:usize,delta:u32,position:&mut [u32;3],velocity:&mut [u32;3],parameters:&mut [u32;3]) {
            self.events.push(json!({"index":index,"delta":delta,"position":*position,"velocity":*velocity,"parameters":*parameters}));
            *position=std::array::from_fn(|j|0x3f800000+(index*3+j) as u32);*velocity=std::array::from_fn(|j|0x40000000+(index*3+j) as u32);
        }
    }
    fn words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()}
    fn triples(v:&Value)->Vec<[u32;3]>{words(v).chunks_exact(3).map(|v|v.try_into().unwrap()).collect()}
    #[test]
    fn force_dispatch_matches384_native_cases_and_array_writes() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_forces_contract.json")).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),384);assert_eq!(p["emulator_cpu_case_disagreements"],0);
        for (i,r) in rows.iter().enumerate() {
            let mut positions=triples(&r["positions"]);let mut velocities=triples(&r["velocities"]);let mut b=Adapter {events:vec![]};let parameters:[u32;3]=words(&r["parameters"]).try_into().unwrap();
            update(u32::from(r["present"].as_bool().unwrap()),r["time"].as_u64().unwrap() as u32,r["last_time"].as_u64().unwrap() as u32,&words(&r["ages"]),&mut positions,&mut velocities,parameters,&mut b).unwrap();
            assert_eq!(b.events,r["cpu"]["events"].as_array().unwrap().clone(),"events case{i}");assert_eq!(positions,triples(&r["cpu"]["positions"]),"positions case{i}");assert_eq!(velocities,triples(&r["cpu"]["velocities"]),"velocities case{i}");assert_eq!(parameters,words(&r["cpu"]["owner_parameters"]).as_slice(),"owner case{i}");
        }
    }
}
