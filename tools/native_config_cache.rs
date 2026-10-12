//! Original8ACEF0 cache decision prefix. Reload/constructor remain separate.
#[derive(Clone,Copy)] pub struct PairState {pub primary_dirty:Option<bool>,pub overlay_dirty:Option<bool>}
#[derive(Debug,PartialEq,Eq)] pub struct Decision {pub dictionary_query:bool,pub found:bool,pub reload:bool,pub stored_last_path:Vec<u8>}
fn cbytes(value:&[u8])->&[u8] {&value[..value.iter().position(|&b|b==0).unwrap_or(value.len())]}
pub fn decide(requested:&[u8],last_path:&[u8],last_pair:Option<PairState>,dictionary_pair:Option<PairState>,flag:u32)->Decision {
 let requested=cbytes(requested);let last_path=cbytes(last_path);
 let same=requested.eq_ignore_ascii_case(last_path);
 let pair=if same {last_pair}else{dictionary_pair};
 let dirty=pair.is_some_and(|p|p.primary_dirty==Some(true) || p.overlay_dirty==Some(true));
 Decision {dictionary_query:!same,found:pair.is_some(),reload:pair.is_none() || flag&255!=0 || dirty,stored_last_path:if same {last_path.to_vec()}else{requested.to_vec()}}
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn native_cache_reuse_dirty_force_and_last_path_match_every_case() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_config_cache_policy_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],1080);
  for c in proof["cases"].as_array().unwrap() {
   let pair=PairState {primary_dirty:c["primary_dirty"].as_bool(),overlay_dirty:c["overlay_dirty"].as_bool()};
   let actual=decide(c["requested"].as_str().unwrap().as_bytes(),c["last_path"].as_str().unwrap().as_bytes(),c["last_exists"].as_bool().unwrap().then_some(pair),c["dictionary_exists"].as_bool().unwrap().then_some(pair),c["flag"].as_u64().unwrap() as u32);
   assert_eq!(actual.dictionary_query,!c["dictionary_queries"].as_array().unwrap().is_empty());assert_eq!(actual.found,c["resolved_pair_found"].as_bool().unwrap());assert_eq!(actual.reload,c["decision"]=="reload");assert_eq!(actual.stored_last_path,c["stored_last_path"].as_str().unwrap().as_bytes());
  }
 }
}
