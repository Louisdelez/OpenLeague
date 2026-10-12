//! Original announcement style families. Physical allocation and stream formatting are explicit boundaries.
use crate::audio_announcer_actor_wrapper::Form;
use crate::audio_announcer_palettes::{self as palettes,Kind as Palette};
#[derive(Clone,Copy,Debug,PartialEq,Eq)] pub enum Kind {Team,TeamHex,ObserverHex,GoldHex,ItemHex,BodyHex}
impl Kind {
 pub fn pattern(self)->&'static [u8] {match self {Self::Team=>b" teamcolor@",Self::TeamHex=>b" teamcolorhex@",Self::ObserverHex=>b" observercolorhex@",Self::GoldHex=>b" goldcolorhex@",Self::ItemHex=>b" itemcalloutitemhex@",Self::BodyHex=>b" itemcalloutbodyhex@"}}
 fn index(self)->usize {match self {Self::Team=>0,Self::TeamHex=>1,Self::ObserverHex=>2,Self::GoldHex=>3,Self::ItemHex=>4,Self::BodyHex=>5}}
}
#[derive(Default)] pub struct Caches {initialized:[bool;6],bytes:[Vec<u8>;6]}
pub trait Backend<A:Copy,M:Copy>:palettes::Backend<A,M> {
 fn team(&mut self,actor:A)->Result<u32,&'static str>;
 fn team_palette(&mut self,manager:M,team:u32,local:Option<A>)->Result<u32,&'static str> where Self:Sized {palettes::packed_color(Palette::Team,manager,team,local,self)}
 fn observer_palette(&mut self,manager:M,team:u32,local:Option<A>)->Result<u32,&'static str> where Self:Sized {palettes::packed_color(Palette::Observer,manager,team,local,self)}
 fn decimal_color(&mut self,packed:u32)->Result<Vec<u8>,&'static str>;
 fn hex_color(&mut self,packed:u32)->Result<Vec<u8>,&'static str>;
 fn register_cache(&mut self,kind:Kind)->Result<(),&'static str>;
 fn moved_temporary_cleanup(&mut self)->Result<(),&'static str>;
}
pub fn style_bytes<A:Copy,M:Copy>(kind:Kind,actor:Option<A>,local:Option<A>,manager:M,caches:&mut Caches,b:&mut impl Backend<A,M>)->Result<Vec<u8>,&'static str> {
 let i=kind.index();if !caches.initialized[i] {caches.initialized[i]=true;caches.bytes[i].clear();b.register_cache(kind)?;}
 caches.bytes[i]=b"unknown".to_vec();
 let packed=match kind {
  Kind::Team|Kind::TeamHex=>{let Some(actor)=actor else {return Ok(caches.bytes[i].clone());};let team=b.team(actor)?;b.team_palette(manager,team,local)?},
  Kind::ObserverHex=>{let actor=actor.ok_or("native observer color actor unavailable")?;let team=b.team(actor)?;b.observer_palette(manager,team,local)?},
  Kind::GoldHex=>b.palette_field(manager,0x58)?,Kind::ItemHex=>b.palette_field(manager,0x6c)?,Kind::BodyHex=>b.palette_field(manager,0x68)?,
 };
 let mut result=if kind==Kind::Team {b.decimal_color(packed)?} else {let mut bytes=vec![b'#'];bytes.extend(b.hex_color(packed)?);bytes};
 caches.bytes[i]=std::mem::take(&mut result);
 if kind==Kind::Team {b.moved_temporary_cleanup()?;} else if kind==Kind::TeamHex {b.moved_temporary_cleanup()?;b.moved_temporary_cleanup()?;}
 let bytes=&caches.bytes[i];Ok(bytes[..bytes.iter().position(|&x|x==0).unwrap_or(bytes.len())].to_vec())
}
pub fn bind_style_bytes<A:Copy,M:Copy>(input:&[u8],_form:Form,actor:Option<A>,local:Option<A>,manager:M,caches:&mut Caches,b:&mut impl Backend<A,M>)->Result<Option<Vec<u8>>,&'static str> {
 for kind in [Kind::Team,Kind::TeamHex,Kind::ObserverHex,Kind::GoldHex,Kind::ItemHex,Kind::BodyHex] {let pattern=kind.pattern();if input.get(..pattern.len()).is_some_and(|s|s.eq_ignore_ascii_case(pattern)) {return style_bytes(kind,actor,local,manager,caches,b).map(Some);}}
 Ok(None)
}
#[cfg(test)] mod tests {
 use super::*;
 struct Provider {team:u32,packed:u32,response:Vec<u8>,allocator:String,ops:Vec<serde_json::Value>,cleanup:Vec<serde_json::Value>,registrations:Vec<&'static str>}
 impl palettes::Backend<u32,u32> for Provider {
  fn local_raw_team(&mut self,_:u32)->Result<u32,&'static str> {Err("native palette composition not supplied in this boundary fixture")}
  fn spectator_raw(&mut self)->Result<u32,&'static str> {Err("native palette composition not supplied in this boundary fixture")}
  fn palette_field(&mut self,_:u32,offset:u32)->Result<u32,&'static str> {let value=self.packed^offset;self.ops.push(serde_json::json!({"op":"palette_field","offset":offset,"value":value}));Ok(value)}
 }
 impl Backend<u32,u32> for Provider {
  fn team(&mut self,_:u32)->Result<u32,&'static str> {self.ops.push(serde_json::json!({"op":"team","value":self.team}));Ok(self.team)}
  fn team_palette(&mut self,_:u32,team:u32,_:Option<u32>)->Result<u32,&'static str> {self.ops.push(serde_json::json!({"op":"team_palette","team":team}));Ok(self.packed)}
  fn observer_palette(&mut self,_:u32,team:u32,_:Option<u32>)->Result<u32,&'static str> {self.ops.push(serde_json::json!({"op":"observer_palette","team":team}));Ok(self.packed)}
  fn decimal_color(&mut self,packed:u32)->Result<Vec<u8>,&'static str> {self.ops.push(serde_json::json!({"op":"decimal_color","packed":packed}));Ok(self.response.clone())}
  fn hex_color(&mut self,packed:u32)->Result<Vec<u8>,&'static str> {self.ops.push(serde_json::json!({"op":"hex_color","packed":packed}));self.ops.push(serde_json::json!({"op":"prefix","text":"#"}));Ok(self.response.clone())}
  fn register_cache(&mut self,kind:Kind)->Result<(),&'static str> {self.registrations.push(["0xf99770","0xf997f0","0xf99870","0xf998f0","0xf99970","0xf999f0"][kind.index()]);Ok(())}
  fn moved_temporary_cleanup(&mut self)->Result<(),&'static str> {self.cleanup.push(serde_json::json!({"op":"temporary_destroy","capacity":15}));Ok(())}
 }
 #[test] fn audio_style_control_matches5940_native_registered_frames_and_explicit_conversion_boundaries() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_style_control_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),5940);
  for c in cases {let mut p=Provider {team:c["team"].as_u64().unwrap() as u32,packed:c["packed"].as_u64().unwrap() as u32,response:c["supplied_converter_result"].as_str().unwrap().as_bytes().to_vec(),allocator:c["allocator"].as_str().unwrap().to_owned(),ops:vec![],cleanup:vec![],registrations:vec![]};let mut caches=Caches::default();let actor=c["exists"].as_bool().unwrap().then_some(7);let form=if c["entry"]=="0x6d4a10" {Form::Plain} else {Form::Localized};let out=bind_style_bytes(c["input"].as_str().unwrap().as_bytes(),form,actor,None,9,&mut caches,&mut p).unwrap().unwrap();assert_eq!(out.iter().map(|b|format!("{b:02x}")).collect::<String>(),c["output_hex"].as_str().unwrap());assert_eq!(serde_json::json!(p.ops),c["ops"]);assert_eq!(serde_json::json!(p.cleanup),c["cleanup"],"allocator {}",p.allocator);assert_eq!(serde_json::json!(p.registrations),c["atexit_registrations"]);}
 }
 struct Composed {team:u32,local_team:u32,spectator:u32,fields:std::collections::BTreeMap<u32,u32>,response:Vec<u8>,ops:Vec<serde_json::Value>,cleanup:Vec<serde_json::Value>,registrations:Vec<&'static str>}
 impl palettes::Backend<u32,u32> for Composed {
  fn local_raw_team(&mut self,_:u32)->Result<u32,&'static str> {self.ops.push(serde_json::json!({"op":"local_raw_team","value":self.local_team}));Ok(self.local_team)}
  fn spectator_raw(&mut self)->Result<u32,&'static str> {self.ops.push(serde_json::json!({"op":"spectator_raw","value":self.spectator}));Ok(self.spectator)}
  fn palette_field(&mut self,_:u32,offset:u32)->Result<u32,&'static str> {let value=*self.fields.get(&offset).ok_or("palette field unavailable")?;self.ops.push(serde_json::json!({"op":"palette_field","offset":offset,"value":value}));Ok(value)}
 }
 impl Backend<u32,u32> for Composed {
  fn team(&mut self,_:u32)->Result<u32,&'static str> {self.ops.push(serde_json::json!({"op":"team","value":self.team}));Ok(self.team)}
  fn decimal_color(&mut self,packed:u32)->Result<Vec<u8>,&'static str> {self.ops.push(serde_json::json!({"op":"decimal_color","packed":packed}));Ok(self.response.clone())}
  fn hex_color(&mut self,packed:u32)->Result<Vec<u8>,&'static str> {self.ops.push(serde_json::json!({"op":"hex_color","packed":packed}));self.ops.push(serde_json::json!({"op":"prefix","text":"#"}));Ok(self.response.clone())}
  fn register_cache(&mut self,kind:Kind)->Result<(),&'static str> {self.registrations.push(["0xf99770","0xf997f0","0xf99870","0xf998f0","0xf99970","0xf999f0"][kind.index()]);Ok(())}
  fn moved_temporary_cleanup(&mut self)->Result<(),&'static str> {self.cleanup.push(serde_json::json!({"op":"temporary_destroy","capacity":15}));Ok(())}
 }
 #[test] fn audio_palette_style_composition_matches720_actual_native_producer_dispatch_frames() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_styles_composed_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),720);
  for c in cases {let mut p=Composed {team:c["team"].as_u64().unwrap() as u32,local_team:c["local_team"].as_u64().unwrap() as u32,spectator:c["spectator_raw"].as_u64().unwrap() as u32,fields:c["fields"].as_object().unwrap().iter().map(|(k,v)|(k.parse().unwrap(),v.as_u64().unwrap() as u32)).collect(),response:c["supplied_converter_result"].as_str().unwrap().as_bytes().to_vec(),ops:vec![],cleanup:vec![],registrations:vec![]};let local=(c["local"]!="none").then_some(8);let form=if c["entry"]=="0x6d4a10" {Form::Plain} else {Form::Localized};let mut caches=Caches::default();let out=bind_style_bytes(c["pattern"].as_str().unwrap().as_bytes(),form,Some(7),local,9,&mut caches,&mut p).unwrap().unwrap();assert_eq!(out.iter().map(|b|format!("{b:02x}")).collect::<String>(),c["output_hex"].as_str().unwrap());let expected_ops:Vec<_>=c["ops"].as_array().unwrap().iter().filter(|x|x["op"]!="team_palette" && x["op"]!="observer_palette").cloned().collect();assert_eq!(p.ops,expected_ops);assert_eq!(serde_json::json!(p.cleanup),c["cleanup"]);assert_eq!(serde_json::json!(p.registrations),c["atexit_registrations"]);}
 }
 #[test] fn audio_observer_null_preserves_native_unknown_cache_before_explicit_missing_storage_error() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_observer_null_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),2);
  for c in cases {assert_eq!(c["faults"][0]["address"],0x124);let mut caches=Caches::default();caches.initialized[Kind::ObserverHex.index()]=true;caches.bytes[Kind::ObserverHex.index()]=b"prior".to_vec();let mut p=Provider {team:0,packed:0,response:vec![],allocator:"standard".to_owned(),ops:vec![],cleanup:vec![],registrations:vec![]};let form=if c["entry"]=="0x6d3d30" {Form::Plain} else {Form::Localized};assert_eq!(bind_style_bytes(b" observercolorhex@",form,None,None,9,&mut caches,&mut p),Err("native observer color actor unavailable"));assert_eq!(caches.bytes[Kind::ObserverHex.index()],c["cache_after_fault"].as_str().unwrap().as_bytes());assert!(p.ops.is_empty() && p.cleanup.is_empty() && p.registrations.is_empty());}
 }
}
