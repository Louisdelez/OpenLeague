//! Native B0EC10/B0EBB0 gain dispatch, B088B0 conversion and spatial/default writes.
use crate::{audio_bus_bank::Error,audio_bus_control_application::{Store,Voice},audio_bus_effects_changed::Graph,audio_bus_properties_bank::Tables,audio_rtpc_manager::Manager};
#[derive(Debug,Clone,serde::Serialize)]#[serde(tag="kind",rename_all="lowercase")]
pub enum Call{Gain{voice:u32,bits:u32},Spatial{node:u32,owner:u32}}
/// Optional observation only; no gameplay operation is replaced by a no-op.
pub trait Observer{fn call(&mut self,call:&Call);fn effect(&mut self,_:&crate::audio_bus_effects_bank::Call){}}
impl Observer for (){fn call(&mut self,_:&Call){}}
pub struct Backend<'a,O>{pub targets:&'a mut Store,pub tables:&'a Tables,pub manager:&'a Manager,pub observer:&'a mut O,pub calls:Vec<Call>}
fn word(v:&Voice,offset:usize)->u32{u32::from_le_bytes(v.raw[offset..offset+4].try_into().unwrap())}
fn set(v:&mut Voice,offset:usize,bits:u32){v.raw[offset..offset+4].copy_from_slice(&bits.to_le_bytes());}
impl<O:Observer>Backend<'_,O>{
 fn emit(&mut self,c:Call){self.observer.call(&c);self.calls.push(c);}
 fn write(&mut self,reference:u32,bits:u32,pointer:u32,g:&Graph)->Result<(),Error>{
  let db=f32::from_bits(bits);let amplitude=crate::audio_gain::amplitude(db).map_err(Error::Backend)?;
  let flags=if pointer==0{0}else{let b=g.buses.get(&pointer).ok_or(Error::UnresolvedReference)?;if b.reference!=pointer || b.word(0)!=0xff1380{return Err(Error::WrongClass);}b.raw[0x2f]};
  self.emit(Call::Gain{voice:reference,bits});let v=self.targets.voices.get_mut(&reference).ok_or(Error::Application(crate::audio_bus_control_application::Error::MissingVoice(reference)))?;
  set(v,0x43c,bits);set(v,0x434,amplitude.to_bits());
  if flags&4==0{v.raw[0x464]&=!1;for(o,value)in [(0x444,0.5f32),(0x448,1.),(0x44c,100.)]{set(v,o,value.to_bits());}v.raw[0x450]=0;return Ok(());}
  v.raw[0x464]|=1;let mut spatial=crate::audio_spatial_controls::Spatial{raw:v.raw[0x444..0x454].try_into().unwrap()};
  self.emit(Call::Spatial{node:pointer,owner:0});let b=&g.buses[&pointer];let mut props=std::collections::BTreeMap::new();
  if b.word(0x28)!=0{let raw=self.tables.values.get(&b.word(0x28)).ok_or(Error::Backend("missing Bus gain spatial table"))?;for key in [11,12,13]{if let Some(v)=crate::audio_bus_gain_aggregation::lookup(raw,key,4)?{props.insert(key,v);}}}
  let node=crate::audio_spatial_controls::Node{reference:pointer,flags2f:flags,props,rtpc_mask:u64::from(b.word(0x30))|(u64::from(b.word(0x34))<<32),attenuation:None};
  crate::audio_spatial_controls::apply(&[node],0,&mut spatial,None,self.manager,&Default::default()).map_err(|_|Error::Backend("Bus gain spatial getter failed"))?;
  self.targets.voices.get_mut(&reference).unwrap().raw[0x444..0x454].copy_from_slice(&spatial.raw);Ok(())
 }
 pub fn root(&mut self,kind:u32,bits:u32,g:&Graph)->Result<(),Error>{
  let selected=if kind as u8!=0{self.targets.roots.iter().find(|r|r.key==[0,0]).map(|r|vec![r.voice]).unwrap_or_default()}else{self.targets.roots.iter().filter(|r|r.key!=[0,0]).map(|r|r.voice).collect()};
  for r in &selected{if !self.targets.voices.contains_key(r){return Err(Error::Application(crate::audio_bus_control_application::Error::MissingVoice(*r)));}}
  for r in selected{self.write(r,bits,0,g)?;}Ok(())
 }
 pub fn bus(&mut self,id:u32,bits:u32,g:&Graph)->Result<(),Error>{
  let mut selected=Vec::new();for r in &self.targets.registered{let v=self.targets.voices.get(r).ok_or(Error::Application(crate::audio_bus_control_application::Error::MissingVoice(*r)))?;let pointer=word(v,0x4d0);let found=if pointer==0{0}else{*self.targets.bus_ids.get(&pointer).ok_or(Error::Application(crate::audio_bus_control_application::Error::MissingBus(pointer)))?};if found==id{selected.push((*r,pointer));}}
  // Mode4D4 is deliberately not filtered: native gain includes mode2.
  for(r,p)in selected{self.write(r,bits,p,g)?;}Ok(())
 }
}
impl<O:Observer>crate::audio_bus_gain_aggregation::Application for Backend<'_,O>{fn root(&mut self,k:u32,b:u32,g:&Graph)->Result<(),Error>{self.root(k,b,g)}fn bus(&mut self,id:u32,b:u32,g:&Graph)->Result<(),Error>{self.bus(id,b,g)}}
#[cfg(test)]mod tests{
 use super::*;use crate::{audio_bus_registry::Bus,audio_bus_control_application::Root};
 #[test]fn audio_bus_gain_application_matches1344_complete_native_target_cases(){
  let p:serde_json::Value=serde_json::from_str(&crate::audio_test_fixture("data/4.20/audio_bus_gain_application_contract.json")).unwrap();assert_eq!(p["case_count"],1344);
  for(case,row)in p["cases"].as_array().unwrap().iter().enumerate(){let mut graph=Graph::default();let mut bus=Bus{reference:0x30001000,raw:[0;200]};bus.set_word(0,0xff1380);bus.set_word(8,1234);bus.set_word(0x28,0x30008000);bus.raw[0x2f]=if row["spatial"]==true{4}else{0};graph.buses.insert(bus.reference,bus);let mut tables=Tables::default();let mut raw=vec![3,11,12,13];for value in [-0.75f32,12.5,7.25]{raw.extend_from_slice(&value.to_le_bytes());}tables.values.insert(0x30008000,raw);
   let mut targets=Store::default();targets.bus_ids.insert(0x30001000,1234);for(i,r)in [0x30002000,0x30003000,0x30004000].into_iter().enumerate(){targets.voices.insert(r,Voice{raw:crate::audio_spatial_controls::tests::hex(row["before"][i].as_str().unwrap())});targets.registered.push(r);targets.roots.push(Root{voice:r,key:[if i==row["first_free"].as_u64().unwrap()as usize{0}else{i as u32+1},0]});}
   let mut observer=();let mut backend=Backend{targets:&mut targets,tables:&tables,manager:&Manager::default(),observer:&mut observer,calls:vec![]};let bits=(row["gain"].as_f64().unwrap()as f32).to_bits();let selector=row["selector"].as_u64().unwrap()as u32;if row["path"]=="root"{backend.root(selector,bits,&graph).unwrap();}else{backend.bus(selector,bits,&graph).unwrap();}assert_eq!(serde_json::json!(backend.calls),row["calls"],"application order {case}");drop(backend);
   for(i,r)in [0x30002000,0x30003000,0x30004000].into_iter().enumerate(){assert_eq!(targets.voices[&r].raw,crate::audio_spatial_controls::tests::hex::<0x500>(row["after"][i].as_str().unwrap()),"voice {case}/{i}");}
  }
 }
 #[test]fn audio_gain_application_missing_target_fails_before_mutation(){let mut targets=Store::default();targets.voices.insert(1,Voice{raw:[0xa5;0x500]});targets.roots=vec![Root{voice:1,key:[1,0]},Root{voice:2,key:[2,0]}];let mut observer=();let mut b=Backend{targets:&mut targets,tables:&Tables::default(),manager:&Manager::default(),observer:&mut observer,calls:vec![]};assert!(b.root(0,0,&Graph::default()).is_err());assert!(b.calls.is_empty());assert_eq!(b.targets.voices[&1].raw,[0xa5;0x500]);}
}
