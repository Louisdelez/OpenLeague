from pathlib import Path
r=Path('E:/OpenLeague');src=r/'crates/core/src'
code=r'''//! Actual B131D0 delayed-first, first-curve-first subscriber unlink; no physical free.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put};
fn list(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,header:u32,target:u32)->Result<bool,Error>{
 let mut at=get(m,d,header,4)?;let mut previous=0;let mut seen=BTreeSet::new();while at!=0{if !seen.insert(at){return Err(Error::CyclicList);}if get(m,d,at+4,4)?==target{let next=get(m,d,at,4)?;if at==get(m,d,header,4)?{put(m,d,header,4,next)?;}else{put(m,d,previous,4,next)?;}if at==get(m,d,header+4,4)?{put(m,d,header+4,4,previous)?;}put(m,d,at,4,get(m,d,header+8,4)?)?;put(m,d,header+20,4,get(m,d,header+20,4)?.wrapping_sub(1))?;put(m,d,header+8,4,at)?;return Ok(true);}previous=at;at=get(m,d,at,4)?;}Ok(false)
}
pub fn unlink(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,manager:u32,target:u32)->Result<(),Error>{
 if list(m,d,manager+0x91c,target)?{return Ok(());}let mut curve=get(m,d,manager+0x938,4)?;let mut seen=BTreeSet::new();while curve!=0{if !seen.insert(curve){return Err(Error::CyclicList);}if list(m,d,curve+24,target)?{return Ok(());}curve=get(m,d,curve,4)?;}Ok(())
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 #[test]fn audio_curve_subscriber_unlink_matches384_original_delayed_first_curve_order_duplicates_head_tail_free_list_and_unsigned_count_wrap_cases(){let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_curve_subscriber_unlink_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],384);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32)).collect::<Vec<_>>();let mut m=regions.iter().map(|(n,r)|(*r,Memory{reference:*r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let d=BTreeSet::new();unlink(&mut m,&d,0x40001000,row["target"].as_u64().unwrap()as u32).unwrap();let mut out=json!({});for(n,r)in regions{out[&n]=json!(hex(&m[&r].raw));}assert_eq!(out,row["after"],"all original list/manager/node/free/padding bytes {i}");}
 }
}
'''
(src/'audio_curve_subscriber_unlink.rs').write_text(code,encoding='utf-8');p=src/'lib.rs';p.write_text(p.read_text(encoding='utf-8')+'\npub mod audio_curve_subscriber_unlink;\n',encoding='utf-8')
p=src/'audio_resource_curve_admission.rs';t=p.read_text(encoding='utf-8');t=t.replace(' fn observe_curve(&mut self,_event:Event,_m:&BTreeMap<u32,Memory>){}',' fn observe_curve(&mut self,_event:Event,_m:&BTreeMap<u32,Memory>){}\n fn observe_curve_unlink(&mut self,_target:u32,_m:&BTreeMap<u32,Memory>){}\n fn allocate_subscription(&mut self,pool:u32,size:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{self.allocate(pool,size,m,dead)}')
helper=r'''
fn find_curve(m:&BTreeMap<u32,Memory>,d:&BTreeSet<u32>,manager:u32,key:u32)->Result<u32,Error>{let mut at=get(m,d,manager+0x938,4)?;let mut seen=BTreeSet::new();while at!=0{if !seen.insert(at){return Err(Error::CyclicList);}if get(m,d,at+4,4)?==key{return Ok(at);}at=get(m,d,at,4)?;}Ok(0)}
fn subscription_slot(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,h:u32,size:u32,pool:u32,s:&mut impl Services)->Result<Option<u32>,Error>{
 if get(m,d,h+8,4)?==0{if get(m,d,h+20,4)? >=get(m,d,h+16,4)?{return Ok(None);}let r=s.allocate_subscription(pool,size,m,d)?.unwrap_or(0);if r==0{return Ok(None);}live(m,d,r,size as usize)?;put(m,d,r,4,get(m,d,h+8,4)?)?;put(m,d,h+8,4,r)?;}
 let tail=get(m,d,h+4,4)?;let free=get(m,d,h+8,4)?;if tail==0{put(m,d,h,4,free)?;}else{put(m,d,tail,4,free)?;}let free=get(m,d,h+8,4)?;put(m,d,h+4,4,free)?;let next=get(m,d,free,4)?;put(m,d,h+8,4,next)?;let at=get(m,d,h+4,4)?;put(m,d,at,4,0)?;let at=get(m,d,h+4,4)?;put(m,d,h+20,4,get(m,d,h+20,4)?.wrapping_add(1))?;Ok(Some(at))
}
fn drain_delayed(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,manager:u32,key:u32,pool:u32,s:&mut impl Services)->Result<(),Error>{
 let h=manager+0x91c;let mut current=get(m,d,h,4)?;let mut previous=0;let mut states=BTreeSet::new();
 while current!=0{let state=(current,previous,m.iter().map(|(r,v)|(*r,v.raw.clone())).collect::<Vec<_>>(),d.iter().copied().collect::<Vec<_>>());if !states.insert(state){return Err(Error::CyclicList);}
 if get(m,d,current+8,4)?!=key{previous=current;current=get(m,d,current,4)?;continue;}
 let target=get(m,d,current+4,4)?;let next=get(m,d,current,4)?;if current==get(m,d,h,4)?{put(m,d,h,4,next)?;}else{put(m,d,previous,4,next)?;}if current==get(m,d,h+4,4)?{put(m,d,h+4,4,previous)?;}put(m,d,current,4,get(m,d,h+8,4)?)?;put(m,d,h+20,4,get(m,d,h+20,4)?.wrapping_sub(1))?;put(m,d,h+8,4,current)?;current=next;
 let curve=find_curve(m,d,manager,key)?;if curve!=0{if let Some(slot)=subscription_slot(m,d,curve+24,8,pool,s)?{put(m,d,slot+4,4,target)?;}}
 else if target!=0{s.observe_curve_unlink(target,m);crate::audio_curve_subscriber_unlink::unlink(m,d,manager,target)?;if let Some(slot)=subscription_slot(m,d,h,12,pool,s)?{put(m,d,slot+4,4,target)?;put(m,d,slot+8,4,key)?;}}
 }Ok(())
}
'''
needle='pub fn register(m:';assert needle in t;t=t.replace(needle,helper+'\npub fn register(m:',1)
old='if get(m,d,manager+0x91c,4)?!=0{return Err(Error::Backend("curve admission delayed subscriber callback producer requires native qualification"));}Ok(status)';assert old in t;t=t.replace(old,'drain_delayed(m,d,manager,key,pool,s)?;Ok(status)')
tests=r'''
#[cfg(test)]mod delayed_tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{regions:Vec<(String,u32,usize)>,calls:Vec<Value>,allocations:Vec<Value>,failure:String,index:u32}
 impl Backend{fn snapshot(&self,m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r,z)in &self.regions{out[n]=json!(hex(&(0..*z).map(|j|crate::audio_path_memory::read(m,r+j as u32,1).unwrap()[0]).collect::<Vec<_>>()));}out}
 fn allocation(&mut self,kind:&str,r:u32,p:u32,z:u32,m:&mut BTreeMap<u32,Memory>)->Result<Option<u32>,Error>{let result=if self.failure==kind{0}else{r};self.calls.push(json!({"kind":"allocate","pool":p,"size":z,"result":result,"at_call":self.snapshot(m)}));if result!=0{self.allocations.push(json!({"reference":result,"size":z}));let full=m.remove(&r).unwrap();if full.raw.len()>z as usize{m.insert(r+z,Memory{reference:r+z,raw:full.raw[z as usize..].to_vec()});}m.insert(r,Memory{reference:r,raw:full.raw[..z as usize].to_vec()});}Ok((result!=0).then_some(result))}}
 impl crate::audio_path_voice_empty_source_release::Services for Backend{fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"kind":"free","pool":p,"reference":r,"at_call":self.snapshot(m)}));Ok(())}}
 impl crate::audio_action_registry_key_publication::Services for Backend{fn allocate(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{Err(Error::Backend("explicit delayed allocator required"))}}
 impl Services for Backend{
 fn observe_curve_unlink(&mut self,target:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"unlink_subscriber","target":target,"at_call":self.snapshot(m)}));}
 fn allocate_curve(&mut self,kind:Allocation,p:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{let(name,r)=match kind{Allocation::Node=>("node",0x40004000),Allocation::Points=>("points",0x40007000),Allocation::Temporary=>unreachable!()};self.allocation(name,r,p,z,m)}
 fn allocate_subscription(&mut self,p:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{assert_eq!(z,8);let r=0x40009000+self.index*16;let result=self.allocation("bound",r,p,z,m)?;if result.is_some(){self.index+=1;}Ok(result)}
 }
 #[test]fn audio_curve_delayed_admission_matches118_original_transfer_existing_skip_requeue_oom_and10_proven_native_cycles_with_explicit_rust_cycle_error(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_curve_delayed_admission_cycle_qualified_preparation.json")).unwrap();assert_eq!(p["case_count"],128);assert_eq!(p["terminal_case_count"],118);assert_eq!(p["cycle_case_count"],10);assert_eq!(p["instruction_limited_case_count"],0);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m=BTreeMap::new();for(n,r,z)in &regions{let raw=bytes(row["before"][n].as_str().unwrap());let chunk=if n=="new_bound"{16}else{*z};for(j,b)in raw.chunks(chunk).enumerate(){let reference=r+j as u32*chunk as u32;m.insert(reference,Memory{reference,raw:b.to_vec()});}}
 let mut d=BTreeSet::new();let mut s=Backend{regions,calls:vec![],allocations:vec![],failure:row["failure"].as_str().unwrap().into(),index:0};let result=register(&mut m,&mut d,0x40001000,7,0xabcdef01,0x40005000,2,19,&mut s);
 if row["terminal"].as_bool().unwrap(){assert_eq!(result.unwrap()as u64,row["result"].as_u64().unwrap(),"native terminal status {i}");assert_eq!(json!(s.calls),row["calls"],"complete native allocation/free/unlink snapshots {i}");}else{assert_eq!(result,Err(Error::CyclicList),"Rust explicitly reports actual native state cycle {i}");let native=row["calls"].as_array().unwrap();assert!(s.calls.len()<=native.len());assert_eq!(s.calls,native[..s.calls.len()],"native prefix before equivalent physical cycle {i}");assert!(!row["cycle"].is_null());}
 assert_eq!(s.snapshot(&m),row["after"],"full banks at original return or repeating state {i}");assert_eq!(json!(s.allocations),row["allocations"],"allocation identities/sizes {i}");let freed:BTreeSet<u32>=row["freed"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect();assert_eq!(d,freed,"retired point buffers {i}");}
 }
}
'''
p.write_text(t+tests,encoding='utf-8');(r/'tools/implement_audio_curve_delayed_admission.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('B131D0 unlink, delayed transfer/requeue and explicit native-cycle handling implemented;384+128 replay added.')
