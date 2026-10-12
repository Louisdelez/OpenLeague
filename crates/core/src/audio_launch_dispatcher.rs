//! Original7067B0 routes registered actor voices or newly allocated ambient voices.
use crate::{audio_event_post::{self,Post,Seek},audio_unbound_post::{self,Target}};
#[derive(Debug,Clone,PartialEq)]
pub enum Command {
    BoundPost(Post),BoundSeek(Seek),
    Unbound(audio_unbound_post::Command),
    Diagnostic {event:String},
}
/// Object IDs come from registered backend objects; callback_cookie is the
/// caller's linked/callback identity, not an actor ID or playing ID. Allocation
/// receives that identity only on the unbound path. Bound positions are ignored.
pub fn dispatch(event:&str,bound_object_id:Option<u32>,position:[f32;3],callback_cookie:u32,
    age:f32,output_object:&mut Option<u32>,mut allocate:impl FnMut(u32)->Option<Target>,
    consume:impl FnMut(Command)->u32)->Result<u32,&'static str> {
    if event.is_empty() {*output_object=None;return Ok(0);}
    if !event.is_ascii() || event.as_bytes().contains(&0) {return Err("unqualified event string");}
    if !age.is_finite() {return Err("invalid event age");}
    let consume=std::cell::RefCell::new(consume);
    let playing_id=if let Some(object_id)=bound_object_id {
        *output_object=Some(object_id);
        audio_event_post::dispatch(event,object_id,callback_cookie,age,
            |p|(consume.borrow_mut())(Command::BoundPost(p)),
            |s| {(consume.borrow_mut())(Command::BoundSeek(s));})?
    } else {
        audio_unbound_post::dispatch(event,position,age,output_object,
            ||allocate(callback_cookie),|command|(consume.borrow_mut())(Command::Unbound(command)))?
    };
    if playing_id==0 {(consume.borrow_mut())(Command::Diagnostic {event:event.into()});}
    Ok(playing_id)
}
#[cfg(test)]
mod tests {
    use super::*;
    use crate::{audio_event_post::Callback,audio_unbound_post::Command as Unbound};
    fn post_notice(p:Post)->serde_json::Value {
        serde_json::json!({"kind":"post","event":p.event,"object_id":p.object_id,"flags":p.flags,"callback_raw":match p.callback {Callback::None=>0,Callback::BoundVoice=>0x704a40u32,Callback::UnboundScratch=>0x704a00u32},"cookie":p.cookie})
    }
    fn seek_notice(s:Seek)->serde_json::Value {
        serde_json::json!({"kind":"seek","event":s.event,"object_id":s.object_id,"milliseconds_raw":s.milliseconds as u32,"nearest_marker_raw":u32::from(s.nearest_marker)})
    }
    #[test]
    fn matches_1008_original_bound_unbound_dispatch_cases() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_launch_dispatcher_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),1008);
        for case in cases {
            let calls=std::cell::RefCell::new(vec![]);let mut output=Some(0xfeedbeef);let mut retired=0;
            let position=std::array::from_fn(|i|f32::from_bits(case["position_bits"][i].as_u64().unwrap() as u32));
            let cookie=case["callback_cookie"].as_u64().unwrap() as u32;
            let target=Target {object_id:123,cookie:data["addresses"]["scratch"].as_u64().unwrap() as u32,linked_present:case["linked_present"].as_bool().unwrap()};
            let result=dispatch(case["event"].as_str().unwrap(),case["bound"].as_bool().unwrap().then_some(123),position,cookie,
                f32::from_bits(case["age_bits"].as_u64().unwrap() as u32),&mut output,
                |given| {assert_eq!(given,cookie);calls.borrow_mut().push(serde_json::json!({"kind":"allocate"}));case["scratch_available"].as_bool().unwrap().then_some(target)},
                |command| {match command {
                    Command::BoundPost(p)|Command::Unbound(Unbound::Post(p))=> {calls.borrow_mut().push(post_notice(p));return case["post_return"].as_u64().unwrap() as u32;},
                    Command::BoundSeek(s)|Command::Unbound(Unbound::Seek(s))=>calls.borrow_mut().push(seek_notice(s)),
                    Command::Unbound(Unbound::Position {position,..})=>calls.borrow_mut().push(serde_json::json!({"kind":"position","bits":position.map(f32::to_bits)})),
                    Command::Unbound(Unbound::Retire(_))=>retired=1,
                    Command::Unbound(Unbound::LinkedEnd(_))=> {assert_eq!(retired,1);calls.borrow_mut().push(serde_json::json!({"kind":"linked_end"}));},
                    Command::Diagnostic {event}=>calls.borrow_mut().push(serde_json::json!({"kind":"diagnostic","event":event})),
                };0 }).unwrap();
            let expected:Vec<_>=case["calls"].as_array().unwrap().iter().filter(|x|x["kind"]!="format_failure").cloned().collect();
            assert_eq!(*calls.borrow(),expected);assert_eq!(result,case["result"].as_u64().unwrap() as u32);assert_eq!(retired,case["retired"].as_u64().unwrap());
            let raw=match output {Some(123)=>data["addresses"]["object"].as_u64().unwrap() as u32,Some(x)=>x,None=>0};
            assert_eq!(raw,case["output_object_raw"].as_u64().unwrap() as u32);
        }
    }
    #[test]
    fn empty_event_clears_output_and_bound_route_ignores_unused_position_without_allocating() {
        let mut output=Some(123);
        assert_eq!(dispatch("",Some(123),[f32::NAN;3],0,f32::NAN,&mut output,|_|panic!("empty event"),|_|panic!("empty event")).unwrap(),0);
        assert_eq!(output,None);
        assert_eq!(dispatch("event",Some(0),[f32::NAN;3],0,0.,&mut output,|_|panic!("bound route"),|c|match c {
            Command::BoundPost(p)=> {assert_eq!(p.callback,Callback::None);assert_eq!((p.flags,p.cookie,p.object_id),(0,0,0));7},_=>panic!("post only"),
        }).unwrap(),7);assert_eq!(output,Some(0));
    }
    #[test]
    fn emitter_request_age_and_creation_gate_flow_through_dispatcher() {
        use crate::audio_requests::{Emitter,Context};
        let mut emitter=Emitter::new("native".into(),String::new());let context=Context {clock:1.25,birth:1.,position:[1.,2.,3.]};
        let request=emitter.creation_request(context).unwrap().unwrap();let mut output=None;let mut seeks=vec![];
        assert_eq!(dispatch(&request.event,None,request.position,42,request.age,&mut output,
            |cookie| {assert_eq!(cookie,42);Some(Target {object_id:123,cookie:10,linked_present:true})},
            |c|match c {Command::Unbound(Unbound::Post(p))=> {assert_eq!(p.callback,Callback::UnboundScratch);7},Command::Unbound(Unbound::Position {..})=>0,Command::Unbound(Unbound::Seek(s))=> {seeks.push(s);0},_=>panic!("successful unbound path"),}).unwrap(),7);
        assert_eq!(output,Some(123));assert_eq!(seeks[0].milliseconds,250);assert!(emitter.creation_request(context).unwrap().is_none());
    }
}
