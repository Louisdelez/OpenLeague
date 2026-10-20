
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

#[cfg(target_arch="x86_64")]
pub(crate) fn loaded(bits:u32)->Result<u32,Error>{
 let mut result=0u32;let mut control=[0x037f0000u32,0,0];
 unsafe{std::arch::asm!("fnstcw word ptr [{control}]","fldcw word ptr [{control} + 2]","fld dword ptr [{bits}]","fstp dword ptr [{result}]","fldcw word ptr [{control}]",control=in(reg)control.as_mut_ptr(),bits=in(reg)&bits,result=in(reg)&mut result,out("st(0)")_,options(nostack));}Ok(result)
}
#[cfg(not(target_arch="x86_64"))]pub(crate) fn loaded(_:u32)->Result<u32,Error>{Err(Error::Backend("native RTPC input x87 conversion unavailable"))}

/// Returned bytes retain the final extended result; intermediate accumulation stores f32.
pub fn evaluate(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,source:u32,parameter:u32,owner:u32,c:Context,s:&mut impl Services)->Result<[u8;10],Error>{
 s.observe_rtpc_manager(c.manager,source,parameter,owner,m);let mut binding=get(m,d,c.manager.wrapping_add(0x614).wrapping_add((source.wrapping_add(parameter)%193)*4),4)?;let mut seen=BTreeSet::new();
 while binding!=0{if !seen.insert(binding){return Err(Error::CyclicList);}if get(m,d,binding,4)?==source&&get(m,d,binding.wrapping_add(4),4)?==parameter{break;}binding=get(m,d,binding.wrapping_add(8),4)?;}
 if binding==0{return scale(0,0,&mut[0;2]);}let table=get(m,d,binding.wrapping_add(20),4)?;let count=get(m,d,binding.wrapping_add(24),4)?;let mut accumulator=0;let mut retained=scale(0,0,&mut[0;2])?;let mut seen=BTreeSet::new();
 for i in 0..count{let entry=table.wrapping_add(i.wrapping_mul(20));if !seen.insert(entry){return Err(Error::CyclicList);}let input=loaded(value(m,d,c.manager,get(m,d,entry.wrapping_add(4),4)?,owner)?)?;let at=entry.wrapping_add(8);s.observe_rtpc_curve(at,input,m);let result=curve(m,d,at,input,c.conversion_cache)?;(retained,accumulator)=add(&result,accumulator);}Ok(retained)
}
/// Actual flags/type gate, parameter9 and towards-zero FISTP low16, no f32 return boundary.
pub fn select(m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,source:u32,owner:u32,c:Context,s:&mut impl Services)->Result<u16,Error>{
 let ty=get(m,d,source.wrapping_add(44),2)?;if get(m,d,source.wrapping_add(48),4)?&0x200==0||ty==0{return Ok(ty as u16);}Ok(low16(&evaluate(m,d,source,9,owner,c,s)?))
}

#[cfg(target_arch="x86_64")]
fn scale(bits:u32,scaling:u32,cache:&mut[u32;2])->Result<[u8;10],Error>{
 let mut args=[bits,0,0,0,0,0];let constants=[0x3caa70deu32,0x3ea67f46u32,0x3ede5bd9u32,0x3f272ddbu32,0x3f317218u32,0x4e7e0000u32,0xbede5bd9u32,0xc2140000u32,0x3d4ccccdu32,0x3eaaaaabu32,0x3f800000u32,0x41a00000u32,0x42fe0000u32,0xbf800000u32];let mut control=[0x037f0000u32,0,0x1f80];let mut result=[0u8;10];
 unsafe{std::arch::asm!("fnstcw word ptr [{control}]",
 "fldcw word ptr [{control} + 2]",
 "stmxcsr dword ptr [{control} + 4]",
 "ldmxcsr dword ptr [{control} + 8]",
 "movss xmm3, dword ptr [{args}]",
 "500:",
 "sub eax, 2",
 "501:",
 "je 572f",
 "502:",
 "dec eax",
 "503:",
 "je 551f",
 "504:",
 "dec eax",
 "505:",
 "jne 654f",
 "506:",
 "mulss xmm3, dword ptr [{constants} + 32]",
 "507:",
 "movss xmm0, dword ptr [{constants} + 28]",
 "508:",
 "comiss xmm0, xmm3",
 "509:",
 "movss dword ptr [{args} + 4], xmm3",
 "510:",
 "jbe 517f",
 "511:",
 "xorps xmm1, xmm1",
 "512:",
 "movss dword ptr [{args}], xmm1",
 "513:",
 "fld dword ptr [{args}]",
 "514:",
 "515:",
 "516:",
 "jmp 900f",
 "517:",
 "mov eax, dword ptr [{cache} + 4]",
 "518:",
 "test al, 1",
 "519:",
 "jne 523f",
 "520:",
 "or eax, 1",
 "521:",
 "mov dword ptr [{cache}], 0x4bd49a78",
 "522:",
 "mov dword ptr [{cache} + 4], eax",
 "523:",
 "fld dword ptr [{args} + 4]",
 "524:",
 "fmul dword ptr [{cache}]",
 "525:",
 "fnstcw word ptr [{args} + 6]",
 "526:",
 "movzx eax, word ptr [{args} + 6]",
 "527:",
 "or eax, 0xc00",
 "528:",
 "mov dword ptr [{args} + 8], eax",
 "529:",
 "fadd dword ptr [{constants} + 20]",
 "530:",
 "fldcw word ptr [{args} + 8]",
 "531:",
 "fistp qword ptr [{args} + 12]",
 "532:",
 "mov eax, dword ptr [{args} + 12]",
 "533:",
 "fldcw word ptr [{args} + 6]",
 "534:",
 "mov ecx, eax",
 "535:",
 "and eax, 0x7fffff",
 "536:",
 "and ecx, 0xff800000",
 "537:",
 "add eax, 0x3f800000",
 "538:",
 "mov dword ptr [{args} + 4], eax",
 "539:",
 "movss xmm1, dword ptr [{args} + 4]",
 "540:",
 "mulss xmm1, dword ptr [{constants} + 4]",
 "541:",
 "mov dword ptr [{args} + 8], ecx",
 "542:",
 "addss xmm1, dword ptr [{constants} + 0]",
 "543:",
 "mulss xmm1, dword ptr [{args} + 4]",
 "544:",
 "addss xmm1, dword ptr [{constants} + 12]",
 "545:",
 "mulss xmm1, dword ptr [{args} + 8]",
 "546:",
 "movss dword ptr [{args}], xmm1",
 "547:",
 "fld dword ptr [{args}]",
 "548:",
 "549:",
 "550:",
 "jmp 900f",
 "551:",
 "movss xmm0, dword ptr [{constants} + 28]",
 "552:",
 "comiss xmm0, xmm3",
 "553:",
 "ja 511b",
 "554:",
 "mov eax, dword ptr [{cache} + 4]",
 "555:",
 "test al, 1",
 "556:",
 "jne 560f",
 "557:",
 "or eax, 1",
 "558:",
 "mov dword ptr [{cache}], 0x4bd49a78",
 "559:",
 "mov dword ptr [{cache} + 4], eax",
 "560:",
 "fld dword ptr [{cache}]",
 "561:",
 "fmul dword ptr [{args}]",
 "562:",
 "fnstcw word ptr [{args} + 6]",
 "563:",
 "movzx eax, word ptr [{args} + 6]",
 "564:",
 "or eax, 0xc00",
 "565:",
 "mov dword ptr [{args} + 8], eax",
 "566:",
 "fadd dword ptr [{constants} + 20]",
 "567:",
 "fldcw word ptr [{args} + 8]",
 "568:",
 "fistp qword ptr [{args} + 12]",
 "569:",
 "mov eax, dword ptr [{args} + 12]",
 "570:",
 "fldcw word ptr [{args} + 6]",
 "571:",
 "jmp 534b",
 "572:",
 "xorps xmm0, xmm0",
 "573:",
 "comiss xmm0, xmm3",
 "574:",
 "jbe 616f",
 "575:",
 "comiss xmm3, dword ptr [{constants} + 52]",
 "576:",
 "jbe 611f",
 "577:",
 "addss xmm3, dword ptr [{constants} + 40]",
 "578:",
 "movss dword ptr [{args} + 4], xmm3",
 "579:",
 "mov eax, dword ptr [{args} + 4]",
 "580:",
 "and eax, 0x7fffff",
 "581:",
 "movss dword ptr [{args} + 4], xmm3",
 "582:",
 "add eax, 0x3f800000",
 "583:",
 "mov dword ptr [{args}], eax",
 "584:",
 "fld dword ptr [{args}]",
 "585:",
 "fld st(0)",
 "586:",
 "mov eax, dword ptr [{args} + 4]",
 "587:",
 "fld1",
 "588:",
 "fsub st(1), st(0)",
 "589:",
 "shr eax, 0x17",
 "590:",
 "fadd st(2), st(0)",
 "591:",
 "and eax, 0xff",
 "592:",
 "fxch st(1)",
 "593:",
 "mov dword ptr [{args} + 4], eax",
 "594:",
 "fdivrp st(2)",
 "595:",
 "fld st(1)",
 "596:",
 "fmul st(2)",
 "597:",
 "fmul dword ptr [{constants} + 36]",
 "598:",
 "faddp st(1)",
 "599:",
 "fxch st(1)",
 "600:",
 "fadd st(0), st(0)",
 "601:",
 "fmulp st(1)",
 "602:",
 "fild dword ptr [{args} + 4]",
 "603:",
 "fsub dword ptr [{constants} + 48]",
 "604:",
 "fmul dword ptr [{constants} + 16]",
 "605:",
 "faddp st(1)",
 "606:",
 "fmul dword ptr [{constants} + 8]",
 "607:",
 "fmul dword ptr [{constants} + 44]",
 "608:",
 "609:",
 "610:",
 "jmp 900f",
 "611:",
 "mov dword ptr [{args}], 0xc5800000",
 "612:",
 "fld dword ptr [{args}]",
 "613:",
 "614:",
 "615:",
 "jmp 900f",
 "616:",
 "movss xmm0, dword ptr [{constants} + 40]",
 "617:",
 "comiss xmm0, xmm3",
 "618:",
 "jbe 653f",
 "619:",
 "subss xmm0, xmm3",
 "620:",
 "movss dword ptr [{args} + 4], xmm0",
 "621:",
 "mov eax, dword ptr [{args} + 4]",
 "622:",
 "and eax, 0x7fffff",
 "623:",
 "movss dword ptr [{args} + 4], xmm0",
 "624:",
 "add eax, 0x3f800000",
 "625:",
 "mov dword ptr [{args}], eax",
 "626:",
 "fld dword ptr [{args}]",
 "627:",
 "fld st(0)",
 "628:",
 "mov eax, dword ptr [{args} + 4]",
 "629:",
 "fld1",
 "630:",
 "fsub st(1), st(0)",
 "631:",
 "shr eax, 0x17",
 "632:",
 "fadd st(2), st(0)",
 "633:",
 "and eax, 0xff",
 "634:",
 "fxch st(1)",
 "635:",
 "mov dword ptr [{args} + 4], eax",
 "636:",
 "fdivrp st(2)",
 "637:",
 "fld st(1)",
 "638:",
 "fmul st(2)",
 "639:",
 "fmul dword ptr [{constants} + 36]",
 "640:",
 "faddp st(1)",
 "641:",
 "fxch st(1)",
 "642:",
 "fadd st(0), st(0)",
 "643:",
 "fmulp st(1)",
 "644:",
 "fild dword ptr [{args} + 4]",
 "645:",
 "fsub dword ptr [{constants} + 48]",
 "646:",
 "fmul dword ptr [{constants} + 16]",
 "647:",
 "faddp st(1)",
 "648:",
 "fmul dword ptr [{constants} + 24]",
 "649:",
 "fmul dword ptr [{constants} + 44]",
 "650:",
 "651:",
 "652:",
 "jmp 900f",
 "653:",
 "mov dword ptr [{args}], 0x45800000",
 "654:",
 "fld dword ptr [{args}]",
 "655:",
 "656:",
 "900:",
 "fstp tbyte ptr [{result}]",
 "ldmxcsr dword ptr [{control} + 4]",
 "fldcw word ptr [{control}]",args=in(reg)args.as_mut_ptr(),constants=in(reg)constants.as_ptr(),control=in(reg)control.as_mut_ptr(),cache=in(reg)cache.as_mut_ptr(),result=in(reg)result.as_mut_ptr(),inout("eax")scaling=>_,out("ecx")_,out("xmm0")_,out("xmm1")_,out("xmm3")_,out("st(0)")_,out("st(1)")_,out("st(2)")_,options(nostack));}Ok(result)
}
#[cfg(not(target_arch="x86_64"))]fn scale(_:u32,_:u32,_:&mut[u32;2])->Result<[u8;10],Error>{Err(Error::Backend("native RTPC x87 scaling unavailable"))}

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

#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn hex(b:&[u8])->String{b.iter().map(|v|format!("{v:02x}")).collect()}
 struct Backend{calls:Vec<Value>,regions:Vec<(String,u32,usize)>,failure:bool}
 impl Backend{fn snapshot(&self,m:&BTreeMap<u32,Memory>)->Value{let mut out=json!({});for(n,r,z)in &self.regions{out[n]=json!(hex(&(0..*z).map(|i|crate::audio_path_memory::read(m,r+i as u32,1).unwrap()[0]).collect::<Vec<_>>()));}out}}
 impl Services for Backend{
 fn observe_rtpc_manager(&mut self,r:u32,source:u32,parameter:u32,owner:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"rtpc_manager","receiver":r,"arguments":[source,parameter,owner],"at_call":self.snapshot(m)}));}
 fn observe_rtpc_curve(&mut self,r:u32,input:u32,m:&BTreeMap<u32,Memory>){self.calls.push(json!({"kind":"curve","receiver":r,"input_bits":input,"at_call":self.snapshot(m)}));}
 }

 impl crate::audio_path_voice_empty_source_release::Services for Backend{fn free(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>)->Result<(),Error>{Err(Error::Backend("acquire does not retire owners in this matrix"))}}
 impl crate::audio_path_source_input_acquisition::Services for Backend{
 fn allocate_input(&mut self,p:u32,size:u32,m:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{assert_eq!(size,60);let result=if self.failure{0}else{0x4000b000};self.calls.push(json!({"kind":"allocate","pool":p,"size":size,"result":result,"at_call":self.snapshot(m)}));Ok((result!=0).then_some(result))}
 fn dynamic_owner_type(&mut self,_:u32,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u16,Error>{Err(Error::Backend("actual dynamic selector must bypass controlled ABI return"))}
 fn parent_virtual98(&mut self,_:u32,_:u32,_:&mut BTreeMap<u32,Memory>,_:&mut BTreeSet<u32>)->Result<u32,Error>{Err(Error::Backend("no parents in this full dynamic acquisition matrix"))}
 }
 #[test]fn audio_dynamic_input_owner_selector_matches240_original_static_gate_collision_missing_binding_constant_curves_retained_x87_near_integer_nan_inf_overflow_low16_and_complete_physical_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_dynamic_input_owner_selector_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],240);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m:BTreeMap<u32,Memory>=regions.iter().map(|(n,r,_)|(*r,Memory{reference:*r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let d=BTreeSet::new();let mut s=Backend{calls:vec![],regions,failure:false};let actual=select(&mut m,&d,0x40001000,0,Context{manager:0x40003000,conversion_cache:0x14a7970},&mut s).unwrap();assert_eq!(actual as u64,row["result"].as_u64().unwrap(),"native low16 {i}");assert_eq!(json!(s.calls),row["calls"],"all native RTPC/curve snapshots {i}");assert_eq!(s.snapshot(&m),row["after"],"complete source/RTPC/binding/curve/point bank {i}");}
 }
 #[test]fn audio_dynamic_input_owner_selector_matches792_original_all9_interpolation_step_default_scaling_zero_db_exponential_cache_initialization_rtpc_defaults_retained_x87_and_complete_physical_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_dynamic_input_owner_selector_curves_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],792);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m:BTreeMap<u32,Memory>=regions.iter().map(|(n,r,_)|(*r,Memory{reference:*r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let d=BTreeSet::new();let mut s=Backend{calls:vec![],regions,failure:false};let actual=select(&mut m,&d,0x40001000,0,Context{manager:0x40003000,conversion_cache:0x14a7970},&mut s).unwrap();assert_eq!(actual as u64,row["result"].as_u64().unwrap(),"native low16 {i}");assert_eq!(json!(s.calls),row["calls"],"all native RTPC/curve snapshots {i}");assert_eq!(s.snapshot(&m),row["after"],"complete source/RTPC/binding/curve/point bank {i}");}
 } #[test]fn audio_dynamic_input_owner_acquisition_matches960_original_real_rtpc_type_constructor60_counter_wrap_existing_skip_oom_flags_and_complete_physical_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_dynamic_input_owner_acquisition_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],960);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m:BTreeMap<u32,Memory>=regions.iter().map(|(n,r,_)|(*r,Memory{reference:*r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let mut d=BTreeSet::new();let mut s=Backend{calls:vec![],regions,failure:row["allocation_failure"].as_bool().unwrap()};s.calls.push(json!({"kind":"input_virtual98","receiver":0x40001000u32,"selector":3,"at_call":s.snapshot(&m)}));let actual=acquire_native_rtpc(&mut m,&mut d,0x40001000,3,19,Context{manager:0x40003000,conversion_cache:0x14a7970},&mut s).unwrap();assert_eq!(actual as u64,row["result"].as_u64().unwrap(),"native low16 {i}");assert_eq!(json!(s.calls),row["calls"],"all native RTPC/curve snapshots {i}");assert_eq!(s.snapshot(&m),row["after"],"complete source/RTPC/binding/curve/point bank {i}");}
 }
 #[test]fn audio_dynamic_input_owner_selector_matches126_original_owner_global_default_collision_duplicate_keys_signaling_nan_hardware_qualified_x87_arguments_and_complete_physical_cases(){
 let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_dynamic_input_owner_selector_overrides_fp_qualified_preparation.json")).unwrap();assert_eq!(p["passed"],true);assert_eq!(p["case_count"],126);
 for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){let regions=p["regions"].as_array().unwrap().iter().map(|v|(v["name"].as_str().unwrap().to_owned(),v["reference"].as_u64().unwrap()as u32,v["size"].as_u64().unwrap()as usize)).collect::<Vec<_>>();let mut m:BTreeMap<u32,Memory>=regions.iter().map(|(n,r,_)|(*r,Memory{reference:*r,raw:bytes(row["before"][n].as_str().unwrap())})).collect();let d=BTreeSet::new();let mut s=Backend{calls:vec![],regions,failure:false};let actual=select(&mut m,&d,0x40001000,row["owner"].as_u64().unwrap()as u32,Context{manager:0x40003000,conversion_cache:0x14a7970},&mut s).unwrap();assert_eq!(actual as u64,row["result"].as_u64().unwrap(),"native low16 {i}");assert_eq!(json!(s.calls),row["calls"],"all native RTPC/curve snapshots {i}");assert_eq!(s.snapshot(&m),row["after"],"complete source/RTPC/binding/curve/point bank {i}");}
 }

}

struct NativeRtpc<'a,S>{backend:&'a mut S,context:Context}
impl<S:crate::audio_path_source_input_acquisition::Services>crate::audio_path_voice_empty_source_release::Services for NativeRtpc<'_,S>{
 fn free(&mut self,p:u32,r:u32,m:&mut BTreeMap<u32,Memory>)->Result<(),Error>{crate::audio_path_voice_empty_source_release::Services::free(self.backend,p,r,m)}
}
impl<S:crate::audio_path_source_input_acquisition::Services+Services>crate::audio_path_source_input_acquisition::Services for NativeRtpc<'_,S>{
 fn allocate_input(&mut self,p:u32,size:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<Option<u32>,Error>{self.backend.allocate_input(p,size,m,d)}
 fn dynamic_owner_type(&mut self,source:u32,parameter:u32,owner:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u16,Error>{if parameter!=9{return Err(Error::Backend("source selector parameter must be9"));}select(m,d,source,owner,self.context,self.backend)}
 fn parent_virtual98(&mut self,r:u32,selector:u32,m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>)->Result<u32,Error>{self.backend.parent_virtual98(r,selector,m,d)}
 fn observe_parent_input98(&mut self,r:u32,selector:u32,m:&BTreeMap<u32,Memory>){self.backend.observe_parent_input98(r,selector,m)}
}
/// Source98/owner60 construction with real canonical RTPC dynamic type producer.
/// Allocator, parent observers and notification boundary services remain caller-owned.
pub fn acquire_native_rtpc<S:crate::audio_path_source_input_acquisition::Services+Services>(m:&mut BTreeMap<u32,Memory>,d:&mut BTreeSet<u32>,source:u32,selector:u32,pool:u32,c:Context,s:&mut S)->Result<u8,Error>{
 crate::audio_path_source_input_acquisition::acquire_recursive(m,d,source,selector,pool,&mut NativeRtpc{backend:s,context:c})
}

/// Selected ADECF0/B11850 single parameter4, scaling2 curve accumulation.
/// OLD/default lookup remains separate. No owner value or default is inserted.
pub(crate) fn evaluate_first_global_curve(
 m:&mut BTreeMap<u32,Memory>,d:&BTreeSet<u32>,curve_address:u32,
 input:u32,parameter:u32,cache_address:u32,
)->Result<([u8;10],u32),Error>{
 if parameter!=4||get(m,d,curve_address.wrapping_add(4),4)?!=2||get(m,d,curve_address.wrapping_add(8),4)?!=2||!f32::from_bits(input).is_finite(){
  return Err(Error::Backend("first-global finite parameter4/two-point scaling2 curve required"));
 }
 let result=curve(m,d,curve_address,loaded(input)?,cache_address)?;
 // Original B11850 initializes its selected curve accumulator to +0 before
 // adding the retained result; this also preserves its native zero sign.
 Ok(add(&result,0))
}
