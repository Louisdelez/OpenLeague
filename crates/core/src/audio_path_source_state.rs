//! AF1A70 nearest ancestor's resource+64 state view; no resource dereference.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
fn word(b:&[u8],o:usize)->u32{u32::from_le_bytes(b[o..o+4].try_into().unwrap())}
pub fn nearest(sources:&BTreeMap<u32,Memory>,mut reference:u32)->Result<u32,Error>{
 let mut visited=BTreeSet::new();
 loop{if reference==0{return Err(Error::UnresolvedReference);}if !visited.insert(reference){return Err(Error::CyclicList);}let source=sources.get(&reference).ok_or(Error::UnresolvedReference)?;if source.reference!=reference||source.raw.len()<72{return Err(Error::InvalidAllocation);}let resource=word(&source.raw,68);if resource!=0{return Ok(resource.wrapping_add(64));}reference=word(&source.raw,32);if reference==0{return Ok(0);}}
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::Value;
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 #[test]fn audio_path_source_state_matches108_native_nearest_ancestor_null_wrapping_and_readonly_cases(){let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_source_state_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],108);for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let sources:BTreeMap<u32,Memory>=row["before"].as_array().unwrap().iter().map(|v|{let reference=v["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(v["raw"].as_str().unwrap())})}).collect();let before=sources.clone();assert_eq!(nearest(&sources,0x40004000).unwrap(),row["result"].as_u64().unwrap()as u32,"state view {i}");assert!(sources.iter().all(|(r,m)|m.raw==before[r].raw));assert_eq!(row["before"],row["after"]);}}
 #[test]fn audio_path_source_state_rejects_cycles_missing_nodes_and_short_layout_without_mutation(){let mut raw=vec![0;72];raw[32..36].copy_from_slice(&1u32.to_le_bytes());let mut sources=BTreeMap::from([(1,Memory{reference:1,raw})]);assert_eq!(nearest(&sources,1),Err(Error::CyclicList));sources.get_mut(&1).unwrap().raw[32..36].copy_from_slice(&2u32.to_le_bytes());assert_eq!(nearest(&sources,1),Err(Error::UnresolvedReference));sources.get_mut(&1).unwrap().raw.truncate(68);assert_eq!(nearest(&sources,1),Err(Error::InvalidAllocation));}
}
