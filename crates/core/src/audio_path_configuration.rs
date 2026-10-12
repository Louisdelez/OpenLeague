//! Native B1B9A0 path configuration, B1B4E0 history initialization and real selection.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_frame_node_update::Runtime as Nodes,audio_timed_node_segment::Runtime as Paths,audio_timed_node_selection::{Runtime as Selection,Observer}};
fn word(r:&[u8],o:usize)->u32{u32::from_le_bytes(r[o..o+4].try_into().unwrap())}
fn set(r:&mut[u8],o:usize,v:u32){r[o..o+4].copy_from_slice(&v.to_le_bytes());}
pub trait Services:Observer{
 /// Physical allocation remains mandatory. None means native null allocation.
 fn allocate_history(&mut self,pool:u32,bytes:u32)->Result<Option<Memory>,Error>;
}
pub struct Configuration{pub descriptors:u32,pub count:u32,pub flags:u32,pub loop_byte:u8,pub state:[u8;8],pub pool:u32}
pub fn configure(nodes:&mut Nodes,paths:&mut Paths,selection:&mut Selection,reference:u32,input:&Configuration,services:&mut impl Services)->Result<u32,Error>{
 let n=nodes.nodes.get_mut(&reference).ok_or(Error::UnresolvedReference)?;
 if reference==0||n.reference!=reference||n.raw.len()<96{return Err(Error::InvalidAllocation);}
 if word(&n.raw,0)!=0{return Ok(2);}
 n.raw[29]=input.loop_byte;set(&mut n.raw,4,input.descriptors);n.raw[18..20].copy_from_slice(&(input.count as u16).to_le_bytes());set(&mut n.raw,24,input.flags);
 let reused=word(&input.state,4);
 if reused!=0{set(&mut n.raw,8,reused);let index=u16::from_le_bytes(input.state[..2].try_into().unwrap());n.raw[16..18].copy_from_slice(&index.to_le_bytes());set(&mut n.raw,12,input.descriptors.wrapping_add(index as u32*16));return Ok(1);}
 set(&mut n.raw,12,input.descriptors);n.raw[16..18].fill(0);
 let allocation=services.allocate_history(input.pool,input.count)?;
 let Some(mut mask)=allocation else{set(&mut n.raw,8,0);return Ok(2);};
 set(&mut n.raw,8,mask.reference);
 if mask.reference==0||mask.raw.len()<input.count as usize||selection.masks.contains_key(&mask.reference){return Err(Error::InvalidAllocation);}
 // Native B1B4E0 clears only the u16 count, preserving allocation remainder.
 mask.raw[..input.count as u16 as usize].fill(0);selection.masks.insert(mask.reference,mask);
 if input.flags&1!=0{selection.select(nodes,paths,reference,services)?;}
 Ok(1)
}
/// B142D0 rejects empty resource descriptors before touching the node.
pub fn configure_guarded(nodes:&mut Nodes,paths:&mut Paths,selection:&mut Selection,reference:u32,input:&Configuration,services:&mut impl Services)->Result<u32,Error>{
 if input.descriptors==0||input.count==0{return Ok(31);}
 configure(nodes,paths,selection,reference,input,services)
}
/// B1B3C0 reads resource flags, descriptor ownership and bit5 loop state.
pub fn from_resource(resource:&Memory,state:[u8;8],pool:u32)->Result<Configuration,Error>{
 if resource.reference==0||resource.raw.len()<57{return Err(Error::InvalidAllocation);}
 Ok(Configuration{descriptors:word(&resource.raw,48),count:word(&resource.raw,52),flags:word(&resource.raw,32),loop_byte:(resource.raw[56]>>5)&1,state,pool})
}
#[cfg(test)]mod tests{
 use super::*;use std::collections::BTreeMap;use serde_json::{Value,json};use crate::audio_random::NativeRandom;
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{failure:bool,allocation:Vec<u8>,calls:Vec<Value>}
 impl Observer for Backend{fn observe_random(&mut self,value:u16){self.calls.push(json!({"kind":"rand","value":value}));}}
 impl Services for Backend{fn allocate_history(&mut self,pool:u32,bytes:u32)->Result<Option<Memory>,Error>{self.calls.push(json!({"kind":"allocate","pool":pool,"bytes":bytes,"reference":if self.failure{0}else{0x40008000u32}}));Ok(if self.failure{None}else{Some(Memory{reference:0x40008000,raw:self.allocation.clone()})})}}
 #[test]fn audio_path_configuration_matches776_native_allocation_reuse_failure_full_count_and_history_cases(){
 let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_configuration_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],776);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut nodes=Nodes{reference:0,header:[0;12],table:Memory{reference:0,raw:vec![]},nodes:BTreeMap::from([(0x40006000,Memory{reference:0x40006000,raw:bytes(b["node"].as_str().unwrap())})])};let mut paths=Paths{descriptors:BTreeMap::new(),points:BTreeMap::new(),random:NativeRandom::seeded(b["rng_state"].as_u64().unwrap()as u32),interval:1024};let mut selection=Selection::default();let state:[u8;8]=bytes(b["state"].as_str().unwrap()).try_into().unwrap();let mut services=Backend{failure:row["mode"]=="failure",allocation:bytes(b["mask"].as_str().unwrap()),calls:vec![]};
 let result=configure(&mut nodes,&mut paths,&mut selection,0x40006000,&Configuration{descriptors:0x40007000,count:row["count"].as_u64().unwrap()as u32,flags:row["flags"].as_u64().unwrap()as u32,loop_byte:row["loop"].as_u64().unwrap()as u8,state,pool:17},&mut services).unwrap();assert_eq!(result,row["result"].as_u64().unwrap()as u32,"status {i}");assert_eq!(json!(services.calls),row["calls"],"calls {i}");let mask=selection.masks.get(&0x40008000).map(|m|m.raw.as_slice()).unwrap_or(&services.allocation);assert_eq!(json!({"node":hex(&nodes.nodes[&0x40006000].raw),"mask":hex(mask),"state":hex(&state),"rng_state":paths.random.state()}),row["after"],"all bytes {i}");
 }
 }
 #[test]fn audio_path_resource_configuration_matches792_native_caller_flags_loop_and_empty_guards(){
 let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_resource_configuration_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],792);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut nodes=Nodes{reference:0,header:[0;12],table:Memory{reference:0,raw:vec![]},nodes:BTreeMap::from([(0x40006000,Memory{reference:0x40006000,raw:bytes(b["node"].as_str().unwrap())})])};let mut paths=Paths{descriptors:BTreeMap::new(),points:BTreeMap::new(),random:NativeRandom::seeded(b["rng_state"].as_u64().unwrap()as u32),interval:1024};let mut selection=Selection::default();let state:[u8;8]=bytes(b["state"].as_str().unwrap()).try_into().unwrap();let mut services=Backend{failure:row["mode"]=="failure",allocation:bytes(b["mask"].as_str().unwrap()),calls:vec![]};
 let result=configure_guarded(&mut nodes,&mut paths,&mut selection,0x40006000,&from_resource(&Memory{reference:0x40004000,raw:bytes(b["resource"].as_str().unwrap())},state,17).unwrap(),&mut services).unwrap();assert_eq!(result,row["result"].as_u64().unwrap()as u32,"status {i}");assert_eq!(json!(services.calls),row["calls"],"calls {i}");let mask=selection.masks.get(&0x40008000).map(|m|m.raw.as_slice()).unwrap_or(&services.allocation);assert_eq!(json!({"node":hex(&nodes.nodes[&0x40006000].raw),"mask":hex(mask),"state":hex(&state),"rng_state":paths.random.state(),"resource":b["resource"]}),row["after"],"all bytes {i}");
 }
 }
 #[test]fn audio_path_resource_configuration_matches48_native_empty_guards_before_absent_node_dereference(){
 let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_resource_configuration_guard_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],48);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut nodes=Nodes{reference:0,header:[0;12],table:Memory{reference:0,raw:vec![]},nodes:BTreeMap::new()};let mut paths=Paths{descriptors:BTreeMap::new(),points:BTreeMap::new(),random:NativeRandom::seeded(17),interval:1024};let mut selection=Selection::default();let resource=Memory{reference:0x40004000,raw:bytes(b["resource"].as_str().unwrap())};let state:[u8;8]=bytes(b["state"].as_str().unwrap()).try_into().unwrap();let mut services=Backend{failure:false,allocation:vec![],calls:vec![]};let input=from_resource(&resource,state,17).unwrap();assert_eq!(configure_guarded(&mut nodes,&mut paths,&mut selection,row["node_reference"].as_u64().unwrap()as u32,&input,&mut services).unwrap(),31,"guard status {i}");assert_eq!(json!(services.calls),row["calls"]);assert!(nodes.nodes.is_empty()&&selection.masks.is_empty()&&paths.points.is_empty()&&paths.descriptors.is_empty());assert_eq!(hex(&resource.raw),b["resource"].as_str().unwrap());assert_eq!(hex(&input.state),b["state"].as_str().unwrap());assert_eq!(paths.random.state(),17);assert_eq!(row["after"],row["before"],"native no mutation {i}");}
 }
}
