//! 9437E0..943924 progress/expiration and dispatch; remaining producer bodies separate.
pub struct Input {
    pub flags:u8,pub time:u32,pub start:u32,pub life:u32,pub lower:u32,pub upper:u32,
    pub delay:u32,pub emitter_linger:u32,pub particle_linger:u32,pub last_step:u32,
}
pub trait Backend {
    fn attachment(&mut self,time:u32,progress:u32);
    fn emission(&mut self,time:u32,progress:u32,resource:&mut u32);
    fn particles(&mut self,resource:u32,time:u32,cap:u32,last_step:u32);
}
fn arithmetic(a:u32,b:u32,divide:bool)->u32 {
    let x=f32::from_bits(a);let y=f32::from_bits(b);
    if x.is_nan(){return a|0x00400000;}if y.is_nan(){return b|0x00400000;}
    let v=if divide{x/y}else{x-y};if v.is_nan(){0xffc00000}else{v.to_bits()}
}
fn quiet(v:u32)->u32 {if f32::from_bits(v).is_nan(){v|0x00400000}else{v}}
/// Native definition fields are explicit raw inputs. In particular this is not
/// Rust min/max: unordered comparisons follow the original COMISS/CMOVBE path.
pub fn update(input:&Input,resource:&mut u32,backend:&mut impl Backend)->bool {
    let elapsed=arithmetic(input.time,input.start,false);
    let threshold=if input.flags&0x10!=0 {input.emitter_linger}else{input.life};
    let expired=f32::from_bits(elapsed)>f32::from_bits(threshold);
    let selected=if f32::from_bits(input.lower)>f32::from_bits(input.upper){input.upper}else{input.lower};
    let denominator=if f32::from_bits(input.life)>f32::from_bits(selected){selected}else{input.life};
    let mut progress=arithmetic(arithmetic(elapsed,input.delay,false),denominator,true);
    if 0.0>f32::from_bits(progress){progress=0;}else if f32::from_bits(progress)>1.0{progress=0x3f800000;}
    backend.attachment(quiet(input.time),quiet(progress));
    if !expired {backend.emission(quiet(input.time),quiet(progress),resource);}
    if *resource!=0 {
        let cap=if input.flags&0x10!=0 && expired{input.particle_linger}else{0x7f7fffff};
        backend.particles(*resource,quiet(input.time),quiet(cap),input.last_step);
    }
    expired
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::{Value,json};
    struct Adapter {events:Vec<Value>,create:bool}
    impl Adapter {fn record(&mut self,name:&str,time:u32,value:u32,last:Option<u32>){self.events.push(json!({"event":name,"time":format!("0x{time:x}"),"value":format!("0x{value:x}"),"last_step":last}));}}
    impl Backend for Adapter {
        fn attachment(&mut self,t:u32,p:u32){self.record("attachment",t,p,None)}
        fn emission(&mut self,t:u32,p:u32,r:&mut u32){self.record("emission",t,p,None);if self.create{*r=1;}}
        fn particles(&mut self,_:u32,t:u32,c:u32,last:u32){self.record("particles",t,c,Some(last))}
    }
    #[test]
    fn simple_progress_dispatch_matches1024_native_cpu_cases() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_control_contract.json")).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),1024);
        for (i,row) in rows.iter().enumerate() {
            let n=|k:&str|row[k].as_u64().unwrap() as u32;
            let mut resource=u32::from(row["present"].as_bool().unwrap());let mut b=Adapter {events:vec![],create:row["create"].as_bool().unwrap()};
            let expired=update(&Input {flags:n("flags") as u8,time:n("time"),start:n("start"),life:n("life"),lower:n("lower"),upper:n("upper"),delay:n("delay"),emitter_linger:n("emitter_linger"),particle_linger:n("particle_linger"),last_step:n("last_step")},&mut resource,&mut b);
            assert_eq!(u8::from(expired),row["cpu"]["expired"].as_u64().unwrap() as u8,"expired case{i}");assert_eq!(resource!=0,row["cpu"]["present"].as_bool().unwrap(),"storage case{i}");assert_eq!(b.events,row["cpu"]["events"].as_array().unwrap().clone(),"dispatch case{i}");
        }
    }
}
