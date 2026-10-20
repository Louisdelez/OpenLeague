//! Ordinary accepted pickup -> owner -> four Simple simulations.
//! Fresh local effect sources have no scale overrides; historical trigger parity is open.
use bevy::prelude::*;
use std::collections::BTreeMap;
use openleague_core::{native_random::Rng55,native_simple_birth_factors as factors};
use crate::{relic_pickup_events as events,relic_pickup_simulation as simulation,relic_pickup_profiles as profiles,relic_pickup_forces as forces};
#[derive(Clone)]struct Effect{started:f64,owner:events::OwnerFrame,profiles:[profiles::Profile;4],forces:[forces::Population;4],hosts:[simulation::Host;4]}
#[derive(Resource,Clone)]pub struct Live{effects:BTreeMap<events::Key,Effect>,pub rng:Rng55,pub ordinal:u64,pub error:Option<String>,initialized:bool,last_clock:Option<f64>}
impl Default for Live{fn default()->Self{Self{effects:BTreeMap::new(),rng:Rng55::seeded(0),ordinal:0,error:Some("pickup stream requires host seed".into()),initialized:false,last_clock:None}}}
/// Exact accepted request inputs which a later draw preparation must not replace.
type RequestToken=(events::Key,events::Key,u64,Option<(events::Binding,[u32;16],[u32;3])>);
fn request_tokens(requests:&events::Host)->Vec<RequestToken>{requests.requests.iter().map(|(key,r)|(*key,r.key,r.observed_snapshot_tick,r.owner.map(|p|(p.binding,p.native_matrix,p.native_position)))).collect()}
/// Simulation, RNG, retirement and completion are proposed together. The future
/// renderer prepares and validates every packet before committing this plan.
pub struct Planned{next:Live,base_ordinal:u64,base_rng:(u32,u32,[u32;55]),requests:Vec<RequestToken>,pub completed:Vec<events::Key>,pub retired:Vec<events::Key>}
pub struct Group<'a>{pub key:events::Key,pub owner:events::OwnerFrame,pub profile:&'a profiles::Profile,pub host:&'a simulation::Host}
impl Planned{
 pub fn ordinal(&self)->u64{self.next.ordinal}
 pub fn groups(&self)->impl Iterator<Item=Group<'_>>{self.next.effects.iter().flat_map(|(&key,e)|e.hosts.iter().enumerate().map(move |(index,host)|Group{key,owner:e.owner,profile:&e.profiles[index],host}))}
 /// Call before publishing external draw/material state. In the exclusive host
 /// no source mutation may occur between this validation and commit().
 pub fn validate(&self,current:&Live,requests:&events::Host)->Result<(),String>{
  if current.ordinal!=self.base_ordinal||(current.rng.first,current.rng.second,current.rng.words)!=self.base_rng||request_tokens(requests)!=self.requests{return Err("pickup plan source/ordinal/RNG changed before publication".into());}
  if self.completed.iter().any(|key|!requests.requests.contains_key(key)){return Err("pickup completion became stale before publication".into());}Ok(())
 }
}
impl Live{
 pub fn planned(&self,requests:&events::Host,now:f64)->Result<Planned,String>{
  if !self.initialized{return Err("pickup stream requires host seed".into());}
  if !now.is_finite()||now<0.||now>f32::MAX as f64||self.last_clock.is_some_and(|old|now<old){return Err("pickup clock invalid or regressed".into());}
  // The canonical EffectClock is already a native f32 game time promoted to
  // f64. Preserve that absolute-time arithmetic; rebasing cannot restore lost
  // source precision and would alter native birth/update rounding unqualified.
  let native_now=now as f32;let mut next=self.clone();
  next.ordinal=next.ordinal.checked_add(1).ok_or("pickup ordinal exhausted")?;next.last_clock=Some(now);next.error=None;
  next.effects.retain(|key,_|requests.requests.get(key).is_some_and(|request|request.owner.is_some()));
  for (&key,request) in &requests.requests{
   if request.key!=key{return Err("pickup request key differs from accepted identity".into());}
   let Some(pose)=request.owner else{continue};
   if next.effects.get(&key).is_some_and(|effect|effect.owner.binding!=pose.binding){return Err("pickup accepted owner binding changed within effect".into());}
   let owner=simulation::Owner{system_matrix:pose.native_matrix,position:pose.native_position,inverse_fallback:Mat4::IDENTITY.to_cols_array().map(f32::to_bits)};
   if !next.effects.contains_key(&key){
    let profile_vec=(0..4).map(profiles::Profile::load).collect::<Result<Vec<_>,_>>()?;let profiles:[profiles::Profile;4]=profile_vec.try_into().map_err(|_|"pickup profile count escaped")?;
    let force_vec=(0..4).map(|index|crate::relic_pickup_force_sources::population(index,&mut next.rng)).collect::<Result<Vec<_>,_>>()?;
    let forces:[forces::Population;4]=force_vec.try_into().map_err(|_|"pickup force count escaped")?;
    let hosts_vec=(0..4).map(|_|simulation::Host::new(&owner,native_now).map_err(str::to_owned)).collect::<Result<Vec<_>,_>>()?;
    let hosts:[simulation::Host;4]=hosts_vec.try_into().map_err(|_|"pickup host count escaped")?;
    next.effects.insert(key,Effect{started:now,owner:pose,profiles,forces,hosts});
   }
   let effect=next.effects.get_mut(&key).unwrap();effect.owner=pose;
   let started=effect.started as f32;
   for index in 0..4{
    let profile=&effect.profiles[index];let rotation=profile.rotation_sources();let life=profile.authored_life()?;
    if !life.is_finite()||life<=0.{return Err("pickup native emitter life invalid".into());}
    // Match9437E0: absolute f32 subtraction, time offset, and native minimum of
    // life/period/active. The selected sources have zero offset and MAX limits.
    let progress=((native_now-started)/life).clamp(0.,1.);let force=effect.forces[index].frame(progress).map_err(str::to_owned)?;let graph=force.graph();
    // These instance values describe the current local no-override creation
    // adapter. They do not prove the historical factory/owner remap defaults.
    let definition=profile.definition(profiles::Instance{life,resource_flags:0,factors:factors::Sources{context:[0;3],offset_coefficients:[0;3],bounds_coefficients:[0;3],life_multiplier:None,offset_attribute:None,size_attribute:None},
     force_resource:u32::from(!effect.forces[index].is_empty()),forces:(!effect.forces[index].is_empty()).then_some(&graph),reset_value:0,manager_flag:None,definition_kind:0,rate_factor:1.,position:[0;3],position_probabilities:[None;3]},&rotation)?;
    let (host,rng)=effect.hosts[index].planned(next.ordinal,native_now,started,&profile.parameters,&definition,&owner,&next.rng,&mut |_|Err("pickup original terrain flag is false")).map_err(str::to_owned)?.ok_or("pickup host ordinal disagreement")?;
    effect.hosts[index]=host;next.rng=rng;
   }
  }
  let completed=next.effects.iter().filter(|(_,effect)|effect.hosts.iter().all(simulation::Host::finished)).map(|(key,_)|*key).collect::<Vec<_>>();
  for key in &completed{next.effects.remove(key);}
  let retired=self.effects.keys().filter(|key|!next.effects.contains_key(*key)).copied().collect();
  Ok(Planned{next,base_ordinal:self.ordinal,base_rng:(self.rng.first,self.rng.second,self.rng.words),requests:request_tokens(requests),completed,retired})
 }
 /// No external draw mutation belongs here. The future draw host first validates
 /// this plan and publishes the complete frame, then commits the owned state.
 pub fn commit(&mut self,plan:Planned,requests:&mut events::Host)->Result<(),String>{
  plan.validate(self,requests)?;
  // All completion keys were validated together above; each key is unique.
  for key in plan.completed{requests.complete(key).expect("validated unique pickup completion");}
  *self=plan.next;Ok(())
 }
}
pub struct Plugin;
impl bevy::app::Plugin for Plugin{fn build(&self,app:&mut App){app.init_resource::<Live>().add_systems(Startup,seed);}}
fn seed(mut live:ResMut<Live>){
 let result=std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).ok().and_then(|d|u64::try_from(d.as_nanos()/100).ok()).and_then(|v|v.checked_add(116_444_736_000_000_000));
 if let Some(filetime)=result{live.rng=Rng55::seeded(Rng55::seed_from_filetime(filetime));live.error=None;live.initialized=true;}
}

#[cfg(test)]
#[path="relic_pickup_live_tests.rs"] mod tests;

/// Controlled prior four-group stream for qualified seven-group order tests.
/// This helper neither registers nor seeds a second ordinary runtime host.
#[cfg(test)]pub(crate) fn initialized_order_fixture(rng:Rng55)->Live {Live {rng,initialized:true,error:None,..Live::default()}}
