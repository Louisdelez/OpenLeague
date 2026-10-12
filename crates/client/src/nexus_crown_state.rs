//! Crown Startup/On private simulation, independent of draw bindings. Local admission
//! policy: no historical catch-up when joining late or while no pose is known.
use bevy::prelude::*;
use openleague_core::{native_crown_birth::{Birth,Emitter,Profile,Side,Phase},
    native_complex_particle_age, native_random::Rng55};
use crate::nexus_idle_particles::{CycleId,Frame,Request};
use std::collections::BTreeMap;

pub const EMITTER_CAPACITY:usize=8;
pub const PARTICLE_CAPACITY:usize=6; // max(rate*life + native batch cap): Startup Order6, Chaos/On5
pub const DRAW_CAPACITY:usize=EMITTER_CAPACITY*PARTICLE_CAPACITY; // conservative guard; actual Order+Chaos Startup44
#[derive(Clone,Copy,Debug,PartialEq,Eq,PartialOrd,Ord)]
pub struct Key {pub source:u32,pub slot:u8}
#[derive(Clone,Copy,Debug,PartialEq,Eq,Hash)]
pub struct ParticleId {pub session:u64,pub source:u32,pub cycle:u64,pub slot:u8,pub birth:u32}
#[derive(Clone,Debug)]
pub struct Particle {
    pub id:ParticleId,pub birth:Birth,
    /// Qualified owner transfer at the actual birth. No replacement pose is
    /// synthesized later in fog; unbound particles retain this birth affine.
    pub orientation:Mat4,
}
#[derive(Clone,Debug)]
pub struct Slot {
    pub key:Key,pub cycle:CycleId,pub side:Side,pub phase:Phase,pub emitter:Emitter,
    pub particles:Vec<Particle>,pub age:f32,pub clock:f64,pub expiration_time:f32,
    pub missing_pose_frames:u64,pub seen:bool,pub continuous_pose:bool,
}
#[derive(Resource,Clone)]
pub struct State {
    pub session:Option<u64>,pub ordinal:u64,pub slots:Vec<Slot>,
    pub rng:Rng55,last_clock:Option<f64>,
}
pub fn side(request:&Request)->Result<Option<Side>,&'static str> {Ok(identity(request)?.map(|(side,_)|side))}
fn identity(request:&Request)->Result<Option<(Side,Phase)>,&'static str> {
    if !(8..=11).contains(&request.descriptor.slot) {return Ok(None);}
    let (side,phase)=match request.descriptor.resource.as_str() {
        "Order_Nexus_Base_Glow_on.troy"=>(Side::Order,Phase::On),
        "Chaos_Nexus_Base_Glow_on.troy"=>(Side::Chaos,Phase::On),
        "Order_Nexus_Base_Glow.troy"=>(Side::Order,Phase::Startup),
        "Chaos_Nexus_Base_Glow.troy"=>(Side::Chaos,Phase::Startup),
        _=>return Err("Crown slot resource is outside the four source profiles"),
    };
    if request.cycle.session==0 || request.cycle.serial==0 || request.cycle.source==0
        || request.owner.session!=request.cycle.session || request.owner.effect_id==0
        || request.owner.attachment_generation==0 || request.native_idle_resource_flag!=0x10
        || request.descriptor.bone!=format!("base{}",request.descriptor.slot-5)
        || request.descriptor.node!=usize::from(request.descriptor.slot)+10
        || !request.age_seconds.is_finite() || request.age_seconds<0. || request.age_seconds>f32::MAX as f64
        || !request.started_at.is_finite() || !request.attachment_world.is_finite()
    {return Err("Crown request identity, bone or time invalid");}
    Ok(Some((side,phase)))
}
impl State {
    pub fn new(seed:u32)->Self {Self {session:None,ordinal:0,slots:Vec::new(),rng:Rng55::seeded(seed),last_clock:None}}
    pub fn live_count(&self)->usize {self.slots.iter().map(|s|s.particles.len()).sum()}
    /// Transactional copy: frame validity/capacity and every sequential RNG plan
    /// are checked before the caller commits this state. No GPU readiness claim.
    pub fn planned(&self,frame:&Frame,now:f64,profiles:&[Profile],admitted:bool)->Result<Option<Self>,String> {
        if frame.ordinal==0 || !now.is_finite() {return Err("Crown ordinal/clock unavailable".into());}
        if frame.session==self.session && frame.ordinal<=self.ordinal {return Ok(None);}
        if frame.error.is_some() {return Err("Crown upstream IdleParticles frame unavailable".into());}
        let mut next=self.clone();
        if next.session!=frame.session {next.slots.clear();next.session=frame.session;next.last_clock=None;}
        if next.last_clock.is_some_and(|old|now<old) {return Err("Crown presentation clock regressed".into());}
        next.ordinal=frame.ordinal;next.last_clock=Some(now);
        if frame.session.is_none() {next.slots.clear();return Ok(Some(next));}
        let mut cycles=BTreeMap::new();let mut current=BTreeMap::new();
        for r in &frame.requests {
            if frame.session!=Some(r.cycle.session) {return Err("Crown mixed sessions in upstream frame".into());}
            if let Some(old)=cycles.insert(r.cycle.source,r.cycle) {if old!=r.cycle {return Err("Crown mixed cycles for one source".into());}}
            if let Some((s,phase))=identity(r)? {
                let key=Key {source:r.cycle.source,slot:r.descriptor.slot};
                if current.insert(key,(r,s,phase)).is_some() {return Err("duplicate Crown source/slot".into());}
            }
        }
        if cycles.len()>2 {return Err("Crown supports the two Map10 Nexus sources".into());}
        // A different cycle for the same source is authoritative retirement.
        // Frame.retired contains bindings, including fog, and is not used here.
        next.slots.retain(|s|cycles.get(&s.key.source).is_none_or(|c|*c==s.cycle));
        let sources:std::collections::BTreeSet<_>=next.slots.iter().map(|s|s.key.source)
            .chain(current.keys().map(|k|k.source)).collect();
        if sources.len()>2 || next.slots.len()+current.keys().filter(|k|!next.slots.iter().any(|s|s.key==**k)).count()>EMITTER_CAPACITY {
            return Err("Crown emitter capacity exceeded; no state or RNG committed".into());
        }
        for (key,(r,s,phase)) in &current {
            if !next.slots.iter().any(|slot|slot.key==*key) {
                let profile=profiles.iter().find(|p|p.side()==*s && p.phase()==*phase).ok_or("Crown exact phase profile missing")?;
                let mut particles=Vec::new();particles.try_reserve_exact(profile.particle_capacity()).map_err(|_|"Crown particle reservation failed")?;
                next.slots.push(Slot {key:*key,cycle:r.cycle,side:*s,phase:*phase,emitter:Emitter::default(),particles,
                    age:r.age_seconds as f32,clock:now,expiration_time:f32::MIN,missing_pose_frames:0,seen:false,continuous_pose:false});
            }
        }
        // Stable order is an explicit local interleaving policy. Each successful
        // commit advances the shared Crown stream before the next plan begins.
        next.slots.sort_by_key(|s|s.key);
        for slot in &mut next.slots {
            let projected=f64::from(slot.age)+(now-slot.clock);
            let observed=current.get(&slot.key).map(|(r,_,_)|r.age_seconds).unwrap_or(0.);
            let elapsed=projected.max(observed);
            if !elapsed.is_finite() || elapsed>f32::MAX as f64 {return Err("Crown age overflow".into());}
            slot.age=elapsed as f32;slot.clock=now;
            // Native93AE90 is strict > life and swaps complete particle records.
            native_complex_particle_age::remove_expired(slot.age,slot.expiration_time,&mut slot.particles,
                |p|(p.birth.schedule.time,p.birth.life),|_,_|{});
            slot.expiration_time=slot.age;
            let Some((r,s,phase))=current.get(&slot.key) else {
                slot.seen=false;slot.continuous_pose=false;slot.missing_pose_frames=slot.missing_pose_frames.saturating_add(1);continue;
            };
            if *s!=slot.side || *phase!=slot.phase || r.cycle!=slot.cycle {return Err("Crown profile changed within an existing cycle".into());}
            slot.seen=true;
            if !admitted {slot.continuous_pose=false;continue;}
            let (orientation,position)=crate::nexus_complex_live::owner_pose(r)?;
            let profile=profiles.iter().find(|p|p.side()==slot.side && p.phase()==slot.phase).ok_or("Crown exact phase profile missing")?;
            // LOCAL Startup admission: first appearance or a pose/resource gap
            // cannot backdate a multi-birth batch using only the current pose.
            // Keep prior particles/RNG/IDs; discard missed emission credit only.
            if slot.phase==Phase::Startup && !slot.continuous_pose {
                slot.emitter.last_emission=slot.age;slot.emitter.previous_frame=slot.age;
            }
            let plan=slot.emitter.prepare(profile,slot.age,position.to_array(),&next.rng).map_err(str::to_owned)?;
            if slot.particles.len()+plan.births().len()>profile.particle_capacity() {return Err("Crown live particle capacity exceeded; no commit".into());}
            slot.particles.try_reserve(plan.births().len()).map_err(|_|"Crown particle storage unavailable")?;
            let births=slot.emitter.commit(plan,&mut next.rng).map_err(str::to_owned)?;
            let first=slot.emitter.emitted.checked_sub(births.len() as u32).ok_or("Crown birth ID underflow")?;
            for (index,birth) in births.into_iter().enumerate() {
                let id=first.checked_add(index as u32+1).ok_or("Crown birth ID exhausted")?;
                slot.particles.push(Particle {id:ParticleId {session:slot.cycle.session,source:slot.key.source,
                    cycle:slot.cycle.serial,slot:slot.key.slot,birth:id},birth,orientation});
            }
            slot.continuous_pose=true;
        }
        Ok(Some(next))
    }
}

#[cfg(test)]
#[path="nexus_crown_state_tests.rs"]
mod tests;
