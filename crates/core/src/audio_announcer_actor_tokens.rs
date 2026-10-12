//! Original plain6D3240 and localized6D3410 actor tokens.
//! Raw flags are the original field1C; caller owns actor identities and localization.
pub const ACTOR_PATTERN:&str=" you | hero | minion | turret@";
pub fn plain_actor_token<A:Copy+PartialEq>(actor:Option<A>,local:Option<A>,mode:u32,
    mut flags:impl FnMut(A)->u32,mut team:impl FnMut(A)->u32)->&'static str {
    let Some(actor)=actor else {return "";};
    if Some(actor)==local {return "you";}
    let flags=flags(actor);
    if flags&0x1000!=0 {
        if local.is_some() {return "hero";}
        if team(actor)==100 {return "blueHero";}
        if team(actor)==200 {return if mode==2 {"redHero"} else {"purpleHero"};}
        return "";
    }
    if flags&0x2000!=0 {return "turret";}
    if flags&0x800!=0 {return "minion";}
    ""
}
/// Preserve exact original localization-key choice, and original bit priority.
/// Do not silently substitute source-token words or invent missing translations.
pub fn localized_actor_token<A:Copy+PartialEq>(actor:Option<A>,local:Option<A>,
    mut flags:impl FnMut(A)->u32,mut localize:impl FnMut(&'static str)->Result<String,&'static str>)->Result<String,&'static str> {
    let Some(actor)=actor else {return Ok(String::new());};
    let key=if Some(actor)==local {"game_announcement_replace_you"} else {
        let flags=flags(actor);
        if flags&0x1000!=0 {"game_announcement_replace_hero"}
        else if flags&0x2000!=0 {"game_announcement_replace_turret"}
        else if flags&0x800!=0 {"game_announcement_replace_minion"}
        else {return Ok(String::new());}
    };
    localize(key)
}
fn matches(input:&str)->bool {input.as_bytes().get(..ACTOR_PATTERN.len()).is_some_and(|p|p.eq_ignore_ascii_case(ACTOR_PATTERN.as_bytes()))}
/// Family matcher only; None delegates to the outer dispatcher, whose name fallback is separate.
pub fn bind_plain_actor_token<A:Copy+PartialEq>(input:&str,actor:Option<A>,local:Option<A>,mode:u32,
    flags:impl FnMut(A)->u32,team:impl FnMut(A)->u32)->Option<&'static str> {
    if !matches(input) {return None;}
    Some(plain_actor_token(actor,local,mode,flags,team))
}
pub fn bind_localized_actor_token<A:Copy+PartialEq>(input:&str,actor:Option<A>,local:Option<A>,
    flags:impl FnMut(A)->u32,localize:impl FnMut(&'static str)->Result<String,&'static str>)->Result<Option<String>,&'static str> {
    if !matches(input) {return Ok(None);}
    localized_actor_token(actor,local,flags,localize).map(Some)
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn plain_actor_tokens_match648_original_cases() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_actor_tokens_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),648);
        for c in cases {
            let actor=if c["actor"]=="null" {None} else {Some(0u8)};
            let local=match c["local"].as_str().unwrap() {"null"=>None,"actor"=>Some(0),_=>Some(1)};let mut trace=Vec::new();
            let value=plain_actor_token(actor,local,c["mode"].as_u64().unwrap() as u32,|_|c["flags"].as_u64().unwrap() as u32,|_|{trace.push("actor");c["team"].as_u64().unwrap() as u32});
            assert_eq!(value,c["output"].as_str().unwrap());assert_eq!(serde_json::json!(trace),c["getter_calls"]);
        }
    }
    #[test] fn actor_binding_matches6480_original_dispatch_compositions_and_accessor_calls() {
        let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_actor_binding_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),6480);
        for c in cases {
            let actor=if c["actor"]=="null" {None} else {Some(0u8)};
            let local=match c["local"].as_str().unwrap() {"null"=>None,"actor"=>Some(0),_=>Some(1)};
            let mut flags_read=0;let mut trace=Vec::new();let mut translations=Vec::new();
            let input=c["input"].as_str().unwrap();
            let value=if c["entry"]=="0x6d4dc0" {
                bind_localized_actor_token(input,actor,local,|_|{flags_read+=1;c["flags"].as_u64().unwrap() as u32},|key|{translations.push(key);Ok(proof["translations"][key].as_str().unwrap().to_owned())}).unwrap()
            } else {
                bind_plain_actor_token(input,actor,local,c["mode"].as_u64().unwrap() as u32,|_|{flags_read+=1;c["flags"].as_u64().unwrap() as u32},|_|{trace.push("actor");c["team"].as_u64().unwrap() as u32}).map(str::to_owned)
            };
            assert_eq!(value.is_some(),c["matched"].as_bool().unwrap());assert_eq!(serde_json::json!(value.into_iter().collect::<Vec<_>>()),c["appends"]);
            assert_eq!(flags_read,c["flag_reads"].as_u64().unwrap());assert_eq!(serde_json::json!(trace),c["getter_calls"]);assert_eq!(serde_json::json!(translations),c["localization_calls"]);
        }
    }
    #[test] fn missing_translation_is_an_error_and_mismatch_performs_no_access() {
        assert_eq!(localized_actor_token(Some(0),None,|_|0x1000,|_|Err("translation missing")),Err("translation missing"));
        assert_eq!(bind_localized_actor_token("unknown",Some(0),None,|_|panic!("flags read"),|_|panic!("localization called")).unwrap(),None);
    }
}

// Compatibility names from initial qualification; they do not assign event src/dest roles.
pub use plain_actor_token as source_actor_token;
pub use localized_actor_token as destination_actor_token;
pub use bind_plain_actor_token as bind_source_actor_token;
pub use bind_localized_actor_token as bind_destination_actor_token;
