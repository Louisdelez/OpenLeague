//! Native fallback B262F0/B263E0/B26580/5EB4B0 and recorder B2F310.
//! Physical clock, aligned allocator and recording stream operations are mandatory.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};use std::collections::BTreeMap;
fn word(r:&[u8],o:usize)->u32{u32::from_le_bytes(r[o..o+4].try_into().unwrap())}
fn set(r:&mut[u8],o:usize,v:u32){r[o..o+4].copy_from_slice(&v.to_le_bytes());}
fn validate(m:&Memory)->Result<(),Error>{if m.reference==0||m.raw.len()!=44{return Err(Error::InvalidAllocation);}if word(&m.raw,0)!=0xff25b0{return Err(Error::Backend("unqualified fallback device class"));}Ok(())}
pub trait Services{
 fn tick(&mut self)->Result<u32,Error>;
 fn allocate_aligned(&mut self,pool:u32,size:u32,alignment:u32)->Result<Option<Memory>,Error>;
 fn free_pool(&mut self,pool:u32,memory:&Memory)->Result<(),Error>;
 fn write_recording(&mut self,stream:u32,recorder:&mut Memory)->Result<u32,Error>;
 fn close_recording(&mut self,stream:u32)->Result<(),Error>;
 /// Passive audit only. The owned configure body already zeroed every byte.
 fn observe_zero_buffer(&mut self,_memory:&Memory){}
}
#[derive(Debug,Default)]pub struct Runtime{pub buffers:BTreeMap<u32,Memory>,pub recorders:BTreeMap<u32,Memory>}
pub fn init(memory:&Memory)->Result<u32,Error>{validate(memory)?;Ok(1)}
pub fn quota(memory:&mut Memory,output:&mut u32,services:&mut impl Services)->Result<u32,Error>{
 validate(memory)?;let now=services.tick()?;let previous=word(&memory.raw,32);
 if now<previous{*output=1;set(&mut memory.raw,32,now);return Ok(1);}
 let period=word(&memory.raw,36);if period==0{return Err(Error::Backend("native fallback period0 arithmetic fault"));}
 *output=(now-previous)/period;if *output!=0{set(&mut memory.raw,32,now);}Ok(1)
}
impl Runtime{
 pub fn configure(&mut self,memory:&mut Memory,mask:u32,rate:u32,pool:u32,services:&mut impl Services)->Result<u32,Error>{
  validate(memory)?;let now=services.tick()?;set(&mut memory.raw,32,now);set(&mut memory.raw,8,mask);
  if rate==0{return Err(Error::Backend("unqualified zero fallback sample rate"));}
  // Exact truncation of1000/(unsigned sample_rate/1024), with binary constants.
  set(&mut memory.raw,36,1024000/rate);let channels=mask.count_ones();memory.raw[40..42].copy_from_slice(&((channels*2)as u16).to_le_bytes());let size=channels*4096;
  let Some(mut buffer)=services.allocate_aligned(pool,size,16)?else{return Ok(52);};if buffer.reference==0||buffer.reference%16!=0||buffer.raw.len()!=size as usize||self.buffers.contains_key(&buffer.reference){return Err(Error::InvalidAllocation);}
  buffer.raw.fill(0);services.observe_zero_buffer(&buffer);let reference=buffer.reference;self.buffers.insert(reference,buffer);set(&mut memory.raw,12,reference);set(&mut memory.raw,16,mask);set(&mut memory.raw,20,43);set(&mut memory.raw,24,1024);Ok(1)
 }
 fn release_recording(&mut self,reference:u32,pool:u32,services:&mut impl Services)->Result<(),Error>{
  let recorder=self.recorders.get_mut(&reference).ok_or(Error::UnresolvedReference)?;if recorder.reference!=reference||recorder.raw.len()!=56{return Err(Error::InvalidAllocation);}let stream=word(&recorder.raw,52);
  if stream!=0{let size=word(&recorder.raw,48);set(&mut recorder.raw,42,size);set(&mut recorder.raw,4,size.wrapping_add(38));services.write_recording(stream,recorder)?;let stream=word(&recorder.raw,52);if stream==0{return Err(Error::UnresolvedReference);}services.close_recording(stream)?;set(&mut recorder.raw,52,0);services.free_pool(pool,recorder)?;self.recorders.remove(&reference);}
  // Native recorder with no stream returns1 without freeing its descriptor.
  Ok(())
 }
 pub fn term(&mut self,memory:&mut Memory,device_pool:u32,recorder_pool:u32,services:&mut impl Services)->Result<(),Error>{
  validate(memory)?;let reference=word(&memory.raw,12);if reference!=0{let buffer=self.buffers.get(&reference).ok_or(Error::UnresolvedReference)?;services.free_pool(device_pool,buffer)?;self.buffers.remove(&reference);set(&mut memory.raw,12,0);}
  let reference=word(&memory.raw,4);if reference!=0{self.release_recording(reference,recorder_pool,services)?;set(&mut memory.raw,4,0);}Ok(())
 }
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{clock:u32,pattern:u8,failure:bool,record_status:u32,calls:Vec<Value>,freed:BTreeMap<u32,Memory>,streams:BTreeMap<u32,Memory>,allocated:Vec<u32>}
 impl Services for Backend{
  fn tick(&mut self)->Result<u32,Error>{self.calls.push(json!({"kind":"tick","value":self.clock}));Ok(self.clock)}
  fn allocate_aligned(&mut self,pool:u32,size:u32,alignment:u32)->Result<Option<Memory>,Error>{let reference=if self.failure{0}else{0x33000000};self.calls.push(json!({"kind":"allocate","method":"aligned","allocator":pool,"size":size,"alignment":alignment,"reference":reference}));if reference==0{return Ok(None);}self.allocated.push(reference);Ok(Some(Memory{reference,raw:vec![self.pattern;size as usize]}))}
  fn free_pool(&mut self,pool:u32,memory:&Memory)->Result<(),Error>{self.calls.push(json!({"kind":"free","method":"pool","allocator":pool,"reference":memory.reference}));assert!(self.freed.insert(memory.reference,memory.clone()).is_none());Ok(())}
  fn write_recording(&mut self,stream:u32,recorder:&mut Memory)->Result<u32,Error>{assert!(self.streams.contains_key(&stream));self.calls.push(json!({"kind":"recording_write","stream":stream,"reference":recorder.reference,"status":self.record_status}));Ok(self.record_status)}
  fn close_recording(&mut self,stream:u32)->Result<(),Error>{assert!(self.streams.contains_key(&stream));self.calls.push(json!({"kind":"recording_close","stream":stream}));Ok(())}
  fn observe_zero_buffer(&mut self,memory:&Memory){assert!(memory.raw.iter().all(|v|*v==0));self.calls.push(json!({"kind":"zero_buffer","reference":memory.reference,"size":memory.raw.len()}));}
 }
 fn snapshot(runtime:&Runtime,backend:&Backend,memory:&Memory,output:u32,refs:&[u32])->Value{
  let allocations:Vec<Value>=refs.iter().map(|r|{let m=backend.freed.get(r).or_else(||runtime.buffers.get(r)).or_else(||runtime.recorders.get(r)).or_else(||backend.streams.get(r)).unwrap();json!({"reference":r,"size":m.raw.len(),"freed":backend.freed.contains_key(r),"raw":hex(&m.raw)})}).collect();assert_eq!(runtime.buffers.len()+runtime.recorders.len()+backend.streams.len()+backend.freed.len(),refs.len());json!({"device":hex(&memory.raw),"output":output,"allocations":allocations})
 }
 fn replay(operation:&str,count:u32){let proof:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_fallback_device_preparation.json")).unwrap();assert_eq!(proof["passed"],true);assert_eq!(proof["case_count"],768);assert_eq!(proof["counts"][operation],count);
  for(i,row)in proof["cases"].as_array().unwrap().iter().enumerate().filter(|(_,r)|r["operation"]==operation){let b=&row["before"];let mut memory=Memory{reference:0x30009400,raw:bytes(b["device"].as_str().unwrap())};let mut output=b["output"].as_u64().unwrap()as u32;let mut runtime=Runtime::default();let mut backend=Backend{clock:row["clock"].as_u64().unwrap_or(0)as u32,pattern:row["pattern"].as_u64().unwrap()as u8,failure:row["allocation_failure"]==true,record_status:row["record_status"].as_u64().unwrap_or(1)as u32,calls:vec![],freed:BTreeMap::new(),streams:BTreeMap::new(),allocated:vec![]};let mut refs=vec![];for a in b["allocations"].as_array().unwrap(){let reference=a["reference"].as_u64().unwrap()as u32;refs.push(reference);let object=Memory{reference,raw:bytes(a["raw"].as_str().unwrap())};match reference{0x33000000=>{runtime.buffers.insert(reference,object);},0x30009600=>{runtime.recorders.insert(reference,object);},0x30009800=>{backend.streams.insert(reference,object);},_=>panic!("unexpected fixture reference")};}
   match operation{
    "configure"=>{assert_eq!(runtime.configure(&mut memory,row["mask"].as_u64().unwrap()as u32,row["rate"].as_u64().unwrap()as u32,u32::MAX,&mut backend).unwrap()as u64,row["result"].as_u64().unwrap(),"configure {i}");assert_eq!(init(&memory).unwrap()as u64,row["init_result"].as_u64().unwrap());},
    "quota"=>{let result=quota(&mut memory,&mut output,&mut backend);if row["native_arithmetic_fault"]==true{assert!(matches!(result,Err(Error::Backend("native fallback period0 arithmetic fault"))),"native DIV0 maps to explicit error {i}");}else{assert_eq!(result.unwrap()as u64,row["result"].as_u64().unwrap(),"quota {i}");}},
    "term"=>{for(step,expected)in row["steps"].as_array().unwrap().iter().enumerate(){backend.calls.clear();runtime.term(&mut memory,u32::MAX,u32::MAX,&mut backend).unwrap();assert_eq!(json!(backend.calls),expected["calls"],"term/recorder order {i}/{step}");assert_eq!(snapshot(&runtime,&backend,&memory,output,&refs),expected["after"],"all term/recorder bytes {i}/{step}");}continue;},_=>unreachable!()
   }
   refs.extend(backend.allocated.iter().copied());assert_eq!(json!(backend.calls),row["calls"],"physical order {i}");assert_eq!(snapshot(&runtime,&backend,&memory,output,&refs),row["after"],"all fallback bytes {i}");
  }
 }
 #[test]fn audio_fallback_configure_matches360_native_clock_mask_rate_allocation_and_init_cases(){replay("configure",360);}
 #[test]fn audio_fallback_quota_matches336_native_timer_wrap_boundary_and_arithmetic_fault_cases(){replay("quota",336);}
 #[test]fn audio_fallback_term_matches72_native_recording_release_and_repeated_lifetime_sequences(){replay("term",72);}
}
