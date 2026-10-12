//! Original CA9026 destructor, CA8B6F locale release and CA915B detach caller.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_global_float_default_power::Windows};
use crate::audio_path_source_virtual_cleanup::{get,put};
pub trait Services:Windows{}
fn decrement(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,a:u32)->Result<u32,Error>{let v=get(m,d,a,4)?.wrapping_sub(1);put(m,d,a,4,v)?;Ok(v)}
/// Native reference operations preserve unsigned wrap and pointer aliases.
pub fn release_locale(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,locale:u32)->Result<(),Error>{if locale==0{return Ok(());}decrement(m,d,locale)?;for offset in[0x78,0x80,0x7c,0x88]{let r=get(m,d,locale+offset,4)?;if r!=0{decrement(m,d,r)?;}}for j in 0..6{let a=locale+0x1c+j*16;if get(m,d,a-8,4)?!=0x12230d4{let r=get(m,d,a,4)?;if r!=0{decrement(m,d,r)?;}}if get(m,d,a-12,4)?!=0{let r=get(m,d,a-4,4)?;if r!=0{decrement(m,d,r)?;}}}let r=get(m,d,locale+0x9c,4)?.wrapping_add(0xb0);decrement(m,d,r)?;Ok(())}
fn free(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,reference:u32,s:&mut impl Services)->Result<(),Error>{s.free_thread(reference,m,d)?;if reference!=0{d.insert(reference);}Ok(())}
pub fn destroy(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,record:u32,s:&mut impl Services)->Result<(),Error>{
 if record==0{return Ok(());}
 for off in[0x24,0x2c,0x34,0x3c,0x40,0x44,0x48]{let reference=get(m,d,record+off,4)?;if reference!=0{free(m,d,reference,s)?;}}
 let exception=get(m,d,record+0x5c,4)?;if exception!=0x106b708{free(m,d,exception,s)?;}
 crate::audio_crt_thread_context::lock(m,d,13,true,s)?;
 let mb=get(m,d,record+0x68,4)?;if mb!=0&&decrement(m,d,mb)?==0&&mb!=0x1222bb0{free(m,d,mb,s)?;}
 crate::audio_crt_thread_context::lock(m,d,13,false,s)?;
 crate::audio_crt_thread_context::lock(m,d,12,true,s)?;
 let locale=get(m,d,record+0x6c,4)?;if locale!=0{release_locale(m,d,locale)?;if locale!=get(m,d,0x122323c,4)?&&locale!=0x1223240&&get(m,d,locale,4)?==0{crate::audio_crt_custom_locale_destructor::destroy(m,d,locale,s)?;}}
 crate::audio_crt_thread_context::lock(m,d,12,false,s)?;free(m,d,record,s)
}
pub fn detach(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,record:u32,s:&mut(impl Services+crate::audio_crt_tls_value_wrappers::Services))->Result<(),Error>{
 let mut index=get(m,d,0x12230cc,4)?;if index==u32::MAX{return Ok(());}let mut r=record;
 if r==0{r=crate::audio_crt_tls_value_wrappers::get_value(m,d,index,s)?;index=get(m,d,0x12230cc,4)?;}
 let _=crate::audio_crt_tls_value_wrappers::set_value(m,d,index,0,s)?;destroy(m,d,r,s)
}
