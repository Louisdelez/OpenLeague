//! Native763536 resource variant selection before7522B0 skin alias resolution.
pub fn select<'a>(base:&'a str,own:&'a str,enemy:&'a str,count:i32,local_present:bool,matching_id:bool,teams:Option<(u32,u32)>)-> &'a str {
 if count>0 && local_present && matching_id && !own.is_empty(){return own;}
 if local_present && teams.is_some_and(|(caster,local)|caster!=local) && !enemy.is_empty(){return enemy;}
 base
}
#[cfg(test)]
mod tests {
 use super::*;
 #[test]
 fn matches192_original_resource_selections(){
 let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/missile_resource_selection_contract.json")).unwrap();let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),192);
 for(n,c) in cases.iter().enumerate(){let b=|k:&str|c[k].as_bool().unwrap();
 let selected=select("Base.troy",if b("own_available"){"Own.troy"}else{""},if b("enemy_available"){"Enemy.troy"}else{""},c["count"].as_i64().unwrap() as i32,b("local_present"),b("matching_id"),b("caster_present").then_some((if b("same_team"){1}else{2},1)));
 assert_eq!(selected,c["alias_input"].as_str().unwrap(),"case{n}");assert_eq!(selected,c["selected"]["name"].as_str().unwrap(),"case{n}");
 }
 }
}
