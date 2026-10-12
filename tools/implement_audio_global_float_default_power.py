from pathlib import Path
import json,struct,re
r=Path('E:/OpenLeague');src=r/'crates/core/src';p=json.loads((r/'data/4.20/audio_global_float_power_boundary_preparation.json').read_text(encoding='utf-8'));finite=[x['exponent_bits']for x in p['cases']if not __import__('math').isnan(struct.unpack('<f',x['exponent_bits'].to_bytes(4,'little'))[0])];minimum=min(finite,key=lambda v:struct.unpack('<f',v.to_bytes(4,'little'))[0])
code=r'''//! Default audio10^exponent power and original existing-thread errno33 path.
//! Host double power reconstruction qualified against12298 original rounded results.
//! Original CRT initialization/custom handlers/other math domains remain separate.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::put;
pub trait Windows{
 fn get_last_error(&mut self,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<u32,Error>;
 fn tls_get_value(&mut self,index:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<u32,Error>;
 fn set_last_error(&mut self,value:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<(),Error>;
}
#[cfg(target_arch="x86_64")]
fn rounded(bits:u32)->u32{
 let mut control=[0x037f0000u32,0,0x1f80];unsafe{std::arch::asm!("fnstcw word ptr [{c}]","fldcw word ptr [{c}+2]","stmxcsr dword ptr [{c}+4]","ldmxcsr dword ptr [{c}+8]",c=in(reg)control.as_mut_ptr(),options(nostack));}
 let exponent=std::hint::black_box(f32::from_bits(bits));let result=(std::hint::black_box(10f64).powf(exponent as f64)as f32).to_bits();
 unsafe{std::arch::asm!("fldcw word ptr [{c}]","ldmxcsr dword ptr [{c}+4]",c=in(reg)control.as_ptr(),options(nostack));}result
}
#[cfg(not(target_arch="x86_64"))]fn rounded(_:u32)->u32{unreachable!()}
/// Supported audio configuration domain only; do not silently extend to generic CRT pow.
pub fn power(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,bits:u32,tls_index:u32,s:&mut impl Windows)->Result<u32,Error>{
 let exponent=f32::from_bits(bits);if exponent<f32::from_bits(MINIMUM)||exponent>0.0{return Err(Error::Backend("power exponent outside qualified audio configuration domain"));}
 if !cfg!(target_arch="x86_64"){return Err(Error::Backend("qualified audio power hardware unavailable"));}let result=rounded(bits);
 if exponent.is_nan(){let saved=s.get_last_error(m,d)?;let record=s.tls_get_value(tls_index,m,d)?;s.set_last_error(saved,m,d)?;if record==0{return Err(Error::Backend("original CRT thread-record construction required"));}put(m,d,record.wrapping_add(8),4,33)?;}Ok(result)
}
/// Default power provider for the real global floating configuration producer.
pub struct Backend<'a,S>{pub tls_index:u32,pub windows:&'a mut S}
impl<S:Windows> crate::audio_global_float_configuration::Services for Backend<'_,S>{fn power(&mut self,bits:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{power(m,d,bits,self.tls_index,self.windows)}}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 struct Api{last:u32,calls:Vec<Value>}
 impl Windows for Api{
 fn get_last_error(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.calls.push(json!({"function":"GetLastError","result":self.last}));Ok(self.last)}
 fn tls_get_value(&mut self,index:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{assert_eq!(index,5);self.calls.push(json!({"function":"TlsGetValue","index":index,"result":0x40012000u32,"last_error_before":self.last}));self.last=0;Ok(0x40012000)}
 fn set_last_error(&mut self,value:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.calls.push(json!({"function":"SetLastError","value":value,"last_error_before":self.last}));self.last=value;Ok(())}
 }
 #[test]fn audio_global_float_default_power_matches12298_original_rounded_powers_and_existing_thread_errno_preservation_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_global_float_power_boundary_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],12298);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m=BTreeMap::from([(0x40012000,Memory{reference:0x40012000,raw:vec![0;0x3bc]})]);let mut d=BTreeSet::new();let mut api=Api{last:97,calls:vec![]};let bits=row["exponent_bits"].as_u64().unwrap()as u32;let result=power(&mut m,&mut d,bits,5,&mut api).unwrap();assert_eq!(result as u64,row["power_bits"].as_u64().unwrap(),"native rounded power {i}");let mut expected=vec![0u8;0x3bc];expected[8..12].copy_from_slice(&(row["errno"].as_u64().unwrap()as u32).to_le_bytes());assert_eq!(m[&0x40012000].raw,expected,"whole thread record {i}");assert_eq!(api.last as u64,row["last_error"].as_u64().unwrap(),"Windows error preserved {i}");assert_eq!(api.calls.len(),if f32::from_bits(bits).is_nan(){3}else{0},"native imported calls {i}");assert!(d.is_empty());}
 }
}
'''.replace('MINIMUM',hex(minimum)+'u32')
(src/'audio_global_float_default_power.rs').write_text(code,encoding='utf-8');lp=src/'lib.rs';lp.write_text(lp.read_text(encoding='utf-8')+'\npub mod audio_global_float_default_power;\n',encoding='utf-8')
p=src/'audio_global_float_configuration.rs';t=p.read_text(encoding='utf-8');start=t.index(' impl Services for Backend{fn power(');end=t.index(' #[test]fn audio_global_float_configuration_',start)
new=r''' impl crate::audio_global_float_default_power::Windows for Backend{
 fn get_last_error(&mut self,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.calls.push(json!({"function":"GetLastError","result":self.last_error,"at_call":self.snapshot(m)}));Ok(self.last_error)}
 fn tls_get_value(&mut self,index:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{assert_eq!(index,5);self.calls.push(json!({"function":"TlsGetValue","index":index,"result":0x40012000u32,"last_error_before":self.last_error,"at_call":self.snapshot(m)}));self.last_error=0;Ok(0x40012000)}
 fn set_last_error(&mut self,value:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.calls.push(json!({"function":"SetLastError","value":value,"last_error_before":self.last_error,"at_call":self.snapshot(m)}));self.last_error=value;Ok(())}
 }
 impl Services for Backend{fn power(&mut self,bits:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{crate::audio_global_float_default_power::power(m,d,bits,5,self)}}
'''
t=t[:start]+new+t[end:];t=t.replace('_with_explicit_candidate_power_dependency','_with_default_power_and_explicit_windows_imports');p.write_text(t,encoding='utf-8')
p=src/'audio_registry_resource_admission.rs';t=p.read_text(encoding='utf-8');t=t.replace('failure:String,index:u32}','failure:String,index:u32,last_error:u32}').replace('index:0};','index:0,last_error:97};');start=t.index(' impl crate::audio_global_float_configuration::Services for Backend{');end=t.index(' impl Services for Backend{',start)
new=r''' impl crate::audio_global_float_default_power::Windows for Backend{
 fn get_last_error(&mut self,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{self.calls.push(json!({"kind":"windows","function":"GetLastError","result":self.last_error,"at_call":self.snapshot(m)}));Ok(self.last_error)}
 fn tls_get_value(&mut self,index:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{assert_eq!(index,5);self.calls.push(json!({"kind":"windows","function":"TlsGetValue","index":index,"result":0x40018000u32,"last_error_before":self.last_error,"at_call":self.snapshot(m)}));self.last_error=0;Ok(0x40018000)}
 fn set_last_error(&mut self,value:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.calls.push(json!({"kind":"windows","function":"SetLastError","value":value,"last_error_before":self.last_error,"at_call":self.snapshot(m)}));self.last_error=value;Ok(())}
 }
 impl crate::audio_global_float_configuration::Services for Backend{fn power(&mut self,bits:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{crate::audio_global_float_default_power::power(m,d,bits,5,self)}}
'''
t=t[:start]+new+t[end:];t=t.replace('_with_explicit_candidate_power_dependency','_with_default_power_and_explicit_windows_imports');p.write_text(t,encoding='utf-8');(r/'tools/implement_audio_global_float_default_power.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Default audio power and existing-thread errno path implemented; actual producer/resource tests now compose it, Windows interfaces remain explicit.')
