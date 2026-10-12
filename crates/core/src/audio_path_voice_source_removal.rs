//! Native AEEA00 intrusive source voice removal and empty-owner release gates.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
fn word(b:&[u8],o:usize)->u32{u32::from_le_bytes(b[o..o+4].try_into().unwrap())}
fn read(m:&BTreeMap<u32,Memory>,r:u32)->Result<u32,Error>{Ok(word(crate::audio_path_memory::read(m,r,4)?,0))}
fn write(m:&mut BTreeMap<u32,Memory>,r:u32,v:u32)->Result<(),Error>{crate::audio_path_memory::read(m,r,4)?;let base=*m.range(..=r).next_back().ok_or(Error::UnresolvedReference)?.0;let offset=r.wrapping_sub(base)as usize;m.get_mut(&base).unwrap().raw[offset..offset+4].copy_from_slice(&v.to_le_bytes());Ok(())}
pub trait Services{fn release_empty_source(&mut self,source:u32,memory:&mut BTreeMap<u32,Memory>)->Result<(),Error>;}
/// The currently borrowed voice may live outside the region map while its
/// caller mutates it. Read its next field directly rather than cloning an owner.
pub fn remove(m:&mut BTreeMap<u32,Memory>,source:u32,target:u32,borrowed_voice:Option<&Memory>,services:&mut impl Services)->Result<(),Error>{
 let owner=read(m,source.wrapping_add(28))?;let mut current=read(m,owner.wrapping_add(12))?;let mut previous=0u32;let mut seen=BTreeSet::new();
 while current!=0{if !seen.insert(current){return Err(Error::CyclicList);}let next=if let Some(v)=borrowed_voice.filter(|v|v.reference==current){if v.raw.len()<20{return Err(Error::Truncated);}word(&v.raw,16)}else{read(m,current.wrapping_add(16))?};if current==target{if previous==0{write(m,owner.wrapping_add(12),next)?;}else{write(m,previous.wrapping_add(16),next)?;}break;}previous=current;current=next;}
 let counters=crate::audio_path_memory::read(m,owner.wrapping_add(48),8)?;if counters.chunks_exact(2).all(|b|u16::from_le_bytes(b.try_into().unwrap())==0)&&read(m,owner.wrapping_add(12))?==0&&read(m,owner.wrapping_add(4))?==0{services.release_empty_source(source,m)?;}Ok(())
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend(Vec<Value>);impl Services for Backend{fn release_empty_source(&mut self,source:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.0.push(json!({"kind":"release_empty_source","source":source,"owner_at_call":hex(&m[&0x40005000].raw)}));Ok(())}}
 #[test]fn audio_path_voice_source_removal_matches144_native_intrusive_first_middle_last_missing_and_six_empty_owner_gate_cases(){let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_voice_source_removal_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],144);for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut m:BTreeMap<u32,Memory>=[("source",0x40004000),("owner",0x40005000),("voices",0x40006000)].into_iter().map(|(n,reference)|(reference,Memory{reference,raw:bytes(b[n].as_str().unwrap())})).collect();let mut backend=Backend(vec![]);remove(&mut m,0x40004000,row["target"].as_u64().unwrap()as u32,None,&mut backend).unwrap();assert_eq!(json!(backend.0),row["calls"],"source release order and gate state {i}");assert_eq!(json!({"source":hex(&m[&0x40004000].raw),"owner":hex(&m[&0x40005000].raw),"voices":hex(&m[&0x40006000].raw)}),row["after"],"all physical source/owner/list/padding bytes {i}");}}
}
