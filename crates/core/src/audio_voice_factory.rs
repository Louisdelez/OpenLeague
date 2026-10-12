//! Original705A10 factory ordering and ownership, with explicit physical backend.
use std::sync::Arc;
use crate::audio_managed_voice::{ManagedVoice,Finalizer,AccessError};
use crate::audio_voice_constructor::{self,Clock,PhysicalVoice};
#[derive(Debug)]
pub enum Ownership {
    Empty,
    /// A control allocation exists even if voice storage allocation failed.
    Managed(Arc<ManagedVoice>),
    /// Native can expose a raw voice when the control allocation failed. The
    /// caller must retain/handle it explicitly; never manufacture shared success.
    NoControl(Option<PhysicalVoice>),
}
impl Ownership {
    pub fn voice(&self)->Result<Option<PhysicalVoice>,AccessError> {
        match self {Self::Empty=>Ok(None),Self::Managed(v)=>v.snapshot(),Self::NoControl(v)=>Ok(v.clone())}
    }
    pub fn has_control(&self)->bool {matches!(self,Self::Managed(_))}
}
#[derive(Debug,Clone,Copy)]
pub struct Launch {pub playing_id:u32,pub object_id:Option<u32>}
#[derive(Debug,Clone)]
pub struct StopEvent {pub id:u32,pub name:String}
pub trait Backend {
    fn launch(&mut self,event:&str,age:f32)->Launch;
    fn resolve_stop(&mut self,event:&str)->StopEvent;
    /// Reports actual backing allocation; adapters must not fabricate success.
    fn allocate(&mut self,bytes:usize)->bool;
    fn clock(&mut self)->Clock;
    /// Context-owned teardown hook runs at final shared ownership release.
    fn finalizer(&mut self)->Finalizer;
    /// Native7074E0 consumes a strong copy and retains a weak reference only.
    /// The backend must not prolong voice lifetime with a retained strong owner.
    fn associate(&mut self,object_id:u32,voice:&Ownership);
}
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Error {InvalidEvent,InvalidAge,Constructor(audio_voice_constructor::Error)}
pub fn create(event:&str,engine_available:bool,age:f32,backend:&mut impl Backend)->Result<Ownership,Error> {
    if !engine_available {return Ok(Ownership::Empty);}
    let expected=crate::audio_release::event_id(event).map_err(|_|Error::InvalidEvent)?;
    if !age.is_finite() {return Err(Error::InvalidAge);}
    let launch=backend.launch(event,age);
    let Some(object_id)=launch.object_id.filter(|_|launch.playing_id!=0) else {return Ok(Ownership::Empty);};
    let stop=backend.resolve_stop(event);
    let voice=if backend.allocate(76) {
        Some(audio_voice_constructor::construct(launch.playing_id,object_id,expected,event,stop.id,&stop.name,backend.clock()).map_err(Error::Constructor)?)
    } else {None};
    let ownership=if backend.allocate(16) {Ownership::Managed(Arc::new(ManagedVoice::new(voice,backend.finalizer())))} else {Ownership::NoControl(voice)};
    backend.associate(object_id,&ownership);
    Ok(ownership)
}
#[cfg(test)]
mod tests {
    use super::*;
    struct Fixture {
        playing:u32,object:bool,voice_ok:bool,control_ok:bool,stop_found:bool,
        calls:Vec<&'static str>,associations:crate::audio_object_association::Associations<ManagedVoice>,clock:Clock,
    }
    impl Backend for Fixture {
        fn launch(&mut self,_:&str,_:f32)->Launch {self.calls.push("launch");Launch {playing_id:self.playing,object_id:self.object.then_some(123)}}
        fn resolve_stop(&mut self,event:&str)->StopEvent {self.calls.push("resolve_stop");StopEvent {id:if self.stop_found {456} else {0},name:crate::audio_release::candidate_stop_name(event).unwrap()}}
        fn allocate(&mut self,bytes:usize)->bool {match bytes {76=> {self.calls.push("allocate_voice");self.voice_ok},16=> {self.calls.push("allocate_control");self.control_ok},_=>panic!("unexpected size")}}
        fn clock(&mut self)->Clock {self.calls.push("clock");self.clock}
        fn finalizer(&mut self)->Finalizer {Arc::new(|voice| {voice.finalize(1,true,|_,_|0,|_|{});})}
        fn associate(&mut self,object_id:u32,ownership:&Ownership) {
            assert_eq!(object_id,123);self.calls.push("associate");
            let owner=match ownership {Ownership::Managed(owner)=>Some(Arc::clone(owner)),_=>None};
            self.associations.associate(object_id as u64,ownership.voice().unwrap().is_some(),owner);
        }
    }
    #[test]
    fn matches_256_original_factory_and_ownership_cases() {
        let data:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_voice_factory_contract.json")).unwrap();
        let cases=data["cases"].as_array().unwrap();assert_eq!(cases.len(),256);
        for case in cases {
            let mut backend=Fixture {playing:case["playing_id"].as_u64().unwrap() as u32,object:case["object_present"].as_bool().unwrap(),voice_ok:case["voice_allocation_ok"].as_bool().unwrap(),control_ok:case["control_allocation_ok"].as_bool().unwrap(),stop_found:case["stop_found"].as_bool().unwrap(),calls:vec![],associations:Default::default(),clock:Clock::Ready(1000.25)};
            let output=create(case["event"].as_str().unwrap(),case["engine_available"].as_bool().unwrap(),f32::from_bits(case["age_bits"].as_u64().unwrap() as u32),&mut backend).unwrap();
            assert_eq!(output.voice().unwrap().is_some(),case["voice_present"].as_bool().unwrap());assert_eq!(output.has_control(),case["control_present"].as_bool().unwrap());
            let native_calls:Vec<&str>=case["calls"].as_array().unwrap().iter().filter_map(|x|match x["kind"].as_str().unwrap() {
                "launch"=>Some("launch"),"resolve_stop"=>Some("resolve_stop"),"allocate"=>Some(if x["bytes"]==76 {"allocate_voice"} else {"allocate_control"}),"clock_ready"=>Some("clock"),"associate"=>Some("associate"),_=>None,
            }).collect();
            assert_eq!(backend.calls,native_calls);
            if let Some(voice)=output.voice().unwrap() {
                let state=&case["state"];assert_eq!(voice.lifecycle.playing_id,state["playing_id"].as_u64().unwrap() as u32);
                assert_eq!(voice.lifecycle.object_id as u32,state["object_id"].as_u64().unwrap() as u32);
                assert_eq!(voice.lifecycle.stop_event_id,state["stop_event_id"].as_u64().unwrap() as u32);
                assert_eq!(voice.refresh.expected_record_raw,state["expected_record_raw"].as_u64().unwrap() as u32);
                assert_eq!(voice.refresh.started_at.to_bits(),state["clock_bits"].as_u64().unwrap() as u32);
                assert!(!voice.lifecycle.released);assert_eq!(voice.flag49_raw,1);
            }
            if let Ownership::Managed(owner)=&output {
                assert_eq!(Arc::strong_count(owner),case["strong_count"].as_u64().unwrap() as usize);
                assert_eq!(Arc::weak_count(owner)+1,case["weak_count"].as_u64().unwrap() as usize);
                if output.voice().unwrap().is_some() {assert!(Arc::ptr_eq(owner,&backend.associations.entries()[0].lock().unwrap()));}
            }
            assert_eq!(backend.associations.entries().len(),case["associated_entries"].as_u64().unwrap() as usize);
        }
    }
    #[test]
    fn association_does_not_retain_voice_after_output_owner_is_dropped() {
        let mut backend=Fixture {playing:7,object:true,voice_ok:true,control_ok:true,stop_found:true,calls:vec![],associations:Default::default(),clock:Clock::Ready(0.)};
        let output=create("event",true,0.,&mut backend).unwrap();
        assert_eq!(backend.associations.entries()[0].lock().unwrap().snapshot().unwrap().unwrap().lifecycle.playing_id,7);
        drop(output);assert!(backend.associations.entries()[0].lock().is_none());
        assert_eq!(backend.associations.entries().len(),1);
    }
    #[test]
    fn missing_clock_does_not_proceed_to_control_allocation_or_association() {
        let mut backend=Fixture {playing:7,object:true,voice_ok:true,control_ok:true,stop_found:true,calls:vec![],associations:Default::default(),clock:Clock::NotReady};
        assert!(matches!(create("event",true,0.,&mut backend),Err(Error::Constructor(audio_voice_constructor::Error::ClockUnavailable))));
        assert_eq!(backend.calls,vec!["launch","resolve_stop","allocate_voice","clock"]);assert!(backend.associations.entries().is_empty());
    }
}
