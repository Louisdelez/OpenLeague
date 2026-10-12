//! Native8B3140 layout scores and unique-maximum/tie mode selection.
//! Cwd/root retrieval is supplied by the OpenLeague project context.
#[derive(Debug,PartialEq,Eq)] pub struct Layout {pub scores:[i32;3],pub mode:u32}
fn directory(value:i32)->bool {value!=-1 && value&16!=0}
fn file(value:i32)->bool {value!=-1 && value&16==0}
fn contains(bytes:&[u8],needle:&[u8])->bool {bytes.windows(needle.len()).any(|w|w==needle)}
pub fn classify(root:&[u8],mut attributes:impl FnMut(&str)->i32)->Layout {
 let lower:Vec<_>=root.iter().map(|b|b.to_ascii_lowercase()).collect();
 let mut primary=3*i32::from(contains(&lower,b"rads"))+i32::from(contains(&lower,b"solutions"))+i32::from(contains(&lower,b"lol_game_client_sln"));
 primary+=2*i32::from(directory(attributes("DATA")))+2*i32::from(file(attributes("../configurationmanifest")))+2*i32::from(file(attributes("../solutionmanifest")));
 let mut tencent=3*i32::from(file(attributes("../lol.launcher_tencent.exe")))+i32::from(directory(attributes("../Air")));
 if directory(attributes("../Game")) {tencent+=1+2*i32::from(file(attributes("HeroPak_client.zip")))+2*i32::from(file(attributes("Map1.zip")));}
 tencent+=2*i32::from(directory(attributes("../TCLS")))+2*i32::from(file(attributes("../zlib1.dll")));
 // Original developer substring check is case-sensitive, unlike primary.
 let mut developer=3*i32::from(contains(root,b"DevRoot"))+i32::from(directory(attributes("debug")))+2*i32::from(directory(attributes("LEVELS")))+i32::from(directory(attributes("Build")))+i32::from(directory(attributes("ParticleTool")));
 if directory(attributes("DATA")) {developer+=1+i32::from(file(attributes("luac5.1.exe")))+i32::from(directory(attributes("DATA/Buffs")));}
 let scores=[primary,tencent,developer];let maximum=*scores.iter().max().unwrap();
 let mode=if scores.iter().filter(|&&score|score==maximum).count()==1 {scores.iter().position(|&score|score==maximum).unwrap() as u32}else{3};Layout {scores,mode}
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn native_layout_scores_queries_and_ties_match_all_original_cases() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_config_layout_classifier_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],1467);
  for c in proof["cases"].as_array().unwrap().iter().chain(std::iter::once(&proof["actual_project"])) {
   let mut queries=Vec::new();let layout=classify(c["root"].as_str().unwrap().as_bytes(),|path| {queries.push(path.to_owned());c["attributes"][path].as_i64().unwrap_or(-1) as i32});
   assert_eq!(layout.mode,c["mode"].as_u64().unwrap() as u32);assert_eq!(layout.scores,c["scores"].as_array().unwrap().iter().map(|v|v.as_i64().unwrap() as i32).collect::<Vec<_>>().as_slice());
   assert_eq!(queries,c["queries"].as_array().unwrap().iter().map(|v|v.as_str().unwrap().to_owned()).collect::<Vec<_>>());
  }
 }
}
