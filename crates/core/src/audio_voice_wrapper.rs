//! Original6F79D0 prepares initial XYZ, resolves legacy paths, calls engine40.
use crate::audio_voice_position;
#[derive(Debug,Clone,Copy)]
pub struct Input<'a> {
    pub event:&'a str,
    /// Opaque original caller identity, not a generated playing ID.
    pub actor_identity:u32,
    pub position:[f32;3],
    pub mode_raw:u8,
    pub callback_identity:u32,
    pub age:f32,
    /// Presence of native2D78B90 cache/service, not engine availability.
    pub legacy_paths_enabled:bool,
}
#[derive(Debug,Clone,PartialEq)]
pub struct FactoryRequest {
    pub event:String,
    pub actor_identity:u32,
    pub position:[f32;3],
    pub callback_identity:u32,
    pub age:f32,
}
pub trait Backend {
    type Output;
    fn height_policy(&mut self)->Option<f32>;
    /// Must use the actual legacy cache/provider; never synthesize event names.
    fn resolve_legacy(&mut self,path:&str)->Result<String,&'static str>;
    fn create(&mut self,request:FactoryRequest)->Result<Self::Output,&'static str>;
}
fn valid_event(event:&str)->bool {event.is_ascii()&&!event.as_bytes().contains(&0)&&event.len()<=4096}
pub fn dispatch<B:Backend>(input:Input<'_>,backend:&mut B)->Result<B::Output,&'static str> {
    if !valid_event(input.event) {return Err("unsupported voice wrapper event");}
    if !input.age.is_finite() {return Err("invalid voice wrapper age");}
    let position=audio_voice_position::prepare(input.position,input.mode_raw,||backend.height_policy())?;
    let event=if input.legacy_paths_enabled && input.event.contains('/') {backend.resolve_legacy(input.event)?} else {input.event.to_owned()};
    if !valid_event(&event) {return Err("unsupported resolved voice event");}
    backend.create(FactoryRequest {event,actor_identity:input.actor_identity,position,callback_identity:input.callback_identity,age:input.age})
}
#[cfg(test)]
mod tests {
    use super::*;
    use std::{collections::BTreeMap,sync::{Arc,atomic::{AtomicUsize,Ordering}}};
    struct Fixture {height:Option<f32>,trace:Vec<&'static str>,request:Option<FactoryRequest>,enabled:bool}
    impl Backend for Fixture {
        type Output=(u32,u32);
        fn height_policy(&mut self)->Option<f32> {self.trace.push("height");self.height}
        fn resolve_legacy(&mut self,path:&str)->Result<String,&'static str> {
            crate::audio_legacy_paths::resolve(path,&BTreeMap::new(),|_|{self.trace.push("provider");Ok("Explicit_Announcer_Event".to_owned())})
        }
        fn create(&mut self,request:FactoryRequest)->Result<Self::Output,&'static str> {self.trace.push("factory");self.request=Some(request);Ok((0x11112222,0x33334444))}
    }
    #[test]
    fn matches_2160_original_wrapper_cases() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_voice_wrapper_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),2160);
        for c in cases {
            let enabled=c["cache_enabled"].as_bool().unwrap();
            let mut b=Fixture {height:c["height_enabled"].as_bool().unwrap().then(||f32::from_bits(c["height_bits"].as_u64().unwrap() as u32)),trace:vec![],request:None,enabled};
            let input=Input {event:c["event"].as_str().unwrap(),actor_identity:c["actor_identity"].as_u64().unwrap() as u32,position:std::array::from_fn(|i|f32::from_bits(c["position_bits"][i].as_u64().unwrap() as u32)),mode_raw:c["mode_raw"].as_u64().unwrap() as u8,callback_identity:c["callback_identity"].as_u64().unwrap() as u32,age:f32::from_bits(c["age_bits"].as_u64().unwrap() as u32),legacy_paths_enabled:enabled};
            assert_eq!(dispatch(input,&mut b).unwrap(),(0x11112222,0x33334444));
            let request=b.request.unwrap();let expected=&c["factory_request"];
            assert_eq!(request.event,expected["event"].as_str().unwrap());assert_eq!(request.actor_identity,expected["actor_identity"].as_u64().unwrap() as u32);assert_eq!(request.callback_identity,expected["callback_identity"].as_u64().unwrap() as u32);assert_eq!(request.age.to_bits(),expected["age_bits"].as_u64().unwrap() as u32);
            assert_eq!(request.position.map(f32::to_bits),std::array::from_fn(|i|expected["position_bits"][i].as_u64().unwrap() as u32));
            // Native string find is an internal operation, not a backend command.
            let trace:Vec<_>=c["trace"].as_array().unwrap().iter().map(|x|x.as_str().unwrap()).filter(|x|*x!="find").collect();assert_eq!(b.trace,trace);assert_eq!(b.enabled,enabled);
        }
    }
    #[test]
    fn provider_failure_preserves_height_order_and_prevents_factory() {
        struct Unavailable {calls:Vec<&'static str>}
        impl Backend for Unavailable {
            type Output=();
            fn height_policy(&mut self)->Option<f32> {self.calls.push("height");None}
            fn resolve_legacy(&mut self,_:&str)->Result<String,&'static str> {self.calls.push("resolve");Err("provider unavailable")}
            fn create(&mut self,_:FactoryRequest)->Result<(),&'static str> {panic!("no invented event")}
        }
        let mut b=Unavailable {calls:vec![]};
        let input=Input {event:"/Dialogue/Announcer/A/a.mp3",actor_identity:0,position:[1.,2.,3.],mode_raw:1,callback_identity:0,age:0.,legacy_paths_enabled:true};
        assert_eq!(dispatch(input,&mut b),Err("provider unavailable"));assert_eq!(b.calls,["height","resolve"]);
        b.calls.clear();assert!(dispatch(Input {age:f32::NAN,..input},&mut b).is_err());assert!(b.calls.is_empty());
    }
    #[test]
    fn resolved_context_reaches_managed_factory_without_extending_ownership() {
        use crate::{audio_voice_factory as factory,audio_managed_voice::{Finalizer,ManagedVoice},audio_voice_constructor::Clock};
        struct Context {request:Option<FactoryRequest>,ended:Arc<AtomicUsize>,associations:crate::audio_object_association::Associations<ManagedVoice>}
        impl Backend for Context {
            type Output=factory::Ownership;
            fn height_policy(&mut self)->Option<f32> {Some(500.)}
            fn resolve_legacy(&mut self,path:&str)->Result<String,&'static str> {crate::audio_legacy_paths::resolve(path,&BTreeMap::new(),|request|{assert_eq!(request.filename,"Welcome_mp3");Ok("Play_Actual_Announcement".to_owned())})}
            fn create(&mut self,request:FactoryRequest)->Result<Self::Output,&'static str> {let event=request.event.clone();let age=request.age;self.request=Some(request);factory::create(&event,true,age,self).map_err(|_|"factory error")}
        }
        impl factory::Backend for Context {
            fn launch(&mut self,event:&str,age:f32)->factory::Launch {let r=self.request.as_ref().unwrap();assert_eq!(r.event,event);assert_eq!(r.age.to_bits(),age.to_bits());assert_eq!(r.position,[1.,500.,3.]);assert_eq!(r.actor_identity,123);assert_eq!(r.callback_identity,456);factory::Launch {playing_id:7,object_id:Some(42)}}
            fn resolve_stop(&mut self,_:&str)->factory::StopEvent {factory::StopEvent {id:0,name:String::new()}}
            fn allocate(&mut self,bytes:usize)->bool {assert!(bytes==76||bytes==16);true}
            fn clock(&mut self)->Clock {Clock::Ready(2.)}
            fn finalizer(&mut self)->Finalizer {let ended=Arc::clone(&self.ended);Arc::new(move |voice|{assert_eq!(voice.lifecycle.playing_id,7);ended.fetch_add(1,Ordering::SeqCst);})}
            fn associate(&mut self,id:u32,voice:&factory::Ownership) {let owner=match voice {factory::Ownership::Managed(v)=>Some(Arc::clone(v)),_=>None};self.associations.associate(id as u64,voice.voice().unwrap().is_some(),owner);}
        }
        let ended=Arc::new(AtomicUsize::new(0));let mut context=Context {request:None,ended:Arc::clone(&ended),associations:Default::default()};
        let output=dispatch(Input {event:"/Dialogue/Announcer/Classic/Welcome.mp3",actor_identity:123,position:[1.,2.,3.],mode_raw:1,callback_identity:456,age:0.125,legacy_paths_enabled:true},&mut context).unwrap();
        assert_eq!(output.voice().unwrap().unwrap().play_event,"Play_Actual_Announcement");assert!(context.associations.entries()[0].lock().is_some());assert_eq!(ended.load(Ordering::SeqCst),0);
        drop(output);assert_eq!(ended.load(Ordering::SeqCst),1);assert!(context.associations.entries()[0].lock().is_none());
    }
}
