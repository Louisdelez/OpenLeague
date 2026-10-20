//! Visible-only Simple population. This named local phase/RNG policy never
//! reconstructs the launch point, hidden particles or a hidden owner transform.
use std::collections::{BTreeMap, BTreeSet};
use openleague_core::{native_random::Rng55, native_simple_emission_count as count,
    native_simple_emission_lifecycle as emission, native_simple_particle_update as particles,
    native_simple_birth_parameters as birth, native_simple_rotation_list as rotations,
    native_particle_force_body as force_body,native_particle_force_graph as force_graph};
use crate::{ezreal_w_missile_presentation::{CurrentW, Key}, ezreal_w_missile_profile::{Profile,Group}};
pub const MAX_EMITTERS: usize = 64;
pub const MAX_SLOTS: usize = 2048;
pub const MAX_STEP: f64 = 0.25;
// Original hoop rate2000 and emitter life0.5. The strict pool budget is a
// rejection boundary, not a rate clamp. Every visibility episode starts locally
// from zero; hidden factory/bone/elapsed time and hidden particles are unknown.
#[derive(Clone,Copy,Debug,PartialEq,Eq,PartialOrd,Ord)]
pub struct GroupKey {pub wave:Key,pub group:u8}
#[derive(Clone)]
pub struct Entry {
    pub sample: CurrentW, pub group:u8, pub storage: particles::State,
    birth: Vec<u32>, owner: emission::State, rng: Rng55,
    started: f64, clock: f64, previous: [u32;3],
}
#[derive(Clone, Default)]
pub struct State { context: Option<(u64,u64)>, pub rows: BTreeMap<GroupKey,Entry> }
pub struct Plan { pub next: State }
fn identity() -> [u32;16] { std::array::from_fn(|i| if [0,5,10,15].contains(&i) { 1f32.to_bits() } else { 0 }) }
fn empty() -> particles::State {
    particles::State { last_time:f32::MIN.to_bits(), life:vec![], ages:vec![], active:0,
        positions:vec![], velocities:vec![], scales:vec![], factors:vec![], scalar:vec![], rates:vec![],
        auxiliary:vec![], attribute_a:vec![], attribute_b:vec![], previous_heights:vec![],
        bounds:openleague_core::native_simple_bounds_policy::State {
            bounds:openleague_core::native_simple_particle_bounds::Bounds {minimum:[0;3],maximum:[0;3]},
            center:[0;3],last:0 }, counter:0 }
}
fn position(s: CurrentW) -> [u32;3] { [s.position.x,s.y_native,s.position.z].map(f32::to_bits) }
fn seed(s: CurrentW, epoch:u64,group:u8) -> u32 {
    // FNV-style local seed uses both halves of every64bit identity. Hash
    // collisions are harmless RNG correlations; keys never use this reduced hash.
    let mut hash = 0x811c9dc5u32;
    for bytes in [s.key.session.to_le_bytes(),s.key.ordinal.to_le_bytes(),s.incarnation.to_le_bytes(),epoch.to_le_bytes()] {
        for byte in bytes { hash = (hash ^ u32::from(byte)).wrapping_mul(0x01000193); }
    }
    for byte in s.key.owner.to_le_bytes().into_iter().chain([s.key.team,group]) {
        hash = (hash ^ u32::from(byte)).wrapping_mul(0x01000193);
    }
    hash
}
fn matrix(s: CurrentW) -> Result<[u32;16], &'static str> {
    let mut frame = [0u32;19]; for index in [0,5,10,15] { frame[index]=1f32.to_bits(); }
    openleague_core::entity_yaw::update(&mut frame,[s.direction.x,0.,s.direction.z])?;
    let mut out: [u32;16] = std::array::from_fn(|i| frame[i]);
    out[12..15].copy_from_slice(&position(s)); Ok(out)
}
impl Entry {
    fn new(sample:CurrentW, clock:f64, epoch:u64,group:u8) -> Self {
        Self { sample,group,storage:empty(),birth:vec![],owner:emission::State {
            previous:0,emitted:0,counter:0,bounds_factor:1f32.to_bits()},
            rng:Rng55::seeded(seed(sample,epoch,group)),started:clock,clock,previous:position(sample) }
    }
    pub fn live_indices(&self) -> impl Iterator<Item=usize> + '_ {
        self.storage.ages.iter().enumerate().filter(|(_,age)| f32::from_bits(**age)<1.).map(|(i,_)|i)
    }
    fn step(&mut self, sample:CurrentW, clock:f64, profile:&Group,force:&Profile) -> Result<(), &'static str> {
        if sample.direction!=self.sample.direction {return Err("W frozen direction changed inside episode");}
        let dt=clock-self.clock;
        if !dt.is_finite() || dt<0. || dt>MAX_STEP { return Err("W missile clock gap outside local policy"); }
        if dt==0. && self.owner.emitted!=0 {
            if sample.position!=self.sample.position || sample.y_native!=self.sample.y_native || sample.direction!=self.sample.direction
                || sample.key!=self.sample.key || sample.incarnation!=self.sample.incarnation { return Err("W missile pose changed while clock frozen"); }
            self.sample=sample;
            return Ok(());
        }
        let age=(clock-self.started) as f32;
        if !age.is_finite() || age<0. { return Err("W missile local age invalid"); }
        let progress=age/profile.emitter_life;
        let values=birth::sample_base(&profile.life.table,&[0.],&profile.scale.table,&[0.],progress)?;
        let source=birth::BaseBirth {values,position:[0;3],
            velocity:birth::sample_vector(&profile.velocity.table,progress)?,
            offset:birth::sample_vector(&profile.offset.table,progress)?};
        let curves=birth::BirthCurves {life:Some(&profile.life.probability),factor:Some(&profile.scale.probability),
            scalar:None,rotation:None,position:[None;3],
            velocity:std::array::from_fn(|i|Some(&profile.velocity.probabilities[i])),
            offset:std::array::from_fn(|i|Some(&profile.offset.probabilities[i]))};
        // Hoop e-rotation1-axis absent uses the proven [0,1,0] caller default
        // (91E995..91EA59). Core has no rotation list: explicit local empty list.
        let rotation_sources:Vec<_>=profile.rotation.iter().map(|r|rotations::Source {table:&r.table,
            axis:[0f32,1.,0.].map(f32::to_bits),probability:Some(&r.probability)}).collect();
        let rotation=rotations::sample(&rotation_sources,progress)?;
        let pose=matrix(sample)?; let current=position(sample);
        // Static loader91E3CF binds p-scale toD8 (per-birth factor);
        // loader91DC81 binds p-xscale to1A0 (insertion and lifetime multiplier).
        // Applying p-scale again here would incorrectly square the authored size.
        let scale=particles::Table {values:&profile.xscale.table,probability:Some(&profile.xscale.probability)};
        let prepared=emission::Prepared {life:values.life,scalar:values.scalar,rate:values.rotation,factor:values.factor,
            offset:source.offset,position_offset:source.position,velocity:source.velocity,matrix:pose,
            previous_position:self.previous,current_position:current,bounds_factor:1f32.to_bits(),scale,terrain:0};
        // Absent start/delay/period are explicit local one-window timing.
        // The authored core single flag and hoop emitter life0.5 are preserved.
        let timing=count::Input {time:age,start:0.,previous:0.,life:profile.emitter_life,
            delay:0.,period:profile.emitter_life,window:profile.emitter_life,rate:profile.rate.maximum,
            single:u32::from(profile.single),emitted:0};
        let emitted=emission::update_with_rate_and_rotation_source(&mut self.owner,timing,&prepared,
            &mut self.storage,&mut self.birth,&mut self.rng,&mut |_|Err("W missile terrain disabled"),
            &mut |rng|birth::sample_rate(&profile.rate.table,Some(&profile.rate.probability),progress,1.,rng),
            &mut |_,rng|Ok(source.birth(&curves,rng)),
            &mut |_,offset,velocity,rng|rotations::evaluate(&rotation,rng)?.apply(offset,velocity))?;
        if emitted<0 || emitted>502 || self.birth.len()>MAX_SLOTS { return Err("W missile population budget exceeded"); }
        // Drag is authored, but its factory transform is not recovered. Local
        // policy attaches its zero offset to the current wave XYZ, no actor lookup.
        let dampings=[force_body::Sphere {position:current,radius:force.radius.to_bits(),strength:force.drag.to_bits()}];
        let graph=force_graph::Input {body:force_body::Input {acceleration:None,points:&[],dampings:&dampings,
            children:&[],final_children:&[],delta:0},random_forces:&[],axis_forces:&[]};
        particles::update(&particles::Input {time:age.to_bits(),cap:f32::MAX.to_bits(),birth:&self.birth,
            bounds_flag:0,previous_position:self.previous,current_position:current,
            initial_inverse:identity(),current_matrix:pose,bind_begin:profile.bind[0].to_bits(),
            bind_end:profile.bind[1].to_bits(),sticky:0,local:0,circular:0,direction:0,
            force_resource:u32::from(profile.drag),force_graph:profile.drag.then_some(&graph),scalar_enabled:0,
            scalar_table:particles::Table {values:&[0.],probability:None},scale_table:scale,
            attributes:std::array::from_fn(|i|particles::Attribute {mode:profile.color_mode[i] as u32,
                multiplier:profile.color_scale[i].to_bits(),offset:profile.color_offset[i].to_bits()}),
            bounds_factor:1f32.to_bits(),terrain_enabled:0},&mut self.storage,&mut self.rng,
            &mut |_|Err("W missile terrain disabled"),&mut |_|{})?;
        if self.storage.life.iter().any(|v| !f32::from_bits(*v).is_finite() || !(0. ..=profile.max_particle_life).contains(&f32::from_bits(*v))) {
            return Err("W missile lifetime exceeds authored bound");
        }
        self.previous=current; self.clock=clock; self.sample=sample; Ok(())
    }
}
impl State {
    pub fn plan(&self, samples:&[CurrentW], clock:f64, context:(u64,u64), profile:&Profile)
        -> Result<Plan,&'static str> {
        if !clock.is_finite() || clock<0. || context.0==0 || context.1==0 || samples.len()>MAX_EMITTERS {
            return Err("W missile clock/session/capacity invalid");
        }
        let mut next=if self.context==Some(context) {self.clone()} else {Self::default()};
        next.context=Some(context); let mut keys=BTreeSet::new();
        for &sample in samples {
            if sample.key.session!=context.0 || sample.key.owner==0 || sample.key.ordinal==0 || sample.key.team>1 || sample.incarnation==0
                || !keys.insert(sample.key) || position(sample).iter().any(|v| !f32::from_bits(*v).is_finite())
                || !sample.direction.x.is_finite() || !sample.direction.z.is_finite()
                || (sample.direction.x.hypot(sample.direction.z)-1.).abs()>0.0001 {
                return Err("W missile invalid current XYZ identity");
            }
            for group in 0..2u8 {
                let key=GroupKey{wave:sample.key,group};
                if !next.rows.get(&key).is_some_and(|old|old.sample.incarnation==sample.incarnation) {
                    next.rows.insert(key,Entry::new(sample,clock,context.1,group));
                }
                next.rows.get_mut(&key).unwrap().step(sample,clock,&profile.groups[group as usize],profile)?;
            }
        }
        next.rows.retain(|key,_|keys.contains(&key.wave)); Ok(Plan {next})
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn sample()->CurrentW {CurrentW {key:Key {session:u64::MAX,owner:4,team:0,ordinal:(1u64<<53)+7},incarnation:1,
        position:openleague_core::Point{x:7000.,z:8000.},y_native:150.,direction:openleague_core::Point{x:1.,z:0.},sample_tick:8,frame_ordinal:9}}
    fn row<'a>(s:&'a State,w:CurrentW,group:u8)->&'a Entry {&s.rows[&GroupKey{wave:w.key,group}]}
    fn signature(s:&State)->String {s.rows.iter().map(|(key,e)|format!("{:?}|{:?}|{:?}|{:?}|{:?}|{:?}",key,e.birth,
        e.storage.positions,e.storage.scales,e.rng.words,e.clock)).collect()}
    #[test]
    fn core_one_birth_and_hoop_original_rate_life_window_remain_distinct(){
        let mut p=Profile::load().unwrap();p.groups[1].life.probability.constant=true;
        p.groups[1].life.probability.constant_value=1.;let w=sample();
        let mut state=State::default().plan(&[w],0.,(w.key.session,7),&p).unwrap().next;
        assert_eq!(row(&state,w,0).owner.counter,1);assert_eq!(row(&state,w,1).owner.counter,1);
        state=state.plan(&[w],0.25,(w.key.session,7),&p).unwrap().next;
        assert_eq!(row(&state,w,0).owner.counter,1);assert_eq!(row(&state,w,1).owner.counter,501);
        state=state.plan(&[w],0.49,(w.key.session,7),&p).unwrap().next;let count=row(&state,w,1).owner.counter;
        assert!(count>=980);state=state.plan(&[w],0.5,(w.key.session,7),&p).unwrap().next;
        assert_eq!(row(&state,w,1).owner.counter,count);assert_eq!(row(&state,w,0).live_indices().count(),0);
        assert!(row(&state,w,1).birth.len()<=MAX_SLOTS);assert!(row(&state,w,1).live_indices().count()>0);
    }
    #[test]
    fn current_motion_bind_drag_and_attribute_policy_use_authored_groups(){
        let p=Profile::load().unwrap();let w=sample();let state=State::default().plan(&[w],0.,(w.key.session,7),&p).unwrap().next;
        let core=row(&state,w,0);assert_eq!(f32::from_bits(core.storage.scales[0]),100.);
        let old=core.storage.positions[0].map(f32::from_bits);let mut moved=w;moved.position.x+=100.;moved.y_native+=10.;
        let next=state.plan(&[moved],0.1,(w.key.session,7),&p).unwrap().next;
        let current=row(&next,w,0);let pos=current.storage.positions[0].map(f32::from_bits);
        assert!((pos[0]-old[0]-100.).abs()<0.01);assert!((pos[1]-old[1]-10.).abs()<0.01);
        assert_eq!(f32::from_bits(current.storage.attribute_a[0]),0.7);
        let mut no_drag=p.clone();no_drag.groups[1].drag=false;
        let other=state.plan(&[moved],0.1,(w.key.session,7),&no_drag).unwrap().next;
        assert_ne!(row(&next,w,1).storage.velocities,row(&other,w,1).storage.velocities);
    }
    #[test]
    fn visibility_pause_epoch_and_later_invalid_row_are_transactional(){
        let p=Profile::load().unwrap();let w=sample();let state=State::default().plan(&[w],1.,(w.key.session,7),&p).unwrap().next;
        let sig=signature(&state);let mut provenance=w;provenance.sample_tick+=1;provenance.frame_ordinal+=1;
        assert_eq!(signature(&state.plan(&[provenance],1.,(w.key.session,7),&p).unwrap().next),sig);
        let mut bad=w;bad.key.owner=6;bad.y_native=f32::NAN;
        assert!(state.plan(&[w,bad],1.1,(w.key.session,7),&p).is_err());assert_eq!(signature(&state),sig);
        assert!(state.plan(&[w],1.251,(w.key.session,7),&p).is_err());
        let gone=state.plan(&[],1.,(w.key.session,7),&p).unwrap().next;assert!(gone.rows.is_empty());
        let mut reveal=w;reveal.incarnation+=1;let returned=gone.plan(&[reveal],99.,(w.key.session,7),&p).unwrap().next;
        assert_eq!(row(&returned,reveal,1).owner.counter,1);
        let epoch=state.plan(&[w],99.,(w.key.session,8),&p).unwrap().next;assert_ne!(row(&epoch,w,1).rng.words,row(&state,w,1).rng.words);
    }
    #[test]
    fn duplicate_nonfinite_capacity_and_unit_direction_are_rejected(){
        let p=Profile::load().unwrap();let w=sample();
        assert!(State::default().plan(&[w,w],0.,(w.key.session,7),&p).is_err());
        assert!(State::default().plan(&vec![w;65],0.,(w.key.session,7),&p).is_err());
        for now in [f64::NAN,f64::INFINITY,-1.]{assert!(State::default().plan(&[w],now,(w.key.session,7),&p).is_err());}
        let mut wrong=w;wrong.direction.x=2.;assert!(State::default().plan(&[wrong],0.,(w.key.session,7),&p).is_err());
    }
}
