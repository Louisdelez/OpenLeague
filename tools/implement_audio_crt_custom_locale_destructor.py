from pathlib import Path
import sys,json
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'))
exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'native-helper-code','exec'))
import capstone
c=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);orders={}
for name,a,z,operation in [('numeric',0xcc7e5a,0x102,'mov'),('monetary',0xcc82f7,0x68,'mov'),('time',0xcc8564,0x385,'push')]:
 fields=[]
 for x in c.disasm(bytes(u.mem_read(a,z)),a):
  if x.mnemonic=='ret':break
  if x.mnemonic!=operation:continue
  text=x.op_str
  if operation=='mov'and not text.startswith('eax, dword ptr [esi'):continue
  if operation=='push'and not text.startswith('dword ptr [esi'):continue
  part=text.split('[esi',1)[1].split(']',1)[0].strip();fields.append(int(part[1:].strip(),0)if part else 0)
 orders[name]=fields
assert len(orders['numeric'])==13 and len(orders['monetary'])==5 and len(orders['time'])==87
s=r'''//! Original CA8A15 custom locale destruction and its3 native nested free helpers.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory,audio_global_float_default_power::Windows};
use crate::audio_path_source_virtual_cleanup::get;
const NUMERIC:&[u32]=@@NUMERIC@@;
const MONETARY:&[u32]=@@MONETARY@@;
const TIME:&[u32]=@@TIME@@;
fn free(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,r:u32,s:&mut impl Windows)->Result<(),Error>{s.free_thread(r,m,d)?;if r!=0{d.insert(r);}Ok(())}
fn conversion(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,r:u32,fields:&[u32],s:&mut impl Windows)->Result<(),Error>{if r==0{return Ok(());}for off in fields{let pointer=get(m,d,r+off,4)?;if pointer!=get(m,d,0x1222558+off,4)?{free(m,d,pointer,s)?;}}Ok(())}
pub fn destroy(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,locale:u32,s:&mut impl Windows)->Result<(),Error>{
 let conv=get(m,d,locale+0x84,4)?;if conv!=0&&conv!=0x1222558{let numeric=get(m,d,locale+0x78,4)?;if numeric!=0&&get(m,d,numeric,4)?==0{
  let r=get(m,d,locale+0x80,4)?;if r!=0&&get(m,d,r,4)?==0{free(m,d,r,s)?;let conv=get(m,d,locale+0x84,4)?;conversion(m,d,conv,NUMERIC,s)?;}
  let r=get(m,d,locale+0x7c,4)?;if r!=0&&get(m,d,r,4)?==0{free(m,d,r,s)?;let conv=get(m,d,locale+0x84,4)?;conversion(m,d,conv,MONETARY,s)?;}
  let r=get(m,d,locale+0x78,4)?;free(m,d,r,s)?;let conv=get(m,d,locale+0x84,4)?;free(m,d,conv,s)?;
 }}
 let ctype=get(m,d,locale+0x88,4)?;if ctype!=0&&get(m,d,ctype,4)?==0{
  let r=get(m,d,locale+0x8c,4)?.wrapping_sub(0xfe);free(m,d,r,s)?;
  let r=get(m,d,locale+0x94,4)?.wrapping_sub(0x80);free(m,d,r,s)?;
  let r=get(m,d,locale+0x98,4)?.wrapping_sub(0x80);free(m,d,r,s)?;
  let r=get(m,d,locale+0x88,4)?;free(m,d,r,s)?;
 }
 let time=get(m,d,locale+0x9c,4)?;if time!=0x12230d8&&get(m,d,time.wrapping_add(0xb0),4)?==0{
  if time!=0{for off in TIME{let r=get(m,d,time+off,4)?;free(m,d,r,s)?;}}
  let r=get(m,d,locale+0x9c,4)?;free(m,d,r,s)?;
 }
 for j in 0..6{let a=locale+0x1c+j*16;if get(m,d,a-8,4)?!=0x12230d4{let r=get(m,d,a,4)?;if r!=0&&get(m,d,r,4)?==0{free(m,d,r,s)?;let name=get(m,d,locale+0xa0+j*4,4)?;free(m,d,name,s)?;}}
  if get(m,d,a-12,4)?!=0{let r=get(m,d,a-4,4)?;if r!=0&&get(m,d,r,4)?==0{free(m,d,r,s)?;}}
 }
 free(m,d,locale,s)
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 struct Api{regions:Vec<(String,u32,usize)>,calls:Vec<Value>,freed:Vec<u32>}
 impl Api{fn snapshot(&self,m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r,z)in &self.regions{out[n]=json!((0..*z).map(|j|format!("{:02x}",crate::audio_path_memory::read(m,r+j as u32,1).unwrap()[0])).collect::<String>());}out}}
 impl Windows for Api{
 fn get_last_error(&mut self,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("unexpected locale LastError call"))}
 fn set_last_error(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{Err(Error::Backend("unexpected locale LastError call"))}
 fn tls_get_value(&mut self,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("unexpected locale TLS call"))}
 fn free_thread(&mut self,r:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.calls.push(json!({"kind":"free","reference":r,"at_call":self.snapshot(m)}));self.freed.push(r);Ok(())}
 }
 #[test]fn audio_crt_custom_locale_destruction_matches96_original_three_nested_helpers_conversion_defaults_ctype_rebasing_string_groups_time_null_frees_and_all_physical_lifetimes(){let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_crt_custom_locale_destruction_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],96);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m:BTreeMap<u32,Memory>=regions.iter().map(|(n,r,_)|(*r,Memory{reference:*r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();for(base,count,size)in[(0x40008000,22,32),(0x40009000,31,512)]{let block=m.remove(&base).unwrap();assert_eq!(block.raw.len(),count*size);for j in 0..count{let reference=base+(j*size)as u32;m.insert(reference,Memory{reference,raw:block.raw[j*size..(j+1)*size].to_vec()});}}
 let mut d=BTreeSet::new();let mut api=Api{regions,calls:vec![],freed:vec![]};destroy(&mut m,&mut d,0x40006000,&mut api).unwrap();assert_eq!(json!(api.calls),row["calls"],"original helper order and every full canonical entry bank {i}");assert_eq!(api.snapshot(&m),row["after"],"all7 canonical regions and passive post-free storage {i}");assert_eq!(json!(api.freed),row["freed"],"exact original NULL/dynamic/default pointer free identities {i}");assert_eq!(d,api.freed.iter().copied().filter(|r|*r!=0).collect(),"actual distinct nonNULL allocations retired {i}");}}
}
'''
for key in ['numeric','monetary','time']:s=s.replace('@@'+key.upper()+'@@','&'+json.dumps(orders[key]))
(r/'crates/core/src/audio_crt_custom_locale_destructor.rs').write_text(s,encoding='utf-8')
p=r/'crates/core/src/audio_crt_thread_destructor.rs';s=p.read_text(encoding='utf-8');old='pub trait Services:Windows{\n fn destroy_locale(&mut self,_reference:u32,_m:&mut BTreeMap<u32,Memory>,_dead:&mut BTreeSet<u32>)->Result<(),Error>{Err(Error::Backend("original custom locale destructor required"))}\n}';assert old in s;s=s.replace(old,'pub trait Services:Windows{}').replace('s.destroy_locale(locale,m,d)?;','crate::audio_crt_custom_locale_destructor::destroy(m,d,locale,s)?;');p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/lib.rs';s=p.read_text(encoding='utf-8');assert 'pub mod audio_crt_custom_locale_destructor;'not in s;p.write_text(s+'\npub mod audio_crt_custom_locale_destructor;\n',encoding='utf-8')
(r/'tools/implement_audio_crt_custom_locale_destructor.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('Implemented actual custom locale destructor and linked thread-destructor branch;96 native comparisons; helper orders', {k:len(v)for k,v in orders.items()})
