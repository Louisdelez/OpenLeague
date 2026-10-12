//! Native5FCD40 grouping/padding and5FCC60/5FCCD0 iterator write semantics.
//! Facets, physical string storage and virtual streambuf ownership remain explicit.
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub struct IteratorState { pub failed:u32, pub buffer_present:bool }
pub trait Backend {
 fn widen(&mut self,number:&[u8])->Result<Vec<u8>,String>;
 fn grouping(&mut self)->Result<Vec<u8>,String>;
 fn thousands_separator(&mut self)->Result<u8,String>;
 /// false is native overflow EOF; subsequent bytes still attempt a write.
 fn write_byte(&mut self,byte:u8)->bool;
}
fn emit<B:Backend>(bytes:&[u8],state:&mut IteratorState,backend:&mut B) {
 for &byte in bytes {if !state.buffer_present || !backend.write_byte(byte) {state.failed=(state.failed&0xffffff00)|1;}}
}
fn pad<B:Backend>(count:u64,fill:u8,state:&mut IteratorState,backend:&mut B) {
 for _ in 0..count {emit(&[fill],state,backend);}
}
pub fn write_number<B:Backend>(number:&[u8],flags:u32,width:&mut u64,fill:u8,mut state:IteratorState,backend:&mut B)->Result<IteratorState,String> {
 let mut prefix=usize::from(matches!(number.first(),Some(b'+'|b'-')));
 if flags&0xe00==0x800 && number.len()>=prefix+2 && number[prefix]==b'0' && matches!(number[prefix+1],b'x'|b'X') {prefix+=2;}
 let mut bytes=backend.widen(number)?;
 if bytes.len()!=number.len() {return Err("num_put widen range length mismatch".into());}
 let grouping=backend.grouping()?;
 let mut group_index=0;let mut group=grouping.first().copied().unwrap_or(0);let mut boundary=number.len();
 if group!=0x7f && (group as i8)>0 {
  let separator=backend.thousands_separator()?;
  while group!=0x7f && (group as i8)>0 && (group as usize)<boundary-prefix {
   boundary-=group as usize;bytes.insert(boundary,separator);
   if grouping.get(group_index+1).copied().unwrap_or(0) as i8>0 {group_index+=1;}
   group=grouping[group_index];
  }
 }
 let padding=if (*width as i64)>0 {(*width).saturating_sub(bytes.len() as u64)} else {0};
 match flags&0x1c0 {
  0x40=>{emit(&bytes[..prefix],&mut state,backend);emit(&bytes[prefix..],&mut state,backend);*width=0;pad(padding,fill,&mut state,backend);},
  0x100=>{emit(&bytes[..prefix],&mut state,backend);pad(padding,fill,&mut state,backend);emit(&bytes[prefix..],&mut state,backend);*width=0;},
  _=>{pad(padding,fill,&mut state,backend);emit(&bytes[..prefix],&mut state,backend);emit(&bytes[prefix..],&mut state,backend);*width=0;},
 }
 Ok(state)
}
#[cfg(test)] mod tests {
 use super::*;
 fn decode(s:&str)->Vec<u8> {(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 struct Sink {group:Vec<u8>,storage:String,limit:Option<usize>,bytes:Vec<u8>,ops:Vec<serde_json::Value>}
 impl Backend for Sink {
  fn widen(&mut self,n:&[u8])->Result<Vec<u8>,String> {self.ops.push(serde_json::json!({"op":"widen","bytes":n.len()}));Ok(n.to_vec())}
  fn grouping(&mut self)->Result<Vec<u8>,String> {self.ops.push(serde_json::json!({"op":"grouping","bytes":self.group.iter().map(|b|format!("{b:02x}")).collect::<String>()}));Ok(self.group.clone())}
  fn thousands_separator(&mut self)->Result<u8,String> {self.ops.push(serde_json::json!({"op":"separator"}));Ok(b',')}
  fn write_byte(&mut self,b:u8)->bool {let failed=self.storage=="overflow" && self.limit.is_some_and(|n|self.bytes.len()>=n);if self.storage=="overflow" {self.ops.push(serde_json::json!({"op":"overflow","byte":b,"failed":failed}));}if !failed {self.bytes.push(b);}!failed}
 }
 #[test] fn audio_num_put_writer_matches15120_original_grouping_padding_and_iterator_failure_frames() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_num_put_writer_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),15120);
  for c in cases {
   let mut sink=Sink{group:decode(c["grouping_hex"].as_str().unwrap()),storage:c["storage"].as_str().unwrap().into(),limit:c["failure_after"].as_u64().map(|n|n as usize),bytes:Vec::new(),ops:Vec::new()};let mut width=c["width"].as_u64().unwrap();
   let result=write_number(c["text"].as_str().unwrap().as_bytes(),c["flags"].as_u64().unwrap() as u32,&mut width,c["fill"].as_u64().unwrap() as u8,IteratorState{failed:c["initial_failed"].as_u64().unwrap() as u32,buffer_present:sink.storage!="null"},&mut sink).unwrap();
   assert_eq!(sink.bytes,decode(c["output_hex"].as_str().unwrap()),"{c}");assert_eq!(result.failed,c["result_failed"].as_u64().unwrap() as u32,"{c}");assert_eq!(width,0);
   // Physical insertion is an explicit boundary in the native fixture; its
   // positions are checked independently from the resulting byte order.
   let mut expected=c["ops"].as_array().unwrap().clone();expected.retain(|o|o["op"]!="insert");assert_eq!(sink.ops,expected,"{c}");
  }
 }
}
