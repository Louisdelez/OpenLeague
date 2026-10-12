//! Original706850 event post/age seek. Backend callbacks must do actual playback.
/// Callback identity determines the native lifecycle; never a host function pointer.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Callback { None, BoundVoice, UnboundScratch }
#[derive(Debug, Clone, PartialEq)]
pub struct Post {
    pub event:String, pub object_id:u32, pub flags:u32,
    pub callback:Callback, pub cookie:u32,
}
#[derive(Debug, Clone, PartialEq)]
pub struct Seek {pub event:String,pub object_id:u32,pub milliseconds:i32,pub nearest_marker:bool}
pub(crate) fn native_milliseconds(age:f32)->i32 {
    let scaled=age*1000.;
    if !scaled.is_finite() || scaled>=2147483648. || scaled < -2147483648. {i32::MIN}
    else {scaled.trunc() as i32}
}
/// Caller supplies an existing registered object and physical backend callbacks.
/// Returned ID is the backend result; zero means no playing voice, no age seek.
pub fn dispatch(event:&str,object_id:u32,cookie:u32,age:f32,
    mut post:impl FnMut(Post)->u32,mut seek:impl FnMut(Seek))->Result<u32,&'static str> {
    if event.is_empty() {return Ok(0);}
    if !event.is_ascii() || event.as_bytes().contains(&0) {return Err("unqualified event string");}
    if !age.is_finite() {return Err("invalid event age");}
    let playing_id=post(Post {event:event.into(),object_id,flags:if cookie==0 {0} else {5},
        callback:if cookie==0 {Callback::None} else {Callback::BoundVoice},cookie});
    if playing_id!=0 && age!=0. {
        seek(Seek {event:event.into(),object_id,milliseconds:native_milliseconds(age),nearest_marker:false});
    }
    Ok(playing_id)
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_252_original_post_and_seek_cases() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_event_post_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),252);
        for case in cases {
            let event=case["event"].as_str().unwrap();let id=case["object_id"].as_u64().unwrap() as u32;
            let cookie=case["cookie"].as_u64().unwrap() as u32;let age=f32::from_bits(case["age_bits"].as_u64().unwrap() as u32);
            let calls=std::cell::RefCell::new(vec![]);
            let result=dispatch(event,id,cookie,age,|p| {
                calls.borrow_mut().push(serde_json::json!({"kind":"post","event":p.event,"object_id":p.object_id,"flags":p.flags,"callback_raw":if p.callback==Callback::BoundVoice {0x704a40u32} else {0},"cookie":p.cookie}));
                case["post_return"].as_u64().unwrap() as u32
            },|s| {calls.borrow_mut().push(serde_json::json!({"kind":"seek","event":s.event,"object_id":s.object_id,"milliseconds_raw":s.milliseconds as u32,"nearest_marker_raw":u32::from(s.nearest_marker)}));}).unwrap();
            assert_eq!(result,case["result"].as_u64().unwrap() as u32);assert_eq!(*calls.borrow(),*case["calls"].as_array().unwrap());
        }
    }
    #[test]
    fn emitter_age_flows_to_seek_without_replaying_consumed_creation_gate() {
        use crate::audio_requests::{Context,Emitter};
        let mut e=Emitter::new("native".into(),String::new());
        let c=Context {clock:2.75,birth:2.,position:[1.,2.,3.]};
        let request=e.creation_request(c).unwrap().unwrap();let mut seeks=vec![];
        let result=dispatch(&request.event,123,42,request.age,|p| {assert_eq!(p.flags,5);7},|s|seeks.push(s)).unwrap();
        assert_eq!(result,7);assert_eq!(seeks[0].milliseconds,750);assert!(!seeks[0].nearest_marker);
        assert!(e.creation_request(c).unwrap().is_none());
        assert_eq!(dispatch("",123,0,f32::NAN, |_|panic!("empty event"), |_|panic!("empty event")).unwrap(),0);
        assert!(dispatch("native",123,0,f32::NAN, |_|panic!("invalid age"), |_|panic!("invalid age")).is_err());
    }
}
