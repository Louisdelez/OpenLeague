//! Original AF5490 transition allocation/reuse, B20EA0/B21040 setup and queue publication.
//! Reuse composes actual B20EE0 progression, reset and first swap-tail removal in canonical memory.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put,live};
#[derive(Clone,Copy,Debug)]pub struct Context{pub pool:u32,pub clock:u32,pub frame_quantum:u32,pub conversion_cache:u32}
pub trait Services:crate::audio_path_voice_empty_source_release::Services{
 fn allocate_owner(&mut self,pool:u32,size:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<Option<u32>,Error>;
 fn observe_owner_progression(&mut self,_owner:u32,_time:u32,_m:&BTreeMap<u32,Memory>){}
 fn action_virtual0(&mut self,action:u32,ty:u32,value_bits:u32,finished:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<(),Error>;
}
struct Progression<'a,S>{backend:&'a mut S}
impl<S:Services>crate::audio_property_owner_progression::Services for Progression<'_,S>{fn action_virtual0(&mut self,r:u32,ty:u32,bits:u32,finished:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{self.backend.action_virtual0(r,ty,bits,finished,m,d)}}
fn alloc(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,size:u32,c:Context,s:&mut impl Services)->Result<u32,Error>{let r=s.allocate_owner(c.pool,size,m,d)?.unwrap_or(0);if r!=0{live(m,d,r,size as usize)?;}Ok(r)}
fn free(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,r:u32,c:Context,s:&mut impl Services)->Result<(),Error>{live(m,d,r,1)?;s.free(c.pool,r,m)?;d.insert(r);Ok(())}
fn construct(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,owner:u32)->Result<(),Error>{
 for(off,value)in[(32,0),(36,0),(40,0),(0,0x20000000),(48,0),(24,0)]{put(m,d,owner.wrapping_add(off),4,value)?;}
 let flags=get(m,d,owner.wrapping_add(52),1)?;put(m,d,owner.wrapping_add(52),1,flags&0xfc)?;put(m,d,owner.wrapping_add(53),1,0)
}
fn reset(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,owner:u32)->Result<(),Error>{
 put(m,d,owner.wrapping_add(36),4,0)?;let flags=get(m,d,owner.wrapping_add(52),1)?;put(m,d,owner.wrapping_add(52),1,flags&0xfc)?;put(m,d,owner.wrapping_add(53),1,0)?;for(off,value)in[(0,0x20000000),(48,0),(24,0)]{put(m,d,owner.wrapping_add(off),4,value)?;}Ok(())
}
fn remove_queue(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,queue:u32,owner:u32)->Result<(),Error>{
 let table=get(m,d,queue,4)?;let count=get(m,d,queue.wrapping_add(4),4)?;for i in 0..count{let at=table.wrapping_add(i.wrapping_mul(4));if get(m,d,at,4)?==owner{if count>1{let tail=get(m,d,table.wrapping_add((count-1).wrapping_mul(4)),4)?;put(m,d,at,4,tail)?;}put(m,d,queue.wrapping_add(4),4,count-1)?;break;}}Ok(())
}
fn grow_bindings(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,owner:u32,c:Context,s:&mut impl Services)->Result<bool,Error>{
 let header=owner.wrapping_add(32);let capacity=get(m,d,header.wrapping_add(8),4)?.wrapping_add(8);let new=alloc(m,d,capacity.wrapping_mul(4),c,s)?;if new==0{return Ok(false);}let old=get(m,d,header,4)?;let count=get(m,d,header.wrapping_add(4),4)?;
 if old!=0{for i in 0..count{let current=get(m,d,header,4)?;let value=get(m,d,current.wrapping_add(i.wrapping_mul(4)),4)?;put(m,d,new.wrapping_add(i.wrapping_mul(4)),4,value)?;}let current=get(m,d,header,4)?;free(m,d,current,c,s)?;}
 put(m,d,header,4,new)?;put(m,d,header.wrapping_add(8),4,capacity)?;Ok(true)
}
fn setup(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,owner:u32,descriptor:u32,current:u32,c:Context,s:&mut impl Services)->Result<u32,Error>{
 let ty=get(m,d,descriptor.wrapping_add(4),4)?;put(m,d,owner,4,ty)?;let flags=get(m,d,owner.wrapping_add(52),1)?;let descriptor_flags=get(m,d,descriptor.wrapping_add(24),1)?;put(m,d,owner.wrapping_add(52),1,(flags&!1)|(descriptor_flags&1))?;
 let mut initial=get(m,d,descriptor.wrapping_add(8),4)?;let mut target=get(m,d,descriptor.wrapping_add(12),4)?;
 if descriptor_flags!=0{let pc=crate::audio_path_property_owner_update::Context{clock:c.clock,frame_quantum:c.frame_quantum,conversion_cache:c.conversion_cache};initial=crate::audio_path_property_owner_update::gain(m,d,initial,pc)?;target=crate::audio_path_property_owner_update::gain(m,d,target,pc)?;}
 put(m,d,owner.wrapping_add(4),4,initial)?;put(m,d,owner.wrapping_add(12),4,initial)?;put(m,d,owner.wrapping_add(8),4,target)?;
 let curve=get(m,d,descriptor.wrapping_add(20),4)?;let processed=get(m,d,descriptor.wrapping_add(25),1)?;let curve=if processed!=0&&!(f32::from_bits(target)>f32::from_bits(initial))&&curve!=3&&curve!=5{8u32.wrapping_sub(curve)}else{curve};put(m,d,owner.wrapping_add(44),4,curve)?;put(m,d,owner.wrapping_add(16),4,current)?;
 let duration=get(m,d,descriptor.wrapping_add(16),4)?;let numerator=duration.wrapping_sub(1).wrapping_add(c.frame_quantum)as i32;let ticks=numerator.checked_div(c.frame_quantum as i32).ok_or(Error::Backend("native owner setup duration division fault"))?as u32;put(m,d,owner.wrapping_add(24),4,0)?;put(m,d,owner.wrapping_add(20),4,ticks)?;
 let action=get(m,d,descriptor,4)?;let table=get(m,d,owner.wrapping_add(32),4)?;let count=get(m,d,owner.wrapping_add(36),4)?;for i in 0..count{if get(m,d,table.wrapping_add(i.wrapping_mul(4)),4)?==action{return Ok(1);}}
 let saved=count;if saved>=get(m,d,owner.wrapping_add(40),4)?{if !grow_bindings(m,d,owner,c,s)?||saved>=get(m,d,owner.wrapping_add(40),4)?{return Ok(2);}}
 let count=get(m,d,owner.wrapping_add(36),4)?;let table=get(m,d,owner.wrapping_add(32),4)?;let entry=table.wrapping_add(count.wrapping_mul(4));put(m,d,owner.wrapping_add(36),4,count.wrapping_add(1))?;if entry==0{return Ok(2);}put(m,d,entry,4,action)?;let refs=get(m,d,owner.wrapping_add(53),1)?;put(m,d,owner.wrapping_add(53),1,refs.wrapping_add(1))?;Ok(1)
}
fn destroy(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,owner:u32,c:Context,s:&mut impl Services)->Result<(),Error>{
 let table=get(m,d,owner.wrapping_add(32),4)?;if table!=0{put(m,d,owner.wrapping_add(36),4,0)?;free(m,d,table,c,s)?;put(m,d,owner.wrapping_add(32),4,0)?;put(m,d,owner.wrapping_add(40),4,0)?;}free(m,d,owner,c,s)
}
/// Descriptor32 is borrowed; only the original fields are read, after allocation/callbacks.
/// Selects queue+16 only when queue_argument equals1, and uses first_argument's low byte.
pub fn create(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,manager:u32,descriptor:u32,first_argument:u32,queue_argument:u32,c:Context,s:&mut impl Services)->Result<Option<u32>,Error>{
 let queue=manager.wrapping_add(if queue_argument==1{16}else{4});let count=get(m,d,queue.wrapping_add(4),4)?;let limit=get(m,d,manager,4)?;let mut owner=0;
 if count<limit{owner=alloc(m,d,56,c,s)?;if owner!=0{construct(m,d,owner)?;}}
 if owner==0{let table=get(m,d,queue,4)?;let count=get(m,d,queue.wrapping_add(4),4)?;let mut highest=-1f32;for i in 0..count{let candidate=get(m,d,table.wrapping_add(i.wrapping_mul(4)),4)?;let progress=f32::from_bits(get(m,d,candidate.wrapping_add(24),4)?);if progress>highest{owner=candidate;highest=progress;}}
 if owner!=0{let time=get(m,d,owner.wrapping_add(16),4)?.wrapping_add(get(m,d,owner.wrapping_add(20),4)?);s.observe_owner_progression(owner,time,m);let mut adapter=Progression{backend:s};crate::audio_property_owner_progression::update(m,d,owner,time,&mut adapter)?;reset(m,d,owner)?;remove_queue(m,d,queue,owner)?;}}
 if owner!=0{let current=get(m,d,c.clock.wrapping_add(124),4)?;if setup(m,d,owner,descriptor,current,c,s)?!=2{let count=get(m,d,queue.wrapping_add(4),4)?;let capacity=get(m,d,queue.wrapping_add(8),4)?;if count<capacity{let table=get(m,d,queue,4)?;let entry=table.wrapping_add(count.wrapping_mul(4));put(m,d,queue.wrapping_add(4),4,count.wrapping_add(1))?;if entry!=0{put(m,d,entry,4,owner)?;if first_argument as u8!=0{put(m,d,owner.wrapping_add(48),4,1)?;}return Ok(Some(owner));}}}destroy(m,d,owner,c,s)?;}
 let action=get(m,d,descriptor,4)?;let target=get(m,d,descriptor.wrapping_add(12),4)?;let ty=get(m,d,descriptor.wrapping_add(4),4)?;s.action_virtual0(action,ty,target,1,m,d)?;Ok(None)
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 const REGIONS:[(&str,u32);8]=[("manager",0x40001000),("queues",0x40002000),("descriptor",0x40003000),("action",0x40004000),("new_owner",0x40008000),("new_binding",0x40009000),("clock",0x40006000),("conversion_cache",0x14a7970)];
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 fn snapshot(m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r)in REGIONS{if r!=0{out[n]=json!(hex(&m[&r].raw));}}out}
 struct Backend{calls:Vec<Value>,failure:String}
 impl crate::audio_path_voice_empty_source_release::Services for Backend{fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"kind":"free","pool":p,"reference":r,"at_call":snapshot(m)}));Ok(())}}
 impl Services for Backend{
 fn allocate_owner(&mut self,p:u32,size:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{let fail=self.failure=="owner"&&size==56||self.failure=="binding"&&size==32;let result=if fail{0}else if size==56{0x40008000}else{assert_eq!(size,32);0x40009000};self.calls.push(json!({"kind":"allocate","pool":p,"size":size,"result":result,"at_call":snapshot(m)}));Ok((result!=0).then_some(result))}
 fn action_virtual0(&mut self,r:u32,ty:u32,bits:u32,finished:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.calls.push(json!({"kind":"action_virtual0","receiver":r,"arguments":[ty,bits,finished],"at_call":snapshot(m)}));Ok(())}
 }
 #[test]fn audio_property_owner_creation_matches3888_native_constructor56_gain_clock_curve_binding_growth_queue_publication_fallback_free_order_and_complete_physical_memory_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_property_owner_creation_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],3888);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m:BTreeMap<u32,Memory>=REGIONS.into_iter().filter(|(_,r)|*r!=0).map(|(n,r)|(r,Memory{reference:r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut dead=BTreeSet::new();let mut s=Backend{calls:vec![],failure:row["failure"].as_str().unwrap().to_owned()};let c=Context{pool:19,clock:0x40006000,frame_quantum:48,conversion_cache:0x14a7970};let result=create(&mut m,&mut dead,0x40001000,0x40003000,row["first_argument"].as_u64().unwrap()as u32,row["queue_argument"].as_u64().unwrap()as u32,c,&mut s).unwrap().unwrap_or(0);assert_eq!(result,row["result"].as_u64().unwrap()as u32,"native result {i}");assert_eq!(json!(s.calls),row["calls"],"every allocation/free/fallback physical snapshot {i}");assert_eq!(snapshot(&m),row["after"],"all owner/queue/binding/gain/descriptor/clock bytes {i}");let mut expected:Vec<u32>=row["freed"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect();expected.sort();assert_eq!(dead.iter().copied().collect::<Vec<_>>(),expected,"retired allocations {i}");for r in &dead{assert_eq!(get(&m,&dead,*r,1),Err(Error::UnresolvedReference));}}
 }
}

#[cfg(test)]mod reuse_tests{
 use super::*;use serde_json::{Value,json};
 const REGIONS:[(&str,u32,usize);8]=[("manager",0x40001000,28),("queues",0x40002000,24),("descriptor",0x40003000,32),("action",0x40004000,44),("owners",0x40008000,168),("bindings",0x40009000,96),("clock",0x40006000,128),("conversion_cache",0x14a7970,8)];
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 fn snapshot(m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r,z)in REGIONS{out[n]=json!(hex(&(0..z).map(|i|crate::audio_path_memory::read(m,r+i as u32,1).unwrap()[0]).collect::<Vec<_>>()));}out}
 struct Backend{calls:Vec<Value>}
 impl crate::audio_path_voice_empty_source_release::Services for Backend{fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"kind":"free","pool":p,"reference":r,"at_call":snapshot(m)}));Ok(())}}
 impl Services for Backend{
 fn allocate_owner(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{Err(Error::Backend("supplied full owner queue excludes fresh allocation"))}
 fn observe_owner_progression(&mut self,r:u32,time:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"progress_owner","receiver":r,"time":time,"at_call":snapshot(m)}));}
 fn action_virtual0(&mut self,r:u32,ty:u32,bits:u32,finished:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.calls.push(json!({"kind":"action_virtual0","receiver":r,"arguments":[ty,bits,finished],"at_call":snapshot(m)}));Ok(())}
 }
 #[test]fn audio_property_owner_creation_matches4320_native_highest_progress_reuse_first_tie_nan_rejection_actual_terminal_progression_reset_swap_binding_publication_and_complete_physical_memory_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_property_owner_reuse_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],4320);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m=BTreeMap::new();for(n,r,z)in REGIONS{let raw=bytes(row["before"][n].as_str().unwrap());let chunk=if n=="owners"{56}else if n=="bindings"{32}else{z};for(j,part)in raw.chunks(chunk).enumerate(){let reference=r+j as u32*chunk as u32;m.insert(reference,Memory{reference,raw:part.to_vec()});}}
 let mut dead=BTreeSet::new();let mut s=Backend{calls:vec![]};let c=Context{pool:19,clock:0x40006000,frame_quantum:48,conversion_cache:0x14a7970};let result=create(&mut m,&mut dead,0x40001000,0x40003000,row["first_argument"].as_u64().unwrap()as u32,row["queue_argument"].as_u64().unwrap()as u32,c,&mut s).unwrap().unwrap_or(0);assert_eq!(result,row["result"].as_u64().unwrap()as u32,"selected/reused native owner {i}");assert_eq!(json!(s.calls),row["calls"],"all original progression/action/free snapshots {i}");assert_eq!(snapshot(&m),row["after"],"complete owner pool/queue/bindings/clock/descriptor bytes {i}");let mut expected:Vec<u32>=row["freed"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect();expected.sort();assert_eq!(dead.iter().copied().collect::<Vec<_>>(),expected,"retired allocations {i}");for r in &dead{assert_eq!(get(&m,&dead,*r,1),Err(Error::UnresolvedReference));}}
 }
}
