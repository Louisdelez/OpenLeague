//! Original B226A0 120-byte Source factory, constructor chain and AFE420 registry insertion.
//! Allocation and operating-system locks are required transports; untouched bytes are preserved.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put,live};
pub trait Services{
 fn allocate(&mut self,pool:u32,size:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<Option<u32>,Error>;
 fn lock(&mut self,critical_section:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>;
 fn unlock(&mut self,critical_section:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>;
}
/// Complete verified constructor bytes, including flags in embedded state88.
fn construct(m:&mut BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,s:u32,key:u32)->Result<(),Error>{
 live(m,dead,s,120)?;
 put(m,dead,s,4,0xff0fe4)?;put(m,dead,s.wrapping_add(8),4,key)?;put(m,dead,s.wrapping_add(12),4,1)?;
 put(m,dead,s,4,0xff10f0)?;
 for o in[16,20,24,28,32,36,40,48,52,56]{put(m,dead,s.wrapping_add(o),4,0)?;}
 put(m,dead,s.wrapping_add(44),4,0x900000)?;
 put(m,dead,s,4,0xff0d2c)?;for o in[64,68,72,76,80]{put(m,dead,s.wrapping_add(o),4,0)?;}
 for(o,mask)in[(84,0x80),(86,0xf8)]{let v=get(m,dead,s.wrapping_add(o),1)?;put(m,dead,s.wrapping_add(o),1,v&mask)?;}
 put(m,dead,s.wrapping_add(85),1,4)?;put(m,dead,s,4,0xff0e80)?;put(m,dead,s,4,0xff1cd8)?;
 put(m,dead,s.wrapping_add(112),4,u32::MAX)?;put(m,dead,s.wrapping_add(108),4,0)?;
 let flags=get(m,dead,s.wrapping_add(104),4)?;put(m,dead,s.wrapping_add(104),4,flags&0xfffff800)?;
 for(o,v)in[(88,0),(92,u32::MAX),(96,0),(100,0)]{put(m,dead,s.wrapping_add(o),4,v)?;}
 // Original Source virtual38 returns3; the factory therefore clears bit1.
 let flags=get(m,dead,s.wrapping_add(47),1)?;put(m,dead,s.wrapping_add(47),1,flags&!2)?;Ok(())
}
pub fn create(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,key:u32,pool:u32,manager:u32,s:&mut impl Services)->Result<Option<u32>,Error>{
 let Some(source)=s.allocate(pool,120,m,dead)?else{return Ok(None);};if source==0{return Err(Error::InvalidAllocation);}construct(m,dead,source,key)?;
 // AF6430 selects the base manager because this class has type3.
 s.lock(manager,m)?;let key=get(m,dead,source.wrapping_add(8),4)?;let bucket=manager.wrapping_add(24+(key%193)*4);let previous=get(m,dead,bucket,4)?;put(m,dead,source.wrapping_add(4),4,previous)?;put(m,dead,bucket,4,source)?;
 let count=get(m,dead,manager.wrapping_add(796),4)?.wrapping_add(1);put(m,dead,manager.wrapping_add(796),4,count)?;s.unlock(manager,m)?;Ok(Some(source))
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 const REGIONS:[(&str,u32);3]=[("source",0x40001000),("manager",0x40005000),("previous",0x40006000)];
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 fn snapshot(m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r)in REGIONS{out[n]=json!(hex(&m[&r].raw));}out}
 struct Backend{calls:Vec<Value>,failure:bool}
 impl Services for Backend{
 fn allocate(&mut self,p:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{let result=if self.failure{0}else{0x40001000};self.calls.push(json!({"kind":"allocate","pool":p,"size":z,"result":result,"at_call":snapshot(m)}));Ok((result!=0).then_some(result))}
 fn lock(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"kind":"lock","receiver":r,"at_call":snapshot(m)}));Ok(())}
 fn unlock(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"kind":"unlock","receiver":r,"at_call":snapshot(m)}));Ok(())}
 }
 #[test]fn audio_path_source_factory_matches144_native_complete120byte_constructor_embedded_flags_unsigned_bucket_previous_link_count_wrap_oom_and_lock_boundary_memory_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_path_source_factory_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],144);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m:BTreeMap<u32,Memory>=REGIONS.into_iter().map(|(n,reference)|(reference,Memory{reference,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut dead=BTreeSet::new();let mut b=Backend{calls:vec![],failure:row["allocation_failure"].as_bool().unwrap()};let result=create(&mut m,&mut dead,row["key"].as_u64().unwrap()as u32,19,0x40005000,&mut b).unwrap().unwrap_or(0);assert_eq!(result,row["result"].as_u64().unwrap()as u32,"returned actual allocation {i}");assert_eq!(json!(b.calls),row["calls"],"allocation and lock boundaries {i}");assert_eq!(snapshot(&m),row["after"],"all120 source bytes and canonical manager/previous node {i}");assert!(dead.is_empty());}
 }
}
