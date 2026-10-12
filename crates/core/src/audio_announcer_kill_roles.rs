//! Original plain champion kill source/destination formatter callbacks.
use crate::audio_announcer_actor_wrapper::Form;
#[derive(Clone,Copy,Debug,PartialEq,Eq)] pub enum Kind {Source,Destination}
impl Kind {pub fn pattern(self)->&'static [u8] {match self {Self::Source=>b" champion kill source@",Self::Destination=>b" champion kill destination@"}}}
pub trait Backend<A:Copy> {
 fn flags(&mut self,actor:A)->Result<u32,&'static str>;
 fn team(&mut self,actor:A)->Result<u32,&'static str>;
}
pub fn kill_role_bytes<A:Copy+Eq>(kind:Kind,actor:Option<A>,local:Option<A>,mode:u32,b:&mut impl Backend<A>)->Result<Vec<u8>,&'static str> {
 let Some(actor)=actor else {return Ok(vec![]);};
 if Some(actor)==local {return Ok(b"you".to_vec());}
 if kind==Kind::Source {
  let flags=b.flags(actor)?;
  return Ok(if flags&0x1000!=0 {b"hero".to_vec()} else if flags&0x2000!=0 {b"turret".to_vec()} else if flags&0x800!=0 {b"minion".to_vec()} else {vec![]});
 }
 if let Some(local)=local {let team=b.team(actor)?;return Ok(if team==b.team(local)? {b"ally".to_vec()} else {b"enemy".to_vec()});}
 if b.team(actor)?==100 {return Ok(b"blue".to_vec());}
 if b.team(actor)?==200 {return Ok(if mode==2 {b"red".to_vec()} else {b"purple".to_vec()});}
 Ok(vec![])
}
pub fn bind_kill_role_bytes<A:Copy+Eq>(input:&[u8],form:Form,actor:Option<A>,local:Option<A>,mode:u32,b:&mut impl Backend<A>)->Result<Option<Vec<u8>>,&'static str> {
 if form!=Form::Plain {return Ok(None);}
 for kind in [Kind::Source,Kind::Destination] {let pattern=kind.pattern();if input.get(..pattern.len()).is_some_and(|s|s.eq_ignore_ascii_case(pattern)) {return kill_role_bytes(kind,actor,local,mode,b).map(Some);}}
 Ok(None)
}
#[cfg(test)] mod tests {
 use super::*;
 struct Provider {flags:u32,values:[u32;2],fields:Vec<&'static str>,calls:Vec<serde_json::Value>}
 impl Backend<u32> for Provider {
  fn flags(&mut self,_:u32)->Result<u32,&'static str> {self.fields.push("flags");Ok(self.flags)}
  fn team(&mut self,actor:u32)->Result<u32,&'static str> {let value=self.values[self.calls.len()];self.calls.push(serde_json::json!({"owner":actor,"value":value}));Ok(value)}
 }
 #[test] fn audio_kill_roles_match12096_original_dispatch_frames_flags_identity_and_independent_team_getters() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_kill_roles_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),12096);
  for c in cases {
   let actor=c["exists"].as_bool().unwrap().then_some(7);let local=match c["local"].as_str().unwrap() {"none"=>None,"self"=>Some(7),"other"=>Some(8),_=>panic!("native local fixture")};
   let mut p=Provider {flags:c["flags"].as_u64().unwrap() as u32,values:[c["first"].as_u64().unwrap() as u32,c["second"].as_u64().unwrap() as u32],fields:vec![],calls:vec![]};
   let out=bind_kill_role_bytes(c["input"].as_str().unwrap().as_bytes(),Form::Plain,actor,local,c["mode"].as_u64().unwrap() as u32,&mut p).unwrap().unwrap();
   assert_eq!(out.iter().map(|b|format!("{b:02x}")).collect::<String>(),c["output_hex"].as_str().unwrap());assert_eq!(serde_json::json!(p.fields),c["field_reads"]);assert_eq!(serde_json::json!(p.calls),c["getter_calls"]);
   assert_eq!(bind_kill_role_bytes(c["input"].as_str().unwrap().as_bytes(),Form::Localized,actor,local,0,&mut p).unwrap(),None);
  }
 }
}
