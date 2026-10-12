//! Original byte/RGB color stream orchestration. Stream and integer locale semantics remain backend-owned.
/// Format fields written by original5F83C0 under the actual color-helper constructor chain.
pub const INITIAL_FLAGS:u32=0x201;
pub const INITIAL_PRECISION:u32=6;
pub const INITIAL_WIDTH:u32=0;
pub trait Backend {
 type Stream:Copy;
 fn create_stream(&mut self)->Result<Self::Stream,&'static str>;
 fn flags(&mut self,s:Self::Stream)->Result<u32,&'static str>;
 fn set_flags(&mut self,s:Self::Stream,flags:u32)->Result<(),&'static str>;
 fn integer(&mut self,s:Self::Stream,value:u32)->Result<(),&'static str>;
 fn literal(&mut self,s:Self::Stream,bytes:&[u8])->Result<(),&'static str>;
 fn string(&mut self,s:Self::Stream,bytes:&[u8])->Result<(),&'static str>;
 fn extract(&mut self,s:Self::Stream)->Result<Vec<u8>,&'static str>;
 fn destroy_stream(&mut self,s:Self::Stream)->Result<(),&'static str>;
}
pub fn byte_hex(value:u8,b:&mut impl Backend)->Result<Vec<u8>,&'static str> {
 let s=b.create_stream()?;
 if value<16 {b.literal(s,b"0")?;}
 let flags=b.flags(s)?;b.set_flags(s,(flags&0xfffff9ff)|0x800)?;b.integer(s,u32::from(value))?;
 let bytes=b.extract(s)?;b.destroy_stream(s)?;Ok(bytes)
}
pub fn rgb_decimal(packed:u32,b:&mut impl Backend)->Result<Vec<u8>,&'static str> {
 let s=b.create_stream()?;b.integer(s,(packed>>16)&255)?;b.literal(s,b" ")?;b.integer(s,(packed>>8)&255)?;b.literal(s,b" ")?;b.integer(s,packed&255)?;
 let bytes=b.extract(s)?;b.destroy_stream(s)?;Ok(bytes)
}
pub fn rgb_hex(packed:u32,b:&mut impl Backend)->Result<Vec<u8>,&'static str> {
 let s=b.create_stream()?;let blue=byte_hex(packed as u8,b)?;let green=byte_hex((packed>>8) as u8,b)?;let red=byte_hex((packed>>16) as u8,b)?;
 b.string(s,&red)?;b.string(s,&green)?;b.string(s,&blue)?;
 let bytes=b.extract(s)?;b.destroy_stream(s)?;Ok(bytes)
}
#[cfg(test)] mod tests {
 use super::*;
 struct Stream {flags:u32,bytes:Vec<u8>,destroyed:bool}
 struct Provider {initial_flags:u32,streams:Vec<Stream>,ops:Vec<serde_json::Value>}
 #[test] fn audio_color_stream_default_format_fields_match96_original_complete_constructor_frames() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_stream_defaults_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),96);
  for c in cases {assert_eq!(INITIAL_FLAGS as u64,c["ios_fields"]["20"].as_u64().unwrap());assert_eq!(INITIAL_PRECISION as u64,c["ios_fields"]["24"].as_u64().unwrap());assert_eq!(INITIAL_WIDTH as u64,c["ios_fields"]["28"].as_u64().unwrap());}
 }
 impl Backend for Provider {
  type Stream=usize;
  fn create_stream(&mut self)->Result<usize,&'static str> {let index=self.streams.len();self.streams.push(Stream {flags:self.initial_flags,bytes:vec![],destroyed:false});Ok(index)}
  fn flags(&mut self,s:usize)->Result<u32,&'static str> {Ok(self.streams[s].flags)}
  fn set_flags(&mut self,s:usize,flags:u32)->Result<(),&'static str> {self.streams[s].flags=flags;Ok(())}
  fn integer(&mut self,s:usize,value:u32)->Result<(),&'static str> {let flags=self.streams[s].flags;let text=if flags&0x800!=0 {format!("{value:x}")} else {value.to_string()};self.streams[s].bytes.extend_from_slice(text.as_bytes());self.ops.push(serde_json::json!({"op":"integer","value":value,"flags":flags,"supplied_output":text}));Ok(())}
  fn literal(&mut self,s:usize,bytes:&[u8])->Result<(),&'static str> {self.streams[s].bytes.extend_from_slice(bytes);self.ops.push(serde_json::json!({"op":"literal","text":std::str::from_utf8(bytes).unwrap()}));Ok(())}
  fn string(&mut self,s:usize,bytes:&[u8])->Result<(),&'static str> {self.streams[s].bytes.extend_from_slice(bytes);self.ops.push(serde_json::json!({"op":"string","text":std::str::from_utf8(bytes).unwrap()}));Ok(())}
  fn extract(&mut self,s:usize)->Result<Vec<u8>,&'static str> {Ok(self.streams[s].bytes.clone())}
  fn destroy_stream(&mut self,s:usize)->Result<(),&'static str> {assert!(!self.streams[s].destroyed);self.streams[s].destroyed=true;Ok(())}
 }
 #[test] fn audio_color_stream_control_matches6680_native_nested_helper_and_rgb_insertion_frames() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_color_stream_control_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),6680);
  for c in cases {let value=c["input"].as_u64().unwrap() as u32;let mut p=Provider {initial_flags:c["initial_flags"].as_u64().unwrap() as u32,streams:vec![],ops:vec![]};let bytes=match c["entry"].as_str().unwrap() {"0x8e19a0"=>byte_hex(value as u8,&mut p),"0x8e1db0"=>rgb_decimal(value,&mut p),"0x8e1b30"=>rgb_hex(value,&mut p),_=>panic!("native color entry")}.unwrap();assert_eq!(bytes,c["output"].as_str().unwrap().as_bytes());assert_eq!(serde_json::json!(p.ops),c["ops"]);assert!(p.streams.iter().all(|s|s.destroyed));}
 }
}
