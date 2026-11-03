//! Visible-only Simple population. This named local phase/RNG policy never
//! reconstructs the launch point, hidden particles or a hidden owner transform.
use std::collections::{BTreeMap, BTreeSet};
use openleague_core::{native_random::Rng55, native_simple_emission_count as count,
    native_simple_emission_lifecycle as emission, native_simple_particle_update as particles,
    native_simple_birth_parameters as birth, native_simple_rotation_list as rotations};
use crate::{ezreal_r_passive_presentation::{CurrentR3d, Key}, ezreal_r_sparks_profile::Profile};
pub const MAX_EMITTERS: usize = 64;
pub const MAX_SLOTS: usize = 4096;
pub const MAX_STEP: f64 = 0.25;
// Original rate2000, life<=1. Native emission precedes age/recycle: at most
// roughly2000*(1+MAX_STEP)+one first birth plus f32 rounding headroom.4096 is a
// rejection boundary, never a rate clamp. p-linger is a post-stop life CAP, not
// an additional1s. Local visibility loss destroys the entire population.
#[derive(Clone)]
pub struct Entry {
    pub sample: CurrentR3d, pub storage: particles::State,
    birth: Vec<u32>, owner: emission::State, rng: Rng55,
    started: f64, clock: f64, previous: [u32;3],
}
#[derive(Clone, Default)]
pub struct State { context: Option<(u64,u64)>, pub rows: BTreeMap<Key,Entry> }
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
fn position(s: CurrentR3d) -> [u32;3] { [s.position.x,s.y_native,s.position.z].map(f32::to_bits) }
fn seed(s: CurrentR3d, epoch:u64) -> u32 {
    // FNV-style local seed uses both halves of every64bit identity. Hash
    // collisions are harmless RNG correlations; keys never use this reduced hash.
    let mut hash = 0x811c9dc5u32;
    for bytes in [s.key.session.to_le_bytes(),s.key.ordinal.to_le_bytes(),s.incarnation.to_le_bytes(),epoch.to_le_bytes()] {
        for byte in bytes { hash = (hash ^ u32::from(byte)).wrapping_mul(0x01000193); }
    }
    for byte in s.key.owner.to_le_bytes().into_iter().chain([s.key.team]) {
        hash = (hash ^ u32::from(byte)).wrapping_mul(0x01000193);
    }
    hash
}
fn matrix(s: CurrentR3d) -> Result<[u32;16], &'static str> {
    let mut frame = [0u32;19]; for index in [0,5,10,15] { frame[index]=1f32.to_bits(); }
    openleague_core::entity_yaw::update(&mut frame,[s.direction.x,0.,s.direction.z])?;
    let mut out: [u32;16] = std::array::from_fn(|i| frame[i]);
    out[12..15].copy_from_slice(&position(s)); Ok(out)
}
impl Entry {
    fn new(sample:CurrentR3d, clock:f64, epoch:u64) -> Self {
        Self { sample,storage:empty(),birth:vec![],owner:emission::State {
            previous:0,emitted:0,counter:0,bounds_factor:1f32.to_bits()},
            rng:Rng55::seeded(seed(sample,epoch)),started:clock,clock,previous:position(sample) }
    }
    pub fn live_indices(&self) -> impl Iterator<Item=usize> + '_ {
        self.storage.ages.iter().enumerate().filter(|(_,age)| f32::from_bits(**age)<1.).map(|(i,_)|i)
    }
    fn step(&mut self, sample:CurrentR3d, clock:f64, profile:&Profile) -> Result<(), &'static str> {
        let dt=clock-self.clock;
        if dt<0. || dt>MAX_STEP { return Err("R sparks clock gap outside local policy"); }
        if dt==0. && self.owner.emitted!=0 {
            if sample!=self.sample { return Err("R sparks pose changed while clock frozen"); }
            return Ok(());
        }
        let age=(clock-self.started) as f32;
        if !age.is_finite() || age<0. { return Err("R sparks local age invalid"); }
        let progress=age/profile.emitter_life;
        let values=birth::sample_base(&profile.life.table,&[0.],&profile.scale.table,&[0.],progress)?;
        let source=birth::BaseBirth {values,position:[0;3],
            velocity:birth::sample_vector(&profile.velocity.table,progress)?,
            offset:birth::sample_vector(&profile.offset.table,progress)?};
        let curves=birth::BirthCurves {life:Some(&profile.life.probability),factor:Some(&profile.scale.probability),
            scalar:None,rotation:None,position:[None;3],
            velocity:std::array::from_fn(|i|Some(&profile.velocity.probabilities[i])),
            offset:std::array::from_fn(|i|Some(&profile.offset.probabilities[i]))};
        // e-rotation1 contains authored degrees. Existing rotation-list evaluator
        // owns the native degrees→radians conversion, after the auxiliary draw.
        let rotation_sources=[rotations::Source {table:&profile.rotation.table,
            axis:[0f32,0.,1.].map(f32::to_bits),probability:Some(&profile.rotation.probability)}];
        let rotation=rotations::sample(&rotation_sources,progress)?;
        let pose=matrix(sample)?; let current=position(sample);
        // Static loader91E3CF binds p-scale toD8 (per-birth factor);
        // loader91DC81 binds p-xscale to1A0 (insertion and lifetime multiplier).
        // Applying p-scale again here would incorrectly square the authored size.
        let scale=particles::Table {values:&profile.xscale.table,probability:Some(&profile.xscale.probability)};
        let prepared=emission::Prepared {life:values.life,scalar:values.scalar,rate:values.rotation,factor:values.factor,
            offset:source.offset,position_offset:source.position,velocity:source.velocity,matrix:pose,
            previous_position:self.previous,current_position:current,bounds_factor:1f32.to_bits(),scale,terrain:0};
        // Absent timing fields use explicit local continuous10s emission. No
        // absent attribute, force, terrain, pitch or dynamic owner factor is inferred.
        let timing=count::Input {time:age,start:0.,previous:0.,life:profile.emitter_life,
            delay:0.,period:profile.emitter_life,window:profile.emitter_life,rate:2000.,single:0,emitted:0};
        let emitted=emission::update_with_rate_and_rotation_source(&mut self.owner,timing,&prepared,
            &mut self.storage,&mut self.birth,&mut self.rng,&mut |_|Err("R sparks terrain disabled"),
            &mut |rng|birth::sample_rate(&profile.rate.table,Some(&profile.rate.probability),progress,1.,rng),
            &mut |_,rng|Ok(source.birth(&curves,rng)),
            &mut |_,offset,velocity,rng|rotations::evaluate(&rotation,rng)?.apply(offset,velocity))?;
        if emitted<0 || emitted>502 || self.birth.len()>MAX_SLOTS { return Err("R sparks population budget exceeded"); }
        particles::update(&particles::Input {time:age.to_bits(),cap:f32::MAX.to_bits(),birth:&self.birth,
            bounds_flag:0,previous_position:self.previous,current_position:current,
            initial_inverse:identity(),current_matrix:pose,bind_begin:profile.bind[0].to_bits(),
            bind_end:profile.bind[1].to_bits(),sticky:0,local:0,circular:0,direction:0,
            force_resource:0,force_graph:None,scalar_enabled:0,
            scalar_table:particles::Table {values:&[0.],probability:None},scale_table:scale,
            attributes:[particles::Attribute {mode:1,multiplier:1f32.to_bits(),offset:0},
                particles::Attribute {mode:3,multiplier:1f32.to_bits(),offset:0}],
            bounds_factor:1f32.to_bits(),terrain_enabled:0},&mut self.storage,&mut self.rng,
            &mut |_|Err("R sparks terrain disabled"),&mut |_|{})?;
        if self.storage.life.iter().any(|v| !(0. ..=profile.particle_linger).contains(&f32::from_bits(*v))) {
            return Err("R sparks lifetime exceeds authored bound");
        }
        self.previous=current; self.clock=clock; self.sample=sample; Ok(())
    }
}
impl State {
    pub fn plan(&self, samples:&[CurrentR3d], clock:f64, context:(u64,u64), profile:&Profile)
        -> Result<Plan,&'static str> {
        if !clock.is_finite() || clock<0. || context.0==0 || samples.len()>MAX_EMITTERS {
            return Err("R sparks clock/session/capacity invalid");
        }
        let mut next=if self.context==Some(context) {self.clone()} else {Self::default()};
        next.context=Some(context); let mut keys=BTreeSet::new();
        for &sample in samples {
            if sample.key.session!=context.0 || sample.key.team>1 || sample.incarnation==0
                || !keys.insert(sample.key) || position(sample).iter().any(|v| !f32::from_bits(*v).is_finite())
                || !sample.direction.x.is_finite() || !sample.direction.z.is_finite()
                || (sample.direction.x==0. && sample.direction.z==0.) {
                return Err("R sparks invalid current XYZ identity");
            }
            if !next.rows.get(&sample.key).is_some_and(|old|old.sample.incarnation==sample.incarnation) {
                next.rows.insert(sample.key,Entry::new(sample,clock,context.1));
            }
            next.rows.get_mut(&sample.key).unwrap().step(sample,clock,profile)?;
        }
        next.rows.retain(|key,_|keys.contains(key)); Ok(Plan {next})
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    fn sample() -> CurrentR3d {
        CurrentR3d {key:Key {session:u64::MAX,owner:4,team:0,ordinal:(1u64<<53)+7},incarnation:1,
            position:openleague_core::Point{x:7000.,z:8000.},y_native:150.,
            direction:openleague_core::Point{x:1.,z:0.},sample_tick:31,frame_ordinal:u64::MAX-1}
    }
    fn signature(s:&State) -> Vec<(Key,Vec<u32>,[u32;55],u32,u32)> {
        s.rows.iter().map(|(k,e)|(*k,e.birth.clone(),e.rng.words,e.rng.first,e.rng.second)).collect()
    }
    #[test]
    fn original_rate_is_not_clamped_and_longest_lives_fit_bounded_pool() {
        let mut p=Profile::load().unwrap(); let mut state=State::default(); let s=sample();
        // Worst-case lifetime oracle: every birth takes the maximum permitted
        // by the real authored probability curve, rather than relying on luck.
        p.life.probability.constant=true;p.life.probability.constant_value=1.;
        for i in 0..=40 {
            state=state.plan(&[s],i as f64*0.25,(s.key.session,7),&p).unwrap().next;
            let e=&state.rows[&s.key]; assert!(e.birth.len()<=MAX_SLOTS);
            if i==1 { assert_eq!(e.owner.counter,501); }
            assert!(e.storage.life.iter().all(|v|f32::from_bits(*v)<=1.));
        }
        assert!(state.rows[&s.key].owner.counter>19000);
    }
    #[test]
    fn invalid_later_sample_rolls_back_all_births_rng_and_clock() {
        let p=Profile::load().unwrap(); let s=sample();
        let state=State::default().plan(&[s],1.,(s.key.session,7),&p).unwrap().next;
        let before=signature(&state); let mut bad=s; bad.key.owner=5; bad.y_native=f32::NAN;
        assert!(state.plan(&[s,bad],1.1,(s.key.session,7),&p).is_err());
        assert_eq!(signature(&state),before); assert_eq!(state.rows[&s.key].clock,1.);
        assert!(state.plan(&[s],1.26,(s.key.session,7),&p).is_err());
        assert_eq!(signature(&state),before);
    }
    #[test]
    fn pause_reveal_loss_and_epoch_change_keep_atomic_visible_population() {
        let p=Profile::load().unwrap(); let s=sample();
        let state=State::default().plan(&[s],1.,(s.key.session,7),&p).unwrap().next;
        let before=signature(&state); let paused=state.plan(&[s],1.,(s.key.session,7),&p).unwrap().next;
        assert_eq!(signature(&paused),before);
        let mut moved=s; moved.y_native+=1.; assert!(state.plan(&[moved],1.,(s.key.session,7),&p).is_err());
        let gone=paused.plan(&[],1.,(s.key.session,7),&p).unwrap().next; assert!(gone.rows.is_empty());
        let mut reveal=s; reveal.incarnation=2;
        let returned=gone.plan(&[reveal],99.,(s.key.session,7),&p).unwrap().next;
        assert_eq!(returned.rows[&s.key].started,99.); assert_eq!(returned.rows[&s.key].birth,vec![0]);
        let reset=state.plan(&[s],100.,(s.key.session,8),&p).unwrap().next;
        assert_eq!(reset.rows[&s.key].started,100.); assert_ne!(signature(&reset),before);
    }
    #[test]
    fn full_width_identity_duplicates_capacity_and_nonfinite_inputs_are_checked() {
        let p=Profile::load().unwrap(); let a=sample(); let mut b=a; b.key.ordinal+=1;
        let pair=State::default().plan(&[a,b],0.,(a.key.session,0),&p).unwrap().next;
        assert_eq!(pair.rows.len(),2); assert_ne!(seed(a,0),seed(b,0));
        assert!(State::default().plan(&[a,a],0.,(a.key.session,0),&p).is_err());
        assert!(State::default().plan(&vec![a;65],0.,(a.key.session,0),&p).is_err());
        for clock in [f64::NAN,f64::INFINITY,-1.] { assert!(State::default().plan(&[a],clock,(a.key.session,0),&p).is_err()); }
    }
}
