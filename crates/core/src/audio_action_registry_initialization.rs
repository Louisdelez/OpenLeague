//! Actual AF66C0 108-byte action registry constructor and AF6B80 two-pool initialization.
//! OS critical-section memory and physical allocations remain explicit transports.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{put,live};
pub trait Services{
 fn initialize_critical_section(&mut self,section:u32,m:&mut BTreeMap<u32,Memory>)->Result<u32,Error>;
 fn allocate(&mut self,pool:u32,size:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<Option<u32>,Error>;
}
pub fn construct(m:&mut BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,registry:u32,s:&mut impl Services)->Result<u32,Error>{
 live(m,dead,registry,108)?;for o in[0,4,8,24,28,32,52,56,60]{put(m,dead,registry.wrapping_add(o),4,0)?;}
 // Original constructor ignores the return register from the OS operation.
 let _=s.initialize_critical_section(registry.wrapping_add(68),m)?;
 for o in[92,96,100,104]{put(m,dead,registry.wrapping_add(o),4,0)?;}Ok(registry)
}
fn allocate(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,p:u32,size:u32,s:&mut impl Services)->Result<u32,Error>{let r=s.allocate(p,size,m,d)?.unwrap_or(0);if r!=0{live(m,d,r,size as usize)?;}Ok(r)}
fn chain(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,r:u32,stride:u32)->Result<(),Error>{for i in 0..8{let at=r.wrapping_add(i*stride);put(m,d,at,4,if i==7{0}else{at.wrapping_add(stride)})?;}Ok(())}
/// Returns original status1 or52. Failure retains all native partial state;
/// a second allocation failure leaves the first pool allocated and published.
pub fn initialize(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,registry:u32,pool:u32,s:&mut impl Services)->Result<u32,Error>{
 put(m,d,registry.wrapping_add(32),4,0)?;put(m,d,registry.wrapping_add(28),4,u32::MAX)?;put(m,d,registry.wrapping_add(20),4,0)?;
 let first=allocate(m,d,pool,96,s)?;put(m,d,registry.wrapping_add(36),4,first)?;
 if first!=0{put(m,d,registry.wrapping_add(24),4,8)?;put(m,d,registry.wrapping_add(20),4,first)?;chain(m,d,first,12)?;}
 put(m,d,registry.wrapping_add(12),4,0)?;put(m,d,registry.wrapping_add(16),4,0)?;if first==0{return Ok(52);}
 put(m,d,registry.wrapping_add(60),4,0)?;put(m,d,registry.wrapping_add(56),4,u32::MAX)?;put(m,d,registry.wrapping_add(48),4,0)?;
 let second=allocate(m,d,pool,128,s)?;put(m,d,registry.wrapping_add(64),4,second)?;
 if second!=0{put(m,d,registry.wrapping_add(52),4,8)?;put(m,d,registry.wrapping_add(48),4,second)?;chain(m,d,second,16)?;}
 put(m,d,registry.wrapping_add(40),4,0)?;put(m,d,registry.wrapping_add(44),4,0)?;Ok(if second==0{52}else{1})
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 const REGIONS:[(&str,u32);3]=[("registry",0x40001000),("first_pool",0x40002000),("second_pool",0x40003000)];
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 fn snapshot(m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r)in REGIONS{out[n]=json!(hex(&m[&r].raw));}out}
 struct Backend{calls:Vec<Value>,section:u8,section_result:u32,fail_first:bool,fail_second:bool}
 impl Services for Backend{
 fn initialize_critical_section(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<u32,Error>{self.calls.push(json!({"kind":"initialize_critical_section","receiver":r,"supplied_pattern":self.section,"result":self.section_result,"at_call":snapshot(m)}));assert_eq!(r,0x40001044);m.get_mut(&0x40001000).unwrap().raw[68..92].fill(self.section);Ok(self.section_result)}
 fn allocate(&mut self,p:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{let result=match z{96=>if self.fail_first{0}else{0x40002000},128=>if self.fail_second{0}else{0x40003000},_=>panic!("unqualified allocation size")};self.calls.push(json!({"kind":"allocate","pool":p,"size":z,"result":result,"at_call":snapshot(m)}));Ok((result!=0).then_some(result))}
 }
 #[test]fn audio_action_registry_initialization_matches48_native_constructor108_critical_section_return_ignored_two_free_list_pools_partial_oom_and_complete_physical_memory_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_action_registry_constructor_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],48);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m:BTreeMap<u32,Memory>=REGIONS.into_iter().map(|(n,reference)|(reference,Memory{reference,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut dead=BTreeSet::new();let mut b=Backend{calls:vec![],section:row["section_pattern"].as_u64().unwrap()as u8,section_result:row["section_result"].as_u64().unwrap()as u32,fail_first:row["fail_first"].as_bool().unwrap(),fail_second:row["fail_second"].as_bool().unwrap()};assert_eq!(construct(&mut m,&dead,0x40001000,&mut b).unwrap(),0x40001000);assert_eq!(json!(b.calls),row["constructor_calls"],"OS call boundary {i}");assert_eq!(snapshot(&m),row["after_constructor"],"all108 bytes including untouched fields {i}");b.calls.clear();assert_eq!(initialize(&mut m,&mut dead,0x40001000,19,&mut b).unwrap(),row["result"].as_u64().unwrap()as u32,"native status {i}");assert_eq!(json!(b.calls),row["initialization_calls"],"both pool allocation boundaries {i}");assert_eq!(snapshot(&m),row["after"],"complete lists and partial OOM state {i}");assert!(dead.is_empty());}
 }
}
