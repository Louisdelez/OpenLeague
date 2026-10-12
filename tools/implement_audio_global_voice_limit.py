from pathlib import Path
r=Path('E:/OpenLeague');src=r/'crates/core/src'
code=r'''//! Actual AEB180 global voice-limit setter; signed selector priority and low16 input.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_plugin_factory::Memory,audio_bus_bank::Error};
use crate::audio_path_source_virtual_cleanup::{get,put};
#[derive(Clone,Copy)]pub struct Limits{pub priority:u32,pub voices:u32}
pub fn set(m:&mut BTreeMap<u32,Memory>,dead:&BTreeSet<u32>,globals:Limits,bits:u32,selector:u32)->Result<u32,Error>{
 let value=bits&0xffff;if value==0{return Ok(31);}
 if selector as i32<=get(m,dead,globals.priority,4)? as i32{put(m,dead,globals.priority,4,selector)?;put(m,dead,globals.voices,2,value)?;}Ok(1)
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::Value;
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 #[test]fn audio_global_voice_limit_matches400_original_signed_priority_low16_zero_status_and_complete_globals(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_global_voice_limit_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],400);let r=p["reference"].as_u64().unwrap()as u32;
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m=BTreeMap::from([(r,Memory{reference:r,raw:bytes(row["before"].as_str().unwrap())})]);let result=set(&mut m,&BTreeSet::new(),Limits{priority:0x12100d8,voices:0x12100ec},row["bits"].as_u64().unwrap()as u32,row["selector"].as_u64().unwrap()as u32).unwrap();assert_eq!(result as u64,row["result"].as_u64().unwrap(),"status {i}");assert_eq!(hex(&m[&r].raw),row["after"].as_str().unwrap(),"all64 global bytes {i}");}
 }
}
'''
(src/'audio_global_voice_limit.rs').write_text(code,encoding='utf-8')
p=src/'lib.rs';t=p.read_text(encoding='utf-8');t+='\npub mod audio_global_voice_limit;\n';p.write_text(t,encoding='utf-8')
p=src/'audio_registry_resource_admission.rs';t=p.read_text(encoding='utf-8')
t=t.replace(' fn configuration(&mut self,float:bool', ' fn observe_configuration(&mut self,_float:bool,_bits:u32,_selector:u32,_m:&BTreeMap<u32,Memory>){}\n fn configuration(&mut self,float:bool',1)
old='pub fn admit(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,stream:u32,enabled:u32,registry:u32,rtpc:u32,pool:u32,b:&mut[u8;52],s:&mut impl Services)->Result<u32,Error>{'
new=old+'admit_inner(m,d,stream,enabled,registry,rtpc,pool,b,None,s)}\n/// Compose the actual global voice-limit producer; float configuration remains explicit.\npub fn admit_native_voice_limit(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,stream:u32,enabled:u32,registry:u32,rtpc:u32,pool:u32,b:&mut[u8;52],limits:crate::audio_global_voice_limit::Limits,s:&mut impl Services)->Result<u32,Error>{admit_inner(m,d,stream,enabled,registry,rtpc,pool,b,Some(limits),s)}\nfn admit_inner(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,stream:u32,enabled:u32,registry:u32,rtpc:u32,pool:u32,b:&mut[u8;52],limits:Option<crate::audio_global_voice_limit::Limits>,s:&mut impl Services)->Result<u32,Error>{'
assert old in t;t=t.replace(old,new)
t=t.replace('s.configuration(false,word(b,48),2,m)?;','if let Some(limits)=limits{s.observe_configuration(false,word(b,48),2,m);crate::audio_global_voice_limit::set(m,d,limits,word(b,48),2)?;}else{s.configuration(false,word(b,48),2,m)?;}')
needle=' fn configuration(&mut self,float:bool,bits:u32,selector:u32,m:&mut BTreeMap<u32,Memory>)->Result<u32,Error>{self.calls.push'
t=t.replace(needle,' fn observe_configuration(&mut self,float:bool,bits:u32,selector:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":if float{"configuration_float"}else{"configuration_word"},"value_bits":bits,"selector":selector,"at_call":self.snapshot(m)}));}\n'+needle)
old=' #[test]fn audio_registry_resource_admission_matches480_original_partial_reads_stack_preservation_key_duration_transition_rtpc_records_oom_and_complete_physical_cases(){\n let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_registry_resource_admission_preparation.json")).unwrap();'
new=' #[test]fn audio_registry_resource_admission_matches480_original_partial_reads_stack_preservation_key_duration_transition_rtpc_records_oom_and_complete_physical_cases(){replay("data/4.20/audio_registry_resource_admission_preparation.json",false);}\n #[test]fn audio_registry_resource_admission_matches480_original_real_global_voice_limit_priority_and_full_resource_compositions(){replay("data/4.20/audio_registry_resource_voice_limit_preparation.json",true);}\n fn replay(path:&str,native:bool){\n let p:Value=serde_json::from_str(&crate::audio_test_fixture(path)).unwrap();'
assert old in t;t=t.replace(old,new)
old='let result=admit(&mut m,&mut d,0x40002000,row["enabled"].as_u64().unwrap()as u32,0x40001000,0x40009000,19,&mut scratch,&mut s).unwrap();'
new='let enabled=row["enabled"].as_u64().unwrap()as u32;let result=if native{admit_native_voice_limit(&mut m,&mut d,0x40002000,enabled,0x40001000,0x40009000,19,&mut scratch,crate::audio_global_voice_limit::Limits{priority:0x12100d8,voices:0x12100ec},&mut s)}else{admit(&mut m,&mut d,0x40002000,enabled,0x40001000,0x40009000,19,&mut scratch,&mut s)}.unwrap();'
assert old in t;t=t.replace(old,new);p.write_text(t,encoding='utf-8')
(r/'tools/implement_audio_global_voice_limit.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('Implemented real global setter,400 native cases and480 full resource compositions.')
