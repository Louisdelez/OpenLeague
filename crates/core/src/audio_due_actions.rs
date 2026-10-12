//! Native B07E50 due-action dequeue/recycle and ordered command retirement.
//! Concrete action virtual methods and playing-ID lifetime remain mandatory.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use std::collections::BTreeMap;
fn word(r:&[u8],o:usize)->u32{u32::from_le_bytes(r[o..o+4].try_into().unwrap())}
fn set(r:&mut[u8],o:usize,v:u32){r[o..o+4].copy_from_slice(&v.to_le_bytes());}
#[derive(Default)]
pub struct Runtime{pub nodes:BTreeMap<u32,Memory>,pub commands:BTreeMap<u32,Memory>,pub actions:BTreeMap<u32,Memory>}
pub trait Services{
 fn query(&mut self,runtime:&mut Runtime,action:u32,output:&mut[u8;68])->Result<(),Error>;
 fn execute(&mut self,runtime:&mut Runtime,context:&mut[u8;0x98],action:u32,command:u32)->Result<(),Error>;
 fn release_playing(&mut self,id:u32)->Result<(),Error>;
 fn release_action(&mut self,runtime:&mut Runtime,action:u32)->Result<(),Error>;
 fn destroy_command(&mut self,runtime:&mut Runtime,command:u32,flags:u32)->Result<(),Error>;
 fn free_pool(&mut self,pool:u32,memory:&Memory)->Result<(),Error>;
}
fn owned(map:&BTreeMap<u32,Memory>,reference:u32,size:usize)->Result<&Memory,Error>{let m=map.get(&reference).ok_or(Error::UnresolvedReference)?;if reference==0||m.reference!=reference||m.raw.len()<size{return Err(Error::InvalidAllocation);}Ok(m)}
impl Runtime{
 fn command_word(&self,reference:u32,offset:usize)->Result<u32,Error>{Ok(word(&owned(&self.commands,reference,offset+4)?.raw,offset))}
 /// Shares the common context's raw header. Re-read head/frame and command action
 /// references after callbacks, so concrete services can enqueue and mutate state.
 pub fn drain(&mut self,context:&mut[u8;0x98],processed:&mut u32,pool:u32,services:&mut impl Services)->Result<(),Error>{
  loop{
   let reference=word(context,0x44);if reference==0{return Ok(());}
   let node=owned(&self.nodes,reference,12)?;if word(&node.raw,4)>word(context,0x7c){return Ok(());}
   let command=word(&node.raw,8);let next=word(&node.raw,0);
   set(context,0x44,next);if reference==word(context,0x48){set(context,0x48,0);}
   set(&mut self.nodes.get_mut(&reference).unwrap().raw,0,word(context,0x4c));let count=word(context,0x58).wrapping_sub(1);set(context,0x58,count);set(context,0x4c,reference);
   let action=self.command_word(command,4)?;let a=owned(&self.actions,action,36)?;let kind=u16::from_le_bytes(a.raw[32..34].try_into().unwrap());
   let mut output=[0u8;68];if kind==0x403||(kind==0x503&&owned(&self.actions,action,153)?.raw[0x98]!=0){let action=self.command_word(command,4)?;services.query(self,action,&mut output)?;}
   let action=self.command_word(command,4)?;services.execute(self,context,action,command)?;
   let playing=self.command_word(command,40)?;if playing!=0{services.release_playing(playing)?;}
   let action=self.command_word(command,4)?;services.release_action(self,action)?;
   services.destroy_command(self,command,0)?;let memory=owned(&self.commands,command,44)?;services.free_pool(pool,memory)?;self.commands.remove(&command);
   *processed=processed.wrapping_add(1);
  }
 }
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 fn map(v:&Value)->BTreeMap<u32,Memory>{v.as_array().unwrap().iter().map(|e|{let reference=e["reference"].as_u64().unwrap()as u32;(reference,Memory{reference,raw:bytes(e["raw"].as_str().unwrap())})}).collect()}
 struct Backend{calls:Vec<Value>,freed:BTreeMap<u32,Memory>}
 impl Services for Backend{
  fn query(&mut self,_:&mut Runtime,action:u32,out:&mut[u8;68])->Result<(),Error>{assert_eq!(&out[..4],&[0;4]);out.fill(0x5a);self.calls.push(json!({"kind":"query","reference":action}));Ok(())}
  fn execute(&mut self,_:&mut Runtime,_:&mut[u8;0x98],action:u32,command:u32)->Result<(),Error>{self.calls.push(json!({"kind":"execute","reference":action,"command":command}));Ok(())}
  fn release_playing(&mut self,id:u32)->Result<(),Error>{self.calls.push(json!({"kind":"release_playing","reference":0x4000d000u32,"id":id}));Ok(())}
  fn release_action(&mut self,_:&mut Runtime,action:u32)->Result<(),Error>{self.calls.push(json!({"kind":"release","reference":action}));Ok(())}
  fn destroy_command(&mut self,_:&mut Runtime,command:u32,flags:u32)->Result<(),Error>{self.calls.push(json!({"kind":"destroy","reference":command,"flags":flags}));Ok(())}
  fn free_pool(&mut self,pool:u32,memory:&Memory)->Result<(),Error>{self.calls.push(json!({"kind":"free","pool":pool,"reference":memory.reference}));assert!(self.freed.insert(memory.reference,memory.clone()).is_none());Ok(())}
 }
 fn snapshot(context:&[u8;0x98],runtime:&Runtime,backend:&Backend,processed:u32)->Value{
  let nodes:Vec<Value>=runtime.nodes.values().map(|m|json!({"reference":m.reference,"raw":hex(&m.raw)})).collect();let actions:Vec<Value>=runtime.actions.values().map(|m|json!({"reference":m.reference,"raw":hex(&m.raw)})).collect();let mut commands:BTreeMap<u32,Memory>=runtime.commands.clone();commands.extend(backend.freed.clone());let commands:Vec<Value>=commands.values().map(|m|json!({"reference":m.reference,"raw":hex(&m.raw),"freed":backend.freed.contains_key(&m.reference)})).collect();json!({"common":hex(context),"nodes":nodes,"commands":commands,"actions":actions,"processed":processed})
 }
 #[test]fn audio_due_actions_matches1200_native_dequeue_recycle_unsigned_deadline_and_release_sequences(){
  let proof:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_due_actions_preparation.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],1200);
  for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut context: [u8;0x98]=bytes(b["common"].as_str().unwrap()).try_into().unwrap();let mut runtime=Runtime{nodes:map(&b["nodes"]),commands:map(&b["commands"]),actions:map(&b["actions"])};let mut processed=b["processed"].as_u64().unwrap()as u32;let mut backend=Backend{calls:vec![],freed:BTreeMap::new()};runtime.drain(&mut context,&mut processed,u32::MAX,&mut backend).unwrap();assert_eq!(snapshot(&context,&runtime,&backend,processed),row["after"],"all raw ownership bytes {i}");assert_eq!(json!(backend.calls),row["calls"],"ordered interfaces {i}");}
 }
}
