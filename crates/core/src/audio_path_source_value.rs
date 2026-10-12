//! AF3150 source integer property7 and signed integer range lookup.
//! Table views remain borrowed; original count0 scans its first ID byte.
use std::collections::BTreeMap;
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_random::NativeRandom,audio_timed_node_selection::Observer};
fn word(b:&[u8],o:usize)->u32{u32::from_le_bytes(b[o..o+4].try_into().unwrap())}
fn lookup(tables:&BTreeMap<u32,Memory>,reference:u32,stride:u32)->Result<Option<u32>,Error>{
 let count=crate::audio_path_memory::read(tables,reference,1)?[0]as u32;
 for index in 0..count.max(1){let id=crate::audio_path_memory::read(tables,reference.wrapping_add(1+index),1)?[0];if id==7{return Ok(Some(reference.wrapping_add((count+4)&!3).wrapping_add(index*stride)));}}Ok(None)
}
pub fn value(source:&Memory,tables:&BTreeMap<u32,Memory>,random:&mut NativeRandom,observer:&mut impl Observer)->Result<u16,Error>{
 if source.reference==0||source.raw.len()<76{return Err(Error::InvalidAllocation);}let mut value=1u32;let static_table=word(&source.raw,40);
 if static_table!=0{if let Some(slot)=lookup(tables,static_table,4)?{value=word(crate::audio_path_memory::read(tables,slot,4)?,0);}}
 let range_table=word(&source.raw,72);if range_table!=0{if let Some(slot)=lookup(tables,range_table,8)?{let range=crate::audio_path_memory::read(tables,slot,8)?;let lower=word(range,0);let delta=word(range,4).wrapping_sub(lower)as i32;let mut offset=0i32;
 if delta!=0{let draw=random.draw();observer.observe_random(draw);let scaled=(draw as f64*f64::from_bits(0x3f00002000400080))*delta as f64+0.5;let truncated=scaled.trunc();if truncated<i32::MIN as f64||truncated>i32::MAX as f64{return Err(Error::Backend("native AF3150 CRT conversion overflow requires qualification"));}offset=truncated as i32;}value=value.wrapping_add(lower).wrapping_add(offset as u32);}}
 Ok(value as u16)
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{calls:Vec<Value>}
 impl Observer for Backend{fn observe_random(&mut self,value:u16){self.calls.push(json!({"kind":"rand","value":value}));}}
 #[test]fn audio_path_source_value_matches5184_native_aligned_empty_duplicate_missing_static_range_signed_wrap_rng_and_crt_cases(){
 let a:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_source_value_preparation.json")).unwrap();let b:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_source_value_tables_preparation.json")).unwrap();assert_eq!(a["passed"],true);assert_eq!(b["passed"],true);assert_eq!(a["case_count"],576);assert_eq!(b["case_count"],4608);assert_eq!(a["random_multiplier_bits"],"800040002000003f");assert_eq!(b["random_multiplier_bits"],a["random_multiplier_bits"]);
 for(i,row)in a["cases"].as_array().unwrap().iter().chain(b["cases"].as_array().unwrap().iter()).enumerate(){let before=&row["before"];let source=Memory{reference:0x40004000,raw:bytes(before["source"].as_str().unwrap())};let tables=BTreeMap::from([(0x40005000,Memory{reference:0x40005000,raw:bytes(before["properties"].as_str().unwrap())}),(0x40006000,Memory{reference:0x40006000,raw:bytes(before["ranges"].as_str().unwrap())})]);let mut random=NativeRandom::seeded(before["rng_state"].as_u64().unwrap()as u32);let mut backend=Backend{calls:vec![]};assert_eq!(value(&source,&tables,&mut random,&mut backend).unwrap(),row["result_low16"].as_u64().unwrap()as u16,"low16 source result {i}");assert_eq!(json!(backend.calls),row["calls"],"conditional RNG {i}");assert_eq!(json!({"source":hex(&source.raw),"properties":hex(&tables[&0x40005000].raw),"ranges":hex(&tables[&0x40006000].raw),"rng_state":random.state()}),row["after"],"readonly source/table bytes and shared RNG {i}");}
 }
 #[test]fn audio_path_source_value_missing_or_truncated_table_returns_error_before_random_draw(){let mut source=Memory{reference:1,raw:vec![0;76]};source.raw[72..76].copy_from_slice(&100u32.to_le_bytes());let mut random=NativeRandom::seeded(17);let mut backend=Backend{calls:vec![]};assert_eq!(value(&source,&BTreeMap::new(),&mut random,&mut backend),Err(Error::UnresolvedReference));let tables=BTreeMap::from([(100,Memory{reference:100,raw:vec![1,7,0,0,0,0,0,0]})]);assert_eq!(value(&source,&tables,&mut random,&mut backend),Err(Error::InvalidAllocation));assert_eq!(random.state(),17);assert!(backend.calls.is_empty());}
}
