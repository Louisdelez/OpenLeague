//! Actual AF5B90 reference removal from the owner's retained interface table.
use std::collections::BTreeMap;
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
fn word(b:&[u8],o:usize)->u32{u32::from_le_bytes(b[o..o+4].try_into().unwrap())}
fn set(b:&mut[u8],o:usize,v:u32){b[o..o+4].copy_from_slice(&v.to_le_bytes());}
#[derive(Default)]pub struct Runtime{pub owners:BTreeMap<u32,Memory>,pub tables:BTreeMap<u32,Memory>}
impl Runtime{
 pub fn remove(&mut self,reference:u32,key:u32)->Result<u32,Error>{let owner=self.owners.get_mut(&reference).ok_or(Error::UnresolvedReference)?;if reference==0||owner.reference!=reference||owner.raw.len()<54{return Err(Error::InvalidAllocation);}let count=word(&owner.raw,36)as usize;if count==0{return Ok(29);}let table_reference=word(&owner.raw,32);let table=self.tables.get_mut(&table_reference).ok_or(Error::UnresolvedReference)?;if table_reference==0||table.reference!=table_reference||table.raw.len()<count.checked_mul(4).ok_or(Error::InvalidAllocation)?{return Err(Error::InvalidAllocation);}let Some(index)=(0..count).find(|i|word(&table.raw,i*4)==key)else{return Ok(29);};if count>1{let last=word(&table.raw,(count-1)*4);set(&mut table.raw,index*4,last);}set(&mut owner.raw,36,(count-1)as u32);owner.raw[53]=owner.raw[53].wrapping_sub(1);if owner.raw[53]==0{set(&mut owner.raw,48,6);}Ok(1)
 }
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 #[test]fn audio_path_voice_owner_release_matches128_native_first_duplicate_swap_last_missing_wrapping_phase_and_padding_cases(){let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_voice_owner_release_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],128);for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut context=Runtime{owners:BTreeMap::from([(0x40004000,Memory{reference:0x40004000,raw:bytes(b["owner"].as_str().unwrap())})]),tables:BTreeMap::from([(0x40005000,Memory{reference:0x40005000,raw:bytes(b["table"].as_str().unwrap())})])};assert_eq!(context.remove(0x40004000,row["key"].as_u64().unwrap()as u32).unwrap(),row["result"].as_u64().unwrap()as u32,"removal result {i}");assert_eq!(json!({"owner":hex(&context.owners[&0x40004000].raw),"table":hex(&context.tables[&0x40005000].raw)}),row["after"],"complete owner/table retained storage {i}");}}
}
