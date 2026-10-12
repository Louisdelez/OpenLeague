from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/audio_registry_resource_admission.rs';t=p.read_text(encoding='utf-8')
t=t.replace('pub trait Services:crate::audio_resource_curve_admission::Services{','pub trait Services:crate::audio_resource_curve_admission::Services+crate::audio_global_float_configuration::Services{')
t=t.replace('pool,b,None,s)}','pool,b,None,None,s)}').replace('pool,b,Some(limits),s)}','pool,b,Some(limits),None,s)}')
needle='fn admit_inner(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,stream:u32,enabled:u32,registry:u32,rtpc:u32,pool:u32,b:&mut[u8;52],limits:Option<crate::audio_global_voice_limit::Limits>,s:&mut impl Services)->Result<u32,Error>{'
new='''/// Compose both original global configuration producers; CRT power remains the explicit backend dependency.
pub fn admit_native_configuration(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,stream:u32,enabled:u32,registry:u32,rtpc:u32,pool:u32,b:&mut[u8;52],limits:crate::audio_global_voice_limit::Limits,float:crate::audio_global_float_configuration::Context,s:&mut impl Services)->Result<u32,Error>{admit_inner(m,d,stream,enabled,registry,rtpc,pool,b,Some(limits),Some(float),s)}
fn admit_inner(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,stream:u32,enabled:u32,registry:u32,rtpc:u32,pool:u32,b:&mut[u8;52],limits:Option<crate::audio_global_voice_limit::Limits>,float:Option<crate::audio_global_float_configuration::Context>,s:&mut impl Services)->Result<u32,Error>{'''
assert needle in t;t=t.replace(needle,new)
t=t.replace('s.configuration(true,bits,2,m)?;','if let Some(float)=float{s.observe_configuration(true,bits,2,m);crate::audio_global_float_configuration::set(m,d,float,bits,2,s)?;}else{s.configuration(true,bits,2,m)?;}')
needle=' impl Services for Backend{'
new=''' impl crate::audio_global_float_configuration::Services for Backend{fn power(&mut self,bits:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{let v=f32::from_bits(bits);if v.is_nan(){self.calls.push(json!({"kind":"windows","function":"GetLastError","result":97,"at_call":self.snapshot(m)}));self.calls.push(json!({"kind":"windows","function":"TlsGetValue","index":5,"result":0x40018000u32,"last_error_before":97,"at_call":self.snapshot(m)}));self.calls.push(json!({"kind":"windows","function":"SetLastError","value":97,"last_error_before":0,"at_call":self.snapshot(m)}));put(m,d,0x40018008,4,33)?;}Ok((10f64.powf(v as f64)as f32).to_bits())}}
'''
assert needle in t;t=t.replace(needle,new+needle)
t=t.replace(' fn replay(path:&str,native:bool){',' #[test]fn audio_registry_resource_admission_matches480_original_both_global_producers_full_curve_registry_thread_and_partial_read_effects_with_explicit_candidate_power_dependency(){replay("data/4.20/audio_registry_resource_full_configuration_preparation.json",true);}\n fn replay(path:&str,native:bool){')
needle='let result=if native{admit_native_voice_limit('
new='let result=if path.contains("full_configuration"){admit_native_configuration(&mut m,&mut d,0x40002000,enabled,0x40001000,0x40009000,19,&mut scratch,crate::audio_global_voice_limit::Limits{priority:0x12100d8,voices:0x12100ec},crate::audio_global_float_configuration::Context{priority:0x12100d4,threshold:0x121022c,value:0x1210230,conversion_cache:0x14a7970},&mut s)}else if native{admit_native_voice_limit('
assert needle in t;t=t.replace(needle,new)
p.write_text(t,encoding='utf-8');(r/'tools/implement_audio_registry_full_configuration.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8');print('Both original configuration bodies integrated; full480 composition replay added.')
