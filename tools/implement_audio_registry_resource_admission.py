from pathlib import Path
r=Path('E:/OpenLeague');s=r/'crates/core/src'
p=s/'audio_dynamic_input_owner_selector.rs';t=p.read_text(encoding='utf-8');t=t.replace('fn loaded(', 'pub(crate) fn loaded(');p.write_text(t,encoding='utf-8')
code=r'''//! AFB320 memory resource reader. Configuration setter bodies and nonempty curve admission remain explicit.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put,live};
#[derive(Clone,Debug)]pub enum Event{Read{tag:u32,size:u32,before:Vec<u8>},Publish(u32),Duration(u32,u32),Transition([u32;5]),Default(u32,u32)}
pub trait Services:crate::audio_action_registry_key_publication::Services{
 fn observe(&mut self,event:Event,m:&BTreeMap<u32,Memory>);
 fn configuration(&mut self,float:bool,bits:u32,selector:u32,m:&mut BTreeMap<u32,Memory>)->Result<u32,Error>;
}
struct Transition<'a,S>(&'a mut S);
impl<S:Services> crate::audio_path_voice_empty_source_release::Services for Transition<'_,S>{fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.0.free(p,r,m)}}
impl<S:Services> crate::audio_action_registry_transition_admission::Services for Transition<'_,S>{fn allocate_transition(&mut self,p:u32,z:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{self.0.allocate(p,z,m,d)}}
fn word(b:&[u8],o:usize)->u32{u32::from_le_bytes(b[o..o+4].try_into().unwrap())}
fn set(b:&mut[u8],o:usize,v:u32){b[o..o+4].copy_from_slice(&v.to_le_bytes());}
fn read(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,stream:u32,b:&mut[u8],o:usize,n:usize,tag:u32,s:&mut impl Services)->Result<u32,Error>{
 s.observe(Event::Read{tag,size:n as u32,before:b[o..o+n].to_vec()},m);
 if get(m,d,stream+28,4)?!=0{return Err(Error::Backend("resource provider reader requires native producer"));}
 let count=(get(m,d,stream+8,4)? as usize).min(n);let at=get(m,d,stream+24,4)?;
 for j in 0..count{b[o+j]=get(m,d,at.wrapping_add(j as u32),1)? as u8;}
 put(m,d,stream+8,4,get(m,d,stream+8,4)?.wrapping_sub(count as u32))?;put(m,d,stream+24,4,at.wrapping_add(count as u32))?;Ok(if count==n{1}else{56})
}
/// B121E0/B111F0/B102D0: actual default record construction in shared physical memory.
/// No status is propagated for allocation failure; existing record lists are preserved.
pub fn default_record(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,manager:u32,key:u32,bits:u32,pool:u32,s:&mut impl Services)->Result<(),Error>{
 let bucket=manager.wrapping_add((key%193)*4);let mut r=get(m,d,bucket,4)?;let mut seen=BTreeSet::new();
 while r!=0{if !seen.insert(r){return Err(Error::CyclicList);}if get(m,d,r,4)?==key{break;}r=get(m,d,r+4,4)?;}
 if r==0{r=s.allocate(pool,40,m,d)?.unwrap_or(0);if r==0{return Ok(());}live(m,d,r,40)?;put(m,d,r,4,key)?;for off in(8..40).step_by(4){put(m,d,r+off,4,0)?;}
 let bucket=manager.wrapping_add((get(m,d,r,4)?%193)*4);put(m,d,r+4,4,get(m,d,bucket,4)?)?;put(m,d,bucket,4,r)?;put(m,d,manager+0x304,4,get(m,d,manager+0x304,4)?.wrapping_add(1))?;
 }put(m,d,r+8,4,bits)?;Ok(())
}
/// Scratch is the original caller's 52 bytes (EBP-28 through EBP+8).
/// Partial reads preserve those bytes; do not silently synthesize missing resource bytes.
pub fn admit(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,stream:u32,enabled:u32,registry:u32,rtpc:u32,pool:u32,b:&mut[u8;52],s:&mut impl Services)->Result<u32,Error>{
 set(b,48,enabled);if enabled==0{return Ok(1);}
 let mut status=read(m,d,stream,b,12,4,0xafb344,s)?;let bits=crate::audio_dynamic_input_owner_selector::loaded(word(b,12))?;s.configuration(true,bits,2,m)?;
 if status==1{status=read(m,d,stream,b,48,2,0xafb369,s)?;s.configuration(false,word(b,48),2,m)?;}
 set(b,28,0);if status!=1{return Ok(status);}status=read(m,d,stream,b,28,4,0xafb395,s)?;if status!=1{return Ok(status);}set(b,16,0);
 while word(b,16)<word(b,28){set(b,48,0);set(b,20,0);set(b,32,0);
 status=read(m,d,stream,b,48,4,0xafb3d4,s)?;if status!=1{break;}status=read(m,d,stream,b,20,4,0xafb3ec,s)?;if status!=1{break;}
 let key=word(b,48);s.observe(Event::Publish(key),m);let result=crate::audio_action_registry_key_publication::publish(m,d,registry,key,pool,s)?;status=if result==0{2}else{1};if status!=1{break;}
 s.observe(Event::Duration(key,word(b,20)),m);status=crate::audio_action_registry_value_update::set_default_duration(m,d,registry,key,word(b,20))?;if status!=1{break;}
 status=read(m,d,stream,b,32,4,0xafb440,s)?;if status!=1{break;}
 let mut i=0;while i<word(b,32){for(o,tag)in[(0,0xafb45d),(4,0xafb471),(8,0xafb485)]{status=read(m,d,stream,b,o,4,tag,s)?;if status!=1{break;}}if status!=1{break;}
 let args=[key,word(b,0),word(b,4),word(b,8),0];s.observe(Event::Transition(args),m);status=crate::audio_action_registry_transition_admission::register(m,d,registry,key,args[1],args[2],args[3],0,pool,&mut Transition(s))?;if status!=1{break;}i+=1;}
 if status!=1{break;}set(b,16,word(b,16).wrapping_add(1));
 }
 set(b,24,0);if status==1{status=read(m,d,stream,b,24,4,0xafb4df,s)?;if status==1{set(b,16,0);while word(b,16)<word(b,24){for(o,tag)in[(4,0xafb505),(0,0xafb51d),(48,0xafb535)]{status=read(m,d,stream,b,o,4,tag,s)?;if status!=1{break;}}if status!=1{break;}if word(b,48)!=0{return Err(Error::Backend("nonempty B10450 curve resource admission not qualified"));}set(b,16,word(b,16).wrapping_add(1));}}}
 set(b,36,0);if status!=1{return Ok(status);}status=read(m,d,stream,b,36,4,0xafb5ca,s)?;if status!=1{return Ok(status);}
 while word(b,36)!=0{status=read(m,d,stream,b,0,4,0xafb5e4,s)?;if status!=1{break;}status=read(m,d,stream,b,48,4,0xafb5f8,s)?;if status!=1{break;}let key=word(b,0);let bits=crate::audio_dynamic_input_owner_selector::loaded(word(b,48))?;s.observe(Event::Default(key,bits),m);default_record(m,d,rtpc,key,bits,pool,s)?;set(b,36,word(b,36).wrapping_sub(1));}Ok(status)
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{regions:Vec<(String,u32,usize)>,calls:Vec<Value>,allocations:Vec<Value>,failure:String,index:u32}
 impl Backend{fn snapshot(&self,m:&BTreeMap<u32,Memory>)->Value{let mut v=json!({});for(n,r,z)in &self.regions{v[n]=json!(hex(&(0..*z).map(|i|crate::audio_path_memory::read(m,r+i as u32,1).unwrap()[0]).collect::<Vec<_>>()));}v}}
 impl crate::audio_path_voice_empty_source_release::Services for Backend{fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{self.calls.push(json!({"kind":"free","pool":p,"reference":r,"at_call":self.snapshot(m)}));Ok(())}}
 impl crate::audio_action_registry_key_publication::Services for Backend{fn allocate(&mut self,p:u32,z:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{let(kind,r)=match z{24=>("key_owner",0x40006000),64|72=>("key_table",0x40005000),60=>("transition_table",0x40007000),40=>("rtpc_record",0x40010000+self.index*64),_=>panic!("size {z}")};let result=if self.failure==kind{0}else{r};self.calls.push(json!({"kind":"allocate","pool":p,"size":z,"result":result,"at_call":self.snapshot(m)}));if result!=0{self.index+=u32::from(z==40);self.allocations.push(json!({"reference":result,"size":z}));let full=m.remove(&r).unwrap();if full.raw.len()>z as usize{m.insert(r+z,Memory{reference:r+z,raw:full.raw[z as usize..].to_vec()});}m.insert(r,Memory{reference:r,raw:full.raw[..z as usize].to_vec()});}Ok((result!=0).then_some(result))}}
 impl Services for Backend{fn observe(&mut self,e:Event,m:&BTreeMap<u32,Memory>){let mut v=match e{Event::Read{tag,size,before}=>json!({"kind":"read","tag":tag,"size":size,"destination_before":hex(&before)}),Event::Publish(key)=>json!({"kind":"publish_key","key":key}),Event::Duration(key,duration)=>json!({"kind":"default_duration","key":key,"duration":duration}),Event::Transition(arguments)=>json!({"kind":"transition","arguments":arguments}),Event::Default(key,bits)=>json!({"kind":"rtpc_default","key":key,"bits":bits})};v["at_call"]=self.snapshot(m);self.calls.push(v);}
 fn configuration(&mut self,float:bool,bits:u32,selector:u32,m:&mut BTreeMap<u32,Memory>)->Result<u32,Error>{self.calls.push(json!({"kind":if float{"configuration_float"}else{"configuration_word"},"value_bits":bits,"selector":selector,"at_call":self.snapshot(m)}));Ok(1)}}
 #[test]fn audio_registry_resource_admission_matches480_original_partial_reads_stack_preservation_key_duration_transition_rtpc_records_oom_and_complete_physical_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_registry_resource_admission_preparation.json")).unwrap();assert_eq!(p["case_count"],480);assert_eq!(p["passed"],true);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m=BTreeMap::new();for(n,r,z)in &regions{let raw=bytes(row["before"][n].as_str().unwrap());let chunk=if n=="records"{64}else{*z};for(j,b)in raw.chunks(chunk).enumerate(){let reference=r+j as u32*chunk as u32;m.insert(reference,Memory{reference,raw:b.to_vec()});}}
 let mut d=BTreeSet::new();let mut s=Backend{regions,calls:vec![],allocations:vec![],failure:row["failure"].as_str().unwrap().into(),index:0};let mut scratch=[row["pattern"].as_u64().unwrap()as u8;52];let result=admit(&mut m,&mut d,0x40002000,row["enabled"].as_u64().unwrap()as u32,0x40001000,0x40009000,19,&mut scratch,&mut s).unwrap();
 assert_eq!(result as u64,row["result"].as_u64().unwrap(),"status {i}");assert_eq!(json!(s.calls),row["calls"],"reads/configuration/native producers/allocator/free snapshots {i}");assert_eq!(s.snapshot(&m),row["after"],"entire physical bank {i}");assert_eq!(json!(s.allocations),row["allocations"],"allocation sizes {i}");let freed:BTreeSet<u32>=row["freed"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap()as u32).collect();assert_eq!(d,freed,"retired storage {i}");}
 }
}
'''
(s/'audio_registry_resource_admission.rs').write_text(code,encoding='utf-8')
p=s/'lib.rs';t=p.read_text(encoding='utf-8');t+='\npub mod audio_registry_resource_admission;\n';p.write_text(t,encoding='utf-8')
(r/'tools/implement_audio_registry_resource_admission.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('Implemented actual memory resource reader and canonical RTPC default producer; 480-case replay added.')
