//! Composes93BDD0,93C450,93C900 with the shared native RNG. No child adapters.
use crate::{native_particle_force_body as body,native_particle_random_force as random,native_particle_axis_force as axis,native_random::Rng55};
#[derive(Debug,Clone,Copy)]
pub struct Call {pub kind:u32,pub resource:u32,pub position:[u32;3],pub velocity:[u32;3],pub parameters:Option<[u32;3]>}
pub struct Input<'a> {pub body:body::Input<'a>,pub random_forces:&'a [(u32,random::Input)],pub axis_forces:&'a [(u32,[u32;3])]}
struct Children<'a,F> {random:&'a [(u32,random::Input)],axes:&'a [(u32,[u32;3])],rng:&'a mut Rng55,observer:&'a mut F,error:Option<&'static str>}
impl<F:FnMut(Call)> body::Backend for Children<'_,F> {
    fn child450(&mut self,resource:u32,p:&mut [u32;3],v:&mut [u32;3]) {
        if self.error.is_some(){return;}
        (self.observer)(Call {kind:0x93c450,resource,position:*p,velocity:*v,parameters:None});
        let input=&self.random.iter().find(|(id,_)|*id==resource).expect("prevalidated random force").1;
        if let Err(e)=random::update(input,*p,v,self.rng){self.error=Some(e);}
    }
    fn child900(&mut self,resource:u32,p:&mut [u32;3],v:&mut [u32;3],parameters:&mut [u32;3]) {
        if self.error.is_some(){return;}
        (self.observer)(Call {kind:0x93c900,resource,position:*p,velocity:*v,parameters:Some(*parameters)});
        let input=self.axes.iter().find(|(id,_)|*id==resource).expect("prevalidated axis force").1;
        if let Err(e)=axis::update(input,*p,v,*parameters){self.error=Some(e);}
    }
}
/// Observer receives the original child-entry values. Unsupported graphs return
/// explicit errors and leave particle/RNG state unchanged; diagnostic calls may
/// already have been observed. Qualified graphs retain native mutation order.
pub fn update(input:&Input,position:&mut [u32;3],velocity:&mut [u32;3],parameters:&mut [u32;3],rng:&mut Rng55,observer:&mut impl FnMut(Call))->Result<(),&'static str> {
    if input.body.children.iter().any(|id|!input.random_forces.iter().any(|(key,_)|key==id)) || input.body.final_children.iter().any(|id|!input.axis_forces.iter().any(|(key,_)|key==id)){return Err("missing concrete native force resource");}
    let mut p=*position;let mut v=*velocity;let mut param=*parameters;let mut random_state=rng.clone();
    let mut children=Children {random:input.random_forces,axes:input.axis_forces,rng:&mut random_state,observer,error:None};
    body::update(&input.body,&mut p,&mut v,&mut param,&mut children)?;
    if let Some(e)=children.error{return Err(e);}
    *position=p;*velocity=v;*parameters=param;*rng=random_state;Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::{Value,json};
    fn words<const N:usize>(v:&Value)->[u32;N]{std::array::from_fn(|j|v[j].as_u64().unwrap() as u32)}
    fn spheres(v:&Value)->Vec<body::Sphere>{v.as_array().unwrap().iter().map(|v|body::Sphere {position:words(&v["position"]),radius:v["radius"].as_u64().unwrap() as u32,strength:v["strength"].as_u64().unwrap() as u32}).collect()}
    #[test]
    fn whole_force_graph_matches2592_native_cpu_cases_without_child_adapters() {
        let p:Value=serde_json::from_str({
            static FIXTURE: std::sync::OnceLock<String> = std::sync::OnceLock::new();
            FIXTURE.get_or_init(|| {
                const PATH: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/../../data/4.20/particle_force_graph_contract.json");
                let text = std::fs::read_to_string(PATH)
                    .unwrap_or_else(|error| panic!("cannot read frozen test fixture {PATH}: {error}"));
                assert_eq!(text.len(), 13933393, "frozen test fixture byte length: {PATH}");
                text
            }).as_str()
        }).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),2592);assert!(p["adapters"].as_array().unwrap().is_empty());
        for (i,r) in rows.iter().enumerate() {
            let points=spheres(&r["points"]);let dampings=spheres(&r["dampings"]);let children=if r["children"].as_bool().unwrap(){vec![0x38000,0x38100]}else{vec![]};let final_children=if children.is_empty(){vec![]}else{vec![0x39000,0x39100]};
            let random_forces:Vec<_>=(0..2).map(|j|(0x38000+j*0x100,random::Input {count:j+1,center:[0;3],radius:5f32.to_bits(),strength:0.25f32.to_bits(),scales:[0.5f32,1.,2.].map(f32::to_bits)})).collect();
            let axes=[(0x39000,[0f32,1.,0.].map(f32::to_bits)),(0x39100,[0f32,0.,1.].map(f32::to_bits))];
            let mut position=words(&r["position"]);let mut velocity=words(&r["velocity"]);let mut parameters=words(&r["parameters"]);let mut rng=Rng55 {words:std::array::from_fn(|j|12345+13579*j as u32),first:0,second:0};let mut events=vec![];
            update(&Input {body:body::Input {acceleration:r["uniform"].as_bool().unwrap().then_some(words(&r["acceleration"])),points:&points,dampings:&dampings,children:&children,final_children:&final_children,delta:r["delta"].as_u64().unwrap() as u32},random_forces:&random_forces,axis_forces:&axes},&mut position,&mut velocity,&mut parameters,&mut rng,&mut |c:Call|events.push(json!({"kind":format!("0x{:x}",c.kind),"resource":c.resource,"position":c.position,"velocity":c.velocity,"parameters":c.parameters}))).unwrap();
            let e=&r["cpu"];assert_eq!(position,words(&e["position"]),"position case{i}");assert_eq!(velocity,words(&e["velocity"]),"velocity case{i}");assert_eq!(parameters,words(&e["parameters"]));assert_eq!(rng.words,words(&e["rng"]),"rng case{i}");assert_eq!(rng.first,e["first"].as_u64().unwrap() as u32);assert_eq!(rng.second,e["second"].as_u64().unwrap() as u32);assert_eq!(events,e["events"].as_array().unwrap().clone(),"events case{i}");
        }
    }
}
