//! Actual source terminal B00180/AF6650/AFEC20/B22660/AEFC60/AFDF20.
//! Canonical live allocations are moved into existing owner helpers and returned.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put,live,unlink_manager_key};
use crate::audio_path_voice_empty_source_release as empty;
#[derive(Clone,Copy,Debug)]pub enum ResourceOperation{Release,Clear,Destroy}
pub trait Services:empty::Services{
 fn lock(&mut self,section:u32)->Result<(),Error>;
 fn unlock(&mut self,section:u32)->Result<(),Error>;
 fn observe_manager_key(&mut self,_table:u32,_key:u32){}
 fn observe_source14(&mut self,_source:u32){}
 fn observe_source_destructor(&mut self,_source:u32,_argument:u32){}
 fn observe_owner_release(&mut self,_manager:u32,_owner:u32,_key:u32){}
 fn observe_owner_release_shared(&mut self,manager:u32,owner:u32,key:u32,memory:&BTreeMap<u32,Memory>){let _=memory;self.observe_owner_release(manager,owner,key)}
 fn input_virtual9c(&mut self,input:u32,selector:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>;
 fn state_object_destructor(&mut self,reference:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>;
 fn resource68(&mut self,reference:u32,operation:ResourceOperation,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>;
 fn remove_callback(&mut self,manager:u32,source:u32,index:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>;
 fn destroy_action_list(&mut self,source:u32,argument:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>;
 /// Shared canonical lifetime hook; older service boundaries remain explicit.
 fn destroy_action_list_shared(&mut self,source:u32,argument:u32,m:&mut BTreeMap<u32,Memory>,_dead:&mut BTreeSet<u32>,_pool:u32,_owner_manager:u32,_callback_manager:u32)->Result<(),Error>{self.destroy_action_list(source,argument,m)}
 fn parent_virtual30(&mut self,parent:u32,source:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>;
 fn operator_delete(&mut self,source:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>;
}
fn free(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,pool:u32,r:u32,s:&mut impl Services)->Result<(),Error>{live(m,dead,r,1)?;s.free(pool,r,m)?;dead.insert(r);Ok(())}
pub(crate) fn owner_remove(m:&mut BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,owner:u32,key:u32)->Result<(),Error>{
 let count=get(m,dead,owner.wrapping_add(36),4)?;let table=get(m,dead,owner.wrapping_add(32),4)?;live(m,dead,owner,54)?;
 if count!=0{if owner==table{return Err(Error::InvalidAllocation);}live(m,dead,table,(count as usize).checked_mul(4).ok_or(Error::InvalidAllocation)?)?;if !m.contains_key(&table){return Err(Error::UnresolvedReference);}}
 let allocation=m.remove(&owner).ok_or(Error::UnresolvedReference)?;let mut runtime=crate::audio_path_voice_owner_release::Runtime{owners:BTreeMap::from([(owner,allocation)]),tables:BTreeMap::new()};if count!=0{runtime.tables.insert(table,m.remove(&table).unwrap());}
 let result=runtime.remove(owner,key);m.append(&mut runtime.owners);m.append(&mut runtime.tables);result.map(|_|())
}
/// Original AFEC20 packed property traversal, actual AF5B90 owner removal,
/// cleared owner-slot before every required input9C selector3 callback.
pub fn release_action_owners(m:&mut BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,action:u32,owner_manager:u32,s:&mut impl Services)->Result<(),Error>{
 let blob=get(m,dead,action.wrapping_add(16),4)?;if blob!=0{let count=get(m,dead,blob,1)?;let mut cursor=blob.wrapping_add((count+4)&!3);for _ in 0..count{cursor=cursor.wrapping_add(4);let owner=get(m,dead,cursor,4)?;if owner!=0{s.observe_owner_release_shared(owner_manager,owner,action,m);owner_remove(m,dead,owner,action)?;put(m,dead,cursor,4,0)?;let input=get(m,dead,action.wrapping_add(12),4)?;s.input_virtual9c(input,3,m)?;}cursor=cursor.wrapping_add(4);}}Ok(())
}
/// Canonical AFEBB0 with actual Source input9C and physical owner lifetime.
pub fn release_action_owners_native_inputs<S:Services+crate::audio_path_source_virtual_cleanup::InputReleaseServices>(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,action:u32,owner_manager:u32,pool:u32,s:&mut S)->Result<(),Error>{
 let blob=get(m,dead,action.wrapping_add(16),4)?;if blob!=0{let count=get(m,dead,blob,1)?;let mut cursor=blob.wrapping_add((count+4)&!3);for _ in 0..count{cursor=cursor.wrapping_add(4);let owner=get(m,dead,cursor,4)?;if owner!=0{s.observe_owner_release_shared(owner_manager,owner,action,m);owner_remove(m,dead,owner,action)?;put(m,dead,cursor,4,0)?;let input=get(m,dead,action.wrapping_add(12),4)?;crate::audio_path_source_virtual_cleanup::release_input(m,dead,input,3,pool,s)?;}cursor=cursor.wrapping_add(4);}}Ok(())
}
pub fn release_action_owners_recursive_inputs<S:Services+crate::audio_path_source_virtual_cleanup::InputReleaseServices>(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,action:u32,owner_manager:u32,pool:u32,s:&mut S)->Result<(),Error>{
 let blob=get(m,dead,action.wrapping_add(16),4)?;if blob!=0{let count=get(m,dead,blob,1)?;let mut cursor=blob.wrapping_add((count+4)&!3);for _ in 0..count{cursor=cursor.wrapping_add(4);let owner=get(m,dead,cursor,4)?;if owner!=0{s.observe_owner_release_shared(owner_manager,owner,action,m);owner_remove(m,dead,owner,action)?;put(m,dead,cursor,4,0)?;let input=get(m,dead,action.wrapping_add(12),4)?;crate::audio_path_source_virtual_cleanup::release_input_recursive(m,dead,input,3,pool,s)?;}cursor=cursor.wrapping_add(4);}}Ok(())
}
pub fn release_actions(m:&mut BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,source:u32,owner_manager:u32,s:&mut impl Services)->Result<(),Error>{let mut action=get(m,dead,source.wrapping_add(16),4)?;let mut seen=BTreeSet::new();while action!=0{if !seen.insert(action){return Err(Error::CyclicList);}release_action_owners(m,dead,action,owner_manager,s)?;action=get(m,dead,action.wrapping_add(8),4)?;}Ok(())}
fn descriptor_buffer(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,descriptor:u32,pool:u32,s:&mut impl Services)->Result<(),Error>{let buffer=get(m,dead,descriptor,4)?;if buffer!=0{put(m,dead,descriptor.wrapping_add(4),4,0)?;free(m,dead,pool,buffer,s)?;put(m,dead,descriptor,4,0)?;put(m,dead,descriptor.wrapping_add(8),4,0)?;}Ok(())}
fn parent_child_remove(m:&mut BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,parent:u32,source:u32)->Result<(),Error>{let owner=get(m,dead,parent.wrapping_add(28),4)?;if owner==0{return Ok(());}let base=get(m,dead,owner.wrapping_add(36),4)?;let count=get(m,dead,owner.wrapping_add(40),4)?;if count!=0{live(m,dead,base,(count as usize).checked_mul(4).ok_or(Error::InvalidAllocation)?)?;}for i in 0..count{let at=base.wrapping_add(i*4);if get(m,dead,at,4)?==source{if count>1{let tail=get(m,dead,base.wrapping_add((count-1)*4),4)?;put(m,dead,at,4,tail)?;}put(m,dead,owner.wrapping_add(40),4,count-1)?;break;}}Ok(())}
/// Original code explicitly revisits wrapper.word0 after its physical free.
/// Permit only that known retained snapshot read; other helpers reject retirees.
fn wrapper_parent(m:&BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,wrapper:u32)->Result<u32,Error>{if dead.contains(&wrapper){Ok(u32::from_le_bytes(crate::audio_path_memory::read(m,wrapper,4)?.try_into().unwrap()))}else{get(m,dead,wrapper,4)}}
pub fn destroy_source(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,source:u32,argument:u32,pool:u32,owner_manager:u32,callback_manager:u32,s:&mut impl Services)->Result<(),Error>{
 put(m,dead,source,4,0xff1cd8)?;
 // B01DA0 destroys the embedded28-byte value, preserving native upper flags.
 let flags=get(m,dead,source.wrapping_add(104),4)?;if flags&0x7c==4{let buffer=get(m,dead,source.wrapping_add(108),4)?;if buffer!=0{free(m,dead,pool,buffer,s)?;put(m,dead,source.wrapping_add(108),4,0)?;}}
 let flags=get(m,dead,source.wrapping_add(104),4)?&0xfffff800;put(m,dead,source.wrapping_add(104),4,flags)?;for(o,value)in[(88,0),(92,0xffffffff),(96,0),(100,0)]{put(m,dead,source.wrapping_add(o),4,value)?;}let flags=get(m,dead,source.wrapping_add(104),4)?&0xffffff7f;put(m,dead,source.wrapping_add(104),4,flags)?;put(m,dead,source.wrapping_add(108),4,0)?;
 put(m,dead,source,4,0xff0e80)?;put(m,dead,source,4,0xff0d2c)?;
 let descriptor=get(m,dead,source.wrapping_add(64),4)?;if descriptor!=0{
 let mut cursor=get(m,dead,descriptor,4)?;let mut seen=BTreeSet::new();loop{let descriptor=get(m,dead,source.wrapping_add(64),4)?;let base=get(m,dead,descriptor,4)?;let count=get(m,dead,descriptor.wrapping_add(4),4)?;let end=base.wrapping_add(count.checked_mul(8).ok_or(Error::InvalidAllocation)?);if cursor==end{break;}if !seen.insert(cursor){return Err(Error::CyclicList);}let child=get(m,dead,cursor.wrapping_add(4),4)?;if child!=0{s.state_object_destructor(child,m)?;free(m,dead,pool,child,s)?;}cursor=cursor.wrapping_add(8);}
 let descriptor=get(m,dead,source.wrapping_add(64),4)?;descriptor_buffer(m,dead,descriptor,pool,s)?;let descriptor=get(m,dead,source.wrapping_add(64),4)?;if descriptor!=0{free(m,dead,pool,descriptor,s)?;}put(m,dead,source.wrapping_add(64),4,0)?;
 }
 if get(m,dead,source.wrapping_add(68),4)?!=0{for operation in[ResourceOperation::Release,ResourceOperation::Clear]{let resource=get(m,dead,source.wrapping_add(68),4)?;s.resource68(resource,operation,m)?;}let resource=get(m,dead,source.wrapping_add(68),4)?;if resource!=0{s.resource68(resource,ResourceOperation::Destroy,m)?;free(m,dead,pool,resource,s)?;}put(m,dead,source.wrapping_add(68),4,0)?;}
 if get(m,dead,source.wrapping_add(68),4)?!=0{s.resource68(get(m,dead,source.wrapping_add(68),4)?,ResourceOperation::Release,m)?;}
 let descriptor=get(m,dead,source.wrapping_add(76),4)?;if descriptor!=0{descriptor_buffer(m,dead,descriptor,pool,s)?;let descriptor=get(m,dead,source.wrapping_add(76),4)?;if descriptor!=0{free(m,dead,pool,descriptor,s)?;}}
 for offset in[80,72]{let buffer=get(m,dead,source.wrapping_add(offset),4)?;if buffer!=0{free(m,dead,pool,buffer,s)?;}}put(m,dead,source.wrapping_add(72),4,0)?;
 let flags=get(m,dead,source.wrapping_add(47),1)?|1;put(m,dead,source.wrapping_add(47),1,flags)?;put(m,dead,source,4,0xff10f0)?;
 let buffer=get(m,dead,source.wrapping_add(24),4)?;if buffer!=0{free(m,dead,pool,buffer,s)?;}
 let mut index=0;while get(m,dead,source.wrapping_add(48),4)?|get(m,dead,source.wrapping_add(52),4)?!=0{if index>=64{return Err(Error::Backend("callback mask mutating already consumed bits is unqualified"));}let offset=if index<32{48}else{52};let bit=1u32<<(index%32);if get(m,dead,source.wrapping_add(offset),4)?&bit!=0{s.remove_callback(callback_manager,source,index,m)?;let bits=get(m,dead,source.wrapping_add(offset),4)?&!bit;put(m,dead,source.wrapping_add(offset),4,bits)?;}index+=1;}
 let callback=get(m,dead,source.wrapping_add(20),4)?;if callback!=0{s.state_object_destructor(callback,m)?;free(m,dead,pool,callback,s)?;}
 if get(m,dead,source.wrapping_add(16),4)?!=0{release_actions(m,dead,source,owner_manager,s)?;s.destroy_action_list_shared(source,1,m,dead,pool,owner_manager,callback_manager)?;}put(m,dead,source.wrapping_add(16),4,0)?;
 let wrapper=get(m,dead,source.wrapping_add(56),4)?;if wrapper!=0{let parent=get(m,dead,wrapper,4)?;if parent!=0{s.parent_virtual30(parent,source,m)?;}let wrapper=get(m,dead,source.wrapping_add(56),4)?;if wrapper!=0{free(m,dead,pool,wrapper,s)?;}}
 if get(m,dead,source.wrapping_add(28),4)?!=0{for offset in[32,36]{let parent=get(m,dead,source.wrapping_add(offset),4)?;if parent!=0{parent_child_remove(m,dead,parent,source)?;}}let wrapper=get(m,dead,source.wrapping_add(56),4)?;if wrapper!=0{let parent=wrapper_parent(m,dead,wrapper)?;if parent!=0{empty::remove_parent(m,dead,parent,source,s)?;}}let owner=get(m,dead,source.wrapping_add(28),4)?;if owner!=0{empty::destroy_owner(m,dead,owner,pool,s)?;}put(m,dead,source.wrapping_add(28),4,0)?;}
 let properties=get(m,dead,source.wrapping_add(40),4)?;if properties!=0{free(m,dead,pool,properties,s)?;}put(m,dead,source.wrapping_add(40),4,0)?;put(m,dead,source,4,0xff0ff4)?;put(m,dead,source,4,0xff0fe4)?;
 if argument&1!=0{s.operator_delete(source,m)?;dead.insert(source);}Ok(())
}
/// Native dependency composition through the real registry, action-owner and
/// derived source destructor bodies with shared retired state and physical map.
pub fn release_reference(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,source:u32,manager:u32,pool:u32,owner_manager:u32,callback_manager:u32,s:&mut impl Services)->Result<u32,Error>{
 let section=manager.wrapping_add(if get(m,dead,source.wrapping_add(47),1)?&2!=0{0x320}else{0});s.lock(section)?;let count=get(m,dead,source.wrapping_add(12),4)?.wrapping_sub(1);put(m,dead,source.wrapping_add(12),4,count)?;
 if count==0{let key=get(m,dead,source.wrapping_add(8),4)?;let inner=manager.wrapping_add(if get(m,dead,source.wrapping_add(47),1)?&2!=0{0x320}else{0});s.lock(inner)?;s.observe_manager_key(inner.wrapping_add(24),key);unlink_manager_key(m,dead,inner.wrapping_add(24),key)?;s.unlock(inner)?;s.observe_source14(source);release_actions(m,dead,source,owner_manager,s)?;for offset in[32,36]{let parent=get(m,dead,source.wrapping_add(offset),4)?;if parent!=0{s.parent_virtual30(parent,source,m)?;}}s.observe_source_destructor(source,0);destroy_source(m,dead,source,0,pool,owner_manager,callback_manager,s)?;free(m,dead,pool,source,s)?;
 }s.unlock(section)?;Ok(count)
}

#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 fn physical(m:&BTreeMap<u32,Memory>,base:u32,n:usize)->String{hex(&(0..n).map(|i|crate::audio_path_memory::read(m,base.wrapping_add(i as u32),1).unwrap()[0]).collect::<Vec<_>>())}
 fn insert(m:&mut BTreeMap<u32,Memory>,b:&Value,name:&str,base:u32,chunk:usize){let raw=bytes(b[name].as_str().unwrap());for(i,part)in raw.chunks(chunk).enumerate(){let reference=base+i as u32*chunk as u32;assert!(m.insert(reference,Memory{reference,raw:part.to_vec()}).is_none());}}
 struct Backend{calls:Vec<Value>,regions:Vec<(&'static str,u32,usize)>,owned:bool,actions:bool,parents:bool}
 impl Backend{fn snapshot(&self,m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r,size)in &self.regions{out[*n]=json!(physical(m,*r,*size));}out}}
 impl empty::Services for Backend{
 fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{let mut event=json!({"kind":"free","pool":p,"reference":r,"source_at_call":physical(m,0x40001000,160)});if self.owned{event["regions_at_call"]=self.snapshot(m);}self.calls.push(event);Ok(())}
 }
 impl Services for Backend{
 fn lock(&mut self,r:u32)->Result<(),Error>{self.calls.push(json!({"kind":"lock","receiver":r}));Ok(())}
 fn unlock(&mut self,r:u32)->Result<(),Error>{self.calls.push(json!({"kind":"unlock","receiver":r}));Ok(())}
 fn observe_manager_key(&mut self,r:u32,key:u32){self.calls.push(json!({"kind":"remove_manager_key","receiver":r,"key":key}));}
 fn observe_source14(&mut self,r:u32){self.calls.push(json!({"kind":"source_virtual14","receiver":r}));}
 fn observe_source_destructor(&mut self,r:u32,a:u32){self.calls.push(json!({"kind":"source_destructor","receiver":r,"argument":a}));}
 fn observe_owner_release(&mut self,r:u32,owner:u32,key:u32){self.calls.push(json!({"kind":"release_owner","receiver":r,"owner":owner,"key":key}));}
 fn input_virtual9c(&mut self,r:u32,a:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{if !self.actions{return Err(Error::Backend("input9c excluded from terminal fixture"));}self.calls.push(json!({"kind":"input_virtual9c","receiver":r,"selector":a,"at_call":self.snapshot(m)}));Ok(())}
 fn state_object_destructor(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("active state/callback objects excluded from fixture"))}
 fn resource68(&mut self,_:u32,_:ResourceOperation,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("resource68 excluded from fixture"))}
 fn remove_callback(&mut self,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("callback registry excluded from fixture"))}
 fn destroy_action_list(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("action list destruction excluded from fixture"))}
 fn parent_virtual30(&mut self,parent:u32,source:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{if !self.parents{return Err(Error::Backend("parent30 excluded from fixture"));}self.calls.push(json!({"kind":"parent_virtual30","receiver":parent,"source":source}));Ok(())}
 fn operator_delete(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("deleting destructor argument excluded from fixture"))}
 }
 fn terminal(owned:bool,parents:bool){let p:Value=serde_json::from_str(if parents{{
            static FIXTURE: std::sync::OnceLock<String> = std::sync::OnceLock::new();
            FIXTURE.get_or_init(|| {
                const PATH: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/../../data/4.20/audio_path_source_terminal_parent_release_preparation.json");
                let text = std::fs::read_to_string(PATH)
                    .unwrap_or_else(|error| panic!("cannot read frozen test fixture {PATH}: {error}"));
                assert_eq!(text.len(), 32151846, "frozen test fixture byte length: {PATH}");
                text
            }).as_str()
        }}else if owned{include_str!("../../../data/4.20/audio_path_source_terminal_owned_release_preparation.json")}else{include_str!("../../../data/4.20/audio_path_source_terminal_release_preparation.json")}).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],if parents{480}else if owned{320}else{160});for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m=BTreeMap::new();let mut regions=vec![("source",0x40001000,160),("manager",0x40005000,1600),("nodes",0x40007000,48),("buffers",0x40008000,160)];if owned{regions.extend([("owner",0x40009000,60),("owner_buffers",0x4000a000,96),("state_descriptor",0x4000b000,12),("state_buffer",0x4000b100,32),("parameter_descriptor",0x4000c000,12),("parameter_buffer",0x4000c100,32)]);}
 if parents{regions.extend([("parents",0x4000d000,512),("parent_owners",0x4000e000,512),("parent_tables",0x4000f100,128)]);}
 for(n,r,size)in &regions{insert(&mut m,&row["before"],n,*r,match *n{"buffers"|"owner_buffers"=>32,"nodes"=>16,"parents"|"parent_owners"=>256,"parent_tables"=>64,_=>*size});}
 let mut backend=Backend{calls:vec![],regions,owned,actions:false,parents};let mut dead=BTreeSet::new();let result=release_reference(&mut m,&mut dead,0x40001000,0x40005000,19,0x4000e000,0x4000e100,&mut backend).unwrap();assert_eq!(result,row["result"].as_u64().unwrap()as u32,"saved reference result {i}");assert_eq!(json!(backend.calls),row["calls"],"ordered real registry/source14/destructor/frees and exact free-time snapshots {i}");assert_eq!(backend.snapshot(&m),row["after"],"every source/manager/node/buffer/owner/descriptor/padding byte {i}");assert_eq!(dead.contains(&0x40001000),row["count"]==1);for r in dead.iter().copied(){assert_eq!(get(&m,&dead,r,1),Err(Error::UnresolvedReference),"retired logical guard {i}");}
 }}
 #[test]fn audio_path_source_terminal_cleanup_matches160_native_real_manager_source14_inline_destructor_base_vtables_simple_frees_and_saved_reference_cases(){terminal(false,false);}
 #[test]fn audio_path_source_terminal_cleanup_matches320_native_owned_source_owner_three_buffers_empty_state_parameter_tables_and_exact_free_time_memory_cases(){terminal(true,false);}
 #[test]fn audio_path_source_terminal_cleanup_matches324_native_action_packed_properties_actual_owner_release_and_cleared_slot_before_input9c_cases(){let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_source_action_owner_release_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],324);for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=vec![("source",0x40001000,96),("actions",0x40002000,64),("properties",0x40003000,128),("owners",0x40005000,384),("tables",0x40008000,96)];let mut m=BTreeMap::new();for(n,r,size)in &regions{insert(&mut m,&row["before"],n,*r,match *n{"owners"|"properties"=>64,"actions"=>32,"tables"=>16,_=>*size});}let mut backend=Backend{calls:vec![],regions,owned:false,actions:true,parents:false};release_actions(&mut m,&BTreeSet::new(),0x40001000,0x4000a000,&mut backend).unwrap();assert_eq!(json!(backend.calls),row["calls"],"native owner/input order and cleared-slot state {i}");assert_eq!(backend.snapshot(&m),row["after"],"full source/action/packed property/owner/table/padding bytes {i}");}}
 #[test]fn audio_path_source_terminal_cleanup_matches480_native_parent30_terminal_child_table36_count40_swap_last_and_exact_physical_lifetime_cases(){terminal(true,true);}

}
