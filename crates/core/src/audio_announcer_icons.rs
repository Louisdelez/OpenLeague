//! Original stateful announcement icon callbacks. Native storage/CRT boundaries are explicit.
use crate::audio_announcer_actor_wrapper::Form;
use crate::audio_announcer_actor_name::NameStorage;
#[derive(Clone,Copy,Debug,PartialEq,Eq)] pub enum Kind {Icon,RingIcon}
impl Kind {pub fn pattern(self)->&'static [u8] {match self {Self::Icon=>b" icon@",Self::RingIcon=>b" ringicon@"}}}
#[derive(Default,Debug)] pub struct Cache {initialized:bool,bytes:Vec<u8>}
#[derive(Default,Debug)] pub struct Caches {pub icon:Cache,pub ring:Cache}
pub enum ResourceName<'a> {IconCache,Storage(NameStorage<'a>)}
pub trait Backend<A:Copy> {
 type Character:Copy;type Resource:Copy;type Skin:Copy;
 fn flags(&mut self,actor:A)->Result<u32,&'static str>;
 fn character(&mut self,actor:A)->Result<Option<Self::Character>,&'static str>;
 fn primary_resource(&mut self,c:Self::Character)->Result<Option<Self::Resource>,&'static str>;
 fn secondary_resource(&mut self,c:Self::Character)->Result<Option<Self::Resource>,&'static str>;
 fn resource_name(&mut self,r:Self::Resource)->Result<ResourceName<'_>,&'static str>;
 fn skin_owner(&mut self,c:Self::Character)->Result<Option<Self::Skin>,&'static str>;
 fn skin_id(&mut self,s:Self::Skin)->Result<u32,&'static str>;
 fn format_skin_id(&mut self,value:u32)->Result<Vec<u8>,&'static str>;
 fn character_flags(&mut self,c:Self::Character)->Result<u32,&'static str>;
 fn suffix_name(&mut self,c:Self::Character)->Result<NameStorage<'_>,&'static str>;
 fn register_cache(&mut self,kind:Kind)->Result<(),&'static str>;
}
pub fn icon_bytes<A:Copy>(kind:Kind,actor:Option<A>,caches:&mut Caches,b:&mut impl Backend<A>)->Result<Vec<u8>,&'static str> {
 let cache=if kind==Kind::Icon {&mut caches.icon} else {&mut caches.ring};
 if !cache.initialized {cache.initialized=true;cache.bytes=if kind==Kind::Icon {b"None".to_vec()} else {vec![]};b.register_cache(kind)?;}
 if kind==Kind::RingIcon {cache.bytes=b"Default".to_vec();}
 let Some(actor)=actor else {return Ok(cache.bytes.clone());};
 if b.flags(actor)?&0x400==0 {return Ok(cache.bytes.clone());}
 let Some(character)=b.character(actor)? else {return Ok(cache.bytes.clone());};
 if kind==Kind::RingIcon {if b.character_flags(character)?&(1<<23)==0 {cache.bytes.clear();}return Ok(cache.bytes.clone());}
 let resource=match b.primary_resource(character)? {Some(r)=>Some(r),None=>b.secondary_resource(character)?};
 if let Some(resource)=resource {match b.resource_name(resource)? {ResourceName::IconCache=>{},ResourceName::Storage(s)=>cache.bytes=s.nul_bytes()?.to_vec()}}
 cache.bytes.push(b';');
 if let Some(owner)=b.skin_owner(character)? {let id=b.skin_id(owner)?;let bytes=b.format_skin_id(id)?;let end=bytes.iter().position(|&x|x==0).unwrap_or(bytes.len());cache.bytes.extend_from_slice(&bytes[..end]);}
 cache.bytes.push(b';');
 if b.character_flags(character)?&(1<<23)==0 {cache.bytes.extend_from_slice(b.suffix_name(character)?.nul_bytes()?);}
 Ok(cache.bytes.clone())
}
pub fn bind_icon_bytes<A:Copy>(input:&[u8],form:Form,actor:Option<A>,caches:&mut Caches,b:&mut impl Backend<A>)->Result<Option<Vec<u8>>,&'static str> {
 for kind in [Kind::Icon,Kind::RingIcon] {let pattern=kind.pattern();if !(kind==Kind::RingIcon && form==Form::Localized) && input.get(..pattern.len()).is_some_and(|s|s.eq_ignore_ascii_case(pattern)) {return icon_bytes(kind,actor,caches,b).map(Some);}}
 Ok(None)
}
#[cfg(test)] mod tests {
 use super::*;
 struct Provider {flags:u32,has_character:bool,resource:String,skin:Option<u32>,hidden:bool,suffix:Vec<u8>,inline:[u8;16],heap:Vec<u8>,ops:Vec<&'static str>,numeric:Vec<serde_json::Value>,registrations:Vec<&'static str>}
 impl Provider {fn storage(&mut self,bytes:&[u8])->NameStorage<'_> {self.inline=[0;16];self.heap.clear();if bytes.len()<16 {self.inline[..bytes.len()].copy_from_slice(bytes);NameStorage {inline:&self.inline,capacity:15,heap:None}} else {self.heap.extend_from_slice(bytes);self.heap.push(0);NameStorage {inline:&self.inline,capacity:bytes.len() as u32,heap:Some(&self.heap)}}}}
 impl Backend<u32> for Provider {
  type Character=u32;type Resource=u32;type Skin=u32;
  fn flags(&mut self,_:u32)->Result<u32,&'static str> {self.ops.push("flags");Ok(self.flags)}
  fn character(&mut self,_:u32)->Result<Option<u32>,&'static str> {self.ops.push("character");Ok(self.has_character.then_some(8))}
  fn primary_resource(&mut self,_:u32)->Result<Option<u32>,&'static str> {self.ops.push("primary");Ok(match self.resource.as_str() {"primary"|"both"=>Some(9),"cache_alias"=>Some(11),_=>None})}
  fn secondary_resource(&mut self,_:u32)->Result<Option<u32>,&'static str> {self.ops.push("secondary");Ok((self.resource=="secondary").then_some(10))}
  fn resource_name(&mut self,r:u32)->Result<ResourceName<'_>,&'static str> {Ok(if r==11 {ResourceName::IconCache} else {ResourceName::Storage(self.storage(if r==9 {b"PrimaryIcon"} else {b"SecondaryIconLongName"}))})}
  fn skin_owner(&mut self,_:u32)->Result<Option<u32>,&'static str> {self.ops.push("skin_owner");Ok(self.skin.map(|_|12))}
  fn skin_id(&mut self,_:u32)->Result<u32,&'static str> {self.ops.push("skin_id");Ok(self.skin.unwrap())}
  fn format_skin_id(&mut self,value:u32)->Result<Vec<u8>,&'static str> {let output=value.to_string();self.numeric.push(serde_json::json!({"value":value,"format":"%u","capacity":11,"output":output}));Ok(output.into_bytes())}
  fn character_flags(&mut self,_:u32)->Result<u32,&'static str> {self.ops.push("character_flags");Ok(if self.hidden {1<<23} else {0})}
  fn suffix_name(&mut self,_:u32)->Result<NameStorage<'_>,&'static str> {let suffix=self.suffix.clone();Ok(self.storage(&suffix))}
  fn register_cache(&mut self,kind:Kind)->Result<(),&'static str> {self.registrations.push(if kind==Kind::Icon {"0xf99a70"} else {"0xf99af0"});Ok(())}
 }
 #[test] fn audio_icons_match3600_native_sequences10800_frames_cache_alias_primary_fallback_skin_and_ring_rules() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_icons_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),3600);
  for c in cases {let mut caches=Caches::default();let mut p=Provider {flags:c["flags"].as_u64().unwrap() as u32,has_character:c["has_character"].as_bool().unwrap(),resource:c["resource"].as_str().unwrap().to_owned(),skin:c["skin_id"].as_u64().map(|x|x as u32),hidden:c["hidden"].as_bool().unwrap(),suffix:c["suffix"].as_str().unwrap().as_bytes().to_vec(),inline:[0;16],heap:vec![],ops:vec![],numeric:vec![],registrations:vec![]};
   for s in c["steps"].as_array().unwrap() {p.ops.clear();p.numeric.clear();p.registrations.clear();let form=if c["entry"]=="0x6d4a10" {Form::Plain} else {Form::Localized};let actor=s["exists"].as_bool().unwrap().then_some(7);
    let out=bind_icon_bytes(c["input"].as_str().unwrap().as_bytes(),form,actor,&mut caches,&mut p).unwrap().unwrap();assert_eq!(out.iter().map(|b|format!("{b:02x}")).collect::<String>(),s["output_hex"].as_str().unwrap(),"{c}");assert_eq!(serde_json::json!(p.ops),s["ops"]);assert_eq!(serde_json::json!(p.numeric),s["numeric_calls"]);assert_eq!(serde_json::json!(p.registrations),s["atexit_registrations"]);
   }
  }
 }
}
