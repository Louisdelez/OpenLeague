//! Actual pickup field definitions; logical child IDs do not claim native heap pointers.
use crate::relic_pickup_forces::{Descriptor,Population};
use openleague_core::{native_vector_parameter::VectorParameter,native_random::Rng55};
pub fn population(index:usize,rng:&mut Rng55)->Result<Population,String>{
 let doc:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_pickup/native_force_sources.json")).map_err(|e|e.to_string())?;
 let row=doc["groups"].as_array().and_then(|rows|rows.get(index)).ok_or("pickup force profile absent")?;
 let expected=[("Odin_HealthPackHeal","starTrailspin"),("Odin_HealthPackHeal","mesh"),("Summoner_Mana","starswirl"),("Summoner_Mana","shafts")];
 let (effect,group)=*expected.get(index).ok_or("pickup force profile escaped")?;
 if row["effect"]!=effect||row["group"]!=group{return Err("pickup force group identity mismatch".into());}
 let mut acceleration=vec![];let mut axes=vec![];
 for (i,source) in row["descriptors"].as_array().ok_or("pickup force descriptors missing")?.iter().enumerate(){
  let key=source["key"].as_str().ok_or("pickup force key absent")?;
  let fields=source["fields"].as_object().ok_or("pickup force fields absent")?;
  let parameter=VectorParameter::read_nonrotation(key,[0.;3],0,|key|fields.get(key)?.as_array()?.iter().map(|v|v.as_f64().map(|v|v as f32)).collect::<Option<Vec<_>>>())
   .map_err(|e|format!("pickup force parameter {e:?}"))?.ok_or("pickup force parameter missing")?;
  let local_space=match source["local_space"].as_i64(){Some(0)=>false,Some(1)=>true,_=>return Err("pickup field local-space flag invalid".into())};
  let descriptor=Descriptor{resource:u32::try_from(i+1).map_err(|_|"pickup field resource exhausted")?,parameter,local_space};
  match source["kind"].as_str(){Some("acceleration")=>acceleration.push(descriptor),Some("axis")=>axes.push(descriptor),_=>return Err("pickup force kind unsupported".into())};
 }
 Population::create(&acceleration,&axes,rng).map_err(str::to_owned)
}
