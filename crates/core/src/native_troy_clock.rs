//! Native928360 clock wrapper, converted to f32 at caller storage.
//! Underlying time producer and scale transitions are separate requirements.
#[derive(Debug,Copy,Clone)]
pub struct Clock {pub origin:f64,pub scale:f64,pub offset:f64}
impl Clock {
 /// Native9283C0: the source is observed once for the old sample and again
 /// for the new origin. Supplying both observations preserves that ordering.
 pub fn set_scale(&mut self,source:Option<[f64;2]>,scale:f64)->Result<(),&'static str>{
  if !scale.is_finite() || !self.offset.is_finite() || source.is_some_and(|v|v.iter().any(|x|!x.is_finite()) || !self.origin.is_finite() || !self.scale.is_finite()) {
   return Err("nonfinite clock scale transition is unqualified");
  }
  #[cfg(any(target_arch="x86",target_arch="x86_64"))]
  {
   let offset=if let Some([first,_])=source {
    let values=[first,self.origin,self.scale,self.offset];let control=0x037fu16;let mut saved=0u16;let mut result=0f64;
    // Native setter stores the extended wrapper result directly to qword28.
    unsafe {core::arch::asm!(
     "fnstcw word ptr [{saved}]","fldcw word ptr [{control}]",
     "fld qword ptr [{input}]","fsub qword ptr [{input}+8]","fmul qword ptr [{input}+16]","fadd qword ptr [{input}+24]",
     "fstp qword ptr [{output}]","fldcw word ptr [{saved}]",
     saved=in(reg)&mut saved,control=in(reg)&control,input=in(reg)values.as_ptr(),output=in(reg)&mut result,out("st(0)") _,options(nostack));}
    result
   }else{self.offset};
   if !offset.is_finite(){return Err("clock scale transition overflow is unqualified");}
   self.origin=source.map_or(offset,|v|v[1]);self.offset=offset;self.scale=scale;Ok(())
  }
  #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
  {Err("native x87 clock scale transition is unqualified on this architecture")}
 }
 pub fn sample(self,source:Option<f64>)->Result<f32,&'static str>{
  if !self.offset.is_finite() || source.is_some_and(|v|!v.is_finite() || !self.origin.is_finite() || !self.scale.is_finite()){return Err("nonfinite effect clock input is unqualified");}
  #[cfg(any(target_arch="x86",target_arch="x86_64"))]
  {
   let values=[source.unwrap_or(0.),self.origin,self.scale,self.offset];let control=0x037fu16;let mut saved=0u16;let mut result=0f32;
   // Original x87 arithmetic retains extended intermediates until the f32 store.
   // Preserve the caller control word; neither branch changes x87 stack depth.
   unsafe {
    if source.is_some(){core::arch::asm!(
     "fnstcw word ptr [{saved}]","fldcw word ptr [{control}]",
     "fld qword ptr [{input}]","fsub qword ptr [{input}+8]","fmul qword ptr [{input}+16]","fadd qword ptr [{input}+24]",
     "fstp dword ptr [{output}]","fldcw word ptr [{saved}]",
     saved=in(reg)&mut saved,control=in(reg)&control,input=in(reg)values.as_ptr(),output=in(reg)&mut result,out("st(0)") _,options(nostack));
    }else{core::arch::asm!(
     "fnstcw word ptr [{saved}]","fldcw word ptr [{control}]","fld qword ptr [{input}+24]","fstp dword ptr [{output}]","fldcw word ptr [{saved}]",
     saved=in(reg)&mut saved,control=in(reg)&control,input=in(reg)values.as_ptr(),output=in(reg)&mut result,out("st(0)") _,options(nostack));}
   }
   if result.is_finite(){Ok(result)}else{Err("effect clock result overflow is unqualified")}
  }
  #[cfg(not(any(target_arch="x86",target_arch="x86_64")))]
  {Err("native x87 effect clock is unqualified on this architecture")}
 }
}
#[cfg(test)]
mod tests {
 use super::*;
 fn double(v:&serde_json::Value)->f64{let s=v.as_str().unwrap();let b=std::array::from_fn(|i|u8::from_str_radix(&s[i*2..i*2+2],16).unwrap());f64::from_le_bytes(b)}
 #[test]
 fn scale_transitions_match512_original_mutator_cases(){
  let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/clock_scale_transition_contract.json")).unwrap();
  let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),512);
  for (n,c) in cases.iter().enumerate(){
   let b=&c["before"];let mut clock=Clock{origin:b["origin"].as_f64().unwrap(),scale:b["scale"].as_f64().unwrap(),offset:b["offset"].as_f64().unwrap()};
   let reads=c["source_reads"].as_array().unwrap();let source=(!reads.is_empty()).then(||[reads[0].as_f64().unwrap(),reads[1].as_f64().unwrap()]);
   clock.set_scale(source,c["new_scale"].as_f64().unwrap()).unwrap();
   for (key,actual) in [("origin",clock.origin),("scale",clock.scale),("offset",clock.offset)] {assert_eq!(actual.to_bits(),double(&c["after_words"][key]).to_bits(),"case{n} {key}");}
  }
 }
 #[test]
 fn matches760_original_clock_and_cpu_x87_cases(){
 let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/troy_clock_contract.json")).unwrap();let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),760);assert_eq!(p["control_word"],"0x037f");
 for(n,c) in cases.iter().enumerate(){let clock=Clock{origin:double(&c["origin_words"]),scale:double(&c["scale_words"]),offset:double(&c["offset_words"])};let source=if c["source_words"].is_null(){None}else{Some(double(&c["source_words"]))};
 assert_eq!(clock.sample(source).unwrap().to_bits(),c["cpu_words"].as_u64().unwrap() as u32,"case{n}");
 }
 }
}
