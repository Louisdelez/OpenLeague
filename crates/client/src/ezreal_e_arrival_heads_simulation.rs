//! Two stationary arrival-head emitters under a named local release policy.
//! This adapter reuses the native Simple arithmetic; it does not reconstruct a
//! target bone, native factory clock or the emitter controller's stop protocol.
use std::collections::BTreeMap;
use openleague_core::{native_random::Rng55,native_simple_emission_sources as sources,
    native_simple_birth_factors as factors,native_simple_rotation_list as rotations,
    ezreal_e_accepted_releases::Phase};
use crate::{ezreal_e_release_events::{Identity,Request,State as Events},
    ezreal_e_arrival_heads_profile::Profile,ezreal_e_simple_simulation as simple,
    ezreal_e_bolt_local as local};
pub(crate) const MAX_EPISODES:usize=32;
pub(crate) const MAX_QUADS:usize=4096;
#[derive(Clone)]
pub(crate) struct Entry {
    pub request:Request,pub particles:[simple::State;2],pub center:[f32;3],
    rng:Rng55,started:f64,clock:f64,ordinal:u64,pose:[u32;16],
}
fn pose(center:[f32;3])->Result<[u32;16],&'static str>{
    if center.iter().any(|v|!v.is_finite()){return Err("E arrival heads pose nonfinite");}
    let mut m=[1f32,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.];
    m[12..15].copy_from_slice(&center);Ok(m.map(f32::to_bits))
}
fn random(request:&Request)->Rng55 {
    // One explicitly local random stream per accepted arrival, shared in the
    // authored order head1 then head2. It is not a native process seed.
    let mut h=0xcbf29ce484222325u64;
    for value in [request.identity.session,request.identity.epoch,u64::from(request.identity.owner),
        request.identity.order,request.incarnation(),0x6172726976616c]{
        for b in value.to_le_bytes(){h^=u64::from(b);h=h.wrapping_mul(0x100000001b3);}}
    Rng55::seeded((h as u32)^((h>>32) as u32))
}
impl Entry {
    fn new(request:Request,now:f64,y:f32)->Result<Self,&'static str>{
        if request.phase!=Phase::Arrival{return Err("E heads require an admitted arrival");}
        let center=[request.position.x,y,request.position.z];let m=pose(center)?;
        let p=simple::Pose{previous:m,current:m,previous_inverse:local::translated_inverse(m)?};
        Ok(Self{request,particles:[simple::State::new(0.,p)?,simple::State::new(0.,p)?],
            center,rng:random(&request),started:now,clock:now,ordinal:0,pose:m})
    }
    fn plan(&self,now:f64,y:f32,profile:&Profile)->Result<Self,&'static str>{
        if now<self.clock||now-self.clock>0.25{return Err("E heads particle frame gap");}
        let time=local::age(self.started,now)?;
        let center=[self.request.position.x,y,self.request.position.z];let m=pose(center)?;
        let ordinal=self.ordinal.checked_add(1).ok_or("E heads ordinal exhausted")?;
        let mut next=self.clone();let scalar=local::scalar(1.);
        for index in 0..2 {
            let p=&profile.parameters[index];let source=&profile.rotations[index];
            let rotation=[rotations::Source{table:&source.table,axis:profile.axis,probability:Some(&source.probability)}];
            // Authored e-life gates continuous emission. Authored p-linger=0 is
            // preserved separately. The explicit local controller keeps sampled
            // particle life before our probability-inclusive conservative end;
            // it never submits zero as a live-particle cap or invents a stop.
            let frame=simple::Frame{ordinal,time,pose:simple::Pose{previous:self.pose,current:m,
                previous_inverse:local::translated_inverse(self.pose)?},emission:simple::Emission{
                enabled:time<p.authored_emitter_life,start:0.,life:p.authored_emitter_life,delay:0.,period:f32::MAX,
                window:f32::MAX,single:0,progress:time/p.authored_emitter_life,rate_factor:1.,
                attributes:sources::Attributes{life:None,position:None,velocity:None,rotation:None,offset:None},
                factors:factors::Sources{context:[0;3],offset_coefficients:[0;3],bounds_coefficients:[0;3],
                    life_multiplier:None,offset_attribute:None,size_attribute:None},rotations:&rotation,rate_attribute:None},
                dynamics:simple::Dynamics{particle_cap:f32::MAX,bounds_flag:1,sticky:0,local:0,circular:0,direction:0,
                    force_resource:0,force_graph:None,scalar_enabled:0,scalar_over_life:&scalar,terrain:0}};
            let (particles,rng)=self.particles[index].plan(p,&frame,&next.rng,
                &mut |_|Err("E heads particle terrain callback forbidden"))?;
            next.particles[index]=particles;next.rng=rng;
        }
        next.center=center;next.clock=now;next.ordinal=ordinal;next.pose=m;Ok(next)
    }
}
#[derive(Clone,Default)]
pub(crate) struct State {pub rows:BTreeMap<Identity,Entry>,context:Option<(u64,u64,u32)>,clock:Option<f64>}
impl State {
    pub(crate) fn plan(&self,events:&Events,requests:&[Request],now:f64,paused:bool,profile:&Profile,
        mut terrain:impl FnMut([f32;2])->Result<f32,&'static str>)->Result<Self,&'static str>{
        let context=events.context().filter(|(_,e,v)|*e!=0&&*v!=0).ok_or("E heads context unavailable")?;
        if !events.presentation_ready(now)||!now.is_finite()||self.clock.is_some_and(|old|now<old)
            ||requests.len()>crate::ezreal_e_release_events::MAX_PENDING||!profile.end.is_finite()||profile.end<=0. {
            return Err("E heads authority/clock/budget unavailable");
        }
        let mut next=if self.context==Some(context){self.clone()}else{Self{context:Some(context),..Self::default()}};
        // This f64 bound includes max(P)*max(life), unlike max(life) alone.
        // Expiration removes only the expired episode; no failing frame is made.
        next.rows.retain(|_,e|events.authorizes(&e.request)&&now>=e.started&&now-e.started<profile.end);
        for request in requests {
            if request.phase!=Phase::Arrival||paused||!events.authorizes(request){continue;}
            if next.rows.contains_key(&request.identity)||next.rows.len()==MAX_EPISODES{return Err("E heads duplicate/budget");}
            let y=terrain([request.position.x,request.position.z])?;
            next.rows.insert(request.identity,Entry::new(*request,now,y)?);
        }
        let mut total=0usize;
        for entry in next.rows.values_mut(){
            let y=terrain([entry.request.position.x,entry.request.position.z])?;
            if paused&&now!=entry.clock{return Err("E heads paused clock advanced");}
            *entry=entry.plan(now,y,profile)?;
            for group in &entry.particles {
                total=total.checked_add(group.live_indices().count()).ok_or("E heads population overflow")?;
            }
            if total>MAX_QUADS{return Err("E heads quad budget exceeded");}
        }
        next.clock=Some(now);Ok(next)
    }
}
pub(crate) fn map10_height(xz:[f32;2])->Result<f32,&'static str>{crate::ezreal_e_release_simulation::map10_height(xz)}
#[cfg(test)]
#[path="ezreal_e_arrival_heads_simulation_tests.rs"]
mod tests;
