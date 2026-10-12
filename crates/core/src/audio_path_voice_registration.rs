//! Native B00250/AFD670/AFD740 registration search/removal and AF3FF0/AF4080
//! global list unlink. Empty registries are unlinked, not physically freed.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
fn word(b:&[u8],o:usize)->u32{u32::from_le_bytes(b[o..o+4].try_into().unwrap())}
fn read(m:&BTreeMap<u32,Memory>,r:u32)->Result<u32,Error>{Ok(word(crate::audio_path_memory::read(m,r,4)?,0))}
fn write(m:&mut BTreeMap<u32,Memory>,r:u32,b:&[u8])->Result<(),Error>{crate::audio_path_memory::read(m,r,b.len())?;let base=*m.range(..=r).next_back().ok_or(Error::UnresolvedReference)?.0;let offset=r.wrapping_sub(base)as usize;m.get_mut(&base).unwrap().raw[offset..offset+b.len()].copy_from_slice(b);Ok(())}
#[derive(Default)]pub struct Heads{pub single:u32,pub multiple:u32}
pub trait Observer{fn observe_unlink(&mut self,_selector:u32,_registry:u32){}}
fn unlink(m:&mut BTreeMap<u32,Memory>,head:&mut u32,target:u32)->Result<(),Error>{let mut current=*head;let mut previous=0u32;let mut seen=BTreeSet::new();while current!=0{if !seen.insert(current){return Err(Error::CyclicList);}let next=read(m,current.wrapping_add(16))?;if current==target{if previous==0{*head=next;}else{write(m,previous.wrapping_add(16),&next.to_le_bytes())?;}return Ok(());}previous=current;current=next;}Ok(())}
/// Searches the borrowed native ordering: descending finite float word308,
/// followed by ascending/descending unsigned word312 depending byte14.
/// Duplicate matches use the native binary-search midpoint, then shift later
/// entries left while retaining the untouched final slot and padding.
pub fn remove(m:&mut BTreeMap<u32,Memory>,heads:&mut Heads,registry:u32,target:&Memory,selector:u32,observer:&mut impl Observer)->Result<bool,Error>{
 if target.reference==0||target.raw.len()<316{return Err(Error::InvalidAllocation);}let score=f32::from_bits(word(&target.raw,308));let key=word(&target.raw,312);
 let header=crate::audio_path_memory::read(m,registry,16)?.to_vec();let base=word(&header,0);let count=word(&header,4)as usize;let ascending=header[14]!=0;if count>i32::MAX as usize{return Err(Error::InvalidAllocation);}if count!=0{crate::audio_path_memory::read(m,base,count.checked_mul(4).ok_or(Error::InvalidAllocation)?)?;}
 let mut low=0i32;let mut high=count as i32-1;let mut matched=None;
 while low<=high{let mid=low+(high-low)/2;let reference=read(m,base.wrapping_add(mid as u32*4))?;let pair=if reference==target.reference{&target.raw[308..316]}else{crate::audio_path_memory::read(m,reference.wrapping_add(308),8)?};let other=f32::from_bits(word(pair,0));let other_key=word(pair,4);if !score.is_finite()||!other.is_finite(){return Err(Error::Backend("nonfinite native registration member is not qualified"));}
 if score>other||(score==other&&if ascending{key<other_key}else{key>other_key}){high=mid-1;}else if score<other||(score==other&&if ascending{key>other_key}else{key<other_key}){low=mid+1;}else{matched=Some(mid as usize);break;}}
 let remaining=if let Some(index)=matched{if index+1<count{let bytes=crate::audio_path_memory::read(m,base.wrapping_add((index+1)as u32*4),(count-index-1)*4)?.to_vec();write(m,base.wrapping_add(index as u32*4),&bytes)?;}write(m,registry.wrapping_add(4),&((count-1)as u32).to_le_bytes())?;count-1}else{count};
 if remaining==0{match selector{1=>{observer.observe_unlink(1,registry);unlink(m,&mut heads.single,registry)?;},2=>{observer.observe_unlink(2,registry);unlink(m,&mut heads.multiple,registry)?;},_=>{}}}Ok(matched.is_some())
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend(Vec<Value>);impl Observer for Backend{fn observe_unlink(&mut self,s:u32,r:u32){self.0.push(json!({"kind":if s==1{"reclaim_single"}else{"reclaim_multiple"},"registry":r}));}}
 #[test]fn audio_path_voice_registration_matches2160_native_compound_binary_search_duplicate_shift_tail_and_actual_global_list_unlink_cases(){let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_path_voice_registration_unlink_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],2160);for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut m:BTreeMap<u32,Memory>=[("registry",0x40008000),("table",0x40009000),("voices",0x40004000),("target",0x40007000),("sibling_a",0x4000a000),("sibling_b",0x4000b000)].into_iter().map(|(n,reference)|(reference,Memory{reference,raw:bytes(b[n].as_str().unwrap())})).collect();let target=m[&0x40007000].clone();let mut heads=Heads{single:b["single_head"].as_u64().unwrap()as u32,multiple:b["multiple_head"].as_u64().unwrap()as u32};let mut backend=Backend(vec![]);remove(&mut m,&mut heads,0x40008000,&target,row["selector"].as_u64().unwrap()as u32,&mut backend).unwrap();assert_eq!(json!(backend.0),row["calls"],"native unlink entry order {i}");let mut after=json!({"single_head":heads.single,"multiple_head":heads.multiple});for(n,r)in[("registry",0x40008000),("table",0x40009000),("voices",0x40004000),("target",0x40007000),("sibling_a",0x4000a000),("sibling_b",0x4000b000)]{after[n]=json!(hex(&m[&r].raw));}assert_eq!(after,row["after"],"all physical table/list/voice/padding bytes {i}");}}
}
