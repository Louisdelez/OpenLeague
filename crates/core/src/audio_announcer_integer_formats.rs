//! Integer format text and the normal fixed64-byte %ld/%lx primitive used by color num_put.
//! General printf, alternate locale/grouping, truncation and C++ writer state are separate contracts.
pub fn format_specifier(flags:u32,descriptor:[u8;2])->Vec<u8> {
 let mut bytes=vec![b'%'];if flags&0x20!=0 {bytes.push(b'+');}if flags&8!=0 {bytes.push(b'#');}
 if descriptor[0]==b'L' {bytes.extend_from_slice(b"I64");} else {bytes.push(descriptor[0]);}
 bytes.push(match flags&0xe00 {0x400=>b'o',0x800=>if flags&4!=0 {b'X'} else {b'x'},_=>descriptor[1]});bytes
}
#[derive(Clone,Copy)] pub enum LongForm {Decimal,Hex}
pub fn write_long_integer(form:LongForm,value:u32,buffer:&mut [u8;64])->i32 {
 let text=match form {LongForm::Decimal=>(value as i32).to_string(),LongForm::Hex=>format!("{value:x}")};let bytes=text.as_bytes();buffer[..bytes.len()].copy_from_slice(bytes);buffer[bytes.len()]=0;bytes.len() as i32
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn audio_integer_format_selection_matches1024_original_flags_and_length_modifier_cases() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_integer_format_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),1024);
  for c in cases {let descriptor=c["type_text"].as_str().unwrap().as_bytes();assert_eq!(format_specifier(c["flags"].as_u64().unwrap() as u32,[descriptor[0],descriptor[1]]),c["format"].as_str().unwrap().as_bytes());}
 }
 #[test] fn audio_normal_integer_primitive_matches1036_actual_native_crt_fresh_cached_tls_frames() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_native_integer_printf_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),1036);
  for c in cases {let form=match c["format"].as_str().unwrap() {"%ld"=>LongForm::Decimal,"%lx"=>LongForm::Hex,_=>panic!("native long format")};let mut buffer=[0xcc;64];let result=write_long_integer(form,c["value"].as_u64().unwrap() as u32,&mut buffer);assert_eq!(result,c["result"].as_i64().unwrap() as i32);assert_eq!(buffer.iter().map(|x|format!("{x:02x}")).collect::<String>(),c["buffer_hex"].as_str().unwrap());}
 }
}

/// Formats independently qualified in the actual composed C++/CRT fixture.
pub fn format_long(flags:u32,value:u32)->Result<Vec<u8>,String> {
 let spec=format_specifier(flags,*b"ld");
 let text=match spec.as_slice() {
  b"%ld"=>(value as i32).to_string(),
  b"%lx"=>format!("{value:x}"),
  b"%+ld"=>format!("{:+}",value as i32),
  b"%#lX"=>if value==0 {"0".to_string()} else {format!("0X{value:X}")},
  _=>return Err("long integer format requires additional native qualification".into()),
 };Ok(text.into_bytes())
}
