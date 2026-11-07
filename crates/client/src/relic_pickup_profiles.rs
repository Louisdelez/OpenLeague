//! Native pickup definition adapter. Owner/instance/force producers stay explicit.
use crate::relic_pickup_simulation::{Definition,Parameters};
use openleague_core::{native_scalar_parameter::ScalarParameter,
 native_simple_rotation_list as rotations,native_simple_birth_factors as factors,
 native_particle_force_graph as graph,native_probability_curve::ProbabilityCurve,
 native_simple_particle_update as particles};
use serde_json::Value;

#[derive(Clone)]pub struct Rotation {pub parameter:ScalarParameter,pub axis:[u32;3]}
#[derive(Clone)]pub struct Profile {pub index:usize,pub effect:String,pub group:String,pub parameters:Parameters,
 pub rotations:Vec<Rotation>,definition:Value}
/// Values whose actual instance/owner production is outside the source adapter.
pub struct Instance<'a> {pub life:f32,pub resource_flags:u8,pub factors:factors::Sources<'a>,
 pub force_resource:u32,pub forces:Option<&'a graph::Input<'a>>,pub reset_value:u32,pub manager_flag:Option<u8>,
 pub definition_kind:u32,pub rate_factor:f32,pub position:[u32;3],pub position_probabilities:[Option<&'a ProbabilityCurve>;3]}
fn word(v:&Value)->Result<u32,String>{v.as_u64().and_then(|v|u32::try_from(v).ok()).ok_or_else(||"native pickup word absent".into())}
fn words(v:&Value)->Result<Vec<u32>,String>{v.as_array().ok_or("native pickup word array absent")?.iter().map(word).collect()}
fn numeric(v:&Value)->Option<Vec<f32>>{v.as_array()?.iter().map(|v|v.as_f64().map(|v|v as f32)).collect()}
fn row<'a>(definition:&'a Value,section:&str,key:&str)->Result<&'a Value,String>{definition[section].as_array().ok_or_else(||format!("pickup {section} absent"))?.iter().find(|r|r["key"]==key).ok_or_else(||format!("pickup {key} absent"))}
fn scalar(definition:&Value,key:&str)->Result<f32,String>{Ok(f32::from_bits(word(&row(definition,"scalars",key)?["word"])?))}
fn flag(definition:&Value,key:&str)->Result<u8,String>{let n=word(&row(definition,"flags",key)?["value"])?;u8::try_from(n).map_err(|_|format!("pickup {key} flag escaped"))}
fn integer(definition:&Value,key:&str)->Result<u32,String>{word(&row(definition,"integers",key)?["value"])}
fn pair(definition:&Value,key:&str)->Result<[u32;2],String>{words(&row(definition,"pairs",key)?["words"])?.try_into().map_err(|_|format!("pickup {key} pair escaped"))}
fn probability_matches(actual:&ProbabilityCurve,expected:&Value)->Result<bool,String>{Ok(actual.constant==expected["constant"].as_bool().ok_or("probability constant absent")?
 &&actual.fast==expected["fast"].as_bool().ok_or("probability fast absent")?
 &&actual.constant_value.to_bits()==word(&expected["constant_word"])?&&actual.begin.to_bits()==word(&expected["begin_word"])?
 &&actual.difference.to_bits()==word(&expected["difference_word"])?
 &&actual.times.iter().map(|v|v.to_bits()).collect::<Vec<_>>()==words(&expected["times_words"])?
 &&actual.values.iter().map(|v|v.to_bits()).collect::<Vec<_>>()==words(&expected["values_words"])?) }
impl Profile {
 pub fn load(index:usize)->Result<Self,String>{let doc:Value=serde_json::from_str(include_str!("../../../data/4.20/relic_pickup/native_parameter_sources.json")).map_err(|e|e.to_string())?;Self::from_document(index,&doc)}
 pub fn from_document(index:usize,doc:&Value)->Result<Self,String>{
  let expected=[("Odin_HealthPackHeal","starTrailspin"),("Odin_HealthPackHeal","mesh"),("Summoner_Mana","starswirl"),("Summoner_Mana","shafts")];
  let (effect,group)=*expected.get(index).ok_or("pickup profile index escaped")?;
  let row=doc["groups"].as_array().and_then(|v|v.get(index)).ok_or("pickup source group absent")?;
  if row["effect"]!=effect||row["group"]!=group{return Err("pickup source order/identity escaped".into());}
  let fields=row["fields"].as_object().ok_or("pickup fields absent")?;
  let get=|key:&str|fields.get(key).and_then(numeric);
  let parameters=Parameters::read(get)?;let definition=row["native_definition"].clone();
  let mut result=vec![];
  for source in definition["rotation"].as_array().ok_or("pickup native rotations absent")? {
   let key=source["key"].as_str().ok_or("pickup rotation key absent")?;
   let parameter=ScalarParameter::read_numeric(key,0.,get).map_err(|e|format!("{key}: {e:?}"))?;
   let accepted=source["accepted"].as_bool().ok_or("pickup rotation acceptance absent")?;
   if parameter.is_some()!=accepted{return Err(format!("pickup {key} source/reader acceptance mismatch"));}
   let Some(parameter)=parameter else{break;};
   if parameter.table.iter().map(|v|v.to_bits()).collect::<Vec<_>>()!=words(&source["table_words"])?||!probability_matches(&parameter.probability,&source["probability"])?{
    return Err(format!("pickup {key} native table/probability mismatch"));
   }
   let axis:[u32;3]=words(&source["axis_words"])?.try_into().map_err(|_|"pickup rotation axis escaped")?;
   // These selected original files omit authored axes. UnitY is exactly the
   // constructor default, unaffected by its normalization. General axes require
   // the original getter/normalization path rather than trusting this fixture.
   if source["axis_found"]!=false||axis!=[0,1f32.to_bits(),0]{return Err("pickup authored rotation axis not qualified".into());}
   if parameter.table.len()==1&&parameter.table[0]==0.{break;}
   result.push(Rotation{parameter,axis});
  }
  Ok(Self{index,effect:effect.into(),group:group.into(),parameters,rotations:result,definition})
 }
 pub fn rotation_sources(&self)->Vec<rotations::Source<'_>>{self.rotations.iter().map(|r|rotations::Source{table:&r.parameter.table,axis:r.axis,probability:Some(&r.parameter.probability)}).collect()}
 pub fn definition<'a>(&'a self,input:Instance<'a>,rotation_sources:&'a [rotations::Source<'a>])->Result<Definition<'a>,String>{
  if !input.life.is_finite()||input.life<0.||!input.rate_factor.is_finite(){return Err("pickup instance life/rate factor invalid".into());}
  if rotation_sources.len()!=self.rotations.len()||rotation_sources.iter().zip(&self.rotations).any(|(s,r)|s.table.as_ptr()!=r.parameter.table.as_ptr()||s.table.len()!=r.parameter.table.len()||s.axis!=r.axis||!s.probability.is_some_and(|p|std::ptr::eq(p,&r.parameter.probability))){return Err("pickup rotation sources foreign".into());}
  let d=&self.definition;let lower=scalar(d,"e-period")?;let upper=scalar(d,"e-active")?;
  let modes=words(&d["color_type"]["values"])?;if modes.len()!=2||d["color_type"]["sscanf_count"]!=2{return Err("pickup color modes unqualified".into());}
  let scale=pair(d,"p-colorscale")?;let offset=pair(d,"p-coloroffset")?;
  let attributes=std::array::from_fn(|i|particles::Attribute{mode:modes[i],multiplier:scale[i],offset:offset[i]});
  Ok(Definition{flags:input.resource_flags,life:input.life,lower,upper,delay:scalar(d,"e-timeoffset")?,
   emitter_linger:scalar(d,"e-linger")?,particle_linger:scalar(d,"p-linger")?,period:lower,window:upper,
   single:integer(d,"single-particle")?,emitter_local:flag(d,"e-local-orient")?,sticky:flag(d,"p-lockedtoemitter")?,
   local:flag(d,"p-local-orient")?,circular:flag(d,"p-fixedorbit")?,direction:integer(d,"p-fixedorbittype")?,
   scalar_enabled:flag(d,"p-xquadrot-on")?,bind:pair(d,"p-bindtoemitter")?,attributes,rotations:rotation_sources,
   factors:input.factors,force_resource:input.force_resource,forces:input.forces,terrain:flag(d,"p-followterrain")?,
   // Original91E39E..91E3B7 singleton fallback after missingp-quadrot.
   quad_rotation_fallback:0,reset_value:input.reset_value,manager_flag:input.manager_flag,definition_kind:input.definition_kind,
   rate_factor:input.rate_factor,position:input.position,position_probabilities:input.position_probabilities})
 }
 pub fn authored_life(&self)->Result<f32,String>{scalar(&self.definition,"e-life")}
}

#[cfg(test)]mod tests{
 use super::*;
 #[test]fn all_original_rotation_parameters_and_definition_values_match_native(){
  for index in 0..4{let p=Profile::load(index).unwrap();assert_eq!(p.rotations.len(),usize::from(index!=1));
   for r in &p.rotations{assert_eq!(r.parameter.table,vec![1.]);assert!(!r.parameter.probability.constant);assert!(r.parameter.probability.fast);assert_eq!(r.parameter.probability.begin.to_bits(),0);assert_eq!(r.parameter.probability.difference.to_bits(),360f32.to_bits());assert_eq!(r.axis,[0,1f32.to_bits(),0]);}
   let rotations=p.rotation_sources();let d=p.definition(Instance{life:p.authored_life().unwrap(),resource_flags:0x10,
    factors:factors::Sources{context:[0;3],offset_coefficients:[0;3],bounds_coefficients:[0;3],life_multiplier:None,offset_attribute:None,size_attribute:None},
    force_resource:0,forces:None,reset_value:0,manager_flag:None,definition_kind:0,rate_factor:1.,position:[0;3],position_probabilities:[None;3]},&rotations).unwrap();
   assert_eq!((d.lower,d.upper,d.period,d.window),(f32::MAX,f32::MAX,f32::MAX,f32::MAX));assert_eq!((d.emitter_local,d.local,d.sticky,d.circular,d.direction,d.scalar_enabled,d.terrain),(1,0,0,0,1,0,0));assert_eq!(d.bind,[1f32.to_bits();2]);assert_eq!(d.attributes[0].mode,1);assert_eq!(d.attributes[1].mode,if index==3{3}else{0});assert_eq!(d.flags,0x10);assert_eq!(d.particle_linger,if index<2{10.}else{1.});
  }
  assert!(Profile::load(4).is_err());
 }
 #[test]fn missing_authored_rotation_probability_is_rejected(){let mut doc:Value=serde_json::from_str(include_str!("../../../data/4.20/relic_pickup/native_parameter_sources.json")).unwrap();doc["groups"][0]["fields"].as_object_mut().unwrap().remove("e-rotation1P1");assert!(Profile::from_document(0,&doc).is_err());}
}
