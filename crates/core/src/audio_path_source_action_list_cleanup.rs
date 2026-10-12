//! Original AF6F00/AF6E10 action registry unlink and B00350 list destruction.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put,live};
use crate::audio_path_source_terminal_cleanup as terminal;
pub trait Services:terminal::Services{
 fn observe_destroy_action_list(&mut self,_source:u32,_argument:u32,_memory:&BTreeMap<u32,Memory>){}
 fn observe_source_virtuald0(&mut self,_source:u32,_memory:&BTreeMap<u32,Memory>){}
 fn observe_source_virtualcc(&mut self,_source:u32,_memory:&BTreeMap<u32,Memory>){}
 fn observe_voice_flag_clear(&mut self,_voice:u32,_memory:&BTreeMap<u32,Memory>){}
 fn observe_registry_unlink(&mut self,_registry:u32,_key:u32,_action:u32,_memory:&BTreeMap<u32,Memory>){}
 fn observe_child_reference_release(&mut self,_child:u32,_memory:&BTreeMap<u32,Memory>){}
 fn source_virtuald0(&mut self,source:u32,memory:&mut BTreeMap<u32,Memory>,retired:&mut BTreeSet<u32>)->Result<(),Error>;
}
/// Original AFFCB0 empty action branch calls AF3420 even when head16 is0.
/// This entry is specifically for the post-destruction phase. Nonempty action
/// property propagation requires the complete D0 path and returns an error here.
pub fn refresh_after_action_destruction(m:&mut BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,source:u32,s:&mut impl Services)->Result<(),Error>{
 if get(m,dead,source.wrapping_add(16),4)?!=0{return Err(Error::Backend("nonempty sourceD0 property propagation requires full query path"));}invalidate_source_voices(m,dead,source,s)
}
/// Original sourceCC for active and destructor-stage classes.
pub fn invalidate_source_voices(m:&mut BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,source:u32,s:&mut impl Services)->Result<(),Error>{
 let vtable=get(m,dead,source,4)?;if vtable!=0xff1cd8&&vtable!=0xff10f0{return Err(Error::Backend("sourceCC vtable is not qualified"));}s.observe_source_virtualcc(source,m);if vtable==0xff10f0{return Ok(());}let owner=get(m,dead,source.wrapping_add(28),4)?;if owner==0{return Ok(());}let mut voice=get(m,dead,owner.wrapping_add(12),4)?;let mut seen=BTreeSet::new();
 while voice!=0{if !seen.insert(voice){return Err(Error::CyclicList);}s.observe_voice_flag_clear(voice,m);let flag=get(m,dead,voice.wrapping_add(300),1)?;put(m,dead,voice.wrapping_add(300),1,flag&0xdf)?;let flag=get(m,dead,voice.wrapping_add(302),1)?;put(m,dead,voice.wrapping_add(302),1,flag&0xbf)?;voice=get(m,dead,voice.wrapping_add(16),4)?;}Ok(())
}
/// A matched registry key returns1 even if AF6E10 finds no action link;
/// an empty or missing registry key returns20. No allocation is freed here.
pub fn unlink_registry(m:&mut BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,registry:u32,key:u32,target:u32)->Result<u32,Error>{
 let base=get(m,dead,registry,4)?;let count=get(m,dead,registry.wrapping_add(4),4)?;if count!=0{live(m,dead,base,(count as usize).checked_mul(8).ok_or(Error::InvalidAllocation)?)?;}
 for i in 0..count{let entry=base.wrapping_add(i*8);if get(m,dead,entry,4)?==key{let owner=get(m,dead,entry.wrapping_add(4),4)?;let head=owner.wrapping_add(8);let mut current=get(m,dead,head,4)?;let mut previous=0u32;let mut seen=BTreeSet::new();while current!=0{if !seen.insert(current){return Err(Error::CyclicList);}if current==target{let next=get(m,dead,current.wrapping_add(4),4)?;put(m,dead,if previous==0{head}else{previous.wrapping_add(4)},4,next)?;break;}previous=current;current=get(m,dead,current.wrapping_add(4),4)?;}return Ok(1);}}Ok(20)
}
fn free(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,pool:u32,r:u32,s:&mut impl Services)->Result<(),Error>{live(m,dead,r,1)?;s.free(pool,r,m)?;dead.insert(r);Ok(())}
/// Pop action head before registry removal; clear child.word20 before releasing
/// its reference; reread and shift the matching12-byte entry after callbacks.
pub fn destroy(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,source:u32,argument:u32,pool:u32,registry:u32,source_manager:u32,owner_manager:u32,callback_manager:u32,s:&mut impl Services)->Result<(),Error>{destroy_impl(m,dead,source,argument,pool,registry,source_manager,owner_manager,callback_manager,s,false)}
/// Compose actual B00350 with D0 and current FF1CD8/FF10F0 CC dispatch.
pub fn destroy_native_query(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,source:u32,argument:u32,pool:u32,registry:u32,source_manager:u32,owner_manager:u32,callback_manager:u32,s:&mut impl Services)->Result<(),Error>{let vtable=get(m,dead,source,4)?;if vtable!=0xff1cd8&&vtable!=0xff10f0{return Err(Error::Backend("sourceD0 vtable is not native FF1CD8 or FF10F0"));}destroy_impl(m,dead,source,argument,pool,registry,source_manager,owner_manager,callback_manager,s,true)}
fn destroy_impl(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,source:u32,argument:u32,pool:u32,registry:u32,source_manager:u32,owner_manager:u32,callback_manager:u32,s:&mut impl Services,native_query:bool)->Result<(),Error>{
 if get(m,dead,source.wrapping_add(16),4)?==0{return Ok(());}let mut seen=BTreeSet::new();loop{let action=get(m,dead,source.wrapping_add(16),4)?;if action==0{break;}if !seen.insert(action){return Err(Error::CyclicList);}let next=get(m,dead,action.wrapping_add(8),4)?;put(m,dead,source.wrapping_add(16),4,next)?;let key=get(m,dead,action.wrapping_add(32),4)?;s.observe_registry_unlink(registry,key,action,m);unlink_registry(m,dead,registry,key,action)?;
 let mut previous_count=get(m,dead,action.wrapping_add(24),4)?;while previous_count!=0{
 let base=get(m,dead,action.wrapping_add(20),4)?;live(m,dead,base,(previous_count as usize).checked_mul(12).ok_or(Error::InvalidAllocation)?)?;let key=get(m,dead,base,4)?;let child=get(m,dead,base.wrapping_add(4),4)?;put(m,dead,child.wrapping_add(20),4,0)?;let child=get(m,dead,base.wrapping_add(4),4)?;s.observe_child_reference_release(child,m);terminal::release_reference(m,dead,child,source_manager,pool,owner_manager,callback_manager,s)?;
 let base=get(m,dead,action.wrapping_add(20),4)?;let count=get(m,dead,action.wrapping_add(24),4)?;if count!=0{live(m,dead,base,(count as usize).checked_mul(12).ok_or(Error::InvalidAllocation)?)?;}
 for i in 0..count{let at=base.wrapping_add(i*12);if get(m,dead,at,4)?==key{if i+1<count{let n=(count-i-1)as usize*12;let bytes=live(m,dead,at.wrapping_add(12),n)?.to_vec();live(m,dead,at,n)?;let allocation=*m.range(..=at).next_back().ok_or(Error::UnresolvedReference)?.0;let offset=at.wrapping_sub(allocation)as usize;m.get_mut(&allocation).unwrap().raw[offset..offset+n].copy_from_slice(&bytes);}put(m,dead,action.wrapping_add(24),4,count-1)?;break;}}
 let count=get(m,dead,action.wrapping_add(24),4)?;if count>=previous_count{return Err(Error::Backend("action entry callbacks did not advance native removal"));}previous_count=count;
 }
 put(m,dead,action,4,0xff10ec)?;let table=get(m,dead,action.wrapping_add(20),4)?;if table!=0{put(m,dead,action.wrapping_add(24),4,0)?;free(m,dead,pool,table,s)?;put(m,dead,action.wrapping_add(20),4,0)?;put(m,dead,action.wrapping_add(28),4,0)?;}
 let blob=get(m,dead,action.wrapping_add(16),4)?;if blob!=0{free(m,dead,pool,blob,s)?;}put(m,dead,action.wrapping_add(16),4,0)?;free(m,dead,pool,action,s)?;
 }if argument as u8!=0{if native_query{s.observe_source_virtuald0(source,m);refresh_after_action_destruction(m,dead,source,s)?;}else{s.source_virtuald0(source,m,dead)?;}}Ok(())
}

/// Routes terminal source action destruction through the native list/query
/// implementation, retaining one shared allocation map and retirement set.
struct NativeActionLists<'a,S>{backend:&'a mut S,registry:u32,source_manager:u32}
impl<S:Services> crate::audio_path_voice_empty_source_release::Services for NativeActionLists<'_,S>{
 fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.backend.free(p,r,m)}
 fn observe_parent_removal(&mut self,p:u32,r:u32){self.backend.observe_parent_removal(p,r)}
 fn observe_empty_source_release(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.backend.observe_empty_source_release(r,m)}
}
impl<S:Services> terminal::Services for NativeActionLists<'_,S>{
 fn lock(&mut self,r:u32)->Result<(),Error>{self.backend.lock(r)}
 fn unlock(&mut self,r:u32)->Result<(),Error>{self.backend.unlock(r)}
 fn observe_manager_key(&mut self,r:u32,key:u32){self.backend.observe_manager_key(r,key)}
 fn observe_source14(&mut self,r:u32){self.backend.observe_source14(r)}
 fn observe_source_destructor(&mut self,r:u32,arg:u32){self.backend.observe_source_destructor(r,arg)}
 fn observe_owner_release(&mut self,r:u32,owner:u32,key:u32){self.backend.observe_owner_release(r,owner,key)}
 fn observe_owner_release_shared(&mut self,r:u32,owner:u32,key:u32,m:&BTreeMap<u32,Memory>){self.backend.observe_owner_release_shared(r,owner,key,m)}
 fn input_virtual9c(&mut self,r:u32,selector:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.backend.input_virtual9c(r,selector,m)}
 fn state_object_destructor(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.backend.state_object_destructor(r,m)}
 fn resource68(&mut self,r:u32,op:terminal::ResourceOperation,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.backend.resource68(r,op,m)}
 fn remove_callback(&mut self,r:u32,source:u32,index:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.backend.remove_callback(r,source,index,m)}
 fn destroy_action_list(&mut self,source:u32,arg:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.backend.destroy_action_list(source,arg,m)}
 fn parent_virtual30(&mut self,r:u32,source:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.backend.parent_virtual30(r,source,m)}
 fn operator_delete(&mut self,source:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.backend.operator_delete(source,m)}
 fn destroy_action_list_shared(&mut self,source:u32,arg:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,pool:u32,owner_manager:u32,callback_manager:u32)->Result<(),Error>{self.backend.observe_destroy_action_list(source,arg,m);destroy_native_query(m,dead,source,arg,pool,self.registry,self.source_manager,owner_manager,callback_manager,self)}
}
impl<S:Services> Services for NativeActionLists<'_,S>{
 fn observe_destroy_action_list(&mut self,source:u32,arg:u32,m:&BTreeMap<u32,Memory>){self.backend.observe_destroy_action_list(source,arg,m)}
 fn observe_source_virtuald0(&mut self,source:u32,m:&BTreeMap<u32,Memory>){self.backend.observe_source_virtuald0(source,m)}
 fn observe_source_virtualcc(&mut self,source:u32,m:&BTreeMap<u32,Memory>){self.backend.observe_source_virtualcc(source,m)}
 fn observe_voice_flag_clear(&mut self,voice:u32,m:&BTreeMap<u32,Memory>){self.backend.observe_voice_flag_clear(voice,m)}
 fn observe_registry_unlink(&mut self,registry:u32,key:u32,action:u32,m:&BTreeMap<u32,Memory>){self.backend.observe_registry_unlink(registry,key,action,m)}
 fn observe_child_reference_release(&mut self,child:u32,m:&BTreeMap<u32,Memory>){self.backend.observe_child_reference_release(child,m)}
 fn source_virtuald0(&mut self,source:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<(),Error>{self.backend.source_virtuald0(source,m,dead)}
}
/// Actual last-source reference, manager unlink, owner releases, source
/// destructor, action/registry/child releases and class-correct D0/CC.
pub fn release_reference_native_actions(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,source:u32,manager:u32,pool:u32,registry:u32,owner_manager:u32,callback_manager:u32,s:&mut impl Services)->Result<u32,Error>{let mut adapter=NativeActionLists{backend:s,registry,source_manager:manager};terminal::release_reference(m,dead,source,manager,pool,owner_manager,callback_manager,&mut adapter)}
pub fn destroy_source_native_actions(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,source:u32,arg:u32,manager:u32,pool:u32,registry:u32,owner_manager:u32,callback_manager:u32,s:&mut impl Services)->Result<(),Error>{let mut adapter=NativeActionLists{backend:s,registry,source_manager:manager};terminal::destroy_source(m,dead,source,arg,pool,owner_manager,callback_manager,&mut adapter)}

#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 const REGIONS:[(&str,u32,usize);5]=[("source",0x40001000,160),("actions",0x40002000,128),("tables",0x40003000,128),("blobs",0x40004000,128),("children",0x40008000,1536)];
 fn snapshot(m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r,size)in REGIONS{out[n]=json!(hex(&(0..size).map(|i|crate::audio_path_memory::read(m,r+i as u32,1).unwrap()[0]).collect::<Vec<_>>()));}if m.contains_key(&0x40003500){for(n,r,size)in [("registry",0x40005000,12),("registry_table",0x40003500,16),("registry_owners",0x40005500,128)]{out[n]=json!(hex(&(0..size).map(|i|crate::audio_path_memory::read(m,r+i as u32,1).unwrap()[0]).collect::<Vec<_>>()));}}if m.contains_key(&0x40007000){for(n,r,size)in [("source_owner",0x40007000,64),("voices",0x40018000,1272)]{out[n]=json!(hex(&(0..size).map(|i|crate::audio_path_memory::read(m,r+i as u32,1).unwrap()[0]).collect::<Vec<_>>()));}}if m.contains_key(&0x40006000){out["source_manager"]=json!(hex(&m[&0x40006000].raw));}out}
 struct Backend(Vec<Value>,bool);
 impl crate::audio_path_voice_empty_source_release::Services for Backend{fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.0.push(json!({"kind":"free","pool":p,"reference":r,"at_call":snapshot(m)}));Ok(())}}
 impl terminal::Services for Backend{
 fn observe_manager_key(&mut self,r:u32,key:u32){self.0.push(json!({"kind":"remove_manager_key","receiver":r,"key":key}));}
 fn observe_source14(&mut self,r:u32){self.0.push(json!({"kind":"source_virtual14","receiver":r}));}
 fn observe_source_destructor(&mut self,r:u32,arg:u32){self.0.push(json!({"kind":"source_destructor","receiver":r,"argument":arg}));}
 fn lock(&mut self,r:u32)->Result<(),Error>{self.0.push(json!({"kind":"lock","receiver":r}));Ok(())}
 fn unlock(&mut self,r:u32)->Result<(),Error>{self.0.push(json!({"kind":"unlock","receiver":r}));Ok(())}
 fn input_virtual9c(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("input9c excluded from fixture"))}
 fn state_object_destructor(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("state object excluded from fixture"))}
 fn resource68(&mut self,_:u32,_:terminal::ResourceOperation,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("resource68 excluded from fixture"))}
 fn remove_callback(&mut self,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("callback registry excluded from fixture"))}
 fn destroy_action_list(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("nested action list excluded from fixture"))}
 fn parent_virtual30(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("parent30 excluded from fixture"))}
 fn operator_delete(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("operator delete excluded from fixture"))}
 }
 impl Services for Backend{
 fn observe_destroy_action_list(&mut self,r:u32,arg:u32,m:&BTreeMap<u32,Memory>){self.0.push(json!({"kind":"destroy_action_list","receiver":r,"argument":arg,"at_call":snapshot(m)}));}
 fn observe_source_virtuald0(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.0.push(json!({"kind":"source_virtuald0","receiver":r,"at_call":snapshot(m)}));}
 fn observe_source_virtualcc(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.0.push(json!({"kind":"source_virtualcc","receiver":r,"at_call":snapshot(m)}));}
 fn observe_voice_flag_clear(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.0.push(json!({"kind":"clear_voice_flags","receiver":r,"at_call":snapshot(m)}));}
 fn observe_registry_unlink(&mut self,r:u32,key:u32,action:u32,m:&BTreeMap<u32,Memory>){self.0.push(json!({"kind":"remove_action_registry","receiver":r,"key":key,"action":action,"source_at_call":hex(&m[&0x40001000].raw)}));}
 fn observe_child_reference_release(&mut self,r:u32,m:&BTreeMap<u32,Memory>){self.0.push(json!({"kind":"child_source_virtual08","receiver":r,"at_call":snapshot(m)}));}
 fn source_virtuald0(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<(),Error>{self.0.push(json!({"kind":"source_virtuald0","receiver":r,"at_call":snapshot(m)}));if self.1{refresh_after_action_destruction(m,dead,r,self)?;}Ok(())}
 }
 #[test]fn audio_path_source_action_list_cleanup_matches432_native_head_pop_child_reference_clear_shift_tails_vtables_free_order_and_low_byte_final_gate_cases(){let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_path_source_action_list_destroy_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],432);for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m=BTreeMap::new();for(n,r,size)in REGIONS{let raw=bytes(row["before"][n].as_str().unwrap());let chunk=match n{"actions"|"tables"|"blobs"=>64,"children"=>256,_=>size};for(j,part)in raw.chunks(chunk).enumerate(){let reference=r+j as u32*chunk as u32;m.insert(reference,Memory{reference,raw:part.to_vec()});}}let mut registry=vec![0;12];registry[..4].copy_from_slice(&0x40003500u32.to_le_bytes());m.insert(0x40005000,Memory{reference:0x40005000,raw:registry});let mut dead=BTreeSet::new();let mut s=Backend(vec![],false);destroy(&mut m,&mut dead,0x40001000,row["argument"].as_u64().unwrap()as u32,19,0x40005000,0x40006000,0,0,&mut s).unwrap();assert_eq!(json!(s.0),row["calls"],"every callback/free and exact memory at each boundary {i}");assert_eq!(snapshot(&m),row["after"],"all source/action/table/blob/child physical bytes {i}");for r in &dead{assert_eq!(get(&m,&dead,*r,1),Err(Error::UnresolvedReference));}for j in 0..6{assert!(!dead.contains(&(0x40008000+j*256)));}}}
 #[test]fn audio_path_source_action_list_cleanup_matches192_native_nonempty_registry_first_key_intrusive_first_middle_last_missing_and_retained_link_cases(){let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_source_action_registry_unlink_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],192);for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m:BTreeMap<u32,Memory>=[("registry",0x40001000),("table",0x40002000),("owners",0x40003000),("actions",0x40004000)].into_iter().map(|(n,reference)|(reference,Memory{reference,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let result=unlink_registry(&mut m,&BTreeSet::new(),0x40001000,row["key"].as_u64().unwrap()as u32,row["target"].as_u64().unwrap()as u32).unwrap();assert_eq!(result,row["result"].as_u64().unwrap()as u32,"wrapper result retains key-match success even for absent link {i}");let mut after=json!({});for(n,r)in[("registry",0x40001000),("table",0x40002000),("owners",0x40003000),("actions",0x40004000)]{after[n]=json!(hex(&m[&r].raw));}assert_eq!(after,row["after"],"all registry/owner/action links retained physical bytes {i}");}}
 #[test]fn audio_path_source_action_list_cleanup_matches576_native_nonempty_registry_and_action_list_composed_callbacks_free_order_and_canonical_lifetimes(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_path_source_action_list_registry_destroy_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],576);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m=BTreeMap::new();for(n,r,size)in REGIONS.into_iter().chain([("registry",0x40005000,12),("registry_table",0x40003500,16),("registry_owners",0x40005500,128)]){let raw=bytes(row["before"][n].as_str().unwrap());let chunk=match n{"actions"|"tables"|"blobs"|"registry_owners"=>64,"children"=>256,_=>size};for(j,part)in raw.chunks(chunk).enumerate(){let reference=r+j as u32*chunk as u32;m.insert(reference,Memory{reference,raw:part.to_vec()});}}
 let mut dead=BTreeSet::new();let mut services=Backend(vec![],false);destroy(&mut m,&mut dead,0x40001000,row["argument"].as_u64().unwrap()as u32,19,0x40005000,0x40006000,0,0,&mut services).unwrap();assert_eq!(json!(services.0),row["calls"],"every registry unlink/child release/free callback snapshot {i}");assert_eq!(snapshot(&m),row["after"],"all canonical physical banks {i}");
 for j in 0..row["action_count"].as_u64().unwrap()as u32{assert!(dead.contains(&(0x40002000+j*64)));assert!(dead.contains(&(0x40003000+j*64)));if row["blob"].as_bool().unwrap(){assert!(dead.contains(&(0x40004000+j*64)));}}
 for r in &dead{assert_eq!(get(&m,&dead,*r,1),Err(Error::UnresolvedReference));}for j in 0..6{assert!(!dead.contains(&(0x40008000+j*256)));}assert!(!dead.contains(&0x40005000));
 }}
 #[test]fn audio_path_source_action_list_cleanup_matches576_native_actual_source_d0_cc_voice_flag_clear_and_full_action_registry_destruction_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_path_source_action_list_native_query_destroy_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],576);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m=BTreeMap::new();for(n,r,size)in REGIONS.into_iter().chain([("registry",0x40005000,12),("registry_table",0x40003500,16),("registry_owners",0x40005500,128),("source_owner",0x40007000,64),("voices",0x40018000,1272)]){let raw=bytes(row["before"][n].as_str().unwrap());let chunk=match n{"actions"|"tables"|"blobs"|"registry_owners"=>64,"children"=>256,"voices"=>424,_=>size};for(j,part)in raw.chunks(chunk).enumerate(){let reference=r+j as u32*chunk as u32;m.insert(reference,Memory{reference,raw:part.to_vec()});}}
 let mut dead=BTreeSet::new();let mut services=Backend(vec![],true);destroy_native_query(&mut m,&mut dead,0x40001000,row["argument"].as_u64().unwrap()as u32,19,0x40005000,0x40006000,0,0,&mut services).unwrap();assert_eq!(json!(services.0),row["calls"],"every registry unlink/child release/free callback snapshot {i}");assert_eq!(snapshot(&m),row["after"],"all canonical physical banks {i}");
 for j in 0..row["action_count"].as_u64().unwrap()as u32{assert!(dead.contains(&(0x40002000+j*64)));assert!(dead.contains(&(0x40003000+j*64)));if row["blob"].as_bool().unwrap(){assert!(dead.contains(&(0x40004000+j*64)));}}
 for r in &dead{assert_eq!(get(&m,&dead,*r,1),Err(Error::UnresolvedReference));}for j in 0..6{assert!(!dead.contains(&(0x40008000+j*256)));}assert!(!dead.contains(&0x40005000));
 }}
 #[test]fn audio_path_source_action_list_cleanup_matches576_native_destructor_base_d0_cc_ret_and_unchanged_voice_banks_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_path_source_action_list_base_query_destroy_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],576);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m=BTreeMap::new();for(n,r,size)in REGIONS.into_iter().chain([("registry",0x40005000,12),("registry_table",0x40003500,16),("registry_owners",0x40005500,128),("source_owner",0x40007000,64),("voices",0x40018000,1272)]){let raw=bytes(row["before"][n].as_str().unwrap());let chunk=match n{"actions"|"tables"|"blobs"|"registry_owners"=>64,"children"=>256,"voices"=>424,_=>size};for(j,part)in raw.chunks(chunk).enumerate(){let reference=r+j as u32*chunk as u32;m.insert(reference,Memory{reference,raw:part.to_vec()});}}
 let mut dead=BTreeSet::new();let mut services=Backend(vec![],true);destroy_native_query(&mut m,&mut dead,0x40001000,row["argument"].as_u64().unwrap()as u32,19,0x40005000,0x40006000,0,0,&mut services).unwrap();assert_eq!(json!(services.0),row["calls"],"every registry unlink/child release/free callback snapshot {i}");assert_eq!(snapshot(&m),row["after"],"all canonical physical banks {i}");
 for j in 0..row["action_count"].as_u64().unwrap()as u32{assert!(dead.contains(&(0x40002000+j*64)));assert!(dead.contains(&(0x40003000+j*64)));if row["blob"].as_bool().unwrap(){assert!(dead.contains(&(0x40004000+j*64)));}}
 for r in &dead{assert_eq!(get(&m,&dead,*r,1),Err(Error::UnresolvedReference));}for j in 0..6{assert!(!dead.contains(&(0x40008000+j*256)));}assert!(!dead.contains(&0x40005000));
 }}
 #[test]fn audio_path_source_action_list_cleanup_matches288_native_complete_last_source_reference_action_registry_children_base_query_owner_destructor_and_canonical_lifetime_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_path_source_terminal_action_graph_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],288);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m=BTreeMap::new();for(n,r,size)in REGIONS.into_iter().chain([("registry",0x40005000,12),("registry_table",0x40003500,16),("registry_owners",0x40005500,128),("source_manager",0x40006000,1600),("source_owner",0x40007000,64),("voices",0x40018000,1272)]){let raw=bytes(row["before"][n].as_str().unwrap());let chunk=match n{"actions"|"tables"|"blobs"|"registry_owners"=>64,"children"=>256,"voices"=>424,_=>size};for(j,part)in raw.chunks(chunk).enumerate(){let reference=r+j as u32*chunk as u32;m.insert(reference,Memory{reference,raw:part.to_vec()});}}
 let mut dead=BTreeSet::new();let mut services=Backend(vec![],true);let result=release_reference_native_actions(&mut m,&mut dead,0x40001000,0x40006000,19,0x40005000,0,0,&mut services).unwrap();assert_eq!(result,0);assert!(dead.contains(&0x40001000));assert_eq!(dead.contains(&0x40007000),row["blob"].as_bool().unwrap());assert_eq!(json!(services.0),row["calls"],"every registry unlink/child release/free callback snapshot {i}");assert_eq!(snapshot(&m),row["after"],"all canonical physical banks {i}");
 for j in 0..row["action_count"].as_u64().unwrap()as u32{assert!(dead.contains(&(0x40002000+j*64)));assert!(dead.contains(&(0x40003000+j*64)));if row["blob"].as_bool().unwrap(){assert!(dead.contains(&(0x40004000+j*64)));}}
 for r in &dead{assert_eq!(get(&m,&dead,*r,1),Err(Error::UnresolvedReference));}for j in 0..6{assert!(!dead.contains(&(0x40008000+j*256)));}assert!(!dead.contains(&0x40005000));
 }}
 #[test]fn audio_path_source_action_list_cleanup_matches288_native_terminal_child_last_references_manager_unlink_destructors_before_parent_shift_and_complete_lifetime_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_path_source_terminal_child_action_graph_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],288);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m=BTreeMap::new();for(n,r,size)in REGIONS.into_iter().chain([("registry",0x40005000,12),("registry_table",0x40003500,16),("registry_owners",0x40005500,128),("source_manager",0x40006000,1600),("source_owner",0x40007000,64),("voices",0x40018000,1272)]){let raw=bytes(row["before"][n].as_str().unwrap());let chunk=match n{"actions"|"tables"|"blobs"|"registry_owners"=>64,"children"=>256,"voices"=>424,_=>size};for(j,part)in raw.chunks(chunk).enumerate(){let reference=r+j as u32*chunk as u32;m.insert(reference,Memory{reference,raw:part.to_vec()});}}
 let mut dead=BTreeSet::new();let mut services=Backend(vec![],true);let result=release_reference_native_actions(&mut m,&mut dead,0x40001000,0x40006000,19,0x40005000,0,0,&mut services).unwrap();assert_eq!(result,0);assert!(dead.contains(&0x40001000));assert_eq!(dead.contains(&0x40007000),row["blob"].as_bool().unwrap());assert_eq!(json!(services.0),row["calls"],"every registry unlink/child release/free callback snapshot {i}");assert_eq!(snapshot(&m),row["after"],"all canonical physical banks {i}");
 for j in 0..row["action_count"].as_u64().unwrap()as u32{assert!(dead.contains(&(0x40002000+j*64)));assert!(dead.contains(&(0x40003000+j*64)));if row["blob"].as_bool().unwrap(){assert!(dead.contains(&(0x40004000+j*64)));}}
 for r in &dead{assert_eq!(get(&m,&dead,*r,1),Err(Error::UnresolvedReference));}for j in 0..6u32{let freed=j/3<row["action_count"].as_u64().unwrap()as u32 && j%3<row["entry_count"].as_u64().unwrap()as u32;assert_eq!(dead.contains(&(0x40008000+j*256)),freed,"child logical retirement {i}");}assert!(!dead.contains(&0x40005000));
 }}

}
