//! Original actor-template wrappers6E9DA0/6E9E00: lookup then prefix scan then dispatch.
//! Plain/localized identify function bodies; outer callback registration is not inferred.
#[derive(Debug,Clone,Copy,PartialEq,Eq)] pub enum Form {Plain,Localized}
pub trait Backend {
    type Actor:Copy;
    fn lookup(&mut self,id:u32)->Result<Option<Self::Actor>,&'static str>;
    fn dispatch(&mut self,form:Form,suffix:&str,actor:Self::Actor)->Result<String,&'static str>;
}
pub fn format(input:&str,id:u32,form:Form,backend:&mut impl Backend)->Result<String,&'static str> {
    let Some(actor)=backend.lookup(id)? else {return Ok("Unknown".to_owned());};
    let end=input.bytes().position(|b|b==0).unwrap_or(input.len());let input=&input[..end];
    let offset=input.bytes().position(|b|b==b' '||b==b'@').unwrap_or(input.len());
    backend.dispatch(form,&input[offset..],actor)
}
#[cfg(test)] mod tests {
    use super::*;use crate::{audio_announcer_actor_tokens as actor,audio_announcer_object_lookup as registry};use std::collections::BTreeMap;
    struct Words(BTreeMap<u32,u32>);
    impl registry::Memory for Words {fn word(&mut self,a:u32)->Result<u32,registry::Error>{self.0.get(&a).copied().ok_or(registry::Error::MissingWord(a))}}
    struct Engine {memory:Words,manager:u32,objects:BTreeMap<u32,u32>,local:Option<u32>,mode:u32,translations:BTreeMap<String,String>,lookup_calls:Vec<u32>,team_calls:Vec<u32>,localization_calls:Vec<String>,flag_reads:u64}
    impl Backend for Engine {
        type Actor=u32;
        fn lookup(&mut self,id:u32)->Result<Option<u32>,&'static str>{self.lookup_calls.push(id);let value=registry::lookup_initialized(&mut self.memory,self.manager,id).map_err(|_|"native registry unavailable")?;Ok((value!=0).then_some(value))}
        fn dispatch(&mut self,form:Form,suffix:&str,p:u32)->Result<String,&'static str>{
            let words=&self.memory.0;let reads=&mut self.flag_reads;let teams=&mut self.team_calls;let objects=&self.objects;let translations=&self.translations;let keys=&mut self.localization_calls;
            match form {
                Form::Plain=>actor::bind_plain_actor_token(suffix,Some(p),self.local,self.mode,|a|{*reads+=1;words[&(a+0x1c)]},|a|{let key=*objects.iter().find(|(_,v)|**v==a).unwrap().0;teams.push(key);if key==100 {100} else {200}}).map(str::to_owned).ok_or("other actor dispatch family not implemented"),
                Form::Localized=>actor::bind_localized_actor_token(suffix,Some(p),self.local,|a|{*reads+=1;words[&(a+0x1c)]},|key|{keys.push(key.to_owned());translations.get(key).cloned().ok_or("translation unavailable")})?.ok_or("other actor dispatch family not implemented"),
            }
        }
    }
    #[test] fn composed_lookup_wrapper_dispatch_matches720_original_frames() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_actor_wrappers_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),720);
        for c in cases {
            let mut words:BTreeMap<u32,u32>=proof["registry_layout"]["words"].as_array().unwrap().iter().map(|w|(w[0].as_u64().unwrap() as u32,w[1].as_u64().unwrap() as u32)).collect();
            let objects:BTreeMap<u32,u32>=proof["objects"].as_object().unwrap().iter().map(|(k,v)|(k.parse().unwrap(),v.as_u64().unwrap() as u32)).collect();
            for p in objects.values(){words.insert(p+0x1c,c["flags"].as_u64().unwrap() as u32);}
            let local=c["local_key"].as_u64().map(|key|objects[&(key as u32)]);
            let translations=proof["translations"].as_object().unwrap().iter().map(|(k,v)|(k.clone(),v.as_str().unwrap().to_owned())).collect();
            let mut engine=Engine {memory:Words(words),manager:proof["registry_layout"]["manager"].as_u64().unwrap() as u32,objects,local,mode:c["mode"].as_u64().unwrap() as u32,translations,lookup_calls:vec![],team_calls:vec![],localization_calls:vec![],flag_reads:0};
            let form=if c["entry"]=="0x6e9da0" {Form::Plain} else {Form::Localized};
            assert_eq!(format(c["input"].as_str().unwrap(),c["key"].as_u64().unwrap() as u32,form,&mut engine).unwrap(),c["output"].as_str().unwrap());
            assert_eq!(serde_json::json!(engine.lookup_calls),c["lookup_keys"]);assert_eq!(serde_json::json!(engine.team_calls),c["getter_calls"]);assert_eq!(serde_json::json!(engine.localization_calls),c["localization_calls"]);assert_eq!(engine.flag_reads,c["flag_reads"].as_u64().unwrap());
        }
    }
    #[test] fn lookup_failure_does_not_emit_unknown_or_dispatch() {
        struct Failed;impl Backend for Failed {type Actor=u32;fn lookup(&mut self,_:u32)->Result<Option<u32>,&'static str>{Err("lookup unavailable")}fn dispatch(&mut self,_:Form,_:&str,_:u32)->Result<String,&'static str>{panic!("unexpected dispatch")}}
        assert_eq!(format("src you | hero | minion | turret@",42,Form::Plain,&mut Failed),Err("lookup unavailable"));
    }
}

/// Raw byte transport for the native wrapper; backend errors keep their concrete type.
pub trait ByteBackend {
 type Actor:Copy;
 type Error;
 fn lookup(&mut self,id:u32)->Result<Option<Self::Actor>,Self::Error>;
 fn dispatch_bytes(&mut self,form:Form,suffix:&[u8],actor:Self::Actor)->Result<Vec<u8>,Self::Error>;
}
pub fn format_bytes<B:ByteBackend>(input:&[u8],id:u32,form:Form,backend:&mut B)->Result<Vec<u8>,B::Error> {
 let Some(actor)=backend.lookup(id)? else {return Ok(b"Unknown".to_vec());};
 let end=input.iter().position(|&b|b==0).unwrap_or(input.len());let input=&input[..end];let offset=input.iter().position(|&b|b==b' '||b==b'@').unwrap_or(input.len());backend.dispatch_bytes(form,&input[offset..],actor)
}
