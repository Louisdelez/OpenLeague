//! Original registered named team-color families; raw mode is not inferred from map ID.
use crate::audio_announcer_actor_wrapper::Form;
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub enum Kind {NoPurple,Absolute,Color,Capitalized}
impl Kind {
    pub fn pattern(self)->&'static [u8] {match self {Self::NoPurple=>b" teamcolornamenopurple@",Self::Absolute=>b" your team color | enemy team color@",Self::Color=>b" red | blue@",Self::Capitalized=>b" red_cap | blue_cap@"}}
    pub fn registered(self,form:Form)->bool {form==Form::Plain || matches!(self,Self::Color|Self::Capitalized)}
}
pub trait Backend<A:Copy> {
    fn team(&mut self,actor:A)->Result<u32,&'static str>;
    fn localize(&mut self,key:&'static str)->Result<String,&'static str>;
}
pub fn color_bytes<A:Copy>(kind:Kind,form:Form,actor:Option<A>,local:Option<A>,mode:u32,backend:&mut impl Backend<A>)->Result<Vec<u8>,&'static str> {
    if !kind.registered(form) {return Err("team-color family not registered in native form");}
    let Some(actor)=actor else {return Ok(if form==Form::Plain {match kind {Kind::Color=>b"unknown".to_vec(),Kind::Capitalized=>b"Unknown".to_vec(),_=>vec![]}} else {vec![]});};
    let color=match kind {
        Kind::NoPurple=> {
            let blue=if let Some(local)=local {let value=backend.team(local)?;value==backend.team(actor)?} else {backend.team(actor)?==100};
            if blue {"blue"} else {"red"}
        },
        Kind::Absolute=> {
            if backend.team(actor)?==100 {"blue"} else if backend.team(actor)?==200 {if mode==2 {"red"} else {"purple"}} else {return Ok(vec![]);}
        },
        Kind::Color|Kind::Capitalized=> {
            if backend.team(actor)?==300 {"neutral"} else if backend.team(actor)?==100 {"blue"} else if mode==2 {"red"} else {"purple"}
        },
    };
    if form==Form::Plain {
        return Ok(match (kind,color) {(Kind::Capitalized,"blue")=>b"Blue".to_vec(),(Kind::Capitalized,"red")=>b"Red".to_vec(),(Kind::Capitalized,"purple")=>b"Purple".to_vec(),(Kind::Capitalized,"neutral")=>b"Neutral".to_vec(),_=>color.as_bytes().to_vec()});
    }
    let key=match (kind,color) {(Kind::Capitalized,"blue")=>"game_announcement_replace_blue_cap",(Kind::Capitalized,"red")=>"game_announcement_replace_red_cap",(Kind::Capitalized,"purple")=>"game_announcement_replace_purple_cap",(Kind::Capitalized,"neutral")=>"game_announcement_replace_neutral_cap",(_,"blue")=>"game_announcement_replace_blue",(_,"red")=>"game_announcement_replace_red",(_,"purple")=>"game_announcement_replace_purple",_=>"game_announcement_replace_neutral"};
    backend.localize(key).map(String::into_bytes)
}
pub fn bind_color_bytes<A:Copy>(input:&[u8],form:Form,actor:Option<A>,local:Option<A>,mode:u32,backend:&mut impl Backend<A>)->Result<Option<Vec<u8>>,&'static str> {
    for kind in [Kind::NoPurple,Kind::Absolute,Kind::Color,Kind::Capitalized] {
        let pattern=kind.pattern();if kind.registered(form)&&input.get(..pattern.len()).is_some_and(|p|p.eq_ignore_ascii_case(pattern)) {return color_bytes(kind,form,actor,local,mode,backend).map(Some);}
    }
    Ok(None)
}
#[cfg(test)] mod tests {
    use super::*;use std::collections::BTreeMap;
    struct Provider {values:[u32;2],calls:Vec<serde_json::Value>,translations:BTreeMap<String,String>,localized:Vec<&'static str>}
    impl Backend<u32> for Provider {
        fn team(&mut self,actor:u32)->Result<u32,&'static str>{let index=self.calls.len();assert!(index<2);let value=self.values[index];self.calls.push(serde_json::json!({"owner":actor,"value":value}));Ok(value)}
        fn localize(&mut self,key:&'static str)->Result<String,&'static str>{self.localized.push(key);self.translations.get(key).cloned().ok_or("translation unavailable")}
    }
    #[test] fn audio_team_colors_match8640_native_registered_forms_local_absolute_dynamic_getters_and_mode_cases() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_team_colors_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),8640);
        for c in cases {
            let mut p=Provider {values:[c["first_team_value"].as_u64().unwrap() as u32,c["second_team_value"].as_u64().unwrap() as u32],calls:vec![],translations:proof["translations"].as_object().unwrap().iter().map(|(k,v)|(k.clone(),v.as_str().unwrap().to_owned())).collect(),localized:vec![]};
            let actor=c["exists"].as_bool().unwrap().then_some(7);let local=match c["local"].as_str().unwrap() {"none"=>None,"self"=>Some(7),"other"=>Some(8),_=>panic!("native local fixture")};let form=if c["entry"]=="0x6d4a10" {Form::Plain} else {Form::Localized};
            let output=bind_color_bytes(c["input"].as_str().unwrap().as_bytes(),form,actor,local,c["mode"].as_u64().unwrap() as u32,&mut p).unwrap().unwrap();
            assert_eq!(output.iter().map(|b|format!("{b:02x}")).collect::<String>(),c["output_hex"].as_str().unwrap());assert_eq!(serde_json::json!(p.calls),c["team_getter_calls"]);assert_eq!(serde_json::json!(p.localized),c["localization_calls"]);
        }
    }
}
