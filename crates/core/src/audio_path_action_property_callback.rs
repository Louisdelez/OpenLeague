//! Actual B01250 action property callback; pair owner clears AFTER input9C.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put};
use crate::audio_path_source_action_list_cleanup as actions;
/// Missing property follows the native NULL-write boundary as an explicit error.
pub fn apply<S:actions::Services+crate::audio_path_source_virtual_cleanup::InputReleaseServices>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,action:u32,ty:u32,value_bits:u32,finished:u32,pool:u32,s:&mut S)->Result<(),Error>{
 if get(m,d,action,4)?!=0xff10ec{return Err(Error::Backend("action0 class is unqualified"));}let blob=get(m,d,action.wrapping_add(16),4)?;let mut pair=0;if blob!=0{let count=get(m,d,blob,1)?;for i in 0..count.max(1){if get(m,d,blob.wrapping_add(i+1),1)?==ty&255{pair=blob.wrapping_add(((count+4)&!3)+i.wrapping_mul(8));break;}}}
 if pair==0{return Err(Error::UnresolvedReference);}put(m,d,pair,4,value_bits)?;if finished as u8!=0{let source=get(m,d,action.wrapping_add(12),4)?;crate::audio_path_source_virtual_cleanup::release_input_recursive(m,d,source,3,pool,s)?;put(m,d,pair.wrapping_add(4),4,0)?;}
 let source=get(m,d,action.wrapping_add(12),4)?;actions::invalidate_source_voices(m,d,source,s)
}

#[cfg(test)]mod tests{
 use super::*;use crate::audio_path_source_terminal_cleanup as terminal;use crate::audio_path_source_property_query as properties;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{calls:Vec<Value>,regions:Vec<(&'static str,u32,usize)>,failure:bool,next:u32,stride:u32,owned:bool}
 impl Backend{fn snapshot(&self,m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r,z)in &self.regions{out[*n]=json!(hex(&(0..*z).map(|i|crate::audio_path_memory::read(m,r+i as u32,1).unwrap()[0]).collect::<Vec<_>>()));}out}}
 impl crate::audio_path_voice_empty_source_release::Services for Backend{fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"kind":"free","pool":p,"reference":r,"at_call":self.snapshot(m)}));Ok(())}}
 impl terminal::Services for Backend{
 fn observe_owner_release_shared(&mut self,r:u32,owner:u32,key:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"release_property_owner","receiver":r,"owner":owner,"key":key,"at_call":self.snapshot(m)}));}
 fn lock(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("lock excluded"))}
 fn unlock(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("unlock excluded"))}
 fn input_virtual9c(&mut self,r:u32,selector:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{if !self.owned{return Err(Error::Backend("input9c excluded"));}self.calls.push(json!({"kind":"input_virtual9c","receiver":r,"selector":selector,"at_call":self.snapshot(m)}));Ok(())}
 fn state_object_destructor(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("state object excluded"))}
 fn resource68(&mut self,_:u32,_:terminal::ResourceOperation,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("resource68 excluded"))}
 fn remove_callback(&mut self,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("callbacks excluded"))}
 fn destroy_action_list(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("destroy action list excluded"))}
 fn parent_virtual30(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("parent30 excluded"))}
 fn operator_delete(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("operator delete excluded"))}
 }
 impl crate::audio_path_source_virtual_cleanup::InputReleaseServices for Backend{
 fn observe_input_release(&mut self,r:u32,selector:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"input_virtual9c","receiver":r,"selector":selector,"at_call":self.snapshot(m)}));}
 fn parent_virtual9c(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{Err(Error::Backend("parent input9c excluded from this matrix"))}
 }
 impl actions::Services for Backend{
 fn source_virtuald0(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{Err(Error::Backend("query executes D0 body directly"))}
 fn observe_source_virtualcc(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"source_virtualcc","receiver":r,"at_call":self.snapshot(m)}));}
 fn observe_voice_flag_clear(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"clear_voice_flags","receiver":r,"at_call":self.snapshot(m)}));}
 }
 impl properties::Services for Backend{
 fn observe_property_owner_update(&mut self,r:u32,owner:u32,ty:u32,value_bits:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"update_property_owner","receiver":r,"arguments":[owner,ty,value_bits,0,4,0],"at_call":self.snapshot(m)}));}
 fn allocate_property(&mut self,p:u32,size:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{let result=if self.failure{0}else{self.next};self.calls.push(json!({"kind":"allocate","pool":p,"size":size,"result":result,"at_call":self.snapshot(m)}));if !self.failure{self.next+=self.stride;}Ok((result!=0).then_some(result))}
 fn observe_copy(&mut self,d:u32,s:u32,n:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"memcpy","destination":d,"source":s,"size":n,"at_call":self.snapshot(m)}));}
 fn observe_append(&mut self,r:u32,ty:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"append_property","receiver":r,"type":ty,"at_call":self.snapshot(m)}));}
 fn observe_action_owner_release(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"release_action_owners","receiver":r,"at_call":self.snapshot(m)}));}
 fn update_property_owner(&mut self,_:u32,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{Err(Error::Backend("nonzero owner update requires real native owner implementation"))}
 }

 #[test]fn audio_path_action_property_callback_matches1920_native_low_byte_type_first_duplicate_zero_count_padding_raw_value_finished_input9c_retirement_owner_clear_after_release_and_null_fault_physical_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_path_action_property_callback_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],1920);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=vec![("action",0x40001000,44),("properties",0x40002000,48),("source",0x40003000,120),("owner",0x40004000,60)];let mut m:BTreeMap<u32,Memory>=regions.iter().map(|(n,r,_)|(*r,Memory{reference:*r,raw:bytes(row["before"][*n].as_str().unwrap())})).collect();let mut d=BTreeSet::new();let mut s=Backend{calls:vec![],regions,failure:false,next:0,stride:0,owned:true};let result=apply(&mut m,&mut d,0x40001000,row["type_argument"].as_u64().unwrap()as u32,row["value_bits"].as_u64().unwrap()as u32,row["finished_argument"].as_u64().unwrap()as u32,19,&mut s);if row["fault"].is_null(){result.unwrap();}else{assert_eq!(row["fault"],"native_null_property_write");assert_eq!(result,Err(Error::UnresolvedReference),"native NULL write maps to explicit error {i}");}assert_eq!(json!(s.calls),row["calls"],"all input9C/free/CC snapshots and clear ordering {i}");assert_eq!(s.snapshot(&m),row["after"],"every property/action/source/owner physical byte {i}");let mut expected:Vec<u32>=row["freed"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect();expected.sort();assert_eq!(d.iter().copied().collect::<Vec<_>>(),expected,"retired allocations {i}");for r in &d{assert_eq!(get(&m,&d,*r,1),Err(Error::UnresolvedReference));}}
 }
}
