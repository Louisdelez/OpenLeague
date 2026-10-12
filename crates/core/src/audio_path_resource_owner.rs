//! AF22A0 disable without property notification: complete owned resource release.
//! Other enable/notification and virtual-reference bodies remain explicit services.
use std::collections::BTreeMap;
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_path_resource,audio_timed_node_segment::Runtime as Paths};
fn word(b:&[u8],o:usize)->u32{u32::from_le_bytes(b[o..o+4].try_into().unwrap())}
fn set(b:&mut[u8],o:usize,v:u32){b[o..o+4].copy_from_slice(&v.to_le_bytes());}
pub trait Services:audio_path_resource::Services{fn release_virtual_reference(&mut self,reference:u32)->Result<(),Error>;fn observe_owner_release(&mut self,_owner:&Memory){}}
fn release_auxiliary(resource:&mut Memory,auxiliary:&mut BTreeMap<u32,Memory>,pool:u32,services:&mut impl Services)->Result<(),Error>{let reference=word(&resource.raw,68);if reference!=0{let memory=auxiliary.get(&reference).ok_or(Error::UnresolvedReference)?;services.observe_resource_release(resource);services.free(pool,memory)?;auxiliary.remove(&reference);set(&mut resource.raw,68,0);}Ok(())}
pub fn disable(owner:&mut Memory,resources:&mut BTreeMap<u32,Memory>,auxiliary:&mut BTreeMap<u32,Memory>,paths:&mut Paths,pool:u32,services:&mut impl Services)->Result<(),Error>{
 if owner.reference==0||owner.raw.len()<86{return Err(Error::InvalidAllocation);}
 owner.raw[47]&=!0x10;services.observe_owner_release(owner);
 let reference=word(&owner.raw,68);if reference!=0{
 let resource=resources.get_mut(&reference).ok_or(Error::UnresolvedReference)?;
 if resource.reference!=reference||resource.raw.len()!=72{return Err(Error::InvalidAllocation);}
 release_auxiliary(resource,auxiliary,pool,services)?;
 audio_path_resource::teardown(resource,paths,pool,services)?;
 if word(&resource.raw,0)!=0xff0d28{return Err(Error::Backend("unsupported path resource virtual destructor"));}
 // Actual derived destructor B1B180 resets class before auxiliary cleanup,
 // then the base class before releasing the optional referenced object.
 set(&mut resource.raw,0,0xff0d28);release_auxiliary(resource,auxiliary,pool,services)?;set(&mut resource.raw,0,0xff174c);
 let virtual_reference=word(&resource.raw,60);if virtual_reference!=0{services.release_virtual_reference(virtual_reference)?;}
 services.observe_resource_release(resource);services.free(pool,resource)?;resources.remove(&reference);set(&mut owner.raw,68,0);
 }
 owner.raw[85]&=0xfc;Ok(())
}

pub trait ControlServices:Services{fn property_notification(&mut self,owner:&Memory,value_bits:u32,property:u32,first:u32,second:u32)->Result<(),Error>;}
/// AF22A0 enable/disable and optional property10 notification. Native ignores
/// acquisition status; a null allocation still updates flags and notifies.
pub fn control(owner:&mut Memory,resources:&mut BTreeMap<u32,Memory>,auxiliary:&mut BTreeMap<u32,Memory>,paths:&mut Paths,enable:bool,skip_notification:bool,first:u8,second:u8,pool:u32,defaults:[u32;3],services:&mut impl ControlServices)->Result<(),Error>{
 if owner.reference==0||owner.raw.len()<86{return Err(Error::InvalidAllocation);}
 if enable{owner.raw[47]|=0x10;let mut resource=Memory{reference:0,raw:vec![]};if word(&owner.raw,68)==0{let status=crate::audio_path_resource_acquisition::acquire(owner,&mut resource,pool,defaults,services)?;if status==1{if resources.contains_key(&resource.reference){return Err(Error::InvalidAllocation);}resources.insert(resource.reference,resource);}}owner.raw[85]=(owner.raw[85]&0xf0)|(first&3)|((second&3)<<2);}
 else{disable(owner,resources,auxiliary,paths,pool,services)?;}
 if !skip_notification{services.property_notification(owner,((owner.raw[85]&3)as f32).to_bits(),10,0,0)?;}
 Ok(())
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};use crate::audio_random::NativeRandom;
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{pattern:u8,failure:bool,owner:Vec<u8>,root:Vec<u8>,calls:Vec<Value>,freed:BTreeMap<u32,Memory>,order:Vec<u32>,allocated:Vec<u32>}
 impl audio_path_resource::Services for Backend{
 fn allocate(&mut self,pool:u32,size:u32)->Result<Option<Memory>,Error>{let reference=if self.failure{0}else{0x40005000};self.calls.push(json!({"kind":"allocate","pool":pool,"bytes":size,"reference":reference}));if reference==0{return Ok(None);}self.allocated.push(reference);Ok(Some(Memory{reference,raw:vec![self.pattern;size as usize]}))}
 fn free(&mut self,pool:u32,m:&Memory)->Result<(),Error>{assert!(!self.freed.contains_key(&m.reference));self.calls.push(json!({"kind":"free","pool":pool,"reference":m.reference,"owner_at_call":hex(&self.owner),"resource_at_call":hex(&self.root)}));self.order.push(m.reference);self.freed.insert(m.reference,m.clone());Ok(())}
 fn observe_resource_release(&mut self,resource:&Memory){self.root=resource.raw.clone();}
 }
 impl Services for Backend{fn release_virtual_reference(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("nonnull virtual reference not covered in owner fixtures"))}fn observe_owner_release(&mut self,owner:&Memory){self.owner=owner.raw.clone();}}
 impl ControlServices for Backend{fn property_notification(&mut self,owner:&Memory,value:u32,property:u32,first:u32,second:u32)->Result<(),Error>{self.calls.push(json!({"kind":"property_notification","receiver":owner.reference,"arguments":[value,property,first,second],"owner_at_call":hex(&owner.raw)}));Ok(())}}
 fn replay(p:Value,is_control:bool){assert_eq!(p["passed"],true);assert_eq!(p["case_count"],if is_control{128}else{48});for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let b=&row["before"];let mut owner=Memory{reference:0x40004000,raw:bytes(b["owner"].as_str().unwrap())};let original=Memory{reference:0x40005000,raw:bytes(b["resource"].as_str().unwrap())};let mut resources=BTreeMap::new();let mut auxiliary=BTreeMap::new();let mut paths=Paths{descriptors:BTreeMap::new(),points:BTreeMap::new(),random:NativeRandom::seeded(17),interval:1024};let mut references=vec![];for a in b["allocations"].as_array().unwrap(){let reference=a["reference"].as_u64().unwrap()as u32;let m=Memory{reference,raw:bytes(a["raw"].as_str().unwrap())};references.push(reference);match reference{0x40005000=>{resources.insert(reference,m);},0x4000a000=>{paths.points.insert(reference,m);},0x4000b000=>{paths.descriptors.insert(reference,m);},0x4000c000=>{auxiliary.insert(reference,m);},_=>panic!("unexpected allocation")}}
 let mut backend=Backend{pattern:row["pattern"].as_u64().unwrap()as u8,failure:row["failure"].as_bool().unwrap_or(false),owner:vec![],root:vec![],calls:vec![],freed:BTreeMap::new(),order:vec![],allocated:vec![]};
 if is_control{control(&mut owner,&mut resources,&mut auxiliary,&mut paths,row["enable"]==1,row["skip_notification"]==1,row["first"].as_u64().unwrap()as u8,row["second"].as_u64().unwrap()as u8,17,[0x3f800000,0,0xbf800000],&mut backend).unwrap();}else{disable(&mut owner,&mut resources,&mut auxiliary,&mut paths,17,&mut backend).unwrap();}
 assert_eq!(json!(backend.calls),row["calls"],"physical calls and intermediate owner/root bytes {i}");assert_eq!(json!(backend.order),row["freed"],"free order {i}");references.extend(backend.allocated.iter().copied());let root=resources.get(&0x40005000).or_else(||backend.freed.get(&0x40005000)).unwrap_or(&original);let allocations:Vec<Value>=references.iter().map(|r|{let m=resources.get(r).or_else(||paths.points.get(r)).or_else(||paths.descriptors.get(r)).or_else(||auxiliary.get(r)).or_else(||backend.freed.get(r)).unwrap();json!({"reference":r,"size":m.raw.len(),"raw":hex(&m.raw),"freed":backend.freed.contains_key(r)})}).collect();assert_eq!(json!({"owner":hex(&owner.raw),"resource":hex(&root.raw),"allocations":allocations}),row["after"],"all final owned and retired bytes {i}");if !is_control||row["enable"]==0{assert!(resources.is_empty()&&auxiliary.is_empty()&&paths.points.is_empty()&&paths.descriptors.is_empty());}assert_eq!(paths.random.state(),17);
 }}
 #[test]fn audio_path_resource_owner_matches48_native_absent_partial_auxiliary_and_exact_release_states(){replay(serde_json::from_str(include_str!("../../../data/4.20/audio_path_resource_owner_preparation.json")).unwrap(),false);}
 #[test]fn audio_path_resource_owner_control_matches128_native_enable_disable_oom_flags_and_property_notification_calls(){replay(serde_json::from_str(include_str!("../../../data/4.20/audio_path_resource_owner_control_preparation.json")).unwrap(),true);}
}
