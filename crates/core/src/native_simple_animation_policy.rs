//! Native9439DF..943ADA clip policy, composed with qualified clock arithmetic.
use crate::native_simple_animation_clock::{self as clock,Clip};
#[derive(Debug,Clone,PartialEq,Eq)]
pub struct State {pub clock:u32,pub resource:u32,pub pose_flag:u8}
pub struct Input {pub definition_kind:u32,pub clip_index:u32,pub time:u32,pub baseline:u32,pub mapping:u32}
pub trait Backend {
    fn lookup(&mut self,index:u32)->Option<Clip>;
    fn special_kind11(&mut self,state:&mut State);
    /// Fallible hook used by owned type11 queues; legacy recording adapters remain compatible.
    fn special_kind11_checked(&mut self,state:&mut State)->Result<(),&'static str>{self.special_kind11(state);Ok(())}
    fn evaluate_uncompressed(&mut self,clip:Clip,time:u32,mapping:u32,state:&mut State);
    /// Backend owns the original per-instance compressed scratch context passed
    /// at instance+100; its layout and concrete evaluator are not inferred here.
    fn evaluate_compressed(&mut self,clip:Clip,time:u32,mapping:u32,state:&mut State);
}
pub fn update(state:&mut State,input:&Input,backend:&mut impl Backend)->Result<(),&'static str> {
    if state.resource==0 {return Ok(());}
    if input.definition_kind==11 {return backend.special_kind11_checked(state);}
    if input.clip_index==u32::MAX {return Ok(());}
    let Some(clip)=backend.lookup(input.clip_index) else{return Ok(());};
    state.clock=clock::advance(state.clock,input.time,input.baseline,clip)?;
    state.pose_flag=0;
    let time=if f32::from_bits(state.clock).is_nan(){state.clock|0x00400000}else{state.clock};
    if clip.kind==0x6d6e6163 {backend.evaluate_compressed(clip,time,input.mapping,state);}else{backend.evaluate_uncompressed(clip,time,input.mapping,state);}
    Ok(())
}
#[cfg(test)]
mod tests {
    use super::*;use serde_json::{Value,json};
    struct Adapter {events:Vec<Value>,clip:Option<Clip>}
    impl Adapter {fn evaluate(&mut self,kind:&str,time:u32,mapping:u32,state:&State){assert_ne!(state.resource,0);self.events.push(json!({"event":kind,"time":format!("0x{time:x}"),"mapping":mapping,"pose_flag":state.pose_flag}));}}
    impl Backend for Adapter {
        fn lookup(&mut self,index:u32)->Option<Clip>{self.events.push(json!({"event":"lookup","index":index}));self.clip}
        fn special_kind11(&mut self,_:&mut State){self.events.push(json!({"event":"special_kind11"}));}
        fn evaluate_uncompressed(&mut self,_:Clip,time:u32,mapping:u32,state:&mut State){self.evaluate("uncompressed",time,mapping,state);}
        fn evaluate_compressed(&mut self,_:Clip,time:u32,mapping:u32,state:&mut State){self.evaluate("compressed",time,mapping,state);}
    }
    fn bits(v:&Value)->u32{u32::from_str_radix(v.as_str().unwrap().trim_start_matches("0x"),16).unwrap()}
    #[test]
    fn clip_policy_composes_clock_and_matches768_native_cases() {
        let p:Value=serde_json::from_str(include_str!("../../../data/4.20/simple_animation_policy_contract.json")).unwrap();let rows=p["cases"].as_array().unwrap();assert_eq!(rows.len(),768);
        for (i,r) in rows.iter().enumerate() {
            let n=|k:&str|r[k].as_u64().unwrap() as u32;
            let mut state=State {clock:bits(&r["old_clock"]),resource:u32::from(r["present"].as_bool().unwrap()),pose_flag:0x7f};
            let mut b=Adapter {events:vec![],clip:r["found"].as_bool().unwrap().then_some(Clip {kind:n("clip_kind"),frames:n("frames"),factor:bits(&r["factor"])})};
            update(&mut state,&Input {definition_kind:n("definition_kind"),clip_index:n("clip_index"),time:bits(&r["time"]),baseline:bits(&r["baseline"]),mapping:n("mapping")},&mut b).unwrap();
            assert_eq!(state.clock,bits(&r["cpu"]["clock"]),"clock case{i}");assert_eq!(state.pose_flag,r["cpu"]["pose_flag"].as_u64().unwrap() as u8,"flag case{i}");assert_eq!(b.events,r["cpu"]["events"].as_array().unwrap().clone(),"dispatch case{i}");
        }
    }
}
