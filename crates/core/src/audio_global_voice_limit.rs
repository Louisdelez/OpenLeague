//! Actual AEB180 global voice-limit setter; signed selector priority and low16 input.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_plugin_factory::Memory,audio_bus_bank::Error};
use crate::audio_path_source_virtual_cleanup::{get,put};
#[derive(Clone,Copy)]pub struct Limits{pub priority:u32,pub voices:u32}
pub fn set(m:&mut BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,globals:Limits,bits:u32,selector:u32)->Result<u32,Error>{
 let value=bits&0xffff;if value==0{return Ok(31);}
 if selector as i32<=get(m,dead,globals.priority,4)? as i32{put(m,dead,globals.priority,4,selector)?;put(m,dead,globals.voices,2,value)?;}Ok(1)
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::Value;
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 #[test]fn audio_global_voice_limit_matches400_original_signed_priority_low16_zero_status_and_complete_globals(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_global_voice_limit_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],400);let r=p["reference"].as_u64().unwrap()as u32;
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m=BTreeMap::from([(r,Memory{reference:r,raw:bytes(row["before"].as_str().unwrap())})]);let result=set(&mut m,&BTreeSet::new(),Limits{priority:0x12100d8,voices:0x12100ec},row["bits"].as_u64().unwrap()as u32,row["selector"].as_u64().unwrap()as u32).unwrap();assert_eq!(result as u64,row["result"].as_u64().unwrap(),"status {i}");assert_eq!(hex(&m[&r].raw),row["after"].as_str().unwrap(),"all64 global bytes {i}");}
 }
}
