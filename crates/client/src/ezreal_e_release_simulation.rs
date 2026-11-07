//! Stationary committed-phase adapter of the existing E Simple engine. No new
//! particle algorithm, native callback, bone or hidden second endpoint.
use std::collections::BTreeMap;
use openleague_core::{native_random::Rng55,native_simple_emission_sources as sources,
    native_simple_birth_factors as factors,native_simple_rotation_list as rotations};
use crate::{ezreal_e_release_events::{Identity,Request,State as Events},ezreal_e_release_profile::Profile,
    ezreal_e_simple_simulation as simple,ezreal_e_bolt_local as local};
pub(crate) const MAX_FLASHES:usize=32;
pub(crate) const MAX_QUADS:usize=4096;
#[derive(Clone)]
pub(crate) struct Entry {pub request:Request,pub particles:simple::State,pub center:[f32;3],
    rng:Rng55,started:f64,clock:f64,ordinal:u64,pose:[u32;16]}
fn pose(center:[f32;3])->Result<[u32;16],&'static str>{
    if center.iter().any(|v|!v.is_finite()){return Err("E release pose nonfinite");}
    let mut m=[1f32,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.];m[12..15].copy_from_slice(&center);Ok(m.map(f32::to_bits))
}
fn random(request:&Request)->Rng55 {
    // Local per-public-event seed: no claimed native process RNG/owner seed.
    let mut h=0xcbf29ce484222325u64;
    for value in [request.identity.session,request.identity.epoch,u64::from(request.identity.owner),
        request.identity.order,request.incarnation(),crate::ezreal_e_release_profile::phase_index(request.phase) as u64]{
        for b in value.to_le_bytes(){h^=u64::from(b);h=h.wrapping_mul(0x100000001b3);}}
    Rng55::seeded((h as u32)^((h>>32) as u32))
}
impl Entry {
    fn new(request:Request,now:f64,y:f32)->Result<Self,&'static str>{
        let center=[request.position.x,y,request.position.z];let m=pose(center)?;
        let p=simple::Pose{previous:m,current:m,previous_inverse:local::translated_inverse(m)?};
        Ok(Self{request,particles:simple::State::new(0.,p)?,center,rng:random(&request),started:now,clock:now,ordinal:0,pose:m})
    }
    fn plan(&self,now:f64,y:f32,profile:&Profile)->Result<Self,&'static str>{
        if now<self.clock||now-self.clock>0.25{return Err("E release particle frame gap");}
        let p=profile.parameter(self.request.phase);let time=local::age(self.started,now)?;
        let center=[self.request.position.x,y,self.request.position.z];let m=pose(center)?;
        let ordinal=self.ordinal.checked_add(1).ok_or("E release frame ordinal exhausted")?;
        let rotation=[rotations::Source{table:&profile.rotation.table,axis:profile.axis,probability:Some(&profile.rotation.probability)}];
        let scalar=local::scalar(1.);
        // Explicit local controller and external-input binding. Original .25
        // e-life gates births; each particle keeps its authored .5 life. The
        // separate e-linger=.25 is preserved in the profile, not used as a cap.
        let frame=simple::Frame{ordinal,time,pose:simple::Pose{previous:self.pose,current:m,
            previous_inverse:local::translated_inverse(self.pose)?},emission:simple::Emission{
            enabled:time<p.authored_emitter_life,start:0.,life:p.authored_emitter_life,delay:0.,period:f32::MAX,
            window:f32::MAX,single:0,progress:time/p.authored_emitter_life,rate_factor:1.,
            attributes:sources::Attributes{life:None,position:None,velocity:None,rotation:None,offset:None},
            factors:factors::Sources{context:[0;3],offset_coefficients:[0;3],bounds_coefficients:[0;3],
                life_multiplier:None,offset_attribute:None,size_attribute:None},rotations:&rotation,rate_attribute:None},
            dynamics:simple::Dynamics{particle_cap:f32::MAX,bounds_flag:1,sticky:0,local:0,circular:0,direction:0,
                force_resource:0,force_graph:None,scalar_enabled:0,scalar_over_life:&scalar,terrain:0}};
        let (particles,rng)=self.particles.plan(p,&frame,&self.rng,&mut |_|Err("E release particle terrain callback forbidden"))?;
        Ok(Self{request:self.request,particles,center,rng,started:self.started,clock:now,ordinal,pose:m})
    }
}
#[derive(Clone,Default)]
pub(crate) struct State {pub rows:BTreeMap<Identity,Entry>,context:Option<(u64,u64,u32)>,clock:Option<f64>}
impl State {
    pub(crate) fn plan(&self,events:&Events,requests:&[Request],now:f64,paused:bool,profile:&Profile,
        mut terrain:impl FnMut([f32;2])->Result<f32,&'static str>)->Result<Self,&'static str>{
        let context=events.context().filter(|(_,e,v)|*e!=0&&*v!=0).ok_or("E release context unavailable")?;
        if !events.presentation_ready(now)||!now.is_finite()||self.clock.is_some_and(|old|now<old)
            ||requests.len()>MAX_FLASHES{return Err("E release authority/clock/budget unavailable");}
        let mut next=if self.context==Some(context){self.clone()}else{Self{context:Some(context),..Self::default()}};
        next.rows.retain(|_,e|{let p=profile.parameter(e.request.phase);let end=p.authored_emitter_life+p.life.maximum;
            events.authorizes(&e.request)&&now>=e.started&&now-e.started<f64::from(end)&&((now-e.started) as f32)<end});
        for request in requests {
            if paused||!events.authorizes(request){continue;}
            if next.rows.contains_key(&request.identity)||next.rows.len()==MAX_FLASHES{return Err("E release duplicate/budget");}
            let y=terrain([request.position.x,request.position.z])?;
            next.rows.insert(request.identity,Entry::new(*request,now,y)?);
        }
        let mut total=0usize;
        for entry in next.rows.values_mut(){
            let y=terrain([entry.request.position.x,entry.request.position.z])?;
            if paused&&now!=entry.clock{return Err("E release paused clock advanced");}
            *entry=entry.plan(now,y,profile)?;
            total=total.checked_add(entry.particles.live_indices().count()).ok_or("E release population overflow")?;
            if total>MAX_QUADS{return Err("E release quad budget exceeded");}
        }
        // The clone, all particle pools and all RNG states commit atomically.
        next.clock=Some(now);Ok(next)
    }
}
pub(crate) fn map10_height(xz:[f32;2])->Result<f32,&'static str>{
    crate::ezreal_r_flash_simulation::map10_height(xz)
}
#[cfg(test)]
#[path="ezreal_e_release_simulation_tests.rs"]
mod tests;
