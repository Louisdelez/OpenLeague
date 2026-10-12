//! Original7024A0 announcer service, selected by native6FA620 mode.
use std::collections::BTreeMap;
#[derive(Debug,Clone,Copy,PartialEq,Eq)]
pub enum Mode {Inactive,Active}
impl Mode {
    /// Unsupported original modes yield no service; never choose Active silently.
    pub fn from_raw(value:u32)->Result<Self,&'static str> {match value {0=>Ok(Self::Inactive),1=>Ok(Self::Active),_=>Err("unsupported announcer service mode")}}
}
fn validate(value:&str)->Result<(),&'static str> {
    if !value.is_ascii()||value.as_bytes().contains(&0)||value.len()>4096 {return Err("unsupported announcer name component");}
    Ok(())
}
/// Destination starts empty as in6F7360. Inactive6008B0 performs no composition.
/// Prefix/namespace/filename keep their case; parameter contents are not formats.
pub fn compose(mode:Mode,namespace:&str,filename:&str,prefix:&str)->Result<String,&'static str> {
    if mode==Mode::Inactive {return Ok(String::new());}
    for value in [namespace,filename,prefix] {validate(value)?;}
    let mut result=format!("play_vo_announcer_{prefix}_");
    if !namespace.is_empty() {result.push_str(namespace);result.push('_');}
    result.push_str(filename);
    // Restrict to the original 0x4000 formatter capacity; truncation unqualified.
    if result.len()>=0x4000 {return Err("announcer formatted name exceeds capacity");}
    Ok(result)
}
pub fn resolve_path(path:&str,cache:&BTreeMap<u32,String>,mode:Mode)->Result<String,&'static str> {
    crate::audio_legacy_paths::resolve(path,cache,|request|compose(mode,&request.namespace,&request.filename,&request.prefix))
}
/// Original initialized voice namespace supplied by the announcer startup configuration.
pub fn resolve_path_with_voice(path:&str,cache:&BTreeMap<u32,String>,mode:Mode,voice:&str)->Result<String,&'static str> {
    crate::audio_legacy_paths::resolve_with_namespace(path,cache,voice,|request|compose(mode,&request.namespace,&request.filename,&request.prefix))
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn matches_72_original_service_and_eight_path_integrations() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_announcer_names_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),72);
        for c in cases {assert_eq!(compose(Mode::from_raw(c["mode"].as_u64().unwrap() as u32).unwrap(),c["namespace"].as_str().unwrap(),c["filename"].as_str().unwrap(),c["prefix"].as_str().unwrap()).unwrap(),c["output"].as_str().unwrap());}
        let cases=proof["path_cases"].as_array().unwrap();assert_eq!(cases.len(),8);
        for c in cases {assert_eq!(resolve_path(c["path"].as_str().unwrap(),&BTreeMap::new(),Mode::from_raw(c["mode"].as_u64().unwrap() as u32).unwrap()).unwrap(),c["output"].as_str().unwrap());}
    }
    #[test]
    fn service_resolver_composes_with_wrapper_and_cache_precedence() {
        use crate::audio_voice_wrapper::{self,Backend,FactoryRequest,Input};
        struct Service {mode:Mode,cache:BTreeMap<u32,String>}
        impl Backend for Service {
            type Output=FactoryRequest;
            fn height_policy(&mut self)->Option<f32> {None}
            fn resolve_legacy(&mut self,path:&str)->Result<String,&'static str> {resolve_path(path,&self.cache,self.mode)}
            fn create(&mut self,request:FactoryRequest)->Result<Self::Output,&'static str> {Ok(request)}
        }
        let path="/Dialogue/Announcer/Classic/Welcome.mp3";
        let input=Input {event:path,actor_identity:123,position:[1.,2.,3.],mode_raw:0,callback_identity:456,age:0.125,legacy_paths_enabled:true};
        let mut backend=Service {mode:Mode::Active,cache:BTreeMap::new()};
        let result=audio_voice_wrapper::dispatch(input,&mut backend).unwrap();assert_eq!(result.event,"play_vo_announcer_Classic_Welcome_mp3");assert_eq!(result.position,[1.,-2500.,3.]);assert_eq!(result.callback_identity,456);
        backend.mode=Mode::Inactive;assert_eq!(audio_voice_wrapper::dispatch(input,&mut backend).unwrap().event,"");
        backend.cache.insert(crate::audio_legacy_paths::path_hash(path).unwrap(),"Cached_Native_Event".to_owned());assert_eq!(audio_voice_wrapper::dispatch(input,&mut backend).unwrap().event,"Cached_Native_Event");
        assert_eq!(audio_voice_wrapper::dispatch(Input {event:"Play_Direct",..input},&mut backend).unwrap().event,"Play_Direct");
    }
    #[test]
    fn initialized_voice_namespace_resolves_native_bank_events_and_cache_still_wins() {
        let path="LoL_Audio_en_US/Dialogue/Announcer/Global/2D/OnFirstBlood";
        let mut cache=BTreeMap::new();
        let name=resolve_path_with_voice(path,&cache,Mode::Active,"Female1").unwrap();
        assert_eq!(name,"play_vo_announcer_Global_Female1_OnFirstBlood");
        let id=crate::audio_release::event_id(&name).unwrap();assert_eq!(id,340758711);
        let catalog=crate::audio_announcer_catalog::original_catalog().unwrap();
        assert!(catalog.banks.iter().any(|bank|bank.events.iter().any(|e|e.id==id)));
        cache.insert(crate::audio_legacy_paths::path_hash(path).unwrap(),"Cached_Event".into());
        assert_eq!(resolve_path_with_voice(path,&cache,Mode::Active,"OtherVoice").unwrap(),"Cached_Event");
        assert_eq!(resolve_path_with_voice(path,&BTreeMap::new(),Mode::Inactive,"Female1").unwrap(),"");
        assert!(resolve_path_with_voice(path,&BTreeMap::new(),Mode::Active,"bad\0voice").is_err());
    }
    #[test]
    fn modes_and_unqualified_strings_are_explicit() {
        assert!(Mode::from_raw(2).is_err());assert!(Mode::from_raw(u32::MAX).is_err());
        for s in ["a\0b",&"x".repeat(4097)] {assert!(compose(Mode::Active,s,"file","prefix").is_err());assert_eq!(compose(Mode::Inactive,s,"file","prefix").unwrap(),"");}
        assert_eq!(compose(Mode::Active,"ns","%1_name","PREFIX").unwrap(),"play_vo_announcer_PREFIX_ns_%1_name");
    }
}
