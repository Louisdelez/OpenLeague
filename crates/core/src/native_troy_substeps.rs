//! Native93F5C0..93F983 substep orchestration. Profiling timer backend unqualified.
#[derive(Debug,Clone,PartialEq,Eq)]
pub struct State {pub previous:[u32;3],pub position:[u32;3],pub direction:[u32;3],pub minimum:[u32;3],pub maximum:[u32;3],pub last:u32,pub flags:u8,pub metrics:[u32;2]}
pub trait Backend {
    fn status(&mut self)->u8;
    fn complex_update(&mut self,index:usize,time:u32,state:&State)->u8;
    fn simple_update(&mut self,index:usize,time:u32,last_step:bool,state:&State)->u8;
}
fn math(a:u32,b:u32,op:u8)->u32 {
    let x=f32::from_bits(a);let y=f32::from_bits(b);if x.is_nan(){return a|0x00400000;}if y.is_nan(){return b|0x00400000;}
    let z=match op {0=>x+y,1=>x-y,2=>x*y,_=>x/y};if z.is_nan(){0xffc00000}else{z.to_bits()}
}
fn quiet(v:u32)->u32 {if f32::from_bits(v).is_nan(){v|0x00400000}else{v}}
fn norm(v:[u32;3])->u32 {math(math(math(v[0],v[0],2),math(v[1],v[1],2),0),math(v[2],v[2],2),0)}
fn status(backend:&mut impl Backend)->Result<(),&'static str>{if backend.status()&8!=0 {Err("native profiling timer producer is not qualified")}else{Ok(())}}
pub fn run(state:&mut State,count:i32,step:u32,coefficient:u32,complex_done:&mut [u8],simple_done:&mut [u8],backend:&mut impl Backend)->Result<(),&'static str> {
    let interpolate=count>1 && f32::from_bits(norm(state.direction))>f32::from_bits(0x3089705f) && f32::from_bits(norm(state.previous))>f32::from_bits(0x3089705f);
    let delta=if interpolate {let reciprocal=math(0x3f800000,(count as f32).to_bits(),3);std::array::from_fn(|i|math(math(state.position[i],state.previous[i],1),reciprocal,2))}else{[0;3]};
    for iteration in 0..count.max(0) {
        let time=math(state.last,step,0);
        if interpolate {
            state.position=[math(delta[0],state.previous[0],0),math(state.previous[1],delta[1],0),math(state.previous[2],delta[2],0)];
            let bounds=crate::native_troy_position_bounds::apply(state.position,coefficient);state.minimum=bounds.minimum;state.maximum=bounds.maximum;
        }
        status(backend)?;
        for (i,done) in complex_done.iter_mut().enumerate(){*done=backend.complex_update(i,quiet(time),state);}
        status(backend)?;state.metrics[0]=math(0,state.metrics[0],0);
        status(backend)?;
        for (i,done) in simple_done.iter_mut().enumerate(){*done=backend.simple_update(i,quiet(time),iteration==count-1,state);}
        status(backend)?;state.metrics[1]=math(0,state.metrics[1],0);
        state.last=time;state.previous=state.position.map(quiet);
    }
    state.flags|=2;for done in complex_done.iter().chain(simple_done.iter()){state.flags&=done.wrapping_mul(2)|0xfd;}
    Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::{Value,json};
    struct Adapter {events:Vec<Value>,done:u8}
    impl Adapter {fn record(&mut self,event:&str,index:usize,time:u32,last:Option<bool>,s:&State)->u8 {self.events.push(json!({"event":event,"id":index+1,"time":format!("0x{time:x}"),"last_step":last.map(u8::from),"position":s.position.map(|v|format!("0x{v:x}")),"minimum":s.minimum.map(|v|format!("0x{v:x}")),"maximum":s.maximum.map(|v|format!("0x{v:x}"))}));self.done}}
    impl Backend for Adapter {
        fn status(&mut self)->u8{self.events.push(json!("engine_status"));0}
        fn complex_update(&mut self,i:usize,t:u32,s:&State)->u8{self.record("complex_update",i,t,None,s)}
        fn simple_update(&mut self,i:usize,t:u32,last:bool,s:&State)->u8{self.record("simple_update",i,t,Some(last),s)}
    }
    fn bits(v:&Value)->u32{u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    fn words<const N:usize>(v:&Value)->[u32;N]{std::array::from_fn(|i|bits(&v[i]))}
    #[test]
    fn substeps_match648_native_cpu_cases_events_positions_and_completion() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/troy_substeps_contract.json")).unwrap();assert_eq!(p["cases"].as_array().unwrap().len(),648);
        for (i,row) in p["cases"].as_array().unwrap().iter().enumerate(){
            let mut s=State {previous:words(&row["previous"]),position:words(&row["position"]),direction:words(&row["direction"]),minimum:[0xcccccccc;3],maximum:[0xcccccccc;3],last:bits(&row["last"]),flags:0x80,metrics:[0x7fa01234;2]};let mut b=Adapter {events:vec![],done:row["done_marker"].as_u64().unwrap() as u8};
            run(&mut s,row["count"].as_i64().unwrap() as i32,bits(&row["step"]),bits(&row["coefficient"]),&mut vec![0;row["complex_count"].as_u64().unwrap() as usize],&mut vec![0;row["simple_count"].as_u64().unwrap() as usize],&mut b).unwrap();let e=&row["cpu"];
            assert_eq!(s,State {previous:words(&e["previous"]),position:words(&e["position"]),direction:words(&row["direction"]),minimum:words(&e["minimum"]),maximum:words(&e["maximum"]),last:bits(&e["last"]),flags:e["flags"].as_u64().unwrap() as u8,metrics:words(&e["metrics"])},"case{i}");assert_eq!(b.events,e["events"].as_array().unwrap().clone(),"case{i}");
        }
    }
}
