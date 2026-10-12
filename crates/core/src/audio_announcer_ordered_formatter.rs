//! Compose the original ordered announcer families through their native-qualified ports.
//! Live actor/facet ownership and template callback registration are separate integration.
use crate::audio_announcer_actor_wrapper::Form;
use crate::{audio_announcer_actor_name as name,audio_announcer_champion_name as champion,audio_announcer_relations as relations,audio_announcer_team_colors as colors,audio_announcer_labels as labels,audio_announcer_kill_roles as kills,audio_announcer_icons as icons,audio_announcer_rendered_styles as rendered,audio_announcer_styles as styles,audio_announcer_value_fields as values};
#[derive(Clone,Copy,Debug,PartialEq,Eq)] pub enum Family {YouName,CharacterName,KillDeath,NoPurple,AlliedCharacterName,Name,HaveHas,YourAlly,Ally,YourTeam,Absolute,Color,Capitalized,TurretLane,TurretPosition,LaneNexus,DampenerLane,Actor,KillSource,KillDestination,Icon,TeamStyle,TeamHexStyle,ObserverHexStyle,GoldStyle,ItemStyle,BodyStyle,Bounty,Champion,RingIcon}
#[derive(Clone,Copy,Debug,PartialEq,Eq)] pub struct Selection {pub ordinal:usize,pub family:Family,pub callback:u32}
const PLAIN:&[(Family,&[u8],u32)]=&[
 (Family::YouName,b" you | name@",0x6d30f0),
 (Family::CharacterName,b" championname@",0x6d37a0),
 (Family::KillDeath,b" killdeathannouncesrc@",0x6d3810),
 (Family::NoPurple,b" teamcolornamenopurple@",0x6d36d0),
 (Family::AlliedCharacterName,b" allychampionname@",0x6d3870),
 (Family::Name,b" name@",0x6d3030),
 (Family::HaveHas,b" have | has@",0x6d31e0),
 (Family::YourAlly,b" blank | your ally | your enemy@",0x6d3490),
 (Family::Ally,b" blank | ally | enemy@",0x6d3560),
 (Family::YourTeam,b" your team | enemy team@",0x6d3630),
 (Family::Absolute,b" your team color | enemy team color@",0x6d3740),
 (Family::Color,b" red | blue@",0x6d38d0),
 (Family::Capitalized,b" red_cap | blue_cap@",0x6d3940),
 (Family::TurretLane,b" turret lane@",0x6d4670),
 (Family::TurretPosition,b" turret position@",0x6d4760),
 (Family::LaneNexus,b" turret lane or nexus@",0x6d46b0),
 (Family::DampenerLane,b" dampener lane@",0x6d45b0),
 (Family::Actor,b" you | hero | minion | turret@",0x6d3240),
 (Family::KillSource,b" champion kill source@",0x6d3300),
 (Family::KillDestination,b" champion kill destination@",0x6d3360),
 (Family::Icon,b" icon@",0x6d47f0),
 (Family::TeamStyle,b" teamcolor@",0x6d3b40),
 (Family::TeamHexStyle,b" teamcolorhex@",0x6d3c10),
 (Family::ObserverHexStyle,b" observercolorhex@",0x6d3d30),
 (Family::GoldStyle,b" goldcolorhex@",0x6d3f10),
 (Family::ItemStyle,b" itemcalloutitemhex@",0x6d40d0),
 (Family::BodyStyle,b" itemcalloutbodyhex@",0x6d4290),
 (Family::Bounty,b" bounty@",0x6d44b0),
 (Family::Champion,b" champion@",0x6d4520),
 (Family::RingIcon,b" ringicon@",0x6d4970),
];
const LOCALIZED:&[(Family,&[u8],u32)]=&[
 (Family::YouName,b" you | name@",0x6d3160),
 (Family::CharacterName,b" championname@",0x6d37a0),
 (Family::KillDeath,b" killdeathannouncesrc@",0x6d3810),
 (Family::AlliedCharacterName,b" allychampionname@",0x6d3870),
 (Family::Name,b" name@",0x6d3090),
 (Family::HaveHas,b" have | has@",0x6d3200),
 (Family::YourAlly,b" blank | your ally | your enemy@",0x6d34f0),
 (Family::Ally,b" blank | ally | enemy@",0x6d35c0),
 (Family::Color,b" red | blue@",0x6d39b0),
 (Family::Capitalized,b" red_cap | blue_cap@",0x6d3a40),
 (Family::TurretLane,b" turret lane@",0x6d4700),
 (Family::TurretPosition,b" turret position@",0x6d47a0),
 (Family::DampenerLane,b" dampener lane@",0x6d4600),
 (Family::Actor,b" you | hero | minion | turret@",0x6d3410),
 (Family::Icon,b" icon@",0x6d4960),
 (Family::TeamStyle,b" teamcolor@",0x6d4450),
 (Family::TeamHexStyle,b" teamcolorhex@",0x6d4460),
 (Family::ObserverHexStyle,b" observercolorhex@",0x6d4470),
 (Family::GoldStyle,b" goldcolorhex@",0x6d4480),
 (Family::ItemStyle,b" itemcalloutitemhex@",0x6d4490),
 (Family::BodyStyle,b" itemcalloutbodyhex@",0x6d44a0),
 (Family::Bounty,b" bounty@",0x6d4500),
 (Family::Champion,b" champion@",0x6d45a0),
];
pub fn select(input:&[u8],form:Form)->Option<Selection> {
 let table=if form==Form::Plain {PLAIN} else {LOCALIZED};
 table.iter().enumerate().find_map(|(ordinal,&(family,pattern,callback))|input.get(..pattern.len()).is_some_and(|p|p.eq_ignore_ascii_case(pattern)).then_some(Selection {ordinal,family,callback}))
}
#[derive(Default)] pub struct Caches {pub icons:icons::Caches,pub styles:styles::Caches,pub values:values::Caches}
pub struct Context<A,M> {pub actor:Option<A>,pub local:Option<A>,pub mode:u32,pub manager:M}
#[derive(Debug,PartialEq,Eq)] pub enum Error {Provider(&'static str),Value(values::Error)}
impl From<&'static str> for Error {fn from(e:&'static str)->Self {Self::Provider(e)}}
impl From<values::Error> for Error {fn from(e:values::Error)->Self {Self::Value(e)}}
pub trait Backend<A:Copy,M:Copy>:name::Backend<A>+champion::TeamBackend<A>+relations::Backend<A>+colors::Backend<A>+labels::Backend<A>+kills::Backend<A>+icons::Backend<A>+rendered::Sources<A,M>+values::Backend<A> {}
impl<A:Copy,M:Copy,B> Backend<A,M> for B where B:name::Backend<A>+champion::TeamBackend<A>+relations::Backend<A>+colors::Backend<A>+labels::Backend<A>+kills::Backend<A>+icons::Backend<A>+rendered::Sources<A,M>+values::Backend<A> {}
fn actor_token<A:Copy+Eq,M:Copy>(form:Form,actor:Option<A>,local:Option<A>,mode:u32,b:&mut impl Backend<A,M>)->Result<Vec<u8>,Error> {
 let b=std::cell::RefCell::new(b);let error=std::cell::RefCell::new(None);
 let flags=|a|match name::Backend::flags(&mut **b.borrow_mut(),a) {Ok(v)=>v,Err(e)=>{*error.borrow_mut()=Some(e);0}};
 let result=if form==Form::Plain {Ok(crate::audio_announcer_actor_tokens::plain_actor_token(actor,local,mode,flags,|a|match colors::Backend::team(&mut **b.borrow_mut(),a) {Ok(v)=>v,Err(e)=>{*error.borrow_mut()=Some(e);0}}).as_bytes().to_vec())} else {crate::audio_announcer_actor_tokens::localized_actor_token(actor,local,flags,|key|name::Backend::localize(&mut **b.borrow_mut(),key)).map(String::into_bytes)};
 if let Some(e)=error.into_inner() {return Err(Error::Provider(e));}Ok(result?)
}
pub fn format_bytes<A:Copy+Eq,M:Copy>(input:&[u8],form:Form,context:Context<A,M>,caches:&mut Caches,b:&mut impl Backend<A,M>)->Result<Vec<u8>,Error> {
 let Context {actor,local,mode,manager}=context;
 let family=select(input,form).map(|s|s.family);
 let mut bytes=match family {
  Some(Family::YouName)=>name::you_or_name_bytes(actor,local,form,b)?,
  Some(Family::CharacterName)=>champion::champion_name_bytes(actor,b)?,
  Some(Family::AlliedCharacterName)=>champion::allied_champion_name_bytes(actor,local,b)?,
  Some(Family::Name)=>name::name_bytes(actor,form,b)?,
  Some(Family::YourAlly)=>relations::relation_bytes(relations::Kind::YourAlly,form,actor,local,b)?,
  Some(Family::Ally)=>relations::relation_bytes(relations::Kind::Ally,form,actor,local,b)?,
  Some(Family::KillDeath)=>relations::relation_bytes(relations::Kind::KillDeathAnnounce,form,actor,local,b)?,
  Some(Family::NoPurple)=>colors::color_bytes(colors::Kind::NoPurple,form,actor,local,mode,b)?,
  Some(Family::Absolute)=>colors::color_bytes(colors::Kind::Absolute,form,actor,local,mode,b)?,
  Some(Family::Color)=>colors::color_bytes(colors::Kind::Color,form,actor,local,mode,b)?,
  Some(Family::Capitalized)=>colors::color_bytes(colors::Kind::Capitalized,form,actor,local,mode,b)?,
  Some(Family::HaveHas)=>labels::label_bytes(labels::Kind::HaveHas,form,actor,local,b)?,
  Some(Family::DampenerLane)=>labels::label_bytes(labels::Kind::DampenerLane,form,actor,local,b)?,
  Some(Family::TurretLane)=>labels::label_bytes(labels::Kind::TurretLane,form,actor,local,b)?,
  Some(Family::TurretPosition)=>labels::label_bytes(labels::Kind::TurretPosition,form,actor,local,b)?,
  Some(Family::LaneNexus)=>labels::label_bytes(labels::Kind::TurretLaneOrNexus,form,actor,local,b)?,
  Some(Family::Actor)=>actor_token(form,actor,local,mode,b)?,
  Some(Family::YourTeam)=>{let mut error=None;let v=crate::audio_announcer_team_tokens::team_token(actor,local,mode,|a|match colors::Backend::team(b,a) {Ok(v)=>v,Err(e)=>{error=Some(e);0}});if let Some(e)=error {return Err(Error::Provider(e));}v.as_bytes().to_vec()},
  Some(Family::KillSource)=>kills::kill_role_bytes(kills::Kind::Source,actor,local,mode,b)?,
  Some(Family::KillDestination)=>kills::kill_role_bytes(kills::Kind::Destination,actor,local,mode,b)?,
  Some(Family::Icon)=>icons::icon_bytes(icons::Kind::Icon,actor,&mut caches.icons,b)?,
  Some(Family::RingIcon)=>icons::icon_bytes(icons::Kind::RingIcon,actor,&mut caches.icons,b)?,
  Some(Family::TeamStyle|Family::TeamHexStyle|Family::ObserverHexStyle|Family::GoldStyle|Family::ItemStyle|Family::BodyStyle)=>rendered::bind_plain_c_style_bytes(input,form,actor,local,manager,&mut caches.styles,b)?.ok_or("selected style registration unavailable")?,
  Some(Family::Bounty)=>values::value(values::Kind::Bounty,actor,&mut caches.values,b)?.bytes,
  Some(Family::Champion)=>values::value(values::Kind::Champion,actor,&mut caches.values,b)?.bytes,
  None=>name::exhausted_fallback_bytes(actor,b)?,
 };
 // The original dispatcher computes strlen before its output insertion.
 if let Some(n)=bytes.iter().position(|&c|c==0) {bytes.truncate(n);}Ok(bytes)
}

#[derive(Debug,PartialEq,Eq)] pub enum RegisteredError {Registry(crate::audio_announcer_object_lookup::Error),Formatter(Error)}
pub struct RegistryContext<M> {pub registry_manager:u32,pub local:Option<u32>,pub mode:u32,pub ui_manager:M}
pub fn format_registered_bytes<M:Copy,B:Backend<u32,M>,R:crate::audio_announcer_object_lookup::Memory>(input:&[u8],id:u32,form:Form,context:RegistryContext<M>,caches:&mut Caches,memory:&mut R,backend:&mut B)->Result<Vec<u8>,RegisteredError> {
 struct Bridge<'a,M,B,R> {context:RegistryContext<M>,caches:&'a mut Caches,memory:&'a mut R,backend:&'a mut B}
 impl<M:Copy,B:Backend<u32,M>,R:crate::audio_announcer_object_lookup::Memory> crate::audio_announcer_actor_wrapper::ByteBackend for Bridge<'_,M,B,R> {
  type Actor=u32;type Error=RegisteredError;
  fn lookup(&mut self,id:u32)->Result<Option<u32>,RegisteredError> {let actor=crate::audio_announcer_object_lookup::lookup_initialized(self.memory,self.context.registry_manager,id).map_err(RegisteredError::Registry)?;Ok((actor!=0).then_some(actor))}
  fn dispatch_bytes(&mut self,form:Form,input:&[u8],actor:u32)->Result<Vec<u8>,RegisteredError> {format_bytes(input,form,Context {actor:Some(actor),local:self.context.local,mode:self.context.mode,manager:self.context.ui_manager},self.caches,self.backend).map_err(RegisteredError::Formatter)}
 }
 crate::audio_announcer_actor_wrapper::format_bytes(input,id,form,&mut Bridge {context,caches,memory,backend})
}
#[cfg(test)] #[allow(unused_variables)] mod tests {
 use super::*;
 #[test] fn audio_ordered_family_selection_matches252_original_dispatcher_and_fixed_matcher_frames() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_ordered_selection_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),252);
  for c in cases {let s=c["input_hex"].as_str().unwrap();let bytes:Vec<_>=(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect();let form=if c["form"]=="plain" {Form::Plain} else {Form::Localized};let selection=select(&bytes,form);assert_eq!(selection.map(|s|s.ordinal as u64),c["selected_ordinal"].as_u64());let callback=selection.map_or(0x6d3030,|s|s.callback);assert_eq!(format!("{callback:#x}"),c["callback"].as_str().unwrap());}
 }
 fn decode(s:&str)->Vec<u8> {(0..s.len()).step_by(2).map(|i|u8::from_str_radix(&s[i..i+2],16).unwrap()).collect()}
 struct Provider {world:Option<serde_json::Value>,translations:Option<std::sync::Arc<std::collections::BTreeMap<String,String>>>,registrations:Vec<String>,flags:u32,bits:u32,name:Option<Vec<u8>>,errno:u32,last_error:u32,ops:Vec<serde_json::Value>}
 impl values::Backend<u32> for Provider {
  fn flags(&mut self,_:u32)->u32 {self.flags}
  fn bounty_bits(&mut self,_:u32)->Result<u32,&'static str> {self.ops.push(serde_json::json!({"op":"bounty_getter"}));Ok(self.bits)}
  fn champion_name_storage(&mut self,_:u32)->Result<Option<Vec<u8>>,&'static str> {self.ops.push(if self.name.is_some() {serde_json::json!({"op":"champion_getter"})} else {serde_json::json!({"op":"champion_getter","result":null})});Ok(self.name.clone())}
  fn set_errno(&mut self,v:u32)->Result<(),&'static str> {self.errno=v;Ok(())}
  fn invalid_parameter(&mut self)->Result<(),&'static str> {self.ops.push(serde_json::json!({"op":"invalid_parameter","args":[0,0,0,0,0]}));Ok(())}
  fn missing_champion_diagnostic(&mut self,label:&[u8])->Result<(),&'static str> {self.ops.push(serde_json::json!({"op":"diagnostic","format_hex":label.iter().map(|b|format!("{b:02x}")).collect::<String>(),"args":[17324845,0,17324845]}));Ok(())}
  fn last_error(&mut self)->u32 {self.ops.push(serde_json::json!({"op":"GetLastError","result":self.last_error}));self.last_error}
 }
 fn provider(c:&serde_json::Value)->Provider {let mut name=c["name_hex"].as_str().map(decode);if let Some(n)=name.as_mut() {n.push(0);}Provider {world:None,translations:None,registrations:Vec::new(),flags:c["flags"].as_u64().unwrap() as u32,bits:c["float_bits_hex"].as_str().map(|s|u32::from_le_bytes(decode(s).try_into().unwrap())).unwrap_or(0),name,errno:0,last_error:c["last_error"].as_u64().unwrap_or(97) as u32,ops:Vec::new()}}
 const PLAYER: [u8;16]=[80,108,97,121,101,114,78,97,109,101,0,0,0,0,0,0];
 const CHARACTER: [u8;16]=[67,104,97,114,97,99,116,101,114,78,97,109,101,0,0,0];
 const FALLBACK: [u8;16]=[70,97,108,108,98,97,99,107,78,97,109,101,0,0,0,0];
 const ICON: [u8;16]=[80,114,105,109,97,114,121,73,99,111,110,0,0,0,0,0];
 const PORTRAIT: [u8;16]=[80,111,114,116,114,97,105,116,0,0,0,0,0,0,0,0];
 fn storage(inline:&'static [u8;16])->name::NameStorage<'static> {name::NameStorage {inline,capacity:15,heap:None}}
 impl Provider {
  fn number(&self,key:&str)->Result<u32,&'static str> {self.world.as_ref().and_then(|v|v[key].as_u64()).map(|v|v as u32).ok_or("world numeric storage unavailable")}
  fn boolean(&self,key:&str)->Result<bool,&'static str> {self.world.as_ref().and_then(|v|v[key].as_bool()).ok_or("world boolean storage unavailable")}
  fn team_value(&self,actor:u32)->Result<u32,&'static str> {self.number(if actor==1 || actor==0x30001000 {"team"} else {"local_team"})}
  fn localized(&self,key:&str)->Result<String,&'static str> {self.translations.as_ref().and_then(|v|v.get(key)).cloned().ok_or("original translation unavailable")}
 }
 impl name::Backend<u32> for Provider {
  fn flags(&mut self,actor:u32)->Result<u32,&'static str> {Ok(self.flags)}
  fn converted_name(&mut self,actor:u32)->Result<name::NameStorage<'_>,&'static str> {Ok(storage(&PLAYER))}
  fn localize(&mut self,key:&'static str)->Result<String,&'static str> {self.localized(key)}
 }
 impl champion::Backend<u32> for Provider {
  type Character=u32;
  fn flags(&mut self,actor:u32)->Result<u32,&'static str> {Ok(self.flags)}
  fn character(&mut self,actor:u32)->Result<Option<Self::Character>,&'static str> {Ok(self.boolean("has_character")?.then_some(3))}
  fn gate_byte(&mut self,character:Self::Character)->Result<u8,&'static str> {Ok(1)}
  fn character_name(&mut self,character:Self::Character)->Result<name::NameStorage<'_>,&'static str> {Ok(storage(&CHARACTER))}
  fn fallback_name(&mut self,actor:u32)->Result<name::NameStorage<'_>,&'static str> {Ok(storage(&FALLBACK))}
 }
 impl champion::TeamBackend<u32> for Provider {
  fn team(&mut self,actor:u32)->Result<u32,&'static str> {self.team_value(actor)}
 }
 impl relations::Backend<u32> for Provider {
  fn team(&mut self,actor:u32)->Result<u32,&'static str> {self.team_value(actor)}
  fn localize(&mut self,key:&'static str)->Result<String,&'static str> {self.localized(key)}
 }
 impl colors::Backend<u32> for Provider {
  fn team(&mut self,actor:u32)->Result<u32,&'static str> {self.team_value(actor)}
  fn localize(&mut self,key:&'static str)->Result<String,&'static str> {self.localized(key)}
 }
 impl labels::Backend<u32> for Provider {
  type LaneOwner=u32;
  fn turret_kind(&mut self,actor:u32)->Result<u32,&'static str> {self.number("kind")}
  fn lane_owner(&mut self,actor:u32)->Result<Option<Self::LaneOwner>,&'static str> {Ok(Some(4))}
  fn turret_lane(&mut self,owner:Self::LaneOwner)->Result<u32,&'static str> {self.number("lane")}
  fn dampener_lane(&mut self,actor:u32)->Result<u32,&'static str> {self.number("lane")}
  fn localize(&mut self,key:&'static str)->Result<String,&'static str> {self.localized(key)}
 }
 impl kills::Backend<u32> for Provider {
  fn flags(&mut self,actor:u32)->Result<u32,&'static str> {Ok(self.flags)}
  fn team(&mut self,actor:u32)->Result<u32,&'static str> {self.team_value(actor)}
 }
 impl icons::Backend<u32> for Provider {
  type Character=u32;
  type Resource=u32;
  type Skin=u32;
  fn flags(&mut self,actor:u32)->Result<u32,&'static str> {Ok(self.flags)}
  fn character(&mut self,actor:u32)->Result<Option<Self::Character>,&'static str> {Ok(self.boolean("has_character")?.then_some(3))}
  fn primary_resource(&mut self,c:Self::Character)->Result<Option<Self::Resource>,&'static str> {Ok(self.boolean("has_resource")?.then_some(5))}
  fn secondary_resource(&mut self,c:Self::Character)->Result<Option<Self::Resource>,&'static str> {Ok(None)}
  fn resource_name(&mut self,r:Self::Resource)->Result<icons::ResourceName<'_>,&'static str> {Ok(icons::ResourceName::Storage(storage(&ICON)))}
  fn skin_owner(&mut self,c:Self::Character)->Result<Option<Self::Skin>,&'static str> {Ok(Some(6))}
  fn skin_id(&mut self,s:Self::Skin)->Result<u32,&'static str> {Ok(42)}
  fn format_skin_id(&mut self,value:u32)->Result<Vec<u8>,&'static str> {Ok(value.to_string().into_bytes())}
  fn character_flags(&mut self,c:Self::Character)->Result<u32,&'static str> {Ok(if self.boolean("hidden")? {1<<23} else {0})}
  fn suffix_name(&mut self,c:Self::Character)->Result<name::NameStorage<'_>,&'static str> {Ok(storage(&PORTRAIT))}
  fn register_cache(&mut self,kind:icons::Kind)->Result<(),&'static str> {self.registrations.push(match kind {icons::Kind::Icon=>"0xf99a70",icons::Kind::RingIcon=>"0xf99af0"}.into());Ok(())}
 }
 impl crate::audio_announcer_palettes::Backend<u32,u32> for Provider {
  fn local_raw_team(&mut self,actor:u32)->Result<u32,&'static str> {self.number("local_team")}
  fn spectator_raw(&mut self)->Result<u32,&'static str> {self.number("spectator_raw")}
  fn palette_field(&mut self,manager:u32,offset:u32)->Result<u32,&'static str> {self.world.as_ref().and_then(|c|c["fields"][offset.to_string()].as_u64()).map(|v|v as u32).ok_or("original palette storage unavailable")}
 }
 impl rendered::Sources<u32,u32> for Provider {
  fn actor_team(&mut self,actor:u32)->Result<u32,&'static str> {self.team_value(actor)}
  fn register_style_cache(&mut self,kind:styles::Kind)->Result<(),&'static str> {self.registrations.push(match kind {styles::Kind::Team=>"0xf99770",styles::Kind::TeamHex=>"0xf997f0",styles::Kind::ObserverHex=>"0xf99870",styles::Kind::GoldHex=>"0xf998f0",styles::Kind::ItemHex=>"0xf99970",styles::Kind::BodyHex=>"0xf999f0"}.into());Ok(())}
  fn moved_style_temporary_cleanup(&mut self)->Result<(),&'static str> {Ok(())}
 }

 #[test] fn audio_whole_ordered_value_composition_matches576_native_dispatcher_field_and_crt_frames() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_registered_value_fields_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),576);
  for c in cases {let mut p=provider(c);let mut caches=Caches::default();let form=if c["entry"]=="0x6d4a10" {Form::Plain} else {Form::Localized};let result=format_bytes(&decode(c["input_hex"].as_str().unwrap()),form,Context {actor:c["actor_present"].as_bool().unwrap().then_some(1),local:None,mode:2,manager:1},&mut caches,&mut p).unwrap();assert_eq!(result,decode(c["output_hex"].as_str().unwrap()),"{c}");let expected:Vec<_>=c["ops"].as_array().unwrap().iter().filter(|o|o["op"]!="DecodePointer" && o["op"]!="EncodePointer").cloned().collect();assert_eq!(p.ops,expected,"{c}");}
 }

 #[test] fn audio_whole_ordered_formatter_matches1776_original_shared_cache_actor_and_all_family_sequences() {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_whole_formatter_contract.json")).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),1776);let translations:std::collections::BTreeMap<String,String>=serde_json::from_value(proof["translations"].clone()).unwrap();let translations=std::sync::Arc::new(translations);let mut epoch=None;let mut caches=Caches::default();
  for c in cases {let current=c["epoch"].as_u64().unwrap();if epoch!=Some(current) {caches=Caches::default();epoch=Some(current);}let mut p=provider(c);p.world=Some(c.clone());p.translations=Some(translations.clone());p.bits=2.5f32.to_bits();p.name=Some(b"UnitChampion\0".to_vec());let local=match c["local"].as_str().unwrap() {"none"=>None,"self"=>Some(1),"other"=>Some(2),_=>panic!("native local")};let form=if c["entry"]=="0x6d4a10" {Form::Plain} else {Form::Localized};let result=format_bytes(&decode(c["input_hex"].as_str().unwrap()),form,Context {actor:c["exists"].as_bool().unwrap().then_some(1),local,mode:c["mode"].as_u64().unwrap() as u32,manager:1},&mut caches,&mut p).unwrap();assert_eq!(result,decode(c["output_hex"].as_str().unwrap()),"{c}");assert_eq!(serde_json::json!(p.registrations),c["atexit_registrations"],"{c}");}
 }

 fn compare_registered_proof(filename:&str,count:usize,outer:bool) {
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture(&format!("data/4.20/{filename}"))).unwrap();let cases=proof["cases"].as_array().unwrap();assert_eq!(cases.len(),count);let translations:std::collections::BTreeMap<String,String>=serde_json::from_value(proof["translations"].clone()).unwrap();let translations=std::sync::Arc::new(translations);let actor=proof["actor"].as_u64().unwrap() as u32;let local_actor=proof["local_actor"].as_u64().unwrap() as u32;let manager=proof["registry_layout"]["manager"].as_u64().unwrap() as u32;
  struct Words(std::collections::BTreeMap<u32,u32>);impl crate::audio_announcer_object_lookup::Memory for Words {fn word(&mut self,a:u32)->Result<u32,crate::audio_announcer_object_lookup::Error> {self.0.get(&a).copied().ok_or(crate::audio_announcer_object_lookup::Error::MissingWord(a))}}
  impl crate::audio_announcer_outer_callbacks::ContextMemory for Words {fn local_actor_id(&mut self,_:u32)->Result<u32,&'static str> {Err("local ID not requested in this composed fixture")}}
  let mut memory=Words(proof["registry_layout"]["words"].as_array().unwrap().iter().map(|w|(w[0].as_u64().unwrap() as u32,w[1].as_u64().unwrap() as u32)).collect());let mut epoch=None;let mut caches=Caches::default();
  for c in cases {let current=c["epoch"].as_u64().unwrap();if epoch!=Some(current) {caches=Caches::default();epoch=Some(current);}let mut p=provider(c);p.world=Some(c.clone());p.translations=Some(translations.clone());p.bits=2.5f32.to_bits();p.name=Some(b"UnitChampion\0".to_vec());let local=match c["local"].as_str().unwrap() {"none"=>None,"self"=>Some(actor),"other"=>Some(local_actor),_=>panic!("native local")};let form=if c["entry"]=="0x6e9da0" {Form::Plain} else {Form::Localized};let input=decode(c["input_hex"].as_str().unwrap());let key=c["key"].as_u64().unwrap() as u32;let context=RegistryContext {registry_manager:manager,local,mode:c["mode"].as_u64().unwrap() as u32,ui_manager:1};let result=if outer {use crate::audio_announcer_outer_callbacks as callback;let role=if c["exists"].as_bool().unwrap() {"src"} else {"dest"};let binding=if form==Form::Localized {format!("{role}tr")} else {role.to_owned()};let selected=callback::registered_actor_callback((current%167) as u32,binding.as_bytes()).unwrap();memory.0.insert(0x35000004,key);memory.0.insert(0x35000008,0x35000020);memory.0.insert(0x35000020,key);callback::format_callback_bytes(&input,selected,0x35000000,context,&mut caches,&mut memory,&mut p).unwrap()} else {format_registered_bytes(&input,key,form,context,&mut caches,&mut memory,&mut p).unwrap()};assert_eq!(result,decode(c["output_hex"].as_str().unwrap()),"{c}");assert_eq!(serde_json::json!(p.registrations),c["atexit_registrations"],"{c}");}
 }

 #[test] fn audio_registered_whole_wrapper_matches4752_original_registry_prefix_and_all_family_frames() {compare_registered_proof("audio_announcer_whole_wrapper_contract.json",4752,false);}
 #[test] fn audio_named_outer_callbacks_compose_with4752_original_registry_and_full_formatter_frames() {compare_registered_proof("audio_announcer_whole_wrapper_contract.json",4752,true);}
 #[test] fn audio_fresh_owned_registry_callback_matches2376_original_missing_id_frames() {
  use crate::audio_announcer_registry_init::{OwnedMemory,State,Storage};use crate::audio_announcer_outer_callbacks as callback;
  struct World(OwnedMemory);
  impl crate::audio_announcer_object_lookup::Memory for World {fn word(&mut self,a:u32)->Result<u32,crate::audio_announcer_object_lookup::Error> {self.0.word(a)}}
  impl Storage for World {fn allocate(&mut self,n:u32)->Result<u32,crate::audio_announcer_registry_init::Error> {self.0.allocate(n)}fn write_word(&mut self,a:u32,v:u32)->Result<(),crate::audio_announcer_registry_init::Error> {self.0.write_word(a,v)}fn write_byte(&mut self,a:u32,v:u8)->Result<(),crate::audio_announcer_registry_init::Error> {self.0.write_byte(a,v)}fn register_shutdown(&mut self,c:u32)->Result<(),crate::audio_announcer_registry_init::Error> {self.0.register_shutdown(c)}}
  impl callback::ContextMemory for World {fn local_actor_id(&mut self,_:u32)->Result<u32,&'static str> {panic!("source callback must not request local ID")}}
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_whole_wrapper_contract.json")).unwrap();let mut compared=0;
  for c in proof["cases"].as_array().unwrap().iter().filter(|c|c["key"]==999) {
   let mut memory=World(OwnedMemory::new(0x36000000,0));let message=memory.allocate(12).unwrap();memory.write_word(message+4,999).unwrap();let mut state=State::default();let mut caches=Caches::default();let mut p=provider(c);let selected=callback::registered_actor_callback(0,if c["entry"]=="0x6e9da0" {b"src"} else {b"srctr"}).unwrap();
   let result=callback::format_live_callback_bytes(&decode(c["input_hex"].as_str().unwrap()),selected,message,RegistryContext {registry_manager:0,local:None,mode:0,ui_manager:1},&mut state,0,&mut caches,&mut memory,&mut p).unwrap();assert_eq!(result,decode(c["output_hex"].as_str().unwrap()));assert_eq!(memory.0.allocations.len(),4);assert_eq!(memory.0.shutdown_callbacks,vec![0x6653b0]);assert!(p.ops.is_empty());compared+=1;
  }assert_eq!(compared,2376);
 }
 #[test] fn audio_admitted_owned_actor_registry_matches4752_original_all_family_callback_frames() {
  use crate::audio_announcer_registry_init::{OwnedMemory,State,Storage};use crate::audio_announcer_outer_callbacks as callback;use crate::audio_announcer_actor_admission as admission;use crate::audio_announcer_registry_remove as removal;
  struct World(OwnedMemory);impl crate::audio_announcer_object_lookup::Memory for World {fn word(&mut self,a:u32)->Result<u32,crate::audio_announcer_object_lookup::Error> {self.0.word(a)}}
  impl Storage for World {fn allocate(&mut self,n:u32)->Result<u32,crate::audio_announcer_registry_init::Error> {self.0.allocate(n)}fn write_word(&mut self,a:u32,v:u32)->Result<(),crate::audio_announcer_registry_init::Error> {self.0.write_word(a,v)}fn write_byte(&mut self,a:u32,v:u8)->Result<(),crate::audio_announcer_registry_init::Error> {self.0.write_byte(a,v)}fn register_shutdown(&mut self,c:u32)->Result<(),crate::audio_announcer_registry_init::Error> {self.0.register_shutdown(c)}}
  impl removal::Backend for World {fn write_word(&mut self,a:u32,v:u32)->Result<(),removal::Error> {removal::Backend::write_word(&mut self.0,a,v)}fn deallocator(&mut self)->Result<removal::Deallocator,removal::Error> {self.0.deallocator()}fn free(&mut self,n:u32,d:removal::Deallocator)->Result<(),removal::Error> {self.0.free(n,d)}}
  impl callback::ContextMemory for World {fn local_actor_id(&mut self,_:u32)->Result<u32,&'static str> {panic!("source callback cannot request local ID")}}
  struct Ids;impl admission::IdProvider for Ids {fn actor_id(&mut self,_:u32)->Result<u32,&'static str> {Ok(42)}fn invalid_id_diagnostic(&mut self)->Result<(),&'static str> {panic!("valid ID must not diagnose")}}
  let proof:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_announcer_whole_wrapper_contract.json")).unwrap();let translations:std::collections::BTreeMap<String,String>=serde_json::from_value(proof["translations"].clone()).unwrap();let translations=std::sync::Arc::new(translations);let actor=proof["actor"].as_u64().unwrap() as u32;let local_actor=proof["local_actor"].as_u64().unwrap() as u32;
  let mut epoch=None;let mut memory=World(OwnedMemory::new(0x36000000,0));let mut state=State::default();let mut message=0;let mut caches=Caches::default();let mut compared=0;
  for c in proof["cases"].as_array().unwrap() {
   let current=c["epoch"].as_u64().unwrap();if epoch!=Some(current) {memory=World(OwnedMemory::new(0x36000000,0));state=State::default();admission::admit_actor(&mut memory,&mut state,0,actor,u32::MAX,&mut Ids).unwrap();message=memory.allocate(12).unwrap();caches=Caches::default();epoch=Some(current);}
   Storage::write_word(&mut memory,message+4,c["key"].as_u64().unwrap() as u32).unwrap();let mut p=provider(c);p.world=Some(c.clone());p.translations=Some(translations.clone());p.bits=2.5f32.to_bits();p.name=Some(b"UnitChampion\0".to_vec());let local=match c["local"].as_str().unwrap() {"none"=>None,"self"=>Some(actor),"other"=>Some(local_actor),_=>panic!("native local")};let selected=callback::registered_actor_callback(0,if c["entry"]=="0x6e9da0" {b"src"} else {b"srctr"}).unwrap();
   let result=callback::format_live_callback_bytes(&decode(c["input_hex"].as_str().unwrap()),selected,message,RegistryContext {registry_manager:0,local,mode:c["mode"].as_u64().unwrap() as u32,ui_manager:1},&mut state,0,&mut caches,&mut memory,&mut p).unwrap();assert_eq!(result,decode(c["output_hex"].as_str().unwrap()),"{c}");assert_eq!(serde_json::json!(p.registrations),c["atexit_registrations"]);compared+=1;
  }assert_eq!(compared,4752);
 }
 #[test] fn audio_registered_wrapper_long_prefix_matches16_original_4097_8192byte_ascii_and_raw_frames() {compare_registered_proof("audio_announcer_long_prefix_contract.json",16,false);}
}

#[cfg(test)] mod outer_composition_tests {
}
