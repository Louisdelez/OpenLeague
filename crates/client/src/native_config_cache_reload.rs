//! Native8ACEF0 reload call plan and8B2ED0 locale branch.
//! Path resolution, resource predicates and actual constructor remain external.
#[derive(Debug,PartialEq,Eq)]
pub struct ReloadPlan {pub primary:[Vec<u8>;3],pub overlay:Option<[Vec<u8>;3]>,pub localized_queries:Vec<Vec<u8>>}
fn cbytes(value:&[u8])->&[u8] {&value[..value.iter().position(|&b|b==0).unwrap_or(value.len())]}
pub fn normalize(value:&[u8])->Vec<u8> {
 let mut out=Vec::new();
 for b in cbytes(value).iter().map(|b|b.to_ascii_lowercase()) {
  let b=if b==b'\\' {b'/'}else{b};
  if b==b'/' && out.len()>1 && out.last()==Some(&b'/') {continue}
  out.push(b);
 }
 out
}
pub fn plan(requested:&[u8],prefix:&[u8],name:&[u8],extension:&[u8],locale:Option<&[u8]>,predicates:[bool;2])->Result<ReloadPlan,&'static str> {
 let requested=cbytes(requested);let extension=cbytes(extension);
 let mut localized=requested.to_vec();let mut queries=Vec::new();
 if let Some(locale)=locale.filter(|_|!extension.is_empty()) {
  let cut=requested.len().checked_sub(extension.len()+usize::from(extension.first()!=Some(&b'.'))).ok_or("native locale suffix would precede filename; unqualified input")?;
  let mut candidate=requested[..cut].to_vec();candidate.push(b'_');candidate.extend_from_slice(cbytes(locale));candidate.extend_from_slice(&requested[cut..]);
  queries.push(candidate.clone());
  if predicates[0] {let mut binary=candidate.clone();binary.extend_from_slice(b"bin");queries.push(binary)}
  if !predicates.iter().all(|&v|v) {localized=candidate}
 }
 let mut defaults=cbytes(prefix).to_vec();defaults.extend_from_slice(b"defaults/");defaults.extend_from_slice(cbytes(name));defaults.push(b'.');defaults.extend_from_slice(extension);
 let localized_normalized=normalize(&localized);
 let is_spell=requested.windows(8).any(|s|s==b"/Spells/" || s==b"\\Spells\\");
 let overlay=(!is_spell && localized_normalized!=normalize(requested)).then(||[localized_normalized.clone(),localized_normalized.clone(),localized]);
 Ok(ReloadPlan {primary:[localized_normalized,defaults,requested.to_vec()],overlay,localized_queries:queries})
}
/// Resolve native metadata and resource status before building the call plan.
pub fn plan_with_resources(requested:&[u8],locale:Option<&[u8]>,mut status:impl FnMut(&[u8])->i32)->Result<ReloadPlan,&'static str> {
 let requested=cbytes(requested);let parts=crate::native_config_path_parts::split(&normalize(requested),b"");
 let mut predicates=[true,true];
 if let Some(locale)=locale.filter(|_|!parts.extension.is_empty()) {
  let cut=requested.len().checked_sub(parts.extension.len()+1).ok_or("unqualified locale suffix")?;
  let mut candidate=requested[..cut].to_vec();candidate.push(b'_');candidate.extend_from_slice(cbytes(locale));candidate.extend_from_slice(&requested[cut..]);
  predicates[0]=status(&candidate)!=0;
  if predicates[0] {candidate.extend_from_slice(b"bin");predicates[1]=status(&candidate)!=0;}
 }
 plan(requested,&parts.prefix,&parts.name,&parts.extension,locale,predicates)
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn connected_path_split_and_resource_status_match_native_reload_calls() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_config_cache_reload_flow_contract.json")).unwrap();assert_eq!(proof["passed"],true);
  for c in proof["cases"].as_array().unwrap().iter().filter(|c|c["reloaded"]==true) {
   let mut queries=Vec::new();let mut index=0;
   let actual=plan_with_resources(c["requested"].as_str().unwrap().as_bytes(),c["locale"].as_str().map(str::as_bytes),|path| {queries.push(path.to_vec());let value=c["locale_predicates"][index].as_bool().unwrap();index+=1;i32::from(value)}).unwrap();
   let mut args=vec![actual.primary];if let Some(overlay)=actual.overlay {args.push(overlay)}
   let expected:Vec<[Vec<u8>;3]>=c["constructors"].as_array().unwrap().iter().map(|a|std::array::from_fn(|i|a[i].as_str().unwrap().as_bytes().to_vec())).collect();assert_eq!(args,expected,"{c}");
   let expected_queries:Vec<Vec<u8>>=c["locale_queries"].as_array().unwrap().iter().map(|a|a.as_str().unwrap().as_bytes().to_vec()).collect();assert_eq!(queries,expected_queries,"{c}");assert_eq!(actual.localized_queries,expected_queries,"{c}");
  }
 }
 #[test] fn native_reload_constructor_arguments_and_locale_queries_match_all_cases() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_config_cache_reload_flow_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],3456);
  for c in proof["cases"].as_array().unwrap().iter().filter(|c|c["reloaded"]==true) {
   let actual=plan(c["requested"].as_str().unwrap().as_bytes(),c["resolved_prefix"].as_str().unwrap().as_bytes(),c["resolved_name"].as_str().unwrap().as_bytes(),c["resolved_extension"].as_str().unwrap().as_bytes(),c["locale"].as_str().map(str::as_bytes),[c["locale_predicates"][0].as_bool().unwrap(),c["locale_predicates"][1].as_bool().unwrap()]).unwrap();
   let mut args=vec![actual.primary];if let Some(overlay)=actual.overlay {args.push(overlay)}
   let expected:Vec<[Vec<u8>;3]>=c["constructors"].as_array().unwrap().iter().map(|a|std::array::from_fn(|i|a[i].as_str().unwrap().as_bytes().to_vec())).collect();assert_eq!(args,expected,"{c}");
   let queries:Vec<Vec<u8>>=c["locale_queries"].as_array().unwrap().iter().map(|a|a.as_str().unwrap().as_bytes().to_vec()).collect();assert_eq!(actual.localized_queries,queries,"{c}");
  }
 }
}
