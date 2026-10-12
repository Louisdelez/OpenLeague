//! Native790020first font-map lookup; owned maps replace native refcounted storage.
//! Locale/fontconfig loading, parser and font GPU creation remain separate.
use std::collections::BTreeMap;
pub type FontMap=BTreeMap<Vec<u8>,Vec<u8>>;
pub struct Entry {pub font_map:Option<FontMap>}
pub fn lookup<'a>(map:&'a FontMap,key:&[u8])->Result<Option<&'a [u8]>,&'static str> {
    if !key.is_ascii() || map.keys().any(|k|!k.is_ascii()) {return Err("unqualified non-ASCII font-map alias comparison");}
    let mut matches=map.iter().filter(|(k,_)|k.eq_ignore_ascii_case(key));
    let found=matches.next().map(|(_,v)|v.as_slice());
    if matches.next().is_some() {return Err("unqualified duplicate case-insensitive font-map alias");}
    Ok(found)
}
pub fn normal_font(entries:&[Option<Entry>])->Result<Option<&[u8]>,&'static str> {
    let Some(map)=entries.first().and_then(Option::as_ref).and_then(|e|e.font_map.as_ref()) else {return Ok(None)};
    lookup(map,b"$NormalFont")
}
// Native bootstrap preserves the previous manager default when supplier is null.
// A mapped empty string is a real assignment, distinct from a missing mapping.
pub fn manager_default<'a>(entries:&'a [Option<Entry>],previous:&'a [u8])->Result<&'a [u8],&'static str> {
    Ok(normal_font(entries)?.unwrap_or(previous))
}
#[cfg(test)] mod tests {
    use super::*;
    #[test] fn sixty_native_normal_font_branches_and_empty_assignment_match() {
        let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_normal_font_contract.json")).unwrap();
        assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],60);
        for c in proof["cases"].as_array().unwrap() {
            let hex=c["mapped_name_hex"].as_str().unwrap();let name=(0..hex.len()).step_by(2).map(|i|u8::from_str_radix(&hex[i..i+2],16).unwrap()).collect::<Vec<_>>();
            let profile=c["profile"].as_str().unwrap();let mut map=FontMap::new();if profile=="success" {map.insert(b"$NormalFont".to_vec(),name.clone());}
            let first=if profile=="null_entry" {None}else {Some(Entry {font_map:if profile=="null_map" {None}else {Some(map)}})};
            let second=Some(Entry {font_map:Some(FontMap::from([(b"$NormalFont".to_vec(),b"SecondMapIgnored".to_vec())]))});
            let entries=if profile=="no_entries" {vec![]}else {vec![first,second]};let result=normal_font(&entries).unwrap();
            assert_eq!(result,if c["returned_name_hex"].is_null(){None}else{Some(name.as_slice())});
            assert_eq!(manager_default(&entries,b"PreviousFont").unwrap(),if profile=="success"{name.as_slice()}else{b"PreviousFont"});
        }
        let init:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_font_manager_contract.json")).unwrap();assert_eq!(init["passed"],true);assert_eq!(init["case_count"],16);
        for c in init["cases"].as_array().unwrap() {assert_eq!(c["assignment_requested"].is_null(),c["default_name_hex"].is_null());}
    }
    #[test] fn hundred_native_font_map_alias_searches_match_case_insensitive_comparison() {
        let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_font_map_lookup_contract.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],100);
        let decode=|s:&str|(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect::<Vec<_>>();
        for c in p["cases"].as_array().unwrap() {
            let mut map=FontMap::new();if let Some(name)=c["stored_hex"].as_str(){map.insert(decode(name),b"MappedFont".to_vec());}
            assert_eq!(lookup(&map,&decode(c["query_hex"].as_str().unwrap())).unwrap().is_some(),c["matched"].as_bool().unwrap());
        }
        let duplicates=FontMap::from([(b"$NormalFont".to_vec(),b"A".to_vec()),(b"$normalfont".to_vec(),b"B".to_vec())]);assert!(lookup(&duplicates,b"$NormalFont").is_err());
    }
}
