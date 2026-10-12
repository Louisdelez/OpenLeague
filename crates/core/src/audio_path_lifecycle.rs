//! Native108-byte B1B480 construction and B1BCA0 allocation retirement.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_frame_node_update::Runtime as Nodes,audio_timed_node_update::Runtime as Bindings,audio_timed_node_selection::Runtime as Selection};
use std::collections::BTreeMap;
fn word(r:&[u8],o:usize)->u32{u32::from_le_bytes(r[o..o+4].try_into().unwrap())}
fn set(r:&mut[u8],o:usize,v:u32){r[o..o+4].copy_from_slice(&v.to_le_bytes());}
fn owned(m:&BTreeMap<u32,Memory>,reference:u32)->Result<&Memory,Error>{let v=m.get(&reference).ok_or(Error::UnresolvedReference)?;if reference==0||v.reference!=reference{return Err(Error::InvalidAllocation);}Ok(v)}
pub fn construct(mut memory:Memory)->Result<Memory,Error>{if memory.reference==0||memory.raw.len()<108{return Err(Error::InvalidAllocation);}for o in [32,36,40,24,48,52,56,68,96,100,104,0,4,8,12]{set(&mut memory.raw,o,0);}for o in [18,28,44]{memory.raw[o..o+2].fill(0);}Ok(memory)}
#[derive(Default)]pub struct Runtime{pub auxiliary:BTreeMap<u32,Memory>}
pub trait Services{
 fn release(&mut self,pool:u32,allocation:&Memory)->Result<(),Error>;
 /// Passive view of the caller's state immediately before physical release.
 fn observe_release(&mut self,_node:&[u8]){}
}
impl Runtime{
 pub fn retire(&mut self,nodes:&mut Nodes,bindings:&mut Bindings,selection:&mut Selection,reference:u32,pool:u32,services:&mut impl Services)->Result<(),Error>{
  let n=nodes.nodes.get_mut(&reference).ok_or(Error::UnresolvedReference)?;if reference==0||n.reference!=reference||n.raw.len()<108{return Err(Error::InvalidAllocation);}set(&mut n.raw,0,0);let table=word(&n.raw,32);
  if table!=0{set(&mut n.raw,36,0);let m=owned(&bindings.tables,table)?;services.observe_release(&n.raw);services.release(pool,m)?;bindings.tables.remove(&table);set(&mut n.raw,32,0);set(&mut n.raw,40,0);}
  if n.raw[24]&2!=0{let mask=word(&n.raw,8);if mask!=0{let m=owned(&selection.masks,mask)?;services.observe_release(&n.raw);services.release(pool,m)?;selection.masks.remove(&mask);set(&mut n.raw,8,0);}}
  let aux=word(&n.raw,104);if aux!=0{let m=owned(&self.auxiliary,aux)?;services.observe_release(&n.raw);services.release(pool,m)?;self.auxiliary.remove(&aux);}
  // Native leaves auxiliary pointer104 unchanged. Ownership is retired, so a
  // repeated release of that dangling reference returns an explicit error.
  Ok(())
 }
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{calls:Vec<Value>,freed:BTreeMap<u32,Memory>,order:Vec<u32>,node:Vec<u8>}
 impl Services for Backend{fn observe_release(&mut self,node:&[u8]){self.node=node.to_vec();}fn release(&mut self,pool:u32,allocation:&Memory)->Result<(),Error>{if self.freed.contains_key(&allocation.reference){return Err(Error::InvalidAllocation);}self.calls.push(json!({"kind":"free","pool":pool,"reference":allocation.reference,"node_at_call":hex(&self.node)}));self.order.push(allocation.reference);self.freed.insert(allocation.reference,Memory{reference:allocation.reference,raw:allocation.raw.clone()});Ok(())}}
 #[test]fn audio_path_lifecycle_matches35_native108byte_construction_and_ordered_ownership_retirement_cases(){let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_lifecycle_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],35);for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let node=Memory{reference:0x40006000,raw:bytes(b["node"].as_str().unwrap())};let mut nodes=Nodes{reference:0,header:[0;12],table:Memory{reference:0,raw:vec![]},nodes:BTreeMap::from([(node.reference,node)])};let mut bindings=Bindings{tables:BTreeMap::from([(0x40007000,Memory{reference:0x40007000,raw:bytes(b["table"].as_str().unwrap())})]),..Bindings::default()};let mut selection=Selection{masks:BTreeMap::from([(0x40008000,Memory{reference:0x40008000,raw:bytes(b["mask"].as_str().unwrap())})])};let mut lifecycle=Runtime{auxiliary:BTreeMap::from([(0x40009000,Memory{reference:0x40009000,raw:bytes(b["aux"].as_str().unwrap())})])};let mut backend=Backend{calls:vec![],freed:BTreeMap::new(),order:vec![],node:vec![]};if row["kind"]=="construct"{let m=nodes.nodes.remove(&0x40006000).unwrap();nodes.nodes.insert(0x40006000,construct(m).unwrap());}else{lifecycle.retire(&mut nodes,&mut bindings,&mut selection,0x40006000,17,&mut backend).unwrap();}assert_eq!(json!(backend.calls),row["calls"],"ordered release and intermediate caller bytes {i}");let table=backend.freed.get(&0x40007000).or_else(||bindings.tables.get(&0x40007000)).unwrap();let mask=backend.freed.get(&0x40008000).or_else(||selection.masks.get(&0x40008000)).unwrap();let aux=backend.freed.get(&0x40009000).or_else(||lifecycle.auxiliary.get(&0x40009000)).unwrap();assert_eq!(json!({"node":hex(&nodes.nodes[&0x40006000].raw),"table":hex(&table.raw),"mask":hex(&mask.raw),"aux":hex(&aux.raw),"freed":backend.order}),row["after"],"all bytes and retired ownership {i}");}}
}
