//! Atomic registration of the selected local seven-group pickup host.
//! A complete native whole-frame qualification must be embedded before this
//! plugin can initialize. There is no fallback to an unqualified source.
use bevy::prelude::*;
use crate::{relic_pickup_complex_sources::{Sources,LocalPolicy},relic_pickup_render_sources::RecoveredLocal,
 relic_pickup_seven_live::{Live,Admission},relic_pickup_seven_render as render};
use openleague_core::{native_random::Rng55,native_complex_particle_storage::GlobalVectors};

/// The recovered local provider does not advertise the original resource
/// capability. This selection is explicit; it is not a recovered actor value.
pub const LOCAL_PROVIDER_CAPABILITIES:[bool;3]=[false;3];
#[derive(Resource,Default)]
pub struct Initialization {pub initialized:bool,pub error:Option<String>,pub native_source_evidence:Option<String>}
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
 fn build(&self,app:&mut App){
  app.init_resource::<Initialization>().add_systems(Startup,initialize)
   .add_plugins((render::Plugin::<Sources,RecoveredLocal>::default(),crate::relic_pickup_seven_readiness::Plugin));
 }
}
#[cfg(test)]
#[path="relic_pickup_seven_integration_tests.rs"]mod tests;
fn filetime()->Result<u64,String>{
 let duration=std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).map_err(|_|"pickup UTC clock before Unix epoch")?;
 u64::try_from(duration.as_nanos()/100).ok().and_then(|v|v.checked_add(116_444_736_000_000_000))
  .ok_or("pickup UTC FILETIME overflow".into())
}
fn local_policy()->LocalPolicy {
 // Explicit no-attribute/no-trail/no-shape local actor policy. These fields
 // remain owner inputs, never a recovered historical global actor claim.
 LocalPolicy {life_owner_scale:1.,actor_rate_scale:1.,scale_owner:1.,owner_flags:0,
  owner_extra:[0.;3],motion_scratch:[0;3],globals:GlobalVectors {unit:[0;3],scale:[1f32.to_bits();3],anchor:[0;3]}}
}
fn configured(filetime:u64,evidence:String)->Result<(Live<Sources>,render::Source<RecoveredLocal>),String>{
 let document:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_pickup/pickup_complex_numeric_factory_contract.json")).map_err(|e|e.to_string())?;
 let sources=Sources::new(&document,LOCAL_PROVIDER_CAPABILITIES,local_policy())?;
 let render_sources=RecoveredLocal::recovered_local()?;
 let admission=Admission::Qualified {source_evidence:evidence};
 // Exactly one source stream for all seven groups in authored global order.
 // No reseed at pickup, effect creation, owner mutation or frame update.
 Ok((Live::new(sources,Rng55::from_filetime(filetime),admission.clone()),render::Source {value:render_sources,admission}))
}
// Controlled configured() tests remain available. Normal startup must also
// respect the recorded activation gate, independently of historical whole-frame proofs.
fn normal_admission(value:&serde_json::Value)->Result<String,String>{
 if value["passed"]!=true || value["whole_frame_qualified"]!=true {
  return Err("pickup seven-group whole native frame qualification pending".into());
 }
 if value["normal_activation_admitted"]!=true {
  return Err("pickup seven-group normal activation remains unadmitted".into());
 }
 value["evidence"].as_str().filter(|v|!v.is_empty()).map(str::to_owned)
  .ok_or("pickup seven-group evidence identity absent".into())
}
fn initialize(world:&mut World){
 let result=(||->Result<(Live<Sources>,render::Source<RecoveredLocal>,String),String>{
  if world.contains_resource::<Live<Sources>>() || world.contains_resource::<render::Source<RecoveredLocal>>() {
   return Err("pickup seven-group resources already initialized; no live migration/reseed".into());
  }
  let qualification:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_pickup/seven_source_admission.json")).map_err(|e|e.to_string())?;
  let evidence=normal_admission(&qualification)?;
  let (live,source)=configured(filetime()?,evidence.clone())?;Ok((live,source,evidence))
 })();
 match result {
  Ok((live,source,evidence))=>{world.insert_resource(live);world.insert_resource(source);world.insert_resource(Initialization {initialized:true,error:None,native_source_evidence:Some(evidence)});},
  Err(error)=>{if let Some(mut backend)=world.get_resource_mut::<render::Backend>() {backend.error=Some(error.clone());}
   world.insert_resource(Initialization {initialized:false,error:Some(error.clone()),native_source_evidence:None});
   eprintln!("pickup seven-group initialization rejected: {error}");},
 }
}

#[cfg(test)]
mod normal_admission_tests {
 use super::*;
 #[test] fn recorded_unadmitted_normal_flag_creates_no_live_source_or_renderer(){
  let actual:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/relic_pickup/seven_source_admission.json")).unwrap();
  assert_eq!(actual["passed"],true);assert_eq!(actual["whole_frame_qualified"],true);
  assert_eq!(actual["normal_activation_admitted"],false);assert!(normal_admission(&actual).is_err());
  let mut world=World::new();initialize(&mut world);
  let state=world.resource::<Initialization>();assert!(!state.initialized);
  assert!(state.error.as_deref().unwrap().contains("normal activation"));
  assert!(!world.contains_resource::<Live<Sources>>());assert!(!world.contains_resource::<render::Source<RecoveredLocal>>());
 }
 #[test] fn normal_admission_never_weakens_whole_frame_or_typed_flag_requirements(){
  let admitted=serde_json::json!({"passed":true,"whole_frame_qualified":true,"normal_activation_admitted":true,"evidence":"explicit future source evidence"});
  assert!(normal_admission(&admitted).is_ok());
  for key in ["passed","whole_frame_qualified","normal_activation_admitted"] {
   for invalid in [serde_json::Value::Bool(false),serde_json::Value::Null,serde_json::json!(1),serde_json::json!("true")] {
    let mut value=admitted.clone();value[key]=invalid;assert!(normal_admission(&value).is_err());
   }
  }
  let mut value=admitted;value["evidence"]=serde_json::json!("");assert!(normal_admission(&value).is_err());
 }
}
