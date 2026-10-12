from pathlib import Path
r=Path('E:/OpenLeague')
s='''//! Native928360 clock wrapper, converted to f32 at caller storage.
//! Underlying time producer and scale transitions are separate requirements.
#[derive(Debug,Copy,Clone)]
pub struct Clock {pub origin:f64,pub scale:f64,pub offset:f64}
impl Clock {
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
 fn matches760_original_clock_and_cpu_x87_cases(){
 let p:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/troy_clock_contract.json")).unwrap();let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),760);assert_eq!(p["control_word"],"0x037f");
 for(n,c) in cases.iter().enumerate(){let clock=Clock{origin:double(&c["origin_words"]),scale:double(&c["scale_words"]),offset:double(&c["offset_words"])};let source=if c["source_words"].is_null(){None}else{Some(double(&c["source_words"]))};
 assert_eq!(clock.sample(source).unwrap().to_bits(),c["cpu_words"].as_u64().unwrap() as u32,"case{n}");
 }
 }
}
'''
(r/'crates/core/src/native_troy_clock.rs').write_text(s,encoding='utf-8')
p=r/'crates/core/src/lib.rs';s=p.read_text(encoding='utf-8');assert 'pub mod native_troy_clock;' not in s;p.write_text(s+'\npub mod native_troy_clock;\n',encoding='utf-8')
