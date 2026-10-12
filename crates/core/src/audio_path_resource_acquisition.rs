//! AF0640 acquisition and B1B0F0 constructor of the 72-byte path resource.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_path_resource::Services};
fn word(b:&[u8],o:usize)->u32{u32::from_le_bytes(b[o..o+4].try_into().unwrap())}
fn set(b:&mut[u8],o:usize,v:u32){b[o..o+4].copy_from_slice(&v.to_le_bytes());}
pub fn acquire(owner:&mut Memory,resource:&mut Memory,pool:u32,defaults:[u32;3],services:&mut impl Services)->Result<u32,Error>{
 if owner.reference==0||owner.raw.len()<72{return Err(Error::InvalidAllocation);}
 if word(&owner.raw,68)!=0{return Ok(1);}
 owner.raw[47]|=0x10;
 let Some(mut allocated)=services.allocate(pool,72)?else{return Ok(52);};
 if allocated.reference==0||allocated.raw.len()!=72{return Err(Error::InvalidAllocation);}
 set(&mut allocated.raw,0,0xff174c);set(&mut allocated.raw,60,0);
 let flags=((allocated.raw[56]&0xde)|8)&0xf9;allocated.raw[56]=flags|0x10;
 for offset in [4,8,12,16,32,36,40,44,48,52]{set(&mut allocated.raw,offset,0);}
 for(i,value)in defaults.iter().enumerate(){set(&mut allocated.raw,20+i*4,*value);}
 set(&mut allocated.raw,0,0xff0d28);set(&mut allocated.raw,64,0);set(&mut allocated.raw,68,0);set(&mut allocated.raw,4,word(&owner.raw,8));
 set(&mut owner.raw,68,allocated.reference);*resource=allocated;Ok(1)
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{json,Value};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{pattern:u8,failure:bool,calls:Vec<Value>}
 impl Services for Backend{fn allocate(&mut self,pool:u32,size:u32)->Result<Option<Memory>,Error>{let reference=if self.failure{0}else{0x40005000};self.calls.push(json!({"kind":"allocate","pool":pool,"bytes":size,"reference":reference}));Ok(if self.failure{None}else{Some(Memory{reference,raw:vec![self.pattern;size as usize]})})}fn free(&mut self,_:u32,_:&Memory)->Result<(),Error>{Err(Error::Backend("unexpected free during acquisition"))}}
 #[test]fn audio_path_resource_acquisition_matches72_native_cached_oom_constructor_defaults_identity_and_publication_cases(){let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_resource_acquisition_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],72);for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut owner=Memory{reference:0x40004000,raw:bytes(b["owner"].as_str().unwrap())};let mut resource=Memory{reference:0x40005000,raw:bytes(b["resource"].as_str().unwrap())};let mut backend=Backend{pattern:row["pattern"].as_u64().unwrap()as u8,failure:row["failure"].as_bool().unwrap(),calls:vec![]};let defaults:[u32;3]=row["defaults"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect::<Vec<_>>().try_into().unwrap();assert_eq!(acquire(&mut owner,&mut resource,17,defaults,&mut backend).unwrap(),row["result"].as_u64().unwrap()as u32,"status {i}");assert_eq!(json!(backend.calls),row["calls"],"physical allocator {i}");assert_eq!(json!({"owner":hex(&owner.raw),"resource":hex(&resource.raw)}),row["after"],"constructor bytes, padding/defaults and publication {i}");}}
}
