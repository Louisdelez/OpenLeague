//! Actual B1B850 random path selection and prior-cycle history.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_frame_node_update::Runtime as Nodes,audio_timed_node_segment::Runtime as Paths};
use std::collections::BTreeMap;
fn word(r:&[u8],o:usize)->u32{u32::from_le_bytes(r[o..o+4].try_into().unwrap())}
fn set(r:&mut[u8],o:usize,v:u32){r[o..o+4].copy_from_slice(&v.to_le_bytes());}
#[derive(Default)]pub struct Runtime{pub masks:BTreeMap<u32,Memory>}
pub trait Observer{fn observe_random(&mut self,value:u16);}
impl Runtime{
 pub fn select(&mut self,nodes:&mut Nodes,paths:&mut Paths,reference:u32,observer:&mut impl Observer)->Result<bool,Error>{
  let n=nodes.nodes.get(&reference).ok_or(Error::UnresolvedReference)?;if reference==0||n.reference!=reference||n.raw.len()<96{return Err(Error::InvalidAllocation);}let count=u16::from_le_bytes(n.raw[18..20].try_into().unwrap())as usize;let mask=word(&n.raw,8);
  let mut completed=true;if count!=0{let m=self.masks.get(&mask).ok_or(Error::UnresolvedReference)?;if mask==0||m.reference!=mask||m.raw.len()<count{return Err(Error::InvalidAllocation);}completed=m.raw[..count].iter().all(|v|*v!=0);}
  if completed&&mask!=0&&count!=0{self.masks.get_mut(&mask).unwrap().raw[..count].fill(0);}
  let draw=paths.random.draw();observer.observe_random(draw);if count==0{return Err(Error::Backend("native path selection IDIV0"));}let index=draw as usize%count;let n=nodes.nodes.get_mut(&reference).unwrap();n.raw[16..18].copy_from_slice(&(index as u16).to_le_bytes());if n.raw[24]&2!=0{let descriptor=word(&n.raw,4).wrapping_add(index as u32*16);set(&mut n.raw,12,descriptor);}self.masks.get_mut(&mask).unwrap().raw[index]=1;Ok(completed)
 }
}
/// Adds the owned selection body to the existing concrete restart adapter.
pub struct Backend<'a,S>{pub selection:&'a mut Runtime,pub backend:&'a mut S}
struct Draw<'a,S>(&'a mut S);
impl<S:crate::audio_timed_node_segment::Services> Observer for Draw<'_,S>{fn observe_random(&mut self,value:u16){self.0.observe_random(value);}}
impl<S:crate::audio_timed_node_segment::Services+crate::audio_timed_node_restart::Services> crate::audio_timed_node_restart::Services for Backend<'_,S>{
 fn select_path(&mut self,nodes:&mut Nodes,paths:&mut Paths,reference:u32)->Result<bool,Error>{self.selection.select(nodes,paths,reference,&mut Draw(self.backend))}
 fn observe_restart(&mut self,reference:u32){self.backend.observe_restart(reference);}
}
impl<S:crate::audio_timed_node_segment::Services> crate::audio_timed_node_segment::Services for Backend<'_,S>{
 fn restart_path(&mut self,nodes:&mut Nodes,paths:&mut Paths,reference:u32)->Result<u32,Error>{self.backend.restart_path(nodes,paths,reference)}
 fn observe_random(&mut self,value:u16){self.backend.observe_random(value);}
 fn observe_node_update(&mut self,reference:u32,frame:u32){self.backend.observe_node_update(reference,frame);}
 fn observe_segment_advance(&mut self,reference:u32){self.backend.observe_segment_advance(reference);}
}
#[cfg(test)]mod tests{
 use super::*;use crate::audio_random::NativeRandom;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Draws(Vec<Value>);impl Observer for Draws{fn observe_random(&mut self,value:u16){self.0.push(json!({"kind":"rand","value":value}));}}
 fn initial(b:&Value)->(Nodes,Paths){(Nodes{reference:0,header:[0;12],table:Memory{reference:0,raw:vec![]},nodes:BTreeMap::from([(0x40006000,Memory{reference:0x40006000,raw:bytes(b["node"].as_str().unwrap())})])},Paths{descriptors:BTreeMap::new(),points:BTreeMap::new(),random:NativeRandom::seeded(b["rng_state"].as_u64().unwrap()as u32),interval:1024})}
 #[test]fn audio_timed_node_selection_matches144_native_history_sequences_and864_shared_rng_steps(){let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_timed_node_selection_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],144);assert_eq!(p["step_count"],864);for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let(mut nodes,mut paths)=initial(b);let mut selection=Runtime{masks:BTreeMap::from([(0x40007000,Memory{reference:0x40007000,raw:bytes(b["mask"].as_str().unwrap())})])};for(j,step)in row["steps"].as_array().unwrap().iter().enumerate(){let mut draws=Draws(vec![]);let completed=selection.select(&mut nodes,&mut paths,0x40006000,&mut draws).unwrap();assert_eq!(u32::from(completed),step["completed"].as_u64().unwrap()as u32,"completion {i}:{j}");assert_eq!(json!(draws.0),step["calls"],"draws {i}:{j}");assert_eq!(json!({"node":hex(&nodes.nodes[&0x40006000].raw),"mask":hex(&selection.masks[&0x40007000].raw),"rng_state":paths.random.state()}),step["after"],"all owned history bytes {i}:{j}");}}}
 #[test]fn audio_timed_node_selection_maps24_native_zero_count_and_unowned_mask_faults_with_exact_rng_effects(){let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_timed_node_selection_preparation.json")).unwrap();let cases=p["fault_cases"].as_array().unwrap();assert_eq!(cases.len(),24);for(i,row)in cases.iter().enumerate(){let(mut nodes,mut paths)=initial(&row["before"]);let mut selection=Runtime::default();let mut draws=Draws(vec![]);let error=selection.select(&mut nodes,&mut paths,0x40006000,&mut draws).unwrap_err();if row["mode"].as_str().unwrap().starts_with("zero"){assert_eq!(error,Error::Backend("native path selection IDIV0"));}else{assert_eq!(error,Error::UnresolvedReference);}assert_eq!(json!(draws.0),row["calls"],"fault draws {i}");assert_eq!(json!({"node":hex(&nodes.nodes[&0x40006000].raw),"rng_state":paths.random.state()}),row["after"],"fault state {i}");}}
}
