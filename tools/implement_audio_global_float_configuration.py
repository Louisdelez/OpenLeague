from pathlib import Path
r=Path('E:/OpenLeague');src=r/'crates/core/src'
probe=(r/'tools/global_float_numeric_hardware_candidate_aligned.rs').read_text(encoding='utf-8');numeric=probe[probe.index('fn numeric('):probe.index('fn main(){')]
numeric=numeric.replace('fn numeric(bits:u32,cache:&mut[u32;2])->[u32;2]{','#[cfg(target_arch="x86_64")]\nfn numeric(bits:u32,scaled:u32,power:u32,cache:&mut[u32;2])->[u32;2]{').replace(' let scaled=(f32::from_bits(bits)*f32::from_bits(0x3d4ccccd)).to_bits();let power=(10f64.powf(f32::from_bits(scaled) as f64) as f32).to_bits();','')
code=r'''//! AEB3D0 global floating configuration. Original CRT power remains an explicit dependency.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put};
#[derive(Clone,Copy)]pub struct Context{pub priority:u32,pub threshold:u32,pub value:u32,pub conversion_cache:u32}
pub trait Services{
 /// CA2FA0: power10^exponent, rounded at the original FSTP m32 boundary.
 /// Implementations own original CRT error/thread effects; no implicit replacement.
 fn power(&mut self,_exponent:u32,_m:&mut BTreeMap<u32,Memory>,_dead:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("original CRT power producer required"))}
}
#[cfg(target_arch="x86_64")]
fn scaled(bits:u32)->u32{let factor=0x3d4ccccdu32;let mut result=0u32;let mut control=[0u32,0x1f80];unsafe{std::arch::asm!("stmxcsr dword ptr [{control}]","ldmxcsr dword ptr [{control}+4]","movss xmm0,dword ptr [{bits}]","mulss xmm0,dword ptr [{factor}]","movss dword ptr [{result}],xmm0","ldmxcsr dword ptr [{control}]",control=in(reg)control.as_mut_ptr(),bits=in(reg)&bits,factor=in(reg)&factor,result=in(reg)&mut result,out("xmm0")_,options(nostack));}result}
#[cfg(not(target_arch="x86_64"))]fn scaled(_:u32)->u32{unreachable!()}
/// Invalid range returns31 before priority mutation. Higher signed priority skips all work.
pub fn set(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,c:Context,bits:u32,selector:u32,s:&mut impl Services)->Result<u32,Error>{
 let value=f32::from_bits(bits);if value<f32::from_bits(0xc2c0999a)||value>0.0{return Ok(31);}if selector as i32>get(m,d,c.priority,4)? as i32{return Ok(1);}
 if !cfg!(target_arch="x86_64"){return Err(Error::Backend("native global float SSE/x87 unavailable"));}
 put(m,d,c.priority,4,selector)?;let exponent=scaled(bits);let power=s.power(exponent,m,d)?;let mut cache=[get(m,d,c.conversion_cache,4)?,get(m,d,c.conversion_cache+4,4)?];let output=numeric(bits,exponent,power,&mut cache);
 put(m,d,c.conversion_cache,4,cache[0])?;put(m,d,c.conversion_cache+4,4,cache[1])?;put(m,d,c.threshold,4,output[0])?;put(m,d,c.value,4,output[1])?;Ok(1)
}
#[repr(align(16))]struct Aligned([u32;16]);
'''+numeric+r'''
#[cfg(not(target_arch="x86_64"))]fn numeric(_:u32,_:u32,_:u32,_:&mut[u32;2])->[u32;2]{unreachable!()}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{regions:Vec<(String,u32)>,calls:Vec<Value>,last_error:u32}
 impl Backend{fn snapshot(&self,m:&BTreeMap<u32,Memory>)->Value{let mut v=json!({});for(n,r)in &self.regions{v[n]=json!(hex(&m[r].raw));}v}}
 impl Services for Backend{fn power(&mut self,bits:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{
 let value=f32::from_bits(bits);if value.is_nan(){let saved=self.last_error;self.calls.push(json!({"function":"GetLastError","result":saved,"at_call":self.snapshot(m)}));self.calls.push(json!({"function":"TlsGetValue","index":5,"result":0x40012000u32,"last_error_before":self.last_error,"at_call":self.snapshot(m)}));self.last_error=0;self.calls.push(json!({"function":"SetLastError","value":saved,"last_error_before":self.last_error,"at_call":self.snapshot(m)}));self.last_error=saved;put(m,d,0x40012008,4,33)?;}
 // Explicit candidate dependency, separately measured on384 actual-CPU numeric cases.
 Ok((10f64.powf(value as f64)as f32).to_bits())
 }}
 #[test]fn audio_global_float_configuration_matches792_original_gates_signed_priority_publishing_cache_and_thread_effects_with_explicit_candidate_power_dependency(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_global_float_configuration_tls_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],792);assert_eq!(p["fault_count"],0);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32)).collect::<Vec<_>>();let mut m=regions.iter().map(|(n,r)|(*r,Memory{reference:*r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut d=BTreeSet::new();let mut s=Backend{regions,calls:vec![],last_error:97};let result=set(&mut m,&mut d,Context{priority:0x12100d4,threshold:0x121022c,value:0x1210230,conversion_cache:0x14a7970},row["bits"].as_u64().unwrap()as u32,row["selector"].as_u64().unwrap()as u32,&mut s).unwrap();assert_eq!(result as u64,row["result"].as_u64().unwrap(),"status {i}");assert_eq!(s.snapshot(&m),row["after"],"global/cache/thread physical state {i}");assert_eq!(json!(s.calls),row["windows_calls"],"controlled CRT dependency native Windows entry snapshots {i}");assert_eq!(s.last_error as u64,row["last_error_after"].as_u64().unwrap(),"prior error restored {i}");}
 }
}
'''
(src/'audio_global_float_configuration.rs').write_text(code,encoding='utf-8');p=src/'lib.rs';p.write_text(p.read_text(encoding='utf-8')+'\npub mod audio_global_float_configuration;\n',encoding='utf-8')
(r/'tools/implement_audio_global_float_configuration.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Global floating configuration body implemented with explicit CRT power dependency;792 replay added.')
