//! Original registered bounty/champion value fields; shared buffers are owned explicitly.
use crate::audio_announcer_actor_wrapper::Form;
#[derive(Clone,Copy,Debug,PartialEq,Eq)] pub enum Kind {Bounty,Champion}
#[derive(Clone,Copy,Debug,PartialEq,Eq)] pub enum Source {LiteralZero,BountyCache,ChampionCache}
#[derive(Debug,PartialEq,Eq)] pub struct Value {pub bytes:Vec<u8>,pub source:Source}
#[derive(Debug,PartialEq,Eq)] pub enum Error {Backend(&'static str),NullChampion {last_error:u32},MissingTerminator}
impl From<&'static str> for Error {fn from(e:&'static str)->Self {Self::Backend(e)}}
pub struct Caches {pub bounty:[u8;256],pub champion:[u8;256]}
impl Default for Caches {fn default()->Self {Self {bounty:[0;256],champion:[0;256]}}}
pub trait Backend<A> {
 fn flags(&mut self,actor:A)->u32;
 fn bounty_bits(&mut self,actor:A)->Result<u32,&'static str>;
 /// Raw accessible C-string storage. None is the native NULL getter path.
 fn champion_name_storage(&mut self,actor:A)->Result<Option<Vec<u8>>,&'static str>;
 fn set_errno(&mut self,value:u32)->Result<(),&'static str>;
 /// Native callback may return or terminate; a returning backend permits the empty result.
 fn invalid_parameter(&mut self)->Result<(),&'static str>;
 fn missing_champion_diagnostic(&mut self,label:&[u8])->Result<(),&'static str>;
 fn last_error(&mut self)->u32;
}
fn bytes(buffer:&[u8;256])->Vec<u8> {buffer[..buffer.iter().position(|&b|b==0).unwrap_or(256)].to_vec()}
pub fn value<A:Copy>(kind:Kind,actor:Option<A>,caches:&mut Caches,backend:&mut impl Backend<A>)->Result<Value,Error> {
 let Some(actor)=actor else {return Ok(Value {bytes:b"0".to_vec(),source:Source::LiteralZero});};
 if backend.flags(actor)&0x400==0 {return Ok(Value {bytes:b"0".to_vec(),source:Source::LiteralZero});}
 match kind {
  Kind::Bounty=>{let text=crate::audio_announcer_bounty::format_bounty_bits(backend.bounty_bits(actor)?);caches.bounty[..text.len()].copy_from_slice(&text);caches.bounty[text.len()]=0;Ok(Value {bytes:text,source:Source::BountyCache})},
  Kind::Champion=>{
   let Some(storage)=backend.champion_name_storage(actor)? else {backend.missing_champion_diagnostic(b"pStr")?;let last_error=backend.last_error();return Err(Error::NullChampion {last_error});};
   // C9F8B6 scans at most255 bytes, but its result is ignored. C9F8D1
   // independently copies up to256 bytes including the terminator.
   if storage.len()<255 && !storage.contains(&0) {return Err(Error::MissingTerminator);}
   for (i,&byte) in storage.iter().take(256).enumerate() {caches.champion[i]=byte;if byte==0 {return Ok(Value {bytes:bytes(&caches.champion),source:Source::ChampionCache});}}
   if storage.len()<256 {return Err(Error::MissingTerminator);}
   caches.champion[0]=0;backend.set_errno(34)?;backend.invalid_parameter()?;Ok(Value {bytes:Vec::new(),source:Source::ChampionCache})
  }
 }
}
pub fn bind_value<A:Copy>(input:&[u8],_form:Form,actor:Option<A>,caches:&mut Caches,backend:&mut impl Backend<A>)->Result<Option<Value>,Error> {
 for (kind,pattern) in [(Kind::Bounty,b" bounty@".as_slice()),(Kind::Champion,b" champion@".as_slice())] {
  if input.get(..pattern.len()).is_some_and(|p|p.eq_ignore_ascii_case(pattern)) {return value(kind,actor,caches,backend).map(Some);}
 }Ok(None)
}
#[cfg(test)] mod tests {
 use super::*;
 fn decode(s:&str)->Vec<u8> {(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 struct Provider {flags:u32,bits:u32,name:Option<Vec<u8>>,errno:u32,last_error:u32,ops:Vec<serde_json::Value>}
 impl Backend<u32> for Provider {
  fn flags(&mut self,_:u32)->u32 {self.flags}
  fn bounty_bits(&mut self,_:u32)->Result<u32,&'static str> {self.ops.push(serde_json::json!({"op":"bounty_getter"}));Ok(self.bits)}
  fn champion_name_storage(&mut self,_:u32)->Result<Option<Vec<u8>>,&'static str> {self.ops.push(if self.name.is_some() {serde_json::json!({"op":"champion_getter"})} else {serde_json::json!({"op":"champion_getter","result":null})});Ok(self.name.clone())}
  fn set_errno(&mut self,v:u32)->Result<(),&'static str> {self.errno=v;Ok(())}
  fn invalid_parameter(&mut self)->Result<(),&'static str> {self.ops.push(serde_json::json!({"op":"invalid_parameter","args":[0,0,0,0,0]}));Ok(())}
  fn missing_champion_diagnostic(&mut self,label:&[u8])->Result<(),&'static str> {self.ops.push(serde_json::json!({"op":"diagnostic","format_hex":label.iter().map(|b|format!("{b:02x}")).collect::<String>(),"args":[17324845,0,17324845]}));Ok(())}
  fn last_error(&mut self)->u32 {self.ops.push(serde_json::json!({"op":"GetLastError","result":self.last_error}));self.last_error}
 }
 fn provider(c:&serde_json::Value)->Provider {let mut name=c["name_hex"].as_str().map(decode);if let Some(n)=name.as_mut() {n.push(0);}Provider {flags:c["flags"].as_u64().unwrap() as u32,bits:c["float_bits_hex"].as_str().map(|s|u32::from_le_bytes(decode(s).try_into().unwrap())).unwrap_or(0),name,errno:0,last_error:c["last_error"].as_u64().unwrap_or(97) as u32,ops:Vec::new()}}
 fn proof(name:&str,count:usize)->Vec<serde_json::Value> {let p:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture(&format!("data/4.20/{name}"))).unwrap();let cases=p["cases"].as_array().unwrap();assert_eq!(cases.len(),count);cases.clone()}
 fn ops(p:&Provider,c:&serde_json::Value) {let expected:Vec<_>=c["ops"].as_array().unwrap().iter().filter(|o|o["op"]!="DecodePointer" && o["op"]!="EncodePointer").cloned().collect();assert_eq!(p.ops,expected);}
 #[test] fn audio_champion_value_matches128_original_gate_raw_copy_and_buffer_tail_frames() {
  for c in proof("audio_announcer_champion_field_contract.json",128) {let mut p=provider(&c);let mut cache=Caches {bounty:[0;256],champion:[0xcc;256]};let v=value(Kind::Champion,c["actor_present"].as_bool().unwrap().then_some(1),&mut cache,&mut p).unwrap();assert_eq!(v.bytes,decode(c["output_hex"].as_str().unwrap()));assert_eq!(cache.champion.as_slice(),decode(c["buffer_hex"].as_str().unwrap()));ops(&p,&c);assert_eq!(v.source,if c["output_pointer"]==0x2d7c260u32 {Source::ChampionCache} else {Source::LiteralZero});}
 }
 #[test] fn audio_bounty_value_matches288_original_gate_and_shared_cache_source_frames() {
  for c in proof("audio_announcer_bounty_contract.json",288) {let mut p=provider(&c);let mut cache=Caches::default();let v=value(Kind::Bounty,c["actor_present"].as_bool().unwrap().then_some(1),&mut cache,&mut p).unwrap();assert_eq!(v.bytes,decode(c["output_hex"].as_str().unwrap()));ops(&p,&c);assert_eq!(v.source,if c["output_pointer"]==0x2d7c160u32 {Source::BountyCache} else {Source::LiteralZero});}
 }
 #[test] fn audio_champion_value_copy_errors_match48_native_partial_copy_errno_and_returning_handler_frames() {
  for c in proof("audio_announcer_champion_field_copy_errors_contract.json",48) {let mut p=provider(&c);let mut cache=Caches {bounty:[0;256],champion:[c["initial_fill"].as_u64().unwrap() as u8;256]};let v=value(Kind::Champion,Some(1),&mut cache,&mut p).unwrap();assert_eq!(v.bytes,decode(c["output_hex"].as_str().unwrap()));assert_eq!(cache.champion.as_slice(),decode(c["buffer_hex"].as_str().unwrap()));assert_eq!(p.errno,c["errno"].as_u64().unwrap() as u32);ops(&p,&c);}
 }
 #[test] fn audio_champion_value_null_fault_preserves12_original_diagnostic_and_last_error_orders() {
  for c in proof("audio_announcer_champion_field_null_contract.json",12) {let mut p=provider(&c);let mut cache=Caches {bounty:[0;256],champion:[0xcc;256]};assert_eq!(value(Kind::Champion,Some(1),&mut cache,&mut p),Err(Error::NullChampion {last_error:p.last_error}));assert_eq!(cache.champion,[0xcc;256]);ops(&p,&c);}
 }
 #[test] fn audio_registered_value_fields_match576_original_dispatcher_matcher_crt_and_raw_copy_frames() {
  for c in proof("audio_announcer_registered_value_fields_contract.json",576) {let mut p=provider(&c);let mut cache=Caches::default();let form=if c["entry"]=="0x6d4a10" {Form::Plain} else {Form::Localized};let v=bind_value(&decode(c["input_hex"].as_str().unwrap()),form,c["actor_present"].as_bool().unwrap().then_some(1),&mut cache,&mut p).unwrap().unwrap();assert_eq!(v.bytes,decode(c["output_hex"].as_str().unwrap()));ops(&p,&c);}
 }
}
