//! AEF2F0/B014D0 and ordered group consumer AFD970/AFDB30 for finite caches.
use std::collections::{BTreeMap,BTreeSet};
#[derive(Debug,Clone)] pub struct Voice {pub value:f32,pub key:u32}
#[derive(Debug,Clone)] pub struct Group {pub ascending:bool,pub voices:Vec<u32>}
#[derive(Debug,Clone,Default)] pub struct Store {pub voices:BTreeMap<u32,Voice>,pub groups:BTreeMap<u32,Group>}
#[derive(Debug,PartialEq,Eq)] pub enum Error {MissingVoice,MissingGroup,InvalidValue,InvalidGroup,AliasedGroups}
#[derive(Debug,Clone,PartialEq,serde::Serialize)] pub struct Dispatch {pub group:u32,pub voice:u32,pub value_bits:u32}
fn before(a:&Voice,b:&Voice,ascending:bool)->bool{a.value>b.value || (a.value==b.value && if ascending {a.key<b.key}else{a.key>b.key})}
impl Store {
 /// The old cache remains unchanged while all groups are reordered. Equal f32
 /// values, including opposite signed zeros, suppress dispatch and cache writes.
 pub fn transition(&mut self,voice:u32,local:[Option<u32>;2],global:u32,new:f32)->Result<Vec<Dispatch>,Error>{
  let old=self.voices.get(&voice).ok_or(Error::MissingVoice)?.clone();if !new.is_finite() || !old.value.is_finite(){return Err(Error::InvalidValue);}if new==old.value{return Ok(vec![]);}
  let ids:Vec<_>=local.into_iter().flatten().chain([global]).collect();if ids.iter().copied().collect::<BTreeSet<_>>().len()!=ids.len(){return Err(Error::AliasedGroups);}
  for id in &ids {let group=self.groups.get(id).ok_or(Error::MissingGroup)?;let mut keys=BTreeSet::new();for id in &group.voices {let v=self.voices.get(id).ok_or(Error::MissingVoice)?;if !v.value.is_finite(){return Err(Error::InvalidValue);}if !keys.insert(v.key){return Err(Error::InvalidGroup);}}
   if group.voices.windows(2).any(|w|before(&self.voices[&w[1]],&self.voices[&w[0]],group.ascending)){return Err(Error::InvalidGroup);}
  }
  let next=Voice {value:new,key:old.key};let mut calls=Vec::new();
  for id in ids {calls.push(Dispatch {group:id,voice,value_bits:new.to_bits()});let group=self.groups.get_mut(&id).unwrap();if let Some(at)=group.voices.iter().position(|id|{let v=&self.voices[id];v.value==old.value && v.key==old.key}) {group.voices.remove(at);let at=group.voices.iter().position(|id|before(&next,&self.voices[id],group.ascending)).unwrap_or(group.voices.len());group.voices.insert(at,voice);}}
  self.voices.get_mut(&voice).unwrap().value=new;Ok(calls)
 }
}
#[derive(Debug,Clone,PartialEq,serde::Serialize)] #[serde(tag="kind",rename_all="lowercase")]
pub enum Call {Transition {value_bits:u32},Dispatch {group:u32,voice:u32,value_bits:u32}}
pub struct TransitionBackend<'a,B>{pub dependencies:&'a mut B,pub store:&'a mut Store,pub voice:u32,pub local:[Option<u32>;2],pub global:u32,pub calls:Vec<Call>}
impl<B:crate::audio_control_refresh::Backend> crate::audio_control_refresh::Backend for TransitionBackend<'_,B>{
 fn spatial(&mut self,s:&mut crate::audio_control_refresh::State)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.spatial(s)}
 fn optional(&mut self)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.optional()}
 fn flag(&mut self,o:u32)->Result<u8,crate::audio_control_refresh::Error>{self.dependencies.flag(o)}
 fn source(&mut self)->Result<f32,crate::audio_control_refresh::Error>{self.dependencies.source()}
 fn routing(&mut self,s:&mut crate::audio_control_refresh::State)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.routing(s)}
 fn parameters(&mut self,s:&mut crate::audio_control_refresh::State,r:crate::audio_control_refresh::Request)->Result<(),crate::audio_control_refresh::Error>{self.dependencies.parameters(s,r)}
 fn pair(&mut self,o:u32)->Result<[f32;2],crate::audio_control_refresh::Error>{self.dependencies.pair(o)}
 fn transition(&mut self,v:f32)->Result<(),crate::audio_control_refresh::Error>{self.calls.push(Call::Transition {value_bits:v.to_bits()});let calls=self.store.transition(self.voice,self.local,self.global,v).map_err(|_|crate::audio_control_refresh::Error::Backend("priority transition failed"))?;self.calls.extend(calls.into_iter().map(|v|Call::Dispatch {group:v.group,voice:v.voice,value_bits:v.value_bits}));Ok(())}
}
#[cfg(test)] pub(crate) mod tests {
 use super::*;
 pub(crate) fn fixture(row:&serde_json::Value,whole:bool)->Store{let voices_key=if whole {"priority_voices"}else{"voices"};let groups_key=if whole {"priority_groups"}else{"groups"};Store {voices:row[voices_key].as_array().unwrap().iter().map(|v|(v["reference"].as_u64().unwrap() as u32,Voice {value:v["value"].as_f64().unwrap() as f32,key:v["key"].as_u64().unwrap() as u32})).collect(),groups:row[groups_key].as_array().unwrap().iter().map(|v|(v["reference"].as_u64().unwrap() as u32,Group {ascending:v["ascending"].as_bool().unwrap(),voices:v["before"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect()})).collect()}}
 #[test] fn native_transition_and_ordered_consumer_match3072_cases(){let proof:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/audio_priority_transition_contract.json")).unwrap();assert_eq!(proof["case_count"],3072);for (case,row) in proof["cases"].as_array().unwrap().iter().enumerate(){let mut s=fixture(row,false);let voice=row["voice"].as_u64().unwrap() as u32;let local=std::array::from_fn(|i|row["local_groups"][i].as_u64().map(|v|v as u32));let calls=s.transition(voice,local,row["global"].as_u64().unwrap() as u32,f32::from_bits(row["new_bits"].as_u64().unwrap() as u32)).unwrap();assert_eq!(serde_json::json!(calls),row["calls"],"calls {case}");assert_eq!(serde_json::json!(s.voices[&voice].value.to_bits()),row["output_value_bits"],"cache {case}");for g in row["output_groups"].as_array().unwrap(){assert_eq!(serde_json::json!(s.groups[&(g["reference"].as_u64().unwrap() as u32)].voices),g["after"],"order {case}");}}}
 #[test] fn invalid_groups_do_not_partially_change_voice_caches(){let mut s=Store {voices:BTreeMap::from([(1,Voice {value:0.,key:2})]),groups:BTreeMap::from([(3,Group {ascending:false,voices:vec![1]})])};assert_eq!(s.transition(1,[None,None],3,f32::NAN),Err(Error::InvalidValue));assert_eq!(s.transition(1,[Some(3),None],3,10.),Err(Error::AliasedGroups));assert_eq!(s.transition(1,[None,None],4,10.),Err(Error::MissingGroup));assert_eq!(s.voices[&1].value,0.);assert_eq!(s.groups[&3].voices,vec![1]);}
}
