//! Native AEEBB0/AED0B0 first id+flags-bit0 match, replace or append.
use crate::audio_control_refresh::Entry;
#[derive(Debug,PartialEq)] pub enum Error {InvalidGain,Allocation}
/// A match preserves existing flags and position; only gain changes. A missing
/// match appends full incoming flags. Caller owns native state flag construction.
pub fn upsert(entries:&mut Vec<Entry>,id:u32,flags:u32,gain:f32)->Result<usize,Error>{
 if !gain.is_finite() || entries.iter().any(|e|!e.gain.is_finite()){return Err(Error::InvalidGain);}
 if let Some(i)=entries.iter().position(|e|e.id==id && (e.flags^flags)&1==0){entries[i].gain=gain;return Ok(i);}
 entries.try_reserve(1).map_err(|_|Error::Allocation)?;let i=entries.len();entries.push(Entry{id,flags,gain});Ok(i)
}
#[cfg(test)] mod tests {
 use super::*;
 fn entries(row:&serde_json::Value)->Vec<Entry>{row.as_array().unwrap().iter().map(|v|Entry{id:v["id"].as_u64().unwrap() as u32,flags:v["flags"].as_u64().unwrap() as u32,gain:f32::from_bits(v["gain_bits"].as_u64().unwrap() as u32)}).collect()}
 fn snapshot(v:&[Entry])->serde_json::Value{serde_json::json!(v.iter().map(|e|serde_json::json!({"id":e.id,"flags":e.flags,"gain_bits":e.gain.to_bits()})).collect::<Vec<_>>())}
 #[test] fn audio_original_gain_lookup_and_mutation_match420_cases(){let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_gain_entries_contract.json")).unwrap();assert_eq!(proof["case_count"],420);for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){let mut e=entries(&row["before"]);let i=upsert(&mut e,row["id"].as_u64().unwrap() as u32,row["flags"].as_u64().unwrap() as u32,f32::from_bits(row["gain_bits"].as_u64().unwrap() as u32)).unwrap();assert_eq!(i as u64,row["selected_index"].as_u64().unwrap(),"index {case}");assert_eq!(snapshot(&e),row["after"],"entries {case}");}}
 #[test] fn audio_invalid_gains_preserve_existing_entries(){let mut e=vec![Entry{id:1,flags:0xa5,gain:0.5}];let before=snapshot(&e);for v in [f32::NAN,f32::INFINITY,f32::NEG_INFINITY]{assert_eq!(upsert(&mut e,1,1,v),Err(Error::InvalidGain));assert_eq!(snapshot(&e),before);}assert_eq!(upsert(&mut e,1,0,-0.),Ok(1));assert_eq!(e[0].flags,0xa5);assert_eq!(e[1].gain.to_bits(),0x80000000);}
}
