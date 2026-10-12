//! Connect original palette/style control to actual Rust RGB stream orchestration.
use crate::{audio_announcer_palettes as palettes,audio_announcer_styles as styles,audio_announcer_color_streams as streams};
pub trait Sources<A:Copy,M:Copy>:palettes::Backend<A,M> {
 fn actor_team(&mut self,actor:A)->Result<u32,&'static str>;
 fn register_style_cache(&mut self,kind:styles::Kind)->Result<(),&'static str>;
 fn moved_style_temporary_cleanup(&mut self)->Result<(),&'static str>;
}
pub struct Rendered<'a,P,S> {pub sources:&'a mut P,pub streams:&'a mut S}
/// Normal C-profile rendering; alternate native locale/writer profiles remain explicit work.
pub fn bind_plain_c_style_bytes<A:Copy,M:Copy>(input:&[u8],form:crate::audio_announcer_actor_wrapper::Form,actor:Option<A>,local:Option<A>,manager:M,caches:&mut styles::Caches,sources:&mut impl Sources<A,M>)->Result<Option<Vec<u8>>,&'static str> {
 let mut stream=crate::audio_announcer_plain_color_streams::PlainColorStreams::default();let mut backend=Rendered {sources,streams:&mut stream};styles::bind_style_bytes(input,form,actor,local,manager,caches,&mut backend)
}
impl<A:Copy,M:Copy,P:Sources<A,M>,S:streams::Backend> palettes::Backend<A,M> for Rendered<'_,P,S> {
 fn local_raw_team(&mut self,a:A)->Result<u32,&'static str> {self.sources.local_raw_team(a)}
 fn spectator_raw(&mut self)->Result<u32,&'static str> {self.sources.spectator_raw()}
 fn palette_field(&mut self,m:M,offset:u32)->Result<u32,&'static str> {self.sources.palette_field(m,offset)}
}
impl<A:Copy,M:Copy,P:Sources<A,M>,S:streams::Backend> styles::Backend<A,M> for Rendered<'_,P,S> {
 fn team(&mut self,a:A)->Result<u32,&'static str> {self.sources.actor_team(a)}
 fn decimal_color(&mut self,packed:u32)->Result<Vec<u8>,&'static str> {streams::rgb_decimal(packed,self.streams)}
 fn hex_color(&mut self,packed:u32)->Result<Vec<u8>,&'static str> {streams::rgb_hex(packed,self.streams)}
 fn register_cache(&mut self,kind:styles::Kind)->Result<(),&'static str> {self.sources.register_style_cache(kind)}
 fn moved_temporary_cleanup(&mut self)->Result<(),&'static str> {self.sources.moved_style_temporary_cleanup()}
}
#[cfg(test)] mod tests {
 use super::*;use crate::audio_announcer_actor_wrapper::Form;
 struct Palette {team:u32,local_team:u32,spectator:u32,fields:std::collections::BTreeMap<u32,u32>,ops:Vec<serde_json::Value>,cleanup:Vec<serde_json::Value>,registrations:Vec<&'static str>}
 impl palettes::Backend<u32,u32> for Palette {
  fn local_raw_team(&mut self,_:u32)->Result<u32,&'static str> {self.ops.push(serde_json::json!({"op":"local_raw_team","value":self.local_team}));Ok(self.local_team)}
  fn spectator_raw(&mut self)->Result<u32,&'static str> {self.ops.push(serde_json::json!({"op":"spectator_raw","value":self.spectator}));Ok(self.spectator)}
  fn palette_field(&mut self,_:u32,offset:u32)->Result<u32,&'static str> {let value=*self.fields.get(&offset).ok_or("palette unavailable")?;self.ops.push(serde_json::json!({"op":"palette_field","offset":offset,"value":value}));Ok(value)}
 }
 impl Sources<u32,u32> for Palette {
  fn actor_team(&mut self,_:u32)->Result<u32,&'static str> {self.ops.push(serde_json::json!({"op":"team","value":self.team}));Ok(self.team)}
  fn register_style_cache(&mut self,kind:styles::Kind)->Result<(),&'static str> {self.registrations.push(match kind {styles::Kind::Team=>"0xf99770",styles::Kind::TeamHex=>"0xf997f0",styles::Kind::ObserverHex=>"0xf99870",_=>panic!("native composition kind")});Ok(())}
  fn moved_style_temporary_cleanup(&mut self)->Result<(),&'static str> {self.cleanup.push(serde_json::json!({"op":"temporary_destroy","capacity":15}));Ok(())}
 }
 #[derive(Default)] struct StreamProvider {values:Vec<(u32,Vec<u8>)>,ops:Vec<serde_json::Value>}
 impl streams::Backend for StreamProvider {
  type Stream=usize;
  fn create_stream(&mut self)->Result<usize,&'static str> {let i=self.values.len();self.values.push((streams::INITIAL_FLAGS,vec![]));Ok(i)}
  fn flags(&mut self,s:usize)->Result<u32,&'static str> {Ok(self.values[s].0)}
  fn set_flags(&mut self,s:usize,flags:u32)->Result<(),&'static str> {self.values[s].0=flags;Ok(())}
  fn integer(&mut self,s:usize,value:u32)->Result<(),&'static str> {let flags=self.values[s].0;let text=if flags&0x800!=0 {format!("{value:x}")} else {value.to_string()};self.values[s].1.extend_from_slice(text.as_bytes());self.ops.push(serde_json::json!({"op":"integer","value":value,"flags":flags,"supplied_output":text}));Ok(())}
  fn literal(&mut self,s:usize,b:&[u8])->Result<(),&'static str> {self.values[s].1.extend_from_slice(b);self.ops.push(serde_json::json!({"op":"literal","text":std::str::from_utf8(b).unwrap()}));Ok(())}
  fn string(&mut self,s:usize,b:&[u8])->Result<(),&'static str> {self.values[s].1.extend_from_slice(b);self.ops.push(serde_json::json!({"op":"string","text":std::str::from_utf8(b).unwrap()}));Ok(())}
  fn extract(&mut self,s:usize)->Result<Vec<u8>,&'static str> {Ok(self.values[s].1.clone())}
  fn destroy_stream(&mut self,_:usize)->Result<(),&'static str> {Ok(())}
 }
 #[test] fn audio_rendered_styles_match1080_native_dispatch_palette_rgb_and_actual_stream_constructor_frames() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_rendered_styles_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),1080);
  for c in cases {let mut p=Palette {team:c["team"].as_u64().unwrap() as u32,local_team:c["local_team"].as_u64().unwrap() as u32,spectator:c["spectator_raw"].as_u64().unwrap() as u32,fields:c["fields"].as_object().unwrap().iter().map(|(k,v)|(k.parse().unwrap(),v.as_u64().unwrap() as u32)).collect(),ops:vec![],cleanup:vec![],registrations:vec![]};let mut s=StreamProvider::default();let mut cache=styles::Caches::default();let mut b=Rendered {sources:&mut p,streams:&mut s};let local=(c["local"]!="none").then_some(8);let form=if c["entry"]=="0x6d4a10" {Form::Plain} else {Form::Localized};let out=styles::bind_style_bytes(c["pattern"].as_str().unwrap().as_bytes(),form,Some(7),local,9,&mut cache,&mut b).unwrap().unwrap();assert_eq!(out.iter().map(|x|format!("{x:02x}")).collect::<String>(),c["output_hex"].as_str().unwrap());let expected:Vec<_>=c["ops"].as_array().unwrap().iter().filter(|x|!matches!(x["op"].as_str(),Some("team_palette"|"observer_palette"|"decimal_color"|"hex_color"|"prefix"))).cloned().collect();assert_eq!(p.ops,expected);assert_eq!(serde_json::json!(s.ops),c["stream_ops"]);assert_eq!(serde_json::json!(p.cleanup),c["cleanup"]);assert_eq!(serde_json::json!(p.registrations),c["atexit_registrations"]);}
 }
 #[test] fn audio_plain_c_style_production_backend_matches1080_native_palette_rgb_composed_frames() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_rendered_styles_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),1080);
  for c in cases {let mut p=Palette {team:c["team"].as_u64().unwrap() as u32,local_team:c["local_team"].as_u64().unwrap() as u32,spectator:c["spectator_raw"].as_u64().unwrap() as u32,fields:c["fields"].as_object().unwrap().iter().map(|(k,v)|(k.parse().unwrap(),v.as_u64().unwrap() as u32)).collect(),ops:vec![],cleanup:vec![],registrations:vec![]};let local=(c["local"]!="none").then_some(8);let form=if c["entry"]=="0x6d4a10" {Form::Plain} else {Form::Localized};let out=bind_plain_c_style_bytes(c["pattern"].as_str().unwrap().as_bytes(),form,Some(7),local,9,&mut styles::Caches::default(),&mut p).unwrap().unwrap();assert_eq!(out.iter().map(|x|format!("{x:02x}")).collect::<String>(),c["output_hex"].as_str().unwrap());}
 }
}
