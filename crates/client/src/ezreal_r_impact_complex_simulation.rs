//! Local stationary public-impact attachment of native Complex arithmetic.
//! The two groups consume one immutable dispatch batch, never the audio queue.
use std::collections::{BTreeMap,BTreeSet};
use openleague_core::{native_random::Rng55,native_complex_vectors::Field,
 native_complex_particle_storage::GlobalVectors,native_simple_rotation_list as rotation,
 native_probability_curve::apply_probability};
use crate::{ezreal_r_flash_events::{Identity,Request,State as Events},
 ezreal_r_impact_complex_profile::{Profile,Rotation},ezreal_r_impact_complex_engine as engine};
pub(crate) type Key=(Identity,u8);
pub(crate) const MAX_EMITTERS:usize=64;
pub(crate) const MAX_STEP:f64=0.25;
#[derive(Clone)]
pub(crate) struct Entry {pub(crate) request:Request,pub(crate) profile:usize,pub(crate) host:engine::Host,
 rng:Rng55,rotations:Vec<Rotation>,anchor:[u32;3],started:f64,clock:f64}
#[derive(Clone,Default)]
pub(crate) struct State {pub(crate) rows:BTreeMap<Key,Entry>,context:Option<(u64,u64,u32)>,clock:Option<f64>}
fn seed(request:&Request,slot:u8)->u32 {
 let id=request.identity;let mut h=0x811c9dc5u32;
 for value in [id.session,id.epoch,id.order,request.incarnation(),u64::from(id.owner),u64::from(slot)]{
  for byte in value.to_le_bytes(){h=(h^u32::from(byte)).wrapping_mul(0x01000193);}
 }h
}
impl Entry {
 fn new(request:Request,profile:usize,now:f64,y:f32,p:&Profile)->Result<Self,&'static str>{
  let anchor=[request.position.x,y,request.position.z];let mut rng=Rng55::seeded(seed(&request,p.slot));
  let mut retained=Vec::new();
  // Existing Complex source-retention order, with explicitly local RNG seed.
  for source in &p.rotations {
   let temporary=apply_probability(Some(&source.scalar.probability),source.scalar.table[0],&mut rng);
   if !temporary.is_finite(){return Err("impact rotation retention invalid");}
   if temporary!=0.{retained.push(source.clone());}
  }
  Ok(Self {request,profile,host:engine::Host::new(0.,anchor),rng,rotations:retained,
   anchor:anchor.map(f32::to_bits),started:now,clock:now})
 }
 fn step(&mut self,now:f64,p:&Profile)->Result<(),&'static str>{
  let dt=now-self.clock;if !dt.is_finite() || !(0. ..=MAX_STEP).contains(&dt){return Err("impact Complex frame gap");}
  if dt==0. && self.host.ordinal!=0{return Ok(());}
  let time=(now-self.started) as f32;
  if !time.is_finite() || time<0. || time>=p.ttl{return Err("impact Complex age outside owned lifetime");}
  let anchor=self.anchor.map(f32::from_bits);
  let globals=GlobalVectors {unit:[0;3],scale:[1f32.to_bits();3],anchor:[0;3]};
  let instance=engine::Instance {duration:p.timing.life,rate_owner_scale:1.,life_owner_scale:1.,
   life_coefficients:[0.;3],life_symmetry:0,limit:0,single_flag:p.single,stopped_flag:0,
   past_end:time>=p.timing.life,globals,motion_scratch:[0;3]};
  let input=engine::FrameInputs {owner_delta:[0.;3],owner_extra:[0.;3],default_vector:[0.;3],
   scale_owner:1.,lookup_modes:[0;2],lookup_scale:[0.;2],lookup_offset:[0.;2],
   surface_direct:false,local_matrix:None,attach_matrix:None};
  let ordinal=self.host.ordinal.checked_add(1).ok_or("impact Complex ordinal exhausted")?;
  let next=self.host.planned_frame(ordinal,p,time,anchor,instance,input,&self.rng,|b,emitter_ordinal,rng|{
   let sources=self.rotations.iter().map(|r|rotation::Source {table:&r.scalar.table,axis:r.axis,probability:Some(&r.scalar.probability)}).collect::<Vec<_>>();
   let sampled=rotation::sample(&sources,b.emitter_age)?;let evaluated=rotation::evaluate(&sampled,rng)?;
   // Same prepared-offset boundary as relic_pickup_complex_sources: rotation
   // list transforms local offset; velocity/acceleration remain distinct packet
   // channels. No invented owner rotation or flex coefficient is supplied.
   let (offset,_)=evaluated.apply(b.vectors[Field::Offset as usize].map(f32::to_bits),
    b.vectors[Field::Velocity as usize].map(f32::to_bits))?;
   let merged_offset=std::array::from_fn(|a|f32::from_bits(offset[a])+b.vectors[Field::PostOffset as usize][a]);
   let mut pose=std::array::from_fn(|i|if [0,5,10,15].contains(&i){1.}else{0.});
   pose[12..15].copy_from_slice(&b.schedule.position);
   Ok(engine::PreparedBirth {pose,merged_offset,world_acceleration:[0.;3],orbit_secondary:[0.;3],
    uv_aux:[0.;2],rate_multiplier:1.,distance_anchor:0.,emitter_ordinal})
  })?.ok_or("impact Complex ordinal not advanced")?;
  if next.0.storage.particles.len()>256 {return Err("impact Complex particle budget");}
  for r in &next.0.storage.particles {
   if r.life.iter().chain(&r.motion).chain(&r.surface).chain(&r.color).chain(&r.scale)
    .any(|v|!f32::from_bits(*v).is_finite()){return Err("impact Complex output nonfinite");}
  }
  self.host=next.0;self.rng=next.1;self.clock=now;Ok(())
 }
}
impl State {
 pub(crate) fn plan(&self,events:&Events,requests:&[Request],now:f64,paused:bool,profiles:&[Profile;2],
  mut terrain:impl FnMut([f32;2])->Result<f32,&'static str>)->Result<Self,&'static str>{
  let context=events.context().filter(|(_,e,v)|*e!=0&&*v!=0).ok_or("impact Complex epoch missing")?;
  if !events.presentation_ready(now) || !now.is_finite() || self.clock.is_some_and(|t|now<t)
   || requests.len()>32{return Err("impact Complex authority/clock/budget invalid");}
  let mut next=if self.context==Some(context){self.clone()}else{Self {context:Some(context),..Self::default()}};
  next.rows.retain(|_,e|events.authorizes(&e.request) && now>=e.started
   && now-e.started<f64::from(profiles[e.profile].ttl) && ((now-e.started) as f32)<profiles[e.profile].ttl);
  let mut seen=BTreeSet::new();
  for request in requests {
   if !seen.insert(request.identity){return Err("impact Complex duplicate accepted birth");}
   if paused || !events.authorizes(request){continue;}
   let y=terrain([request.position.x,request.position.z])?;if !y.is_finite(){return Err("impact Complex terrain invalid");}
   for (i,p) in profiles.iter().enumerate(){let key=(request.identity,p.slot);
    if next.rows.contains_key(&key){return Err("impact Complex repeated group birth");}
    if next.rows.len()>=MAX_EMITTERS{return Err("impact Complex emitter budget");}
    next.rows.insert(key,Entry::new(*request,i,now,y,p)?);
   }
  }
  for e in next.rows.values_mut(){
   let y=terrain([e.request.position.x,e.request.position.z])?;
   if !y.is_finite() || y.to_bits()!=e.anchor[1]{return Err("impact Complex terrain changed");}
   e.step(now,&profiles[e.profile])?;
  }
  next.rows.retain(|_,e|!e.host.finished(&profiles[e.profile],(now-e.started) as f32));
  next.clock=Some(now);Ok(next)
 }
}
#[cfg(test)]
mod tests {
 use super::*;use crate::ezreal_r_flash_events::test_fixture;
 fn profiles()->[Profile;2]{[Profile::load(0).unwrap(),Profile::load(1).unwrap()]}
 #[test] fn one_accepted_batch_creates_two_distinct_groups_and_forty_rays_once(){
  let p=profiles();let (_,_,mut events)=test_fixture([100.,5000.]);let requests=events.take(1.01,true,false);
  let state=State::default().plan(&events,&requests,1.01,false,&p,|_|Ok(75.)).unwrap();assert_eq!(state.rows.len(),2);
  let rays=&state.rows[&(requests[0].identity,4)];assert_eq!(rays.host.emitted,40);assert_eq!(rays.host.storage.particles.len(),40);
  assert!(rays.host.storage.particles.iter().all(|r|(0.15..=0.451).contains(&f32::from_bits(r.life[1]))));
  assert_eq!(state.rows[&(requests[0].identity,1)].host.emitted,1);
  let next=state.plan(&events,&[],1.06,false,&p,|_|Ok(75.)).unwrap();
  assert_eq!(next.rows[&(requests[0].identity,4)].host.emitted,40);
  assert!(next.rows[&(requests[0].identity,1)].host.emitted>1);
 }
 #[test] fn authored_motion_is_not_replaced_by_stationary_particle_geometry(){
  let p=profiles();let (_,_,mut events)=test_fixture([100.,5000.]);let req=events.take(1.01,true,false);
  let s=State::default().plan(&events,&req,1.01,false,&p,|_|Ok(75.)).unwrap();
  let next=s.plan(&events,&[],1.06,false,&p,|_|Ok(75.)).unwrap();
  let a=&s.rows[&(req[0].identity,1)].host.storage.particles[0];let b=&next.rows[&(req[0].identity,1)].host.storage.particles[0];
  assert_ne!(a.surface[28..31],b.surface[28..31]);assert!(b.surface[32..35].iter().any(|v|f32::from_bits(*v)!=0.));
  assert_eq!(s.rows[&(req[0].identity,4)].host.storage.particles[0].motion[19..22],[0;3]);
 }
 #[test] fn pause_does_not_advance_rng_and_gaps_or_terrain_fail_transactionally(){
  let p=profiles();let (_,_,mut events)=test_fixture([100.,5000.]);let req=events.take(1.01,true,false);
  let s=State::default().plan(&events,&req,1.01,false,&p,|_|Ok(75.)).unwrap();
  let frozen=s.plan(&events,&[],1.01,true,&p,|_|Ok(75.)).unwrap();
  for (k,e) in &s.rows{assert_eq!(e.rng.words,frozen.rows[k].rng.words);assert_eq!(e.host.ordinal,frozen.rows[k].host.ordinal);}
  assert!(s.plan(&events,&[],1.27,false,&p,|_|Ok(75.)).is_err());
  assert!(s.plan(&events,&[],1.02,false,&p,|_|Ok(76.)).is_err());
  assert!(s.plan(&events,&[],1.02,false,&p,|_|Ok(f32::NAN)).is_err());assert_eq!(s.rows.len(),2);
 }
 #[test] fn pause_at_birth_and_revelation_do_not_create_historical_groups(){
  let p=profiles();let (mut snapshot,_,mut events)=test_fixture([100.,5000.]);let req=events.take(1.01,true,false);
  assert!(State::default().plan(&events,&req,1.01,true,&p,|_|Ok(75.)).unwrap().rows.is_empty());
  let s=State::default().plan(&events,&req,1.01,false,&p,|_|Ok(75.)).unwrap();
  let old=snapshot.ezreal_r_accepted_impacts.clone();snapshot.tick+=1;snapshot.ezreal_r_accepted_impacts=None;
  events.observe_test_frame(&snapshot,1.02,true,false).unwrap();snapshot.tick+=1;snapshot.ezreal_r_accepted_impacts=old;
  events.observe_test_frame(&snapshot,1.02,true,false).unwrap();assert!(events.take(1.02,true,false).is_empty());
  assert!(s.plan(&events,&[],1.02,false,&p,|_|Ok(75.)).unwrap().rows.is_empty());
 }
 #[test] fn finite_lifetime_finishes_without_replaying_single_burst(){
  let p=profiles();let (mut snap,_,mut events)=test_fixture([100.,5000.]);let req=events.take(1.01,true,false);
  let mut s=State::default().plan(&events,&req,1.01,false,&p,|_|Ok(75.)).unwrap();
  for n in 1..=5 {let now=1.01+n as f64*0.2;snap.tick+=6;events.observe_test_frame(&snap,now,true,false).unwrap();
   assert!(events.take(now,true,false).is_empty());s=s.plan(&events,&[],now,false,&p,|_|Ok(75.)).unwrap();}
  assert!(s.rows.is_empty());
 }
}
