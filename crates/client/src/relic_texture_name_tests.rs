use super::*;
#[test]
fn original_54_hashes_and_27_loader_name_choices_match(){
 let hashes:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_runes/texture_name_hash_contract.json")).unwrap();
 let choices:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_runes/cache_name_choice_contract.json")).unwrap();
 assert_eq!(hashes["passed"],true);assert_eq!(choices["passed"],true);assert_eq!(hashes["cases"].as_array().unwrap().len(),54);assert_eq!(choices["cases"].as_array().unwrap().len(),27);
 for row in hashes["cases"].as_array().unwrap(){
  let hex=row["input_hex"].as_str().unwrap();let bytes=(0..hex.len()).step_by(2).map(|i|u8::from_str_radix(&hex[i..i+2],16).unwrap()).collect::<Vec<_>>();
  assert_eq!(hash(std::ffi::CStr::from_bytes_with_nul(&bytes).unwrap()),row["native_hash"].as_u64().unwrap() as u32);
 }
 for row in choices["cases"].as_array().unwrap(){
  let requested=std::ffi::CString::new(row["requested"].as_str().unwrap()).unwrap();let canonical=std::ffi::CString::new(row["supplied_canonical"].as_str().unwrap()).unwrap();
  assert_eq!(cache_key(&requested,&canonical),row["native_hash"].as_u64().unwrap() as u32);
 }
}
