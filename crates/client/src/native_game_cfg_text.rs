//! Native Game.cfg parsing loop (8AED5D..8AF242), with file bytes plus NUL.
//! File/cache initialization and alternate encodings are separate contracts.
use std::collections::BTreeMap;
#[derive(Debug,Clone,PartialEq,Eq)]
pub struct Entry {pub hash:u32,pub section:Vec<u8>,pub key:Vec<u8>,pub value:Vec<u8>}
#[derive(Debug,Default,Clone,PartialEq,Eq)]
pub struct Parsed {pub entries:Vec<Entry>,pub warnings:usize,pub error:Option<&'static str>}
pub fn key_hash(section:&[u8],key:&[u8])->u32 {
 section.iter().copied().take_while(|&b|b!=0).chain(std::iter::once(b'*')).chain(key.iter().copied().take_while(|&b|b!=0))
 .fold(0u32,|h,b|h.wrapping_mul(65599).wrapping_add(b.to_ascii_lowercase() as u32))
}
fn find(data:&[u8],start:usize,byte:u8)->usize {data.get(start..).and_then(|s|s.iter().position(|&b|b==byte)).map(|p|start+p).unwrap_or(usize::MAX)}
fn trim(data:&[u8])->Result<Vec<u8>,&'static str> {
 if data.is_empty() {return Ok(Vec::new());}
 let start=data.iter().position(|b|!matches!(b,b' '|b'\t')).ok_or("substring_out_of_range")?;
 let end=data.iter().rposition(|b|!matches!(b,b' '|b'\t')).unwrap()+1;
 Ok(data[start..end].to_vec())
}
pub fn parse(bytes:&[u8],flag:u32)->Parsed {parse_into(bytes,flag,Parsed::default())}
fn parse_into(bytes:&[u8],flag:u32,mut parsed:Parsed)->Parsed {
 if parsed.error.is_some() {return parsed;}
 let mut data=bytes.to_vec();data.push(0);
 let mut section=Vec::new();let mut cursor=0;let mut hashes:BTreeMap<u32,usize>=parsed.entries.iter().enumerate().map(|(i,e)|(e.hash,i)).collect();
 while cursor<data.len() {
  while cursor<data.len() && matches!(data[cursor],b' '|b'\n'|b'\r') {cursor+=1;}
  if cursor>=data.len() {break;}
  match data[cursor] {
   b'['=>{let end=find(&data,cursor+1,b']');if end==usize::MAX {break;}section=data[cursor+1..end].to_vec();cursor=end+1;continue;},
   b'#'|b'\''|b';'=>{cursor=find(&data,cursor,b'\n');continue;},
   _=>{}
  }
  let bracket=find(&data,cursor,b'[');let equal=find(&data,cursor,b'=');
  if equal==usize::MAX {break;}
  if equal>bracket {cursor+=1;continue;}
  let key=match trim(&data[cursor..equal]) {Ok(v)=>v,Err(e)=>{parsed.error=Some(e);break;}};
  let mut start=equal;
  while start<data.len() && matches!(data[start],b' '|b'\t'|b'=') {start+=1;}
  if start>=data.len() {break;}
  let end=data[start..].iter().position(|b|matches!(b,b'\n'|b'\r'|b'#'|b';')).map(|p|start+p).unwrap_or(data.len());
  let mut value=match trim(&data[start..end]) {Ok(v)=>v,Err(e)=>{parsed.error=Some(e);break;}};
  if value.len()>1 && matches!(value[0],b'\''|b'"') && value.last()==value.first() {value=value[1..value.len()-1].to_vec();}
  cursor=end;
  if section.is_empty() {parsed.warnings+=1;continue;}
  let hash=key_hash(&section,&key);
  if hashes.contains_key(&hash) {if flag&1==0 {parsed.warnings+=1;}continue;}
  hashes.insert(hash,parsed.entries.len());parsed.entries.push(Entry {hash,section:section.clone(),key,value});
 }
 parsed
}
#[derive(Debug,PartialEq,Eq)]
pub struct TextFiles {pub parsed:Parsed,pub loaded:bool}
pub fn merge(primary:Option<&[u8]>,baseline:Option<&[u8]>)->TextFiles {
 let mut parsed=Parsed::default();
 if let Some(bytes)=primary {parsed=parse_into(bytes,0,parsed);}
 if let Some(bytes)=baseline {parsed=parse_into(bytes,1,parsed);}
 TextFiles {parsed,loaded:primary.is_some() || baseline.is_some()}
}
/// Native file-loader buffer is null for a zero-byte file; no parse occurs.
pub fn load_text_files(primary:Option<&[u8]>,baseline:Option<&[u8]>)->TextFiles {
 merge(primary.filter(|b|!b.is_empty()),baseline.filter(|b|!b.is_empty()))
}
#[derive(Debug,PartialEq,Eq)]
pub struct TextLookup {pub value:Vec<u8>,pub found:bool}
impl Parsed {
 pub fn lookup(&self,hash:u32,fallback:Option<&[u8]>)->TextLookup {
  match self.entries.iter().find(|e|e.hash==hash) {
   Some(entry)=>TextLookup {value:entry.value.clone(),found:true},
   None=>TextLookup {value:fallback.unwrap_or_default().iter().copied().take_while(|&b|b!=0).collect(),found:false}
  }
 }
 pub fn value(&self,section:&[u8],key:&[u8])->Option<&[u8]> {let hash=key_hash(section,key);self.entries.iter().find(|e|e.hash==hash).map(|e|e.value.as_slice())}
}
#[cfg(test)] mod tests {
 use super::*;
 fn bytes(s:&str)->Vec<u8> {s.chars().map(|c|u8::try_from(c as u32).unwrap()).collect()}
 fn compare(actual:&Parsed,result:&serde_json::Value) {
  assert_eq!(actual.warnings,result["warnings"].as_u64().unwrap() as usize);
  assert_eq!(actual.error,result["error"].as_str());let expected=result["entries"].as_array().unwrap();assert_eq!(actual.entries.len(),expected.len());
  for (entry,e) in actual.entries.iter().zip(expected) {assert_eq!(entry.hash,e["hash"].as_u64().unwrap() as u32);assert_eq!(entry.section,bytes(e["section"].as_str().unwrap()));assert_eq!(entry.key,bytes(e["key"].as_str().unwrap()));assert_eq!(entry.value,bytes(e["value"].as_str().unwrap()));}
 }
 #[test] fn native_two_file_merge_matches_all_original_wrapper_and_parser_cases() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_config_text_merge_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],60);
  for c in proof["cases"].as_array().unwrap() {
   let bytes=|v:&serde_json::Value|v.as_array().map(|a|a.iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<u8>>());
   let primary=bytes(&c["primary"]);let baseline=bytes(&c["baseline"]);let actual=merge(primary.as_deref(),baseline.as_deref());
   assert_eq!(actual.loaded,c["opened"].as_bool().unwrap());compare(&actual.parsed,&c["result"]);
  }
 }
 #[test] fn native_complete_text_file_flow_matches_empty_missing_and_merge_cases() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_config_text_file_flow_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],60);
  for c in proof["cases"].as_array().unwrap() {
   let bytes=|v:&serde_json::Value|v.as_array().map(|a|a.iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<u8>>());
   let primary=bytes(&c["primary"]);let baseline=bytes(&c["baseline"]);let actual=load_text_files(primary.as_deref(),baseline.as_deref());
   assert_eq!(actual.loaded,c["loaded"].as_bool().unwrap());compare(&actual.parsed,&c["result"]);
  }
 }
 #[test] fn parser_matches_all_native_branch_fixtures() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_game_cfg_parser_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],260);
  for c in proof["cases"].as_array().unwrap() {let input:Vec<u8>=c["bytes"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect();compare(&parse(&input,c["flag"].as_u64().unwrap() as u32),&c["result"]);}
 }
 #[test] fn original_default_file_entries_and_environment_value_match_native_loop() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_game_cfg_parser_contract.json")).unwrap();let actual=parse(include_bytes!("../../../data/4.20/configuration/defaults/Game.cfg"),0);
  compare(&actual,&proof["actual_game_cfg"]["result"]);assert_eq!(actual.entries.len(),387);assert_eq!(actual.value(b"Performance",b"EnvironmentQuality"),Some(b"3".as_slice()));
 }
 #[test] fn text_lookup_found_fallback_and_alias_match_original_hash_bucket_search() {
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_text_config_lookup_contract.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],2859);
  let tables:Vec<Parsed>=proof["tables"].as_array().unwrap().iter().map(|table|Parsed {entries:table["entries"].as_array().unwrap().iter().map(|e|Entry {hash:e["hash"].as_u64().unwrap() as u32,section:vec![],key:vec![],value:bytes(e["value"].as_str().unwrap())}).collect(),warnings:0,error:None}).collect();
  for c in proof["cases"].as_array().unwrap() {
   let fallback=c["fallback"].as_array().map(|a|a.iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<u8>>());
   let expected:Vec<u8>=c["value"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect();
   let result=tables[c["table"].as_u64().unwrap() as usize].lookup(c["hash"].as_u64().unwrap() as u32,fallback.as_deref());
   assert_eq!(result.value,expected);assert_eq!(result.found,c["found"].as_bool().unwrap());
   if c["alias"]==true {assert_eq!(result.value,c["initial"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u8).collect::<Vec<u8>>());}
  }
 }

}
