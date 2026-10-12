//! Default audio10^exponent power and original existing-thread errno33 path.
//! Host double power reconstruction qualified against12298 original rounded results.
//! Original CRT initialization/custom handlers/other math domains remain separate.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::put;
pub trait Windows{
 fn calloc_thread(&mut self,_count:u32,_size:u32,_m:&mut BTreeMap<u32,Memory>,_dead:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{Err(Error::Backend("original CRT calloc service required"))}
 fn free_thread(&mut self,_reference:u32,_m:&mut BTreeMap<u32,Memory>,_dead:&mut BTreeSet<u32>)->Result<(),Error>{Err(Error::Backend("original CRT free service required"))}
 fn tls_set_value(&mut self,_index:u32,_value:u32,_m:&mut BTreeMap<u32,Memory>,_dead:&mut BTreeSet<u32>)->Result<bool,Error>{Err(Error::Backend("Windows TLS setter required"))}
 fn current_thread_id(&mut self,_m:&mut BTreeMap<u32,Memory>,_dead:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("Windows thread identity required"))}
 fn thread_lock(&mut self,_reference:u32,_enter:bool,_m:&mut BTreeMap<u32,Memory>,_dead:&mut BTreeSet<u32>)->Result<(),Error>{Err(Error::Backend("Windows CRT lock service required"))}

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
 let exponent=f32::from_bits(bits);if exponent<f32::from_bits(0xc09a147bu32)||exponent>0.0{return Err(Error::Backend("power exponent outside qualified audio configuration domain"));}
 if !cfg!(target_arch="x86_64"){return Err(Error::Backend("qualified audio power hardware unavailable"));}let result=rounded(bits);
 if exponent.is_nan(){let saved=s.get_last_error(m,d)?;let mut record=s.tls_get_value(tls_index,m,d)?;if record==0{record=crate::audio_crt_thread_context::create(m,d,s)?;}s.set_last_error(saved,m,d)?;if record==0{return Err(Error::Backend("original CRT fatal missing-thread-context path required"));}put(m,d,record.wrapping_add(8),4,33)?;}Ok(result)
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
