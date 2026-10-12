//! Native B1B510 restart/sequence rules. B1B850 random selection stays mandatory.
use crate::{audio_bus_bank::Error,audio_frame_node_update::Runtime as Nodes,audio_timed_node_segment::Runtime as Paths};
fn word(r:&[u8],o:usize)->u32{u32::from_le_bytes(r[o..o+4].try_into().unwrap())}
fn set(r:&mut[u8],o:usize,v:u32){r[o..o+4].copy_from_slice(&v.to_le_bytes());}
pub trait Services{
 fn select_path(&mut self,nodes:&mut Nodes,paths:&mut Paths,reference:u32)->Result<bool,Error>;
 fn observe_restart(&mut self,_reference:u32){}
}
pub fn restart(nodes:&mut Nodes,paths:&mut Paths,reference:u32,services:&mut impl Services)->Result<u32,Error>{
 services.observe_restart(reference);let n=nodes.nodes.get(&reference).ok_or(Error::UnresolvedReference)?;if reference==0||n.reference!=reference||n.raw.len()<96{return Err(Error::InvalidAllocation);}let descriptor=word(&n.raw,12);if descriptor==0{return Ok(17);}let flags=word(&n.raw,24);
 let completed=if flags&1!=0{services.select_path(nodes,paths,reference)?}else{let n=nodes.nodes.get_mut(&reference).unwrap();let index=u16::from_le_bytes(n.raw[16..18].try_into().unwrap()).wrapping_add(1);n.raw[16..18].copy_from_slice(&index.to_le_bytes());let limit=u16::from_le_bytes(n.raw[18..20].try_into().unwrap());if index<limit{if flags&2!=0{set(&mut n.raw,12,descriptor.wrapping_add(16));}false}else{if flags&2!=0{let base=word(&n.raw,4);set(&mut n.raw,12,base);}n.raw[16..18].fill(0);true}};
 let n=nodes.nodes.get_mut(&reference).ok_or(Error::UnresolvedReference)?;if n.raw.len()<96{return Err(Error::InvalidAllocation);}if n.raw[24]&2==0||(completed&&n.raw[29]==0){return Ok(17);}n.raw[20..22].fill(0);Ok(1)
}
pub struct Backend<'a,S>{pub backend:&'a mut S}
impl<S:Services+crate::audio_timed_node_segment::Services> crate::audio_timed_node_segment::Services for Backend<'_,S>{
 fn restart_path(&mut self,nodes:&mut Nodes,paths:&mut Paths,reference:u32)->Result<u32,Error>{restart(nodes,paths,reference,self.backend)}
 fn observe_random(&mut self,value:u16){crate::audio_timed_node_segment::Services::observe_random(self.backend,value);}
 fn observe_node_update(&mut self,reference:u32,frame:u32){crate::audio_timed_node_segment::Services::observe_node_update(self.backend,reference,frame);}
 fn observe_segment_advance(&mut self,reference:u32){crate::audio_timed_node_segment::Services::observe_segment_advance(self.backend,reference);}
}
#[cfg(test)]mod tests{
 use super::*;use crate::{audio_plugin_factory::Memory,audio_random::NativeRandom};use std::collections::BTreeMap;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Selection{completed:bool,calls:Vec<Value>}
 impl Services for Selection{fn select_path(&mut self,nodes:&mut Nodes,_:&mut Paths,reference:u32)->Result<bool,Error>{self.calls.push(json!({"kind":"select_path","reference":reference,"completed":u32::from(self.completed)}));let n=nodes.nodes.get_mut(&reference).unwrap();set(&mut n.raw,12,0x40007400);n.raw[16..18].copy_from_slice(&0x1234u16.to_le_bytes());Ok(self.completed)}}
 #[test]fn audio_timed_node_restart_matches1152_native_flags_cursors_sequence_selection_and_loop_cases(){let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_timed_node_restart_preparation.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],1152);for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){let mut nodes=Nodes{reference:0,header:[0;12],table:Memory{reference:0,raw:vec![]},nodes:BTreeMap::from([(0x40006000,Memory{reference:0x40006000,raw:bytes(row["before"].as_str().unwrap())})])};let mut paths=Paths{descriptors:BTreeMap::new(),points:BTreeMap::new(),random:NativeRandom::seeded(0),interval:1024};let mut backend=Selection{completed:row["completed"]==1,calls:vec![]};let result=restart(&mut nodes,&mut paths,0x40006000,&mut backend).unwrap();assert_eq!(result as u64,row["result"].as_u64().unwrap(),"result {i}");assert_eq!(hex(&nodes.nodes[&0x40006000].raw),row["after"].as_str().unwrap(),"raw state {i}");assert_eq!(json!(backend.calls),row["calls"],"selection interface {i}");}}
}
