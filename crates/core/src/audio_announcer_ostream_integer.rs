//! Normal-return native5FD260 ostream<long> control flow.
//! Throwing facets, native exceptional unwinding and exception masks remain explicit.
use crate::audio_announcer_num_put_writer::{self as writer,IteratorState};
#[derive(Clone,Copy,PartialEq,Eq)] pub enum Tie {None,SelfStream,External}
pub struct StreamState {pub flags:u32,pub width:u64,pub state:u32,pub exception_mask:u32,pub buffer_present:bool,pub tie:Tie,pub fill:u8}
pub trait Backend:writer::Backend {
 fn lock(&mut self)->Result<(),String>;
 fn unlock(&mut self)->Result<(),String>;
 fn flush_tied(&mut self)->Result<(),String>;
 fn num_put_facet(&mut self)->Result<(),String>;
 fn format_integer(&mut self,flags:u32,value:u32)->Result<Vec<u8>,String>;
 fn uncaught_exception_raw(&mut self)->u32;
 fn sync(&mut self)->i32;
}
pub fn insert_long<B:Backend>(stream:&mut StreamState,value:u32,backend:&mut B)->Result<(),String> {
 if stream.exception_mask!=0 {return Err("ostream exception masks require native exception qualification".into());}
 if stream.buffer_present {backend.lock()?;}
 if stream.state==0 && stream.tie==Tie::External {backend.flush_tied()?;}
 if stream.state==0 {
  backend.num_put_facet()?;let bytes=backend.format_integer(stream.flags,value)?;
  let result=writer::write_number(&bytes,stream.flags,&mut stream.width,stream.fill,IteratorState {failed:0,buffer_present:stream.buffer_present},backend)?;
  if result.failed as u8!=0 {stream.state=(stream.state|4)&0x17;}
 }
 if backend.uncaught_exception_raw() as u8==0 && stream.state==0 && stream.flags&2!=0 {
  if !stream.buffer_present {return Err("ostream unitbuf requires native buffer storage".into());}
  if backend.sync()==-1 {stream.state=(stream.state|4)&0x17;}
 }
 if stream.buffer_present {backend.unlock()?;}
 Ok(())
}
#[cfg(test)] mod tests {
 use super::*;
 struct Sink {group:Vec<u8>,storage:String,limit:Option<usize>,bytes:Vec<u8>,ops:Vec<serde_json::Value>,uncaught:u32,sync:i32}
 impl writer::Backend for Sink {
  fn widen(&mut self,n:&[u8])->Result<Vec<u8>,String> {self.ops.push(serde_json::json!({"op":"widen","bytes":n.len()}));Ok(n.to_vec())}
  fn grouping(&mut self)->Result<Vec<u8>,String> {self.ops.push(serde_json::json!({"op":"grouping","bytes":self.group.iter().map(|b|format!("{b:02x}")).collect::<String>()}));Ok(self.group.clone())}
  fn thousands_separator(&mut self)->Result<u8,String> {self.ops.push(serde_json::json!({"op":"separator"}));Ok(b',')}
  fn write_byte(&mut self,b:u8)->bool {let failed=self.storage=="overflow" && self.limit.is_some_and(|n|self.bytes.len()>=n);if self.storage=="overflow" {self.ops.push(serde_json::json!({"op":"overflow","byte":b,"failed":failed}));}if !failed {self.bytes.push(b);}!failed}
 }
 impl Backend for Sink {
  fn lock(&mut self)->Result<(),String> {self.ops.push(serde_json::json!({"op":"lock"}));Ok(())}
  fn unlock(&mut self)->Result<(),String> {self.ops.push(serde_json::json!({"op":"unlock"}));Ok(())}
  fn flush_tied(&mut self)->Result<(),String> {panic!("no external ties in native fixture")}
  fn num_put_facet(&mut self)->Result<(),String> {self.ops.push(serde_json::json!({"op":"num_put_facet"}));Ok(())}
  fn format_integer(&mut self,flags:u32,value:u32)->Result<Vec<u8>,String> {crate::audio_announcer_integer_formats::format_long(flags,value)}
  fn uncaught_exception_raw(&mut self)->u32 {self.ops.push(serde_json::json!({"op":"uncaught_exception","raw":self.uncaught}));self.uncaught}
  fn sync(&mut self)->i32 {self.ops.push(serde_json::json!({"op":"sync","result":self.sync}));self.sync}
 }
 #[test] fn audio_ostream_long_matches5184_original_full_crt_writer_state_and_unitbuf_frames() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_ostream_integer_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),5184);
  for c in cases {
   let mut sink=Sink {group:Vec::new(),storage:c["storage"].as_str().unwrap().into(),limit:c["failure_after"].as_u64().map(|n|n as usize),bytes:Vec::new(),ops:Vec::new(),uncaught:c["uncaught_raw"].as_u64().unwrap() as u32,sync:c["sync_result"].as_i64().unwrap() as i32};
   let mut stream=StreamState {flags:c["flags"].as_u64().unwrap() as u32,width:0,state:c["initial_state"].as_u64().unwrap() as u32,exception_mask:0,buffer_present:sink.storage!="null",tie:if c["tied"]=="self" {Tie::SelfStream} else {Tie::None},fill:b' '};
   insert_long(&mut stream,c["value"].as_u64().unwrap() as u32,&mut sink).unwrap();assert_eq!(stream.state,c["result_state"].as_u64().unwrap() as u32,"{c}");assert_eq!(sink.bytes.iter().map(|b|format!("{b:02x}")).collect::<String>(),c["output_hex"].as_str().unwrap(),"{c}");assert_eq!(serde_json::Value::Array(sink.ops),c["ops"],"{c}");
  }
 }

 #[test] fn audio_num_put_composed_matches1920_original_virtual_facet_crt_grouping_and_writer_frames() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_num_put_composed_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),1920);
  for c in cases {
   let group_text=c["grouping_hex"].as_str().unwrap();let group=(0..group_text.len()).step_by(2).map(|i|u8::from_str_radix(&group_text[i..i+2],16).unwrap()).collect();
   let mut sink=Sink {group,storage:c["storage"].as_str().unwrap().into(),limit:c["failure_after"].as_u64().map(|n|n as usize),bytes:Vec::new(),ops:Vec::new(),uncaught:0,sync:0};let flags=c["flags"].as_u64().unwrap() as u32;let mut width=c["width"].as_u64().unwrap();
   let bytes=crate::audio_announcer_integer_formats::format_long(flags,c["value"].as_u64().unwrap() as u32).unwrap();let result=writer::write_number(&bytes,flags,&mut width,c["fill"].as_u64().unwrap() as u8,IteratorState {failed:0,buffer_present:true},&mut sink).unwrap();
   assert_eq!(sink.bytes.iter().map(|b|format!("{b:02x}")).collect::<String>(),c["output_hex"].as_str().unwrap(),"{c}");assert_eq!(result.failed,c["result_failed"].as_u64().unwrap() as u32);assert_eq!(width,0);
   let mut expected=c["ops"].as_array().unwrap().clone();expected.retain(|o|o["op"]!="insert");assert_eq!(sink.ops,expected,"{c}");
  }
 }
}
