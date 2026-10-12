from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
source='''//! Original6D3630 team substitution and6ED1F0 case-insensitive token binding.
//! Caller supplies the native actor/local identities and team getter, preserving call order.
pub const TEAM_PATTERN:&str=" your team | enemy team@";
pub fn team_token<A:Copy>(actor:Option<A>,local:Option<A>,mode:u32,mut team:impl FnMut(A)->u32)->&'static str {
    let Some(actor)=actor else {return "";};
    if let Some(local)=local {
        let reference=team(local);
        return if team(actor)==reference {"YourTeam"} else {"EnemyTeam"};
    }
    if team(actor)==100 {return "blue";}
    // Preserve the original second virtual getter; it is not a cached team value.
    if team(actor)==200 {if mode==2 {"red"} else {"purple"}} else {""}
}
/// Input starts after the source/destination selector in the outer template scanner.
/// Native matcher accepts trailing bytes; it appends even an empty matched value.
/// None denotes mismatch and therefore no getter calls or append.
pub fn bind_team_token<A:Copy>(input:&str,actor:Option<A>,local:Option<A>,mode:u32,team:impl FnMut(A)->u32)->Option<&'static str> {
    let prefix=input.as_bytes().get(..TEAM_PATTERN.len())?;
    if !prefix.eq_ignore_ascii_case(TEAM_PATTERN.as_bytes()) {return None;}
    Some(team_token(actor,local,mode,team))
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn team_tokens_match64_original_calls_and_literals() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_announcer_team_tokens_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),64);
        for c in cases {
            let actor=c["actor_team"].as_u64().map(|_|0);let local=c["local_team"].as_u64().map(|_|1);let mut trace=Vec::new();
            let value=team_token(actor,local,c["mode"].as_u64().unwrap() as u32,|id|{trace.push(if id==0 {"actor"} else {"local"});c[if id==0 {"actor_team"} else {"local_team"}].as_u64().unwrap() as u32});
            assert_eq!(value,c["output"].as_str().unwrap());assert_eq!(serde_json::json!(trace),c["getter_calls"]);
        }
    }
    #[test] fn binding_matches256_original_compositions_including_case_trailing_and_empty() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_announcer_team_binding_contract.json")).unwrap();
        let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),256);
        for c in cases {
            let actor=c["actor_team"].as_u64().map(|_|0);let local=c["local_team"].as_u64().map(|_|1);let mut trace=Vec::new();
            let value=bind_team_token(c["input"].as_str().unwrap(),actor,local,c["mode"].as_u64().unwrap() as u32,|id|{trace.push(if id==0 {"actor"} else {"local"});c[if id==0 {"actor_team"} else {"local_team"}].as_u64().unwrap() as u32});
            assert_eq!(value.is_some(),c["matched"].as_bool().unwrap());assert_eq!(serde_json::json!(value.into_iter().collect::<Vec<_>>()),c["appends"]);assert_eq!(serde_json::json!(trace),c["getter_calls"]);
        }
    }
}
'''
p=r/'crates/core/src/audio_announcer_team_tokens.rs';assert not p.exists();p.write_text(source,encoding='utf-8')
p=r/'crates/core/src/lib.rs';s=p.read_text(encoding='utf-8');assert 'pub mod audio_announcer_team_tokens;' not in s;s=s.replace('pub mod audio_announcer_names;','pub mod audio_announcer_names;\npub mod audio_announcer_team_tokens;');p.write_text(s,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools/add_announcer_team_tokens.py');print('Original team token and binding port registered in core.')
