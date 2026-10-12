//! Owned normal C-profile color streams, using qualified default fields and integer primitives.
//! Native grouping/padding/writer semantics are ported separately; this profile uses C facets.
//! Normal-return ostream sentry/state/unitbuf behavior is ported; owned streams use Rust C facets.
//! Native physical locking, external ties, C++ exception handling and live facet provenance remain separate work.
use crate::audio_announcer_color_streams::{self as color,Backend};
use crate::audio_announcer_integer_formats as integer;
use crate::audio_announcer_ostream_integer::{self as ostream,StreamState,Tie};
use crate::audio_announcer_num_put_writer as writer;
struct Stream {state:StreamState,bytes:Vec<u8>,alive:bool}
struct CNumberWriter<'a>(&'a mut Vec<u8>);
impl writer::Backend for CNumberWriter<'_> {
 fn widen(&mut self,number:&[u8])->Result<Vec<u8>,String> {Ok(number.to_vec())}
 fn grouping(&mut self)->Result<Vec<u8>,String> {Ok(Vec::new())}
 fn thousands_separator(&mut self)->Result<u8,String> {Ok(b',')}
 fn write_byte(&mut self,byte:u8)->bool {self.0.push(byte);true}
}
impl ostream::Backend for CNumberWriter<'_> {
 fn lock(&mut self)->Result<(),String> {Ok(())}
 fn unlock(&mut self)->Result<(),String> {Ok(())}
 fn flush_tied(&mut self)->Result<(),String> {Err("plain color stream has no external tied stream".into())}
 fn num_put_facet(&mut self)->Result<(),String> {Ok(())}
 fn format_integer(&mut self,flags:u32,value:u32)->Result<Vec<u8>,String> {integer::format_long(flags,value)}
 fn uncaught_exception_raw(&mut self)->u32 {0}
 fn sync(&mut self)->i32 {0}
}
#[derive(Default)] pub struct PlainColorStreams {streams:Vec<Stream>}
impl PlainColorStreams {
 fn active(&mut self,s:usize)->Result<&mut Stream,&'static str> {self.streams.get_mut(s).filter(|s|s.alive).ok_or("color stream storage unavailable")}
}
impl Backend for PlainColorStreams {
 type Stream=usize;
 fn create_stream(&mut self)->Result<usize,&'static str> {let index=self.streams.len();self.streams.push(Stream {state:StreamState {flags:color::INITIAL_FLAGS,width:0,state:0,exception_mask:0,buffer_present:true,tie:Tie::None,fill:b' '},bytes:vec![],alive:true});Ok(index)}
 fn flags(&mut self,s:usize)->Result<u32,&'static str> {Ok(self.active(s)?.state.flags)}
 fn set_flags(&mut self,s:usize,flags:u32)->Result<(),&'static str> {self.active(s)?.state.flags=flags;Ok(())}
 fn integer(&mut self,s:usize,value:u32)->Result<(),&'static str> {
  let stream=self.active(s)?;let mut sink=CNumberWriter(&mut stream.bytes);ostream::insert_long(&mut stream.state,value,&mut sink).map_err(|_|"color ostream normal profile requires additional native qualification")?;Ok(())
 }
 fn literal(&mut self,s:usize,bytes:&[u8])->Result<(),&'static str> {self.active(s)?.bytes.extend_from_slice(bytes);Ok(())}
 fn string(&mut self,s:usize,bytes:&[u8])->Result<(),&'static str> {self.active(s)?.bytes.extend_from_slice(bytes);Ok(())}
 fn extract(&mut self,s:usize)->Result<Vec<u8>,&'static str> {Ok(self.active(s)?.bytes.clone())}
 fn destroy_stream(&mut self,s:usize)->Result<(),&'static str> {let stream=self.active(s)?;stream.bytes.clear();stream.alive=false;Ok(())}
}
#[cfg(test)] mod tests {
 use super::*;
 #[test] fn audio_plain_color_streams_match3340_original_normal_default_byte_rgb_frames_using_production_integer_primitive() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_color_stream_control_contract.json")).unwrap();let cases:Vec<_>=proof["cases"].as_array().unwrap().iter().filter(|c|c["initial_flags"]==color::INITIAL_FLAGS).collect();assert_eq!(cases.len(),3340);
  for c in cases {let mut b=PlainColorStreams::default();let value=c["input"].as_u64().unwrap() as u32;let out=match c["entry"].as_str().unwrap() {"0x8e19a0"=>color::byte_hex(value as u8,&mut b),"0x8e1db0"=>color::rgb_decimal(value,&mut b),"0x8e1b30"=>color::rgb_hex(value,&mut b),_=>panic!("native color entry")}.unwrap();assert_eq!(out,c["output"].as_str().unwrap().as_bytes());}
 }
}
