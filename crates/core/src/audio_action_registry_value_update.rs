//! Original AF6FF0 state publication, AF7600 notifications and AF6A30 duration lookup.
//! Complete native transitions, recursive input acquisition and action callbacks compose in canonical storage.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put};
use crate::audio_path_source_property_query as properties;
#[derive(Clone,Copy,Debug)]pub struct Context{
 pub pool:u32,pub owner_manager:u32,pub callback_slot:u32,
 pub property:crate::audio_path_property_owner_update::Context,
 pub property_flags:[u8;5],
}
#[derive(Clone,Copy,Debug)]pub struct Transition{
 pub action:u32,pub property_type:u32,pub initial_bits:u32,pub target_bits:u32,
 pub duration:u32,pub curve:u32,pub flags:u8,pub processed:u8,
}
pub trait Services:properties::Services{
 fn observe_input_acquisition(&mut self,_source:u32,_selector:u32,_m:&BTreeMap<u32,Memory>){}
 fn observe_action_callback(&mut self,_action:u32,_ty:u32,_bits:u32,_finished:u32,_m:&BTreeMap<u32,Memory>){}
 fn observe_transition_creation(&mut self,_manager:u32,_descriptor:Transition,_first:u32,_second:u32,_m:&BTreeMap<u32,Memory>){}
 fn observe_existing_transition(&mut self,manager:u32,owner:u32,ty:u32,value_bits:u32,_duration:u32,m:&BTreeMap<u32,Memory>){self.observe_property_owner_update(manager,owner,ty,value_bits,m)}

 fn observe_state_notify(&mut self,_registry:u32,_key:u32,_old:u32,_new:u32,_m:&BTreeMap<u32,Memory>){}
 fn notification_virtual4(&mut self,receiver:u32,value:u32,argument:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<(),Error>;
 fn state_callback(&mut self,callback:u32,key:u32,value:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<u32,Error>;
 fn create_transition(&mut self,manager:u32,descriptor:Transition,first:u32,second:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<Option<u32>,Error>;
 fn input_virtual98(&mut self,source:u32,selector:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<u32,Error>;
 fn action_virtual0(&mut self,action:u32,ty:u32,value_bits:u32,argument:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<(),Error>;
}
fn find_key(m:&BTreeMap<u32,Memory>,d:&BTreeSet<u32>,registry:u32,key:u32)->Result<Option<u32>,Error>{
 let mut at=get(m,d,registry,4)?;let end=at.wrapping_add(get(m,d,registry.wrapping_add(4),4)?.wrapping_mul(8));let mut seen=BTreeSet::new();while at!=end{if !seen.insert(at){return Err(Error::CyclicList);}if get(m,d,at,4)?==key{let slot=at.wrapping_add(4);return if slot==0{Ok(None)}else{Ok(Some(get(m,d,slot,4)?))};}at=at.wrapping_add(8);}Ok(None)
}
fn notify(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,registry:u32,key:u32,old:u32,new:u32,s:&mut impl Services)->Result<(),Error>{
 s.observe_state_notify(registry,key,old,new,m);if old==new{return Ok(());}let mut node=get(m,d,registry.wrapping_add(12),4)?;let mut seen=BTreeSet::new();while node!=0{if !seen.insert(node){return Err(Error::CyclicList);}if get(m,d,node.wrapping_add(8),4)?==key{let target=get(m,d,node.wrapping_add(4),4)?;s.notification_virtual4(target,new,0,m,d)?;}node=get(m,d,node,4)?;}Ok(())
}
fn duration(m:&BTreeMap<u32,Memory>,d:&BTreeSet<u32>,owner:u32,new:u32)->Result<u32,Error>{
 let old=get(m,d,owner.wrapping_add(4),4)?;let mut at=get(m,d,owner.wrapping_add(12),4)?;let end=at.wrapping_add(get(m,d,owner.wrapping_add(16),4)?.wrapping_mul(12));let mut seen=BTreeSet::new();while at!=end{if !seen.insert(at){return Err(Error::CyclicList);}if get(m,d,at,4)?==old&&get(m,d,at.wrapping_add(4),4)?==new{return get(m,d,at.wrapping_add(8),4);}at=at.wrapping_add(12);}get(m,d,owner,4)
}

/// AF7280 changes the default duration at owner.word0; it preserves current state word4.
pub fn set_default_duration(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,registry:u32,key:u32,value:u32)->Result<u32,Error>{
 let Some(owner)=find_key(m,d,registry,key)?else{return Ok(20);};if owner==0{return Err(Error::UnresolvedReference);}put(m,d,owner,4,value)?;Ok(1)
}
/// Native first explicit old/new transition duration, then the owner.word0 fallback.
pub fn transition_duration(m:&BTreeMap<u32,Memory>,d:&BTreeSet<u32>,owner:u32,new:u32)->Result<u32,Error>{duration(m,d,owner,new)}

// Native packed lookup reads type0 padding even when count is zero.
fn property(m:&BTreeMap<u32,Memory>,d:&BTreeSet<u32>,blob:u32,ty:u32,stride:u32)->Result<Option<u32>,Error>{
 if blob==0{return Ok(None);}let count=get(m,d,blob,1)?;for i in 0..count.max(1){if get(m,d,blob.wrapping_add(i+1),1)?==ty{return Ok(Some(blob.wrapping_add(((count+4)&!3)+i*stride)));}}Ok(None)
}
fn child(m:&BTreeMap<u32,Memory>,d:&BTreeSet<u32>,action:u32,key:u32)->Result<u32,Error>{
 let mut at=get(m,d,action.wrapping_add(20),4)?;let end=at.wrapping_add(get(m,d,action.wrapping_add(24),4)?.wrapping_mul(12));let mut seen=BTreeSet::new();while at!=end{if !seen.insert(at){return Err(Error::CyclicList);}if get(m,d,at,4)?==key{return get(m,d,at.wrapping_add(4),4);}at=at.wrapping_add(12);}Ok(0)
}
fn release(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,manager:u32,owner:u32,action:u32,s:&mut impl Services)->Result<(),Error>{
 s.observe_owner_release_shared(manager,owner,action,m);crate::audio_path_source_terminal_cleanup::owner_remove(m,d,owner,action)
}
/// Ordered notification/veto, duration lookup, five properties per action, then owner.word4.
/// Existing transitions use the verified AF5670 implementation; allocation/setup is mandatory.
pub fn update(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,registry:u32,key:u32,new:u32,instant:u32,skip_notify:u32,c:Context,s:&mut impl Services)->Result<(),Error>{update_impl(m,d,registry,key,new,instant,skip_notify,c,s,None,None)}
type Creator<S>=fn(&mut BTreeMap<u32,Memory>,&mut BTreeSet<u32>,u32,u32,Transition,Context,&mut S)->Result<Option<u32>,Error>;
/// Compose real AF5490 creation in canonical memory; descriptor32 is caller stack storage.
pub fn update_native_transitions<S:Services+crate::audio_property_owner_creation::Services>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,registry:u32,key:u32,new:u32,instant:u32,skip_notify:u32,scratch:u32,c:Context,s:&mut S)->Result<(),Error>{update_impl(m,d,registry,key,new,instant,skip_notify,c,s,Some((scratch,native_create::<S>)),None)}
fn native_create<S:Services+crate::audio_property_owner_creation::Services>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,manager:u32,scratch:u32,descriptor:Transition,c:Context,s:&mut S)->Result<Option<u32>,Error>{
 for(i,value)in[descriptor.action,descriptor.property_type,descriptor.initial_bits,descriptor.target_bits,descriptor.duration,descriptor.curve].into_iter().enumerate(){put(m,d,scratch.wrapping_add(i as u32*4),4,value)?;}put(m,d,scratch.wrapping_add(24),1,descriptor.flags as u32)?;put(m,d,scratch.wrapping_add(25),1,descriptor.processed as u32)?;
 s.observe_transition_creation(manager,descriptor,1,1,m);let context=crate::audio_property_owner_creation::Context{pool:c.pool,clock:c.property.clock,frame_quantum:c.property.frame_quantum,conversion_cache:c.property.conversion_cache};crate::audio_property_owner_creation::create(m,d,manager,scratch,1,1,context,s)
}

type Acquire<S>=fn(&mut BTreeMap<u32,Memory>,&mut BTreeSet<u32>,u32,u32,u32,Context,&mut S)->Result<u8,Error>;
type Apply<S>=fn(&mut BTreeMap<u32,Memory>,&mut BTreeSet<u32>,u32,u32,u32,u32,u32,&mut S)->Result<(),Error>;
/// AF6FF0 composed with real AF5490, recursive Source98 and Action0/Source9C/CC.
/// Only allocation, notifications and dynamic selector boundaries remain ABI services.
pub fn update_native_callbacks<S:Services+crate::audio_property_owner_creation::Services+crate::audio_path_source_input_acquisition::Services+crate::audio_path_source_virtual_cleanup::InputReleaseServices>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,registry:u32,key:u32,new:u32,instant:u32,skip_notify:u32,scratch:u32,c:Context,s:&mut S)->Result<(),Error>{
 update_impl(m,d,registry,key,new,instant,skip_notify,c,s,Some((scratch,native_create_callbacks::<S>)),Some((native_acquire::<S>,native_apply::<S>,0)))
}
fn native_acquire<S:Services+crate::audio_path_source_input_acquisition::Services>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,source:u32,selector:u32,_rtpc_manager:u32,c:Context,s:&mut S)->Result<u8,Error>{s.observe_input_acquisition(source,selector,m);crate::audio_path_source_input_acquisition::acquire_recursive(m,d,source,selector,c.pool,s)}

/// Complete registry transition pipeline with the canonical dynamic RTPC source type producer.
pub fn update_native_rtpc_callbacks<S:Services+crate::audio_property_owner_creation::Services+crate::audio_path_source_input_acquisition::Services+crate::audio_path_source_virtual_cleanup::InputReleaseServices+crate::audio_dynamic_input_owner_selector::Services>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,registry:u32,key:u32,new:u32,instant:u32,skip_notify:u32,scratch:u32,rtpc_manager:u32,c:Context,s:&mut S)->Result<(),Error>{
 update_impl(m,d,registry,key,new,instant,skip_notify,c,s,Some((scratch,native_create_callbacks::<S>)),Some((native_rtpc_acquire::<S>,native_apply::<S>,rtpc_manager)))
}
fn native_rtpc_acquire<S:Services+crate::audio_path_source_input_acquisition::Services+crate::audio_dynamic_input_owner_selector::Services>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,source:u32,selector:u32,rtpc_manager:u32,c:Context,s:&mut S)->Result<u8,Error>{
 s.observe_input_acquisition(source,selector,m);crate::audio_dynamic_input_owner_selector::acquire_native_rtpc(m,d,source,selector,c.pool,crate::audio_dynamic_input_owner_selector::Context{manager:rtpc_manager,conversion_cache:c.property.conversion_cache},s)
}

fn native_apply<S:Services+crate::audio_path_source_virtual_cleanup::InputReleaseServices>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,action:u32,ty:u32,bits:u32,finished:u32,pool:u32,s:&mut S)->Result<(),Error>{s.observe_action_callback(action,ty,bits,finished&255,m);crate::audio_path_action_property_callback::apply(m,d,action,ty,bits,finished,pool,s)}
struct NativeCallbacks<'a,S>{backend:&'a mut S,pool:u32}
impl<S:Services>crate::audio_path_voice_empty_source_release::Services for NativeCallbacks<'_,S>{fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{crate::audio_path_voice_empty_source_release::Services::free(self.backend,p,r,m)}}
impl<S:Services+crate::audio_property_owner_creation::Services+crate::audio_path_source_virtual_cleanup::InputReleaseServices>crate::audio_property_owner_creation::Services for NativeCallbacks<'_,S>{
 fn allocate_owner(&mut self,p:u32,size:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{crate::audio_property_owner_creation::Services::allocate_owner(self.backend,p,size,m,d)}
 fn observe_owner_progression(&mut self,r:u32,time:u32,m:&BTreeMap<u32,Memory>){crate::audio_property_owner_creation::Services::observe_owner_progression(self.backend,r,time,m)}
 fn action_virtual0(&mut self,r:u32,ty:u32,bits:u32,finished:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{native_apply(m,d,r,ty,bits,finished,self.pool,self.backend)}
}
impl<S:Services+crate::audio_path_source_virtual_cleanup::InputReleaseServices>crate::audio_property_owner_progression::Services for NativeCallbacks<'_,S>{fn action_virtual0(&mut self,r:u32,ty:u32,bits:u32,finished:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{native_apply(m,d,r,ty,bits,finished,self.pool,self.backend)}}
fn native_create_callbacks<S:Services+crate::audio_property_owner_creation::Services+crate::audio_path_source_virtual_cleanup::InputReleaseServices>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,manager:u32,scratch:u32,descriptor:Transition,c:Context,s:&mut S)->Result<Option<u32>,Error>{
 for(i,value)in[descriptor.action,descriptor.property_type,descriptor.initial_bits,descriptor.target_bits,descriptor.duration,descriptor.curve].into_iter().enumerate(){put(m,d,scratch.wrapping_add(i as u32*4),4,value)?;}put(m,d,scratch.wrapping_add(24),1,descriptor.flags as u32)?;put(m,d,scratch.wrapping_add(25),1,descriptor.processed as u32)?;
 s.observe_transition_creation(manager,descriptor,1,1,m);let context=crate::audio_property_owner_creation::Context{pool:c.pool,clock:c.property.clock,frame_quantum:c.property.frame_quantum,conversion_cache:c.property.conversion_cache};crate::audio_property_owner_creation::create(m,d,manager,scratch,1,1,context,&mut NativeCallbacks{backend:s,pool:c.pool})
}
/// Real B20EE0 with canonical property publication, recursive release and active voice flags.
pub fn progress_native_callbacks<S:Services+crate::audio_property_owner_creation::Services+crate::audio_path_source_virtual_cleanup::InputReleaseServices>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,owner:u32,time:u32,pool:u32,s:&mut S)->Result<u8,Error>{crate::audio_property_owner_creation::Services::observe_owner_progression(s,owner,time,m);crate::audio_property_owner_progression::update(m,d,owner,time,&mut NativeCallbacks{backend:s,pool})}

fn update_impl<S:Services>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,registry:u32,key:u32,new:u32,instant:u32,skip_notify:u32,c:Context,s:&mut S,native:Option<(u32,Creator<S>)>,callbacks:Option<(Acquire<S>,Apply<S>,u32)>)->Result<(),Error>{
 let Some(owner)=find_key(m,d,registry,key)?else{return Ok(());};
 if skip_notify as u8==0{let old=get(m,d,owner.wrapping_add(4),4)?;notify(m,d,registry,key,old,new,s)?;let callback=get(m,d,c.callback_slot,4)?;if callback!=0&&instant as u8==0&&s.state_callback(callback,key,new,m,d)?as u8!=0{return Ok(());}}
 let duration=if instant as u8!=0{0}else{duration(m,d,owner,new)?};let mut action=get(m,d,owner.wrapping_add(8),4)?;let mut seen=BTreeSet::new();while action!=0{
 if !seen.insert(action){return Err(Error::CyclicList);}put(m,d,action.wrapping_add(36),4,new)?;let child=child(m,d,action,new)?;let mut changed=false;
 for ty in 0..5{let slot=action.wrapping_add(16);let blob=get(m,d,slot,4)?;let pair=property(m,d,blob,ty,8)?;let child_blob=if child==0{0}else{get(m,d,child.wrapping_add(16),4)?};let target=property(m,d,child_blob,ty,4)?.map(|at|get(m,d,at,4)).transpose()?.unwrap_or(0);
 let existing=pair.map(|at|get(m,d,at.wrapping_add(4),4)).transpose()?.unwrap_or(0);
 if existing!=0{s.observe_existing_transition(c.owner_manager,existing,ty,target,duration,m);crate::audio_path_property_owner_update::update(m,d,existing,ty,target,duration,4,0,c.property)?;continue;}
 let initial=pair.map(|at|get(m,d,at,4)).transpose()?.unwrap_or(0);
 // UCOMISS equality skips ordered equal values, including signed zero; unordered advances.
 if f32::from_bits(initial)==f32::from_bits(target){continue;}
 let descriptor=Transition{action,property_type:ty,initial_bits:initial,target_bits:target,duration,curve:4,flags:c.property_flags[ty as usize],processed:1};
 let new_owner=if let Some((scratch,create))=native{create(m,d,c.owner_manager,scratch,descriptor,c,s)?}else{s.create_transition(c.owner_manager,descriptor,1,1,m,d)?}.unwrap_or(0);
 let pair=if let Some(pair)=pair{Some(pair)}else{s.observe_append(slot,ty,m);properties::append(m,d,slot,ty,c.pool,s)?};
 let Some(pair)=pair else{if new_owner!=0{release(m,d,c.owner_manager,new_owner,action,s)?;}continue;};put(m,d,pair.wrapping_add(4),4,new_owner)?;
 if new_owner!=0{let input=get(m,d,action.wrapping_add(12),4)?;if (if let Some((acquire,_,rtpc_manager))=callbacks{acquire(m,d,input,3,rtpc_manager,c,s)?as u32}else{s.input_virtual98(input,3,m,d)?})as u8==0{if let Some((_,apply,_))=callbacks{apply(m,d,action,ty,target,1,c.pool,s)?;}else{s.action_virtual0(action,ty,target,1,m,d)?;}release(m,d,c.owner_manager,new_owner,action,s)?;}}
 else{put(m,d,pair,4,target)?;changed=true;}
 }
 if changed{let input=get(m,d,action.wrapping_add(12),4)?;crate::audio_path_source_action_list_cleanup::invalidate_source_voices(m,d,input,s)?;}
 action=get(m,d,action.wrapping_add(4),4)?;
 }put(m,d,owner.wrapping_add(4),4,new)?;Ok(())
}

#[cfg(test)]mod tests{
 use super::*;use crate::audio_path_source_terminal_cleanup as terminal;use crate::audio_path_source_action_list_cleanup as actions;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{calls:Vec<Value>,regions:Vec<(&'static str,u32,usize)>,failure:bool,next:u32,stride:u32,owned:bool,callback_result:u32}
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

 impl Services for Backend{
 fn observe_state_notify(&mut self,r:u32,key:u32,old:u32,new:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"state_notify","receiver":r,"arguments":[key,old,new],"at_call":self.snapshot(m)}));}
 fn state_callback(&mut self,_:u32,key:u32,new:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.calls.push(json!({"kind":"state_callback","arguments":[key,new],"result":self.callback_result,"at_call":self.snapshot(m)}));Ok(self.callback_result)}
 fn notification_virtual4(&mut self,r:u32,value:u32,argument:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.calls.push(json!({"kind":"notification_virtual4","receiver":r,"arguments":[value,argument],"at_call":self.snapshot(m)}));Ok(())}
 fn create_transition(&mut self,_:u32,_:Transition,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{Err(Error::Backend("transition producer requires qualification"))}
 fn input_virtual98(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("input98 requires qualification"))}
 fn action_virtual0(&mut self,_:u32,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{Err(Error::Backend("action0 requires qualification"))}
 }
 #[test]fn audio_action_registry_value_update_matches720_native_first_key_low_byte_flags_notification_callback_veto_and_complete_physical_memory_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_action_registry_value_update_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],720);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=vec![("registry",0x40001000,108),("table",0x40002000,24),("owners",0x40003000,72)];let mut m=BTreeMap::new();for(n,r,z)in &regions{let raw=bytes(row["before"][*n].as_str().unwrap());let size=if *n=="owners"{24}else{*z};for(j,part)in raw.chunks(size).enumerate(){let reference=r+j as u32*size as u32;m.insert(reference,Memory{reference,raw:part.to_vec()});}}
 m.insert(0x14a7a0c,Memory{reference:0x14a7a0c,raw:(if row["callback_kind"]=="null"{0u32}else{0x4001f000u32}).to_le_bytes().to_vec()});let mut dead=BTreeSet::new();let mut s=Backend{calls:vec![],regions,failure:false,next:0,stride:0,owned:false,callback_result:row["callback_result"].as_u64().unwrap()as u32};let c=Context{pool:19,owner_manager:0,callback_slot:0x14a7a0c,property:crate::audio_path_property_owner_update::Context{clock:0,frame_quantum:48,conversion_cache:0},property_flags:[0;5]};
 update(&mut m,&mut dead,0x40001000,row["key"].as_u64().unwrap()as u32,row["new_value"].as_u64().unwrap()as u32,row["instant_argument"].as_u64().unwrap()as u32,row["skip_notify_argument"].as_u64().unwrap()as u32,c,&mut s).unwrap();assert_eq!(json!(s.calls),row["calls"],"notification and callback snapshots {i}");assert_eq!(s.snapshot(&m),row["after"],"all physical registry/table/owner bytes {i}");assert!(dead.is_empty());
 }
 } #[test]fn audio_action_registry_value_update_matches2160_native_nonempty_notification_traversal_first_all_missing_keys_low_byte_callback_veto_and_complete_physical_memory_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_action_registry_value_update_notifications_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],2160);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=vec![("registry",0x40001000,108),("table",0x40002000,24),("owners",0x40003000,72),("notifications",0x40005000,36),("receivers",0x40006000,24),("notification_vtable",0x40007000,8)];let mut m=BTreeMap::new();for(n,r,z)in &regions{let raw=bytes(row["before"][*n].as_str().unwrap());let size=if *n=="owners"{24}else{*z};for(j,part)in raw.chunks(size).enumerate(){let reference=r+j as u32*size as u32;m.insert(reference,Memory{reference,raw:part.to_vec()});}}
 m.insert(0x14a7a0c,Memory{reference:0x14a7a0c,raw:(if row["callback_kind"]=="null"{0u32}else{0x4001f000u32}).to_le_bytes().to_vec()});let mut dead=BTreeSet::new();let mut s=Backend{calls:vec![],regions,failure:false,next:0,stride:0,owned:false,callback_result:row["callback_result"].as_u64().unwrap()as u32};let c=Context{pool:19,owner_manager:0,callback_slot:0x14a7a0c,property:crate::audio_path_property_owner_update::Context{clock:0,frame_quantum:48,conversion_cache:0},property_flags:[0;5]};
 update(&mut m,&mut dead,0x40001000,row["key"].as_u64().unwrap()as u32,row["new_value"].as_u64().unwrap()as u32,row["instant_argument"].as_u64().unwrap()as u32,row["skip_notify_argument"].as_u64().unwrap()as u32,c,&mut s).unwrap();assert_eq!(json!(s.calls),row["calls"],"notification and callback snapshots {i}");assert_eq!(s.snapshot(&m),row["after"],"all physical registry/table/owner bytes {i}");assert!(dead.is_empty());
 }
 }
}

#[cfg(test)]mod native_transition_tests{
 use super::*;use crate::audio_path_source_terminal_cleanup as terminal;use crate::audio_path_source_action_list_cleanup as actions;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{calls:Vec<Value>,regions:Vec<(&'static str,u32,usize)>,failure:bool,next:u32,stride:u32,owned:bool,callback_result:u32}
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

 impl Services for Backend{
 fn observe_existing_transition(&mut self,r:u32,owner:u32,ty:u32,bits:u32,duration:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"update_property_owner","receiver":r,"arguments":[owner,ty,bits,duration,4,0],"at_call":self.snapshot(m)}));}
 fn observe_transition_creation(&mut self,r:u32,d:Transition,first:u32,second:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"create_transition","receiver":r,"descriptor_words":[d.action,d.property_type,d.initial_bits,d.target_bits,d.duration,d.curve],"descriptor_flags":[d.flags,d.processed],"arguments":[first,second],"at_call":self.snapshot(m)}));}
 fn observe_state_notify(&mut self,r:u32,key:u32,old:u32,new:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"state_notify","receiver":r,"arguments":[key,old,new],"at_call":self.snapshot(m)}));}
 fn state_callback(&mut self,_:u32,key:u32,new:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.calls.push(json!({"kind":"state_callback","arguments":[key,new],"result":self.callback_result,"at_call":self.snapshot(m)}));Ok(self.callback_result)}
 fn notification_virtual4(&mut self,r:u32,value:u32,argument:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.calls.push(json!({"kind":"notification_virtual4","receiver":r,"arguments":[value,argument],"at_call":self.snapshot(m)}));Ok(())}
 fn create_transition(&mut self,_:u32,_:Transition,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{Err(Error::Backend("transition producer requires qualification"))}
 fn input_virtual98(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("input98 requires qualification"))}
 fn action_virtual0(&mut self,r:u32,ty:u32,bits:u32,finished:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.calls.push(json!({"kind":"action_virtual0","receiver":r,"arguments":[ty,bits,finished],"at_call":self.snapshot(m)}));Ok(())}
 }

 impl crate::audio_property_owner_creation::Services for Backend{
 fn allocate_owner(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{Err(Error::Backend("manager count limit0 excludes fresh allocation in this composition"))}
 fn action_virtual0(&mut self,r:u32,ty:u32,bits:u32,finished:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{<Self as Services>::action_virtual0(self,r,ty,bits,finished,m,d)}
 }
 #[test]fn audio_action_registry_value_update_matches576_native_nonempty_actions_duration_first_lookup_actual_owner_update_real_transition_fallback_and_complete_physical_memory_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_action_registry_nonempty_value_update_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],576);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=vec![("registry",0x40001000,108),("table",0x40002000,8),("state",0x40003000,24),("action",0x40004000,44),("properties",0x40005000,48),("source",0x40006000,120),("transitions",0x40007000,36),("manager",0x40008000,28),("property_owner",0x40009000,56),("clock",0x4000a000,128),("conversion_cache",0x14a7970,8)];let mut m:BTreeMap<u32,Memory>=regions.iter().map(|(n,r,_)|(*r,Memory{reference:*r,raw:bytes(row["before"][*n].as_str().unwrap())})).collect();let mut dead=BTreeSet::new();let mut s=Backend{calls:vec![],regions,failure:false,next:0,stride:0,owned:false,callback_result:row["callback_result"].as_u64().unwrap()as u32};m.insert(0x14a7a0c,Memory{reference:0x14a7a0c,raw:(if row["callback_kind"]=="null"{0u32}else{0x4001f000u32}).to_le_bytes().to_vec()});m.insert(0x4001c000,Memory{reference:0x4001c000,raw:vec![0;32]});let c=Context{pool:19,owner_manager:0x40008000,callback_slot:0x14a7a0c,property:crate::audio_path_property_owner_update::Context{clock:0x4000a000,frame_quantum:48,conversion_cache:0x14a7970},property_flags:[1,1,0,0,1]};
 update_native_transitions(&mut m,&mut dead,0x40001000,row["key"].as_u64().unwrap()as u32,row["new_value"].as_u64().unwrap()as u32,row["instant_argument"].as_u64().unwrap()as u32,row["skip_notify_argument"].as_u64().unwrap()as u32,0x4001c000,c,&mut s).unwrap();assert_eq!(json!(s.calls),row["calls"],"all owner update/fallback/state/CC snapshots {i}");assert_eq!(s.snapshot(&m),row["after"],"all canonical property/state/source/manager/clock bytes {i}");assert!(dead.is_empty());
 }
 }
}

#[cfg(test)]mod native_callback_tests{
 use super::*;use crate::audio_path_source_terminal_cleanup as terminal;use crate::audio_path_source_action_list_cleanup as actions;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{calls:Vec<Value>,regions:Vec<(&'static str,u32,usize)>,failure:bool,next:u32,stride:u32,owned:bool,callback_result:u32,oom:String,owner_index:u32,binding_index:u32,allocated:Vec<(u32,u32)>,mutation:String,mutated:bool}
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

 impl Services for Backend{
 fn observe_transition_creation(&mut self,r:u32,t:Transition,first:u32,second:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"create_transition","receiver":r,"descriptor_words":[t.action,t.property_type,t.initial_bits,t.target_bits,t.duration,t.curve],"descriptor_flags":[t.flags,t.processed],"arguments":[first,second],"at_call":self.snapshot(m)}));}
 fn observe_input_acquisition(&mut self,r:u32,selector:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"input_virtual98","receiver":r,"selector":selector,"at_call":self.snapshot(m)}));}
 fn observe_action_callback(&mut self,r:u32,ty:u32,bits:u32,finished:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"action_virtual0","receiver":r,"arguments":[ty,bits,finished],"at_call":self.snapshot(m)}));}

 fn observe_state_notify(&mut self,r:u32,key:u32,old:u32,new:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"state_notify","receiver":r,"arguments":[key,old,new],"at_call":self.snapshot(m)}));}
 fn state_callback(&mut self,_:u32,key:u32,new:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.calls.push(json!({"kind":"state_callback","arguments":[key,new],"result":self.callback_result,"at_call":self.snapshot(m)}));Ok(self.callback_result)}
 fn notification_virtual4(&mut self,r:u32,value:u32,argument:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.calls.push(json!({"kind":"notification_virtual4","receiver":r,"arguments":[value,argument],"at_call":self.snapshot(m)}));Ok(())}
 fn create_transition(&mut self,_:u32,_:Transition,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{Err(Error::Backend("transition producer requires qualification"))}
 fn input_virtual98(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("input98 requires qualification"))}
 fn action_virtual0(&mut self,_:u32,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{Err(Error::Backend("action0 requires qualification"))}
 }

 impl Backend{fn allocate(&mut self,p:u32,size:u32,m:&mut BTreeMap<u32,Memory>)->Result<Option<u32>,Error>{let fail=match size{56=>self.oom=="owner",32=>self.oom=="binding",60=>self.oom=="input",_=>return Err(Error::Backend("unexpected allocation"))};let result=if fail{0}else{match size{56=>{let r=0x4000c000+self.owner_index*64;self.owner_index+=1;r},32=>{let r=0x4000e000+self.binding_index*32;self.binding_index+=1;r},60=>0x40007000,_=>unreachable!()}};self.calls.push(json!({"kind":"allocate","pool":p,"size":size,"result":result,"at_call":self.snapshot(m)}));if result!=0{self.allocated.push((result,size));}
 if size==56&&!self.mutated&&!self.mutation.is_empty(){self.mutated=true;let(at,value)=match self.mutation.as_str(){"selected_blob_swap"=>(0x40010010,0x40013000),"selected_table_swap"=>(0x40011004,0),"action_blob_swap"=>(0x40004010,0x40013000),"queue_capacity_zero"=>(0x40008018,0),_=>return Err(Error::Backend("unknown native allocator mutation"))};put(m,&BTreeSet::new(),at,4,value)?;}
 Ok((result!=0).then_some(result))}}
 impl crate::audio_property_owner_creation::Services for Backend{
 fn allocate_owner(&mut self,p:u32,size:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{self.allocate(p,size,m)}
 fn observe_owner_progression(&mut self,r:u32,time:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"progress_owner","receiver":r,"time":time,"at_call":self.snapshot(m)}));}
 fn action_virtual0(&mut self,_:u32,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{Err(Error::Backend("native composition must bypass controlled Action0"))}
 }
 impl crate::audio_path_source_input_acquisition::Services for Backend{
 fn allocate_input(&mut self,p:u32,size:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{self.allocate(p,size,m)}
 fn dynamic_owner_type(&mut self,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u16,Error>{Err(Error::Backend("dynamic selector excluded from this native matrix"))}
 fn parent_virtual98(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("recursive native acquisition must bypass controlled parent"))}
 }
 #[test]fn audio_registry_native_callbacks_matches288_original_transition_creation_acquisition_progression_recursive_release_active_voice_flags_oom_and_complete_physical_lifetimes(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_registry_native_transition_callbacks_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],288);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){
 let regions=vec![("registry",0x40001000,108),("key_table",0x40002000,8),("state",0x40003000,24),("action",0x40004000,44),("properties",0x40005000,48),("source",0x40006000,120),("input_owner",0x40007000,60),("manager",0x40008000,28),("queues",0x40009000,64),("clock",0x4000a000,128),("voices",0x4000b000,424),("property_owners",0x4000c000,320),("bindings",0x4000e000,160),("conversion_cache",0x14a7970,8)];
 let mut m=BTreeMap::new();for(n,r,z)in &regions{let raw=bytes(row["before"][*n].as_str().unwrap());assert_eq!(raw.len(),*z);if *n=="property_owners"{for(j,slot)in raw.chunks(64).enumerate(){let reference=r+j as u32*64;m.insert(reference,Memory{reference,raw:slot[..56].to_vec()});m.insert(reference+56,Memory{reference:reference+56,raw:slot[56..].to_vec()});}}else{let size=if *n=="bindings"{32}else{*z};for(j,part)in raw.chunks(size).enumerate(){let reference=r+j as u32*size as u32;m.insert(reference,Memory{reference,raw:part.to_vec()});}}}
 m.insert(0x40018000,Memory{reference:0x40018000,raw:vec![0;32]});let mut d=BTreeSet::new();let mut s=Backend{calls:vec![],regions,failure:false,next:0,stride:0,owned:true,callback_result:0,oom:row["failure"].as_str().unwrap().to_owned(),owner_index:0,binding_index:0,allocated:vec![],mutation:String::new(),mutated:false};let c=Context{pool:19,owner_manager:0x40008000,callback_slot:0,property:crate::audio_path_property_owner_update::Context{clock:0x4000a000,frame_quantum:48,conversion_cache:0x14a7970},property_flags:[1,1,0,0,1]};
 update_native_callbacks(&mut m,&mut d,0x40001000,row["key"].as_u64().unwrap()as u32,row["new_value"].as_u64().unwrap()as u32,row["instant_argument"].as_u64().unwrap()as u32,1,0x40018000,c,&mut s).unwrap();
 assert_eq!(json!(s.calls),row["creation_calls"],"every creation/input/action/free/voice snapshot {i}");assert_eq!(s.snapshot(&m),row["after_creation"],"complete canonical creation physical bank {i}");s.calls.clear();
 for(step_index,step)in row["steps"].as_array().unwrap().iter().enumerate(){assert_eq!(s.snapshot(&m),step["before"],"progression input {i}/{step_index}");let finished=progress_native_callbacks(&mut m,&mut d,step["owner"].as_u64().unwrap()as u32,step["time"].as_u64().unwrap()as u32,19,&mut s).unwrap();assert_eq!(finished as u64,step["finished"].as_u64().unwrap(),"progression return {i}/{step_index}");assert_eq!(json!(s.calls),step["calls"],"all progression/action/release/voice snapshots {i}/{step_index}");assert_eq!(s.snapshot(&m),step["after"],"complete progression physical bank {i}/{step_index}");s.calls.clear();}
 assert_eq!(s.snapshot(&m),row["after"],"final physical lifetime {i}");let expected:BTreeSet<u32>=row["freed"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect();assert_eq!(d,expected,"retired allocations {i}");let allocations:Vec<Value>=s.allocated.iter().map(|(reference,size)|json!({"reference":reference,"size":size})).collect();assert_eq!(json!(allocations),row["allocations"],"actual allocation identities and sizes {i}");for r in &d{assert_eq!(get(&m,&d,*r,1),Err(Error::UnresolvedReference));}
 }
 }
 #[test]fn audio_registry_selected_child_callbacks_matches288_original_first_duplicate_later_match_zero_count_padding_targets_transition_lifetimes_and_active_voice_physical_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_registry_selected_child_callbacks_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],288);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){
 let regions:Vec<(&str,u32,usize)>=p["regions"].as_array().unwrap().iter().map(|v|(match v["name"].as_str().unwrap(){"registry"=>"registry","key_table"=>"key_table","state"=>"state","action"=>"action","properties"=>"properties","source"=>"source","input_owner"=>"input_owner","manager"=>"manager","queues"=>"queues","clock"=>"clock","voices"=>"voices","property_owners"=>"property_owners","bindings"=>"bindings","conversion_cache"=>"conversion_cache","selected_child"=>"selected_child","selected_children"=>"selected_children","selected_properties"=>"selected_properties",_=>panic!("unexpected fixture region")},v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect();
 let mut m=BTreeMap::new();for(n,r,z)in &regions{let raw=bytes(row["before"][*n].as_str().unwrap());assert_eq!(raw.len(),*z);if *n=="property_owners"{for(j,slot)in raw.chunks(64).enumerate(){let reference=r+j as u32*64;m.insert(reference,Memory{reference,raw:slot[..56].to_vec()});m.insert(reference+56,Memory{reference:reference+56,raw:slot[56..].to_vec()});}}else{let size=if *n=="bindings"{32}else{*z};for(j,part)in raw.chunks(size).enumerate(){let reference=r+j as u32*size as u32;m.insert(reference,Memory{reference,raw:part.to_vec()});}}}
 m.insert(0x40018000,Memory{reference:0x40018000,raw:vec![0;32]});let mut d=BTreeSet::new();let mut s=Backend{calls:vec![],regions,failure:false,next:0,stride:0,owned:true,callback_result:0,oom:row["failure"].as_str().unwrap().to_owned(),owner_index:0,binding_index:0,allocated:vec![],mutation:String::new(),mutated:false};let c=Context{pool:19,owner_manager:0x40008000,callback_slot:0,property:crate::audio_path_property_owner_update::Context{clock:0x4000a000,frame_quantum:48,conversion_cache:0x14a7970},property_flags:[1,1,0,0,1]};
 update_native_callbacks(&mut m,&mut d,0x40001000,row["key"].as_u64().unwrap()as u32,row["new_value"].as_u64().unwrap()as u32,row["instant_argument"].as_u64().unwrap()as u32,1,0x40018000,c,&mut s).unwrap();
 assert_eq!(json!(s.calls),row["creation_calls"],"every creation/input/action/free/voice snapshot {i}");assert_eq!(s.snapshot(&m),row["after_creation"],"complete canonical creation physical bank {i}");s.calls.clear();
 for(step_index,step)in row["steps"].as_array().unwrap().iter().enumerate(){assert_eq!(s.snapshot(&m),step["before"],"progression input {i}/{step_index}");let finished=progress_native_callbacks(&mut m,&mut d,step["owner"].as_u64().unwrap()as u32,step["time"].as_u64().unwrap()as u32,19,&mut s).unwrap();assert_eq!(finished as u64,step["finished"].as_u64().unwrap(),"progression return {i}/{step_index}");assert_eq!(json!(s.calls),step["calls"],"all progression/action/release/voice snapshots {i}/{step_index}");assert_eq!(s.snapshot(&m),step["after"],"complete progression physical bank {i}/{step_index}");s.calls.clear();}
 assert_eq!(s.snapshot(&m),row["after"],"final physical lifetime {i}");let expected:BTreeSet<u32>=row["freed"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect();assert_eq!(d,expected,"retired allocations {i}");let allocations:Vec<Value>=s.allocated.iter().map(|(reference,size)|json!({"reference":reference,"size":size})).collect();assert_eq!(json!(allocations),row["allocations"],"actual allocation identities and sizes {i}");for r in &d{assert_eq!(get(&m,&d,*r,1),Err(Error::UnresolvedReference));}
 }
 }
 #[test]fn audio_registry_allocator_mutation_callbacks_matches256_original_selected_blob_table_action_blob_queue_capacity_reloads_cached_values_oom_and_complete_physical_lifetimes(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_registry_allocator_mutation_callbacks_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],256);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){
 let regions:Vec<(&str,u32,usize)>=p["regions"].as_array().unwrap().iter().map(|v|(match v["name"].as_str().unwrap(){"registry"=>"registry","key_table"=>"key_table","state"=>"state","action"=>"action","properties"=>"properties","source"=>"source","input_owner"=>"input_owner","manager"=>"manager","queues"=>"queues","clock"=>"clock","voices"=>"voices","property_owners"=>"property_owners","bindings"=>"bindings","conversion_cache"=>"conversion_cache","selected_child"=>"selected_child","selected_children"=>"selected_children","selected_properties"=>"selected_properties","alternate_properties"=>"alternate_properties",_=>panic!("unexpected fixture region")},v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect();
 let mut m=BTreeMap::new();for(n,r,z)in &regions{let raw=bytes(row["before"][*n].as_str().unwrap());assert_eq!(raw.len(),*z);if *n=="property_owners"{for(j,slot)in raw.chunks(64).enumerate(){let reference=r+j as u32*64;m.insert(reference,Memory{reference,raw:slot[..56].to_vec()});m.insert(reference+56,Memory{reference:reference+56,raw:slot[56..].to_vec()});}}else{let size=if *n=="bindings"{32}else{*z};for(j,part)in raw.chunks(size).enumerate(){let reference=r+j as u32*size as u32;m.insert(reference,Memory{reference,raw:part.to_vec()});}}}
 m.insert(0x40018000,Memory{reference:0x40018000,raw:vec![0;32]});let mut d=BTreeSet::new();let mut s=Backend{calls:vec![],regions,failure:false,next:0,stride:0,owned:true,callback_result:0,oom:row["failure"].as_str().unwrap().to_owned(),owner_index:0,binding_index:0,allocated:vec![],mutation:row["mutation"].as_str().unwrap().to_owned(),mutated:false};let c=Context{pool:19,owner_manager:0x40008000,callback_slot:0,property:crate::audio_path_property_owner_update::Context{clock:0x4000a000,frame_quantum:48,conversion_cache:0x14a7970},property_flags:[1,1,0,0,1]};
 update_native_callbacks(&mut m,&mut d,0x40001000,row["key"].as_u64().unwrap()as u32,row["new_value"].as_u64().unwrap()as u32,row["instant_argument"].as_u64().unwrap()as u32,1,0x40018000,c,&mut s).unwrap();
 assert_eq!(json!(s.calls),row["creation_calls"],"every creation/input/action/free/voice snapshot {i}");assert_eq!(s.snapshot(&m),row["after_creation"],"complete canonical creation physical bank {i}");s.calls.clear();
 for(step_index,step)in row["steps"].as_array().unwrap().iter().enumerate(){assert_eq!(s.snapshot(&m),step["before"],"progression input {i}/{step_index}");let finished=progress_native_callbacks(&mut m,&mut d,step["owner"].as_u64().unwrap()as u32,step["time"].as_u64().unwrap()as u32,19,&mut s).unwrap();assert_eq!(finished as u64,step["finished"].as_u64().unwrap(),"progression return {i}/{step_index}");assert_eq!(json!(s.calls),step["calls"],"all progression/action/release/voice snapshots {i}/{step_index}");assert_eq!(s.snapshot(&m),step["after"],"complete progression physical bank {i}/{step_index}");s.calls.clear();}
 assert_eq!(s.snapshot(&m),row["after"],"final physical lifetime {i}");let expected:BTreeSet<u32>=row["freed"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect();assert_eq!(d,expected,"retired allocations {i}");let allocations:Vec<Value>=s.allocated.iter().map(|(reference,size)|json!({"reference":reference,"size":size})).collect();assert_eq!(json!(allocations),row["allocations"],"actual allocation identities and sizes {i}");for r in &d{assert_eq!(get(&m,&d,*r,1),Err(Error::UnresolvedReference));}
 }
 }

 impl crate::audio_dynamic_input_owner_selector::Services for Backend{
 fn observe_rtpc_manager(&mut self,r:u32,source:u32,parameter:u32,owner:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"rtpc_manager","receiver":r,"arguments":[source,parameter,owner],"at_call":self.snapshot(m)}));}
 fn observe_rtpc_curve(&mut self,r:u32,input:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"curve","receiver":r,"input_bits":input,"at_call":self.snapshot(m)}));}
 }
 #[test]fn audio_registry_dynamic_rtpc_callbacks_matches192_original_transition_acquisition_real_rtpc_source_type_constructor_callback_release_active_voice_progression_oom_and_complete_physical_lifetimes(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_registry_dynamic_rtpc_callbacks_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],192);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){
 let regions:Vec<(&str,u32,usize)>=p["regions"].as_array().unwrap().iter().map(|v|(match v["name"].as_str().unwrap(){"registry"=>"registry","key_table"=>"key_table","state"=>"state","action"=>"action","properties"=>"properties","source"=>"source","input_owner"=>"input_owner","manager"=>"manager","queues"=>"queues","clock"=>"clock","voices"=>"voices","property_owners"=>"property_owners","bindings"=>"bindings","conversion_cache"=>"conversion_cache","selected_child"=>"selected_child","selected_children"=>"selected_children","selected_properties"=>"selected_properties","rtpc_manager"=>"rtpc_manager","rtpc_binding"=>"rtpc_binding","rtpc_collision"=>"rtpc_collision","rtpc_curves"=>"rtpc_curves","rtpc_points"=>"rtpc_points",_=>panic!("unexpected fixture region")},v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect();
 let mut m=BTreeMap::new();for(n,r,z)in &regions{let raw=bytes(row["before"][*n].as_str().unwrap());assert_eq!(raw.len(),*z);if *n=="property_owners"{for(j,slot)in raw.chunks(64).enumerate(){let reference=r+j as u32*64;m.insert(reference,Memory{reference,raw:slot[..56].to_vec()});m.insert(reference+56,Memory{reference:reference+56,raw:slot[56..].to_vec()});}}else{let size=if *n=="bindings"{32}else{*z};for(j,part)in raw.chunks(size).enumerate(){let reference=r+j as u32*size as u32;m.insert(reference,Memory{reference,raw:part.to_vec()});}}}
 m.insert(0x4001c000,Memory{reference:0x4001c000,raw:vec![0;32]});let mut d=BTreeSet::new();let mut s=Backend{calls:vec![],regions,failure:false,next:0,stride:0,owned:true,callback_result:0,oom:row["failure"].as_str().unwrap().to_owned(),owner_index:0,binding_index:0,allocated:vec![],mutation:String::new(),mutated:false};let c=Context{pool:19,owner_manager:0x40008000,callback_slot:0,property:crate::audio_path_property_owner_update::Context{clock:0x4000a000,frame_quantum:48,conversion_cache:0x14a7970},property_flags:[1,1,0,0,1]};
 update_native_rtpc_callbacks(&mut m,&mut d,0x40001000,row["key"].as_u64().unwrap()as u32,row["new_value"].as_u64().unwrap()as u32,row["instant_argument"].as_u64().unwrap()as u32,1,0x4001c000,0x40014000,c,&mut s).unwrap();
 assert_eq!(json!(s.calls),row["creation_calls"],"every creation/input/action/free/voice snapshot {i}");assert_eq!(s.snapshot(&m),row["after_creation"],"complete canonical creation physical bank {i}");s.calls.clear();
 for(step_index,step)in row["steps"].as_array().unwrap().iter().enumerate(){assert_eq!(s.snapshot(&m),step["before"],"progression input {i}/{step_index}");let finished=progress_native_callbacks(&mut m,&mut d,step["owner"].as_u64().unwrap()as u32,step["time"].as_u64().unwrap()as u32,19,&mut s).unwrap();assert_eq!(finished as u64,step["finished"].as_u64().unwrap(),"progression return {i}/{step_index}");assert_eq!(json!(s.calls),step["calls"],"all progression/action/release/voice snapshots {i}/{step_index}");assert_eq!(s.snapshot(&m),step["after"],"complete progression physical bank {i}/{step_index}");s.calls.clear();}
 assert_eq!(s.snapshot(&m),row["after"],"final physical lifetime {i}");let expected:BTreeSet<u32>=row["freed"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect();assert_eq!(d,expected,"retired allocations {i}");let allocations:Vec<Value>=s.allocated.iter().map(|(reference,size)|json!({"reference":reference,"size":size})).collect();assert_eq!(json!(allocations),row["allocations"],"actual allocation identities and sizes {i}");for r in &d{assert_eq!(get(&m,&d,*r,1),Err(Error::UnresolvedReference));}
 }
 }
}

#[cfg(test)]mod default_duration_tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 fn snapshot(m:&BTreeMap<u32,Memory>,regions:&[(String,u32,usize)])->Value{let mut out=json!({});for(n,r,z)in regions{out[n]=json!(hex(&(0..*z).map(|i|crate::audio_path_memory::read(m,r+i as u32,1).unwrap()[0]).collect::<Vec<_>>()));}out}
 #[test]fn audio_action_registry_default_duration_matches120_original_first_key_duplicate_missing_null_owner_duration_state_separation_transition_priority_and_complete_physical_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_action_registry_default_duration_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],120);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m=BTreeMap::new();for(n,r,z)in &regions{let raw=bytes(row["before"][n].as_str().unwrap());let size=if n=="owners"||n=="transitions"{24}else{*z};for(j,b)in raw.chunks(size).enumerate(){let reference=r+j as u32*size as u32;m.insert(reference,Memory{reference,raw:b.to_vec()});}}
 let d=BTreeSet::new();let result=set_default_duration(&mut m,&d,0x40001000,row["key"].as_u64().unwrap()as u32,row["duration"].as_u64().unwrap()as u32);if row["fault"].is_null(){assert_eq!(result.unwrap()as u64,row["result"].as_u64().unwrap(),"native status {i}");}else{assert_eq!(row["fault"],"native_null_owner_default_write");assert_eq!(result,Err(Error::UnresolvedReference),"NULL write boundary {i}");}
 assert_eq!(snapshot(&m,&regions),row["after"],"all default/current/transition bytes {i}");
 for lookup in row["duration_lookups"].as_array().unwrap(){assert_eq!(transition_duration(&m,&d,lookup["owner"].as_u64().unwrap()as u32,lookup["new_value"].as_u64().unwrap()as u32).unwrap()as u64,lookup["effective_duration"].as_u64().unwrap(),"first explicit transition/fallback {i}");}
 }}
}
