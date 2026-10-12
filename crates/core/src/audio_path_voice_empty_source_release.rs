//! Native AFE9C0 source owner release, B01360 parent-table removal and AFDE90
//! ordered buffer destruction. Retired regions are physical snapshots only.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
fn word(b:&[u8],o:usize)->u32{u32::from_le_bytes(b[o..o+4].try_into().unwrap())}
fn read(m:&BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,r:u32)->Result<u32,Error>{if dead.iter().any(|b|r>=*b&&m.get(b).map(|v|r.wrapping_sub(*b)<v.raw.len()as u32).unwrap_or(r==*b)){return Err(Error::UnresolvedReference);}Ok(word(crate::audio_path_memory::read(m,r,4)?,0))}
fn write(m:&mut BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,r:u32,v:u32)->Result<(),Error>{read(m,dead,r)?;let base=*m.range(..=r).next_back().ok_or(Error::UnresolvedReference)?.0;let offset=r.wrapping_sub(base)as usize;m.get_mut(&base).unwrap().raw[offset..offset+4].copy_from_slice(&v.to_le_bytes());Ok(())}
pub trait Services{
 fn free(&mut self,pool:u32,reference:u32,memory:&mut BTreeMap<u32,Memory>)->Result<(),Error>;
 fn observe_parent_removal(&mut self,_parent:u32,_source:u32){}
 fn observe_empty_source_release(&mut self,_source:u32,_memory:&BTreeMap<u32,Memory>){}
}
fn free(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,pool:u32,r:u32,s:&mut impl Services)->Result<(),Error>{if dead.contains(&r){return Err(Error::UnresolvedReference);}s.free(pool,r,m)?;dead.insert(r);Ok(())}
/// Original first matching source is replaced with the final retained slot.
pub fn remove_parent(m:&mut BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,parent:u32,source:u32,s:&mut impl Services)->Result<(),Error>{
 s.observe_parent_removal(parent,source);let owner=read(m,dead,parent.wrapping_add(28))?;if owner==0{return Ok(());}let base=read(m,dead,owner.wrapping_add(36))?;let count=read(m,dead,owner.wrapping_add(40))?as usize;if count==0{return Ok(());}let size=count.checked_mul(4).ok_or(Error::InvalidAllocation)?;crate::audio_path_memory::read(m,base,size)?;
 for i in 0..count{if read(m,dead,base.wrapping_add(i as u32*4))?==source{if count>1{let last=read(m,dead,base.wrapping_add((count-1)as u32*4))?;write(m,dead,base.wrapping_add(i as u32*4),last)?;}write(m,dead,owner.wrapping_add(40),(count-1)as u32)?;break;}}Ok(())
}
/// Actual AFDE90 and physical owner release, shared by empty and terminal source destruction.
pub fn destroy_owner(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,owner:u32,pool:u32,s:&mut impl Services)->Result<(),Error>{
 // AFDE90 clears the count before free and pointer/capacity after free.
 let allocation=read(m,dead,owner.wrapping_add(16))?;if allocation!=0{write(m,dead,owner.wrapping_add(20),0)?;free(m,dead,pool,allocation,s)?;write(m,dead,owner.wrapping_add(16),0)?;write(m,dead,owner.wrapping_add(24),0)?;}
 write(m,dead,owner.wrapping_add(12),0)?;
 for(pointer,count,capacity)in[(0,4,8),(36,40,44)]{let allocation=read(m,dead,owner.wrapping_add(pointer))?;if allocation!=0{write(m,dead,owner.wrapping_add(count),0)?;free(m,dead,pool,allocation,s)?;write(m,dead,owner.wrapping_add(pointer),0)?;write(m,dead,owner.wrapping_add(capacity),0)?;}}
 free(m,dead,pool,owner,s)?;
 Ok(())
}
pub fn release(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,source:u32,pool:u32,s:&mut impl Services)->Result<(),Error>{
 if read(m,dead,source.wrapping_add(28))?!=0{
 for offset in [32,36]{let parent=read(m,dead,source.wrapping_add(offset))?;if parent!=0{remove_parent(m,dead,parent,source,s)?;}}
 let wrapper=read(m,dead,source.wrapping_add(56))?;if wrapper!=0{let parent=read(m,dead,wrapper)?;if parent!=0{remove_parent(m,dead,parent,source,s)?;}}
 }
 let owner=read(m,dead,source.wrapping_add(28))?;
 if owner!=0{
 destroy_owner(m,dead,owner,pool,s)?;
 }
 write(m,dead,source.wrapping_add(28),0)?;Ok(())
}
struct NativeRelease<'a,S>{dead:&'a mut BTreeSet<u32>,pool:u32,services:&'a mut S}
impl<S:Services> crate::audio_path_voice_source_removal::Services for NativeRelease<'_,S>{fn release_empty_source(&mut self,source:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.services.observe_empty_source_release(source,m);release(m,self.dead,source,self.pool,self.services)}}
/// Actual source list removal and empty-owner destruction compose without
/// replacing the AFE9C0 call with a no-op or independently owned memory clone.
pub fn remove_releasing(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,source:u32,target:u32,voice:Option<&Memory>,pool:u32,s:&mut impl Services)->Result<(),Error>{if dead.contains(&source){return Err(Error::UnresolvedReference);}crate::audio_path_voice_source_removal::remove(m,source,target,voice,&mut NativeRelease{dead,pool,services:s})}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{calls:Vec<Value>,freed:BTreeSet<u32>}
 impl Services for Backend{
 fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{assert!(self.freed.insert(r));self.calls.push(json!({"kind":"free","pool":p,"reference":r,"source_at_call":hex(&m[&0x40004000].raw),"owner_at_call":hex(&m[&0x40005000].raw)}));Ok(())}
 fn observe_parent_removal(&mut self,p:u32,s:u32){self.calls.push(json!({"kind":"remove_parent_source","parent":p,"source":s}));}
 fn observe_empty_source_release(&mut self,s:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"release_empty_source","source":s,"owner_at_call":hex(&m[&0x40005000].raw)}));}
 }
 fn replay(p:Value,composed:bool){assert_eq!(p["passed"],true);assert_eq!(p["case_count"],if composed{192}else{64});for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut m:BTreeMap<u32,Memory>=[("source",0x40004000),("owner",0x40005000),("wrapper",0x40007000)].into_iter().map(|(n,reference)|(reference,Memory{reference,raw:bytes(b[n].as_str().unwrap())})).collect();for name in ["parents","parent_owners","tables","buffers"]{for v in b[name].as_array().unwrap(){let reference=v["reference"].as_u64().unwrap()as u32;m.insert(reference,Memory{reference,raw:bytes(v["raw"].as_str().unwrap())});}}
 let mut dead=BTreeSet::new();let mut backend=Backend{calls:vec![],freed:BTreeSet::new()};if composed{remove_releasing(&mut m,&mut dead,0x40004000,0x40004600,None,19,&mut backend).unwrap();}else{release(&mut m,&mut dead,0x40004000,19,&mut backend).unwrap();}assert_eq!(json!(backend.calls),row["calls"],"ordered parent operations/frees and exact states {i}");assert_eq!(json!(backend.freed.iter().copied().collect::<Vec<_>>()),row["freed"],"physical freed set {i}");assert_eq!(dead,backend.freed);let mut after=json!({"source":hex(&m[&0x40004000].raw),"owner":hex(&m[&0x40005000].raw),"wrapper":hex(&m[&0x40007000].raw)});for name in ["parents","parent_owners","tables","buffers"]{after[name]=json!(b[name].as_array().unwrap().iter().map(|v|{let r=v["reference"].as_u64().unwrap()as u32;json!({"reference":r,"raw":hex(&m[&r].raw)})}).collect::<Vec<_>>());}assert_eq!(after,row["after"],"all physical source/owner/parent/tail/padding bytes {i}");if dead.contains(&0x40005000){assert_eq!(read(&m,&dead,0x40005000),Err(Error::UnresolvedReference));}
 }}
 #[test]fn audio_path_voice_empty_source_release_matches64_native_actual_parent_swap_last_owner_buffer_free_order_padding_and_snapshots(){replay(serde_json::from_str(include_str!("../../../data/4.20/audio_path_voice_empty_source_release_preparation.json")).unwrap(),false);}
 #[test]fn audio_path_voice_empty_source_release_matches192_native_actual_source_removal_empty_gates_parent_cleanup_and_physical_lifetime_cases(){replay(serde_json::from_str(include_str!("../../../data/4.20/audio_path_voice_source_empty_release_composition_preparation.json")).unwrap(),true);}
}
