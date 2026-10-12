//! Original706910 unbound post. Callers supply registered scratch/object identities
//! and consume commands against a real backend; this is not audible playback.
use crate::audio_event_post::{Callback,Post,Seek,native_milliseconds};
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub struct Target {pub object_id:u32,pub cookie:u32,pub linked_present:bool}
#[derive(Debug,Clone,PartialEq)]
pub enum Command {
    Position {target:Target,position:[f32;3]},
    Post(Post), Seek(Seek),
    Retire(Target), LinkedEnd(Target),
}
/// Position is already prepared by the physical factory; do not apply height
/// preparation again here. Empty events leave the caller output unchanged.
/// Failed scratch allocation clears output; failed Post retains object output.
pub fn dispatch(event:&str,position:[f32;3],age:f32,output_object:&mut Option<u32>,
    mut allocate:impl FnMut()->Option<Target>,
    mut consume:impl FnMut(Command)->u32)->Result<u32,&'static str> {
    if event.is_empty() {return Ok(0);}
    if !event.is_ascii() || event.as_bytes().contains(&0) {return Err("unqualified event string");}
    if !age.is_finite() || !position.iter().all(|x|x.is_finite()) {return Err("invalid event input");}
    let Some(target)=allocate() else {*output_object=None;return Ok(0);};
    *output_object=Some(target.object_id);
    if position!=[f32::MAX;3] {consume(Command::Position {target,position});}
    let playing_id=consume(Command::Post(Post {event:event.into(),object_id:target.object_id,
        flags:5,callback:Callback::UnboundScratch,cookie:target.cookie}));
    if playing_id==0 {
        consume(Command::Retire(target));
        if target.linked_present {consume(Command::LinkedEnd(target));}
    } else if age!=0. {
        consume(Command::Seek(Seek {event:event.into(),object_id:target.object_id,
            milliseconds:native_milliseconds(age),nearest_marker:false}));
    }
    Ok(playing_id)
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_504_original_unbound_launch_cases() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_unbound_post_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),504);
        for case in cases {
            let calls=std::cell::RefCell::new(vec![]);
            let target=Target {object_id:123,cookie:data["addresses"]["scratch"].as_u64().unwrap() as u32,linked_present:case["linked_present"].as_bool().unwrap()};
            let position=std::array::from_fn(|i|f32::from_bits(case["position_bits"][i].as_u64().unwrap() as u32));
            let age=f32::from_bits(case["age_bits"].as_u64().unwrap() as u32);
            let mut output=Some(0xfeedbeef);let mut retired=0;
            let result=dispatch(case["event"].as_str().unwrap(),position,age,&mut output,
                || {calls.borrow_mut().push(serde_json::json!({"kind":"allocate"}));case["scratch_available"].as_bool().unwrap().then_some(target)},
                |command| {match command {
                    Command::Position {position,..}=>calls.borrow_mut().push(serde_json::json!({"kind":"position","bits":position.map(f32::to_bits)})),
                    Command::Post(p)=> {
                        assert_eq!(p.callback,Callback::UnboundScratch);
                        calls.borrow_mut().push(serde_json::json!({"kind":"post","event":p.event,"object_id":p.object_id,"flags":p.flags,"callback_raw":0x704a00u32,"cookie":p.cookie}));
                        return case["post_return"].as_u64().unwrap() as u32;
                    },
                    Command::Seek(s)=>calls.borrow_mut().push(serde_json::json!({"kind":"seek","event":s.event,"object_id":s.object_id,"milliseconds_raw":s.milliseconds as u32,"nearest_marker_raw":u32::from(s.nearest_marker)})),
                    Command::Retire(t)=> {assert_eq!(t,target);retired=1;},
                    Command::LinkedEnd(t)=> {assert_eq!(retired,1);assert_eq!(t,target);calls.borrow_mut().push(serde_json::json!({"kind":"linked_end"}));},
                };0 }).unwrap();
            assert_eq!(result,case["result"].as_u64().unwrap() as u32);assert_eq!(retired,case["retired"].as_u64().unwrap());
            let output_raw=match output {Some(123)=>data["addresses"]["object"].as_u64().unwrap() as u32,Some(x)=>x,None=>0};
            assert_eq!(output_raw,case["output_object_raw"].as_u64().unwrap() as u32);
            assert_eq!(*calls.borrow(),*case["calls"].as_array().unwrap());
        }
    }
    #[test]
    fn failed_post_retires_allocated_scratch_before_deferred_cleanup() {
        use crate::audio_deferred_pool::{Allocation,Cleanup,Pool,ScratchSubsystem};
        let pool=std::cell::RefCell::new(Pool::<u32,u32>::default());
        let mut subsystem=ScratchSubsystem {initialized:false};let mut output=None;let mut linked_end=0;
        let result=dispatch("native",[1.,2.,3.],0.5,&mut output,
            || {let mut p=pool.borrow_mut();match p.allocate(&mut subsystem,Some(42),||Some(123),||{},||Some(10)) {
                Allocation::Registered {token}=>Some(Target {object_id:123,cookie:token as u32,linked_present:true}),
                _=>panic!("fixture allocation must succeed"),
            }},
            |command| {match command {
                Command::Position {target,position}=> {assert_eq!(target.object_id,123);assert_eq!(position,[1.,2.,3.]);},
                Command::Post(p)=> {assert_eq!(p.callback,Callback::UnboundScratch);assert_eq!(p.cookie,10);},
                Command::Retire(target)=>pool.borrow_mut().entries_mut().iter_mut().find(|e|e.token==target.cookie as u64).unwrap().retired=1,
                Command::LinkedEnd(_)=> {assert_eq!(pool.borrow().entries()[0].retired,1);linked_end+=1;},
                Command::Seek(_)=>panic!("failed Post must not seek"),
            };0 }).unwrap();
        assert_eq!(result,0);assert_eq!(output,Some(123));assert_eq!(linked_end,1);
        assert_eq!(pool.borrow().entries().len(),1);
        let mut order=vec![];pool.borrow_mut().cleanup(|c|order.push(match c {Cleanup::DisposeObject(_)=>"dispose",Cleanup::DestroyLinked(_)=>"linked_destroy",Cleanup::RemoveScratch(_)=>"free"}));
        assert_eq!(order,vec!["dispose","linked_destroy","free"]);assert!(pool.borrow().entries().is_empty());
    }
}
