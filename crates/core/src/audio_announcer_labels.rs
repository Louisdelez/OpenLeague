//! Native turret labels, inhibitor lane and have/has formatter families.
use crate::audio_announcer_actor_wrapper::Form;
#[derive(Clone,Copy,Debug,PartialEq,Eq)]
pub enum Kind {TurretLane,TurretPosition,TurretLaneOrNexus,DampenerLane,HaveHas}
impl Kind {
 pub fn pattern(self)->&'static [u8] {match self {
  Self::TurretLane=>b" turret lane@",Self::TurretPosition=>b" turret position@",
  Self::TurretLaneOrNexus=>b" turret lane or nexus@",Self::DampenerLane=>b" dampener lane@",Self::HaveHas=>b" have | has@",
 }}
 pub fn registered(self,form:Form)->bool {self!=Self::TurretLaneOrNexus || form==Form::Plain}
}
pub trait Backend<A:Copy> {
 type LaneOwner:Copy;
 fn turret_kind(&mut self,actor:A)->Result<u32,&'static str>;
 fn lane_owner(&mut self,actor:A)->Result<Option<Self::LaneOwner>,&'static str>;
 fn turret_lane(&mut self,owner:Self::LaneOwner)->Result<u32,&'static str>;
 fn dampener_lane(&mut self,actor:A)->Result<u32,&'static str>;
 fn localize(&mut self,key:&'static str)->Result<String,&'static str>;
}
fn rendered<A:Copy>(plain:&'static str,key:&'static str,form:Form,b:&mut impl Backend<A>)->Result<Vec<u8>,&'static str> {
 if form==Form::Plain {Ok(plain.as_bytes().to_vec())} else {b.localize(key).map(String::into_bytes)}
}
pub fn label_bytes<A:Copy+Eq>(kind:Kind,form:Form,actor:Option<A>,local:Option<A>,b:&mut impl Backend<A>)->Result<Vec<u8>,&'static str> {
 if !kind.registered(form) {return Err("unregistered localized turret lane-or-nexus family");}
 if kind==Kind::HaveHas {
  if form==Form::Localized && actor.is_none() {return Ok(vec![]);}
  let have=actor.is_none() || actor==local;
  return rendered(if have {"have"} else {"has"},if have {"game_announcement_replace_have"} else {"game_announcement_replace_has"},form,b);
 }
 let Some(actor)=actor else {return Ok(if form==Form::Localized && matches!(kind,Kind::TurretPosition|Kind::DampenerLane) {vec![]} else {b"unknown".to_vec()});};
 if kind==Kind::TurretPosition {
  let (word,key)=match b.turret_kind(actor)? {1=>("first","game_announcement_replace_first"),2=>("second","game_announcement_replace_second"),_=>("third","game_announcement_replace_third")};
  return rendered(word,key,form,b);
 }
 if kind==Kind::TurretLaneOrNexus && matches!(b.turret_kind(actor)?,4|5) {return Ok(b"nexus".to_vec());}
 let lane=if kind==Kind::DampenerLane {
  if b.dampener_lane(actor)?==0 {0} else if b.dampener_lane(actor)?==1 {1} else {2}
 } else {let owner=b.lane_owner(actor)?.ok_or("native turret lane owner unavailable")?;b.turret_lane(owner)?};
 let (word,key)=match lane {0=>("bottom","game_announcement_replace_right"),1=>("middle","game_announcement_replace_center"),_=>("top","game_announcement_replace_left")};
 rendered(word,key,form,b)
}
pub fn bind_label_bytes<A:Copy+Eq>(input:&[u8],form:Form,actor:Option<A>,local:Option<A>,b:&mut impl Backend<A>)->Result<Option<Vec<u8>>,&'static str> {
 for kind in [Kind::HaveHas,Kind::DampenerLane,Kind::TurretLane,Kind::TurretLaneOrNexus,Kind::TurretPosition] {
  let pattern=kind.pattern();if kind.registered(form) && input.get(..pattern.len()).is_some_and(|s|s.eq_ignore_ascii_case(pattern)) {return label_bytes(kind,form,actor,local,b).map(Some);}
 }
 Ok(None)
}
#[cfg(test)] mod tests {
 use super::*;use std::collections::BTreeMap;
 struct Provider {kind:u32,lane:u32,owner:bool,values:[u32;2],fields:Vec<&'static str>,getters:Vec<u32>,localized:Vec<&'static str>,translations:BTreeMap<String,String>}
 impl Backend<u32> for Provider {
  type LaneOwner=u32;
  fn turret_kind(&mut self,_:u32)->Result<u32,&'static str> {self.fields.push("kind");Ok(self.kind)}
  fn lane_owner(&mut self,_:u32)->Result<Option<u32>,&'static str> {self.fields.push("lane_owner");Ok(self.owner.then_some(9))}
  fn turret_lane(&mut self,owner:u32)->Result<u32,&'static str> {assert_eq!(owner,9);self.fields.push("lane");Ok(self.lane)}
  fn dampener_lane(&mut self,_:u32)->Result<u32,&'static str> {let value=self.values[self.getters.len()];self.getters.push(value);Ok(value)}
  fn localize(&mut self,key:&'static str)->Result<String,&'static str> {self.localized.push(key);self.translations.get(key).cloned().ok_or("translation unavailable")}
 }
 fn provider(proof:&serde_json::Value,c:&serde_json::Value)->Provider {Provider {kind:c["kind"].as_u64().unwrap_or(0) as u32,lane:c["lane"].as_u64().unwrap_or(0) as u32,owner:true,values:[c["first"].as_u64().unwrap_or(0) as u32,c["second"].as_u64().unwrap_or(0) as u32],fields:vec![],getters:vec![],localized:vec![],translations:proof["translations"].as_object().unwrap().iter().map(|(k,v)|(k.clone(),v.as_str().unwrap().to_owned())).collect()}}
 fn verify(path:&str,count:usize,fixed:bool) {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture(path)).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),count);
  for c in cases {
   let mut p=provider(&proof,c);let actor=c["exists"].as_bool().unwrap().then_some(7);let local=match c["local"].as_str() {Some("self")=>Some(7),Some("other")=>Some(8),_=>None};let form=if c["entry"]=="0x6d4a10" {Form::Plain} else {Form::Localized};
   let out=bind_label_bytes(c["input"].as_str().unwrap().as_bytes(),form,actor,local,&mut p).unwrap().unwrap();
   assert_eq!(out.iter().map(|b|format!("{b:02x}")).collect::<String>(),c["output_hex"].as_str().unwrap(),"{c}");
   assert_eq!(serde_json::json!(p.localized),c["localization_calls"]);
   if fixed {assert_eq!(serde_json::json!(p.getters),c["getter_calls"]);} else {assert_eq!(serde_json::json!(p.fields),c["field_reads"]);}
  }
 }
 #[test] fn audio_turret_labels_match1440_native_dispatch_frames_and_field_read_order() {verify("data/4.20/audio_announcer_turret_labels_contract.json",1440,false);}
 #[test] fn audio_fixed_matchers_match1152_original_have_has_and_dampener_getter_frames() {verify("data/4.20/audio_announcer_fixed_matchers_contract.json",1152,true);}
 #[test] fn audio_labels_unregistered_forms_mismatch_and_missing_lane_owner_are_explicit() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_turret_labels_contract.json")).unwrap();let mut p=provider(&proof,&proof["cases"][0]);p.owner=false;
  assert_eq!(label_bytes(Kind::TurretLane,Form::Plain,Some(7),None,&mut p),Err("native turret lane owner unavailable"));assert_eq!(p.fields,["lane_owner"]);
  assert_eq!(bind_label_bytes(b" turret lane or nexus@",Form::Localized,Some(7),None,&mut p).unwrap(),None);
  assert_eq!(bind_label_bytes(b"not a native pattern",Form::Plain,Some(7),None,&mut p).unwrap(),None);
 }
}
