//! Whole945620 composition with concrete93BDD0/93C450/93C900 and shared RNG.
use crate::{native_simple_forces as dispatch,native_particle_force_graph as graph,native_particle_force_body as body,native_random::Rng55};
#[derive(Debug,Clone,Copy)]
pub struct Call {pub kind:u32,pub index:usize,pub resource:u32,pub delta:Option<u32>,pub position:[u32;3],pub velocity:[u32;3],pub parameters:Option<[u32;3]>}
struct Concrete<'a,F> {input:Option<&'a graph::Input<'a>>,rng:&'a mut Rng55,observer:&'a mut F,error:Option<&'static str>}
impl<F:FnMut(Call)> dispatch::Backend for Concrete<'_,F> {
    fn force(&mut self,resource:u32,index:usize,delta:u32,p:&mut [u32;3],v:&mut [u32;3],parameters:&mut [u32;3]) {
        if self.error.is_some(){return;}
        let Some(input)=self.input else {self.error=Some("missing concrete Simple force graph");return;};
        (self.observer)(Call {kind:0x93bdd0,index,resource,delta:Some(delta),position:*p,velocity:*v,parameters:Some(*parameters)});
        let b=&input.body;let input=graph::Input {body:body::Input {acceleration:b.acceleration,points:b.points,dampings:b.dampings,children:b.children,final_children:b.final_children,delta},random_forces:input.random_forces,axis_forces:input.axis_forces};
        let result=graph::update(&input,p,v,parameters,self.rng,&mut |c:graph::Call|(self.observer)(Call {kind:c.kind,index,resource:c.resource,delta:None,position:c.position,velocity:c.velocity,parameters:c.parameters}));
        if let Err(e)=result{self.error=Some(e);}
    }
}
/// Native null resource skips all particle processing. Unsupported active graph
/// leaves the entire batch and RNG unchanged; observer may have seen attempted
/// calls. Current/last times and owner parameter fields are read-only inputs.
pub fn update(resource:u32,input:Option<&graph::Input>,time:u32,last:u32,ages:&[u32],positions:&mut [[u32;3]],velocities:&mut [[u32;3]],owner_parameters:[u32;3],rng:&mut Rng55,observer:&mut impl FnMut(Call))->Result<(),&'static str> {
    if resource==0{return Ok(());}
    let mut p=positions.to_vec();let mut v=velocities.to_vec();let mut random=rng.clone();
    let mut backend=Concrete {input,rng:&mut random,observer,error:None};
    dispatch::update(resource,time,last,ages,&mut p,&mut v,owner_parameters,&mut backend)?;
    if let Some(e)=backend.error{return Err(e);}
    positions.copy_from_slice(&p);velocities.copy_from_slice(&v);*rng=random;Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;use crate::native_particle_random_force;use serde_json::{Value,json};
    fn words(v:&Value)->Vec<u32>{v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()}
    fn triples(v:&Value)->Vec<[u32;3]>{words(v).chunks_exact(3).map(|v|v.try_into().unwrap()).collect()}
    #[test]
    fn concrete_force_dispatch_matches144_native_multi_particle_captures() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_concrete_forces_contract.json")).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),144);assert!(p["adapters"].as_array().unwrap().is_empty());
        let points=[body::Sphere {position:[0;3],radius:5f32.to_bits(),strength:1f32.to_bits()}];let dampings=[body::Sphere {position:[0;3],radius:5f32.to_bits(),strength:0.5f32.to_bits()}];
        let random_forces=[(0x2b000,native_particle_random_force::Input {count:2,center:[0;3],radius:5f32.to_bits(),strength:0.25f32.to_bits(),scales:[0.5f32,1.,2.].map(f32::to_bits)})];let axes=[(0x2c000,[0f32,1.,0.].map(f32::to_bits))];
        let input=graph::Input {body:body::Input {acceleration:Some([1f32,-2.,0.5].map(f32::to_bits)),points:&points,dampings:&dampings,children:&[0x2b000],final_children:&[0x2c000],delta:0},random_forces:&random_forces,axis_forces:&axes};
        for (i,r) in rows.iter().enumerate() {
            let mut positions=triples(&r["positions"]);let mut velocities=triples(&r["velocities"]);let parameters=words(&r["parameters"]).try_into().unwrap();let mut rng=Rng55 {words:std::array::from_fn(|j|12345+13579*j as u32),first:0,second:0};let mut events=vec![];
            update(if r["present"].as_bool().unwrap(){0x24000}else{0},Some(&input),r["time"].as_u64().unwrap() as u32,r["last_time"].as_u64().unwrap() as u32,&words(&r["ages"]),&mut positions,&mut velocities,parameters,&mut rng,&mut |c:Call|events.push(json!({"kind":format!("0x{:x}",c.kind),"index":c.index,"resource":c.resource,"delta":c.delta,"position":c.position,"velocity":c.velocity,"parameters":c.parameters}))).unwrap();
            let e=&r["cpu"];assert_eq!(positions,triples(&e["positions"]),"position case{i}");assert_eq!(velocities,triples(&e["velocities"]),"velocity case{i}");assert_eq!(rng.words,words(&e["rng"]).as_slice(),"rng case{i}");assert_eq!(rng.first,e["first"].as_u64().unwrap() as u32);assert_eq!(rng.second,e["second"].as_u64().unwrap() as u32);assert_eq!(events,e["events"].as_array().unwrap().clone(),"events case{i}");assert_eq!(parameters,words(&e["parameters"]).as_slice());
        }
    }
}
