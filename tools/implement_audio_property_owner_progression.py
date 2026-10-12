from pathlib import Path
import json,re
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
import capstone
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);md.detail=True
ins=list(md.disasm(bytes(u.mem_read(0xadf587,0xadf7ac-0xadf587)),0xadf587));dispatch=[read(0xadf7ac+i*4)for i in range(9)]
proof=json.loads((r/'data/4.20/audio_property_owner_progression_preparation.json').read_text(encoding='utf-8'));addresses=sorted(int(a,16)for a in proof['constants']);offset={a:i*4 for i,a in enumerate(addresses)}
labels={i.address:j+200 for j,i in enumerate(ins)};endlabel=len(ins)+201
asm=['fnstcw word ptr [{saved}]','fldcw word ptr [{native}]','stmxcsr dword ptr [{saved_mx}]','ldmxcsr dword ptr [{native_mx}]']
for ty,a in enumerate(dispatch):asm+=['cmp {curve:e}, '+str(ty),'je '+str(labels[a])+'f']
asm+=['jmp '+str(labels[0xadf7a3])+'f']
for i in ins:
 asm.append(str(labels[i.address])+':')
 if i.mnemonic=='ret':asm.append('jmp '+str(endlabel)+'f');continue
 if i.mnemonic in['int3','pop']or(i.mnemonic=='mov'and i.op_str=='esp, ebp'):continue
 if i.mnemonic.startswith('j'):
  target=int(i.op_str,16);asm.append(i.mnemonic+' '+str(labels[target])+('f'if target>i.address else'b'));continue
 op=i.op_str
 for original,replacement in [('[ebp + 8]','[{args}]'),('[ebp + 0xc]','[{args} + 4]'),('[ebp + 0x10]','[{args} + 8]'),('[ebp + 0x14]','[{args} + 12]'),('[ebp - 4]','[{args} + 16]')]:op=op.replace(original,replacement)
 def const(m):return '[{constants} + '+str(offset[int(m.group(1),16)])+']'
 op=re.sub(r'\[0x([0-9a-f]+)\]',const,op)
 assert 'ebp'not in op and 'esp'not in op,(i.address,op)
 asm.append(i.mnemonic+(' '+op if op else''))
asm +=[str(endlabel)+':','fstp dword ptr [{result}]','ldmxcsr dword ptr [{saved_mx}]','fldcw word ptr [{saved}]']
constant_code=','.join('f32::from_bits('+proof['constants'][hex(a)]+')'for a in addresses)
curve=r'''#[cfg(any(target_arch="x86",target_arch="x86_64"))]
fn curve(progress:u32,initial:u32,target:u32,curve:u32)->Result<u32,Error>{
 let mut args=[f32::from_bits(progress),f32::from_bits(initial),f32::from_bits(target),0f32,0f32];let constants=[CONSTANTS];let mut result=0f32;let mut saved=0u16;let native=0x037fu16;let mut saved_mx=0u32;let native_mx=0x1f80u32;
 unsafe{std::arch::asm!(ASM,
 saved=in(reg)&mut saved,native=in(reg)&native,saved_mx=in(reg)&mut saved_mx,native_mx=in(reg)&native_mx,args=in(reg)args.as_mut_ptr(),constants=in(reg)constants.as_ptr(),curve=in(reg)curve,result=in(reg)&mut result,
 out("st(0)")_,out("st(1)")_,out("st(2)")_,out("st(3)")_,out("xmm0")_,out("xmm1")_,options(nostack));}Ok(result.to_bits())
}
#[cfg(not(any(target_arch="x86",target_arch="x86_64")))]fn curve(_:u32,_:u32,_:u32,_:u32)->Result<u32,Error>{Err(Error::Backend("native owner x87 curves unavailable"))}
'''.replace('CONSTANTS',constant_code).replace('ASM',',\n '.join(json.dumps(a)for a in asm))
# Preserve exact original inverse-gain x87 operations with decoded original constants.
inverse=r'''#[cfg(any(target_arch="x86",target_arch="x86_64"))]
fn inverse_gain(bits:u32)->Result<u32,Error>{
 let mantissa=f32::from_bits((bits&0x7fffff)+0x3f800000);let exponent=((bits>>23)&255)as i32;let constants=[CONSTANTS];let mut result=0f32;let mut saved=0u16;let native=0x037fu16;
 unsafe{std::arch::asm!(
 "fnstcw word ptr [{saved}]","fldcw word ptr [{native}]",
 "fld dword ptr [{mantissa}]","fld st(0)","fld1","fsub st(1), st(0)","fadd st(2), st(0)","fxch st(1)","fdivrp st(2)","fld st(1)","fmul st(2)","fmul dword ptr [{constants} + OFF1]","faddp st(1)","fxch st(1)","fadd st(0), st(0)","fmulp st(1)","fild dword ptr [{exponent}]","fsub dword ptr [{constants} + OFF2]","fmul dword ptr [{constants} + OFF3]","faddp st(1)","fmul dword ptr [{constants} + OFF4]","fmul dword ptr [{constants} + OFF5]","fstp dword ptr [{result}]","fldcw word ptr [{saved}]",
 saved=in(reg)&mut saved,native=in(reg)&native,mantissa=in(reg)&mantissa,exponent=in(reg)&exponent,constants=in(reg)constants.as_ptr(),result=in(reg)&mut result,out("st(0)")_,out("st(1)")_,out("st(2)")_,options(nostack));}Ok(result.to_bits())
}
#[cfg(not(any(target_arch="x86",target_arch="x86_64")))]fn inverse_gain(_:u32)->Result<u32,Error>{Err(Error::Backend("native inverse gain x87 unavailable"))}
'''.replace('CONSTANTS',constant_code)
for name,a in [('OFF1',0x1138b64),('OFF2',0x11390b0),('OFF3',0xff00ec),('OFF4',0xff00dc),('OFF5',0x1138ff0)]:inverse=inverse.replace(name,str(offset[a]))
ratio=r'''#[cfg(any(target_arch="x86",target_arch="x86_64"))]
fn ratio(numerator:u32,denominator:u32)->Result<u32,Error>{
 let numerator=i64::from(numerator);let denominator=i64::from(denominator);let mut result=0f32;let mut saved=0u16;let native=0x037fu16;
 unsafe{std::arch::asm!("fnstcw word ptr [{saved}]","fldcw word ptr [{native}]","fild qword ptr [{numerator}]","fild qword ptr [{denominator}]","fdivp st(1)","fstp dword ptr [{result}]","fldcw word ptr [{saved}]",saved=in(reg)&mut saved,native=in(reg)&native,numerator=in(reg)&numerator,denominator=in(reg)&denominator,result=in(reg)&mut result,out("st(0)")_,out("st(1)")_,options(nostack));}Ok(result.to_bits())
}
#[cfg(not(any(target_arch="x86",target_arch="x86_64")))]fn ratio(_:u32,_:u32)->Result<u32,Error>{Err(Error::Backend("native progression x87 ratio unavailable"))}
'''
header=r'''//! Original B20EE0 owner time/progression, ADF570 all9 curves and inverse gain.
//! The numeric path uses the original instruction order with explicit PC64 nearest.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put};
pub trait Services{fn action_virtual0(&mut self,action:u32,ty:u32,value_bits:u32,finished:u32,m:&mut BTreeMap<u32,Memory>,dead:&mut BTreeSet<u32>)->Result<(),Error>;}
'''
body=r'''
/// Returns native AL. Unsigned start+duration wraps; finished leaves progress24 untouched.
pub fn update(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,owner:u32,time:u32,s:&mut impl Services)->Result<u8,Error>{
 let duration=get(m,d,owner.wrapping_add(20),4)?;let start=get(m,d,owner.wrapping_add(16),4)?;let finished=time>=start.wrapping_add(duration);
 let mut value=if finished{get(m,d,owner.wrapping_add(8),4)?}else{let progress=if time<=start{0}else{ratio(time.wrapping_sub(start),duration)?};put(m,d,owner.wrapping_add(24),4,progress)?;curve(progress,get(m,d,owner.wrapping_add(4),4)?,get(m,d,owner.wrapping_add(8),4)?,get(m,d,owner.wrapping_add(44),4)?)?};
 let flags=get(m,d,owner.wrapping_add(52),1)?;if flags&1!=0{value=inverse_gain(value)?;}put(m,d,owner.wrapping_add(12),4,value)?;put(m,d,owner.wrapping_add(52),1,flags|2)?;
 let mut cursor=get(m,d,owner.wrapping_add(32),4)?;let mut seen=BTreeSet::new();loop{let table=get(m,d,owner.wrapping_add(32),4)?;let count=get(m,d,owner.wrapping_add(36),4)?;let end=table.wrapping_add(count.wrapping_mul(4));if cursor==end{break;}if !seen.insert(cursor){return Err(Error::CyclicList);}let action=get(m,d,cursor,4)?;let ty=get(m,d,owner,4)?;s.action_virtual0(action,ty,value,u32::from(finished),m,d)?;cursor=cursor.wrapping_add(4);}
 Ok(u8::from(finished))
}
'''
tests=r'''
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 fn snapshot(m:&BTreeMap<u32,Memory>)->Value{json!({"owner":hex(&m[&0x40001000].raw),"bindings":hex(&m[&0x40002000].raw),"actions":hex(&m[&0x40003000].raw)})}
 struct Backend{calls:Vec<Value>}
 impl Services for Backend{fn action_virtual0(&mut self,r:u32,ty:u32,bits:u32,finished:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),Error>{self.calls.push(json!({"kind":"action_virtual0","receiver":r,"arguments":[ty,bits,finished],"at_call":snapshot(m)}));Ok(())}}
 #[test]fn audio_property_owner_progression_matches13728_native_all9_curves_unsigned_time_wrap_exact_x87_inverse_gain_flags_duplicate_bindings_and_complete_physical_memory_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_property_owner_progression_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],13728);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut m:BTreeMap<u32,Memory>=[("owner",0x40001000),("bindings",0x40002000),("actions",0x40003000)].into_iter().map(|(n,r)|(r,Memory{reference:r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut d=BTreeSet::new();let mut s=Backend{calls:vec![]};assert_eq!(update(&mut m,&mut d,0x40001000,row["time"].as_u64().unwrap()as u32,&mut s).unwrap(),row["finished"].as_u64().unwrap()as u8,"native AL {i}");assert_eq!(json!(s.calls),row["calls"],"all propagated values, finish low byte and every physical snapshot {i}");assert_eq!(snapshot(&m),row["after"],"all owner/binding/action bytes {i}");assert!(d.is_empty());}
 }
}
'''
code=header+curve+inverse+ratio+body+tests;(r/'crates/core/src/audio_property_owner_progression.rs').write_text(code,encoding='utf-8')
# Standalone numeric smoke uses production code and all native vectors, without rebuilding the core first.
w=Path('E:/mapslol3v3');stub=r'''mod audio_bus_bank{#[derive(Debug)]pub enum Error{Backend(&'static str),CyclicList,UnresolvedReference}}
mod audio_plugin_factory{pub struct Memory{pub reference:u32,pub raw:Vec<u8>}}
mod audio_path_source_virtual_cleanup{
 use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};use std::collections::{BTreeMap,BTreeSet};
 pub fn get(m:&BTreeMap<u32,Memory>,_:&BTreeSet<u32>,a:u32,z:usize)->Result<u32,Error>{let(k,b)=m.range(..=a).next_back().ok_or(Error::UnresolvedReference)?;let off=(a-k)as usize;let s=b.raw.get(off..off+z).ok_or(Error::UnresolvedReference)?;let mut raw=[0;4];raw[..z].copy_from_slice(s);Ok(u32::from_le_bytes(raw))}
 pub fn put(m:&mut BTreeMap<u32,Memory>,_:&BTreeSet<u32>,a:u32,z:usize,v:u32)->Result<(),Error>{let(k,b)=m.range_mut(..=a).next_back().ok_or(Error::UnresolvedReference)?;let off=(a-*k)as usize;b.raw[off..off+z].copy_from_slice(&v.to_le_bytes()[..z]);Ok(())}
}
mod production{include!("production_owner_progression.inc.rs");}
use std::collections::{BTreeMap,BTreeSet};use audio_plugin_factory::Memory;
struct Backend;impl production::Services for Backend{fn action_virtual0(&mut self,_:u32,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<(),audio_bus_bank::Error>{Ok(())}}
fn main(){let vectors=std::fs::read_to_string("E:/mapslol3v3/owner_progression_numeric.csv").unwrap();let mut failures=0;for(i,line)in vectors.lines().enumerate(){let v:Vec<u32>=line.split(',').map(|s|s.parse().unwrap()).collect();let mut m=BTreeMap::from([(0x1000,Memory{reference:0x1000,raw:vec![0;56]})]);let mut d=BTreeSet::new();for(off,value)in[(4,v[5]),(8,v[6]),(12,0x3f000000),(16,v[0]),(20,v[1]),(24,0x3e800000),(44,v[3])]{audio_path_source_virtual_cleanup::put(&mut m,&d,0x1000+off,4,value).unwrap();}audio_path_source_virtual_cleanup::put(&mut m,&d,0x1000+52,1,v[4]).unwrap();let result=production::update(&mut m,&mut d,0x1000,v[2],&mut Backend).unwrap();let current=audio_path_source_virtual_cleanup::get(&m,&d,0x1000+12,4).unwrap();let progress=audio_path_source_virtual_cleanup::get(&m,&d,0x1000+24,4).unwrap();if(current,progress,result as u32)!=(v[7],v[8],v[9]){failures+=1;if failures<15{println!("mismatch {i}: curve{} flags{} input{:x}/{:x} result{current:x}/{progress:x}/{result} expected{:x}/{:x}/{}",v[3],v[4],v[5],v[6],v[7],v[8],v[9]);}}}println!("native numeric cases {} mismatches {failures}",vectors.lines().count());assert_eq!(failures,0);}
'''
(w/'production_owner_progression.inc.rs').write_text('\n'.join(line for line in (header+curve+inverse+ratio+body).splitlines()if not line.startswith('//!')),encoding='utf-8');(w/'owner_progression_smoke.rs').write_text(stub,encoding='utf-8')
rows=[]
for row in proof['cases']:
 b=bytes.fromhex(row['after']['owner']);rows.append(','.join(str(v)for v in[row['start'],row['duration'],row['time'],row['curve'],row['flags'],row['initial_bits'],row['target_bits'],int.from_bytes(b[12:16],'little'),int.from_bytes(b[24:28],'little'),row['finished']]))
(w/'owner_progression_numeric.csv').write_text('\n'.join(rows)+'\n',encoding='utf-8');print('Wrote actual progression and native x87 instruction curve bodies; numeric smoke vectors',len(rows))


