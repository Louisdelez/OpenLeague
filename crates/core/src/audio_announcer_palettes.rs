//! Original team/observer palette selectors, with raw field and spectator boundaries.
#[derive(Clone,Copy,Debug,PartialEq,Eq)] pub enum Kind {Team,Observer}
pub trait Backend<A:Copy,M:Copy> {
 fn local_raw_team(&mut self,actor:A)->Result<u32,&'static str>;
 fn spectator_raw(&mut self)->Result<u32,&'static str>;
 fn palette_field(&mut self,manager:M,offset:u32)->Result<u32,&'static str>;
}
pub fn packed_color<A:Copy,M:Copy>(kind:Kind,manager:M,team:u32,local:Option<A>,b:&mut impl Backend<A,M>)->Result<u32,&'static str> {
 let (ally,other,neutral,blue,purple)=match kind {Kind::Team=>(0x34,0x3c,0x40,0x50,0x54),Kind::Observer=>(0xc,0x10,0x14,0x18,0x1c)};
 let offset=if let Some(local)=local {
  if team==300 {neutral} else if b.local_raw_team(local)?==team {ally} else {other}
 } else if b.spectator_raw()? as u8!=0 {
  match team {300=>neutral,100=>blue,200=>purple,_=>other}
 } else {other};
 b.palette_field(manager,offset)
}
#[cfg(test)] mod tests {
 use super::*;use std::collections::BTreeMap;
 struct Provider {local_team:u32,spectator:u32,fields:BTreeMap<u32,u32>,reads:Vec<serde_json::Value>,calls:Vec<u32>}
 impl Backend<u32,u32> for Provider {
  fn local_raw_team(&mut self,actor:u32)->Result<u32,&'static str> {assert_eq!(actor,7);self.reads.push(serde_json::json!({"op":"local_raw_team","value":self.local_team}));Ok(self.local_team)}
  fn spectator_raw(&mut self)->Result<u32,&'static str> {self.calls.push(self.spectator);Ok(self.spectator)}
  fn palette_field(&mut self,manager:u32,offset:u32)->Result<u32,&'static str> {assert_eq!(manager,9);let value=*self.fields.get(&offset).ok_or("native palette field unavailable")?;self.reads.push(serde_json::json!({"op":"palette_field","offset":offset,"value":value}));Ok(value)}
 }
 #[test] fn audio_palettes_match2880_original_raw_local_team_low_spectator_byte_and_exact_field_cases() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_palettes_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),2880);
  for c in cases {let mut p=Provider {local_team:c["local_team"].as_u64().unwrap() as u32,spectator:c["spectator_raw"].as_u64().unwrap() as u32,fields:c["fields"].as_object().unwrap().iter().map(|(k,v)|(k.parse::<u32>().unwrap(),v.as_u64().unwrap() as u32)).collect(),reads:vec![],calls:vec![]};let kind=if c["entry"]=="0x7de7b0" {Kind::Team} else {Kind::Observer};let out=packed_color(kind,9,c["team"].as_u64().unwrap() as u32,c["has_local"].as_bool().unwrap().then_some(7),&mut p).unwrap();assert_eq!(out,c["output"].as_u64().unwrap() as u32);assert_eq!(serde_json::json!(p.reads),c["field_reads"]);assert_eq!(serde_json::json!(p.calls),c["spectator_calls"]);}
 }
}
