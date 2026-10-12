//! Actual B131D0 delayed-first, first-curve-first subscriber unlink; no physical free.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put};
fn list(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,header:u32,target:u32)->Result<bool,Error>{
 let mut at=get(m,d,header,4)?;let mut previous=0;let mut seen=BTreeSet::new();while at!=0{if !seen.insert(at){return Err(Error::CyclicList);}if get(m,d,at+4,4)?==target{let next=get(m,d,at,4)?;if at==get(m,d,header,4)?{put(m,d,header,4,next)?;}else{put(m,d,previous,4,next)?;}if at==get(m,d,header+4,4)?{put(m,d,header+4,4,previous)?;}put(m,d,at,4,get(m,d,header+8,4)?)?;put(m,d,header+20,4,get(m,d,header+20,4)?.wrapping_sub(1))?;put(m,d,header+8,4,at)?;return Ok(true);}previous=at;at=get(m,d,at,4)?;}Ok(false)
}
pub fn unlink(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,manager:u32,target:u32)->Result<(),Error>{
 if list(m,d,manager+0x91c,target)?{return Ok(());}let mut curve=get(m,d,manager+0x938,4)?;let mut seen=BTreeSet::new();while curve!=0{if !seen.insert(curve){return Err(Error::CyclicList);}if list(m,d,curve+24,target)?{return Ok(());}curve=get(m,d,curve,4)?;}Ok(())
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 #[test]fn audio_curve_subscriber_unlink_matches384_original_delayed_first_curve_order_duplicates_head_tail_free_list_and_unsigned_count_wrap_cases(){let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_curve_subscriber_unlink_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],384);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32)).collect::<Vec<_>>();let mut m=regions.iter().map(|(n,r)|(*r,Memory{reference:*r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let d=BTreeSet::new();unlink(&mut m,&d,0x40001000,row["target"].as_u64().unwrap()as u32).unwrap();let mut out=json!({});for(n,r)in regions{out[&n]=json!(hex(&m[&r].raw));}assert_eq!(out,row["after"],"all original list/manager/node/free/padding bytes {i}");}
 }
}
