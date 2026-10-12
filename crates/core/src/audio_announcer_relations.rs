//! Original blank/ally/enemy and kill/death audio selector token families.
use crate::audio_announcer_actor_wrapper::Form;
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub enum Kind {YourAlly,Ally,KillDeathAnnounce}
impl Kind {
    pub fn pattern(self)->&'static [u8] {match self {
        Self::YourAlly=>b" blank | your ally | your enemy@",
        Self::Ally=>b" blank | ally | enemy@",
        Self::KillDeathAnnounce=>b" killdeathannouncesrc@",
    }}
}
pub trait Backend<A:Copy> {
    fn team(&mut self,actor:A)->Result<u32,&'static str>;
    fn localize(&mut self,key:&'static str)->Result<String,&'static str>;
}
pub fn relation_bytes<A:Copy+Eq>(kind:Kind,form:Form,actor:Option<A>,local:Option<A>,backend:&mut impl Backend<A>)->Result<Vec<u8>,&'static str> {
    let (Some(actor),Some(local))=(actor,local) else {return Ok(vec![]);};
    if kind!=Kind::KillDeathAnnounce && actor==local {return Ok(vec![]);}
    let equal=if form==Form::Localized && kind!=Kind::KillDeathAnnounce {
        let actor_team=backend.team(actor)?;actor_team==backend.team(local)?
    } else {let local_team=backend.team(local)?;local_team==backend.team(actor)?};
    if kind==Kind::KillDeathAnnounce {return Ok(if equal {b"KillAnnounce2D".to_vec()} else {b"DeathAnnounce2D".to_vec()});}
    if form==Form::Plain {return Ok(match (kind,equal) {(Kind::YourAlly,true)=>b"your ally".to_vec(),(Kind::YourAlly,false)=>b"your enemy".to_vec(),(_,true)=>b"ally".to_vec(),(_,false)=>b"enemy".to_vec()});}
    let key=match (kind,equal) {(Kind::YourAlly,true)=>"game_announcement_replace_yourally",(Kind::YourAlly,false)=>"game_announcement_replace_yourenemy",(_,true)=>"game_announcement_replace_ally",(_,false)=>"game_announcement_replace_enemy"};
    backend.localize(key).map(String::into_bytes)
}
pub fn bind_relation_bytes<A:Copy+Eq>(input:&[u8],form:Form,actor:Option<A>,local:Option<A>,backend:&mut impl Backend<A>)->Result<Option<Vec<u8>>,&'static str> {
    for kind in [Kind::YourAlly,Kind::Ally,Kind::KillDeathAnnounce] {
        let pattern=kind.pattern();if input.get(..pattern.len()).is_some_and(|p|p.eq_ignore_ascii_case(pattern)) {return relation_bytes(kind,form,actor,local,backend).map(Some);}
    }
    Ok(None)
}
#[cfg(test)] mod tests {
    use super::*;use std::collections::BTreeMap;
    struct Provider {values:[u32;2],calls:Vec<serde_json::Value>,translations:BTreeMap<String,String>,localized:Vec<&'static str>}
    impl Backend<u32> for Provider {
        fn team(&mut self,actor:u32)->Result<u32,&'static str> {let index=self.calls.len();assert!(index<2);let value=self.values[index];self.calls.push(serde_json::json!({"owner":actor,"value":value}));Ok(value)}
        fn localize(&mut self,key:&'static str)->Result<String,&'static str> {self.localized.push(key);self.translations.get(key).cloned().ok_or("translation unavailable")}
    }
    #[test] fn audio_relational_tokens_match1728_native_call_order_local_self_and_kill_death_event_selector_cases() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_relations_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),1728);
        for c in cases {
            let mut p=Provider {values:[c["first_team_value"].as_u64().unwrap() as u32,c["second_team_value"].as_u64().unwrap() as u32],calls:vec![],translations:proof["translations"].as_object().unwrap().iter().map(|(k,v)|(k.clone(),v.as_str().unwrap().to_owned())).collect(),localized:vec![]};
            let actor=c["exists"].as_bool().unwrap().then_some(7);let local=match c["local"].as_str().unwrap() {"none"=>None,"self"=>Some(7),"other"=>Some(8),_=>panic!("native local fixture")};let form=if c["entry"]=="0x6d4a10" {Form::Plain} else {Form::Localized};
            let output=bind_relation_bytes(c["input"].as_str().unwrap().as_bytes(),form,actor,local,&mut p).unwrap().unwrap();
            assert_eq!(output.iter().map(|b|format!("{b:02x}")).collect::<String>(),c["output_hex"].as_str().unwrap());assert_eq!(serde_json::json!(p.calls),c["team_getter_calls"]);assert_eq!(serde_json::json!(p.localized),c["localization_calls"]);
        }
    }
}
