//! Native8B5700; prefix/name initially empty as in cache caller.
#[derive(Debug,PartialEq,Eq)] pub struct Parts {pub prefix:Vec<u8>,pub name:Vec<u8>,pub extension:Vec<u8>}
pub fn split(path:&[u8],previous_extension:&[u8])->Parts {
 let path=&path[..path.iter().position(|&b|b==0).unwrap_or(path.len())];
 let separator=path.iter().rposition(|b|matches!(b,b'/'|b'\\'|b':'));
 let mut prefix=separator.map(|i|path[..=i].to_vec()).unwrap_or_default();
 if separator.is_some_and(|i|path[i]==b':') {prefix.push(b'/')}
 let filename=&path[separator.map(|i|i+1).unwrap_or(0)..];
 let (name,extension)=if let Some(i)=filename.iter().rposition(|&b|b==b'.') {(filename[..i].to_vec(),filename[i+1..].to_vec())}else{(filename.to_vec(),previous_extension.to_vec())};
 Parts {prefix,name,extension}
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn native_path_separators_colon_extension_and_nul_match_all_cases() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_config_path_parts_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],144);
  let bytes=|v:&serde_json::Value|v.as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<u8>>();
  for c in proof["cases"].as_array().unwrap() {let actual=split(&bytes(&c["input"]),&bytes(&c["initial_extension"]));assert_eq!(actual,Parts {prefix:bytes(&c["prefix"]),name:bytes(&c["name"]),extension:bytes(&c["extension"])});}
 }
}
