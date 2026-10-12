//! Original AFE2E0 44-byte action producer, AF6950 registration and AF6B40 type lookup.
//! Actual property refresh composes in canonical storage; allocation/free remain required transports.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put,live};
use crate::audio_path_source_property_query as property;
pub trait Services:property::Services{
 fn allocate_action(&mut self,pool:u32,size:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<Option<u32>,Error>;
 fn observe_registration(&mut self,_registry:u32,_key:u32,_action:u32,_m:&BTreeMap<u32,Memory>){}
 fn observe_type_lookup(&mut self,_registry:u32,_key:u32,_m:&BTreeMap<u32,Memory>){}
 fn observe_refresh(&mut self,_source:u32,_m:&BTreeMap<u32,Memory>){}
}
fn registry_owner(m:&BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,registry:u32,key:u32)->Result<Option<u32>,Error>{
 let table=get(m,dead,registry,4)?;let count=get(m,dead,registry.wrapping_add(4),4)?;if count!=0{live(m,dead,table,(count as usize).checked_mul(8).ok_or(Error::InvalidAllocation)?)?;}
 for i in 0..count{let entry=table.wrapping_add(i.wrapping_mul(8));if get(m,dead,entry,4)?==key{return Ok(Some(get(m,dead,entry.wrapping_add(4),4)?));}}Ok(None)
}
/// First matching registry key prepends the action to its intrusive list.
pub fn register(m:&mut BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,registry:u32,key:u32,action:u32)->Result<u32,Error>{
 let Some(owner)=registry_owner(m,dead,registry,key)?else{return Ok(20);};let head=get(m,dead,owner.wrapping_add(8),4)?;
 // Original empty-head branch publishes before setting the zero next link.
 if head==0{put(m,dead,owner.wrapping_add(8),4,action)?;put(m,dead,action.wrapping_add(4),4,head)?;}else{put(m,dead,action.wrapping_add(4),4,head)?;put(m,dead,owner.wrapping_add(8),4,action)?;}Ok(1)
}
pub fn action_type(m:&BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,registry:u32,key:u32)->Result<u32,Error>{if let Some(owner)=registry_owner(m,dead,registry,key)?{get(m,dead,owner.wrapping_add(4),4)}else{Ok(0)}}
fn free(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,pool:u32,r:u32,s:&mut impl Services)->Result<(),Error>{live(m,dead,r,1)?;s.free(pool,r,m)?;dead.insert(r);Ok(())}
pub fn create(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,source:u32,key:u32,refresh:u32,registry:u32,pool:u32,owner_manager:u32,s:&mut impl Services)->Result<Option<u32>,Error>{
 let mut action=get(m,dead,source.wrapping_add(16),4)?;let mut seen=BTreeSet::new();while action!=0{if !seen.insert(action){return Err(Error::CyclicList);}if get(m,dead,action.wrapping_add(32),4)?==key{return Ok(Some(action));}action=get(m,dead,action.wrapping_add(8),4)?;}
 let Some(action)=s.allocate_action(pool,44,m,dead)?else{return Ok(None);};if action==0{return Err(Error::InvalidAllocation);}live(m,dead,action,44)?;
 put(m,dead,action,4,0xff10ec)?;for o in[4,8,16,20,24,28,36]{put(m,dead,action.wrapping_add(o),4,0)?;}put(m,dead,action.wrapping_add(12),4,source)?;put(m,dead,action.wrapping_add(32),4,key)?;put(m,dead,action.wrapping_add(40),1,0)?;
 s.observe_registration(registry,key,action,m);if register(m,dead,registry,key,action)?!=1{
 put(m,dead,action,4,0xff10ec)?;let table=get(m,dead,action.wrapping_add(20),4)?;if table!=0{put(m,dead,action.wrapping_add(24),4,0)?;free(m,dead,pool,table,s)?;put(m,dead,action.wrapping_add(20),4,0)?;put(m,dead,action.wrapping_add(28),4,0)?;}
 let blob=get(m,dead,action.wrapping_add(16),4)?;if blob!=0{free(m,dead,pool,blob,s)?;}put(m,dead,action.wrapping_add(16),4,0)?;free(m,dead,pool,action,s)?;return Ok(None);}
 let head=get(m,dead,source.wrapping_add(16),4)?;if head==0{put(m,dead,source.wrapping_add(16),4,action)?;put(m,dead,action.wrapping_add(8),4,head)?;}else{put(m,dead,action.wrapping_add(8),4,head)?;put(m,dead,source.wrapping_add(16),4,action)?;}
 s.observe_type_lookup(registry,key,m);let ty=action_type(m,dead,registry,key)?;put(m,dead,action.wrapping_add(36),4,ty)?;
 if refresh&255!=0{s.observe_refresh(source,m);property::query(m,dead,source,pool,owner_manager,s)?;}Ok(Some(action))
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 use crate::audio_path_source_terminal_cleanup as terminal;use crate::audio_path_source_action_list_cleanup as actions;
 const REGIONS:[(&str,u32,usize);7]=[("source",0x40001000,120),("action",0x40002000,44),("existing",0x40003000,132),("registry",0x40004000,12),("table",0x40004100,24),("registry_owners",0x40004200,96),("source_manager",0x40005000,800)];
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 fn snapshot(m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r,z)in REGIONS{out[n]=json!(hex(&(0..z).map(|i|crate::audio_path_memory::read(m,r+i as u32,1).unwrap()[0]).collect::<Vec<_>>()));}out}
 struct Backend{calls:Vec<Value>,failure:bool}
 impl crate::audio_path_voice_empty_source_release::Services for Backend{
 fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"kind":"free","pool":p,"reference":r,"at_call":snapshot(m)}));Ok(())}
 }
 impl terminal::Services for Backend{
 fn lock(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("lock excluded"))}
 fn unlock(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("unlock excluded"))}
 fn input_virtual9c(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("input owner excluded"))}
 fn state_object_destructor(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("state excluded"))}
 fn resource68(&mut self,_:u32,_:terminal::ResourceOperation,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("resource excluded"))}
 fn remove_callback(&mut self,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("callback excluded"))}
 fn destroy_action_list(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("destruction excluded"))}
 fn parent_virtual30(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("parent excluded"))}
 fn operator_delete(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("delete excluded"))}
 }
 impl actions::Services for Backend{
 fn source_virtuald0(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{Err(Error::Backend("native refresh executes directly"))}
 fn observe_source_virtualcc(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"source_virtualcc","receiver":r,"at_call":snapshot(m)}));}
 }
 impl property::Services for Backend{
 fn allocate_property(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{Err(Error::Backend("property allocation excluded"))}
 fn update_property_owner(&mut self,_:u32,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{Err(Error::Backend("owner update excluded"))}
 fn observe_action_owner_release(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"release_action_owners","receiver":r,"at_call":snapshot(m)}));}
 }
 impl Services for Backend{
 fn allocate_action(&mut self,p:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{let result=if self.failure{0}else{0x40002000};self.calls.push(json!({"kind":"allocate","pool":p,"size":z,"result":result,"at_call":snapshot(m)}));Ok((result!=0).then_some(result))}
 fn observe_registration(&mut self,r:u32,k:u32,a:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"register_action","receiver":r,"key":k,"arguments":[k,a],"at_call":snapshot(m)}));}
 fn observe_type_lookup(&mut self,r:u32,k:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"read_action_type","receiver":r,"key":k,"arguments":[k],"at_call":snapshot(m)}));}
 fn observe_refresh(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"source_virtuald0","receiver":r,"at_call":snapshot(m)}));}
 }
 #[test]fn audio_path_source_action_factory_matches144_native_action44_constructor_source_input_first_reuse_register_failure_type_lookup_low_byte_actual_d0_refresh_and_all_physical_memory_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_path_source_action_factory_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],144);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m=BTreeMap::new();for(n,r,z)in REGIONS{let raw=bytes(row["before"][n].as_str().unwrap());let chunk=match n{"existing"=>44,"registry_owners"=>32,_=>z};for(j,part)in raw.chunks(chunk).enumerate(){let reference=r+j as u32*chunk as u32;m.insert(reference,Memory{reference,raw:part.to_vec()});}}let mut dead=BTreeSet::new();let mut b=Backend{calls:vec![],failure:row["allocation_failure"].as_bool().unwrap()};let result=create(&mut m,&mut dead,0x40001000,row["key"].as_u64().unwrap()as u32,row["refresh_argument"].as_u64().unwrap()as u32,0x40004000,19,0,&mut b).unwrap().unwrap_or(0);assert_eq!(result,row["result"].as_u64().unwrap()as u32,"returned first existing/new/null {i}");assert_eq!(json!(b.calls),row["calls"],"all allocation/registry/query/free boundaries {i}");assert_eq!(snapshot(&m),row["after"],"all canonical bytes including unused44-byte tail {i}");assert_eq!(json!(dead.iter().copied().collect::<Vec<_>>()),row["freed"],"physical retirement {i}");for r in &dead{assert_eq!(get(&m,&dead,*r,1),Err(Error::UnresolvedReference));}}
 }
}

#[cfg(test)]mod constructed_lifetime_tests{
 use super::*;use serde_json::{Value,json};
 use crate::audio_path_source_terminal_cleanup as terminal;use crate::audio_path_source_action_list_cleanup as actions;
 const REGIONS:[(&str,u32,usize);7]=[("source",0x40001000,120),("action",0x40002000,88),("existing",0x40003000,132),("registry",0x40004000,12),("table",0x40004100,24),("registry_owners",0x40004200,96),("source_manager",0x40005000,800)];
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 fn snapshot(m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r,z)in REGIONS{out[n]=json!(hex(&(0..z).map(|i|crate::audio_path_memory::read(m,r+i as u32,1).unwrap()[0]).collect::<Vec<_>>()));}out}
 struct Backend{calls:Vec<Value>,fail_index:i32,index:i32}
 impl crate::audio_path_voice_empty_source_release::Services for Backend{
 fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"kind":"free","pool":p,"reference":r,"at_call":snapshot(m)}));Ok(())}
 }
 impl terminal::Services for Backend{
 fn observe_manager_key(&mut self,r:u32,k:u32){self.calls.push(json!({"kind":"remove_manager_key","receiver":r,"key":k}));}
 fn observe_source14(&mut self,r:u32){self.calls.push(json!({"kind":"source_virtual14","receiver":r}));}
 fn observe_source_destructor(&mut self,r:u32,a:u32){self.calls.push(json!({"kind":"source_destructor","receiver":r,"argument":a}));}

 fn lock(&mut self,r:u32)->Result<(),Error>{self.calls.push(json!({"kind":"lock","receiver":r}));Ok(())}
 fn unlock(&mut self,r:u32)->Result<(),Error>{self.calls.push(json!({"kind":"unlock","receiver":r}));Ok(())}
 fn input_virtual9c(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("input owner excluded"))}
 fn state_object_destructor(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("state excluded"))}
 fn resource68(&mut self,_:u32,_:terminal::ResourceOperation,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("resource excluded"))}
 fn remove_callback(&mut self,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("callback excluded"))}
 fn destroy_action_list(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("destruction excluded"))}
 fn parent_virtual30(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("parent excluded"))}
 fn operator_delete(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("delete excluded"))}
 }
 impl actions::Services for Backend{
 fn observe_source_virtuald0(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"source_virtuald0","receiver":r,"at_call":snapshot(m)}));}
 fn observe_destroy_action_list(&mut self,r:u32,a:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"destroy_action_list","receiver":r,"argument":a,"at_call":snapshot(m)}));}
 fn observe_registry_unlink(&mut self,r:u32,k:u32,a:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"remove_action_registry","receiver":r,"key":k,"action":a,"at_call":snapshot(m)}));}

 fn source_virtuald0(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{actions::refresh_after_action_destruction(m,d,r,self)}
 fn observe_source_virtualcc(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"source_virtualcc","receiver":r,"at_call":snapshot(m)}));}
 }
 impl property::Services for Backend{
 fn allocate_property(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{Err(Error::Backend("property allocation excluded"))}
 fn update_property_owner(&mut self,_:u32,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{Err(Error::Backend("owner update excluded"))}
 fn observe_action_owner_release(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"release_action_owners","receiver":r,"at_call":snapshot(m)}));}
 }
 impl Services for Backend{
 fn allocate_action(&mut self,p:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{let result=if self.index==self.fail_index{0}else{0x40002000+self.index as u32*44};self.index+=1;self.calls.push(json!({"kind":"allocate","pool":p,"size":z,"result":result,"at_call":snapshot(m)}));Ok((result!=0).then_some(result))}
 fn observe_registration(&mut self,r:u32,k:u32,a:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"register_action","receiver":r,"key":k,"arguments":[k,a],"at_call":snapshot(m)}));}
 fn observe_type_lookup(&mut self,r:u32,k:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"read_action_type","receiver":r,"key":k,"arguments":[k],"at_call":snapshot(m)}));}
 fn observe_refresh(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"source_virtuald0","receiver":r,"at_call":snapshot(m)}));}
 }

 impl crate::audio_path_source_factory::Services for Backend{
 fn allocate(&mut self,p:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{self.calls.push(json!({"kind":"allocate","pool":p,"size":z,"result":0x40001000u32,"at_call":snapshot(m)}));Ok(Some(0x40001000))}
 fn lock(&mut self,r:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"kind":"lock","receiver":r}));Ok(())}
 fn unlock(&mut self,r:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"kind":"unlock","receiver":r}));Ok(())}
 }
 #[test]fn audio_path_source_constructed_lifetime_matches96_native_source120_action44_creation_reference_manager_registry_class_d0_destructors_intermediate_memory_and_all_physical_retirement_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_path_source_constructed_action_lifetime_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],96);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m=BTreeMap::new();for(n,r,z)in REGIONS{let raw=bytes(row["before"][n].as_str().unwrap());let chunk=match n{"action"|"existing"=>44,"registry_owners"=>32,_=>z};for(j,part)in raw.chunks(chunk).enumerate(){let reference=r+j as u32*chunk as u32;m.insert(reference,Memory{reference,raw:part.to_vec()});}}let mut dead=BTreeSet::new();let mut b=Backend{calls:vec![],fail_index:row["fail_index"].as_i64().unwrap()as i32,index:0};let result=crate::audio_path_source_factory::create(&mut m,&mut dead,row["source_key"].as_u64().unwrap()as u32,19,0x40005000,&mut b).unwrap().unwrap();assert_eq!(result,0x40001000);assert_eq!(json!(b.calls),row["factory_calls"],"constructor allocation/lock boundaries {i}");assert_eq!(snapshot(&m),row["after_factory"],"all native constructor bytes {i}");
 for(j,step)in row["action_steps"].as_array().unwrap().iter().enumerate(){b.calls.clear();let result=create(&mut m,&mut dead,0x40001000,step["key"].as_u64().unwrap()as u32,row["refresh_argument"].as_u64().unwrap()as u32,0x40004000,19,0,&mut b).unwrap().unwrap_or(0);assert_eq!(result,step["result"].as_u64().unwrap()as u32,"action result {i}:{j}");assert_eq!(json!(b.calls),step["calls"],"all action creator/refresh/free boundaries {i}:{j}");assert_eq!(snapshot(&m),step["after"],"complete intermediate state {i}:{j}");}
 put(&mut m,&dead,0x4000100c,4,row["reference_count"].as_u64().unwrap()as u32).unwrap();assert_eq!(snapshot(&m),row["before_release"]);b.calls.clear();let result=actions::release_reference_native_actions(&mut m,&mut dead,0x40001000,0x40005000,19,0x40004000,0,0,&mut b).unwrap();assert_eq!(result,row["result"].as_u64().unwrap()as u32,"saved reference result {i}");assert_eq!(json!(b.calls),row["release_calls"],"full manager/registry/destructor/class-specific D0/free boundaries {i}");assert_eq!(snapshot(&m),row["after"],"all physical final memory {i}");assert_eq!(json!(dead.iter().copied().collect::<Vec<_>>()),row["freed"],"canonical lifetimes {i}");for r in &dead{assert_eq!(get(&m,&dead,*r,1),Err(Error::UnresolvedReference));}}
 }
}

#[cfg(test)]mod real_registry_lifetime_tests{
 use super::*;use serde_json::{Value,json};
 use crate::audio_path_source_terminal_cleanup as terminal;use crate::audio_path_source_action_list_cleanup as actions;
 const REGIONS:[(&str,u32,usize);9]=[("source",0x40001000,120),("action",0x40002000,88),("existing",0x40003000,132),("registry",0x40004000,108),("table",0x40004100,64),("registry_owners",0x40004200,48),("source_manager",0x40005000,800),("first_pool",0x40006000,96),("second_pool",0x40007000,128)];
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 fn snapshot(m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r,z)in REGIONS{out[n]=json!(hex(&(0..z).map(|i|crate::audio_path_memory::read(m,r+i as u32,1).unwrap()[0]).collect::<Vec<_>>()));}out}
 struct Backend{calls:Vec<Value>,fail_index:i32,index:i32,key_failure:String,key_owner_index:u32,key_table_index:u32}
 impl crate::audio_path_voice_empty_source_release::Services for Backend{
 fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"kind":"free","pool":p,"reference":r,"at_call":snapshot(m)}));Ok(())}
 }
 impl terminal::Services for Backend{
 fn observe_manager_key(&mut self,r:u32,k:u32){self.calls.push(json!({"kind":"remove_manager_key","receiver":r,"key":k}));}
 fn observe_source14(&mut self,r:u32){self.calls.push(json!({"kind":"source_virtual14","receiver":r}));}
 fn observe_source_destructor(&mut self,r:u32,a:u32){self.calls.push(json!({"kind":"source_destructor","receiver":r,"argument":a}));}

 fn lock(&mut self,r:u32)->Result<(),Error>{self.calls.push(json!({"kind":"lock","receiver":r}));Ok(())}
 fn unlock(&mut self,r:u32)->Result<(),Error>{self.calls.push(json!({"kind":"unlock","receiver":r}));Ok(())}
 fn input_virtual9c(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("input owner excluded"))}
 fn state_object_destructor(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("state excluded"))}
 fn resource68(&mut self,_:u32,_:terminal::ResourceOperation,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("resource excluded"))}
 fn remove_callback(&mut self,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("callback excluded"))}
 fn destroy_action_list(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("destruction excluded"))}
 fn parent_virtual30(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("parent excluded"))}
 fn operator_delete(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("delete excluded"))}
 }
 impl actions::Services for Backend{
 fn observe_source_virtuald0(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"source_virtuald0","receiver":r,"at_call":snapshot(m)}));}
 fn observe_destroy_action_list(&mut self,r:u32,a:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"destroy_action_list","receiver":r,"argument":a,"at_call":snapshot(m)}));}
 fn observe_registry_unlink(&mut self,r:u32,k:u32,a:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"remove_action_registry","receiver":r,"key":k,"action":a,"at_call":snapshot(m)}));}

 fn source_virtuald0(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{actions::refresh_after_action_destruction(m,d,r,self)}
 fn observe_source_virtualcc(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"source_virtualcc","receiver":r,"at_call":snapshot(m)}));}
 }
 impl property::Services for Backend{
 fn allocate_property(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{Err(Error::Backend("property allocation excluded"))}
 fn update_property_owner(&mut self,_:u32,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{Err(Error::Backend("owner update excluded"))}
 fn observe_action_owner_release(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"release_action_owners","receiver":r,"at_call":snapshot(m)}));}
 }
 impl Services for Backend{
 fn allocate_action(&mut self,p:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{let result=if self.index==self.fail_index{0}else{0x40002000+self.index as u32*44};self.index+=1;self.calls.push(json!({"kind":"allocate","pool":p,"size":z,"result":result,"at_call":snapshot(m)}));Ok((result!=0).then_some(result))}
 fn observe_registration(&mut self,r:u32,k:u32,a:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"register_action","receiver":r,"key":k,"arguments":[k,a],"at_call":snapshot(m)}));}
 fn observe_type_lookup(&mut self,r:u32,k:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"read_action_type","receiver":r,"key":k,"arguments":[k],"at_call":snapshot(m)}));}
 fn observe_refresh(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"source_virtuald0","receiver":r,"at_call":snapshot(m)}));}
 }

 impl crate::audio_path_source_factory::Services for Backend{
 fn allocate(&mut self,p:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{self.calls.push(json!({"kind":"allocate","pool":p,"size":z,"result":0x40001000u32,"at_call":snapshot(m)}));Ok(Some(0x40001000))}
 fn lock(&mut self,r:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"kind":"lock","receiver":r}));Ok(())}
 fn unlock(&mut self,r:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"kind":"unlock","receiver":r}));Ok(())}
 }

 impl crate::audio_action_registry_initialization::Services for Backend{
 fn initialize_critical_section(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<u32,Error>{self.calls.push(json!({"kind":"initialize_critical_section","receiver":r,"supplied_pattern":17,"result":0,"at_call":snapshot(m)}));assert_eq!(r,0x40004044);m.get_mut(&0x40004000).unwrap().raw[68..92].fill(17);Ok(0)}
 fn allocate(&mut self,p:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{let result=match z{96=>0x40006000u32,128=>0x40007000,_=>panic!("unexpected initialization allocation")};self.calls.push(json!({"kind":"allocate","pool":p,"size":z,"result":result,"at_call":snapshot(m)}));Ok(Some(result))}
 }
 impl crate::audio_action_registry_key_publication::Services for Backend{
 fn allocate(&mut self,p:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{let result=if z==24{let r=if self.key_failure=="owner"&&self.key_owner_index==0{0}else{0x40004200+self.key_owner_index*24};self.key_owner_index+=1;r}else{assert_eq!(z,64);let r=if self.key_failure=="table"&&self.key_table_index==0{0}else{0x40004100};self.key_table_index+=1;r};self.calls.push(json!({"kind":"allocate","pool":p,"size":z,"result":result,"at_call":snapshot(m)}));Ok((result!=0).then_some(result))}
 }
 #[test]fn audio_registry_constructed_lifetime_matches96_native_real_registry108_pools_key_publication_source120_action44_reference_destructor_all_intermediate_physical_memory_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_registry_constructed_source_action_lifetime_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],96);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m=BTreeMap::new();for(n,r,z)in REGIONS{let raw=bytes(row["before"][n].as_str().unwrap());let chunk=match n{"action"|"existing"=>44,"registry_owners"=>24,_=>z};for(j,part)in raw.chunks(chunk).enumerate(){let reference=r+j as u32*chunk as u32;m.insert(reference,Memory{reference,raw:part.to_vec()});}}let mut dead=BTreeSet::new();let mut b=Backend{calls:vec![],fail_index:row["fail_index"].as_i64().unwrap()as i32,index:0,key_failure:row["key_failure"].as_str().unwrap().to_owned(),key_owner_index:0,key_table_index:0};

 assert_eq!(crate::audio_action_registry_initialization::construct(&mut m,&dead,0x40004000,&mut b).unwrap(),0x40004000);assert_eq!(json!(b.calls),row["registry_constructor_calls"],"registry constructor/OS boundary {i}");assert_eq!(snapshot(&m),row["after_registry_constructor"],"registry108 all bytes {i}");b.calls.clear();assert_eq!(crate::audio_action_registry_initialization::initialize(&mut m,&mut dead,0x40004000,19,&mut b).unwrap(),1);assert_eq!(json!(b.calls),row["registry_init_calls"],"both native pools {i}");assert_eq!(snapshot(&m),row["after_registry_init"],"registry and two native free lists {i}");
 for(j,step)in row["key_steps"].as_array().unwrap().iter().enumerate(){b.calls.clear();assert_eq!(crate::audio_action_registry_key_publication::publish(&mut m,&mut dead,0x40004000,step["key"].as_u64().unwrap()as u32,19,&mut b).unwrap(),step["result"].as_u64().unwrap()as u32,"actual key status {i}:{j}");assert_eq!(json!(b.calls),step["calls"],"every key allocation/grow/cleanup boundary {i}:{j}");assert_eq!(snapshot(&m),step["after"],"real key table and owner24 bytes {i}:{j}");}
 b.calls.clear();let result=crate::audio_path_source_factory::create(&mut m,&mut dead,row["source_key"].as_u64().unwrap()as u32,19,0x40005000,&mut b).unwrap().unwrap();assert_eq!(result,0x40001000);assert_eq!(json!(b.calls),row["factory_calls"],"constructor allocation/lock boundaries {i}");assert_eq!(snapshot(&m),row["after_factory"],"all native constructor bytes {i}");
 for(j,step)in row["action_steps"].as_array().unwrap().iter().enumerate(){b.calls.clear();let result=create(&mut m,&mut dead,0x40001000,step["key"].as_u64().unwrap()as u32,row["refresh_argument"].as_u64().unwrap()as u32,0x40004000,19,0,&mut b).unwrap().unwrap_or(0);assert_eq!(result,step["result"].as_u64().unwrap()as u32,"action result {i}:{j}");assert_eq!(json!(b.calls),step["calls"],"all action creator/refresh/free boundaries {i}:{j}");assert_eq!(snapshot(&m),step["after"],"complete intermediate state {i}:{j}");}
 put(&mut m,&dead,0x4000100c,4,row["reference_count"].as_u64().unwrap()as u32).unwrap();assert_eq!(snapshot(&m),row["before_release"]);b.calls.clear();let result=actions::release_reference_native_actions(&mut m,&mut dead,0x40001000,0x40005000,19,0x40004000,0,0,&mut b).unwrap();assert_eq!(result,row["result"].as_u64().unwrap()as u32,"saved reference result {i}");assert_eq!(json!(b.calls),row["release_calls"],"full manager/registry/destructor/class-specific D0/free boundaries {i}");assert_eq!(snapshot(&m),row["after"],"all physical final memory {i}");assert_eq!(json!(dead.iter().copied().collect::<Vec<_>>()),row["freed"],"canonical lifetimes {i}");for r in &dead{assert_eq!(get(&m,&dead,*r,1),Err(Error::UnresolvedReference));}}
 }
}
