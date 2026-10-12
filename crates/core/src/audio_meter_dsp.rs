//! Actual Meter Process, detector, history/attack/release and planar tail clear.
//! x87 operations retain the original logarithm/division rounding. No audio device.
use crate::{audio_bus_bank::Error,audio_plugin_factory::Memory};
#[derive(Debug,Clone)]pub struct Buffer{pub raw:[u8;16],pub samples:Vec<u32>}
#[derive(Debug,Clone,PartialEq,Eq)]pub struct Clear{pub offset:usize,pub size:usize}
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
fn float(raw:&[u8],o:usize)->f32{f32::from_bits(word(raw,o))}
fn write(raw:&mut[u8],o:usize,v:f32){raw[o..o+4].copy_from_slice(&v.to_bits().to_le_bytes());}
#[cfg(any(target_arch="x86",target_arch="x86_64"))]
fn log_db(value:f32)->Result<f32,Error>{
 let mut result=0f32;let mut saved=0u16;let native=0x037fu16;let scale=20f32;
 // Both x87 entries are consumed, and caller precision/rounding is restored.
 unsafe{std::arch::asm!("fnstcw word ptr [{saved}]","fldcw word ptr [{native}]",
 "fld dword ptr [{value}]","fldlg2","fxch st(1)","fyl2x","fmul dword ptr [{scale}]",
 "fstp dword ptr [{result}]","fldcw word ptr [{saved}]",
 saved=in(reg)&mut saved,native=in(reg)&native,value=in(reg)&value,scale=in(reg)&scale,result=in(reg)&mut result,
 out("st(0)")_,out("st(1)")_,options(nostack));}Ok(result)
}
#[cfg(not(any(target_arch="x86",target_arch="x86_64")))]fn log_db(_:f32)->Result<f32,Error>{Err(Error::Backend("Meter x87 unavailable"))}
#[cfg(any(target_arch="x86",target_arch="x86_64"))]
fn ratio(frames:u32,rate:u32)->Result<f32,Error>{
 let frames=i64::from(frames);let rate=i64::from(rate);let mut result=0f32;let mut saved=0u16;let native=0x037fu16;
 unsafe{std::arch::asm!("fnstcw word ptr [{saved}]","fldcw word ptr [{native}]","fild qword ptr [{frames}]","fild qword ptr [{rate}]","fdivp st(1)","fstp dword ptr [{result}]","fldcw word ptr [{saved}]",
 saved=in(reg)&mut saved,native=in(reg)&native,frames=in(reg)&frames,rate=in(reg)&rate,result=in(reg)&mut result,out("st(0)")_,out("st(1)")_,options(nostack));}Ok(result)
}
#[cfg(not(any(target_arch="x86",target_arch="x86_64")))]fn ratio(_:u32,_:u32)->Result<f32,Error>{Err(Error::Backend("Meter x87 unavailable"))}
#[cfg(any(target_arch="x86",target_arch="x86_64"))]
fn attack(frames:u32,rate:u32,time:f32,old:f32,target:f32)->Result<f32,Error>{
 let frames=i64::from(frames);let rate=i64::from(rate);let mut result=0f32;let mut saved=0u16;let native=0x037fu16;let scale=10f32;let exceeds:u8;
 unsafe{std::arch::asm!("fnstcw word ptr [{saved}]","fldcw word ptr [{native}]","fild qword ptr [{frames}]","fild qword ptr [{rate}]","fdivp st(1)","fdiv dword ptr [{time}]","fmul dword ptr [{scale}]","fadd dword ptr [{old}]","fst dword ptr [{result}]","fld dword ptr [{target}]","fxch st(1)","fcomip st(0), st(1)","fstp st(0)","fldcw word ptr [{saved}]","seta {exceeds}",
 saved=in(reg)&mut saved,native=in(reg)&native,frames=in(reg)&frames,rate=in(reg)&rate,time=in(reg)&time,scale=in(reg)&scale,old=in(reg)&old,target=in(reg)&target,result=in(reg)&mut result,exceeds=lateout(reg_byte)exceeds,out("st(0)")_,out("st(1)")_,options(nostack));}Ok(if exceeds!=0{target}else{result})
}
#[cfg(not(any(target_arch="x86",target_arch="x86_64")))]fn attack(_:u32,_:u32,_:f32,_:f32,_:f32)->Result<f32,Error>{Err(Error::Backend("Meter x87 unavailable"))}
#[cfg(any(target_arch="x86",target_arch="x86_64"))]
fn sqrt(value:f32)->f32{let result:f32;unsafe{std::arch::asm!("sqrtss {result}, {value}",value=in(xmm_reg)value,result=lateout(xmm_reg)result,options(nostack,pure,nomem));}result}
#[cfg(not(any(target_arch="x86",target_arch="x86_64")))]fn sqrt(value:f32)->f32{value.sqrt()}
fn detector(buffer:&Buffer,param:&[u8])->Result<f32,Error>{
 let channels=word(&buffer.raw,4).count_ones()as usize;let max=u16::from_le_bytes(buffer.raw[12..14].try_into().unwrap())as usize;let valid=u16::from_le_bytes(buffer.raw[14..16].try_into().unwrap())as usize;
 let mut amplitude=0f32;
 if valid!=0{
  if word(param,24)==0{
   let mut lo=2147483648f32;let mut hi=-2147483648f32;
   for channel in 0..channels{let mut min=2147483648f32;let mut max_value=-2147483648f32;
    for &bits in &buffer.samples[channel*max..channel*max+valid]{let v=f32::from_bits(bits);if !(v>min){min=v;}if !(max_value>v){max_value=v;}}
    if !(min>lo){lo=min;}if !(hi>max_value){hi=max_value;}
   }
   let magnitude=f32::from_bits(lo.to_bits()&0x7fffffff);amplitude=if magnitude>hi{magnitude}else{hi};
  }else{
   let mut max_mean=-2147483648f32;
   for channel in 0..channels{let mut sum=0f32;for &bits in &buffer.samples[channel*max..channel*max+valid]{let v=f32::from_bits(bits);let square=v*v;sum+=square;}let mean=sum/valid as f32;if !(max_mean>mean){max_mean=mean;}}
   amplitude=sqrt(max_mean);
  }
 }
 let mut db=log_db(amplitude)?;let floor=float(param,12);let ceiling=float(param,16);if floor>db{db=floor;}if db>ceiling{db=ceiling;}Ok(db)
}
fn smooth(raw:&mut[u8],param:&[u8],frames:u32,mut value:f32)->Result<(),Error>{
 let rate=word(raw,24);let previous=float(raw,36);let floor=float(param,12);
 if value>previous{
  write(raw,28,0.);for o in (40..72).step_by(4){write(raw,o,floor);}
  let time=float(param,4);if time!=0.{value=attack(frames,rate,time,previous,value)?;}
  write(raw,36,value);write(raw,32,value);return Ok(());
 }
 let dt=ratio(frames,rate)?;let mut elapsed=float(raw,28)+dt;write(raw,28,elapsed);let window=float(param,20);
 if elapsed>=window{
  let mut index=8usize;for i in 0..8{let v=float(raw,40+4*i);if v>=value{value=v;index=i;}}
  elapsed=(8-index)as f32*(window*f32::from_bits(0x3de38e39));write(raw,28,elapsed);
  let remaining=if index<8{7-index}else{0};for i in 0..remaining{let v=float(raw,40+4*(index+1+i));write(raw,40+4*i,v);}for i in remaining..8{write(raw,40+4*i,floor);}
  write(raw,32,value);
 }else{
  let position=(elapsed/window)*8.+0.5;
  if !position.is_finite()||position>=2147483648.||position< -2147483648.{return Err(Error::Backend("unqualified Meter history conversion"));}
  let index=(position.trunc()as i32).wrapping_sub(1);
  if index>=0{if index>=8{return Err(Error::Backend("unqualified Meter history index"));}let offset=40+4*index as usize;if value>float(raw,offset){write(raw,offset,value);}}
  if value>float(raw,32){write(raw,32,value);}
 }
 let release=float(param,8);let peak=float(raw,32);
 if release==0.{write(raw,36,peak);}else{let delta=(dt/release)*10.;let descending=float(raw,36)-delta;write(raw,36,if peak>descending{peak}else{descending});}Ok(())
}
pub fn process(effect:&mut Memory,parameter:&Memory,buffer:&mut Buffer)->Result<Vec<Clear>,Error>{
 if effect.raw.len()!=84||parameter.raw.len()!=32{return Err(Error::InvalidAllocation);}
 if word(&effect.raw,0)!=0xff36d4||word(&parameter.raw,0)!=0xff36a4{return Err(Error::Backend("unqualified Meter class"));}
 if word(&effect.raw,8)!=parameter.reference{return Err(Error::UnresolvedReference);}
 let channels=word(&buffer.raw,4).count_ones()as usize;let max=u16::from_le_bytes(buffer.raw[12..14].try_into().unwrap())as usize;let valid=u16::from_le_bytes(buffer.raw[14..16].try_into().unwrap())as usize;
 if valid>max||buffer.samples.len()<channels*max{return Err(Error::Truncated);}
 if word(&effect.raw,24)==0{return Err(Error::Backend("unqualified Meter zero sample rate"));}
 for o in (4..24).step_by(4){if !float(&parameter.raw,o).is_finite(){return Err(Error::Backend("unqualified Meter nonfinite parameter"));}}
 if buffer.samples[..channels*max].iter().any(|&b|!f32::from_bits(b).is_finite()){return Err(Error::Backend("unqualified Meter nonfinite samples"));}
 let db=detector(buffer,&parameter.raw)?;smooth(&mut effect.raw,&parameter.raw,max as u32,db)?;
 let mut clears=vec![];let floor=float(&parameter.raw,12);
 if word(&buffer.raw,8)==17 && floor<float(&effect.raw,36){
  if max!=valid{for channel in 0..channels{let start=channel*max+valid;buffer.samples[start..channel*max+max].fill(0);clears.push(Clear{offset:start*4,size:(max-valid)*4});}buffer.raw[14..16].copy_from_slice(&(max as u16).to_le_bytes());}
  buffer.raw[8..12].copy_from_slice(&45u32.to_le_bytes());
 }
 write(&mut effect.raw,72,floor);effect.raw[76..80].copy_from_slice(&parameter.raw[28..32]);Ok(clears)
}
impl crate::audio_meter_lifecycle::Runtime{
 pub fn process_meter(&mut self,effect:u32,buffer:&mut Buffer)->Result<Vec<Clear>,Error>{
  let object=self.objects.get(&effect).ok_or(Error::UnresolvedReference)?;if object.raw.len()!=84{return Err(Error::InvalidAllocation);}
  let reference=word(&object.raw,8);let parameter=self.objects.get(&reference).ok_or(Error::UnresolvedReference)?.clone();
  process(self.objects.get_mut(&effect).ok_or(Error::UnresolvedReference)?,&parameter,buffer)
 }
}
#[cfg(test)]mod tests{
 use super::*;use serde_json::{Value,json};
 fn bytes(s:&str)->Vec<u8>{(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 fn replay(p:Value)->usize{
  let mut nan=0;
  for(i,row)in p["cases"].as_array().unwrap().iter().enumerate(){
   let mut runtime=crate::audio_meter_lifecycle::Runtime::default();runtime.objects.insert(0x30001000,Memory{reference:0x30001000,raw:bytes(row["effect_before"].as_str().unwrap())});runtime.objects.insert(0x30002000,Memory{reference:0x30002000,raw:bytes(row["parameter"].as_str().unwrap())});
   for(j,step)in row["steps"].as_array().unwrap().iter().enumerate(){
    if let Some(packet)=step["parameter_update"].as_str(){let backing=bytes(packet);crate::audio_plugin_factory::meter_set_block(runtime.objects.get_mut(&0x30002000).unwrap(),&backing,25).unwrap();}
    let parameter=bytes(step["parameter_before"].as_str().unwrap_or(row["parameter"].as_str().unwrap()));assert_eq!(runtime.objects[&0x30002000].raw,parameter,"parameter before {i}/{j}");
    let raw=bytes(step["buffer_before"].as_str().unwrap()).try_into().unwrap();let data=bytes(step["samples_before"].as_str().unwrap());let samples=data.chunks_exact(4).map(|b|u32::from_le_bytes(b.try_into().unwrap())).collect();let mut buffer=Buffer{raw,samples};let clears=runtime.process_meter(0x30001000,&mut buffer).unwrap();
    assert_eq!(buffer.raw.to_vec(),bytes(step["buffer_after"].as_str().unwrap()),"buffer {i}/{j}");let data:Vec<u8>=buffer.samples.iter().flat_map(|b|b.to_le_bytes()).collect();assert_eq!(data,bytes(step["samples_after"].as_str().unwrap()),"samples {i}/{j}");assert_eq!(runtime.objects[&0x30001000].raw,bytes(step["effect_after"].as_str().unwrap()),"effect {i}/{j}");assert_eq!(runtime.objects[&0x30002000].raw,parameter,"parameter after {i}/{j}");assert_eq!(json!(clears.iter().map(|c|json!({"kind":"memset","offset":c.offset,"value":0,"size":c.size})).collect::<Vec<_>>()),step["calls"],"clear order {i}/{j}");nan+=usize::from(word(&runtime.objects[&0x30001000].raw,32)==0xffc00000);
   }
  }nan
 }
 #[cfg(any(target_arch="x86",target_arch="x86_64"))]
 #[test]fn audio_meter_attack_restores_control_word_for_both_comparison_results(){
  let mut before=0u16;unsafe{std::arch::asm!("fnstcw word ptr [{value}]",value=in(reg)&mut before,options(nostack));}
  for(frames,rate,time,old,target)in [(8,48000,0.007,-48.,0.),(256,44100,0.001,-48.,0.),(256,48000,0.05,-60.,-10.)]{
   let _=attack(frames,rate,time,old,target).unwrap();let mut after=0u16;unsafe{std::arch::asm!("fnstcw word ptr [{value}]",value=in(reg)&mut after,options(nostack));}assert_eq!(after,before);
  }
 }
 #[test]fn audio_meter_dsp_matches256_native_cases_and768_retained_steps(){
  let p:Value=serde_json::from_str(include_str!("../../../data/4.20/audio_meter_dsp_contract.json")).unwrap();assert_eq!(p["case_count"],256);assert_eq!(replay(p),72);
 }
 #[test]fn audio_meter_dsp_matches96_native_long_parameter_ramp_and_tail_cases(){
  let p:Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_meter_dsp_extended_contract.json")).unwrap();assert_eq!(p["case_count"],96);assert_eq!(p["cases"].as_array().unwrap().iter().map(|c|c["steps"].as_array().unwrap().len()).sum::<usize>(),4608);assert_eq!(replay(p),0);
 }
}
