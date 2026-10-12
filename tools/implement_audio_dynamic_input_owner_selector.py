from pathlib import Path
import json,re
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
import capstone
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
ins=list(md.disasm(bytes(u.mem_read(0xadee05,0xadf057-0xadee05)),0xadee05))
addresses=sorted(set(int(a,16)for i in ins for a in re.findall(r'\[0x([0-9a-f]+)\]',i.op_str))-set([0x14a7970,0x14a7974]))
offset={a:j*4 for j,a in enumerate(addresses)}
labels={i.address:j+500 for j,i in enumerate(ins)};finish=900
asm=['fnstcw word ptr [{control}]','fldcw word ptr [{control} + 2]','stmxcsr dword ptr [{control} + 4]','ldmxcsr dword ptr [{control} + 8]','movss xmm3, dword ptr [{args}]']
for i in ins:
 asm.append(str(labels[i.address])+':')
 if i.mnemonic in ['int3','pop']or i.mnemonic=='mov'and i.op_str=='esp, ebp':continue
 if i.mnemonic=='ret':asm.append('jmp 900f');continue
 if i.mnemonic.startswith('j'):
  target=int(i.op_str,16);asm.append(i.mnemonic+' '+str(labels[target])+('f'if target>i.address else'b'));continue
 op=i.op_str
 for old,new in [('[ebp + 8]','[{args}]'),('[ebp + 0xc]','[{args} + 4]'),('[ebp + 0x10]','[{args} + 8]'),('[ebp + 0xe]','[{args} + 6]'),('[ebp - 8]','[{args} + 12]'),('[0x14a7970]','[{cache}]'),('[0x14a7974]','[{cache} + 4]')]:op=op.replace(old,new)
 op=re.sub(r'\[0x([0-9a-f]+)\]',lambda m:'[{constants} + '+str(offset[int(m.group(1),16)])+']',op)
 assert not any(v in op for v in ['ebp','esp','0x14a797']),op
 asm.append(i.mnemonic+(' '+op if op else''))
asm+=['900:','fstp tbyte ptr [{result}]','ldmxcsr dword ptr [{control} + 4]','fldcw word ptr [{control}]']
scale=r'''
#[cfg(target_arch="x86_64")]
fn scale(bits:u32,scaling:u32,cache:&mut[u32;2])->Result<[u8;10],Error>{
 let mut args=[bits,0,0,0,0,0];let constants=[CONSTANTS];let mut control=[0x037f0000u32,0,0x1f80];let mut result=[0u8;10];
 unsafe{std::arch::asm!(ASM,args=in(reg)args.as_mut_ptr(),constants=in(reg)constants.as_ptr(),control=in(reg)control.as_mut_ptr(),cache=in(reg)cache.as_mut_ptr(),result=in(reg)result.as_mut_ptr(),inout("eax")scaling=>_,out("ecx")_,out("xmm0")_,out("xmm1")_,out("xmm3")_,out("st(0)")_,out("st(1)")_,out("st(2)")_,options(nostack));}Ok(result)
}
#[cfg(not(target_arch="x86_64"))]fn scale(_:u32,_:u32,_:&mut[u32;2])->Result<[u8;10],Error>{Err(Error::Backend("native RTPC x87 scaling unavailable"))}
'''.replace('CONSTANTS',','.join(hex(read(a))+'u32'for a in addresses)).replace('ASM',',\n '.join(json.dumps(a)for a in asm))
numeric=r'''
#[cfg(target_arch="x86_64")]
fn interpolate(input:u32,left:u32,right:u32,initial:u32,target:u32,linear:bool)->u32{
 let args=[input,left,right,initial,target];let mut result=0u32;let mut control=[0x037f0000u32,0,0x1f80];
 unsafe{std::arch::asm!("fnstcw word ptr [{control}]","fldcw word ptr [{control} + 2]","stmxcsr dword ptr [{control} + 4]","ldmxcsr dword ptr [{control} + 8]",
 "movss xmm3, dword ptr [{args}]","movss xmm1, dword ptr [{args} + 4]","movss xmm0, dword ptr [{args} + 8]","subss xmm3, xmm1","subss xmm0, xmm1","divss xmm3, xmm0","test {linear:e}, {linear:e}","jz 910f",
 "movss xmm0, dword ptr [{args} + 16]","subss xmm0, dword ptr [{args} + 12]","mulss xmm3, xmm0","addss xmm3, dword ptr [{args} + 12]","910:","movss dword ptr [{result}], xmm3","ldmxcsr dword ptr [{control} + 4]","fldcw word ptr [{control}]",
 args=in(reg)args.as_ptr(),result=in(reg)&mut result,control=in(reg)control.as_mut_ptr(),linear=in(reg)u32::from(linear),out("xmm0")_,out("xmm1")_,out("xmm3")_,options(nostack));}result
}
#[cfg(not(target_arch="x86_64"))]fn interpolate(_:u32,_:u32,_:u32,_:u32,_:u32,_:bool)->u32{unreachable!()}
#[cfg(target_arch="x86_64")]
fn add(value:&[u8;10],accumulator:u32)->([u8;10],u32){
 let mut raw=[0u8;10];let mut rounded=0u32;let mut control=[0x037f0000u32,0,0x1f80];
 unsafe{std::arch::asm!("fnstcw word ptr [{control}]","fldcw word ptr [{control} + 2]","fld tbyte ptr [{value}]","fadd dword ptr [{accumulator}]","fst dword ptr [{rounded}]","fstp tbyte ptr [{raw}]","fldcw word ptr [{control}]",control=in(reg)control.as_mut_ptr(),value=in(reg)value.as_ptr(),accumulator=in(reg)&accumulator,rounded=in(reg)&mut rounded,raw=in(reg)raw.as_mut_ptr(),out("st(0)")_,options(nostack));}(raw,rounded)
}
#[cfg(not(target_arch="x86_64"))]fn add(_:&[u8;10],_:u32)->([u8;10],u32){unreachable!()}
#[cfg(target_arch="x86_64")]
fn low16(value:&[u8;10])->u16{
 let mut output=0i32;let mut control=[0x0f7f0000u32,0,0];
 unsafe{std::arch::asm!("fnstcw word ptr [{control}]","fldcw word ptr [{control} + 2]","fld tbyte ptr [{value}]","fistp dword ptr [{output}]","fldcw word ptr [{control}]",value=in(reg)value.as_ptr(),output=in(reg)&mut output,control=in(reg)control.as_mut_ptr(),out("st(0)")_,options(nostack));}output as u16
}
#[cfg(not(target_arch="x86_64"))]fn low16(_:&[u8;10])->u16{unreachable!()}
'''
body=r'''
//! Canonical AFF3D0/B11040/B110A0/B11320 RTPC source selector.
//! ADECF0 all9 interpolation curves, scaling0/2/3/4 and retained x87 final conversion.
use std::collections::{BTreeMap,BTreeSet};
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
use crate::audio_path_source_virtual_cleanup::{get,put};
#[derive(Clone,Copy)]pub struct Context{pub manager:u32,pub conversion_cache:u32}
pub trait Services{
 fn observe_rtpc_manager(&mut self,_manager:u32,_source:u32,_parameter:u32,_owner:u32,_m:&BTreeMap<u32,Memory>){}
 fn observe_rtpc_curve(&mut self,_curve:u32,_input:u32,_m:&BTreeMap<u32,Memory>){}
}
fn record(m:&BTreeMap<u32,Memory>,d:&BTreeSet<u32>,manager:u32,id:u32)->Result<u32,Error>{
 let mut node=get(m,d,manager.wrapping_add((id%193)*4),4)?;let mut seen=BTreeSet::new();
 while node!=0{if !seen.insert(node){return Err(Error::CyclicList);}if get(m,d,node,4)?==id{return Ok(node);}node=get(m,d,node.wrapping_add(4),4)?;}Ok(0)
}
fn override_value(m:&BTreeMap<u32,Memory>,d:&BTreeSet<u32>,node:u32,owner:u32)->Result<Option<u32>,Error>{
 let table=get(m,d,node.wrapping_add(12),4)?;let count=get(m,d,node.wrapping_add(16),4)?;let mut left=0i64;let mut right=i64::from(count.wrapping_sub(1)as i32);
 while left<=right{let mid=(left+right)/2;let at=table.wrapping_add((mid as u32).wrapping_mul(8));let key=get(m,d,at,4)?;if owner<key{right=mid-1;}else if owner>key{left=mid+1;}else{return Ok(Some(get(m,d,at.wrapping_add(4),4)?));}}Ok(None)
}
fn value(m:&BTreeMap<u32,Memory>,d:&BTreeSet<u32>,manager:u32,id:u32,owner:u32)->Result<u32,Error>{
 let node=record(m,d,manager,id)?;if node==0{return Ok(0);}if let Some(bits)=override_value(m,d,node,owner)?{return Ok(bits);}if owner!=0{if let Some(bits)=override_value(m,d,node,0)?{return Ok(bits);}}get(m,d,node.wrapping_add(8),4)
}
fn curve(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,curve:u32,input:u32,cache_address:u32)->Result<[u8;10],Error>{
 let table=get(m,d,curve,4)?;let count=get(m,d,curve.wrapping_add(4),4)?;let mut raw=input;
 if count==1{raw=get(m,d,table.wrapping_add(4),4)?;}else{let mut index=0;let mut seen=BTreeSet::new();while index<count{
  let at=table.wrapping_add(index.wrapping_mul(12));if !seen.insert(at){return Err(Error::CyclicList);}let left=get(m,d,at,4)?;
  if f32::from_bits(left)>=f32::from_bits(input)||index==count.wrapping_sub(1){raw=get(m,d,at.wrapping_add(4),4)?;break;}
  let right=get(m,d,at.wrapping_add(12),4)?;
  if f32::from_bits(right)>f32::from_bits(input){let initial=get(m,d,at.wrapping_add(4),4)?;let target=get(m,d,at.wrapping_add(16),4)?;let interp=get(m,d,at.wrapping_add(8),4)?;
   raw=if interp==9{initial}else if interp==4{interpolate(input,left,right,initial,target,true)}else{crate::audio_property_owner_progression::curve(interpolate(input,left,right,initial,target,false),initial,target,interp)?};break;
  }index=index.wrapping_add(1);
 }}
 let scaling=get(m,d,curve.wrapping_add(8),4)?;let mut cache=if scaling==3||scaling==4{[get(m,d,cache_address,4)?,get(m,d,cache_address.wrapping_add(4),4)?]}else{[0;2]};
 let result=scale(raw,scaling,&mut cache)?;if scaling==3||scaling==4{put(m,d,cache_address,4,cache[0])?;put(m,d,cache_address.wrapping_add(4),4,cache[1])?;}Ok(result)
}
/// Returned bytes retain the final extended result; intermediate accumulation stores f32.
pub fn evaluate(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,source:u32,parameter:u32,owner:u32,c:Context,s:&mut impl Services)->Result<[u8;10],Error>{
 s.observe_rtpc_manager(c.manager,source,parameter,owner,m);let mut binding=get(m,d,c.manager.wrapping_add(0x614).wrapping_add((source.wrapping_add(parameter)%193)*4),4)?;let mut seen=BTreeSet::new();
 while binding!=0{if !seen.insert(binding){return Err(Error::CyclicList);}if get(m,d,binding,4)?==source&&get(m,d,binding.wrapping_add(4),4)?==parameter{break;}binding=get(m,d,binding.wrapping_add(8),4)?;}
 if binding==0{return scale(0,0,&mut[0;2]);}let table=get(m,d,binding.wrapping_add(20),4)?;let count=get(m,d,binding.wrapping_add(24),4)?;let mut accumulator=0;let mut retained=scale(0,0,&mut[0;2])?;let mut seen=BTreeSet::new();
 for i in 0..count{let entry=table.wrapping_add(i.wrapping_mul(20));if !seen.insert(entry){return Err(Error::CyclicList);}let input=value(m,d,c.manager,get(m,d,entry.wrapping_add(4),4)?,owner)?;let at=entry.wrapping_add(8);s.observe_rtpc_curve(at,input,m);let result=curve(m,d,at,input,c.conversion_cache)?;(retained,accumulator)=add(&result,accumulator);}Ok(retained)
}
/// Actual flags/type gate, parameter9 and towards-zero FISTP low16, no f32 return boundary.
pub fn select(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,source:u32,owner:u32,c:Context,s:&mut impl Services)->Result<u16,Error>{
 let ty=get(m,d,source.wrapping_add(44),2)?;if get(m,d,source.wrapping_add(48),4)?&0x200==0||ty==0{return Ok(ty as u16);}Ok(low16(&evaluate(m,d,source,9,owner,c,s)?))
}
'''
tests=r'''
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{calls:Vec<Value>,regions:Vec<(String,u32,usize)>}
 impl Backend{fn snapshot(&self,m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r,z)in &self.regions{out[n]=json!(hex(&(0..*z).map(|i|crate::audio_path_memory::read(m,r+i as u32,1).unwrap()[0]).collect::<Vec<_>>()));}out}}
 impl Services for Backend{
 fn observe_rtpc_manager(&mut self,r:u32,source:u32,parameter:u32,owner:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"rtpc_manager","receiver":r,"arguments":[source,parameter,owner],"at_call":self.snapshot(m)}));}
 fn observe_rtpc_curve(&mut self,r:u32,input:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"curve","receiver":r,"input_bits":input,"at_call":self.snapshot(m)}));}
 }
 #[test]fn audio_dynamic_input_owner_selector_matches240_original_static_gate_collision_missing_binding_constant_curves_retained_x87_near_integer_nan_inf_overflow_low16_and_complete_physical_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_dynamic_input_owner_selector_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],240);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m:BTreeMap<u32,Memory>=regions.iter().map(|(n,r,_)|(*r,Memory{reference:*r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let d=BTreeSet::new();let mut s=Backend{calls:vec![],regions};let actual=select(&mut m,&d,0x40001000,0,Context{manager:0x40003000,conversion_cache:0x14a7970},&mut s).unwrap();assert_eq!(actual as u64,row["result"].as_u64().unwrap(),"native low16 {i}");assert_eq!(json!(s.calls),row["calls"],"all native RTPC/curve snapshots {i}");assert_eq!(s.snapshot(&m),row["after"],"complete source/RTPC/binding/curve/point bank {i}");}
 }
}
'''
p=r/'crates/core/src/audio_dynamic_input_owner_selector.rs';assert not p.exists();p.write_text(body+scale+numeric+tests,encoding='utf-8')
p=r/'crates/core/src/audio_property_owner_progression.rs';s=p.read_text(encoding='utf-8');s=s.replace('fn curve(', 'pub(crate) fn curve(');p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/lib.rs';s=p.read_text(encoding='utf-8');s+='\npub mod audio_dynamic_input_owner_selector;\n';p.write_text(s,encoding='utf-8')
(r/'data/4.20/audio_dynamic_input_owner_selector_numeric_provenance.json').write_text(json.dumps({'native_sha256':__import__('hashlib').sha256(raw).hexdigest(),'scaling_range':['0xadee05','0xadf057'],'constants':{hex(a):hex(read(a))for a in addresses},'asm':asm,'limits':['PC64 nearest/MXCSR1f80 explicitly used and caller control restored; startup producer remains open. Canonical lookup and full scaling are implementation pending qualification beyond constant240 matrix.']},indent=2)+'\n')
print('Implemented canonical RTPC source selector with retained80-bit result, native scaling and all9 interpolation dispatch')
