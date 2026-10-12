//! B1CAF0 bound-source pointer lookup and unchanged source field20.
use std::collections::BTreeMap;
#[derive(Debug,Clone,Copy)] pub struct Binding {pub id:u32,pub source:u32}
#[derive(Debug,Default)] pub struct Registry {pub values:BTreeMap<u32,f32>}
#[derive(Debug,PartialEq)] pub enum Error {MissingBinding,MissingSource,InvalidValue}
#[derive(Debug,serde::Serialize)] #[serde(tag="kind",rename_all="lowercase")] pub enum Call {Source}
pub fn lookup(bindings:&[Binding],source:u32,registry:&Registry)->Result<f32,Error>{
 if !bindings.iter().any(|b|b.source==source){return Err(Error::MissingBinding);}
 let value=*registry.values.get(&source).ok_or(Error::MissingSource)?;
 if !value.is_finite(){return Err(Error::InvalidValue);}Ok(value)
}
pub struct SourceBackend<'a,B>{pub dependencies:&'a mut B,pub bindings:&'a [Binding],pub source_reference:u32,pub registry:&'a Registry,pub calls:Vec<Call>}
impl<B:crate::audio_control_refresh::Backend> crate::audio_control_refresh::Backend for SourceBackend<'_,B>{
 fn spatial(&mut self,s:&mut crate::audio_control_refresh::State)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.spatial(s)}
 fn optional(&mut self)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.optional()}
 fn flag(&mut self,o:u32)->Result<u8,crate::audio_control_refresh::Error>{self.dependencies.flag(o)}
 fn source(&mut self)->Result<f32,crate::audio_control_refresh::Error>{self.calls.push(Call::Source);lookup(self.bindings,self.source_reference,self.registry).map_err(|_|crate::audio_control_refresh::Error::Backend("unresolved or invalid source control"))}
 fn routing(&mut self,s:&mut crate::audio_control_refresh::State)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.routing(s)}
 fn parameters(&mut self,s:&mut crate::audio_control_refresh::State,r:crate::audio_control_refresh::Request)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.parameters(s,r)}
 fn pair(&mut self,o:u32)->Result<[f32;2],crate::audio_control_refresh::Error>{self.dependencies.pair(o)}
 fn transition(&mut self,v:f32)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.transition(v)}
}
#[cfg(test)] pub(crate) mod tests {
 use super::*;
 pub(crate) fn fixture(entries:&serde_json::Value)->(Vec<Binding>,Registry){let bindings=entries.as_array().unwrap().iter().map(|v|Binding{id:v["id"].as_u64().unwrap() as u32,source:v["source"].as_u64().unwrap() as u32}).collect();let values=entries.as_array().unwrap().iter().map(|v|(v["source"].as_u64().unwrap() as u32,f32::from_bits(v["value_bits"].as_u64().unwrap() as u32))).collect();(bindings,Registry{values})}
 #[test] fn audio_native_source_lookup_matches24_cases(){let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_source_control_contract.json")).unwrap();assert_eq!(proof["case_count"],24);for row in proof["cases"].as_array().unwrap(){let (bindings,registry)=fixture(&row["entries"]);assert_eq!(lookup(&bindings,row["source"].as_u64().unwrap() as u32,&registry).unwrap().to_bits() as u64,row["result_bits"].as_u64().unwrap());}}
 #[test] fn audio_unresolved_source_is_explicit_and_preserves_signed_zero(){let b=[Binding{id:1,source:7}];let mut r=Registry::default();assert_eq!(lookup(&[],7,&r),Err(Error::MissingBinding));assert_eq!(lookup(&b,7,&r),Err(Error::MissingSource));for v in [f32::NAN,f32::INFINITY,f32::NEG_INFINITY]{r.values.insert(7,v);assert_eq!(lookup(&b,7,&r),Err(Error::InvalidValue));}r.values.insert(7,-0.);assert_eq!(lookup(&b,7,&r).unwrap().to_bits(),0x80000000);assert_eq!(lookup(&b,8,&r),Err(Error::MissingBinding));}
}
