//! Original FF1CD8 source callbacks B00180/AF0370 and owner counter helpers.
//! OS locks, manager removal and derived virtual methods remain mandatory services.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_voice_empty_source_release as empty;
pub(crate) fn live<'a>(m:&'a BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,a:u32,n:usize)->Result<&'a[u8],Error>{if dead.iter().any(|base|a>=*base&&m.get(base).map(|v|a.wrapping_sub(*base)<v.raw.len()as u32).unwrap_or(a==*base)){return Err(Error::UnresolvedReference);}crate::audio_path_memory::read(m,a,n)}
pub(crate) fn get(m:&BTreeMap<u32,Memory>,d:&BTreeSet<u32>,a:u32,n:usize)->Result<u32,Error>{let b=live(m,d,a,n)?;Ok(match n{1=>b[0]as u32,2=>u16::from_le_bytes(b.try_into().unwrap())as u32,4=>u32::from_le_bytes(b.try_into().unwrap()),_=>return Err(Error::InvalidAllocation)})}
pub(crate) fn put(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,a:u32,n:usize,v:u32)->Result<(),Error>{live(m,d,a,n)?;let base=*m.range(..=a).next_back().ok_or(Error::UnresolvedReference)?.0;let o=a.wrapping_sub(base)as usize;m.get_mut(&base).unwrap().raw[o..o+n].copy_from_slice(&v.to_le_bytes()[..n]);Ok(())}
fn pw(p:&Memory,o:usize,n:usize)->Result<u32,Error>{if p.raw.len()<o+n{return Err(Error::Truncated);}Ok(match n{1=>p.raw[o]as u32,2=>u16::from_le_bytes(p.raw[o..o+2].try_into().unwrap())as u32,4=>u32::from_le_bytes(p.raw[o..o+4].try_into().unwrap()),_=>return Err(Error::InvalidAllocation)})}
fn pp(p:&mut Memory,o:usize,n:usize,v:u32)->Result<(),Error>{pw(p,o,n)?;p.raw[o..o+n].copy_from_slice(&v.to_le_bytes()[..n]);Ok(())}
pub trait Services:empty::Services{
 fn lock(&mut self,critical_section:u32)->Result<(),Error>;
 fn unlock(&mut self,critical_section:u32)->Result<(),Error>;
 fn remove_manager_key(&mut self,table:u32,key:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>;
 fn source_virtual14(&mut self,source:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>;
 fn parent_virtual30(&mut self,parent:u32,source:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>;
 fn source_destructor(&mut self,source:u32,argument:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>;
 fn parent_virtual8c(&mut self,parent:u32,payload:&mut Memory,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>;
}
fn section(m:&BTreeMap<u32,Memory>,d:&BTreeSet<u32>,source:u32,manager:u32)->Result<u32,Error>{Ok(manager.wrapping_add(if get(m,d,source.wrapping_add(47),1)?&2!=0{0x320}else{0}))}
/// Original source reference release returns the saved decremented count even
/// after source destruction. Lock selection is reread at the terminal branch.
pub fn release_reference(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,source:u32,manager:u32,pool:u32,s:&mut impl Services)->Result<u32,Error>{
 let outer=section(m,dead,source,manager)?;s.lock(outer)?;let count=get(m,dead,source.wrapping_add(12),4)?.wrapping_sub(1);put(m,dead,source.wrapping_add(12),4,count)?;
 if count==0{let key=get(m,dead,source.wrapping_add(8),4)?;let inner=section(m,dead,source,manager)?;s.lock(inner)?;s.remove_manager_key(inner.wrapping_add(24),key,m)?;s.unlock(inner)?;s.source_virtual14(source,m)?;
 for o in[32,36]{let parent=get(m,dead,source.wrapping_add(o),4)?;if parent!=0{s.parent_virtual30(parent,source,m)?;}}
 s.source_destructor(source,0,m)?;s.free(pool,source,m)?;dead.insert(source);
 }s.unlock(outer)?;Ok(count)
}
fn release_if_empty(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,source:u32,pool:u32,s:&mut impl empty::Services)->Result<(),Error>{let owner=get(m,dead,source.wrapping_add(28),4)?;for o in[48,50,52,54]{if get(m,dead,owner.wrapping_add(o),2)?!=0{return Ok(());}}if get(m,dead,owner.wrapping_add(12),4)?==0&&get(m,dead,owner.wrapping_add(4),4)?==0{empty::release(m,dead,source,pool,s)?;}Ok(())}
fn decrement(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,source:u32,offset:u32,pool:u32,s:&mut impl empty::Services)->Result<(),Error>{let owner=get(m,dead,source.wrapping_add(28),4)?;if owner!=0{let value=get(m,dead,owner.wrapping_add(offset),2)?.wrapping_sub(1)&0xffff;put(m,dead,owner.wrapping_add(offset),2,value)?;release_if_empty(m,dead,source,pool,s)?;}Ok(())}
pub fn keyed_decrement(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,source:u32,key:u32,pool:u32,s:&mut impl Services)->Result<(),Error>{let owner=get(m,dead,source.wrapping_add(28),4)?;let base=get(m,dead,owner,4)?;let count=get(m,dead,owner.wrapping_add(4),4)?;let size=(count as usize).checked_mul(12).ok_or(Error::InvalidAllocation)?;if size!=0{live(m,dead,base,size)?;}
 for i in 0..count{let entry=base.wrapping_add(i.wrapping_mul(12));if get(m,dead,entry,4)?==key{let value=get(m,dead,entry.wrapping_add(8),2)?.wrapping_sub(1)&0xffff;put(m,dead,entry.wrapping_add(8),2,value)?;if value==0&&get(m,dead,entry.wrapping_add(10),2)?==0{release_owner_entry(m,dead,source,entry,key,pool,s)?;}release_if_empty(m,dead,source,pool,s)?;break;}}Ok(())}
/// AF6650 detaches the first matching key from one of193 buckets. The
/// removed allocation is retained; this helper performs no physical free.
pub fn unlink_manager_key(m:&mut BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,table:u32,key:u32)->Result<(),Error>{
 let bucket=table.wrapping_add((key%193)*4);let mut current=get(m,dead,bucket,4)?;let mut previous=0u32;let mut visited=BTreeSet::new();
 while current!=0{if !visited.insert(current){return Err(Error::CyclicList);}if get(m,dead,current.wrapping_add(8),4)?==key{let next=get(m,dead,current.wrapping_add(4),4)?;put(m,dead,if previous==0{bucket}else{previous.wrapping_add(4)},4,next)?;let count=get(m,dead,table.wrapping_add(772),4)?.wrapping_sub(1);put(m,dead,table.wrapping_add(772),4,count)?;break;}previous=current;current=get(m,dead,current.wrapping_add(4),4)?;}Ok(())
}
fn physical_free(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,pool:u32,reference:u32,s:&mut impl Services)->Result<(),Error>{live(m,dead,reference,1)?;s.free(pool,reference,m)?;dead.insert(reference);Ok(())}
/// AFEA30 clears descriptor buffer count before free, then pointer/capacity;
/// B01300 shifts12-byte entries left while preserving the unused final slot.
fn release_owner_entry(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,source:u32,entry:u32,key:u32,pool:u32,s:&mut impl Services)->Result<(),Error>{
 let slot=entry.wrapping_add(4);let descriptor=get(m,dead,slot,4)?;if descriptor!=0{let buffer=get(m,dead,descriptor,4)?;if buffer!=0{put(m,dead,descriptor.wrapping_add(4),4,0)?;physical_free(m,dead,pool,buffer,s)?;put(m,dead,descriptor,4,0)?;put(m,dead,descriptor.wrapping_add(8),4,0)?;}let descriptor=get(m,dead,slot,4)?;physical_free(m,dead,pool,descriptor,s)?;put(m,dead,slot,4,0)?;}
 let owner=get(m,dead,source.wrapping_add(28),4)?;let count=get(m,dead,owner.wrapping_add(4),4)?;let base=get(m,dead,owner,4)?;let size=(count as usize).checked_mul(12).ok_or(Error::InvalidAllocation)?;if size!=0{live(m,dead,base,size)?;}
 for i in 0..count{let at=base.wrapping_add(i.wrapping_mul(12));if get(m,dead,at,4)?==key{if i+1<count{let n=(count-i-1)as usize*12;let bytes=live(m,dead,at.wrapping_add(12),n)?.to_vec();let allocation=*m.range(..=at).next_back().ok_or(Error::UnresolvedReference)?.0;live(m,dead,at,n)?;let offset=at.wrapping_sub(allocation)as usize;m.get_mut(&allocation).unwrap().raw[offset..offset+n].copy_from_slice(&bytes);}put(m,dead,owner.wrapping_add(4),4,count.wrapping_sub(1))?;break;}}Ok(())
}
/// Mutates the borrowed 24-byte registration payload exactly between parent
/// dispatches; each parent callback is required and may mutate the same payload.
pub fn propagate_release(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,source:u32,payload:&mut Memory,pool:u32,s:&mut impl Services)->Result<(),Error>{
 pw(payload,20,1)?;decrement(m,dead,source,48,pool,s)?;
 if get(m,dead,source.wrapping_add(46),1)?&8!=0||get(m,dead,source.wrapping_add(32),4)?==0{
 if pw(payload,20,1)?==0{let owner=get(m,dead,source.wrapping_add(28),4)?;if owner!=0{if get(m,dead,owner.wrapping_add(56),1)?&1!=0{decrement(m,dead,source,52,pool,s)?;}else{keyed_decrement(m,dead,source,pw(payload,4,4)?,pool,s)?;}}}pp(payload,20,1,1)?;
 }
 let processed=pw(payload,20,1)?;let mask=pw(payload,16,2)?;if mask&1!=0{let parent=get(m,dead,source.wrapping_add(36),4)?;if parent!=0{pp(payload,20,1,0)?;pp(payload,16,2,mask&!1)?;s.parent_virtual8c(parent,payload,m)?;}}
 let mask=pw(payload,16,2)?;if mask&2!=0{let wrapper=get(m,dead,source.wrapping_add(56),4)?;if wrapper!=0&&get(m,dead,wrapper,4)?!=0{pp(payload,20,1,0)?;pp(payload,16,2,mask&!2)?;let wrapper=get(m,dead,source.wrapping_add(56),4)?;let parent=get(m,dead,wrapper,4)?;s.parent_virtual8c(parent,payload,m)?;}}
 if get(m,dead,source.wrapping_add(32),4)?!=0{pp(payload,20,1,processed)?;let parent=get(m,dead,source.wrapping_add(32),4)?;s.parent_virtual8c(parent,payload,m)?;}Ok(())
}
/// Required parent dispatch for original AFE5B0 (Source virtual9C).
pub trait InputReleaseServices:empty::Services{
 fn observe_input_release(&mut self,_source:u32,_selector:u32,_m:&BTreeMap<u32,Memory>){}
 fn parent_virtual9c(&mut self,parent:u32,selector:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<(),Error>;
}
/// Source input release decrements owner half50, releases an empty owner,
/// then forwards the selector to the optional parents in native order.
pub fn release_input(m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>,source:u32,mut selector:u32,pool:u32,s:&mut impl InputReleaseServices)->Result<(),Error>{
 let vt=get(m,dead,source,4)?;if vt!=0xff1cd8&&vt!=0xff10f0{return Err(Error::Backend("input9c class is unqualified"));}
 s.observe_input_release(source,selector,m);decrement(m,dead,source,50,pool,s)?;
 if selector&1!=0{let parent=get(m,dead,source.wrapping_add(36),4)?;if parent!=0{selector&=0xfffe;s.parent_virtual9c(parent,3,m,dead)?;}}
 if selector&2!=0{let wrapper=get(m,dead,source.wrapping_add(56),4)?;if wrapper!=0{let parent=get(m,dead,wrapper,4)?;if parent!=0{selector&=0xfffd;s.parent_virtual9c(parent,3,m,dead)?;}}}
 let parent=get(m,dead,source.wrapping_add(32),4)?;if parent!=0{s.parent_virtual9c(parent,selector,m,dead)?;}Ok(())
}

struct RecursiveInputs<'a,S>{pool:u32,services:&'a mut S,visiting:BTreeSet<u32>}
impl<S:InputReleaseServices> empty::Services for RecursiveInputs<'_,S>{
 fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.services.free(p,r,m)}
 fn observe_parent_removal(&mut self,p:u32,s:u32){self.services.observe_parent_removal(p,s)}
 fn observe_empty_source_release(&mut self,s:u32,m:&BTreeMap<u32,Memory>){self.services.observe_empty_source_release(s,m)}
}
impl<S:InputReleaseServices> InputReleaseServices for RecursiveInputs<'_,S>{
 fn observe_input_release(&mut self,s:u32,v:u32,m:&BTreeMap<u32,Memory>){self.services.observe_input_release(s,v,m)}
 fn parent_virtual9c(&mut self,p:u32,v:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<(),Error>{
 if !self.visiting.insert(p){return Err(Error::CyclicList);}let result=release_input(m,d,p,v,self.pool,self);self.visiting.remove(&p);result
 }
}
/// Recursively dispatches verified Source classes in the same live memory.
/// Shared parents may be visited again after returning; cycles are explicit errors.
pub fn release_input_recursive(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,source:u32,selector:u32,pool:u32,s:&mut impl InputReleaseServices)->Result<(),Error>{
 release_input(m,d,source,selector,pool,&mut RecursiveInputs{pool,services:s,visiting:BTreeSet::from([source])})
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend(Vec<Value>);
 impl empty::Services for Backend{fn free(&mut self,p:u32,r:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.0.push(json!({"kind":"free","pool":p,"reference":r}));Ok(())}}
 impl Services for Backend{
 fn lock(&mut self,r:u32)->Result<(),Error>{self.0.push(json!({"kind":"lock","receiver":r}));Ok(())}
 fn unlock(&mut self,r:u32)->Result<(),Error>{self.0.push(json!({"kind":"unlock","receiver":r}));Ok(())}
 fn remove_manager_key(&mut self,r:u32,k:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.0.push(json!({"kind":"remove_manager_key","receiver":r,"key":k}));Ok(())}
 fn source_virtual14(&mut self,r:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.0.push(json!({"kind":"source_virtual14","receiver":r}));Ok(())}
 fn parent_virtual30(&mut self,r:u32,v:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.0.push(json!({"kind":"parent_virtual30","receiver":r,"argument":v}));Ok(())}
 fn source_destructor(&mut self,r:u32,a:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.0.push(json!({"kind":"source_destructor","receiver":r,"argument":a}));Ok(())}
 fn parent_virtual8c(&mut self,r:u32,p:&mut Memory,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.0.push(json!({"kind":"parent_virtual8c","receiver":r,"payload":hex(&p.raw)}));p.raw[20]=1;Ok(())}
 }
 const REGIONS:[(&str,u32);5]=[("source",0x40001000),("owner",0x40002000),("entries",0x40003000),("parents",0x40007000),("wrapper",0x40008000)];
 fn replay(release:bool){let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_source_virtual_cleanup_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p[if release{"release_case_count"}else{"propagation_case_count"}],if release{64}else{1024});for(i,row)in p[if release{"release_cases"}else{"propagation_cases"}].as_array().unwrap().iter().enumerate(){let before=&row["before"];let mut m:BTreeMap<u32,Memory>=REGIONS.into_iter().map(|(n,reference)|(reference,Memory{reference,raw:bytes(before[n].as_str().unwrap())})).collect();let mut payload=Memory{reference:0x40004000,raw:bytes(before["payload"].as_str().unwrap())};let mut dead=BTreeSet::new();let mut s=Backend(vec![]);
 if release{assert_eq!(release_reference(&mut m,&mut dead,0x40001000,0x40005000,19,&mut s).unwrap(),row["result"].as_u64().unwrap()as u32);assert_eq!(dead.contains(&0x40001000),row["count"]==1);if dead.contains(&0x40001000){assert_eq!(get(&m,&dead,0x4000100c,4),Err(Error::UnresolvedReference));}}else{propagate_release(&mut m,&mut dead,0x40001000,&mut payload,19,&mut s).unwrap();assert!(dead.is_empty());}
 assert_eq!(json!(s.0),row["calls"],"ordered native callback/lock/free sequence {i}");let mut after=json!({"payload":hex(&payload.raw)});for(n,r)in REGIONS{after[n]=json!(hex(&m[&r].raw));}assert_eq!(after,row["after"],"all physical counter/entry/source/payload/padding bytes {i}");}}
 #[test]fn audio_path_source_virtual_cleanup_matches64_native_lock_reference_wrap_terminal_callbacks_and_retired_source_snapshots(){replay(true);}
 #[test]fn audio_path_source_virtual_cleanup_matches1024_native_owner_counter_wrap_keyed_decrement_parent_mask_and_borrowed_payload_routing(){replay(false);}
 const KEY_REGIONS:[(&str,u32);5]=[("source",0x40001000),("owner",0x40002000),("entries",0x40003000),("descriptors",0x40004000),("buffers",0x40005000)];
 fn key_snapshot(m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r)in KEY_REGIONS{out[n]=json!(hex(&m[&r].raw));}out}
 struct KeyBackend(Vec<Value>);
 impl empty::Services for KeyBackend{fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.0.push(json!({"kind":"free","pool":p,"reference":r,"at_call":key_snapshot(m)}));Ok(())}}
 impl Services for KeyBackend{
 fn lock(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("unexpected lock"))}
 fn unlock(&mut self,_:u32)->Result<(),Error>{Err(Error::Backend("unexpected unlock"))}
 fn remove_manager_key(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("unexpected manager"))}
 fn source_virtual14(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("unexpected source14"))}
 fn parent_virtual30(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("unexpected parent30"))}
 fn source_destructor(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("unexpected destructor"))}
 fn parent_virtual8c(&mut self,_:u32,_:&mut Memory,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("unexpected parent8c"))}
 }
 #[test]fn audio_path_source_virtual_cleanup_matches576_native_keyed_descriptor_buffer_free_order_shift_remove_wrap_and_physical_snapshots(){let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_source_keyed_release_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],576);for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m:BTreeMap<u32,Memory>=KEY_REGIONS.into_iter().map(|(n,reference)|(reference,Memory{reference,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut dead=BTreeSet::new();let mut s=KeyBackend(vec![]);keyed_decrement(&mut m,&mut dead,0x40001000,row["key"].as_u64().unwrap()as u32,19,&mut s).unwrap();assert_eq!(json!(s.0),row["calls"],"exact free-time bytes and order {i}");assert_eq!(key_snapshot(&m),row["after"],"shifted entries, retained final slot and every physical byte {i}");for r in dead{assert_eq!(get(&m,&BTreeSet::from([r]),r,1),Err(Error::UnresolvedReference));}}}
 #[test]fn audio_path_source_virtual_cleanup_matches384_native_unsigned_bucket_first_duplicate_unlink_count_wrap_and_retained_nodes(){let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_path_source_manager_unlink_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],384);for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m:BTreeMap<u32,Memory>=[("table",0x40001000),("nodes",0x40002000)].into_iter().map(|(n,reference)|(reference,Memory{reference,raw:bytes(row["before"][n].as_str().unwrap())})).collect();unlink_manager_key(&mut m,&BTreeSet::new(),0x40001000,row["key"].as_u64().unwrap()as u32).unwrap();assert_eq!(json!({"table":hex(&m[&0x40001000].raw),"nodes":hex(&m[&0x40002000].raw)}),row["after"],"physical bucket/next/count and retained removed node bytes {i}");}}

}

#[cfg(test)]mod input_routing_tests{
 use super::*;use serde_json::{Value,json};
 const REGIONS:[(&str,u32);4]=[("source",0x40001000),("owner",0x40002000),("parents",0x40003000),("wrapper",0x40004000)];
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 fn snapshot(m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r)in REGIONS{out[n]=json!(hex(&m[&r].raw));}out}
 struct Backend{calls:Vec<Value>,mutate:bool}
 impl empty::Services for Backend{
 fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"kind":"free","pool":p,"reference":r,"at_call":snapshot(m)}));Ok(())}
 fn observe_parent_removal(&mut self,p:u32,s:u32){self.calls.push(json!({"kind":"remove_parent_source","parent":p,"source":s}));}
 }
 impl InputReleaseServices for Backend{
 fn parent_virtual9c(&mut self,p:u32,v:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<(),Error>{self.calls.push(json!({"kind":"parent_virtual9c","receiver":p,"selector":v,"at_call":snapshot(m)}));if self.mutate{put(m,dead,0x40001020,4,0)?;}Ok(())}
 }
 #[test]fn audio_path_source_input9c_matches3840_native_counter_wrap_all_empty_gates_parent_routing_selector_upper_bits_mutation_and_physical_owner_retirement_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_path_source_input9c_routing_native_empty_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],3840);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m:BTreeMap<u32,Memory>=REGIONS.into_iter().map(|(n,reference)|(reference,Memory{reference,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut dead=BTreeSet::new();let mut b=Backend{calls:vec![],mutate:row["mutate_primary"].as_bool().unwrap()};release_input(&mut m,&mut dead,0x40001000,row["selector"].as_u64().unwrap()as u32,19,&mut b).unwrap();assert_eq!(json!(b.calls),row["calls"],"all callbacks, selector arguments and complete free-time memory {i}");assert_eq!(snapshot(&m),row["after"],"all physical bytes and preserved padding {i}");assert_eq!(dead.contains(&0x40002000),row["gate"]=="one_empty","owner retirement {i}");for r in &dead{assert_eq!(get(&m,&dead,*r,1),Err(Error::UnresolvedReference));}}
 }
}

#[cfg(test)]mod recursive_input_tests{
 use super::*;use serde_json::{Value,json};
 const REGIONS:[(&str,u32,usize);3]=[("sources",0x40001000,160),("owners",0x40003000,64),("wrappers",0x40004000,32)];
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 fn snapshot(m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r,z)in REGIONS{let count=if n=="wrappers"{1}else{5};let raw=(0..count).flat_map(|i|m[&(r+i as u32*z as u32)].raw.iter().copied()).collect::<Vec<_>>();out[n]=json!(hex(&raw));}out}
 struct Backend(Vec<Value>);
 impl empty::Services for Backend{
 fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.0.push(json!({"kind":"free","pool":p,"reference":r,"at_call":snapshot(m)}));Ok(())}
 fn observe_parent_removal(&mut self,p:u32,s:u32){self.0.push(json!({"kind":"remove_parent_source","parent":p,"source":s}));}
 }
 impl InputReleaseServices for Backend{
 fn observe_input_release(&mut self,p:u32,v:u32,m:&BTreeMap<u32,Memory>){self.0.push(json!({"kind":"input_virtual9c","receiver":p,"selector":v,"at_call":snapshot(m)}));}
 fn parent_virtual9c(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{Err(Error::Backend("recursive path must execute actual Source parent body"))}
 }
 #[test]fn audio_path_source_input9c_matches512_native_recursive_five_node_parent_chains_shared_leaf_duplicate_parent_and_complete_physical_retirement_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_path_source_input9c_recursive_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],512);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m=BTreeMap::new();for(n,r,z)in REGIONS{for(j,raw)in bytes(row["before"][n].as_str().unwrap()).chunks(z).enumerate(){let reference=r+j as u32*z as u32;m.insert(reference,Memory{reference,raw:raw.to_vec()});}}let mut dead=BTreeSet::new();let mut b=Backend(vec![]);release_input_recursive(&mut m,&mut dead,0x40001000,row["selector"].as_u64().unwrap()as u32,19,&mut b).unwrap();assert_eq!(json!(b.0),row["calls"],"all recursive calls and complete boundary memory {i}");assert_eq!(snapshot(&m),row["after"],"all shared physical banks {i}");assert_eq!(json!(dead.iter().copied().collect::<Vec<_>>()),row["freed"],"exact physical owner lifetimes {i}");for r in &dead{assert_eq!(get(&m,&dead,*r,1),Err(Error::UnresolvedReference));}}
 }
}
