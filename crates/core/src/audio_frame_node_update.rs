//! Native B14140 live forward traversal and class1 timed-node dispatch.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use std::collections::BTreeMap;
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
pub struct Runtime{pub reference:u32,pub header:[u8;12],pub table:Memory,pub nodes:BTreeMap<u32,Memory>}
pub trait Services{
 /// Actual B1BD10 timed update is required; no success default is supplied.
 fn update_node(&mut self,runtime:&mut Runtime,reference:u32,frame:u32)->Result<(),Error>;
}
impl Runtime{
 fn bounds(&self)->Result<(u32,u32),Error>{let base=word(&self.header,0);let count=word(&self.header,4);let capacity=word(&self.header,8);if base!=self.table.reference||count>capacity||(capacity!=0&&base==0)||self.table.raw.len()<(capacity as usize).checked_mul(4).ok_or(Error::InvalidAllocation)?{return Err(Error::InvalidAllocation);}Ok((base,base.checked_add(count.checked_mul(4).ok_or(Error::InvalidAllocation)?).ok_or(Error::InvalidAllocation)?))}
 /// Reload live base/count after every node. The native cursor remains an absolute
 /// pointer, so unowned relocation/traversal is an explicit error, never skipped.
 pub fn update(&mut self,frame:u32,services:&mut impl Services)->Result<(),Error>{
  let(mut cursor,end)=self.bounds()?;if cursor==end{return Ok(());}
  loop{let(base,_)=self.bounds()?;let offset=cursor.checked_sub(base).ok_or(Error::UnresolvedReference)?as usize;if offset.checked_add(4).filter(|n|*n<=self.table.raw.len()).is_none(){return Err(Error::UnresolvedReference);}let reference=word(&self.table.raw,offset);let node=self.nodes.get(&reference).ok_or(Error::UnresolvedReference)?;if reference==0||node.reference!=reference||node.raw.len()<4{return Err(Error::InvalidAllocation);}if word(&node.raw,0)==1{services.update_node(self,reference,frame)?;}
   cursor=cursor.checked_add(4).ok_or(Error::InvalidAllocation)?;let(_,end)=self.bounds()?;if cursor==end{return Ok(());}
  }
 }
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{append:bool,did_append:bool,calls:Vec<Value>}
 impl Services for Backend{fn update_node(&mut self,runtime:&mut Runtime,reference:u32,frame:u32)->Result<(),Error>{self.calls.push(json!({"reference":reference,"frame":frame}));if self.append&&!self.did_append{let count=word(&runtime.header,4)as usize;runtime.table.raw[count*4..count*4+4].copy_from_slice(&0x40008240u32.to_le_bytes());runtime.header[4..8].copy_from_slice(&(count as u32+1).to_le_bytes());self.did_append=true;}Ok(())}}
 #[test]fn audio_frame_node_update_matches180_native_class1_filter_live_count_and_append_sequences(){
  let proof:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_frame_node_update_preparation.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],180);
  for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut runtime=Runtime{reference:0x40006000,header:bytes(b["header"].as_str().unwrap()).try_into().unwrap(),table:Memory{reference:0x40007000,raw:bytes(b["table"].as_str().unwrap())},nodes:b["objects"].as_array().unwrap().iter().map(|e|{let reference=e["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(e["raw"].as_str().unwrap())})}).collect()};let mut backend=Backend{append:row["append"]==1,did_append:false,calls:vec![]};runtime.update(row["frame"].as_u64().unwrap()as u32,&mut backend).unwrap();assert_eq!(json!(backend.calls),row["calls"],"calls {i}");let nodes:Vec<Value>=runtime.nodes.values().map(|m|json!({"reference":m.reference,"raw":hex(&m.raw)})).collect();assert_eq!(json!({"header":hex(&runtime.header),"table":hex(&runtime.table.raw),"objects":nodes}),row["after"],"owned bytes {i}");}
 }
}
